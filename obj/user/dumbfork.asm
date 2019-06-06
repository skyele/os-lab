
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
  80009c:	68 e0 26 80 00       	push   $0x8026e0
  8000a1:	6a 20                	push   $0x20
  8000a3:	68 f3 26 80 00       	push   $0x8026f3
  8000a8:	e8 32 02 00 00       	call   8002df <_panic>
		panic("sys_page_map: %e", r);
  8000ad:	50                   	push   %eax
  8000ae:	68 03 27 80 00       	push   $0x802703
  8000b3:	6a 22                	push   $0x22
  8000b5:	68 f3 26 80 00       	push   $0x8026f3
  8000ba:	e8 20 02 00 00       	call   8002df <_panic>
		panic("sys_page_unmap: %e", r);
  8000bf:	50                   	push   %eax
  8000c0:	68 14 27 80 00       	push   $0x802714
  8000c5:	6a 25                	push   $0x25
  8000c7:	68 f3 26 80 00       	push   $0x8026f3
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
  800113:	68 27 27 80 00       	push   $0x802727
  800118:	6a 37                	push   $0x37
  80011a:	68 f3 26 80 00       	push   $0x8026f3
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
  80016b:	68 37 27 80 00       	push   $0x802737
  800170:	6a 4c                	push   $0x4c
  800172:	68 f3 26 80 00       	push   $0x8026f3
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
  80018e:	be 4e 27 80 00       	mov    $0x80274e,%esi
  800193:	b8 55 27 80 00       	mov    $0x802755,%eax
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
  8001ac:	68 5b 27 80 00       	push   $0x80275b
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
  800255:	68 6d 27 80 00       	push   $0x80276d
  80025a:	e8 76 01 00 00       	call   8003d5 <cprintf>
	cprintf("before umain\n");
  80025f:	c7 04 24 8b 27 80 00 	movl   $0x80278b,(%esp)
  800266:	e8 6a 01 00 00       	call   8003d5 <cprintf>
	// call user main routine
	umain(argc, argv);
  80026b:	83 c4 08             	add    $0x8,%esp
  80026e:	ff 75 0c             	pushl  0xc(%ebp)
  800271:	ff 75 08             	pushl  0x8(%ebp)
  800274:	e8 03 ff ff ff       	call   80017c <umain>
	cprintf("after umain\n");
  800279:	c7 04 24 99 27 80 00 	movl   $0x802799,(%esp)
  800280:	e8 50 01 00 00       	call   8003d5 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800285:	a1 08 40 80 00       	mov    0x804008,%eax
  80028a:	8b 40 48             	mov    0x48(%eax),%eax
  80028d:	83 c4 08             	add    $0x8,%esp
  800290:	50                   	push   %eax
  800291:	68 a6 27 80 00       	push   $0x8027a6
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
  8002b9:	68 d0 27 80 00       	push   $0x8027d0
  8002be:	50                   	push   %eax
  8002bf:	68 c5 27 80 00       	push   $0x8027c5
  8002c4:	e8 0c 01 00 00       	call   8003d5 <cprintf>
	close_all();
  8002c9:	e8 05 11 00 00       	call   8013d3 <close_all>
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
  8002ef:	68 fc 27 80 00       	push   $0x8027fc
  8002f4:	50                   	push   %eax
  8002f5:	68 c5 27 80 00       	push   $0x8027c5
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
  800318:	68 d8 27 80 00       	push   $0x8027d8
  80031d:	e8 b3 00 00 00       	call   8003d5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800322:	83 c4 18             	add    $0x18,%esp
  800325:	53                   	push   %ebx
  800326:	ff 75 10             	pushl  0x10(%ebp)
  800329:	e8 56 00 00 00       	call   800384 <vcprintf>
	cprintf("\n");
  80032e:	c7 04 24 89 27 80 00 	movl   $0x802789,(%esp)
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
  800482:	e8 09 20 00 00       	call   802490 <__udivdi3>
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
  8004ab:	e8 f0 20 00 00       	call   8025a0 <__umoddi3>
  8004b0:	83 c4 14             	add    $0x14,%esp
  8004b3:	0f be 80 03 28 80 00 	movsbl 0x802803(%eax),%eax
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
  80055c:	ff 24 85 e0 29 80 00 	jmp    *0x8029e0(,%eax,4)
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
  800627:	8b 14 85 40 2b 80 00 	mov    0x802b40(,%eax,4),%edx
  80062e:	85 d2                	test   %edx,%edx
  800630:	74 18                	je     80064a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800632:	52                   	push   %edx
  800633:	68 61 2c 80 00       	push   $0x802c61
  800638:	53                   	push   %ebx
  800639:	56                   	push   %esi
  80063a:	e8 a6 fe ff ff       	call   8004e5 <printfmt>
  80063f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800642:	89 7d 14             	mov    %edi,0x14(%ebp)
  800645:	e9 fe 02 00 00       	jmp    800948 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80064a:	50                   	push   %eax
  80064b:	68 1b 28 80 00       	push   $0x80281b
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
  800672:	b8 14 28 80 00       	mov    $0x802814,%eax
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
  800a0a:	bf 39 29 80 00       	mov    $0x802939,%edi
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
  800a36:	bf 71 29 80 00       	mov    $0x802971,%edi
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
  800ed7:	68 88 2b 80 00       	push   $0x802b88
  800edc:	6a 43                	push   $0x43
  800ede:	68 a5 2b 80 00       	push   $0x802ba5
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
  800f58:	68 88 2b 80 00       	push   $0x802b88
  800f5d:	6a 43                	push   $0x43
  800f5f:	68 a5 2b 80 00       	push   $0x802ba5
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
  800f9a:	68 88 2b 80 00       	push   $0x802b88
  800f9f:	6a 43                	push   $0x43
  800fa1:	68 a5 2b 80 00       	push   $0x802ba5
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
  800fdc:	68 88 2b 80 00       	push   $0x802b88
  800fe1:	6a 43                	push   $0x43
  800fe3:	68 a5 2b 80 00       	push   $0x802ba5
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
  80101e:	68 88 2b 80 00       	push   $0x802b88
  801023:	6a 43                	push   $0x43
  801025:	68 a5 2b 80 00       	push   $0x802ba5
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
  801060:	68 88 2b 80 00       	push   $0x802b88
  801065:	6a 43                	push   $0x43
  801067:	68 a5 2b 80 00       	push   $0x802ba5
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
  8010a2:	68 88 2b 80 00       	push   $0x802b88
  8010a7:	6a 43                	push   $0x43
  8010a9:	68 a5 2b 80 00       	push   $0x802ba5
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
  801106:	68 88 2b 80 00       	push   $0x802b88
  80110b:	6a 43                	push   $0x43
  80110d:	68 a5 2b 80 00       	push   $0x802ba5
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
  8011ea:	68 88 2b 80 00       	push   $0x802b88
  8011ef:	6a 43                	push   $0x43
  8011f1:	68 a5 2b 80 00       	push   $0x802ba5
  8011f6:	e8 e4 f0 ff ff       	call   8002df <_panic>

008011fb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	05 00 00 00 30       	add    $0x30000000,%eax
  801206:	c1 e8 0c             	shr    $0xc,%eax
}
  801209:	5d                   	pop    %ebp
  80120a:	c3                   	ret    

0080120b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801216:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80121b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    

00801222 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80122a:	89 c2                	mov    %eax,%edx
  80122c:	c1 ea 16             	shr    $0x16,%edx
  80122f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801236:	f6 c2 01             	test   $0x1,%dl
  801239:	74 2d                	je     801268 <fd_alloc+0x46>
  80123b:	89 c2                	mov    %eax,%edx
  80123d:	c1 ea 0c             	shr    $0xc,%edx
  801240:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801247:	f6 c2 01             	test   $0x1,%dl
  80124a:	74 1c                	je     801268 <fd_alloc+0x46>
  80124c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801251:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801256:	75 d2                	jne    80122a <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801261:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801266:	eb 0a                	jmp    801272 <fd_alloc+0x50>
			*fd_store = fd;
  801268:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80126b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80126d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801272:	5d                   	pop    %ebp
  801273:	c3                   	ret    

00801274 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80127a:	83 f8 1f             	cmp    $0x1f,%eax
  80127d:	77 30                	ja     8012af <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80127f:	c1 e0 0c             	shl    $0xc,%eax
  801282:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801287:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80128d:	f6 c2 01             	test   $0x1,%dl
  801290:	74 24                	je     8012b6 <fd_lookup+0x42>
  801292:	89 c2                	mov    %eax,%edx
  801294:	c1 ea 0c             	shr    $0xc,%edx
  801297:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80129e:	f6 c2 01             	test   $0x1,%dl
  8012a1:	74 1a                	je     8012bd <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a6:	89 02                	mov    %eax,(%edx)
	return 0;
  8012a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ad:	5d                   	pop    %ebp
  8012ae:	c3                   	ret    
		return -E_INVAL;
  8012af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012b4:	eb f7                	jmp    8012ad <fd_lookup+0x39>
		return -E_INVAL;
  8012b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012bb:	eb f0                	jmp    8012ad <fd_lookup+0x39>
  8012bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c2:	eb e9                	jmp    8012ad <fd_lookup+0x39>

008012c4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8012cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d2:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012d7:	39 08                	cmp    %ecx,(%eax)
  8012d9:	74 38                	je     801313 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8012db:	83 c2 01             	add    $0x1,%edx
  8012de:	8b 04 95 34 2c 80 00 	mov    0x802c34(,%edx,4),%eax
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	75 ee                	jne    8012d7 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012e9:	a1 08 40 80 00       	mov    0x804008,%eax
  8012ee:	8b 40 48             	mov    0x48(%eax),%eax
  8012f1:	83 ec 04             	sub    $0x4,%esp
  8012f4:	51                   	push   %ecx
  8012f5:	50                   	push   %eax
  8012f6:	68 b4 2b 80 00       	push   $0x802bb4
  8012fb:	e8 d5 f0 ff ff       	call   8003d5 <cprintf>
	*dev = 0;
  801300:	8b 45 0c             	mov    0xc(%ebp),%eax
  801303:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801309:	83 c4 10             	add    $0x10,%esp
  80130c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801311:	c9                   	leave  
  801312:	c3                   	ret    
			*dev = devtab[i];
  801313:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801316:	89 01                	mov    %eax,(%ecx)
			return 0;
  801318:	b8 00 00 00 00       	mov    $0x0,%eax
  80131d:	eb f2                	jmp    801311 <dev_lookup+0x4d>

0080131f <fd_close>:
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	57                   	push   %edi
  801323:	56                   	push   %esi
  801324:	53                   	push   %ebx
  801325:	83 ec 24             	sub    $0x24,%esp
  801328:	8b 75 08             	mov    0x8(%ebp),%esi
  80132b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80132e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801331:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801332:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801338:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80133b:	50                   	push   %eax
  80133c:	e8 33 ff ff ff       	call   801274 <fd_lookup>
  801341:	89 c3                	mov    %eax,%ebx
  801343:	83 c4 10             	add    $0x10,%esp
  801346:	85 c0                	test   %eax,%eax
  801348:	78 05                	js     80134f <fd_close+0x30>
	    || fd != fd2)
  80134a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80134d:	74 16                	je     801365 <fd_close+0x46>
		return (must_exist ? r : 0);
  80134f:	89 f8                	mov    %edi,%eax
  801351:	84 c0                	test   %al,%al
  801353:	b8 00 00 00 00       	mov    $0x0,%eax
  801358:	0f 44 d8             	cmove  %eax,%ebx
}
  80135b:	89 d8                	mov    %ebx,%eax
  80135d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801360:	5b                   	pop    %ebx
  801361:	5e                   	pop    %esi
  801362:	5f                   	pop    %edi
  801363:	5d                   	pop    %ebp
  801364:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801365:	83 ec 08             	sub    $0x8,%esp
  801368:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80136b:	50                   	push   %eax
  80136c:	ff 36                	pushl  (%esi)
  80136e:	e8 51 ff ff ff       	call   8012c4 <dev_lookup>
  801373:	89 c3                	mov    %eax,%ebx
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	85 c0                	test   %eax,%eax
  80137a:	78 1a                	js     801396 <fd_close+0x77>
		if (dev->dev_close)
  80137c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80137f:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801382:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801387:	85 c0                	test   %eax,%eax
  801389:	74 0b                	je     801396 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80138b:	83 ec 0c             	sub    $0xc,%esp
  80138e:	56                   	push   %esi
  80138f:	ff d0                	call   *%eax
  801391:	89 c3                	mov    %eax,%ebx
  801393:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801396:	83 ec 08             	sub    $0x8,%esp
  801399:	56                   	push   %esi
  80139a:	6a 00                	push   $0x0
  80139c:	e8 0a fc ff ff       	call   800fab <sys_page_unmap>
	return r;
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	eb b5                	jmp    80135b <fd_close+0x3c>

008013a6 <close>:

int
close(int fdnum)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013af:	50                   	push   %eax
  8013b0:	ff 75 08             	pushl  0x8(%ebp)
  8013b3:	e8 bc fe ff ff       	call   801274 <fd_lookup>
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	85 c0                	test   %eax,%eax
  8013bd:	79 02                	jns    8013c1 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    
		return fd_close(fd, 1);
  8013c1:	83 ec 08             	sub    $0x8,%esp
  8013c4:	6a 01                	push   $0x1
  8013c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8013c9:	e8 51 ff ff ff       	call   80131f <fd_close>
  8013ce:	83 c4 10             	add    $0x10,%esp
  8013d1:	eb ec                	jmp    8013bf <close+0x19>

008013d3 <close_all>:

void
close_all(void)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	53                   	push   %ebx
  8013d7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013da:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013df:	83 ec 0c             	sub    $0xc,%esp
  8013e2:	53                   	push   %ebx
  8013e3:	e8 be ff ff ff       	call   8013a6 <close>
	for (i = 0; i < MAXFD; i++)
  8013e8:	83 c3 01             	add    $0x1,%ebx
  8013eb:	83 c4 10             	add    $0x10,%esp
  8013ee:	83 fb 20             	cmp    $0x20,%ebx
  8013f1:	75 ec                	jne    8013df <close_all+0xc>
}
  8013f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f6:	c9                   	leave  
  8013f7:	c3                   	ret    

008013f8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
  8013fb:	57                   	push   %edi
  8013fc:	56                   	push   %esi
  8013fd:	53                   	push   %ebx
  8013fe:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801401:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801404:	50                   	push   %eax
  801405:	ff 75 08             	pushl  0x8(%ebp)
  801408:	e8 67 fe ff ff       	call   801274 <fd_lookup>
  80140d:	89 c3                	mov    %eax,%ebx
  80140f:	83 c4 10             	add    $0x10,%esp
  801412:	85 c0                	test   %eax,%eax
  801414:	0f 88 81 00 00 00    	js     80149b <dup+0xa3>
		return r;
	close(newfdnum);
  80141a:	83 ec 0c             	sub    $0xc,%esp
  80141d:	ff 75 0c             	pushl  0xc(%ebp)
  801420:	e8 81 ff ff ff       	call   8013a6 <close>

	newfd = INDEX2FD(newfdnum);
  801425:	8b 75 0c             	mov    0xc(%ebp),%esi
  801428:	c1 e6 0c             	shl    $0xc,%esi
  80142b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801431:	83 c4 04             	add    $0x4,%esp
  801434:	ff 75 e4             	pushl  -0x1c(%ebp)
  801437:	e8 cf fd ff ff       	call   80120b <fd2data>
  80143c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80143e:	89 34 24             	mov    %esi,(%esp)
  801441:	e8 c5 fd ff ff       	call   80120b <fd2data>
  801446:	83 c4 10             	add    $0x10,%esp
  801449:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80144b:	89 d8                	mov    %ebx,%eax
  80144d:	c1 e8 16             	shr    $0x16,%eax
  801450:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801457:	a8 01                	test   $0x1,%al
  801459:	74 11                	je     80146c <dup+0x74>
  80145b:	89 d8                	mov    %ebx,%eax
  80145d:	c1 e8 0c             	shr    $0xc,%eax
  801460:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801467:	f6 c2 01             	test   $0x1,%dl
  80146a:	75 39                	jne    8014a5 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80146c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80146f:	89 d0                	mov    %edx,%eax
  801471:	c1 e8 0c             	shr    $0xc,%eax
  801474:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80147b:	83 ec 0c             	sub    $0xc,%esp
  80147e:	25 07 0e 00 00       	and    $0xe07,%eax
  801483:	50                   	push   %eax
  801484:	56                   	push   %esi
  801485:	6a 00                	push   $0x0
  801487:	52                   	push   %edx
  801488:	6a 00                	push   $0x0
  80148a:	e8 da fa ff ff       	call   800f69 <sys_page_map>
  80148f:	89 c3                	mov    %eax,%ebx
  801491:	83 c4 20             	add    $0x20,%esp
  801494:	85 c0                	test   %eax,%eax
  801496:	78 31                	js     8014c9 <dup+0xd1>
		goto err;

	return newfdnum;
  801498:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80149b:	89 d8                	mov    %ebx,%eax
  80149d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a0:	5b                   	pop    %ebx
  8014a1:	5e                   	pop    %esi
  8014a2:	5f                   	pop    %edi
  8014a3:	5d                   	pop    %ebp
  8014a4:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014a5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014ac:	83 ec 0c             	sub    $0xc,%esp
  8014af:	25 07 0e 00 00       	and    $0xe07,%eax
  8014b4:	50                   	push   %eax
  8014b5:	57                   	push   %edi
  8014b6:	6a 00                	push   $0x0
  8014b8:	53                   	push   %ebx
  8014b9:	6a 00                	push   $0x0
  8014bb:	e8 a9 fa ff ff       	call   800f69 <sys_page_map>
  8014c0:	89 c3                	mov    %eax,%ebx
  8014c2:	83 c4 20             	add    $0x20,%esp
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	79 a3                	jns    80146c <dup+0x74>
	sys_page_unmap(0, newfd);
  8014c9:	83 ec 08             	sub    $0x8,%esp
  8014cc:	56                   	push   %esi
  8014cd:	6a 00                	push   $0x0
  8014cf:	e8 d7 fa ff ff       	call   800fab <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014d4:	83 c4 08             	add    $0x8,%esp
  8014d7:	57                   	push   %edi
  8014d8:	6a 00                	push   $0x0
  8014da:	e8 cc fa ff ff       	call   800fab <sys_page_unmap>
	return r;
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	eb b7                	jmp    80149b <dup+0xa3>

008014e4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	53                   	push   %ebx
  8014e8:	83 ec 1c             	sub    $0x1c,%esp
  8014eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f1:	50                   	push   %eax
  8014f2:	53                   	push   %ebx
  8014f3:	e8 7c fd ff ff       	call   801274 <fd_lookup>
  8014f8:	83 c4 10             	add    $0x10,%esp
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	78 3f                	js     80153e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ff:	83 ec 08             	sub    $0x8,%esp
  801502:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801505:	50                   	push   %eax
  801506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801509:	ff 30                	pushl  (%eax)
  80150b:	e8 b4 fd ff ff       	call   8012c4 <dev_lookup>
  801510:	83 c4 10             	add    $0x10,%esp
  801513:	85 c0                	test   %eax,%eax
  801515:	78 27                	js     80153e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801517:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80151a:	8b 42 08             	mov    0x8(%edx),%eax
  80151d:	83 e0 03             	and    $0x3,%eax
  801520:	83 f8 01             	cmp    $0x1,%eax
  801523:	74 1e                	je     801543 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801528:	8b 40 08             	mov    0x8(%eax),%eax
  80152b:	85 c0                	test   %eax,%eax
  80152d:	74 35                	je     801564 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80152f:	83 ec 04             	sub    $0x4,%esp
  801532:	ff 75 10             	pushl  0x10(%ebp)
  801535:	ff 75 0c             	pushl  0xc(%ebp)
  801538:	52                   	push   %edx
  801539:	ff d0                	call   *%eax
  80153b:	83 c4 10             	add    $0x10,%esp
}
  80153e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801541:	c9                   	leave  
  801542:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801543:	a1 08 40 80 00       	mov    0x804008,%eax
  801548:	8b 40 48             	mov    0x48(%eax),%eax
  80154b:	83 ec 04             	sub    $0x4,%esp
  80154e:	53                   	push   %ebx
  80154f:	50                   	push   %eax
  801550:	68 f8 2b 80 00       	push   $0x802bf8
  801555:	e8 7b ee ff ff       	call   8003d5 <cprintf>
		return -E_INVAL;
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801562:	eb da                	jmp    80153e <read+0x5a>
		return -E_NOT_SUPP;
  801564:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801569:	eb d3                	jmp    80153e <read+0x5a>

0080156b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	57                   	push   %edi
  80156f:	56                   	push   %esi
  801570:	53                   	push   %ebx
  801571:	83 ec 0c             	sub    $0xc,%esp
  801574:	8b 7d 08             	mov    0x8(%ebp),%edi
  801577:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80157a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80157f:	39 f3                	cmp    %esi,%ebx
  801581:	73 23                	jae    8015a6 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801583:	83 ec 04             	sub    $0x4,%esp
  801586:	89 f0                	mov    %esi,%eax
  801588:	29 d8                	sub    %ebx,%eax
  80158a:	50                   	push   %eax
  80158b:	89 d8                	mov    %ebx,%eax
  80158d:	03 45 0c             	add    0xc(%ebp),%eax
  801590:	50                   	push   %eax
  801591:	57                   	push   %edi
  801592:	e8 4d ff ff ff       	call   8014e4 <read>
		if (m < 0)
  801597:	83 c4 10             	add    $0x10,%esp
  80159a:	85 c0                	test   %eax,%eax
  80159c:	78 06                	js     8015a4 <readn+0x39>
			return m;
		if (m == 0)
  80159e:	74 06                	je     8015a6 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8015a0:	01 c3                	add    %eax,%ebx
  8015a2:	eb db                	jmp    80157f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015a4:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015a6:	89 d8                	mov    %ebx,%eax
  8015a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015ab:	5b                   	pop    %ebx
  8015ac:	5e                   	pop    %esi
  8015ad:	5f                   	pop    %edi
  8015ae:	5d                   	pop    %ebp
  8015af:	c3                   	ret    

008015b0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	53                   	push   %ebx
  8015b4:	83 ec 1c             	sub    $0x1c,%esp
  8015b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015bd:	50                   	push   %eax
  8015be:	53                   	push   %ebx
  8015bf:	e8 b0 fc ff ff       	call   801274 <fd_lookup>
  8015c4:	83 c4 10             	add    $0x10,%esp
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	78 3a                	js     801605 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015cb:	83 ec 08             	sub    $0x8,%esp
  8015ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d1:	50                   	push   %eax
  8015d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d5:	ff 30                	pushl  (%eax)
  8015d7:	e8 e8 fc ff ff       	call   8012c4 <dev_lookup>
  8015dc:	83 c4 10             	add    $0x10,%esp
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	78 22                	js     801605 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015ea:	74 1e                	je     80160a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ef:	8b 52 0c             	mov    0xc(%edx),%edx
  8015f2:	85 d2                	test   %edx,%edx
  8015f4:	74 35                	je     80162b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015f6:	83 ec 04             	sub    $0x4,%esp
  8015f9:	ff 75 10             	pushl  0x10(%ebp)
  8015fc:	ff 75 0c             	pushl  0xc(%ebp)
  8015ff:	50                   	push   %eax
  801600:	ff d2                	call   *%edx
  801602:	83 c4 10             	add    $0x10,%esp
}
  801605:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801608:	c9                   	leave  
  801609:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80160a:	a1 08 40 80 00       	mov    0x804008,%eax
  80160f:	8b 40 48             	mov    0x48(%eax),%eax
  801612:	83 ec 04             	sub    $0x4,%esp
  801615:	53                   	push   %ebx
  801616:	50                   	push   %eax
  801617:	68 14 2c 80 00       	push   $0x802c14
  80161c:	e8 b4 ed ff ff       	call   8003d5 <cprintf>
		return -E_INVAL;
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801629:	eb da                	jmp    801605 <write+0x55>
		return -E_NOT_SUPP;
  80162b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801630:	eb d3                	jmp    801605 <write+0x55>

00801632 <seek>:

int
seek(int fdnum, off_t offset)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801638:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163b:	50                   	push   %eax
  80163c:	ff 75 08             	pushl  0x8(%ebp)
  80163f:	e8 30 fc ff ff       	call   801274 <fd_lookup>
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	85 c0                	test   %eax,%eax
  801649:	78 0e                	js     801659 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80164b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801651:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801654:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	53                   	push   %ebx
  80165f:	83 ec 1c             	sub    $0x1c,%esp
  801662:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801665:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801668:	50                   	push   %eax
  801669:	53                   	push   %ebx
  80166a:	e8 05 fc ff ff       	call   801274 <fd_lookup>
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	85 c0                	test   %eax,%eax
  801674:	78 37                	js     8016ad <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801676:	83 ec 08             	sub    $0x8,%esp
  801679:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167c:	50                   	push   %eax
  80167d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801680:	ff 30                	pushl  (%eax)
  801682:	e8 3d fc ff ff       	call   8012c4 <dev_lookup>
  801687:	83 c4 10             	add    $0x10,%esp
  80168a:	85 c0                	test   %eax,%eax
  80168c:	78 1f                	js     8016ad <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80168e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801691:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801695:	74 1b                	je     8016b2 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801697:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80169a:	8b 52 18             	mov    0x18(%edx),%edx
  80169d:	85 d2                	test   %edx,%edx
  80169f:	74 32                	je     8016d3 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016a1:	83 ec 08             	sub    $0x8,%esp
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	50                   	push   %eax
  8016a8:	ff d2                	call   *%edx
  8016aa:	83 c4 10             	add    $0x10,%esp
}
  8016ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016b2:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016b7:	8b 40 48             	mov    0x48(%eax),%eax
  8016ba:	83 ec 04             	sub    $0x4,%esp
  8016bd:	53                   	push   %ebx
  8016be:	50                   	push   %eax
  8016bf:	68 d4 2b 80 00       	push   $0x802bd4
  8016c4:	e8 0c ed ff ff       	call   8003d5 <cprintf>
		return -E_INVAL;
  8016c9:	83 c4 10             	add    $0x10,%esp
  8016cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d1:	eb da                	jmp    8016ad <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016d8:	eb d3                	jmp    8016ad <ftruncate+0x52>

008016da <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	53                   	push   %ebx
  8016de:	83 ec 1c             	sub    $0x1c,%esp
  8016e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e7:	50                   	push   %eax
  8016e8:	ff 75 08             	pushl  0x8(%ebp)
  8016eb:	e8 84 fb ff ff       	call   801274 <fd_lookup>
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	78 4b                	js     801742 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f7:	83 ec 08             	sub    $0x8,%esp
  8016fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016fd:	50                   	push   %eax
  8016fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801701:	ff 30                	pushl  (%eax)
  801703:	e8 bc fb ff ff       	call   8012c4 <dev_lookup>
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	85 c0                	test   %eax,%eax
  80170d:	78 33                	js     801742 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80170f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801712:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801716:	74 2f                	je     801747 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801718:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80171b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801722:	00 00 00 
	stat->st_isdir = 0;
  801725:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80172c:	00 00 00 
	stat->st_dev = dev;
  80172f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801735:	83 ec 08             	sub    $0x8,%esp
  801738:	53                   	push   %ebx
  801739:	ff 75 f0             	pushl  -0x10(%ebp)
  80173c:	ff 50 14             	call   *0x14(%eax)
  80173f:	83 c4 10             	add    $0x10,%esp
}
  801742:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801745:	c9                   	leave  
  801746:	c3                   	ret    
		return -E_NOT_SUPP;
  801747:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80174c:	eb f4                	jmp    801742 <fstat+0x68>

0080174e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	56                   	push   %esi
  801752:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801753:	83 ec 08             	sub    $0x8,%esp
  801756:	6a 00                	push   $0x0
  801758:	ff 75 08             	pushl  0x8(%ebp)
  80175b:	e8 22 02 00 00       	call   801982 <open>
  801760:	89 c3                	mov    %eax,%ebx
  801762:	83 c4 10             	add    $0x10,%esp
  801765:	85 c0                	test   %eax,%eax
  801767:	78 1b                	js     801784 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801769:	83 ec 08             	sub    $0x8,%esp
  80176c:	ff 75 0c             	pushl  0xc(%ebp)
  80176f:	50                   	push   %eax
  801770:	e8 65 ff ff ff       	call   8016da <fstat>
  801775:	89 c6                	mov    %eax,%esi
	close(fd);
  801777:	89 1c 24             	mov    %ebx,(%esp)
  80177a:	e8 27 fc ff ff       	call   8013a6 <close>
	return r;
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	89 f3                	mov    %esi,%ebx
}
  801784:	89 d8                	mov    %ebx,%eax
  801786:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801789:	5b                   	pop    %ebx
  80178a:	5e                   	pop    %esi
  80178b:	5d                   	pop    %ebp
  80178c:	c3                   	ret    

0080178d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	56                   	push   %esi
  801791:	53                   	push   %ebx
  801792:	89 c6                	mov    %eax,%esi
  801794:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801796:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80179d:	74 27                	je     8017c6 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80179f:	6a 07                	push   $0x7
  8017a1:	68 00 50 80 00       	push   $0x805000
  8017a6:	56                   	push   %esi
  8017a7:	ff 35 00 40 80 00    	pushl  0x804000
  8017ad:	e8 08 0c 00 00       	call   8023ba <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017b2:	83 c4 0c             	add    $0xc,%esp
  8017b5:	6a 00                	push   $0x0
  8017b7:	53                   	push   %ebx
  8017b8:	6a 00                	push   $0x0
  8017ba:	e8 92 0b 00 00       	call   802351 <ipc_recv>
}
  8017bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c2:	5b                   	pop    %ebx
  8017c3:	5e                   	pop    %esi
  8017c4:	5d                   	pop    %ebp
  8017c5:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017c6:	83 ec 0c             	sub    $0xc,%esp
  8017c9:	6a 01                	push   $0x1
  8017cb:	e8 42 0c 00 00       	call   802412 <ipc_find_env>
  8017d0:	a3 00 40 80 00       	mov    %eax,0x804000
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	eb c5                	jmp    80179f <fsipc+0x12>

008017da <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ee:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f8:	b8 02 00 00 00       	mov    $0x2,%eax
  8017fd:	e8 8b ff ff ff       	call   80178d <fsipc>
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <devfile_flush>:
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	8b 40 0c             	mov    0xc(%eax),%eax
  801810:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801815:	ba 00 00 00 00       	mov    $0x0,%edx
  80181a:	b8 06 00 00 00       	mov    $0x6,%eax
  80181f:	e8 69 ff ff ff       	call   80178d <fsipc>
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <devfile_stat>:
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	53                   	push   %ebx
  80182a:	83 ec 04             	sub    $0x4,%esp
  80182d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	8b 40 0c             	mov    0xc(%eax),%eax
  801836:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80183b:	ba 00 00 00 00       	mov    $0x0,%edx
  801840:	b8 05 00 00 00       	mov    $0x5,%eax
  801845:	e8 43 ff ff ff       	call   80178d <fsipc>
  80184a:	85 c0                	test   %eax,%eax
  80184c:	78 2c                	js     80187a <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80184e:	83 ec 08             	sub    $0x8,%esp
  801851:	68 00 50 80 00       	push   $0x805000
  801856:	53                   	push   %ebx
  801857:	e8 d8 f2 ff ff       	call   800b34 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80185c:	a1 80 50 80 00       	mov    0x805080,%eax
  801861:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801867:	a1 84 50 80 00       	mov    0x805084,%eax
  80186c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801872:	83 c4 10             	add    $0x10,%esp
  801875:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80187a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <devfile_write>:
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	53                   	push   %ebx
  801883:	83 ec 08             	sub    $0x8,%esp
  801886:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
  80188c:	8b 40 0c             	mov    0xc(%eax),%eax
  80188f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801894:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80189a:	53                   	push   %ebx
  80189b:	ff 75 0c             	pushl  0xc(%ebp)
  80189e:	68 08 50 80 00       	push   $0x805008
  8018a3:	e8 7c f4 ff ff       	call   800d24 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ad:	b8 04 00 00 00       	mov    $0x4,%eax
  8018b2:	e8 d6 fe ff ff       	call   80178d <fsipc>
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	78 0b                	js     8018c9 <devfile_write+0x4a>
	assert(r <= n);
  8018be:	39 d8                	cmp    %ebx,%eax
  8018c0:	77 0c                	ja     8018ce <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8018c2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018c7:	7f 1e                	jg     8018e7 <devfile_write+0x68>
}
  8018c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    
	assert(r <= n);
  8018ce:	68 48 2c 80 00       	push   $0x802c48
  8018d3:	68 4f 2c 80 00       	push   $0x802c4f
  8018d8:	68 98 00 00 00       	push   $0x98
  8018dd:	68 64 2c 80 00       	push   $0x802c64
  8018e2:	e8 f8 e9 ff ff       	call   8002df <_panic>
	assert(r <= PGSIZE);
  8018e7:	68 6f 2c 80 00       	push   $0x802c6f
  8018ec:	68 4f 2c 80 00       	push   $0x802c4f
  8018f1:	68 99 00 00 00       	push   $0x99
  8018f6:	68 64 2c 80 00       	push   $0x802c64
  8018fb:	e8 df e9 ff ff       	call   8002df <_panic>

00801900 <devfile_read>:
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	56                   	push   %esi
  801904:	53                   	push   %ebx
  801905:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	8b 40 0c             	mov    0xc(%eax),%eax
  80190e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801913:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801919:	ba 00 00 00 00       	mov    $0x0,%edx
  80191e:	b8 03 00 00 00       	mov    $0x3,%eax
  801923:	e8 65 fe ff ff       	call   80178d <fsipc>
  801928:	89 c3                	mov    %eax,%ebx
  80192a:	85 c0                	test   %eax,%eax
  80192c:	78 1f                	js     80194d <devfile_read+0x4d>
	assert(r <= n);
  80192e:	39 f0                	cmp    %esi,%eax
  801930:	77 24                	ja     801956 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801932:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801937:	7f 33                	jg     80196c <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801939:	83 ec 04             	sub    $0x4,%esp
  80193c:	50                   	push   %eax
  80193d:	68 00 50 80 00       	push   $0x805000
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	e8 78 f3 ff ff       	call   800cc2 <memmove>
	return r;
  80194a:	83 c4 10             	add    $0x10,%esp
}
  80194d:	89 d8                	mov    %ebx,%eax
  80194f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801952:	5b                   	pop    %ebx
  801953:	5e                   	pop    %esi
  801954:	5d                   	pop    %ebp
  801955:	c3                   	ret    
	assert(r <= n);
  801956:	68 48 2c 80 00       	push   $0x802c48
  80195b:	68 4f 2c 80 00       	push   $0x802c4f
  801960:	6a 7c                	push   $0x7c
  801962:	68 64 2c 80 00       	push   $0x802c64
  801967:	e8 73 e9 ff ff       	call   8002df <_panic>
	assert(r <= PGSIZE);
  80196c:	68 6f 2c 80 00       	push   $0x802c6f
  801971:	68 4f 2c 80 00       	push   $0x802c4f
  801976:	6a 7d                	push   $0x7d
  801978:	68 64 2c 80 00       	push   $0x802c64
  80197d:	e8 5d e9 ff ff       	call   8002df <_panic>

00801982 <open>:
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	56                   	push   %esi
  801986:	53                   	push   %ebx
  801987:	83 ec 1c             	sub    $0x1c,%esp
  80198a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80198d:	56                   	push   %esi
  80198e:	e8 68 f1 ff ff       	call   800afb <strlen>
  801993:	83 c4 10             	add    $0x10,%esp
  801996:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80199b:	7f 6c                	jg     801a09 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80199d:	83 ec 0c             	sub    $0xc,%esp
  8019a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a3:	50                   	push   %eax
  8019a4:	e8 79 f8 ff ff       	call   801222 <fd_alloc>
  8019a9:	89 c3                	mov    %eax,%ebx
  8019ab:	83 c4 10             	add    $0x10,%esp
  8019ae:	85 c0                	test   %eax,%eax
  8019b0:	78 3c                	js     8019ee <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019b2:	83 ec 08             	sub    $0x8,%esp
  8019b5:	56                   	push   %esi
  8019b6:	68 00 50 80 00       	push   $0x805000
  8019bb:	e8 74 f1 ff ff       	call   800b34 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c3:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d0:	e8 b8 fd ff ff       	call   80178d <fsipc>
  8019d5:	89 c3                	mov    %eax,%ebx
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	78 19                	js     8019f7 <open+0x75>
	return fd2num(fd);
  8019de:	83 ec 0c             	sub    $0xc,%esp
  8019e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e4:	e8 12 f8 ff ff       	call   8011fb <fd2num>
  8019e9:	89 c3                	mov    %eax,%ebx
  8019eb:	83 c4 10             	add    $0x10,%esp
}
  8019ee:	89 d8                	mov    %ebx,%eax
  8019f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f3:	5b                   	pop    %ebx
  8019f4:	5e                   	pop    %esi
  8019f5:	5d                   	pop    %ebp
  8019f6:	c3                   	ret    
		fd_close(fd, 0);
  8019f7:	83 ec 08             	sub    $0x8,%esp
  8019fa:	6a 00                	push   $0x0
  8019fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ff:	e8 1b f9 ff ff       	call   80131f <fd_close>
		return r;
  801a04:	83 c4 10             	add    $0x10,%esp
  801a07:	eb e5                	jmp    8019ee <open+0x6c>
		return -E_BAD_PATH;
  801a09:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a0e:	eb de                	jmp    8019ee <open+0x6c>

00801a10 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a16:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1b:	b8 08 00 00 00       	mov    $0x8,%eax
  801a20:	e8 68 fd ff ff       	call   80178d <fsipc>
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a2d:	68 7b 2c 80 00       	push   $0x802c7b
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	e8 fa f0 ff ff       	call   800b34 <strcpy>
	return 0;
}
  801a3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <devsock_close>:
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	53                   	push   %ebx
  801a45:	83 ec 10             	sub    $0x10,%esp
  801a48:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a4b:	53                   	push   %ebx
  801a4c:	e8 fc 09 00 00       	call   80244d <pageref>
  801a51:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a54:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a59:	83 f8 01             	cmp    $0x1,%eax
  801a5c:	74 07                	je     801a65 <devsock_close+0x24>
}
  801a5e:	89 d0                	mov    %edx,%eax
  801a60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a65:	83 ec 0c             	sub    $0xc,%esp
  801a68:	ff 73 0c             	pushl  0xc(%ebx)
  801a6b:	e8 b9 02 00 00       	call   801d29 <nsipc_close>
  801a70:	89 c2                	mov    %eax,%edx
  801a72:	83 c4 10             	add    $0x10,%esp
  801a75:	eb e7                	jmp    801a5e <devsock_close+0x1d>

00801a77 <devsock_write>:
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	ff 75 10             	pushl  0x10(%ebp)
  801a82:	ff 75 0c             	pushl  0xc(%ebp)
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	ff 70 0c             	pushl  0xc(%eax)
  801a8b:	e8 76 03 00 00       	call   801e06 <nsipc_send>
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <devsock_read>:
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a98:	6a 00                	push   $0x0
  801a9a:	ff 75 10             	pushl  0x10(%ebp)
  801a9d:	ff 75 0c             	pushl  0xc(%ebp)
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	ff 70 0c             	pushl  0xc(%eax)
  801aa6:	e8 ef 02 00 00       	call   801d9a <nsipc_recv>
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <fd2sockid>:
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ab3:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ab6:	52                   	push   %edx
  801ab7:	50                   	push   %eax
  801ab8:	e8 b7 f7 ff ff       	call   801274 <fd_lookup>
  801abd:	83 c4 10             	add    $0x10,%esp
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	78 10                	js     801ad4 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac7:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801acd:	39 08                	cmp    %ecx,(%eax)
  801acf:	75 05                	jne    801ad6 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ad1:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    
		return -E_NOT_SUPP;
  801ad6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801adb:	eb f7                	jmp    801ad4 <fd2sockid+0x27>

00801add <alloc_sockfd>:
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	56                   	push   %esi
  801ae1:	53                   	push   %ebx
  801ae2:	83 ec 1c             	sub    $0x1c,%esp
  801ae5:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ae7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aea:	50                   	push   %eax
  801aeb:	e8 32 f7 ff ff       	call   801222 <fd_alloc>
  801af0:	89 c3                	mov    %eax,%ebx
  801af2:	83 c4 10             	add    $0x10,%esp
  801af5:	85 c0                	test   %eax,%eax
  801af7:	78 43                	js     801b3c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801af9:	83 ec 04             	sub    $0x4,%esp
  801afc:	68 07 04 00 00       	push   $0x407
  801b01:	ff 75 f4             	pushl  -0xc(%ebp)
  801b04:	6a 00                	push   $0x0
  801b06:	e8 1b f4 ff ff       	call   800f26 <sys_page_alloc>
  801b0b:	89 c3                	mov    %eax,%ebx
  801b0d:	83 c4 10             	add    $0x10,%esp
  801b10:	85 c0                	test   %eax,%eax
  801b12:	78 28                	js     801b3c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b17:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b1d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b22:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b29:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b2c:	83 ec 0c             	sub    $0xc,%esp
  801b2f:	50                   	push   %eax
  801b30:	e8 c6 f6 ff ff       	call   8011fb <fd2num>
  801b35:	89 c3                	mov    %eax,%ebx
  801b37:	83 c4 10             	add    $0x10,%esp
  801b3a:	eb 0c                	jmp    801b48 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b3c:	83 ec 0c             	sub    $0xc,%esp
  801b3f:	56                   	push   %esi
  801b40:	e8 e4 01 00 00       	call   801d29 <nsipc_close>
		return r;
  801b45:	83 c4 10             	add    $0x10,%esp
}
  801b48:	89 d8                	mov    %ebx,%eax
  801b4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b4d:	5b                   	pop    %ebx
  801b4e:	5e                   	pop    %esi
  801b4f:	5d                   	pop    %ebp
  801b50:	c3                   	ret    

00801b51 <accept>:
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	e8 4e ff ff ff       	call   801aad <fd2sockid>
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 1b                	js     801b7e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b63:	83 ec 04             	sub    $0x4,%esp
  801b66:	ff 75 10             	pushl  0x10(%ebp)
  801b69:	ff 75 0c             	pushl  0xc(%ebp)
  801b6c:	50                   	push   %eax
  801b6d:	e8 0e 01 00 00       	call   801c80 <nsipc_accept>
  801b72:	83 c4 10             	add    $0x10,%esp
  801b75:	85 c0                	test   %eax,%eax
  801b77:	78 05                	js     801b7e <accept+0x2d>
	return alloc_sockfd(r);
  801b79:	e8 5f ff ff ff       	call   801add <alloc_sockfd>
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <bind>:
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	e8 1f ff ff ff       	call   801aad <fd2sockid>
  801b8e:	85 c0                	test   %eax,%eax
  801b90:	78 12                	js     801ba4 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b92:	83 ec 04             	sub    $0x4,%esp
  801b95:	ff 75 10             	pushl  0x10(%ebp)
  801b98:	ff 75 0c             	pushl  0xc(%ebp)
  801b9b:	50                   	push   %eax
  801b9c:	e8 31 01 00 00       	call   801cd2 <nsipc_bind>
  801ba1:	83 c4 10             	add    $0x10,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <shutdown>:
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	e8 f9 fe ff ff       	call   801aad <fd2sockid>
  801bb4:	85 c0                	test   %eax,%eax
  801bb6:	78 0f                	js     801bc7 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801bb8:	83 ec 08             	sub    $0x8,%esp
  801bbb:	ff 75 0c             	pushl  0xc(%ebp)
  801bbe:	50                   	push   %eax
  801bbf:	e8 43 01 00 00       	call   801d07 <nsipc_shutdown>
  801bc4:	83 c4 10             	add    $0x10,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <connect>:
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	e8 d6 fe ff ff       	call   801aad <fd2sockid>
  801bd7:	85 c0                	test   %eax,%eax
  801bd9:	78 12                	js     801bed <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801bdb:	83 ec 04             	sub    $0x4,%esp
  801bde:	ff 75 10             	pushl  0x10(%ebp)
  801be1:	ff 75 0c             	pushl  0xc(%ebp)
  801be4:	50                   	push   %eax
  801be5:	e8 59 01 00 00       	call   801d43 <nsipc_connect>
  801bea:	83 c4 10             	add    $0x10,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <listen>:
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	e8 b0 fe ff ff       	call   801aad <fd2sockid>
  801bfd:	85 c0                	test   %eax,%eax
  801bff:	78 0f                	js     801c10 <listen+0x21>
	return nsipc_listen(r, backlog);
  801c01:	83 ec 08             	sub    $0x8,%esp
  801c04:	ff 75 0c             	pushl  0xc(%ebp)
  801c07:	50                   	push   %eax
  801c08:	e8 6b 01 00 00       	call   801d78 <nsipc_listen>
  801c0d:	83 c4 10             	add    $0x10,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <socket>:

int
socket(int domain, int type, int protocol)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c18:	ff 75 10             	pushl  0x10(%ebp)
  801c1b:	ff 75 0c             	pushl  0xc(%ebp)
  801c1e:	ff 75 08             	pushl  0x8(%ebp)
  801c21:	e8 3e 02 00 00       	call   801e64 <nsipc_socket>
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	78 05                	js     801c32 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c2d:	e8 ab fe ff ff       	call   801add <alloc_sockfd>
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	53                   	push   %ebx
  801c38:	83 ec 04             	sub    $0x4,%esp
  801c3b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c3d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c44:	74 26                	je     801c6c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c46:	6a 07                	push   $0x7
  801c48:	68 00 60 80 00       	push   $0x806000
  801c4d:	53                   	push   %ebx
  801c4e:	ff 35 04 40 80 00    	pushl  0x804004
  801c54:	e8 61 07 00 00       	call   8023ba <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c59:	83 c4 0c             	add    $0xc,%esp
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	e8 ea 06 00 00       	call   802351 <ipc_recv>
}
  801c67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c6c:	83 ec 0c             	sub    $0xc,%esp
  801c6f:	6a 02                	push   $0x2
  801c71:	e8 9c 07 00 00       	call   802412 <ipc_find_env>
  801c76:	a3 04 40 80 00       	mov    %eax,0x804004
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	eb c6                	jmp    801c46 <nsipc+0x12>

00801c80 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	56                   	push   %esi
  801c84:	53                   	push   %ebx
  801c85:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c90:	8b 06                	mov    (%esi),%eax
  801c92:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c97:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9c:	e8 93 ff ff ff       	call   801c34 <nsipc>
  801ca1:	89 c3                	mov    %eax,%ebx
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	79 09                	jns    801cb0 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ca7:	89 d8                	mov    %ebx,%eax
  801ca9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cac:	5b                   	pop    %ebx
  801cad:	5e                   	pop    %esi
  801cae:	5d                   	pop    %ebp
  801caf:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cb0:	83 ec 04             	sub    $0x4,%esp
  801cb3:	ff 35 10 60 80 00    	pushl  0x806010
  801cb9:	68 00 60 80 00       	push   $0x806000
  801cbe:	ff 75 0c             	pushl  0xc(%ebp)
  801cc1:	e8 fc ef ff ff       	call   800cc2 <memmove>
		*addrlen = ret->ret_addrlen;
  801cc6:	a1 10 60 80 00       	mov    0x806010,%eax
  801ccb:	89 06                	mov    %eax,(%esi)
  801ccd:	83 c4 10             	add    $0x10,%esp
	return r;
  801cd0:	eb d5                	jmp    801ca7 <nsipc_accept+0x27>

00801cd2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	53                   	push   %ebx
  801cd6:	83 ec 08             	sub    $0x8,%esp
  801cd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ce4:	53                   	push   %ebx
  801ce5:	ff 75 0c             	pushl  0xc(%ebp)
  801ce8:	68 04 60 80 00       	push   $0x806004
  801ced:	e8 d0 ef ff ff       	call   800cc2 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801cf2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801cf8:	b8 02 00 00 00       	mov    $0x2,%eax
  801cfd:	e8 32 ff ff ff       	call   801c34 <nsipc>
}
  801d02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d18:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d1d:	b8 03 00 00 00       	mov    $0x3,%eax
  801d22:	e8 0d ff ff ff       	call   801c34 <nsipc>
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <nsipc_close>:

int
nsipc_close(int s)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d37:	b8 04 00 00 00       	mov    $0x4,%eax
  801d3c:	e8 f3 fe ff ff       	call   801c34 <nsipc>
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	53                   	push   %ebx
  801d47:	83 ec 08             	sub    $0x8,%esp
  801d4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d55:	53                   	push   %ebx
  801d56:	ff 75 0c             	pushl  0xc(%ebp)
  801d59:	68 04 60 80 00       	push   $0x806004
  801d5e:	e8 5f ef ff ff       	call   800cc2 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d63:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d69:	b8 05 00 00 00       	mov    $0x5,%eax
  801d6e:	e8 c1 fe ff ff       	call   801c34 <nsipc>
}
  801d73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d81:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d89:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d8e:	b8 06 00 00 00       	mov    $0x6,%eax
  801d93:	e8 9c fe ff ff       	call   801c34 <nsipc>
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	56                   	push   %esi
  801d9e:	53                   	push   %ebx
  801d9f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801daa:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801db0:	8b 45 14             	mov    0x14(%ebp),%eax
  801db3:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801db8:	b8 07 00 00 00       	mov    $0x7,%eax
  801dbd:	e8 72 fe ff ff       	call   801c34 <nsipc>
  801dc2:	89 c3                	mov    %eax,%ebx
  801dc4:	85 c0                	test   %eax,%eax
  801dc6:	78 1f                	js     801de7 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801dc8:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801dcd:	7f 21                	jg     801df0 <nsipc_recv+0x56>
  801dcf:	39 c6                	cmp    %eax,%esi
  801dd1:	7c 1d                	jl     801df0 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801dd3:	83 ec 04             	sub    $0x4,%esp
  801dd6:	50                   	push   %eax
  801dd7:	68 00 60 80 00       	push   $0x806000
  801ddc:	ff 75 0c             	pushl  0xc(%ebp)
  801ddf:	e8 de ee ff ff       	call   800cc2 <memmove>
  801de4:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801de7:	89 d8                	mov    %ebx,%eax
  801de9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dec:	5b                   	pop    %ebx
  801ded:	5e                   	pop    %esi
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801df0:	68 87 2c 80 00       	push   $0x802c87
  801df5:	68 4f 2c 80 00       	push   $0x802c4f
  801dfa:	6a 62                	push   $0x62
  801dfc:	68 9c 2c 80 00       	push   $0x802c9c
  801e01:	e8 d9 e4 ff ff       	call   8002df <_panic>

00801e06 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	53                   	push   %ebx
  801e0a:	83 ec 04             	sub    $0x4,%esp
  801e0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e10:	8b 45 08             	mov    0x8(%ebp),%eax
  801e13:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e18:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e1e:	7f 2e                	jg     801e4e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e20:	83 ec 04             	sub    $0x4,%esp
  801e23:	53                   	push   %ebx
  801e24:	ff 75 0c             	pushl  0xc(%ebp)
  801e27:	68 0c 60 80 00       	push   $0x80600c
  801e2c:	e8 91 ee ff ff       	call   800cc2 <memmove>
	nsipcbuf.send.req_size = size;
  801e31:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e37:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e3f:	b8 08 00 00 00       	mov    $0x8,%eax
  801e44:	e8 eb fd ff ff       	call   801c34 <nsipc>
}
  801e49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    
	assert(size < 1600);
  801e4e:	68 a8 2c 80 00       	push   $0x802ca8
  801e53:	68 4f 2c 80 00       	push   $0x802c4f
  801e58:	6a 6d                	push   $0x6d
  801e5a:	68 9c 2c 80 00       	push   $0x802c9c
  801e5f:	e8 7b e4 ff ff       	call   8002df <_panic>

00801e64 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e75:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e82:	b8 09 00 00 00       	mov    $0x9,%eax
  801e87:	e8 a8 fd ff ff       	call   801c34 <nsipc>
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	56                   	push   %esi
  801e92:	53                   	push   %ebx
  801e93:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e96:	83 ec 0c             	sub    $0xc,%esp
  801e99:	ff 75 08             	pushl  0x8(%ebp)
  801e9c:	e8 6a f3 ff ff       	call   80120b <fd2data>
  801ea1:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ea3:	83 c4 08             	add    $0x8,%esp
  801ea6:	68 b4 2c 80 00       	push   $0x802cb4
  801eab:	53                   	push   %ebx
  801eac:	e8 83 ec ff ff       	call   800b34 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801eb1:	8b 46 04             	mov    0x4(%esi),%eax
  801eb4:	2b 06                	sub    (%esi),%eax
  801eb6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ebc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ec3:	00 00 00 
	stat->st_dev = &devpipe;
  801ec6:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ecd:	30 80 00 
	return 0;
}
  801ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed8:	5b                   	pop    %ebx
  801ed9:	5e                   	pop    %esi
  801eda:	5d                   	pop    %ebp
  801edb:	c3                   	ret    

00801edc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	53                   	push   %ebx
  801ee0:	83 ec 0c             	sub    $0xc,%esp
  801ee3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ee6:	53                   	push   %ebx
  801ee7:	6a 00                	push   $0x0
  801ee9:	e8 bd f0 ff ff       	call   800fab <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801eee:	89 1c 24             	mov    %ebx,(%esp)
  801ef1:	e8 15 f3 ff ff       	call   80120b <fd2data>
  801ef6:	83 c4 08             	add    $0x8,%esp
  801ef9:	50                   	push   %eax
  801efa:	6a 00                	push   $0x0
  801efc:	e8 aa f0 ff ff       	call   800fab <sys_page_unmap>
}
  801f01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <_pipeisclosed>:
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	57                   	push   %edi
  801f0a:	56                   	push   %esi
  801f0b:	53                   	push   %ebx
  801f0c:	83 ec 1c             	sub    $0x1c,%esp
  801f0f:	89 c7                	mov    %eax,%edi
  801f11:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f13:	a1 08 40 80 00       	mov    0x804008,%eax
  801f18:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f1b:	83 ec 0c             	sub    $0xc,%esp
  801f1e:	57                   	push   %edi
  801f1f:	e8 29 05 00 00       	call   80244d <pageref>
  801f24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f27:	89 34 24             	mov    %esi,(%esp)
  801f2a:	e8 1e 05 00 00       	call   80244d <pageref>
		nn = thisenv->env_runs;
  801f2f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f35:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	39 cb                	cmp    %ecx,%ebx
  801f3d:	74 1b                	je     801f5a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f3f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f42:	75 cf                	jne    801f13 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f44:	8b 42 58             	mov    0x58(%edx),%eax
  801f47:	6a 01                	push   $0x1
  801f49:	50                   	push   %eax
  801f4a:	53                   	push   %ebx
  801f4b:	68 bb 2c 80 00       	push   $0x802cbb
  801f50:	e8 80 e4 ff ff       	call   8003d5 <cprintf>
  801f55:	83 c4 10             	add    $0x10,%esp
  801f58:	eb b9                	jmp    801f13 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f5a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f5d:	0f 94 c0             	sete   %al
  801f60:	0f b6 c0             	movzbl %al,%eax
}
  801f63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f66:	5b                   	pop    %ebx
  801f67:	5e                   	pop    %esi
  801f68:	5f                   	pop    %edi
  801f69:	5d                   	pop    %ebp
  801f6a:	c3                   	ret    

00801f6b <devpipe_write>:
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	57                   	push   %edi
  801f6f:	56                   	push   %esi
  801f70:	53                   	push   %ebx
  801f71:	83 ec 28             	sub    $0x28,%esp
  801f74:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f77:	56                   	push   %esi
  801f78:	e8 8e f2 ff ff       	call   80120b <fd2data>
  801f7d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f7f:	83 c4 10             	add    $0x10,%esp
  801f82:	bf 00 00 00 00       	mov    $0x0,%edi
  801f87:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f8a:	74 4f                	je     801fdb <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f8c:	8b 43 04             	mov    0x4(%ebx),%eax
  801f8f:	8b 0b                	mov    (%ebx),%ecx
  801f91:	8d 51 20             	lea    0x20(%ecx),%edx
  801f94:	39 d0                	cmp    %edx,%eax
  801f96:	72 14                	jb     801fac <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f98:	89 da                	mov    %ebx,%edx
  801f9a:	89 f0                	mov    %esi,%eax
  801f9c:	e8 65 ff ff ff       	call   801f06 <_pipeisclosed>
  801fa1:	85 c0                	test   %eax,%eax
  801fa3:	75 3b                	jne    801fe0 <devpipe_write+0x75>
			sys_yield();
  801fa5:	e8 5d ef ff ff       	call   800f07 <sys_yield>
  801faa:	eb e0                	jmp    801f8c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801faf:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801fb3:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fb6:	89 c2                	mov    %eax,%edx
  801fb8:	c1 fa 1f             	sar    $0x1f,%edx
  801fbb:	89 d1                	mov    %edx,%ecx
  801fbd:	c1 e9 1b             	shr    $0x1b,%ecx
  801fc0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801fc3:	83 e2 1f             	and    $0x1f,%edx
  801fc6:	29 ca                	sub    %ecx,%edx
  801fc8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801fcc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801fd0:	83 c0 01             	add    $0x1,%eax
  801fd3:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801fd6:	83 c7 01             	add    $0x1,%edi
  801fd9:	eb ac                	jmp    801f87 <devpipe_write+0x1c>
	return i;
  801fdb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fde:	eb 05                	jmp    801fe5 <devpipe_write+0x7a>
				return 0;
  801fe0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fe8:	5b                   	pop    %ebx
  801fe9:	5e                   	pop    %esi
  801fea:	5f                   	pop    %edi
  801feb:	5d                   	pop    %ebp
  801fec:	c3                   	ret    

00801fed <devpipe_read>:
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	57                   	push   %edi
  801ff1:	56                   	push   %esi
  801ff2:	53                   	push   %ebx
  801ff3:	83 ec 18             	sub    $0x18,%esp
  801ff6:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ff9:	57                   	push   %edi
  801ffa:	e8 0c f2 ff ff       	call   80120b <fd2data>
  801fff:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802001:	83 c4 10             	add    $0x10,%esp
  802004:	be 00 00 00 00       	mov    $0x0,%esi
  802009:	3b 75 10             	cmp    0x10(%ebp),%esi
  80200c:	75 14                	jne    802022 <devpipe_read+0x35>
	return i;
  80200e:	8b 45 10             	mov    0x10(%ebp),%eax
  802011:	eb 02                	jmp    802015 <devpipe_read+0x28>
				return i;
  802013:	89 f0                	mov    %esi,%eax
}
  802015:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802018:	5b                   	pop    %ebx
  802019:	5e                   	pop    %esi
  80201a:	5f                   	pop    %edi
  80201b:	5d                   	pop    %ebp
  80201c:	c3                   	ret    
			sys_yield();
  80201d:	e8 e5 ee ff ff       	call   800f07 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802022:	8b 03                	mov    (%ebx),%eax
  802024:	3b 43 04             	cmp    0x4(%ebx),%eax
  802027:	75 18                	jne    802041 <devpipe_read+0x54>
			if (i > 0)
  802029:	85 f6                	test   %esi,%esi
  80202b:	75 e6                	jne    802013 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80202d:	89 da                	mov    %ebx,%edx
  80202f:	89 f8                	mov    %edi,%eax
  802031:	e8 d0 fe ff ff       	call   801f06 <_pipeisclosed>
  802036:	85 c0                	test   %eax,%eax
  802038:	74 e3                	je     80201d <devpipe_read+0x30>
				return 0;
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
  80203f:	eb d4                	jmp    802015 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802041:	99                   	cltd   
  802042:	c1 ea 1b             	shr    $0x1b,%edx
  802045:	01 d0                	add    %edx,%eax
  802047:	83 e0 1f             	and    $0x1f,%eax
  80204a:	29 d0                	sub    %edx,%eax
  80204c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802051:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802054:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802057:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80205a:	83 c6 01             	add    $0x1,%esi
  80205d:	eb aa                	jmp    802009 <devpipe_read+0x1c>

0080205f <pipe>:
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	56                   	push   %esi
  802063:	53                   	push   %ebx
  802064:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802067:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80206a:	50                   	push   %eax
  80206b:	e8 b2 f1 ff ff       	call   801222 <fd_alloc>
  802070:	89 c3                	mov    %eax,%ebx
  802072:	83 c4 10             	add    $0x10,%esp
  802075:	85 c0                	test   %eax,%eax
  802077:	0f 88 23 01 00 00    	js     8021a0 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80207d:	83 ec 04             	sub    $0x4,%esp
  802080:	68 07 04 00 00       	push   $0x407
  802085:	ff 75 f4             	pushl  -0xc(%ebp)
  802088:	6a 00                	push   $0x0
  80208a:	e8 97 ee ff ff       	call   800f26 <sys_page_alloc>
  80208f:	89 c3                	mov    %eax,%ebx
  802091:	83 c4 10             	add    $0x10,%esp
  802094:	85 c0                	test   %eax,%eax
  802096:	0f 88 04 01 00 00    	js     8021a0 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80209c:	83 ec 0c             	sub    $0xc,%esp
  80209f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020a2:	50                   	push   %eax
  8020a3:	e8 7a f1 ff ff       	call   801222 <fd_alloc>
  8020a8:	89 c3                	mov    %eax,%ebx
  8020aa:	83 c4 10             	add    $0x10,%esp
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	0f 88 db 00 00 00    	js     802190 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020b5:	83 ec 04             	sub    $0x4,%esp
  8020b8:	68 07 04 00 00       	push   $0x407
  8020bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8020c0:	6a 00                	push   $0x0
  8020c2:	e8 5f ee ff ff       	call   800f26 <sys_page_alloc>
  8020c7:	89 c3                	mov    %eax,%ebx
  8020c9:	83 c4 10             	add    $0x10,%esp
  8020cc:	85 c0                	test   %eax,%eax
  8020ce:	0f 88 bc 00 00 00    	js     802190 <pipe+0x131>
	va = fd2data(fd0);
  8020d4:	83 ec 0c             	sub    $0xc,%esp
  8020d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8020da:	e8 2c f1 ff ff       	call   80120b <fd2data>
  8020df:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020e1:	83 c4 0c             	add    $0xc,%esp
  8020e4:	68 07 04 00 00       	push   $0x407
  8020e9:	50                   	push   %eax
  8020ea:	6a 00                	push   $0x0
  8020ec:	e8 35 ee ff ff       	call   800f26 <sys_page_alloc>
  8020f1:	89 c3                	mov    %eax,%ebx
  8020f3:	83 c4 10             	add    $0x10,%esp
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	0f 88 82 00 00 00    	js     802180 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020fe:	83 ec 0c             	sub    $0xc,%esp
  802101:	ff 75 f0             	pushl  -0x10(%ebp)
  802104:	e8 02 f1 ff ff       	call   80120b <fd2data>
  802109:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802110:	50                   	push   %eax
  802111:	6a 00                	push   $0x0
  802113:	56                   	push   %esi
  802114:	6a 00                	push   $0x0
  802116:	e8 4e ee ff ff       	call   800f69 <sys_page_map>
  80211b:	89 c3                	mov    %eax,%ebx
  80211d:	83 c4 20             	add    $0x20,%esp
  802120:	85 c0                	test   %eax,%eax
  802122:	78 4e                	js     802172 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802124:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802129:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80212e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802131:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802138:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80213b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80213d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802140:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802147:	83 ec 0c             	sub    $0xc,%esp
  80214a:	ff 75 f4             	pushl  -0xc(%ebp)
  80214d:	e8 a9 f0 ff ff       	call   8011fb <fd2num>
  802152:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802155:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802157:	83 c4 04             	add    $0x4,%esp
  80215a:	ff 75 f0             	pushl  -0x10(%ebp)
  80215d:	e8 99 f0 ff ff       	call   8011fb <fd2num>
  802162:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802165:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802168:	83 c4 10             	add    $0x10,%esp
  80216b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802170:	eb 2e                	jmp    8021a0 <pipe+0x141>
	sys_page_unmap(0, va);
  802172:	83 ec 08             	sub    $0x8,%esp
  802175:	56                   	push   %esi
  802176:	6a 00                	push   $0x0
  802178:	e8 2e ee ff ff       	call   800fab <sys_page_unmap>
  80217d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802180:	83 ec 08             	sub    $0x8,%esp
  802183:	ff 75 f0             	pushl  -0x10(%ebp)
  802186:	6a 00                	push   $0x0
  802188:	e8 1e ee ff ff       	call   800fab <sys_page_unmap>
  80218d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802190:	83 ec 08             	sub    $0x8,%esp
  802193:	ff 75 f4             	pushl  -0xc(%ebp)
  802196:	6a 00                	push   $0x0
  802198:	e8 0e ee ff ff       	call   800fab <sys_page_unmap>
  80219d:	83 c4 10             	add    $0x10,%esp
}
  8021a0:	89 d8                	mov    %ebx,%eax
  8021a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021a5:	5b                   	pop    %ebx
  8021a6:	5e                   	pop    %esi
  8021a7:	5d                   	pop    %ebp
  8021a8:	c3                   	ret    

008021a9 <pipeisclosed>:
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b2:	50                   	push   %eax
  8021b3:	ff 75 08             	pushl  0x8(%ebp)
  8021b6:	e8 b9 f0 ff ff       	call   801274 <fd_lookup>
  8021bb:	83 c4 10             	add    $0x10,%esp
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	78 18                	js     8021da <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8021c2:	83 ec 0c             	sub    $0xc,%esp
  8021c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8021c8:	e8 3e f0 ff ff       	call   80120b <fd2data>
	return _pipeisclosed(fd, p);
  8021cd:	89 c2                	mov    %eax,%edx
  8021cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d2:	e8 2f fd ff ff       	call   801f06 <_pipeisclosed>
  8021d7:	83 c4 10             	add    $0x10,%esp
}
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8021dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e1:	c3                   	ret    

008021e2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8021e8:	68 d3 2c 80 00       	push   $0x802cd3
  8021ed:	ff 75 0c             	pushl  0xc(%ebp)
  8021f0:	e8 3f e9 ff ff       	call   800b34 <strcpy>
	return 0;
}
  8021f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <devcons_write>:
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	57                   	push   %edi
  802200:	56                   	push   %esi
  802201:	53                   	push   %ebx
  802202:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802208:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80220d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802213:	3b 75 10             	cmp    0x10(%ebp),%esi
  802216:	73 31                	jae    802249 <devcons_write+0x4d>
		m = n - tot;
  802218:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80221b:	29 f3                	sub    %esi,%ebx
  80221d:	83 fb 7f             	cmp    $0x7f,%ebx
  802220:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802225:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802228:	83 ec 04             	sub    $0x4,%esp
  80222b:	53                   	push   %ebx
  80222c:	89 f0                	mov    %esi,%eax
  80222e:	03 45 0c             	add    0xc(%ebp),%eax
  802231:	50                   	push   %eax
  802232:	57                   	push   %edi
  802233:	e8 8a ea ff ff       	call   800cc2 <memmove>
		sys_cputs(buf, m);
  802238:	83 c4 08             	add    $0x8,%esp
  80223b:	53                   	push   %ebx
  80223c:	57                   	push   %edi
  80223d:	e8 28 ec ff ff       	call   800e6a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802242:	01 de                	add    %ebx,%esi
  802244:	83 c4 10             	add    $0x10,%esp
  802247:	eb ca                	jmp    802213 <devcons_write+0x17>
}
  802249:	89 f0                	mov    %esi,%eax
  80224b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80224e:	5b                   	pop    %ebx
  80224f:	5e                   	pop    %esi
  802250:	5f                   	pop    %edi
  802251:	5d                   	pop    %ebp
  802252:	c3                   	ret    

00802253 <devcons_read>:
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	83 ec 08             	sub    $0x8,%esp
  802259:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80225e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802262:	74 21                	je     802285 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802264:	e8 1f ec ff ff       	call   800e88 <sys_cgetc>
  802269:	85 c0                	test   %eax,%eax
  80226b:	75 07                	jne    802274 <devcons_read+0x21>
		sys_yield();
  80226d:	e8 95 ec ff ff       	call   800f07 <sys_yield>
  802272:	eb f0                	jmp    802264 <devcons_read+0x11>
	if (c < 0)
  802274:	78 0f                	js     802285 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802276:	83 f8 04             	cmp    $0x4,%eax
  802279:	74 0c                	je     802287 <devcons_read+0x34>
	*(char*)vbuf = c;
  80227b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227e:	88 02                	mov    %al,(%edx)
	return 1;
  802280:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802285:	c9                   	leave  
  802286:	c3                   	ret    
		return 0;
  802287:	b8 00 00 00 00       	mov    $0x0,%eax
  80228c:	eb f7                	jmp    802285 <devcons_read+0x32>

0080228e <cputchar>:
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
  802291:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80229a:	6a 01                	push   $0x1
  80229c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80229f:	50                   	push   %eax
  8022a0:	e8 c5 eb ff ff       	call   800e6a <sys_cputs>
}
  8022a5:	83 c4 10             	add    $0x10,%esp
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <getchar>:
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
  8022ad:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8022b0:	6a 01                	push   $0x1
  8022b2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022b5:	50                   	push   %eax
  8022b6:	6a 00                	push   $0x0
  8022b8:	e8 27 f2 ff ff       	call   8014e4 <read>
	if (r < 0)
  8022bd:	83 c4 10             	add    $0x10,%esp
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	78 06                	js     8022ca <getchar+0x20>
	if (r < 1)
  8022c4:	74 06                	je     8022cc <getchar+0x22>
	return c;
  8022c6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    
		return -E_EOF;
  8022cc:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8022d1:	eb f7                	jmp    8022ca <getchar+0x20>

008022d3 <iscons>:
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022dc:	50                   	push   %eax
  8022dd:	ff 75 08             	pushl  0x8(%ebp)
  8022e0:	e8 8f ef ff ff       	call   801274 <fd_lookup>
  8022e5:	83 c4 10             	add    $0x10,%esp
  8022e8:	85 c0                	test   %eax,%eax
  8022ea:	78 11                	js     8022fd <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022f5:	39 10                	cmp    %edx,(%eax)
  8022f7:	0f 94 c0             	sete   %al
  8022fa:	0f b6 c0             	movzbl %al,%eax
}
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <opencons>:
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802305:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802308:	50                   	push   %eax
  802309:	e8 14 ef ff ff       	call   801222 <fd_alloc>
  80230e:	83 c4 10             	add    $0x10,%esp
  802311:	85 c0                	test   %eax,%eax
  802313:	78 3a                	js     80234f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802315:	83 ec 04             	sub    $0x4,%esp
  802318:	68 07 04 00 00       	push   $0x407
  80231d:	ff 75 f4             	pushl  -0xc(%ebp)
  802320:	6a 00                	push   $0x0
  802322:	e8 ff eb ff ff       	call   800f26 <sys_page_alloc>
  802327:	83 c4 10             	add    $0x10,%esp
  80232a:	85 c0                	test   %eax,%eax
  80232c:	78 21                	js     80234f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802337:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802343:	83 ec 0c             	sub    $0xc,%esp
  802346:	50                   	push   %eax
  802347:	e8 af ee ff ff       	call   8011fb <fd2num>
  80234c:	83 c4 10             	add    $0x10,%esp
}
  80234f:	c9                   	leave  
  802350:	c3                   	ret    

00802351 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	56                   	push   %esi
  802355:	53                   	push   %ebx
  802356:	8b 75 08             	mov    0x8(%ebp),%esi
  802359:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80235f:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802361:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802366:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802369:	83 ec 0c             	sub    $0xc,%esp
  80236c:	50                   	push   %eax
  80236d:	e8 64 ed ff ff       	call   8010d6 <sys_ipc_recv>
	if(ret < 0){
  802372:	83 c4 10             	add    $0x10,%esp
  802375:	85 c0                	test   %eax,%eax
  802377:	78 2b                	js     8023a4 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802379:	85 f6                	test   %esi,%esi
  80237b:	74 0a                	je     802387 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80237d:	a1 08 40 80 00       	mov    0x804008,%eax
  802382:	8b 40 74             	mov    0x74(%eax),%eax
  802385:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802387:	85 db                	test   %ebx,%ebx
  802389:	74 0a                	je     802395 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80238b:	a1 08 40 80 00       	mov    0x804008,%eax
  802390:	8b 40 78             	mov    0x78(%eax),%eax
  802393:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802395:	a1 08 40 80 00       	mov    0x804008,%eax
  80239a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80239d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023a0:	5b                   	pop    %ebx
  8023a1:	5e                   	pop    %esi
  8023a2:	5d                   	pop    %ebp
  8023a3:	c3                   	ret    
		if(from_env_store)
  8023a4:	85 f6                	test   %esi,%esi
  8023a6:	74 06                	je     8023ae <ipc_recv+0x5d>
			*from_env_store = 0;
  8023a8:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8023ae:	85 db                	test   %ebx,%ebx
  8023b0:	74 eb                	je     80239d <ipc_recv+0x4c>
			*perm_store = 0;
  8023b2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8023b8:	eb e3                	jmp    80239d <ipc_recv+0x4c>

008023ba <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
  8023bd:	57                   	push   %edi
  8023be:	56                   	push   %esi
  8023bf:	53                   	push   %ebx
  8023c0:	83 ec 0c             	sub    $0xc,%esp
  8023c3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023c6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8023cc:	85 db                	test   %ebx,%ebx
  8023ce:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023d3:	0f 44 d8             	cmove  %eax,%ebx
  8023d6:	eb 05                	jmp    8023dd <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8023d8:	e8 2a eb ff ff       	call   800f07 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8023dd:	ff 75 14             	pushl  0x14(%ebp)
  8023e0:	53                   	push   %ebx
  8023e1:	56                   	push   %esi
  8023e2:	57                   	push   %edi
  8023e3:	e8 cb ec ff ff       	call   8010b3 <sys_ipc_try_send>
  8023e8:	83 c4 10             	add    $0x10,%esp
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	74 1b                	je     80240a <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8023ef:	79 e7                	jns    8023d8 <ipc_send+0x1e>
  8023f1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023f4:	74 e2                	je     8023d8 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8023f6:	83 ec 04             	sub    $0x4,%esp
  8023f9:	68 df 2c 80 00       	push   $0x802cdf
  8023fe:	6a 46                	push   $0x46
  802400:	68 f4 2c 80 00       	push   $0x802cf4
  802405:	e8 d5 de ff ff       	call   8002df <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80240a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80240d:	5b                   	pop    %ebx
  80240e:	5e                   	pop    %esi
  80240f:	5f                   	pop    %edi
  802410:	5d                   	pop    %ebp
  802411:	c3                   	ret    

00802412 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802418:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80241d:	89 c2                	mov    %eax,%edx
  80241f:	c1 e2 07             	shl    $0x7,%edx
  802422:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802428:	8b 52 50             	mov    0x50(%edx),%edx
  80242b:	39 ca                	cmp    %ecx,%edx
  80242d:	74 11                	je     802440 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80242f:	83 c0 01             	add    $0x1,%eax
  802432:	3d 00 04 00 00       	cmp    $0x400,%eax
  802437:	75 e4                	jne    80241d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802439:	b8 00 00 00 00       	mov    $0x0,%eax
  80243e:	eb 0b                	jmp    80244b <ipc_find_env+0x39>
			return envs[i].env_id;
  802440:	c1 e0 07             	shl    $0x7,%eax
  802443:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802448:	8b 40 48             	mov    0x48(%eax),%eax
}
  80244b:	5d                   	pop    %ebp
  80244c:	c3                   	ret    

0080244d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
  802450:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802453:	89 d0                	mov    %edx,%eax
  802455:	c1 e8 16             	shr    $0x16,%eax
  802458:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80245f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802464:	f6 c1 01             	test   $0x1,%cl
  802467:	74 1d                	je     802486 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802469:	c1 ea 0c             	shr    $0xc,%edx
  80246c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802473:	f6 c2 01             	test   $0x1,%dl
  802476:	74 0e                	je     802486 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802478:	c1 ea 0c             	shr    $0xc,%edx
  80247b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802482:	ef 
  802483:	0f b7 c0             	movzwl %ax,%eax
}
  802486:	5d                   	pop    %ebp
  802487:	c3                   	ret    
  802488:	66 90                	xchg   %ax,%ax
  80248a:	66 90                	xchg   %ax,%ax
  80248c:	66 90                	xchg   %ax,%ax
  80248e:	66 90                	xchg   %ax,%ax

00802490 <__udivdi3>:
  802490:	55                   	push   %ebp
  802491:	57                   	push   %edi
  802492:	56                   	push   %esi
  802493:	53                   	push   %ebx
  802494:	83 ec 1c             	sub    $0x1c,%esp
  802497:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80249b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80249f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024a7:	85 d2                	test   %edx,%edx
  8024a9:	75 4d                	jne    8024f8 <__udivdi3+0x68>
  8024ab:	39 f3                	cmp    %esi,%ebx
  8024ad:	76 19                	jbe    8024c8 <__udivdi3+0x38>
  8024af:	31 ff                	xor    %edi,%edi
  8024b1:	89 e8                	mov    %ebp,%eax
  8024b3:	89 f2                	mov    %esi,%edx
  8024b5:	f7 f3                	div    %ebx
  8024b7:	89 fa                	mov    %edi,%edx
  8024b9:	83 c4 1c             	add    $0x1c,%esp
  8024bc:	5b                   	pop    %ebx
  8024bd:	5e                   	pop    %esi
  8024be:	5f                   	pop    %edi
  8024bf:	5d                   	pop    %ebp
  8024c0:	c3                   	ret    
  8024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024c8:	89 d9                	mov    %ebx,%ecx
  8024ca:	85 db                	test   %ebx,%ebx
  8024cc:	75 0b                	jne    8024d9 <__udivdi3+0x49>
  8024ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d3:	31 d2                	xor    %edx,%edx
  8024d5:	f7 f3                	div    %ebx
  8024d7:	89 c1                	mov    %eax,%ecx
  8024d9:	31 d2                	xor    %edx,%edx
  8024db:	89 f0                	mov    %esi,%eax
  8024dd:	f7 f1                	div    %ecx
  8024df:	89 c6                	mov    %eax,%esi
  8024e1:	89 e8                	mov    %ebp,%eax
  8024e3:	89 f7                	mov    %esi,%edi
  8024e5:	f7 f1                	div    %ecx
  8024e7:	89 fa                	mov    %edi,%edx
  8024e9:	83 c4 1c             	add    $0x1c,%esp
  8024ec:	5b                   	pop    %ebx
  8024ed:	5e                   	pop    %esi
  8024ee:	5f                   	pop    %edi
  8024ef:	5d                   	pop    %ebp
  8024f0:	c3                   	ret    
  8024f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024f8:	39 f2                	cmp    %esi,%edx
  8024fa:	77 1c                	ja     802518 <__udivdi3+0x88>
  8024fc:	0f bd fa             	bsr    %edx,%edi
  8024ff:	83 f7 1f             	xor    $0x1f,%edi
  802502:	75 2c                	jne    802530 <__udivdi3+0xa0>
  802504:	39 f2                	cmp    %esi,%edx
  802506:	72 06                	jb     80250e <__udivdi3+0x7e>
  802508:	31 c0                	xor    %eax,%eax
  80250a:	39 eb                	cmp    %ebp,%ebx
  80250c:	77 a9                	ja     8024b7 <__udivdi3+0x27>
  80250e:	b8 01 00 00 00       	mov    $0x1,%eax
  802513:	eb a2                	jmp    8024b7 <__udivdi3+0x27>
  802515:	8d 76 00             	lea    0x0(%esi),%esi
  802518:	31 ff                	xor    %edi,%edi
  80251a:	31 c0                	xor    %eax,%eax
  80251c:	89 fa                	mov    %edi,%edx
  80251e:	83 c4 1c             	add    $0x1c,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    
  802526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80252d:	8d 76 00             	lea    0x0(%esi),%esi
  802530:	89 f9                	mov    %edi,%ecx
  802532:	b8 20 00 00 00       	mov    $0x20,%eax
  802537:	29 f8                	sub    %edi,%eax
  802539:	d3 e2                	shl    %cl,%edx
  80253b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80253f:	89 c1                	mov    %eax,%ecx
  802541:	89 da                	mov    %ebx,%edx
  802543:	d3 ea                	shr    %cl,%edx
  802545:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802549:	09 d1                	or     %edx,%ecx
  80254b:	89 f2                	mov    %esi,%edx
  80254d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802551:	89 f9                	mov    %edi,%ecx
  802553:	d3 e3                	shl    %cl,%ebx
  802555:	89 c1                	mov    %eax,%ecx
  802557:	d3 ea                	shr    %cl,%edx
  802559:	89 f9                	mov    %edi,%ecx
  80255b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80255f:	89 eb                	mov    %ebp,%ebx
  802561:	d3 e6                	shl    %cl,%esi
  802563:	89 c1                	mov    %eax,%ecx
  802565:	d3 eb                	shr    %cl,%ebx
  802567:	09 de                	or     %ebx,%esi
  802569:	89 f0                	mov    %esi,%eax
  80256b:	f7 74 24 08          	divl   0x8(%esp)
  80256f:	89 d6                	mov    %edx,%esi
  802571:	89 c3                	mov    %eax,%ebx
  802573:	f7 64 24 0c          	mull   0xc(%esp)
  802577:	39 d6                	cmp    %edx,%esi
  802579:	72 15                	jb     802590 <__udivdi3+0x100>
  80257b:	89 f9                	mov    %edi,%ecx
  80257d:	d3 e5                	shl    %cl,%ebp
  80257f:	39 c5                	cmp    %eax,%ebp
  802581:	73 04                	jae    802587 <__udivdi3+0xf7>
  802583:	39 d6                	cmp    %edx,%esi
  802585:	74 09                	je     802590 <__udivdi3+0x100>
  802587:	89 d8                	mov    %ebx,%eax
  802589:	31 ff                	xor    %edi,%edi
  80258b:	e9 27 ff ff ff       	jmp    8024b7 <__udivdi3+0x27>
  802590:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802593:	31 ff                	xor    %edi,%edi
  802595:	e9 1d ff ff ff       	jmp    8024b7 <__udivdi3+0x27>
  80259a:	66 90                	xchg   %ax,%ax
  80259c:	66 90                	xchg   %ax,%ax
  80259e:	66 90                	xchg   %ax,%ax

008025a0 <__umoddi3>:
  8025a0:	55                   	push   %ebp
  8025a1:	57                   	push   %edi
  8025a2:	56                   	push   %esi
  8025a3:	53                   	push   %ebx
  8025a4:	83 ec 1c             	sub    $0x1c,%esp
  8025a7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8025af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8025b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025b7:	89 da                	mov    %ebx,%edx
  8025b9:	85 c0                	test   %eax,%eax
  8025bb:	75 43                	jne    802600 <__umoddi3+0x60>
  8025bd:	39 df                	cmp    %ebx,%edi
  8025bf:	76 17                	jbe    8025d8 <__umoddi3+0x38>
  8025c1:	89 f0                	mov    %esi,%eax
  8025c3:	f7 f7                	div    %edi
  8025c5:	89 d0                	mov    %edx,%eax
  8025c7:	31 d2                	xor    %edx,%edx
  8025c9:	83 c4 1c             	add    $0x1c,%esp
  8025cc:	5b                   	pop    %ebx
  8025cd:	5e                   	pop    %esi
  8025ce:	5f                   	pop    %edi
  8025cf:	5d                   	pop    %ebp
  8025d0:	c3                   	ret    
  8025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025d8:	89 fd                	mov    %edi,%ebp
  8025da:	85 ff                	test   %edi,%edi
  8025dc:	75 0b                	jne    8025e9 <__umoddi3+0x49>
  8025de:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e3:	31 d2                	xor    %edx,%edx
  8025e5:	f7 f7                	div    %edi
  8025e7:	89 c5                	mov    %eax,%ebp
  8025e9:	89 d8                	mov    %ebx,%eax
  8025eb:	31 d2                	xor    %edx,%edx
  8025ed:	f7 f5                	div    %ebp
  8025ef:	89 f0                	mov    %esi,%eax
  8025f1:	f7 f5                	div    %ebp
  8025f3:	89 d0                	mov    %edx,%eax
  8025f5:	eb d0                	jmp    8025c7 <__umoddi3+0x27>
  8025f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025fe:	66 90                	xchg   %ax,%ax
  802600:	89 f1                	mov    %esi,%ecx
  802602:	39 d8                	cmp    %ebx,%eax
  802604:	76 0a                	jbe    802610 <__umoddi3+0x70>
  802606:	89 f0                	mov    %esi,%eax
  802608:	83 c4 1c             	add    $0x1c,%esp
  80260b:	5b                   	pop    %ebx
  80260c:	5e                   	pop    %esi
  80260d:	5f                   	pop    %edi
  80260e:	5d                   	pop    %ebp
  80260f:	c3                   	ret    
  802610:	0f bd e8             	bsr    %eax,%ebp
  802613:	83 f5 1f             	xor    $0x1f,%ebp
  802616:	75 20                	jne    802638 <__umoddi3+0x98>
  802618:	39 d8                	cmp    %ebx,%eax
  80261a:	0f 82 b0 00 00 00    	jb     8026d0 <__umoddi3+0x130>
  802620:	39 f7                	cmp    %esi,%edi
  802622:	0f 86 a8 00 00 00    	jbe    8026d0 <__umoddi3+0x130>
  802628:	89 c8                	mov    %ecx,%eax
  80262a:	83 c4 1c             	add    $0x1c,%esp
  80262d:	5b                   	pop    %ebx
  80262e:	5e                   	pop    %esi
  80262f:	5f                   	pop    %edi
  802630:	5d                   	pop    %ebp
  802631:	c3                   	ret    
  802632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802638:	89 e9                	mov    %ebp,%ecx
  80263a:	ba 20 00 00 00       	mov    $0x20,%edx
  80263f:	29 ea                	sub    %ebp,%edx
  802641:	d3 e0                	shl    %cl,%eax
  802643:	89 44 24 08          	mov    %eax,0x8(%esp)
  802647:	89 d1                	mov    %edx,%ecx
  802649:	89 f8                	mov    %edi,%eax
  80264b:	d3 e8                	shr    %cl,%eax
  80264d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802651:	89 54 24 04          	mov    %edx,0x4(%esp)
  802655:	8b 54 24 04          	mov    0x4(%esp),%edx
  802659:	09 c1                	or     %eax,%ecx
  80265b:	89 d8                	mov    %ebx,%eax
  80265d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802661:	89 e9                	mov    %ebp,%ecx
  802663:	d3 e7                	shl    %cl,%edi
  802665:	89 d1                	mov    %edx,%ecx
  802667:	d3 e8                	shr    %cl,%eax
  802669:	89 e9                	mov    %ebp,%ecx
  80266b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80266f:	d3 e3                	shl    %cl,%ebx
  802671:	89 c7                	mov    %eax,%edi
  802673:	89 d1                	mov    %edx,%ecx
  802675:	89 f0                	mov    %esi,%eax
  802677:	d3 e8                	shr    %cl,%eax
  802679:	89 e9                	mov    %ebp,%ecx
  80267b:	89 fa                	mov    %edi,%edx
  80267d:	d3 e6                	shl    %cl,%esi
  80267f:	09 d8                	or     %ebx,%eax
  802681:	f7 74 24 08          	divl   0x8(%esp)
  802685:	89 d1                	mov    %edx,%ecx
  802687:	89 f3                	mov    %esi,%ebx
  802689:	f7 64 24 0c          	mull   0xc(%esp)
  80268d:	89 c6                	mov    %eax,%esi
  80268f:	89 d7                	mov    %edx,%edi
  802691:	39 d1                	cmp    %edx,%ecx
  802693:	72 06                	jb     80269b <__umoddi3+0xfb>
  802695:	75 10                	jne    8026a7 <__umoddi3+0x107>
  802697:	39 c3                	cmp    %eax,%ebx
  802699:	73 0c                	jae    8026a7 <__umoddi3+0x107>
  80269b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80269f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8026a3:	89 d7                	mov    %edx,%edi
  8026a5:	89 c6                	mov    %eax,%esi
  8026a7:	89 ca                	mov    %ecx,%edx
  8026a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026ae:	29 f3                	sub    %esi,%ebx
  8026b0:	19 fa                	sbb    %edi,%edx
  8026b2:	89 d0                	mov    %edx,%eax
  8026b4:	d3 e0                	shl    %cl,%eax
  8026b6:	89 e9                	mov    %ebp,%ecx
  8026b8:	d3 eb                	shr    %cl,%ebx
  8026ba:	d3 ea                	shr    %cl,%edx
  8026bc:	09 d8                	or     %ebx,%eax
  8026be:	83 c4 1c             	add    $0x1c,%esp
  8026c1:	5b                   	pop    %ebx
  8026c2:	5e                   	pop    %esi
  8026c3:	5f                   	pop    %edi
  8026c4:	5d                   	pop    %ebp
  8026c5:	c3                   	ret    
  8026c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026cd:	8d 76 00             	lea    0x0(%esi),%esi
  8026d0:	89 da                	mov    %ebx,%edx
  8026d2:	29 fe                	sub    %edi,%esi
  8026d4:	19 c2                	sbb    %eax,%edx
  8026d6:	89 f1                	mov    %esi,%ecx
  8026d8:	89 c8                	mov    %ecx,%eax
  8026da:	e9 4b ff ff ff       	jmp    80262a <__umoddi3+0x8a>
