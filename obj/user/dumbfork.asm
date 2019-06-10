
obj/user/dumbfork.debug:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 a1 01 00 00       	call   8001d2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 07                	push   $0x7
  800043:	53                   	push   %ebx
  800044:	56                   	push   %esi
  800045:	e8 dc 0e 00 00       	call   800f26 <sys_page_alloc>
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	78 4a                	js     80009b <duppage+0x68>
		panic("sys_page_alloc: %e", r);
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 07                	push   $0x7
  800056:	68 00 00 40 00       	push   $0x400000
  80005b:	6a 00                	push   $0x0
  80005d:	53                   	push   %ebx
  80005e:	56                   	push   %esi
  80005f:	e8 05 0f 00 00       	call   800f69 <sys_page_map>
  800064:	83 c4 20             	add    $0x20,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 42                	js     8000ad <duppage+0x7a>
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	68 00 10 00 00       	push   $0x1000
  800073:	53                   	push   %ebx
  800074:	68 00 00 40 00       	push   $0x400000
  800079:	e8 44 0c 00 00       	call   800cc2 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80007e:	83 c4 08             	add    $0x8,%esp
  800081:	68 00 00 40 00       	push   $0x400000
  800086:	6a 00                	push   $0x0
  800088:	e8 1e 0f 00 00       	call   800fab <sys_page_unmap>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	85 c0                	test   %eax,%eax
  800092:	78 2b                	js     8000bf <duppage+0x8c>
		panic("sys_page_unmap: %e", r);
}
  800094:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800097:	5b                   	pop    %ebx
  800098:	5e                   	pop    %esi
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80009b:	50                   	push   %eax
  80009c:	68 00 27 80 00       	push   $0x802700
  8000a1:	6a 20                	push   $0x20
  8000a3:	68 13 27 80 00       	push   $0x802713
  8000a8:	e8 32 02 00 00       	call   8002df <_panic>
		panic("sys_page_map: %e", r);
  8000ad:	50                   	push   %eax
  8000ae:	68 23 27 80 00       	push   $0x802723
  8000b3:	6a 22                	push   $0x22
  8000b5:	68 13 27 80 00       	push   $0x802713
  8000ba:	e8 20 02 00 00       	call   8002df <_panic>
		panic("sys_page_unmap: %e", r);
  8000bf:	50                   	push   %eax
  8000c0:	68 34 27 80 00       	push   $0x802734
  8000c5:	6a 25                	push   $0x25
  8000c7:	68 13 27 80 00       	push   $0x802713
  8000cc:	e8 0e 02 00 00       	call   8002df <_panic>

008000d1 <dumbfork>:

envid_t
dumbfork(void)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 10             	sub    $0x10,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8000d9:	b8 07 00 00 00       	mov    $0x7,%eax
  8000de:	cd 30                	int    $0x30
  8000e0:	89 c3                	mov    %eax,%ebx
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8000e2:	85 c0                	test   %eax,%eax
  8000e4:	78 2c                	js     800112 <dumbfork+0x41>
  8000e6:	89 c6                	mov    %eax,%esi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8000e8:	74 3a                	je     800124 <dumbfork+0x53>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8000ea:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8000f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000f4:	81 fa 00 70 80 00    	cmp    $0x807000,%edx
  8000fa:	73 41                	jae    80013d <dumbfork+0x6c>
		duppage(envid, addr);
  8000fc:	83 ec 08             	sub    $0x8,%esp
  8000ff:	52                   	push   %edx
  800100:	56                   	push   %esi
  800101:	e8 2d ff ff ff       	call   800033 <duppage>
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  800106:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	eb df                	jmp    8000f1 <dumbfork+0x20>
		panic("sys_exofork: %e", envid);
  800112:	50                   	push   %eax
  800113:	68 47 27 80 00       	push   $0x802747
  800118:	6a 37                	push   $0x37
  80011a:	68 13 27 80 00       	push   $0x802713
  80011f:	e8 bb 01 00 00       	call   8002df <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  800124:	e8 bf 0d 00 00       	call   800ee8 <sys_getenvid>
  800129:	25 ff 03 00 00       	and    $0x3ff,%eax
  80012e:	c1 e0 07             	shl    $0x7,%eax
  800131:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800136:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  80013b:	eb 24                	jmp    800161 <dumbfork+0x90>

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  80013d:	83 ec 08             	sub    $0x8,%esp
  800140:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800143:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800148:	50                   	push   %eax
  800149:	53                   	push   %ebx
  80014a:	e8 e4 fe ff ff       	call   800033 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80014f:	83 c4 08             	add    $0x8,%esp
  800152:	6a 02                	push   $0x2
  800154:	53                   	push   %ebx
  800155:	e8 93 0e 00 00       	call   800fed <sys_env_set_status>
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	85 c0                	test   %eax,%eax
  80015f:	78 09                	js     80016a <dumbfork+0x99>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  800161:	89 d8                	mov    %ebx,%eax
  800163:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800166:	5b                   	pop    %ebx
  800167:	5e                   	pop    %esi
  800168:	5d                   	pop    %ebp
  800169:	c3                   	ret    
		panic("sys_env_set_status: %e", r);
  80016a:	50                   	push   %eax
  80016b:	68 57 27 80 00       	push   $0x802757
  800170:	6a 4c                	push   $0x4c
  800172:	68 13 27 80 00       	push   $0x802713
  800177:	e8 63 01 00 00       	call   8002df <_panic>

0080017c <umain>:
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	57                   	push   %edi
  800180:	56                   	push   %esi
  800181:	53                   	push   %ebx
  800182:	83 ec 0c             	sub    $0xc,%esp
	who = dumbfork();
  800185:	e8 47 ff ff ff       	call   8000d1 <dumbfork>
  80018a:	89 c7                	mov    %eax,%edi
  80018c:	85 c0                	test   %eax,%eax
  80018e:	be 6e 27 80 00       	mov    $0x80276e,%esi
  800193:	b8 75 27 80 00       	mov    $0x802775,%eax
  800198:	0f 44 f0             	cmove  %eax,%esi
	for (i = 0; i < (who ? 10 : 20); i++) {
  80019b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001a0:	eb 1f                	jmp    8001c1 <umain+0x45>
  8001a2:	83 fb 13             	cmp    $0x13,%ebx
  8001a5:	7f 23                	jg     8001ca <umain+0x4e>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  8001a7:	83 ec 04             	sub    $0x4,%esp
  8001aa:	56                   	push   %esi
  8001ab:	53                   	push   %ebx
  8001ac:	68 7b 27 80 00       	push   $0x80277b
  8001b1:	e8 1f 02 00 00       	call   8003d5 <cprintf>
		sys_yield();
  8001b6:	e8 4c 0d 00 00       	call   800f07 <sys_yield>
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001bb:	83 c3 01             	add    $0x1,%ebx
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	85 ff                	test   %edi,%edi
  8001c3:	74 dd                	je     8001a2 <umain+0x26>
  8001c5:	83 fb 09             	cmp    $0x9,%ebx
  8001c8:	7e dd                	jle    8001a7 <umain+0x2b>
}
  8001ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cd:	5b                   	pop    %ebx
  8001ce:	5e                   	pop    %esi
  8001cf:	5f                   	pop    %edi
  8001d0:	5d                   	pop    %ebp
  8001d1:	c3                   	ret    

008001d2 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	57                   	push   %edi
  8001d6:	56                   	push   %esi
  8001d7:	53                   	push   %ebx
  8001d8:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8001db:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8001e2:	00 00 00 
	envid_t find = sys_getenvid();
  8001e5:	e8 fe 0c 00 00       	call   800ee8 <sys_getenvid>
  8001ea:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8001f0:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8001f5:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8001fa:	bf 01 00 00 00       	mov    $0x1,%edi
  8001ff:	eb 0b                	jmp    80020c <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800201:	83 c2 01             	add    $0x1,%edx
  800204:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80020a:	74 21                	je     80022d <libmain+0x5b>
		if(envs[i].env_id == find)
  80020c:	89 d1                	mov    %edx,%ecx
  80020e:	c1 e1 07             	shl    $0x7,%ecx
  800211:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800217:	8b 49 48             	mov    0x48(%ecx),%ecx
  80021a:	39 c1                	cmp    %eax,%ecx
  80021c:	75 e3                	jne    800201 <libmain+0x2f>
  80021e:	89 d3                	mov    %edx,%ebx
  800220:	c1 e3 07             	shl    $0x7,%ebx
  800223:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800229:	89 fe                	mov    %edi,%esi
  80022b:	eb d4                	jmp    800201 <libmain+0x2f>
  80022d:	89 f0                	mov    %esi,%eax
  80022f:	84 c0                	test   %al,%al
  800231:	74 06                	je     800239 <libmain+0x67>
  800233:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80023d:	7e 0a                	jle    800249 <libmain+0x77>
		binaryname = argv[0];
  80023f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800242:	8b 00                	mov    (%eax),%eax
  800244:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800249:	a1 08 40 80 00       	mov    0x804008,%eax
  80024e:	8b 40 48             	mov    0x48(%eax),%eax
  800251:	83 ec 08             	sub    $0x8,%esp
  800254:	50                   	push   %eax
  800255:	68 8d 27 80 00       	push   $0x80278d
  80025a:	e8 76 01 00 00       	call   8003d5 <cprintf>
	cprintf("before umain\n");
  80025f:	c7 04 24 ab 27 80 00 	movl   $0x8027ab,(%esp)
  800266:	e8 6a 01 00 00       	call   8003d5 <cprintf>
	// call user main routine
	umain(argc, argv);
  80026b:	83 c4 08             	add    $0x8,%esp
  80026e:	ff 75 0c             	pushl  0xc(%ebp)
  800271:	ff 75 08             	pushl  0x8(%ebp)
  800274:	e8 03 ff ff ff       	call   80017c <umain>
	cprintf("after umain\n");
  800279:	c7 04 24 b9 27 80 00 	movl   $0x8027b9,(%esp)
  800280:	e8 50 01 00 00       	call   8003d5 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800285:	a1 08 40 80 00       	mov    0x804008,%eax
  80028a:	8b 40 48             	mov    0x48(%eax),%eax
  80028d:	83 c4 08             	add    $0x8,%esp
  800290:	50                   	push   %eax
  800291:	68 c6 27 80 00       	push   $0x8027c6
  800296:	e8 3a 01 00 00       	call   8003d5 <cprintf>
	// exit gracefully
	exit();
  80029b:	e8 0b 00 00 00       	call   8002ab <exit>
}
  8002a0:	83 c4 10             	add    $0x10,%esp
  8002a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a6:	5b                   	pop    %ebx
  8002a7:	5e                   	pop    %esi
  8002a8:	5f                   	pop    %edi
  8002a9:	5d                   	pop    %ebp
  8002aa:	c3                   	ret    

008002ab <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
  8002ae:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002b1:	a1 08 40 80 00       	mov    0x804008,%eax
  8002b6:	8b 40 48             	mov    0x48(%eax),%eax
  8002b9:	68 f0 27 80 00       	push   $0x8027f0
  8002be:	50                   	push   %eax
  8002bf:	68 e5 27 80 00       	push   $0x8027e5
  8002c4:	e8 0c 01 00 00       	call   8003d5 <cprintf>
	close_all();
  8002c9:	e8 25 11 00 00       	call   8013f3 <close_all>
	sys_env_destroy(0);
  8002ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002d5:	e8 cd 0b 00 00       	call   800ea7 <sys_env_destroy>
}
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	c9                   	leave  
  8002de:	c3                   	ret    

008002df <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	56                   	push   %esi
  8002e3:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8002e4:	a1 08 40 80 00       	mov    0x804008,%eax
  8002e9:	8b 40 48             	mov    0x48(%eax),%eax
  8002ec:	83 ec 04             	sub    $0x4,%esp
  8002ef:	68 1c 28 80 00       	push   $0x80281c
  8002f4:	50                   	push   %eax
  8002f5:	68 e5 27 80 00       	push   $0x8027e5
  8002fa:	e8 d6 00 00 00       	call   8003d5 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8002ff:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800302:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800308:	e8 db 0b 00 00       	call   800ee8 <sys_getenvid>
  80030d:	83 c4 04             	add    $0x4,%esp
  800310:	ff 75 0c             	pushl  0xc(%ebp)
  800313:	ff 75 08             	pushl  0x8(%ebp)
  800316:	56                   	push   %esi
  800317:	50                   	push   %eax
  800318:	68 f8 27 80 00       	push   $0x8027f8
  80031d:	e8 b3 00 00 00       	call   8003d5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800322:	83 c4 18             	add    $0x18,%esp
  800325:	53                   	push   %ebx
  800326:	ff 75 10             	pushl  0x10(%ebp)
  800329:	e8 56 00 00 00       	call   800384 <vcprintf>
	cprintf("\n");
  80032e:	c7 04 24 a9 27 80 00 	movl   $0x8027a9,(%esp)
  800335:	e8 9b 00 00 00       	call   8003d5 <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80033d:	cc                   	int3   
  80033e:	eb fd                	jmp    80033d <_panic+0x5e>

00800340 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	53                   	push   %ebx
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80034a:	8b 13                	mov    (%ebx),%edx
  80034c:	8d 42 01             	lea    0x1(%edx),%eax
  80034f:	89 03                	mov    %eax,(%ebx)
  800351:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800354:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800358:	3d ff 00 00 00       	cmp    $0xff,%eax
  80035d:	74 09                	je     800368 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80035f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800363:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800366:	c9                   	leave  
  800367:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	68 ff 00 00 00       	push   $0xff
  800370:	8d 43 08             	lea    0x8(%ebx),%eax
  800373:	50                   	push   %eax
  800374:	e8 f1 0a 00 00       	call   800e6a <sys_cputs>
		b->idx = 0;
  800379:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80037f:	83 c4 10             	add    $0x10,%esp
  800382:	eb db                	jmp    80035f <putch+0x1f>

00800384 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80038d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800394:	00 00 00 
	b.cnt = 0;
  800397:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80039e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003a1:	ff 75 0c             	pushl  0xc(%ebp)
  8003a4:	ff 75 08             	pushl  0x8(%ebp)
  8003a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ad:	50                   	push   %eax
  8003ae:	68 40 03 80 00       	push   $0x800340
  8003b3:	e8 4a 01 00 00       	call   800502 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003b8:	83 c4 08             	add    $0x8,%esp
  8003bb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003c1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 9d 0a 00 00       	call   800e6a <sys_cputs>

	return b.cnt;
}
  8003cd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003d3:	c9                   	leave  
  8003d4:	c3                   	ret    

008003d5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003d5:	55                   	push   %ebp
  8003d6:	89 e5                	mov    %esp,%ebp
  8003d8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003db:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003de:	50                   	push   %eax
  8003df:	ff 75 08             	pushl  0x8(%ebp)
  8003e2:	e8 9d ff ff ff       	call   800384 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003e7:	c9                   	leave  
  8003e8:	c3                   	ret    

008003e9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	57                   	push   %edi
  8003ed:	56                   	push   %esi
  8003ee:	53                   	push   %ebx
  8003ef:	83 ec 1c             	sub    $0x1c,%esp
  8003f2:	89 c6                	mov    %eax,%esi
  8003f4:	89 d7                	mov    %edx,%edi
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800402:	8b 45 10             	mov    0x10(%ebp),%eax
  800405:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800408:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80040c:	74 2c                	je     80043a <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80040e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800411:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800418:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80041b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80041e:	39 c2                	cmp    %eax,%edx
  800420:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800423:	73 43                	jae    800468 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800425:	83 eb 01             	sub    $0x1,%ebx
  800428:	85 db                	test   %ebx,%ebx
  80042a:	7e 6c                	jle    800498 <printnum+0xaf>
				putch(padc, putdat);
  80042c:	83 ec 08             	sub    $0x8,%esp
  80042f:	57                   	push   %edi
  800430:	ff 75 18             	pushl  0x18(%ebp)
  800433:	ff d6                	call   *%esi
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	eb eb                	jmp    800425 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80043a:	83 ec 0c             	sub    $0xc,%esp
  80043d:	6a 20                	push   $0x20
  80043f:	6a 00                	push   $0x0
  800441:	50                   	push   %eax
  800442:	ff 75 e4             	pushl  -0x1c(%ebp)
  800445:	ff 75 e0             	pushl  -0x20(%ebp)
  800448:	89 fa                	mov    %edi,%edx
  80044a:	89 f0                	mov    %esi,%eax
  80044c:	e8 98 ff ff ff       	call   8003e9 <printnum>
		while (--width > 0)
  800451:	83 c4 20             	add    $0x20,%esp
  800454:	83 eb 01             	sub    $0x1,%ebx
  800457:	85 db                	test   %ebx,%ebx
  800459:	7e 65                	jle    8004c0 <printnum+0xd7>
			putch(padc, putdat);
  80045b:	83 ec 08             	sub    $0x8,%esp
  80045e:	57                   	push   %edi
  80045f:	6a 20                	push   $0x20
  800461:	ff d6                	call   *%esi
  800463:	83 c4 10             	add    $0x10,%esp
  800466:	eb ec                	jmp    800454 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800468:	83 ec 0c             	sub    $0xc,%esp
  80046b:	ff 75 18             	pushl  0x18(%ebp)
  80046e:	83 eb 01             	sub    $0x1,%ebx
  800471:	53                   	push   %ebx
  800472:	50                   	push   %eax
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	ff 75 dc             	pushl  -0x24(%ebp)
  800479:	ff 75 d8             	pushl  -0x28(%ebp)
  80047c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80047f:	ff 75 e0             	pushl  -0x20(%ebp)
  800482:	e8 29 20 00 00       	call   8024b0 <__udivdi3>
  800487:	83 c4 18             	add    $0x18,%esp
  80048a:	52                   	push   %edx
  80048b:	50                   	push   %eax
  80048c:	89 fa                	mov    %edi,%edx
  80048e:	89 f0                	mov    %esi,%eax
  800490:	e8 54 ff ff ff       	call   8003e9 <printnum>
  800495:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	57                   	push   %edi
  80049c:	83 ec 04             	sub    $0x4,%esp
  80049f:	ff 75 dc             	pushl  -0x24(%ebp)
  8004a2:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a8:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ab:	e8 10 21 00 00       	call   8025c0 <__umoddi3>
  8004b0:	83 c4 14             	add    $0x14,%esp
  8004b3:	0f be 80 23 28 80 00 	movsbl 0x802823(%eax),%eax
  8004ba:	50                   	push   %eax
  8004bb:	ff d6                	call   *%esi
  8004bd:	83 c4 10             	add    $0x10,%esp
	}
}
  8004c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004c3:	5b                   	pop    %ebx
  8004c4:	5e                   	pop    %esi
  8004c5:	5f                   	pop    %edi
  8004c6:	5d                   	pop    %ebp
  8004c7:	c3                   	ret    

008004c8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004ce:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004d2:	8b 10                	mov    (%eax),%edx
  8004d4:	3b 50 04             	cmp    0x4(%eax),%edx
  8004d7:	73 0a                	jae    8004e3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004dc:	89 08                	mov    %ecx,(%eax)
  8004de:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e1:	88 02                	mov    %al,(%edx)
}
  8004e3:	5d                   	pop    %ebp
  8004e4:	c3                   	ret    

008004e5 <printfmt>:
{
  8004e5:	55                   	push   %ebp
  8004e6:	89 e5                	mov    %esp,%ebp
  8004e8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004eb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004ee:	50                   	push   %eax
  8004ef:	ff 75 10             	pushl  0x10(%ebp)
  8004f2:	ff 75 0c             	pushl  0xc(%ebp)
  8004f5:	ff 75 08             	pushl  0x8(%ebp)
  8004f8:	e8 05 00 00 00       	call   800502 <vprintfmt>
}
  8004fd:	83 c4 10             	add    $0x10,%esp
  800500:	c9                   	leave  
  800501:	c3                   	ret    

00800502 <vprintfmt>:
{
  800502:	55                   	push   %ebp
  800503:	89 e5                	mov    %esp,%ebp
  800505:	57                   	push   %edi
  800506:	56                   	push   %esi
  800507:	53                   	push   %ebx
  800508:	83 ec 3c             	sub    $0x3c,%esp
  80050b:	8b 75 08             	mov    0x8(%ebp),%esi
  80050e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800511:	8b 7d 10             	mov    0x10(%ebp),%edi
  800514:	e9 32 04 00 00       	jmp    80094b <vprintfmt+0x449>
		padc = ' ';
  800519:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80051d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800524:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80052b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800532:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800539:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800540:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800545:	8d 47 01             	lea    0x1(%edi),%eax
  800548:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80054b:	0f b6 17             	movzbl (%edi),%edx
  80054e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800551:	3c 55                	cmp    $0x55,%al
  800553:	0f 87 12 05 00 00    	ja     800a6b <vprintfmt+0x569>
  800559:	0f b6 c0             	movzbl %al,%eax
  80055c:	ff 24 85 00 2a 80 00 	jmp    *0x802a00(,%eax,4)
  800563:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800566:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80056a:	eb d9                	jmp    800545 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80056c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80056f:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800573:	eb d0                	jmp    800545 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800575:	0f b6 d2             	movzbl %dl,%edx
  800578:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80057b:	b8 00 00 00 00       	mov    $0x0,%eax
  800580:	89 75 08             	mov    %esi,0x8(%ebp)
  800583:	eb 03                	jmp    800588 <vprintfmt+0x86>
  800585:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800588:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80058b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80058f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800592:	8d 72 d0             	lea    -0x30(%edx),%esi
  800595:	83 fe 09             	cmp    $0x9,%esi
  800598:	76 eb                	jbe    800585 <vprintfmt+0x83>
  80059a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059d:	8b 75 08             	mov    0x8(%ebp),%esi
  8005a0:	eb 14                	jmp    8005b6 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 40 04             	lea    0x4(%eax),%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005ba:	79 89                	jns    800545 <vprintfmt+0x43>
				width = precision, precision = -1;
  8005bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005c9:	e9 77 ff ff ff       	jmp    800545 <vprintfmt+0x43>
  8005ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d1:	85 c0                	test   %eax,%eax
  8005d3:	0f 48 c1             	cmovs  %ecx,%eax
  8005d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005dc:	e9 64 ff ff ff       	jmp    800545 <vprintfmt+0x43>
  8005e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005e4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8005eb:	e9 55 ff ff ff       	jmp    800545 <vprintfmt+0x43>
			lflag++;
  8005f0:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005f7:	e9 49 ff ff ff       	jmp    800545 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8d 78 04             	lea    0x4(%eax),%edi
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	53                   	push   %ebx
  800606:	ff 30                	pushl  (%eax)
  800608:	ff d6                	call   *%esi
			break;
  80060a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80060d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800610:	e9 33 03 00 00       	jmp    800948 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8d 78 04             	lea    0x4(%eax),%edi
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	99                   	cltd   
  80061e:	31 d0                	xor    %edx,%eax
  800620:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800622:	83 f8 11             	cmp    $0x11,%eax
  800625:	7f 23                	jg     80064a <vprintfmt+0x148>
  800627:	8b 14 85 60 2b 80 00 	mov    0x802b60(,%eax,4),%edx
  80062e:	85 d2                	test   %edx,%edx
  800630:	74 18                	je     80064a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800632:	52                   	push   %edx
  800633:	68 81 2c 80 00       	push   $0x802c81
  800638:	53                   	push   %ebx
  800639:	56                   	push   %esi
  80063a:	e8 a6 fe ff ff       	call   8004e5 <printfmt>
  80063f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800642:	89 7d 14             	mov    %edi,0x14(%ebp)
  800645:	e9 fe 02 00 00       	jmp    800948 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80064a:	50                   	push   %eax
  80064b:	68 3b 28 80 00       	push   $0x80283b
  800650:	53                   	push   %ebx
  800651:	56                   	push   %esi
  800652:	e8 8e fe ff ff       	call   8004e5 <printfmt>
  800657:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80065a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80065d:	e9 e6 02 00 00       	jmp    800948 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	83 c0 04             	add    $0x4,%eax
  800668:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800670:	85 c9                	test   %ecx,%ecx
  800672:	b8 34 28 80 00       	mov    $0x802834,%eax
  800677:	0f 45 c1             	cmovne %ecx,%eax
  80067a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80067d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800681:	7e 06                	jle    800689 <vprintfmt+0x187>
  800683:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800687:	75 0d                	jne    800696 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800689:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80068c:	89 c7                	mov    %eax,%edi
  80068e:	03 45 e0             	add    -0x20(%ebp),%eax
  800691:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800694:	eb 53                	jmp    8006e9 <vprintfmt+0x1e7>
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	ff 75 d8             	pushl  -0x28(%ebp)
  80069c:	50                   	push   %eax
  80069d:	e8 71 04 00 00       	call   800b13 <strnlen>
  8006a2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006a5:	29 c1                	sub    %eax,%ecx
  8006a7:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8006aa:	83 c4 10             	add    $0x10,%esp
  8006ad:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8006af:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b6:	eb 0f                	jmp    8006c7 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	53                   	push   %ebx
  8006bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8006bf:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c1:	83 ef 01             	sub    $0x1,%edi
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	85 ff                	test   %edi,%edi
  8006c9:	7f ed                	jg     8006b8 <vprintfmt+0x1b6>
  8006cb:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8006ce:	85 c9                	test   %ecx,%ecx
  8006d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d5:	0f 49 c1             	cmovns %ecx,%eax
  8006d8:	29 c1                	sub    %eax,%ecx
  8006da:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8006dd:	eb aa                	jmp    800689 <vprintfmt+0x187>
					putch(ch, putdat);
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	53                   	push   %ebx
  8006e3:	52                   	push   %edx
  8006e4:	ff d6                	call   *%esi
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006ec:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ee:	83 c7 01             	add    $0x1,%edi
  8006f1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006f5:	0f be d0             	movsbl %al,%edx
  8006f8:	85 d2                	test   %edx,%edx
  8006fa:	74 4b                	je     800747 <vprintfmt+0x245>
  8006fc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800700:	78 06                	js     800708 <vprintfmt+0x206>
  800702:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800706:	78 1e                	js     800726 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800708:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80070c:	74 d1                	je     8006df <vprintfmt+0x1dd>
  80070e:	0f be c0             	movsbl %al,%eax
  800711:	83 e8 20             	sub    $0x20,%eax
  800714:	83 f8 5e             	cmp    $0x5e,%eax
  800717:	76 c6                	jbe    8006df <vprintfmt+0x1dd>
					putch('?', putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	53                   	push   %ebx
  80071d:	6a 3f                	push   $0x3f
  80071f:	ff d6                	call   *%esi
  800721:	83 c4 10             	add    $0x10,%esp
  800724:	eb c3                	jmp    8006e9 <vprintfmt+0x1e7>
  800726:	89 cf                	mov    %ecx,%edi
  800728:	eb 0e                	jmp    800738 <vprintfmt+0x236>
				putch(' ', putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	53                   	push   %ebx
  80072e:	6a 20                	push   $0x20
  800730:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800732:	83 ef 01             	sub    $0x1,%edi
  800735:	83 c4 10             	add    $0x10,%esp
  800738:	85 ff                	test   %edi,%edi
  80073a:	7f ee                	jg     80072a <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80073c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
  800742:	e9 01 02 00 00       	jmp    800948 <vprintfmt+0x446>
  800747:	89 cf                	mov    %ecx,%edi
  800749:	eb ed                	jmp    800738 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80074b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80074e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800755:	e9 eb fd ff ff       	jmp    800545 <vprintfmt+0x43>
	if (lflag >= 2)
  80075a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80075e:	7f 21                	jg     800781 <vprintfmt+0x27f>
	else if (lflag)
  800760:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800764:	74 68                	je     8007ce <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80076e:	89 c1                	mov    %eax,%ecx
  800770:	c1 f9 1f             	sar    $0x1f,%ecx
  800773:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8d 40 04             	lea    0x4(%eax),%eax
  80077c:	89 45 14             	mov    %eax,0x14(%ebp)
  80077f:	eb 17                	jmp    800798 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 50 04             	mov    0x4(%eax),%edx
  800787:	8b 00                	mov    (%eax),%eax
  800789:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80078c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8d 40 08             	lea    0x8(%eax),%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800798:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80079e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8007a4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007a8:	78 3f                	js     8007e9 <vprintfmt+0x2e7>
			base = 10;
  8007aa:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8007af:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8007b3:	0f 84 71 01 00 00    	je     80092a <vprintfmt+0x428>
				putch('+', putdat);
  8007b9:	83 ec 08             	sub    $0x8,%esp
  8007bc:	53                   	push   %ebx
  8007bd:	6a 2b                	push   $0x2b
  8007bf:	ff d6                	call   *%esi
  8007c1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c9:	e9 5c 01 00 00       	jmp    80092a <vprintfmt+0x428>
		return va_arg(*ap, int);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007d6:	89 c1                	mov    %eax,%ecx
  8007d8:	c1 f9 1f             	sar    $0x1f,%ecx
  8007db:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8d 40 04             	lea    0x4(%eax),%eax
  8007e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e7:	eb af                	jmp    800798 <vprintfmt+0x296>
				putch('-', putdat);
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	53                   	push   %ebx
  8007ed:	6a 2d                	push   $0x2d
  8007ef:	ff d6                	call   *%esi
				num = -(long long) num;
  8007f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007f7:	f7 d8                	neg    %eax
  8007f9:	83 d2 00             	adc    $0x0,%edx
  8007fc:	f7 da                	neg    %edx
  8007fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800801:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800804:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800807:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080c:	e9 19 01 00 00       	jmp    80092a <vprintfmt+0x428>
	if (lflag >= 2)
  800811:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800815:	7f 29                	jg     800840 <vprintfmt+0x33e>
	else if (lflag)
  800817:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80081b:	74 44                	je     800861 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	ba 00 00 00 00       	mov    $0x0,%edx
  800827:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8d 40 04             	lea    0x4(%eax),%eax
  800833:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800836:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083b:	e9 ea 00 00 00       	jmp    80092a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	8b 50 04             	mov    0x4(%eax),%edx
  800846:	8b 00                	mov    (%eax),%eax
  800848:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	8d 40 08             	lea    0x8(%eax),%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800857:	b8 0a 00 00 00       	mov    $0xa,%eax
  80085c:	e9 c9 00 00 00       	jmp    80092a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	8b 00                	mov    (%eax),%eax
  800866:	ba 00 00 00 00       	mov    $0x0,%edx
  80086b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	8d 40 04             	lea    0x4(%eax),%eax
  800877:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80087a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80087f:	e9 a6 00 00 00       	jmp    80092a <vprintfmt+0x428>
			putch('0', putdat);
  800884:	83 ec 08             	sub    $0x8,%esp
  800887:	53                   	push   %ebx
  800888:	6a 30                	push   $0x30
  80088a:	ff d6                	call   *%esi
	if (lflag >= 2)
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800893:	7f 26                	jg     8008bb <vprintfmt+0x3b9>
	else if (lflag)
  800895:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800899:	74 3e                	je     8008d9 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	8b 00                	mov    (%eax),%eax
  8008a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ae:	8d 40 04             	lea    0x4(%eax),%eax
  8008b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008b4:	b8 08 00 00 00       	mov    $0x8,%eax
  8008b9:	eb 6f                	jmp    80092a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	8b 50 04             	mov    0x4(%eax),%edx
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	8d 40 08             	lea    0x8(%eax),%eax
  8008cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008d2:	b8 08 00 00 00       	mov    $0x8,%eax
  8008d7:	eb 51                	jmp    80092a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	8d 40 04             	lea    0x4(%eax),%eax
  8008ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8008f7:	eb 31                	jmp    80092a <vprintfmt+0x428>
			putch('0', putdat);
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	53                   	push   %ebx
  8008fd:	6a 30                	push   $0x30
  8008ff:	ff d6                	call   *%esi
			putch('x', putdat);
  800901:	83 c4 08             	add    $0x8,%esp
  800904:	53                   	push   %ebx
  800905:	6a 78                	push   $0x78
  800907:	ff d6                	call   *%esi
			num = (unsigned long long)
  800909:	8b 45 14             	mov    0x14(%ebp),%eax
  80090c:	8b 00                	mov    (%eax),%eax
  80090e:	ba 00 00 00 00       	mov    $0x0,%edx
  800913:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800916:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800919:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80091c:	8b 45 14             	mov    0x14(%ebp),%eax
  80091f:	8d 40 04             	lea    0x4(%eax),%eax
  800922:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800925:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80092a:	83 ec 0c             	sub    $0xc,%esp
  80092d:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800931:	52                   	push   %edx
  800932:	ff 75 e0             	pushl  -0x20(%ebp)
  800935:	50                   	push   %eax
  800936:	ff 75 dc             	pushl  -0x24(%ebp)
  800939:	ff 75 d8             	pushl  -0x28(%ebp)
  80093c:	89 da                	mov    %ebx,%edx
  80093e:	89 f0                	mov    %esi,%eax
  800940:	e8 a4 fa ff ff       	call   8003e9 <printnum>
			break;
  800945:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800948:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80094b:	83 c7 01             	add    $0x1,%edi
  80094e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800952:	83 f8 25             	cmp    $0x25,%eax
  800955:	0f 84 be fb ff ff    	je     800519 <vprintfmt+0x17>
			if (ch == '\0')
  80095b:	85 c0                	test   %eax,%eax
  80095d:	0f 84 28 01 00 00    	je     800a8b <vprintfmt+0x589>
			putch(ch, putdat);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	53                   	push   %ebx
  800967:	50                   	push   %eax
  800968:	ff d6                	call   *%esi
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	eb dc                	jmp    80094b <vprintfmt+0x449>
	if (lflag >= 2)
  80096f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800973:	7f 26                	jg     80099b <vprintfmt+0x499>
	else if (lflag)
  800975:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800979:	74 41                	je     8009bc <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80097b:	8b 45 14             	mov    0x14(%ebp),%eax
  80097e:	8b 00                	mov    (%eax),%eax
  800980:	ba 00 00 00 00       	mov    $0x0,%edx
  800985:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800988:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80098b:	8b 45 14             	mov    0x14(%ebp),%eax
  80098e:	8d 40 04             	lea    0x4(%eax),%eax
  800991:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800994:	b8 10 00 00 00       	mov    $0x10,%eax
  800999:	eb 8f                	jmp    80092a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80099b:	8b 45 14             	mov    0x14(%ebp),%eax
  80099e:	8b 50 04             	mov    0x4(%eax),%edx
  8009a1:	8b 00                	mov    (%eax),%eax
  8009a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ac:	8d 40 08             	lea    0x8(%eax),%eax
  8009af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009b2:	b8 10 00 00 00       	mov    $0x10,%eax
  8009b7:	e9 6e ff ff ff       	jmp    80092a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8009bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bf:	8b 00                	mov    (%eax),%eax
  8009c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cf:	8d 40 04             	lea    0x4(%eax),%eax
  8009d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009d5:	b8 10 00 00 00       	mov    $0x10,%eax
  8009da:	e9 4b ff ff ff       	jmp    80092a <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8009df:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e2:	83 c0 04             	add    $0x4,%eax
  8009e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	85 c0                	test   %eax,%eax
  8009ef:	74 14                	je     800a05 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8009f1:	8b 13                	mov    (%ebx),%edx
  8009f3:	83 fa 7f             	cmp    $0x7f,%edx
  8009f6:	7f 37                	jg     800a2f <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8009f8:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8009fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800a00:	e9 43 ff ff ff       	jmp    800948 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800a05:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a0a:	bf 59 29 80 00       	mov    $0x802959,%edi
							putch(ch, putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	53                   	push   %ebx
  800a13:	50                   	push   %eax
  800a14:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a16:	83 c7 01             	add    $0x1,%edi
  800a19:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a1d:	83 c4 10             	add    $0x10,%esp
  800a20:	85 c0                	test   %eax,%eax
  800a22:	75 eb                	jne    800a0f <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800a24:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a27:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2a:	e9 19 ff ff ff       	jmp    800948 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800a2f:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800a31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a36:	bf 91 29 80 00       	mov    $0x802991,%edi
							putch(ch, putdat);
  800a3b:	83 ec 08             	sub    $0x8,%esp
  800a3e:	53                   	push   %ebx
  800a3f:	50                   	push   %eax
  800a40:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800a42:	83 c7 01             	add    $0x1,%edi
  800a45:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800a49:	83 c4 10             	add    $0x10,%esp
  800a4c:	85 c0                	test   %eax,%eax
  800a4e:	75 eb                	jne    800a3b <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800a50:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a53:	89 45 14             	mov    %eax,0x14(%ebp)
  800a56:	e9 ed fe ff ff       	jmp    800948 <vprintfmt+0x446>
			putch(ch, putdat);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	53                   	push   %ebx
  800a5f:	6a 25                	push   $0x25
  800a61:	ff d6                	call   *%esi
			break;
  800a63:	83 c4 10             	add    $0x10,%esp
  800a66:	e9 dd fe ff ff       	jmp    800948 <vprintfmt+0x446>
			putch('%', putdat);
  800a6b:	83 ec 08             	sub    $0x8,%esp
  800a6e:	53                   	push   %ebx
  800a6f:	6a 25                	push   $0x25
  800a71:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a73:	83 c4 10             	add    $0x10,%esp
  800a76:	89 f8                	mov    %edi,%eax
  800a78:	eb 03                	jmp    800a7d <vprintfmt+0x57b>
  800a7a:	83 e8 01             	sub    $0x1,%eax
  800a7d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a81:	75 f7                	jne    800a7a <vprintfmt+0x578>
  800a83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a86:	e9 bd fe ff ff       	jmp    800948 <vprintfmt+0x446>
}
  800a8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a8e:	5b                   	pop    %ebx
  800a8f:	5e                   	pop    %esi
  800a90:	5f                   	pop    %edi
  800a91:	5d                   	pop    %ebp
  800a92:	c3                   	ret    

00800a93 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	83 ec 18             	sub    $0x18,%esp
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800aa2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800aa6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800aa9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ab0:	85 c0                	test   %eax,%eax
  800ab2:	74 26                	je     800ada <vsnprintf+0x47>
  800ab4:	85 d2                	test   %edx,%edx
  800ab6:	7e 22                	jle    800ada <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ab8:	ff 75 14             	pushl  0x14(%ebp)
  800abb:	ff 75 10             	pushl  0x10(%ebp)
  800abe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ac1:	50                   	push   %eax
  800ac2:	68 c8 04 80 00       	push   $0x8004c8
  800ac7:	e8 36 fa ff ff       	call   800502 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800acc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800acf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ad5:	83 c4 10             	add    $0x10,%esp
}
  800ad8:	c9                   	leave  
  800ad9:	c3                   	ret    
		return -E_INVAL;
  800ada:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800adf:	eb f7                	jmp    800ad8 <vsnprintf+0x45>

00800ae1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ae7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800aea:	50                   	push   %eax
  800aeb:	ff 75 10             	pushl  0x10(%ebp)
  800aee:	ff 75 0c             	pushl  0xc(%ebp)
  800af1:	ff 75 08             	pushl  0x8(%ebp)
  800af4:	e8 9a ff ff ff       	call   800a93 <vsnprintf>
	va_end(ap);

	return rc;
}
  800af9:	c9                   	leave  
  800afa:	c3                   	ret    

00800afb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b01:	b8 00 00 00 00       	mov    $0x0,%eax
  800b06:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b0a:	74 05                	je     800b11 <strlen+0x16>
		n++;
  800b0c:	83 c0 01             	add    $0x1,%eax
  800b0f:	eb f5                	jmp    800b06 <strlen+0xb>
	return n;
}
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b19:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b21:	39 c2                	cmp    %eax,%edx
  800b23:	74 0d                	je     800b32 <strnlen+0x1f>
  800b25:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800b29:	74 05                	je     800b30 <strnlen+0x1d>
		n++;
  800b2b:	83 c2 01             	add    $0x1,%edx
  800b2e:	eb f1                	jmp    800b21 <strnlen+0xe>
  800b30:	89 d0                	mov    %edx,%eax
	return n;
}
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	53                   	push   %ebx
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b43:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b47:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b4a:	83 c2 01             	add    $0x1,%edx
  800b4d:	84 c9                	test   %cl,%cl
  800b4f:	75 f2                	jne    800b43 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b51:	5b                   	pop    %ebx
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    

00800b54 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	53                   	push   %ebx
  800b58:	83 ec 10             	sub    $0x10,%esp
  800b5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b5e:	53                   	push   %ebx
  800b5f:	e8 97 ff ff ff       	call   800afb <strlen>
  800b64:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b67:	ff 75 0c             	pushl  0xc(%ebp)
  800b6a:	01 d8                	add    %ebx,%eax
  800b6c:	50                   	push   %eax
  800b6d:	e8 c2 ff ff ff       	call   800b34 <strcpy>
	return dst;
}
  800b72:	89 d8                	mov    %ebx,%eax
  800b74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b77:	c9                   	leave  
  800b78:	c3                   	ret    

00800b79 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	56                   	push   %esi
  800b7d:	53                   	push   %ebx
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b84:	89 c6                	mov    %eax,%esi
  800b86:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b89:	89 c2                	mov    %eax,%edx
  800b8b:	39 f2                	cmp    %esi,%edx
  800b8d:	74 11                	je     800ba0 <strncpy+0x27>
		*dst++ = *src;
  800b8f:	83 c2 01             	add    $0x1,%edx
  800b92:	0f b6 19             	movzbl (%ecx),%ebx
  800b95:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b98:	80 fb 01             	cmp    $0x1,%bl
  800b9b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b9e:	eb eb                	jmp    800b8b <strncpy+0x12>
	}
	return ret;
}
  800ba0:	5b                   	pop    %ebx
  800ba1:	5e                   	pop    %esi
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	56                   	push   %esi
  800ba8:	53                   	push   %ebx
  800ba9:	8b 75 08             	mov    0x8(%ebp),%esi
  800bac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800baf:	8b 55 10             	mov    0x10(%ebp),%edx
  800bb2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bb4:	85 d2                	test   %edx,%edx
  800bb6:	74 21                	je     800bd9 <strlcpy+0x35>
  800bb8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bbc:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800bbe:	39 c2                	cmp    %eax,%edx
  800bc0:	74 14                	je     800bd6 <strlcpy+0x32>
  800bc2:	0f b6 19             	movzbl (%ecx),%ebx
  800bc5:	84 db                	test   %bl,%bl
  800bc7:	74 0b                	je     800bd4 <strlcpy+0x30>
			*dst++ = *src++;
  800bc9:	83 c1 01             	add    $0x1,%ecx
  800bcc:	83 c2 01             	add    $0x1,%edx
  800bcf:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bd2:	eb ea                	jmp    800bbe <strlcpy+0x1a>
  800bd4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800bd6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bd9:	29 f0                	sub    %esi,%eax
}
  800bdb:	5b                   	pop    %ebx
  800bdc:	5e                   	pop    %esi
  800bdd:	5d                   	pop    %ebp
  800bde:	c3                   	ret    

00800bdf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800be8:	0f b6 01             	movzbl (%ecx),%eax
  800beb:	84 c0                	test   %al,%al
  800bed:	74 0c                	je     800bfb <strcmp+0x1c>
  800bef:	3a 02                	cmp    (%edx),%al
  800bf1:	75 08                	jne    800bfb <strcmp+0x1c>
		p++, q++;
  800bf3:	83 c1 01             	add    $0x1,%ecx
  800bf6:	83 c2 01             	add    $0x1,%edx
  800bf9:	eb ed                	jmp    800be8 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bfb:	0f b6 c0             	movzbl %al,%eax
  800bfe:	0f b6 12             	movzbl (%edx),%edx
  800c01:	29 d0                	sub    %edx,%eax
}
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	53                   	push   %ebx
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0f:	89 c3                	mov    %eax,%ebx
  800c11:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c14:	eb 06                	jmp    800c1c <strncmp+0x17>
		n--, p++, q++;
  800c16:	83 c0 01             	add    $0x1,%eax
  800c19:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c1c:	39 d8                	cmp    %ebx,%eax
  800c1e:	74 16                	je     800c36 <strncmp+0x31>
  800c20:	0f b6 08             	movzbl (%eax),%ecx
  800c23:	84 c9                	test   %cl,%cl
  800c25:	74 04                	je     800c2b <strncmp+0x26>
  800c27:	3a 0a                	cmp    (%edx),%cl
  800c29:	74 eb                	je     800c16 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c2b:	0f b6 00             	movzbl (%eax),%eax
  800c2e:	0f b6 12             	movzbl (%edx),%edx
  800c31:	29 d0                	sub    %edx,%eax
}
  800c33:	5b                   	pop    %ebx
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    
		return 0;
  800c36:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3b:	eb f6                	jmp    800c33 <strncmp+0x2e>

00800c3d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c47:	0f b6 10             	movzbl (%eax),%edx
  800c4a:	84 d2                	test   %dl,%dl
  800c4c:	74 09                	je     800c57 <strchr+0x1a>
		if (*s == c)
  800c4e:	38 ca                	cmp    %cl,%dl
  800c50:	74 0a                	je     800c5c <strchr+0x1f>
	for (; *s; s++)
  800c52:	83 c0 01             	add    $0x1,%eax
  800c55:	eb f0                	jmp    800c47 <strchr+0xa>
			return (char *) s;
	return 0;
  800c57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c5c:	5d                   	pop    %ebp
  800c5d:	c3                   	ret    

00800c5e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c68:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c6b:	38 ca                	cmp    %cl,%dl
  800c6d:	74 09                	je     800c78 <strfind+0x1a>
  800c6f:	84 d2                	test   %dl,%dl
  800c71:	74 05                	je     800c78 <strfind+0x1a>
	for (; *s; s++)
  800c73:	83 c0 01             	add    $0x1,%eax
  800c76:	eb f0                	jmp    800c68 <strfind+0xa>
			break;
	return (char *) s;
}
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	57                   	push   %edi
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
  800c80:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c83:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c86:	85 c9                	test   %ecx,%ecx
  800c88:	74 31                	je     800cbb <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c8a:	89 f8                	mov    %edi,%eax
  800c8c:	09 c8                	or     %ecx,%eax
  800c8e:	a8 03                	test   $0x3,%al
  800c90:	75 23                	jne    800cb5 <memset+0x3b>
		c &= 0xFF;
  800c92:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c96:	89 d3                	mov    %edx,%ebx
  800c98:	c1 e3 08             	shl    $0x8,%ebx
  800c9b:	89 d0                	mov    %edx,%eax
  800c9d:	c1 e0 18             	shl    $0x18,%eax
  800ca0:	89 d6                	mov    %edx,%esi
  800ca2:	c1 e6 10             	shl    $0x10,%esi
  800ca5:	09 f0                	or     %esi,%eax
  800ca7:	09 c2                	or     %eax,%edx
  800ca9:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cab:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800cae:	89 d0                	mov    %edx,%eax
  800cb0:	fc                   	cld    
  800cb1:	f3 ab                	rep stos %eax,%es:(%edi)
  800cb3:	eb 06                	jmp    800cbb <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb8:	fc                   	cld    
  800cb9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cbb:	89 f8                	mov    %edi,%eax
  800cbd:	5b                   	pop    %ebx
  800cbe:	5e                   	pop    %esi
  800cbf:	5f                   	pop    %edi
  800cc0:	5d                   	pop    %ebp
  800cc1:	c3                   	ret    

00800cc2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	57                   	push   %edi
  800cc6:	56                   	push   %esi
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ccd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cd0:	39 c6                	cmp    %eax,%esi
  800cd2:	73 32                	jae    800d06 <memmove+0x44>
  800cd4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cd7:	39 c2                	cmp    %eax,%edx
  800cd9:	76 2b                	jbe    800d06 <memmove+0x44>
		s += n;
		d += n;
  800cdb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cde:	89 fe                	mov    %edi,%esi
  800ce0:	09 ce                	or     %ecx,%esi
  800ce2:	09 d6                	or     %edx,%esi
  800ce4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cea:	75 0e                	jne    800cfa <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cec:	83 ef 04             	sub    $0x4,%edi
  800cef:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cf2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cf5:	fd                   	std    
  800cf6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cf8:	eb 09                	jmp    800d03 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cfa:	83 ef 01             	sub    $0x1,%edi
  800cfd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d00:	fd                   	std    
  800d01:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d03:	fc                   	cld    
  800d04:	eb 1a                	jmp    800d20 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d06:	89 c2                	mov    %eax,%edx
  800d08:	09 ca                	or     %ecx,%edx
  800d0a:	09 f2                	or     %esi,%edx
  800d0c:	f6 c2 03             	test   $0x3,%dl
  800d0f:	75 0a                	jne    800d1b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d11:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d14:	89 c7                	mov    %eax,%edi
  800d16:	fc                   	cld    
  800d17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d19:	eb 05                	jmp    800d20 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800d1b:	89 c7                	mov    %eax,%edi
  800d1d:	fc                   	cld    
  800d1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d20:	5e                   	pop    %esi
  800d21:	5f                   	pop    %edi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d2a:	ff 75 10             	pushl  0x10(%ebp)
  800d2d:	ff 75 0c             	pushl  0xc(%ebp)
  800d30:	ff 75 08             	pushl  0x8(%ebp)
  800d33:	e8 8a ff ff ff       	call   800cc2 <memmove>
}
  800d38:	c9                   	leave  
  800d39:	c3                   	ret    

00800d3a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	56                   	push   %esi
  800d3e:	53                   	push   %ebx
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d45:	89 c6                	mov    %eax,%esi
  800d47:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d4a:	39 f0                	cmp    %esi,%eax
  800d4c:	74 1c                	je     800d6a <memcmp+0x30>
		if (*s1 != *s2)
  800d4e:	0f b6 08             	movzbl (%eax),%ecx
  800d51:	0f b6 1a             	movzbl (%edx),%ebx
  800d54:	38 d9                	cmp    %bl,%cl
  800d56:	75 08                	jne    800d60 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d58:	83 c0 01             	add    $0x1,%eax
  800d5b:	83 c2 01             	add    $0x1,%edx
  800d5e:	eb ea                	jmp    800d4a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d60:	0f b6 c1             	movzbl %cl,%eax
  800d63:	0f b6 db             	movzbl %bl,%ebx
  800d66:	29 d8                	sub    %ebx,%eax
  800d68:	eb 05                	jmp    800d6f <memcmp+0x35>
	}

	return 0;
  800d6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    

00800d73 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d7c:	89 c2                	mov    %eax,%edx
  800d7e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d81:	39 d0                	cmp    %edx,%eax
  800d83:	73 09                	jae    800d8e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d85:	38 08                	cmp    %cl,(%eax)
  800d87:	74 05                	je     800d8e <memfind+0x1b>
	for (; s < ends; s++)
  800d89:	83 c0 01             	add    $0x1,%eax
  800d8c:	eb f3                	jmp    800d81 <memfind+0xe>
			break;
	return (void *) s;
}
  800d8e:	5d                   	pop    %ebp
  800d8f:	c3                   	ret    

00800d90 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	57                   	push   %edi
  800d94:	56                   	push   %esi
  800d95:	53                   	push   %ebx
  800d96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d9c:	eb 03                	jmp    800da1 <strtol+0x11>
		s++;
  800d9e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800da1:	0f b6 01             	movzbl (%ecx),%eax
  800da4:	3c 20                	cmp    $0x20,%al
  800da6:	74 f6                	je     800d9e <strtol+0xe>
  800da8:	3c 09                	cmp    $0x9,%al
  800daa:	74 f2                	je     800d9e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800dac:	3c 2b                	cmp    $0x2b,%al
  800dae:	74 2a                	je     800dda <strtol+0x4a>
	int neg = 0;
  800db0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800db5:	3c 2d                	cmp    $0x2d,%al
  800db7:	74 2b                	je     800de4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800dbf:	75 0f                	jne    800dd0 <strtol+0x40>
  800dc1:	80 39 30             	cmpb   $0x30,(%ecx)
  800dc4:	74 28                	je     800dee <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dc6:	85 db                	test   %ebx,%ebx
  800dc8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dcd:	0f 44 d8             	cmove  %eax,%ebx
  800dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800dd8:	eb 50                	jmp    800e2a <strtol+0x9a>
		s++;
  800dda:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ddd:	bf 00 00 00 00       	mov    $0x0,%edi
  800de2:	eb d5                	jmp    800db9 <strtol+0x29>
		s++, neg = 1;
  800de4:	83 c1 01             	add    $0x1,%ecx
  800de7:	bf 01 00 00 00       	mov    $0x1,%edi
  800dec:	eb cb                	jmp    800db9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dee:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800df2:	74 0e                	je     800e02 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800df4:	85 db                	test   %ebx,%ebx
  800df6:	75 d8                	jne    800dd0 <strtol+0x40>
		s++, base = 8;
  800df8:	83 c1 01             	add    $0x1,%ecx
  800dfb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e00:	eb ce                	jmp    800dd0 <strtol+0x40>
		s += 2, base = 16;
  800e02:	83 c1 02             	add    $0x2,%ecx
  800e05:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e0a:	eb c4                	jmp    800dd0 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e0c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e0f:	89 f3                	mov    %esi,%ebx
  800e11:	80 fb 19             	cmp    $0x19,%bl
  800e14:	77 29                	ja     800e3f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800e16:	0f be d2             	movsbl %dl,%edx
  800e19:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e1c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e1f:	7d 30                	jge    800e51 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800e21:	83 c1 01             	add    $0x1,%ecx
  800e24:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e28:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e2a:	0f b6 11             	movzbl (%ecx),%edx
  800e2d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e30:	89 f3                	mov    %esi,%ebx
  800e32:	80 fb 09             	cmp    $0x9,%bl
  800e35:	77 d5                	ja     800e0c <strtol+0x7c>
			dig = *s - '0';
  800e37:	0f be d2             	movsbl %dl,%edx
  800e3a:	83 ea 30             	sub    $0x30,%edx
  800e3d:	eb dd                	jmp    800e1c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800e3f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e42:	89 f3                	mov    %esi,%ebx
  800e44:	80 fb 19             	cmp    $0x19,%bl
  800e47:	77 08                	ja     800e51 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800e49:	0f be d2             	movsbl %dl,%edx
  800e4c:	83 ea 37             	sub    $0x37,%edx
  800e4f:	eb cb                	jmp    800e1c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e55:	74 05                	je     800e5c <strtol+0xcc>
		*endptr = (char *) s;
  800e57:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e5a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e5c:	89 c2                	mov    %eax,%edx
  800e5e:	f7 da                	neg    %edx
  800e60:	85 ff                	test   %edi,%edi
  800e62:	0f 45 c2             	cmovne %edx,%eax
}
  800e65:	5b                   	pop    %ebx
  800e66:	5e                   	pop    %esi
  800e67:	5f                   	pop    %edi
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	57                   	push   %edi
  800e6e:	56                   	push   %esi
  800e6f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e70:	b8 00 00 00 00       	mov    $0x0,%eax
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7b:	89 c3                	mov    %eax,%ebx
  800e7d:	89 c7                	mov    %eax,%edi
  800e7f:	89 c6                	mov    %eax,%esi
  800e81:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e83:	5b                   	pop    %ebx
  800e84:	5e                   	pop    %esi
  800e85:	5f                   	pop    %edi
  800e86:	5d                   	pop    %ebp
  800e87:	c3                   	ret    

00800e88 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	57                   	push   %edi
  800e8c:	56                   	push   %esi
  800e8d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e93:	b8 01 00 00 00       	mov    $0x1,%eax
  800e98:	89 d1                	mov    %edx,%ecx
  800e9a:	89 d3                	mov    %edx,%ebx
  800e9c:	89 d7                	mov    %edx,%edi
  800e9e:	89 d6                	mov    %edx,%esi
  800ea0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ea2:	5b                   	pop    %ebx
  800ea3:	5e                   	pop    %esi
  800ea4:	5f                   	pop    %edi
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    

00800ea7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	57                   	push   %edi
  800eab:	56                   	push   %esi
  800eac:	53                   	push   %ebx
  800ead:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb8:	b8 03 00 00 00       	mov    $0x3,%eax
  800ebd:	89 cb                	mov    %ecx,%ebx
  800ebf:	89 cf                	mov    %ecx,%edi
  800ec1:	89 ce                	mov    %ecx,%esi
  800ec3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	7f 08                	jg     800ed1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ec9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ecc:	5b                   	pop    %ebx
  800ecd:	5e                   	pop    %esi
  800ece:	5f                   	pop    %edi
  800ecf:	5d                   	pop    %ebp
  800ed0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed1:	83 ec 0c             	sub    $0xc,%esp
  800ed4:	50                   	push   %eax
  800ed5:	6a 03                	push   $0x3
  800ed7:	68 a8 2b 80 00       	push   $0x802ba8
  800edc:	6a 43                	push   $0x43
  800ede:	68 c5 2b 80 00       	push   $0x802bc5
  800ee3:	e8 f7 f3 ff ff       	call   8002df <_panic>

00800ee8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	57                   	push   %edi
  800eec:	56                   	push   %esi
  800eed:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eee:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef3:	b8 02 00 00 00       	mov    $0x2,%eax
  800ef8:	89 d1                	mov    %edx,%ecx
  800efa:	89 d3                	mov    %edx,%ebx
  800efc:	89 d7                	mov    %edx,%edi
  800efe:	89 d6                	mov    %edx,%esi
  800f00:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5f                   	pop    %edi
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    

00800f07 <sys_yield>:

void
sys_yield(void)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	57                   	push   %edi
  800f0b:	56                   	push   %esi
  800f0c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f12:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f17:	89 d1                	mov    %edx,%ecx
  800f19:	89 d3                	mov    %edx,%ebx
  800f1b:	89 d7                	mov    %edx,%edi
  800f1d:	89 d6                	mov    %edx,%esi
  800f1f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f21:	5b                   	pop    %ebx
  800f22:	5e                   	pop    %esi
  800f23:	5f                   	pop    %edi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	57                   	push   %edi
  800f2a:	56                   	push   %esi
  800f2b:	53                   	push   %ebx
  800f2c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2f:	be 00 00 00 00       	mov    $0x0,%esi
  800f34:	8b 55 08             	mov    0x8(%ebp),%edx
  800f37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3a:	b8 04 00 00 00       	mov    $0x4,%eax
  800f3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f42:	89 f7                	mov    %esi,%edi
  800f44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f46:	85 c0                	test   %eax,%eax
  800f48:	7f 08                	jg     800f52 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4d:	5b                   	pop    %ebx
  800f4e:	5e                   	pop    %esi
  800f4f:	5f                   	pop    %edi
  800f50:	5d                   	pop    %ebp
  800f51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f52:	83 ec 0c             	sub    $0xc,%esp
  800f55:	50                   	push   %eax
  800f56:	6a 04                	push   $0x4
  800f58:	68 a8 2b 80 00       	push   $0x802ba8
  800f5d:	6a 43                	push   $0x43
  800f5f:	68 c5 2b 80 00       	push   $0x802bc5
  800f64:	e8 76 f3 ff ff       	call   8002df <_panic>

00800f69 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f69:	55                   	push   %ebp
  800f6a:	89 e5                	mov    %esp,%ebp
  800f6c:	57                   	push   %edi
  800f6d:	56                   	push   %esi
  800f6e:	53                   	push   %ebx
  800f6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f72:	8b 55 08             	mov    0x8(%ebp),%edx
  800f75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f78:	b8 05 00 00 00       	mov    $0x5,%eax
  800f7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f80:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f83:	8b 75 18             	mov    0x18(%ebp),%esi
  800f86:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f88:	85 c0                	test   %eax,%eax
  800f8a:	7f 08                	jg     800f94 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8f:	5b                   	pop    %ebx
  800f90:	5e                   	pop    %esi
  800f91:	5f                   	pop    %edi
  800f92:	5d                   	pop    %ebp
  800f93:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f94:	83 ec 0c             	sub    $0xc,%esp
  800f97:	50                   	push   %eax
  800f98:	6a 05                	push   $0x5
  800f9a:	68 a8 2b 80 00       	push   $0x802ba8
  800f9f:	6a 43                	push   $0x43
  800fa1:	68 c5 2b 80 00       	push   $0x802bc5
  800fa6:	e8 34 f3 ff ff       	call   8002df <_panic>

00800fab <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	57                   	push   %edi
  800faf:	56                   	push   %esi
  800fb0:	53                   	push   %ebx
  800fb1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbf:	b8 06 00 00 00       	mov    $0x6,%eax
  800fc4:	89 df                	mov    %ebx,%edi
  800fc6:	89 de                	mov    %ebx,%esi
  800fc8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fca:	85 c0                	test   %eax,%eax
  800fcc:	7f 08                	jg     800fd6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd1:	5b                   	pop    %ebx
  800fd2:	5e                   	pop    %esi
  800fd3:	5f                   	pop    %edi
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd6:	83 ec 0c             	sub    $0xc,%esp
  800fd9:	50                   	push   %eax
  800fda:	6a 06                	push   $0x6
  800fdc:	68 a8 2b 80 00       	push   $0x802ba8
  800fe1:	6a 43                	push   $0x43
  800fe3:	68 c5 2b 80 00       	push   $0x802bc5
  800fe8:	e8 f2 f2 ff ff       	call   8002df <_panic>

00800fed <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	57                   	push   %edi
  800ff1:	56                   	push   %esi
  800ff2:	53                   	push   %ebx
  800ff3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801001:	b8 08 00 00 00       	mov    $0x8,%eax
  801006:	89 df                	mov    %ebx,%edi
  801008:	89 de                	mov    %ebx,%esi
  80100a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80100c:	85 c0                	test   %eax,%eax
  80100e:	7f 08                	jg     801018 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801010:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801013:	5b                   	pop    %ebx
  801014:	5e                   	pop    %esi
  801015:	5f                   	pop    %edi
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801018:	83 ec 0c             	sub    $0xc,%esp
  80101b:	50                   	push   %eax
  80101c:	6a 08                	push   $0x8
  80101e:	68 a8 2b 80 00       	push   $0x802ba8
  801023:	6a 43                	push   $0x43
  801025:	68 c5 2b 80 00       	push   $0x802bc5
  80102a:	e8 b0 f2 ff ff       	call   8002df <_panic>

0080102f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
  801032:	57                   	push   %edi
  801033:	56                   	push   %esi
  801034:	53                   	push   %ebx
  801035:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801038:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103d:	8b 55 08             	mov    0x8(%ebp),%edx
  801040:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801043:	b8 09 00 00 00       	mov    $0x9,%eax
  801048:	89 df                	mov    %ebx,%edi
  80104a:	89 de                	mov    %ebx,%esi
  80104c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80104e:	85 c0                	test   %eax,%eax
  801050:	7f 08                	jg     80105a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801052:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801055:	5b                   	pop    %ebx
  801056:	5e                   	pop    %esi
  801057:	5f                   	pop    %edi
  801058:	5d                   	pop    %ebp
  801059:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80105a:	83 ec 0c             	sub    $0xc,%esp
  80105d:	50                   	push   %eax
  80105e:	6a 09                	push   $0x9
  801060:	68 a8 2b 80 00       	push   $0x802ba8
  801065:	6a 43                	push   $0x43
  801067:	68 c5 2b 80 00       	push   $0x802bc5
  80106c:	e8 6e f2 ff ff       	call   8002df <_panic>

00801071 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	57                   	push   %edi
  801075:	56                   	push   %esi
  801076:	53                   	push   %ebx
  801077:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80107a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107f:	8b 55 08             	mov    0x8(%ebp),%edx
  801082:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801085:	b8 0a 00 00 00       	mov    $0xa,%eax
  80108a:	89 df                	mov    %ebx,%edi
  80108c:	89 de                	mov    %ebx,%esi
  80108e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801090:	85 c0                	test   %eax,%eax
  801092:	7f 08                	jg     80109c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801094:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801097:	5b                   	pop    %ebx
  801098:	5e                   	pop    %esi
  801099:	5f                   	pop    %edi
  80109a:	5d                   	pop    %ebp
  80109b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80109c:	83 ec 0c             	sub    $0xc,%esp
  80109f:	50                   	push   %eax
  8010a0:	6a 0a                	push   $0xa
  8010a2:	68 a8 2b 80 00       	push   $0x802ba8
  8010a7:	6a 43                	push   $0x43
  8010a9:	68 c5 2b 80 00       	push   $0x802bc5
  8010ae:	e8 2c f2 ff ff       	call   8002df <_panic>

008010b3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	57                   	push   %edi
  8010b7:	56                   	push   %esi
  8010b8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bf:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010c4:	be 00 00 00 00       	mov    $0x0,%esi
  8010c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010cc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010cf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010d1:	5b                   	pop    %ebx
  8010d2:	5e                   	pop    %esi
  8010d3:	5f                   	pop    %edi
  8010d4:	5d                   	pop    %ebp
  8010d5:	c3                   	ret    

008010d6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	57                   	push   %edi
  8010da:	56                   	push   %esi
  8010db:	53                   	push   %ebx
  8010dc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010ec:	89 cb                	mov    %ecx,%ebx
  8010ee:	89 cf                	mov    %ecx,%edi
  8010f0:	89 ce                	mov    %ecx,%esi
  8010f2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	7f 08                	jg     801100 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010fb:	5b                   	pop    %ebx
  8010fc:	5e                   	pop    %esi
  8010fd:	5f                   	pop    %edi
  8010fe:	5d                   	pop    %ebp
  8010ff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801100:	83 ec 0c             	sub    $0xc,%esp
  801103:	50                   	push   %eax
  801104:	6a 0d                	push   $0xd
  801106:	68 a8 2b 80 00       	push   $0x802ba8
  80110b:	6a 43                	push   $0x43
  80110d:	68 c5 2b 80 00       	push   $0x802bc5
  801112:	e8 c8 f1 ff ff       	call   8002df <_panic>

00801117 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	57                   	push   %edi
  80111b:	56                   	push   %esi
  80111c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80111d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801122:	8b 55 08             	mov    0x8(%ebp),%edx
  801125:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801128:	b8 0e 00 00 00       	mov    $0xe,%eax
  80112d:	89 df                	mov    %ebx,%edi
  80112f:	89 de                	mov    %ebx,%esi
  801131:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801133:	5b                   	pop    %ebx
  801134:	5e                   	pop    %esi
  801135:	5f                   	pop    %edi
  801136:	5d                   	pop    %ebp
  801137:	c3                   	ret    

00801138 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	57                   	push   %edi
  80113c:	56                   	push   %esi
  80113d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80113e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801143:	8b 55 08             	mov    0x8(%ebp),%edx
  801146:	b8 0f 00 00 00       	mov    $0xf,%eax
  80114b:	89 cb                	mov    %ecx,%ebx
  80114d:	89 cf                	mov    %ecx,%edi
  80114f:	89 ce                	mov    %ecx,%esi
  801151:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801153:	5b                   	pop    %ebx
  801154:	5e                   	pop    %esi
  801155:	5f                   	pop    %edi
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    

00801158 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	57                   	push   %edi
  80115c:	56                   	push   %esi
  80115d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80115e:	ba 00 00 00 00       	mov    $0x0,%edx
  801163:	b8 10 00 00 00       	mov    $0x10,%eax
  801168:	89 d1                	mov    %edx,%ecx
  80116a:	89 d3                	mov    %edx,%ebx
  80116c:	89 d7                	mov    %edx,%edi
  80116e:	89 d6                	mov    %edx,%esi
  801170:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801172:	5b                   	pop    %ebx
  801173:	5e                   	pop    %esi
  801174:	5f                   	pop    %edi
  801175:	5d                   	pop    %ebp
  801176:	c3                   	ret    

00801177 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	57                   	push   %edi
  80117b:	56                   	push   %esi
  80117c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80117d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801182:	8b 55 08             	mov    0x8(%ebp),%edx
  801185:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801188:	b8 11 00 00 00       	mov    $0x11,%eax
  80118d:	89 df                	mov    %ebx,%edi
  80118f:	89 de                	mov    %ebx,%esi
  801191:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801193:	5b                   	pop    %ebx
  801194:	5e                   	pop    %esi
  801195:	5f                   	pop    %edi
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    

00801198 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	57                   	push   %edi
  80119c:	56                   	push   %esi
  80119d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80119e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a9:	b8 12 00 00 00       	mov    $0x12,%eax
  8011ae:	89 df                	mov    %ebx,%edi
  8011b0:	89 de                	mov    %ebx,%esi
  8011b2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8011b4:	5b                   	pop    %ebx
  8011b5:	5e                   	pop    %esi
  8011b6:	5f                   	pop    %edi
  8011b7:	5d                   	pop    %ebp
  8011b8:	c3                   	ret    

008011b9 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
  8011bc:	57                   	push   %edi
  8011bd:	56                   	push   %esi
  8011be:	53                   	push   %ebx
  8011bf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011cd:	b8 13 00 00 00       	mov    $0x13,%eax
  8011d2:	89 df                	mov    %ebx,%edi
  8011d4:	89 de                	mov    %ebx,%esi
  8011d6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011d8:	85 c0                	test   %eax,%eax
  8011da:	7f 08                	jg     8011e4 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011df:	5b                   	pop    %ebx
  8011e0:	5e                   	pop    %esi
  8011e1:	5f                   	pop    %edi
  8011e2:	5d                   	pop    %ebp
  8011e3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	50                   	push   %eax
  8011e8:	6a 13                	push   $0x13
  8011ea:	68 a8 2b 80 00       	push   $0x802ba8
  8011ef:	6a 43                	push   $0x43
  8011f1:	68 c5 2b 80 00       	push   $0x802bc5
  8011f6:	e8 e4 f0 ff ff       	call   8002df <_panic>

008011fb <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	57                   	push   %edi
  8011ff:	56                   	push   %esi
  801200:	53                   	push   %ebx
	asm volatile("int %1\n"
  801201:	b9 00 00 00 00       	mov    $0x0,%ecx
  801206:	8b 55 08             	mov    0x8(%ebp),%edx
  801209:	b8 14 00 00 00       	mov    $0x14,%eax
  80120e:	89 cb                	mov    %ecx,%ebx
  801210:	89 cf                	mov    %ecx,%edi
  801212:	89 ce                	mov    %ecx,%esi
  801214:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801216:	5b                   	pop    %ebx
  801217:	5e                   	pop    %esi
  801218:	5f                   	pop    %edi
  801219:	5d                   	pop    %ebp
  80121a:	c3                   	ret    

0080121b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	05 00 00 00 30       	add    $0x30000000,%eax
  801226:	c1 e8 0c             	shr    $0xc,%eax
}
  801229:	5d                   	pop    %ebp
  80122a:	c3                   	ret    

0080122b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801236:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80123b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801240:	5d                   	pop    %ebp
  801241:	c3                   	ret    

00801242 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80124a:	89 c2                	mov    %eax,%edx
  80124c:	c1 ea 16             	shr    $0x16,%edx
  80124f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801256:	f6 c2 01             	test   $0x1,%dl
  801259:	74 2d                	je     801288 <fd_alloc+0x46>
  80125b:	89 c2                	mov    %eax,%edx
  80125d:	c1 ea 0c             	shr    $0xc,%edx
  801260:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801267:	f6 c2 01             	test   $0x1,%dl
  80126a:	74 1c                	je     801288 <fd_alloc+0x46>
  80126c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801271:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801276:	75 d2                	jne    80124a <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801281:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801286:	eb 0a                	jmp    801292 <fd_alloc+0x50>
			*fd_store = fd;
  801288:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80128b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80128d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801292:	5d                   	pop    %ebp
  801293:	c3                   	ret    

00801294 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80129a:	83 f8 1f             	cmp    $0x1f,%eax
  80129d:	77 30                	ja     8012cf <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80129f:	c1 e0 0c             	shl    $0xc,%eax
  8012a2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012a7:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012ad:	f6 c2 01             	test   $0x1,%dl
  8012b0:	74 24                	je     8012d6 <fd_lookup+0x42>
  8012b2:	89 c2                	mov    %eax,%edx
  8012b4:	c1 ea 0c             	shr    $0xc,%edx
  8012b7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012be:	f6 c2 01             	test   $0x1,%dl
  8012c1:	74 1a                	je     8012dd <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c6:	89 02                	mov    %eax,(%edx)
	return 0;
  8012c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012cd:	5d                   	pop    %ebp
  8012ce:	c3                   	ret    
		return -E_INVAL;
  8012cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d4:	eb f7                	jmp    8012cd <fd_lookup+0x39>
		return -E_INVAL;
  8012d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012db:	eb f0                	jmp    8012cd <fd_lookup+0x39>
  8012dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e2:	eb e9                	jmp    8012cd <fd_lookup+0x39>

008012e4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	83 ec 08             	sub    $0x8,%esp
  8012ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8012ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8012f2:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012f7:	39 08                	cmp    %ecx,(%eax)
  8012f9:	74 38                	je     801333 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8012fb:	83 c2 01             	add    $0x1,%edx
  8012fe:	8b 04 95 54 2c 80 00 	mov    0x802c54(,%edx,4),%eax
  801305:	85 c0                	test   %eax,%eax
  801307:	75 ee                	jne    8012f7 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801309:	a1 08 40 80 00       	mov    0x804008,%eax
  80130e:	8b 40 48             	mov    0x48(%eax),%eax
  801311:	83 ec 04             	sub    $0x4,%esp
  801314:	51                   	push   %ecx
  801315:	50                   	push   %eax
  801316:	68 d4 2b 80 00       	push   $0x802bd4
  80131b:	e8 b5 f0 ff ff       	call   8003d5 <cprintf>
	*dev = 0;
  801320:	8b 45 0c             	mov    0xc(%ebp),%eax
  801323:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801329:	83 c4 10             	add    $0x10,%esp
  80132c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801331:	c9                   	leave  
  801332:	c3                   	ret    
			*dev = devtab[i];
  801333:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801336:	89 01                	mov    %eax,(%ecx)
			return 0;
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
  80133d:	eb f2                	jmp    801331 <dev_lookup+0x4d>

0080133f <fd_close>:
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	57                   	push   %edi
  801343:	56                   	push   %esi
  801344:	53                   	push   %ebx
  801345:	83 ec 24             	sub    $0x24,%esp
  801348:	8b 75 08             	mov    0x8(%ebp),%esi
  80134b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80134e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801351:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801352:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801358:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80135b:	50                   	push   %eax
  80135c:	e8 33 ff ff ff       	call   801294 <fd_lookup>
  801361:	89 c3                	mov    %eax,%ebx
  801363:	83 c4 10             	add    $0x10,%esp
  801366:	85 c0                	test   %eax,%eax
  801368:	78 05                	js     80136f <fd_close+0x30>
	    || fd != fd2)
  80136a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80136d:	74 16                	je     801385 <fd_close+0x46>
		return (must_exist ? r : 0);
  80136f:	89 f8                	mov    %edi,%eax
  801371:	84 c0                	test   %al,%al
  801373:	b8 00 00 00 00       	mov    $0x0,%eax
  801378:	0f 44 d8             	cmove  %eax,%ebx
}
  80137b:	89 d8                	mov    %ebx,%eax
  80137d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801380:	5b                   	pop    %ebx
  801381:	5e                   	pop    %esi
  801382:	5f                   	pop    %edi
  801383:	5d                   	pop    %ebp
  801384:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801385:	83 ec 08             	sub    $0x8,%esp
  801388:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80138b:	50                   	push   %eax
  80138c:	ff 36                	pushl  (%esi)
  80138e:	e8 51 ff ff ff       	call   8012e4 <dev_lookup>
  801393:	89 c3                	mov    %eax,%ebx
  801395:	83 c4 10             	add    $0x10,%esp
  801398:	85 c0                	test   %eax,%eax
  80139a:	78 1a                	js     8013b6 <fd_close+0x77>
		if (dev->dev_close)
  80139c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80139f:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013a2:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013a7:	85 c0                	test   %eax,%eax
  8013a9:	74 0b                	je     8013b6 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8013ab:	83 ec 0c             	sub    $0xc,%esp
  8013ae:	56                   	push   %esi
  8013af:	ff d0                	call   *%eax
  8013b1:	89 c3                	mov    %eax,%ebx
  8013b3:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013b6:	83 ec 08             	sub    $0x8,%esp
  8013b9:	56                   	push   %esi
  8013ba:	6a 00                	push   $0x0
  8013bc:	e8 ea fb ff ff       	call   800fab <sys_page_unmap>
	return r;
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	eb b5                	jmp    80137b <fd_close+0x3c>

008013c6 <close>:

int
close(int fdnum)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013cf:	50                   	push   %eax
  8013d0:	ff 75 08             	pushl  0x8(%ebp)
  8013d3:	e8 bc fe ff ff       	call   801294 <fd_lookup>
  8013d8:	83 c4 10             	add    $0x10,%esp
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	79 02                	jns    8013e1 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    
		return fd_close(fd, 1);
  8013e1:	83 ec 08             	sub    $0x8,%esp
  8013e4:	6a 01                	push   $0x1
  8013e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8013e9:	e8 51 ff ff ff       	call   80133f <fd_close>
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	eb ec                	jmp    8013df <close+0x19>

008013f3 <close_all>:

void
close_all(void)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	53                   	push   %ebx
  8013f7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013fa:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013ff:	83 ec 0c             	sub    $0xc,%esp
  801402:	53                   	push   %ebx
  801403:	e8 be ff ff ff       	call   8013c6 <close>
	for (i = 0; i < MAXFD; i++)
  801408:	83 c3 01             	add    $0x1,%ebx
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	83 fb 20             	cmp    $0x20,%ebx
  801411:	75 ec                	jne    8013ff <close_all+0xc>
}
  801413:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	57                   	push   %edi
  80141c:	56                   	push   %esi
  80141d:	53                   	push   %ebx
  80141e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801421:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801424:	50                   	push   %eax
  801425:	ff 75 08             	pushl  0x8(%ebp)
  801428:	e8 67 fe ff ff       	call   801294 <fd_lookup>
  80142d:	89 c3                	mov    %eax,%ebx
  80142f:	83 c4 10             	add    $0x10,%esp
  801432:	85 c0                	test   %eax,%eax
  801434:	0f 88 81 00 00 00    	js     8014bb <dup+0xa3>
		return r;
	close(newfdnum);
  80143a:	83 ec 0c             	sub    $0xc,%esp
  80143d:	ff 75 0c             	pushl  0xc(%ebp)
  801440:	e8 81 ff ff ff       	call   8013c6 <close>

	newfd = INDEX2FD(newfdnum);
  801445:	8b 75 0c             	mov    0xc(%ebp),%esi
  801448:	c1 e6 0c             	shl    $0xc,%esi
  80144b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801451:	83 c4 04             	add    $0x4,%esp
  801454:	ff 75 e4             	pushl  -0x1c(%ebp)
  801457:	e8 cf fd ff ff       	call   80122b <fd2data>
  80145c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80145e:	89 34 24             	mov    %esi,(%esp)
  801461:	e8 c5 fd ff ff       	call   80122b <fd2data>
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80146b:	89 d8                	mov    %ebx,%eax
  80146d:	c1 e8 16             	shr    $0x16,%eax
  801470:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801477:	a8 01                	test   $0x1,%al
  801479:	74 11                	je     80148c <dup+0x74>
  80147b:	89 d8                	mov    %ebx,%eax
  80147d:	c1 e8 0c             	shr    $0xc,%eax
  801480:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801487:	f6 c2 01             	test   $0x1,%dl
  80148a:	75 39                	jne    8014c5 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80148c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80148f:	89 d0                	mov    %edx,%eax
  801491:	c1 e8 0c             	shr    $0xc,%eax
  801494:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80149b:	83 ec 0c             	sub    $0xc,%esp
  80149e:	25 07 0e 00 00       	and    $0xe07,%eax
  8014a3:	50                   	push   %eax
  8014a4:	56                   	push   %esi
  8014a5:	6a 00                	push   $0x0
  8014a7:	52                   	push   %edx
  8014a8:	6a 00                	push   $0x0
  8014aa:	e8 ba fa ff ff       	call   800f69 <sys_page_map>
  8014af:	89 c3                	mov    %eax,%ebx
  8014b1:	83 c4 20             	add    $0x20,%esp
  8014b4:	85 c0                	test   %eax,%eax
  8014b6:	78 31                	js     8014e9 <dup+0xd1>
		goto err;

	return newfdnum;
  8014b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014bb:	89 d8                	mov    %ebx,%eax
  8014bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c0:	5b                   	pop    %ebx
  8014c1:	5e                   	pop    %esi
  8014c2:	5f                   	pop    %edi
  8014c3:	5d                   	pop    %ebp
  8014c4:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014c5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014cc:	83 ec 0c             	sub    $0xc,%esp
  8014cf:	25 07 0e 00 00       	and    $0xe07,%eax
  8014d4:	50                   	push   %eax
  8014d5:	57                   	push   %edi
  8014d6:	6a 00                	push   $0x0
  8014d8:	53                   	push   %ebx
  8014d9:	6a 00                	push   $0x0
  8014db:	e8 89 fa ff ff       	call   800f69 <sys_page_map>
  8014e0:	89 c3                	mov    %eax,%ebx
  8014e2:	83 c4 20             	add    $0x20,%esp
  8014e5:	85 c0                	test   %eax,%eax
  8014e7:	79 a3                	jns    80148c <dup+0x74>
	sys_page_unmap(0, newfd);
  8014e9:	83 ec 08             	sub    $0x8,%esp
  8014ec:	56                   	push   %esi
  8014ed:	6a 00                	push   $0x0
  8014ef:	e8 b7 fa ff ff       	call   800fab <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014f4:	83 c4 08             	add    $0x8,%esp
  8014f7:	57                   	push   %edi
  8014f8:	6a 00                	push   $0x0
  8014fa:	e8 ac fa ff ff       	call   800fab <sys_page_unmap>
	return r;
  8014ff:	83 c4 10             	add    $0x10,%esp
  801502:	eb b7                	jmp    8014bb <dup+0xa3>

00801504 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	53                   	push   %ebx
  801508:	83 ec 1c             	sub    $0x1c,%esp
  80150b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80150e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801511:	50                   	push   %eax
  801512:	53                   	push   %ebx
  801513:	e8 7c fd ff ff       	call   801294 <fd_lookup>
  801518:	83 c4 10             	add    $0x10,%esp
  80151b:	85 c0                	test   %eax,%eax
  80151d:	78 3f                	js     80155e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80151f:	83 ec 08             	sub    $0x8,%esp
  801522:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801525:	50                   	push   %eax
  801526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801529:	ff 30                	pushl  (%eax)
  80152b:	e8 b4 fd ff ff       	call   8012e4 <dev_lookup>
  801530:	83 c4 10             	add    $0x10,%esp
  801533:	85 c0                	test   %eax,%eax
  801535:	78 27                	js     80155e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801537:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80153a:	8b 42 08             	mov    0x8(%edx),%eax
  80153d:	83 e0 03             	and    $0x3,%eax
  801540:	83 f8 01             	cmp    $0x1,%eax
  801543:	74 1e                	je     801563 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801548:	8b 40 08             	mov    0x8(%eax),%eax
  80154b:	85 c0                	test   %eax,%eax
  80154d:	74 35                	je     801584 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80154f:	83 ec 04             	sub    $0x4,%esp
  801552:	ff 75 10             	pushl  0x10(%ebp)
  801555:	ff 75 0c             	pushl  0xc(%ebp)
  801558:	52                   	push   %edx
  801559:	ff d0                	call   *%eax
  80155b:	83 c4 10             	add    $0x10,%esp
}
  80155e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801561:	c9                   	leave  
  801562:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801563:	a1 08 40 80 00       	mov    0x804008,%eax
  801568:	8b 40 48             	mov    0x48(%eax),%eax
  80156b:	83 ec 04             	sub    $0x4,%esp
  80156e:	53                   	push   %ebx
  80156f:	50                   	push   %eax
  801570:	68 18 2c 80 00       	push   $0x802c18
  801575:	e8 5b ee ff ff       	call   8003d5 <cprintf>
		return -E_INVAL;
  80157a:	83 c4 10             	add    $0x10,%esp
  80157d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801582:	eb da                	jmp    80155e <read+0x5a>
		return -E_NOT_SUPP;
  801584:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801589:	eb d3                	jmp    80155e <read+0x5a>

0080158b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	57                   	push   %edi
  80158f:	56                   	push   %esi
  801590:	53                   	push   %ebx
  801591:	83 ec 0c             	sub    $0xc,%esp
  801594:	8b 7d 08             	mov    0x8(%ebp),%edi
  801597:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80159a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80159f:	39 f3                	cmp    %esi,%ebx
  8015a1:	73 23                	jae    8015c6 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015a3:	83 ec 04             	sub    $0x4,%esp
  8015a6:	89 f0                	mov    %esi,%eax
  8015a8:	29 d8                	sub    %ebx,%eax
  8015aa:	50                   	push   %eax
  8015ab:	89 d8                	mov    %ebx,%eax
  8015ad:	03 45 0c             	add    0xc(%ebp),%eax
  8015b0:	50                   	push   %eax
  8015b1:	57                   	push   %edi
  8015b2:	e8 4d ff ff ff       	call   801504 <read>
		if (m < 0)
  8015b7:	83 c4 10             	add    $0x10,%esp
  8015ba:	85 c0                	test   %eax,%eax
  8015bc:	78 06                	js     8015c4 <readn+0x39>
			return m;
		if (m == 0)
  8015be:	74 06                	je     8015c6 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8015c0:	01 c3                	add    %eax,%ebx
  8015c2:	eb db                	jmp    80159f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015c4:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015c6:	89 d8                	mov    %ebx,%eax
  8015c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015cb:	5b                   	pop    %ebx
  8015cc:	5e                   	pop    %esi
  8015cd:	5f                   	pop    %edi
  8015ce:	5d                   	pop    %ebp
  8015cf:	c3                   	ret    

008015d0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	53                   	push   %ebx
  8015d4:	83 ec 1c             	sub    $0x1c,%esp
  8015d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015dd:	50                   	push   %eax
  8015de:	53                   	push   %ebx
  8015df:	e8 b0 fc ff ff       	call   801294 <fd_lookup>
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	78 3a                	js     801625 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015eb:	83 ec 08             	sub    $0x8,%esp
  8015ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f1:	50                   	push   %eax
  8015f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f5:	ff 30                	pushl  (%eax)
  8015f7:	e8 e8 fc ff ff       	call   8012e4 <dev_lookup>
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	85 c0                	test   %eax,%eax
  801601:	78 22                	js     801625 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801606:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80160a:	74 1e                	je     80162a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80160c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80160f:	8b 52 0c             	mov    0xc(%edx),%edx
  801612:	85 d2                	test   %edx,%edx
  801614:	74 35                	je     80164b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801616:	83 ec 04             	sub    $0x4,%esp
  801619:	ff 75 10             	pushl  0x10(%ebp)
  80161c:	ff 75 0c             	pushl  0xc(%ebp)
  80161f:	50                   	push   %eax
  801620:	ff d2                	call   *%edx
  801622:	83 c4 10             	add    $0x10,%esp
}
  801625:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801628:	c9                   	leave  
  801629:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80162a:	a1 08 40 80 00       	mov    0x804008,%eax
  80162f:	8b 40 48             	mov    0x48(%eax),%eax
  801632:	83 ec 04             	sub    $0x4,%esp
  801635:	53                   	push   %ebx
  801636:	50                   	push   %eax
  801637:	68 34 2c 80 00       	push   $0x802c34
  80163c:	e8 94 ed ff ff       	call   8003d5 <cprintf>
		return -E_INVAL;
  801641:	83 c4 10             	add    $0x10,%esp
  801644:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801649:	eb da                	jmp    801625 <write+0x55>
		return -E_NOT_SUPP;
  80164b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801650:	eb d3                	jmp    801625 <write+0x55>

00801652 <seek>:

int
seek(int fdnum, off_t offset)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801658:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165b:	50                   	push   %eax
  80165c:	ff 75 08             	pushl  0x8(%ebp)
  80165f:	e8 30 fc ff ff       	call   801294 <fd_lookup>
  801664:	83 c4 10             	add    $0x10,%esp
  801667:	85 c0                	test   %eax,%eax
  801669:	78 0e                	js     801679 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80166b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801671:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801674:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	53                   	push   %ebx
  80167f:	83 ec 1c             	sub    $0x1c,%esp
  801682:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801685:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801688:	50                   	push   %eax
  801689:	53                   	push   %ebx
  80168a:	e8 05 fc ff ff       	call   801294 <fd_lookup>
  80168f:	83 c4 10             	add    $0x10,%esp
  801692:	85 c0                	test   %eax,%eax
  801694:	78 37                	js     8016cd <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801696:	83 ec 08             	sub    $0x8,%esp
  801699:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80169c:	50                   	push   %eax
  80169d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a0:	ff 30                	pushl  (%eax)
  8016a2:	e8 3d fc ff ff       	call   8012e4 <dev_lookup>
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	78 1f                	js     8016cd <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016b5:	74 1b                	je     8016d2 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ba:	8b 52 18             	mov    0x18(%edx),%edx
  8016bd:	85 d2                	test   %edx,%edx
  8016bf:	74 32                	je     8016f3 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	50                   	push   %eax
  8016c8:	ff d2                	call   *%edx
  8016ca:	83 c4 10             	add    $0x10,%esp
}
  8016cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016d2:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016d7:	8b 40 48             	mov    0x48(%eax),%eax
  8016da:	83 ec 04             	sub    $0x4,%esp
  8016dd:	53                   	push   %ebx
  8016de:	50                   	push   %eax
  8016df:	68 f4 2b 80 00       	push   $0x802bf4
  8016e4:	e8 ec ec ff ff       	call   8003d5 <cprintf>
		return -E_INVAL;
  8016e9:	83 c4 10             	add    $0x10,%esp
  8016ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f1:	eb da                	jmp    8016cd <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016f8:	eb d3                	jmp    8016cd <ftruncate+0x52>

008016fa <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	53                   	push   %ebx
  8016fe:	83 ec 1c             	sub    $0x1c,%esp
  801701:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801704:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801707:	50                   	push   %eax
  801708:	ff 75 08             	pushl  0x8(%ebp)
  80170b:	e8 84 fb ff ff       	call   801294 <fd_lookup>
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	85 c0                	test   %eax,%eax
  801715:	78 4b                	js     801762 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801717:	83 ec 08             	sub    $0x8,%esp
  80171a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171d:	50                   	push   %eax
  80171e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801721:	ff 30                	pushl  (%eax)
  801723:	e8 bc fb ff ff       	call   8012e4 <dev_lookup>
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	85 c0                	test   %eax,%eax
  80172d:	78 33                	js     801762 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80172f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801732:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801736:	74 2f                	je     801767 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801738:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80173b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801742:	00 00 00 
	stat->st_isdir = 0;
  801745:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80174c:	00 00 00 
	stat->st_dev = dev;
  80174f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801755:	83 ec 08             	sub    $0x8,%esp
  801758:	53                   	push   %ebx
  801759:	ff 75 f0             	pushl  -0x10(%ebp)
  80175c:	ff 50 14             	call   *0x14(%eax)
  80175f:	83 c4 10             	add    $0x10,%esp
}
  801762:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801765:	c9                   	leave  
  801766:	c3                   	ret    
		return -E_NOT_SUPP;
  801767:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80176c:	eb f4                	jmp    801762 <fstat+0x68>

0080176e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
  801771:	56                   	push   %esi
  801772:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801773:	83 ec 08             	sub    $0x8,%esp
  801776:	6a 00                	push   $0x0
  801778:	ff 75 08             	pushl  0x8(%ebp)
  80177b:	e8 22 02 00 00       	call   8019a2 <open>
  801780:	89 c3                	mov    %eax,%ebx
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	85 c0                	test   %eax,%eax
  801787:	78 1b                	js     8017a4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801789:	83 ec 08             	sub    $0x8,%esp
  80178c:	ff 75 0c             	pushl  0xc(%ebp)
  80178f:	50                   	push   %eax
  801790:	e8 65 ff ff ff       	call   8016fa <fstat>
  801795:	89 c6                	mov    %eax,%esi
	close(fd);
  801797:	89 1c 24             	mov    %ebx,(%esp)
  80179a:	e8 27 fc ff ff       	call   8013c6 <close>
	return r;
  80179f:	83 c4 10             	add    $0x10,%esp
  8017a2:	89 f3                	mov    %esi,%ebx
}
  8017a4:	89 d8                	mov    %ebx,%eax
  8017a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a9:	5b                   	pop    %ebx
  8017aa:	5e                   	pop    %esi
  8017ab:	5d                   	pop    %ebp
  8017ac:	c3                   	ret    

008017ad <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	56                   	push   %esi
  8017b1:	53                   	push   %ebx
  8017b2:	89 c6                	mov    %eax,%esi
  8017b4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017b6:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017bd:	74 27                	je     8017e6 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017bf:	6a 07                	push   $0x7
  8017c1:	68 00 50 80 00       	push   $0x805000
  8017c6:	56                   	push   %esi
  8017c7:	ff 35 00 40 80 00    	pushl  0x804000
  8017cd:	e8 08 0c 00 00       	call   8023da <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017d2:	83 c4 0c             	add    $0xc,%esp
  8017d5:	6a 00                	push   $0x0
  8017d7:	53                   	push   %ebx
  8017d8:	6a 00                	push   $0x0
  8017da:	e8 92 0b 00 00       	call   802371 <ipc_recv>
}
  8017df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e2:	5b                   	pop    %ebx
  8017e3:	5e                   	pop    %esi
  8017e4:	5d                   	pop    %ebp
  8017e5:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017e6:	83 ec 0c             	sub    $0xc,%esp
  8017e9:	6a 01                	push   $0x1
  8017eb:	e8 42 0c 00 00       	call   802432 <ipc_find_env>
  8017f0:	a3 00 40 80 00       	mov    %eax,0x804000
  8017f5:	83 c4 10             	add    $0x10,%esp
  8017f8:	eb c5                	jmp    8017bf <fsipc+0x12>

008017fa <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801800:	8b 45 08             	mov    0x8(%ebp),%eax
  801803:	8b 40 0c             	mov    0xc(%eax),%eax
  801806:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80180b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801813:	ba 00 00 00 00       	mov    $0x0,%edx
  801818:	b8 02 00 00 00       	mov    $0x2,%eax
  80181d:	e8 8b ff ff ff       	call   8017ad <fsipc>
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <devfile_flush>:
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	8b 40 0c             	mov    0xc(%eax),%eax
  801830:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801835:	ba 00 00 00 00       	mov    $0x0,%edx
  80183a:	b8 06 00 00 00       	mov    $0x6,%eax
  80183f:	e8 69 ff ff ff       	call   8017ad <fsipc>
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <devfile_stat>:
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	53                   	push   %ebx
  80184a:	83 ec 04             	sub    $0x4,%esp
  80184d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	8b 40 0c             	mov    0xc(%eax),%eax
  801856:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80185b:	ba 00 00 00 00       	mov    $0x0,%edx
  801860:	b8 05 00 00 00       	mov    $0x5,%eax
  801865:	e8 43 ff ff ff       	call   8017ad <fsipc>
  80186a:	85 c0                	test   %eax,%eax
  80186c:	78 2c                	js     80189a <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80186e:	83 ec 08             	sub    $0x8,%esp
  801871:	68 00 50 80 00       	push   $0x805000
  801876:	53                   	push   %ebx
  801877:	e8 b8 f2 ff ff       	call   800b34 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80187c:	a1 80 50 80 00       	mov    0x805080,%eax
  801881:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801887:	a1 84 50 80 00       	mov    0x805084,%eax
  80188c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801892:	83 c4 10             	add    $0x10,%esp
  801895:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <devfile_write>:
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	53                   	push   %ebx
  8018a3:	83 ec 08             	sub    $0x8,%esp
  8018a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8018af:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8018b4:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8018ba:	53                   	push   %ebx
  8018bb:	ff 75 0c             	pushl  0xc(%ebp)
  8018be:	68 08 50 80 00       	push   $0x805008
  8018c3:	e8 5c f4 ff ff       	call   800d24 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cd:	b8 04 00 00 00       	mov    $0x4,%eax
  8018d2:	e8 d6 fe ff ff       	call   8017ad <fsipc>
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	78 0b                	js     8018e9 <devfile_write+0x4a>
	assert(r <= n);
  8018de:	39 d8                	cmp    %ebx,%eax
  8018e0:	77 0c                	ja     8018ee <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8018e2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018e7:	7f 1e                	jg     801907 <devfile_write+0x68>
}
  8018e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    
	assert(r <= n);
  8018ee:	68 68 2c 80 00       	push   $0x802c68
  8018f3:	68 6f 2c 80 00       	push   $0x802c6f
  8018f8:	68 98 00 00 00       	push   $0x98
  8018fd:	68 84 2c 80 00       	push   $0x802c84
  801902:	e8 d8 e9 ff ff       	call   8002df <_panic>
	assert(r <= PGSIZE);
  801907:	68 8f 2c 80 00       	push   $0x802c8f
  80190c:	68 6f 2c 80 00       	push   $0x802c6f
  801911:	68 99 00 00 00       	push   $0x99
  801916:	68 84 2c 80 00       	push   $0x802c84
  80191b:	e8 bf e9 ff ff       	call   8002df <_panic>

00801920 <devfile_read>:
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	56                   	push   %esi
  801924:	53                   	push   %ebx
  801925:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	8b 40 0c             	mov    0xc(%eax),%eax
  80192e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801933:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801939:	ba 00 00 00 00       	mov    $0x0,%edx
  80193e:	b8 03 00 00 00       	mov    $0x3,%eax
  801943:	e8 65 fe ff ff       	call   8017ad <fsipc>
  801948:	89 c3                	mov    %eax,%ebx
  80194a:	85 c0                	test   %eax,%eax
  80194c:	78 1f                	js     80196d <devfile_read+0x4d>
	assert(r <= n);
  80194e:	39 f0                	cmp    %esi,%eax
  801950:	77 24                	ja     801976 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801952:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801957:	7f 33                	jg     80198c <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801959:	83 ec 04             	sub    $0x4,%esp
  80195c:	50                   	push   %eax
  80195d:	68 00 50 80 00       	push   $0x805000
  801962:	ff 75 0c             	pushl  0xc(%ebp)
  801965:	e8 58 f3 ff ff       	call   800cc2 <memmove>
	return r;
  80196a:	83 c4 10             	add    $0x10,%esp
}
  80196d:	89 d8                	mov    %ebx,%eax
  80196f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801972:	5b                   	pop    %ebx
  801973:	5e                   	pop    %esi
  801974:	5d                   	pop    %ebp
  801975:	c3                   	ret    
	assert(r <= n);
  801976:	68 68 2c 80 00       	push   $0x802c68
  80197b:	68 6f 2c 80 00       	push   $0x802c6f
  801980:	6a 7c                	push   $0x7c
  801982:	68 84 2c 80 00       	push   $0x802c84
  801987:	e8 53 e9 ff ff       	call   8002df <_panic>
	assert(r <= PGSIZE);
  80198c:	68 8f 2c 80 00       	push   $0x802c8f
  801991:	68 6f 2c 80 00       	push   $0x802c6f
  801996:	6a 7d                	push   $0x7d
  801998:	68 84 2c 80 00       	push   $0x802c84
  80199d:	e8 3d e9 ff ff       	call   8002df <_panic>

008019a2 <open>:
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	56                   	push   %esi
  8019a6:	53                   	push   %ebx
  8019a7:	83 ec 1c             	sub    $0x1c,%esp
  8019aa:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019ad:	56                   	push   %esi
  8019ae:	e8 48 f1 ff ff       	call   800afb <strlen>
  8019b3:	83 c4 10             	add    $0x10,%esp
  8019b6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019bb:	7f 6c                	jg     801a29 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019bd:	83 ec 0c             	sub    $0xc,%esp
  8019c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c3:	50                   	push   %eax
  8019c4:	e8 79 f8 ff ff       	call   801242 <fd_alloc>
  8019c9:	89 c3                	mov    %eax,%ebx
  8019cb:	83 c4 10             	add    $0x10,%esp
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	78 3c                	js     801a0e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019d2:	83 ec 08             	sub    $0x8,%esp
  8019d5:	56                   	push   %esi
  8019d6:	68 00 50 80 00       	push   $0x805000
  8019db:	e8 54 f1 ff ff       	call   800b34 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e3:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8019f0:	e8 b8 fd ff ff       	call   8017ad <fsipc>
  8019f5:	89 c3                	mov    %eax,%ebx
  8019f7:	83 c4 10             	add    $0x10,%esp
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	78 19                	js     801a17 <open+0x75>
	return fd2num(fd);
  8019fe:	83 ec 0c             	sub    $0xc,%esp
  801a01:	ff 75 f4             	pushl  -0xc(%ebp)
  801a04:	e8 12 f8 ff ff       	call   80121b <fd2num>
  801a09:	89 c3                	mov    %eax,%ebx
  801a0b:	83 c4 10             	add    $0x10,%esp
}
  801a0e:	89 d8                	mov    %ebx,%eax
  801a10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a13:	5b                   	pop    %ebx
  801a14:	5e                   	pop    %esi
  801a15:	5d                   	pop    %ebp
  801a16:	c3                   	ret    
		fd_close(fd, 0);
  801a17:	83 ec 08             	sub    $0x8,%esp
  801a1a:	6a 00                	push   $0x0
  801a1c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a1f:	e8 1b f9 ff ff       	call   80133f <fd_close>
		return r;
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	eb e5                	jmp    801a0e <open+0x6c>
		return -E_BAD_PATH;
  801a29:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a2e:	eb de                	jmp    801a0e <open+0x6c>

00801a30 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a36:	ba 00 00 00 00       	mov    $0x0,%edx
  801a3b:	b8 08 00 00 00       	mov    $0x8,%eax
  801a40:	e8 68 fd ff ff       	call   8017ad <fsipc>
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a4d:	68 9b 2c 80 00       	push   $0x802c9b
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	e8 da f0 ff ff       	call   800b34 <strcpy>
	return 0;
}
  801a5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <devsock_close>:
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	53                   	push   %ebx
  801a65:	83 ec 10             	sub    $0x10,%esp
  801a68:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a6b:	53                   	push   %ebx
  801a6c:	e8 fc 09 00 00       	call   80246d <pageref>
  801a71:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a74:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a79:	83 f8 01             	cmp    $0x1,%eax
  801a7c:	74 07                	je     801a85 <devsock_close+0x24>
}
  801a7e:	89 d0                	mov    %edx,%eax
  801a80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a85:	83 ec 0c             	sub    $0xc,%esp
  801a88:	ff 73 0c             	pushl  0xc(%ebx)
  801a8b:	e8 b9 02 00 00       	call   801d49 <nsipc_close>
  801a90:	89 c2                	mov    %eax,%edx
  801a92:	83 c4 10             	add    $0x10,%esp
  801a95:	eb e7                	jmp    801a7e <devsock_close+0x1d>

00801a97 <devsock_write>:
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	ff 75 10             	pushl  0x10(%ebp)
  801aa2:	ff 75 0c             	pushl  0xc(%ebp)
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	ff 70 0c             	pushl  0xc(%eax)
  801aab:	e8 76 03 00 00       	call   801e26 <nsipc_send>
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <devsock_read>:
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ab8:	6a 00                	push   $0x0
  801aba:	ff 75 10             	pushl  0x10(%ebp)
  801abd:	ff 75 0c             	pushl  0xc(%ebp)
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac3:	ff 70 0c             	pushl  0xc(%eax)
  801ac6:	e8 ef 02 00 00       	call   801dba <nsipc_recv>
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <fd2sockid>:
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ad3:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ad6:	52                   	push   %edx
  801ad7:	50                   	push   %eax
  801ad8:	e8 b7 f7 ff ff       	call   801294 <fd_lookup>
  801add:	83 c4 10             	add    $0x10,%esp
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	78 10                	js     801af4 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae7:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801aed:	39 08                	cmp    %ecx,(%eax)
  801aef:	75 05                	jne    801af6 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801af1:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    
		return -E_NOT_SUPP;
  801af6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801afb:	eb f7                	jmp    801af4 <fd2sockid+0x27>

00801afd <alloc_sockfd>:
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	56                   	push   %esi
  801b01:	53                   	push   %ebx
  801b02:	83 ec 1c             	sub    $0x1c,%esp
  801b05:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b07:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0a:	50                   	push   %eax
  801b0b:	e8 32 f7 ff ff       	call   801242 <fd_alloc>
  801b10:	89 c3                	mov    %eax,%ebx
  801b12:	83 c4 10             	add    $0x10,%esp
  801b15:	85 c0                	test   %eax,%eax
  801b17:	78 43                	js     801b5c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b19:	83 ec 04             	sub    $0x4,%esp
  801b1c:	68 07 04 00 00       	push   $0x407
  801b21:	ff 75 f4             	pushl  -0xc(%ebp)
  801b24:	6a 00                	push   $0x0
  801b26:	e8 fb f3 ff ff       	call   800f26 <sys_page_alloc>
  801b2b:	89 c3                	mov    %eax,%ebx
  801b2d:	83 c4 10             	add    $0x10,%esp
  801b30:	85 c0                	test   %eax,%eax
  801b32:	78 28                	js     801b5c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b37:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b3d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b42:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b49:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b4c:	83 ec 0c             	sub    $0xc,%esp
  801b4f:	50                   	push   %eax
  801b50:	e8 c6 f6 ff ff       	call   80121b <fd2num>
  801b55:	89 c3                	mov    %eax,%ebx
  801b57:	83 c4 10             	add    $0x10,%esp
  801b5a:	eb 0c                	jmp    801b68 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b5c:	83 ec 0c             	sub    $0xc,%esp
  801b5f:	56                   	push   %esi
  801b60:	e8 e4 01 00 00       	call   801d49 <nsipc_close>
		return r;
  801b65:	83 c4 10             	add    $0x10,%esp
}
  801b68:	89 d8                	mov    %ebx,%eax
  801b6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b6d:	5b                   	pop    %ebx
  801b6e:	5e                   	pop    %esi
  801b6f:	5d                   	pop    %ebp
  801b70:	c3                   	ret    

00801b71 <accept>:
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	e8 4e ff ff ff       	call   801acd <fd2sockid>
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 1b                	js     801b9e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b83:	83 ec 04             	sub    $0x4,%esp
  801b86:	ff 75 10             	pushl  0x10(%ebp)
  801b89:	ff 75 0c             	pushl  0xc(%ebp)
  801b8c:	50                   	push   %eax
  801b8d:	e8 0e 01 00 00       	call   801ca0 <nsipc_accept>
  801b92:	83 c4 10             	add    $0x10,%esp
  801b95:	85 c0                	test   %eax,%eax
  801b97:	78 05                	js     801b9e <accept+0x2d>
	return alloc_sockfd(r);
  801b99:	e8 5f ff ff ff       	call   801afd <alloc_sockfd>
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <bind>:
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba9:	e8 1f ff ff ff       	call   801acd <fd2sockid>
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	78 12                	js     801bc4 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801bb2:	83 ec 04             	sub    $0x4,%esp
  801bb5:	ff 75 10             	pushl  0x10(%ebp)
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	50                   	push   %eax
  801bbc:	e8 31 01 00 00       	call   801cf2 <nsipc_bind>
  801bc1:	83 c4 10             	add    $0x10,%esp
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <shutdown>:
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	e8 f9 fe ff ff       	call   801acd <fd2sockid>
  801bd4:	85 c0                	test   %eax,%eax
  801bd6:	78 0f                	js     801be7 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801bd8:	83 ec 08             	sub    $0x8,%esp
  801bdb:	ff 75 0c             	pushl  0xc(%ebp)
  801bde:	50                   	push   %eax
  801bdf:	e8 43 01 00 00       	call   801d27 <nsipc_shutdown>
  801be4:	83 c4 10             	add    $0x10,%esp
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <connect>:
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	e8 d6 fe ff ff       	call   801acd <fd2sockid>
  801bf7:	85 c0                	test   %eax,%eax
  801bf9:	78 12                	js     801c0d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801bfb:	83 ec 04             	sub    $0x4,%esp
  801bfe:	ff 75 10             	pushl  0x10(%ebp)
  801c01:	ff 75 0c             	pushl  0xc(%ebp)
  801c04:	50                   	push   %eax
  801c05:	e8 59 01 00 00       	call   801d63 <nsipc_connect>
  801c0a:	83 c4 10             	add    $0x10,%esp
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <listen>:
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
  801c12:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	e8 b0 fe ff ff       	call   801acd <fd2sockid>
  801c1d:	85 c0                	test   %eax,%eax
  801c1f:	78 0f                	js     801c30 <listen+0x21>
	return nsipc_listen(r, backlog);
  801c21:	83 ec 08             	sub    $0x8,%esp
  801c24:	ff 75 0c             	pushl  0xc(%ebp)
  801c27:	50                   	push   %eax
  801c28:	e8 6b 01 00 00       	call   801d98 <nsipc_listen>
  801c2d:	83 c4 10             	add    $0x10,%esp
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <socket>:

int
socket(int domain, int type, int protocol)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c38:	ff 75 10             	pushl  0x10(%ebp)
  801c3b:	ff 75 0c             	pushl  0xc(%ebp)
  801c3e:	ff 75 08             	pushl  0x8(%ebp)
  801c41:	e8 3e 02 00 00       	call   801e84 <nsipc_socket>
  801c46:	83 c4 10             	add    $0x10,%esp
  801c49:	85 c0                	test   %eax,%eax
  801c4b:	78 05                	js     801c52 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c4d:	e8 ab fe ff ff       	call   801afd <alloc_sockfd>
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	53                   	push   %ebx
  801c58:	83 ec 04             	sub    $0x4,%esp
  801c5b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c5d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c64:	74 26                	je     801c8c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c66:	6a 07                	push   $0x7
  801c68:	68 00 60 80 00       	push   $0x806000
  801c6d:	53                   	push   %ebx
  801c6e:	ff 35 04 40 80 00    	pushl  0x804004
  801c74:	e8 61 07 00 00       	call   8023da <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c79:	83 c4 0c             	add    $0xc,%esp
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	e8 ea 06 00 00       	call   802371 <ipc_recv>
}
  801c87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c8c:	83 ec 0c             	sub    $0xc,%esp
  801c8f:	6a 02                	push   $0x2
  801c91:	e8 9c 07 00 00       	call   802432 <ipc_find_env>
  801c96:	a3 04 40 80 00       	mov    %eax,0x804004
  801c9b:	83 c4 10             	add    $0x10,%esp
  801c9e:	eb c6                	jmp    801c66 <nsipc+0x12>

00801ca0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	56                   	push   %esi
  801ca4:	53                   	push   %ebx
  801ca5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801cb0:	8b 06                	mov    (%esi),%eax
  801cb2:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801cb7:	b8 01 00 00 00       	mov    $0x1,%eax
  801cbc:	e8 93 ff ff ff       	call   801c54 <nsipc>
  801cc1:	89 c3                	mov    %eax,%ebx
  801cc3:	85 c0                	test   %eax,%eax
  801cc5:	79 09                	jns    801cd0 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801cc7:	89 d8                	mov    %ebx,%eax
  801cc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ccc:	5b                   	pop    %ebx
  801ccd:	5e                   	pop    %esi
  801cce:	5d                   	pop    %ebp
  801ccf:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cd0:	83 ec 04             	sub    $0x4,%esp
  801cd3:	ff 35 10 60 80 00    	pushl  0x806010
  801cd9:	68 00 60 80 00       	push   $0x806000
  801cde:	ff 75 0c             	pushl  0xc(%ebp)
  801ce1:	e8 dc ef ff ff       	call   800cc2 <memmove>
		*addrlen = ret->ret_addrlen;
  801ce6:	a1 10 60 80 00       	mov    0x806010,%eax
  801ceb:	89 06                	mov    %eax,(%esi)
  801ced:	83 c4 10             	add    $0x10,%esp
	return r;
  801cf0:	eb d5                	jmp    801cc7 <nsipc_accept+0x27>

00801cf2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	53                   	push   %ebx
  801cf6:	83 ec 08             	sub    $0x8,%esp
  801cf9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d04:	53                   	push   %ebx
  801d05:	ff 75 0c             	pushl  0xc(%ebp)
  801d08:	68 04 60 80 00       	push   $0x806004
  801d0d:	e8 b0 ef ff ff       	call   800cc2 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d12:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d18:	b8 02 00 00 00       	mov    $0x2,%eax
  801d1d:	e8 32 ff ff ff       	call   801c54 <nsipc>
}
  801d22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d38:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d3d:	b8 03 00 00 00       	mov    $0x3,%eax
  801d42:	e8 0d ff ff ff       	call   801c54 <nsipc>
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <nsipc_close>:

int
nsipc_close(int s)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d57:	b8 04 00 00 00       	mov    $0x4,%eax
  801d5c:	e8 f3 fe ff ff       	call   801c54 <nsipc>
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	53                   	push   %ebx
  801d67:	83 ec 08             	sub    $0x8,%esp
  801d6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d75:	53                   	push   %ebx
  801d76:	ff 75 0c             	pushl  0xc(%ebp)
  801d79:	68 04 60 80 00       	push   $0x806004
  801d7e:	e8 3f ef ff ff       	call   800cc2 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d83:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d89:	b8 05 00 00 00       	mov    $0x5,%eax
  801d8e:	e8 c1 fe ff ff       	call   801c54 <nsipc>
}
  801d93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da9:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801dae:	b8 06 00 00 00       	mov    $0x6,%eax
  801db3:	e8 9c fe ff ff       	call   801c54 <nsipc>
}
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	56                   	push   %esi
  801dbe:	53                   	push   %ebx
  801dbf:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801dca:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801dd0:	8b 45 14             	mov    0x14(%ebp),%eax
  801dd3:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801dd8:	b8 07 00 00 00       	mov    $0x7,%eax
  801ddd:	e8 72 fe ff ff       	call   801c54 <nsipc>
  801de2:	89 c3                	mov    %eax,%ebx
  801de4:	85 c0                	test   %eax,%eax
  801de6:	78 1f                	js     801e07 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801de8:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ded:	7f 21                	jg     801e10 <nsipc_recv+0x56>
  801def:	39 c6                	cmp    %eax,%esi
  801df1:	7c 1d                	jl     801e10 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801df3:	83 ec 04             	sub    $0x4,%esp
  801df6:	50                   	push   %eax
  801df7:	68 00 60 80 00       	push   $0x806000
  801dfc:	ff 75 0c             	pushl  0xc(%ebp)
  801dff:	e8 be ee ff ff       	call   800cc2 <memmove>
  801e04:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e07:	89 d8                	mov    %ebx,%eax
  801e09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0c:	5b                   	pop    %ebx
  801e0d:	5e                   	pop    %esi
  801e0e:	5d                   	pop    %ebp
  801e0f:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e10:	68 a7 2c 80 00       	push   $0x802ca7
  801e15:	68 6f 2c 80 00       	push   $0x802c6f
  801e1a:	6a 62                	push   $0x62
  801e1c:	68 bc 2c 80 00       	push   $0x802cbc
  801e21:	e8 b9 e4 ff ff       	call   8002df <_panic>

00801e26 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	53                   	push   %ebx
  801e2a:	83 ec 04             	sub    $0x4,%esp
  801e2d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e30:	8b 45 08             	mov    0x8(%ebp),%eax
  801e33:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e38:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e3e:	7f 2e                	jg     801e6e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e40:	83 ec 04             	sub    $0x4,%esp
  801e43:	53                   	push   %ebx
  801e44:	ff 75 0c             	pushl  0xc(%ebp)
  801e47:	68 0c 60 80 00       	push   $0x80600c
  801e4c:	e8 71 ee ff ff       	call   800cc2 <memmove>
	nsipcbuf.send.req_size = size;
  801e51:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e57:	8b 45 14             	mov    0x14(%ebp),%eax
  801e5a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e5f:	b8 08 00 00 00       	mov    $0x8,%eax
  801e64:	e8 eb fd ff ff       	call   801c54 <nsipc>
}
  801e69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    
	assert(size < 1600);
  801e6e:	68 c8 2c 80 00       	push   $0x802cc8
  801e73:	68 6f 2c 80 00       	push   $0x802c6f
  801e78:	6a 6d                	push   $0x6d
  801e7a:	68 bc 2c 80 00       	push   $0x802cbc
  801e7f:	e8 5b e4 ff ff       	call   8002df <_panic>

00801e84 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e95:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e9a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ea2:	b8 09 00 00 00       	mov    $0x9,%eax
  801ea7:	e8 a8 fd ff ff       	call   801c54 <nsipc>
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	56                   	push   %esi
  801eb2:	53                   	push   %ebx
  801eb3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801eb6:	83 ec 0c             	sub    $0xc,%esp
  801eb9:	ff 75 08             	pushl  0x8(%ebp)
  801ebc:	e8 6a f3 ff ff       	call   80122b <fd2data>
  801ec1:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ec3:	83 c4 08             	add    $0x8,%esp
  801ec6:	68 d4 2c 80 00       	push   $0x802cd4
  801ecb:	53                   	push   %ebx
  801ecc:	e8 63 ec ff ff       	call   800b34 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ed1:	8b 46 04             	mov    0x4(%esi),%eax
  801ed4:	2b 06                	sub    (%esi),%eax
  801ed6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801edc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ee3:	00 00 00 
	stat->st_dev = &devpipe;
  801ee6:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801eed:	30 80 00 
	return 0;
}
  801ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ef8:	5b                   	pop    %ebx
  801ef9:	5e                   	pop    %esi
  801efa:	5d                   	pop    %ebp
  801efb:	c3                   	ret    

00801efc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	53                   	push   %ebx
  801f00:	83 ec 0c             	sub    $0xc,%esp
  801f03:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f06:	53                   	push   %ebx
  801f07:	6a 00                	push   $0x0
  801f09:	e8 9d f0 ff ff       	call   800fab <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f0e:	89 1c 24             	mov    %ebx,(%esp)
  801f11:	e8 15 f3 ff ff       	call   80122b <fd2data>
  801f16:	83 c4 08             	add    $0x8,%esp
  801f19:	50                   	push   %eax
  801f1a:	6a 00                	push   $0x0
  801f1c:	e8 8a f0 ff ff       	call   800fab <sys_page_unmap>
}
  801f21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <_pipeisclosed>:
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	57                   	push   %edi
  801f2a:	56                   	push   %esi
  801f2b:	53                   	push   %ebx
  801f2c:	83 ec 1c             	sub    $0x1c,%esp
  801f2f:	89 c7                	mov    %eax,%edi
  801f31:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f33:	a1 08 40 80 00       	mov    0x804008,%eax
  801f38:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f3b:	83 ec 0c             	sub    $0xc,%esp
  801f3e:	57                   	push   %edi
  801f3f:	e8 29 05 00 00       	call   80246d <pageref>
  801f44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f47:	89 34 24             	mov    %esi,(%esp)
  801f4a:	e8 1e 05 00 00       	call   80246d <pageref>
		nn = thisenv->env_runs;
  801f4f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f55:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f58:	83 c4 10             	add    $0x10,%esp
  801f5b:	39 cb                	cmp    %ecx,%ebx
  801f5d:	74 1b                	je     801f7a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f5f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f62:	75 cf                	jne    801f33 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f64:	8b 42 58             	mov    0x58(%edx),%eax
  801f67:	6a 01                	push   $0x1
  801f69:	50                   	push   %eax
  801f6a:	53                   	push   %ebx
  801f6b:	68 db 2c 80 00       	push   $0x802cdb
  801f70:	e8 60 e4 ff ff       	call   8003d5 <cprintf>
  801f75:	83 c4 10             	add    $0x10,%esp
  801f78:	eb b9                	jmp    801f33 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f7a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f7d:	0f 94 c0             	sete   %al
  801f80:	0f b6 c0             	movzbl %al,%eax
}
  801f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f86:	5b                   	pop    %ebx
  801f87:	5e                   	pop    %esi
  801f88:	5f                   	pop    %edi
  801f89:	5d                   	pop    %ebp
  801f8a:	c3                   	ret    

00801f8b <devpipe_write>:
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	57                   	push   %edi
  801f8f:	56                   	push   %esi
  801f90:	53                   	push   %ebx
  801f91:	83 ec 28             	sub    $0x28,%esp
  801f94:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f97:	56                   	push   %esi
  801f98:	e8 8e f2 ff ff       	call   80122b <fd2data>
  801f9d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f9f:	83 c4 10             	add    $0x10,%esp
  801fa2:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa7:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801faa:	74 4f                	je     801ffb <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fac:	8b 43 04             	mov    0x4(%ebx),%eax
  801faf:	8b 0b                	mov    (%ebx),%ecx
  801fb1:	8d 51 20             	lea    0x20(%ecx),%edx
  801fb4:	39 d0                	cmp    %edx,%eax
  801fb6:	72 14                	jb     801fcc <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801fb8:	89 da                	mov    %ebx,%edx
  801fba:	89 f0                	mov    %esi,%eax
  801fbc:	e8 65 ff ff ff       	call   801f26 <_pipeisclosed>
  801fc1:	85 c0                	test   %eax,%eax
  801fc3:	75 3b                	jne    802000 <devpipe_write+0x75>
			sys_yield();
  801fc5:	e8 3d ef ff ff       	call   800f07 <sys_yield>
  801fca:	eb e0                	jmp    801fac <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fcf:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801fd3:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fd6:	89 c2                	mov    %eax,%edx
  801fd8:	c1 fa 1f             	sar    $0x1f,%edx
  801fdb:	89 d1                	mov    %edx,%ecx
  801fdd:	c1 e9 1b             	shr    $0x1b,%ecx
  801fe0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801fe3:	83 e2 1f             	and    $0x1f,%edx
  801fe6:	29 ca                	sub    %ecx,%edx
  801fe8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801fec:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ff0:	83 c0 01             	add    $0x1,%eax
  801ff3:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ff6:	83 c7 01             	add    $0x1,%edi
  801ff9:	eb ac                	jmp    801fa7 <devpipe_write+0x1c>
	return i;
  801ffb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ffe:	eb 05                	jmp    802005 <devpipe_write+0x7a>
				return 0;
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802005:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802008:	5b                   	pop    %ebx
  802009:	5e                   	pop    %esi
  80200a:	5f                   	pop    %edi
  80200b:	5d                   	pop    %ebp
  80200c:	c3                   	ret    

0080200d <devpipe_read>:
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	57                   	push   %edi
  802011:	56                   	push   %esi
  802012:	53                   	push   %ebx
  802013:	83 ec 18             	sub    $0x18,%esp
  802016:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802019:	57                   	push   %edi
  80201a:	e8 0c f2 ff ff       	call   80122b <fd2data>
  80201f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802021:	83 c4 10             	add    $0x10,%esp
  802024:	be 00 00 00 00       	mov    $0x0,%esi
  802029:	3b 75 10             	cmp    0x10(%ebp),%esi
  80202c:	75 14                	jne    802042 <devpipe_read+0x35>
	return i;
  80202e:	8b 45 10             	mov    0x10(%ebp),%eax
  802031:	eb 02                	jmp    802035 <devpipe_read+0x28>
				return i;
  802033:	89 f0                	mov    %esi,%eax
}
  802035:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802038:	5b                   	pop    %ebx
  802039:	5e                   	pop    %esi
  80203a:	5f                   	pop    %edi
  80203b:	5d                   	pop    %ebp
  80203c:	c3                   	ret    
			sys_yield();
  80203d:	e8 c5 ee ff ff       	call   800f07 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802042:	8b 03                	mov    (%ebx),%eax
  802044:	3b 43 04             	cmp    0x4(%ebx),%eax
  802047:	75 18                	jne    802061 <devpipe_read+0x54>
			if (i > 0)
  802049:	85 f6                	test   %esi,%esi
  80204b:	75 e6                	jne    802033 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80204d:	89 da                	mov    %ebx,%edx
  80204f:	89 f8                	mov    %edi,%eax
  802051:	e8 d0 fe ff ff       	call   801f26 <_pipeisclosed>
  802056:	85 c0                	test   %eax,%eax
  802058:	74 e3                	je     80203d <devpipe_read+0x30>
				return 0;
  80205a:	b8 00 00 00 00       	mov    $0x0,%eax
  80205f:	eb d4                	jmp    802035 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802061:	99                   	cltd   
  802062:	c1 ea 1b             	shr    $0x1b,%edx
  802065:	01 d0                	add    %edx,%eax
  802067:	83 e0 1f             	and    $0x1f,%eax
  80206a:	29 d0                	sub    %edx,%eax
  80206c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802071:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802074:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802077:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80207a:	83 c6 01             	add    $0x1,%esi
  80207d:	eb aa                	jmp    802029 <devpipe_read+0x1c>

0080207f <pipe>:
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	56                   	push   %esi
  802083:	53                   	push   %ebx
  802084:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802087:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80208a:	50                   	push   %eax
  80208b:	e8 b2 f1 ff ff       	call   801242 <fd_alloc>
  802090:	89 c3                	mov    %eax,%ebx
  802092:	83 c4 10             	add    $0x10,%esp
  802095:	85 c0                	test   %eax,%eax
  802097:	0f 88 23 01 00 00    	js     8021c0 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80209d:	83 ec 04             	sub    $0x4,%esp
  8020a0:	68 07 04 00 00       	push   $0x407
  8020a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8020a8:	6a 00                	push   $0x0
  8020aa:	e8 77 ee ff ff       	call   800f26 <sys_page_alloc>
  8020af:	89 c3                	mov    %eax,%ebx
  8020b1:	83 c4 10             	add    $0x10,%esp
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	0f 88 04 01 00 00    	js     8021c0 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8020bc:	83 ec 0c             	sub    $0xc,%esp
  8020bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020c2:	50                   	push   %eax
  8020c3:	e8 7a f1 ff ff       	call   801242 <fd_alloc>
  8020c8:	89 c3                	mov    %eax,%ebx
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	0f 88 db 00 00 00    	js     8021b0 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020d5:	83 ec 04             	sub    $0x4,%esp
  8020d8:	68 07 04 00 00       	push   $0x407
  8020dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8020e0:	6a 00                	push   $0x0
  8020e2:	e8 3f ee ff ff       	call   800f26 <sys_page_alloc>
  8020e7:	89 c3                	mov    %eax,%ebx
  8020e9:	83 c4 10             	add    $0x10,%esp
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	0f 88 bc 00 00 00    	js     8021b0 <pipe+0x131>
	va = fd2data(fd0);
  8020f4:	83 ec 0c             	sub    $0xc,%esp
  8020f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8020fa:	e8 2c f1 ff ff       	call   80122b <fd2data>
  8020ff:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802101:	83 c4 0c             	add    $0xc,%esp
  802104:	68 07 04 00 00       	push   $0x407
  802109:	50                   	push   %eax
  80210a:	6a 00                	push   $0x0
  80210c:	e8 15 ee ff ff       	call   800f26 <sys_page_alloc>
  802111:	89 c3                	mov    %eax,%ebx
  802113:	83 c4 10             	add    $0x10,%esp
  802116:	85 c0                	test   %eax,%eax
  802118:	0f 88 82 00 00 00    	js     8021a0 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80211e:	83 ec 0c             	sub    $0xc,%esp
  802121:	ff 75 f0             	pushl  -0x10(%ebp)
  802124:	e8 02 f1 ff ff       	call   80122b <fd2data>
  802129:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802130:	50                   	push   %eax
  802131:	6a 00                	push   $0x0
  802133:	56                   	push   %esi
  802134:	6a 00                	push   $0x0
  802136:	e8 2e ee ff ff       	call   800f69 <sys_page_map>
  80213b:	89 c3                	mov    %eax,%ebx
  80213d:	83 c4 20             	add    $0x20,%esp
  802140:	85 c0                	test   %eax,%eax
  802142:	78 4e                	js     802192 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802144:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80214e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802151:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802158:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80215b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80215d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802160:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802167:	83 ec 0c             	sub    $0xc,%esp
  80216a:	ff 75 f4             	pushl  -0xc(%ebp)
  80216d:	e8 a9 f0 ff ff       	call   80121b <fd2num>
  802172:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802175:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802177:	83 c4 04             	add    $0x4,%esp
  80217a:	ff 75 f0             	pushl  -0x10(%ebp)
  80217d:	e8 99 f0 ff ff       	call   80121b <fd2num>
  802182:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802185:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802188:	83 c4 10             	add    $0x10,%esp
  80218b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802190:	eb 2e                	jmp    8021c0 <pipe+0x141>
	sys_page_unmap(0, va);
  802192:	83 ec 08             	sub    $0x8,%esp
  802195:	56                   	push   %esi
  802196:	6a 00                	push   $0x0
  802198:	e8 0e ee ff ff       	call   800fab <sys_page_unmap>
  80219d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8021a0:	83 ec 08             	sub    $0x8,%esp
  8021a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8021a6:	6a 00                	push   $0x0
  8021a8:	e8 fe ed ff ff       	call   800fab <sys_page_unmap>
  8021ad:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8021b0:	83 ec 08             	sub    $0x8,%esp
  8021b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8021b6:	6a 00                	push   $0x0
  8021b8:	e8 ee ed ff ff       	call   800fab <sys_page_unmap>
  8021bd:	83 c4 10             	add    $0x10,%esp
}
  8021c0:	89 d8                	mov    %ebx,%eax
  8021c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021c5:	5b                   	pop    %ebx
  8021c6:	5e                   	pop    %esi
  8021c7:	5d                   	pop    %ebp
  8021c8:	c3                   	ret    

008021c9 <pipeisclosed>:
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021d2:	50                   	push   %eax
  8021d3:	ff 75 08             	pushl  0x8(%ebp)
  8021d6:	e8 b9 f0 ff ff       	call   801294 <fd_lookup>
  8021db:	83 c4 10             	add    $0x10,%esp
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	78 18                	js     8021fa <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8021e2:	83 ec 0c             	sub    $0xc,%esp
  8021e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e8:	e8 3e f0 ff ff       	call   80122b <fd2data>
	return _pipeisclosed(fd, p);
  8021ed:	89 c2                	mov    %eax,%edx
  8021ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f2:	e8 2f fd ff ff       	call   801f26 <_pipeisclosed>
  8021f7:	83 c4 10             	add    $0x10,%esp
}
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802201:	c3                   	ret    

00802202 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802208:	68 f3 2c 80 00       	push   $0x802cf3
  80220d:	ff 75 0c             	pushl  0xc(%ebp)
  802210:	e8 1f e9 ff ff       	call   800b34 <strcpy>
	return 0;
}
  802215:	b8 00 00 00 00       	mov    $0x0,%eax
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    

0080221c <devcons_write>:
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
  80221f:	57                   	push   %edi
  802220:	56                   	push   %esi
  802221:	53                   	push   %ebx
  802222:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802228:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80222d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802233:	3b 75 10             	cmp    0x10(%ebp),%esi
  802236:	73 31                	jae    802269 <devcons_write+0x4d>
		m = n - tot;
  802238:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80223b:	29 f3                	sub    %esi,%ebx
  80223d:	83 fb 7f             	cmp    $0x7f,%ebx
  802240:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802245:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802248:	83 ec 04             	sub    $0x4,%esp
  80224b:	53                   	push   %ebx
  80224c:	89 f0                	mov    %esi,%eax
  80224e:	03 45 0c             	add    0xc(%ebp),%eax
  802251:	50                   	push   %eax
  802252:	57                   	push   %edi
  802253:	e8 6a ea ff ff       	call   800cc2 <memmove>
		sys_cputs(buf, m);
  802258:	83 c4 08             	add    $0x8,%esp
  80225b:	53                   	push   %ebx
  80225c:	57                   	push   %edi
  80225d:	e8 08 ec ff ff       	call   800e6a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802262:	01 de                	add    %ebx,%esi
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	eb ca                	jmp    802233 <devcons_write+0x17>
}
  802269:	89 f0                	mov    %esi,%eax
  80226b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80226e:	5b                   	pop    %ebx
  80226f:	5e                   	pop    %esi
  802270:	5f                   	pop    %edi
  802271:	5d                   	pop    %ebp
  802272:	c3                   	ret    

00802273 <devcons_read>:
{
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
  802276:	83 ec 08             	sub    $0x8,%esp
  802279:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80227e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802282:	74 21                	je     8022a5 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802284:	e8 ff eb ff ff       	call   800e88 <sys_cgetc>
  802289:	85 c0                	test   %eax,%eax
  80228b:	75 07                	jne    802294 <devcons_read+0x21>
		sys_yield();
  80228d:	e8 75 ec ff ff       	call   800f07 <sys_yield>
  802292:	eb f0                	jmp    802284 <devcons_read+0x11>
	if (c < 0)
  802294:	78 0f                	js     8022a5 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802296:	83 f8 04             	cmp    $0x4,%eax
  802299:	74 0c                	je     8022a7 <devcons_read+0x34>
	*(char*)vbuf = c;
  80229b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229e:	88 02                	mov    %al,(%edx)
	return 1;
  8022a0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022a5:	c9                   	leave  
  8022a6:	c3                   	ret    
		return 0;
  8022a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ac:	eb f7                	jmp    8022a5 <devcons_read+0x32>

008022ae <cputchar>:
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8022ba:	6a 01                	push   $0x1
  8022bc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022bf:	50                   	push   %eax
  8022c0:	e8 a5 eb ff ff       	call   800e6a <sys_cputs>
}
  8022c5:	83 c4 10             	add    $0x10,%esp
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <getchar>:
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8022d0:	6a 01                	push   $0x1
  8022d2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022d5:	50                   	push   %eax
  8022d6:	6a 00                	push   $0x0
  8022d8:	e8 27 f2 ff ff       	call   801504 <read>
	if (r < 0)
  8022dd:	83 c4 10             	add    $0x10,%esp
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	78 06                	js     8022ea <getchar+0x20>
	if (r < 1)
  8022e4:	74 06                	je     8022ec <getchar+0x22>
	return c;
  8022e6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8022ea:	c9                   	leave  
  8022eb:	c3                   	ret    
		return -E_EOF;
  8022ec:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8022f1:	eb f7                	jmp    8022ea <getchar+0x20>

008022f3 <iscons>:
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022fc:	50                   	push   %eax
  8022fd:	ff 75 08             	pushl  0x8(%ebp)
  802300:	e8 8f ef ff ff       	call   801294 <fd_lookup>
  802305:	83 c4 10             	add    $0x10,%esp
  802308:	85 c0                	test   %eax,%eax
  80230a:	78 11                	js     80231d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802315:	39 10                	cmp    %edx,(%eax)
  802317:	0f 94 c0             	sete   %al
  80231a:	0f b6 c0             	movzbl %al,%eax
}
  80231d:	c9                   	leave  
  80231e:	c3                   	ret    

0080231f <opencons>:
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
  802322:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802325:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802328:	50                   	push   %eax
  802329:	e8 14 ef ff ff       	call   801242 <fd_alloc>
  80232e:	83 c4 10             	add    $0x10,%esp
  802331:	85 c0                	test   %eax,%eax
  802333:	78 3a                	js     80236f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802335:	83 ec 04             	sub    $0x4,%esp
  802338:	68 07 04 00 00       	push   $0x407
  80233d:	ff 75 f4             	pushl  -0xc(%ebp)
  802340:	6a 00                	push   $0x0
  802342:	e8 df eb ff ff       	call   800f26 <sys_page_alloc>
  802347:	83 c4 10             	add    $0x10,%esp
  80234a:	85 c0                	test   %eax,%eax
  80234c:	78 21                	js     80236f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80234e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802351:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802357:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802363:	83 ec 0c             	sub    $0xc,%esp
  802366:	50                   	push   %eax
  802367:	e8 af ee ff ff       	call   80121b <fd2num>
  80236c:	83 c4 10             	add    $0x10,%esp
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
  802374:	56                   	push   %esi
  802375:	53                   	push   %ebx
  802376:	8b 75 08             	mov    0x8(%ebp),%esi
  802379:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80237f:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802381:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802386:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802389:	83 ec 0c             	sub    $0xc,%esp
  80238c:	50                   	push   %eax
  80238d:	e8 44 ed ff ff       	call   8010d6 <sys_ipc_recv>
	if(ret < 0){
  802392:	83 c4 10             	add    $0x10,%esp
  802395:	85 c0                	test   %eax,%eax
  802397:	78 2b                	js     8023c4 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802399:	85 f6                	test   %esi,%esi
  80239b:	74 0a                	je     8023a7 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80239d:	a1 08 40 80 00       	mov    0x804008,%eax
  8023a2:	8b 40 74             	mov    0x74(%eax),%eax
  8023a5:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8023a7:	85 db                	test   %ebx,%ebx
  8023a9:	74 0a                	je     8023b5 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8023ab:	a1 08 40 80 00       	mov    0x804008,%eax
  8023b0:	8b 40 78             	mov    0x78(%eax),%eax
  8023b3:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8023b5:	a1 08 40 80 00       	mov    0x804008,%eax
  8023ba:	8b 40 70             	mov    0x70(%eax),%eax
}
  8023bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023c0:	5b                   	pop    %ebx
  8023c1:	5e                   	pop    %esi
  8023c2:	5d                   	pop    %ebp
  8023c3:	c3                   	ret    
		if(from_env_store)
  8023c4:	85 f6                	test   %esi,%esi
  8023c6:	74 06                	je     8023ce <ipc_recv+0x5d>
			*from_env_store = 0;
  8023c8:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8023ce:	85 db                	test   %ebx,%ebx
  8023d0:	74 eb                	je     8023bd <ipc_recv+0x4c>
			*perm_store = 0;
  8023d2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8023d8:	eb e3                	jmp    8023bd <ipc_recv+0x4c>

008023da <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8023da:	55                   	push   %ebp
  8023db:	89 e5                	mov    %esp,%ebp
  8023dd:	57                   	push   %edi
  8023de:	56                   	push   %esi
  8023df:	53                   	push   %ebx
  8023e0:	83 ec 0c             	sub    $0xc,%esp
  8023e3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023e6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8023ec:	85 db                	test   %ebx,%ebx
  8023ee:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023f3:	0f 44 d8             	cmove  %eax,%ebx
  8023f6:	eb 05                	jmp    8023fd <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8023f8:	e8 0a eb ff ff       	call   800f07 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8023fd:	ff 75 14             	pushl  0x14(%ebp)
  802400:	53                   	push   %ebx
  802401:	56                   	push   %esi
  802402:	57                   	push   %edi
  802403:	e8 ab ec ff ff       	call   8010b3 <sys_ipc_try_send>
  802408:	83 c4 10             	add    $0x10,%esp
  80240b:	85 c0                	test   %eax,%eax
  80240d:	74 1b                	je     80242a <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80240f:	79 e7                	jns    8023f8 <ipc_send+0x1e>
  802411:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802414:	74 e2                	je     8023f8 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802416:	83 ec 04             	sub    $0x4,%esp
  802419:	68 ff 2c 80 00       	push   $0x802cff
  80241e:	6a 46                	push   $0x46
  802420:	68 14 2d 80 00       	push   $0x802d14
  802425:	e8 b5 de ff ff       	call   8002df <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80242a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80242d:	5b                   	pop    %ebx
  80242e:	5e                   	pop    %esi
  80242f:	5f                   	pop    %edi
  802430:	5d                   	pop    %ebp
  802431:	c3                   	ret    

00802432 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
  802435:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802438:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80243d:	89 c2                	mov    %eax,%edx
  80243f:	c1 e2 07             	shl    $0x7,%edx
  802442:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802448:	8b 52 50             	mov    0x50(%edx),%edx
  80244b:	39 ca                	cmp    %ecx,%edx
  80244d:	74 11                	je     802460 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80244f:	83 c0 01             	add    $0x1,%eax
  802452:	3d 00 04 00 00       	cmp    $0x400,%eax
  802457:	75 e4                	jne    80243d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802459:	b8 00 00 00 00       	mov    $0x0,%eax
  80245e:	eb 0b                	jmp    80246b <ipc_find_env+0x39>
			return envs[i].env_id;
  802460:	c1 e0 07             	shl    $0x7,%eax
  802463:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802468:	8b 40 48             	mov    0x48(%eax),%eax
}
  80246b:	5d                   	pop    %ebp
  80246c:	c3                   	ret    

0080246d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80246d:	55                   	push   %ebp
  80246e:	89 e5                	mov    %esp,%ebp
  802470:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802473:	89 d0                	mov    %edx,%eax
  802475:	c1 e8 16             	shr    $0x16,%eax
  802478:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80247f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802484:	f6 c1 01             	test   $0x1,%cl
  802487:	74 1d                	je     8024a6 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802489:	c1 ea 0c             	shr    $0xc,%edx
  80248c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802493:	f6 c2 01             	test   $0x1,%dl
  802496:	74 0e                	je     8024a6 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802498:	c1 ea 0c             	shr    $0xc,%edx
  80249b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024a2:	ef 
  8024a3:	0f b7 c0             	movzwl %ax,%eax
}
  8024a6:	5d                   	pop    %ebp
  8024a7:	c3                   	ret    
  8024a8:	66 90                	xchg   %ax,%ax
  8024aa:	66 90                	xchg   %ax,%ax
  8024ac:	66 90                	xchg   %ax,%ax
  8024ae:	66 90                	xchg   %ax,%ax

008024b0 <__udivdi3>:
  8024b0:	55                   	push   %ebp
  8024b1:	57                   	push   %edi
  8024b2:	56                   	push   %esi
  8024b3:	53                   	push   %ebx
  8024b4:	83 ec 1c             	sub    $0x1c,%esp
  8024b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8024bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8024bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024c7:	85 d2                	test   %edx,%edx
  8024c9:	75 4d                	jne    802518 <__udivdi3+0x68>
  8024cb:	39 f3                	cmp    %esi,%ebx
  8024cd:	76 19                	jbe    8024e8 <__udivdi3+0x38>
  8024cf:	31 ff                	xor    %edi,%edi
  8024d1:	89 e8                	mov    %ebp,%eax
  8024d3:	89 f2                	mov    %esi,%edx
  8024d5:	f7 f3                	div    %ebx
  8024d7:	89 fa                	mov    %edi,%edx
  8024d9:	83 c4 1c             	add    $0x1c,%esp
  8024dc:	5b                   	pop    %ebx
  8024dd:	5e                   	pop    %esi
  8024de:	5f                   	pop    %edi
  8024df:	5d                   	pop    %ebp
  8024e0:	c3                   	ret    
  8024e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024e8:	89 d9                	mov    %ebx,%ecx
  8024ea:	85 db                	test   %ebx,%ebx
  8024ec:	75 0b                	jne    8024f9 <__udivdi3+0x49>
  8024ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f3:	31 d2                	xor    %edx,%edx
  8024f5:	f7 f3                	div    %ebx
  8024f7:	89 c1                	mov    %eax,%ecx
  8024f9:	31 d2                	xor    %edx,%edx
  8024fb:	89 f0                	mov    %esi,%eax
  8024fd:	f7 f1                	div    %ecx
  8024ff:	89 c6                	mov    %eax,%esi
  802501:	89 e8                	mov    %ebp,%eax
  802503:	89 f7                	mov    %esi,%edi
  802505:	f7 f1                	div    %ecx
  802507:	89 fa                	mov    %edi,%edx
  802509:	83 c4 1c             	add    $0x1c,%esp
  80250c:	5b                   	pop    %ebx
  80250d:	5e                   	pop    %esi
  80250e:	5f                   	pop    %edi
  80250f:	5d                   	pop    %ebp
  802510:	c3                   	ret    
  802511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802518:	39 f2                	cmp    %esi,%edx
  80251a:	77 1c                	ja     802538 <__udivdi3+0x88>
  80251c:	0f bd fa             	bsr    %edx,%edi
  80251f:	83 f7 1f             	xor    $0x1f,%edi
  802522:	75 2c                	jne    802550 <__udivdi3+0xa0>
  802524:	39 f2                	cmp    %esi,%edx
  802526:	72 06                	jb     80252e <__udivdi3+0x7e>
  802528:	31 c0                	xor    %eax,%eax
  80252a:	39 eb                	cmp    %ebp,%ebx
  80252c:	77 a9                	ja     8024d7 <__udivdi3+0x27>
  80252e:	b8 01 00 00 00       	mov    $0x1,%eax
  802533:	eb a2                	jmp    8024d7 <__udivdi3+0x27>
  802535:	8d 76 00             	lea    0x0(%esi),%esi
  802538:	31 ff                	xor    %edi,%edi
  80253a:	31 c0                	xor    %eax,%eax
  80253c:	89 fa                	mov    %edi,%edx
  80253e:	83 c4 1c             	add    $0x1c,%esp
  802541:	5b                   	pop    %ebx
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    
  802546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80254d:	8d 76 00             	lea    0x0(%esi),%esi
  802550:	89 f9                	mov    %edi,%ecx
  802552:	b8 20 00 00 00       	mov    $0x20,%eax
  802557:	29 f8                	sub    %edi,%eax
  802559:	d3 e2                	shl    %cl,%edx
  80255b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80255f:	89 c1                	mov    %eax,%ecx
  802561:	89 da                	mov    %ebx,%edx
  802563:	d3 ea                	shr    %cl,%edx
  802565:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802569:	09 d1                	or     %edx,%ecx
  80256b:	89 f2                	mov    %esi,%edx
  80256d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802571:	89 f9                	mov    %edi,%ecx
  802573:	d3 e3                	shl    %cl,%ebx
  802575:	89 c1                	mov    %eax,%ecx
  802577:	d3 ea                	shr    %cl,%edx
  802579:	89 f9                	mov    %edi,%ecx
  80257b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80257f:	89 eb                	mov    %ebp,%ebx
  802581:	d3 e6                	shl    %cl,%esi
  802583:	89 c1                	mov    %eax,%ecx
  802585:	d3 eb                	shr    %cl,%ebx
  802587:	09 de                	or     %ebx,%esi
  802589:	89 f0                	mov    %esi,%eax
  80258b:	f7 74 24 08          	divl   0x8(%esp)
  80258f:	89 d6                	mov    %edx,%esi
  802591:	89 c3                	mov    %eax,%ebx
  802593:	f7 64 24 0c          	mull   0xc(%esp)
  802597:	39 d6                	cmp    %edx,%esi
  802599:	72 15                	jb     8025b0 <__udivdi3+0x100>
  80259b:	89 f9                	mov    %edi,%ecx
  80259d:	d3 e5                	shl    %cl,%ebp
  80259f:	39 c5                	cmp    %eax,%ebp
  8025a1:	73 04                	jae    8025a7 <__udivdi3+0xf7>
  8025a3:	39 d6                	cmp    %edx,%esi
  8025a5:	74 09                	je     8025b0 <__udivdi3+0x100>
  8025a7:	89 d8                	mov    %ebx,%eax
  8025a9:	31 ff                	xor    %edi,%edi
  8025ab:	e9 27 ff ff ff       	jmp    8024d7 <__udivdi3+0x27>
  8025b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025b3:	31 ff                	xor    %edi,%edi
  8025b5:	e9 1d ff ff ff       	jmp    8024d7 <__udivdi3+0x27>
  8025ba:	66 90                	xchg   %ax,%ax
  8025bc:	66 90                	xchg   %ax,%ax
  8025be:	66 90                	xchg   %ax,%ax

008025c0 <__umoddi3>:
  8025c0:	55                   	push   %ebp
  8025c1:	57                   	push   %edi
  8025c2:	56                   	push   %esi
  8025c3:	53                   	push   %ebx
  8025c4:	83 ec 1c             	sub    $0x1c,%esp
  8025c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8025cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8025d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025d7:	89 da                	mov    %ebx,%edx
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	75 43                	jne    802620 <__umoddi3+0x60>
  8025dd:	39 df                	cmp    %ebx,%edi
  8025df:	76 17                	jbe    8025f8 <__umoddi3+0x38>
  8025e1:	89 f0                	mov    %esi,%eax
  8025e3:	f7 f7                	div    %edi
  8025e5:	89 d0                	mov    %edx,%eax
  8025e7:	31 d2                	xor    %edx,%edx
  8025e9:	83 c4 1c             	add    $0x1c,%esp
  8025ec:	5b                   	pop    %ebx
  8025ed:	5e                   	pop    %esi
  8025ee:	5f                   	pop    %edi
  8025ef:	5d                   	pop    %ebp
  8025f0:	c3                   	ret    
  8025f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025f8:	89 fd                	mov    %edi,%ebp
  8025fa:	85 ff                	test   %edi,%edi
  8025fc:	75 0b                	jne    802609 <__umoddi3+0x49>
  8025fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802603:	31 d2                	xor    %edx,%edx
  802605:	f7 f7                	div    %edi
  802607:	89 c5                	mov    %eax,%ebp
  802609:	89 d8                	mov    %ebx,%eax
  80260b:	31 d2                	xor    %edx,%edx
  80260d:	f7 f5                	div    %ebp
  80260f:	89 f0                	mov    %esi,%eax
  802611:	f7 f5                	div    %ebp
  802613:	89 d0                	mov    %edx,%eax
  802615:	eb d0                	jmp    8025e7 <__umoddi3+0x27>
  802617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80261e:	66 90                	xchg   %ax,%ax
  802620:	89 f1                	mov    %esi,%ecx
  802622:	39 d8                	cmp    %ebx,%eax
  802624:	76 0a                	jbe    802630 <__umoddi3+0x70>
  802626:	89 f0                	mov    %esi,%eax
  802628:	83 c4 1c             	add    $0x1c,%esp
  80262b:	5b                   	pop    %ebx
  80262c:	5e                   	pop    %esi
  80262d:	5f                   	pop    %edi
  80262e:	5d                   	pop    %ebp
  80262f:	c3                   	ret    
  802630:	0f bd e8             	bsr    %eax,%ebp
  802633:	83 f5 1f             	xor    $0x1f,%ebp
  802636:	75 20                	jne    802658 <__umoddi3+0x98>
  802638:	39 d8                	cmp    %ebx,%eax
  80263a:	0f 82 b0 00 00 00    	jb     8026f0 <__umoddi3+0x130>
  802640:	39 f7                	cmp    %esi,%edi
  802642:	0f 86 a8 00 00 00    	jbe    8026f0 <__umoddi3+0x130>
  802648:	89 c8                	mov    %ecx,%eax
  80264a:	83 c4 1c             	add    $0x1c,%esp
  80264d:	5b                   	pop    %ebx
  80264e:	5e                   	pop    %esi
  80264f:	5f                   	pop    %edi
  802650:	5d                   	pop    %ebp
  802651:	c3                   	ret    
  802652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802658:	89 e9                	mov    %ebp,%ecx
  80265a:	ba 20 00 00 00       	mov    $0x20,%edx
  80265f:	29 ea                	sub    %ebp,%edx
  802661:	d3 e0                	shl    %cl,%eax
  802663:	89 44 24 08          	mov    %eax,0x8(%esp)
  802667:	89 d1                	mov    %edx,%ecx
  802669:	89 f8                	mov    %edi,%eax
  80266b:	d3 e8                	shr    %cl,%eax
  80266d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802671:	89 54 24 04          	mov    %edx,0x4(%esp)
  802675:	8b 54 24 04          	mov    0x4(%esp),%edx
  802679:	09 c1                	or     %eax,%ecx
  80267b:	89 d8                	mov    %ebx,%eax
  80267d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802681:	89 e9                	mov    %ebp,%ecx
  802683:	d3 e7                	shl    %cl,%edi
  802685:	89 d1                	mov    %edx,%ecx
  802687:	d3 e8                	shr    %cl,%eax
  802689:	89 e9                	mov    %ebp,%ecx
  80268b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80268f:	d3 e3                	shl    %cl,%ebx
  802691:	89 c7                	mov    %eax,%edi
  802693:	89 d1                	mov    %edx,%ecx
  802695:	89 f0                	mov    %esi,%eax
  802697:	d3 e8                	shr    %cl,%eax
  802699:	89 e9                	mov    %ebp,%ecx
  80269b:	89 fa                	mov    %edi,%edx
  80269d:	d3 e6                	shl    %cl,%esi
  80269f:	09 d8                	or     %ebx,%eax
  8026a1:	f7 74 24 08          	divl   0x8(%esp)
  8026a5:	89 d1                	mov    %edx,%ecx
  8026a7:	89 f3                	mov    %esi,%ebx
  8026a9:	f7 64 24 0c          	mull   0xc(%esp)
  8026ad:	89 c6                	mov    %eax,%esi
  8026af:	89 d7                	mov    %edx,%edi
  8026b1:	39 d1                	cmp    %edx,%ecx
  8026b3:	72 06                	jb     8026bb <__umoddi3+0xfb>
  8026b5:	75 10                	jne    8026c7 <__umoddi3+0x107>
  8026b7:	39 c3                	cmp    %eax,%ebx
  8026b9:	73 0c                	jae    8026c7 <__umoddi3+0x107>
  8026bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8026bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8026c3:	89 d7                	mov    %edx,%edi
  8026c5:	89 c6                	mov    %eax,%esi
  8026c7:	89 ca                	mov    %ecx,%edx
  8026c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026ce:	29 f3                	sub    %esi,%ebx
  8026d0:	19 fa                	sbb    %edi,%edx
  8026d2:	89 d0                	mov    %edx,%eax
  8026d4:	d3 e0                	shl    %cl,%eax
  8026d6:	89 e9                	mov    %ebp,%ecx
  8026d8:	d3 eb                	shr    %cl,%ebx
  8026da:	d3 ea                	shr    %cl,%edx
  8026dc:	09 d8                	or     %ebx,%eax
  8026de:	83 c4 1c             	add    $0x1c,%esp
  8026e1:	5b                   	pop    %ebx
  8026e2:	5e                   	pop    %esi
  8026e3:	5f                   	pop    %edi
  8026e4:	5d                   	pop    %ebp
  8026e5:	c3                   	ret    
  8026e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026ed:	8d 76 00             	lea    0x0(%esi),%esi
  8026f0:	89 da                	mov    %ebx,%edx
  8026f2:	29 fe                	sub    %edi,%esi
  8026f4:	19 c2                	sbb    %eax,%edx
  8026f6:	89 f1                	mov    %esi,%ecx
  8026f8:	89 c8                	mov    %ecx,%eax
  8026fa:	e9 4b ff ff ff       	jmp    80264a <__umoddi3+0x8a>
