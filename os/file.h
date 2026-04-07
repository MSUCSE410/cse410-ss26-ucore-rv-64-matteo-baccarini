#ifndef FILE_H
#define FILE_H

#include "fs.h"
#include "proc.h"
#include "types.h"

#define PIPESIZE (512)
#define FILEPOOLSIZE (NPROC * FD_BUFFER_SIZE)

// in-memory copy of an inode
struct inode {
	uint dev;
	uint inum;
	int ref;
	int valid;
	short type;
	short nlink; // hard link count
	uint size;
	uint addrs[NDIRECT + 1];
};

struct file {
	enum { FD_NONE = 0, FD_INODE, FD_STDIO } type;
	int ref;
	char readable;
	char writable;
	struct inode *ip;
	uint off;
};

enum {
	STDIN = 0,
	STDOUT = 1,
	STDERR = 2,
};

extern struct file filepool[FILEPOOLSIZE];

void fileclose(struct file *);
struct file *filealloc();
int fileopen(char *, uint64);
uint64 inodewrite(struct file *, uint64, uint64);
uint64 inoderead(struct file *, uint64, uint64);
struct file *stdio_init(int);
int show_all_files();

#endif // FILE_H