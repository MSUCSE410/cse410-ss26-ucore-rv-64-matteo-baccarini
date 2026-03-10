#include "syscall.h"
#include "defs.h"
#include "loader.h"
#include "syscall_ids.h"
#include "timer.h"
#include "trap.h"
#include "vm.h"

uint64 sys_write(int fd, uint64 va, uint len)
{
	debugf("sys_write fd = %d va = %x, len = %d", fd, va, len);
	if (fd != STDOUT)
		return -1;
	struct proc *p = curr_proc();
	char str[MAX_STR_LEN];
	int size = copyinstr(p->pagetable, str, va, MIN(len, MAX_STR_LEN));
	debugf("size = %d", size);
	for (int i = 0; i < size; ++i) {
		console_putchar(str[i]);
	}
	return size;
}

__attribute__((noreturn)) void sys_exit(int code)
{
	exit(code);
	__builtin_unreachable();
}

uint64 sys_sched_yield()
{
	yield();
	return 0;
}

uint64 sys_gettimeofday(TimeVal *val, int _tz) // TODO: implement sys_gettimeofday in pagetable. (VA to PA)
{
	// YOUR CODE
	val->sec = 0;
	val->usec = 0;

	/* The code in `ch3` will leads to memory bugs*/

	pagetable_t current_proc = curr_proc()->pagetable;

	TimeVal * physical_val = (TimeVal *)useraddr(current_proc, (uint64)val);


	uint64 cycle = get_cycle();
	physical_val->sec = cycle / CPU_FREQ;
	physical_val->usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;
	return 0;
}

// TODO: add support for mmap and munmap syscall.
// hint: read through docstrings in vm.c. Watching CH4 video may also help.
// Note the return value and PTE flags (especially U,X,W,R)

uint64 sys_mmap(uint64 start, uint64 len, int port, int flag, int fd)
{
	struct proc *p = curr_proc();
	
	// 1. Validate parameters
	
	// Check if start is page-aligned
	if (start % PGSIZE != 0) {
		return -1;
	}
	
	// If len is 0, return immediately
	if (len == 0) {
		return 0;
	}
	
	// Check if len is too big (upper limit 1GiB)
	if (len > (1ULL << 30)) {
		return -1;
	}
	
	// Check if port has invalid bits set (other bits must be 0)
	if ((port & ~0x7) != 0) {
		return -1;
	}
	
	// Check if port has no permissions (meaningless)
	if ((port & 0x7) == 0) {
		return -1;
	}
	
	// 2. Round len up to page boundary
	uint64 npages = (len + PGSIZE - 1) / PGSIZE;
	
	// 3. Check if any page in [start, start+len) is already mapped
	for (uint64 i = 0; i < npages; i++) {
		uint64 va = start + i * PGSIZE;
		pte_t *pte = walk(p->pagetable, va, 0);
		
		// If page table entry exists and is valid, page is already mapped
		if (pte != 0 && (*pte & PTE_V)) {
			return -1;
		}
	}
	
	// 4. Convert port bits to PTE flags
	// port bit 0 = readable -> PTE_R (bit 1)
	// port bit 1 = writable -> PTE_W (bit 2)
	// port bit 2 = executable -> PTE_X (bit 3)
	// Also need PTE_U (bit 4) for user access and PTE_V (bit 0) for valid
	int perm = PTE_U | PTE_V;
	if (port & 0x1) perm |= PTE_R;
	if (port & 0x2) perm |= PTE_W;
	if (port & 0x4) perm |= PTE_X;
	
	// 5. Allocate physical pages and map them one by one
	for (uint64 i = 0; i < npages; i++) {
		uint64 va = start + i * PGSIZE;
		
		// Allocate physical page
		void *pa = kalloc();
		if (pa == 0) {
			// Insufficient physical memory
			// Should clean up already allocated pages, but spec says
			// "For simplicity, page recovery in case of allocation failure is not considered"
			return -1;
		}
		
		// Clear the allocated page
		memset(pa, 0, PGSIZE);
		
		if (mappages(p->pagetable, va, PGSIZE, (uint64)pa, perm) != 0) {
			kfree(pa);
			return -1;
		}
	}
	
	return 0;
}

uint64 sys_munmap(uint64 start, uint64 len)
{
	struct proc *p = curr_proc();
	
	// 1. Validate that start is page-aligned
	if (start % PGSIZE != 0) {
		return -1;
	}
	
	// If len is 0, nothing to do
	if (len == 0) {
		return 0;
	}
	
	// 2. Calculate number of pages
	uint64 npages = (len + PGSIZE - 1) / PGSIZE;
	
	// 3. Check if all pages in [start, start+len) are mapped
	for (uint64 i = 0; i < npages; i++) {
		uint64 va = start + i * PGSIZE;
		pte_t *pte = walk(p->pagetable, va, 0);
		
		// If page table entry doesn't exist or is not valid, return error
		if (pte == 0 || (*pte & PTE_V) == 0) {
			return -1;
		}
	}
	
	// 4. Unmap the pages and free physical memory
	uvmunmap(p->pagetable, start, npages, 1);
	
	return 0;
}

/*
* LAB1: you may need to define sys_task_info here
*/

uint64 sys_task_info(struct TaskInfo *info) {
	struct proc * p = curr_proc();
	struct TaskInfo *physical_info = (struct TaskInfo *)useraddr(p->pagetable, (uint64)info);
	physical_info->status = Running;
	for (int i = 0; i < MAX_SYSCALL_NUM; i++) {
		physical_info->syscall_times[i] = p->syscall_times[i];
	}
	uint64 cycle = get_cycle();
	uint64 running_time = cycle - p->time;
	physical_info->time = (running_time * 1000) / CPU_FREQ; // ms
	return 0;
}

extern char trap_page[];

void syscall()
{
	struct trapframe *trapframe = curr_proc()->trapframe;
	int id = trapframe->a7, ret;
	uint64 args[6] = { trapframe->a0, trapframe->a1, trapframe->a2,
			   trapframe->a3, trapframe->a4, trapframe->a5 };
	tracef("syscall %d args = [%x, %x, %x, %x, %x, %x]", id, args[0],
	       args[1], args[2], args[3], args[4], args[5]);
	curr_proc()->syscall_times[id]++;
	switch (id) {
	case SYS_write:
		ret = sys_write(args[0], args[1], args[2]);
		break;
	case SYS_exit:
		sys_exit(args[0]);
		// __builtin_unreachable();
	case SYS_sched_yield:
		ret = sys_sched_yield();
		break;
	case SYS_gettimeofday:
		ret = sys_gettimeofday((TimeVal *)args[0], args[1]);
		break;
	/*
	* LAB1: you may need to add SYS_taskinfo case here
	*/
	case SYS_task_info:
		ret = sys_task_info((struct TaskInfo *)args[0]);
		break;
	case SYS_mmap:
		ret = sys_mmap(args[0], args[1], args[2], args[3], args[4]);
		break;
	case SYS_munmap:
		ret = sys_munmap(args[0], args[1]);
		break;
	default:
		ret = -1;
		errorf("unknown syscall %d", id);
	}
	trapframe->a0 = ret;
	tracef("syscall ret %d", ret);
}