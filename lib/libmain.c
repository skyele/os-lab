// Called from entry.S to get us going.
// entry.S already took care of defining envs, pages, uvpd, and uvpt.

// #include <inc/lib.h>

// extern void umain(int argc, char **argv);

// const volatile struct Env *thisenv;
// const char *binaryname = "<unknown>";

// extern const volatile struct Env envs[NENV];
// const volatile inline struct Env* getthisenv(){
//         return &envs[ENVX(sys_getenvid())];
// } 

// void
// libmain(int argc, char **argv)
// {
// 	// set thisenv to point at our Env structure in envs[].
// 	// LAB 3: Your code here.

// 	thisenv = 0;
// 	envid_t find = sys_getenvid();
// 	for(int i = 0; i < NENV; i++){
// 		cprintf("xixixi the envs 0x%x\n", envs);
// 		if(envs[i].env_id == find)
// 			thisenv = &envs[i];
// 		cprintf("hahaha\n");
// 	}

// 	// save the name of the program so that panic() can use it
// 	if (argc > 0)
// 		binaryname = argv[0];

// 	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
// 	cprintf("before umain\n");
// 	// call user main routine
// 	umain(argc, argv);
// 	cprintf("after umain\n");
// 	cprintf("%d: limain.c exit()\n", thisenv->env_id);
// 	// exit gracefully
// 	exit();
// }









#include <inc/lib.h>

extern void umain(int argc, char **argv);

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
	thisenv = envs + ENVX(curenv);

	// save the name of the program so that panic() can use it
	if (argc > 0)
		binaryname = argv[0];

	// call user main routine
	umain(argc, argv);

	// exit gracefully
	exit();
}
