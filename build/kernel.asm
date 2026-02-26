
build/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
    .section .text.entry
    .globl _entry
_entry:
    la sp, boot_stack_top
    80200000:	00035117          	auipc	sp,0x35
    80200004:	00010113          	mv	sp,sp
    call main
    80200008:	440000ef          	jal	ra,80200448 <main>

000000008020000c <consputc>:
#include "console.h"
#include "sbi.h"

void consputc(int c)
{
    8020000c:	1141                	addi	sp,sp,-16
    8020000e:	e406                	sd	ra,8(sp)
    80200010:	e022                	sd	s0,0(sp)
    80200012:	0800                	addi	s0,sp,16
	console_putchar(c);
    80200014:	00001097          	auipc	ra,0x1
    80200018:	a0c080e7          	jalr	-1524(ra) # 80200a20 <console_putchar>
}
    8020001c:	60a2                	ld	ra,8(sp)
    8020001e:	6402                	ld	s0,0(sp)
    80200020:	0141                	addi	sp,sp,16
    80200022:	8082                	ret

0000000080200024 <console_init>:

void console_init()
{
    80200024:	1141                	addi	sp,sp,-16
    80200026:	e422                	sd	s0,8(sp)
    80200028:	0800                	addi	s0,sp,16
	// DO NOTHING
    8020002a:	6422                	ld	s0,8(sp)
    8020002c:	0141                	addi	sp,sp,16
    8020002e:	8082                	ret

0000000080200030 <kfree>:
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    80200030:	1101                	addi	sp,sp,-32
    80200032:	ec06                	sd	ra,24(sp)
    80200034:	e822                	sd	s0,16(sp)
    80200036:	e426                	sd	s1,8(sp)
    80200038:	1000                	addi	s0,sp,32
    8020003a:	84aa                	mv	s1,a0
	struct linklist *l;
	if (((uint64)pa % PGSIZE) != 0 || (char *)pa < ekernel ||
    8020003c:	03451793          	slli	a5,a0,0x34
    80200040:	eb99                	bnez	a5,80200056 <kfree+0x26>
    80200042:	0005f797          	auipc	a5,0x5f
    80200046:	fbe78793          	addi	a5,a5,-66 # 8025f000 <e_bss>
    8020004a:	00f56663          	bltu	a0,a5,80200056 <kfree+0x26>
    8020004e:	47c5                	li	a5,17
    80200050:	07ee                	slli	a5,a5,0x1b
    80200052:	02f56e63          	bltu	a0,a5,8020008e <kfree+0x5e>
	    (uint64)pa >= PHYSTOP)
		panic("kfree");
    80200056:	00000097          	auipc	ra,0x0
    8020005a:	6d4080e7          	jalr	1748(ra) # 8020072a <threadid>
    8020005e:	86aa                	mv	a3,a0
    80200060:	02500793          	li	a5,37
    80200064:	00003717          	auipc	a4,0x3
    80200068:	f9c70713          	addi	a4,a4,-100 # 80203000 <e_text>
    8020006c:	00003617          	auipc	a2,0x3
    80200070:	fa460613          	addi	a2,a2,-92 # 80203010 <e_text+0x10>
    80200074:	45fd                	li	a1,31
    80200076:	00003517          	auipc	a0,0x3
    8020007a:	fa250513          	addi	a0,a0,-94 # 80203018 <e_text+0x18>
    8020007e:	00000097          	auipc	ra,0x0
    80200082:	4d6080e7          	jalr	1238(ra) # 80200554 <printf>
    80200086:	00001097          	auipc	ra,0x1
    8020008a:	9ca080e7          	jalr	-1590(ra) # 80200a50 <shutdown>
	// Fill with junk to catch dangling refs.
	memset(pa, 1, PGSIZE);
    8020008e:	6605                	lui	a2,0x1
    80200090:	4585                	li	a1,1
    80200092:	8526                	mv	a0,s1
    80200094:	00001097          	auipc	ra,0x1
    80200098:	9ea080e7          	jalr	-1558(ra) # 80200a7e <memset>
	l = (struct linklist *)pa;
	l->next = kmem.freelist;
    8020009c:	0005e797          	auipc	a5,0x5e
    802000a0:	6e478793          	addi	a5,a5,1764 # 8025e780 <kmem>
    802000a4:	6398                	ld	a4,0(a5)
    802000a6:	e098                	sd	a4,0(s1)
	kmem.freelist = l;
    802000a8:	e384                	sd	s1,0(a5)
}
    802000aa:	60e2                	ld	ra,24(sp)
    802000ac:	6442                	ld	s0,16(sp)
    802000ae:	64a2                	ld	s1,8(sp)
    802000b0:	6105                	addi	sp,sp,32
    802000b2:	8082                	ret

00000000802000b4 <freerange>:
{
    802000b4:	7179                	addi	sp,sp,-48
    802000b6:	f406                	sd	ra,40(sp)
    802000b8:	f022                	sd	s0,32(sp)
    802000ba:	ec26                	sd	s1,24(sp)
    802000bc:	e84a                	sd	s2,16(sp)
    802000be:	e44e                	sd	s3,8(sp)
    802000c0:	e052                	sd	s4,0(sp)
    802000c2:	1800                	addi	s0,sp,48
	p = (char *)PGROUNDUP((uint64)pa_start);
    802000c4:	6785                	lui	a5,0x1
    802000c6:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x801ff001>
    802000ca:	94aa                	add	s1,s1,a0
    802000cc:	757d                	lui	a0,0xfffff
    802000ce:	8ce9                	and	s1,s1,a0
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    802000d0:	94be                	add	s1,s1,a5
    802000d2:	0095ee63          	bltu	a1,s1,802000ee <freerange+0x3a>
    802000d6:	892e                	mv	s2,a1
		kfree(p);
    802000d8:	7a7d                	lui	s4,0xfffff
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    802000da:	6985                	lui	s3,0x1
		kfree(p);
    802000dc:	01448533          	add	a0,s1,s4
    802000e0:	00000097          	auipc	ra,0x0
    802000e4:	f50080e7          	jalr	-176(ra) # 80200030 <kfree>
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    802000e8:	94ce                	add	s1,s1,s3
    802000ea:	fe9979e3          	bgeu	s2,s1,802000dc <freerange+0x28>
}
    802000ee:	70a2                	ld	ra,40(sp)
    802000f0:	7402                	ld	s0,32(sp)
    802000f2:	64e2                	ld	s1,24(sp)
    802000f4:	6942                	ld	s2,16(sp)
    802000f6:	69a2                	ld	s3,8(sp)
    802000f8:	6a02                	ld	s4,0(sp)
    802000fa:	6145                	addi	sp,sp,48
    802000fc:	8082                	ret

00000000802000fe <kinit>:
{
    802000fe:	1141                	addi	sp,sp,-16
    80200100:	e406                	sd	ra,8(sp)
    80200102:	e022                	sd	s0,0(sp)
    80200104:	0800                	addi	s0,sp,16
	freerange(ekernel, (void *)PHYSTOP);
    80200106:	45c5                	li	a1,17
    80200108:	05ee                	slli	a1,a1,0x1b
    8020010a:	0005f517          	auipc	a0,0x5f
    8020010e:	ef650513          	addi	a0,a0,-266 # 8025f000 <e_bss>
    80200112:	00000097          	auipc	ra,0x0
    80200116:	fa2080e7          	jalr	-94(ra) # 802000b4 <freerange>
}
    8020011a:	60a2                	ld	ra,8(sp)
    8020011c:	6402                	ld	s0,0(sp)
    8020011e:	0141                	addi	sp,sp,16
    80200120:	8082                	ret

0000000080200122 <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void)
{
    80200122:	1101                	addi	sp,sp,-32
    80200124:	ec06                	sd	ra,24(sp)
    80200126:	e822                	sd	s0,16(sp)
    80200128:	e426                	sd	s1,8(sp)
    8020012a:	1000                	addi	s0,sp,32
	struct linklist *l;
	l = kmem.freelist;
    8020012c:	0005e497          	auipc	s1,0x5e
    80200130:	6544b483          	ld	s1,1620(s1) # 8025e780 <kmem>
	if (l) {
    80200134:	cc89                	beqz	s1,8020014e <kalloc+0x2c>
		kmem.freelist = l->next;
    80200136:	609c                	ld	a5,0(s1)
    80200138:	0005e717          	auipc	a4,0x5e
    8020013c:	64f73423          	sd	a5,1608(a4) # 8025e780 <kmem>
		memset((char *)l, 5, PGSIZE); // fill with junk
    80200140:	6605                	lui	a2,0x1
    80200142:	4595                	li	a1,5
    80200144:	8526                	mv	a0,s1
    80200146:	00001097          	auipc	ra,0x1
    8020014a:	938080e7          	jalr	-1736(ra) # 80200a7e <memset>
	}
	return (void *)l;
    8020014e:	8526                	mv	a0,s1
    80200150:	60e2                	ld	ra,24(sp)
    80200152:	6442                	ld	s0,16(sp)
    80200154:	64a2                	ld	s1,8(sp)
    80200156:	6105                	addi	sp,sp,32
    80200158:	8082                	ret

000000008020015a <finished>:

// Count finished programs. If all apps exited, shutdown.
int finished()
{
	static int fin = 0;
	if (++fin >= app_num)
    8020015a:	0005e717          	auipc	a4,0x5e
    8020015e:	62e70713          	addi	a4,a4,1582 # 8025e788 <fin.0>
    80200162:	431c                	lw	a5,0(a4)
    80200164:	2785                	addiw	a5,a5,1
    80200166:	0007869b          	sext.w	a3,a5
    8020016a:	c31c                	sw	a5,0(a4)
    8020016c:	0005e797          	auipc	a5,0x5e
    80200170:	62c7a783          	lw	a5,1580(a5) # 8025e798 <app_num>
    80200174:	00f6d463          	bge	a3,a5,8020017c <finished+0x22>
		panic("all apps over");
	return 0;
}
    80200178:	4501                	li	a0,0
    8020017a:	8082                	ret
{
    8020017c:	1141                	addi	sp,sp,-16
    8020017e:	e406                	sd	ra,8(sp)
    80200180:	e022                	sd	s0,0(sp)
    80200182:	0800                	addi	s0,sp,16
		panic("all apps over");
    80200184:	00000097          	auipc	ra,0x0
    80200188:	5a6080e7          	jalr	1446(ra) # 8020072a <threadid>
    8020018c:	86aa                	mv	a3,a0
    8020018e:	47b9                	li	a5,14
    80200190:	00003717          	auipc	a4,0x3
    80200194:	ea870713          	addi	a4,a4,-344 # 80203038 <e_text+0x38>
    80200198:	00003617          	auipc	a2,0x3
    8020019c:	e7860613          	addi	a2,a2,-392 # 80203010 <e_text+0x10>
    802001a0:	45fd                	li	a1,31
    802001a2:	00003517          	auipc	a0,0x3
    802001a6:	ea650513          	addi	a0,a0,-346 # 80203048 <e_text+0x48>
    802001aa:	00000097          	auipc	ra,0x0
    802001ae:	3aa080e7          	jalr	938(ra) # 80200554 <printf>
    802001b2:	00001097          	auipc	ra,0x1
    802001b6:	89e080e7          	jalr	-1890(ra) # 80200a50 <shutdown>
}
    802001ba:	4501                	li	a0,0
    802001bc:	60a2                	ld	ra,8(sp)
    802001be:	6402                	ld	s0,0(sp)
    802001c0:	0141                	addi	sp,sp,16
    802001c2:	8082                	ret

00000000802001c4 <loader_init>:

// Get user progs' infomation through pre-defined symbol in `link_app.S`
void loader_init()
{
    802001c4:	1141                	addi	sp,sp,-16
    802001c6:	e422                	sd	s0,8(sp)
    802001c8:	0800                	addi	s0,sp,16
	app_info_ptr = (uint64 *)_app_num;
	app_num = *app_info_ptr;
    802001ca:	00004697          	auipc	a3,0x4
    802001ce:	e3668693          	addi	a3,a3,-458 # 80204000 <_app_num>
    802001d2:	0006c783          	lbu	a5,0(a3)
    802001d6:	0016c703          	lbu	a4,1(a3)
    802001da:	0722                	slli	a4,a4,0x8
    802001dc:	8f5d                	or	a4,a4,a5
    802001de:	0026c783          	lbu	a5,2(a3)
    802001e2:	07c2                	slli	a5,a5,0x10
    802001e4:	8f5d                	or	a4,a4,a5
    802001e6:	0036c783          	lbu	a5,3(a3)
    802001ea:	07e2                	slli	a5,a5,0x18
    802001ec:	8fd9                	or	a5,a5,a4
    802001ee:	0005e717          	auipc	a4,0x5e
    802001f2:	5af72523          	sw	a5,1450(a4) # 8025e798 <app_num>
	app_info_ptr++;
    802001f6:	00004797          	auipc	a5,0x4
    802001fa:	e1278793          	addi	a5,a5,-494 # 80204008 <_app_num+0x8>
    802001fe:	0005e717          	auipc	a4,0x5e
    80200202:	58f73923          	sd	a5,1426(a4) # 8025e790 <app_info_ptr>
}
    80200206:	6422                	ld	s0,8(sp)
    80200208:	0141                	addi	sp,sp,16
    8020020a:	8082                	ret

000000008020020c <bin_loader>:

pagetable_t bin_loader(uint64 start, uint64 end, struct proc *p)
{
    8020020c:	7179                	addi	sp,sp,-48
    8020020e:	f406                	sd	ra,40(sp)
    80200210:	f022                	sd	s0,32(sp)
    80200212:	ec26                	sd	s1,24(sp)
    80200214:	e84a                	sd	s2,16(sp)
    80200216:	e44e                	sd	s3,8(sp)
    80200218:	e052                	sd	s4,0(sp)
    8020021a:	1800                	addi	s0,sp,48
    8020021c:	8a2a                	mv	s4,a0
    8020021e:	84ae                	mv	s1,a1
    80200220:	8932                	mv	s2,a2
	pagetable_t pg = uvmcreate();
    80200222:	00001097          	auipc	ra,0x1
    80200226:	6cc080e7          	jalr	1740(ra) # 802018ee <uvmcreate>
    8020022a:	89aa                	mv	s3,a0
	if (mappages(pg, TRAPFRAME, PGSIZE, (uint64)p->trapframe,
    8020022c:	4719                	li	a4,6
    8020022e:	01893683          	ld	a3,24(s2)
    80200232:	6605                	lui	a2,0x1
    80200234:	020005b7          	lui	a1,0x2000
    80200238:	15fd                	addi	a1,a1,-1
    8020023a:	05b6                	slli	a1,a1,0xd
    8020023c:	00001097          	auipc	ra,0x1
    80200240:	3dc080e7          	jalr	988(ra) # 80201618 <mappages>
    80200244:	08054663          	bltz	a0,802002d0 <bin_loader+0xc4>
		     PTE_R | PTE_W) < 0) {
		panic("mappages fail");
	}
	if (!PGALIGNED(start)) {
    80200248:	034a1793          	slli	a5,s4,0x34
    8020024c:	efd5                	bnez	a5,80200308 <bin_loader+0xfc>
		panic("user program not aligned, start = %p", start);
	}
	if (!PGALIGNED(end)) {
    8020024e:	03449793          	slli	a5,s1,0x34
    80200252:	ebed                	bnez	a5,80200344 <bin_loader+0x138>
		// Fix in ch5
		warnf("Some kernel data maybe mapped to user, start = %p, end = %p",
		      start, end);
	}
	end = PGROUNDUP(end);
    80200254:	6585                	lui	a1,0x1
    80200256:	15fd                	addi	a1,a1,-1
    80200258:	94ae                	add	s1,s1,a1
    8020025a:	75fd                	lui	a1,0xfffff
    8020025c:	8ced                	and	s1,s1,a1
	uint64 length = end - start;
    8020025e:	414484b3          	sub	s1,s1,s4
	if (mappages(pg, BASE_ADDRESS, length, start,
    80200262:	4779                	li	a4,30
    80200264:	86d2                	mv	a3,s4
    80200266:	8626                	mv	a2,s1
    80200268:	6585                	lui	a1,0x1
    8020026a:	854e                	mv	a0,s3
    8020026c:	00001097          	auipc	ra,0x1
    80200270:	3ac080e7          	jalr	940(ra) # 80201618 <mappages>
    80200274:	e165                	bnez	a0,80200354 <bin_loader+0x148>
		     PTE_U | PTE_R | PTE_W | PTE_X) != 0) {
		panic("mappages fail");
	}
	p->pagetable = pg;
    80200276:	09393823          	sd	s3,144(s2)
	uint64 ustack_bottom_vaddr = BASE_ADDRESS + length + PAGE_SIZE;
    8020027a:	6a09                	lui	s4,0x2
    8020027c:	94d2                	add	s1,s1,s4
	if (USTACK_SIZE != PAGE_SIZE) {
		// Fix in ch5
		panic("Unsupported");
	}
	mappages(pg, ustack_bottom_vaddr, USTACK_SIZE, (uint64)kalloc(),
    8020027e:	00000097          	auipc	ra,0x0
    80200282:	ea4080e7          	jalr	-348(ra) # 80200122 <kalloc>
    80200286:	86aa                	mv	a3,a0
    80200288:	4779                	li	a4,30
    8020028a:	6605                	lui	a2,0x1
    8020028c:	85a6                	mv	a1,s1
    8020028e:	854e                	mv	a0,s3
    80200290:	00001097          	auipc	ra,0x1
    80200294:	388080e7          	jalr	904(ra) # 80201618 <mappages>
		 PTE_U | PTE_R | PTE_W | PTE_X);
	p->ustack = ustack_bottom_vaddr;
    80200298:	00993423          	sd	s1,8(s2)
	p->trapframe->epc = BASE_ADDRESS;
    8020029c:	01893783          	ld	a5,24(s2)
    802002a0:	6705                	lui	a4,0x1
    802002a2:	ef98                	sd	a4,24(a5)
	p->trapframe->sp = p->ustack + USTACK_SIZE;
    802002a4:	01893683          	ld	a3,24(s2)
    802002a8:	00893783          	ld	a5,8(s2)
    802002ac:	97ba                	add	a5,a5,a4
    802002ae:	fa9c                	sd	a5,48(a3)
	p->max_page = PGROUNDUP(p->ustack + USTACK_SIZE - 1) / PAGE_SIZE;
    802002b0:	00893783          	ld	a5,8(s2)
    802002b4:	1a79                	addi	s4,s4,-2
    802002b6:	97d2                	add	a5,a5,s4
    802002b8:	83b1                	srli	a5,a5,0xc
    802002ba:	08f93c23          	sd	a5,152(s2)
	return pg;
}
    802002be:	854e                	mv	a0,s3
    802002c0:	70a2                	ld	ra,40(sp)
    802002c2:	7402                	ld	s0,32(sp)
    802002c4:	64e2                	ld	s1,24(sp)
    802002c6:	6942                	ld	s2,16(sp)
    802002c8:	69a2                	ld	s3,8(sp)
    802002ca:	6a02                	ld	s4,0(sp)
    802002cc:	6145                	addi	sp,sp,48
    802002ce:	8082                	ret
		panic("mappages fail");
    802002d0:	00000097          	auipc	ra,0x0
    802002d4:	45a080e7          	jalr	1114(ra) # 8020072a <threadid>
    802002d8:	86aa                	mv	a3,a0
    802002da:	47fd                	li	a5,31
    802002dc:	00003717          	auipc	a4,0x3
    802002e0:	d5c70713          	addi	a4,a4,-676 # 80203038 <e_text+0x38>
    802002e4:	00003617          	auipc	a2,0x3
    802002e8:	d2c60613          	addi	a2,a2,-724 # 80203010 <e_text+0x10>
    802002ec:	45fd                	li	a1,31
    802002ee:	00003517          	auipc	a0,0x3
    802002f2:	d8250513          	addi	a0,a0,-638 # 80203070 <e_text+0x70>
    802002f6:	00000097          	auipc	ra,0x0
    802002fa:	25e080e7          	jalr	606(ra) # 80200554 <printf>
    802002fe:	00000097          	auipc	ra,0x0
    80200302:	752080e7          	jalr	1874(ra) # 80200a50 <shutdown>
    80200306:	b789                	j	80200248 <bin_loader+0x3c>
		panic("user program not aligned, start = %p", start);
    80200308:	00000097          	auipc	ra,0x0
    8020030c:	422080e7          	jalr	1058(ra) # 8020072a <threadid>
    80200310:	86aa                	mv	a3,a0
    80200312:	8852                	mv	a6,s4
    80200314:	02200793          	li	a5,34
    80200318:	00003717          	auipc	a4,0x3
    8020031c:	d2070713          	addi	a4,a4,-736 # 80203038 <e_text+0x38>
    80200320:	00003617          	auipc	a2,0x3
    80200324:	cf060613          	addi	a2,a2,-784 # 80203010 <e_text+0x10>
    80200328:	45fd                	li	a1,31
    8020032a:	00003517          	auipc	a0,0x3
    8020032e:	d6e50513          	addi	a0,a0,-658 # 80203098 <e_text+0x98>
    80200332:	00000097          	auipc	ra,0x0
    80200336:	222080e7          	jalr	546(ra) # 80200554 <printf>
    8020033a:	00000097          	auipc	ra,0x0
    8020033e:	716080e7          	jalr	1814(ra) # 80200a50 <shutdown>
    80200342:	b731                	j	8020024e <bin_loader+0x42>
		warnf("Some kernel data maybe mapped to user, start = %p, end = %p",
    80200344:	8626                	mv	a2,s1
    80200346:	85d2                	mv	a1,s4
    80200348:	4501                	li	a0,0
    8020034a:	00001097          	auipc	ra,0x1
    8020034e:	8e2080e7          	jalr	-1822(ra) # 80200c2c <dummy>
    80200352:	b709                	j	80200254 <bin_loader+0x48>
		panic("mappages fail");
    80200354:	00000097          	auipc	ra,0x0
    80200358:	3d6080e7          	jalr	982(ra) # 8020072a <threadid>
    8020035c:	86aa                	mv	a3,a0
    8020035e:	02d00793          	li	a5,45
    80200362:	00003717          	auipc	a4,0x3
    80200366:	cd670713          	addi	a4,a4,-810 # 80203038 <e_text+0x38>
    8020036a:	00003617          	auipc	a2,0x3
    8020036e:	ca660613          	addi	a2,a2,-858 # 80203010 <e_text+0x10>
    80200372:	45fd                	li	a1,31
    80200374:	00003517          	auipc	a0,0x3
    80200378:	cfc50513          	addi	a0,a0,-772 # 80203070 <e_text+0x70>
    8020037c:	00000097          	auipc	ra,0x0
    80200380:	1d8080e7          	jalr	472(ra) # 80200554 <printf>
    80200384:	00000097          	auipc	ra,0x0
    80200388:	6cc080e7          	jalr	1740(ra) # 80200a50 <shutdown>
    8020038c:	b5ed                	j	80200276 <bin_loader+0x6a>

000000008020038e <run_all_app>:

// load all apps and init the corresponding `proc` structure.
int run_all_app()
{
	for (int i = 0; i < app_num; ++i) {
    8020038e:	0005e797          	auipc	a5,0x5e
    80200392:	40a7a783          	lw	a5,1034(a5) # 8025e798 <app_num>
    80200396:	08f05163          	blez	a5,80200418 <run_all_app+0x8a>
{
    8020039a:	7139                	addi	sp,sp,-64
    8020039c:	fc06                	sd	ra,56(sp)
    8020039e:	f822                	sd	s0,48(sp)
    802003a0:	f426                	sd	s1,40(sp)
    802003a2:	f04a                	sd	s2,32(sp)
    802003a4:	ec4e                	sd	s3,24(sp)
    802003a6:	e852                	sd	s4,16(sp)
    802003a8:	e456                	sd	s5,8(sp)
    802003aa:	e05a                	sd	s6,0(sp)
    802003ac:	0080                	addi	s0,sp,64
	for (int i = 0; i < app_num; ++i) {
    802003ae:	4981                	li	s3,0
    802003b0:	4901                	li	s2,0
		struct proc *p = allocproc();
		tracef("load app %d", i);
		bin_loader(app_info_ptr[i], app_info_ptr[i + 1], p);
    802003b2:	0005eb17          	auipc	s6,0x5e
    802003b6:	3deb0b13          	addi	s6,s6,990 # 8025e790 <app_info_ptr>
		p->state = RUNNABLE;
    802003ba:	4a8d                	li	s5,3
	for (int i = 0; i < app_num; ++i) {
    802003bc:	0005ea17          	auipc	s4,0x5e
    802003c0:	3dca0a13          	addi	s4,s4,988 # 8025e798 <app_num>
		struct proc *p = allocproc();
    802003c4:	00000097          	auipc	ra,0x0
    802003c8:	468080e7          	jalr	1128(ra) # 8020082c <allocproc>
    802003cc:	84aa                	mv	s1,a0
		tracef("load app %d", i);
    802003ce:	85ca                	mv	a1,s2
    802003d0:	4501                	li	a0,0
    802003d2:	00001097          	auipc	ra,0x1
    802003d6:	85a080e7          	jalr	-1958(ra) # 80200c2c <dummy>
		bin_loader(app_info_ptr[i], app_info_ptr[i + 1], p);
    802003da:	000b3783          	ld	a5,0(s6)
    802003de:	01378733          	add	a4,a5,s3
    802003e2:	09a1                	addi	s3,s3,8
    802003e4:	97ce                	add	a5,a5,s3
    802003e6:	8626                	mv	a2,s1
    802003e8:	638c                	ld	a1,0(a5)
    802003ea:	6308                	ld	a0,0(a4)
    802003ec:	00000097          	auipc	ra,0x0
    802003f0:	e20080e7          	jalr	-480(ra) # 8020020c <bin_loader>
		p->state = RUNNABLE;
    802003f4:	0154a023          	sw	s5,0(s1)
	for (int i = 0; i < app_num; ++i) {
    802003f8:	2905                	addiw	s2,s2,1
    802003fa:	000a2783          	lw	a5,0(s4)
    802003fe:	fcf943e3          	blt	s2,a5,802003c4 <run_all_app+0x36>
		/*
		* LAB1: you may need to initialize your new fields of proc here
		*/
	}
	return 0;
    80200402:	4501                	li	a0,0
    80200404:	70e2                	ld	ra,56(sp)
    80200406:	7442                	ld	s0,48(sp)
    80200408:	74a2                	ld	s1,40(sp)
    8020040a:	7902                	ld	s2,32(sp)
    8020040c:	69e2                	ld	s3,24(sp)
    8020040e:	6a42                	ld	s4,16(sp)
    80200410:	6aa2                	ld	s5,8(sp)
    80200412:	6b02                	ld	s6,0(sp)
    80200414:	6121                	addi	sp,sp,64
    80200416:	8082                	ret
    80200418:	4501                	li	a0,0
    8020041a:	8082                	ret

000000008020041c <clean_bss>:
#include "loader.h"
#include "timer.h"
#include "trap.h"

void clean_bss()
{
    8020041c:	1141                	addi	sp,sp,-16
    8020041e:	e406                	sd	ra,8(sp)
    80200420:	e022                	sd	s0,0(sp)
    80200422:	0800                	addi	s0,sp,16
	extern char s_bss[];
	extern char e_bss[];
	memset(s_bss, 0, e_bss - s_bss);
    80200424:	00035517          	auipc	a0,0x35
    80200428:	bdc50513          	addi	a0,a0,-1060 # 80235000 <idle>
    8020042c:	0005f617          	auipc	a2,0x5f
    80200430:	bd460613          	addi	a2,a2,-1068 # 8025f000 <e_bss>
    80200434:	9e09                	subw	a2,a2,a0
    80200436:	4581                	li	a1,0
    80200438:	00000097          	auipc	ra,0x0
    8020043c:	646080e7          	jalr	1606(ra) # 80200a7e <memset>
}
    80200440:	60a2                	ld	ra,8(sp)
    80200442:	6402                	ld	s0,0(sp)
    80200444:	0141                	addi	sp,sp,16
    80200446:	8082                	ret

0000000080200448 <main>:

void main()
{
    80200448:	1141                	addi	sp,sp,-16
    8020044a:	e406                	sd	ra,8(sp)
    8020044c:	e022                	sd	s0,0(sp)
    8020044e:	0800                	addi	s0,sp,16
	clean_bss();
    80200450:	00000097          	auipc	ra,0x0
    80200454:	fcc080e7          	jalr	-52(ra) # 8020041c <clean_bss>
	printf("hello world!\n");
    80200458:	00003517          	auipc	a0,0x3
    8020045c:	c8050513          	addi	a0,a0,-896 # 802030d8 <e_text+0xd8>
    80200460:	00000097          	auipc	ra,0x0
    80200464:	0f4080e7          	jalr	244(ra) # 80200554 <printf>
	proc_init();
    80200468:	00000097          	auipc	ra,0x0
    8020046c:	2ec080e7          	jalr	748(ra) # 80200754 <proc_init>
	kinit();
    80200470:	00000097          	auipc	ra,0x0
    80200474:	c8e080e7          	jalr	-882(ra) # 802000fe <kinit>
	kvm_init();
    80200478:	00001097          	auipc	ra,0x1
    8020047c:	32a080e7          	jalr	810(ra) # 802017a2 <kvm_init>
	loader_init();
    80200480:	00000097          	auipc	ra,0x0
    80200484:	d44080e7          	jalr	-700(ra) # 802001c4 <loader_init>
	trap_init();
    80200488:	00001097          	auipc	ra,0x1
    8020048c:	dbc080e7          	jalr	-580(ra) # 80201244 <trap_init>
	timer_init();
    80200490:	00001097          	auipc	ra,0x1
    80200494:	cc0080e7          	jalr	-832(ra) # 80201150 <timer_init>
	run_all_app();
    80200498:	00000097          	auipc	ra,0x0
    8020049c:	ef6080e7          	jalr	-266(ra) # 8020038e <run_all_app>
	infof("start scheduler!");
    802004a0:	4501                	li	a0,0
    802004a2:	00000097          	auipc	ra,0x0
    802004a6:	78a080e7          	jalr	1930(ra) # 80200c2c <dummy>
	scheduler();
    802004aa:	00000097          	auipc	ra,0x0
    802004ae:	416080e7          	jalr	1046(ra) # 802008c0 <scheduler>

00000000802004b2 <printint>:
#include "console.h"
#include "defs.h"
static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign)
{
    802004b2:	7179                	addi	sp,sp,-48
    802004b4:	f406                	sd	ra,40(sp)
    802004b6:	f022                	sd	s0,32(sp)
    802004b8:	ec26                	sd	s1,24(sp)
    802004ba:	e84a                	sd	s2,16(sp)
    802004bc:	1800                	addi	s0,sp,48
	char buf[16];
	int i;
	uint x;

	if (sign && (sign = xx < 0))
    802004be:	c219                	beqz	a2,802004c4 <printint+0x12>
    802004c0:	08054663          	bltz	a0,8020054c <printint+0x9a>
		x = -xx;
	else
		x = xx;
    802004c4:	2501                	sext.w	a0,a0
    802004c6:	4881                	li	a7,0
    802004c8:	fd040693          	addi	a3,s0,-48

	i = 0;
    802004cc:	4701                	li	a4,0
	do {
		buf[i++] = digits[x % base];
    802004ce:	2581                	sext.w	a1,a1
    802004d0:	00003617          	auipc	a2,0x3
    802004d4:	c5860613          	addi	a2,a2,-936 # 80203128 <digits>
    802004d8:	883a                	mv	a6,a4
    802004da:	2705                	addiw	a4,a4,1
    802004dc:	02b577bb          	remuw	a5,a0,a1
    802004e0:	1782                	slli	a5,a5,0x20
    802004e2:	9381                	srli	a5,a5,0x20
    802004e4:	97b2                	add	a5,a5,a2
    802004e6:	0007c783          	lbu	a5,0(a5)
    802004ea:	00f68023          	sb	a5,0(a3)
	} while ((x /= base) != 0);
    802004ee:	0005079b          	sext.w	a5,a0
    802004f2:	02b5553b          	divuw	a0,a0,a1
    802004f6:	0685                	addi	a3,a3,1
    802004f8:	feb7f0e3          	bgeu	a5,a1,802004d8 <printint+0x26>

	if (sign)
    802004fc:	00088b63          	beqz	a7,80200512 <printint+0x60>
		buf[i++] = '-';
    80200500:	fe040793          	addi	a5,s0,-32
    80200504:	973e                	add	a4,a4,a5
    80200506:	02d00793          	li	a5,45
    8020050a:	fef70823          	sb	a5,-16(a4)
    8020050e:	0028071b          	addiw	a4,a6,2

	while (--i >= 0)
    80200512:	02e05763          	blez	a4,80200540 <printint+0x8e>
    80200516:	fd040793          	addi	a5,s0,-48
    8020051a:	00e784b3          	add	s1,a5,a4
    8020051e:	fff78913          	addi	s2,a5,-1
    80200522:	993a                	add	s2,s2,a4
    80200524:	377d                	addiw	a4,a4,-1
    80200526:	1702                	slli	a4,a4,0x20
    80200528:	9301                	srli	a4,a4,0x20
    8020052a:	40e90933          	sub	s2,s2,a4
		consputc(buf[i]);
    8020052e:	fff4c503          	lbu	a0,-1(s1)
    80200532:	00000097          	auipc	ra,0x0
    80200536:	ada080e7          	jalr	-1318(ra) # 8020000c <consputc>
	while (--i >= 0)
    8020053a:	14fd                	addi	s1,s1,-1
    8020053c:	ff2499e3          	bne	s1,s2,8020052e <printint+0x7c>
}
    80200540:	70a2                	ld	ra,40(sp)
    80200542:	7402                	ld	s0,32(sp)
    80200544:	64e2                	ld	s1,24(sp)
    80200546:	6942                	ld	s2,16(sp)
    80200548:	6145                	addi	sp,sp,48
    8020054a:	8082                	ret
		x = -xx;
    8020054c:	40a0053b          	negw	a0,a0
	if (sign && (sign = xx < 0))
    80200550:	4885                	li	a7,1
		x = -xx;
    80200552:	bf9d                	j	802004c8 <printint+0x16>

0000000080200554 <printf>:
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the console. only understands %d, %x, %p, %s.
void printf(char *fmt, ...)
{
    80200554:	7131                	addi	sp,sp,-192
    80200556:	fc86                	sd	ra,120(sp)
    80200558:	f8a2                	sd	s0,112(sp)
    8020055a:	f4a6                	sd	s1,104(sp)
    8020055c:	f0ca                	sd	s2,96(sp)
    8020055e:	ecce                	sd	s3,88(sp)
    80200560:	e8d2                	sd	s4,80(sp)
    80200562:	e4d6                	sd	s5,72(sp)
    80200564:	e0da                	sd	s6,64(sp)
    80200566:	fc5e                	sd	s7,56(sp)
    80200568:	f862                	sd	s8,48(sp)
    8020056a:	f466                	sd	s9,40(sp)
    8020056c:	f06a                	sd	s10,32(sp)
    8020056e:	ec6e                	sd	s11,24(sp)
    80200570:	0100                	addi	s0,sp,128
    80200572:	8a2a                	mv	s4,a0
    80200574:	e40c                	sd	a1,8(s0)
    80200576:	e810                	sd	a2,16(s0)
    80200578:	ec14                	sd	a3,24(s0)
    8020057a:	f018                	sd	a4,32(s0)
    8020057c:	f41c                	sd	a5,40(s0)
    8020057e:	03043823          	sd	a6,48(s0)
    80200582:	03143c23          	sd	a7,56(s0)
	va_list ap;
	int i, c;
	char *s;

	if (fmt == 0)
    80200586:	c915                	beqz	a0,802005ba <printf+0x66>
		panic("null fmt");

	va_start(ap, fmt);
    80200588:	00840793          	addi	a5,s0,8
    8020058c:	f8f43423          	sd	a5,-120(s0)
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80200590:	000a4503          	lbu	a0,0(s4)
    80200594:	16050c63          	beqz	a0,8020070c <printf+0x1b8>
    80200598:	4981                	li	s3,0
		if (c != '%') {
    8020059a:	02500a93          	li	s5,37
			continue;
		}
		c = fmt[++i] & 0xff;
		if (c == 0)
			break;
		switch (c) {
    8020059e:	07000b93          	li	s7,112
	consputc('x');
    802005a2:	4d41                	li	s10,16
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    802005a4:	00003b17          	auipc	s6,0x3
    802005a8:	b84b0b13          	addi	s6,s6,-1148 # 80203128 <digits>
		switch (c) {
    802005ac:	07300c93          	li	s9,115
			printptr(va_arg(ap, uint64));
			break;
		case 's':
			if ((s = va_arg(ap, char *)) == 0)
				s = "(null)";
			for (; *s; s++)
    802005b0:	02800d93          	li	s11,40
		switch (c) {
    802005b4:	06400c13          	li	s8,100
    802005b8:	a889                	j	8020060a <printf+0xb6>
		panic("null fmt");
    802005ba:	00000097          	auipc	ra,0x0
    802005be:	170080e7          	jalr	368(ra) # 8020072a <threadid>
    802005c2:	86aa                	mv	a3,a0
    802005c4:	02e00793          	li	a5,46
    802005c8:	00003717          	auipc	a4,0x3
    802005cc:	b2870713          	addi	a4,a4,-1240 # 802030f0 <e_text+0xf0>
    802005d0:	00003617          	auipc	a2,0x3
    802005d4:	a4060613          	addi	a2,a2,-1472 # 80203010 <e_text+0x10>
    802005d8:	45fd                	li	a1,31
    802005da:	00003517          	auipc	a0,0x3
    802005de:	b2650513          	addi	a0,a0,-1242 # 80203100 <e_text+0x100>
    802005e2:	00000097          	auipc	ra,0x0
    802005e6:	f72080e7          	jalr	-142(ra) # 80200554 <printf>
    802005ea:	00000097          	auipc	ra,0x0
    802005ee:	466080e7          	jalr	1126(ra) # 80200a50 <shutdown>
    802005f2:	bf59                	j	80200588 <printf+0x34>
			consputc(c);
    802005f4:	00000097          	auipc	ra,0x0
    802005f8:	a18080e7          	jalr	-1512(ra) # 8020000c <consputc>
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    802005fc:	2985                	addiw	s3,s3,1
    802005fe:	013a07b3          	add	a5,s4,s3
    80200602:	0007c503          	lbu	a0,0(a5)
    80200606:	10050363          	beqz	a0,8020070c <printf+0x1b8>
		if (c != '%') {
    8020060a:	ff5515e3          	bne	a0,s5,802005f4 <printf+0xa0>
		c = fmt[++i] & 0xff;
    8020060e:	2985                	addiw	s3,s3,1
    80200610:	013a07b3          	add	a5,s4,s3
    80200614:	0007c783          	lbu	a5,0(a5)
    80200618:	0007849b          	sext.w	s1,a5
		if (c == 0)
    8020061c:	cbe5                	beqz	a5,8020070c <printf+0x1b8>
		switch (c) {
    8020061e:	05778a63          	beq	a5,s7,80200672 <printf+0x11e>
    80200622:	02fbf663          	bgeu	s7,a5,8020064e <printf+0xfa>
    80200626:	09978863          	beq	a5,s9,802006b6 <printf+0x162>
    8020062a:	07800713          	li	a4,120
    8020062e:	0ce79463          	bne	a5,a4,802006f6 <printf+0x1a2>
			printint(va_arg(ap, int), 16, 1);
    80200632:	f8843783          	ld	a5,-120(s0)
    80200636:	00878713          	addi	a4,a5,8
    8020063a:	f8e43423          	sd	a4,-120(s0)
    8020063e:	4605                	li	a2,1
    80200640:	85ea                	mv	a1,s10
    80200642:	4388                	lw	a0,0(a5)
    80200644:	00000097          	auipc	ra,0x0
    80200648:	e6e080e7          	jalr	-402(ra) # 802004b2 <printint>
			break;
    8020064c:	bf45                	j	802005fc <printf+0xa8>
		switch (c) {
    8020064e:	09578e63          	beq	a5,s5,802006ea <printf+0x196>
    80200652:	0b879263          	bne	a5,s8,802006f6 <printf+0x1a2>
			printint(va_arg(ap, int), 10, 1);
    80200656:	f8843783          	ld	a5,-120(s0)
    8020065a:	00878713          	addi	a4,a5,8
    8020065e:	f8e43423          	sd	a4,-120(s0)
    80200662:	4605                	li	a2,1
    80200664:	45a9                	li	a1,10
    80200666:	4388                	lw	a0,0(a5)
    80200668:	00000097          	auipc	ra,0x0
    8020066c:	e4a080e7          	jalr	-438(ra) # 802004b2 <printint>
			break;
    80200670:	b771                	j	802005fc <printf+0xa8>
			printptr(va_arg(ap, uint64));
    80200672:	f8843783          	ld	a5,-120(s0)
    80200676:	00878713          	addi	a4,a5,8
    8020067a:	f8e43423          	sd	a4,-120(s0)
    8020067e:	0007b903          	ld	s2,0(a5)
	consputc('0');
    80200682:	03000513          	li	a0,48
    80200686:	00000097          	auipc	ra,0x0
    8020068a:	986080e7          	jalr	-1658(ra) # 8020000c <consputc>
	consputc('x');
    8020068e:	07800513          	li	a0,120
    80200692:	00000097          	auipc	ra,0x0
    80200696:	97a080e7          	jalr	-1670(ra) # 8020000c <consputc>
    8020069a:	84ea                	mv	s1,s10
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8020069c:	03c95793          	srli	a5,s2,0x3c
    802006a0:	97da                	add	a5,a5,s6
    802006a2:	0007c503          	lbu	a0,0(a5)
    802006a6:	00000097          	auipc	ra,0x0
    802006aa:	966080e7          	jalr	-1690(ra) # 8020000c <consputc>
	for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    802006ae:	0912                	slli	s2,s2,0x4
    802006b0:	34fd                	addiw	s1,s1,-1
    802006b2:	f4ed                	bnez	s1,8020069c <printf+0x148>
    802006b4:	b7a1                	j	802005fc <printf+0xa8>
			if ((s = va_arg(ap, char *)) == 0)
    802006b6:	f8843783          	ld	a5,-120(s0)
    802006ba:	00878713          	addi	a4,a5,8
    802006be:	f8e43423          	sd	a4,-120(s0)
    802006c2:	6384                	ld	s1,0(a5)
    802006c4:	cc89                	beqz	s1,802006de <printf+0x18a>
			for (; *s; s++)
    802006c6:	0004c503          	lbu	a0,0(s1)
    802006ca:	d90d                	beqz	a0,802005fc <printf+0xa8>
				consputc(*s);
    802006cc:	00000097          	auipc	ra,0x0
    802006d0:	940080e7          	jalr	-1728(ra) # 8020000c <consputc>
			for (; *s; s++)
    802006d4:	0485                	addi	s1,s1,1
    802006d6:	0004c503          	lbu	a0,0(s1)
    802006da:	f96d                	bnez	a0,802006cc <printf+0x178>
    802006dc:	b705                	j	802005fc <printf+0xa8>
				s = "(null)";
    802006de:	00003497          	auipc	s1,0x3
    802006e2:	a0a48493          	addi	s1,s1,-1526 # 802030e8 <e_text+0xe8>
			for (; *s; s++)
    802006e6:	856e                	mv	a0,s11
    802006e8:	b7d5                	j	802006cc <printf+0x178>
			break;
		case '%':
			consputc('%');
    802006ea:	8556                	mv	a0,s5
    802006ec:	00000097          	auipc	ra,0x0
    802006f0:	920080e7          	jalr	-1760(ra) # 8020000c <consputc>
			break;
    802006f4:	b721                	j	802005fc <printf+0xa8>
		default:
			// Print unknown % sequence to draw attention.
			consputc('%');
    802006f6:	8556                	mv	a0,s5
    802006f8:	00000097          	auipc	ra,0x0
    802006fc:	914080e7          	jalr	-1772(ra) # 8020000c <consputc>
			consputc(c);
    80200700:	8526                	mv	a0,s1
    80200702:	00000097          	auipc	ra,0x0
    80200706:	90a080e7          	jalr	-1782(ra) # 8020000c <consputc>
			break;
    8020070a:	bdcd                	j	802005fc <printf+0xa8>
		}
	}
    8020070c:	70e6                	ld	ra,120(sp)
    8020070e:	7446                	ld	s0,112(sp)
    80200710:	74a6                	ld	s1,104(sp)
    80200712:	7906                	ld	s2,96(sp)
    80200714:	69e6                	ld	s3,88(sp)
    80200716:	6a46                	ld	s4,80(sp)
    80200718:	6aa6                	ld	s5,72(sp)
    8020071a:	6b06                	ld	s6,64(sp)
    8020071c:	7be2                	ld	s7,56(sp)
    8020071e:	7c42                	ld	s8,48(sp)
    80200720:	7ca2                	ld	s9,40(sp)
    80200722:	7d02                	ld	s10,32(sp)
    80200724:	6de2                	ld	s11,24(sp)
    80200726:	6129                	addi	sp,sp,192
    80200728:	8082                	ret

000000008020072a <threadid>:
extern char boot_stack_top[];
struct proc *current_proc;
struct proc idle;

int threadid()
{
    8020072a:	1141                	addi	sp,sp,-16
    8020072c:	e422                	sd	s0,8(sp)
    8020072e:	0800                	addi	s0,sp,16
	return curr_proc()->pid;
}
    80200730:	0005e797          	auipc	a5,0x5e
    80200734:	0707b783          	ld	a5,112(a5) # 8025e7a0 <current_proc>
    80200738:	43c8                	lw	a0,4(a5)
    8020073a:	6422                	ld	s0,8(sp)
    8020073c:	0141                	addi	sp,sp,16
    8020073e:	8082                	ret

0000000080200740 <curr_proc>:

struct proc *curr_proc()
{
    80200740:	1141                	addi	sp,sp,-16
    80200742:	e422                	sd	s0,8(sp)
    80200744:	0800                	addi	s0,sp,16
	return current_proc;
}
    80200746:	0005e517          	auipc	a0,0x5e
    8020074a:	05a53503          	ld	a0,90(a0) # 8025e7a0 <current_proc>
    8020074e:	6422                	ld	s0,8(sp)
    80200750:	0141                	addi	sp,sp,16
    80200752:	8082                	ret

0000000080200754 <proc_init>:

// initialize the proc table at boot time.
void proc_init(void)
{
    80200754:	715d                	addi	sp,sp,-80
    80200756:	e486                	sd	ra,72(sp)
    80200758:	e0a2                	sd	s0,64(sp)
    8020075a:	fc26                	sd	s1,56(sp)
    8020075c:	f84a                	sd	s2,48(sp)
    8020075e:	f44e                	sd	s3,40(sp)
    80200760:	f052                	sd	s4,32(sp)
    80200762:	ec56                	sd	s5,24(sp)
    80200764:	e85a                	sd	s6,16(sp)
    80200766:	e45e                	sd	s7,8(sp)
    80200768:	0880                	addi	s0,sp,80
	struct proc *p;
	for (p = pool; p < &pool[NPROC]; p++) {
    8020076a:	00056497          	auipc	s1,0x56
    8020076e:	93648493          	addi	s1,s1,-1738 # 802560a0 <pool+0xa0>
    80200772:	0005eb97          	auipc	s7,0x5e
    80200776:	0aeb8b93          	addi	s7,s7,174 # 8025e820 <kernel_pagetable+0x78>
		p->state = UNUSED;
		p->kstack = (uint64)kstack[p - pool];
    8020077a:	00056b17          	auipc	s6,0x56
    8020077e:	886b0b13          	addi	s6,s6,-1914 # 80256000 <pool>
    80200782:	00003a97          	auipc	s5,0x3
    80200786:	d36aba83          	ld	s5,-714(s5) # 802034b8 <digits+0x390>
    8020078a:	00046a17          	auipc	s4,0x46
    8020078e:	876a0a13          	addi	s4,s4,-1930 # 80246000 <kstack>
		p->trapframe = (struct trapframe *)trapframe[p - pool];
    80200792:	00036997          	auipc	s3,0x36
    80200796:	86e98993          	addi	s3,s3,-1938 # 80236000 <trapframe>
	for (p = pool; p < &pool[NPROC]; p++) {
    8020079a:	6905                	lui	s2,0x1
    8020079c:	87890913          	addi	s2,s2,-1928 # 878 <_entry-0x801ff788>
		p->state = UNUSED;
    802007a0:	f604a023          	sw	zero,-160(s1)
		p->kstack = (uint64)kstack[p - pool];
    802007a4:	f6048793          	addi	a5,s1,-160
    802007a8:	416787b3          	sub	a5,a5,s6
    802007ac:	878d                	srai	a5,a5,0x3
    802007ae:	035787b3          	mul	a5,a5,s5
    802007b2:	07b2                	slli	a5,a5,0xc
    802007b4:	01478733          	add	a4,a5,s4
    802007b8:	f6e4b823          	sd	a4,-144(s1)
		p->trapframe = (struct trapframe *)trapframe[p - pool];
    802007bc:	97ce                	add	a5,a5,s3
    802007be:	f6f4bc23          	sd	a5,-136(s1)
		/*
		* LAB1: you may need to initialize your new fields of proc here
		*/
		p->time = 0;
    802007c2:	7c04a823          	sw	zero,2000(s1)
		memset(p->syscall_times, 0, sizeof(p->syscall_times));
    802007c6:	7d000613          	li	a2,2000
    802007ca:	4581                	li	a1,0
    802007cc:	8526                	mv	a0,s1
    802007ce:	00000097          	auipc	ra,0x0
    802007d2:	2b0080e7          	jalr	688(ra) # 80200a7e <memset>
	for (p = pool; p < &pool[NPROC]; p++) {
    802007d6:	94ca                	add	s1,s1,s2
    802007d8:	fd7494e3          	bne	s1,s7,802007a0 <proc_init+0x4c>
	}
	idle.kstack = (uint64)boot_stack_top;
    802007dc:	00035797          	auipc	a5,0x35
    802007e0:	82478793          	addi	a5,a5,-2012 # 80235000 <idle>
    802007e4:	00035717          	auipc	a4,0x35
    802007e8:	81c70713          	addi	a4,a4,-2020 # 80235000 <idle>
    802007ec:	eb98                	sd	a4,16(a5)
	idle.pid = 0;
    802007ee:	0007a223          	sw	zero,4(a5)
	current_proc = &idle;
    802007f2:	0005e717          	auipc	a4,0x5e
    802007f6:	faf73723          	sd	a5,-82(a4) # 8025e7a0 <current_proc>
}
    802007fa:	60a6                	ld	ra,72(sp)
    802007fc:	6406                	ld	s0,64(sp)
    802007fe:	74e2                	ld	s1,56(sp)
    80200800:	7942                	ld	s2,48(sp)
    80200802:	79a2                	ld	s3,40(sp)
    80200804:	7a02                	ld	s4,32(sp)
    80200806:	6ae2                	ld	s5,24(sp)
    80200808:	6b42                	ld	s6,16(sp)
    8020080a:	6ba2                	ld	s7,8(sp)
    8020080c:	6161                	addi	sp,sp,80
    8020080e:	8082                	ret

0000000080200810 <allocpid>:

int allocpid()
{
    80200810:	1141                	addi	sp,sp,-16
    80200812:	e422                	sd	s0,8(sp)
    80200814:	0800                	addi	s0,sp,16
	static int PID = 1;
	return PID++;
    80200816:	00023797          	auipc	a5,0x23
    8020081a:	7ea78793          	addi	a5,a5,2026 # 80224000 <PID.0>
    8020081e:	4388                	lw	a0,0(a5)
    80200820:	0015071b          	addiw	a4,a0,1
    80200824:	c398                	sw	a4,0(a5)
}
    80200826:	6422                	ld	s0,8(sp)
    80200828:	0141                	addi	sp,sp,16
    8020082a:	8082                	ret

000000008020082c <allocproc>:

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel.
// If there are no free procs, or a memory allocation fails, return 0.
struct proc *allocproc(void)
{
    8020082c:	1101                	addi	sp,sp,-32
    8020082e:	ec06                	sd	ra,24(sp)
    80200830:	e822                	sd	s0,16(sp)
    80200832:	e426                	sd	s1,8(sp)
    80200834:	1000                	addi	s0,sp,32
	struct proc *p;
	for (p = pool; p < &pool[NPROC]; p++) {
    80200836:	00055497          	auipc	s1,0x55
    8020083a:	7ca48493          	addi	s1,s1,1994 # 80256000 <pool>
    8020083e:	6705                	lui	a4,0x1
    80200840:	87870713          	addi	a4,a4,-1928 # 878 <_entry-0x801ff788>
    80200844:	0005e697          	auipc	a3,0x5e
    80200848:	f3c68693          	addi	a3,a3,-196 # 8025e780 <kmem>
		if (p->state == UNUSED) {
    8020084c:	409c                	lw	a5,0(s1)
    8020084e:	cb99                	beqz	a5,80200864 <allocproc+0x38>
	for (p = pool; p < &pool[NPROC]; p++) {
    80200850:	94ba                	add	s1,s1,a4
    80200852:	fed49de3          	bne	s1,a3,8020084c <allocproc+0x20>
			goto found;
		}
	}
	return 0;
    80200856:	4481                	li	s1,0
	memset((void *)p->kstack, 0, KSTACK_SIZE);
	memset((void *)p->trapframe, 0, TRAP_PAGE_SIZE);
	p->context.ra = (uint64)usertrapret;
	p->context.sp = p->kstack + KSTACK_SIZE;
	return p;
}
    80200858:	8526                	mv	a0,s1
    8020085a:	60e2                	ld	ra,24(sp)
    8020085c:	6442                	ld	s0,16(sp)
    8020085e:	64a2                	ld	s1,8(sp)
    80200860:	6105                	addi	sp,sp,32
    80200862:	8082                	ret
	p->pid = allocpid();
    80200864:	00000097          	auipc	ra,0x0
    80200868:	fac080e7          	jalr	-84(ra) # 80200810 <allocpid>
    8020086c:	c0c8                	sw	a0,4(s1)
	p->state = USED;
    8020086e:	4785                	li	a5,1
    80200870:	c09c                	sw	a5,0(s1)
	p->pagetable = 0;
    80200872:	0804b823          	sd	zero,144(s1)
	p->ustack = 0;
    80200876:	0004b423          	sd	zero,8(s1)
	p->max_page = 0;
    8020087a:	0804bc23          	sd	zero,152(s1)
	memset(&p->context, 0, sizeof(p->context));
    8020087e:	07000613          	li	a2,112
    80200882:	4581                	li	a1,0
    80200884:	02048513          	addi	a0,s1,32
    80200888:	00000097          	auipc	ra,0x0
    8020088c:	1f6080e7          	jalr	502(ra) # 80200a7e <memset>
	memset((void *)p->kstack, 0, KSTACK_SIZE);
    80200890:	6605                	lui	a2,0x1
    80200892:	4581                	li	a1,0
    80200894:	6888                	ld	a0,16(s1)
    80200896:	00000097          	auipc	ra,0x0
    8020089a:	1e8080e7          	jalr	488(ra) # 80200a7e <memset>
	memset((void *)p->trapframe, 0, TRAP_PAGE_SIZE);
    8020089e:	6605                	lui	a2,0x1
    802008a0:	4581                	li	a1,0
    802008a2:	6c88                	ld	a0,24(s1)
    802008a4:	00000097          	auipc	ra,0x0
    802008a8:	1da080e7          	jalr	474(ra) # 80200a7e <memset>
	p->context.ra = (uint64)usertrapret;
    802008ac:	00001797          	auipc	a5,0x1
    802008b0:	9f878793          	addi	a5,a5,-1544 # 802012a4 <usertrapret>
    802008b4:	f09c                	sd	a5,32(s1)
	p->context.sp = p->kstack + KSTACK_SIZE;
    802008b6:	689c                	ld	a5,16(s1)
    802008b8:	6705                	lui	a4,0x1
    802008ba:	97ba                	add	a5,a5,a4
    802008bc:	f49c                	sd	a5,40(s1)
	return p;
    802008be:	bf69                	j	80200858 <allocproc+0x2c>

00000000802008c0 <scheduler>:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void scheduler(void)
{
    802008c0:	715d                	addi	sp,sp,-80
    802008c2:	e486                	sd	ra,72(sp)
    802008c4:	e0a2                	sd	s0,64(sp)
    802008c6:	fc26                	sd	s1,56(sp)
    802008c8:	f84a                	sd	s2,48(sp)
    802008ca:	f44e                	sd	s3,40(sp)
    802008cc:	f052                	sd	s4,32(sp)
    802008ce:	ec56                	sd	s5,24(sp)
    802008d0:	e85a                	sd	s6,16(sp)
    802008d2:	e45e                	sd	s7,8(sp)
    802008d4:	e062                	sd	s8,0(sp)
    802008d6:	0880                	addi	s0,sp,80
	struct proc *p;
	for (;;) {
		for (p = pool; p < &pool[NPROC]; p++) {
			if (p->state == RUNNABLE) {
    802008d8:	4a8d                	li	s5,3
				* LAB1: you may need to init proc start time here
				*/
				if (p->time == 0) {
					p->time = get_cycle();
				}
				p->state = RUNNING;
    802008da:	4c11                	li	s8,4
				current_proc = p;
    802008dc:	0005eb97          	auipc	s7,0x5e
    802008e0:	ec4b8b93          	addi	s7,s7,-316 # 8025e7a0 <current_proc>
				swtch(&idle.context, &p->context);
    802008e4:	00034b17          	auipc	s6,0x34
    802008e8:	73cb0b13          	addi	s6,s6,1852 # 80235020 <idle+0x20>
		for (p = pool; p < &pool[NPROC]; p++) {
    802008ec:	6985                	lui	s3,0x1
    802008ee:	87898993          	addi	s3,s3,-1928 # 878 <_entry-0x801ff788>
    802008f2:	0005ea17          	auipc	s4,0x5e
    802008f6:	e8ea0a13          	addi	s4,s4,-370 # 8025e780 <kmem>
    802008fa:	00056917          	auipc	s2,0x56
    802008fe:	f7690913          	addi	s2,s2,-138 # 80256870 <pool+0x870>
    80200902:	00055497          	auipc	s1,0x55
    80200906:	6fe48493          	addi	s1,s1,1790 # 80256000 <pool>
    8020090a:	a005                	j	8020092a <scheduler+0x6a>
				p->state = RUNNING;
    8020090c:	0184a023          	sw	s8,0(s1)
				current_proc = p;
    80200910:	009bb023          	sd	s1,0(s7)
				swtch(&idle.context, &p->context);
    80200914:	02048593          	addi	a1,s1,32
    80200918:	855a                	mv	a0,s6
    8020091a:	00001097          	auipc	ra,0x1
    8020091e:	318080e7          	jalr	792(ra) # 80201c32 <swtch>
		for (p = pool; p < &pool[NPROC]; p++) {
    80200922:	94ce                	add	s1,s1,s3
    80200924:	994e                	add	s2,s2,s3
    80200926:	fd448ae3          	beq	s1,s4,802008fa <scheduler+0x3a>
			if (p->state == RUNNABLE) {
    8020092a:	409c                	lw	a5,0(s1)
    8020092c:	ff579be3          	bne	a5,s5,80200922 <scheduler+0x62>
				if (p->time == 0) {
    80200930:	00092783          	lw	a5,0(s2)
    80200934:	ffe1                	bnez	a5,8020090c <scheduler+0x4c>
					p->time = get_cycle();
    80200936:	00000097          	auipc	ra,0x0
    8020093a:	7e6080e7          	jalr	2022(ra) # 8020111c <get_cycle>
    8020093e:	00a92023          	sw	a0,0(s2)
    80200942:	b7e9                	j	8020090c <scheduler+0x4c>

0000000080200944 <sched>:
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void sched(void)
{
    80200944:	1101                	addi	sp,sp,-32
    80200946:	ec06                	sd	ra,24(sp)
    80200948:	e822                	sd	s0,16(sp)
    8020094a:	e426                	sd	s1,8(sp)
    8020094c:	1000                	addi	s0,sp,32
	return current_proc;
    8020094e:	0005e497          	auipc	s1,0x5e
    80200952:	e524b483          	ld	s1,-430(s1) # 8025e7a0 <current_proc>
	struct proc *p = curr_proc();
	if (p->state == RUNNING)
    80200956:	4098                	lw	a4,0(s1)
    80200958:	4791                	li	a5,4
    8020095a:	02f70163          	beq	a4,a5,8020097c <sched+0x38>
		panic("sched running");
	swtch(&p->context, &idle.context);
    8020095e:	00034597          	auipc	a1,0x34
    80200962:	6c258593          	addi	a1,a1,1730 # 80235020 <idle+0x20>
    80200966:	02048513          	addi	a0,s1,32
    8020096a:	00001097          	auipc	ra,0x1
    8020096e:	2c8080e7          	jalr	712(ra) # 80201c32 <swtch>
}
    80200972:	60e2                	ld	ra,24(sp)
    80200974:	6442                	ld	s0,16(sp)
    80200976:	64a2                	ld	s1,8(sp)
    80200978:	6105                	addi	sp,sp,32
    8020097a:	8082                	ret
		panic("sched running");
    8020097c:	07200793          	li	a5,114
    80200980:	00002717          	auipc	a4,0x2
    80200984:	7c070713          	addi	a4,a4,1984 # 80203140 <digits+0x18>
    80200988:	40d4                	lw	a3,4(s1)
    8020098a:	00002617          	auipc	a2,0x2
    8020098e:	68660613          	addi	a2,a2,1670 # 80203010 <e_text+0x10>
    80200992:	45fd                	li	a1,31
    80200994:	00002517          	auipc	a0,0x2
    80200998:	7bc50513          	addi	a0,a0,1980 # 80203150 <digits+0x28>
    8020099c:	00000097          	auipc	ra,0x0
    802009a0:	bb8080e7          	jalr	-1096(ra) # 80200554 <printf>
    802009a4:	00000097          	auipc	ra,0x0
    802009a8:	0ac080e7          	jalr	172(ra) # 80200a50 <shutdown>
    802009ac:	bf4d                	j	8020095e <sched+0x1a>

00000000802009ae <yield>:

// Give up the CPU for one scheduling round.
void yield(void)
{
    802009ae:	1141                	addi	sp,sp,-16
    802009b0:	e406                	sd	ra,8(sp)
    802009b2:	e022                	sd	s0,0(sp)
    802009b4:	0800                	addi	s0,sp,16
	current_proc->state = RUNNABLE;
    802009b6:	0005e797          	auipc	a5,0x5e
    802009ba:	dea7b783          	ld	a5,-534(a5) # 8025e7a0 <current_proc>
    802009be:	470d                	li	a4,3
    802009c0:	c398                	sw	a4,0(a5)
	sched();
    802009c2:	00000097          	auipc	ra,0x0
    802009c6:	f82080e7          	jalr	-126(ra) # 80200944 <sched>
}
    802009ca:	60a2                	ld	ra,8(sp)
    802009cc:	6402                	ld	s0,0(sp)
    802009ce:	0141                	addi	sp,sp,16
    802009d0:	8082                	ret

00000000802009d2 <freeproc>:

void freeproc(struct proc *p)
{
    802009d2:	1141                	addi	sp,sp,-16
    802009d4:	e422                	sd	s0,8(sp)
    802009d6:	0800                	addi	s0,sp,16
	p->state = UNUSED;
    802009d8:	00052023          	sw	zero,0(a0)
	// uvmfree(p->pagetable, p->max_page);
}
    802009dc:	6422                	ld	s0,8(sp)
    802009de:	0141                	addi	sp,sp,16
    802009e0:	8082                	ret

00000000802009e2 <exit>:

// Exit the current process.
void exit(int code)
{
    802009e2:	1101                	addi	sp,sp,-32
    802009e4:	ec06                	sd	ra,24(sp)
    802009e6:	e822                	sd	s0,16(sp)
    802009e8:	e426                	sd	s1,8(sp)
    802009ea:	1000                	addi	s0,sp,32
    802009ec:	862a                	mv	a2,a0
	return current_proc;
    802009ee:	0005e497          	auipc	s1,0x5e
    802009f2:	db24b483          	ld	s1,-590(s1) # 8025e7a0 <current_proc>
	struct proc *p = curr_proc();
	infof("proc %d exit with %d", p->pid, code);
    802009f6:	40cc                	lw	a1,4(s1)
    802009f8:	4501                	li	a0,0
    802009fa:	00000097          	auipc	ra,0x0
    802009fe:	232080e7          	jalr	562(ra) # 80200c2c <dummy>
	p->state = UNUSED;
    80200a02:	0004a023          	sw	zero,0(s1)
	freeproc(p);
	finished();
    80200a06:	fffff097          	auipc	ra,0xfffff
    80200a0a:	754080e7          	jalr	1876(ra) # 8020015a <finished>
	sched();
    80200a0e:	00000097          	auipc	ra,0x0
    80200a12:	f36080e7          	jalr	-202(ra) # 80200944 <sched>
}
    80200a16:	60e2                	ld	ra,24(sp)
    80200a18:	6442                	ld	s0,16(sp)
    80200a1a:	64a2                	ld	s1,8(sp)
    80200a1c:	6105                	addi	sp,sp,32
    80200a1e:	8082                	ret

0000000080200a20 <console_putchar>:
		     : "memory");
	return a0;
}

void console_putchar(int c)
{
    80200a20:	1141                	addi	sp,sp,-16
    80200a22:	e422                	sd	s0,8(sp)
    80200a24:	0800                	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    80200a26:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    80200a28:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    80200a2a:	4885                	li	a7,1
	asm volatile("ecall"
    80200a2c:	00000073          	ecall
	sbi_call(SBI_CONSOLE_PUTCHAR, c, 0, 0);
}
    80200a30:	6422                	ld	s0,8(sp)
    80200a32:	0141                	addi	sp,sp,16
    80200a34:	8082                	ret

0000000080200a36 <console_getchar>:

int console_getchar()
{
    80200a36:	1141                	addi	sp,sp,-16
    80200a38:	e422                	sd	s0,8(sp)
    80200a3a:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    80200a3c:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    80200a3e:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    80200a40:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    80200a42:	4889                	li	a7,2
	asm volatile("ecall"
    80200a44:	00000073          	ecall
	return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
    80200a48:	2501                	sext.w	a0,a0
    80200a4a:	6422                	ld	s0,8(sp)
    80200a4c:	0141                	addi	sp,sp,16
    80200a4e:	8082                	ret

0000000080200a50 <shutdown>:

void shutdown()
{
    80200a50:	1141                	addi	sp,sp,-16
    80200a52:	e422                	sd	s0,8(sp)
    80200a54:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    80200a56:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    80200a58:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    80200a5a:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    80200a5c:	48a1                	li	a7,8
	asm volatile("ecall"
    80200a5e:	00000073          	ecall
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
}
    80200a62:	6422                	ld	s0,8(sp)
    80200a64:	0141                	addi	sp,sp,16
    80200a66:	8082                	ret

0000000080200a68 <set_timer>:

void set_timer(uint64 stime)
{
    80200a68:	1141                	addi	sp,sp,-16
    80200a6a:	e422                	sd	s0,8(sp)
    80200a6c:	0800                	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    80200a6e:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    80200a70:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    80200a72:	4881                	li	a7,0
	asm volatile("ecall"
    80200a74:	00000073          	ecall
	sbi_call(SBI_SET_TIMER, stime, 0, 0);
    80200a78:	6422                	ld	s0,8(sp)
    80200a7a:	0141                	addi	sp,sp,16
    80200a7c:	8082                	ret

0000000080200a7e <memset>:
#include "string.h"
#include "types.h"

void *memset(void *dst, int c, uint n)
{
    80200a7e:	1141                	addi	sp,sp,-16
    80200a80:	e422                	sd	s0,8(sp)
    80200a82:	0800                	addi	s0,sp,16
	char *cdst = (char *)dst;
	int i;
	for (i = 0; i < n; i++) {
    80200a84:	ca19                	beqz	a2,80200a9a <memset+0x1c>
    80200a86:	87aa                	mv	a5,a0
    80200a88:	1602                	slli	a2,a2,0x20
    80200a8a:	9201                	srli	a2,a2,0x20
    80200a8c:	00a60733          	add	a4,a2,a0
		cdst[i] = c;
    80200a90:	00b78023          	sb	a1,0(a5)
	for (i = 0; i < n; i++) {
    80200a94:	0785                	addi	a5,a5,1
    80200a96:	fee79de3          	bne	a5,a4,80200a90 <memset+0x12>
	}
	return dst;
}
    80200a9a:	6422                	ld	s0,8(sp)
    80200a9c:	0141                	addi	sp,sp,16
    80200a9e:	8082                	ret

0000000080200aa0 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
    80200aa0:	1141                	addi	sp,sp,-16
    80200aa2:	e422                	sd	s0,8(sp)
    80200aa4:	0800                	addi	s0,sp,16
	const uchar *s1, *s2;

	s1 = v1;
	s2 = v2;
	while (n-- > 0) {
    80200aa6:	ca05                	beqz	a2,80200ad6 <memcmp+0x36>
    80200aa8:	fff6069b          	addiw	a3,a2,-1
    80200aac:	1682                	slli	a3,a3,0x20
    80200aae:	9281                	srli	a3,a3,0x20
    80200ab0:	0685                	addi	a3,a3,1
    80200ab2:	96aa                	add	a3,a3,a0
		if (*s1 != *s2)
    80200ab4:	00054783          	lbu	a5,0(a0)
    80200ab8:	0005c703          	lbu	a4,0(a1)
    80200abc:	00e79863          	bne	a5,a4,80200acc <memcmp+0x2c>
			return *s1 - *s2;
		s1++, s2++;
    80200ac0:	0505                	addi	a0,a0,1
    80200ac2:	0585                	addi	a1,a1,1
	while (n-- > 0) {
    80200ac4:	fed518e3          	bne	a0,a3,80200ab4 <memcmp+0x14>
	}

	return 0;
    80200ac8:	4501                	li	a0,0
    80200aca:	a019                	j	80200ad0 <memcmp+0x30>
			return *s1 - *s2;
    80200acc:	40e7853b          	subw	a0,a5,a4
}
    80200ad0:	6422                	ld	s0,8(sp)
    80200ad2:	0141                	addi	sp,sp,16
    80200ad4:	8082                	ret
	return 0;
    80200ad6:	4501                	li	a0,0
    80200ad8:	bfe5                	j	80200ad0 <memcmp+0x30>

0000000080200ada <memmove>:

void *memmove(void *dst, const void *src, uint n)
{
    80200ada:	1141                	addi	sp,sp,-16
    80200adc:	e422                	sd	s0,8(sp)
    80200ade:	0800                	addi	s0,sp,16
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
    80200ae0:	02a5e563          	bltu	a1,a0,80200b0a <memmove+0x30>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
    80200ae4:	fff6069b          	addiw	a3,a2,-1
    80200ae8:	ce11                	beqz	a2,80200b04 <memmove+0x2a>
    80200aea:	1682                	slli	a3,a3,0x20
    80200aec:	9281                	srli	a3,a3,0x20
    80200aee:	0685                	addi	a3,a3,1
    80200af0:	96ae                	add	a3,a3,a1
    80200af2:	87aa                	mv	a5,a0
			*d++ = *s++;
    80200af4:	0585                	addi	a1,a1,1
    80200af6:	0785                	addi	a5,a5,1
    80200af8:	fff5c703          	lbu	a4,-1(a1)
    80200afc:	fee78fa3          	sb	a4,-1(a5)
		while (n-- > 0)
    80200b00:	fed59ae3          	bne	a1,a3,80200af4 <memmove+0x1a>

	return dst;
}
    80200b04:	6422                	ld	s0,8(sp)
    80200b06:	0141                	addi	sp,sp,16
    80200b08:	8082                	ret
	if (s < d && s + n > d) {
    80200b0a:	02061713          	slli	a4,a2,0x20
    80200b0e:	9301                	srli	a4,a4,0x20
    80200b10:	00e587b3          	add	a5,a1,a4
    80200b14:	fcf578e3          	bgeu	a0,a5,80200ae4 <memmove+0xa>
		d += n;
    80200b18:	972a                	add	a4,a4,a0
		while (n-- > 0)
    80200b1a:	fff6069b          	addiw	a3,a2,-1
    80200b1e:	d27d                	beqz	a2,80200b04 <memmove+0x2a>
    80200b20:	02069613          	slli	a2,a3,0x20
    80200b24:	9201                	srli	a2,a2,0x20
    80200b26:	fff64613          	not	a2,a2
    80200b2a:	963e                	add	a2,a2,a5
			*--d = *--s;
    80200b2c:	17fd                	addi	a5,a5,-1
    80200b2e:	177d                	addi	a4,a4,-1
    80200b30:	0007c683          	lbu	a3,0(a5)
    80200b34:	00d70023          	sb	a3,0(a4)
		while (n-- > 0)
    80200b38:	fef61ae3          	bne	a2,a5,80200b2c <memmove+0x52>
    80200b3c:	b7e1                	j	80200b04 <memmove+0x2a>

0000000080200b3e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n)
{
    80200b3e:	1141                	addi	sp,sp,-16
    80200b40:	e406                	sd	ra,8(sp)
    80200b42:	e022                	sd	s0,0(sp)
    80200b44:	0800                	addi	s0,sp,16
	return memmove(dst, src, n);
    80200b46:	00000097          	auipc	ra,0x0
    80200b4a:	f94080e7          	jalr	-108(ra) # 80200ada <memmove>
}
    80200b4e:	60a2                	ld	ra,8(sp)
    80200b50:	6402                	ld	s0,0(sp)
    80200b52:	0141                	addi	sp,sp,16
    80200b54:	8082                	ret

0000000080200b56 <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    80200b56:	1141                	addi	sp,sp,-16
    80200b58:	e422                	sd	s0,8(sp)
    80200b5a:	0800                	addi	s0,sp,16
	while (n > 0 && *p && *p == *q)
    80200b5c:	ce11                	beqz	a2,80200b78 <strncmp+0x22>
    80200b5e:	00054783          	lbu	a5,0(a0)
    80200b62:	cf89                	beqz	a5,80200b7c <strncmp+0x26>
    80200b64:	0005c703          	lbu	a4,0(a1)
    80200b68:	00f71a63          	bne	a4,a5,80200b7c <strncmp+0x26>
		n--, p++, q++;
    80200b6c:	367d                	addiw	a2,a2,-1
    80200b6e:	0505                	addi	a0,a0,1
    80200b70:	0585                	addi	a1,a1,1
	while (n > 0 && *p && *p == *q)
    80200b72:	f675                	bnez	a2,80200b5e <strncmp+0x8>
	if (n == 0)
		return 0;
    80200b74:	4501                	li	a0,0
    80200b76:	a809                	j	80200b88 <strncmp+0x32>
    80200b78:	4501                	li	a0,0
    80200b7a:	a039                	j	80200b88 <strncmp+0x32>
	if (n == 0)
    80200b7c:	ca09                	beqz	a2,80200b8e <strncmp+0x38>
	return (uchar)*p - (uchar)*q;
    80200b7e:	00054503          	lbu	a0,0(a0)
    80200b82:	0005c783          	lbu	a5,0(a1)
    80200b86:	9d1d                	subw	a0,a0,a5
}
    80200b88:	6422                	ld	s0,8(sp)
    80200b8a:	0141                	addi	sp,sp,16
    80200b8c:	8082                	ret
		return 0;
    80200b8e:	4501                	li	a0,0
    80200b90:	bfe5                	j	80200b88 <strncmp+0x32>

0000000080200b92 <strncpy>:

char *strncpy(char *s, const char *t, int n)
{
    80200b92:	1141                	addi	sp,sp,-16
    80200b94:	e422                	sd	s0,8(sp)
    80200b96:	0800                	addi	s0,sp,16
	char *os;

	os = s;
	while (n-- > 0 && (*s++ = *t++) != 0)
    80200b98:	872a                	mv	a4,a0
    80200b9a:	8832                	mv	a6,a2
    80200b9c:	367d                	addiw	a2,a2,-1
    80200b9e:	01005963          	blez	a6,80200bb0 <strncpy+0x1e>
    80200ba2:	0705                	addi	a4,a4,1
    80200ba4:	0005c783          	lbu	a5,0(a1)
    80200ba8:	fef70fa3          	sb	a5,-1(a4)
    80200bac:	0585                	addi	a1,a1,1
    80200bae:	f7f5                	bnez	a5,80200b9a <strncpy+0x8>
		;
	while (n-- > 0)
    80200bb0:	86ba                	mv	a3,a4
    80200bb2:	00c05c63          	blez	a2,80200bca <strncpy+0x38>
		*s++ = 0;
    80200bb6:	0685                	addi	a3,a3,1
    80200bb8:	fe068fa3          	sb	zero,-1(a3)
	while (n-- > 0)
    80200bbc:	fff6c793          	not	a5,a3
    80200bc0:	9fb9                	addw	a5,a5,a4
    80200bc2:	010787bb          	addw	a5,a5,a6
    80200bc6:	fef048e3          	bgtz	a5,80200bb6 <strncpy+0x24>
	return os;
}
    80200bca:	6422                	ld	s0,8(sp)
    80200bcc:	0141                	addi	sp,sp,16
    80200bce:	8082                	ret

0000000080200bd0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n)
{
    80200bd0:	1141                	addi	sp,sp,-16
    80200bd2:	e422                	sd	s0,8(sp)
    80200bd4:	0800                	addi	s0,sp,16
	char *os;

	os = s;
	if (n <= 0)
    80200bd6:	02c05363          	blez	a2,80200bfc <safestrcpy+0x2c>
    80200bda:	fff6069b          	addiw	a3,a2,-1
    80200bde:	1682                	slli	a3,a3,0x20
    80200be0:	9281                	srli	a3,a3,0x20
    80200be2:	96ae                	add	a3,a3,a1
    80200be4:	87aa                	mv	a5,a0
		return os;
	while (--n > 0 && (*s++ = *t++) != 0)
    80200be6:	00d58963          	beq	a1,a3,80200bf8 <safestrcpy+0x28>
    80200bea:	0585                	addi	a1,a1,1
    80200bec:	0785                	addi	a5,a5,1
    80200bee:	fff5c703          	lbu	a4,-1(a1)
    80200bf2:	fee78fa3          	sb	a4,-1(a5)
    80200bf6:	fb65                	bnez	a4,80200be6 <safestrcpy+0x16>
		;
	*s = 0;
    80200bf8:	00078023          	sb	zero,0(a5)
	return os;
}
    80200bfc:	6422                	ld	s0,8(sp)
    80200bfe:	0141                	addi	sp,sp,16
    80200c00:	8082                	ret

0000000080200c02 <strlen>:

int strlen(const char *s)
{
    80200c02:	1141                	addi	sp,sp,-16
    80200c04:	e422                	sd	s0,8(sp)
    80200c06:	0800                	addi	s0,sp,16
	int n;

	for (n = 0; s[n]; n++)
    80200c08:	00054783          	lbu	a5,0(a0)
    80200c0c:	cf91                	beqz	a5,80200c28 <strlen+0x26>
    80200c0e:	0505                	addi	a0,a0,1
    80200c10:	87aa                	mv	a5,a0
    80200c12:	4685                	li	a3,1
    80200c14:	9e89                	subw	a3,a3,a0
    80200c16:	00f6853b          	addw	a0,a3,a5
    80200c1a:	0785                	addi	a5,a5,1
    80200c1c:	fff7c703          	lbu	a4,-1(a5)
    80200c20:	fb7d                	bnez	a4,80200c16 <strlen+0x14>
		;
	return n;
}
    80200c22:	6422                	ld	s0,8(sp)
    80200c24:	0141                	addi	sp,sp,16
    80200c26:	8082                	ret
	for (n = 0; s[n]; n++)
    80200c28:	4501                	li	a0,0
    80200c2a:	bfe5                	j	80200c22 <strlen+0x20>

0000000080200c2c <dummy>:

void dummy(int _, ...)
{
    80200c2c:	715d                	addi	sp,sp,-80
    80200c2e:	e422                	sd	s0,8(sp)
    80200c30:	0800                	addi	s0,sp,16
    80200c32:	e40c                	sd	a1,8(s0)
    80200c34:	e810                	sd	a2,16(s0)
    80200c36:	ec14                	sd	a3,24(s0)
    80200c38:	f018                	sd	a4,32(s0)
    80200c3a:	f41c                	sd	a5,40(s0)
    80200c3c:	03043823          	sd	a6,48(s0)
    80200c40:	03143c23          	sd	a7,56(s0)
    80200c44:	6422                	ld	s0,8(sp)
    80200c46:	6161                	addi	sp,sp,80
    80200c48:	8082                	ret

0000000080200c4a <sys_write>:
#include "timer.h"
#include "trap.h"
#include "vm.h"

uint64 sys_write(int fd, uint64 va, uint len)
{
    80200c4a:	7111                	addi	sp,sp,-256
    80200c4c:	fd86                	sd	ra,248(sp)
    80200c4e:	f9a2                	sd	s0,240(sp)
    80200c50:	f5a6                	sd	s1,232(sp)
    80200c52:	f1ca                	sd	s2,224(sp)
    80200c54:	edce                	sd	s3,216(sp)
    80200c56:	0200                	addi	s0,sp,256
    80200c58:	84aa                	mv	s1,a0
    80200c5a:	89ae                	mv	s3,a1
    80200c5c:	8932                	mv	s2,a2
	debugf("sys_write fd = %d va = %x, len = %d", fd, va, len);
    80200c5e:	86b2                	mv	a3,a2
    80200c60:	862e                	mv	a2,a1
    80200c62:	85aa                	mv	a1,a0
    80200c64:	4501                	li	a0,0
    80200c66:	00000097          	auipc	ra,0x0
    80200c6a:	fc6080e7          	jalr	-58(ra) # 80200c2c <dummy>
	if (fd != STDOUT)
    80200c6e:	4785                	li	a5,1
		return -1;
    80200c70:	557d                	li	a0,-1
	if (fd != STDOUT)
    80200c72:	00f48963          	beq	s1,a5,80200c84 <sys_write+0x3a>
	debugf("size = %d", size);
	for (int i = 0; i < size; ++i) {
		console_putchar(str[i]);
	}
	return size;
}
    80200c76:	70ee                	ld	ra,248(sp)
    80200c78:	744e                	ld	s0,240(sp)
    80200c7a:	74ae                	ld	s1,232(sp)
    80200c7c:	790e                	ld	s2,224(sp)
    80200c7e:	69ee                	ld	s3,216(sp)
    80200c80:	6111                	addi	sp,sp,256
    80200c82:	8082                	ret
	struct proc *p = curr_proc();
    80200c84:	00000097          	auipc	ra,0x0
    80200c88:	abc080e7          	jalr	-1348(ra) # 80200740 <curr_proc>
	int size = copyinstr(p->pagetable, str, va, MIN(len, MAX_STR_LEN));
    80200c8c:	86ca                	mv	a3,s2
    80200c8e:	0c800793          	li	a5,200
    80200c92:	0127f463          	bgeu	a5,s2,80200c9a <sys_write+0x50>
    80200c96:	0c800693          	li	a3,200
    80200c9a:	1682                	slli	a3,a3,0x20
    80200c9c:	9281                	srli	a3,a3,0x20
    80200c9e:	864e                	mv	a2,s3
    80200ca0:	f0840593          	addi	a1,s0,-248
    80200ca4:	6948                	ld	a0,144(a0)
    80200ca6:	00001097          	auipc	ra,0x1
    80200caa:	ee2080e7          	jalr	-286(ra) # 80201b88 <copyinstr>
    80200cae:	892a                	mv	s2,a0
	debugf("size = %d", size);
    80200cb0:	85aa                	mv	a1,a0
    80200cb2:	4501                	li	a0,0
    80200cb4:	00000097          	auipc	ra,0x0
    80200cb8:	f78080e7          	jalr	-136(ra) # 80200c2c <dummy>
	for (int i = 0; i < size; ++i) {
    80200cbc:	03205563          	blez	s2,80200ce6 <sys_write+0x9c>
    80200cc0:	f0840493          	addi	s1,s0,-248
    80200cc4:	fff9099b          	addiw	s3,s2,-1
    80200cc8:	1982                	slli	s3,s3,0x20
    80200cca:	0209d993          	srli	s3,s3,0x20
    80200cce:	f0940793          	addi	a5,s0,-247
    80200cd2:	99be                	add	s3,s3,a5
		console_putchar(str[i]);
    80200cd4:	0004c503          	lbu	a0,0(s1)
    80200cd8:	00000097          	auipc	ra,0x0
    80200cdc:	d48080e7          	jalr	-696(ra) # 80200a20 <console_putchar>
	for (int i = 0; i < size; ++i) {
    80200ce0:	0485                	addi	s1,s1,1
    80200ce2:	ff3499e3          	bne	s1,s3,80200cd4 <sys_write+0x8a>
	return size;
    80200ce6:	854a                	mv	a0,s2
    80200ce8:	b779                	j	80200c76 <sys_write+0x2c>

0000000080200cea <sys_exit>:

__attribute__((noreturn)) void sys_exit(int code)
{
    80200cea:	1141                	addi	sp,sp,-16
    80200cec:	e406                	sd	ra,8(sp)
    80200cee:	e022                	sd	s0,0(sp)
    80200cf0:	0800                	addi	s0,sp,16
	exit(code);
    80200cf2:	00000097          	auipc	ra,0x0
    80200cf6:	cf0080e7          	jalr	-784(ra) # 802009e2 <exit>

0000000080200cfa <sys_sched_yield>:
	__builtin_unreachable();
}

uint64 sys_sched_yield()
{
    80200cfa:	1141                	addi	sp,sp,-16
    80200cfc:	e406                	sd	ra,8(sp)
    80200cfe:	e022                	sd	s0,0(sp)
    80200d00:	0800                	addi	s0,sp,16
	yield();
    80200d02:	00000097          	auipc	ra,0x0
    80200d06:	cac080e7          	jalr	-852(ra) # 802009ae <yield>
	return 0;
}
    80200d0a:	4501                	li	a0,0
    80200d0c:	60a2                	ld	ra,8(sp)
    80200d0e:	6402                	ld	s0,0(sp)
    80200d10:	0141                	addi	sp,sp,16
    80200d12:	8082                	ret

0000000080200d14 <sys_gettimeofday>:

uint64 sys_gettimeofday(TimeVal *val, int _tz) // TODO: implement sys_gettimeofday in pagetable. (VA to PA)
{
    80200d14:	1101                	addi	sp,sp,-32
    80200d16:	ec06                	sd	ra,24(sp)
    80200d18:	e822                	sd	s0,16(sp)
    80200d1a:	e426                	sd	s1,8(sp)
    80200d1c:	1000                	addi	s0,sp,32
    80200d1e:	84aa                	mv	s1,a0
	// YOUR CODE
	val->sec = 0;
    80200d20:	00053023          	sd	zero,0(a0)
	val->usec = 0;
    80200d24:	00053423          	sd	zero,8(a0)

	/* The code in `ch3` will leads to memory bugs*/

	pagetable_t current_proc = curr_proc()->pagetable;
    80200d28:	00000097          	auipc	ra,0x0
    80200d2c:	a18080e7          	jalr	-1512(ra) # 80200740 <curr_proc>

	TimeVal * physical_val = (TimeVal *)useraddr(current_proc, (uint64)val);
    80200d30:	85a6                	mv	a1,s1
    80200d32:	6948                	ld	a0,144(a0)
    80200d34:	00001097          	auipc	ra,0x1
    80200d38:	8bc080e7          	jalr	-1860(ra) # 802015f0 <useraddr>
    80200d3c:	84aa                	mv	s1,a0


	uint64 cycle = get_cycle();
    80200d3e:	00000097          	auipc	ra,0x0
    80200d42:	3de080e7          	jalr	990(ra) # 8020111c <get_cycle>
	physical_val->sec = cycle / CPU_FREQ;
    80200d46:	00bec7b7          	lui	a5,0xbec
    80200d4a:	c2078713          	addi	a4,a5,-992 # bebc20 <_entry-0x7f6143e0>
    80200d4e:	02e557b3          	divu	a5,a0,a4
    80200d52:	e09c                	sd	a5,0(s1)
	physical_val->usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;
    80200d54:	02e577b3          	remu	a5,a0,a4
    80200d58:	000f4537          	lui	a0,0xf4
    80200d5c:	24050513          	addi	a0,a0,576 # f4240 <_entry-0x8010bdc0>
    80200d60:	02a787b3          	mul	a5,a5,a0
    80200d64:	02e7d7b3          	divu	a5,a5,a4
    80200d68:	e49c                	sd	a5,8(s1)
	return 0;
}
    80200d6a:	4501                	li	a0,0
    80200d6c:	60e2                	ld	ra,24(sp)
    80200d6e:	6442                	ld	s0,16(sp)
    80200d70:	64a2                	ld	s1,8(sp)
    80200d72:	6105                	addi	sp,sp,32
    80200d74:	8082                	ret

0000000080200d76 <sys_mmap>:
// TODO: add support for mmap and munmap syscall.
// hint: read through docstrings in vm.c. Watching CH4 video may also help.
// Note the return value and PTE flags (especially U,X,W,R)

uint64 sys_mmap(uint64 start, uint64 len, int port, int flag, int fd)
{
    80200d76:	715d                	addi	sp,sp,-80
    80200d78:	e486                	sd	ra,72(sp)
    80200d7a:	e0a2                	sd	s0,64(sp)
    80200d7c:	fc26                	sd	s1,56(sp)
    80200d7e:	f84a                	sd	s2,48(sp)
    80200d80:	f44e                	sd	s3,40(sp)
    80200d82:	f052                	sd	s4,32(sp)
    80200d84:	ec56                	sd	s5,24(sp)
    80200d86:	e85a                	sd	s6,16(sp)
    80200d88:	e45e                	sd	s7,8(sp)
    80200d8a:	0880                	addi	s0,sp,80
    80200d8c:	892a                	mv	s2,a0
    80200d8e:	8a2e                	mv	s4,a1
    80200d90:	8b32                	mv	s6,a2
	struct proc *p = curr_proc();
    80200d92:	00000097          	auipc	ra,0x0
    80200d96:	9ae080e7          	jalr	-1618(ra) # 80200740 <curr_proc>
	
	// 1. Validate parameters
	
	// Check if start is page-aligned
	if (start % PGSIZE != 0) {
    80200d9a:	03491793          	slli	a5,s2,0x34
		return -1;
    80200d9e:	5afd                	li	s5,-1
	if (start % PGSIZE != 0) {
    80200da0:	efdd                	bnez	a5,80200e5e <sys_mmap+0xe8>
    80200da2:	89aa                	mv	s3,a0
    80200da4:	0347da93          	srli	s5,a5,0x34
	}
	
	// If len is 0, return immediately
	if (len == 0) {
    80200da8:	0a0a0a63          	beqz	s4,80200e5c <sys_mmap+0xe6>
		return 0;
	}
	
	// Check if len is too big (upper limit 1GiB)
	if (len > (1ULL << 30)) {
    80200dac:	400007b7          	lui	a5,0x40000
    80200db0:	0d47e363          	bltu	a5,s4,80200e76 <sys_mmap+0x100>
		return -1;
	}
	
	// Check if port has invalid bits set (other bits must be 0)
	if ((port & ~0x7) != 0) {
    80200db4:	ff8b7793          	andi	a5,s6,-8
    80200db8:	e3e9                	bnez	a5,80200e7a <sys_mmap+0x104>
		return -1;
	}
	
	// Check if port has no permissions (meaningless)
	if ((port & 0x7) == 0) {
    80200dba:	007b7793          	andi	a5,s6,7
    80200dbe:	c3e1                	beqz	a5,80200e7e <sys_mmap+0x108>
		return -1;
	}
	
	// 2. Round len up to page boundary
	uint64 npages = (len + PGSIZE - 1) / PGSIZE;
    80200dc0:	6585                	lui	a1,0x1
    80200dc2:	15fd                	addi	a1,a1,-1
    80200dc4:	9a2e                	add	s4,s4,a1
    80200dc6:	77fd                	lui	a5,0xfffff
    80200dc8:	00fa7a33          	and	s4,s4,a5
    80200dcc:	9a4a                	add	s4,s4,s2
    80200dce:	84ca                	mv	s1,s2
	
	// 3. Check if any page in [start, start+len) is already mapped
	for (uint64 i = 0; i < npages; i++) {
    80200dd0:	6b85                	lui	s7,0x1
    80200dd2:	a021                	j	80200dda <sys_mmap+0x64>
    80200dd4:	94de                	add	s1,s1,s7
    80200dd6:	029a0063          	beq	s4,s1,80200df6 <sys_mmap+0x80>
		uint64 va = start + i * PGSIZE;
		pte_t *pte = walk(p->pagetable, va, 0);
    80200dda:	4601                	li	a2,0
    80200ddc:	85a6                	mv	a1,s1
    80200dde:	0909b503          	ld	a0,144(s3)
    80200de2:	00000097          	auipc	ra,0x0
    80200de6:	6fa080e7          	jalr	1786(ra) # 802014dc <walk>
		
		// If page table entry exists and is valid, page is already mapped
		if (pte != 0 && (*pte & PTE_V)) {
    80200dea:	d56d                	beqz	a0,80200dd4 <sys_mmap+0x5e>
    80200dec:	611c                	ld	a5,0(a0)
    80200dee:	8b85                	andi	a5,a5,1
    80200df0:	d3f5                	beqz	a5,80200dd4 <sys_mmap+0x5e>
			return -1;
    80200df2:	5afd                	li	s5,-1
    80200df4:	a0ad                	j	80200e5e <sys_mmap+0xe8>
	// port bit 0 = readable -> PTE_R (bit 1)
	// port bit 1 = writable -> PTE_W (bit 2)
	// port bit 2 = executable -> PTE_X (bit 3)
	// Also need PTE_U (bit 4) for user access and PTE_V (bit 0) for valid
	int perm = PTE_U | PTE_V;
	if (port & 0x1) perm |= PTE_R;
    80200df6:	001b7793          	andi	a5,s6,1
	int perm = PTE_U | PTE_V;
    80200dfa:	4bc5                	li	s7,17
	if (port & 0x1) perm |= PTE_R;
    80200dfc:	c391                	beqz	a5,80200e00 <sys_mmap+0x8a>
    80200dfe:	4bcd                	li	s7,19
	if (port & 0x2) perm |= PTE_W;
    80200e00:	002b7793          	andi	a5,s6,2
    80200e04:	c399                	beqz	a5,80200e0a <sys_mmap+0x94>
    80200e06:	004beb93          	ori	s7,s7,4
	if (port & 0x4) perm |= PTE_X;
    80200e0a:	004b7b13          	andi	s6,s6,4
    80200e0e:	000b0463          	beqz	s6,80200e16 <sys_mmap+0xa0>
    80200e12:	008beb93          	ori	s7,s7,8
	// 5. Allocate physical pages and map them one by one
	for (uint64 i = 0; i < npages; i++) {
		uint64 va = start + i * PGSIZE;
		
		// Allocate physical page
		void *pa = kalloc();
    80200e16:	fffff097          	auipc	ra,0xfffff
    80200e1a:	30c080e7          	jalr	780(ra) # 80200122 <kalloc>
    80200e1e:	84aa                	mv	s1,a0
		if (pa == 0) {
    80200e20:	c12d                	beqz	a0,80200e82 <sys_mmap+0x10c>
			// "For simplicity, page recovery in case of allocation failure is not considered"
			return -1;
		}
		
		// Clear the allocated page
		memset(pa, 0, PGSIZE);
    80200e22:	6605                	lui	a2,0x1
    80200e24:	4581                	li	a1,0
    80200e26:	00000097          	auipc	ra,0x0
    80200e2a:	c58080e7          	jalr	-936(ra) # 80200a7e <memset>
		
		// Map the page
		if (mappages(p->pagetable, va, PGSIZE, (uint64)pa, perm) != 0) {
    80200e2e:	875e                	mv	a4,s7
    80200e30:	86a6                	mv	a3,s1
    80200e32:	6605                	lui	a2,0x1
    80200e34:	85ca                	mv	a1,s2
    80200e36:	0909b503          	ld	a0,144(s3)
    80200e3a:	00000097          	auipc	ra,0x0
    80200e3e:	7de080e7          	jalr	2014(ra) # 80201618 <mappages>
    80200e42:	e511                	bnez	a0,80200e4e <sys_mmap+0xd8>
	for (uint64 i = 0; i < npages; i++) {
    80200e44:	6785                	lui	a5,0x1
    80200e46:	993e                	add	s2,s2,a5
    80200e48:	fd4917e3          	bne	s2,s4,80200e16 <sys_mmap+0xa0>
    80200e4c:	a809                	j	80200e5e <sys_mmap+0xe8>
			kfree(pa);
    80200e4e:	8526                	mv	a0,s1
    80200e50:	fffff097          	auipc	ra,0xfffff
    80200e54:	1e0080e7          	jalr	480(ra) # 80200030 <kfree>
			return -1;
    80200e58:	5afd                	li	s5,-1
    80200e5a:	a011                	j	80200e5e <sys_mmap+0xe8>
		return 0;
    80200e5c:	8ad2                	mv	s5,s4
		}
	}
	
	return 0;
}
    80200e5e:	8556                	mv	a0,s5
    80200e60:	60a6                	ld	ra,72(sp)
    80200e62:	6406                	ld	s0,64(sp)
    80200e64:	74e2                	ld	s1,56(sp)
    80200e66:	7942                	ld	s2,48(sp)
    80200e68:	79a2                	ld	s3,40(sp)
    80200e6a:	7a02                	ld	s4,32(sp)
    80200e6c:	6ae2                	ld	s5,24(sp)
    80200e6e:	6b42                	ld	s6,16(sp)
    80200e70:	6ba2                	ld	s7,8(sp)
    80200e72:	6161                	addi	sp,sp,80
    80200e74:	8082                	ret
		return -1;
    80200e76:	5afd                	li	s5,-1
    80200e78:	b7dd                	j	80200e5e <sys_mmap+0xe8>
		return -1;
    80200e7a:	5afd                	li	s5,-1
    80200e7c:	b7cd                	j	80200e5e <sys_mmap+0xe8>
		return -1;
    80200e7e:	5afd                	li	s5,-1
    80200e80:	bff9                	j	80200e5e <sys_mmap+0xe8>
			return -1;
    80200e82:	5afd                	li	s5,-1
    80200e84:	bfe9                	j	80200e5e <sys_mmap+0xe8>

0000000080200e86 <sys_munmap>:

uint64 sys_munmap(uint64 start, uint64 len)
{
    80200e86:	715d                	addi	sp,sp,-80
    80200e88:	e486                	sd	ra,72(sp)
    80200e8a:	e0a2                	sd	s0,64(sp)
    80200e8c:	fc26                	sd	s1,56(sp)
    80200e8e:	f84a                	sd	s2,48(sp)
    80200e90:	f44e                	sd	s3,40(sp)
    80200e92:	f052                	sd	s4,32(sp)
    80200e94:	ec56                	sd	s5,24(sp)
    80200e96:	e85a                	sd	s6,16(sp)
    80200e98:	e45e                	sd	s7,8(sp)
    80200e9a:	0880                	addi	s0,sp,80
    80200e9c:	8a2a                	mv	s4,a0
    80200e9e:	84ae                	mv	s1,a1
	struct proc *p = curr_proc();
    80200ea0:	00000097          	auipc	ra,0x0
    80200ea4:	8a0080e7          	jalr	-1888(ra) # 80200740 <curr_proc>
	
	// 1. Validate that start is page-aligned
	if (start % PGSIZE != 0) {
    80200ea8:	034a1793          	slli	a5,s4,0x34
		return -1;
    80200eac:	5afd                	li	s5,-1
	if (start % PGSIZE != 0) {
    80200eae:	ebb9                	bnez	a5,80200f04 <sys_munmap+0x7e>
    80200eb0:	89aa                	mv	s3,a0
    80200eb2:	0347da93          	srli	s5,a5,0x34
	}
	
	// If len is 0, nothing to do
	if (len == 0) {
    80200eb6:	c4b1                	beqz	s1,80200f02 <sys_munmap+0x7c>
		return 0;
	}
	
	// 2. Calculate number of pages
	uint64 npages = (len + PGSIZE - 1) / PGSIZE;
    80200eb8:	6785                	lui	a5,0x1
    80200eba:	fff78593          	addi	a1,a5,-1 # fff <_entry-0x801ff001>
    80200ebe:	94ae                	add	s1,s1,a1
    80200ec0:	00c4db13          	srli	s6,s1,0xc
	
	// 3. Check if all pages in [start, start+len) are mapped
	for (uint64 i = 0; i < npages; i++) {
    80200ec4:	02f4e563          	bltu	s1,a5,80200eee <sys_munmap+0x68>
    80200ec8:	84d2                	mv	s1,s4
    80200eca:	8956                	mv	s2,s5
    80200ecc:	6b85                	lui	s7,0x1
		uint64 va = start + i * PGSIZE;
		pte_t *pte = walk(p->pagetable, va, 0);
    80200ece:	4601                	li	a2,0
    80200ed0:	85a6                	mv	a1,s1
    80200ed2:	0909b503          	ld	a0,144(s3)
    80200ed6:	00000097          	auipc	ra,0x0
    80200eda:	606080e7          	jalr	1542(ra) # 802014dc <walk>
		
		// If page table entry doesn't exist or is not valid, return error
		if (pte == 0 || (*pte & PTE_V) == 0) {
    80200ede:	cd1d                	beqz	a0,80200f1c <sys_munmap+0x96>
    80200ee0:	611c                	ld	a5,0(a0)
    80200ee2:	8b85                	andi	a5,a5,1
    80200ee4:	cf95                	beqz	a5,80200f20 <sys_munmap+0x9a>
	for (uint64 i = 0; i < npages; i++) {
    80200ee6:	0905                	addi	s2,s2,1
    80200ee8:	94de                	add	s1,s1,s7
    80200eea:	ff6962e3          	bltu	s2,s6,80200ece <sys_munmap+0x48>
		}
	}
	
	// 4. Unmap the pages and free physical memory
	// Since we've verified all pages exist above, this should succeed
	uvmunmap(p->pagetable, start, npages, 1);
    80200eee:	4685                	li	a3,1
    80200ef0:	865a                	mv	a2,s6
    80200ef2:	85d2                	mv	a1,s4
    80200ef4:	0909b503          	ld	a0,144(s3)
    80200ef8:	00001097          	auipc	ra,0x1
    80200efc:	8e8080e7          	jalr	-1816(ra) # 802017e0 <uvmunmap>
	
	return 0;
    80200f00:	a011                	j	80200f04 <sys_munmap+0x7e>
		return 0;
    80200f02:	8aa6                	mv	s5,s1
}
    80200f04:	8556                	mv	a0,s5
    80200f06:	60a6                	ld	ra,72(sp)
    80200f08:	6406                	ld	s0,64(sp)
    80200f0a:	74e2                	ld	s1,56(sp)
    80200f0c:	7942                	ld	s2,48(sp)
    80200f0e:	79a2                	ld	s3,40(sp)
    80200f10:	7a02                	ld	s4,32(sp)
    80200f12:	6ae2                	ld	s5,24(sp)
    80200f14:	6b42                	ld	s6,16(sp)
    80200f16:	6ba2                	ld	s7,8(sp)
    80200f18:	6161                	addi	sp,sp,80
    80200f1a:	8082                	ret
			return -1;
    80200f1c:	5afd                	li	s5,-1
    80200f1e:	b7dd                	j	80200f04 <sys_munmap+0x7e>
    80200f20:	5afd                	li	s5,-1
    80200f22:	b7cd                	j	80200f04 <sys_munmap+0x7e>

0000000080200f24 <sys_task_info>:

/*
* LAB1: you may need to define sys_task_info here
*/

uint64 sys_task_info(struct TaskInfo *info) {
    80200f24:	1101                	addi	sp,sp,-32
    80200f26:	ec06                	sd	ra,24(sp)
    80200f28:	e822                	sd	s0,16(sp)
    80200f2a:	e426                	sd	s1,8(sp)
    80200f2c:	e04a                	sd	s2,0(sp)
    80200f2e:	1000                	addi	s0,sp,32
    80200f30:	892a                	mv	s2,a0
	struct proc * p = curr_proc();
    80200f32:	00000097          	auipc	ra,0x0
    80200f36:	80e080e7          	jalr	-2034(ra) # 80200740 <curr_proc>
    80200f3a:	84aa                	mv	s1,a0
	struct TaskInfo *physical_info = (struct TaskInfo *)useraddr(p->pagetable, (uint64)info);
    80200f3c:	85ca                	mv	a1,s2
    80200f3e:	6948                	ld	a0,144(a0)
    80200f40:	00000097          	auipc	ra,0x0
    80200f44:	6b0080e7          	jalr	1712(ra) # 802015f0 <useraddr>
    80200f48:	892a                	mv	s2,a0
	physical_info->status = Running;
    80200f4a:	4789                	li	a5,2
    80200f4c:	c11c                	sw	a5,0(a0)
	for (int i = 0; i < MAX_SYSCALL_NUM; i++) {
    80200f4e:	0a048793          	addi	a5,s1,160
    80200f52:	00450713          	addi	a4,a0,4
    80200f56:	6605                	lui	a2,0x1
    80200f58:	87060613          	addi	a2,a2,-1936 # 870 <_entry-0x801ff790>
    80200f5c:	9626                	add	a2,a2,s1
		physical_info->syscall_times[i] = p->syscall_times[i];
    80200f5e:	4394                	lw	a3,0(a5)
    80200f60:	c314                	sw	a3,0(a4)
	for (int i = 0; i < MAX_SYSCALL_NUM; i++) {
    80200f62:	0791                	addi	a5,a5,4
    80200f64:	0711                	addi	a4,a4,4
    80200f66:	fec79ce3          	bne	a5,a2,80200f5e <sys_task_info+0x3a>
	}
	uint64 cycle = get_cycle();
    80200f6a:	00000097          	auipc	ra,0x0
    80200f6e:	1b2080e7          	jalr	434(ra) # 8020111c <get_cycle>
	uint64 running_time = cycle - p->time;
    80200f72:	6785                	lui	a5,0x1
    80200f74:	94be                	add	s1,s1,a5
    80200f76:	8704a783          	lw	a5,-1936(s1)
    80200f7a:	40f507b3          	sub	a5,a0,a5
	physical_info->time = (running_time * 1000) / CPU_FREQ; // ms
    80200f7e:	3e800713          	li	a4,1000
    80200f82:	02e787b3          	mul	a5,a5,a4
    80200f86:	00bec737          	lui	a4,0xbec
    80200f8a:	c2070713          	addi	a4,a4,-992 # bebc20 <_entry-0x7f6143e0>
    80200f8e:	02e7d7b3          	divu	a5,a5,a4
    80200f92:	7cf92a23          	sw	a5,2004(s2)
	return 0;
}
    80200f96:	4501                	li	a0,0
    80200f98:	60e2                	ld	ra,24(sp)
    80200f9a:	6442                	ld	s0,16(sp)
    80200f9c:	64a2                	ld	s1,8(sp)
    80200f9e:	6902                	ld	s2,0(sp)
    80200fa0:	6105                	addi	sp,sp,32
    80200fa2:	8082                	ret

0000000080200fa4 <syscall>:

extern char trap_page[];

void syscall()
{
    80200fa4:	715d                	addi	sp,sp,-80
    80200fa6:	e486                	sd	ra,72(sp)
    80200fa8:	e0a2                	sd	s0,64(sp)
    80200faa:	fc26                	sd	s1,56(sp)
    80200fac:	f84a                	sd	s2,48(sp)
    80200fae:	f44e                	sd	s3,40(sp)
    80200fb0:	f052                	sd	s4,32(sp)
    80200fb2:	ec56                	sd	s5,24(sp)
    80200fb4:	e85a                	sd	s6,16(sp)
    80200fb6:	e45e                	sd	s7,8(sp)
    80200fb8:	0880                	addi	s0,sp,80
	struct trapframe *trapframe = curr_proc()->trapframe;
    80200fba:	fffff097          	auipc	ra,0xfffff
    80200fbe:	786080e7          	jalr	1926(ra) # 80200740 <curr_proc>
    80200fc2:	01853903          	ld	s2,24(a0)
	int id = trapframe->a7, ret;
    80200fc6:	0a892483          	lw	s1,168(s2)
	uint64 args[6] = { trapframe->a0, trapframe->a1, trapframe->a2,
    80200fca:	07093983          	ld	s3,112(s2)
    80200fce:	07893a03          	ld	s4,120(s2)
    80200fd2:	08093a83          	ld	s5,128(s2)
			   trapframe->a3, trapframe->a4, trapframe->a5 };
    80200fd6:	08893b03          	ld	s6,136(s2)
    80200fda:	09093b83          	ld	s7,144(s2)
	tracef("syscall %d args = [%x, %x, %x, %x, %x, %x]", id, args[0],
    80200fde:	09893883          	ld	a7,152(s2)
    80200fe2:	885e                	mv	a6,s7
    80200fe4:	87da                	mv	a5,s6
    80200fe6:	8756                	mv	a4,s5
    80200fe8:	86d2                	mv	a3,s4
    80200fea:	864e                	mv	a2,s3
    80200fec:	85a6                	mv	a1,s1
    80200fee:	4501                	li	a0,0
    80200ff0:	00000097          	auipc	ra,0x0
    80200ff4:	c3c080e7          	jalr	-964(ra) # 80200c2c <dummy>
	       args[1], args[2], args[3], args[4], args[5]);
	/*
	* LAB1: you may need to update syscall counter for task info here
	*/
	curr_proc()->syscall_times[id]++;
    80200ff8:	fffff097          	auipc	ra,0xfffff
    80200ffc:	748080e7          	jalr	1864(ra) # 80200740 <curr_proc>
    80201000:	00249793          	slli	a5,s1,0x2
    80201004:	953e                	add	a0,a0,a5
    80201006:	0a052783          	lw	a5,160(a0)
    8020100a:	2785                	addiw	a5,a5,1
    8020100c:	0af52023          	sw	a5,160(a0)
	switch (id) {
    80201010:	0a900793          	li	a5,169
    80201014:	0cf48b63          	beq	s1,a5,802010ea <syscall+0x146>
    80201018:	0297d263          	bge	a5,s1,8020103c <syscall+0x98>
    8020101c:	0de00793          	li	a5,222
    80201020:	0cf48f63          	beq	s1,a5,802010fe <syscall+0x15a>
    80201024:	19a00793          	li	a5,410
    80201028:	04f49b63          	bne	s1,a5,8020107e <syscall+0xda>
		break;
	/*
	* LAB1: you may need to add SYS_taskinfo case here
	*/
	case SYS_task_info:
		ret = sys_task_info((struct TaskInfo *)args[0]);
    8020102c:	854e                	mv	a0,s3
    8020102e:	00000097          	auipc	ra,0x0
    80201032:	ef6080e7          	jalr	-266(ra) # 80200f24 <sys_task_info>
    80201036:	0005059b          	sext.w	a1,a0
		break;
    8020103a:	a895                	j	802010ae <syscall+0x10a>
	switch (id) {
    8020103c:	05d00793          	li	a5,93
    80201040:	08f48963          	beq	s1,a5,802010d2 <syscall+0x12e>
    80201044:	07c00793          	li	a5,124
    80201048:	08f48b63          	beq	s1,a5,802010de <syscall+0x13a>
    8020104c:	04000793          	li	a5,64
    80201050:	04f48463          	beq	s1,a5,80201098 <syscall+0xf4>
	case SYS_munmap:
		ret = sys_munmap(args[0], args[1]);
		break;
	default:
		ret = -1;
		errorf("unknown syscall %d", id);
    80201054:	fffff097          	auipc	ra,0xfffff
    80201058:	6d6080e7          	jalr	1750(ra) # 8020072a <threadid>
    8020105c:	86aa                	mv	a3,a0
    8020105e:	8726                	mv	a4,s1
    80201060:	00002617          	auipc	a2,0x2
    80201064:	11860613          	addi	a2,a2,280 # 80203178 <digits+0x50>
    80201068:	45fd                	li	a1,31
    8020106a:	00002517          	auipc	a0,0x2
    8020106e:	11650513          	addi	a0,a0,278 # 80203180 <digits+0x58>
    80201072:	fffff097          	auipc	ra,0xfffff
    80201076:	4e2080e7          	jalr	1250(ra) # 80200554 <printf>
		ret = -1;
    8020107a:	55fd                	li	a1,-1
    8020107c:	a80d                	j	802010ae <syscall+0x10a>
	switch (id) {
    8020107e:	0d700793          	li	a5,215
    80201082:	fcf499e3          	bne	s1,a5,80201054 <syscall+0xb0>
		ret = sys_munmap(args[0], args[1]);
    80201086:	85d2                	mv	a1,s4
    80201088:	854e                	mv	a0,s3
    8020108a:	00000097          	auipc	ra,0x0
    8020108e:	dfc080e7          	jalr	-516(ra) # 80200e86 <sys_munmap>
    80201092:	0005059b          	sext.w	a1,a0
		break;
    80201096:	a821                	j	802010ae <syscall+0x10a>
		ret = sys_write(args[0], args[1], args[2]);
    80201098:	000a861b          	sext.w	a2,s5
    8020109c:	85d2                	mv	a1,s4
    8020109e:	0009851b          	sext.w	a0,s3
    802010a2:	00000097          	auipc	ra,0x0
    802010a6:	ba8080e7          	jalr	-1112(ra) # 80200c4a <sys_write>
    802010aa:	0005059b          	sext.w	a1,a0
	}
	trapframe->a0 = ret;
    802010ae:	06b93823          	sd	a1,112(s2)
	tracef("syscall ret %d", ret);
    802010b2:	4501                	li	a0,0
    802010b4:	00000097          	auipc	ra,0x0
    802010b8:	b78080e7          	jalr	-1160(ra) # 80200c2c <dummy>
    802010bc:	60a6                	ld	ra,72(sp)
    802010be:	6406                	ld	s0,64(sp)
    802010c0:	74e2                	ld	s1,56(sp)
    802010c2:	7942                	ld	s2,48(sp)
    802010c4:	79a2                	ld	s3,40(sp)
    802010c6:	7a02                	ld	s4,32(sp)
    802010c8:	6ae2                	ld	s5,24(sp)
    802010ca:	6b42                	ld	s6,16(sp)
    802010cc:	6ba2                	ld	s7,8(sp)
    802010ce:	6161                	addi	sp,sp,80
    802010d0:	8082                	ret
	exit(code);
    802010d2:	0009851b          	sext.w	a0,s3
    802010d6:	00000097          	auipc	ra,0x0
    802010da:	90c080e7          	jalr	-1780(ra) # 802009e2 <exit>
	yield();
    802010de:	00000097          	auipc	ra,0x0
    802010e2:	8d0080e7          	jalr	-1840(ra) # 802009ae <yield>
		ret = sys_sched_yield();
    802010e6:	4581                	li	a1,0
		break;
    802010e8:	b7d9                	j	802010ae <syscall+0x10a>
		ret = sys_gettimeofday((TimeVal *)args[0], args[1]);
    802010ea:	000a059b          	sext.w	a1,s4
    802010ee:	854e                	mv	a0,s3
    802010f0:	00000097          	auipc	ra,0x0
    802010f4:	c24080e7          	jalr	-988(ra) # 80200d14 <sys_gettimeofday>
    802010f8:	0005059b          	sext.w	a1,a0
		break;
    802010fc:	bf4d                	j	802010ae <syscall+0x10a>
		ret = sys_mmap(args[0], args[1], args[2], args[3], args[4]);
    802010fe:	000b871b          	sext.w	a4,s7
    80201102:	000b069b          	sext.w	a3,s6
    80201106:	000a861b          	sext.w	a2,s5
    8020110a:	85d2                	mv	a1,s4
    8020110c:	854e                	mv	a0,s3
    8020110e:	00000097          	auipc	ra,0x0
    80201112:	c68080e7          	jalr	-920(ra) # 80200d76 <sys_mmap>
    80201116:	0005059b          	sext.w	a1,a0
		break;
    8020111a:	bf51                	j	802010ae <syscall+0x10a>

000000008020111c <get_cycle>:
#include "riscv.h"
#include "sbi.h"

/// read the `mtime` regiser
uint64 get_cycle()
{
    8020111c:	1141                	addi	sp,sp,-16
    8020111e:	e422                	sd	s0,8(sp)
    80201120:	0800                	addi	s0,sp,16

// machine-mode cycle counter
static inline uint64 r_time()
{
	uint64 x;
	asm volatile("csrr %0, time" : "=r"(x));
    80201122:	c0102573          	rdtime	a0
	return r_time();
}
    80201126:	6422                	ld	s0,8(sp)
    80201128:	0141                	addi	sp,sp,16
    8020112a:	8082                	ret

000000008020112c <set_next_timer>:
	set_next_timer();
}

/// Set the next timer interrupt
void set_next_timer()
{
    8020112c:	1141                	addi	sp,sp,-16
    8020112e:	e406                	sd	ra,8(sp)
    80201130:	e022                	sd	s0,0(sp)
    80201132:	0800                	addi	s0,sp,16
    80201134:	c0102573          	rdtime	a0
	const uint64 timebase = CPU_FREQ / TICKS_PER_SEC;
	set_timer(get_cycle() + timebase);
    80201138:	67fd                	lui	a5,0x1f
    8020113a:	84878793          	addi	a5,a5,-1976 # 1e848 <_entry-0x801e17b8>
    8020113e:	953e                	add	a0,a0,a5
    80201140:	00000097          	auipc	ra,0x0
    80201144:	928080e7          	jalr	-1752(ra) # 80200a68 <set_timer>
    80201148:	60a2                	ld	ra,8(sp)
    8020114a:	6402                	ld	s0,0(sp)
    8020114c:	0141                	addi	sp,sp,16
    8020114e:	8082                	ret

0000000080201150 <timer_init>:
{
    80201150:	1141                	addi	sp,sp,-16
    80201152:	e406                	sd	ra,8(sp)
    80201154:	e022                	sd	s0,0(sp)
    80201156:	0800                	addi	s0,sp,16
	asm volatile("csrr %0, sie" : "=r"(x));
    80201158:	104027f3          	csrr	a5,sie
	w_sie(r_sie() | SIE_STIE);
    8020115c:	0207e793          	ori	a5,a5,32
	asm volatile("csrw sie, %0" : : "r"(x));
    80201160:	10479073          	csrw	sie,a5
	set_next_timer();
    80201164:	00000097          	auipc	ra,0x0
    80201168:	fc8080e7          	jalr	-56(ra) # 8020112c <set_next_timer>
}
    8020116c:	60a2                	ld	ra,8(sp)
    8020116e:	6402                	ld	s0,0(sp)
    80201170:	0141                	addi	sp,sp,16
    80201172:	8082                	ret

0000000080201174 <kerneltrap>:

extern char trampoline[], uservec[];
extern char userret[];

void kerneltrap()
{
    80201174:	1141                	addi	sp,sp,-16
    80201176:	e406                	sd	ra,8(sp)
    80201178:	e022                	sd	s0,0(sp)
    8020117a:	0800                	addi	s0,sp,16
	asm volatile("csrr %0, sstatus" : "=r"(x));
    8020117c:	100027f3          	csrr	a5,sstatus
	if ((r_sstatus() & SSTATUS_SPP) == 0)
    80201180:	1007f793          	andi	a5,a5,256
    80201184:	c3a1                	beqz	a5,802011c4 <kerneltrap+0x50>
		panic("kerneltrap: not from supervisor mode");
	panic("trap from kerne");
    80201186:	fffff097          	auipc	ra,0xfffff
    8020118a:	5a4080e7          	jalr	1444(ra) # 8020072a <threadid>
    8020118e:	86aa                	mv	a3,a0
    80201190:	47b9                	li	a5,14
    80201192:	00002717          	auipc	a4,0x2
    80201196:	01670713          	addi	a4,a4,22 # 802031a8 <digits+0x80>
    8020119a:	00002617          	auipc	a2,0x2
    8020119e:	e7660613          	addi	a2,a2,-394 # 80203010 <e_text+0x10>
    802011a2:	45fd                	li	a1,31
    802011a4:	00002517          	auipc	a0,0x2
    802011a8:	05450513          	addi	a0,a0,84 # 802031f8 <digits+0xd0>
    802011ac:	fffff097          	auipc	ra,0xfffff
    802011b0:	3a8080e7          	jalr	936(ra) # 80200554 <printf>
    802011b4:	00000097          	auipc	ra,0x0
    802011b8:	89c080e7          	jalr	-1892(ra) # 80200a50 <shutdown>
}
    802011bc:	60a2                	ld	ra,8(sp)
    802011be:	6402                	ld	s0,0(sp)
    802011c0:	0141                	addi	sp,sp,16
    802011c2:	8082                	ret
		panic("kerneltrap: not from supervisor mode");
    802011c4:	fffff097          	auipc	ra,0xfffff
    802011c8:	566080e7          	jalr	1382(ra) # 8020072a <threadid>
    802011cc:	86aa                	mv	a3,a0
    802011ce:	47b5                	li	a5,13
    802011d0:	00002717          	auipc	a4,0x2
    802011d4:	fd870713          	addi	a4,a4,-40 # 802031a8 <digits+0x80>
    802011d8:	00002617          	auipc	a2,0x2
    802011dc:	e3860613          	addi	a2,a2,-456 # 80203010 <e_text+0x10>
    802011e0:	45fd                	li	a1,31
    802011e2:	00002517          	auipc	a0,0x2
    802011e6:	fd650513          	addi	a0,a0,-42 # 802031b8 <digits+0x90>
    802011ea:	fffff097          	auipc	ra,0xfffff
    802011ee:	36a080e7          	jalr	874(ra) # 80200554 <printf>
    802011f2:	00000097          	auipc	ra,0x0
    802011f6:	85e080e7          	jalr	-1954(ra) # 80200a50 <shutdown>
    802011fa:	b771                	j	80201186 <kerneltrap+0x12>

00000000802011fc <set_usertrap>:

// set up to take exceptions and traps while in the kernel.
void set_usertrap(void)
{
    802011fc:	1141                	addi	sp,sp,-16
    802011fe:	e422                	sd	s0,8(sp)
    80201200:	0800                	addi	s0,sp,16
	w_stvec(((uint64)TRAMPOLINE + (uservec - trampoline)) & ~0x3); // DIRECT
    80201202:	04000737          	lui	a4,0x4000
    80201206:	00001797          	auipc	a5,0x1
    8020120a:	dfa78793          	addi	a5,a5,-518 # 80202000 <trampoline>
    8020120e:	00001697          	auipc	a3,0x1
    80201212:	df268693          	addi	a3,a3,-526 # 80202000 <trampoline>
    80201216:	8f95                	sub	a5,a5,a3
    80201218:	177d                	addi	a4,a4,-1
    8020121a:	0732                	slli	a4,a4,0xc
    8020121c:	97ba                	add	a5,a5,a4
    8020121e:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    80201220:	10579073          	csrw	stvec,a5
}
    80201224:	6422                	ld	s0,8(sp)
    80201226:	0141                	addi	sp,sp,16
    80201228:	8082                	ret

000000008020122a <set_kerneltrap>:

void set_kerneltrap(void)
{
    8020122a:	1141                	addi	sp,sp,-16
    8020122c:	e422                	sd	s0,8(sp)
    8020122e:	0800                	addi	s0,sp,16
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    80201230:	00000797          	auipc	a5,0x0
    80201234:	f4478793          	addi	a5,a5,-188 # 80201174 <kerneltrap>
    80201238:	9bf1                	andi	a5,a5,-4
    8020123a:	10579073          	csrw	stvec,a5
}
    8020123e:	6422                	ld	s0,8(sp)
    80201240:	0141                	addi	sp,sp,16
    80201242:	8082                	ret

0000000080201244 <trap_init>:

// set up to take exceptions and traps while in the kernel.
void trap_init(void)
{
    80201244:	1141                	addi	sp,sp,-16
    80201246:	e422                	sd	s0,8(sp)
    80201248:	0800                	addi	s0,sp,16
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    8020124a:	00000797          	auipc	a5,0x0
    8020124e:	f2a78793          	addi	a5,a5,-214 # 80201174 <kerneltrap>
    80201252:	9bf1                	andi	a5,a5,-4
    80201254:	10579073          	csrw	stvec,a5
	// intr_on();
	set_kerneltrap();
}
    80201258:	6422                	ld	s0,8(sp)
    8020125a:	0141                	addi	sp,sp,16
    8020125c:	8082                	ret

000000008020125e <unknown_trap>:

void unknown_trap()
{
    8020125e:	1141                	addi	sp,sp,-16
    80201260:	e406                	sd	ra,8(sp)
    80201262:	e022                	sd	s0,0(sp)
    80201264:	0800                	addi	s0,sp,16
	errorf("unknown trap: %p, stval = %p", r_scause(), r_stval());
    80201266:	fffff097          	auipc	ra,0xfffff
    8020126a:	4c4080e7          	jalr	1220(ra) # 8020072a <threadid>
    8020126e:	86aa                	mv	a3,a0
	asm volatile("csrr %0, scause" : "=r"(x));
    80201270:	14202773          	csrr	a4,scause
	asm volatile("csrr %0, stval" : "=r"(x));
    80201274:	143027f3          	csrr	a5,stval
    80201278:	00002617          	auipc	a2,0x2
    8020127c:	f0060613          	addi	a2,a2,-256 # 80203178 <digits+0x50>
    80201280:	45fd                	li	a1,31
    80201282:	00002517          	auipc	a0,0x2
    80201286:	fa650513          	addi	a0,a0,-90 # 80203228 <digits+0x100>
    8020128a:	fffff097          	auipc	ra,0xfffff
    8020128e:	2ca080e7          	jalr	714(ra) # 80200554 <printf>
	exit(-1);
    80201292:	557d                	li	a0,-1
    80201294:	fffff097          	auipc	ra,0xfffff
    80201298:	74e080e7          	jalr	1870(ra) # 802009e2 <exit>
}
    8020129c:	60a2                	ld	ra,8(sp)
    8020129e:	6402                	ld	s0,0(sp)
    802012a0:	0141                	addi	sp,sp,16
    802012a2:	8082                	ret

00000000802012a4 <usertrapret>:

//
// return to user space
//
void usertrapret()
{
    802012a4:	7179                	addi	sp,sp,-48
    802012a6:	f406                	sd	ra,40(sp)
    802012a8:	f022                	sd	s0,32(sp)
    802012aa:	ec26                	sd	s1,24(sp)
    802012ac:	e84a                	sd	s2,16(sp)
    802012ae:	e44e                	sd	s3,8(sp)
    802012b0:	e052                	sd	s4,0(sp)
    802012b2:	1800                	addi	s0,sp,48
	w_stvec(((uint64)TRAMPOLINE + (uservec - trampoline)) & ~0x3); // DIRECT
    802012b4:	00001a17          	auipc	s4,0x1
    802012b8:	d4ca0a13          	addi	s4,s4,-692 # 80202000 <trampoline>
    802012bc:	00001797          	auipc	a5,0x1
    802012c0:	d4478793          	addi	a5,a5,-700 # 80202000 <trampoline>
    802012c4:	414787b3          	sub	a5,a5,s4
    802012c8:	040004b7          	lui	s1,0x4000
    802012cc:	14fd                	addi	s1,s1,-1
    802012ce:	04b2                	slli	s1,s1,0xc
    802012d0:	97a6                	add	a5,a5,s1
    802012d2:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    802012d4:	10579073          	csrw	stvec,a5
	set_usertrap();
	struct trapframe *trapframe = curr_proc()->trapframe;
    802012d8:	fffff097          	auipc	ra,0xfffff
    802012dc:	468080e7          	jalr	1128(ra) # 80200740 <curr_proc>
    802012e0:	01853903          	ld	s2,24(a0)
	asm volatile("csrr %0, satp" : "=r"(x));
    802012e4:	180027f3          	csrr	a5,satp
	trapframe->kernel_satp = r_satp(); // kernel page table
    802012e8:	00f93023          	sd	a5,0(s2)
	trapframe->kernel_sp =
		curr_proc()->kstack + KSTACK_SIZE; // process's kernel stack
    802012ec:	fffff097          	auipc	ra,0xfffff
    802012f0:	454080e7          	jalr	1108(ra) # 80200740 <curr_proc>
    802012f4:	691c                	ld	a5,16(a0)
    802012f6:	6705                	lui	a4,0x1
    802012f8:	97ba                	add	a5,a5,a4
	trapframe->kernel_sp =
    802012fa:	00f93423          	sd	a5,8(s2)
	trapframe->kernel_trap = (uint64)usertrap;
    802012fe:	00000797          	auipc	a5,0x0
    80201302:	07a78793          	addi	a5,a5,122 # 80201378 <usertrap>
    80201306:	00f93823          	sd	a5,16(s2)
// read and write tp, the thread pointer, which holds
// this core's hartid (core number), the index into cpus[].
static inline uint64 r_tp()
{
	uint64 x;
	asm volatile("mv %0, tp" : "=r"(x));
    8020130a:	8792                	mv	a5,tp
	trapframe->kernel_hartid = r_tp(); // unuesd
    8020130c:	02f93023          	sd	a5,32(s2)
	asm volatile("csrw sepc, %0" : : "r"(x));
    80201310:	01893783          	ld	a5,24(s2)
    80201314:	14179073          	csrw	sepc,a5
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80201318:	100027f3          	csrr	a5,sstatus
	// set up the registers that trampoline.S's sret will use
	// to get to user space.

	// set S Previous Privilege mode to User.
	uint64 x = r_sstatus();
	x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8020131c:	eff7f793          	andi	a5,a5,-257
	x |= SSTATUS_SPIE; // enable interrupts in user mode
    80201320:	0207e793          	ori	a5,a5,32
	asm volatile("csrw sstatus, %0" : : "r"(x));
    80201324:	10079073          	csrw	sstatus,a5
	w_sstatus(x);

	// tell trampoline.S the user page table to switch to.
	uint64 satp = MAKE_SATP(curr_proc()->pagetable);
    80201328:	fffff097          	auipc	ra,0xfffff
    8020132c:	418080e7          	jalr	1048(ra) # 80200740 <curr_proc>
    80201330:	09053983          	ld	s3,144(a0)
    80201334:	00c9d993          	srli	s3,s3,0xc
    80201338:	57fd                	li	a5,-1
    8020133a:	17fe                	slli	a5,a5,0x3f
    8020133c:	00f9e9b3          	or	s3,s3,a5
	uint64 fn = TRAMPOLINE + (userret - trampoline);
	tracef("return to user @ %p", trapframe->epc);
    80201340:	01893583          	ld	a1,24(s2)
    80201344:	4501                	li	a0,0
    80201346:	00000097          	auipc	ra,0x0
    8020134a:	8e6080e7          	jalr	-1818(ra) # 80200c2c <dummy>
	uint64 fn = TRAMPOLINE + (userret - trampoline);
    8020134e:	00001797          	auipc	a5,0x1
    80201352:	d4a78793          	addi	a5,a5,-694 # 80202098 <userret>
    80201356:	414787b3          	sub	a5,a5,s4
    8020135a:	94be                	add	s1,s1,a5
	((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    8020135c:	85ce                	mv	a1,s3
    8020135e:	02000537          	lui	a0,0x2000
    80201362:	157d                	addi	a0,a0,-1
    80201364:	0536                	slli	a0,a0,0xd
    80201366:	9482                	jalr	s1
    80201368:	70a2                	ld	ra,40(sp)
    8020136a:	7402                	ld	s0,32(sp)
    8020136c:	64e2                	ld	s1,24(sp)
    8020136e:	6942                	ld	s2,16(sp)
    80201370:	69a2                	ld	s3,8(sp)
    80201372:	6a02                	ld	s4,0(sp)
    80201374:	6145                	addi	sp,sp,48
    80201376:	8082                	ret

0000000080201378 <usertrap>:
{
    80201378:	1101                	addi	sp,sp,-32
    8020137a:	ec06                	sd	ra,24(sp)
    8020137c:	e822                	sd	s0,16(sp)
    8020137e:	e426                	sd	s1,8(sp)
    80201380:	e04a                	sd	s2,0(sp)
    80201382:	1000                	addi	s0,sp,32
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    80201384:	00000797          	auipc	a5,0x0
    80201388:	df078793          	addi	a5,a5,-528 # 80201174 <kerneltrap>
    8020138c:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    8020138e:	10579073          	csrw	stvec,a5
	struct trapframe *trapframe = curr_proc()->trapframe;
    80201392:	fffff097          	auipc	ra,0xfffff
    80201396:	3ae080e7          	jalr	942(ra) # 80200740 <curr_proc>
    8020139a:	01853903          	ld	s2,24(a0) # 2000018 <_entry-0x7e1fffe8>
	tracef("trap from user epc = %p", trapframe->epc);
    8020139e:	01893583          	ld	a1,24(s2)
    802013a2:	4501                	li	a0,0
    802013a4:	00000097          	auipc	ra,0x0
    802013a8:	888080e7          	jalr	-1912(ra) # 80200c2c <dummy>
	asm volatile("csrr %0, sstatus" : "=r"(x));
    802013ac:	100027f3          	csrr	a5,sstatus
	if ((r_sstatus() & SSTATUS_SPP) != 0)
    802013b0:	1007f793          	andi	a5,a5,256
    802013b4:	e395                	bnez	a5,802013d8 <usertrap+0x60>
	asm volatile("csrr %0, scause" : "=r"(x));
    802013b6:	142024f3          	csrr	s1,scause
	if (cause & (1ULL << 63)) {
    802013ba:	0404cc63          	bltz	s1,80201412 <usertrap+0x9a>
		switch (cause) {
    802013be:	47bd                	li	a5,15
    802013c0:	1097e963          	bltu	a5,s1,802014d2 <usertrap+0x15a>
    802013c4:	00249713          	slli	a4,s1,0x2
    802013c8:	00002697          	auipc	a3,0x2
    802013cc:	f6468693          	addi	a3,a3,-156 # 8020332c <digits+0x204>
    802013d0:	9736                	add	a4,a4,a3
    802013d2:	431c                	lw	a5,0(a4)
    802013d4:	97b6                	add	a5,a5,a3
    802013d6:	8782                	jr	a5
		panic("usertrap: not from user mode");
    802013d8:	fffff097          	auipc	ra,0xfffff
    802013dc:	352080e7          	jalr	850(ra) # 8020072a <threadid>
    802013e0:	86aa                	mv	a3,a0
    802013e2:	03300793          	li	a5,51
    802013e6:	00002717          	auipc	a4,0x2
    802013ea:	dc270713          	addi	a4,a4,-574 # 802031a8 <digits+0x80>
    802013ee:	00002617          	auipc	a2,0x2
    802013f2:	c2260613          	addi	a2,a2,-990 # 80203010 <e_text+0x10>
    802013f6:	45fd                	li	a1,31
    802013f8:	00002517          	auipc	a0,0x2
    802013fc:	e6050513          	addi	a0,a0,-416 # 80203258 <digits+0x130>
    80201400:	fffff097          	auipc	ra,0xfffff
    80201404:	154080e7          	jalr	340(ra) # 80200554 <printf>
    80201408:	fffff097          	auipc	ra,0xfffff
    8020140c:	648080e7          	jalr	1608(ra) # 80200a50 <shutdown>
    80201410:	b75d                	j	802013b6 <usertrap+0x3e>
		cause &= ~(1ULL << 63);
    80201412:	0486                	slli	s1,s1,0x1
    80201414:	8085                	srli	s1,s1,0x1
		switch (cause) {
    80201416:	4795                	li	a5,5
    80201418:	02f48063          	beq	s1,a5,80201438 <usertrap+0xc0>
			unknown_trap();
    8020141c:	00000097          	auipc	ra,0x0
    80201420:	e42080e7          	jalr	-446(ra) # 8020125e <unknown_trap>
	usertrapret();
    80201424:	00000097          	auipc	ra,0x0
    80201428:	e80080e7          	jalr	-384(ra) # 802012a4 <usertrapret>
}
    8020142c:	60e2                	ld	ra,24(sp)
    8020142e:	6442                	ld	s0,16(sp)
    80201430:	64a2                	ld	s1,8(sp)
    80201432:	6902                	ld	s2,0(sp)
    80201434:	6105                	addi	sp,sp,32
    80201436:	8082                	ret
			tracef("time interrupt!");
    80201438:	4501                	li	a0,0
    8020143a:	fffff097          	auipc	ra,0xfffff
    8020143e:	7f2080e7          	jalr	2034(ra) # 80200c2c <dummy>
			set_next_timer();
    80201442:	00000097          	auipc	ra,0x0
    80201446:	cea080e7          	jalr	-790(ra) # 8020112c <set_next_timer>
			yield();
    8020144a:	fffff097          	auipc	ra,0xfffff
    8020144e:	564080e7          	jalr	1380(ra) # 802009ae <yield>
			break;
    80201452:	bfc9                	j	80201424 <usertrap+0xac>
			trapframe->epc += 4;
    80201454:	01893783          	ld	a5,24(s2)
    80201458:	0791                	addi	a5,a5,4
    8020145a:	00f93c23          	sd	a5,24(s2)
			syscall();
    8020145e:	00000097          	auipc	ra,0x0
    80201462:	b46080e7          	jalr	-1210(ra) # 80200fa4 <syscall>
			break;
    80201466:	bf7d                	j	80201424 <usertrap+0xac>
			errorf("%d in application, bad addr = %p, bad instruction = %p, "
    80201468:	fffff097          	auipc	ra,0xfffff
    8020146c:	2c2080e7          	jalr	706(ra) # 8020072a <threadid>
    80201470:	86aa                	mv	a3,a0
	asm volatile("csrr %0, stval" : "=r"(x));
    80201472:	143027f3          	csrr	a5,stval
    80201476:	01893803          	ld	a6,24(s2)
    8020147a:	8726                	mv	a4,s1
    8020147c:	00002617          	auipc	a2,0x2
    80201480:	cfc60613          	addi	a2,a2,-772 # 80203178 <digits+0x50>
    80201484:	45fd                	li	a1,31
    80201486:	00002517          	auipc	a0,0x2
    8020148a:	e0a50513          	addi	a0,a0,-502 # 80203290 <digits+0x168>
    8020148e:	fffff097          	auipc	ra,0xfffff
    80201492:	0c6080e7          	jalr	198(ra) # 80200554 <printf>
			exit(-2);
    80201496:	5579                	li	a0,-2
    80201498:	fffff097          	auipc	ra,0xfffff
    8020149c:	54a080e7          	jalr	1354(ra) # 802009e2 <exit>
			break;
    802014a0:	b751                	j	80201424 <usertrap+0xac>
			errorf("IllegalInstruction in application, core dumped.");
    802014a2:	fffff097          	auipc	ra,0xfffff
    802014a6:	288080e7          	jalr	648(ra) # 8020072a <threadid>
    802014aa:	86aa                	mv	a3,a0
    802014ac:	00002617          	auipc	a2,0x2
    802014b0:	ccc60613          	addi	a2,a2,-820 # 80203178 <digits+0x50>
    802014b4:	45fd                	li	a1,31
    802014b6:	00002517          	auipc	a0,0x2
    802014ba:	e3250513          	addi	a0,a0,-462 # 802032e8 <digits+0x1c0>
    802014be:	fffff097          	auipc	ra,0xfffff
    802014c2:	096080e7          	jalr	150(ra) # 80200554 <printf>
			exit(-3);
    802014c6:	5575                	li	a0,-3
    802014c8:	fffff097          	auipc	ra,0xfffff
    802014cc:	51a080e7          	jalr	1306(ra) # 802009e2 <exit>
			break;
    802014d0:	bf91                	j	80201424 <usertrap+0xac>
			unknown_trap();
    802014d2:	00000097          	auipc	ra,0x0
    802014d6:	d8c080e7          	jalr	-628(ra) # 8020125e <unknown_trap>
			break;
    802014da:	b7a9                	j	80201424 <usertrap+0xac>

00000000802014dc <walk>:
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc)
{
    802014dc:	7139                	addi	sp,sp,-64
    802014de:	fc06                	sd	ra,56(sp)
    802014e0:	f822                	sd	s0,48(sp)
    802014e2:	f426                	sd	s1,40(sp)
    802014e4:	f04a                	sd	s2,32(sp)
    802014e6:	ec4e                	sd	s3,24(sp)
    802014e8:	e852                	sd	s4,16(sp)
    802014ea:	e456                	sd	s5,8(sp)
    802014ec:	e05a                	sd	s6,0(sp)
    802014ee:	0080                	addi	s0,sp,64
    802014f0:	84aa                	mv	s1,a0
    802014f2:	89ae                	mv	s3,a1
    802014f4:	8ab2                	mv	s5,a2
	if (va >= MAXVA)
    802014f6:	57fd                	li	a5,-1
    802014f8:	83e9                	srli	a5,a5,0x1a
    802014fa:	00b7e563          	bltu	a5,a1,80201504 <walk+0x28>
{
    802014fe:	4a79                	li	s4,30
		panic("walk");

	for (int level = 2; level > 0; level--) {
    80201500:	4b31                	li	s6,12
    80201502:	a0b5                	j	8020156e <walk+0x92>
		panic("walk");
    80201504:	fffff097          	auipc	ra,0xfffff
    80201508:	226080e7          	jalr	550(ra) # 8020072a <threadid>
    8020150c:	86aa                	mv	a3,a0
    8020150e:	03400793          	li	a5,52
    80201512:	00002717          	auipc	a4,0x2
    80201516:	e5e70713          	addi	a4,a4,-418 # 80203370 <digits+0x248>
    8020151a:	00002617          	auipc	a2,0x2
    8020151e:	af660613          	addi	a2,a2,-1290 # 80203010 <e_text+0x10>
    80201522:	45fd                	li	a1,31
    80201524:	00002517          	auipc	a0,0x2
    80201528:	e5450513          	addi	a0,a0,-428 # 80203378 <digits+0x250>
    8020152c:	fffff097          	auipc	ra,0xfffff
    80201530:	028080e7          	jalr	40(ra) # 80200554 <printf>
    80201534:	fffff097          	auipc	ra,0xfffff
    80201538:	51c080e7          	jalr	1308(ra) # 80200a50 <shutdown>
    8020153c:	b7c9                	j	802014fe <walk+0x22>
		pte_t *pte = &pagetable[PX(level, va)];
		if (*pte & PTE_V) {
			pagetable = (pagetable_t)PTE2PA(*pte);
		} else {
			if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    8020153e:	060a8663          	beqz	s5,802015aa <walk+0xce>
    80201542:	fffff097          	auipc	ra,0xfffff
    80201546:	be0080e7          	jalr	-1056(ra) # 80200122 <kalloc>
    8020154a:	84aa                	mv	s1,a0
    8020154c:	c529                	beqz	a0,80201596 <walk+0xba>
				return 0;
			memset(pagetable, 0, PGSIZE);
    8020154e:	6605                	lui	a2,0x1
    80201550:	4581                	li	a1,0
    80201552:	fffff097          	auipc	ra,0xfffff
    80201556:	52c080e7          	jalr	1324(ra) # 80200a7e <memset>
			*pte = PA2PTE(pagetable) | PTE_V;
    8020155a:	00c4d793          	srli	a5,s1,0xc
    8020155e:	07aa                	slli	a5,a5,0xa
    80201560:	0017e793          	ori	a5,a5,1
    80201564:	00f93023          	sd	a5,0(s2)
	for (int level = 2; level > 0; level--) {
    80201568:	3a5d                	addiw	s4,s4,-9
    8020156a:	036a0063          	beq	s4,s6,8020158a <walk+0xae>
		pte_t *pte = &pagetable[PX(level, va)];
    8020156e:	0149d933          	srl	s2,s3,s4
    80201572:	1ff97913          	andi	s2,s2,511
    80201576:	090e                	slli	s2,s2,0x3
    80201578:	9926                	add	s2,s2,s1
		if (*pte & PTE_V) {
    8020157a:	00093483          	ld	s1,0(s2)
    8020157e:	0014f793          	andi	a5,s1,1
    80201582:	dfd5                	beqz	a5,8020153e <walk+0x62>
			pagetable = (pagetable_t)PTE2PA(*pte);
    80201584:	80a9                	srli	s1,s1,0xa
    80201586:	04b2                	slli	s1,s1,0xc
    80201588:	b7c5                	j	80201568 <walk+0x8c>
		}
	}
	return &pagetable[PX(0, va)];
    8020158a:	00c9d513          	srli	a0,s3,0xc
    8020158e:	1ff57513          	andi	a0,a0,511
    80201592:	050e                	slli	a0,a0,0x3
    80201594:	9526                	add	a0,a0,s1
}
    80201596:	70e2                	ld	ra,56(sp)
    80201598:	7442                	ld	s0,48(sp)
    8020159a:	74a2                	ld	s1,40(sp)
    8020159c:	7902                	ld	s2,32(sp)
    8020159e:	69e2                	ld	s3,24(sp)
    802015a0:	6a42                	ld	s4,16(sp)
    802015a2:	6aa2                	ld	s5,8(sp)
    802015a4:	6b02                	ld	s6,0(sp)
    802015a6:	6121                	addi	sp,sp,64
    802015a8:	8082                	ret
				return 0;
    802015aa:	4501                	li	a0,0
    802015ac:	b7ed                	j	80201596 <walk+0xba>

00000000802015ae <walkaddr>:
uint64 walkaddr(pagetable_t pagetable, uint64 va)
{
	pte_t *pte;
	uint64 pa;

	if (va >= MAXVA)
    802015ae:	57fd                	li	a5,-1
    802015b0:	83e9                	srli	a5,a5,0x1a
    802015b2:	00b7f463          	bgeu	a5,a1,802015ba <walkaddr+0xc>
		return 0;
    802015b6:	4501                	li	a0,0
		return 0;
	if ((*pte & PTE_U) == 0)
		return 0;
	pa = PTE2PA(*pte);
	return pa;
}
    802015b8:	8082                	ret
{
    802015ba:	1141                	addi	sp,sp,-16
    802015bc:	e406                	sd	ra,8(sp)
    802015be:	e022                	sd	s0,0(sp)
    802015c0:	0800                	addi	s0,sp,16
	pte = walk(pagetable, va, 0);
    802015c2:	4601                	li	a2,0
    802015c4:	00000097          	auipc	ra,0x0
    802015c8:	f18080e7          	jalr	-232(ra) # 802014dc <walk>
	if (pte == 0)
    802015cc:	c105                	beqz	a0,802015ec <walkaddr+0x3e>
	if ((*pte & PTE_V) == 0)
    802015ce:	611c                	ld	a5,0(a0)
	if ((*pte & PTE_U) == 0)
    802015d0:	0117f693          	andi	a3,a5,17
    802015d4:	4745                	li	a4,17
		return 0;
    802015d6:	4501                	li	a0,0
	if ((*pte & PTE_U) == 0)
    802015d8:	00e68663          	beq	a3,a4,802015e4 <walkaddr+0x36>
}
    802015dc:	60a2                	ld	ra,8(sp)
    802015de:	6402                	ld	s0,0(sp)
    802015e0:	0141                	addi	sp,sp,16
    802015e2:	8082                	ret
	pa = PTE2PA(*pte);
    802015e4:	00a7d513          	srli	a0,a5,0xa
    802015e8:	0532                	slli	a0,a0,0xc
	return pa;
    802015ea:	bfcd                	j	802015dc <walkaddr+0x2e>
		return 0;
    802015ec:	4501                	li	a0,0
    802015ee:	b7fd                	j	802015dc <walkaddr+0x2e>

00000000802015f0 <useraddr>:

// Look up a virtual address, return the physical address,
uint64 useraddr(pagetable_t pagetable, uint64 va)
{
    802015f0:	1101                	addi	sp,sp,-32
    802015f2:	ec06                	sd	ra,24(sp)
    802015f4:	e822                	sd	s0,16(sp)
    802015f6:	e426                	sd	s1,8(sp)
    802015f8:	1000                	addi	s0,sp,32
    802015fa:	84ae                	mv	s1,a1
	uint64 page = walkaddr(pagetable, va);
    802015fc:	00000097          	auipc	ra,0x0
    80201600:	fb2080e7          	jalr	-78(ra) # 802015ae <walkaddr>
	if (page == 0)
    80201604:	c509                	beqz	a0,8020160e <useraddr+0x1e>
		return 0;
	return page | (va & 0xFFFULL);
    80201606:	03449593          	slli	a1,s1,0x34
    8020160a:	91d1                	srli	a1,a1,0x34
    8020160c:	8d4d                	or	a0,a0,a1
}
    8020160e:	60e2                	ld	ra,24(sp)
    80201610:	6442                	ld	s0,16(sp)
    80201612:	64a2                	ld	s1,8(sp)
    80201614:	6105                	addi	sp,sp,32
    80201616:	8082                	ret

0000000080201618 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80201618:	715d                	addi	sp,sp,-80
    8020161a:	e486                	sd	ra,72(sp)
    8020161c:	e0a2                	sd	s0,64(sp)
    8020161e:	fc26                	sd	s1,56(sp)
    80201620:	f84a                	sd	s2,48(sp)
    80201622:	f44e                	sd	s3,40(sp)
    80201624:	f052                	sd	s4,32(sp)
    80201626:	ec56                	sd	s5,24(sp)
    80201628:	e85a                	sd	s6,16(sp)
    8020162a:	e45e                	sd	s7,8(sp)
    8020162c:	0880                	addi	s0,sp,80
    8020162e:	8aaa                	mv	s5,a0
    80201630:	8b3a                	mv	s6,a4
	uint64 a, last;
	pte_t *pte;

	a = PGROUNDDOWN(va);
    80201632:	777d                	lui	a4,0xfffff
    80201634:	00e5f7b3          	and	a5,a1,a4
	last = PGROUNDDOWN(va + size - 1);
    80201638:	167d                	addi	a2,a2,-1
    8020163a:	00b609b3          	add	s3,a2,a1
    8020163e:	00e9f9b3          	and	s3,s3,a4
	a = PGROUNDDOWN(va);
    80201642:	893e                	mv	s2,a5
    80201644:	40f68a33          	sub	s4,a3,a5
			return -1;
		}
		*pte = PA2PTE(pa) | perm | PTE_V;
		if (a == last)
			break;
		a += PGSIZE;
    80201648:	6b85                	lui	s7,0x1
    8020164a:	a035                	j	80201676 <mappages+0x5e>
			errorf("remap");
    8020164c:	fffff097          	auipc	ra,0xfffff
    80201650:	0de080e7          	jalr	222(ra) # 8020072a <threadid>
    80201654:	86aa                	mv	a3,a0
    80201656:	00002617          	auipc	a2,0x2
    8020165a:	b2260613          	addi	a2,a2,-1246 # 80203178 <digits+0x50>
    8020165e:	45fd                	li	a1,31
    80201660:	00002517          	auipc	a0,0x2
    80201664:	d3850513          	addi	a0,a0,-712 # 80203398 <digits+0x270>
    80201668:	fffff097          	auipc	ra,0xfffff
    8020166c:	eec080e7          	jalr	-276(ra) # 80200554 <printf>
			return -1;
    80201670:	557d                	li	a0,-1
    80201672:	a81d                	j	802016a8 <mappages+0x90>
		a += PGSIZE;
    80201674:	995e                	add	s2,s2,s7
	for (;;) {
    80201676:	012a04b3          	add	s1,s4,s2
		if ((pte = walk(pagetable, a, 1)) == 0)
    8020167a:	4605                	li	a2,1
    8020167c:	85ca                	mv	a1,s2
    8020167e:	8556                	mv	a0,s5
    80201680:	00000097          	auipc	ra,0x0
    80201684:	e5c080e7          	jalr	-420(ra) # 802014dc <walk>
    80201688:	cd19                	beqz	a0,802016a6 <mappages+0x8e>
		if (*pte & PTE_V) {
    8020168a:	611c                	ld	a5,0(a0)
    8020168c:	8b85                	andi	a5,a5,1
    8020168e:	ffdd                	bnez	a5,8020164c <mappages+0x34>
		*pte = PA2PTE(pa) | perm | PTE_V;
    80201690:	80b1                	srli	s1,s1,0xc
    80201692:	04aa                	slli	s1,s1,0xa
    80201694:	0164e4b3          	or	s1,s1,s6
    80201698:	0014e493          	ori	s1,s1,1
    8020169c:	e104                	sd	s1,0(a0)
		if (a == last)
    8020169e:	fd391be3          	bne	s2,s3,80201674 <mappages+0x5c>
		pa += PGSIZE;
	}
	return 0;
    802016a2:	4501                	li	a0,0
    802016a4:	a011                	j	802016a8 <mappages+0x90>
			return -1;
    802016a6:	557d                	li	a0,-1
}
    802016a8:	60a6                	ld	ra,72(sp)
    802016aa:	6406                	ld	s0,64(sp)
    802016ac:	74e2                	ld	s1,56(sp)
    802016ae:	7942                	ld	s2,48(sp)
    802016b0:	79a2                	ld	s3,40(sp)
    802016b2:	7a02                	ld	s4,32(sp)
    802016b4:	6ae2                	ld	s5,24(sp)
    802016b6:	6b42                	ld	s6,16(sp)
    802016b8:	6ba2                	ld	s7,8(sp)
    802016ba:	6161                	addi	sp,sp,80
    802016bc:	8082                	ret

00000000802016be <kvmmap>:
{
    802016be:	1141                	addi	sp,sp,-16
    802016c0:	e406                	sd	ra,8(sp)
    802016c2:	e022                	sd	s0,0(sp)
    802016c4:	0800                	addi	s0,sp,16
    802016c6:	87b6                	mv	a5,a3
	if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    802016c8:	86b2                	mv	a3,a2
    802016ca:	863e                	mv	a2,a5
    802016cc:	00000097          	auipc	ra,0x0
    802016d0:	f4c080e7          	jalr	-180(ra) # 80201618 <mappages>
    802016d4:	e509                	bnez	a0,802016de <kvmmap+0x20>
}
    802016d6:	60a2                	ld	ra,8(sp)
    802016d8:	6402                	ld	s0,0(sp)
    802016da:	0141                	addi	sp,sp,16
    802016dc:	8082                	ret
		panic("kvmmap");
    802016de:	fffff097          	auipc	ra,0xfffff
    802016e2:	04c080e7          	jalr	76(ra) # 8020072a <threadid>
    802016e6:	86aa                	mv	a3,a0
    802016e8:	06900793          	li	a5,105
    802016ec:	00002717          	auipc	a4,0x2
    802016f0:	c8470713          	addi	a4,a4,-892 # 80203370 <digits+0x248>
    802016f4:	00002617          	auipc	a2,0x2
    802016f8:	91c60613          	addi	a2,a2,-1764 # 80203010 <e_text+0x10>
    802016fc:	45fd                	li	a1,31
    802016fe:	00002517          	auipc	a0,0x2
    80201702:	cb250513          	addi	a0,a0,-846 # 802033b0 <digits+0x288>
    80201706:	fffff097          	auipc	ra,0xfffff
    8020170a:	e4e080e7          	jalr	-434(ra) # 80200554 <printf>
    8020170e:	fffff097          	auipc	ra,0xfffff
    80201712:	342080e7          	jalr	834(ra) # 80200a50 <shutdown>
}
    80201716:	b7c1                	j	802016d6 <kvmmap+0x18>

0000000080201718 <kvmmake>:
{
    80201718:	1101                	addi	sp,sp,-32
    8020171a:	ec06                	sd	ra,24(sp)
    8020171c:	e822                	sd	s0,16(sp)
    8020171e:	e426                	sd	s1,8(sp)
    80201720:	e04a                	sd	s2,0(sp)
    80201722:	1000                	addi	s0,sp,32
	kpgtbl = (pagetable_t)kalloc();
    80201724:	fffff097          	auipc	ra,0xfffff
    80201728:	9fe080e7          	jalr	-1538(ra) # 80200122 <kalloc>
    8020172c:	84aa                	mv	s1,a0
	memset(kpgtbl, 0, PGSIZE);
    8020172e:	6605                	lui	a2,0x1
    80201730:	4581                	li	a1,0
    80201732:	fffff097          	auipc	ra,0xfffff
    80201736:	34c080e7          	jalr	844(ra) # 80200a7e <memset>
	kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)e_text - KERNBASE,
    8020173a:	00002917          	auipc	s2,0x2
    8020173e:	8c690913          	addi	s2,s2,-1850 # 80203000 <e_text>
    80201742:	4729                	li	a4,10
    80201744:	bff00693          	li	a3,-1025
    80201748:	06d6                	slli	a3,a3,0x15
    8020174a:	96ca                	add	a3,a3,s2
    8020174c:	40100613          	li	a2,1025
    80201750:	0656                	slli	a2,a2,0x15
    80201752:	85b2                	mv	a1,a2
    80201754:	8526                	mv	a0,s1
    80201756:	00000097          	auipc	ra,0x0
    8020175a:	f68080e7          	jalr	-152(ra) # 802016be <kvmmap>
	kvmmap(kpgtbl, (uint64)e_text, (uint64)e_text, PHYSTOP - (uint64)e_text,
    8020175e:	4719                	li	a4,6
    80201760:	46c5                	li	a3,17
    80201762:	06ee                	slli	a3,a3,0x1b
    80201764:	412686b3          	sub	a3,a3,s2
    80201768:	864a                	mv	a2,s2
    8020176a:	85ca                	mv	a1,s2
    8020176c:	8526                	mv	a0,s1
    8020176e:	00000097          	auipc	ra,0x0
    80201772:	f50080e7          	jalr	-176(ra) # 802016be <kvmmap>
	kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80201776:	4729                	li	a4,10
    80201778:	6685                	lui	a3,0x1
    8020177a:	00001617          	auipc	a2,0x1
    8020177e:	88660613          	addi	a2,a2,-1914 # 80202000 <trampoline>
    80201782:	040005b7          	lui	a1,0x4000
    80201786:	15fd                	addi	a1,a1,-1
    80201788:	05b2                	slli	a1,a1,0xc
    8020178a:	8526                	mv	a0,s1
    8020178c:	00000097          	auipc	ra,0x0
    80201790:	f32080e7          	jalr	-206(ra) # 802016be <kvmmap>
}
    80201794:	8526                	mv	a0,s1
    80201796:	60e2                	ld	ra,24(sp)
    80201798:	6442                	ld	s0,16(sp)
    8020179a:	64a2                	ld	s1,8(sp)
    8020179c:	6902                	ld	s2,0(sp)
    8020179e:	6105                	addi	sp,sp,32
    802017a0:	8082                	ret

00000000802017a2 <kvm_init>:
{
    802017a2:	1141                	addi	sp,sp,-16
    802017a4:	e406                	sd	ra,8(sp)
    802017a6:	e022                	sd	s0,0(sp)
    802017a8:	0800                	addi	s0,sp,16
	kernel_pagetable = kvmmake();
    802017aa:	00000097          	auipc	ra,0x0
    802017ae:	f6e080e7          	jalr	-146(ra) # 80201718 <kvmmake>
    802017b2:	0005d797          	auipc	a5,0x5d
    802017b6:	fea7bb23          	sd	a0,-10(a5) # 8025e7a8 <kernel_pagetable>
	w_satp(MAKE_SATP(kernel_pagetable));
    802017ba:	8131                	srli	a0,a0,0xc
    802017bc:	57fd                	li	a5,-1
    802017be:	17fe                	slli	a5,a5,0x3f
    802017c0:	8d5d                	or	a0,a0,a5
	asm volatile("csrw satp, %0" : : "r"(x));
    802017c2:	18051073          	csrw	satp,a0

// flush the TLB.
static inline void sfence_vma()
{
	// the zero, zero means flush all TLB entries.
	asm volatile("sfence.vma zero, zero");
    802017c6:	12000073          	sfence.vma
	asm volatile("csrr %0, satp" : "=r"(x));
    802017ca:	180025f3          	csrr	a1,satp
	infof("enable pageing at %p", r_satp());
    802017ce:	4501                	li	a0,0
    802017d0:	fffff097          	auipc	ra,0xfffff
    802017d4:	45c080e7          	jalr	1116(ra) # 80200c2c <dummy>
}
    802017d8:	60a2                	ld	ra,8(sp)
    802017da:	6402                	ld	s0,0(sp)
    802017dc:	0141                	addi	sp,sp,16
    802017de:	8082                	ret

00000000802017e0 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    802017e0:	711d                	addi	sp,sp,-96
    802017e2:	ec86                	sd	ra,88(sp)
    802017e4:	e8a2                	sd	s0,80(sp)
    802017e6:	e4a6                	sd	s1,72(sp)
    802017e8:	e0ca                	sd	s2,64(sp)
    802017ea:	fc4e                	sd	s3,56(sp)
    802017ec:	f852                	sd	s4,48(sp)
    802017ee:	f456                	sd	s5,40(sp)
    802017f0:	f05a                	sd	s6,32(sp)
    802017f2:	ec5e                	sd	s7,24(sp)
    802017f4:	e862                	sd	s8,16(sp)
    802017f6:	e466                	sd	s9,8(sp)
    802017f8:	e06a                	sd	s10,0(sp)
    802017fa:	1080                	addi	s0,sp,96
    802017fc:	8a2a                	mv	s4,a0
    802017fe:	892e                	mv	s2,a1
    80201800:	89b2                	mv	s3,a2
    80201802:	8b36                	mv	s6,a3
	uint64 a;
	pte_t *pte;

	if ((va % PGSIZE) != 0)
    80201804:	03459793          	slli	a5,a1,0x34
    80201808:	e785                	bnez	a5,80201830 <uvmunmap+0x50>
		panic("uvmunmap: not aligned");

	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8020180a:	09b2                	slli	s3,s3,0xc
    8020180c:	99ca                	add	s3,s3,s2
    8020180e:	0d397263          	bgeu	s2,s3,802018d2 <uvmunmap+0xf2>
		if ((pte = walk(pagetable, a, 0)) == 0)
			continue;
		if ((*pte & PTE_V) != 0) {
			if (PTE_FLAGS(*pte) == PTE_V)
    80201812:	4b85                	li	s7,1
				panic("uvmunmap: not a leaf");
    80201814:	00002d17          	auipc	s10,0x2
    80201818:	b5cd0d13          	addi	s10,s10,-1188 # 80203370 <digits+0x248>
    8020181c:	00001c97          	auipc	s9,0x1
    80201820:	7f4c8c93          	addi	s9,s9,2036 # 80203010 <e_text+0x10>
    80201824:	00002c17          	auipc	s8,0x2
    80201828:	bdcc0c13          	addi	s8,s8,-1060 # 80203400 <digits+0x2d8>
	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8020182c:	6a85                	lui	s5,0x1
    8020182e:	a0bd                	j	8020189c <uvmunmap+0xbc>
		panic("uvmunmap: not aligned");
    80201830:	fffff097          	auipc	ra,0xfffff
    80201834:	efa080e7          	jalr	-262(ra) # 8020072a <threadid>
    80201838:	86aa                	mv	a3,a0
    8020183a:	09000793          	li	a5,144
    8020183e:	00002717          	auipc	a4,0x2
    80201842:	b3270713          	addi	a4,a4,-1230 # 80203370 <digits+0x248>
    80201846:	00001617          	auipc	a2,0x1
    8020184a:	7ca60613          	addi	a2,a2,1994 # 80203010 <e_text+0x10>
    8020184e:	45fd                	li	a1,31
    80201850:	00002517          	auipc	a0,0x2
    80201854:	b8050513          	addi	a0,a0,-1152 # 802033d0 <digits+0x2a8>
    80201858:	fffff097          	auipc	ra,0xfffff
    8020185c:	cfc080e7          	jalr	-772(ra) # 80200554 <printf>
    80201860:	fffff097          	auipc	ra,0xfffff
    80201864:	1f0080e7          	jalr	496(ra) # 80200a50 <shutdown>
    80201868:	b74d                	j	8020180a <uvmunmap+0x2a>
				panic("uvmunmap: not a leaf");
    8020186a:	fffff097          	auipc	ra,0xfffff
    8020186e:	ec0080e7          	jalr	-320(ra) # 8020072a <threadid>
    80201872:	86aa                	mv	a3,a0
    80201874:	09700793          	li	a5,151
    80201878:	876a                	mv	a4,s10
    8020187a:	8666                	mv	a2,s9
    8020187c:	45fd                	li	a1,31
    8020187e:	8562                	mv	a0,s8
    80201880:	fffff097          	auipc	ra,0xfffff
    80201884:	cd4080e7          	jalr	-812(ra) # 80200554 <printf>
    80201888:	fffff097          	auipc	ra,0xfffff
    8020188c:	1c8080e7          	jalr	456(ra) # 80200a50 <shutdown>
    80201890:	a03d                	j	802018be <uvmunmap+0xde>
			if (do_free) {
				uint64 pa = PTE2PA(*pte);
				kfree((void *)pa);
			}
		}
		*pte = 0;
    80201892:	0004b023          	sd	zero,0(s1) # 4000000 <_entry-0x7c200000>
	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80201896:	9956                	add	s2,s2,s5
    80201898:	03397d63          	bgeu	s2,s3,802018d2 <uvmunmap+0xf2>
		if ((pte = walk(pagetable, a, 0)) == 0)
    8020189c:	4601                	li	a2,0
    8020189e:	85ca                	mv	a1,s2
    802018a0:	8552                	mv	a0,s4
    802018a2:	00000097          	auipc	ra,0x0
    802018a6:	c3a080e7          	jalr	-966(ra) # 802014dc <walk>
    802018aa:	84aa                	mv	s1,a0
    802018ac:	d56d                	beqz	a0,80201896 <uvmunmap+0xb6>
		if ((*pte & PTE_V) != 0) {
    802018ae:	611c                	ld	a5,0(a0)
    802018b0:	0017f713          	andi	a4,a5,1
    802018b4:	df79                	beqz	a4,80201892 <uvmunmap+0xb2>
			if (PTE_FLAGS(*pte) == PTE_V)
    802018b6:	3ff7f793          	andi	a5,a5,1023
    802018ba:	fb7788e3          	beq	a5,s7,8020186a <uvmunmap+0x8a>
			if (do_free) {
    802018be:	fc0b0ae3          	beqz	s6,80201892 <uvmunmap+0xb2>
				uint64 pa = PTE2PA(*pte);
    802018c2:	6088                	ld	a0,0(s1)
    802018c4:	8129                	srli	a0,a0,0xa
				kfree((void *)pa);
    802018c6:	0532                	slli	a0,a0,0xc
    802018c8:	ffffe097          	auipc	ra,0xffffe
    802018cc:	768080e7          	jalr	1896(ra) # 80200030 <kfree>
    802018d0:	b7c9                	j	80201892 <uvmunmap+0xb2>
	}
}
    802018d2:	60e6                	ld	ra,88(sp)
    802018d4:	6446                	ld	s0,80(sp)
    802018d6:	64a6                	ld	s1,72(sp)
    802018d8:	6906                	ld	s2,64(sp)
    802018da:	79e2                	ld	s3,56(sp)
    802018dc:	7a42                	ld	s4,48(sp)
    802018de:	7aa2                	ld	s5,40(sp)
    802018e0:	7b02                	ld	s6,32(sp)
    802018e2:	6be2                	ld	s7,24(sp)
    802018e4:	6c42                	ld	s8,16(sp)
    802018e6:	6ca2                	ld	s9,8(sp)
    802018e8:	6d02                	ld	s10,0(sp)
    802018ea:	6125                	addi	sp,sp,96
    802018ec:	8082                	ret

00000000802018ee <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate()
{
    802018ee:	1101                	addi	sp,sp,-32
    802018f0:	ec06                	sd	ra,24(sp)
    802018f2:	e822                	sd	s0,16(sp)
    802018f4:	e426                	sd	s1,8(sp)
    802018f6:	1000                	addi	s0,sp,32
	pagetable_t pagetable;
	pagetable = (pagetable_t)kalloc();
    802018f8:	fffff097          	auipc	ra,0xfffff
    802018fc:	82a080e7          	jalr	-2006(ra) # 80200122 <kalloc>
    80201900:	84aa                	mv	s1,a0
	if (pagetable == 0) {
    80201902:	cd15                	beqz	a0,8020193e <uvmcreate+0x50>
		errorf("uvmcreate: kalloc error");
		return 0;
	}
	memset(pagetable, 0, PGSIZE);
    80201904:	6605                	lui	a2,0x1
    80201906:	4581                	li	a1,0
    80201908:	fffff097          	auipc	ra,0xfffff
    8020190c:	176080e7          	jalr	374(ra) # 80200a7e <memset>
	if (mappages(pagetable, TRAMPOLINE, PAGE_SIZE, (uint64)trampoline,
    80201910:	4729                	li	a4,10
    80201912:	00000697          	auipc	a3,0x0
    80201916:	6ee68693          	addi	a3,a3,1774 # 80202000 <trampoline>
    8020191a:	6605                	lui	a2,0x1
    8020191c:	040005b7          	lui	a1,0x4000
    80201920:	15fd                	addi	a1,a1,-1
    80201922:	05b2                	slli	a1,a1,0xc
    80201924:	8526                	mv	a0,s1
    80201926:	00000097          	auipc	ra,0x0
    8020192a:	cf2080e7          	jalr	-782(ra) # 80201618 <mappages>
    8020192e:	02054b63          	bltz	a0,80201964 <uvmcreate+0x76>
		kfree(pagetable);
		errorf("uvmcreate: mappages error");
		return 0;
	}
	return pagetable;
}
    80201932:	8526                	mv	a0,s1
    80201934:	60e2                	ld	ra,24(sp)
    80201936:	6442                	ld	s0,16(sp)
    80201938:	64a2                	ld	s1,8(sp)
    8020193a:	6105                	addi	sp,sp,32
    8020193c:	8082                	ret
		errorf("uvmcreate: kalloc error");
    8020193e:	fffff097          	auipc	ra,0xfffff
    80201942:	dec080e7          	jalr	-532(ra) # 8020072a <threadid>
    80201946:	86aa                	mv	a3,a0
    80201948:	00002617          	auipc	a2,0x2
    8020194c:	83060613          	addi	a2,a2,-2000 # 80203178 <digits+0x50>
    80201950:	45fd                	li	a1,31
    80201952:	00002517          	auipc	a0,0x2
    80201956:	ade50513          	addi	a0,a0,-1314 # 80203430 <digits+0x308>
    8020195a:	fffff097          	auipc	ra,0xfffff
    8020195e:	bfa080e7          	jalr	-1030(ra) # 80200554 <printf>
		return 0;
    80201962:	bfc1                	j	80201932 <uvmcreate+0x44>
		kfree(pagetable);
    80201964:	8526                	mv	a0,s1
    80201966:	ffffe097          	auipc	ra,0xffffe
    8020196a:	6ca080e7          	jalr	1738(ra) # 80200030 <kfree>
		errorf("uvmcreate: mappages error");
    8020196e:	fffff097          	auipc	ra,0xfffff
    80201972:	dbc080e7          	jalr	-580(ra) # 8020072a <threadid>
    80201976:	86aa                	mv	a3,a0
    80201978:	00002617          	auipc	a2,0x2
    8020197c:	80060613          	addi	a2,a2,-2048 # 80203178 <digits+0x50>
    80201980:	45fd                	li	a1,31
    80201982:	00002517          	auipc	a0,0x2
    80201986:	ade50513          	addi	a0,a0,-1314 # 80203460 <digits+0x338>
    8020198a:	fffff097          	auipc	ra,0xfffff
    8020198e:	bca080e7          	jalr	-1078(ra) # 80200554 <printf>
		return 0;
    80201992:	4481                	li	s1,0
    80201994:	bf79                	j	80201932 <uvmcreate+0x44>

0000000080201996 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    80201996:	715d                	addi	sp,sp,-80
    80201998:	e486                	sd	ra,72(sp)
    8020199a:	e0a2                	sd	s0,64(sp)
    8020199c:	fc26                	sd	s1,56(sp)
    8020199e:	f84a                	sd	s2,48(sp)
    802019a0:	f44e                	sd	s3,40(sp)
    802019a2:	f052                	sd	s4,32(sp)
    802019a4:	ec56                	sd	s5,24(sp)
    802019a6:	e85a                	sd	s6,16(sp)
    802019a8:	e45e                	sd	s7,8(sp)
    802019aa:	0880                	addi	s0,sp,80
    802019ac:	8baa                	mv	s7,a0
	// there are 2^9 = 512 PTEs in a page table.
	for (int i = 0; i < 512; i++) {
    802019ae:	84aa                	mv	s1,a0
    802019b0:	6905                	lui	s2,0x1
    802019b2:	992a                	add	s2,s2,a0
		pte_t pte = pagetable[i];
		if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    802019b4:	4985                	li	s3,1
			// this PTE points to a lower-level page table.
			uint64 child = PTE2PA(pte);
			freewalk((pagetable_t)child);
			pagetable[i] = 0;
		} else if (pte & PTE_V) {
			panic("freewalk: leaf");
    802019b6:	00002b17          	auipc	s6,0x2
    802019ba:	9bab0b13          	addi	s6,s6,-1606 # 80203370 <digits+0x248>
    802019be:	00001a97          	auipc	s5,0x1
    802019c2:	652a8a93          	addi	s5,s5,1618 # 80203010 <e_text+0x10>
    802019c6:	00002a17          	auipc	s4,0x2
    802019ca:	acaa0a13          	addi	s4,s4,-1334 # 80203490 <digits+0x368>
    802019ce:	a821                	j	802019e6 <freewalk+0x50>
			uint64 child = PTE2PA(pte);
    802019d0:	8129                	srli	a0,a0,0xa
			freewalk((pagetable_t)child);
    802019d2:	0532                	slli	a0,a0,0xc
    802019d4:	00000097          	auipc	ra,0x0
    802019d8:	fc2080e7          	jalr	-62(ra) # 80201996 <freewalk>
			pagetable[i] = 0;
    802019dc:	0004b023          	sd	zero,0(s1)
	for (int i = 0; i < 512; i++) {
    802019e0:	04a1                	addi	s1,s1,8
    802019e2:	03248d63          	beq	s1,s2,80201a1c <freewalk+0x86>
		pte_t pte = pagetable[i];
    802019e6:	6088                	ld	a0,0(s1)
		if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    802019e8:	00f57793          	andi	a5,a0,15
    802019ec:	ff3782e3          	beq	a5,s3,802019d0 <freewalk+0x3a>
		} else if (pte & PTE_V) {
    802019f0:	8905                	andi	a0,a0,1
    802019f2:	d57d                	beqz	a0,802019e0 <freewalk+0x4a>
			panic("freewalk: leaf");
    802019f4:	fffff097          	auipc	ra,0xfffff
    802019f8:	d36080e7          	jalr	-714(ra) # 8020072a <threadid>
    802019fc:	86aa                	mv	a3,a0
    802019fe:	0c200793          	li	a5,194
    80201a02:	875a                	mv	a4,s6
    80201a04:	8656                	mv	a2,s5
    80201a06:	45fd                	li	a1,31
    80201a08:	8552                	mv	a0,s4
    80201a0a:	fffff097          	auipc	ra,0xfffff
    80201a0e:	b4a080e7          	jalr	-1206(ra) # 80200554 <printf>
    80201a12:	fffff097          	auipc	ra,0xfffff
    80201a16:	03e080e7          	jalr	62(ra) # 80200a50 <shutdown>
    80201a1a:	b7d9                	j	802019e0 <freewalk+0x4a>
		}
	}
	kfree((void *)pagetable);
    80201a1c:	855e                	mv	a0,s7
    80201a1e:	ffffe097          	auipc	ra,0xffffe
    80201a22:	612080e7          	jalr	1554(ra) # 80200030 <kfree>
}
    80201a26:	60a6                	ld	ra,72(sp)
    80201a28:	6406                	ld	s0,64(sp)
    80201a2a:	74e2                	ld	s1,56(sp)
    80201a2c:	7942                	ld	s2,48(sp)
    80201a2e:	79a2                	ld	s3,40(sp)
    80201a30:	7a02                	ld	s4,32(sp)
    80201a32:	6ae2                	ld	s5,24(sp)
    80201a34:	6b42                	ld	s6,16(sp)
    80201a36:	6ba2                	ld	s7,8(sp)
    80201a38:	6161                	addi	sp,sp,80
    80201a3a:	8082                	ret

0000000080201a3c <uvmfree>:
 * @brief Free user memory pages, then free page-table pages.
 *
 * @param max_page The max vaddr of user-space.
 */
void uvmfree(pagetable_t pagetable, uint64 max_page)
{
    80201a3c:	1101                	addi	sp,sp,-32
    80201a3e:	ec06                	sd	ra,24(sp)
    80201a40:	e822                	sd	s0,16(sp)
    80201a42:	e426                	sd	s1,8(sp)
    80201a44:	1000                	addi	s0,sp,32
    80201a46:	84aa                	mv	s1,a0
	if (max_page > 0)
    80201a48:	e999                	bnez	a1,80201a5e <uvmfree+0x22>
		uvmunmap(pagetable, 0, max_page, 1);
	freewalk(pagetable);
    80201a4a:	8526                	mv	a0,s1
    80201a4c:	00000097          	auipc	ra,0x0
    80201a50:	f4a080e7          	jalr	-182(ra) # 80201996 <freewalk>
}
    80201a54:	60e2                	ld	ra,24(sp)
    80201a56:	6442                	ld	s0,16(sp)
    80201a58:	64a2                	ld	s1,8(sp)
    80201a5a:	6105                	addi	sp,sp,32
    80201a5c:	8082                	ret
		uvmunmap(pagetable, 0, max_page, 1);
    80201a5e:	4685                	li	a3,1
    80201a60:	862e                	mv	a2,a1
    80201a62:	4581                	li	a1,0
    80201a64:	00000097          	auipc	ra,0x0
    80201a68:	d7c080e7          	jalr	-644(ra) # 802017e0 <uvmunmap>
    80201a6c:	bff9                	j	80201a4a <uvmfree+0xe>

0000000080201a6e <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
	uint64 n, va0, pa0;

	while (len > 0) {
    80201a6e:	c6bd                	beqz	a3,80201adc <copyout+0x6e>
{
    80201a70:	715d                	addi	sp,sp,-80
    80201a72:	e486                	sd	ra,72(sp)
    80201a74:	e0a2                	sd	s0,64(sp)
    80201a76:	fc26                	sd	s1,56(sp)
    80201a78:	f84a                	sd	s2,48(sp)
    80201a7a:	f44e                	sd	s3,40(sp)
    80201a7c:	f052                	sd	s4,32(sp)
    80201a7e:	ec56                	sd	s5,24(sp)
    80201a80:	e85a                	sd	s6,16(sp)
    80201a82:	e45e                	sd	s7,8(sp)
    80201a84:	e062                	sd	s8,0(sp)
    80201a86:	0880                	addi	s0,sp,80
    80201a88:	8b2a                	mv	s6,a0
    80201a8a:	8c2e                	mv	s8,a1
    80201a8c:	8a32                	mv	s4,a2
    80201a8e:	89b6                	mv	s3,a3
		va0 = PGROUNDDOWN(dstva);
    80201a90:	7bfd                	lui	s7,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (dstva - va0);
    80201a92:	6a85                	lui	s5,0x1
    80201a94:	a015                	j	80201ab8 <copyout+0x4a>
		if (n > len)
			n = len;
		memmove((void *)(pa0 + (dstva - va0)), src, n);
    80201a96:	9562                	add	a0,a0,s8
    80201a98:	0004861b          	sext.w	a2,s1
    80201a9c:	85d2                	mv	a1,s4
    80201a9e:	41250533          	sub	a0,a0,s2
    80201aa2:	fffff097          	auipc	ra,0xfffff
    80201aa6:	038080e7          	jalr	56(ra) # 80200ada <memmove>

		len -= n;
    80201aaa:	409989b3          	sub	s3,s3,s1
		src += n;
    80201aae:	9a26                	add	s4,s4,s1
		dstva = va0 + PGSIZE;
    80201ab0:	01590c33          	add	s8,s2,s5
	while (len > 0) {
    80201ab4:	02098263          	beqz	s3,80201ad8 <copyout+0x6a>
		va0 = PGROUNDDOWN(dstva);
    80201ab8:	017c7933          	and	s2,s8,s7
		pa0 = walkaddr(pagetable, va0);
    80201abc:	85ca                	mv	a1,s2
    80201abe:	855a                	mv	a0,s6
    80201ac0:	00000097          	auipc	ra,0x0
    80201ac4:	aee080e7          	jalr	-1298(ra) # 802015ae <walkaddr>
		if (pa0 == 0)
    80201ac8:	cd01                	beqz	a0,80201ae0 <copyout+0x72>
		n = PGSIZE - (dstva - va0);
    80201aca:	418904b3          	sub	s1,s2,s8
    80201ace:	94d6                	add	s1,s1,s5
		if (n > len)
    80201ad0:	fc99f3e3          	bgeu	s3,s1,80201a96 <copyout+0x28>
    80201ad4:	84ce                	mv	s1,s3
    80201ad6:	b7c1                	j	80201a96 <copyout+0x28>
	}
	return 0;
    80201ad8:	4501                	li	a0,0
    80201ada:	a021                	j	80201ae2 <copyout+0x74>
    80201adc:	4501                	li	a0,0
}
    80201ade:	8082                	ret
			return -1;
    80201ae0:	557d                	li	a0,-1
}
    80201ae2:	60a6                	ld	ra,72(sp)
    80201ae4:	6406                	ld	s0,64(sp)
    80201ae6:	74e2                	ld	s1,56(sp)
    80201ae8:	7942                	ld	s2,48(sp)
    80201aea:	79a2                	ld	s3,40(sp)
    80201aec:	7a02                	ld	s4,32(sp)
    80201aee:	6ae2                	ld	s5,24(sp)
    80201af0:	6b42                	ld	s6,16(sp)
    80201af2:	6ba2                	ld	s7,8(sp)
    80201af4:	6c02                	ld	s8,0(sp)
    80201af6:	6161                	addi	sp,sp,80
    80201af8:	8082                	ret

0000000080201afa <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
	uint64 n, va0, pa0;

	while (len > 0) {
    80201afa:	caa5                	beqz	a3,80201b6a <copyin+0x70>
{
    80201afc:	715d                	addi	sp,sp,-80
    80201afe:	e486                	sd	ra,72(sp)
    80201b00:	e0a2                	sd	s0,64(sp)
    80201b02:	fc26                	sd	s1,56(sp)
    80201b04:	f84a                	sd	s2,48(sp)
    80201b06:	f44e                	sd	s3,40(sp)
    80201b08:	f052                	sd	s4,32(sp)
    80201b0a:	ec56                	sd	s5,24(sp)
    80201b0c:	e85a                	sd	s6,16(sp)
    80201b0e:	e45e                	sd	s7,8(sp)
    80201b10:	e062                	sd	s8,0(sp)
    80201b12:	0880                	addi	s0,sp,80
    80201b14:	8b2a                	mv	s6,a0
    80201b16:	8a2e                	mv	s4,a1
    80201b18:	8c32                	mv	s8,a2
    80201b1a:	89b6                	mv	s3,a3
		va0 = PGROUNDDOWN(srcva);
    80201b1c:	7bfd                	lui	s7,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (srcva - va0);
    80201b1e:	6a85                	lui	s5,0x1
    80201b20:	a01d                	j	80201b46 <copyin+0x4c>
		if (n > len)
			n = len;
		memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80201b22:	018505b3          	add	a1,a0,s8
    80201b26:	0004861b          	sext.w	a2,s1
    80201b2a:	412585b3          	sub	a1,a1,s2
    80201b2e:	8552                	mv	a0,s4
    80201b30:	fffff097          	auipc	ra,0xfffff
    80201b34:	faa080e7          	jalr	-86(ra) # 80200ada <memmove>

		len -= n;
    80201b38:	409989b3          	sub	s3,s3,s1
		dst += n;
    80201b3c:	9a26                	add	s4,s4,s1
		srcva = va0 + PGSIZE;
    80201b3e:	01590c33          	add	s8,s2,s5
	while (len > 0) {
    80201b42:	02098263          	beqz	s3,80201b66 <copyin+0x6c>
		va0 = PGROUNDDOWN(srcva);
    80201b46:	017c7933          	and	s2,s8,s7
		pa0 = walkaddr(pagetable, va0);
    80201b4a:	85ca                	mv	a1,s2
    80201b4c:	855a                	mv	a0,s6
    80201b4e:	00000097          	auipc	ra,0x0
    80201b52:	a60080e7          	jalr	-1440(ra) # 802015ae <walkaddr>
		if (pa0 == 0)
    80201b56:	cd01                	beqz	a0,80201b6e <copyin+0x74>
		n = PGSIZE - (srcva - va0);
    80201b58:	418904b3          	sub	s1,s2,s8
    80201b5c:	94d6                	add	s1,s1,s5
		if (n > len)
    80201b5e:	fc99f2e3          	bgeu	s3,s1,80201b22 <copyin+0x28>
    80201b62:	84ce                	mv	s1,s3
    80201b64:	bf7d                	j	80201b22 <copyin+0x28>
	}
	return 0;
    80201b66:	4501                	li	a0,0
    80201b68:	a021                	j	80201b70 <copyin+0x76>
    80201b6a:	4501                	li	a0,0
}
    80201b6c:	8082                	ret
			return -1;
    80201b6e:	557d                	li	a0,-1
}
    80201b70:	60a6                	ld	ra,72(sp)
    80201b72:	6406                	ld	s0,64(sp)
    80201b74:	74e2                	ld	s1,56(sp)
    80201b76:	7942                	ld	s2,48(sp)
    80201b78:	79a2                	ld	s3,40(sp)
    80201b7a:	7a02                	ld	s4,32(sp)
    80201b7c:	6ae2                	ld	s5,24(sp)
    80201b7e:	6b42                	ld	s6,16(sp)
    80201b80:	6ba2                	ld	s7,8(sp)
    80201b82:	6c02                	ld	s8,0(sp)
    80201b84:	6161                	addi	sp,sp,80
    80201b86:	8082                	ret

0000000080201b88 <copyinstr>:
// Copy a null-terminated string from user to kernel.
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80201b88:	715d                	addi	sp,sp,-80
    80201b8a:	e486                	sd	ra,72(sp)
    80201b8c:	e0a2                	sd	s0,64(sp)
    80201b8e:	fc26                	sd	s1,56(sp)
    80201b90:	f84a                	sd	s2,48(sp)
    80201b92:	f44e                	sd	s3,40(sp)
    80201b94:	f052                	sd	s4,32(sp)
    80201b96:	ec56                	sd	s5,24(sp)
    80201b98:	e85a                	sd	s6,16(sp)
    80201b9a:	e45e                	sd	s7,8(sp)
    80201b9c:	e062                	sd	s8,0(sp)
    80201b9e:	0880                	addi	s0,sp,80
	uint64 n, va0, pa0;
	int got_null = 0, len = 0;

	while (got_null == 0 && max > 0) {
    80201ba0:	c6c9                	beqz	a3,80201c2a <copyinstr+0xa2>
    80201ba2:	8aaa                	mv	s5,a0
    80201ba4:	8bae                	mv	s7,a1
    80201ba6:	8c32                	mv	s8,a2
    80201ba8:	8936                	mv	s2,a3
	int got_null = 0, len = 0;
    80201baa:	4481                	li	s1,0
		va0 = PGROUNDDOWN(srcva);
    80201bac:	7b7d                	lui	s6,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (srcva - va0);
    80201bae:	6a05                	lui	s4,0x1
    80201bb0:	a025                	j	80201bd8 <copyinstr+0x50>
			n = max;

		char *p = (char *)(pa0 + (srcva - va0));
		while (n > 0) {
			if (*p == '\0') {
				*dst = '\0';
    80201bb2:	00078023          	sb	zero,0(a5)
		}

		srcva = va0 + PGSIZE;
	}
	return len;
}
    80201bb6:	8526                	mv	a0,s1
    80201bb8:	60a6                	ld	ra,72(sp)
    80201bba:	6406                	ld	s0,64(sp)
    80201bbc:	74e2                	ld	s1,56(sp)
    80201bbe:	7942                	ld	s2,48(sp)
    80201bc0:	79a2                	ld	s3,40(sp)
    80201bc2:	7a02                	ld	s4,32(sp)
    80201bc4:	6ae2                	ld	s5,24(sp)
    80201bc6:	6b42                	ld	s6,16(sp)
    80201bc8:	6ba2                	ld	s7,8(sp)
    80201bca:	6c02                	ld	s8,0(sp)
    80201bcc:	6161                	addi	sp,sp,80
    80201bce:	8082                	ret
		srcva = va0 + PGSIZE;
    80201bd0:	01498c33          	add	s8,s3,s4
	while (got_null == 0 && max > 0) {
    80201bd4:	fe0901e3          	beqz	s2,80201bb6 <copyinstr+0x2e>
		va0 = PGROUNDDOWN(srcva);
    80201bd8:	016c79b3          	and	s3,s8,s6
		pa0 = walkaddr(pagetable, va0);
    80201bdc:	85ce                	mv	a1,s3
    80201bde:	8556                	mv	a0,s5
    80201be0:	00000097          	auipc	ra,0x0
    80201be4:	9ce080e7          	jalr	-1586(ra) # 802015ae <walkaddr>
		if (pa0 == 0)
    80201be8:	c139                	beqz	a0,80201c2e <copyinstr+0xa6>
		n = PGSIZE - (srcva - va0);
    80201bea:	41898833          	sub	a6,s3,s8
    80201bee:	9852                	add	a6,a6,s4
		if (n > max)
    80201bf0:	01097363          	bgeu	s2,a6,80201bf6 <copyinstr+0x6e>
    80201bf4:	884a                	mv	a6,s2
		char *p = (char *)(pa0 + (srcva - va0));
    80201bf6:	9562                	add	a0,a0,s8
    80201bf8:	41350533          	sub	a0,a0,s3
		while (n > 0) {
    80201bfc:	fc080ae3          	beqz	a6,80201bd0 <copyinstr+0x48>
    80201c00:	985e                	add	a6,a6,s7
    80201c02:	87de                	mv	a5,s7
			if (*p == '\0') {
    80201c04:	41750633          	sub	a2,a0,s7
    80201c08:	197d                	addi	s2,s2,-1
    80201c0a:	9bca                	add	s7,s7,s2
    80201c0c:	00f60733          	add	a4,a2,a5
    80201c10:	00074703          	lbu	a4,0(a4)
    80201c14:	df59                	beqz	a4,80201bb2 <copyinstr+0x2a>
				*dst = *p;
    80201c16:	00e78023          	sb	a4,0(a5)
			--max;
    80201c1a:	40fb8933          	sub	s2,s7,a5
			dst++;
    80201c1e:	0785                	addi	a5,a5,1
			len++;
    80201c20:	2485                	addiw	s1,s1,1
		while (n > 0) {
    80201c22:	ff0795e3          	bne	a5,a6,80201c0c <copyinstr+0x84>
			dst++;
    80201c26:	8bc2                	mv	s7,a6
    80201c28:	b765                	j	80201bd0 <copyinstr+0x48>
	int got_null = 0, len = 0;
    80201c2a:	4481                	li	s1,0
    80201c2c:	b769                	j	80201bb6 <copyinstr+0x2e>
			return -1;
    80201c2e:	54fd                	li	s1,-1
    80201c30:	b759                	j	80201bb6 <copyinstr+0x2e>

0000000080201c32 <swtch>:
# Save current registers in old. Load from new.


.globl swtch
swtch:
        sd ra, 0(a0)
    80201c32:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80201c36:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80201c3a:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80201c3c:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80201c3e:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80201c42:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80201c46:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80201c4a:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80201c4e:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80201c52:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80201c56:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80201c5a:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80201c5e:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80201c62:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80201c66:	0005b083          	ld	ra,0(a1) # 4000000 <_entry-0x7c200000>
        ld sp, 8(a1)
    80201c6a:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80201c6e:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80201c70:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80201c72:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80201c76:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80201c7a:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80201c7e:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80201c82:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80201c86:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80201c8a:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80201c8e:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80201c92:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80201c96:	0685bd83          	ld	s11,104(a1)

    80201c9a:	8082                	ret
	...

0000000080202000 <trampoline>:
        # mapped into user space, at TRAPFRAME.
        #

	# swap a0 and sscratch
        # so that a0 is TRAPFRAME
        csrrw a0, sscratch, a0
    80202000:	14051573          	csrrw	a0,sscratch,a0

        # save the user registers in TRAPFRAME
        sd ra, 40(a0)
    80202004:	02153423          	sd	ra,40(a0)
        sd sp, 48(a0)
    80202008:	02253823          	sd	sp,48(a0)
        sd gp, 56(a0)
    8020200c:	02353c23          	sd	gp,56(a0)
        sd tp, 64(a0)
    80202010:	04453023          	sd	tp,64(a0)
        sd t0, 72(a0)
    80202014:	04553423          	sd	t0,72(a0)
        sd t1, 80(a0)
    80202018:	04653823          	sd	t1,80(a0)
        sd t2, 88(a0)
    8020201c:	04753c23          	sd	t2,88(a0)
        sd s0, 96(a0)
    80202020:	f120                	sd	s0,96(a0)
        sd s1, 104(a0)
    80202022:	f524                	sd	s1,104(a0)
        sd a1, 120(a0)
    80202024:	fd2c                	sd	a1,120(a0)
        sd a2, 128(a0)
    80202026:	e150                	sd	a2,128(a0)
        sd a3, 136(a0)
    80202028:	e554                	sd	a3,136(a0)
        sd a4, 144(a0)
    8020202a:	e958                	sd	a4,144(a0)
        sd a5, 152(a0)
    8020202c:	ed5c                	sd	a5,152(a0)
        sd a6, 160(a0)
    8020202e:	0b053023          	sd	a6,160(a0)
        sd a7, 168(a0)
    80202032:	0b153423          	sd	a7,168(a0)
        sd s2, 176(a0)
    80202036:	0b253823          	sd	s2,176(a0)
        sd s3, 184(a0)
    8020203a:	0b353c23          	sd	s3,184(a0)
        sd s4, 192(a0)
    8020203e:	0d453023          	sd	s4,192(a0)
        sd s5, 200(a0)
    80202042:	0d553423          	sd	s5,200(a0)
        sd s6, 208(a0)
    80202046:	0d653823          	sd	s6,208(a0)
        sd s7, 216(a0)
    8020204a:	0d753c23          	sd	s7,216(a0)
        sd s8, 224(a0)
    8020204e:	0f853023          	sd	s8,224(a0)
        sd s9, 232(a0)
    80202052:	0f953423          	sd	s9,232(a0)
        sd s10, 240(a0)
    80202056:	0fa53823          	sd	s10,240(a0)
        sd s11, 248(a0)
    8020205a:	0fb53c23          	sd	s11,248(a0)
        sd t3, 256(a0)
    8020205e:	11c53023          	sd	t3,256(a0)
        sd t4, 264(a0)
    80202062:	11d53423          	sd	t4,264(a0)
        sd t5, 272(a0)
    80202066:	11e53823          	sd	t5,272(a0)
        sd t6, 280(a0)
    8020206a:	11f53c23          	sd	t6,280(a0)

        csrr t0, sscratch
    8020206e:	140022f3          	csrr	t0,sscratch
        sd t0, 112(a0)
    80202072:	06553823          	sd	t0,112(a0)
        csrr t1, sepc
    80202076:	14102373          	csrr	t1,sepc
        sd t1, 24(a0)
    8020207a:	00653c23          	sd	t1,24(a0)
        ld sp, 8(a0)
    8020207e:	00853103          	ld	sp,8(a0)
        ld tp, 32(a0)
    80202082:	02053203          	ld	tp,32(a0)
        ld t0, 16(a0)
    80202086:	01053283          	ld	t0,16(a0)
        ld t1, 0(a0)
    8020208a:	00053303          	ld	t1,0(a0)
        csrw satp, t1
    8020208e:	18031073          	csrw	satp,t1
        sfence.vma zero, zero
    80202092:	12000073          	sfence.vma
        jr t0
    80202096:	8282                	jr	t0

0000000080202098 <userret>:
        # usertrapret() calls here.
        # a0: TRAPFRAME, in user page table.
        # a1: user page table, for satp.

        # switch to the user page table.
        csrw satp, a1
    80202098:	18059073          	csrw	satp,a1
        sfence.vma zero, zero
    8020209c:	12000073          	sfence.vma

        # put the saved user a0 in sscratch, so we
        # can swap it with our a0 (TRAPFRAME) in the last step.
        ld t0, 112(a0)
    802020a0:	07053283          	ld	t0,112(a0)
        csrw sscratch, t0
    802020a4:	14029073          	csrw	sscratch,t0

        # restore all but a0 from TRAPFRAME
        ld ra, 40(a0)
    802020a8:	02853083          	ld	ra,40(a0)
        ld sp, 48(a0)
    802020ac:	03053103          	ld	sp,48(a0)
        ld gp, 56(a0)
    802020b0:	03853183          	ld	gp,56(a0)
        ld tp, 64(a0)
    802020b4:	04053203          	ld	tp,64(a0)
        ld t0, 72(a0)
    802020b8:	04853283          	ld	t0,72(a0)
        ld t1, 80(a0)
    802020bc:	05053303          	ld	t1,80(a0)
        ld t2, 88(a0)
    802020c0:	05853383          	ld	t2,88(a0)
        ld s0, 96(a0)
    802020c4:	7120                	ld	s0,96(a0)
        ld s1, 104(a0)
    802020c6:	7524                	ld	s1,104(a0)
        ld a1, 120(a0)
    802020c8:	7d2c                	ld	a1,120(a0)
        ld a2, 128(a0)
    802020ca:	6150                	ld	a2,128(a0)
        ld a3, 136(a0)
    802020cc:	6554                	ld	a3,136(a0)
        ld a4, 144(a0)
    802020ce:	6958                	ld	a4,144(a0)
        ld a5, 152(a0)
    802020d0:	6d5c                	ld	a5,152(a0)
        ld a6, 160(a0)
    802020d2:	0a053803          	ld	a6,160(a0)
        ld a7, 168(a0)
    802020d6:	0a853883          	ld	a7,168(a0)
        ld s2, 176(a0)
    802020da:	0b053903          	ld	s2,176(a0)
        ld s3, 184(a0)
    802020de:	0b853983          	ld	s3,184(a0)
        ld s4, 192(a0)
    802020e2:	0c053a03          	ld	s4,192(a0)
        ld s5, 200(a0)
    802020e6:	0c853a83          	ld	s5,200(a0)
        ld s6, 208(a0)
    802020ea:	0d053b03          	ld	s6,208(a0)
        ld s7, 216(a0)
    802020ee:	0d853b83          	ld	s7,216(a0)
        ld s8, 224(a0)
    802020f2:	0e053c03          	ld	s8,224(a0)
        ld s9, 232(a0)
    802020f6:	0e853c83          	ld	s9,232(a0)
        ld s10, 240(a0)
    802020fa:	0f053d03          	ld	s10,240(a0)
        ld s11, 248(a0)
    802020fe:	0f853d83          	ld	s11,248(a0)
        ld t3, 256(a0)
    80202102:	10053e03          	ld	t3,256(a0)
        ld t4, 264(a0)
    80202106:	10853e83          	ld	t4,264(a0)
        ld t5, 272(a0)
    8020210a:	11053f03          	ld	t5,272(a0)
        ld t6, 280(a0)
    8020210e:	11853f83          	ld	t6,280(a0)

	# restore user a0, and save TRAPFRAME in sscratch
        csrrw a0, sscratch, a0
    80202112:	14051573          	csrrw	a0,sscratch,a0

        # return to user mode and user pc.
        # usertrapret() set up sstatus and sepc.
        sret
    80202116:	10200073          	sret
	...
