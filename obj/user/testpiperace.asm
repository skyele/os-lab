
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 d0 01 00 00       	call   800201 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 1c             	sub    $0x1c,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003b:	68 20 2c 80 00       	push   $0x802c20
  800040:	e8 2f 03 00 00       	call   800374 <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 f6 25 00 00       	call   802646 <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 80 00 00 00    	js     8000db <umain+0xa8>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  80005b:	e8 af 13 00 00       	call   80140f <fork>
  800060:	89 c6                	mov    %eax,%esi
  800062:	85 c0                	test   %eax,%eax
  800064:	0f 88 83 00 00 00    	js     8000ed <umain+0xba>
		panic("fork: %e", r);
	if (r == 0) {
  80006a:	0f 84 8f 00 00 00    	je     8000ff <umain+0xcc>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800070:	83 ec 08             	sub    $0x8,%esp
  800073:	56                   	push   %esi
  800074:	68 7a 2c 80 00       	push   $0x802c7a
  800079:	e8 f6 02 00 00       	call   800374 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  80007e:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  800084:	83 c4 08             	add    $0x8,%esp
  800087:	69 c6 84 00 00 00    	imul   $0x84,%esi,%eax
  80008d:	c1 f8 02             	sar    $0x2,%eax
  800090:	69 c0 e1 83 0f 3e    	imul   $0x3e0f83e1,%eax,%eax
  800096:	50                   	push   %eax
  800097:	68 85 2c 80 00       	push   $0x802c85
  80009c:	e8 d3 02 00 00       	call   800374 <cprintf>
	dup(p[0], 10);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	6a 0a                	push   $0xa
  8000a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a9:	e8 f6 18 00 00       	call   8019a4 <dup>
	while (kid->env_status == ENV_RUNNABLE)
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	69 de 84 00 00 00    	imul   $0x84,%esi,%ebx
  8000b7:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000bd:	8b 53 54             	mov    0x54(%ebx),%edx
  8000c0:	83 fa 02             	cmp    $0x2,%edx
  8000c3:	0f 85 94 00 00 00    	jne    80015d <umain+0x12a>
		dup(p[0], 10);
  8000c9:	83 ec 08             	sub    $0x8,%esp
  8000cc:	6a 0a                	push   $0xa
  8000ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8000d1:	e8 ce 18 00 00       	call   8019a4 <dup>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	eb e2                	jmp    8000bd <umain+0x8a>
		panic("pipe: %e", r);
  8000db:	50                   	push   %eax
  8000dc:	68 39 2c 80 00       	push   $0x802c39
  8000e1:	6a 0d                	push   $0xd
  8000e3:	68 42 2c 80 00       	push   $0x802c42
  8000e8:	e8 91 01 00 00       	call   80027e <_panic>
		panic("fork: %e", r);
  8000ed:	50                   	push   %eax
  8000ee:	68 56 2c 80 00       	push   $0x802c56
  8000f3:	6a 10                	push   $0x10
  8000f5:	68 42 2c 80 00       	push   $0x802c42
  8000fa:	e8 7f 01 00 00       	call   80027e <_panic>
		close(p[1]);
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	ff 75 f4             	pushl  -0xc(%ebp)
  800105:	e8 48 18 00 00       	call   801952 <close>
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	bb c8 00 00 00       	mov    $0xc8,%ebx
  800112:	eb 1f                	jmp    800133 <umain+0x100>
				cprintf("RACE: pipe appears closed\n");
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 5f 2c 80 00       	push   $0x802c5f
  80011c:	e8 53 02 00 00       	call   800374 <cprintf>
				exit();
  800121:	e8 24 01 00 00       	call   80024a <exit>
  800126:	83 c4 10             	add    $0x10,%esp
			sys_yield();
  800129:	e8 78 0d 00 00       	call   800ea6 <sys_yield>
		for (i=0; i<max; i++) {
  80012e:	83 eb 01             	sub    $0x1,%ebx
  800131:	74 14                	je     800147 <umain+0x114>
			if(pipeisclosed(p[0])){
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	ff 75 f0             	pushl  -0x10(%ebp)
  800139:	e8 52 26 00 00       	call   802790 <pipeisclosed>
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	85 c0                	test   %eax,%eax
  800143:	74 e4                	je     800129 <umain+0xf6>
  800145:	eb cd                	jmp    800114 <umain+0xe1>
		ipc_recv(0,0,0);
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	6a 00                	push   $0x0
  80014c:	6a 00                	push   $0x0
  80014e:	6a 00                	push   $0x0
  800150:	e8 52 15 00 00       	call   8016a7 <ipc_recv>
  800155:	83 c4 10             	add    $0x10,%esp
  800158:	e9 13 ff ff ff       	jmp    800070 <umain+0x3d>

	cprintf("child done with loop\n");
  80015d:	83 ec 0c             	sub    $0xc,%esp
  800160:	68 90 2c 80 00       	push   $0x802c90
  800165:	e8 0a 02 00 00       	call   800374 <cprintf>
	if (pipeisclosed(p[0]))
  80016a:	83 c4 04             	add    $0x4,%esp
  80016d:	ff 75 f0             	pushl  -0x10(%ebp)
  800170:	e8 1b 26 00 00       	call   802790 <pipeisclosed>
  800175:	83 c4 10             	add    $0x10,%esp
  800178:	85 c0                	test   %eax,%eax
  80017a:	75 48                	jne    8001c4 <umain+0x191>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80017c:	83 ec 08             	sub    $0x8,%esp
  80017f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800182:	50                   	push   %eax
  800183:	ff 75 f0             	pushl  -0x10(%ebp)
  800186:	e8 95 16 00 00       	call   801820 <fd_lookup>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	85 c0                	test   %eax,%eax
  800190:	78 46                	js     8001d8 <umain+0x1a5>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	ff 75 ec             	pushl  -0x14(%ebp)
  800198:	e8 1a 16 00 00       	call   8017b7 <fd2data>
	if (pageref(va) != 3+1)
  80019d:	89 04 24             	mov    %eax,(%esp)
  8001a0:	e8 2e 1e 00 00       	call   801fd3 <pageref>
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	83 f8 04             	cmp    $0x4,%eax
  8001ab:	74 3d                	je     8001ea <umain+0x1b7>
		cprintf("\nchild detected race\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 be 2c 80 00       	push   $0x802cbe
  8001b5:	e8 ba 01 00 00       	call   800374 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nrace didn't happen\n", max);
}
  8001bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001c0:	5b                   	pop    %ebx
  8001c1:	5e                   	pop    %esi
  8001c2:	5d                   	pop    %ebp
  8001c3:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	68 ec 2c 80 00       	push   $0x802cec
  8001cc:	6a 3a                	push   $0x3a
  8001ce:	68 42 2c 80 00       	push   $0x802c42
  8001d3:	e8 a6 00 00 00       	call   80027e <_panic>
		panic("cannot look up p[0]: %e", r);
  8001d8:	50                   	push   %eax
  8001d9:	68 a6 2c 80 00       	push   $0x802ca6
  8001de:	6a 3c                	push   $0x3c
  8001e0:	68 42 2c 80 00       	push   $0x802c42
  8001e5:	e8 94 00 00 00       	call   80027e <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	68 c8 00 00 00       	push   $0xc8
  8001f2:	68 d4 2c 80 00       	push   $0x802cd4
  8001f7:	e8 78 01 00 00       	call   800374 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp
}
  8001ff:	eb bc                	jmp    8001bd <umain+0x18a>

00800201 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800201:	55                   	push   %ebp
  800202:	89 e5                	mov    %esp,%ebp
  800204:	56                   	push   %esi
  800205:	53                   	push   %ebx
  800206:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800209:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  80020c:	e8 76 0c 00 00       	call   800e87 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800211:	25 ff 03 00 00       	and    $0x3ff,%eax
  800216:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80021c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800221:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800226:	85 db                	test   %ebx,%ebx
  800228:	7e 07                	jle    800231 <libmain+0x30>
		binaryname = argv[0];
  80022a:	8b 06                	mov    (%esi),%eax
  80022c:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800231:	83 ec 08             	sub    $0x8,%esp
  800234:	56                   	push   %esi
  800235:	53                   	push   %ebx
  800236:	e8 f8 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80023b:	e8 0a 00 00 00       	call   80024a <exit>
}
  800240:	83 c4 10             	add    $0x10,%esp
  800243:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800246:	5b                   	pop    %ebx
  800247:	5e                   	pop    %esi
  800248:	5d                   	pop    %ebp
  800249:	c3                   	ret    

0080024a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800250:	a1 08 50 80 00       	mov    0x805008,%eax
  800255:	8b 40 48             	mov    0x48(%eax),%eax
  800258:	68 2c 2d 80 00       	push   $0x802d2c
  80025d:	50                   	push   %eax
  80025e:	68 20 2d 80 00       	push   $0x802d20
  800263:	e8 0c 01 00 00       	call   800374 <cprintf>
	close_all();
  800268:	e8 12 17 00 00       	call   80197f <close_all>
	sys_env_destroy(0);
  80026d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800274:	e8 cd 0b 00 00       	call   800e46 <sys_env_destroy>
}
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	56                   	push   %esi
  800282:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800283:	a1 08 50 80 00       	mov    0x805008,%eax
  800288:	8b 40 48             	mov    0x48(%eax),%eax
  80028b:	83 ec 04             	sub    $0x4,%esp
  80028e:	68 58 2d 80 00       	push   $0x802d58
  800293:	50                   	push   %eax
  800294:	68 20 2d 80 00       	push   $0x802d20
  800299:	e8 d6 00 00 00       	call   800374 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80029e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002a1:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8002a7:	e8 db 0b 00 00       	call   800e87 <sys_getenvid>
  8002ac:	83 c4 04             	add    $0x4,%esp
  8002af:	ff 75 0c             	pushl  0xc(%ebp)
  8002b2:	ff 75 08             	pushl  0x8(%ebp)
  8002b5:	56                   	push   %esi
  8002b6:	50                   	push   %eax
  8002b7:	68 34 2d 80 00       	push   $0x802d34
  8002bc:	e8 b3 00 00 00       	call   800374 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002c1:	83 c4 18             	add    $0x18,%esp
  8002c4:	53                   	push   %ebx
  8002c5:	ff 75 10             	pushl  0x10(%ebp)
  8002c8:	e8 56 00 00 00       	call   800323 <vcprintf>
	cprintf("\n");
  8002cd:	c7 04 24 61 31 80 00 	movl   $0x803161,(%esp)
  8002d4:	e8 9b 00 00 00       	call   800374 <cprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002dc:	cc                   	int3   
  8002dd:	eb fd                	jmp    8002dc <_panic+0x5e>

008002df <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	53                   	push   %ebx
  8002e3:	83 ec 04             	sub    $0x4,%esp
  8002e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002e9:	8b 13                	mov    (%ebx),%edx
  8002eb:	8d 42 01             	lea    0x1(%edx),%eax
  8002ee:	89 03                	mov    %eax,(%ebx)
  8002f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002f3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002f7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002fc:	74 09                	je     800307 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002fe:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800302:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800305:	c9                   	leave  
  800306:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	68 ff 00 00 00       	push   $0xff
  80030f:	8d 43 08             	lea    0x8(%ebx),%eax
  800312:	50                   	push   %eax
  800313:	e8 f1 0a 00 00       	call   800e09 <sys_cputs>
		b->idx = 0;
  800318:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	eb db                	jmp    8002fe <putch+0x1f>

00800323 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80032c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800333:	00 00 00 
	b.cnt = 0;
  800336:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80033d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800340:	ff 75 0c             	pushl  0xc(%ebp)
  800343:	ff 75 08             	pushl  0x8(%ebp)
  800346:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80034c:	50                   	push   %eax
  80034d:	68 df 02 80 00       	push   $0x8002df
  800352:	e8 4a 01 00 00       	call   8004a1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800357:	83 c4 08             	add    $0x8,%esp
  80035a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800360:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800366:	50                   	push   %eax
  800367:	e8 9d 0a 00 00       	call   800e09 <sys_cputs>

	return b.cnt;
}
  80036c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800372:	c9                   	leave  
  800373:	c3                   	ret    

00800374 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80037a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80037d:	50                   	push   %eax
  80037e:	ff 75 08             	pushl  0x8(%ebp)
  800381:	e8 9d ff ff ff       	call   800323 <vcprintf>
	va_end(ap);

	return cnt;
}
  800386:	c9                   	leave  
  800387:	c3                   	ret    

00800388 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	57                   	push   %edi
  80038c:	56                   	push   %esi
  80038d:	53                   	push   %ebx
  80038e:	83 ec 1c             	sub    $0x1c,%esp
  800391:	89 c6                	mov    %eax,%esi
  800393:	89 d7                	mov    %edx,%edi
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	8b 55 0c             	mov    0xc(%ebp),%edx
  80039b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80039e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a4:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8003a7:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8003ab:	74 2c                	je     8003d9 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8003ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003bd:	39 c2                	cmp    %eax,%edx
  8003bf:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003c2:	73 43                	jae    800407 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8003c4:	83 eb 01             	sub    $0x1,%ebx
  8003c7:	85 db                	test   %ebx,%ebx
  8003c9:	7e 6c                	jle    800437 <printnum+0xaf>
				putch(padc, putdat);
  8003cb:	83 ec 08             	sub    $0x8,%esp
  8003ce:	57                   	push   %edi
  8003cf:	ff 75 18             	pushl  0x18(%ebp)
  8003d2:	ff d6                	call   *%esi
  8003d4:	83 c4 10             	add    $0x10,%esp
  8003d7:	eb eb                	jmp    8003c4 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003d9:	83 ec 0c             	sub    $0xc,%esp
  8003dc:	6a 20                	push   $0x20
  8003de:	6a 00                	push   $0x0
  8003e0:	50                   	push   %eax
  8003e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003e4:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e7:	89 fa                	mov    %edi,%edx
  8003e9:	89 f0                	mov    %esi,%eax
  8003eb:	e8 98 ff ff ff       	call   800388 <printnum>
		while (--width > 0)
  8003f0:	83 c4 20             	add    $0x20,%esp
  8003f3:	83 eb 01             	sub    $0x1,%ebx
  8003f6:	85 db                	test   %ebx,%ebx
  8003f8:	7e 65                	jle    80045f <printnum+0xd7>
			putch(padc, putdat);
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	57                   	push   %edi
  8003fe:	6a 20                	push   $0x20
  800400:	ff d6                	call   *%esi
  800402:	83 c4 10             	add    $0x10,%esp
  800405:	eb ec                	jmp    8003f3 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800407:	83 ec 0c             	sub    $0xc,%esp
  80040a:	ff 75 18             	pushl  0x18(%ebp)
  80040d:	83 eb 01             	sub    $0x1,%ebx
  800410:	53                   	push   %ebx
  800411:	50                   	push   %eax
  800412:	83 ec 08             	sub    $0x8,%esp
  800415:	ff 75 dc             	pushl  -0x24(%ebp)
  800418:	ff 75 d8             	pushl  -0x28(%ebp)
  80041b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80041e:	ff 75 e0             	pushl  -0x20(%ebp)
  800421:	e8 aa 25 00 00       	call   8029d0 <__udivdi3>
  800426:	83 c4 18             	add    $0x18,%esp
  800429:	52                   	push   %edx
  80042a:	50                   	push   %eax
  80042b:	89 fa                	mov    %edi,%edx
  80042d:	89 f0                	mov    %esi,%eax
  80042f:	e8 54 ff ff ff       	call   800388 <printnum>
  800434:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800437:	83 ec 08             	sub    $0x8,%esp
  80043a:	57                   	push   %edi
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	ff 75 dc             	pushl  -0x24(%ebp)
  800441:	ff 75 d8             	pushl  -0x28(%ebp)
  800444:	ff 75 e4             	pushl  -0x1c(%ebp)
  800447:	ff 75 e0             	pushl  -0x20(%ebp)
  80044a:	e8 91 26 00 00       	call   802ae0 <__umoddi3>
  80044f:	83 c4 14             	add    $0x14,%esp
  800452:	0f be 80 5f 2d 80 00 	movsbl 0x802d5f(%eax),%eax
  800459:	50                   	push   %eax
  80045a:	ff d6                	call   *%esi
  80045c:	83 c4 10             	add    $0x10,%esp
	}
}
  80045f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800462:	5b                   	pop    %ebx
  800463:	5e                   	pop    %esi
  800464:	5f                   	pop    %edi
  800465:	5d                   	pop    %ebp
  800466:	c3                   	ret    

00800467 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
  80046a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80046d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800471:	8b 10                	mov    (%eax),%edx
  800473:	3b 50 04             	cmp    0x4(%eax),%edx
  800476:	73 0a                	jae    800482 <sprintputch+0x1b>
		*b->buf++ = ch;
  800478:	8d 4a 01             	lea    0x1(%edx),%ecx
  80047b:	89 08                	mov    %ecx,(%eax)
  80047d:	8b 45 08             	mov    0x8(%ebp),%eax
  800480:	88 02                	mov    %al,(%edx)
}
  800482:	5d                   	pop    %ebp
  800483:	c3                   	ret    

00800484 <printfmt>:
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80048a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80048d:	50                   	push   %eax
  80048e:	ff 75 10             	pushl  0x10(%ebp)
  800491:	ff 75 0c             	pushl  0xc(%ebp)
  800494:	ff 75 08             	pushl  0x8(%ebp)
  800497:	e8 05 00 00 00       	call   8004a1 <vprintfmt>
}
  80049c:	83 c4 10             	add    $0x10,%esp
  80049f:	c9                   	leave  
  8004a0:	c3                   	ret    

008004a1 <vprintfmt>:
{
  8004a1:	55                   	push   %ebp
  8004a2:	89 e5                	mov    %esp,%ebp
  8004a4:	57                   	push   %edi
  8004a5:	56                   	push   %esi
  8004a6:	53                   	push   %ebx
  8004a7:	83 ec 3c             	sub    $0x3c,%esp
  8004aa:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004b0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004b3:	e9 32 04 00 00       	jmp    8008ea <vprintfmt+0x449>
		padc = ' ';
  8004b8:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8004bc:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8004c3:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8004ca:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004d1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004d8:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004df:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004e4:	8d 47 01             	lea    0x1(%edi),%eax
  8004e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ea:	0f b6 17             	movzbl (%edi),%edx
  8004ed:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004f0:	3c 55                	cmp    $0x55,%al
  8004f2:	0f 87 12 05 00 00    	ja     800a0a <vprintfmt+0x569>
  8004f8:	0f b6 c0             	movzbl %al,%eax
  8004fb:	ff 24 85 40 2f 80 00 	jmp    *0x802f40(,%eax,4)
  800502:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800505:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800509:	eb d9                	jmp    8004e4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80050b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80050e:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800512:	eb d0                	jmp    8004e4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800514:	0f b6 d2             	movzbl %dl,%edx
  800517:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80051a:	b8 00 00 00 00       	mov    $0x0,%eax
  80051f:	89 75 08             	mov    %esi,0x8(%ebp)
  800522:	eb 03                	jmp    800527 <vprintfmt+0x86>
  800524:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800527:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80052a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80052e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800531:	8d 72 d0             	lea    -0x30(%edx),%esi
  800534:	83 fe 09             	cmp    $0x9,%esi
  800537:	76 eb                	jbe    800524 <vprintfmt+0x83>
  800539:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053c:	8b 75 08             	mov    0x8(%ebp),%esi
  80053f:	eb 14                	jmp    800555 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8b 00                	mov    (%eax),%eax
  800546:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800549:	8b 45 14             	mov    0x14(%ebp),%eax
  80054c:	8d 40 04             	lea    0x4(%eax),%eax
  80054f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800552:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800555:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800559:	79 89                	jns    8004e4 <vprintfmt+0x43>
				width = precision, precision = -1;
  80055b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80055e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800561:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800568:	e9 77 ff ff ff       	jmp    8004e4 <vprintfmt+0x43>
  80056d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800570:	85 c0                	test   %eax,%eax
  800572:	0f 48 c1             	cmovs  %ecx,%eax
  800575:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800578:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80057b:	e9 64 ff ff ff       	jmp    8004e4 <vprintfmt+0x43>
  800580:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800583:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80058a:	e9 55 ff ff ff       	jmp    8004e4 <vprintfmt+0x43>
			lflag++;
  80058f:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800593:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800596:	e9 49 ff ff ff       	jmp    8004e4 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80059b:	8b 45 14             	mov    0x14(%ebp),%eax
  80059e:	8d 78 04             	lea    0x4(%eax),%edi
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	53                   	push   %ebx
  8005a5:	ff 30                	pushl  (%eax)
  8005a7:	ff d6                	call   *%esi
			break;
  8005a9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005ac:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005af:	e9 33 03 00 00       	jmp    8008e7 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8d 78 04             	lea    0x4(%eax),%edi
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	99                   	cltd   
  8005bd:	31 d0                	xor    %edx,%eax
  8005bf:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005c1:	83 f8 11             	cmp    $0x11,%eax
  8005c4:	7f 23                	jg     8005e9 <vprintfmt+0x148>
  8005c6:	8b 14 85 a0 30 80 00 	mov    0x8030a0(,%eax,4),%edx
  8005cd:	85 d2                	test   %edx,%edx
  8005cf:	74 18                	je     8005e9 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005d1:	52                   	push   %edx
  8005d2:	68 cd 32 80 00       	push   $0x8032cd
  8005d7:	53                   	push   %ebx
  8005d8:	56                   	push   %esi
  8005d9:	e8 a6 fe ff ff       	call   800484 <printfmt>
  8005de:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005e1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005e4:	e9 fe 02 00 00       	jmp    8008e7 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005e9:	50                   	push   %eax
  8005ea:	68 77 2d 80 00       	push   $0x802d77
  8005ef:	53                   	push   %ebx
  8005f0:	56                   	push   %esi
  8005f1:	e8 8e fe ff ff       	call   800484 <printfmt>
  8005f6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005f9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005fc:	e9 e6 02 00 00       	jmp    8008e7 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	83 c0 04             	add    $0x4,%eax
  800607:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80060f:	85 c9                	test   %ecx,%ecx
  800611:	b8 70 2d 80 00       	mov    $0x802d70,%eax
  800616:	0f 45 c1             	cmovne %ecx,%eax
  800619:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80061c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800620:	7e 06                	jle    800628 <vprintfmt+0x187>
  800622:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800626:	75 0d                	jne    800635 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800628:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80062b:	89 c7                	mov    %eax,%edi
  80062d:	03 45 e0             	add    -0x20(%ebp),%eax
  800630:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800633:	eb 53                	jmp    800688 <vprintfmt+0x1e7>
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	ff 75 d8             	pushl  -0x28(%ebp)
  80063b:	50                   	push   %eax
  80063c:	e8 71 04 00 00       	call   800ab2 <strnlen>
  800641:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800644:	29 c1                	sub    %eax,%ecx
  800646:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80064e:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800652:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800655:	eb 0f                	jmp    800666 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	53                   	push   %ebx
  80065b:	ff 75 e0             	pushl  -0x20(%ebp)
  80065e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800660:	83 ef 01             	sub    $0x1,%edi
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	85 ff                	test   %edi,%edi
  800668:	7f ed                	jg     800657 <vprintfmt+0x1b6>
  80066a:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80066d:	85 c9                	test   %ecx,%ecx
  80066f:	b8 00 00 00 00       	mov    $0x0,%eax
  800674:	0f 49 c1             	cmovns %ecx,%eax
  800677:	29 c1                	sub    %eax,%ecx
  800679:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80067c:	eb aa                	jmp    800628 <vprintfmt+0x187>
					putch(ch, putdat);
  80067e:	83 ec 08             	sub    $0x8,%esp
  800681:	53                   	push   %ebx
  800682:	52                   	push   %edx
  800683:	ff d6                	call   *%esi
  800685:	83 c4 10             	add    $0x10,%esp
  800688:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80068b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068d:	83 c7 01             	add    $0x1,%edi
  800690:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800694:	0f be d0             	movsbl %al,%edx
  800697:	85 d2                	test   %edx,%edx
  800699:	74 4b                	je     8006e6 <vprintfmt+0x245>
  80069b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80069f:	78 06                	js     8006a7 <vprintfmt+0x206>
  8006a1:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006a5:	78 1e                	js     8006c5 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8006a7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006ab:	74 d1                	je     80067e <vprintfmt+0x1dd>
  8006ad:	0f be c0             	movsbl %al,%eax
  8006b0:	83 e8 20             	sub    $0x20,%eax
  8006b3:	83 f8 5e             	cmp    $0x5e,%eax
  8006b6:	76 c6                	jbe    80067e <vprintfmt+0x1dd>
					putch('?', putdat);
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	53                   	push   %ebx
  8006bc:	6a 3f                	push   $0x3f
  8006be:	ff d6                	call   *%esi
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	eb c3                	jmp    800688 <vprintfmt+0x1e7>
  8006c5:	89 cf                	mov    %ecx,%edi
  8006c7:	eb 0e                	jmp    8006d7 <vprintfmt+0x236>
				putch(' ', putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	53                   	push   %ebx
  8006cd:	6a 20                	push   $0x20
  8006cf:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006d1:	83 ef 01             	sub    $0x1,%edi
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	85 ff                	test   %edi,%edi
  8006d9:	7f ee                	jg     8006c9 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006db:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e1:	e9 01 02 00 00       	jmp    8008e7 <vprintfmt+0x446>
  8006e6:	89 cf                	mov    %ecx,%edi
  8006e8:	eb ed                	jmp    8006d7 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006ed:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006f4:	e9 eb fd ff ff       	jmp    8004e4 <vprintfmt+0x43>
	if (lflag >= 2)
  8006f9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006fd:	7f 21                	jg     800720 <vprintfmt+0x27f>
	else if (lflag)
  8006ff:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800703:	74 68                	je     80076d <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80070d:	89 c1                	mov    %eax,%ecx
  80070f:	c1 f9 1f             	sar    $0x1f,%ecx
  800712:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8d 40 04             	lea    0x4(%eax),%eax
  80071b:	89 45 14             	mov    %eax,0x14(%ebp)
  80071e:	eb 17                	jmp    800737 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8b 50 04             	mov    0x4(%eax),%edx
  800726:	8b 00                	mov    (%eax),%eax
  800728:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80072b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8d 40 08             	lea    0x8(%eax),%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800737:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80073a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80073d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800740:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800743:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800747:	78 3f                	js     800788 <vprintfmt+0x2e7>
			base = 10;
  800749:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80074e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800752:	0f 84 71 01 00 00    	je     8008c9 <vprintfmt+0x428>
				putch('+', putdat);
  800758:	83 ec 08             	sub    $0x8,%esp
  80075b:	53                   	push   %ebx
  80075c:	6a 2b                	push   $0x2b
  80075e:	ff d6                	call   *%esi
  800760:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800763:	b8 0a 00 00 00       	mov    $0xa,%eax
  800768:	e9 5c 01 00 00       	jmp    8008c9 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800775:	89 c1                	mov    %eax,%ecx
  800777:	c1 f9 1f             	sar    $0x1f,%ecx
  80077a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8d 40 04             	lea    0x4(%eax),%eax
  800783:	89 45 14             	mov    %eax,0x14(%ebp)
  800786:	eb af                	jmp    800737 <vprintfmt+0x296>
				putch('-', putdat);
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	53                   	push   %ebx
  80078c:	6a 2d                	push   $0x2d
  80078e:	ff d6                	call   *%esi
				num = -(long long) num;
  800790:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800793:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800796:	f7 d8                	neg    %eax
  800798:	83 d2 00             	adc    $0x0,%edx
  80079b:	f7 da                	neg    %edx
  80079d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007a6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ab:	e9 19 01 00 00       	jmp    8008c9 <vprintfmt+0x428>
	if (lflag >= 2)
  8007b0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007b4:	7f 29                	jg     8007df <vprintfmt+0x33e>
	else if (lflag)
  8007b6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007ba:	74 44                	je     800800 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	8d 40 04             	lea    0x4(%eax),%eax
  8007d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007da:	e9 ea 00 00 00       	jmp    8008c9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8b 50 04             	mov    0x4(%eax),%edx
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	8d 40 08             	lea    0x8(%eax),%eax
  8007f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007f6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fb:	e9 c9 00 00 00       	jmp    8008c9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	ba 00 00 00 00       	mov    $0x0,%edx
  80080a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	8d 40 04             	lea    0x4(%eax),%eax
  800816:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800819:	b8 0a 00 00 00       	mov    $0xa,%eax
  80081e:	e9 a6 00 00 00       	jmp    8008c9 <vprintfmt+0x428>
			putch('0', putdat);
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	53                   	push   %ebx
  800827:	6a 30                	push   $0x30
  800829:	ff d6                	call   *%esi
	if (lflag >= 2)
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800832:	7f 26                	jg     80085a <vprintfmt+0x3b9>
	else if (lflag)
  800834:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800838:	74 3e                	je     800878 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	8b 00                	mov    (%eax),%eax
  80083f:	ba 00 00 00 00       	mov    $0x0,%edx
  800844:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800847:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80084a:	8b 45 14             	mov    0x14(%ebp),%eax
  80084d:	8d 40 04             	lea    0x4(%eax),%eax
  800850:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800853:	b8 08 00 00 00       	mov    $0x8,%eax
  800858:	eb 6f                	jmp    8008c9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	8b 50 04             	mov    0x4(%eax),%edx
  800860:	8b 00                	mov    (%eax),%eax
  800862:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800865:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8d 40 08             	lea    0x8(%eax),%eax
  80086e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800871:	b8 08 00 00 00       	mov    $0x8,%eax
  800876:	eb 51                	jmp    8008c9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	ba 00 00 00 00       	mov    $0x0,%edx
  800882:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800885:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800888:	8b 45 14             	mov    0x14(%ebp),%eax
  80088b:	8d 40 04             	lea    0x4(%eax),%eax
  80088e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800891:	b8 08 00 00 00       	mov    $0x8,%eax
  800896:	eb 31                	jmp    8008c9 <vprintfmt+0x428>
			putch('0', putdat);
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	53                   	push   %ebx
  80089c:	6a 30                	push   $0x30
  80089e:	ff d6                	call   *%esi
			putch('x', putdat);
  8008a0:	83 c4 08             	add    $0x8,%esp
  8008a3:	53                   	push   %ebx
  8008a4:	6a 78                	push   $0x78
  8008a6:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ab:	8b 00                	mov    (%eax),%eax
  8008ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008b8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	8d 40 04             	lea    0x4(%eax),%eax
  8008c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c4:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008c9:	83 ec 0c             	sub    $0xc,%esp
  8008cc:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008d0:	52                   	push   %edx
  8008d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8008d4:	50                   	push   %eax
  8008d5:	ff 75 dc             	pushl  -0x24(%ebp)
  8008d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8008db:	89 da                	mov    %ebx,%edx
  8008dd:	89 f0                	mov    %esi,%eax
  8008df:	e8 a4 fa ff ff       	call   800388 <printnum>
			break;
  8008e4:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ea:	83 c7 01             	add    $0x1,%edi
  8008ed:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008f1:	83 f8 25             	cmp    $0x25,%eax
  8008f4:	0f 84 be fb ff ff    	je     8004b8 <vprintfmt+0x17>
			if (ch == '\0')
  8008fa:	85 c0                	test   %eax,%eax
  8008fc:	0f 84 28 01 00 00    	je     800a2a <vprintfmt+0x589>
			putch(ch, putdat);
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	53                   	push   %ebx
  800906:	50                   	push   %eax
  800907:	ff d6                	call   *%esi
  800909:	83 c4 10             	add    $0x10,%esp
  80090c:	eb dc                	jmp    8008ea <vprintfmt+0x449>
	if (lflag >= 2)
  80090e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800912:	7f 26                	jg     80093a <vprintfmt+0x499>
	else if (lflag)
  800914:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800918:	74 41                	je     80095b <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	ba 00 00 00 00       	mov    $0x0,%edx
  800924:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800927:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	8d 40 04             	lea    0x4(%eax),%eax
  800930:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800933:	b8 10 00 00 00       	mov    $0x10,%eax
  800938:	eb 8f                	jmp    8008c9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80093a:	8b 45 14             	mov    0x14(%ebp),%eax
  80093d:	8b 50 04             	mov    0x4(%eax),%edx
  800940:	8b 00                	mov    (%eax),%eax
  800942:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800945:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	8d 40 08             	lea    0x8(%eax),%eax
  80094e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800951:	b8 10 00 00 00       	mov    $0x10,%eax
  800956:	e9 6e ff ff ff       	jmp    8008c9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80095b:	8b 45 14             	mov    0x14(%ebp),%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	ba 00 00 00 00       	mov    $0x0,%edx
  800965:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800968:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	8d 40 04             	lea    0x4(%eax),%eax
  800971:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800974:	b8 10 00 00 00       	mov    $0x10,%eax
  800979:	e9 4b ff ff ff       	jmp    8008c9 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80097e:	8b 45 14             	mov    0x14(%ebp),%eax
  800981:	83 c0 04             	add    $0x4,%eax
  800984:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800987:	8b 45 14             	mov    0x14(%ebp),%eax
  80098a:	8b 00                	mov    (%eax),%eax
  80098c:	85 c0                	test   %eax,%eax
  80098e:	74 14                	je     8009a4 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800990:	8b 13                	mov    (%ebx),%edx
  800992:	83 fa 7f             	cmp    $0x7f,%edx
  800995:	7f 37                	jg     8009ce <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800997:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800999:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80099c:	89 45 14             	mov    %eax,0x14(%ebp)
  80099f:	e9 43 ff ff ff       	jmp    8008e7 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8009a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009a9:	bf 95 2e 80 00       	mov    $0x802e95,%edi
							putch(ch, putdat);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	53                   	push   %ebx
  8009b2:	50                   	push   %eax
  8009b3:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009b5:	83 c7 01             	add    $0x1,%edi
  8009b8:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
  8009bf:	85 c0                	test   %eax,%eax
  8009c1:	75 eb                	jne    8009ae <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8009c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c9:	e9 19 ff ff ff       	jmp    8008e7 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009ce:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009d5:	bf cd 2e 80 00       	mov    $0x802ecd,%edi
							putch(ch, putdat);
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	53                   	push   %ebx
  8009de:	50                   	push   %eax
  8009df:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009e1:	83 c7 01             	add    $0x1,%edi
  8009e4:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
  8009eb:	85 c0                	test   %eax,%eax
  8009ed:	75 eb                	jne    8009da <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f5:	e9 ed fe ff ff       	jmp    8008e7 <vprintfmt+0x446>
			putch(ch, putdat);
  8009fa:	83 ec 08             	sub    $0x8,%esp
  8009fd:	53                   	push   %ebx
  8009fe:	6a 25                	push   $0x25
  800a00:	ff d6                	call   *%esi
			break;
  800a02:	83 c4 10             	add    $0x10,%esp
  800a05:	e9 dd fe ff ff       	jmp    8008e7 <vprintfmt+0x446>
			putch('%', putdat);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	53                   	push   %ebx
  800a0e:	6a 25                	push   $0x25
  800a10:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a12:	83 c4 10             	add    $0x10,%esp
  800a15:	89 f8                	mov    %edi,%eax
  800a17:	eb 03                	jmp    800a1c <vprintfmt+0x57b>
  800a19:	83 e8 01             	sub    $0x1,%eax
  800a1c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a20:	75 f7                	jne    800a19 <vprintfmt+0x578>
  800a22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a25:	e9 bd fe ff ff       	jmp    8008e7 <vprintfmt+0x446>
}
  800a2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a2d:	5b                   	pop    %ebx
  800a2e:	5e                   	pop    %esi
  800a2f:	5f                   	pop    %edi
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	83 ec 18             	sub    $0x18,%esp
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a41:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a45:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a4f:	85 c0                	test   %eax,%eax
  800a51:	74 26                	je     800a79 <vsnprintf+0x47>
  800a53:	85 d2                	test   %edx,%edx
  800a55:	7e 22                	jle    800a79 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a57:	ff 75 14             	pushl  0x14(%ebp)
  800a5a:	ff 75 10             	pushl  0x10(%ebp)
  800a5d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a60:	50                   	push   %eax
  800a61:	68 67 04 80 00       	push   $0x800467
  800a66:	e8 36 fa ff ff       	call   8004a1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a6e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a74:	83 c4 10             	add    $0x10,%esp
}
  800a77:	c9                   	leave  
  800a78:	c3                   	ret    
		return -E_INVAL;
  800a79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a7e:	eb f7                	jmp    800a77 <vsnprintf+0x45>

00800a80 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a86:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a89:	50                   	push   %eax
  800a8a:	ff 75 10             	pushl  0x10(%ebp)
  800a8d:	ff 75 0c             	pushl  0xc(%ebp)
  800a90:	ff 75 08             	pushl  0x8(%ebp)
  800a93:	e8 9a ff ff ff       	call   800a32 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a98:	c9                   	leave  
  800a99:	c3                   	ret    

00800a9a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800aa9:	74 05                	je     800ab0 <strlen+0x16>
		n++;
  800aab:	83 c0 01             	add    $0x1,%eax
  800aae:	eb f5                	jmp    800aa5 <strlen+0xb>
	return n;
}
  800ab0:	5d                   	pop    %ebp
  800ab1:	c3                   	ret    

00800ab2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800abb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac0:	39 c2                	cmp    %eax,%edx
  800ac2:	74 0d                	je     800ad1 <strnlen+0x1f>
  800ac4:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ac8:	74 05                	je     800acf <strnlen+0x1d>
		n++;
  800aca:	83 c2 01             	add    $0x1,%edx
  800acd:	eb f1                	jmp    800ac0 <strnlen+0xe>
  800acf:	89 d0                	mov    %edx,%eax
	return n;
}
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	53                   	push   %ebx
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800add:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae2:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ae6:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ae9:	83 c2 01             	add    $0x1,%edx
  800aec:	84 c9                	test   %cl,%cl
  800aee:	75 f2                	jne    800ae2 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800af0:	5b                   	pop    %ebx
  800af1:	5d                   	pop    %ebp
  800af2:	c3                   	ret    

00800af3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	53                   	push   %ebx
  800af7:	83 ec 10             	sub    $0x10,%esp
  800afa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800afd:	53                   	push   %ebx
  800afe:	e8 97 ff ff ff       	call   800a9a <strlen>
  800b03:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b06:	ff 75 0c             	pushl  0xc(%ebp)
  800b09:	01 d8                	add    %ebx,%eax
  800b0b:	50                   	push   %eax
  800b0c:	e8 c2 ff ff ff       	call   800ad3 <strcpy>
	return dst;
}
  800b11:	89 d8                	mov    %ebx,%eax
  800b13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b16:	c9                   	leave  
  800b17:	c3                   	ret    

00800b18 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	56                   	push   %esi
  800b1c:	53                   	push   %ebx
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b23:	89 c6                	mov    %eax,%esi
  800b25:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b28:	89 c2                	mov    %eax,%edx
  800b2a:	39 f2                	cmp    %esi,%edx
  800b2c:	74 11                	je     800b3f <strncpy+0x27>
		*dst++ = *src;
  800b2e:	83 c2 01             	add    $0x1,%edx
  800b31:	0f b6 19             	movzbl (%ecx),%ebx
  800b34:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b37:	80 fb 01             	cmp    $0x1,%bl
  800b3a:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b3d:	eb eb                	jmp    800b2a <strncpy+0x12>
	}
	return ret;
}
  800b3f:	5b                   	pop    %ebx
  800b40:	5e                   	pop    %esi
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	56                   	push   %esi
  800b47:	53                   	push   %ebx
  800b48:	8b 75 08             	mov    0x8(%ebp),%esi
  800b4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b4e:	8b 55 10             	mov    0x10(%ebp),%edx
  800b51:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b53:	85 d2                	test   %edx,%edx
  800b55:	74 21                	je     800b78 <strlcpy+0x35>
  800b57:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b5b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b5d:	39 c2                	cmp    %eax,%edx
  800b5f:	74 14                	je     800b75 <strlcpy+0x32>
  800b61:	0f b6 19             	movzbl (%ecx),%ebx
  800b64:	84 db                	test   %bl,%bl
  800b66:	74 0b                	je     800b73 <strlcpy+0x30>
			*dst++ = *src++;
  800b68:	83 c1 01             	add    $0x1,%ecx
  800b6b:	83 c2 01             	add    $0x1,%edx
  800b6e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b71:	eb ea                	jmp    800b5d <strlcpy+0x1a>
  800b73:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b75:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b78:	29 f0                	sub    %esi,%eax
}
  800b7a:	5b                   	pop    %ebx
  800b7b:	5e                   	pop    %esi
  800b7c:	5d                   	pop    %ebp
  800b7d:	c3                   	ret    

00800b7e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b84:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b87:	0f b6 01             	movzbl (%ecx),%eax
  800b8a:	84 c0                	test   %al,%al
  800b8c:	74 0c                	je     800b9a <strcmp+0x1c>
  800b8e:	3a 02                	cmp    (%edx),%al
  800b90:	75 08                	jne    800b9a <strcmp+0x1c>
		p++, q++;
  800b92:	83 c1 01             	add    $0x1,%ecx
  800b95:	83 c2 01             	add    $0x1,%edx
  800b98:	eb ed                	jmp    800b87 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b9a:	0f b6 c0             	movzbl %al,%eax
  800b9d:	0f b6 12             	movzbl (%edx),%edx
  800ba0:	29 d0                	sub    %edx,%eax
}
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	53                   	push   %ebx
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bae:	89 c3                	mov    %eax,%ebx
  800bb0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bb3:	eb 06                	jmp    800bbb <strncmp+0x17>
		n--, p++, q++;
  800bb5:	83 c0 01             	add    $0x1,%eax
  800bb8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bbb:	39 d8                	cmp    %ebx,%eax
  800bbd:	74 16                	je     800bd5 <strncmp+0x31>
  800bbf:	0f b6 08             	movzbl (%eax),%ecx
  800bc2:	84 c9                	test   %cl,%cl
  800bc4:	74 04                	je     800bca <strncmp+0x26>
  800bc6:	3a 0a                	cmp    (%edx),%cl
  800bc8:	74 eb                	je     800bb5 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bca:	0f b6 00             	movzbl (%eax),%eax
  800bcd:	0f b6 12             	movzbl (%edx),%edx
  800bd0:	29 d0                	sub    %edx,%eax
}
  800bd2:	5b                   	pop    %ebx
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    
		return 0;
  800bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bda:	eb f6                	jmp    800bd2 <strncmp+0x2e>

00800bdc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800be6:	0f b6 10             	movzbl (%eax),%edx
  800be9:	84 d2                	test   %dl,%dl
  800beb:	74 09                	je     800bf6 <strchr+0x1a>
		if (*s == c)
  800bed:	38 ca                	cmp    %cl,%dl
  800bef:	74 0a                	je     800bfb <strchr+0x1f>
	for (; *s; s++)
  800bf1:	83 c0 01             	add    $0x1,%eax
  800bf4:	eb f0                	jmp    800be6 <strchr+0xa>
			return (char *) s;
	return 0;
  800bf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bfb:	5d                   	pop    %ebp
  800bfc:	c3                   	ret    

00800bfd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c07:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c0a:	38 ca                	cmp    %cl,%dl
  800c0c:	74 09                	je     800c17 <strfind+0x1a>
  800c0e:	84 d2                	test   %dl,%dl
  800c10:	74 05                	je     800c17 <strfind+0x1a>
	for (; *s; s++)
  800c12:	83 c0 01             	add    $0x1,%eax
  800c15:	eb f0                	jmp    800c07 <strfind+0xa>
			break;
	return (char *) s;
}
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    

00800c19 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	57                   	push   %edi
  800c1d:	56                   	push   %esi
  800c1e:	53                   	push   %ebx
  800c1f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c22:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c25:	85 c9                	test   %ecx,%ecx
  800c27:	74 31                	je     800c5a <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c29:	89 f8                	mov    %edi,%eax
  800c2b:	09 c8                	or     %ecx,%eax
  800c2d:	a8 03                	test   $0x3,%al
  800c2f:	75 23                	jne    800c54 <memset+0x3b>
		c &= 0xFF;
  800c31:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c35:	89 d3                	mov    %edx,%ebx
  800c37:	c1 e3 08             	shl    $0x8,%ebx
  800c3a:	89 d0                	mov    %edx,%eax
  800c3c:	c1 e0 18             	shl    $0x18,%eax
  800c3f:	89 d6                	mov    %edx,%esi
  800c41:	c1 e6 10             	shl    $0x10,%esi
  800c44:	09 f0                	or     %esi,%eax
  800c46:	09 c2                	or     %eax,%edx
  800c48:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c4a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c4d:	89 d0                	mov    %edx,%eax
  800c4f:	fc                   	cld    
  800c50:	f3 ab                	rep stos %eax,%es:(%edi)
  800c52:	eb 06                	jmp    800c5a <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c57:	fc                   	cld    
  800c58:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c5a:	89 f8                	mov    %edi,%eax
  800c5c:	5b                   	pop    %ebx
  800c5d:	5e                   	pop    %esi
  800c5e:	5f                   	pop    %edi
  800c5f:	5d                   	pop    %ebp
  800c60:	c3                   	ret    

00800c61 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	57                   	push   %edi
  800c65:	56                   	push   %esi
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c6f:	39 c6                	cmp    %eax,%esi
  800c71:	73 32                	jae    800ca5 <memmove+0x44>
  800c73:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c76:	39 c2                	cmp    %eax,%edx
  800c78:	76 2b                	jbe    800ca5 <memmove+0x44>
		s += n;
		d += n;
  800c7a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c7d:	89 fe                	mov    %edi,%esi
  800c7f:	09 ce                	or     %ecx,%esi
  800c81:	09 d6                	or     %edx,%esi
  800c83:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c89:	75 0e                	jne    800c99 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c8b:	83 ef 04             	sub    $0x4,%edi
  800c8e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c91:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c94:	fd                   	std    
  800c95:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c97:	eb 09                	jmp    800ca2 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c99:	83 ef 01             	sub    $0x1,%edi
  800c9c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c9f:	fd                   	std    
  800ca0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ca2:	fc                   	cld    
  800ca3:	eb 1a                	jmp    800cbf <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ca5:	89 c2                	mov    %eax,%edx
  800ca7:	09 ca                	or     %ecx,%edx
  800ca9:	09 f2                	or     %esi,%edx
  800cab:	f6 c2 03             	test   $0x3,%dl
  800cae:	75 0a                	jne    800cba <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cb0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cb3:	89 c7                	mov    %eax,%edi
  800cb5:	fc                   	cld    
  800cb6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cb8:	eb 05                	jmp    800cbf <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cba:	89 c7                	mov    %eax,%edi
  800cbc:	fc                   	cld    
  800cbd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cbf:	5e                   	pop    %esi
  800cc0:	5f                   	pop    %edi
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cc9:	ff 75 10             	pushl  0x10(%ebp)
  800ccc:	ff 75 0c             	pushl  0xc(%ebp)
  800ccf:	ff 75 08             	pushl  0x8(%ebp)
  800cd2:	e8 8a ff ff ff       	call   800c61 <memmove>
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	56                   	push   %esi
  800cdd:	53                   	push   %ebx
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce4:	89 c6                	mov    %eax,%esi
  800ce6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ce9:	39 f0                	cmp    %esi,%eax
  800ceb:	74 1c                	je     800d09 <memcmp+0x30>
		if (*s1 != *s2)
  800ced:	0f b6 08             	movzbl (%eax),%ecx
  800cf0:	0f b6 1a             	movzbl (%edx),%ebx
  800cf3:	38 d9                	cmp    %bl,%cl
  800cf5:	75 08                	jne    800cff <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cf7:	83 c0 01             	add    $0x1,%eax
  800cfa:	83 c2 01             	add    $0x1,%edx
  800cfd:	eb ea                	jmp    800ce9 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cff:	0f b6 c1             	movzbl %cl,%eax
  800d02:	0f b6 db             	movzbl %bl,%ebx
  800d05:	29 d8                	sub    %ebx,%eax
  800d07:	eb 05                	jmp    800d0e <memcmp+0x35>
	}

	return 0;
  800d09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d0e:	5b                   	pop    %ebx
  800d0f:	5e                   	pop    %esi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d1b:	89 c2                	mov    %eax,%edx
  800d1d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d20:	39 d0                	cmp    %edx,%eax
  800d22:	73 09                	jae    800d2d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d24:	38 08                	cmp    %cl,(%eax)
  800d26:	74 05                	je     800d2d <memfind+0x1b>
	for (; s < ends; s++)
  800d28:	83 c0 01             	add    $0x1,%eax
  800d2b:	eb f3                	jmp    800d20 <memfind+0xe>
			break;
	return (void *) s;
}
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	57                   	push   %edi
  800d33:	56                   	push   %esi
  800d34:	53                   	push   %ebx
  800d35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d38:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d3b:	eb 03                	jmp    800d40 <strtol+0x11>
		s++;
  800d3d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d40:	0f b6 01             	movzbl (%ecx),%eax
  800d43:	3c 20                	cmp    $0x20,%al
  800d45:	74 f6                	je     800d3d <strtol+0xe>
  800d47:	3c 09                	cmp    $0x9,%al
  800d49:	74 f2                	je     800d3d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d4b:	3c 2b                	cmp    $0x2b,%al
  800d4d:	74 2a                	je     800d79 <strtol+0x4a>
	int neg = 0;
  800d4f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d54:	3c 2d                	cmp    $0x2d,%al
  800d56:	74 2b                	je     800d83 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d58:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d5e:	75 0f                	jne    800d6f <strtol+0x40>
  800d60:	80 39 30             	cmpb   $0x30,(%ecx)
  800d63:	74 28                	je     800d8d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d65:	85 db                	test   %ebx,%ebx
  800d67:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d6c:	0f 44 d8             	cmove  %eax,%ebx
  800d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d74:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d77:	eb 50                	jmp    800dc9 <strtol+0x9a>
		s++;
  800d79:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d7c:	bf 00 00 00 00       	mov    $0x0,%edi
  800d81:	eb d5                	jmp    800d58 <strtol+0x29>
		s++, neg = 1;
  800d83:	83 c1 01             	add    $0x1,%ecx
  800d86:	bf 01 00 00 00       	mov    $0x1,%edi
  800d8b:	eb cb                	jmp    800d58 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d8d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d91:	74 0e                	je     800da1 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d93:	85 db                	test   %ebx,%ebx
  800d95:	75 d8                	jne    800d6f <strtol+0x40>
		s++, base = 8;
  800d97:	83 c1 01             	add    $0x1,%ecx
  800d9a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d9f:	eb ce                	jmp    800d6f <strtol+0x40>
		s += 2, base = 16;
  800da1:	83 c1 02             	add    $0x2,%ecx
  800da4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800da9:	eb c4                	jmp    800d6f <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800dab:	8d 72 9f             	lea    -0x61(%edx),%esi
  800dae:	89 f3                	mov    %esi,%ebx
  800db0:	80 fb 19             	cmp    $0x19,%bl
  800db3:	77 29                	ja     800dde <strtol+0xaf>
			dig = *s - 'a' + 10;
  800db5:	0f be d2             	movsbl %dl,%edx
  800db8:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dbb:	3b 55 10             	cmp    0x10(%ebp),%edx
  800dbe:	7d 30                	jge    800df0 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800dc0:	83 c1 01             	add    $0x1,%ecx
  800dc3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dc7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800dc9:	0f b6 11             	movzbl (%ecx),%edx
  800dcc:	8d 72 d0             	lea    -0x30(%edx),%esi
  800dcf:	89 f3                	mov    %esi,%ebx
  800dd1:	80 fb 09             	cmp    $0x9,%bl
  800dd4:	77 d5                	ja     800dab <strtol+0x7c>
			dig = *s - '0';
  800dd6:	0f be d2             	movsbl %dl,%edx
  800dd9:	83 ea 30             	sub    $0x30,%edx
  800ddc:	eb dd                	jmp    800dbb <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800dde:	8d 72 bf             	lea    -0x41(%edx),%esi
  800de1:	89 f3                	mov    %esi,%ebx
  800de3:	80 fb 19             	cmp    $0x19,%bl
  800de6:	77 08                	ja     800df0 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800de8:	0f be d2             	movsbl %dl,%edx
  800deb:	83 ea 37             	sub    $0x37,%edx
  800dee:	eb cb                	jmp    800dbb <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800df0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df4:	74 05                	je     800dfb <strtol+0xcc>
		*endptr = (char *) s;
  800df6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800df9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800dfb:	89 c2                	mov    %eax,%edx
  800dfd:	f7 da                	neg    %edx
  800dff:	85 ff                	test   %edi,%edi
  800e01:	0f 45 c2             	cmovne %edx,%eax
}
  800e04:	5b                   	pop    %ebx
  800e05:	5e                   	pop    %esi
  800e06:	5f                   	pop    %edi
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    

00800e09 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	57                   	push   %edi
  800e0d:	56                   	push   %esi
  800e0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e14:	8b 55 08             	mov    0x8(%ebp),%edx
  800e17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1a:	89 c3                	mov    %eax,%ebx
  800e1c:	89 c7                	mov    %eax,%edi
  800e1e:	89 c6                	mov    %eax,%esi
  800e20:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e22:	5b                   	pop    %ebx
  800e23:	5e                   	pop    %esi
  800e24:	5f                   	pop    %edi
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    

00800e27 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	57                   	push   %edi
  800e2b:	56                   	push   %esi
  800e2c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e32:	b8 01 00 00 00       	mov    $0x1,%eax
  800e37:	89 d1                	mov    %edx,%ecx
  800e39:	89 d3                	mov    %edx,%ebx
  800e3b:	89 d7                	mov    %edx,%edi
  800e3d:	89 d6                	mov    %edx,%esi
  800e3f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
  800e4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e54:	8b 55 08             	mov    0x8(%ebp),%edx
  800e57:	b8 03 00 00 00       	mov    $0x3,%eax
  800e5c:	89 cb                	mov    %ecx,%ebx
  800e5e:	89 cf                	mov    %ecx,%edi
  800e60:	89 ce                	mov    %ecx,%esi
  800e62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e64:	85 c0                	test   %eax,%eax
  800e66:	7f 08                	jg     800e70 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6b:	5b                   	pop    %ebx
  800e6c:	5e                   	pop    %esi
  800e6d:	5f                   	pop    %edi
  800e6e:	5d                   	pop    %ebp
  800e6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e70:	83 ec 0c             	sub    $0xc,%esp
  800e73:	50                   	push   %eax
  800e74:	6a 03                	push   $0x3
  800e76:	68 e8 30 80 00       	push   $0x8030e8
  800e7b:	6a 43                	push   $0x43
  800e7d:	68 05 31 80 00       	push   $0x803105
  800e82:	e8 f7 f3 ff ff       	call   80027e <_panic>

00800e87 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	57                   	push   %edi
  800e8b:	56                   	push   %esi
  800e8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e92:	b8 02 00 00 00       	mov    $0x2,%eax
  800e97:	89 d1                	mov    %edx,%ecx
  800e99:	89 d3                	mov    %edx,%ebx
  800e9b:	89 d7                	mov    %edx,%edi
  800e9d:	89 d6                	mov    %edx,%esi
  800e9f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ea1:	5b                   	pop    %ebx
  800ea2:	5e                   	pop    %esi
  800ea3:	5f                   	pop    %edi
  800ea4:	5d                   	pop    %ebp
  800ea5:	c3                   	ret    

00800ea6 <sys_yield>:

void
sys_yield(void)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	57                   	push   %edi
  800eaa:	56                   	push   %esi
  800eab:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eac:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb1:	b8 0b 00 00 00       	mov    $0xb,%eax
  800eb6:	89 d1                	mov    %edx,%ecx
  800eb8:	89 d3                	mov    %edx,%ebx
  800eba:	89 d7                	mov    %edx,%edi
  800ebc:	89 d6                	mov    %edx,%esi
  800ebe:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    

00800ec5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	57                   	push   %edi
  800ec9:	56                   	push   %esi
  800eca:	53                   	push   %ebx
  800ecb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ece:	be 00 00 00 00       	mov    $0x0,%esi
  800ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed9:	b8 04 00 00 00       	mov    $0x4,%eax
  800ede:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee1:	89 f7                	mov    %esi,%edi
  800ee3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee5:	85 c0                	test   %eax,%eax
  800ee7:	7f 08                	jg     800ef1 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ee9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eec:	5b                   	pop    %ebx
  800eed:	5e                   	pop    %esi
  800eee:	5f                   	pop    %edi
  800eef:	5d                   	pop    %ebp
  800ef0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef1:	83 ec 0c             	sub    $0xc,%esp
  800ef4:	50                   	push   %eax
  800ef5:	6a 04                	push   $0x4
  800ef7:	68 e8 30 80 00       	push   $0x8030e8
  800efc:	6a 43                	push   $0x43
  800efe:	68 05 31 80 00       	push   $0x803105
  800f03:	e8 76 f3 ff ff       	call   80027e <_panic>

00800f08 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	57                   	push   %edi
  800f0c:	56                   	push   %esi
  800f0d:	53                   	push   %ebx
  800f0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f11:	8b 55 08             	mov    0x8(%ebp),%edx
  800f14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f17:	b8 05 00 00 00       	mov    $0x5,%eax
  800f1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f22:	8b 75 18             	mov    0x18(%ebp),%esi
  800f25:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f27:	85 c0                	test   %eax,%eax
  800f29:	7f 08                	jg     800f33 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2e:	5b                   	pop    %ebx
  800f2f:	5e                   	pop    %esi
  800f30:	5f                   	pop    %edi
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f33:	83 ec 0c             	sub    $0xc,%esp
  800f36:	50                   	push   %eax
  800f37:	6a 05                	push   $0x5
  800f39:	68 e8 30 80 00       	push   $0x8030e8
  800f3e:	6a 43                	push   $0x43
  800f40:	68 05 31 80 00       	push   $0x803105
  800f45:	e8 34 f3 ff ff       	call   80027e <_panic>

00800f4a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	57                   	push   %edi
  800f4e:	56                   	push   %esi
  800f4f:	53                   	push   %ebx
  800f50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f58:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5e:	b8 06 00 00 00       	mov    $0x6,%eax
  800f63:	89 df                	mov    %ebx,%edi
  800f65:	89 de                	mov    %ebx,%esi
  800f67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	7f 08                	jg     800f75 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f70:	5b                   	pop    %ebx
  800f71:	5e                   	pop    %esi
  800f72:	5f                   	pop    %edi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f75:	83 ec 0c             	sub    $0xc,%esp
  800f78:	50                   	push   %eax
  800f79:	6a 06                	push   $0x6
  800f7b:	68 e8 30 80 00       	push   $0x8030e8
  800f80:	6a 43                	push   $0x43
  800f82:	68 05 31 80 00       	push   $0x803105
  800f87:	e8 f2 f2 ff ff       	call   80027e <_panic>

00800f8c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	57                   	push   %edi
  800f90:	56                   	push   %esi
  800f91:	53                   	push   %ebx
  800f92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa0:	b8 08 00 00 00       	mov    $0x8,%eax
  800fa5:	89 df                	mov    %ebx,%edi
  800fa7:	89 de                	mov    %ebx,%esi
  800fa9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fab:	85 c0                	test   %eax,%eax
  800fad:	7f 08                	jg     800fb7 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb2:	5b                   	pop    %ebx
  800fb3:	5e                   	pop    %esi
  800fb4:	5f                   	pop    %edi
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb7:	83 ec 0c             	sub    $0xc,%esp
  800fba:	50                   	push   %eax
  800fbb:	6a 08                	push   $0x8
  800fbd:	68 e8 30 80 00       	push   $0x8030e8
  800fc2:	6a 43                	push   $0x43
  800fc4:	68 05 31 80 00       	push   $0x803105
  800fc9:	e8 b0 f2 ff ff       	call   80027e <_panic>

00800fce <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	57                   	push   %edi
  800fd2:	56                   	push   %esi
  800fd3:	53                   	push   %ebx
  800fd4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe2:	b8 09 00 00 00       	mov    $0x9,%eax
  800fe7:	89 df                	mov    %ebx,%edi
  800fe9:	89 de                	mov    %ebx,%esi
  800feb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fed:	85 c0                	test   %eax,%eax
  800fef:	7f 08                	jg     800ff9 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff4:	5b                   	pop    %ebx
  800ff5:	5e                   	pop    %esi
  800ff6:	5f                   	pop    %edi
  800ff7:	5d                   	pop    %ebp
  800ff8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff9:	83 ec 0c             	sub    $0xc,%esp
  800ffc:	50                   	push   %eax
  800ffd:	6a 09                	push   $0x9
  800fff:	68 e8 30 80 00       	push   $0x8030e8
  801004:	6a 43                	push   $0x43
  801006:	68 05 31 80 00       	push   $0x803105
  80100b:	e8 6e f2 ff ff       	call   80027e <_panic>

00801010 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	57                   	push   %edi
  801014:	56                   	push   %esi
  801015:	53                   	push   %ebx
  801016:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801019:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101e:	8b 55 08             	mov    0x8(%ebp),%edx
  801021:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801024:	b8 0a 00 00 00       	mov    $0xa,%eax
  801029:	89 df                	mov    %ebx,%edi
  80102b:	89 de                	mov    %ebx,%esi
  80102d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80102f:	85 c0                	test   %eax,%eax
  801031:	7f 08                	jg     80103b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801033:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801036:	5b                   	pop    %ebx
  801037:	5e                   	pop    %esi
  801038:	5f                   	pop    %edi
  801039:	5d                   	pop    %ebp
  80103a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80103b:	83 ec 0c             	sub    $0xc,%esp
  80103e:	50                   	push   %eax
  80103f:	6a 0a                	push   $0xa
  801041:	68 e8 30 80 00       	push   $0x8030e8
  801046:	6a 43                	push   $0x43
  801048:	68 05 31 80 00       	push   $0x803105
  80104d:	e8 2c f2 ff ff       	call   80027e <_panic>

00801052 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	57                   	push   %edi
  801056:	56                   	push   %esi
  801057:	53                   	push   %ebx
	asm volatile("int %1\n"
  801058:	8b 55 08             	mov    0x8(%ebp),%edx
  80105b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801063:	be 00 00 00 00       	mov    $0x0,%esi
  801068:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80106b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80106e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801070:	5b                   	pop    %ebx
  801071:	5e                   	pop    %esi
  801072:	5f                   	pop    %edi
  801073:	5d                   	pop    %ebp
  801074:	c3                   	ret    

00801075 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	57                   	push   %edi
  801079:	56                   	push   %esi
  80107a:	53                   	push   %ebx
  80107b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80107e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801083:	8b 55 08             	mov    0x8(%ebp),%edx
  801086:	b8 0d 00 00 00       	mov    $0xd,%eax
  80108b:	89 cb                	mov    %ecx,%ebx
  80108d:	89 cf                	mov    %ecx,%edi
  80108f:	89 ce                	mov    %ecx,%esi
  801091:	cd 30                	int    $0x30
	if(check && ret > 0)
  801093:	85 c0                	test   %eax,%eax
  801095:	7f 08                	jg     80109f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801097:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109a:	5b                   	pop    %ebx
  80109b:	5e                   	pop    %esi
  80109c:	5f                   	pop    %edi
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80109f:	83 ec 0c             	sub    $0xc,%esp
  8010a2:	50                   	push   %eax
  8010a3:	6a 0d                	push   $0xd
  8010a5:	68 e8 30 80 00       	push   $0x8030e8
  8010aa:	6a 43                	push   $0x43
  8010ac:	68 05 31 80 00       	push   $0x803105
  8010b1:	e8 c8 f1 ff ff       	call   80027e <_panic>

008010b6 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	57                   	push   %edi
  8010ba:	56                   	push   %esi
  8010bb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c7:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010cc:	89 df                	mov    %ebx,%edi
  8010ce:	89 de                	mov    %ebx,%esi
  8010d0:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010d2:	5b                   	pop    %ebx
  8010d3:	5e                   	pop    %esi
  8010d4:	5f                   	pop    %edi
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    

008010d7 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	57                   	push   %edi
  8010db:	56                   	push   %esi
  8010dc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e5:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010ea:	89 cb                	mov    %ecx,%ebx
  8010ec:	89 cf                	mov    %ecx,%edi
  8010ee:	89 ce                	mov    %ecx,%esi
  8010f0:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010f2:	5b                   	pop    %ebx
  8010f3:	5e                   	pop    %esi
  8010f4:	5f                   	pop    %edi
  8010f5:	5d                   	pop    %ebp
  8010f6:	c3                   	ret    

008010f7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	57                   	push   %edi
  8010fb:	56                   	push   %esi
  8010fc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801102:	b8 10 00 00 00       	mov    $0x10,%eax
  801107:	89 d1                	mov    %edx,%ecx
  801109:	89 d3                	mov    %edx,%ebx
  80110b:	89 d7                	mov    %edx,%edi
  80110d:	89 d6                	mov    %edx,%esi
  80110f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801111:	5b                   	pop    %ebx
  801112:	5e                   	pop    %esi
  801113:	5f                   	pop    %edi
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    

00801116 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	57                   	push   %edi
  80111a:	56                   	push   %esi
  80111b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80111c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801121:	8b 55 08             	mov    0x8(%ebp),%edx
  801124:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801127:	b8 11 00 00 00       	mov    $0x11,%eax
  80112c:	89 df                	mov    %ebx,%edi
  80112e:	89 de                	mov    %ebx,%esi
  801130:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801132:	5b                   	pop    %ebx
  801133:	5e                   	pop    %esi
  801134:	5f                   	pop    %edi
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	57                   	push   %edi
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80113d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801142:	8b 55 08             	mov    0x8(%ebp),%edx
  801145:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801148:	b8 12 00 00 00       	mov    $0x12,%eax
  80114d:	89 df                	mov    %ebx,%edi
  80114f:	89 de                	mov    %ebx,%esi
  801151:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801153:	5b                   	pop    %ebx
  801154:	5e                   	pop    %esi
  801155:	5f                   	pop    %edi
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    

00801158 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	57                   	push   %edi
  80115c:	56                   	push   %esi
  80115d:	53                   	push   %ebx
  80115e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801161:	bb 00 00 00 00       	mov    $0x0,%ebx
  801166:	8b 55 08             	mov    0x8(%ebp),%edx
  801169:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116c:	b8 13 00 00 00       	mov    $0x13,%eax
  801171:	89 df                	mov    %ebx,%edi
  801173:	89 de                	mov    %ebx,%esi
  801175:	cd 30                	int    $0x30
	if(check && ret > 0)
  801177:	85 c0                	test   %eax,%eax
  801179:	7f 08                	jg     801183 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80117b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80117e:	5b                   	pop    %ebx
  80117f:	5e                   	pop    %esi
  801180:	5f                   	pop    %edi
  801181:	5d                   	pop    %ebp
  801182:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801183:	83 ec 0c             	sub    $0xc,%esp
  801186:	50                   	push   %eax
  801187:	6a 13                	push   $0x13
  801189:	68 e8 30 80 00       	push   $0x8030e8
  80118e:	6a 43                	push   $0x43
  801190:	68 05 31 80 00       	push   $0x803105
  801195:	e8 e4 f0 ff ff       	call   80027e <_panic>

0080119a <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	57                   	push   %edi
  80119e:	56                   	push   %esi
  80119f:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a8:	b8 14 00 00 00       	mov    $0x14,%eax
  8011ad:	89 cb                	mov    %ecx,%ebx
  8011af:	89 cf                	mov    %ecx,%edi
  8011b1:	89 ce                	mov    %ecx,%esi
  8011b3:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8011b5:	5b                   	pop    %ebx
  8011b6:	5e                   	pop    %esi
  8011b7:	5f                   	pop    %edi
  8011b8:	5d                   	pop    %ebp
  8011b9:	c3                   	ret    

008011ba <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	53                   	push   %ebx
  8011be:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8011c1:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011c8:	f6 c5 04             	test   $0x4,%ch
  8011cb:	75 45                	jne    801212 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8011cd:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011d4:	83 e1 07             	and    $0x7,%ecx
  8011d7:	83 f9 07             	cmp    $0x7,%ecx
  8011da:	74 6f                	je     80124b <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8011dc:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011e3:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8011e9:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8011ef:	0f 84 b6 00 00 00    	je     8012ab <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8011f5:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011fc:	83 e1 05             	and    $0x5,%ecx
  8011ff:	83 f9 05             	cmp    $0x5,%ecx
  801202:	0f 84 d7 00 00 00    	je     8012df <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801208:	b8 00 00 00 00       	mov    $0x0,%eax
  80120d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801210:	c9                   	leave  
  801211:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801212:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801219:	c1 e2 0c             	shl    $0xc,%edx
  80121c:	83 ec 0c             	sub    $0xc,%esp
  80121f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801225:	51                   	push   %ecx
  801226:	52                   	push   %edx
  801227:	50                   	push   %eax
  801228:	52                   	push   %edx
  801229:	6a 00                	push   $0x0
  80122b:	e8 d8 fc ff ff       	call   800f08 <sys_page_map>
		if(r < 0)
  801230:	83 c4 20             	add    $0x20,%esp
  801233:	85 c0                	test   %eax,%eax
  801235:	79 d1                	jns    801208 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801237:	83 ec 04             	sub    $0x4,%esp
  80123a:	68 13 31 80 00       	push   $0x803113
  80123f:	6a 54                	push   $0x54
  801241:	68 29 31 80 00       	push   $0x803129
  801246:	e8 33 f0 ff ff       	call   80027e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80124b:	89 d3                	mov    %edx,%ebx
  80124d:	c1 e3 0c             	shl    $0xc,%ebx
  801250:	83 ec 0c             	sub    $0xc,%esp
  801253:	68 05 08 00 00       	push   $0x805
  801258:	53                   	push   %ebx
  801259:	50                   	push   %eax
  80125a:	53                   	push   %ebx
  80125b:	6a 00                	push   $0x0
  80125d:	e8 a6 fc ff ff       	call   800f08 <sys_page_map>
		if(r < 0)
  801262:	83 c4 20             	add    $0x20,%esp
  801265:	85 c0                	test   %eax,%eax
  801267:	78 2e                	js     801297 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	68 05 08 00 00       	push   $0x805
  801271:	53                   	push   %ebx
  801272:	6a 00                	push   $0x0
  801274:	53                   	push   %ebx
  801275:	6a 00                	push   $0x0
  801277:	e8 8c fc ff ff       	call   800f08 <sys_page_map>
		if(r < 0)
  80127c:	83 c4 20             	add    $0x20,%esp
  80127f:	85 c0                	test   %eax,%eax
  801281:	79 85                	jns    801208 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801283:	83 ec 04             	sub    $0x4,%esp
  801286:	68 13 31 80 00       	push   $0x803113
  80128b:	6a 5f                	push   $0x5f
  80128d:	68 29 31 80 00       	push   $0x803129
  801292:	e8 e7 ef ff ff       	call   80027e <_panic>
			panic("sys_page_map() panic\n");
  801297:	83 ec 04             	sub    $0x4,%esp
  80129a:	68 13 31 80 00       	push   $0x803113
  80129f:	6a 5b                	push   $0x5b
  8012a1:	68 29 31 80 00       	push   $0x803129
  8012a6:	e8 d3 ef ff ff       	call   80027e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012ab:	c1 e2 0c             	shl    $0xc,%edx
  8012ae:	83 ec 0c             	sub    $0xc,%esp
  8012b1:	68 05 08 00 00       	push   $0x805
  8012b6:	52                   	push   %edx
  8012b7:	50                   	push   %eax
  8012b8:	52                   	push   %edx
  8012b9:	6a 00                	push   $0x0
  8012bb:	e8 48 fc ff ff       	call   800f08 <sys_page_map>
		if(r < 0)
  8012c0:	83 c4 20             	add    $0x20,%esp
  8012c3:	85 c0                	test   %eax,%eax
  8012c5:	0f 89 3d ff ff ff    	jns    801208 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012cb:	83 ec 04             	sub    $0x4,%esp
  8012ce:	68 13 31 80 00       	push   $0x803113
  8012d3:	6a 66                	push   $0x66
  8012d5:	68 29 31 80 00       	push   $0x803129
  8012da:	e8 9f ef ff ff       	call   80027e <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012df:	c1 e2 0c             	shl    $0xc,%edx
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	6a 05                	push   $0x5
  8012e7:	52                   	push   %edx
  8012e8:	50                   	push   %eax
  8012e9:	52                   	push   %edx
  8012ea:	6a 00                	push   $0x0
  8012ec:	e8 17 fc ff ff       	call   800f08 <sys_page_map>
		if(r < 0)
  8012f1:	83 c4 20             	add    $0x20,%esp
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	0f 89 0c ff ff ff    	jns    801208 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012fc:	83 ec 04             	sub    $0x4,%esp
  8012ff:	68 13 31 80 00       	push   $0x803113
  801304:	6a 6d                	push   $0x6d
  801306:	68 29 31 80 00       	push   $0x803129
  80130b:	e8 6e ef ff ff       	call   80027e <_panic>

00801310 <pgfault>:
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	53                   	push   %ebx
  801314:	83 ec 04             	sub    $0x4,%esp
  801317:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80131a:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80131c:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801320:	0f 84 99 00 00 00    	je     8013bf <pgfault+0xaf>
  801326:	89 c2                	mov    %eax,%edx
  801328:	c1 ea 16             	shr    $0x16,%edx
  80132b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801332:	f6 c2 01             	test   $0x1,%dl
  801335:	0f 84 84 00 00 00    	je     8013bf <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80133b:	89 c2                	mov    %eax,%edx
  80133d:	c1 ea 0c             	shr    $0xc,%edx
  801340:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801347:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80134d:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801353:	75 6a                	jne    8013bf <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801355:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80135a:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80135c:	83 ec 04             	sub    $0x4,%esp
  80135f:	6a 07                	push   $0x7
  801361:	68 00 f0 7f 00       	push   $0x7ff000
  801366:	6a 00                	push   $0x0
  801368:	e8 58 fb ff ff       	call   800ec5 <sys_page_alloc>
	if(ret < 0)
  80136d:	83 c4 10             	add    $0x10,%esp
  801370:	85 c0                	test   %eax,%eax
  801372:	78 5f                	js     8013d3 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801374:	83 ec 04             	sub    $0x4,%esp
  801377:	68 00 10 00 00       	push   $0x1000
  80137c:	53                   	push   %ebx
  80137d:	68 00 f0 7f 00       	push   $0x7ff000
  801382:	e8 3c f9 ff ff       	call   800cc3 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801387:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80138e:	53                   	push   %ebx
  80138f:	6a 00                	push   $0x0
  801391:	68 00 f0 7f 00       	push   $0x7ff000
  801396:	6a 00                	push   $0x0
  801398:	e8 6b fb ff ff       	call   800f08 <sys_page_map>
	if(ret < 0)
  80139d:	83 c4 20             	add    $0x20,%esp
  8013a0:	85 c0                	test   %eax,%eax
  8013a2:	78 43                	js     8013e7 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8013a4:	83 ec 08             	sub    $0x8,%esp
  8013a7:	68 00 f0 7f 00       	push   $0x7ff000
  8013ac:	6a 00                	push   $0x0
  8013ae:	e8 97 fb ff ff       	call   800f4a <sys_page_unmap>
	if(ret < 0)
  8013b3:	83 c4 10             	add    $0x10,%esp
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	78 41                	js     8013fb <pgfault+0xeb>
}
  8013ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    
		panic("panic at pgfault()\n");
  8013bf:	83 ec 04             	sub    $0x4,%esp
  8013c2:	68 34 31 80 00       	push   $0x803134
  8013c7:	6a 26                	push   $0x26
  8013c9:	68 29 31 80 00       	push   $0x803129
  8013ce:	e8 ab ee ff ff       	call   80027e <_panic>
		panic("panic in sys_page_alloc()\n");
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	68 48 31 80 00       	push   $0x803148
  8013db:	6a 31                	push   $0x31
  8013dd:	68 29 31 80 00       	push   $0x803129
  8013e2:	e8 97 ee ff ff       	call   80027e <_panic>
		panic("panic in sys_page_map()\n");
  8013e7:	83 ec 04             	sub    $0x4,%esp
  8013ea:	68 63 31 80 00       	push   $0x803163
  8013ef:	6a 36                	push   $0x36
  8013f1:	68 29 31 80 00       	push   $0x803129
  8013f6:	e8 83 ee ff ff       	call   80027e <_panic>
		panic("panic in sys_page_unmap()\n");
  8013fb:	83 ec 04             	sub    $0x4,%esp
  8013fe:	68 7c 31 80 00       	push   $0x80317c
  801403:	6a 39                	push   $0x39
  801405:	68 29 31 80 00       	push   $0x803129
  80140a:	e8 6f ee ff ff       	call   80027e <_panic>

0080140f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	57                   	push   %edi
  801413:	56                   	push   %esi
  801414:	53                   	push   %ebx
  801415:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801418:	68 10 13 80 00       	push   $0x801310
  80141d:	e8 16 15 00 00       	call   802938 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801422:	b8 07 00 00 00       	mov    $0x7,%eax
  801427:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801429:	83 c4 10             	add    $0x10,%esp
  80142c:	85 c0                	test   %eax,%eax
  80142e:	78 2a                	js     80145a <fork+0x4b>
  801430:	89 c6                	mov    %eax,%esi
  801432:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801434:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801439:	75 4b                	jne    801486 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  80143b:	e8 47 fa ff ff       	call   800e87 <sys_getenvid>
  801440:	25 ff 03 00 00       	and    $0x3ff,%eax
  801445:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80144b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801450:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801455:	e9 90 00 00 00       	jmp    8014ea <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  80145a:	83 ec 04             	sub    $0x4,%esp
  80145d:	68 98 31 80 00       	push   $0x803198
  801462:	68 8c 00 00 00       	push   $0x8c
  801467:	68 29 31 80 00       	push   $0x803129
  80146c:	e8 0d ee ff ff       	call   80027e <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801471:	89 f8                	mov    %edi,%eax
  801473:	e8 42 fd ff ff       	call   8011ba <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801478:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80147e:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801484:	74 26                	je     8014ac <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801486:	89 d8                	mov    %ebx,%eax
  801488:	c1 e8 16             	shr    $0x16,%eax
  80148b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801492:	a8 01                	test   $0x1,%al
  801494:	74 e2                	je     801478 <fork+0x69>
  801496:	89 da                	mov    %ebx,%edx
  801498:	c1 ea 0c             	shr    $0xc,%edx
  80149b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014a2:	83 e0 05             	and    $0x5,%eax
  8014a5:	83 f8 05             	cmp    $0x5,%eax
  8014a8:	75 ce                	jne    801478 <fork+0x69>
  8014aa:	eb c5                	jmp    801471 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014ac:	83 ec 04             	sub    $0x4,%esp
  8014af:	6a 07                	push   $0x7
  8014b1:	68 00 f0 bf ee       	push   $0xeebff000
  8014b6:	56                   	push   %esi
  8014b7:	e8 09 fa ff ff       	call   800ec5 <sys_page_alloc>
	if(ret < 0)
  8014bc:	83 c4 10             	add    $0x10,%esp
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	78 31                	js     8014f4 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014c3:	83 ec 08             	sub    $0x8,%esp
  8014c6:	68 a7 29 80 00       	push   $0x8029a7
  8014cb:	56                   	push   %esi
  8014cc:	e8 3f fb ff ff       	call   801010 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014d1:	83 c4 10             	add    $0x10,%esp
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	78 33                	js     80150b <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014d8:	83 ec 08             	sub    $0x8,%esp
  8014db:	6a 02                	push   $0x2
  8014dd:	56                   	push   %esi
  8014de:	e8 a9 fa ff ff       	call   800f8c <sys_env_set_status>
	if(ret < 0)
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	78 38                	js     801522 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8014ea:	89 f0                	mov    %esi,%eax
  8014ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014ef:	5b                   	pop    %ebx
  8014f0:	5e                   	pop    %esi
  8014f1:	5f                   	pop    %edi
  8014f2:	5d                   	pop    %ebp
  8014f3:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014f4:	83 ec 04             	sub    $0x4,%esp
  8014f7:	68 48 31 80 00       	push   $0x803148
  8014fc:	68 98 00 00 00       	push   $0x98
  801501:	68 29 31 80 00       	push   $0x803129
  801506:	e8 73 ed ff ff       	call   80027e <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80150b:	83 ec 04             	sub    $0x4,%esp
  80150e:	68 bc 31 80 00       	push   $0x8031bc
  801513:	68 9b 00 00 00       	push   $0x9b
  801518:	68 29 31 80 00       	push   $0x803129
  80151d:	e8 5c ed ff ff       	call   80027e <_panic>
		panic("panic in sys_env_set_status()\n");
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	68 e4 31 80 00       	push   $0x8031e4
  80152a:	68 9e 00 00 00       	push   $0x9e
  80152f:	68 29 31 80 00       	push   $0x803129
  801534:	e8 45 ed ff ff       	call   80027e <_panic>

00801539 <sfork>:

// Challenge!
int
sfork(void)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	57                   	push   %edi
  80153d:	56                   	push   %esi
  80153e:	53                   	push   %ebx
  80153f:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801542:	68 10 13 80 00       	push   $0x801310
  801547:	e8 ec 13 00 00       	call   802938 <set_pgfault_handler>
  80154c:	b8 07 00 00 00       	mov    $0x7,%eax
  801551:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801553:	83 c4 10             	add    $0x10,%esp
  801556:	85 c0                	test   %eax,%eax
  801558:	78 2a                	js     801584 <sfork+0x4b>
  80155a:	89 c7                	mov    %eax,%edi
  80155c:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80155e:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801563:	75 58                	jne    8015bd <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  801565:	e8 1d f9 ff ff       	call   800e87 <sys_getenvid>
  80156a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80156f:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801575:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80157a:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80157f:	e9 d4 00 00 00       	jmp    801658 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  801584:	83 ec 04             	sub    $0x4,%esp
  801587:	68 98 31 80 00       	push   $0x803198
  80158c:	68 af 00 00 00       	push   $0xaf
  801591:	68 29 31 80 00       	push   $0x803129
  801596:	e8 e3 ec ff ff       	call   80027e <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80159b:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8015a0:	89 f0                	mov    %esi,%eax
  8015a2:	e8 13 fc ff ff       	call   8011ba <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015ad:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8015b3:	77 65                	ja     80161a <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  8015b5:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8015bb:	74 de                	je     80159b <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8015bd:	89 d8                	mov    %ebx,%eax
  8015bf:	c1 e8 16             	shr    $0x16,%eax
  8015c2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015c9:	a8 01                	test   $0x1,%al
  8015cb:	74 da                	je     8015a7 <sfork+0x6e>
  8015cd:	89 da                	mov    %ebx,%edx
  8015cf:	c1 ea 0c             	shr    $0xc,%edx
  8015d2:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015d9:	83 e0 05             	and    $0x5,%eax
  8015dc:	83 f8 05             	cmp    $0x5,%eax
  8015df:	75 c6                	jne    8015a7 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015e1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8015e8:	c1 e2 0c             	shl    $0xc,%edx
  8015eb:	83 ec 0c             	sub    $0xc,%esp
  8015ee:	83 e0 07             	and    $0x7,%eax
  8015f1:	50                   	push   %eax
  8015f2:	52                   	push   %edx
  8015f3:	56                   	push   %esi
  8015f4:	52                   	push   %edx
  8015f5:	6a 00                	push   $0x0
  8015f7:	e8 0c f9 ff ff       	call   800f08 <sys_page_map>
  8015fc:	83 c4 20             	add    $0x20,%esp
  8015ff:	85 c0                	test   %eax,%eax
  801601:	74 a4                	je     8015a7 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801603:	83 ec 04             	sub    $0x4,%esp
  801606:	68 13 31 80 00       	push   $0x803113
  80160b:	68 ba 00 00 00       	push   $0xba
  801610:	68 29 31 80 00       	push   $0x803129
  801615:	e8 64 ec ff ff       	call   80027e <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80161a:	83 ec 04             	sub    $0x4,%esp
  80161d:	6a 07                	push   $0x7
  80161f:	68 00 f0 bf ee       	push   $0xeebff000
  801624:	57                   	push   %edi
  801625:	e8 9b f8 ff ff       	call   800ec5 <sys_page_alloc>
	if(ret < 0)
  80162a:	83 c4 10             	add    $0x10,%esp
  80162d:	85 c0                	test   %eax,%eax
  80162f:	78 31                	js     801662 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801631:	83 ec 08             	sub    $0x8,%esp
  801634:	68 a7 29 80 00       	push   $0x8029a7
  801639:	57                   	push   %edi
  80163a:	e8 d1 f9 ff ff       	call   801010 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80163f:	83 c4 10             	add    $0x10,%esp
  801642:	85 c0                	test   %eax,%eax
  801644:	78 33                	js     801679 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801646:	83 ec 08             	sub    $0x8,%esp
  801649:	6a 02                	push   $0x2
  80164b:	57                   	push   %edi
  80164c:	e8 3b f9 ff ff       	call   800f8c <sys_env_set_status>
	if(ret < 0)
  801651:	83 c4 10             	add    $0x10,%esp
  801654:	85 c0                	test   %eax,%eax
  801656:	78 38                	js     801690 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801658:	89 f8                	mov    %edi,%eax
  80165a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80165d:	5b                   	pop    %ebx
  80165e:	5e                   	pop    %esi
  80165f:	5f                   	pop    %edi
  801660:	5d                   	pop    %ebp
  801661:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801662:	83 ec 04             	sub    $0x4,%esp
  801665:	68 48 31 80 00       	push   $0x803148
  80166a:	68 c0 00 00 00       	push   $0xc0
  80166f:	68 29 31 80 00       	push   $0x803129
  801674:	e8 05 ec ff ff       	call   80027e <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801679:	83 ec 04             	sub    $0x4,%esp
  80167c:	68 bc 31 80 00       	push   $0x8031bc
  801681:	68 c3 00 00 00       	push   $0xc3
  801686:	68 29 31 80 00       	push   $0x803129
  80168b:	e8 ee eb ff ff       	call   80027e <_panic>
		panic("panic in sys_env_set_status()\n");
  801690:	83 ec 04             	sub    $0x4,%esp
  801693:	68 e4 31 80 00       	push   $0x8031e4
  801698:	68 c6 00 00 00       	push   $0xc6
  80169d:	68 29 31 80 00       	push   $0x803129
  8016a2:	e8 d7 eb ff ff       	call   80027e <_panic>

008016a7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	56                   	push   %esi
  8016ab:	53                   	push   %ebx
  8016ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8016af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8016b5:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8016b7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8016bc:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8016bf:	83 ec 0c             	sub    $0xc,%esp
  8016c2:	50                   	push   %eax
  8016c3:	e8 ad f9 ff ff       	call   801075 <sys_ipc_recv>
	if(ret < 0){
  8016c8:	83 c4 10             	add    $0x10,%esp
  8016cb:	85 c0                	test   %eax,%eax
  8016cd:	78 2b                	js     8016fa <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8016cf:	85 f6                	test   %esi,%esi
  8016d1:	74 0a                	je     8016dd <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8016d3:	a1 08 50 80 00       	mov    0x805008,%eax
  8016d8:	8b 40 78             	mov    0x78(%eax),%eax
  8016db:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8016dd:	85 db                	test   %ebx,%ebx
  8016df:	74 0a                	je     8016eb <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8016e1:	a1 08 50 80 00       	mov    0x805008,%eax
  8016e6:	8b 40 7c             	mov    0x7c(%eax),%eax
  8016e9:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8016eb:	a1 08 50 80 00       	mov    0x805008,%eax
  8016f0:	8b 40 74             	mov    0x74(%eax),%eax
}
  8016f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f6:	5b                   	pop    %ebx
  8016f7:	5e                   	pop    %esi
  8016f8:	5d                   	pop    %ebp
  8016f9:	c3                   	ret    
		if(from_env_store)
  8016fa:	85 f6                	test   %esi,%esi
  8016fc:	74 06                	je     801704 <ipc_recv+0x5d>
			*from_env_store = 0;
  8016fe:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801704:	85 db                	test   %ebx,%ebx
  801706:	74 eb                	je     8016f3 <ipc_recv+0x4c>
			*perm_store = 0;
  801708:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80170e:	eb e3                	jmp    8016f3 <ipc_recv+0x4c>

00801710 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	57                   	push   %edi
  801714:	56                   	push   %esi
  801715:	53                   	push   %ebx
  801716:	83 ec 0c             	sub    $0xc,%esp
  801719:	8b 7d 08             	mov    0x8(%ebp),%edi
  80171c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80171f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801722:	85 db                	test   %ebx,%ebx
  801724:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801729:	0f 44 d8             	cmove  %eax,%ebx
  80172c:	eb 05                	jmp    801733 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80172e:	e8 73 f7 ff ff       	call   800ea6 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801733:	ff 75 14             	pushl  0x14(%ebp)
  801736:	53                   	push   %ebx
  801737:	56                   	push   %esi
  801738:	57                   	push   %edi
  801739:	e8 14 f9 ff ff       	call   801052 <sys_ipc_try_send>
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	85 c0                	test   %eax,%eax
  801743:	74 1b                	je     801760 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801745:	79 e7                	jns    80172e <ipc_send+0x1e>
  801747:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80174a:	74 e2                	je     80172e <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80174c:	83 ec 04             	sub    $0x4,%esp
  80174f:	68 03 32 80 00       	push   $0x803203
  801754:	6a 46                	push   $0x46
  801756:	68 18 32 80 00       	push   $0x803218
  80175b:	e8 1e eb ff ff       	call   80027e <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801760:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801763:	5b                   	pop    %ebx
  801764:	5e                   	pop    %esi
  801765:	5f                   	pop    %edi
  801766:	5d                   	pop    %ebp
  801767:	c3                   	ret    

00801768 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80176e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801773:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  801779:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80177f:	8b 52 50             	mov    0x50(%edx),%edx
  801782:	39 ca                	cmp    %ecx,%edx
  801784:	74 11                	je     801797 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801786:	83 c0 01             	add    $0x1,%eax
  801789:	3d 00 04 00 00       	cmp    $0x400,%eax
  80178e:	75 e3                	jne    801773 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801790:	b8 00 00 00 00       	mov    $0x0,%eax
  801795:	eb 0e                	jmp    8017a5 <ipc_find_env+0x3d>
			return envs[i].env_id;
  801797:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80179d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8017a2:	8b 40 48             	mov    0x48(%eax),%eax
}
  8017a5:	5d                   	pop    %ebp
  8017a6:	c3                   	ret    

008017a7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	05 00 00 00 30       	add    $0x30000000,%eax
  8017b2:	c1 e8 0c             	shr    $0xc,%eax
}
  8017b5:	5d                   	pop    %ebp
  8017b6:	c3                   	ret    

008017b7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8017c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017c7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017cc:	5d                   	pop    %ebp
  8017cd:	c3                   	ret    

008017ce <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017d6:	89 c2                	mov    %eax,%edx
  8017d8:	c1 ea 16             	shr    $0x16,%edx
  8017db:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017e2:	f6 c2 01             	test   $0x1,%dl
  8017e5:	74 2d                	je     801814 <fd_alloc+0x46>
  8017e7:	89 c2                	mov    %eax,%edx
  8017e9:	c1 ea 0c             	shr    $0xc,%edx
  8017ec:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017f3:	f6 c2 01             	test   $0x1,%dl
  8017f6:	74 1c                	je     801814 <fd_alloc+0x46>
  8017f8:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8017fd:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801802:	75 d2                	jne    8017d6 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80180d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801812:	eb 0a                	jmp    80181e <fd_alloc+0x50>
			*fd_store = fd;
  801814:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801817:	89 01                	mov    %eax,(%ecx)
			return 0;
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181e:	5d                   	pop    %ebp
  80181f:	c3                   	ret    

00801820 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801826:	83 f8 1f             	cmp    $0x1f,%eax
  801829:	77 30                	ja     80185b <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80182b:	c1 e0 0c             	shl    $0xc,%eax
  80182e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801833:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801839:	f6 c2 01             	test   $0x1,%dl
  80183c:	74 24                	je     801862 <fd_lookup+0x42>
  80183e:	89 c2                	mov    %eax,%edx
  801840:	c1 ea 0c             	shr    $0xc,%edx
  801843:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80184a:	f6 c2 01             	test   $0x1,%dl
  80184d:	74 1a                	je     801869 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80184f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801852:	89 02                	mov    %eax,(%edx)
	return 0;
  801854:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801859:	5d                   	pop    %ebp
  80185a:	c3                   	ret    
		return -E_INVAL;
  80185b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801860:	eb f7                	jmp    801859 <fd_lookup+0x39>
		return -E_INVAL;
  801862:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801867:	eb f0                	jmp    801859 <fd_lookup+0x39>
  801869:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80186e:	eb e9                	jmp    801859 <fd_lookup+0x39>

00801870 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 08             	sub    $0x8,%esp
  801876:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801879:	ba 00 00 00 00       	mov    $0x0,%edx
  80187e:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801883:	39 08                	cmp    %ecx,(%eax)
  801885:	74 38                	je     8018bf <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801887:	83 c2 01             	add    $0x1,%edx
  80188a:	8b 04 95 a0 32 80 00 	mov    0x8032a0(,%edx,4),%eax
  801891:	85 c0                	test   %eax,%eax
  801893:	75 ee                	jne    801883 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801895:	a1 08 50 80 00       	mov    0x805008,%eax
  80189a:	8b 40 48             	mov    0x48(%eax),%eax
  80189d:	83 ec 04             	sub    $0x4,%esp
  8018a0:	51                   	push   %ecx
  8018a1:	50                   	push   %eax
  8018a2:	68 24 32 80 00       	push   $0x803224
  8018a7:	e8 c8 ea ff ff       	call   800374 <cprintf>
	*dev = 0;
  8018ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8018b5:	83 c4 10             	add    $0x10,%esp
  8018b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    
			*dev = devtab[i];
  8018bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018c2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c9:	eb f2                	jmp    8018bd <dev_lookup+0x4d>

008018cb <fd_close>:
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	57                   	push   %edi
  8018cf:	56                   	push   %esi
  8018d0:	53                   	push   %ebx
  8018d1:	83 ec 24             	sub    $0x24,%esp
  8018d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8018d7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018dd:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018de:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018e4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018e7:	50                   	push   %eax
  8018e8:	e8 33 ff ff ff       	call   801820 <fd_lookup>
  8018ed:	89 c3                	mov    %eax,%ebx
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	78 05                	js     8018fb <fd_close+0x30>
	    || fd != fd2)
  8018f6:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8018f9:	74 16                	je     801911 <fd_close+0x46>
		return (must_exist ? r : 0);
  8018fb:	89 f8                	mov    %edi,%eax
  8018fd:	84 c0                	test   %al,%al
  8018ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801904:	0f 44 d8             	cmove  %eax,%ebx
}
  801907:	89 d8                	mov    %ebx,%eax
  801909:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80190c:	5b                   	pop    %ebx
  80190d:	5e                   	pop    %esi
  80190e:	5f                   	pop    %edi
  80190f:	5d                   	pop    %ebp
  801910:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801911:	83 ec 08             	sub    $0x8,%esp
  801914:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801917:	50                   	push   %eax
  801918:	ff 36                	pushl  (%esi)
  80191a:	e8 51 ff ff ff       	call   801870 <dev_lookup>
  80191f:	89 c3                	mov    %eax,%ebx
  801921:	83 c4 10             	add    $0x10,%esp
  801924:	85 c0                	test   %eax,%eax
  801926:	78 1a                	js     801942 <fd_close+0x77>
		if (dev->dev_close)
  801928:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80192b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80192e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801933:	85 c0                	test   %eax,%eax
  801935:	74 0b                	je     801942 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801937:	83 ec 0c             	sub    $0xc,%esp
  80193a:	56                   	push   %esi
  80193b:	ff d0                	call   *%eax
  80193d:	89 c3                	mov    %eax,%ebx
  80193f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801942:	83 ec 08             	sub    $0x8,%esp
  801945:	56                   	push   %esi
  801946:	6a 00                	push   $0x0
  801948:	e8 fd f5 ff ff       	call   800f4a <sys_page_unmap>
	return r;
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	eb b5                	jmp    801907 <fd_close+0x3c>

00801952 <close>:

int
close(int fdnum)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801958:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195b:	50                   	push   %eax
  80195c:	ff 75 08             	pushl  0x8(%ebp)
  80195f:	e8 bc fe ff ff       	call   801820 <fd_lookup>
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	85 c0                	test   %eax,%eax
  801969:	79 02                	jns    80196d <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    
		return fd_close(fd, 1);
  80196d:	83 ec 08             	sub    $0x8,%esp
  801970:	6a 01                	push   $0x1
  801972:	ff 75 f4             	pushl  -0xc(%ebp)
  801975:	e8 51 ff ff ff       	call   8018cb <fd_close>
  80197a:	83 c4 10             	add    $0x10,%esp
  80197d:	eb ec                	jmp    80196b <close+0x19>

0080197f <close_all>:

void
close_all(void)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	53                   	push   %ebx
  801983:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801986:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80198b:	83 ec 0c             	sub    $0xc,%esp
  80198e:	53                   	push   %ebx
  80198f:	e8 be ff ff ff       	call   801952 <close>
	for (i = 0; i < MAXFD; i++)
  801994:	83 c3 01             	add    $0x1,%ebx
  801997:	83 c4 10             	add    $0x10,%esp
  80199a:	83 fb 20             	cmp    $0x20,%ebx
  80199d:	75 ec                	jne    80198b <close_all+0xc>
}
  80199f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	57                   	push   %edi
  8019a8:	56                   	push   %esi
  8019a9:	53                   	push   %ebx
  8019aa:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019ad:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019b0:	50                   	push   %eax
  8019b1:	ff 75 08             	pushl  0x8(%ebp)
  8019b4:	e8 67 fe ff ff       	call   801820 <fd_lookup>
  8019b9:	89 c3                	mov    %eax,%ebx
  8019bb:	83 c4 10             	add    $0x10,%esp
  8019be:	85 c0                	test   %eax,%eax
  8019c0:	0f 88 81 00 00 00    	js     801a47 <dup+0xa3>
		return r;
	close(newfdnum);
  8019c6:	83 ec 0c             	sub    $0xc,%esp
  8019c9:	ff 75 0c             	pushl  0xc(%ebp)
  8019cc:	e8 81 ff ff ff       	call   801952 <close>

	newfd = INDEX2FD(newfdnum);
  8019d1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019d4:	c1 e6 0c             	shl    $0xc,%esi
  8019d7:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8019dd:	83 c4 04             	add    $0x4,%esp
  8019e0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019e3:	e8 cf fd ff ff       	call   8017b7 <fd2data>
  8019e8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019ea:	89 34 24             	mov    %esi,(%esp)
  8019ed:	e8 c5 fd ff ff       	call   8017b7 <fd2data>
  8019f2:	83 c4 10             	add    $0x10,%esp
  8019f5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019f7:	89 d8                	mov    %ebx,%eax
  8019f9:	c1 e8 16             	shr    $0x16,%eax
  8019fc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a03:	a8 01                	test   $0x1,%al
  801a05:	74 11                	je     801a18 <dup+0x74>
  801a07:	89 d8                	mov    %ebx,%eax
  801a09:	c1 e8 0c             	shr    $0xc,%eax
  801a0c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a13:	f6 c2 01             	test   $0x1,%dl
  801a16:	75 39                	jne    801a51 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a18:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a1b:	89 d0                	mov    %edx,%eax
  801a1d:	c1 e8 0c             	shr    $0xc,%eax
  801a20:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a27:	83 ec 0c             	sub    $0xc,%esp
  801a2a:	25 07 0e 00 00       	and    $0xe07,%eax
  801a2f:	50                   	push   %eax
  801a30:	56                   	push   %esi
  801a31:	6a 00                	push   $0x0
  801a33:	52                   	push   %edx
  801a34:	6a 00                	push   $0x0
  801a36:	e8 cd f4 ff ff       	call   800f08 <sys_page_map>
  801a3b:	89 c3                	mov    %eax,%ebx
  801a3d:	83 c4 20             	add    $0x20,%esp
  801a40:	85 c0                	test   %eax,%eax
  801a42:	78 31                	js     801a75 <dup+0xd1>
		goto err;

	return newfdnum;
  801a44:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a47:	89 d8                	mov    %ebx,%eax
  801a49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a4c:	5b                   	pop    %ebx
  801a4d:	5e                   	pop    %esi
  801a4e:	5f                   	pop    %edi
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a51:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a58:	83 ec 0c             	sub    $0xc,%esp
  801a5b:	25 07 0e 00 00       	and    $0xe07,%eax
  801a60:	50                   	push   %eax
  801a61:	57                   	push   %edi
  801a62:	6a 00                	push   $0x0
  801a64:	53                   	push   %ebx
  801a65:	6a 00                	push   $0x0
  801a67:	e8 9c f4 ff ff       	call   800f08 <sys_page_map>
  801a6c:	89 c3                	mov    %eax,%ebx
  801a6e:	83 c4 20             	add    $0x20,%esp
  801a71:	85 c0                	test   %eax,%eax
  801a73:	79 a3                	jns    801a18 <dup+0x74>
	sys_page_unmap(0, newfd);
  801a75:	83 ec 08             	sub    $0x8,%esp
  801a78:	56                   	push   %esi
  801a79:	6a 00                	push   $0x0
  801a7b:	e8 ca f4 ff ff       	call   800f4a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a80:	83 c4 08             	add    $0x8,%esp
  801a83:	57                   	push   %edi
  801a84:	6a 00                	push   $0x0
  801a86:	e8 bf f4 ff ff       	call   800f4a <sys_page_unmap>
	return r;
  801a8b:	83 c4 10             	add    $0x10,%esp
  801a8e:	eb b7                	jmp    801a47 <dup+0xa3>

00801a90 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	53                   	push   %ebx
  801a94:	83 ec 1c             	sub    $0x1c,%esp
  801a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a9d:	50                   	push   %eax
  801a9e:	53                   	push   %ebx
  801a9f:	e8 7c fd ff ff       	call   801820 <fd_lookup>
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	78 3f                	js     801aea <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aab:	83 ec 08             	sub    $0x8,%esp
  801aae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab1:	50                   	push   %eax
  801ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab5:	ff 30                	pushl  (%eax)
  801ab7:	e8 b4 fd ff ff       	call   801870 <dev_lookup>
  801abc:	83 c4 10             	add    $0x10,%esp
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	78 27                	js     801aea <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ac3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ac6:	8b 42 08             	mov    0x8(%edx),%eax
  801ac9:	83 e0 03             	and    $0x3,%eax
  801acc:	83 f8 01             	cmp    $0x1,%eax
  801acf:	74 1e                	je     801aef <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad4:	8b 40 08             	mov    0x8(%eax),%eax
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	74 35                	je     801b10 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801adb:	83 ec 04             	sub    $0x4,%esp
  801ade:	ff 75 10             	pushl  0x10(%ebp)
  801ae1:	ff 75 0c             	pushl  0xc(%ebp)
  801ae4:	52                   	push   %edx
  801ae5:	ff d0                	call   *%eax
  801ae7:	83 c4 10             	add    $0x10,%esp
}
  801aea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801aef:	a1 08 50 80 00       	mov    0x805008,%eax
  801af4:	8b 40 48             	mov    0x48(%eax),%eax
  801af7:	83 ec 04             	sub    $0x4,%esp
  801afa:	53                   	push   %ebx
  801afb:	50                   	push   %eax
  801afc:	68 65 32 80 00       	push   $0x803265
  801b01:	e8 6e e8 ff ff       	call   800374 <cprintf>
		return -E_INVAL;
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b0e:	eb da                	jmp    801aea <read+0x5a>
		return -E_NOT_SUPP;
  801b10:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b15:	eb d3                	jmp    801aea <read+0x5a>

00801b17 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
  801b1a:	57                   	push   %edi
  801b1b:	56                   	push   %esi
  801b1c:	53                   	push   %ebx
  801b1d:	83 ec 0c             	sub    $0xc,%esp
  801b20:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b23:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b26:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b2b:	39 f3                	cmp    %esi,%ebx
  801b2d:	73 23                	jae    801b52 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b2f:	83 ec 04             	sub    $0x4,%esp
  801b32:	89 f0                	mov    %esi,%eax
  801b34:	29 d8                	sub    %ebx,%eax
  801b36:	50                   	push   %eax
  801b37:	89 d8                	mov    %ebx,%eax
  801b39:	03 45 0c             	add    0xc(%ebp),%eax
  801b3c:	50                   	push   %eax
  801b3d:	57                   	push   %edi
  801b3e:	e8 4d ff ff ff       	call   801a90 <read>
		if (m < 0)
  801b43:	83 c4 10             	add    $0x10,%esp
  801b46:	85 c0                	test   %eax,%eax
  801b48:	78 06                	js     801b50 <readn+0x39>
			return m;
		if (m == 0)
  801b4a:	74 06                	je     801b52 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801b4c:	01 c3                	add    %eax,%ebx
  801b4e:	eb db                	jmp    801b2b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b50:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b52:	89 d8                	mov    %ebx,%eax
  801b54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b57:	5b                   	pop    %ebx
  801b58:	5e                   	pop    %esi
  801b59:	5f                   	pop    %edi
  801b5a:	5d                   	pop    %ebp
  801b5b:	c3                   	ret    

00801b5c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	53                   	push   %ebx
  801b60:	83 ec 1c             	sub    $0x1c,%esp
  801b63:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b66:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b69:	50                   	push   %eax
  801b6a:	53                   	push   %ebx
  801b6b:	e8 b0 fc ff ff       	call   801820 <fd_lookup>
  801b70:	83 c4 10             	add    $0x10,%esp
  801b73:	85 c0                	test   %eax,%eax
  801b75:	78 3a                	js     801bb1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b77:	83 ec 08             	sub    $0x8,%esp
  801b7a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b7d:	50                   	push   %eax
  801b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b81:	ff 30                	pushl  (%eax)
  801b83:	e8 e8 fc ff ff       	call   801870 <dev_lookup>
  801b88:	83 c4 10             	add    $0x10,%esp
  801b8b:	85 c0                	test   %eax,%eax
  801b8d:	78 22                	js     801bb1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b92:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b96:	74 1e                	je     801bb6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b9b:	8b 52 0c             	mov    0xc(%edx),%edx
  801b9e:	85 d2                	test   %edx,%edx
  801ba0:	74 35                	je     801bd7 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ba2:	83 ec 04             	sub    $0x4,%esp
  801ba5:	ff 75 10             	pushl  0x10(%ebp)
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	50                   	push   %eax
  801bac:	ff d2                	call   *%edx
  801bae:	83 c4 10             	add    $0x10,%esp
}
  801bb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801bb6:	a1 08 50 80 00       	mov    0x805008,%eax
  801bbb:	8b 40 48             	mov    0x48(%eax),%eax
  801bbe:	83 ec 04             	sub    $0x4,%esp
  801bc1:	53                   	push   %ebx
  801bc2:	50                   	push   %eax
  801bc3:	68 81 32 80 00       	push   $0x803281
  801bc8:	e8 a7 e7 ff ff       	call   800374 <cprintf>
		return -E_INVAL;
  801bcd:	83 c4 10             	add    $0x10,%esp
  801bd0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bd5:	eb da                	jmp    801bb1 <write+0x55>
		return -E_NOT_SUPP;
  801bd7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bdc:	eb d3                	jmp    801bb1 <write+0x55>

00801bde <seek>:

int
seek(int fdnum, off_t offset)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801be4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801be7:	50                   	push   %eax
  801be8:	ff 75 08             	pushl  0x8(%ebp)
  801beb:	e8 30 fc ff ff       	call   801820 <fd_lookup>
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	78 0e                	js     801c05 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801bf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfd:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	53                   	push   %ebx
  801c0b:	83 ec 1c             	sub    $0x1c,%esp
  801c0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c11:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c14:	50                   	push   %eax
  801c15:	53                   	push   %ebx
  801c16:	e8 05 fc ff ff       	call   801820 <fd_lookup>
  801c1b:	83 c4 10             	add    $0x10,%esp
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	78 37                	js     801c59 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c22:	83 ec 08             	sub    $0x8,%esp
  801c25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c28:	50                   	push   %eax
  801c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2c:	ff 30                	pushl  (%eax)
  801c2e:	e8 3d fc ff ff       	call   801870 <dev_lookup>
  801c33:	83 c4 10             	add    $0x10,%esp
  801c36:	85 c0                	test   %eax,%eax
  801c38:	78 1f                	js     801c59 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c41:	74 1b                	je     801c5e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c46:	8b 52 18             	mov    0x18(%edx),%edx
  801c49:	85 d2                	test   %edx,%edx
  801c4b:	74 32                	je     801c7f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c4d:	83 ec 08             	sub    $0x8,%esp
  801c50:	ff 75 0c             	pushl  0xc(%ebp)
  801c53:	50                   	push   %eax
  801c54:	ff d2                	call   *%edx
  801c56:	83 c4 10             	add    $0x10,%esp
}
  801c59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c5e:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c63:	8b 40 48             	mov    0x48(%eax),%eax
  801c66:	83 ec 04             	sub    $0x4,%esp
  801c69:	53                   	push   %ebx
  801c6a:	50                   	push   %eax
  801c6b:	68 44 32 80 00       	push   $0x803244
  801c70:	e8 ff e6 ff ff       	call   800374 <cprintf>
		return -E_INVAL;
  801c75:	83 c4 10             	add    $0x10,%esp
  801c78:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c7d:	eb da                	jmp    801c59 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c7f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c84:	eb d3                	jmp    801c59 <ftruncate+0x52>

00801c86 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	53                   	push   %ebx
  801c8a:	83 ec 1c             	sub    $0x1c,%esp
  801c8d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c90:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c93:	50                   	push   %eax
  801c94:	ff 75 08             	pushl  0x8(%ebp)
  801c97:	e8 84 fb ff ff       	call   801820 <fd_lookup>
  801c9c:	83 c4 10             	add    $0x10,%esp
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	78 4b                	js     801cee <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ca3:	83 ec 08             	sub    $0x8,%esp
  801ca6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca9:	50                   	push   %eax
  801caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cad:	ff 30                	pushl  (%eax)
  801caf:	e8 bc fb ff ff       	call   801870 <dev_lookup>
  801cb4:	83 c4 10             	add    $0x10,%esp
  801cb7:	85 c0                	test   %eax,%eax
  801cb9:	78 33                	js     801cee <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbe:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801cc2:	74 2f                	je     801cf3 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801cc4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801cc7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801cce:	00 00 00 
	stat->st_isdir = 0;
  801cd1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cd8:	00 00 00 
	stat->st_dev = dev;
  801cdb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ce1:	83 ec 08             	sub    $0x8,%esp
  801ce4:	53                   	push   %ebx
  801ce5:	ff 75 f0             	pushl  -0x10(%ebp)
  801ce8:	ff 50 14             	call   *0x14(%eax)
  801ceb:	83 c4 10             	add    $0x10,%esp
}
  801cee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    
		return -E_NOT_SUPP;
  801cf3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cf8:	eb f4                	jmp    801cee <fstat+0x68>

00801cfa <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	56                   	push   %esi
  801cfe:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cff:	83 ec 08             	sub    $0x8,%esp
  801d02:	6a 00                	push   $0x0
  801d04:	ff 75 08             	pushl  0x8(%ebp)
  801d07:	e8 22 02 00 00       	call   801f2e <open>
  801d0c:	89 c3                	mov    %eax,%ebx
  801d0e:	83 c4 10             	add    $0x10,%esp
  801d11:	85 c0                	test   %eax,%eax
  801d13:	78 1b                	js     801d30 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801d15:	83 ec 08             	sub    $0x8,%esp
  801d18:	ff 75 0c             	pushl  0xc(%ebp)
  801d1b:	50                   	push   %eax
  801d1c:	e8 65 ff ff ff       	call   801c86 <fstat>
  801d21:	89 c6                	mov    %eax,%esi
	close(fd);
  801d23:	89 1c 24             	mov    %ebx,(%esp)
  801d26:	e8 27 fc ff ff       	call   801952 <close>
	return r;
  801d2b:	83 c4 10             	add    $0x10,%esp
  801d2e:	89 f3                	mov    %esi,%ebx
}
  801d30:	89 d8                	mov    %ebx,%eax
  801d32:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d35:	5b                   	pop    %ebx
  801d36:	5e                   	pop    %esi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    

00801d39 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	56                   	push   %esi
  801d3d:	53                   	push   %ebx
  801d3e:	89 c6                	mov    %eax,%esi
  801d40:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d42:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d49:	74 27                	je     801d72 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d4b:	6a 07                	push   $0x7
  801d4d:	68 00 60 80 00       	push   $0x806000
  801d52:	56                   	push   %esi
  801d53:	ff 35 00 50 80 00    	pushl  0x805000
  801d59:	e8 b2 f9 ff ff       	call   801710 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d5e:	83 c4 0c             	add    $0xc,%esp
  801d61:	6a 00                	push   $0x0
  801d63:	53                   	push   %ebx
  801d64:	6a 00                	push   $0x0
  801d66:	e8 3c f9 ff ff       	call   8016a7 <ipc_recv>
}
  801d6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d6e:	5b                   	pop    %ebx
  801d6f:	5e                   	pop    %esi
  801d70:	5d                   	pop    %ebp
  801d71:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d72:	83 ec 0c             	sub    $0xc,%esp
  801d75:	6a 01                	push   $0x1
  801d77:	e8 ec f9 ff ff       	call   801768 <ipc_find_env>
  801d7c:	a3 00 50 80 00       	mov    %eax,0x805000
  801d81:	83 c4 10             	add    $0x10,%esp
  801d84:	eb c5                	jmp    801d4b <fsipc+0x12>

00801d86 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d92:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d9a:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801da4:	b8 02 00 00 00       	mov    $0x2,%eax
  801da9:	e8 8b ff ff ff       	call   801d39 <fsipc>
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <devfile_flush>:
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	8b 40 0c             	mov    0xc(%eax),%eax
  801dbc:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801dc1:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc6:	b8 06 00 00 00       	mov    $0x6,%eax
  801dcb:	e8 69 ff ff ff       	call   801d39 <fsipc>
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <devfile_stat>:
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	53                   	push   %ebx
  801dd6:	83 ec 04             	sub    $0x4,%esp
  801dd9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddf:	8b 40 0c             	mov    0xc(%eax),%eax
  801de2:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801de7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dec:	b8 05 00 00 00       	mov    $0x5,%eax
  801df1:	e8 43 ff ff ff       	call   801d39 <fsipc>
  801df6:	85 c0                	test   %eax,%eax
  801df8:	78 2c                	js     801e26 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801dfa:	83 ec 08             	sub    $0x8,%esp
  801dfd:	68 00 60 80 00       	push   $0x806000
  801e02:	53                   	push   %ebx
  801e03:	e8 cb ec ff ff       	call   800ad3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e08:	a1 80 60 80 00       	mov    0x806080,%eax
  801e0d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e13:	a1 84 60 80 00       	mov    0x806084,%eax
  801e18:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e1e:	83 c4 10             	add    $0x10,%esp
  801e21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <devfile_write>:
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	53                   	push   %ebx
  801e2f:	83 ec 08             	sub    $0x8,%esp
  801e32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	8b 40 0c             	mov    0xc(%eax),%eax
  801e3b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801e40:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801e46:	53                   	push   %ebx
  801e47:	ff 75 0c             	pushl  0xc(%ebp)
  801e4a:	68 08 60 80 00       	push   $0x806008
  801e4f:	e8 6f ee ff ff       	call   800cc3 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e54:	ba 00 00 00 00       	mov    $0x0,%edx
  801e59:	b8 04 00 00 00       	mov    $0x4,%eax
  801e5e:	e8 d6 fe ff ff       	call   801d39 <fsipc>
  801e63:	83 c4 10             	add    $0x10,%esp
  801e66:	85 c0                	test   %eax,%eax
  801e68:	78 0b                	js     801e75 <devfile_write+0x4a>
	assert(r <= n);
  801e6a:	39 d8                	cmp    %ebx,%eax
  801e6c:	77 0c                	ja     801e7a <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e6e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e73:	7f 1e                	jg     801e93 <devfile_write+0x68>
}
  801e75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    
	assert(r <= n);
  801e7a:	68 b4 32 80 00       	push   $0x8032b4
  801e7f:	68 bb 32 80 00       	push   $0x8032bb
  801e84:	68 98 00 00 00       	push   $0x98
  801e89:	68 d0 32 80 00       	push   $0x8032d0
  801e8e:	e8 eb e3 ff ff       	call   80027e <_panic>
	assert(r <= PGSIZE);
  801e93:	68 db 32 80 00       	push   $0x8032db
  801e98:	68 bb 32 80 00       	push   $0x8032bb
  801e9d:	68 99 00 00 00       	push   $0x99
  801ea2:	68 d0 32 80 00       	push   $0x8032d0
  801ea7:	e8 d2 e3 ff ff       	call   80027e <_panic>

00801eac <devfile_read>:
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	56                   	push   %esi
  801eb0:	53                   	push   %ebx
  801eb1:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb7:	8b 40 0c             	mov    0xc(%eax),%eax
  801eba:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ebf:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ec5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eca:	b8 03 00 00 00       	mov    $0x3,%eax
  801ecf:	e8 65 fe ff ff       	call   801d39 <fsipc>
  801ed4:	89 c3                	mov    %eax,%ebx
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	78 1f                	js     801ef9 <devfile_read+0x4d>
	assert(r <= n);
  801eda:	39 f0                	cmp    %esi,%eax
  801edc:	77 24                	ja     801f02 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ede:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ee3:	7f 33                	jg     801f18 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ee5:	83 ec 04             	sub    $0x4,%esp
  801ee8:	50                   	push   %eax
  801ee9:	68 00 60 80 00       	push   $0x806000
  801eee:	ff 75 0c             	pushl  0xc(%ebp)
  801ef1:	e8 6b ed ff ff       	call   800c61 <memmove>
	return r;
  801ef6:	83 c4 10             	add    $0x10,%esp
}
  801ef9:	89 d8                	mov    %ebx,%eax
  801efb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801efe:	5b                   	pop    %ebx
  801eff:	5e                   	pop    %esi
  801f00:	5d                   	pop    %ebp
  801f01:	c3                   	ret    
	assert(r <= n);
  801f02:	68 b4 32 80 00       	push   $0x8032b4
  801f07:	68 bb 32 80 00       	push   $0x8032bb
  801f0c:	6a 7c                	push   $0x7c
  801f0e:	68 d0 32 80 00       	push   $0x8032d0
  801f13:	e8 66 e3 ff ff       	call   80027e <_panic>
	assert(r <= PGSIZE);
  801f18:	68 db 32 80 00       	push   $0x8032db
  801f1d:	68 bb 32 80 00       	push   $0x8032bb
  801f22:	6a 7d                	push   $0x7d
  801f24:	68 d0 32 80 00       	push   $0x8032d0
  801f29:	e8 50 e3 ff ff       	call   80027e <_panic>

00801f2e <open>:
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	56                   	push   %esi
  801f32:	53                   	push   %ebx
  801f33:	83 ec 1c             	sub    $0x1c,%esp
  801f36:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f39:	56                   	push   %esi
  801f3a:	e8 5b eb ff ff       	call   800a9a <strlen>
  801f3f:	83 c4 10             	add    $0x10,%esp
  801f42:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f47:	7f 6c                	jg     801fb5 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f49:	83 ec 0c             	sub    $0xc,%esp
  801f4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f4f:	50                   	push   %eax
  801f50:	e8 79 f8 ff ff       	call   8017ce <fd_alloc>
  801f55:	89 c3                	mov    %eax,%ebx
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	78 3c                	js     801f9a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f5e:	83 ec 08             	sub    $0x8,%esp
  801f61:	56                   	push   %esi
  801f62:	68 00 60 80 00       	push   $0x806000
  801f67:	e8 67 eb ff ff       	call   800ad3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6f:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f77:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7c:	e8 b8 fd ff ff       	call   801d39 <fsipc>
  801f81:	89 c3                	mov    %eax,%ebx
  801f83:	83 c4 10             	add    $0x10,%esp
  801f86:	85 c0                	test   %eax,%eax
  801f88:	78 19                	js     801fa3 <open+0x75>
	return fd2num(fd);
  801f8a:	83 ec 0c             	sub    $0xc,%esp
  801f8d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f90:	e8 12 f8 ff ff       	call   8017a7 <fd2num>
  801f95:	89 c3                	mov    %eax,%ebx
  801f97:	83 c4 10             	add    $0x10,%esp
}
  801f9a:	89 d8                	mov    %ebx,%eax
  801f9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f9f:	5b                   	pop    %ebx
  801fa0:	5e                   	pop    %esi
  801fa1:	5d                   	pop    %ebp
  801fa2:	c3                   	ret    
		fd_close(fd, 0);
  801fa3:	83 ec 08             	sub    $0x8,%esp
  801fa6:	6a 00                	push   $0x0
  801fa8:	ff 75 f4             	pushl  -0xc(%ebp)
  801fab:	e8 1b f9 ff ff       	call   8018cb <fd_close>
		return r;
  801fb0:	83 c4 10             	add    $0x10,%esp
  801fb3:	eb e5                	jmp    801f9a <open+0x6c>
		return -E_BAD_PATH;
  801fb5:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801fba:	eb de                	jmp    801f9a <open+0x6c>

00801fbc <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801fc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc7:	b8 08 00 00 00       	mov    $0x8,%eax
  801fcc:	e8 68 fd ff ff       	call   801d39 <fsipc>
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fd9:	89 d0                	mov    %edx,%eax
  801fdb:	c1 e8 16             	shr    $0x16,%eax
  801fde:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fe5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fea:	f6 c1 01             	test   $0x1,%cl
  801fed:	74 1d                	je     80200c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801fef:	c1 ea 0c             	shr    $0xc,%edx
  801ff2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ff9:	f6 c2 01             	test   $0x1,%dl
  801ffc:	74 0e                	je     80200c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ffe:	c1 ea 0c             	shr    $0xc,%edx
  802001:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802008:	ef 
  802009:	0f b7 c0             	movzwl %ax,%eax
}
  80200c:	5d                   	pop    %ebp
  80200d:	c3                   	ret    

0080200e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802014:	68 e7 32 80 00       	push   $0x8032e7
  802019:	ff 75 0c             	pushl  0xc(%ebp)
  80201c:	e8 b2 ea ff ff       	call   800ad3 <strcpy>
	return 0;
}
  802021:	b8 00 00 00 00       	mov    $0x0,%eax
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <devsock_close>:
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	53                   	push   %ebx
  80202c:	83 ec 10             	sub    $0x10,%esp
  80202f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802032:	53                   	push   %ebx
  802033:	e8 9b ff ff ff       	call   801fd3 <pageref>
  802038:	83 c4 10             	add    $0x10,%esp
		return 0;
  80203b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  802040:	83 f8 01             	cmp    $0x1,%eax
  802043:	74 07                	je     80204c <devsock_close+0x24>
}
  802045:	89 d0                	mov    %edx,%eax
  802047:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80204c:	83 ec 0c             	sub    $0xc,%esp
  80204f:	ff 73 0c             	pushl  0xc(%ebx)
  802052:	e8 b9 02 00 00       	call   802310 <nsipc_close>
  802057:	89 c2                	mov    %eax,%edx
  802059:	83 c4 10             	add    $0x10,%esp
  80205c:	eb e7                	jmp    802045 <devsock_close+0x1d>

0080205e <devsock_write>:
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802064:	6a 00                	push   $0x0
  802066:	ff 75 10             	pushl  0x10(%ebp)
  802069:	ff 75 0c             	pushl  0xc(%ebp)
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	ff 70 0c             	pushl  0xc(%eax)
  802072:	e8 76 03 00 00       	call   8023ed <nsipc_send>
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <devsock_read>:
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80207f:	6a 00                	push   $0x0
  802081:	ff 75 10             	pushl  0x10(%ebp)
  802084:	ff 75 0c             	pushl  0xc(%ebp)
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	ff 70 0c             	pushl  0xc(%eax)
  80208d:	e8 ef 02 00 00       	call   802381 <nsipc_recv>
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <fd2sockid>:
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80209a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80209d:	52                   	push   %edx
  80209e:	50                   	push   %eax
  80209f:	e8 7c f7 ff ff       	call   801820 <fd_lookup>
  8020a4:	83 c4 10             	add    $0x10,%esp
  8020a7:	85 c0                	test   %eax,%eax
  8020a9:	78 10                	js     8020bb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8020ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ae:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8020b4:	39 08                	cmp    %ecx,(%eax)
  8020b6:	75 05                	jne    8020bd <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8020b8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    
		return -E_NOT_SUPP;
  8020bd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020c2:	eb f7                	jmp    8020bb <fd2sockid+0x27>

008020c4 <alloc_sockfd>:
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	56                   	push   %esi
  8020c8:	53                   	push   %ebx
  8020c9:	83 ec 1c             	sub    $0x1c,%esp
  8020cc:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8020ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d1:	50                   	push   %eax
  8020d2:	e8 f7 f6 ff ff       	call   8017ce <fd_alloc>
  8020d7:	89 c3                	mov    %eax,%ebx
  8020d9:	83 c4 10             	add    $0x10,%esp
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	78 43                	js     802123 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020e0:	83 ec 04             	sub    $0x4,%esp
  8020e3:	68 07 04 00 00       	push   $0x407
  8020e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8020eb:	6a 00                	push   $0x0
  8020ed:	e8 d3 ed ff ff       	call   800ec5 <sys_page_alloc>
  8020f2:	89 c3                	mov    %eax,%ebx
  8020f4:	83 c4 10             	add    $0x10,%esp
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	78 28                	js     802123 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802104:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802109:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802110:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802113:	83 ec 0c             	sub    $0xc,%esp
  802116:	50                   	push   %eax
  802117:	e8 8b f6 ff ff       	call   8017a7 <fd2num>
  80211c:	89 c3                	mov    %eax,%ebx
  80211e:	83 c4 10             	add    $0x10,%esp
  802121:	eb 0c                	jmp    80212f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802123:	83 ec 0c             	sub    $0xc,%esp
  802126:	56                   	push   %esi
  802127:	e8 e4 01 00 00       	call   802310 <nsipc_close>
		return r;
  80212c:	83 c4 10             	add    $0x10,%esp
}
  80212f:	89 d8                	mov    %ebx,%eax
  802131:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802134:	5b                   	pop    %ebx
  802135:	5e                   	pop    %esi
  802136:	5d                   	pop    %ebp
  802137:	c3                   	ret    

00802138 <accept>:
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	e8 4e ff ff ff       	call   802094 <fd2sockid>
  802146:	85 c0                	test   %eax,%eax
  802148:	78 1b                	js     802165 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80214a:	83 ec 04             	sub    $0x4,%esp
  80214d:	ff 75 10             	pushl  0x10(%ebp)
  802150:	ff 75 0c             	pushl  0xc(%ebp)
  802153:	50                   	push   %eax
  802154:	e8 0e 01 00 00       	call   802267 <nsipc_accept>
  802159:	83 c4 10             	add    $0x10,%esp
  80215c:	85 c0                	test   %eax,%eax
  80215e:	78 05                	js     802165 <accept+0x2d>
	return alloc_sockfd(r);
  802160:	e8 5f ff ff ff       	call   8020c4 <alloc_sockfd>
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <bind>:
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	e8 1f ff ff ff       	call   802094 <fd2sockid>
  802175:	85 c0                	test   %eax,%eax
  802177:	78 12                	js     80218b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802179:	83 ec 04             	sub    $0x4,%esp
  80217c:	ff 75 10             	pushl  0x10(%ebp)
  80217f:	ff 75 0c             	pushl  0xc(%ebp)
  802182:	50                   	push   %eax
  802183:	e8 31 01 00 00       	call   8022b9 <nsipc_bind>
  802188:	83 c4 10             	add    $0x10,%esp
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <shutdown>:
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	e8 f9 fe ff ff       	call   802094 <fd2sockid>
  80219b:	85 c0                	test   %eax,%eax
  80219d:	78 0f                	js     8021ae <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80219f:	83 ec 08             	sub    $0x8,%esp
  8021a2:	ff 75 0c             	pushl  0xc(%ebp)
  8021a5:	50                   	push   %eax
  8021a6:	e8 43 01 00 00       	call   8022ee <nsipc_shutdown>
  8021ab:	83 c4 10             	add    $0x10,%esp
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <connect>:
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	e8 d6 fe ff ff       	call   802094 <fd2sockid>
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	78 12                	js     8021d4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8021c2:	83 ec 04             	sub    $0x4,%esp
  8021c5:	ff 75 10             	pushl  0x10(%ebp)
  8021c8:	ff 75 0c             	pushl  0xc(%ebp)
  8021cb:	50                   	push   %eax
  8021cc:	e8 59 01 00 00       	call   80232a <nsipc_connect>
  8021d1:	83 c4 10             	add    $0x10,%esp
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <listen>:
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	e8 b0 fe ff ff       	call   802094 <fd2sockid>
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	78 0f                	js     8021f7 <listen+0x21>
	return nsipc_listen(r, backlog);
  8021e8:	83 ec 08             	sub    $0x8,%esp
  8021eb:	ff 75 0c             	pushl  0xc(%ebp)
  8021ee:	50                   	push   %eax
  8021ef:	e8 6b 01 00 00       	call   80235f <nsipc_listen>
  8021f4:	83 c4 10             	add    $0x10,%esp
}
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    

008021f9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
  8021fc:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021ff:	ff 75 10             	pushl  0x10(%ebp)
  802202:	ff 75 0c             	pushl  0xc(%ebp)
  802205:	ff 75 08             	pushl  0x8(%ebp)
  802208:	e8 3e 02 00 00       	call   80244b <nsipc_socket>
  80220d:	83 c4 10             	add    $0x10,%esp
  802210:	85 c0                	test   %eax,%eax
  802212:	78 05                	js     802219 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802214:	e8 ab fe ff ff       	call   8020c4 <alloc_sockfd>
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	53                   	push   %ebx
  80221f:	83 ec 04             	sub    $0x4,%esp
  802222:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802224:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80222b:	74 26                	je     802253 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80222d:	6a 07                	push   $0x7
  80222f:	68 00 70 80 00       	push   $0x807000
  802234:	53                   	push   %ebx
  802235:	ff 35 04 50 80 00    	pushl  0x805004
  80223b:	e8 d0 f4 ff ff       	call   801710 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802240:	83 c4 0c             	add    $0xc,%esp
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	e8 59 f4 ff ff       	call   8016a7 <ipc_recv>
}
  80224e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802251:	c9                   	leave  
  802252:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802253:	83 ec 0c             	sub    $0xc,%esp
  802256:	6a 02                	push   $0x2
  802258:	e8 0b f5 ff ff       	call   801768 <ipc_find_env>
  80225d:	a3 04 50 80 00       	mov    %eax,0x805004
  802262:	83 c4 10             	add    $0x10,%esp
  802265:	eb c6                	jmp    80222d <nsipc+0x12>

00802267 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802267:	55                   	push   %ebp
  802268:	89 e5                	mov    %esp,%ebp
  80226a:	56                   	push   %esi
  80226b:	53                   	push   %ebx
  80226c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802277:	8b 06                	mov    (%esi),%eax
  802279:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80227e:	b8 01 00 00 00       	mov    $0x1,%eax
  802283:	e8 93 ff ff ff       	call   80221b <nsipc>
  802288:	89 c3                	mov    %eax,%ebx
  80228a:	85 c0                	test   %eax,%eax
  80228c:	79 09                	jns    802297 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80228e:	89 d8                	mov    %ebx,%eax
  802290:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802293:	5b                   	pop    %ebx
  802294:	5e                   	pop    %esi
  802295:	5d                   	pop    %ebp
  802296:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802297:	83 ec 04             	sub    $0x4,%esp
  80229a:	ff 35 10 70 80 00    	pushl  0x807010
  8022a0:	68 00 70 80 00       	push   $0x807000
  8022a5:	ff 75 0c             	pushl  0xc(%ebp)
  8022a8:	e8 b4 e9 ff ff       	call   800c61 <memmove>
		*addrlen = ret->ret_addrlen;
  8022ad:	a1 10 70 80 00       	mov    0x807010,%eax
  8022b2:	89 06                	mov    %eax,(%esi)
  8022b4:	83 c4 10             	add    $0x10,%esp
	return r;
  8022b7:	eb d5                	jmp    80228e <nsipc_accept+0x27>

008022b9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	53                   	push   %ebx
  8022bd:	83 ec 08             	sub    $0x8,%esp
  8022c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022cb:	53                   	push   %ebx
  8022cc:	ff 75 0c             	pushl  0xc(%ebp)
  8022cf:	68 04 70 80 00       	push   $0x807004
  8022d4:	e8 88 e9 ff ff       	call   800c61 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8022d9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8022df:	b8 02 00 00 00       	mov    $0x2,%eax
  8022e4:	e8 32 ff ff ff       	call   80221b <nsipc>
}
  8022e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    

008022ee <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8022fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ff:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802304:	b8 03 00 00 00       	mov    $0x3,%eax
  802309:	e8 0d ff ff ff       	call   80221b <nsipc>
}
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <nsipc_close>:

int
nsipc_close(int s)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80231e:	b8 04 00 00 00       	mov    $0x4,%eax
  802323:	e8 f3 fe ff ff       	call   80221b <nsipc>
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	53                   	push   %ebx
  80232e:	83 ec 08             	sub    $0x8,%esp
  802331:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80233c:	53                   	push   %ebx
  80233d:	ff 75 0c             	pushl  0xc(%ebp)
  802340:	68 04 70 80 00       	push   $0x807004
  802345:	e8 17 e9 ff ff       	call   800c61 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80234a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802350:	b8 05 00 00 00       	mov    $0x5,%eax
  802355:	e8 c1 fe ff ff       	call   80221b <nsipc>
}
  80235a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80236d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802370:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802375:	b8 06 00 00 00       	mov    $0x6,%eax
  80237a:	e8 9c fe ff ff       	call   80221b <nsipc>
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	56                   	push   %esi
  802385:	53                   	push   %ebx
  802386:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802391:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802397:	8b 45 14             	mov    0x14(%ebp),%eax
  80239a:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80239f:	b8 07 00 00 00       	mov    $0x7,%eax
  8023a4:	e8 72 fe ff ff       	call   80221b <nsipc>
  8023a9:	89 c3                	mov    %eax,%ebx
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	78 1f                	js     8023ce <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8023af:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023b4:	7f 21                	jg     8023d7 <nsipc_recv+0x56>
  8023b6:	39 c6                	cmp    %eax,%esi
  8023b8:	7c 1d                	jl     8023d7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8023ba:	83 ec 04             	sub    $0x4,%esp
  8023bd:	50                   	push   %eax
  8023be:	68 00 70 80 00       	push   $0x807000
  8023c3:	ff 75 0c             	pushl  0xc(%ebp)
  8023c6:	e8 96 e8 ff ff       	call   800c61 <memmove>
  8023cb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8023ce:	89 d8                	mov    %ebx,%eax
  8023d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023d3:	5b                   	pop    %ebx
  8023d4:	5e                   	pop    %esi
  8023d5:	5d                   	pop    %ebp
  8023d6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8023d7:	68 f3 32 80 00       	push   $0x8032f3
  8023dc:	68 bb 32 80 00       	push   $0x8032bb
  8023e1:	6a 62                	push   $0x62
  8023e3:	68 08 33 80 00       	push   $0x803308
  8023e8:	e8 91 de ff ff       	call   80027e <_panic>

008023ed <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
  8023f0:	53                   	push   %ebx
  8023f1:	83 ec 04             	sub    $0x4,%esp
  8023f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fa:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8023ff:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802405:	7f 2e                	jg     802435 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802407:	83 ec 04             	sub    $0x4,%esp
  80240a:	53                   	push   %ebx
  80240b:	ff 75 0c             	pushl  0xc(%ebp)
  80240e:	68 0c 70 80 00       	push   $0x80700c
  802413:	e8 49 e8 ff ff       	call   800c61 <memmove>
	nsipcbuf.send.req_size = size;
  802418:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80241e:	8b 45 14             	mov    0x14(%ebp),%eax
  802421:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802426:	b8 08 00 00 00       	mov    $0x8,%eax
  80242b:	e8 eb fd ff ff       	call   80221b <nsipc>
}
  802430:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802433:	c9                   	leave  
  802434:	c3                   	ret    
	assert(size < 1600);
  802435:	68 14 33 80 00       	push   $0x803314
  80243a:	68 bb 32 80 00       	push   $0x8032bb
  80243f:	6a 6d                	push   $0x6d
  802441:	68 08 33 80 00       	push   $0x803308
  802446:	e8 33 de ff ff       	call   80027e <_panic>

0080244b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
  80244e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802451:	8b 45 08             	mov    0x8(%ebp),%eax
  802454:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802459:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245c:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802461:	8b 45 10             	mov    0x10(%ebp),%eax
  802464:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802469:	b8 09 00 00 00       	mov    $0x9,%eax
  80246e:	e8 a8 fd ff ff       	call   80221b <nsipc>
}
  802473:	c9                   	leave  
  802474:	c3                   	ret    

00802475 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
  802478:	56                   	push   %esi
  802479:	53                   	push   %ebx
  80247a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80247d:	83 ec 0c             	sub    $0xc,%esp
  802480:	ff 75 08             	pushl  0x8(%ebp)
  802483:	e8 2f f3 ff ff       	call   8017b7 <fd2data>
  802488:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80248a:	83 c4 08             	add    $0x8,%esp
  80248d:	68 20 33 80 00       	push   $0x803320
  802492:	53                   	push   %ebx
  802493:	e8 3b e6 ff ff       	call   800ad3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802498:	8b 46 04             	mov    0x4(%esi),%eax
  80249b:	2b 06                	sub    (%esi),%eax
  80249d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8024a3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024aa:	00 00 00 
	stat->st_dev = &devpipe;
  8024ad:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8024b4:	40 80 00 
	return 0;
}
  8024b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024bf:	5b                   	pop    %ebx
  8024c0:	5e                   	pop    %esi
  8024c1:	5d                   	pop    %ebp
  8024c2:	c3                   	ret    

008024c3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
  8024c6:	53                   	push   %ebx
  8024c7:	83 ec 0c             	sub    $0xc,%esp
  8024ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024cd:	53                   	push   %ebx
  8024ce:	6a 00                	push   $0x0
  8024d0:	e8 75 ea ff ff       	call   800f4a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024d5:	89 1c 24             	mov    %ebx,(%esp)
  8024d8:	e8 da f2 ff ff       	call   8017b7 <fd2data>
  8024dd:	83 c4 08             	add    $0x8,%esp
  8024e0:	50                   	push   %eax
  8024e1:	6a 00                	push   $0x0
  8024e3:	e8 62 ea ff ff       	call   800f4a <sys_page_unmap>
}
  8024e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <_pipeisclosed>:
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
  8024f0:	57                   	push   %edi
  8024f1:	56                   	push   %esi
  8024f2:	53                   	push   %ebx
  8024f3:	83 ec 1c             	sub    $0x1c,%esp
  8024f6:	89 c7                	mov    %eax,%edi
  8024f8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8024fa:	a1 08 50 80 00       	mov    0x805008,%eax
  8024ff:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802502:	83 ec 0c             	sub    $0xc,%esp
  802505:	57                   	push   %edi
  802506:	e8 c8 fa ff ff       	call   801fd3 <pageref>
  80250b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80250e:	89 34 24             	mov    %esi,(%esp)
  802511:	e8 bd fa ff ff       	call   801fd3 <pageref>
		nn = thisenv->env_runs;
  802516:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80251c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80251f:	83 c4 10             	add    $0x10,%esp
  802522:	39 cb                	cmp    %ecx,%ebx
  802524:	74 1b                	je     802541 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802526:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802529:	75 cf                	jne    8024fa <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80252b:	8b 42 58             	mov    0x58(%edx),%eax
  80252e:	6a 01                	push   $0x1
  802530:	50                   	push   %eax
  802531:	53                   	push   %ebx
  802532:	68 27 33 80 00       	push   $0x803327
  802537:	e8 38 de ff ff       	call   800374 <cprintf>
  80253c:	83 c4 10             	add    $0x10,%esp
  80253f:	eb b9                	jmp    8024fa <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802541:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802544:	0f 94 c0             	sete   %al
  802547:	0f b6 c0             	movzbl %al,%eax
}
  80254a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80254d:	5b                   	pop    %ebx
  80254e:	5e                   	pop    %esi
  80254f:	5f                   	pop    %edi
  802550:	5d                   	pop    %ebp
  802551:	c3                   	ret    

00802552 <devpipe_write>:
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
  802555:	57                   	push   %edi
  802556:	56                   	push   %esi
  802557:	53                   	push   %ebx
  802558:	83 ec 28             	sub    $0x28,%esp
  80255b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80255e:	56                   	push   %esi
  80255f:	e8 53 f2 ff ff       	call   8017b7 <fd2data>
  802564:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802566:	83 c4 10             	add    $0x10,%esp
  802569:	bf 00 00 00 00       	mov    $0x0,%edi
  80256e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802571:	74 4f                	je     8025c2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802573:	8b 43 04             	mov    0x4(%ebx),%eax
  802576:	8b 0b                	mov    (%ebx),%ecx
  802578:	8d 51 20             	lea    0x20(%ecx),%edx
  80257b:	39 d0                	cmp    %edx,%eax
  80257d:	72 14                	jb     802593 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80257f:	89 da                	mov    %ebx,%edx
  802581:	89 f0                	mov    %esi,%eax
  802583:	e8 65 ff ff ff       	call   8024ed <_pipeisclosed>
  802588:	85 c0                	test   %eax,%eax
  80258a:	75 3b                	jne    8025c7 <devpipe_write+0x75>
			sys_yield();
  80258c:	e8 15 e9 ff ff       	call   800ea6 <sys_yield>
  802591:	eb e0                	jmp    802573 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802593:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802596:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80259a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80259d:	89 c2                	mov    %eax,%edx
  80259f:	c1 fa 1f             	sar    $0x1f,%edx
  8025a2:	89 d1                	mov    %edx,%ecx
  8025a4:	c1 e9 1b             	shr    $0x1b,%ecx
  8025a7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8025aa:	83 e2 1f             	and    $0x1f,%edx
  8025ad:	29 ca                	sub    %ecx,%edx
  8025af:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8025b3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8025b7:	83 c0 01             	add    $0x1,%eax
  8025ba:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8025bd:	83 c7 01             	add    $0x1,%edi
  8025c0:	eb ac                	jmp    80256e <devpipe_write+0x1c>
	return i;
  8025c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8025c5:	eb 05                	jmp    8025cc <devpipe_write+0x7a>
				return 0;
  8025c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025cf:	5b                   	pop    %ebx
  8025d0:	5e                   	pop    %esi
  8025d1:	5f                   	pop    %edi
  8025d2:	5d                   	pop    %ebp
  8025d3:	c3                   	ret    

008025d4 <devpipe_read>:
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
  8025d7:	57                   	push   %edi
  8025d8:	56                   	push   %esi
  8025d9:	53                   	push   %ebx
  8025da:	83 ec 18             	sub    $0x18,%esp
  8025dd:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8025e0:	57                   	push   %edi
  8025e1:	e8 d1 f1 ff ff       	call   8017b7 <fd2data>
  8025e6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025e8:	83 c4 10             	add    $0x10,%esp
  8025eb:	be 00 00 00 00       	mov    $0x0,%esi
  8025f0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025f3:	75 14                	jne    802609 <devpipe_read+0x35>
	return i;
  8025f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8025f8:	eb 02                	jmp    8025fc <devpipe_read+0x28>
				return i;
  8025fa:	89 f0                	mov    %esi,%eax
}
  8025fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025ff:	5b                   	pop    %ebx
  802600:	5e                   	pop    %esi
  802601:	5f                   	pop    %edi
  802602:	5d                   	pop    %ebp
  802603:	c3                   	ret    
			sys_yield();
  802604:	e8 9d e8 ff ff       	call   800ea6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802609:	8b 03                	mov    (%ebx),%eax
  80260b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80260e:	75 18                	jne    802628 <devpipe_read+0x54>
			if (i > 0)
  802610:	85 f6                	test   %esi,%esi
  802612:	75 e6                	jne    8025fa <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802614:	89 da                	mov    %ebx,%edx
  802616:	89 f8                	mov    %edi,%eax
  802618:	e8 d0 fe ff ff       	call   8024ed <_pipeisclosed>
  80261d:	85 c0                	test   %eax,%eax
  80261f:	74 e3                	je     802604 <devpipe_read+0x30>
				return 0;
  802621:	b8 00 00 00 00       	mov    $0x0,%eax
  802626:	eb d4                	jmp    8025fc <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802628:	99                   	cltd   
  802629:	c1 ea 1b             	shr    $0x1b,%edx
  80262c:	01 d0                	add    %edx,%eax
  80262e:	83 e0 1f             	and    $0x1f,%eax
  802631:	29 d0                	sub    %edx,%eax
  802633:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802638:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80263b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80263e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802641:	83 c6 01             	add    $0x1,%esi
  802644:	eb aa                	jmp    8025f0 <devpipe_read+0x1c>

00802646 <pipe>:
{
  802646:	55                   	push   %ebp
  802647:	89 e5                	mov    %esp,%ebp
  802649:	56                   	push   %esi
  80264a:	53                   	push   %ebx
  80264b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80264e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802651:	50                   	push   %eax
  802652:	e8 77 f1 ff ff       	call   8017ce <fd_alloc>
  802657:	89 c3                	mov    %eax,%ebx
  802659:	83 c4 10             	add    $0x10,%esp
  80265c:	85 c0                	test   %eax,%eax
  80265e:	0f 88 23 01 00 00    	js     802787 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802664:	83 ec 04             	sub    $0x4,%esp
  802667:	68 07 04 00 00       	push   $0x407
  80266c:	ff 75 f4             	pushl  -0xc(%ebp)
  80266f:	6a 00                	push   $0x0
  802671:	e8 4f e8 ff ff       	call   800ec5 <sys_page_alloc>
  802676:	89 c3                	mov    %eax,%ebx
  802678:	83 c4 10             	add    $0x10,%esp
  80267b:	85 c0                	test   %eax,%eax
  80267d:	0f 88 04 01 00 00    	js     802787 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802683:	83 ec 0c             	sub    $0xc,%esp
  802686:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802689:	50                   	push   %eax
  80268a:	e8 3f f1 ff ff       	call   8017ce <fd_alloc>
  80268f:	89 c3                	mov    %eax,%ebx
  802691:	83 c4 10             	add    $0x10,%esp
  802694:	85 c0                	test   %eax,%eax
  802696:	0f 88 db 00 00 00    	js     802777 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80269c:	83 ec 04             	sub    $0x4,%esp
  80269f:	68 07 04 00 00       	push   $0x407
  8026a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8026a7:	6a 00                	push   $0x0
  8026a9:	e8 17 e8 ff ff       	call   800ec5 <sys_page_alloc>
  8026ae:	89 c3                	mov    %eax,%ebx
  8026b0:	83 c4 10             	add    $0x10,%esp
  8026b3:	85 c0                	test   %eax,%eax
  8026b5:	0f 88 bc 00 00 00    	js     802777 <pipe+0x131>
	va = fd2data(fd0);
  8026bb:	83 ec 0c             	sub    $0xc,%esp
  8026be:	ff 75 f4             	pushl  -0xc(%ebp)
  8026c1:	e8 f1 f0 ff ff       	call   8017b7 <fd2data>
  8026c6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026c8:	83 c4 0c             	add    $0xc,%esp
  8026cb:	68 07 04 00 00       	push   $0x407
  8026d0:	50                   	push   %eax
  8026d1:	6a 00                	push   $0x0
  8026d3:	e8 ed e7 ff ff       	call   800ec5 <sys_page_alloc>
  8026d8:	89 c3                	mov    %eax,%ebx
  8026da:	83 c4 10             	add    $0x10,%esp
  8026dd:	85 c0                	test   %eax,%eax
  8026df:	0f 88 82 00 00 00    	js     802767 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026e5:	83 ec 0c             	sub    $0xc,%esp
  8026e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8026eb:	e8 c7 f0 ff ff       	call   8017b7 <fd2data>
  8026f0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8026f7:	50                   	push   %eax
  8026f8:	6a 00                	push   $0x0
  8026fa:	56                   	push   %esi
  8026fb:	6a 00                	push   $0x0
  8026fd:	e8 06 e8 ff ff       	call   800f08 <sys_page_map>
  802702:	89 c3                	mov    %eax,%ebx
  802704:	83 c4 20             	add    $0x20,%esp
  802707:	85 c0                	test   %eax,%eax
  802709:	78 4e                	js     802759 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80270b:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802710:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802713:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802715:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802718:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80271f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802722:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802727:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80272e:	83 ec 0c             	sub    $0xc,%esp
  802731:	ff 75 f4             	pushl  -0xc(%ebp)
  802734:	e8 6e f0 ff ff       	call   8017a7 <fd2num>
  802739:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80273c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80273e:	83 c4 04             	add    $0x4,%esp
  802741:	ff 75 f0             	pushl  -0x10(%ebp)
  802744:	e8 5e f0 ff ff       	call   8017a7 <fd2num>
  802749:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80274c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80274f:	83 c4 10             	add    $0x10,%esp
  802752:	bb 00 00 00 00       	mov    $0x0,%ebx
  802757:	eb 2e                	jmp    802787 <pipe+0x141>
	sys_page_unmap(0, va);
  802759:	83 ec 08             	sub    $0x8,%esp
  80275c:	56                   	push   %esi
  80275d:	6a 00                	push   $0x0
  80275f:	e8 e6 e7 ff ff       	call   800f4a <sys_page_unmap>
  802764:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802767:	83 ec 08             	sub    $0x8,%esp
  80276a:	ff 75 f0             	pushl  -0x10(%ebp)
  80276d:	6a 00                	push   $0x0
  80276f:	e8 d6 e7 ff ff       	call   800f4a <sys_page_unmap>
  802774:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802777:	83 ec 08             	sub    $0x8,%esp
  80277a:	ff 75 f4             	pushl  -0xc(%ebp)
  80277d:	6a 00                	push   $0x0
  80277f:	e8 c6 e7 ff ff       	call   800f4a <sys_page_unmap>
  802784:	83 c4 10             	add    $0x10,%esp
}
  802787:	89 d8                	mov    %ebx,%eax
  802789:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80278c:	5b                   	pop    %ebx
  80278d:	5e                   	pop    %esi
  80278e:	5d                   	pop    %ebp
  80278f:	c3                   	ret    

00802790 <pipeisclosed>:
{
  802790:	55                   	push   %ebp
  802791:	89 e5                	mov    %esp,%ebp
  802793:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802796:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802799:	50                   	push   %eax
  80279a:	ff 75 08             	pushl  0x8(%ebp)
  80279d:	e8 7e f0 ff ff       	call   801820 <fd_lookup>
  8027a2:	83 c4 10             	add    $0x10,%esp
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	78 18                	js     8027c1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8027a9:	83 ec 0c             	sub    $0xc,%esp
  8027ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8027af:	e8 03 f0 ff ff       	call   8017b7 <fd2data>
	return _pipeisclosed(fd, p);
  8027b4:	89 c2                	mov    %eax,%edx
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	e8 2f fd ff ff       	call   8024ed <_pipeisclosed>
  8027be:	83 c4 10             	add    $0x10,%esp
}
  8027c1:	c9                   	leave  
  8027c2:	c3                   	ret    

008027c3 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8027c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c8:	c3                   	ret    

008027c9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027c9:	55                   	push   %ebp
  8027ca:	89 e5                	mov    %esp,%ebp
  8027cc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8027cf:	68 3f 33 80 00       	push   $0x80333f
  8027d4:	ff 75 0c             	pushl  0xc(%ebp)
  8027d7:	e8 f7 e2 ff ff       	call   800ad3 <strcpy>
	return 0;
}
  8027dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e1:	c9                   	leave  
  8027e2:	c3                   	ret    

008027e3 <devcons_write>:
{
  8027e3:	55                   	push   %ebp
  8027e4:	89 e5                	mov    %esp,%ebp
  8027e6:	57                   	push   %edi
  8027e7:	56                   	push   %esi
  8027e8:	53                   	push   %ebx
  8027e9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8027ef:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8027f4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8027fa:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027fd:	73 31                	jae    802830 <devcons_write+0x4d>
		m = n - tot;
  8027ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802802:	29 f3                	sub    %esi,%ebx
  802804:	83 fb 7f             	cmp    $0x7f,%ebx
  802807:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80280c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80280f:	83 ec 04             	sub    $0x4,%esp
  802812:	53                   	push   %ebx
  802813:	89 f0                	mov    %esi,%eax
  802815:	03 45 0c             	add    0xc(%ebp),%eax
  802818:	50                   	push   %eax
  802819:	57                   	push   %edi
  80281a:	e8 42 e4 ff ff       	call   800c61 <memmove>
		sys_cputs(buf, m);
  80281f:	83 c4 08             	add    $0x8,%esp
  802822:	53                   	push   %ebx
  802823:	57                   	push   %edi
  802824:	e8 e0 e5 ff ff       	call   800e09 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802829:	01 de                	add    %ebx,%esi
  80282b:	83 c4 10             	add    $0x10,%esp
  80282e:	eb ca                	jmp    8027fa <devcons_write+0x17>
}
  802830:	89 f0                	mov    %esi,%eax
  802832:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802835:	5b                   	pop    %ebx
  802836:	5e                   	pop    %esi
  802837:	5f                   	pop    %edi
  802838:	5d                   	pop    %ebp
  802839:	c3                   	ret    

0080283a <devcons_read>:
{
  80283a:	55                   	push   %ebp
  80283b:	89 e5                	mov    %esp,%ebp
  80283d:	83 ec 08             	sub    $0x8,%esp
  802840:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802845:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802849:	74 21                	je     80286c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80284b:	e8 d7 e5 ff ff       	call   800e27 <sys_cgetc>
  802850:	85 c0                	test   %eax,%eax
  802852:	75 07                	jne    80285b <devcons_read+0x21>
		sys_yield();
  802854:	e8 4d e6 ff ff       	call   800ea6 <sys_yield>
  802859:	eb f0                	jmp    80284b <devcons_read+0x11>
	if (c < 0)
  80285b:	78 0f                	js     80286c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80285d:	83 f8 04             	cmp    $0x4,%eax
  802860:	74 0c                	je     80286e <devcons_read+0x34>
	*(char*)vbuf = c;
  802862:	8b 55 0c             	mov    0xc(%ebp),%edx
  802865:	88 02                	mov    %al,(%edx)
	return 1;
  802867:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80286c:	c9                   	leave  
  80286d:	c3                   	ret    
		return 0;
  80286e:	b8 00 00 00 00       	mov    $0x0,%eax
  802873:	eb f7                	jmp    80286c <devcons_read+0x32>

00802875 <cputchar>:
{
  802875:	55                   	push   %ebp
  802876:	89 e5                	mov    %esp,%ebp
  802878:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80287b:	8b 45 08             	mov    0x8(%ebp),%eax
  80287e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802881:	6a 01                	push   $0x1
  802883:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802886:	50                   	push   %eax
  802887:	e8 7d e5 ff ff       	call   800e09 <sys_cputs>
}
  80288c:	83 c4 10             	add    $0x10,%esp
  80288f:	c9                   	leave  
  802890:	c3                   	ret    

00802891 <getchar>:
{
  802891:	55                   	push   %ebp
  802892:	89 e5                	mov    %esp,%ebp
  802894:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802897:	6a 01                	push   $0x1
  802899:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80289c:	50                   	push   %eax
  80289d:	6a 00                	push   $0x0
  80289f:	e8 ec f1 ff ff       	call   801a90 <read>
	if (r < 0)
  8028a4:	83 c4 10             	add    $0x10,%esp
  8028a7:	85 c0                	test   %eax,%eax
  8028a9:	78 06                	js     8028b1 <getchar+0x20>
	if (r < 1)
  8028ab:	74 06                	je     8028b3 <getchar+0x22>
	return c;
  8028ad:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8028b1:	c9                   	leave  
  8028b2:	c3                   	ret    
		return -E_EOF;
  8028b3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8028b8:	eb f7                	jmp    8028b1 <getchar+0x20>

008028ba <iscons>:
{
  8028ba:	55                   	push   %ebp
  8028bb:	89 e5                	mov    %esp,%ebp
  8028bd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028c3:	50                   	push   %eax
  8028c4:	ff 75 08             	pushl  0x8(%ebp)
  8028c7:	e8 54 ef ff ff       	call   801820 <fd_lookup>
  8028cc:	83 c4 10             	add    $0x10,%esp
  8028cf:	85 c0                	test   %eax,%eax
  8028d1:	78 11                	js     8028e4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028dc:	39 10                	cmp    %edx,(%eax)
  8028de:	0f 94 c0             	sete   %al
  8028e1:	0f b6 c0             	movzbl %al,%eax
}
  8028e4:	c9                   	leave  
  8028e5:	c3                   	ret    

008028e6 <opencons>:
{
  8028e6:	55                   	push   %ebp
  8028e7:	89 e5                	mov    %esp,%ebp
  8028e9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8028ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028ef:	50                   	push   %eax
  8028f0:	e8 d9 ee ff ff       	call   8017ce <fd_alloc>
  8028f5:	83 c4 10             	add    $0x10,%esp
  8028f8:	85 c0                	test   %eax,%eax
  8028fa:	78 3a                	js     802936 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028fc:	83 ec 04             	sub    $0x4,%esp
  8028ff:	68 07 04 00 00       	push   $0x407
  802904:	ff 75 f4             	pushl  -0xc(%ebp)
  802907:	6a 00                	push   $0x0
  802909:	e8 b7 e5 ff ff       	call   800ec5 <sys_page_alloc>
  80290e:	83 c4 10             	add    $0x10,%esp
  802911:	85 c0                	test   %eax,%eax
  802913:	78 21                	js     802936 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80291e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80292a:	83 ec 0c             	sub    $0xc,%esp
  80292d:	50                   	push   %eax
  80292e:	e8 74 ee ff ff       	call   8017a7 <fd2num>
  802933:	83 c4 10             	add    $0x10,%esp
}
  802936:	c9                   	leave  
  802937:	c3                   	ret    

00802938 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802938:	55                   	push   %ebp
  802939:	89 e5                	mov    %esp,%ebp
  80293b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80293e:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802945:	74 0a                	je     802951 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802947:	8b 45 08             	mov    0x8(%ebp),%eax
  80294a:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80294f:	c9                   	leave  
  802950:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802951:	83 ec 04             	sub    $0x4,%esp
  802954:	6a 07                	push   $0x7
  802956:	68 00 f0 bf ee       	push   $0xeebff000
  80295b:	6a 00                	push   $0x0
  80295d:	e8 63 e5 ff ff       	call   800ec5 <sys_page_alloc>
		if(r < 0)
  802962:	83 c4 10             	add    $0x10,%esp
  802965:	85 c0                	test   %eax,%eax
  802967:	78 2a                	js     802993 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802969:	83 ec 08             	sub    $0x8,%esp
  80296c:	68 a7 29 80 00       	push   $0x8029a7
  802971:	6a 00                	push   $0x0
  802973:	e8 98 e6 ff ff       	call   801010 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802978:	83 c4 10             	add    $0x10,%esp
  80297b:	85 c0                	test   %eax,%eax
  80297d:	79 c8                	jns    802947 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80297f:	83 ec 04             	sub    $0x4,%esp
  802982:	68 7c 33 80 00       	push   $0x80337c
  802987:	6a 25                	push   $0x25
  802989:	68 b8 33 80 00       	push   $0x8033b8
  80298e:	e8 eb d8 ff ff       	call   80027e <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802993:	83 ec 04             	sub    $0x4,%esp
  802996:	68 4c 33 80 00       	push   $0x80334c
  80299b:	6a 22                	push   $0x22
  80299d:	68 b8 33 80 00       	push   $0x8033b8
  8029a2:	e8 d7 d8 ff ff       	call   80027e <_panic>

008029a7 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8029a7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029a8:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8029ad:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029af:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8029b2:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8029b6:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8029ba:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8029bd:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8029bf:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8029c3:	83 c4 08             	add    $0x8,%esp
	popal
  8029c6:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8029c7:	83 c4 04             	add    $0x4,%esp
	popfl
  8029ca:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8029cb:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8029cc:	c3                   	ret    
  8029cd:	66 90                	xchg   %ax,%ax
  8029cf:	90                   	nop

008029d0 <__udivdi3>:
  8029d0:	55                   	push   %ebp
  8029d1:	57                   	push   %edi
  8029d2:	56                   	push   %esi
  8029d3:	53                   	push   %ebx
  8029d4:	83 ec 1c             	sub    $0x1c,%esp
  8029d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029e7:	85 d2                	test   %edx,%edx
  8029e9:	75 4d                	jne    802a38 <__udivdi3+0x68>
  8029eb:	39 f3                	cmp    %esi,%ebx
  8029ed:	76 19                	jbe    802a08 <__udivdi3+0x38>
  8029ef:	31 ff                	xor    %edi,%edi
  8029f1:	89 e8                	mov    %ebp,%eax
  8029f3:	89 f2                	mov    %esi,%edx
  8029f5:	f7 f3                	div    %ebx
  8029f7:	89 fa                	mov    %edi,%edx
  8029f9:	83 c4 1c             	add    $0x1c,%esp
  8029fc:	5b                   	pop    %ebx
  8029fd:	5e                   	pop    %esi
  8029fe:	5f                   	pop    %edi
  8029ff:	5d                   	pop    %ebp
  802a00:	c3                   	ret    
  802a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a08:	89 d9                	mov    %ebx,%ecx
  802a0a:	85 db                	test   %ebx,%ebx
  802a0c:	75 0b                	jne    802a19 <__udivdi3+0x49>
  802a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a13:	31 d2                	xor    %edx,%edx
  802a15:	f7 f3                	div    %ebx
  802a17:	89 c1                	mov    %eax,%ecx
  802a19:	31 d2                	xor    %edx,%edx
  802a1b:	89 f0                	mov    %esi,%eax
  802a1d:	f7 f1                	div    %ecx
  802a1f:	89 c6                	mov    %eax,%esi
  802a21:	89 e8                	mov    %ebp,%eax
  802a23:	89 f7                	mov    %esi,%edi
  802a25:	f7 f1                	div    %ecx
  802a27:	89 fa                	mov    %edi,%edx
  802a29:	83 c4 1c             	add    $0x1c,%esp
  802a2c:	5b                   	pop    %ebx
  802a2d:	5e                   	pop    %esi
  802a2e:	5f                   	pop    %edi
  802a2f:	5d                   	pop    %ebp
  802a30:	c3                   	ret    
  802a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a38:	39 f2                	cmp    %esi,%edx
  802a3a:	77 1c                	ja     802a58 <__udivdi3+0x88>
  802a3c:	0f bd fa             	bsr    %edx,%edi
  802a3f:	83 f7 1f             	xor    $0x1f,%edi
  802a42:	75 2c                	jne    802a70 <__udivdi3+0xa0>
  802a44:	39 f2                	cmp    %esi,%edx
  802a46:	72 06                	jb     802a4e <__udivdi3+0x7e>
  802a48:	31 c0                	xor    %eax,%eax
  802a4a:	39 eb                	cmp    %ebp,%ebx
  802a4c:	77 a9                	ja     8029f7 <__udivdi3+0x27>
  802a4e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a53:	eb a2                	jmp    8029f7 <__udivdi3+0x27>
  802a55:	8d 76 00             	lea    0x0(%esi),%esi
  802a58:	31 ff                	xor    %edi,%edi
  802a5a:	31 c0                	xor    %eax,%eax
  802a5c:	89 fa                	mov    %edi,%edx
  802a5e:	83 c4 1c             	add    $0x1c,%esp
  802a61:	5b                   	pop    %ebx
  802a62:	5e                   	pop    %esi
  802a63:	5f                   	pop    %edi
  802a64:	5d                   	pop    %ebp
  802a65:	c3                   	ret    
  802a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a6d:	8d 76 00             	lea    0x0(%esi),%esi
  802a70:	89 f9                	mov    %edi,%ecx
  802a72:	b8 20 00 00 00       	mov    $0x20,%eax
  802a77:	29 f8                	sub    %edi,%eax
  802a79:	d3 e2                	shl    %cl,%edx
  802a7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a7f:	89 c1                	mov    %eax,%ecx
  802a81:	89 da                	mov    %ebx,%edx
  802a83:	d3 ea                	shr    %cl,%edx
  802a85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a89:	09 d1                	or     %edx,%ecx
  802a8b:	89 f2                	mov    %esi,%edx
  802a8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a91:	89 f9                	mov    %edi,%ecx
  802a93:	d3 e3                	shl    %cl,%ebx
  802a95:	89 c1                	mov    %eax,%ecx
  802a97:	d3 ea                	shr    %cl,%edx
  802a99:	89 f9                	mov    %edi,%ecx
  802a9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a9f:	89 eb                	mov    %ebp,%ebx
  802aa1:	d3 e6                	shl    %cl,%esi
  802aa3:	89 c1                	mov    %eax,%ecx
  802aa5:	d3 eb                	shr    %cl,%ebx
  802aa7:	09 de                	or     %ebx,%esi
  802aa9:	89 f0                	mov    %esi,%eax
  802aab:	f7 74 24 08          	divl   0x8(%esp)
  802aaf:	89 d6                	mov    %edx,%esi
  802ab1:	89 c3                	mov    %eax,%ebx
  802ab3:	f7 64 24 0c          	mull   0xc(%esp)
  802ab7:	39 d6                	cmp    %edx,%esi
  802ab9:	72 15                	jb     802ad0 <__udivdi3+0x100>
  802abb:	89 f9                	mov    %edi,%ecx
  802abd:	d3 e5                	shl    %cl,%ebp
  802abf:	39 c5                	cmp    %eax,%ebp
  802ac1:	73 04                	jae    802ac7 <__udivdi3+0xf7>
  802ac3:	39 d6                	cmp    %edx,%esi
  802ac5:	74 09                	je     802ad0 <__udivdi3+0x100>
  802ac7:	89 d8                	mov    %ebx,%eax
  802ac9:	31 ff                	xor    %edi,%edi
  802acb:	e9 27 ff ff ff       	jmp    8029f7 <__udivdi3+0x27>
  802ad0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ad3:	31 ff                	xor    %edi,%edi
  802ad5:	e9 1d ff ff ff       	jmp    8029f7 <__udivdi3+0x27>
  802ada:	66 90                	xchg   %ax,%ax
  802adc:	66 90                	xchg   %ax,%ax
  802ade:	66 90                	xchg   %ax,%ax

00802ae0 <__umoddi3>:
  802ae0:	55                   	push   %ebp
  802ae1:	57                   	push   %edi
  802ae2:	56                   	push   %esi
  802ae3:	53                   	push   %ebx
  802ae4:	83 ec 1c             	sub    $0x1c,%esp
  802ae7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802aeb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802aef:	8b 74 24 30          	mov    0x30(%esp),%esi
  802af3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802af7:	89 da                	mov    %ebx,%edx
  802af9:	85 c0                	test   %eax,%eax
  802afb:	75 43                	jne    802b40 <__umoddi3+0x60>
  802afd:	39 df                	cmp    %ebx,%edi
  802aff:	76 17                	jbe    802b18 <__umoddi3+0x38>
  802b01:	89 f0                	mov    %esi,%eax
  802b03:	f7 f7                	div    %edi
  802b05:	89 d0                	mov    %edx,%eax
  802b07:	31 d2                	xor    %edx,%edx
  802b09:	83 c4 1c             	add    $0x1c,%esp
  802b0c:	5b                   	pop    %ebx
  802b0d:	5e                   	pop    %esi
  802b0e:	5f                   	pop    %edi
  802b0f:	5d                   	pop    %ebp
  802b10:	c3                   	ret    
  802b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b18:	89 fd                	mov    %edi,%ebp
  802b1a:	85 ff                	test   %edi,%edi
  802b1c:	75 0b                	jne    802b29 <__umoddi3+0x49>
  802b1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b23:	31 d2                	xor    %edx,%edx
  802b25:	f7 f7                	div    %edi
  802b27:	89 c5                	mov    %eax,%ebp
  802b29:	89 d8                	mov    %ebx,%eax
  802b2b:	31 d2                	xor    %edx,%edx
  802b2d:	f7 f5                	div    %ebp
  802b2f:	89 f0                	mov    %esi,%eax
  802b31:	f7 f5                	div    %ebp
  802b33:	89 d0                	mov    %edx,%eax
  802b35:	eb d0                	jmp    802b07 <__umoddi3+0x27>
  802b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b3e:	66 90                	xchg   %ax,%ax
  802b40:	89 f1                	mov    %esi,%ecx
  802b42:	39 d8                	cmp    %ebx,%eax
  802b44:	76 0a                	jbe    802b50 <__umoddi3+0x70>
  802b46:	89 f0                	mov    %esi,%eax
  802b48:	83 c4 1c             	add    $0x1c,%esp
  802b4b:	5b                   	pop    %ebx
  802b4c:	5e                   	pop    %esi
  802b4d:	5f                   	pop    %edi
  802b4e:	5d                   	pop    %ebp
  802b4f:	c3                   	ret    
  802b50:	0f bd e8             	bsr    %eax,%ebp
  802b53:	83 f5 1f             	xor    $0x1f,%ebp
  802b56:	75 20                	jne    802b78 <__umoddi3+0x98>
  802b58:	39 d8                	cmp    %ebx,%eax
  802b5a:	0f 82 b0 00 00 00    	jb     802c10 <__umoddi3+0x130>
  802b60:	39 f7                	cmp    %esi,%edi
  802b62:	0f 86 a8 00 00 00    	jbe    802c10 <__umoddi3+0x130>
  802b68:	89 c8                	mov    %ecx,%eax
  802b6a:	83 c4 1c             	add    $0x1c,%esp
  802b6d:	5b                   	pop    %ebx
  802b6e:	5e                   	pop    %esi
  802b6f:	5f                   	pop    %edi
  802b70:	5d                   	pop    %ebp
  802b71:	c3                   	ret    
  802b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b78:	89 e9                	mov    %ebp,%ecx
  802b7a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b7f:	29 ea                	sub    %ebp,%edx
  802b81:	d3 e0                	shl    %cl,%eax
  802b83:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b87:	89 d1                	mov    %edx,%ecx
  802b89:	89 f8                	mov    %edi,%eax
  802b8b:	d3 e8                	shr    %cl,%eax
  802b8d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b91:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b95:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b99:	09 c1                	or     %eax,%ecx
  802b9b:	89 d8                	mov    %ebx,%eax
  802b9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ba1:	89 e9                	mov    %ebp,%ecx
  802ba3:	d3 e7                	shl    %cl,%edi
  802ba5:	89 d1                	mov    %edx,%ecx
  802ba7:	d3 e8                	shr    %cl,%eax
  802ba9:	89 e9                	mov    %ebp,%ecx
  802bab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802baf:	d3 e3                	shl    %cl,%ebx
  802bb1:	89 c7                	mov    %eax,%edi
  802bb3:	89 d1                	mov    %edx,%ecx
  802bb5:	89 f0                	mov    %esi,%eax
  802bb7:	d3 e8                	shr    %cl,%eax
  802bb9:	89 e9                	mov    %ebp,%ecx
  802bbb:	89 fa                	mov    %edi,%edx
  802bbd:	d3 e6                	shl    %cl,%esi
  802bbf:	09 d8                	or     %ebx,%eax
  802bc1:	f7 74 24 08          	divl   0x8(%esp)
  802bc5:	89 d1                	mov    %edx,%ecx
  802bc7:	89 f3                	mov    %esi,%ebx
  802bc9:	f7 64 24 0c          	mull   0xc(%esp)
  802bcd:	89 c6                	mov    %eax,%esi
  802bcf:	89 d7                	mov    %edx,%edi
  802bd1:	39 d1                	cmp    %edx,%ecx
  802bd3:	72 06                	jb     802bdb <__umoddi3+0xfb>
  802bd5:	75 10                	jne    802be7 <__umoddi3+0x107>
  802bd7:	39 c3                	cmp    %eax,%ebx
  802bd9:	73 0c                	jae    802be7 <__umoddi3+0x107>
  802bdb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802bdf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802be3:	89 d7                	mov    %edx,%edi
  802be5:	89 c6                	mov    %eax,%esi
  802be7:	89 ca                	mov    %ecx,%edx
  802be9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bee:	29 f3                	sub    %esi,%ebx
  802bf0:	19 fa                	sbb    %edi,%edx
  802bf2:	89 d0                	mov    %edx,%eax
  802bf4:	d3 e0                	shl    %cl,%eax
  802bf6:	89 e9                	mov    %ebp,%ecx
  802bf8:	d3 eb                	shr    %cl,%ebx
  802bfa:	d3 ea                	shr    %cl,%edx
  802bfc:	09 d8                	or     %ebx,%eax
  802bfe:	83 c4 1c             	add    $0x1c,%esp
  802c01:	5b                   	pop    %ebx
  802c02:	5e                   	pop    %esi
  802c03:	5f                   	pop    %edi
  802c04:	5d                   	pop    %ebp
  802c05:	c3                   	ret    
  802c06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c0d:	8d 76 00             	lea    0x0(%esi),%esi
  802c10:	89 da                	mov    %ebx,%edx
  802c12:	29 fe                	sub    %edi,%esi
  802c14:	19 c2                	sbb    %eax,%edx
  802c16:	89 f1                	mov    %esi,%ecx
  802c18:	89 c8                	mov    %ecx,%eax
  802c1a:	e9 4b ff ff ff       	jmp    802b6a <__umoddi3+0x8a>
