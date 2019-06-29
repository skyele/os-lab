
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 b8 01 00 00       	call   8001e9 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 28             	sub    $0x28,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	68 20 2c 80 00       	push   $0x802c20
  800041:	e8 16 03 00 00       	call   80035c <cprintf>
	if ((r = pipe(p)) < 0)
  800046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 a2 24 00 00       	call   8024f3 <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	78 74                	js     8000cc <umain+0x99>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  800058:	e8 9a 13 00 00       	call   8013f7 <fork>
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	85 c0                	test   %eax,%eax
  800061:	78 7b                	js     8000de <umain+0xab>
		panic("fork: %e", r);
	if (r == 0) {
  800063:	0f 84 87 00 00 00    	je     8000f0 <umain+0xbd>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800069:	89 fb                	mov    %edi,%ebx
  80006b:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  800071:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  800077:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80007d:	8b 43 54             	mov    0x54(%ebx),%eax
  800080:	83 f8 02             	cmp    $0x2,%eax
  800083:	0f 85 e3 00 00 00    	jne    80016c <umain+0x139>
		if (pipeisclosed(p[0]) != 0) {
  800089:	83 ec 0c             	sub    $0xc,%esp
  80008c:	ff 75 e0             	pushl  -0x20(%ebp)
  80008f:	e8 a9 25 00 00       	call   80263d <pipeisclosed>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	85 c0                	test   %eax,%eax
  800099:	74 e2                	je     80007d <umain+0x4a>
			cprintf("\nRACE: pipe appears closed\n");
  80009b:	83 ec 0c             	sub    $0xc,%esp
  80009e:	68 99 2c 80 00       	push   $0x802c99
  8000a3:	e8 b4 02 00 00       	call   80035c <cprintf>
			cprintf("in %s\n", __FUNCTION__);
  8000a8:	83 c4 08             	add    $0x8,%esp
  8000ab:	68 f8 2c 80 00       	push   $0x802cf8
  8000b0:	68 0c 2d 80 00       	push   $0x802d0c
  8000b5:	e8 a2 02 00 00       	call   80035c <cprintf>
			sys_env_destroy(r);
  8000ba:	89 3c 24             	mov    %edi,(%esp)
  8000bd:	e8 6c 0d 00 00       	call   800e2e <sys_env_destroy>
			exit();
  8000c2:	e8 6b 01 00 00       	call   800232 <exit>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	eb b1                	jmp    80007d <umain+0x4a>
		panic("pipe: %e", r);
  8000cc:	50                   	push   %eax
  8000cd:	68 6e 2c 80 00       	push   $0x802c6e
  8000d2:	6a 0d                	push   $0xd
  8000d4:	68 77 2c 80 00       	push   $0x802c77
  8000d9:	e8 88 01 00 00       	call   800266 <_panic>
		panic("fork: %e", r);
  8000de:	50                   	push   %eax
  8000df:	68 8c 2c 80 00       	push   $0x802c8c
  8000e4:	6a 0f                	push   $0xf
  8000e6:	68 77 2c 80 00       	push   $0x802c77
  8000eb:	e8 76 01 00 00       	call   800266 <_panic>
		close(p[1]);
  8000f0:	83 ec 0c             	sub    $0xc,%esp
  8000f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000f6:	e8 3f 17 00 00       	call   80183a <close>
  8000fb:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000fe:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  800100:	be 67 66 66 66       	mov    $0x66666667,%esi
  800105:	eb 42                	jmp    800149 <umain+0x116>
				cprintf("%d.", i);
  800107:	83 ec 08             	sub    $0x8,%esp
  80010a:	53                   	push   %ebx
  80010b:	68 95 2c 80 00       	push   $0x802c95
  800110:	e8 47 02 00 00       	call   80035c <cprintf>
  800115:	83 c4 10             	add    $0x10,%esp
			dup(p[0], 10);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	6a 0a                	push   $0xa
  80011d:	ff 75 e0             	pushl  -0x20(%ebp)
  800120:	e8 67 17 00 00       	call   80188c <dup>
			sys_yield();
  800125:	e8 64 0d 00 00       	call   800e8e <sys_yield>
			close(10);
  80012a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800131:	e8 04 17 00 00       	call   80183a <close>
			sys_yield();
  800136:	e8 53 0d 00 00       	call   800e8e <sys_yield>
		for (i = 0; i < 200; i++) {
  80013b:	83 c3 01             	add    $0x1,%ebx
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800147:	74 19                	je     800162 <umain+0x12f>
			if (i % 10 == 0)
  800149:	89 d8                	mov    %ebx,%eax
  80014b:	f7 ee                	imul   %esi
  80014d:	c1 fa 02             	sar    $0x2,%edx
  800150:	89 d8                	mov    %ebx,%eax
  800152:	c1 f8 1f             	sar    $0x1f,%eax
  800155:	29 c2                	sub    %eax,%edx
  800157:	8d 04 92             	lea    (%edx,%edx,4),%eax
  80015a:	01 c0                	add    %eax,%eax
  80015c:	39 c3                	cmp    %eax,%ebx
  80015e:	75 b8                	jne    800118 <umain+0xe5>
  800160:	eb a5                	jmp    800107 <umain+0xd4>
		exit();
  800162:	e8 cb 00 00 00       	call   800232 <exit>
  800167:	e9 fd fe ff ff       	jmp    800069 <umain+0x36>
		}
	cprintf("child done with loop\n");
  80016c:	83 ec 0c             	sub    $0xc,%esp
  80016f:	68 b5 2c 80 00       	push   $0x802cb5
  800174:	e8 e3 01 00 00       	call   80035c <cprintf>
	if (pipeisclosed(p[0]))
  800179:	83 c4 04             	add    $0x4,%esp
  80017c:	ff 75 e0             	pushl  -0x20(%ebp)
  80017f:	e8 b9 24 00 00       	call   80263d <pipeisclosed>
  800184:	83 c4 10             	add    $0x10,%esp
  800187:	85 c0                	test   %eax,%eax
  800189:	75 38                	jne    8001c3 <umain+0x190>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800191:	50                   	push   %eax
  800192:	ff 75 e0             	pushl  -0x20(%ebp)
  800195:	e8 6e 15 00 00       	call   801708 <fd_lookup>
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	85 c0                	test   %eax,%eax
  80019f:	78 36                	js     8001d7 <umain+0x1a4>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001a7:	e8 f3 14 00 00       	call   80169f <fd2data>
	cprintf("race didn't happen\n");
  8001ac:	c7 04 24 e3 2c 80 00 	movl   $0x802ce3,(%esp)
  8001b3:	e8 a4 01 00 00       	call   80035c <cprintf>
}
  8001b8:	83 c4 10             	add    $0x10,%esp
  8001bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001be:	5b                   	pop    %ebx
  8001bf:	5e                   	pop    %esi
  8001c0:	5f                   	pop    %edi
  8001c1:	5d                   	pop    %ebp
  8001c2:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001c3:	83 ec 04             	sub    $0x4,%esp
  8001c6:	68 44 2c 80 00       	push   $0x802c44
  8001cb:	6a 41                	push   $0x41
  8001cd:	68 77 2c 80 00       	push   $0x802c77
  8001d2:	e8 8f 00 00 00       	call   800266 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001d7:	50                   	push   %eax
  8001d8:	68 cb 2c 80 00       	push   $0x802ccb
  8001dd:	6a 43                	push   $0x43
  8001df:	68 77 2c 80 00       	push   $0x802c77
  8001e4:	e8 7d 00 00 00       	call   800266 <_panic>

008001e9 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001e9:	55                   	push   %ebp
  8001ea:	89 e5                	mov    %esp,%ebp
  8001ec:	56                   	push   %esi
  8001ed:	53                   	push   %ebx
  8001ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001f1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8001f4:	e8 76 0c 00 00       	call   800e6f <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8001f9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001fe:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800204:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800209:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80020e:	85 db                	test   %ebx,%ebx
  800210:	7e 07                	jle    800219 <libmain+0x30>
		binaryname = argv[0];
  800212:	8b 06                	mov    (%esi),%eax
  800214:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	56                   	push   %esi
  80021d:	53                   	push   %ebx
  80021e:	e8 10 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800223:	e8 0a 00 00 00       	call   800232 <exit>
}
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80022e:	5b                   	pop    %ebx
  80022f:	5e                   	pop    %esi
  800230:	5d                   	pop    %ebp
  800231:	c3                   	ret    

00800232 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800238:	a1 08 50 80 00       	mov    0x805008,%eax
  80023d:	8b 40 48             	mov    0x48(%eax),%eax
  800240:	68 14 2d 80 00       	push   $0x802d14
  800245:	50                   	push   %eax
  800246:	68 08 2d 80 00       	push   $0x802d08
  80024b:	e8 0c 01 00 00       	call   80035c <cprintf>
	close_all();
  800250:	e8 12 16 00 00       	call   801867 <close_all>
	sys_env_destroy(0);
  800255:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80025c:	e8 cd 0b 00 00       	call   800e2e <sys_env_destroy>
}
  800261:	83 c4 10             	add    $0x10,%esp
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	56                   	push   %esi
  80026a:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80026b:	a1 08 50 80 00       	mov    0x805008,%eax
  800270:	8b 40 48             	mov    0x48(%eax),%eax
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	68 40 2d 80 00       	push   $0x802d40
  80027b:	50                   	push   %eax
  80027c:	68 08 2d 80 00       	push   $0x802d08
  800281:	e8 d6 00 00 00       	call   80035c <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800286:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800289:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80028f:	e8 db 0b 00 00       	call   800e6f <sys_getenvid>
  800294:	83 c4 04             	add    $0x4,%esp
  800297:	ff 75 0c             	pushl  0xc(%ebp)
  80029a:	ff 75 08             	pushl  0x8(%ebp)
  80029d:	56                   	push   %esi
  80029e:	50                   	push   %eax
  80029f:	68 1c 2d 80 00       	push   $0x802d1c
  8002a4:	e8 b3 00 00 00       	call   80035c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002a9:	83 c4 18             	add    $0x18,%esp
  8002ac:	53                   	push   %ebx
  8002ad:	ff 75 10             	pushl  0x10(%ebp)
  8002b0:	e8 56 00 00 00       	call   80030b <vcprintf>
	cprintf("\n");
  8002b5:	c7 04 24 41 31 80 00 	movl   $0x803141,(%esp)
  8002bc:	e8 9b 00 00 00       	call   80035c <cprintf>
  8002c1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002c4:	cc                   	int3   
  8002c5:	eb fd                	jmp    8002c4 <_panic+0x5e>

008002c7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
  8002ca:	53                   	push   %ebx
  8002cb:	83 ec 04             	sub    $0x4,%esp
  8002ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002d1:	8b 13                	mov    (%ebx),%edx
  8002d3:	8d 42 01             	lea    0x1(%edx),%eax
  8002d6:	89 03                	mov    %eax,(%ebx)
  8002d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002db:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002df:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002e4:	74 09                	je     8002ef <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002e6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ed:	c9                   	leave  
  8002ee:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002ef:	83 ec 08             	sub    $0x8,%esp
  8002f2:	68 ff 00 00 00       	push   $0xff
  8002f7:	8d 43 08             	lea    0x8(%ebx),%eax
  8002fa:	50                   	push   %eax
  8002fb:	e8 f1 0a 00 00       	call   800df1 <sys_cputs>
		b->idx = 0;
  800300:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	eb db                	jmp    8002e6 <putch+0x1f>

0080030b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800314:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80031b:	00 00 00 
	b.cnt = 0;
  80031e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800325:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800328:	ff 75 0c             	pushl  0xc(%ebp)
  80032b:	ff 75 08             	pushl  0x8(%ebp)
  80032e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800334:	50                   	push   %eax
  800335:	68 c7 02 80 00       	push   $0x8002c7
  80033a:	e8 4a 01 00 00       	call   800489 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80033f:	83 c4 08             	add    $0x8,%esp
  800342:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800348:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80034e:	50                   	push   %eax
  80034f:	e8 9d 0a 00 00       	call   800df1 <sys_cputs>

	return b.cnt;
}
  800354:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800362:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800365:	50                   	push   %eax
  800366:	ff 75 08             	pushl  0x8(%ebp)
  800369:	e8 9d ff ff ff       	call   80030b <vcprintf>
	va_end(ap);

	return cnt;
}
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	57                   	push   %edi
  800374:	56                   	push   %esi
  800375:	53                   	push   %ebx
  800376:	83 ec 1c             	sub    $0x1c,%esp
  800379:	89 c6                	mov    %eax,%esi
  80037b:	89 d7                	mov    %edx,%edi
  80037d:	8b 45 08             	mov    0x8(%ebp),%eax
  800380:	8b 55 0c             	mov    0xc(%ebp),%edx
  800383:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800386:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800389:	8b 45 10             	mov    0x10(%ebp),%eax
  80038c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80038f:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800393:	74 2c                	je     8003c1 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800395:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800398:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80039f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003a2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003a5:	39 c2                	cmp    %eax,%edx
  8003a7:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003aa:	73 43                	jae    8003ef <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8003ac:	83 eb 01             	sub    $0x1,%ebx
  8003af:	85 db                	test   %ebx,%ebx
  8003b1:	7e 6c                	jle    80041f <printnum+0xaf>
				putch(padc, putdat);
  8003b3:	83 ec 08             	sub    $0x8,%esp
  8003b6:	57                   	push   %edi
  8003b7:	ff 75 18             	pushl  0x18(%ebp)
  8003ba:	ff d6                	call   *%esi
  8003bc:	83 c4 10             	add    $0x10,%esp
  8003bf:	eb eb                	jmp    8003ac <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003c1:	83 ec 0c             	sub    $0xc,%esp
  8003c4:	6a 20                	push   $0x20
  8003c6:	6a 00                	push   $0x0
  8003c8:	50                   	push   %eax
  8003c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8003cf:	89 fa                	mov    %edi,%edx
  8003d1:	89 f0                	mov    %esi,%eax
  8003d3:	e8 98 ff ff ff       	call   800370 <printnum>
		while (--width > 0)
  8003d8:	83 c4 20             	add    $0x20,%esp
  8003db:	83 eb 01             	sub    $0x1,%ebx
  8003de:	85 db                	test   %ebx,%ebx
  8003e0:	7e 65                	jle    800447 <printnum+0xd7>
			putch(padc, putdat);
  8003e2:	83 ec 08             	sub    $0x8,%esp
  8003e5:	57                   	push   %edi
  8003e6:	6a 20                	push   $0x20
  8003e8:	ff d6                	call   *%esi
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	eb ec                	jmp    8003db <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ef:	83 ec 0c             	sub    $0xc,%esp
  8003f2:	ff 75 18             	pushl  0x18(%ebp)
  8003f5:	83 eb 01             	sub    $0x1,%ebx
  8003f8:	53                   	push   %ebx
  8003f9:	50                   	push   %eax
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	ff 75 dc             	pushl  -0x24(%ebp)
  800400:	ff 75 d8             	pushl  -0x28(%ebp)
  800403:	ff 75 e4             	pushl  -0x1c(%ebp)
  800406:	ff 75 e0             	pushl  -0x20(%ebp)
  800409:	e8 b2 25 00 00       	call   8029c0 <__udivdi3>
  80040e:	83 c4 18             	add    $0x18,%esp
  800411:	52                   	push   %edx
  800412:	50                   	push   %eax
  800413:	89 fa                	mov    %edi,%edx
  800415:	89 f0                	mov    %esi,%eax
  800417:	e8 54 ff ff ff       	call   800370 <printnum>
  80041c:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80041f:	83 ec 08             	sub    $0x8,%esp
  800422:	57                   	push   %edi
  800423:	83 ec 04             	sub    $0x4,%esp
  800426:	ff 75 dc             	pushl  -0x24(%ebp)
  800429:	ff 75 d8             	pushl  -0x28(%ebp)
  80042c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80042f:	ff 75 e0             	pushl  -0x20(%ebp)
  800432:	e8 99 26 00 00       	call   802ad0 <__umoddi3>
  800437:	83 c4 14             	add    $0x14,%esp
  80043a:	0f be 80 47 2d 80 00 	movsbl 0x802d47(%eax),%eax
  800441:	50                   	push   %eax
  800442:	ff d6                	call   *%esi
  800444:	83 c4 10             	add    $0x10,%esp
	}
}
  800447:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80044a:	5b                   	pop    %ebx
  80044b:	5e                   	pop    %esi
  80044c:	5f                   	pop    %edi
  80044d:	5d                   	pop    %ebp
  80044e:	c3                   	ret    

0080044f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80044f:	55                   	push   %ebp
  800450:	89 e5                	mov    %esp,%ebp
  800452:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800455:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800459:	8b 10                	mov    (%eax),%edx
  80045b:	3b 50 04             	cmp    0x4(%eax),%edx
  80045e:	73 0a                	jae    80046a <sprintputch+0x1b>
		*b->buf++ = ch;
  800460:	8d 4a 01             	lea    0x1(%edx),%ecx
  800463:	89 08                	mov    %ecx,(%eax)
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	88 02                	mov    %al,(%edx)
}
  80046a:	5d                   	pop    %ebp
  80046b:	c3                   	ret    

0080046c <printfmt>:
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800472:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800475:	50                   	push   %eax
  800476:	ff 75 10             	pushl  0x10(%ebp)
  800479:	ff 75 0c             	pushl  0xc(%ebp)
  80047c:	ff 75 08             	pushl  0x8(%ebp)
  80047f:	e8 05 00 00 00       	call   800489 <vprintfmt>
}
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	c9                   	leave  
  800488:	c3                   	ret    

00800489 <vprintfmt>:
{
  800489:	55                   	push   %ebp
  80048a:	89 e5                	mov    %esp,%ebp
  80048c:	57                   	push   %edi
  80048d:	56                   	push   %esi
  80048e:	53                   	push   %ebx
  80048f:	83 ec 3c             	sub    $0x3c,%esp
  800492:	8b 75 08             	mov    0x8(%ebp),%esi
  800495:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800498:	8b 7d 10             	mov    0x10(%ebp),%edi
  80049b:	e9 32 04 00 00       	jmp    8008d2 <vprintfmt+0x449>
		padc = ' ';
  8004a0:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8004a4:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8004ab:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8004b2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004b9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004c0:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004c7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004cc:	8d 47 01             	lea    0x1(%edi),%eax
  8004cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004d2:	0f b6 17             	movzbl (%edi),%edx
  8004d5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004d8:	3c 55                	cmp    $0x55,%al
  8004da:	0f 87 12 05 00 00    	ja     8009f2 <vprintfmt+0x569>
  8004e0:	0f b6 c0             	movzbl %al,%eax
  8004e3:	ff 24 85 20 2f 80 00 	jmp    *0x802f20(,%eax,4)
  8004ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004ed:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8004f1:	eb d9                	jmp    8004cc <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004f6:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004fa:	eb d0                	jmp    8004cc <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004fc:	0f b6 d2             	movzbl %dl,%edx
  8004ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800502:	b8 00 00 00 00       	mov    $0x0,%eax
  800507:	89 75 08             	mov    %esi,0x8(%ebp)
  80050a:	eb 03                	jmp    80050f <vprintfmt+0x86>
  80050c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80050f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800512:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800516:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800519:	8d 72 d0             	lea    -0x30(%edx),%esi
  80051c:	83 fe 09             	cmp    $0x9,%esi
  80051f:	76 eb                	jbe    80050c <vprintfmt+0x83>
  800521:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800524:	8b 75 08             	mov    0x8(%ebp),%esi
  800527:	eb 14                	jmp    80053d <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	8b 00                	mov    (%eax),%eax
  80052e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8d 40 04             	lea    0x4(%eax),%eax
  800537:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80053a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80053d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800541:	79 89                	jns    8004cc <vprintfmt+0x43>
				width = precision, precision = -1;
  800543:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800546:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800549:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800550:	e9 77 ff ff ff       	jmp    8004cc <vprintfmt+0x43>
  800555:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800558:	85 c0                	test   %eax,%eax
  80055a:	0f 48 c1             	cmovs  %ecx,%eax
  80055d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800560:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800563:	e9 64 ff ff ff       	jmp    8004cc <vprintfmt+0x43>
  800568:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80056b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800572:	e9 55 ff ff ff       	jmp    8004cc <vprintfmt+0x43>
			lflag++;
  800577:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80057b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80057e:	e9 49 ff ff ff       	jmp    8004cc <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	8d 78 04             	lea    0x4(%eax),%edi
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	53                   	push   %ebx
  80058d:	ff 30                	pushl  (%eax)
  80058f:	ff d6                	call   *%esi
			break;
  800591:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800594:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800597:	e9 33 03 00 00       	jmp    8008cf <vprintfmt+0x446>
			err = va_arg(ap, int);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8d 78 04             	lea    0x4(%eax),%edi
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	99                   	cltd   
  8005a5:	31 d0                	xor    %edx,%eax
  8005a7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005a9:	83 f8 11             	cmp    $0x11,%eax
  8005ac:	7f 23                	jg     8005d1 <vprintfmt+0x148>
  8005ae:	8b 14 85 80 30 80 00 	mov    0x803080(,%eax,4),%edx
  8005b5:	85 d2                	test   %edx,%edx
  8005b7:	74 18                	je     8005d1 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005b9:	52                   	push   %edx
  8005ba:	68 8d 32 80 00       	push   $0x80328d
  8005bf:	53                   	push   %ebx
  8005c0:	56                   	push   %esi
  8005c1:	e8 a6 fe ff ff       	call   80046c <printfmt>
  8005c6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005c9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005cc:	e9 fe 02 00 00       	jmp    8008cf <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005d1:	50                   	push   %eax
  8005d2:	68 5f 2d 80 00       	push   $0x802d5f
  8005d7:	53                   	push   %ebx
  8005d8:	56                   	push   %esi
  8005d9:	e8 8e fe ff ff       	call   80046c <printfmt>
  8005de:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005e1:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005e4:	e9 e6 02 00 00       	jmp    8008cf <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	83 c0 04             	add    $0x4,%eax
  8005ef:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005f7:	85 c9                	test   %ecx,%ecx
  8005f9:	b8 58 2d 80 00       	mov    $0x802d58,%eax
  8005fe:	0f 45 c1             	cmovne %ecx,%eax
  800601:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800604:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800608:	7e 06                	jle    800610 <vprintfmt+0x187>
  80060a:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80060e:	75 0d                	jne    80061d <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800610:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800613:	89 c7                	mov    %eax,%edi
  800615:	03 45 e0             	add    -0x20(%ebp),%eax
  800618:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80061b:	eb 53                	jmp    800670 <vprintfmt+0x1e7>
  80061d:	83 ec 08             	sub    $0x8,%esp
  800620:	ff 75 d8             	pushl  -0x28(%ebp)
  800623:	50                   	push   %eax
  800624:	e8 71 04 00 00       	call   800a9a <strnlen>
  800629:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80062c:	29 c1                	sub    %eax,%ecx
  80062e:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800636:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80063a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80063d:	eb 0f                	jmp    80064e <vprintfmt+0x1c5>
					putch(padc, putdat);
  80063f:	83 ec 08             	sub    $0x8,%esp
  800642:	53                   	push   %ebx
  800643:	ff 75 e0             	pushl  -0x20(%ebp)
  800646:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800648:	83 ef 01             	sub    $0x1,%edi
  80064b:	83 c4 10             	add    $0x10,%esp
  80064e:	85 ff                	test   %edi,%edi
  800650:	7f ed                	jg     80063f <vprintfmt+0x1b6>
  800652:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800655:	85 c9                	test   %ecx,%ecx
  800657:	b8 00 00 00 00       	mov    $0x0,%eax
  80065c:	0f 49 c1             	cmovns %ecx,%eax
  80065f:	29 c1                	sub    %eax,%ecx
  800661:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800664:	eb aa                	jmp    800610 <vprintfmt+0x187>
					putch(ch, putdat);
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	53                   	push   %ebx
  80066a:	52                   	push   %edx
  80066b:	ff d6                	call   *%esi
  80066d:	83 c4 10             	add    $0x10,%esp
  800670:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800673:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800675:	83 c7 01             	add    $0x1,%edi
  800678:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80067c:	0f be d0             	movsbl %al,%edx
  80067f:	85 d2                	test   %edx,%edx
  800681:	74 4b                	je     8006ce <vprintfmt+0x245>
  800683:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800687:	78 06                	js     80068f <vprintfmt+0x206>
  800689:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80068d:	78 1e                	js     8006ad <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80068f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800693:	74 d1                	je     800666 <vprintfmt+0x1dd>
  800695:	0f be c0             	movsbl %al,%eax
  800698:	83 e8 20             	sub    $0x20,%eax
  80069b:	83 f8 5e             	cmp    $0x5e,%eax
  80069e:	76 c6                	jbe    800666 <vprintfmt+0x1dd>
					putch('?', putdat);
  8006a0:	83 ec 08             	sub    $0x8,%esp
  8006a3:	53                   	push   %ebx
  8006a4:	6a 3f                	push   $0x3f
  8006a6:	ff d6                	call   *%esi
  8006a8:	83 c4 10             	add    $0x10,%esp
  8006ab:	eb c3                	jmp    800670 <vprintfmt+0x1e7>
  8006ad:	89 cf                	mov    %ecx,%edi
  8006af:	eb 0e                	jmp    8006bf <vprintfmt+0x236>
				putch(' ', putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	53                   	push   %ebx
  8006b5:	6a 20                	push   $0x20
  8006b7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006b9:	83 ef 01             	sub    $0x1,%edi
  8006bc:	83 c4 10             	add    $0x10,%esp
  8006bf:	85 ff                	test   %edi,%edi
  8006c1:	7f ee                	jg     8006b1 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006c3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c9:	e9 01 02 00 00       	jmp    8008cf <vprintfmt+0x446>
  8006ce:	89 cf                	mov    %ecx,%edi
  8006d0:	eb ed                	jmp    8006bf <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006d5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006dc:	e9 eb fd ff ff       	jmp    8004cc <vprintfmt+0x43>
	if (lflag >= 2)
  8006e1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006e5:	7f 21                	jg     800708 <vprintfmt+0x27f>
	else if (lflag)
  8006e7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006eb:	74 68                	je     800755 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006f5:	89 c1                	mov    %eax,%ecx
  8006f7:	c1 f9 1f             	sar    $0x1f,%ecx
  8006fa:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8d 40 04             	lea    0x4(%eax),%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
  800706:	eb 17                	jmp    80071f <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8b 50 04             	mov    0x4(%eax),%edx
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800713:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8d 40 08             	lea    0x8(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80071f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800722:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800725:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800728:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80072b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80072f:	78 3f                	js     800770 <vprintfmt+0x2e7>
			base = 10;
  800731:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800736:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80073a:	0f 84 71 01 00 00    	je     8008b1 <vprintfmt+0x428>
				putch('+', putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	53                   	push   %ebx
  800744:	6a 2b                	push   $0x2b
  800746:	ff d6                	call   *%esi
  800748:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80074b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800750:	e9 5c 01 00 00       	jmp    8008b1 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800755:	8b 45 14             	mov    0x14(%ebp),%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80075d:	89 c1                	mov    %eax,%ecx
  80075f:	c1 f9 1f             	sar    $0x1f,%ecx
  800762:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8d 40 04             	lea    0x4(%eax),%eax
  80076b:	89 45 14             	mov    %eax,0x14(%ebp)
  80076e:	eb af                	jmp    80071f <vprintfmt+0x296>
				putch('-', putdat);
  800770:	83 ec 08             	sub    $0x8,%esp
  800773:	53                   	push   %ebx
  800774:	6a 2d                	push   $0x2d
  800776:	ff d6                	call   *%esi
				num = -(long long) num;
  800778:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80077b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80077e:	f7 d8                	neg    %eax
  800780:	83 d2 00             	adc    $0x0,%edx
  800783:	f7 da                	neg    %edx
  800785:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800788:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80078e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800793:	e9 19 01 00 00       	jmp    8008b1 <vprintfmt+0x428>
	if (lflag >= 2)
  800798:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80079c:	7f 29                	jg     8007c7 <vprintfmt+0x33e>
	else if (lflag)
  80079e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007a2:	74 44                	je     8007e8 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	8d 40 04             	lea    0x4(%eax),%eax
  8007ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007bd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c2:	e9 ea 00 00 00       	jmp    8008b1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8b 50 04             	mov    0x4(%eax),%edx
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8d 40 08             	lea    0x8(%eax),%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007de:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e3:	e9 c9 00 00 00       	jmp    8008b1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	8d 40 04             	lea    0x4(%eax),%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800801:	b8 0a 00 00 00       	mov    $0xa,%eax
  800806:	e9 a6 00 00 00       	jmp    8008b1 <vprintfmt+0x428>
			putch('0', putdat);
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	53                   	push   %ebx
  80080f:	6a 30                	push   $0x30
  800811:	ff d6                	call   *%esi
	if (lflag >= 2)
  800813:	83 c4 10             	add    $0x10,%esp
  800816:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80081a:	7f 26                	jg     800842 <vprintfmt+0x3b9>
	else if (lflag)
  80081c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800820:	74 3e                	je     800860 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	8b 00                	mov    (%eax),%eax
  800827:	ba 00 00 00 00       	mov    $0x0,%edx
  80082c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	8d 40 04             	lea    0x4(%eax),%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80083b:	b8 08 00 00 00       	mov    $0x8,%eax
  800840:	eb 6f                	jmp    8008b1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	8b 50 04             	mov    0x4(%eax),%edx
  800848:	8b 00                	mov    (%eax),%eax
  80084a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	8d 40 08             	lea    0x8(%eax),%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800859:	b8 08 00 00 00       	mov    $0x8,%eax
  80085e:	eb 51                	jmp    8008b1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	8b 00                	mov    (%eax),%eax
  800865:	ba 00 00 00 00       	mov    $0x0,%edx
  80086a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	8d 40 04             	lea    0x4(%eax),%eax
  800876:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800879:	b8 08 00 00 00       	mov    $0x8,%eax
  80087e:	eb 31                	jmp    8008b1 <vprintfmt+0x428>
			putch('0', putdat);
  800880:	83 ec 08             	sub    $0x8,%esp
  800883:	53                   	push   %ebx
  800884:	6a 30                	push   $0x30
  800886:	ff d6                	call   *%esi
			putch('x', putdat);
  800888:	83 c4 08             	add    $0x8,%esp
  80088b:	53                   	push   %ebx
  80088c:	6a 78                	push   $0x78
  80088e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800890:	8b 45 14             	mov    0x14(%ebp),%eax
  800893:	8b 00                	mov    (%eax),%eax
  800895:	ba 00 00 00 00       	mov    $0x0,%edx
  80089a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008a0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a6:	8d 40 04             	lea    0x4(%eax),%eax
  8008a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ac:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008b1:	83 ec 0c             	sub    $0xc,%esp
  8008b4:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008b8:	52                   	push   %edx
  8008b9:	ff 75 e0             	pushl  -0x20(%ebp)
  8008bc:	50                   	push   %eax
  8008bd:	ff 75 dc             	pushl  -0x24(%ebp)
  8008c0:	ff 75 d8             	pushl  -0x28(%ebp)
  8008c3:	89 da                	mov    %ebx,%edx
  8008c5:	89 f0                	mov    %esi,%eax
  8008c7:	e8 a4 fa ff ff       	call   800370 <printnum>
			break;
  8008cc:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d2:	83 c7 01             	add    $0x1,%edi
  8008d5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008d9:	83 f8 25             	cmp    $0x25,%eax
  8008dc:	0f 84 be fb ff ff    	je     8004a0 <vprintfmt+0x17>
			if (ch == '\0')
  8008e2:	85 c0                	test   %eax,%eax
  8008e4:	0f 84 28 01 00 00    	je     800a12 <vprintfmt+0x589>
			putch(ch, putdat);
  8008ea:	83 ec 08             	sub    $0x8,%esp
  8008ed:	53                   	push   %ebx
  8008ee:	50                   	push   %eax
  8008ef:	ff d6                	call   *%esi
  8008f1:	83 c4 10             	add    $0x10,%esp
  8008f4:	eb dc                	jmp    8008d2 <vprintfmt+0x449>
	if (lflag >= 2)
  8008f6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008fa:	7f 26                	jg     800922 <vprintfmt+0x499>
	else if (lflag)
  8008fc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800900:	74 41                	je     800943 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	8b 00                	mov    (%eax),%eax
  800907:	ba 00 00 00 00       	mov    $0x0,%edx
  80090c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80090f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	8d 40 04             	lea    0x4(%eax),%eax
  800918:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80091b:	b8 10 00 00 00       	mov    $0x10,%eax
  800920:	eb 8f                	jmp    8008b1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800922:	8b 45 14             	mov    0x14(%ebp),%eax
  800925:	8b 50 04             	mov    0x4(%eax),%edx
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	8d 40 08             	lea    0x8(%eax),%eax
  800936:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800939:	b8 10 00 00 00       	mov    $0x10,%eax
  80093e:	e9 6e ff ff ff       	jmp    8008b1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	ba 00 00 00 00       	mov    $0x0,%edx
  80094d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800950:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800953:	8b 45 14             	mov    0x14(%ebp),%eax
  800956:	8d 40 04             	lea    0x4(%eax),%eax
  800959:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80095c:	b8 10 00 00 00       	mov    $0x10,%eax
  800961:	e9 4b ff ff ff       	jmp    8008b1 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800966:	8b 45 14             	mov    0x14(%ebp),%eax
  800969:	83 c0 04             	add    $0x4,%eax
  80096c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80096f:	8b 45 14             	mov    0x14(%ebp),%eax
  800972:	8b 00                	mov    (%eax),%eax
  800974:	85 c0                	test   %eax,%eax
  800976:	74 14                	je     80098c <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800978:	8b 13                	mov    (%ebx),%edx
  80097a:	83 fa 7f             	cmp    $0x7f,%edx
  80097d:	7f 37                	jg     8009b6 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80097f:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800981:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800984:	89 45 14             	mov    %eax,0x14(%ebp)
  800987:	e9 43 ff ff ff       	jmp    8008cf <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80098c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800991:	bf 7d 2e 80 00       	mov    $0x802e7d,%edi
							putch(ch, putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	53                   	push   %ebx
  80099a:	50                   	push   %eax
  80099b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80099d:	83 c7 01             	add    $0x1,%edi
  8009a0:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009a4:	83 c4 10             	add    $0x10,%esp
  8009a7:	85 c0                	test   %eax,%eax
  8009a9:	75 eb                	jne    800996 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8009ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b1:	e9 19 ff ff ff       	jmp    8008cf <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009b6:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009b8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009bd:	bf b5 2e 80 00       	mov    $0x802eb5,%edi
							putch(ch, putdat);
  8009c2:	83 ec 08             	sub    $0x8,%esp
  8009c5:	53                   	push   %ebx
  8009c6:	50                   	push   %eax
  8009c7:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009c9:	83 c7 01             	add    $0x1,%edi
  8009cc:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009d0:	83 c4 10             	add    $0x10,%esp
  8009d3:	85 c0                	test   %eax,%eax
  8009d5:	75 eb                	jne    8009c2 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009da:	89 45 14             	mov    %eax,0x14(%ebp)
  8009dd:	e9 ed fe ff ff       	jmp    8008cf <vprintfmt+0x446>
			putch(ch, putdat);
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	53                   	push   %ebx
  8009e6:	6a 25                	push   $0x25
  8009e8:	ff d6                	call   *%esi
			break;
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	e9 dd fe ff ff       	jmp    8008cf <vprintfmt+0x446>
			putch('%', putdat);
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	53                   	push   %ebx
  8009f6:	6a 25                	push   $0x25
  8009f8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	89 f8                	mov    %edi,%eax
  8009ff:	eb 03                	jmp    800a04 <vprintfmt+0x57b>
  800a01:	83 e8 01             	sub    $0x1,%eax
  800a04:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a08:	75 f7                	jne    800a01 <vprintfmt+0x578>
  800a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a0d:	e9 bd fe ff ff       	jmp    8008cf <vprintfmt+0x446>
}
  800a12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a15:	5b                   	pop    %ebx
  800a16:	5e                   	pop    %esi
  800a17:	5f                   	pop    %edi
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    

00800a1a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	83 ec 18             	sub    $0x18,%esp
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a26:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a29:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a2d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a37:	85 c0                	test   %eax,%eax
  800a39:	74 26                	je     800a61 <vsnprintf+0x47>
  800a3b:	85 d2                	test   %edx,%edx
  800a3d:	7e 22                	jle    800a61 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a3f:	ff 75 14             	pushl  0x14(%ebp)
  800a42:	ff 75 10             	pushl  0x10(%ebp)
  800a45:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a48:	50                   	push   %eax
  800a49:	68 4f 04 80 00       	push   $0x80044f
  800a4e:	e8 36 fa ff ff       	call   800489 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a56:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a5c:	83 c4 10             	add    $0x10,%esp
}
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    
		return -E_INVAL;
  800a61:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a66:	eb f7                	jmp    800a5f <vsnprintf+0x45>

00800a68 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a6e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a71:	50                   	push   %eax
  800a72:	ff 75 10             	pushl  0x10(%ebp)
  800a75:	ff 75 0c             	pushl  0xc(%ebp)
  800a78:	ff 75 08             	pushl  0x8(%ebp)
  800a7b:	e8 9a ff ff ff       	call   800a1a <vsnprintf>
	va_end(ap);

	return rc;
}
  800a80:	c9                   	leave  
  800a81:	c3                   	ret    

00800a82 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a88:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a91:	74 05                	je     800a98 <strlen+0x16>
		n++;
  800a93:	83 c0 01             	add    $0x1,%eax
  800a96:	eb f5                	jmp    800a8d <strlen+0xb>
	return n;
}
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    

00800a9a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aa3:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa8:	39 c2                	cmp    %eax,%edx
  800aaa:	74 0d                	je     800ab9 <strnlen+0x1f>
  800aac:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ab0:	74 05                	je     800ab7 <strnlen+0x1d>
		n++;
  800ab2:	83 c2 01             	add    $0x1,%edx
  800ab5:	eb f1                	jmp    800aa8 <strnlen+0xe>
  800ab7:	89 d0                	mov    %edx,%eax
	return n;
}
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	53                   	push   %ebx
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ac5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aca:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ace:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ad1:	83 c2 01             	add    $0x1,%edx
  800ad4:	84 c9                	test   %cl,%cl
  800ad6:	75 f2                	jne    800aca <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ad8:	5b                   	pop    %ebx
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <strcat>:

char *
strcat(char *dst, const char *src)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	53                   	push   %ebx
  800adf:	83 ec 10             	sub    $0x10,%esp
  800ae2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ae5:	53                   	push   %ebx
  800ae6:	e8 97 ff ff ff       	call   800a82 <strlen>
  800aeb:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800aee:	ff 75 0c             	pushl  0xc(%ebp)
  800af1:	01 d8                	add    %ebx,%eax
  800af3:	50                   	push   %eax
  800af4:	e8 c2 ff ff ff       	call   800abb <strcpy>
	return dst;
}
  800af9:	89 d8                	mov    %ebx,%eax
  800afb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800afe:	c9                   	leave  
  800aff:	c3                   	ret    

00800b00 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	56                   	push   %esi
  800b04:	53                   	push   %ebx
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b0b:	89 c6                	mov    %eax,%esi
  800b0d:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b10:	89 c2                	mov    %eax,%edx
  800b12:	39 f2                	cmp    %esi,%edx
  800b14:	74 11                	je     800b27 <strncpy+0x27>
		*dst++ = *src;
  800b16:	83 c2 01             	add    $0x1,%edx
  800b19:	0f b6 19             	movzbl (%ecx),%ebx
  800b1c:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b1f:	80 fb 01             	cmp    $0x1,%bl
  800b22:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b25:	eb eb                	jmp    800b12 <strncpy+0x12>
	}
	return ret;
}
  800b27:	5b                   	pop    %ebx
  800b28:	5e                   	pop    %esi
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	56                   	push   %esi
  800b2f:	53                   	push   %ebx
  800b30:	8b 75 08             	mov    0x8(%ebp),%esi
  800b33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b36:	8b 55 10             	mov    0x10(%ebp),%edx
  800b39:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b3b:	85 d2                	test   %edx,%edx
  800b3d:	74 21                	je     800b60 <strlcpy+0x35>
  800b3f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b43:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b45:	39 c2                	cmp    %eax,%edx
  800b47:	74 14                	je     800b5d <strlcpy+0x32>
  800b49:	0f b6 19             	movzbl (%ecx),%ebx
  800b4c:	84 db                	test   %bl,%bl
  800b4e:	74 0b                	je     800b5b <strlcpy+0x30>
			*dst++ = *src++;
  800b50:	83 c1 01             	add    $0x1,%ecx
  800b53:	83 c2 01             	add    $0x1,%edx
  800b56:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b59:	eb ea                	jmp    800b45 <strlcpy+0x1a>
  800b5b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b5d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b60:	29 f0                	sub    %esi,%eax
}
  800b62:	5b                   	pop    %ebx
  800b63:	5e                   	pop    %esi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b6f:	0f b6 01             	movzbl (%ecx),%eax
  800b72:	84 c0                	test   %al,%al
  800b74:	74 0c                	je     800b82 <strcmp+0x1c>
  800b76:	3a 02                	cmp    (%edx),%al
  800b78:	75 08                	jne    800b82 <strcmp+0x1c>
		p++, q++;
  800b7a:	83 c1 01             	add    $0x1,%ecx
  800b7d:	83 c2 01             	add    $0x1,%edx
  800b80:	eb ed                	jmp    800b6f <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b82:	0f b6 c0             	movzbl %al,%eax
  800b85:	0f b6 12             	movzbl (%edx),%edx
  800b88:	29 d0                	sub    %edx,%eax
}
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	53                   	push   %ebx
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b96:	89 c3                	mov    %eax,%ebx
  800b98:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b9b:	eb 06                	jmp    800ba3 <strncmp+0x17>
		n--, p++, q++;
  800b9d:	83 c0 01             	add    $0x1,%eax
  800ba0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ba3:	39 d8                	cmp    %ebx,%eax
  800ba5:	74 16                	je     800bbd <strncmp+0x31>
  800ba7:	0f b6 08             	movzbl (%eax),%ecx
  800baa:	84 c9                	test   %cl,%cl
  800bac:	74 04                	je     800bb2 <strncmp+0x26>
  800bae:	3a 0a                	cmp    (%edx),%cl
  800bb0:	74 eb                	je     800b9d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bb2:	0f b6 00             	movzbl (%eax),%eax
  800bb5:	0f b6 12             	movzbl (%edx),%edx
  800bb8:	29 d0                	sub    %edx,%eax
}
  800bba:	5b                   	pop    %ebx
  800bbb:	5d                   	pop    %ebp
  800bbc:	c3                   	ret    
		return 0;
  800bbd:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc2:	eb f6                	jmp    800bba <strncmp+0x2e>

00800bc4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bce:	0f b6 10             	movzbl (%eax),%edx
  800bd1:	84 d2                	test   %dl,%dl
  800bd3:	74 09                	je     800bde <strchr+0x1a>
		if (*s == c)
  800bd5:	38 ca                	cmp    %cl,%dl
  800bd7:	74 0a                	je     800be3 <strchr+0x1f>
	for (; *s; s++)
  800bd9:	83 c0 01             	add    $0x1,%eax
  800bdc:	eb f0                	jmp    800bce <strchr+0xa>
			return (char *) s;
	return 0;
  800bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bef:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bf2:	38 ca                	cmp    %cl,%dl
  800bf4:	74 09                	je     800bff <strfind+0x1a>
  800bf6:	84 d2                	test   %dl,%dl
  800bf8:	74 05                	je     800bff <strfind+0x1a>
	for (; *s; s++)
  800bfa:	83 c0 01             	add    $0x1,%eax
  800bfd:	eb f0                	jmp    800bef <strfind+0xa>
			break;
	return (char *) s;
}
  800bff:	5d                   	pop    %ebp
  800c00:	c3                   	ret    

00800c01 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
  800c04:	57                   	push   %edi
  800c05:	56                   	push   %esi
  800c06:	53                   	push   %ebx
  800c07:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c0d:	85 c9                	test   %ecx,%ecx
  800c0f:	74 31                	je     800c42 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c11:	89 f8                	mov    %edi,%eax
  800c13:	09 c8                	or     %ecx,%eax
  800c15:	a8 03                	test   $0x3,%al
  800c17:	75 23                	jne    800c3c <memset+0x3b>
		c &= 0xFF;
  800c19:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c1d:	89 d3                	mov    %edx,%ebx
  800c1f:	c1 e3 08             	shl    $0x8,%ebx
  800c22:	89 d0                	mov    %edx,%eax
  800c24:	c1 e0 18             	shl    $0x18,%eax
  800c27:	89 d6                	mov    %edx,%esi
  800c29:	c1 e6 10             	shl    $0x10,%esi
  800c2c:	09 f0                	or     %esi,%eax
  800c2e:	09 c2                	or     %eax,%edx
  800c30:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c32:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c35:	89 d0                	mov    %edx,%eax
  800c37:	fc                   	cld    
  800c38:	f3 ab                	rep stos %eax,%es:(%edi)
  800c3a:	eb 06                	jmp    800c42 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3f:	fc                   	cld    
  800c40:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c42:	89 f8                	mov    %edi,%eax
  800c44:	5b                   	pop    %ebx
  800c45:	5e                   	pop    %esi
  800c46:	5f                   	pop    %edi
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	57                   	push   %edi
  800c4d:	56                   	push   %esi
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c54:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c57:	39 c6                	cmp    %eax,%esi
  800c59:	73 32                	jae    800c8d <memmove+0x44>
  800c5b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c5e:	39 c2                	cmp    %eax,%edx
  800c60:	76 2b                	jbe    800c8d <memmove+0x44>
		s += n;
		d += n;
  800c62:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c65:	89 fe                	mov    %edi,%esi
  800c67:	09 ce                	or     %ecx,%esi
  800c69:	09 d6                	or     %edx,%esi
  800c6b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c71:	75 0e                	jne    800c81 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c73:	83 ef 04             	sub    $0x4,%edi
  800c76:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c79:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c7c:	fd                   	std    
  800c7d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c7f:	eb 09                	jmp    800c8a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c81:	83 ef 01             	sub    $0x1,%edi
  800c84:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c87:	fd                   	std    
  800c88:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c8a:	fc                   	cld    
  800c8b:	eb 1a                	jmp    800ca7 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c8d:	89 c2                	mov    %eax,%edx
  800c8f:	09 ca                	or     %ecx,%edx
  800c91:	09 f2                	or     %esi,%edx
  800c93:	f6 c2 03             	test   $0x3,%dl
  800c96:	75 0a                	jne    800ca2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c98:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c9b:	89 c7                	mov    %eax,%edi
  800c9d:	fc                   	cld    
  800c9e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca0:	eb 05                	jmp    800ca7 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ca2:	89 c7                	mov    %eax,%edi
  800ca4:	fc                   	cld    
  800ca5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    

00800cab <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cb1:	ff 75 10             	pushl  0x10(%ebp)
  800cb4:	ff 75 0c             	pushl  0xc(%ebp)
  800cb7:	ff 75 08             	pushl  0x8(%ebp)
  800cba:	e8 8a ff ff ff       	call   800c49 <memmove>
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	56                   	push   %esi
  800cc5:	53                   	push   %ebx
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccc:	89 c6                	mov    %eax,%esi
  800cce:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cd1:	39 f0                	cmp    %esi,%eax
  800cd3:	74 1c                	je     800cf1 <memcmp+0x30>
		if (*s1 != *s2)
  800cd5:	0f b6 08             	movzbl (%eax),%ecx
  800cd8:	0f b6 1a             	movzbl (%edx),%ebx
  800cdb:	38 d9                	cmp    %bl,%cl
  800cdd:	75 08                	jne    800ce7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cdf:	83 c0 01             	add    $0x1,%eax
  800ce2:	83 c2 01             	add    $0x1,%edx
  800ce5:	eb ea                	jmp    800cd1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ce7:	0f b6 c1             	movzbl %cl,%eax
  800cea:	0f b6 db             	movzbl %bl,%ebx
  800ced:	29 d8                	sub    %ebx,%eax
  800cef:	eb 05                	jmp    800cf6 <memcmp+0x35>
	}

	return 0;
  800cf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf6:	5b                   	pop    %ebx
  800cf7:	5e                   	pop    %esi
  800cf8:	5d                   	pop    %ebp
  800cf9:	c3                   	ret    

00800cfa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d03:	89 c2                	mov    %eax,%edx
  800d05:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d08:	39 d0                	cmp    %edx,%eax
  800d0a:	73 09                	jae    800d15 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d0c:	38 08                	cmp    %cl,(%eax)
  800d0e:	74 05                	je     800d15 <memfind+0x1b>
	for (; s < ends; s++)
  800d10:	83 c0 01             	add    $0x1,%eax
  800d13:	eb f3                	jmp    800d08 <memfind+0xe>
			break;
	return (void *) s;
}
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
  800d1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d20:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d23:	eb 03                	jmp    800d28 <strtol+0x11>
		s++;
  800d25:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d28:	0f b6 01             	movzbl (%ecx),%eax
  800d2b:	3c 20                	cmp    $0x20,%al
  800d2d:	74 f6                	je     800d25 <strtol+0xe>
  800d2f:	3c 09                	cmp    $0x9,%al
  800d31:	74 f2                	je     800d25 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d33:	3c 2b                	cmp    $0x2b,%al
  800d35:	74 2a                	je     800d61 <strtol+0x4a>
	int neg = 0;
  800d37:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d3c:	3c 2d                	cmp    $0x2d,%al
  800d3e:	74 2b                	je     800d6b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d40:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d46:	75 0f                	jne    800d57 <strtol+0x40>
  800d48:	80 39 30             	cmpb   $0x30,(%ecx)
  800d4b:	74 28                	je     800d75 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d4d:	85 db                	test   %ebx,%ebx
  800d4f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d54:	0f 44 d8             	cmove  %eax,%ebx
  800d57:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d5f:	eb 50                	jmp    800db1 <strtol+0x9a>
		s++;
  800d61:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d64:	bf 00 00 00 00       	mov    $0x0,%edi
  800d69:	eb d5                	jmp    800d40 <strtol+0x29>
		s++, neg = 1;
  800d6b:	83 c1 01             	add    $0x1,%ecx
  800d6e:	bf 01 00 00 00       	mov    $0x1,%edi
  800d73:	eb cb                	jmp    800d40 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d75:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d79:	74 0e                	je     800d89 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d7b:	85 db                	test   %ebx,%ebx
  800d7d:	75 d8                	jne    800d57 <strtol+0x40>
		s++, base = 8;
  800d7f:	83 c1 01             	add    $0x1,%ecx
  800d82:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d87:	eb ce                	jmp    800d57 <strtol+0x40>
		s += 2, base = 16;
  800d89:	83 c1 02             	add    $0x2,%ecx
  800d8c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d91:	eb c4                	jmp    800d57 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d93:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d96:	89 f3                	mov    %esi,%ebx
  800d98:	80 fb 19             	cmp    $0x19,%bl
  800d9b:	77 29                	ja     800dc6 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d9d:	0f be d2             	movsbl %dl,%edx
  800da0:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800da3:	3b 55 10             	cmp    0x10(%ebp),%edx
  800da6:	7d 30                	jge    800dd8 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800da8:	83 c1 01             	add    $0x1,%ecx
  800dab:	0f af 45 10          	imul   0x10(%ebp),%eax
  800daf:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800db1:	0f b6 11             	movzbl (%ecx),%edx
  800db4:	8d 72 d0             	lea    -0x30(%edx),%esi
  800db7:	89 f3                	mov    %esi,%ebx
  800db9:	80 fb 09             	cmp    $0x9,%bl
  800dbc:	77 d5                	ja     800d93 <strtol+0x7c>
			dig = *s - '0';
  800dbe:	0f be d2             	movsbl %dl,%edx
  800dc1:	83 ea 30             	sub    $0x30,%edx
  800dc4:	eb dd                	jmp    800da3 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800dc6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800dc9:	89 f3                	mov    %esi,%ebx
  800dcb:	80 fb 19             	cmp    $0x19,%bl
  800dce:	77 08                	ja     800dd8 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800dd0:	0f be d2             	movsbl %dl,%edx
  800dd3:	83 ea 37             	sub    $0x37,%edx
  800dd6:	eb cb                	jmp    800da3 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ddc:	74 05                	je     800de3 <strtol+0xcc>
		*endptr = (char *) s;
  800dde:	8b 75 0c             	mov    0xc(%ebp),%esi
  800de1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800de3:	89 c2                	mov    %eax,%edx
  800de5:	f7 da                	neg    %edx
  800de7:	85 ff                	test   %edi,%edi
  800de9:	0f 45 c2             	cmovne %edx,%eax
}
  800dec:	5b                   	pop    %ebx
  800ded:	5e                   	pop    %esi
  800dee:	5f                   	pop    %edi
  800def:	5d                   	pop    %ebp
  800df0:	c3                   	ret    

00800df1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	57                   	push   %edi
  800df5:	56                   	push   %esi
  800df6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df7:	b8 00 00 00 00       	mov    $0x0,%eax
  800dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e02:	89 c3                	mov    %eax,%ebx
  800e04:	89 c7                	mov    %eax,%edi
  800e06:	89 c6                	mov    %eax,%esi
  800e08:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e0a:	5b                   	pop    %ebx
  800e0b:	5e                   	pop    %esi
  800e0c:	5f                   	pop    %edi
  800e0d:	5d                   	pop    %ebp
  800e0e:	c3                   	ret    

00800e0f <sys_cgetc>:

int
sys_cgetc(void)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	57                   	push   %edi
  800e13:	56                   	push   %esi
  800e14:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e15:	ba 00 00 00 00       	mov    $0x0,%edx
  800e1a:	b8 01 00 00 00       	mov    $0x1,%eax
  800e1f:	89 d1                	mov    %edx,%ecx
  800e21:	89 d3                	mov    %edx,%ebx
  800e23:	89 d7                	mov    %edx,%edi
  800e25:	89 d6                	mov    %edx,%esi
  800e27:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e29:	5b                   	pop    %ebx
  800e2a:	5e                   	pop    %esi
  800e2b:	5f                   	pop    %edi
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    

00800e2e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	57                   	push   %edi
  800e32:	56                   	push   %esi
  800e33:	53                   	push   %ebx
  800e34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e37:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3f:	b8 03 00 00 00       	mov    $0x3,%eax
  800e44:	89 cb                	mov    %ecx,%ebx
  800e46:	89 cf                	mov    %ecx,%edi
  800e48:	89 ce                	mov    %ecx,%esi
  800e4a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4c:	85 c0                	test   %eax,%eax
  800e4e:	7f 08                	jg     800e58 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e53:	5b                   	pop    %ebx
  800e54:	5e                   	pop    %esi
  800e55:	5f                   	pop    %edi
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e58:	83 ec 0c             	sub    $0xc,%esp
  800e5b:	50                   	push   %eax
  800e5c:	6a 03                	push   $0x3
  800e5e:	68 c8 30 80 00       	push   $0x8030c8
  800e63:	6a 43                	push   $0x43
  800e65:	68 e5 30 80 00       	push   $0x8030e5
  800e6a:	e8 f7 f3 ff ff       	call   800266 <_panic>

00800e6f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	57                   	push   %edi
  800e73:	56                   	push   %esi
  800e74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e75:	ba 00 00 00 00       	mov    $0x0,%edx
  800e7a:	b8 02 00 00 00       	mov    $0x2,%eax
  800e7f:	89 d1                	mov    %edx,%ecx
  800e81:	89 d3                	mov    %edx,%ebx
  800e83:	89 d7                	mov    %edx,%edi
  800e85:	89 d6                	mov    %edx,%esi
  800e87:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e89:	5b                   	pop    %ebx
  800e8a:	5e                   	pop    %esi
  800e8b:	5f                   	pop    %edi
  800e8c:	5d                   	pop    %ebp
  800e8d:	c3                   	ret    

00800e8e <sys_yield>:

void
sys_yield(void)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	57                   	push   %edi
  800e92:	56                   	push   %esi
  800e93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e94:	ba 00 00 00 00       	mov    $0x0,%edx
  800e99:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e9e:	89 d1                	mov    %edx,%ecx
  800ea0:	89 d3                	mov    %edx,%ebx
  800ea2:	89 d7                	mov    %edx,%edi
  800ea4:	89 d6                	mov    %edx,%esi
  800ea6:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ea8:	5b                   	pop    %ebx
  800ea9:	5e                   	pop    %esi
  800eaa:	5f                   	pop    %edi
  800eab:	5d                   	pop    %ebp
  800eac:	c3                   	ret    

00800ead <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	57                   	push   %edi
  800eb1:	56                   	push   %esi
  800eb2:	53                   	push   %ebx
  800eb3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb6:	be 00 00 00 00       	mov    $0x0,%esi
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ec6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec9:	89 f7                	mov    %esi,%edi
  800ecb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ecd:	85 c0                	test   %eax,%eax
  800ecf:	7f 08                	jg     800ed9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed4:	5b                   	pop    %ebx
  800ed5:	5e                   	pop    %esi
  800ed6:	5f                   	pop    %edi
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed9:	83 ec 0c             	sub    $0xc,%esp
  800edc:	50                   	push   %eax
  800edd:	6a 04                	push   $0x4
  800edf:	68 c8 30 80 00       	push   $0x8030c8
  800ee4:	6a 43                	push   $0x43
  800ee6:	68 e5 30 80 00       	push   $0x8030e5
  800eeb:	e8 76 f3 ff ff       	call   800266 <_panic>

00800ef0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	57                   	push   %edi
  800ef4:	56                   	push   %esi
  800ef5:	53                   	push   %ebx
  800ef6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eff:	b8 05 00 00 00       	mov    $0x5,%eax
  800f04:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f07:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f0a:	8b 75 18             	mov    0x18(%ebp),%esi
  800f0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0f:	85 c0                	test   %eax,%eax
  800f11:	7f 08                	jg     800f1b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1b:	83 ec 0c             	sub    $0xc,%esp
  800f1e:	50                   	push   %eax
  800f1f:	6a 05                	push   $0x5
  800f21:	68 c8 30 80 00       	push   $0x8030c8
  800f26:	6a 43                	push   $0x43
  800f28:	68 e5 30 80 00       	push   $0x8030e5
  800f2d:	e8 34 f3 ff ff       	call   800266 <_panic>

00800f32 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	57                   	push   %edi
  800f36:	56                   	push   %esi
  800f37:	53                   	push   %ebx
  800f38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f40:	8b 55 08             	mov    0x8(%ebp),%edx
  800f43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f46:	b8 06 00 00 00       	mov    $0x6,%eax
  800f4b:	89 df                	mov    %ebx,%edi
  800f4d:	89 de                	mov    %ebx,%esi
  800f4f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f51:	85 c0                	test   %eax,%eax
  800f53:	7f 08                	jg     800f5d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f58:	5b                   	pop    %ebx
  800f59:	5e                   	pop    %esi
  800f5a:	5f                   	pop    %edi
  800f5b:	5d                   	pop    %ebp
  800f5c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5d:	83 ec 0c             	sub    $0xc,%esp
  800f60:	50                   	push   %eax
  800f61:	6a 06                	push   $0x6
  800f63:	68 c8 30 80 00       	push   $0x8030c8
  800f68:	6a 43                	push   $0x43
  800f6a:	68 e5 30 80 00       	push   $0x8030e5
  800f6f:	e8 f2 f2 ff ff       	call   800266 <_panic>

00800f74 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	57                   	push   %edi
  800f78:	56                   	push   %esi
  800f79:	53                   	push   %ebx
  800f7a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f82:	8b 55 08             	mov    0x8(%ebp),%edx
  800f85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f88:	b8 08 00 00 00       	mov    $0x8,%eax
  800f8d:	89 df                	mov    %ebx,%edi
  800f8f:	89 de                	mov    %ebx,%esi
  800f91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f93:	85 c0                	test   %eax,%eax
  800f95:	7f 08                	jg     800f9f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f9a:	5b                   	pop    %ebx
  800f9b:	5e                   	pop    %esi
  800f9c:	5f                   	pop    %edi
  800f9d:	5d                   	pop    %ebp
  800f9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9f:	83 ec 0c             	sub    $0xc,%esp
  800fa2:	50                   	push   %eax
  800fa3:	6a 08                	push   $0x8
  800fa5:	68 c8 30 80 00       	push   $0x8030c8
  800faa:	6a 43                	push   $0x43
  800fac:	68 e5 30 80 00       	push   $0x8030e5
  800fb1:	e8 b0 f2 ff ff       	call   800266 <_panic>

00800fb6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	57                   	push   %edi
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
  800fbc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fca:	b8 09 00 00 00       	mov    $0x9,%eax
  800fcf:	89 df                	mov    %ebx,%edi
  800fd1:	89 de                	mov    %ebx,%esi
  800fd3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd5:	85 c0                	test   %eax,%eax
  800fd7:	7f 08                	jg     800fe1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fdc:	5b                   	pop    %ebx
  800fdd:	5e                   	pop    %esi
  800fde:	5f                   	pop    %edi
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe1:	83 ec 0c             	sub    $0xc,%esp
  800fe4:	50                   	push   %eax
  800fe5:	6a 09                	push   $0x9
  800fe7:	68 c8 30 80 00       	push   $0x8030c8
  800fec:	6a 43                	push   $0x43
  800fee:	68 e5 30 80 00       	push   $0x8030e5
  800ff3:	e8 6e f2 ff ff       	call   800266 <_panic>

00800ff8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	57                   	push   %edi
  800ffc:	56                   	push   %esi
  800ffd:	53                   	push   %ebx
  800ffe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801001:	bb 00 00 00 00       	mov    $0x0,%ebx
  801006:	8b 55 08             	mov    0x8(%ebp),%edx
  801009:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801011:	89 df                	mov    %ebx,%edi
  801013:	89 de                	mov    %ebx,%esi
  801015:	cd 30                	int    $0x30
	if(check && ret > 0)
  801017:	85 c0                	test   %eax,%eax
  801019:	7f 08                	jg     801023 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80101b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80101e:	5b                   	pop    %ebx
  80101f:	5e                   	pop    %esi
  801020:	5f                   	pop    %edi
  801021:	5d                   	pop    %ebp
  801022:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801023:	83 ec 0c             	sub    $0xc,%esp
  801026:	50                   	push   %eax
  801027:	6a 0a                	push   $0xa
  801029:	68 c8 30 80 00       	push   $0x8030c8
  80102e:	6a 43                	push   $0x43
  801030:	68 e5 30 80 00       	push   $0x8030e5
  801035:	e8 2c f2 ff ff       	call   800266 <_panic>

0080103a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	57                   	push   %edi
  80103e:	56                   	push   %esi
  80103f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801040:	8b 55 08             	mov    0x8(%ebp),%edx
  801043:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801046:	b8 0c 00 00 00       	mov    $0xc,%eax
  80104b:	be 00 00 00 00       	mov    $0x0,%esi
  801050:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801053:	8b 7d 14             	mov    0x14(%ebp),%edi
  801056:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801058:	5b                   	pop    %ebx
  801059:	5e                   	pop    %esi
  80105a:	5f                   	pop    %edi
  80105b:	5d                   	pop    %ebp
  80105c:	c3                   	ret    

0080105d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	57                   	push   %edi
  801061:	56                   	push   %esi
  801062:	53                   	push   %ebx
  801063:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801066:	b9 00 00 00 00       	mov    $0x0,%ecx
  80106b:	8b 55 08             	mov    0x8(%ebp),%edx
  80106e:	b8 0d 00 00 00       	mov    $0xd,%eax
  801073:	89 cb                	mov    %ecx,%ebx
  801075:	89 cf                	mov    %ecx,%edi
  801077:	89 ce                	mov    %ecx,%esi
  801079:	cd 30                	int    $0x30
	if(check && ret > 0)
  80107b:	85 c0                	test   %eax,%eax
  80107d:	7f 08                	jg     801087 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80107f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801082:	5b                   	pop    %ebx
  801083:	5e                   	pop    %esi
  801084:	5f                   	pop    %edi
  801085:	5d                   	pop    %ebp
  801086:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801087:	83 ec 0c             	sub    $0xc,%esp
  80108a:	50                   	push   %eax
  80108b:	6a 0d                	push   $0xd
  80108d:	68 c8 30 80 00       	push   $0x8030c8
  801092:	6a 43                	push   $0x43
  801094:	68 e5 30 80 00       	push   $0x8030e5
  801099:	e8 c8 f1 ff ff       	call   800266 <_panic>

0080109e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	57                   	push   %edi
  8010a2:	56                   	push   %esi
  8010a3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010af:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010b4:	89 df                	mov    %ebx,%edi
  8010b6:	89 de                	mov    %ebx,%esi
  8010b8:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010ba:	5b                   	pop    %ebx
  8010bb:	5e                   	pop    %esi
  8010bc:	5f                   	pop    %edi
  8010bd:	5d                   	pop    %ebp
  8010be:	c3                   	ret    

008010bf <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	57                   	push   %edi
  8010c3:	56                   	push   %esi
  8010c4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cd:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010d2:	89 cb                	mov    %ecx,%ebx
  8010d4:	89 cf                	mov    %ecx,%edi
  8010d6:	89 ce                	mov    %ecx,%esi
  8010d8:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010da:	5b                   	pop    %ebx
  8010db:	5e                   	pop    %esi
  8010dc:	5f                   	pop    %edi
  8010dd:	5d                   	pop    %ebp
  8010de:	c3                   	ret    

008010df <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	57                   	push   %edi
  8010e3:	56                   	push   %esi
  8010e4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ea:	b8 10 00 00 00       	mov    $0x10,%eax
  8010ef:	89 d1                	mov    %edx,%ecx
  8010f1:	89 d3                	mov    %edx,%ebx
  8010f3:	89 d7                	mov    %edx,%edi
  8010f5:	89 d6                	mov    %edx,%esi
  8010f7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010f9:	5b                   	pop    %ebx
  8010fa:	5e                   	pop    %esi
  8010fb:	5f                   	pop    %edi
  8010fc:	5d                   	pop    %ebp
  8010fd:	c3                   	ret    

008010fe <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	57                   	push   %edi
  801102:	56                   	push   %esi
  801103:	53                   	push   %ebx
	asm volatile("int %1\n"
  801104:	bb 00 00 00 00       	mov    $0x0,%ebx
  801109:	8b 55 08             	mov    0x8(%ebp),%edx
  80110c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80110f:	b8 11 00 00 00       	mov    $0x11,%eax
  801114:	89 df                	mov    %ebx,%edi
  801116:	89 de                	mov    %ebx,%esi
  801118:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80111a:	5b                   	pop    %ebx
  80111b:	5e                   	pop    %esi
  80111c:	5f                   	pop    %edi
  80111d:	5d                   	pop    %ebp
  80111e:	c3                   	ret    

0080111f <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	57                   	push   %edi
  801123:	56                   	push   %esi
  801124:	53                   	push   %ebx
	asm volatile("int %1\n"
  801125:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112a:	8b 55 08             	mov    0x8(%ebp),%edx
  80112d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801130:	b8 12 00 00 00       	mov    $0x12,%eax
  801135:	89 df                	mov    %ebx,%edi
  801137:	89 de                	mov    %ebx,%esi
  801139:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80113b:	5b                   	pop    %ebx
  80113c:	5e                   	pop    %esi
  80113d:	5f                   	pop    %edi
  80113e:	5d                   	pop    %ebp
  80113f:	c3                   	ret    

00801140 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
  801143:	57                   	push   %edi
  801144:	56                   	push   %esi
  801145:	53                   	push   %ebx
  801146:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801149:	bb 00 00 00 00       	mov    $0x0,%ebx
  80114e:	8b 55 08             	mov    0x8(%ebp),%edx
  801151:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801154:	b8 13 00 00 00       	mov    $0x13,%eax
  801159:	89 df                	mov    %ebx,%edi
  80115b:	89 de                	mov    %ebx,%esi
  80115d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80115f:	85 c0                	test   %eax,%eax
  801161:	7f 08                	jg     80116b <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801163:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801166:	5b                   	pop    %ebx
  801167:	5e                   	pop    %esi
  801168:	5f                   	pop    %edi
  801169:	5d                   	pop    %ebp
  80116a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80116b:	83 ec 0c             	sub    $0xc,%esp
  80116e:	50                   	push   %eax
  80116f:	6a 13                	push   $0x13
  801171:	68 c8 30 80 00       	push   $0x8030c8
  801176:	6a 43                	push   $0x43
  801178:	68 e5 30 80 00       	push   $0x8030e5
  80117d:	e8 e4 f0 ff ff       	call   800266 <_panic>

00801182 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
  801185:	57                   	push   %edi
  801186:	56                   	push   %esi
  801187:	53                   	push   %ebx
	asm volatile("int %1\n"
  801188:	b9 00 00 00 00       	mov    $0x0,%ecx
  80118d:	8b 55 08             	mov    0x8(%ebp),%edx
  801190:	b8 14 00 00 00       	mov    $0x14,%eax
  801195:	89 cb                	mov    %ecx,%ebx
  801197:	89 cf                	mov    %ecx,%edi
  801199:	89 ce                	mov    %ecx,%esi
  80119b:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80119d:	5b                   	pop    %ebx
  80119e:	5e                   	pop    %esi
  80119f:	5f                   	pop    %edi
  8011a0:	5d                   	pop    %ebp
  8011a1:	c3                   	ret    

008011a2 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	53                   	push   %ebx
  8011a6:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8011a9:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011b0:	f6 c5 04             	test   $0x4,%ch
  8011b3:	75 45                	jne    8011fa <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8011b5:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011bc:	83 e1 07             	and    $0x7,%ecx
  8011bf:	83 f9 07             	cmp    $0x7,%ecx
  8011c2:	74 6f                	je     801233 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8011c4:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011cb:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8011d1:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8011d7:	0f 84 b6 00 00 00    	je     801293 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8011dd:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011e4:	83 e1 05             	and    $0x5,%ecx
  8011e7:	83 f9 05             	cmp    $0x5,%ecx
  8011ea:	0f 84 d7 00 00 00    	je     8012c7 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8011f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8011fa:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801201:	c1 e2 0c             	shl    $0xc,%edx
  801204:	83 ec 0c             	sub    $0xc,%esp
  801207:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80120d:	51                   	push   %ecx
  80120e:	52                   	push   %edx
  80120f:	50                   	push   %eax
  801210:	52                   	push   %edx
  801211:	6a 00                	push   $0x0
  801213:	e8 d8 fc ff ff       	call   800ef0 <sys_page_map>
		if(r < 0)
  801218:	83 c4 20             	add    $0x20,%esp
  80121b:	85 c0                	test   %eax,%eax
  80121d:	79 d1                	jns    8011f0 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	68 f3 30 80 00       	push   $0x8030f3
  801227:	6a 54                	push   $0x54
  801229:	68 09 31 80 00       	push   $0x803109
  80122e:	e8 33 f0 ff ff       	call   800266 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801233:	89 d3                	mov    %edx,%ebx
  801235:	c1 e3 0c             	shl    $0xc,%ebx
  801238:	83 ec 0c             	sub    $0xc,%esp
  80123b:	68 05 08 00 00       	push   $0x805
  801240:	53                   	push   %ebx
  801241:	50                   	push   %eax
  801242:	53                   	push   %ebx
  801243:	6a 00                	push   $0x0
  801245:	e8 a6 fc ff ff       	call   800ef0 <sys_page_map>
		if(r < 0)
  80124a:	83 c4 20             	add    $0x20,%esp
  80124d:	85 c0                	test   %eax,%eax
  80124f:	78 2e                	js     80127f <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801251:	83 ec 0c             	sub    $0xc,%esp
  801254:	68 05 08 00 00       	push   $0x805
  801259:	53                   	push   %ebx
  80125a:	6a 00                	push   $0x0
  80125c:	53                   	push   %ebx
  80125d:	6a 00                	push   $0x0
  80125f:	e8 8c fc ff ff       	call   800ef0 <sys_page_map>
		if(r < 0)
  801264:	83 c4 20             	add    $0x20,%esp
  801267:	85 c0                	test   %eax,%eax
  801269:	79 85                	jns    8011f0 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80126b:	83 ec 04             	sub    $0x4,%esp
  80126e:	68 f3 30 80 00       	push   $0x8030f3
  801273:	6a 5f                	push   $0x5f
  801275:	68 09 31 80 00       	push   $0x803109
  80127a:	e8 e7 ef ff ff       	call   800266 <_panic>
			panic("sys_page_map() panic\n");
  80127f:	83 ec 04             	sub    $0x4,%esp
  801282:	68 f3 30 80 00       	push   $0x8030f3
  801287:	6a 5b                	push   $0x5b
  801289:	68 09 31 80 00       	push   $0x803109
  80128e:	e8 d3 ef ff ff       	call   800266 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801293:	c1 e2 0c             	shl    $0xc,%edx
  801296:	83 ec 0c             	sub    $0xc,%esp
  801299:	68 05 08 00 00       	push   $0x805
  80129e:	52                   	push   %edx
  80129f:	50                   	push   %eax
  8012a0:	52                   	push   %edx
  8012a1:	6a 00                	push   $0x0
  8012a3:	e8 48 fc ff ff       	call   800ef0 <sys_page_map>
		if(r < 0)
  8012a8:	83 c4 20             	add    $0x20,%esp
  8012ab:	85 c0                	test   %eax,%eax
  8012ad:	0f 89 3d ff ff ff    	jns    8011f0 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012b3:	83 ec 04             	sub    $0x4,%esp
  8012b6:	68 f3 30 80 00       	push   $0x8030f3
  8012bb:	6a 66                	push   $0x66
  8012bd:	68 09 31 80 00       	push   $0x803109
  8012c2:	e8 9f ef ff ff       	call   800266 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012c7:	c1 e2 0c             	shl    $0xc,%edx
  8012ca:	83 ec 0c             	sub    $0xc,%esp
  8012cd:	6a 05                	push   $0x5
  8012cf:	52                   	push   %edx
  8012d0:	50                   	push   %eax
  8012d1:	52                   	push   %edx
  8012d2:	6a 00                	push   $0x0
  8012d4:	e8 17 fc ff ff       	call   800ef0 <sys_page_map>
		if(r < 0)
  8012d9:	83 c4 20             	add    $0x20,%esp
  8012dc:	85 c0                	test   %eax,%eax
  8012de:	0f 89 0c ff ff ff    	jns    8011f0 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012e4:	83 ec 04             	sub    $0x4,%esp
  8012e7:	68 f3 30 80 00       	push   $0x8030f3
  8012ec:	6a 6d                	push   $0x6d
  8012ee:	68 09 31 80 00       	push   $0x803109
  8012f3:	e8 6e ef ff ff       	call   800266 <_panic>

008012f8 <pgfault>:
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	53                   	push   %ebx
  8012fc:	83 ec 04             	sub    $0x4,%esp
  8012ff:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801302:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801304:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801308:	0f 84 99 00 00 00    	je     8013a7 <pgfault+0xaf>
  80130e:	89 c2                	mov    %eax,%edx
  801310:	c1 ea 16             	shr    $0x16,%edx
  801313:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80131a:	f6 c2 01             	test   $0x1,%dl
  80131d:	0f 84 84 00 00 00    	je     8013a7 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801323:	89 c2                	mov    %eax,%edx
  801325:	c1 ea 0c             	shr    $0xc,%edx
  801328:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80132f:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801335:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  80133b:	75 6a                	jne    8013a7 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  80133d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801342:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801344:	83 ec 04             	sub    $0x4,%esp
  801347:	6a 07                	push   $0x7
  801349:	68 00 f0 7f 00       	push   $0x7ff000
  80134e:	6a 00                	push   $0x0
  801350:	e8 58 fb ff ff       	call   800ead <sys_page_alloc>
	if(ret < 0)
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	85 c0                	test   %eax,%eax
  80135a:	78 5f                	js     8013bb <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80135c:	83 ec 04             	sub    $0x4,%esp
  80135f:	68 00 10 00 00       	push   $0x1000
  801364:	53                   	push   %ebx
  801365:	68 00 f0 7f 00       	push   $0x7ff000
  80136a:	e8 3c f9 ff ff       	call   800cab <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80136f:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801376:	53                   	push   %ebx
  801377:	6a 00                	push   $0x0
  801379:	68 00 f0 7f 00       	push   $0x7ff000
  80137e:	6a 00                	push   $0x0
  801380:	e8 6b fb ff ff       	call   800ef0 <sys_page_map>
	if(ret < 0)
  801385:	83 c4 20             	add    $0x20,%esp
  801388:	85 c0                	test   %eax,%eax
  80138a:	78 43                	js     8013cf <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  80138c:	83 ec 08             	sub    $0x8,%esp
  80138f:	68 00 f0 7f 00       	push   $0x7ff000
  801394:	6a 00                	push   $0x0
  801396:	e8 97 fb ff ff       	call   800f32 <sys_page_unmap>
	if(ret < 0)
  80139b:	83 c4 10             	add    $0x10,%esp
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	78 41                	js     8013e3 <pgfault+0xeb>
}
  8013a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    
		panic("panic at pgfault()\n");
  8013a7:	83 ec 04             	sub    $0x4,%esp
  8013aa:	68 14 31 80 00       	push   $0x803114
  8013af:	6a 26                	push   $0x26
  8013b1:	68 09 31 80 00       	push   $0x803109
  8013b6:	e8 ab ee ff ff       	call   800266 <_panic>
		panic("panic in sys_page_alloc()\n");
  8013bb:	83 ec 04             	sub    $0x4,%esp
  8013be:	68 28 31 80 00       	push   $0x803128
  8013c3:	6a 31                	push   $0x31
  8013c5:	68 09 31 80 00       	push   $0x803109
  8013ca:	e8 97 ee ff ff       	call   800266 <_panic>
		panic("panic in sys_page_map()\n");
  8013cf:	83 ec 04             	sub    $0x4,%esp
  8013d2:	68 43 31 80 00       	push   $0x803143
  8013d7:	6a 36                	push   $0x36
  8013d9:	68 09 31 80 00       	push   $0x803109
  8013de:	e8 83 ee ff ff       	call   800266 <_panic>
		panic("panic in sys_page_unmap()\n");
  8013e3:	83 ec 04             	sub    $0x4,%esp
  8013e6:	68 5c 31 80 00       	push   $0x80315c
  8013eb:	6a 39                	push   $0x39
  8013ed:	68 09 31 80 00       	push   $0x803109
  8013f2:	e8 6f ee ff ff       	call   800266 <_panic>

008013f7 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	57                   	push   %edi
  8013fb:	56                   	push   %esi
  8013fc:	53                   	push   %ebx
  8013fd:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801400:	68 f8 12 80 00       	push   $0x8012f8
  801405:	e8 db 13 00 00       	call   8027e5 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80140a:	b8 07 00 00 00       	mov    $0x7,%eax
  80140f:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801411:	83 c4 10             	add    $0x10,%esp
  801414:	85 c0                	test   %eax,%eax
  801416:	78 2a                	js     801442 <fork+0x4b>
  801418:	89 c6                	mov    %eax,%esi
  80141a:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80141c:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801421:	75 4b                	jne    80146e <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  801423:	e8 47 fa ff ff       	call   800e6f <sys_getenvid>
  801428:	25 ff 03 00 00       	and    $0x3ff,%eax
  80142d:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801433:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801438:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80143d:	e9 90 00 00 00       	jmp    8014d2 <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  801442:	83 ec 04             	sub    $0x4,%esp
  801445:	68 78 31 80 00       	push   $0x803178
  80144a:	68 8c 00 00 00       	push   $0x8c
  80144f:	68 09 31 80 00       	push   $0x803109
  801454:	e8 0d ee ff ff       	call   800266 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801459:	89 f8                	mov    %edi,%eax
  80145b:	e8 42 fd ff ff       	call   8011a2 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801460:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801466:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80146c:	74 26                	je     801494 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  80146e:	89 d8                	mov    %ebx,%eax
  801470:	c1 e8 16             	shr    $0x16,%eax
  801473:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80147a:	a8 01                	test   $0x1,%al
  80147c:	74 e2                	je     801460 <fork+0x69>
  80147e:	89 da                	mov    %ebx,%edx
  801480:	c1 ea 0c             	shr    $0xc,%edx
  801483:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80148a:	83 e0 05             	and    $0x5,%eax
  80148d:	83 f8 05             	cmp    $0x5,%eax
  801490:	75 ce                	jne    801460 <fork+0x69>
  801492:	eb c5                	jmp    801459 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801494:	83 ec 04             	sub    $0x4,%esp
  801497:	6a 07                	push   $0x7
  801499:	68 00 f0 bf ee       	push   $0xeebff000
  80149e:	56                   	push   %esi
  80149f:	e8 09 fa ff ff       	call   800ead <sys_page_alloc>
	if(ret < 0)
  8014a4:	83 c4 10             	add    $0x10,%esp
  8014a7:	85 c0                	test   %eax,%eax
  8014a9:	78 31                	js     8014dc <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014ab:	83 ec 08             	sub    $0x8,%esp
  8014ae:	68 54 28 80 00       	push   $0x802854
  8014b3:	56                   	push   %esi
  8014b4:	e8 3f fb ff ff       	call   800ff8 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014b9:	83 c4 10             	add    $0x10,%esp
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	78 33                	js     8014f3 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014c0:	83 ec 08             	sub    $0x8,%esp
  8014c3:	6a 02                	push   $0x2
  8014c5:	56                   	push   %esi
  8014c6:	e8 a9 fa ff ff       	call   800f74 <sys_env_set_status>
	if(ret < 0)
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	78 38                	js     80150a <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8014d2:	89 f0                	mov    %esi,%eax
  8014d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d7:	5b                   	pop    %ebx
  8014d8:	5e                   	pop    %esi
  8014d9:	5f                   	pop    %edi
  8014da:	5d                   	pop    %ebp
  8014db:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014dc:	83 ec 04             	sub    $0x4,%esp
  8014df:	68 28 31 80 00       	push   $0x803128
  8014e4:	68 98 00 00 00       	push   $0x98
  8014e9:	68 09 31 80 00       	push   $0x803109
  8014ee:	e8 73 ed ff ff       	call   800266 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014f3:	83 ec 04             	sub    $0x4,%esp
  8014f6:	68 9c 31 80 00       	push   $0x80319c
  8014fb:	68 9b 00 00 00       	push   $0x9b
  801500:	68 09 31 80 00       	push   $0x803109
  801505:	e8 5c ed ff ff       	call   800266 <_panic>
		panic("panic in sys_env_set_status()\n");
  80150a:	83 ec 04             	sub    $0x4,%esp
  80150d:	68 c4 31 80 00       	push   $0x8031c4
  801512:	68 9e 00 00 00       	push   $0x9e
  801517:	68 09 31 80 00       	push   $0x803109
  80151c:	e8 45 ed ff ff       	call   800266 <_panic>

00801521 <sfork>:

// Challenge!
int
sfork(void)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	57                   	push   %edi
  801525:	56                   	push   %esi
  801526:	53                   	push   %ebx
  801527:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  80152a:	68 f8 12 80 00       	push   $0x8012f8
  80152f:	e8 b1 12 00 00       	call   8027e5 <set_pgfault_handler>
  801534:	b8 07 00 00 00       	mov    $0x7,%eax
  801539:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	85 c0                	test   %eax,%eax
  801540:	78 2a                	js     80156c <sfork+0x4b>
  801542:	89 c7                	mov    %eax,%edi
  801544:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801546:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80154b:	75 58                	jne    8015a5 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  80154d:	e8 1d f9 ff ff       	call   800e6f <sys_getenvid>
  801552:	25 ff 03 00 00       	and    $0x3ff,%eax
  801557:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80155d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801562:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801567:	e9 d4 00 00 00       	jmp    801640 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  80156c:	83 ec 04             	sub    $0x4,%esp
  80156f:	68 78 31 80 00       	push   $0x803178
  801574:	68 af 00 00 00       	push   $0xaf
  801579:	68 09 31 80 00       	push   $0x803109
  80157e:	e8 e3 ec ff ff       	call   800266 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801583:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801588:	89 f0                	mov    %esi,%eax
  80158a:	e8 13 fc ff ff       	call   8011a2 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80158f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801595:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80159b:	77 65                	ja     801602 <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  80159d:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8015a3:	74 de                	je     801583 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8015a5:	89 d8                	mov    %ebx,%eax
  8015a7:	c1 e8 16             	shr    $0x16,%eax
  8015aa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015b1:	a8 01                	test   $0x1,%al
  8015b3:	74 da                	je     80158f <sfork+0x6e>
  8015b5:	89 da                	mov    %ebx,%edx
  8015b7:	c1 ea 0c             	shr    $0xc,%edx
  8015ba:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015c1:	83 e0 05             	and    $0x5,%eax
  8015c4:	83 f8 05             	cmp    $0x5,%eax
  8015c7:	75 c6                	jne    80158f <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015c9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8015d0:	c1 e2 0c             	shl    $0xc,%edx
  8015d3:	83 ec 0c             	sub    $0xc,%esp
  8015d6:	83 e0 07             	and    $0x7,%eax
  8015d9:	50                   	push   %eax
  8015da:	52                   	push   %edx
  8015db:	56                   	push   %esi
  8015dc:	52                   	push   %edx
  8015dd:	6a 00                	push   $0x0
  8015df:	e8 0c f9 ff ff       	call   800ef0 <sys_page_map>
  8015e4:	83 c4 20             	add    $0x20,%esp
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	74 a4                	je     80158f <sfork+0x6e>
				panic("sys_page_map() panic\n");
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	68 f3 30 80 00       	push   $0x8030f3
  8015f3:	68 ba 00 00 00       	push   $0xba
  8015f8:	68 09 31 80 00       	push   $0x803109
  8015fd:	e8 64 ec ff ff       	call   800266 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	6a 07                	push   $0x7
  801607:	68 00 f0 bf ee       	push   $0xeebff000
  80160c:	57                   	push   %edi
  80160d:	e8 9b f8 ff ff       	call   800ead <sys_page_alloc>
	if(ret < 0)
  801612:	83 c4 10             	add    $0x10,%esp
  801615:	85 c0                	test   %eax,%eax
  801617:	78 31                	js     80164a <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801619:	83 ec 08             	sub    $0x8,%esp
  80161c:	68 54 28 80 00       	push   $0x802854
  801621:	57                   	push   %edi
  801622:	e8 d1 f9 ff ff       	call   800ff8 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	85 c0                	test   %eax,%eax
  80162c:	78 33                	js     801661 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	6a 02                	push   $0x2
  801633:	57                   	push   %edi
  801634:	e8 3b f9 ff ff       	call   800f74 <sys_env_set_status>
	if(ret < 0)
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	85 c0                	test   %eax,%eax
  80163e:	78 38                	js     801678 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801640:	89 f8                	mov    %edi,%eax
  801642:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801645:	5b                   	pop    %ebx
  801646:	5e                   	pop    %esi
  801647:	5f                   	pop    %edi
  801648:	5d                   	pop    %ebp
  801649:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80164a:	83 ec 04             	sub    $0x4,%esp
  80164d:	68 28 31 80 00       	push   $0x803128
  801652:	68 c0 00 00 00       	push   $0xc0
  801657:	68 09 31 80 00       	push   $0x803109
  80165c:	e8 05 ec ff ff       	call   800266 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801661:	83 ec 04             	sub    $0x4,%esp
  801664:	68 9c 31 80 00       	push   $0x80319c
  801669:	68 c3 00 00 00       	push   $0xc3
  80166e:	68 09 31 80 00       	push   $0x803109
  801673:	e8 ee eb ff ff       	call   800266 <_panic>
		panic("panic in sys_env_set_status()\n");
  801678:	83 ec 04             	sub    $0x4,%esp
  80167b:	68 c4 31 80 00       	push   $0x8031c4
  801680:	68 c6 00 00 00       	push   $0xc6
  801685:	68 09 31 80 00       	push   $0x803109
  80168a:	e8 d7 eb ff ff       	call   800266 <_panic>

0080168f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	05 00 00 00 30       	add    $0x30000000,%eax
  80169a:	c1 e8 0c             	shr    $0xc,%eax
}
  80169d:	5d                   	pop    %ebp
  80169e:	c3                   	ret    

0080169f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016af:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016b4:	5d                   	pop    %ebp
  8016b5:	c3                   	ret    

008016b6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016be:	89 c2                	mov    %eax,%edx
  8016c0:	c1 ea 16             	shr    $0x16,%edx
  8016c3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016ca:	f6 c2 01             	test   $0x1,%dl
  8016cd:	74 2d                	je     8016fc <fd_alloc+0x46>
  8016cf:	89 c2                	mov    %eax,%edx
  8016d1:	c1 ea 0c             	shr    $0xc,%edx
  8016d4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016db:	f6 c2 01             	test   $0x1,%dl
  8016de:	74 1c                	je     8016fc <fd_alloc+0x46>
  8016e0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016e5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016ea:	75 d2                	jne    8016be <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8016f5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8016fa:	eb 0a                	jmp    801706 <fd_alloc+0x50>
			*fd_store = fd;
  8016fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ff:	89 01                	mov    %eax,(%ecx)
			return 0;
  801701:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801706:	5d                   	pop    %ebp
  801707:	c3                   	ret    

00801708 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80170e:	83 f8 1f             	cmp    $0x1f,%eax
  801711:	77 30                	ja     801743 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801713:	c1 e0 0c             	shl    $0xc,%eax
  801716:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80171b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801721:	f6 c2 01             	test   $0x1,%dl
  801724:	74 24                	je     80174a <fd_lookup+0x42>
  801726:	89 c2                	mov    %eax,%edx
  801728:	c1 ea 0c             	shr    $0xc,%edx
  80172b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801732:	f6 c2 01             	test   $0x1,%dl
  801735:	74 1a                	je     801751 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801737:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173a:	89 02                	mov    %eax,(%edx)
	return 0;
  80173c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801741:	5d                   	pop    %ebp
  801742:	c3                   	ret    
		return -E_INVAL;
  801743:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801748:	eb f7                	jmp    801741 <fd_lookup+0x39>
		return -E_INVAL;
  80174a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80174f:	eb f0                	jmp    801741 <fd_lookup+0x39>
  801751:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801756:	eb e9                	jmp    801741 <fd_lookup+0x39>

00801758 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	83 ec 08             	sub    $0x8,%esp
  80175e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801761:	ba 00 00 00 00       	mov    $0x0,%edx
  801766:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80176b:	39 08                	cmp    %ecx,(%eax)
  80176d:	74 38                	je     8017a7 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80176f:	83 c2 01             	add    $0x1,%edx
  801772:	8b 04 95 60 32 80 00 	mov    0x803260(,%edx,4),%eax
  801779:	85 c0                	test   %eax,%eax
  80177b:	75 ee                	jne    80176b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80177d:	a1 08 50 80 00       	mov    0x805008,%eax
  801782:	8b 40 48             	mov    0x48(%eax),%eax
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	51                   	push   %ecx
  801789:	50                   	push   %eax
  80178a:	68 e4 31 80 00       	push   $0x8031e4
  80178f:	e8 c8 eb ff ff       	call   80035c <cprintf>
	*dev = 0;
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80179d:	83 c4 10             	add    $0x10,%esp
  8017a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    
			*dev = devtab[i];
  8017a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017aa:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b1:	eb f2                	jmp    8017a5 <dev_lookup+0x4d>

008017b3 <fd_close>:
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	57                   	push   %edi
  8017b7:	56                   	push   %esi
  8017b8:	53                   	push   %ebx
  8017b9:	83 ec 24             	sub    $0x24,%esp
  8017bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8017bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017c5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017c6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017cc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017cf:	50                   	push   %eax
  8017d0:	e8 33 ff ff ff       	call   801708 <fd_lookup>
  8017d5:	89 c3                	mov    %eax,%ebx
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	78 05                	js     8017e3 <fd_close+0x30>
	    || fd != fd2)
  8017de:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017e1:	74 16                	je     8017f9 <fd_close+0x46>
		return (must_exist ? r : 0);
  8017e3:	89 f8                	mov    %edi,%eax
  8017e5:	84 c0                	test   %al,%al
  8017e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ec:	0f 44 d8             	cmove  %eax,%ebx
}
  8017ef:	89 d8                	mov    %ebx,%eax
  8017f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017f4:	5b                   	pop    %ebx
  8017f5:	5e                   	pop    %esi
  8017f6:	5f                   	pop    %edi
  8017f7:	5d                   	pop    %ebp
  8017f8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017f9:	83 ec 08             	sub    $0x8,%esp
  8017fc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017ff:	50                   	push   %eax
  801800:	ff 36                	pushl  (%esi)
  801802:	e8 51 ff ff ff       	call   801758 <dev_lookup>
  801807:	89 c3                	mov    %eax,%ebx
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	85 c0                	test   %eax,%eax
  80180e:	78 1a                	js     80182a <fd_close+0x77>
		if (dev->dev_close)
  801810:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801813:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801816:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80181b:	85 c0                	test   %eax,%eax
  80181d:	74 0b                	je     80182a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80181f:	83 ec 0c             	sub    $0xc,%esp
  801822:	56                   	push   %esi
  801823:	ff d0                	call   *%eax
  801825:	89 c3                	mov    %eax,%ebx
  801827:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80182a:	83 ec 08             	sub    $0x8,%esp
  80182d:	56                   	push   %esi
  80182e:	6a 00                	push   $0x0
  801830:	e8 fd f6 ff ff       	call   800f32 <sys_page_unmap>
	return r;
  801835:	83 c4 10             	add    $0x10,%esp
  801838:	eb b5                	jmp    8017ef <fd_close+0x3c>

0080183a <close>:

int
close(int fdnum)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801840:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801843:	50                   	push   %eax
  801844:	ff 75 08             	pushl  0x8(%ebp)
  801847:	e8 bc fe ff ff       	call   801708 <fd_lookup>
  80184c:	83 c4 10             	add    $0x10,%esp
  80184f:	85 c0                	test   %eax,%eax
  801851:	79 02                	jns    801855 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    
		return fd_close(fd, 1);
  801855:	83 ec 08             	sub    $0x8,%esp
  801858:	6a 01                	push   $0x1
  80185a:	ff 75 f4             	pushl  -0xc(%ebp)
  80185d:	e8 51 ff ff ff       	call   8017b3 <fd_close>
  801862:	83 c4 10             	add    $0x10,%esp
  801865:	eb ec                	jmp    801853 <close+0x19>

00801867 <close_all>:

void
close_all(void)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	53                   	push   %ebx
  80186b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80186e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801873:	83 ec 0c             	sub    $0xc,%esp
  801876:	53                   	push   %ebx
  801877:	e8 be ff ff ff       	call   80183a <close>
	for (i = 0; i < MAXFD; i++)
  80187c:	83 c3 01             	add    $0x1,%ebx
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	83 fb 20             	cmp    $0x20,%ebx
  801885:	75 ec                	jne    801873 <close_all+0xc>
}
  801887:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	57                   	push   %edi
  801890:	56                   	push   %esi
  801891:	53                   	push   %ebx
  801892:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801895:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801898:	50                   	push   %eax
  801899:	ff 75 08             	pushl  0x8(%ebp)
  80189c:	e8 67 fe ff ff       	call   801708 <fd_lookup>
  8018a1:	89 c3                	mov    %eax,%ebx
  8018a3:	83 c4 10             	add    $0x10,%esp
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	0f 88 81 00 00 00    	js     80192f <dup+0xa3>
		return r;
	close(newfdnum);
  8018ae:	83 ec 0c             	sub    $0xc,%esp
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	e8 81 ff ff ff       	call   80183a <close>

	newfd = INDEX2FD(newfdnum);
  8018b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018bc:	c1 e6 0c             	shl    $0xc,%esi
  8018bf:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018c5:	83 c4 04             	add    $0x4,%esp
  8018c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018cb:	e8 cf fd ff ff       	call   80169f <fd2data>
  8018d0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018d2:	89 34 24             	mov    %esi,(%esp)
  8018d5:	e8 c5 fd ff ff       	call   80169f <fd2data>
  8018da:	83 c4 10             	add    $0x10,%esp
  8018dd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018df:	89 d8                	mov    %ebx,%eax
  8018e1:	c1 e8 16             	shr    $0x16,%eax
  8018e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018eb:	a8 01                	test   $0x1,%al
  8018ed:	74 11                	je     801900 <dup+0x74>
  8018ef:	89 d8                	mov    %ebx,%eax
  8018f1:	c1 e8 0c             	shr    $0xc,%eax
  8018f4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018fb:	f6 c2 01             	test   $0x1,%dl
  8018fe:	75 39                	jne    801939 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801900:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801903:	89 d0                	mov    %edx,%eax
  801905:	c1 e8 0c             	shr    $0xc,%eax
  801908:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80190f:	83 ec 0c             	sub    $0xc,%esp
  801912:	25 07 0e 00 00       	and    $0xe07,%eax
  801917:	50                   	push   %eax
  801918:	56                   	push   %esi
  801919:	6a 00                	push   $0x0
  80191b:	52                   	push   %edx
  80191c:	6a 00                	push   $0x0
  80191e:	e8 cd f5 ff ff       	call   800ef0 <sys_page_map>
  801923:	89 c3                	mov    %eax,%ebx
  801925:	83 c4 20             	add    $0x20,%esp
  801928:	85 c0                	test   %eax,%eax
  80192a:	78 31                	js     80195d <dup+0xd1>
		goto err;

	return newfdnum;
  80192c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80192f:	89 d8                	mov    %ebx,%eax
  801931:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801934:	5b                   	pop    %ebx
  801935:	5e                   	pop    %esi
  801936:	5f                   	pop    %edi
  801937:	5d                   	pop    %ebp
  801938:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801939:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801940:	83 ec 0c             	sub    $0xc,%esp
  801943:	25 07 0e 00 00       	and    $0xe07,%eax
  801948:	50                   	push   %eax
  801949:	57                   	push   %edi
  80194a:	6a 00                	push   $0x0
  80194c:	53                   	push   %ebx
  80194d:	6a 00                	push   $0x0
  80194f:	e8 9c f5 ff ff       	call   800ef0 <sys_page_map>
  801954:	89 c3                	mov    %eax,%ebx
  801956:	83 c4 20             	add    $0x20,%esp
  801959:	85 c0                	test   %eax,%eax
  80195b:	79 a3                	jns    801900 <dup+0x74>
	sys_page_unmap(0, newfd);
  80195d:	83 ec 08             	sub    $0x8,%esp
  801960:	56                   	push   %esi
  801961:	6a 00                	push   $0x0
  801963:	e8 ca f5 ff ff       	call   800f32 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801968:	83 c4 08             	add    $0x8,%esp
  80196b:	57                   	push   %edi
  80196c:	6a 00                	push   $0x0
  80196e:	e8 bf f5 ff ff       	call   800f32 <sys_page_unmap>
	return r;
  801973:	83 c4 10             	add    $0x10,%esp
  801976:	eb b7                	jmp    80192f <dup+0xa3>

00801978 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	53                   	push   %ebx
  80197c:	83 ec 1c             	sub    $0x1c,%esp
  80197f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801982:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801985:	50                   	push   %eax
  801986:	53                   	push   %ebx
  801987:	e8 7c fd ff ff       	call   801708 <fd_lookup>
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	85 c0                	test   %eax,%eax
  801991:	78 3f                	js     8019d2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801993:	83 ec 08             	sub    $0x8,%esp
  801996:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801999:	50                   	push   %eax
  80199a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80199d:	ff 30                	pushl  (%eax)
  80199f:	e8 b4 fd ff ff       	call   801758 <dev_lookup>
  8019a4:	83 c4 10             	add    $0x10,%esp
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	78 27                	js     8019d2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019ae:	8b 42 08             	mov    0x8(%edx),%eax
  8019b1:	83 e0 03             	and    $0x3,%eax
  8019b4:	83 f8 01             	cmp    $0x1,%eax
  8019b7:	74 1e                	je     8019d7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bc:	8b 40 08             	mov    0x8(%eax),%eax
  8019bf:	85 c0                	test   %eax,%eax
  8019c1:	74 35                	je     8019f8 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019c3:	83 ec 04             	sub    $0x4,%esp
  8019c6:	ff 75 10             	pushl  0x10(%ebp)
  8019c9:	ff 75 0c             	pushl  0xc(%ebp)
  8019cc:	52                   	push   %edx
  8019cd:	ff d0                	call   *%eax
  8019cf:	83 c4 10             	add    $0x10,%esp
}
  8019d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019d7:	a1 08 50 80 00       	mov    0x805008,%eax
  8019dc:	8b 40 48             	mov    0x48(%eax),%eax
  8019df:	83 ec 04             	sub    $0x4,%esp
  8019e2:	53                   	push   %ebx
  8019e3:	50                   	push   %eax
  8019e4:	68 25 32 80 00       	push   $0x803225
  8019e9:	e8 6e e9 ff ff       	call   80035c <cprintf>
		return -E_INVAL;
  8019ee:	83 c4 10             	add    $0x10,%esp
  8019f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019f6:	eb da                	jmp    8019d2 <read+0x5a>
		return -E_NOT_SUPP;
  8019f8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019fd:	eb d3                	jmp    8019d2 <read+0x5a>

008019ff <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	57                   	push   %edi
  801a03:	56                   	push   %esi
  801a04:	53                   	push   %ebx
  801a05:	83 ec 0c             	sub    $0xc,%esp
  801a08:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a0b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a0e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a13:	39 f3                	cmp    %esi,%ebx
  801a15:	73 23                	jae    801a3a <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a17:	83 ec 04             	sub    $0x4,%esp
  801a1a:	89 f0                	mov    %esi,%eax
  801a1c:	29 d8                	sub    %ebx,%eax
  801a1e:	50                   	push   %eax
  801a1f:	89 d8                	mov    %ebx,%eax
  801a21:	03 45 0c             	add    0xc(%ebp),%eax
  801a24:	50                   	push   %eax
  801a25:	57                   	push   %edi
  801a26:	e8 4d ff ff ff       	call   801978 <read>
		if (m < 0)
  801a2b:	83 c4 10             	add    $0x10,%esp
  801a2e:	85 c0                	test   %eax,%eax
  801a30:	78 06                	js     801a38 <readn+0x39>
			return m;
		if (m == 0)
  801a32:	74 06                	je     801a3a <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a34:	01 c3                	add    %eax,%ebx
  801a36:	eb db                	jmp    801a13 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a38:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a3a:	89 d8                	mov    %ebx,%eax
  801a3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a3f:	5b                   	pop    %ebx
  801a40:	5e                   	pop    %esi
  801a41:	5f                   	pop    %edi
  801a42:	5d                   	pop    %ebp
  801a43:	c3                   	ret    

00801a44 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	53                   	push   %ebx
  801a48:	83 ec 1c             	sub    $0x1c,%esp
  801a4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a4e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a51:	50                   	push   %eax
  801a52:	53                   	push   %ebx
  801a53:	e8 b0 fc ff ff       	call   801708 <fd_lookup>
  801a58:	83 c4 10             	add    $0x10,%esp
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	78 3a                	js     801a99 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a5f:	83 ec 08             	sub    $0x8,%esp
  801a62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a65:	50                   	push   %eax
  801a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a69:	ff 30                	pushl  (%eax)
  801a6b:	e8 e8 fc ff ff       	call   801758 <dev_lookup>
  801a70:	83 c4 10             	add    $0x10,%esp
  801a73:	85 c0                	test   %eax,%eax
  801a75:	78 22                	js     801a99 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a7e:	74 1e                	je     801a9e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a83:	8b 52 0c             	mov    0xc(%edx),%edx
  801a86:	85 d2                	test   %edx,%edx
  801a88:	74 35                	je     801abf <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	ff 75 10             	pushl  0x10(%ebp)
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	50                   	push   %eax
  801a94:	ff d2                	call   *%edx
  801a96:	83 c4 10             	add    $0x10,%esp
}
  801a99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a9e:	a1 08 50 80 00       	mov    0x805008,%eax
  801aa3:	8b 40 48             	mov    0x48(%eax),%eax
  801aa6:	83 ec 04             	sub    $0x4,%esp
  801aa9:	53                   	push   %ebx
  801aaa:	50                   	push   %eax
  801aab:	68 41 32 80 00       	push   $0x803241
  801ab0:	e8 a7 e8 ff ff       	call   80035c <cprintf>
		return -E_INVAL;
  801ab5:	83 c4 10             	add    $0x10,%esp
  801ab8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801abd:	eb da                	jmp    801a99 <write+0x55>
		return -E_NOT_SUPP;
  801abf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ac4:	eb d3                	jmp    801a99 <write+0x55>

00801ac6 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801acc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801acf:	50                   	push   %eax
  801ad0:	ff 75 08             	pushl  0x8(%ebp)
  801ad3:	e8 30 fc ff ff       	call   801708 <fd_lookup>
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	85 c0                	test   %eax,%eax
  801add:	78 0e                	js     801aed <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801adf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ae8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	53                   	push   %ebx
  801af3:	83 ec 1c             	sub    $0x1c,%esp
  801af6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801af9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801afc:	50                   	push   %eax
  801afd:	53                   	push   %ebx
  801afe:	e8 05 fc ff ff       	call   801708 <fd_lookup>
  801b03:	83 c4 10             	add    $0x10,%esp
  801b06:	85 c0                	test   %eax,%eax
  801b08:	78 37                	js     801b41 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b0a:	83 ec 08             	sub    $0x8,%esp
  801b0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b10:	50                   	push   %eax
  801b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b14:	ff 30                	pushl  (%eax)
  801b16:	e8 3d fc ff ff       	call   801758 <dev_lookup>
  801b1b:	83 c4 10             	add    $0x10,%esp
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	78 1f                	js     801b41 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b25:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b29:	74 1b                	je     801b46 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2e:	8b 52 18             	mov    0x18(%edx),%edx
  801b31:	85 d2                	test   %edx,%edx
  801b33:	74 32                	je     801b67 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b35:	83 ec 08             	sub    $0x8,%esp
  801b38:	ff 75 0c             	pushl  0xc(%ebp)
  801b3b:	50                   	push   %eax
  801b3c:	ff d2                	call   *%edx
  801b3e:	83 c4 10             	add    $0x10,%esp
}
  801b41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b46:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b4b:	8b 40 48             	mov    0x48(%eax),%eax
  801b4e:	83 ec 04             	sub    $0x4,%esp
  801b51:	53                   	push   %ebx
  801b52:	50                   	push   %eax
  801b53:	68 04 32 80 00       	push   $0x803204
  801b58:	e8 ff e7 ff ff       	call   80035c <cprintf>
		return -E_INVAL;
  801b5d:	83 c4 10             	add    $0x10,%esp
  801b60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b65:	eb da                	jmp    801b41 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b67:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b6c:	eb d3                	jmp    801b41 <ftruncate+0x52>

00801b6e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	53                   	push   %ebx
  801b72:	83 ec 1c             	sub    $0x1c,%esp
  801b75:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b78:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b7b:	50                   	push   %eax
  801b7c:	ff 75 08             	pushl  0x8(%ebp)
  801b7f:	e8 84 fb ff ff       	call   801708 <fd_lookup>
  801b84:	83 c4 10             	add    $0x10,%esp
  801b87:	85 c0                	test   %eax,%eax
  801b89:	78 4b                	js     801bd6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b8b:	83 ec 08             	sub    $0x8,%esp
  801b8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b91:	50                   	push   %eax
  801b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b95:	ff 30                	pushl  (%eax)
  801b97:	e8 bc fb ff ff       	call   801758 <dev_lookup>
  801b9c:	83 c4 10             	add    $0x10,%esp
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	78 33                	js     801bd6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801baa:	74 2f                	je     801bdb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bac:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801baf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bb6:	00 00 00 
	stat->st_isdir = 0;
  801bb9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bc0:	00 00 00 
	stat->st_dev = dev;
  801bc3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bc9:	83 ec 08             	sub    $0x8,%esp
  801bcc:	53                   	push   %ebx
  801bcd:	ff 75 f0             	pushl  -0x10(%ebp)
  801bd0:	ff 50 14             	call   *0x14(%eax)
  801bd3:	83 c4 10             	add    $0x10,%esp
}
  801bd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    
		return -E_NOT_SUPP;
  801bdb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801be0:	eb f4                	jmp    801bd6 <fstat+0x68>

00801be2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	56                   	push   %esi
  801be6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801be7:	83 ec 08             	sub    $0x8,%esp
  801bea:	6a 00                	push   $0x0
  801bec:	ff 75 08             	pushl  0x8(%ebp)
  801bef:	e8 22 02 00 00       	call   801e16 <open>
  801bf4:	89 c3                	mov    %eax,%ebx
  801bf6:	83 c4 10             	add    $0x10,%esp
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	78 1b                	js     801c18 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801bfd:	83 ec 08             	sub    $0x8,%esp
  801c00:	ff 75 0c             	pushl  0xc(%ebp)
  801c03:	50                   	push   %eax
  801c04:	e8 65 ff ff ff       	call   801b6e <fstat>
  801c09:	89 c6                	mov    %eax,%esi
	close(fd);
  801c0b:	89 1c 24             	mov    %ebx,(%esp)
  801c0e:	e8 27 fc ff ff       	call   80183a <close>
	return r;
  801c13:	83 c4 10             	add    $0x10,%esp
  801c16:	89 f3                	mov    %esi,%ebx
}
  801c18:	89 d8                	mov    %ebx,%eax
  801c1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1d:	5b                   	pop    %ebx
  801c1e:	5e                   	pop    %esi
  801c1f:	5d                   	pop    %ebp
  801c20:	c3                   	ret    

00801c21 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	56                   	push   %esi
  801c25:	53                   	push   %ebx
  801c26:	89 c6                	mov    %eax,%esi
  801c28:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c2a:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c31:	74 27                	je     801c5a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c33:	6a 07                	push   $0x7
  801c35:	68 00 60 80 00       	push   $0x806000
  801c3a:	56                   	push   %esi
  801c3b:	ff 35 00 50 80 00    	pushl  0x805000
  801c41:	e8 9d 0c 00 00       	call   8028e3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c46:	83 c4 0c             	add    $0xc,%esp
  801c49:	6a 00                	push   $0x0
  801c4b:	53                   	push   %ebx
  801c4c:	6a 00                	push   $0x0
  801c4e:	e8 27 0c 00 00       	call   80287a <ipc_recv>
}
  801c53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c56:	5b                   	pop    %ebx
  801c57:	5e                   	pop    %esi
  801c58:	5d                   	pop    %ebp
  801c59:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c5a:	83 ec 0c             	sub    $0xc,%esp
  801c5d:	6a 01                	push   $0x1
  801c5f:	e8 d7 0c 00 00       	call   80293b <ipc_find_env>
  801c64:	a3 00 50 80 00       	mov    %eax,0x805000
  801c69:	83 c4 10             	add    $0x10,%esp
  801c6c:	eb c5                	jmp    801c33 <fsipc+0x12>

00801c6e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	8b 40 0c             	mov    0xc(%eax),%eax
  801c7a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c82:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c87:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8c:	b8 02 00 00 00       	mov    $0x2,%eax
  801c91:	e8 8b ff ff ff       	call   801c21 <fsipc>
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <devfile_flush>:
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca4:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ca9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cae:	b8 06 00 00 00       	mov    $0x6,%eax
  801cb3:	e8 69 ff ff ff       	call   801c21 <fsipc>
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <devfile_stat>:
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	53                   	push   %ebx
  801cbe:	83 ec 04             	sub    $0x4,%esp
  801cc1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	8b 40 0c             	mov    0xc(%eax),%eax
  801cca:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ccf:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd4:	b8 05 00 00 00       	mov    $0x5,%eax
  801cd9:	e8 43 ff ff ff       	call   801c21 <fsipc>
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	78 2c                	js     801d0e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ce2:	83 ec 08             	sub    $0x8,%esp
  801ce5:	68 00 60 80 00       	push   $0x806000
  801cea:	53                   	push   %ebx
  801ceb:	e8 cb ed ff ff       	call   800abb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cf0:	a1 80 60 80 00       	mov    0x806080,%eax
  801cf5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cfb:	a1 84 60 80 00       	mov    0x806084,%eax
  801d00:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d06:	83 c4 10             	add    $0x10,%esp
  801d09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <devfile_write>:
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	53                   	push   %ebx
  801d17:	83 ec 08             	sub    $0x8,%esp
  801d1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	8b 40 0c             	mov    0xc(%eax),%eax
  801d23:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d28:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d2e:	53                   	push   %ebx
  801d2f:	ff 75 0c             	pushl  0xc(%ebp)
  801d32:	68 08 60 80 00       	push   $0x806008
  801d37:	e8 6f ef ff ff       	call   800cab <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d41:	b8 04 00 00 00       	mov    $0x4,%eax
  801d46:	e8 d6 fe ff ff       	call   801c21 <fsipc>
  801d4b:	83 c4 10             	add    $0x10,%esp
  801d4e:	85 c0                	test   %eax,%eax
  801d50:	78 0b                	js     801d5d <devfile_write+0x4a>
	assert(r <= n);
  801d52:	39 d8                	cmp    %ebx,%eax
  801d54:	77 0c                	ja     801d62 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d56:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d5b:	7f 1e                	jg     801d7b <devfile_write+0x68>
}
  801d5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    
	assert(r <= n);
  801d62:	68 74 32 80 00       	push   $0x803274
  801d67:	68 7b 32 80 00       	push   $0x80327b
  801d6c:	68 98 00 00 00       	push   $0x98
  801d71:	68 90 32 80 00       	push   $0x803290
  801d76:	e8 eb e4 ff ff       	call   800266 <_panic>
	assert(r <= PGSIZE);
  801d7b:	68 9b 32 80 00       	push   $0x80329b
  801d80:	68 7b 32 80 00       	push   $0x80327b
  801d85:	68 99 00 00 00       	push   $0x99
  801d8a:	68 90 32 80 00       	push   $0x803290
  801d8f:	e8 d2 e4 ff ff       	call   800266 <_panic>

00801d94 <devfile_read>:
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	56                   	push   %esi
  801d98:	53                   	push   %ebx
  801d99:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801da2:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801da7:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801dad:	ba 00 00 00 00       	mov    $0x0,%edx
  801db2:	b8 03 00 00 00       	mov    $0x3,%eax
  801db7:	e8 65 fe ff ff       	call   801c21 <fsipc>
  801dbc:	89 c3                	mov    %eax,%ebx
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	78 1f                	js     801de1 <devfile_read+0x4d>
	assert(r <= n);
  801dc2:	39 f0                	cmp    %esi,%eax
  801dc4:	77 24                	ja     801dea <devfile_read+0x56>
	assert(r <= PGSIZE);
  801dc6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dcb:	7f 33                	jg     801e00 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801dcd:	83 ec 04             	sub    $0x4,%esp
  801dd0:	50                   	push   %eax
  801dd1:	68 00 60 80 00       	push   $0x806000
  801dd6:	ff 75 0c             	pushl  0xc(%ebp)
  801dd9:	e8 6b ee ff ff       	call   800c49 <memmove>
	return r;
  801dde:	83 c4 10             	add    $0x10,%esp
}
  801de1:	89 d8                	mov    %ebx,%eax
  801de3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de6:	5b                   	pop    %ebx
  801de7:	5e                   	pop    %esi
  801de8:	5d                   	pop    %ebp
  801de9:	c3                   	ret    
	assert(r <= n);
  801dea:	68 74 32 80 00       	push   $0x803274
  801def:	68 7b 32 80 00       	push   $0x80327b
  801df4:	6a 7c                	push   $0x7c
  801df6:	68 90 32 80 00       	push   $0x803290
  801dfb:	e8 66 e4 ff ff       	call   800266 <_panic>
	assert(r <= PGSIZE);
  801e00:	68 9b 32 80 00       	push   $0x80329b
  801e05:	68 7b 32 80 00       	push   $0x80327b
  801e0a:	6a 7d                	push   $0x7d
  801e0c:	68 90 32 80 00       	push   $0x803290
  801e11:	e8 50 e4 ff ff       	call   800266 <_panic>

00801e16 <open>:
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	56                   	push   %esi
  801e1a:	53                   	push   %ebx
  801e1b:	83 ec 1c             	sub    $0x1c,%esp
  801e1e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e21:	56                   	push   %esi
  801e22:	e8 5b ec ff ff       	call   800a82 <strlen>
  801e27:	83 c4 10             	add    $0x10,%esp
  801e2a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e2f:	7f 6c                	jg     801e9d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e31:	83 ec 0c             	sub    $0xc,%esp
  801e34:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e37:	50                   	push   %eax
  801e38:	e8 79 f8 ff ff       	call   8016b6 <fd_alloc>
  801e3d:	89 c3                	mov    %eax,%ebx
  801e3f:	83 c4 10             	add    $0x10,%esp
  801e42:	85 c0                	test   %eax,%eax
  801e44:	78 3c                	js     801e82 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e46:	83 ec 08             	sub    $0x8,%esp
  801e49:	56                   	push   %esi
  801e4a:	68 00 60 80 00       	push   $0x806000
  801e4f:	e8 67 ec ff ff       	call   800abb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e57:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e5f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e64:	e8 b8 fd ff ff       	call   801c21 <fsipc>
  801e69:	89 c3                	mov    %eax,%ebx
  801e6b:	83 c4 10             	add    $0x10,%esp
  801e6e:	85 c0                	test   %eax,%eax
  801e70:	78 19                	js     801e8b <open+0x75>
	return fd2num(fd);
  801e72:	83 ec 0c             	sub    $0xc,%esp
  801e75:	ff 75 f4             	pushl  -0xc(%ebp)
  801e78:	e8 12 f8 ff ff       	call   80168f <fd2num>
  801e7d:	89 c3                	mov    %eax,%ebx
  801e7f:	83 c4 10             	add    $0x10,%esp
}
  801e82:	89 d8                	mov    %ebx,%eax
  801e84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5d                   	pop    %ebp
  801e8a:	c3                   	ret    
		fd_close(fd, 0);
  801e8b:	83 ec 08             	sub    $0x8,%esp
  801e8e:	6a 00                	push   $0x0
  801e90:	ff 75 f4             	pushl  -0xc(%ebp)
  801e93:	e8 1b f9 ff ff       	call   8017b3 <fd_close>
		return r;
  801e98:	83 c4 10             	add    $0x10,%esp
  801e9b:	eb e5                	jmp    801e82 <open+0x6c>
		return -E_BAD_PATH;
  801e9d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ea2:	eb de                	jmp    801e82 <open+0x6c>

00801ea4 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801eaa:	ba 00 00 00 00       	mov    $0x0,%edx
  801eaf:	b8 08 00 00 00       	mov    $0x8,%eax
  801eb4:	e8 68 fd ff ff       	call   801c21 <fsipc>
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ec1:	68 a7 32 80 00       	push   $0x8032a7
  801ec6:	ff 75 0c             	pushl  0xc(%ebp)
  801ec9:	e8 ed eb ff ff       	call   800abb <strcpy>
	return 0;
}
  801ece:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed3:	c9                   	leave  
  801ed4:	c3                   	ret    

00801ed5 <devsock_close>:
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	53                   	push   %ebx
  801ed9:	83 ec 10             	sub    $0x10,%esp
  801edc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801edf:	53                   	push   %ebx
  801ee0:	e8 95 0a 00 00       	call   80297a <pageref>
  801ee5:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ee8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801eed:	83 f8 01             	cmp    $0x1,%eax
  801ef0:	74 07                	je     801ef9 <devsock_close+0x24>
}
  801ef2:	89 d0                	mov    %edx,%eax
  801ef4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ef9:	83 ec 0c             	sub    $0xc,%esp
  801efc:	ff 73 0c             	pushl  0xc(%ebx)
  801eff:	e8 b9 02 00 00       	call   8021bd <nsipc_close>
  801f04:	89 c2                	mov    %eax,%edx
  801f06:	83 c4 10             	add    $0x10,%esp
  801f09:	eb e7                	jmp    801ef2 <devsock_close+0x1d>

00801f0b <devsock_write>:
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f11:	6a 00                	push   $0x0
  801f13:	ff 75 10             	pushl  0x10(%ebp)
  801f16:	ff 75 0c             	pushl  0xc(%ebp)
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	ff 70 0c             	pushl  0xc(%eax)
  801f1f:	e8 76 03 00 00       	call   80229a <nsipc_send>
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <devsock_read>:
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	ff 75 10             	pushl  0x10(%ebp)
  801f31:	ff 75 0c             	pushl  0xc(%ebp)
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	ff 70 0c             	pushl  0xc(%eax)
  801f3a:	e8 ef 02 00 00       	call   80222e <nsipc_recv>
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <fd2sockid>:
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
  801f44:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f47:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f4a:	52                   	push   %edx
  801f4b:	50                   	push   %eax
  801f4c:	e8 b7 f7 ff ff       	call   801708 <fd_lookup>
  801f51:	83 c4 10             	add    $0x10,%esp
  801f54:	85 c0                	test   %eax,%eax
  801f56:	78 10                	js     801f68 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5b:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f61:	39 08                	cmp    %ecx,(%eax)
  801f63:	75 05                	jne    801f6a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f65:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    
		return -E_NOT_SUPP;
  801f6a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f6f:	eb f7                	jmp    801f68 <fd2sockid+0x27>

00801f71 <alloc_sockfd>:
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	56                   	push   %esi
  801f75:	53                   	push   %ebx
  801f76:	83 ec 1c             	sub    $0x1c,%esp
  801f79:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f7e:	50                   	push   %eax
  801f7f:	e8 32 f7 ff ff       	call   8016b6 <fd_alloc>
  801f84:	89 c3                	mov    %eax,%ebx
  801f86:	83 c4 10             	add    $0x10,%esp
  801f89:	85 c0                	test   %eax,%eax
  801f8b:	78 43                	js     801fd0 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f8d:	83 ec 04             	sub    $0x4,%esp
  801f90:	68 07 04 00 00       	push   $0x407
  801f95:	ff 75 f4             	pushl  -0xc(%ebp)
  801f98:	6a 00                	push   $0x0
  801f9a:	e8 0e ef ff ff       	call   800ead <sys_page_alloc>
  801f9f:	89 c3                	mov    %eax,%ebx
  801fa1:	83 c4 10             	add    $0x10,%esp
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	78 28                	js     801fd0 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fab:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fb1:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fbd:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fc0:	83 ec 0c             	sub    $0xc,%esp
  801fc3:	50                   	push   %eax
  801fc4:	e8 c6 f6 ff ff       	call   80168f <fd2num>
  801fc9:	89 c3                	mov    %eax,%ebx
  801fcb:	83 c4 10             	add    $0x10,%esp
  801fce:	eb 0c                	jmp    801fdc <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fd0:	83 ec 0c             	sub    $0xc,%esp
  801fd3:	56                   	push   %esi
  801fd4:	e8 e4 01 00 00       	call   8021bd <nsipc_close>
		return r;
  801fd9:	83 c4 10             	add    $0x10,%esp
}
  801fdc:	89 d8                	mov    %ebx,%eax
  801fde:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fe1:	5b                   	pop    %ebx
  801fe2:	5e                   	pop    %esi
  801fe3:	5d                   	pop    %ebp
  801fe4:	c3                   	ret    

00801fe5 <accept>:
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	e8 4e ff ff ff       	call   801f41 <fd2sockid>
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	78 1b                	js     802012 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ff7:	83 ec 04             	sub    $0x4,%esp
  801ffa:	ff 75 10             	pushl  0x10(%ebp)
  801ffd:	ff 75 0c             	pushl  0xc(%ebp)
  802000:	50                   	push   %eax
  802001:	e8 0e 01 00 00       	call   802114 <nsipc_accept>
  802006:	83 c4 10             	add    $0x10,%esp
  802009:	85 c0                	test   %eax,%eax
  80200b:	78 05                	js     802012 <accept+0x2d>
	return alloc_sockfd(r);
  80200d:	e8 5f ff ff ff       	call   801f71 <alloc_sockfd>
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <bind>:
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	e8 1f ff ff ff       	call   801f41 <fd2sockid>
  802022:	85 c0                	test   %eax,%eax
  802024:	78 12                	js     802038 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	ff 75 10             	pushl  0x10(%ebp)
  80202c:	ff 75 0c             	pushl  0xc(%ebp)
  80202f:	50                   	push   %eax
  802030:	e8 31 01 00 00       	call   802166 <nsipc_bind>
  802035:	83 c4 10             	add    $0x10,%esp
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <shutdown>:
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	e8 f9 fe ff ff       	call   801f41 <fd2sockid>
  802048:	85 c0                	test   %eax,%eax
  80204a:	78 0f                	js     80205b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80204c:	83 ec 08             	sub    $0x8,%esp
  80204f:	ff 75 0c             	pushl  0xc(%ebp)
  802052:	50                   	push   %eax
  802053:	e8 43 01 00 00       	call   80219b <nsipc_shutdown>
  802058:	83 c4 10             	add    $0x10,%esp
}
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <connect>:
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	e8 d6 fe ff ff       	call   801f41 <fd2sockid>
  80206b:	85 c0                	test   %eax,%eax
  80206d:	78 12                	js     802081 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80206f:	83 ec 04             	sub    $0x4,%esp
  802072:	ff 75 10             	pushl  0x10(%ebp)
  802075:	ff 75 0c             	pushl  0xc(%ebp)
  802078:	50                   	push   %eax
  802079:	e8 59 01 00 00       	call   8021d7 <nsipc_connect>
  80207e:	83 c4 10             	add    $0x10,%esp
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <listen>:
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	e8 b0 fe ff ff       	call   801f41 <fd2sockid>
  802091:	85 c0                	test   %eax,%eax
  802093:	78 0f                	js     8020a4 <listen+0x21>
	return nsipc_listen(r, backlog);
  802095:	83 ec 08             	sub    $0x8,%esp
  802098:	ff 75 0c             	pushl  0xc(%ebp)
  80209b:	50                   	push   %eax
  80209c:	e8 6b 01 00 00       	call   80220c <nsipc_listen>
  8020a1:	83 c4 10             	add    $0x10,%esp
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020ac:	ff 75 10             	pushl  0x10(%ebp)
  8020af:	ff 75 0c             	pushl  0xc(%ebp)
  8020b2:	ff 75 08             	pushl  0x8(%ebp)
  8020b5:	e8 3e 02 00 00       	call   8022f8 <nsipc_socket>
  8020ba:	83 c4 10             	add    $0x10,%esp
  8020bd:	85 c0                	test   %eax,%eax
  8020bf:	78 05                	js     8020c6 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020c1:	e8 ab fe ff ff       	call   801f71 <alloc_sockfd>
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	53                   	push   %ebx
  8020cc:	83 ec 04             	sub    $0x4,%esp
  8020cf:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020d1:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020d8:	74 26                	je     802100 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020da:	6a 07                	push   $0x7
  8020dc:	68 00 70 80 00       	push   $0x807000
  8020e1:	53                   	push   %ebx
  8020e2:	ff 35 04 50 80 00    	pushl  0x805004
  8020e8:	e8 f6 07 00 00       	call   8028e3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020ed:	83 c4 0c             	add    $0xc,%esp
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	e8 7f 07 00 00       	call   80287a <ipc_recv>
}
  8020fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802100:	83 ec 0c             	sub    $0xc,%esp
  802103:	6a 02                	push   $0x2
  802105:	e8 31 08 00 00       	call   80293b <ipc_find_env>
  80210a:	a3 04 50 80 00       	mov    %eax,0x805004
  80210f:	83 c4 10             	add    $0x10,%esp
  802112:	eb c6                	jmp    8020da <nsipc+0x12>

00802114 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	56                   	push   %esi
  802118:	53                   	push   %ebx
  802119:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802124:	8b 06                	mov    (%esi),%eax
  802126:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80212b:	b8 01 00 00 00       	mov    $0x1,%eax
  802130:	e8 93 ff ff ff       	call   8020c8 <nsipc>
  802135:	89 c3                	mov    %eax,%ebx
  802137:	85 c0                	test   %eax,%eax
  802139:	79 09                	jns    802144 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80213b:	89 d8                	mov    %ebx,%eax
  80213d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802140:	5b                   	pop    %ebx
  802141:	5e                   	pop    %esi
  802142:	5d                   	pop    %ebp
  802143:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802144:	83 ec 04             	sub    $0x4,%esp
  802147:	ff 35 10 70 80 00    	pushl  0x807010
  80214d:	68 00 70 80 00       	push   $0x807000
  802152:	ff 75 0c             	pushl  0xc(%ebp)
  802155:	e8 ef ea ff ff       	call   800c49 <memmove>
		*addrlen = ret->ret_addrlen;
  80215a:	a1 10 70 80 00       	mov    0x807010,%eax
  80215f:	89 06                	mov    %eax,(%esi)
  802161:	83 c4 10             	add    $0x10,%esp
	return r;
  802164:	eb d5                	jmp    80213b <nsipc_accept+0x27>

00802166 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	53                   	push   %ebx
  80216a:	83 ec 08             	sub    $0x8,%esp
  80216d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802178:	53                   	push   %ebx
  802179:	ff 75 0c             	pushl  0xc(%ebp)
  80217c:	68 04 70 80 00       	push   $0x807004
  802181:	e8 c3 ea ff ff       	call   800c49 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802186:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80218c:	b8 02 00 00 00       	mov    $0x2,%eax
  802191:	e8 32 ff ff ff       	call   8020c8 <nsipc>
}
  802196:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ac:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021b1:	b8 03 00 00 00       	mov    $0x3,%eax
  8021b6:	e8 0d ff ff ff       	call   8020c8 <nsipc>
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <nsipc_close>:

int
nsipc_close(int s)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021cb:	b8 04 00 00 00       	mov    $0x4,%eax
  8021d0:	e8 f3 fe ff ff       	call   8020c8 <nsipc>
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
  8021da:	53                   	push   %ebx
  8021db:	83 ec 08             	sub    $0x8,%esp
  8021de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021e9:	53                   	push   %ebx
  8021ea:	ff 75 0c             	pushl  0xc(%ebp)
  8021ed:	68 04 70 80 00       	push   $0x807004
  8021f2:	e8 52 ea ff ff       	call   800c49 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021f7:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021fd:	b8 05 00 00 00       	mov    $0x5,%eax
  802202:	e8 c1 fe ff ff       	call   8020c8 <nsipc>
}
  802207:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80221a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221d:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802222:	b8 06 00 00 00       	mov    $0x6,%eax
  802227:	e8 9c fe ff ff       	call   8020c8 <nsipc>
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	56                   	push   %esi
  802232:	53                   	push   %ebx
  802233:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80223e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802244:	8b 45 14             	mov    0x14(%ebp),%eax
  802247:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80224c:	b8 07 00 00 00       	mov    $0x7,%eax
  802251:	e8 72 fe ff ff       	call   8020c8 <nsipc>
  802256:	89 c3                	mov    %eax,%ebx
  802258:	85 c0                	test   %eax,%eax
  80225a:	78 1f                	js     80227b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80225c:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802261:	7f 21                	jg     802284 <nsipc_recv+0x56>
  802263:	39 c6                	cmp    %eax,%esi
  802265:	7c 1d                	jl     802284 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802267:	83 ec 04             	sub    $0x4,%esp
  80226a:	50                   	push   %eax
  80226b:	68 00 70 80 00       	push   $0x807000
  802270:	ff 75 0c             	pushl  0xc(%ebp)
  802273:	e8 d1 e9 ff ff       	call   800c49 <memmove>
  802278:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80227b:	89 d8                	mov    %ebx,%eax
  80227d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802280:	5b                   	pop    %ebx
  802281:	5e                   	pop    %esi
  802282:	5d                   	pop    %ebp
  802283:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802284:	68 b3 32 80 00       	push   $0x8032b3
  802289:	68 7b 32 80 00       	push   $0x80327b
  80228e:	6a 62                	push   $0x62
  802290:	68 c8 32 80 00       	push   $0x8032c8
  802295:	e8 cc df ff ff       	call   800266 <_panic>

0080229a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	53                   	push   %ebx
  80229e:	83 ec 04             	sub    $0x4,%esp
  8022a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022ac:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022b2:	7f 2e                	jg     8022e2 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022b4:	83 ec 04             	sub    $0x4,%esp
  8022b7:	53                   	push   %ebx
  8022b8:	ff 75 0c             	pushl  0xc(%ebp)
  8022bb:	68 0c 70 80 00       	push   $0x80700c
  8022c0:	e8 84 e9 ff ff       	call   800c49 <memmove>
	nsipcbuf.send.req_size = size;
  8022c5:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8022ce:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022d3:	b8 08 00 00 00       	mov    $0x8,%eax
  8022d8:	e8 eb fd ff ff       	call   8020c8 <nsipc>
}
  8022dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    
	assert(size < 1600);
  8022e2:	68 d4 32 80 00       	push   $0x8032d4
  8022e7:	68 7b 32 80 00       	push   $0x80327b
  8022ec:	6a 6d                	push   $0x6d
  8022ee:	68 c8 32 80 00       	push   $0x8032c8
  8022f3:	e8 6e df ff ff       	call   800266 <_panic>

008022f8 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802306:	8b 45 0c             	mov    0xc(%ebp),%eax
  802309:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80230e:	8b 45 10             	mov    0x10(%ebp),%eax
  802311:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802316:	b8 09 00 00 00       	mov    $0x9,%eax
  80231b:	e8 a8 fd ff ff       	call   8020c8 <nsipc>
}
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	56                   	push   %esi
  802326:	53                   	push   %ebx
  802327:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80232a:	83 ec 0c             	sub    $0xc,%esp
  80232d:	ff 75 08             	pushl  0x8(%ebp)
  802330:	e8 6a f3 ff ff       	call   80169f <fd2data>
  802335:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802337:	83 c4 08             	add    $0x8,%esp
  80233a:	68 e0 32 80 00       	push   $0x8032e0
  80233f:	53                   	push   %ebx
  802340:	e8 76 e7 ff ff       	call   800abb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802345:	8b 46 04             	mov    0x4(%esi),%eax
  802348:	2b 06                	sub    (%esi),%eax
  80234a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802350:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802357:	00 00 00 
	stat->st_dev = &devpipe;
  80235a:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802361:	40 80 00 
	return 0;
}
  802364:	b8 00 00 00 00       	mov    $0x0,%eax
  802369:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80236c:	5b                   	pop    %ebx
  80236d:	5e                   	pop    %esi
  80236e:	5d                   	pop    %ebp
  80236f:	c3                   	ret    

00802370 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	53                   	push   %ebx
  802374:	83 ec 0c             	sub    $0xc,%esp
  802377:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80237a:	53                   	push   %ebx
  80237b:	6a 00                	push   $0x0
  80237d:	e8 b0 eb ff ff       	call   800f32 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802382:	89 1c 24             	mov    %ebx,(%esp)
  802385:	e8 15 f3 ff ff       	call   80169f <fd2data>
  80238a:	83 c4 08             	add    $0x8,%esp
  80238d:	50                   	push   %eax
  80238e:	6a 00                	push   $0x0
  802390:	e8 9d eb ff ff       	call   800f32 <sys_page_unmap>
}
  802395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802398:	c9                   	leave  
  802399:	c3                   	ret    

0080239a <_pipeisclosed>:
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
  80239d:	57                   	push   %edi
  80239e:	56                   	push   %esi
  80239f:	53                   	push   %ebx
  8023a0:	83 ec 1c             	sub    $0x1c,%esp
  8023a3:	89 c7                	mov    %eax,%edi
  8023a5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023a7:	a1 08 50 80 00       	mov    0x805008,%eax
  8023ac:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023af:	83 ec 0c             	sub    $0xc,%esp
  8023b2:	57                   	push   %edi
  8023b3:	e8 c2 05 00 00       	call   80297a <pageref>
  8023b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023bb:	89 34 24             	mov    %esi,(%esp)
  8023be:	e8 b7 05 00 00       	call   80297a <pageref>
		nn = thisenv->env_runs;
  8023c3:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8023c9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023cc:	83 c4 10             	add    $0x10,%esp
  8023cf:	39 cb                	cmp    %ecx,%ebx
  8023d1:	74 1b                	je     8023ee <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023d3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023d6:	75 cf                	jne    8023a7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023d8:	8b 42 58             	mov    0x58(%edx),%eax
  8023db:	6a 01                	push   $0x1
  8023dd:	50                   	push   %eax
  8023de:	53                   	push   %ebx
  8023df:	68 e7 32 80 00       	push   $0x8032e7
  8023e4:	e8 73 df ff ff       	call   80035c <cprintf>
  8023e9:	83 c4 10             	add    $0x10,%esp
  8023ec:	eb b9                	jmp    8023a7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8023ee:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023f1:	0f 94 c0             	sete   %al
  8023f4:	0f b6 c0             	movzbl %al,%eax
}
  8023f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023fa:	5b                   	pop    %ebx
  8023fb:	5e                   	pop    %esi
  8023fc:	5f                   	pop    %edi
  8023fd:	5d                   	pop    %ebp
  8023fe:	c3                   	ret    

008023ff <devpipe_write>:
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
  802402:	57                   	push   %edi
  802403:	56                   	push   %esi
  802404:	53                   	push   %ebx
  802405:	83 ec 28             	sub    $0x28,%esp
  802408:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80240b:	56                   	push   %esi
  80240c:	e8 8e f2 ff ff       	call   80169f <fd2data>
  802411:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802413:	83 c4 10             	add    $0x10,%esp
  802416:	bf 00 00 00 00       	mov    $0x0,%edi
  80241b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80241e:	74 4f                	je     80246f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802420:	8b 43 04             	mov    0x4(%ebx),%eax
  802423:	8b 0b                	mov    (%ebx),%ecx
  802425:	8d 51 20             	lea    0x20(%ecx),%edx
  802428:	39 d0                	cmp    %edx,%eax
  80242a:	72 14                	jb     802440 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80242c:	89 da                	mov    %ebx,%edx
  80242e:	89 f0                	mov    %esi,%eax
  802430:	e8 65 ff ff ff       	call   80239a <_pipeisclosed>
  802435:	85 c0                	test   %eax,%eax
  802437:	75 3b                	jne    802474 <devpipe_write+0x75>
			sys_yield();
  802439:	e8 50 ea ff ff       	call   800e8e <sys_yield>
  80243e:	eb e0                	jmp    802420 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802440:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802443:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802447:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80244a:	89 c2                	mov    %eax,%edx
  80244c:	c1 fa 1f             	sar    $0x1f,%edx
  80244f:	89 d1                	mov    %edx,%ecx
  802451:	c1 e9 1b             	shr    $0x1b,%ecx
  802454:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802457:	83 e2 1f             	and    $0x1f,%edx
  80245a:	29 ca                	sub    %ecx,%edx
  80245c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802460:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802464:	83 c0 01             	add    $0x1,%eax
  802467:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80246a:	83 c7 01             	add    $0x1,%edi
  80246d:	eb ac                	jmp    80241b <devpipe_write+0x1c>
	return i;
  80246f:	8b 45 10             	mov    0x10(%ebp),%eax
  802472:	eb 05                	jmp    802479 <devpipe_write+0x7a>
				return 0;
  802474:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802479:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80247c:	5b                   	pop    %ebx
  80247d:	5e                   	pop    %esi
  80247e:	5f                   	pop    %edi
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    

00802481 <devpipe_read>:
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	57                   	push   %edi
  802485:	56                   	push   %esi
  802486:	53                   	push   %ebx
  802487:	83 ec 18             	sub    $0x18,%esp
  80248a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80248d:	57                   	push   %edi
  80248e:	e8 0c f2 ff ff       	call   80169f <fd2data>
  802493:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802495:	83 c4 10             	add    $0x10,%esp
  802498:	be 00 00 00 00       	mov    $0x0,%esi
  80249d:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024a0:	75 14                	jne    8024b6 <devpipe_read+0x35>
	return i;
  8024a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024a5:	eb 02                	jmp    8024a9 <devpipe_read+0x28>
				return i;
  8024a7:	89 f0                	mov    %esi,%eax
}
  8024a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ac:	5b                   	pop    %ebx
  8024ad:	5e                   	pop    %esi
  8024ae:	5f                   	pop    %edi
  8024af:	5d                   	pop    %ebp
  8024b0:	c3                   	ret    
			sys_yield();
  8024b1:	e8 d8 e9 ff ff       	call   800e8e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024b6:	8b 03                	mov    (%ebx),%eax
  8024b8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024bb:	75 18                	jne    8024d5 <devpipe_read+0x54>
			if (i > 0)
  8024bd:	85 f6                	test   %esi,%esi
  8024bf:	75 e6                	jne    8024a7 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024c1:	89 da                	mov    %ebx,%edx
  8024c3:	89 f8                	mov    %edi,%eax
  8024c5:	e8 d0 fe ff ff       	call   80239a <_pipeisclosed>
  8024ca:	85 c0                	test   %eax,%eax
  8024cc:	74 e3                	je     8024b1 <devpipe_read+0x30>
				return 0;
  8024ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d3:	eb d4                	jmp    8024a9 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024d5:	99                   	cltd   
  8024d6:	c1 ea 1b             	shr    $0x1b,%edx
  8024d9:	01 d0                	add    %edx,%eax
  8024db:	83 e0 1f             	and    $0x1f,%eax
  8024de:	29 d0                	sub    %edx,%eax
  8024e0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024e8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024eb:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8024ee:	83 c6 01             	add    $0x1,%esi
  8024f1:	eb aa                	jmp    80249d <devpipe_read+0x1c>

008024f3 <pipe>:
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
  8024f6:	56                   	push   %esi
  8024f7:	53                   	push   %ebx
  8024f8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8024fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024fe:	50                   	push   %eax
  8024ff:	e8 b2 f1 ff ff       	call   8016b6 <fd_alloc>
  802504:	89 c3                	mov    %eax,%ebx
  802506:	83 c4 10             	add    $0x10,%esp
  802509:	85 c0                	test   %eax,%eax
  80250b:	0f 88 23 01 00 00    	js     802634 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802511:	83 ec 04             	sub    $0x4,%esp
  802514:	68 07 04 00 00       	push   $0x407
  802519:	ff 75 f4             	pushl  -0xc(%ebp)
  80251c:	6a 00                	push   $0x0
  80251e:	e8 8a e9 ff ff       	call   800ead <sys_page_alloc>
  802523:	89 c3                	mov    %eax,%ebx
  802525:	83 c4 10             	add    $0x10,%esp
  802528:	85 c0                	test   %eax,%eax
  80252a:	0f 88 04 01 00 00    	js     802634 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802530:	83 ec 0c             	sub    $0xc,%esp
  802533:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802536:	50                   	push   %eax
  802537:	e8 7a f1 ff ff       	call   8016b6 <fd_alloc>
  80253c:	89 c3                	mov    %eax,%ebx
  80253e:	83 c4 10             	add    $0x10,%esp
  802541:	85 c0                	test   %eax,%eax
  802543:	0f 88 db 00 00 00    	js     802624 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802549:	83 ec 04             	sub    $0x4,%esp
  80254c:	68 07 04 00 00       	push   $0x407
  802551:	ff 75 f0             	pushl  -0x10(%ebp)
  802554:	6a 00                	push   $0x0
  802556:	e8 52 e9 ff ff       	call   800ead <sys_page_alloc>
  80255b:	89 c3                	mov    %eax,%ebx
  80255d:	83 c4 10             	add    $0x10,%esp
  802560:	85 c0                	test   %eax,%eax
  802562:	0f 88 bc 00 00 00    	js     802624 <pipe+0x131>
	va = fd2data(fd0);
  802568:	83 ec 0c             	sub    $0xc,%esp
  80256b:	ff 75 f4             	pushl  -0xc(%ebp)
  80256e:	e8 2c f1 ff ff       	call   80169f <fd2data>
  802573:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802575:	83 c4 0c             	add    $0xc,%esp
  802578:	68 07 04 00 00       	push   $0x407
  80257d:	50                   	push   %eax
  80257e:	6a 00                	push   $0x0
  802580:	e8 28 e9 ff ff       	call   800ead <sys_page_alloc>
  802585:	89 c3                	mov    %eax,%ebx
  802587:	83 c4 10             	add    $0x10,%esp
  80258a:	85 c0                	test   %eax,%eax
  80258c:	0f 88 82 00 00 00    	js     802614 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802592:	83 ec 0c             	sub    $0xc,%esp
  802595:	ff 75 f0             	pushl  -0x10(%ebp)
  802598:	e8 02 f1 ff ff       	call   80169f <fd2data>
  80259d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025a4:	50                   	push   %eax
  8025a5:	6a 00                	push   $0x0
  8025a7:	56                   	push   %esi
  8025a8:	6a 00                	push   $0x0
  8025aa:	e8 41 e9 ff ff       	call   800ef0 <sys_page_map>
  8025af:	89 c3                	mov    %eax,%ebx
  8025b1:	83 c4 20             	add    $0x20,%esp
  8025b4:	85 c0                	test   %eax,%eax
  8025b6:	78 4e                	js     802606 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8025b8:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8025bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c0:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025cf:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025db:	83 ec 0c             	sub    $0xc,%esp
  8025de:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e1:	e8 a9 f0 ff ff       	call   80168f <fd2num>
  8025e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025e9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025eb:	83 c4 04             	add    $0x4,%esp
  8025ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8025f1:	e8 99 f0 ff ff       	call   80168f <fd2num>
  8025f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025f9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025fc:	83 c4 10             	add    $0x10,%esp
  8025ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  802604:	eb 2e                	jmp    802634 <pipe+0x141>
	sys_page_unmap(0, va);
  802606:	83 ec 08             	sub    $0x8,%esp
  802609:	56                   	push   %esi
  80260a:	6a 00                	push   $0x0
  80260c:	e8 21 e9 ff ff       	call   800f32 <sys_page_unmap>
  802611:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802614:	83 ec 08             	sub    $0x8,%esp
  802617:	ff 75 f0             	pushl  -0x10(%ebp)
  80261a:	6a 00                	push   $0x0
  80261c:	e8 11 e9 ff ff       	call   800f32 <sys_page_unmap>
  802621:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802624:	83 ec 08             	sub    $0x8,%esp
  802627:	ff 75 f4             	pushl  -0xc(%ebp)
  80262a:	6a 00                	push   $0x0
  80262c:	e8 01 e9 ff ff       	call   800f32 <sys_page_unmap>
  802631:	83 c4 10             	add    $0x10,%esp
}
  802634:	89 d8                	mov    %ebx,%eax
  802636:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802639:	5b                   	pop    %ebx
  80263a:	5e                   	pop    %esi
  80263b:	5d                   	pop    %ebp
  80263c:	c3                   	ret    

0080263d <pipeisclosed>:
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
  802640:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802643:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802646:	50                   	push   %eax
  802647:	ff 75 08             	pushl  0x8(%ebp)
  80264a:	e8 b9 f0 ff ff       	call   801708 <fd_lookup>
  80264f:	83 c4 10             	add    $0x10,%esp
  802652:	85 c0                	test   %eax,%eax
  802654:	78 18                	js     80266e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802656:	83 ec 0c             	sub    $0xc,%esp
  802659:	ff 75 f4             	pushl  -0xc(%ebp)
  80265c:	e8 3e f0 ff ff       	call   80169f <fd2data>
	return _pipeisclosed(fd, p);
  802661:	89 c2                	mov    %eax,%edx
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	e8 2f fd ff ff       	call   80239a <_pipeisclosed>
  80266b:	83 c4 10             	add    $0x10,%esp
}
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802670:	b8 00 00 00 00       	mov    $0x0,%eax
  802675:	c3                   	ret    

00802676 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
  802679:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80267c:	68 ff 32 80 00       	push   $0x8032ff
  802681:	ff 75 0c             	pushl  0xc(%ebp)
  802684:	e8 32 e4 ff ff       	call   800abb <strcpy>
	return 0;
}
  802689:	b8 00 00 00 00       	mov    $0x0,%eax
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <devcons_write>:
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	57                   	push   %edi
  802694:	56                   	push   %esi
  802695:	53                   	push   %ebx
  802696:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80269c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026a1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026a7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026aa:	73 31                	jae    8026dd <devcons_write+0x4d>
		m = n - tot;
  8026ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026af:	29 f3                	sub    %esi,%ebx
  8026b1:	83 fb 7f             	cmp    $0x7f,%ebx
  8026b4:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8026b9:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8026bc:	83 ec 04             	sub    $0x4,%esp
  8026bf:	53                   	push   %ebx
  8026c0:	89 f0                	mov    %esi,%eax
  8026c2:	03 45 0c             	add    0xc(%ebp),%eax
  8026c5:	50                   	push   %eax
  8026c6:	57                   	push   %edi
  8026c7:	e8 7d e5 ff ff       	call   800c49 <memmove>
		sys_cputs(buf, m);
  8026cc:	83 c4 08             	add    $0x8,%esp
  8026cf:	53                   	push   %ebx
  8026d0:	57                   	push   %edi
  8026d1:	e8 1b e7 ff ff       	call   800df1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8026d6:	01 de                	add    %ebx,%esi
  8026d8:	83 c4 10             	add    $0x10,%esp
  8026db:	eb ca                	jmp    8026a7 <devcons_write+0x17>
}
  8026dd:	89 f0                	mov    %esi,%eax
  8026df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026e2:	5b                   	pop    %ebx
  8026e3:	5e                   	pop    %esi
  8026e4:	5f                   	pop    %edi
  8026e5:	5d                   	pop    %ebp
  8026e6:	c3                   	ret    

008026e7 <devcons_read>:
{
  8026e7:	55                   	push   %ebp
  8026e8:	89 e5                	mov    %esp,%ebp
  8026ea:	83 ec 08             	sub    $0x8,%esp
  8026ed:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8026f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026f6:	74 21                	je     802719 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8026f8:	e8 12 e7 ff ff       	call   800e0f <sys_cgetc>
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	75 07                	jne    802708 <devcons_read+0x21>
		sys_yield();
  802701:	e8 88 e7 ff ff       	call   800e8e <sys_yield>
  802706:	eb f0                	jmp    8026f8 <devcons_read+0x11>
	if (c < 0)
  802708:	78 0f                	js     802719 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80270a:	83 f8 04             	cmp    $0x4,%eax
  80270d:	74 0c                	je     80271b <devcons_read+0x34>
	*(char*)vbuf = c;
  80270f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802712:	88 02                	mov    %al,(%edx)
	return 1;
  802714:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802719:	c9                   	leave  
  80271a:	c3                   	ret    
		return 0;
  80271b:	b8 00 00 00 00       	mov    $0x0,%eax
  802720:	eb f7                	jmp    802719 <devcons_read+0x32>

00802722 <cputchar>:
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
  802725:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802728:	8b 45 08             	mov    0x8(%ebp),%eax
  80272b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80272e:	6a 01                	push   $0x1
  802730:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802733:	50                   	push   %eax
  802734:	e8 b8 e6 ff ff       	call   800df1 <sys_cputs>
}
  802739:	83 c4 10             	add    $0x10,%esp
  80273c:	c9                   	leave  
  80273d:	c3                   	ret    

0080273e <getchar>:
{
  80273e:	55                   	push   %ebp
  80273f:	89 e5                	mov    %esp,%ebp
  802741:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802744:	6a 01                	push   $0x1
  802746:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802749:	50                   	push   %eax
  80274a:	6a 00                	push   $0x0
  80274c:	e8 27 f2 ff ff       	call   801978 <read>
	if (r < 0)
  802751:	83 c4 10             	add    $0x10,%esp
  802754:	85 c0                	test   %eax,%eax
  802756:	78 06                	js     80275e <getchar+0x20>
	if (r < 1)
  802758:	74 06                	je     802760 <getchar+0x22>
	return c;
  80275a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80275e:	c9                   	leave  
  80275f:	c3                   	ret    
		return -E_EOF;
  802760:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802765:	eb f7                	jmp    80275e <getchar+0x20>

00802767 <iscons>:
{
  802767:	55                   	push   %ebp
  802768:	89 e5                	mov    %esp,%ebp
  80276a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80276d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802770:	50                   	push   %eax
  802771:	ff 75 08             	pushl  0x8(%ebp)
  802774:	e8 8f ef ff ff       	call   801708 <fd_lookup>
  802779:	83 c4 10             	add    $0x10,%esp
  80277c:	85 c0                	test   %eax,%eax
  80277e:	78 11                	js     802791 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802789:	39 10                	cmp    %edx,(%eax)
  80278b:	0f 94 c0             	sete   %al
  80278e:	0f b6 c0             	movzbl %al,%eax
}
  802791:	c9                   	leave  
  802792:	c3                   	ret    

00802793 <opencons>:
{
  802793:	55                   	push   %ebp
  802794:	89 e5                	mov    %esp,%ebp
  802796:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802799:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80279c:	50                   	push   %eax
  80279d:	e8 14 ef ff ff       	call   8016b6 <fd_alloc>
  8027a2:	83 c4 10             	add    $0x10,%esp
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	78 3a                	js     8027e3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027a9:	83 ec 04             	sub    $0x4,%esp
  8027ac:	68 07 04 00 00       	push   $0x407
  8027b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8027b4:	6a 00                	push   $0x0
  8027b6:	e8 f2 e6 ff ff       	call   800ead <sys_page_alloc>
  8027bb:	83 c4 10             	add    $0x10,%esp
  8027be:	85 c0                	test   %eax,%eax
  8027c0:	78 21                	js     8027e3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027cb:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027d7:	83 ec 0c             	sub    $0xc,%esp
  8027da:	50                   	push   %eax
  8027db:	e8 af ee ff ff       	call   80168f <fd2num>
  8027e0:	83 c4 10             	add    $0x10,%esp
}
  8027e3:	c9                   	leave  
  8027e4:	c3                   	ret    

008027e5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
  8027e8:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8027eb:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8027f2:	74 0a                	je     8027fe <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f7:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8027fc:	c9                   	leave  
  8027fd:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8027fe:	83 ec 04             	sub    $0x4,%esp
  802801:	6a 07                	push   $0x7
  802803:	68 00 f0 bf ee       	push   $0xeebff000
  802808:	6a 00                	push   $0x0
  80280a:	e8 9e e6 ff ff       	call   800ead <sys_page_alloc>
		if(r < 0)
  80280f:	83 c4 10             	add    $0x10,%esp
  802812:	85 c0                	test   %eax,%eax
  802814:	78 2a                	js     802840 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802816:	83 ec 08             	sub    $0x8,%esp
  802819:	68 54 28 80 00       	push   $0x802854
  80281e:	6a 00                	push   $0x0
  802820:	e8 d3 e7 ff ff       	call   800ff8 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802825:	83 c4 10             	add    $0x10,%esp
  802828:	85 c0                	test   %eax,%eax
  80282a:	79 c8                	jns    8027f4 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80282c:	83 ec 04             	sub    $0x4,%esp
  80282f:	68 3c 33 80 00       	push   $0x80333c
  802834:	6a 25                	push   $0x25
  802836:	68 78 33 80 00       	push   $0x803378
  80283b:	e8 26 da ff ff       	call   800266 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802840:	83 ec 04             	sub    $0x4,%esp
  802843:	68 0c 33 80 00       	push   $0x80330c
  802848:	6a 22                	push   $0x22
  80284a:	68 78 33 80 00       	push   $0x803378
  80284f:	e8 12 da ff ff       	call   800266 <_panic>

00802854 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802854:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802855:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80285a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80285c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80285f:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802863:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802867:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80286a:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80286c:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802870:	83 c4 08             	add    $0x8,%esp
	popal
  802873:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802874:	83 c4 04             	add    $0x4,%esp
	popfl
  802877:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802878:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802879:	c3                   	ret    

0080287a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80287a:	55                   	push   %ebp
  80287b:	89 e5                	mov    %esp,%ebp
  80287d:	56                   	push   %esi
  80287e:	53                   	push   %ebx
  80287f:	8b 75 08             	mov    0x8(%ebp),%esi
  802882:	8b 45 0c             	mov    0xc(%ebp),%eax
  802885:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802888:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80288a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80288f:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802892:	83 ec 0c             	sub    $0xc,%esp
  802895:	50                   	push   %eax
  802896:	e8 c2 e7 ff ff       	call   80105d <sys_ipc_recv>
	if(ret < 0){
  80289b:	83 c4 10             	add    $0x10,%esp
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	78 2b                	js     8028cd <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8028a2:	85 f6                	test   %esi,%esi
  8028a4:	74 0a                	je     8028b0 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8028a6:	a1 08 50 80 00       	mov    0x805008,%eax
  8028ab:	8b 40 78             	mov    0x78(%eax),%eax
  8028ae:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8028b0:	85 db                	test   %ebx,%ebx
  8028b2:	74 0a                	je     8028be <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8028b4:	a1 08 50 80 00       	mov    0x805008,%eax
  8028b9:	8b 40 7c             	mov    0x7c(%eax),%eax
  8028bc:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8028be:	a1 08 50 80 00       	mov    0x805008,%eax
  8028c3:	8b 40 74             	mov    0x74(%eax),%eax
}
  8028c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028c9:	5b                   	pop    %ebx
  8028ca:	5e                   	pop    %esi
  8028cb:	5d                   	pop    %ebp
  8028cc:	c3                   	ret    
		if(from_env_store)
  8028cd:	85 f6                	test   %esi,%esi
  8028cf:	74 06                	je     8028d7 <ipc_recv+0x5d>
			*from_env_store = 0;
  8028d1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8028d7:	85 db                	test   %ebx,%ebx
  8028d9:	74 eb                	je     8028c6 <ipc_recv+0x4c>
			*perm_store = 0;
  8028db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8028e1:	eb e3                	jmp    8028c6 <ipc_recv+0x4c>

008028e3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
  8028e6:	57                   	push   %edi
  8028e7:	56                   	push   %esi
  8028e8:	53                   	push   %ebx
  8028e9:	83 ec 0c             	sub    $0xc,%esp
  8028ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  8028ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8028f5:	85 db                	test   %ebx,%ebx
  8028f7:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8028fc:	0f 44 d8             	cmove  %eax,%ebx
  8028ff:	eb 05                	jmp    802906 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802901:	e8 88 e5 ff ff       	call   800e8e <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802906:	ff 75 14             	pushl  0x14(%ebp)
  802909:	53                   	push   %ebx
  80290a:	56                   	push   %esi
  80290b:	57                   	push   %edi
  80290c:	e8 29 e7 ff ff       	call   80103a <sys_ipc_try_send>
  802911:	83 c4 10             	add    $0x10,%esp
  802914:	85 c0                	test   %eax,%eax
  802916:	74 1b                	je     802933 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802918:	79 e7                	jns    802901 <ipc_send+0x1e>
  80291a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80291d:	74 e2                	je     802901 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80291f:	83 ec 04             	sub    $0x4,%esp
  802922:	68 86 33 80 00       	push   $0x803386
  802927:	6a 46                	push   $0x46
  802929:	68 9b 33 80 00       	push   $0x80339b
  80292e:	e8 33 d9 ff ff       	call   800266 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802933:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802936:	5b                   	pop    %ebx
  802937:	5e                   	pop    %esi
  802938:	5f                   	pop    %edi
  802939:	5d                   	pop    %ebp
  80293a:	c3                   	ret    

0080293b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80293b:	55                   	push   %ebp
  80293c:	89 e5                	mov    %esp,%ebp
  80293e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802941:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802946:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80294c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802952:	8b 52 50             	mov    0x50(%edx),%edx
  802955:	39 ca                	cmp    %ecx,%edx
  802957:	74 11                	je     80296a <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802959:	83 c0 01             	add    $0x1,%eax
  80295c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802961:	75 e3                	jne    802946 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802963:	b8 00 00 00 00       	mov    $0x0,%eax
  802968:	eb 0e                	jmp    802978 <ipc_find_env+0x3d>
			return envs[i].env_id;
  80296a:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802970:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802975:	8b 40 48             	mov    0x48(%eax),%eax
}
  802978:	5d                   	pop    %ebp
  802979:	c3                   	ret    

0080297a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80297a:	55                   	push   %ebp
  80297b:	89 e5                	mov    %esp,%ebp
  80297d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802980:	89 d0                	mov    %edx,%eax
  802982:	c1 e8 16             	shr    $0x16,%eax
  802985:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80298c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802991:	f6 c1 01             	test   $0x1,%cl
  802994:	74 1d                	je     8029b3 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802996:	c1 ea 0c             	shr    $0xc,%edx
  802999:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029a0:	f6 c2 01             	test   $0x1,%dl
  8029a3:	74 0e                	je     8029b3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029a5:	c1 ea 0c             	shr    $0xc,%edx
  8029a8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029af:	ef 
  8029b0:	0f b7 c0             	movzwl %ax,%eax
}
  8029b3:	5d                   	pop    %ebp
  8029b4:	c3                   	ret    
  8029b5:	66 90                	xchg   %ax,%ax
  8029b7:	66 90                	xchg   %ax,%ax
  8029b9:	66 90                	xchg   %ax,%ax
  8029bb:	66 90                	xchg   %ax,%ax
  8029bd:	66 90                	xchg   %ax,%ax
  8029bf:	90                   	nop

008029c0 <__udivdi3>:
  8029c0:	55                   	push   %ebp
  8029c1:	57                   	push   %edi
  8029c2:	56                   	push   %esi
  8029c3:	53                   	push   %ebx
  8029c4:	83 ec 1c             	sub    $0x1c,%esp
  8029c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029d7:	85 d2                	test   %edx,%edx
  8029d9:	75 4d                	jne    802a28 <__udivdi3+0x68>
  8029db:	39 f3                	cmp    %esi,%ebx
  8029dd:	76 19                	jbe    8029f8 <__udivdi3+0x38>
  8029df:	31 ff                	xor    %edi,%edi
  8029e1:	89 e8                	mov    %ebp,%eax
  8029e3:	89 f2                	mov    %esi,%edx
  8029e5:	f7 f3                	div    %ebx
  8029e7:	89 fa                	mov    %edi,%edx
  8029e9:	83 c4 1c             	add    $0x1c,%esp
  8029ec:	5b                   	pop    %ebx
  8029ed:	5e                   	pop    %esi
  8029ee:	5f                   	pop    %edi
  8029ef:	5d                   	pop    %ebp
  8029f0:	c3                   	ret    
  8029f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029f8:	89 d9                	mov    %ebx,%ecx
  8029fa:	85 db                	test   %ebx,%ebx
  8029fc:	75 0b                	jne    802a09 <__udivdi3+0x49>
  8029fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802a03:	31 d2                	xor    %edx,%edx
  802a05:	f7 f3                	div    %ebx
  802a07:	89 c1                	mov    %eax,%ecx
  802a09:	31 d2                	xor    %edx,%edx
  802a0b:	89 f0                	mov    %esi,%eax
  802a0d:	f7 f1                	div    %ecx
  802a0f:	89 c6                	mov    %eax,%esi
  802a11:	89 e8                	mov    %ebp,%eax
  802a13:	89 f7                	mov    %esi,%edi
  802a15:	f7 f1                	div    %ecx
  802a17:	89 fa                	mov    %edi,%edx
  802a19:	83 c4 1c             	add    $0x1c,%esp
  802a1c:	5b                   	pop    %ebx
  802a1d:	5e                   	pop    %esi
  802a1e:	5f                   	pop    %edi
  802a1f:	5d                   	pop    %ebp
  802a20:	c3                   	ret    
  802a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a28:	39 f2                	cmp    %esi,%edx
  802a2a:	77 1c                	ja     802a48 <__udivdi3+0x88>
  802a2c:	0f bd fa             	bsr    %edx,%edi
  802a2f:	83 f7 1f             	xor    $0x1f,%edi
  802a32:	75 2c                	jne    802a60 <__udivdi3+0xa0>
  802a34:	39 f2                	cmp    %esi,%edx
  802a36:	72 06                	jb     802a3e <__udivdi3+0x7e>
  802a38:	31 c0                	xor    %eax,%eax
  802a3a:	39 eb                	cmp    %ebp,%ebx
  802a3c:	77 a9                	ja     8029e7 <__udivdi3+0x27>
  802a3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a43:	eb a2                	jmp    8029e7 <__udivdi3+0x27>
  802a45:	8d 76 00             	lea    0x0(%esi),%esi
  802a48:	31 ff                	xor    %edi,%edi
  802a4a:	31 c0                	xor    %eax,%eax
  802a4c:	89 fa                	mov    %edi,%edx
  802a4e:	83 c4 1c             	add    $0x1c,%esp
  802a51:	5b                   	pop    %ebx
  802a52:	5e                   	pop    %esi
  802a53:	5f                   	pop    %edi
  802a54:	5d                   	pop    %ebp
  802a55:	c3                   	ret    
  802a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a5d:	8d 76 00             	lea    0x0(%esi),%esi
  802a60:	89 f9                	mov    %edi,%ecx
  802a62:	b8 20 00 00 00       	mov    $0x20,%eax
  802a67:	29 f8                	sub    %edi,%eax
  802a69:	d3 e2                	shl    %cl,%edx
  802a6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a6f:	89 c1                	mov    %eax,%ecx
  802a71:	89 da                	mov    %ebx,%edx
  802a73:	d3 ea                	shr    %cl,%edx
  802a75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a79:	09 d1                	or     %edx,%ecx
  802a7b:	89 f2                	mov    %esi,%edx
  802a7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a81:	89 f9                	mov    %edi,%ecx
  802a83:	d3 e3                	shl    %cl,%ebx
  802a85:	89 c1                	mov    %eax,%ecx
  802a87:	d3 ea                	shr    %cl,%edx
  802a89:	89 f9                	mov    %edi,%ecx
  802a8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a8f:	89 eb                	mov    %ebp,%ebx
  802a91:	d3 e6                	shl    %cl,%esi
  802a93:	89 c1                	mov    %eax,%ecx
  802a95:	d3 eb                	shr    %cl,%ebx
  802a97:	09 de                	or     %ebx,%esi
  802a99:	89 f0                	mov    %esi,%eax
  802a9b:	f7 74 24 08          	divl   0x8(%esp)
  802a9f:	89 d6                	mov    %edx,%esi
  802aa1:	89 c3                	mov    %eax,%ebx
  802aa3:	f7 64 24 0c          	mull   0xc(%esp)
  802aa7:	39 d6                	cmp    %edx,%esi
  802aa9:	72 15                	jb     802ac0 <__udivdi3+0x100>
  802aab:	89 f9                	mov    %edi,%ecx
  802aad:	d3 e5                	shl    %cl,%ebp
  802aaf:	39 c5                	cmp    %eax,%ebp
  802ab1:	73 04                	jae    802ab7 <__udivdi3+0xf7>
  802ab3:	39 d6                	cmp    %edx,%esi
  802ab5:	74 09                	je     802ac0 <__udivdi3+0x100>
  802ab7:	89 d8                	mov    %ebx,%eax
  802ab9:	31 ff                	xor    %edi,%edi
  802abb:	e9 27 ff ff ff       	jmp    8029e7 <__udivdi3+0x27>
  802ac0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ac3:	31 ff                	xor    %edi,%edi
  802ac5:	e9 1d ff ff ff       	jmp    8029e7 <__udivdi3+0x27>
  802aca:	66 90                	xchg   %ax,%ax
  802acc:	66 90                	xchg   %ax,%ax
  802ace:	66 90                	xchg   %ax,%ax

00802ad0 <__umoddi3>:
  802ad0:	55                   	push   %ebp
  802ad1:	57                   	push   %edi
  802ad2:	56                   	push   %esi
  802ad3:	53                   	push   %ebx
  802ad4:	83 ec 1c             	sub    $0x1c,%esp
  802ad7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802adb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802adf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ae3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ae7:	89 da                	mov    %ebx,%edx
  802ae9:	85 c0                	test   %eax,%eax
  802aeb:	75 43                	jne    802b30 <__umoddi3+0x60>
  802aed:	39 df                	cmp    %ebx,%edi
  802aef:	76 17                	jbe    802b08 <__umoddi3+0x38>
  802af1:	89 f0                	mov    %esi,%eax
  802af3:	f7 f7                	div    %edi
  802af5:	89 d0                	mov    %edx,%eax
  802af7:	31 d2                	xor    %edx,%edx
  802af9:	83 c4 1c             	add    $0x1c,%esp
  802afc:	5b                   	pop    %ebx
  802afd:	5e                   	pop    %esi
  802afe:	5f                   	pop    %edi
  802aff:	5d                   	pop    %ebp
  802b00:	c3                   	ret    
  802b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b08:	89 fd                	mov    %edi,%ebp
  802b0a:	85 ff                	test   %edi,%edi
  802b0c:	75 0b                	jne    802b19 <__umoddi3+0x49>
  802b0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b13:	31 d2                	xor    %edx,%edx
  802b15:	f7 f7                	div    %edi
  802b17:	89 c5                	mov    %eax,%ebp
  802b19:	89 d8                	mov    %ebx,%eax
  802b1b:	31 d2                	xor    %edx,%edx
  802b1d:	f7 f5                	div    %ebp
  802b1f:	89 f0                	mov    %esi,%eax
  802b21:	f7 f5                	div    %ebp
  802b23:	89 d0                	mov    %edx,%eax
  802b25:	eb d0                	jmp    802af7 <__umoddi3+0x27>
  802b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b2e:	66 90                	xchg   %ax,%ax
  802b30:	89 f1                	mov    %esi,%ecx
  802b32:	39 d8                	cmp    %ebx,%eax
  802b34:	76 0a                	jbe    802b40 <__umoddi3+0x70>
  802b36:	89 f0                	mov    %esi,%eax
  802b38:	83 c4 1c             	add    $0x1c,%esp
  802b3b:	5b                   	pop    %ebx
  802b3c:	5e                   	pop    %esi
  802b3d:	5f                   	pop    %edi
  802b3e:	5d                   	pop    %ebp
  802b3f:	c3                   	ret    
  802b40:	0f bd e8             	bsr    %eax,%ebp
  802b43:	83 f5 1f             	xor    $0x1f,%ebp
  802b46:	75 20                	jne    802b68 <__umoddi3+0x98>
  802b48:	39 d8                	cmp    %ebx,%eax
  802b4a:	0f 82 b0 00 00 00    	jb     802c00 <__umoddi3+0x130>
  802b50:	39 f7                	cmp    %esi,%edi
  802b52:	0f 86 a8 00 00 00    	jbe    802c00 <__umoddi3+0x130>
  802b58:	89 c8                	mov    %ecx,%eax
  802b5a:	83 c4 1c             	add    $0x1c,%esp
  802b5d:	5b                   	pop    %ebx
  802b5e:	5e                   	pop    %esi
  802b5f:	5f                   	pop    %edi
  802b60:	5d                   	pop    %ebp
  802b61:	c3                   	ret    
  802b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b68:	89 e9                	mov    %ebp,%ecx
  802b6a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b6f:	29 ea                	sub    %ebp,%edx
  802b71:	d3 e0                	shl    %cl,%eax
  802b73:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b77:	89 d1                	mov    %edx,%ecx
  802b79:	89 f8                	mov    %edi,%eax
  802b7b:	d3 e8                	shr    %cl,%eax
  802b7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b81:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b85:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b89:	09 c1                	or     %eax,%ecx
  802b8b:	89 d8                	mov    %ebx,%eax
  802b8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b91:	89 e9                	mov    %ebp,%ecx
  802b93:	d3 e7                	shl    %cl,%edi
  802b95:	89 d1                	mov    %edx,%ecx
  802b97:	d3 e8                	shr    %cl,%eax
  802b99:	89 e9                	mov    %ebp,%ecx
  802b9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b9f:	d3 e3                	shl    %cl,%ebx
  802ba1:	89 c7                	mov    %eax,%edi
  802ba3:	89 d1                	mov    %edx,%ecx
  802ba5:	89 f0                	mov    %esi,%eax
  802ba7:	d3 e8                	shr    %cl,%eax
  802ba9:	89 e9                	mov    %ebp,%ecx
  802bab:	89 fa                	mov    %edi,%edx
  802bad:	d3 e6                	shl    %cl,%esi
  802baf:	09 d8                	or     %ebx,%eax
  802bb1:	f7 74 24 08          	divl   0x8(%esp)
  802bb5:	89 d1                	mov    %edx,%ecx
  802bb7:	89 f3                	mov    %esi,%ebx
  802bb9:	f7 64 24 0c          	mull   0xc(%esp)
  802bbd:	89 c6                	mov    %eax,%esi
  802bbf:	89 d7                	mov    %edx,%edi
  802bc1:	39 d1                	cmp    %edx,%ecx
  802bc3:	72 06                	jb     802bcb <__umoddi3+0xfb>
  802bc5:	75 10                	jne    802bd7 <__umoddi3+0x107>
  802bc7:	39 c3                	cmp    %eax,%ebx
  802bc9:	73 0c                	jae    802bd7 <__umoddi3+0x107>
  802bcb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802bcf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802bd3:	89 d7                	mov    %edx,%edi
  802bd5:	89 c6                	mov    %eax,%esi
  802bd7:	89 ca                	mov    %ecx,%edx
  802bd9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bde:	29 f3                	sub    %esi,%ebx
  802be0:	19 fa                	sbb    %edi,%edx
  802be2:	89 d0                	mov    %edx,%eax
  802be4:	d3 e0                	shl    %cl,%eax
  802be6:	89 e9                	mov    %ebp,%ecx
  802be8:	d3 eb                	shr    %cl,%ebx
  802bea:	d3 ea                	shr    %cl,%edx
  802bec:	09 d8                	or     %ebx,%eax
  802bee:	83 c4 1c             	add    $0x1c,%esp
  802bf1:	5b                   	pop    %ebx
  802bf2:	5e                   	pop    %esi
  802bf3:	5f                   	pop    %edi
  802bf4:	5d                   	pop    %ebp
  802bf5:	c3                   	ret    
  802bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bfd:	8d 76 00             	lea    0x0(%esi),%esi
  802c00:	89 da                	mov    %ebx,%edx
  802c02:	29 fe                	sub    %edi,%esi
  802c04:	19 c2                	sbb    %eax,%edx
  802c06:	89 f1                	mov    %esi,%ecx
  802c08:	89 c8                	mov    %ecx,%eax
  802c0a:	e9 4b ff ff ff       	jmp    802b5a <__umoddi3+0x8a>
