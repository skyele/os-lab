
obj/user/testfdsharing.debug:     file format elf32-i386


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
  80002c:	e8 99 01 00 00       	call   8001ca <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003c:	6a 00                	push   $0x0
  80003e:	68 40 2c 80 00       	push   $0x802c40
  800043:	e8 af 1d 00 00       	call   801df7 <open>
  800048:	89 c3                	mov    %eax,%ebx
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	0f 88 ff 00 00 00    	js     800154 <umain+0x121>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	50                   	push   %eax
  80005b:	e8 47 1a 00 00       	call   801aa7 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800060:	83 c4 0c             	add    $0xc,%esp
  800063:	68 00 02 00 00       	push   $0x200
  800068:	68 20 52 80 00       	push   $0x805220
  80006d:	53                   	push   %ebx
  80006e:	e8 6d 19 00 00       	call   8019e0 <readn>
  800073:	89 c6                	mov    %eax,%esi
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 8e e6 00 00 00    	jle    800166 <umain+0x133>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800080:	e8 53 13 00 00       	call   8013d8 <fork>
  800085:	89 c7                	mov    %eax,%edi
  800087:	85 c0                	test   %eax,%eax
  800089:	0f 88 e9 00 00 00    	js     800178 <umain+0x145>
		panic("fork: %e", r);
	if (r == 0) {
  80008f:	75 7b                	jne    80010c <umain+0xd9>
		seek(fd, 0);
  800091:	83 ec 08             	sub    $0x8,%esp
  800094:	6a 00                	push   $0x0
  800096:	53                   	push   %ebx
  800097:	e8 0b 1a 00 00       	call   801aa7 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80009c:	c7 04 24 b0 2c 80 00 	movl   $0x802cb0,(%esp)
  8000a3:	e8 95 02 00 00       	call   80033d <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	68 00 02 00 00       	push   $0x200
  8000b0:	68 20 50 80 00       	push   $0x805020
  8000b5:	53                   	push   %ebx
  8000b6:	e8 25 19 00 00       	call   8019e0 <readn>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	39 c6                	cmp    %eax,%esi
  8000c0:	0f 85 c4 00 00 00    	jne    80018a <umain+0x157>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	56                   	push   %esi
  8000ca:	68 20 50 80 00       	push   $0x805020
  8000cf:	68 20 52 80 00       	push   $0x805220
  8000d4:	e8 c9 0b 00 00       	call   800ca2 <memcmp>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	0f 85 bc 00 00 00    	jne    8001a0 <umain+0x16d>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 7b 2c 80 00       	push   $0x802c7b
  8000ec:	e8 4c 02 00 00       	call   80033d <cprintf>
		seek(fd, 0);
  8000f1:	83 c4 08             	add    $0x8,%esp
  8000f4:	6a 00                	push   $0x0
  8000f6:	53                   	push   %ebx
  8000f7:	e8 ab 19 00 00       	call   801aa7 <seek>
		close(fd);
  8000fc:	89 1c 24             	mov    %ebx,(%esp)
  8000ff:	e8 17 17 00 00       	call   80181b <close>
		exit();
  800104:	e8 0a 01 00 00       	call   800213 <exit>
  800109:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	57                   	push   %edi
  800110:	e8 3c 25 00 00       	call   802651 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800115:	83 c4 0c             	add    $0xc,%esp
  800118:	68 00 02 00 00       	push   $0x200
  80011d:	68 20 50 80 00       	push   $0x805020
  800122:	53                   	push   %ebx
  800123:	e8 b8 18 00 00       	call   8019e0 <readn>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	39 c6                	cmp    %eax,%esi
  80012d:	0f 85 81 00 00 00    	jne    8001b4 <umain+0x181>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 94 2c 80 00       	push   $0x802c94
  80013b:	e8 fd 01 00 00       	call   80033d <cprintf>
	close(fd);
  800140:	89 1c 24             	mov    %ebx,(%esp)
  800143:	e8 d3 16 00 00       	call   80181b <close>
  : "c" (msr), "a" (val1), "d" (val2))

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800148:	cc                   	int3   

	breakpoint();
}
  800149:	83 c4 10             	add    $0x10,%esp
  80014c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80014f:	5b                   	pop    %ebx
  800150:	5e                   	pop    %esi
  800151:	5f                   	pop    %edi
  800152:	5d                   	pop    %ebp
  800153:	c3                   	ret    
		panic("open motd: %e", fd);
  800154:	50                   	push   %eax
  800155:	68 45 2c 80 00       	push   $0x802c45
  80015a:	6a 0c                	push   $0xc
  80015c:	68 53 2c 80 00       	push   $0x802c53
  800161:	e8 e1 00 00 00       	call   800247 <_panic>
		panic("readn: %e", n);
  800166:	50                   	push   %eax
  800167:	68 68 2c 80 00       	push   $0x802c68
  80016c:	6a 0f                	push   $0xf
  80016e:	68 53 2c 80 00       	push   $0x802c53
  800173:	e8 cf 00 00 00       	call   800247 <_panic>
		panic("fork: %e", r);
  800178:	50                   	push   %eax
  800179:	68 72 2c 80 00       	push   $0x802c72
  80017e:	6a 12                	push   $0x12
  800180:	68 53 2c 80 00       	push   $0x802c53
  800185:	e8 bd 00 00 00       	call   800247 <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	56                   	push   %esi
  80018f:	68 f4 2c 80 00       	push   $0x802cf4
  800194:	6a 17                	push   $0x17
  800196:	68 53 2c 80 00       	push   $0x802c53
  80019b:	e8 a7 00 00 00       	call   800247 <_panic>
			panic("read in parent got different bytes from read in child");
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	68 20 2d 80 00       	push   $0x802d20
  8001a8:	6a 19                	push   $0x19
  8001aa:	68 53 2c 80 00       	push   $0x802c53
  8001af:	e8 93 00 00 00       	call   800247 <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	50                   	push   %eax
  8001b8:	56                   	push   %esi
  8001b9:	68 58 2d 80 00       	push   $0x802d58
  8001be:	6a 21                	push   $0x21
  8001c0:	68 53 2c 80 00       	push   $0x802c53
  8001c5:	e8 7d 00 00 00       	call   800247 <_panic>

008001ca <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	56                   	push   %esi
  8001ce:	53                   	push   %ebx
  8001cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8001d5:	e8 76 0c 00 00       	call   800e50 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8001da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001df:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8001e5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ea:	a3 20 54 80 00       	mov    %eax,0x805420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ef:	85 db                	test   %ebx,%ebx
  8001f1:	7e 07                	jle    8001fa <libmain+0x30>
		binaryname = argv[0];
  8001f3:	8b 06                	mov    (%esi),%eax
  8001f5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	56                   	push   %esi
  8001fe:	53                   	push   %ebx
  8001ff:	e8 2f fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800204:	e8 0a 00 00 00       	call   800213 <exit>
}
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80020f:	5b                   	pop    %ebx
  800210:	5e                   	pop    %esi
  800211:	5d                   	pop    %ebp
  800212:	c3                   	ret    

00800213 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800219:	a1 20 54 80 00       	mov    0x805420,%eax
  80021e:	8b 40 48             	mov    0x48(%eax),%eax
  800221:	68 90 2d 80 00       	push   $0x802d90
  800226:	50                   	push   %eax
  800227:	68 85 2d 80 00       	push   $0x802d85
  80022c:	e8 0c 01 00 00       	call   80033d <cprintf>
	close_all();
  800231:	e8 12 16 00 00       	call   801848 <close_all>
	sys_env_destroy(0);
  800236:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80023d:	e8 cd 0b 00 00       	call   800e0f <sys_env_destroy>
}
  800242:	83 c4 10             	add    $0x10,%esp
  800245:	c9                   	leave  
  800246:	c3                   	ret    

00800247 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	56                   	push   %esi
  80024b:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80024c:	a1 20 54 80 00       	mov    0x805420,%eax
  800251:	8b 40 48             	mov    0x48(%eax),%eax
  800254:	83 ec 04             	sub    $0x4,%esp
  800257:	68 bc 2d 80 00       	push   $0x802dbc
  80025c:	50                   	push   %eax
  80025d:	68 85 2d 80 00       	push   $0x802d85
  800262:	e8 d6 00 00 00       	call   80033d <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800267:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80026a:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800270:	e8 db 0b 00 00       	call   800e50 <sys_getenvid>
  800275:	83 c4 04             	add    $0x4,%esp
  800278:	ff 75 0c             	pushl  0xc(%ebp)
  80027b:	ff 75 08             	pushl  0x8(%ebp)
  80027e:	56                   	push   %esi
  80027f:	50                   	push   %eax
  800280:	68 98 2d 80 00       	push   $0x802d98
  800285:	e8 b3 00 00 00       	call   80033d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80028a:	83 c4 18             	add    $0x18,%esp
  80028d:	53                   	push   %ebx
  80028e:	ff 75 10             	pushl  0x10(%ebp)
  800291:	e8 56 00 00 00       	call   8002ec <vcprintf>
	cprintf("\n");
  800296:	c7 04 24 c1 31 80 00 	movl   $0x8031c1,(%esp)
  80029d:	e8 9b 00 00 00       	call   80033d <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002a5:	cc                   	int3   
  8002a6:	eb fd                	jmp    8002a5 <_panic+0x5e>

008002a8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	53                   	push   %ebx
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002b2:	8b 13                	mov    (%ebx),%edx
  8002b4:	8d 42 01             	lea    0x1(%edx),%eax
  8002b7:	89 03                	mov    %eax,(%ebx)
  8002b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002bc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c5:	74 09                	je     8002d0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002c7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	68 ff 00 00 00       	push   $0xff
  8002d8:	8d 43 08             	lea    0x8(%ebx),%eax
  8002db:	50                   	push   %eax
  8002dc:	e8 f1 0a 00 00       	call   800dd2 <sys_cputs>
		b->idx = 0;
  8002e1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	eb db                	jmp    8002c7 <putch+0x1f>

008002ec <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002fc:	00 00 00 
	b.cnt = 0;
  8002ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800306:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800309:	ff 75 0c             	pushl  0xc(%ebp)
  80030c:	ff 75 08             	pushl  0x8(%ebp)
  80030f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800315:	50                   	push   %eax
  800316:	68 a8 02 80 00       	push   $0x8002a8
  80031b:	e8 4a 01 00 00       	call   80046a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800320:	83 c4 08             	add    $0x8,%esp
  800323:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800329:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80032f:	50                   	push   %eax
  800330:	e8 9d 0a 00 00       	call   800dd2 <sys_cputs>

	return b.cnt;
}
  800335:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80033b:	c9                   	leave  
  80033c:	c3                   	ret    

0080033d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80033d:	55                   	push   %ebp
  80033e:	89 e5                	mov    %esp,%ebp
  800340:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800343:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800346:	50                   	push   %eax
  800347:	ff 75 08             	pushl  0x8(%ebp)
  80034a:	e8 9d ff ff ff       	call   8002ec <vcprintf>
	va_end(ap);

	return cnt;
}
  80034f:	c9                   	leave  
  800350:	c3                   	ret    

00800351 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	57                   	push   %edi
  800355:	56                   	push   %esi
  800356:	53                   	push   %ebx
  800357:	83 ec 1c             	sub    $0x1c,%esp
  80035a:	89 c6                	mov    %eax,%esi
  80035c:	89 d7                	mov    %edx,%edi
  80035e:	8b 45 08             	mov    0x8(%ebp),%eax
  800361:	8b 55 0c             	mov    0xc(%ebp),%edx
  800364:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800367:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80036a:	8b 45 10             	mov    0x10(%ebp),%eax
  80036d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800370:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800374:	74 2c                	je     8003a2 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800376:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800379:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800380:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800383:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800386:	39 c2                	cmp    %eax,%edx
  800388:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80038b:	73 43                	jae    8003d0 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80038d:	83 eb 01             	sub    $0x1,%ebx
  800390:	85 db                	test   %ebx,%ebx
  800392:	7e 6c                	jle    800400 <printnum+0xaf>
				putch(padc, putdat);
  800394:	83 ec 08             	sub    $0x8,%esp
  800397:	57                   	push   %edi
  800398:	ff 75 18             	pushl  0x18(%ebp)
  80039b:	ff d6                	call   *%esi
  80039d:	83 c4 10             	add    $0x10,%esp
  8003a0:	eb eb                	jmp    80038d <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003a2:	83 ec 0c             	sub    $0xc,%esp
  8003a5:	6a 20                	push   $0x20
  8003a7:	6a 00                	push   $0x0
  8003a9:	50                   	push   %eax
  8003aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8003b0:	89 fa                	mov    %edi,%edx
  8003b2:	89 f0                	mov    %esi,%eax
  8003b4:	e8 98 ff ff ff       	call   800351 <printnum>
		while (--width > 0)
  8003b9:	83 c4 20             	add    $0x20,%esp
  8003bc:	83 eb 01             	sub    $0x1,%ebx
  8003bf:	85 db                	test   %ebx,%ebx
  8003c1:	7e 65                	jle    800428 <printnum+0xd7>
			putch(padc, putdat);
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	57                   	push   %edi
  8003c7:	6a 20                	push   $0x20
  8003c9:	ff d6                	call   *%esi
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb ec                	jmp    8003bc <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	ff 75 18             	pushl  0x18(%ebp)
  8003d6:	83 eb 01             	sub    $0x1,%ebx
  8003d9:	53                   	push   %ebx
  8003da:	50                   	push   %eax
  8003db:	83 ec 08             	sub    $0x8,%esp
  8003de:	ff 75 dc             	pushl  -0x24(%ebp)
  8003e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8003e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ea:	e8 01 26 00 00       	call   8029f0 <__udivdi3>
  8003ef:	83 c4 18             	add    $0x18,%esp
  8003f2:	52                   	push   %edx
  8003f3:	50                   	push   %eax
  8003f4:	89 fa                	mov    %edi,%edx
  8003f6:	89 f0                	mov    %esi,%eax
  8003f8:	e8 54 ff ff ff       	call   800351 <printnum>
  8003fd:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800400:	83 ec 08             	sub    $0x8,%esp
  800403:	57                   	push   %edi
  800404:	83 ec 04             	sub    $0x4,%esp
  800407:	ff 75 dc             	pushl  -0x24(%ebp)
  80040a:	ff 75 d8             	pushl  -0x28(%ebp)
  80040d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800410:	ff 75 e0             	pushl  -0x20(%ebp)
  800413:	e8 e8 26 00 00       	call   802b00 <__umoddi3>
  800418:	83 c4 14             	add    $0x14,%esp
  80041b:	0f be 80 c3 2d 80 00 	movsbl 0x802dc3(%eax),%eax
  800422:	50                   	push   %eax
  800423:	ff d6                	call   *%esi
  800425:	83 c4 10             	add    $0x10,%esp
	}
}
  800428:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80042b:	5b                   	pop    %ebx
  80042c:	5e                   	pop    %esi
  80042d:	5f                   	pop    %edi
  80042e:	5d                   	pop    %ebp
  80042f:	c3                   	ret    

00800430 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
  800433:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800436:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80043a:	8b 10                	mov    (%eax),%edx
  80043c:	3b 50 04             	cmp    0x4(%eax),%edx
  80043f:	73 0a                	jae    80044b <sprintputch+0x1b>
		*b->buf++ = ch;
  800441:	8d 4a 01             	lea    0x1(%edx),%ecx
  800444:	89 08                	mov    %ecx,(%eax)
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	88 02                	mov    %al,(%edx)
}
  80044b:	5d                   	pop    %ebp
  80044c:	c3                   	ret    

0080044d <printfmt>:
{
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800453:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800456:	50                   	push   %eax
  800457:	ff 75 10             	pushl  0x10(%ebp)
  80045a:	ff 75 0c             	pushl  0xc(%ebp)
  80045d:	ff 75 08             	pushl  0x8(%ebp)
  800460:	e8 05 00 00 00       	call   80046a <vprintfmt>
}
  800465:	83 c4 10             	add    $0x10,%esp
  800468:	c9                   	leave  
  800469:	c3                   	ret    

0080046a <vprintfmt>:
{
  80046a:	55                   	push   %ebp
  80046b:	89 e5                	mov    %esp,%ebp
  80046d:	57                   	push   %edi
  80046e:	56                   	push   %esi
  80046f:	53                   	push   %ebx
  800470:	83 ec 3c             	sub    $0x3c,%esp
  800473:	8b 75 08             	mov    0x8(%ebp),%esi
  800476:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800479:	8b 7d 10             	mov    0x10(%ebp),%edi
  80047c:	e9 32 04 00 00       	jmp    8008b3 <vprintfmt+0x449>
		padc = ' ';
  800481:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800485:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80048c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800493:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80049a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004a1:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004a8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004ad:	8d 47 01             	lea    0x1(%edi),%eax
  8004b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004b3:	0f b6 17             	movzbl (%edi),%edx
  8004b6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004b9:	3c 55                	cmp    $0x55,%al
  8004bb:	0f 87 12 05 00 00    	ja     8009d3 <vprintfmt+0x569>
  8004c1:	0f b6 c0             	movzbl %al,%eax
  8004c4:	ff 24 85 a0 2f 80 00 	jmp    *0x802fa0(,%eax,4)
  8004cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004ce:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8004d2:	eb d9                	jmp    8004ad <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004d7:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004db:	eb d0                	jmp    8004ad <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004dd:	0f b6 d2             	movzbl %dl,%edx
  8004e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e8:	89 75 08             	mov    %esi,0x8(%ebp)
  8004eb:	eb 03                	jmp    8004f0 <vprintfmt+0x86>
  8004ed:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004f0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004f3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004f7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004fa:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004fd:	83 fe 09             	cmp    $0x9,%esi
  800500:	76 eb                	jbe    8004ed <vprintfmt+0x83>
  800502:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800505:	8b 75 08             	mov    0x8(%ebp),%esi
  800508:	eb 14                	jmp    80051e <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	8b 00                	mov    (%eax),%eax
  80050f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	8d 40 04             	lea    0x4(%eax),%eax
  800518:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80051b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80051e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800522:	79 89                	jns    8004ad <vprintfmt+0x43>
				width = precision, precision = -1;
  800524:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800527:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80052a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800531:	e9 77 ff ff ff       	jmp    8004ad <vprintfmt+0x43>
  800536:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800539:	85 c0                	test   %eax,%eax
  80053b:	0f 48 c1             	cmovs  %ecx,%eax
  80053e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800541:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800544:	e9 64 ff ff ff       	jmp    8004ad <vprintfmt+0x43>
  800549:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80054c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800553:	e9 55 ff ff ff       	jmp    8004ad <vprintfmt+0x43>
			lflag++;
  800558:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80055c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80055f:	e9 49 ff ff ff       	jmp    8004ad <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	8d 78 04             	lea    0x4(%eax),%edi
  80056a:	83 ec 08             	sub    $0x8,%esp
  80056d:	53                   	push   %ebx
  80056e:	ff 30                	pushl  (%eax)
  800570:	ff d6                	call   *%esi
			break;
  800572:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800575:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800578:	e9 33 03 00 00       	jmp    8008b0 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8d 78 04             	lea    0x4(%eax),%edi
  800583:	8b 00                	mov    (%eax),%eax
  800585:	99                   	cltd   
  800586:	31 d0                	xor    %edx,%eax
  800588:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80058a:	83 f8 11             	cmp    $0x11,%eax
  80058d:	7f 23                	jg     8005b2 <vprintfmt+0x148>
  80058f:	8b 14 85 00 31 80 00 	mov    0x803100(,%eax,4),%edx
  800596:	85 d2                	test   %edx,%edx
  800598:	74 18                	je     8005b2 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80059a:	52                   	push   %edx
  80059b:	68 0d 33 80 00       	push   $0x80330d
  8005a0:	53                   	push   %ebx
  8005a1:	56                   	push   %esi
  8005a2:	e8 a6 fe ff ff       	call   80044d <printfmt>
  8005a7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005aa:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005ad:	e9 fe 02 00 00       	jmp    8008b0 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005b2:	50                   	push   %eax
  8005b3:	68 db 2d 80 00       	push   $0x802ddb
  8005b8:	53                   	push   %ebx
  8005b9:	56                   	push   %esi
  8005ba:	e8 8e fe ff ff       	call   80044d <printfmt>
  8005bf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005c2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005c5:	e9 e6 02 00 00       	jmp    8008b0 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	83 c0 04             	add    $0x4,%eax
  8005d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005d8:	85 c9                	test   %ecx,%ecx
  8005da:	b8 d4 2d 80 00       	mov    $0x802dd4,%eax
  8005df:	0f 45 c1             	cmovne %ecx,%eax
  8005e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005e9:	7e 06                	jle    8005f1 <vprintfmt+0x187>
  8005eb:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005ef:	75 0d                	jne    8005fe <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005f4:	89 c7                	mov    %eax,%edi
  8005f6:	03 45 e0             	add    -0x20(%ebp),%eax
  8005f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005fc:	eb 53                	jmp    800651 <vprintfmt+0x1e7>
  8005fe:	83 ec 08             	sub    $0x8,%esp
  800601:	ff 75 d8             	pushl  -0x28(%ebp)
  800604:	50                   	push   %eax
  800605:	e8 71 04 00 00       	call   800a7b <strnlen>
  80060a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80060d:	29 c1                	sub    %eax,%ecx
  80060f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800612:	83 c4 10             	add    $0x10,%esp
  800615:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800617:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80061b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80061e:	eb 0f                	jmp    80062f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	53                   	push   %ebx
  800624:	ff 75 e0             	pushl  -0x20(%ebp)
  800627:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800629:	83 ef 01             	sub    $0x1,%edi
  80062c:	83 c4 10             	add    $0x10,%esp
  80062f:	85 ff                	test   %edi,%edi
  800631:	7f ed                	jg     800620 <vprintfmt+0x1b6>
  800633:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800636:	85 c9                	test   %ecx,%ecx
  800638:	b8 00 00 00 00       	mov    $0x0,%eax
  80063d:	0f 49 c1             	cmovns %ecx,%eax
  800640:	29 c1                	sub    %eax,%ecx
  800642:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800645:	eb aa                	jmp    8005f1 <vprintfmt+0x187>
					putch(ch, putdat);
  800647:	83 ec 08             	sub    $0x8,%esp
  80064a:	53                   	push   %ebx
  80064b:	52                   	push   %edx
  80064c:	ff d6                	call   *%esi
  80064e:	83 c4 10             	add    $0x10,%esp
  800651:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800654:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800656:	83 c7 01             	add    $0x1,%edi
  800659:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80065d:	0f be d0             	movsbl %al,%edx
  800660:	85 d2                	test   %edx,%edx
  800662:	74 4b                	je     8006af <vprintfmt+0x245>
  800664:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800668:	78 06                	js     800670 <vprintfmt+0x206>
  80066a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80066e:	78 1e                	js     80068e <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800670:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800674:	74 d1                	je     800647 <vprintfmt+0x1dd>
  800676:	0f be c0             	movsbl %al,%eax
  800679:	83 e8 20             	sub    $0x20,%eax
  80067c:	83 f8 5e             	cmp    $0x5e,%eax
  80067f:	76 c6                	jbe    800647 <vprintfmt+0x1dd>
					putch('?', putdat);
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	53                   	push   %ebx
  800685:	6a 3f                	push   $0x3f
  800687:	ff d6                	call   *%esi
  800689:	83 c4 10             	add    $0x10,%esp
  80068c:	eb c3                	jmp    800651 <vprintfmt+0x1e7>
  80068e:	89 cf                	mov    %ecx,%edi
  800690:	eb 0e                	jmp    8006a0 <vprintfmt+0x236>
				putch(' ', putdat);
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	53                   	push   %ebx
  800696:	6a 20                	push   $0x20
  800698:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80069a:	83 ef 01             	sub    $0x1,%edi
  80069d:	83 c4 10             	add    $0x10,%esp
  8006a0:	85 ff                	test   %edi,%edi
  8006a2:	7f ee                	jg     800692 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006aa:	e9 01 02 00 00       	jmp    8008b0 <vprintfmt+0x446>
  8006af:	89 cf                	mov    %ecx,%edi
  8006b1:	eb ed                	jmp    8006a0 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006b6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006bd:	e9 eb fd ff ff       	jmp    8004ad <vprintfmt+0x43>
	if (lflag >= 2)
  8006c2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006c6:	7f 21                	jg     8006e9 <vprintfmt+0x27f>
	else if (lflag)
  8006c8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006cc:	74 68                	je     800736 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006d6:	89 c1                	mov    %eax,%ecx
  8006d8:	c1 f9 1f             	sar    $0x1f,%ecx
  8006db:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 40 04             	lea    0x4(%eax),%eax
  8006e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e7:	eb 17                	jmp    800700 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	8b 50 04             	mov    0x4(%eax),%edx
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	8d 40 08             	lea    0x8(%eax),%eax
  8006fd:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800700:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800703:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800706:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800709:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80070c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800710:	78 3f                	js     800751 <vprintfmt+0x2e7>
			base = 10;
  800712:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800717:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80071b:	0f 84 71 01 00 00    	je     800892 <vprintfmt+0x428>
				putch('+', putdat);
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	53                   	push   %ebx
  800725:	6a 2b                	push   $0x2b
  800727:	ff d6                	call   *%esi
  800729:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80072c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800731:	e9 5c 01 00 00       	jmp    800892 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80073e:	89 c1                	mov    %eax,%ecx
  800740:	c1 f9 1f             	sar    $0x1f,%ecx
  800743:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8d 40 04             	lea    0x4(%eax),%eax
  80074c:	89 45 14             	mov    %eax,0x14(%ebp)
  80074f:	eb af                	jmp    800700 <vprintfmt+0x296>
				putch('-', putdat);
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	53                   	push   %ebx
  800755:	6a 2d                	push   $0x2d
  800757:	ff d6                	call   *%esi
				num = -(long long) num;
  800759:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80075c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80075f:	f7 d8                	neg    %eax
  800761:	83 d2 00             	adc    $0x0,%edx
  800764:	f7 da                	neg    %edx
  800766:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800769:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80076f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800774:	e9 19 01 00 00       	jmp    800892 <vprintfmt+0x428>
	if (lflag >= 2)
  800779:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80077d:	7f 29                	jg     8007a8 <vprintfmt+0x33e>
	else if (lflag)
  80077f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800783:	74 44                	je     8007c9 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	ba 00 00 00 00       	mov    $0x0,%edx
  80078f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800792:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	8d 40 04             	lea    0x4(%eax),%eax
  80079b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80079e:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a3:	e9 ea 00 00 00       	jmp    800892 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	8b 50 04             	mov    0x4(%eax),%edx
  8007ae:	8b 00                	mov    (%eax),%eax
  8007b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8d 40 08             	lea    0x8(%eax),%eax
  8007bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007bf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c4:	e9 c9 00 00 00       	jmp    800892 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8d 40 04             	lea    0x4(%eax),%eax
  8007df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007e2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e7:	e9 a6 00 00 00       	jmp    800892 <vprintfmt+0x428>
			putch('0', putdat);
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	53                   	push   %ebx
  8007f0:	6a 30                	push   $0x30
  8007f2:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007f4:	83 c4 10             	add    $0x10,%esp
  8007f7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007fb:	7f 26                	jg     800823 <vprintfmt+0x3b9>
	else if (lflag)
  8007fd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800801:	74 3e                	je     800841 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	ba 00 00 00 00       	mov    $0x0,%edx
  80080d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800810:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	8d 40 04             	lea    0x4(%eax),%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80081c:	b8 08 00 00 00       	mov    $0x8,%eax
  800821:	eb 6f                	jmp    800892 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800823:	8b 45 14             	mov    0x14(%ebp),%eax
  800826:	8b 50 04             	mov    0x4(%eax),%edx
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	8d 40 08             	lea    0x8(%eax),%eax
  800837:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80083a:	b8 08 00 00 00       	mov    $0x8,%eax
  80083f:	eb 51                	jmp    800892 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	ba 00 00 00 00       	mov    $0x0,%edx
  80084b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	8d 40 04             	lea    0x4(%eax),%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80085a:	b8 08 00 00 00       	mov    $0x8,%eax
  80085f:	eb 31                	jmp    800892 <vprintfmt+0x428>
			putch('0', putdat);
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	53                   	push   %ebx
  800865:	6a 30                	push   $0x30
  800867:	ff d6                	call   *%esi
			putch('x', putdat);
  800869:	83 c4 08             	add    $0x8,%esp
  80086c:	53                   	push   %ebx
  80086d:	6a 78                	push   $0x78
  80086f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	ba 00 00 00 00       	mov    $0x0,%edx
  80087b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800881:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	8d 40 04             	lea    0x4(%eax),%eax
  80088a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80088d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800892:	83 ec 0c             	sub    $0xc,%esp
  800895:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800899:	52                   	push   %edx
  80089a:	ff 75 e0             	pushl  -0x20(%ebp)
  80089d:	50                   	push   %eax
  80089e:	ff 75 dc             	pushl  -0x24(%ebp)
  8008a1:	ff 75 d8             	pushl  -0x28(%ebp)
  8008a4:	89 da                	mov    %ebx,%edx
  8008a6:	89 f0                	mov    %esi,%eax
  8008a8:	e8 a4 fa ff ff       	call   800351 <printnum>
			break;
  8008ad:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b3:	83 c7 01             	add    $0x1,%edi
  8008b6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008ba:	83 f8 25             	cmp    $0x25,%eax
  8008bd:	0f 84 be fb ff ff    	je     800481 <vprintfmt+0x17>
			if (ch == '\0')
  8008c3:	85 c0                	test   %eax,%eax
  8008c5:	0f 84 28 01 00 00    	je     8009f3 <vprintfmt+0x589>
			putch(ch, putdat);
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	53                   	push   %ebx
  8008cf:	50                   	push   %eax
  8008d0:	ff d6                	call   *%esi
  8008d2:	83 c4 10             	add    $0x10,%esp
  8008d5:	eb dc                	jmp    8008b3 <vprintfmt+0x449>
	if (lflag >= 2)
  8008d7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008db:	7f 26                	jg     800903 <vprintfmt+0x499>
	else if (lflag)
  8008dd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008e1:	74 41                	je     800924 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f6:	8d 40 04             	lea    0x4(%eax),%eax
  8008f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008fc:	b8 10 00 00 00       	mov    $0x10,%eax
  800901:	eb 8f                	jmp    800892 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	8b 50 04             	mov    0x4(%eax),%edx
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80090e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	8d 40 08             	lea    0x8(%eax),%eax
  800917:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80091a:	b8 10 00 00 00       	mov    $0x10,%eax
  80091f:	e9 6e ff ff ff       	jmp    800892 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800924:	8b 45 14             	mov    0x14(%ebp),%eax
  800927:	8b 00                	mov    (%eax),%eax
  800929:	ba 00 00 00 00       	mov    $0x0,%edx
  80092e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800931:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	8d 40 04             	lea    0x4(%eax),%eax
  80093a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80093d:	b8 10 00 00 00       	mov    $0x10,%eax
  800942:	e9 4b ff ff ff       	jmp    800892 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800947:	8b 45 14             	mov    0x14(%ebp),%eax
  80094a:	83 c0 04             	add    $0x4,%eax
  80094d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	8b 00                	mov    (%eax),%eax
  800955:	85 c0                	test   %eax,%eax
  800957:	74 14                	je     80096d <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800959:	8b 13                	mov    (%ebx),%edx
  80095b:	83 fa 7f             	cmp    $0x7f,%edx
  80095e:	7f 37                	jg     800997 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800960:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800962:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800965:	89 45 14             	mov    %eax,0x14(%ebp)
  800968:	e9 43 ff ff ff       	jmp    8008b0 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80096d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800972:	bf f9 2e 80 00       	mov    $0x802ef9,%edi
							putch(ch, putdat);
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	53                   	push   %ebx
  80097b:	50                   	push   %eax
  80097c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80097e:	83 c7 01             	add    $0x1,%edi
  800981:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800985:	83 c4 10             	add    $0x10,%esp
  800988:	85 c0                	test   %eax,%eax
  80098a:	75 eb                	jne    800977 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80098c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80098f:	89 45 14             	mov    %eax,0x14(%ebp)
  800992:	e9 19 ff ff ff       	jmp    8008b0 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800997:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800999:	b8 0a 00 00 00       	mov    $0xa,%eax
  80099e:	bf 31 2f 80 00       	mov    $0x802f31,%edi
							putch(ch, putdat);
  8009a3:	83 ec 08             	sub    $0x8,%esp
  8009a6:	53                   	push   %ebx
  8009a7:	50                   	push   %eax
  8009a8:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009aa:	83 c7 01             	add    $0x1,%edi
  8009ad:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009b1:	83 c4 10             	add    $0x10,%esp
  8009b4:	85 c0                	test   %eax,%eax
  8009b6:	75 eb                	jne    8009a3 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8009be:	e9 ed fe ff ff       	jmp    8008b0 <vprintfmt+0x446>
			putch(ch, putdat);
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	53                   	push   %ebx
  8009c7:	6a 25                	push   $0x25
  8009c9:	ff d6                	call   *%esi
			break;
  8009cb:	83 c4 10             	add    $0x10,%esp
  8009ce:	e9 dd fe ff ff       	jmp    8008b0 <vprintfmt+0x446>
			putch('%', putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	53                   	push   %ebx
  8009d7:	6a 25                	push   $0x25
  8009d9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009db:	83 c4 10             	add    $0x10,%esp
  8009de:	89 f8                	mov    %edi,%eax
  8009e0:	eb 03                	jmp    8009e5 <vprintfmt+0x57b>
  8009e2:	83 e8 01             	sub    $0x1,%eax
  8009e5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009e9:	75 f7                	jne    8009e2 <vprintfmt+0x578>
  8009eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009ee:	e9 bd fe ff ff       	jmp    8008b0 <vprintfmt+0x446>
}
  8009f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009f6:	5b                   	pop    %ebx
  8009f7:	5e                   	pop    %esi
  8009f8:	5f                   	pop    %edi
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	83 ec 18             	sub    $0x18,%esp
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a0a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a0e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a18:	85 c0                	test   %eax,%eax
  800a1a:	74 26                	je     800a42 <vsnprintf+0x47>
  800a1c:	85 d2                	test   %edx,%edx
  800a1e:	7e 22                	jle    800a42 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a20:	ff 75 14             	pushl  0x14(%ebp)
  800a23:	ff 75 10             	pushl  0x10(%ebp)
  800a26:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a29:	50                   	push   %eax
  800a2a:	68 30 04 80 00       	push   $0x800430
  800a2f:	e8 36 fa ff ff       	call   80046a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a37:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a3d:	83 c4 10             	add    $0x10,%esp
}
  800a40:	c9                   	leave  
  800a41:	c3                   	ret    
		return -E_INVAL;
  800a42:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a47:	eb f7                	jmp    800a40 <vsnprintf+0x45>

00800a49 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a4f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a52:	50                   	push   %eax
  800a53:	ff 75 10             	pushl  0x10(%ebp)
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	ff 75 08             	pushl  0x8(%ebp)
  800a5c:	e8 9a ff ff ff       	call   8009fb <vsnprintf>
	va_end(ap);

	return rc;
}
  800a61:	c9                   	leave  
  800a62:	c3                   	ret    

00800a63 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a69:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a72:	74 05                	je     800a79 <strlen+0x16>
		n++;
  800a74:	83 c0 01             	add    $0x1,%eax
  800a77:	eb f5                	jmp    800a6e <strlen+0xb>
	return n;
}
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a81:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a84:	ba 00 00 00 00       	mov    $0x0,%edx
  800a89:	39 c2                	cmp    %eax,%edx
  800a8b:	74 0d                	je     800a9a <strnlen+0x1f>
  800a8d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a91:	74 05                	je     800a98 <strnlen+0x1d>
		n++;
  800a93:	83 c2 01             	add    $0x1,%edx
  800a96:	eb f1                	jmp    800a89 <strnlen+0xe>
  800a98:	89 d0                	mov    %edx,%eax
	return n;
}
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	53                   	push   %ebx
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800aa6:	ba 00 00 00 00       	mov    $0x0,%edx
  800aab:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aaf:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ab2:	83 c2 01             	add    $0x1,%edx
  800ab5:	84 c9                	test   %cl,%cl
  800ab7:	75 f2                	jne    800aab <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ab9:	5b                   	pop    %ebx
  800aba:	5d                   	pop    %ebp
  800abb:	c3                   	ret    

00800abc <strcat>:

char *
strcat(char *dst, const char *src)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	53                   	push   %ebx
  800ac0:	83 ec 10             	sub    $0x10,%esp
  800ac3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ac6:	53                   	push   %ebx
  800ac7:	e8 97 ff ff ff       	call   800a63 <strlen>
  800acc:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	01 d8                	add    %ebx,%eax
  800ad4:	50                   	push   %eax
  800ad5:	e8 c2 ff ff ff       	call   800a9c <strcpy>
	return dst;
}
  800ada:	89 d8                	mov    %ebx,%eax
  800adc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800adf:	c9                   	leave  
  800ae0:	c3                   	ret    

00800ae1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	56                   	push   %esi
  800ae5:	53                   	push   %ebx
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aec:	89 c6                	mov    %eax,%esi
  800aee:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800af1:	89 c2                	mov    %eax,%edx
  800af3:	39 f2                	cmp    %esi,%edx
  800af5:	74 11                	je     800b08 <strncpy+0x27>
		*dst++ = *src;
  800af7:	83 c2 01             	add    $0x1,%edx
  800afa:	0f b6 19             	movzbl (%ecx),%ebx
  800afd:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b00:	80 fb 01             	cmp    $0x1,%bl
  800b03:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b06:	eb eb                	jmp    800af3 <strncpy+0x12>
	}
	return ret;
}
  800b08:	5b                   	pop    %ebx
  800b09:	5e                   	pop    %esi
  800b0a:	5d                   	pop    %ebp
  800b0b:	c3                   	ret    

00800b0c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	56                   	push   %esi
  800b10:	53                   	push   %ebx
  800b11:	8b 75 08             	mov    0x8(%ebp),%esi
  800b14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b17:	8b 55 10             	mov    0x10(%ebp),%edx
  800b1a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b1c:	85 d2                	test   %edx,%edx
  800b1e:	74 21                	je     800b41 <strlcpy+0x35>
  800b20:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b24:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b26:	39 c2                	cmp    %eax,%edx
  800b28:	74 14                	je     800b3e <strlcpy+0x32>
  800b2a:	0f b6 19             	movzbl (%ecx),%ebx
  800b2d:	84 db                	test   %bl,%bl
  800b2f:	74 0b                	je     800b3c <strlcpy+0x30>
			*dst++ = *src++;
  800b31:	83 c1 01             	add    $0x1,%ecx
  800b34:	83 c2 01             	add    $0x1,%edx
  800b37:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b3a:	eb ea                	jmp    800b26 <strlcpy+0x1a>
  800b3c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b3e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b41:	29 f0                	sub    %esi,%eax
}
  800b43:	5b                   	pop    %ebx
  800b44:	5e                   	pop    %esi
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    

00800b47 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b50:	0f b6 01             	movzbl (%ecx),%eax
  800b53:	84 c0                	test   %al,%al
  800b55:	74 0c                	je     800b63 <strcmp+0x1c>
  800b57:	3a 02                	cmp    (%edx),%al
  800b59:	75 08                	jne    800b63 <strcmp+0x1c>
		p++, q++;
  800b5b:	83 c1 01             	add    $0x1,%ecx
  800b5e:	83 c2 01             	add    $0x1,%edx
  800b61:	eb ed                	jmp    800b50 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b63:	0f b6 c0             	movzbl %al,%eax
  800b66:	0f b6 12             	movzbl (%edx),%edx
  800b69:	29 d0                	sub    %edx,%eax
}
  800b6b:	5d                   	pop    %ebp
  800b6c:	c3                   	ret    

00800b6d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	53                   	push   %ebx
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b77:	89 c3                	mov    %eax,%ebx
  800b79:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b7c:	eb 06                	jmp    800b84 <strncmp+0x17>
		n--, p++, q++;
  800b7e:	83 c0 01             	add    $0x1,%eax
  800b81:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b84:	39 d8                	cmp    %ebx,%eax
  800b86:	74 16                	je     800b9e <strncmp+0x31>
  800b88:	0f b6 08             	movzbl (%eax),%ecx
  800b8b:	84 c9                	test   %cl,%cl
  800b8d:	74 04                	je     800b93 <strncmp+0x26>
  800b8f:	3a 0a                	cmp    (%edx),%cl
  800b91:	74 eb                	je     800b7e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b93:	0f b6 00             	movzbl (%eax),%eax
  800b96:	0f b6 12             	movzbl (%edx),%edx
  800b99:	29 d0                	sub    %edx,%eax
}
  800b9b:	5b                   	pop    %ebx
  800b9c:	5d                   	pop    %ebp
  800b9d:	c3                   	ret    
		return 0;
  800b9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba3:	eb f6                	jmp    800b9b <strncmp+0x2e>

00800ba5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800baf:	0f b6 10             	movzbl (%eax),%edx
  800bb2:	84 d2                	test   %dl,%dl
  800bb4:	74 09                	je     800bbf <strchr+0x1a>
		if (*s == c)
  800bb6:	38 ca                	cmp    %cl,%dl
  800bb8:	74 0a                	je     800bc4 <strchr+0x1f>
	for (; *s; s++)
  800bba:	83 c0 01             	add    $0x1,%eax
  800bbd:	eb f0                	jmp    800baf <strchr+0xa>
			return (char *) s;
	return 0;
  800bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bd0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bd3:	38 ca                	cmp    %cl,%dl
  800bd5:	74 09                	je     800be0 <strfind+0x1a>
  800bd7:	84 d2                	test   %dl,%dl
  800bd9:	74 05                	je     800be0 <strfind+0x1a>
	for (; *s; s++)
  800bdb:	83 c0 01             	add    $0x1,%eax
  800bde:	eb f0                	jmp    800bd0 <strfind+0xa>
			break;
	return (char *) s;
}
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    

00800be2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	57                   	push   %edi
  800be6:	56                   	push   %esi
  800be7:	53                   	push   %ebx
  800be8:	8b 7d 08             	mov    0x8(%ebp),%edi
  800beb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bee:	85 c9                	test   %ecx,%ecx
  800bf0:	74 31                	je     800c23 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bf2:	89 f8                	mov    %edi,%eax
  800bf4:	09 c8                	or     %ecx,%eax
  800bf6:	a8 03                	test   $0x3,%al
  800bf8:	75 23                	jne    800c1d <memset+0x3b>
		c &= 0xFF;
  800bfa:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bfe:	89 d3                	mov    %edx,%ebx
  800c00:	c1 e3 08             	shl    $0x8,%ebx
  800c03:	89 d0                	mov    %edx,%eax
  800c05:	c1 e0 18             	shl    $0x18,%eax
  800c08:	89 d6                	mov    %edx,%esi
  800c0a:	c1 e6 10             	shl    $0x10,%esi
  800c0d:	09 f0                	or     %esi,%eax
  800c0f:	09 c2                	or     %eax,%edx
  800c11:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c13:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c16:	89 d0                	mov    %edx,%eax
  800c18:	fc                   	cld    
  800c19:	f3 ab                	rep stos %eax,%es:(%edi)
  800c1b:	eb 06                	jmp    800c23 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c20:	fc                   	cld    
  800c21:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c23:	89 f8                	mov    %edi,%eax
  800c25:	5b                   	pop    %ebx
  800c26:	5e                   	pop    %esi
  800c27:	5f                   	pop    %edi
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    

00800c2a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	57                   	push   %edi
  800c2e:	56                   	push   %esi
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c35:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c38:	39 c6                	cmp    %eax,%esi
  800c3a:	73 32                	jae    800c6e <memmove+0x44>
  800c3c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c3f:	39 c2                	cmp    %eax,%edx
  800c41:	76 2b                	jbe    800c6e <memmove+0x44>
		s += n;
		d += n;
  800c43:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c46:	89 fe                	mov    %edi,%esi
  800c48:	09 ce                	or     %ecx,%esi
  800c4a:	09 d6                	or     %edx,%esi
  800c4c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c52:	75 0e                	jne    800c62 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c54:	83 ef 04             	sub    $0x4,%edi
  800c57:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c5a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c5d:	fd                   	std    
  800c5e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c60:	eb 09                	jmp    800c6b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c62:	83 ef 01             	sub    $0x1,%edi
  800c65:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c68:	fd                   	std    
  800c69:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c6b:	fc                   	cld    
  800c6c:	eb 1a                	jmp    800c88 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c6e:	89 c2                	mov    %eax,%edx
  800c70:	09 ca                	or     %ecx,%edx
  800c72:	09 f2                	or     %esi,%edx
  800c74:	f6 c2 03             	test   $0x3,%dl
  800c77:	75 0a                	jne    800c83 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c79:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c7c:	89 c7                	mov    %eax,%edi
  800c7e:	fc                   	cld    
  800c7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c81:	eb 05                	jmp    800c88 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c83:	89 c7                	mov    %eax,%edi
  800c85:	fc                   	cld    
  800c86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c88:	5e                   	pop    %esi
  800c89:	5f                   	pop    %edi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c92:	ff 75 10             	pushl  0x10(%ebp)
  800c95:	ff 75 0c             	pushl  0xc(%ebp)
  800c98:	ff 75 08             	pushl  0x8(%ebp)
  800c9b:	e8 8a ff ff ff       	call   800c2a <memmove>
}
  800ca0:	c9                   	leave  
  800ca1:	c3                   	ret    

00800ca2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	56                   	push   %esi
  800ca6:	53                   	push   %ebx
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cad:	89 c6                	mov    %eax,%esi
  800caf:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cb2:	39 f0                	cmp    %esi,%eax
  800cb4:	74 1c                	je     800cd2 <memcmp+0x30>
		if (*s1 != *s2)
  800cb6:	0f b6 08             	movzbl (%eax),%ecx
  800cb9:	0f b6 1a             	movzbl (%edx),%ebx
  800cbc:	38 d9                	cmp    %bl,%cl
  800cbe:	75 08                	jne    800cc8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cc0:	83 c0 01             	add    $0x1,%eax
  800cc3:	83 c2 01             	add    $0x1,%edx
  800cc6:	eb ea                	jmp    800cb2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cc8:	0f b6 c1             	movzbl %cl,%eax
  800ccb:	0f b6 db             	movzbl %bl,%ebx
  800cce:	29 d8                	sub    %ebx,%eax
  800cd0:	eb 05                	jmp    800cd7 <memcmp+0x35>
	}

	return 0;
  800cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd7:	5b                   	pop    %ebx
  800cd8:	5e                   	pop    %esi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ce4:	89 c2                	mov    %eax,%edx
  800ce6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ce9:	39 d0                	cmp    %edx,%eax
  800ceb:	73 09                	jae    800cf6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ced:	38 08                	cmp    %cl,(%eax)
  800cef:	74 05                	je     800cf6 <memfind+0x1b>
	for (; s < ends; s++)
  800cf1:	83 c0 01             	add    $0x1,%eax
  800cf4:	eb f3                	jmp    800ce9 <memfind+0xe>
			break;
	return (void *) s;
}
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    

00800cf8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	57                   	push   %edi
  800cfc:	56                   	push   %esi
  800cfd:	53                   	push   %ebx
  800cfe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d04:	eb 03                	jmp    800d09 <strtol+0x11>
		s++;
  800d06:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d09:	0f b6 01             	movzbl (%ecx),%eax
  800d0c:	3c 20                	cmp    $0x20,%al
  800d0e:	74 f6                	je     800d06 <strtol+0xe>
  800d10:	3c 09                	cmp    $0x9,%al
  800d12:	74 f2                	je     800d06 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d14:	3c 2b                	cmp    $0x2b,%al
  800d16:	74 2a                	je     800d42 <strtol+0x4a>
	int neg = 0;
  800d18:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d1d:	3c 2d                	cmp    $0x2d,%al
  800d1f:	74 2b                	je     800d4c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d21:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d27:	75 0f                	jne    800d38 <strtol+0x40>
  800d29:	80 39 30             	cmpb   $0x30,(%ecx)
  800d2c:	74 28                	je     800d56 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d2e:	85 db                	test   %ebx,%ebx
  800d30:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d35:	0f 44 d8             	cmove  %eax,%ebx
  800d38:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d40:	eb 50                	jmp    800d92 <strtol+0x9a>
		s++;
  800d42:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d45:	bf 00 00 00 00       	mov    $0x0,%edi
  800d4a:	eb d5                	jmp    800d21 <strtol+0x29>
		s++, neg = 1;
  800d4c:	83 c1 01             	add    $0x1,%ecx
  800d4f:	bf 01 00 00 00       	mov    $0x1,%edi
  800d54:	eb cb                	jmp    800d21 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d56:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d5a:	74 0e                	je     800d6a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d5c:	85 db                	test   %ebx,%ebx
  800d5e:	75 d8                	jne    800d38 <strtol+0x40>
		s++, base = 8;
  800d60:	83 c1 01             	add    $0x1,%ecx
  800d63:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d68:	eb ce                	jmp    800d38 <strtol+0x40>
		s += 2, base = 16;
  800d6a:	83 c1 02             	add    $0x2,%ecx
  800d6d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d72:	eb c4                	jmp    800d38 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d74:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d77:	89 f3                	mov    %esi,%ebx
  800d79:	80 fb 19             	cmp    $0x19,%bl
  800d7c:	77 29                	ja     800da7 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d7e:	0f be d2             	movsbl %dl,%edx
  800d81:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d84:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d87:	7d 30                	jge    800db9 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d89:	83 c1 01             	add    $0x1,%ecx
  800d8c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d90:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d92:	0f b6 11             	movzbl (%ecx),%edx
  800d95:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d98:	89 f3                	mov    %esi,%ebx
  800d9a:	80 fb 09             	cmp    $0x9,%bl
  800d9d:	77 d5                	ja     800d74 <strtol+0x7c>
			dig = *s - '0';
  800d9f:	0f be d2             	movsbl %dl,%edx
  800da2:	83 ea 30             	sub    $0x30,%edx
  800da5:	eb dd                	jmp    800d84 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800da7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800daa:	89 f3                	mov    %esi,%ebx
  800dac:	80 fb 19             	cmp    $0x19,%bl
  800daf:	77 08                	ja     800db9 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800db1:	0f be d2             	movsbl %dl,%edx
  800db4:	83 ea 37             	sub    $0x37,%edx
  800db7:	eb cb                	jmp    800d84 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800db9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dbd:	74 05                	je     800dc4 <strtol+0xcc>
		*endptr = (char *) s;
  800dbf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dc2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800dc4:	89 c2                	mov    %eax,%edx
  800dc6:	f7 da                	neg    %edx
  800dc8:	85 ff                	test   %edi,%edi
  800dca:	0f 45 c2             	cmovne %edx,%eax
}
  800dcd:	5b                   	pop    %ebx
  800dce:	5e                   	pop    %esi
  800dcf:	5f                   	pop    %edi
  800dd0:	5d                   	pop    %ebp
  800dd1:	c3                   	ret    

00800dd2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	57                   	push   %edi
  800dd6:	56                   	push   %esi
  800dd7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ddd:	8b 55 08             	mov    0x8(%ebp),%edx
  800de0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de3:	89 c3                	mov    %eax,%ebx
  800de5:	89 c7                	mov    %eax,%edi
  800de7:	89 c6                	mov    %eax,%esi
  800de9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800deb:	5b                   	pop    %ebx
  800dec:	5e                   	pop    %esi
  800ded:	5f                   	pop    %edi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    

00800df0 <sys_cgetc>:

int
sys_cgetc(void)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	57                   	push   %edi
  800df4:	56                   	push   %esi
  800df5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df6:	ba 00 00 00 00       	mov    $0x0,%edx
  800dfb:	b8 01 00 00 00       	mov    $0x1,%eax
  800e00:	89 d1                	mov    %edx,%ecx
  800e02:	89 d3                	mov    %edx,%ebx
  800e04:	89 d7                	mov    %edx,%edi
  800e06:	89 d6                	mov    %edx,%esi
  800e08:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e0a:	5b                   	pop    %ebx
  800e0b:	5e                   	pop    %esi
  800e0c:	5f                   	pop    %edi
  800e0d:	5d                   	pop    %ebp
  800e0e:	c3                   	ret    

00800e0f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	57                   	push   %edi
  800e13:	56                   	push   %esi
  800e14:	53                   	push   %ebx
  800e15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e18:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e20:	b8 03 00 00 00       	mov    $0x3,%eax
  800e25:	89 cb                	mov    %ecx,%ebx
  800e27:	89 cf                	mov    %ecx,%edi
  800e29:	89 ce                	mov    %ecx,%esi
  800e2b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2d:	85 c0                	test   %eax,%eax
  800e2f:	7f 08                	jg     800e39 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e39:	83 ec 0c             	sub    $0xc,%esp
  800e3c:	50                   	push   %eax
  800e3d:	6a 03                	push   $0x3
  800e3f:	68 48 31 80 00       	push   $0x803148
  800e44:	6a 43                	push   $0x43
  800e46:	68 65 31 80 00       	push   $0x803165
  800e4b:	e8 f7 f3 ff ff       	call   800247 <_panic>

00800e50 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	57                   	push   %edi
  800e54:	56                   	push   %esi
  800e55:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e56:	ba 00 00 00 00       	mov    $0x0,%edx
  800e5b:	b8 02 00 00 00       	mov    $0x2,%eax
  800e60:	89 d1                	mov    %edx,%ecx
  800e62:	89 d3                	mov    %edx,%ebx
  800e64:	89 d7                	mov    %edx,%edi
  800e66:	89 d6                	mov    %edx,%esi
  800e68:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e6a:	5b                   	pop    %ebx
  800e6b:	5e                   	pop    %esi
  800e6c:	5f                   	pop    %edi
  800e6d:	5d                   	pop    %ebp
  800e6e:	c3                   	ret    

00800e6f <sys_yield>:

void
sys_yield(void)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	57                   	push   %edi
  800e73:	56                   	push   %esi
  800e74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e75:	ba 00 00 00 00       	mov    $0x0,%edx
  800e7a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e7f:	89 d1                	mov    %edx,%ecx
  800e81:	89 d3                	mov    %edx,%ebx
  800e83:	89 d7                	mov    %edx,%edi
  800e85:	89 d6                	mov    %edx,%esi
  800e87:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e89:	5b                   	pop    %ebx
  800e8a:	5e                   	pop    %esi
  800e8b:	5f                   	pop    %edi
  800e8c:	5d                   	pop    %ebp
  800e8d:	c3                   	ret    

00800e8e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	57                   	push   %edi
  800e92:	56                   	push   %esi
  800e93:	53                   	push   %ebx
  800e94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e97:	be 00 00 00 00       	mov    $0x0,%esi
  800e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea2:	b8 04 00 00 00       	mov    $0x4,%eax
  800ea7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eaa:	89 f7                	mov    %esi,%edi
  800eac:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	7f 08                	jg     800eba <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800eb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb5:	5b                   	pop    %ebx
  800eb6:	5e                   	pop    %esi
  800eb7:	5f                   	pop    %edi
  800eb8:	5d                   	pop    %ebp
  800eb9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eba:	83 ec 0c             	sub    $0xc,%esp
  800ebd:	50                   	push   %eax
  800ebe:	6a 04                	push   $0x4
  800ec0:	68 48 31 80 00       	push   $0x803148
  800ec5:	6a 43                	push   $0x43
  800ec7:	68 65 31 80 00       	push   $0x803165
  800ecc:	e8 76 f3 ff ff       	call   800247 <_panic>

00800ed1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	57                   	push   %edi
  800ed5:	56                   	push   %esi
  800ed6:	53                   	push   %ebx
  800ed7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eda:	8b 55 08             	mov    0x8(%ebp),%edx
  800edd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee0:	b8 05 00 00 00       	mov    $0x5,%eax
  800ee5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eeb:	8b 75 18             	mov    0x18(%ebp),%esi
  800eee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	7f 08                	jg     800efc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ef4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef7:	5b                   	pop    %ebx
  800ef8:	5e                   	pop    %esi
  800ef9:	5f                   	pop    %edi
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efc:	83 ec 0c             	sub    $0xc,%esp
  800eff:	50                   	push   %eax
  800f00:	6a 05                	push   $0x5
  800f02:	68 48 31 80 00       	push   $0x803148
  800f07:	6a 43                	push   $0x43
  800f09:	68 65 31 80 00       	push   $0x803165
  800f0e:	e8 34 f3 ff ff       	call   800247 <_panic>

00800f13 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	57                   	push   %edi
  800f17:	56                   	push   %esi
  800f18:	53                   	push   %ebx
  800f19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f27:	b8 06 00 00 00       	mov    $0x6,%eax
  800f2c:	89 df                	mov    %ebx,%edi
  800f2e:	89 de                	mov    %ebx,%esi
  800f30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f32:	85 c0                	test   %eax,%eax
  800f34:	7f 08                	jg     800f3e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f39:	5b                   	pop    %ebx
  800f3a:	5e                   	pop    %esi
  800f3b:	5f                   	pop    %edi
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3e:	83 ec 0c             	sub    $0xc,%esp
  800f41:	50                   	push   %eax
  800f42:	6a 06                	push   $0x6
  800f44:	68 48 31 80 00       	push   $0x803148
  800f49:	6a 43                	push   $0x43
  800f4b:	68 65 31 80 00       	push   $0x803165
  800f50:	e8 f2 f2 ff ff       	call   800247 <_panic>

00800f55 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	57                   	push   %edi
  800f59:	56                   	push   %esi
  800f5a:	53                   	push   %ebx
  800f5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f63:	8b 55 08             	mov    0x8(%ebp),%edx
  800f66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f69:	b8 08 00 00 00       	mov    $0x8,%eax
  800f6e:	89 df                	mov    %ebx,%edi
  800f70:	89 de                	mov    %ebx,%esi
  800f72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f74:	85 c0                	test   %eax,%eax
  800f76:	7f 08                	jg     800f80 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7b:	5b                   	pop    %ebx
  800f7c:	5e                   	pop    %esi
  800f7d:	5f                   	pop    %edi
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f80:	83 ec 0c             	sub    $0xc,%esp
  800f83:	50                   	push   %eax
  800f84:	6a 08                	push   $0x8
  800f86:	68 48 31 80 00       	push   $0x803148
  800f8b:	6a 43                	push   $0x43
  800f8d:	68 65 31 80 00       	push   $0x803165
  800f92:	e8 b0 f2 ff ff       	call   800247 <_panic>

00800f97 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	57                   	push   %edi
  800f9b:	56                   	push   %esi
  800f9c:	53                   	push   %ebx
  800f9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fab:	b8 09 00 00 00       	mov    $0x9,%eax
  800fb0:	89 df                	mov    %ebx,%edi
  800fb2:	89 de                	mov    %ebx,%esi
  800fb4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	7f 08                	jg     800fc2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbd:	5b                   	pop    %ebx
  800fbe:	5e                   	pop    %esi
  800fbf:	5f                   	pop    %edi
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc2:	83 ec 0c             	sub    $0xc,%esp
  800fc5:	50                   	push   %eax
  800fc6:	6a 09                	push   $0x9
  800fc8:	68 48 31 80 00       	push   $0x803148
  800fcd:	6a 43                	push   $0x43
  800fcf:	68 65 31 80 00       	push   $0x803165
  800fd4:	e8 6e f2 ff ff       	call   800247 <_panic>

00800fd9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
  800fdf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fed:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ff2:	89 df                	mov    %ebx,%edi
  800ff4:	89 de                	mov    %ebx,%esi
  800ff6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff8:	85 c0                	test   %eax,%eax
  800ffa:	7f 08                	jg     801004 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fff:	5b                   	pop    %ebx
  801000:	5e                   	pop    %esi
  801001:	5f                   	pop    %edi
  801002:	5d                   	pop    %ebp
  801003:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801004:	83 ec 0c             	sub    $0xc,%esp
  801007:	50                   	push   %eax
  801008:	6a 0a                	push   $0xa
  80100a:	68 48 31 80 00       	push   $0x803148
  80100f:	6a 43                	push   $0x43
  801011:	68 65 31 80 00       	push   $0x803165
  801016:	e8 2c f2 ff ff       	call   800247 <_panic>

0080101b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	57                   	push   %edi
  80101f:	56                   	push   %esi
  801020:	53                   	push   %ebx
	asm volatile("int %1\n"
  801021:	8b 55 08             	mov    0x8(%ebp),%edx
  801024:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801027:	b8 0c 00 00 00       	mov    $0xc,%eax
  80102c:	be 00 00 00 00       	mov    $0x0,%esi
  801031:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801034:	8b 7d 14             	mov    0x14(%ebp),%edi
  801037:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801039:	5b                   	pop    %ebx
  80103a:	5e                   	pop    %esi
  80103b:	5f                   	pop    %edi
  80103c:	5d                   	pop    %ebp
  80103d:	c3                   	ret    

0080103e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	57                   	push   %edi
  801042:	56                   	push   %esi
  801043:	53                   	push   %ebx
  801044:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801047:	b9 00 00 00 00       	mov    $0x0,%ecx
  80104c:	8b 55 08             	mov    0x8(%ebp),%edx
  80104f:	b8 0d 00 00 00       	mov    $0xd,%eax
  801054:	89 cb                	mov    %ecx,%ebx
  801056:	89 cf                	mov    %ecx,%edi
  801058:	89 ce                	mov    %ecx,%esi
  80105a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80105c:	85 c0                	test   %eax,%eax
  80105e:	7f 08                	jg     801068 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801060:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801063:	5b                   	pop    %ebx
  801064:	5e                   	pop    %esi
  801065:	5f                   	pop    %edi
  801066:	5d                   	pop    %ebp
  801067:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801068:	83 ec 0c             	sub    $0xc,%esp
  80106b:	50                   	push   %eax
  80106c:	6a 0d                	push   $0xd
  80106e:	68 48 31 80 00       	push   $0x803148
  801073:	6a 43                	push   $0x43
  801075:	68 65 31 80 00       	push   $0x803165
  80107a:	e8 c8 f1 ff ff       	call   800247 <_panic>

0080107f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	57                   	push   %edi
  801083:	56                   	push   %esi
  801084:	53                   	push   %ebx
	asm volatile("int %1\n"
  801085:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108a:	8b 55 08             	mov    0x8(%ebp),%edx
  80108d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801090:	b8 0e 00 00 00       	mov    $0xe,%eax
  801095:	89 df                	mov    %ebx,%edi
  801097:	89 de                	mov    %ebx,%esi
  801099:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80109b:	5b                   	pop    %ebx
  80109c:	5e                   	pop    %esi
  80109d:	5f                   	pop    %edi
  80109e:	5d                   	pop    %ebp
  80109f:	c3                   	ret    

008010a0 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
  8010a3:	57                   	push   %edi
  8010a4:	56                   	push   %esi
  8010a5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ae:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010b3:	89 cb                	mov    %ecx,%ebx
  8010b5:	89 cf                	mov    %ecx,%edi
  8010b7:	89 ce                	mov    %ecx,%esi
  8010b9:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010bb:	5b                   	pop    %ebx
  8010bc:	5e                   	pop    %esi
  8010bd:	5f                   	pop    %edi
  8010be:	5d                   	pop    %ebp
  8010bf:	c3                   	ret    

008010c0 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
  8010c3:	57                   	push   %edi
  8010c4:	56                   	push   %esi
  8010c5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8010cb:	b8 10 00 00 00       	mov    $0x10,%eax
  8010d0:	89 d1                	mov    %edx,%ecx
  8010d2:	89 d3                	mov    %edx,%ebx
  8010d4:	89 d7                	mov    %edx,%edi
  8010d6:	89 d6                	mov    %edx,%esi
  8010d8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010da:	5b                   	pop    %ebx
  8010db:	5e                   	pop    %esi
  8010dc:	5f                   	pop    %edi
  8010dd:	5d                   	pop    %ebp
  8010de:	c3                   	ret    

008010df <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	57                   	push   %edi
  8010e3:	56                   	push   %esi
  8010e4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f0:	b8 11 00 00 00       	mov    $0x11,%eax
  8010f5:	89 df                	mov    %ebx,%edi
  8010f7:	89 de                	mov    %ebx,%esi
  8010f9:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010fb:	5b                   	pop    %ebx
  8010fc:	5e                   	pop    %esi
  8010fd:	5f                   	pop    %edi
  8010fe:	5d                   	pop    %ebp
  8010ff:	c3                   	ret    

00801100 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	57                   	push   %edi
  801104:	56                   	push   %esi
  801105:	53                   	push   %ebx
	asm volatile("int %1\n"
  801106:	bb 00 00 00 00       	mov    $0x0,%ebx
  80110b:	8b 55 08             	mov    0x8(%ebp),%edx
  80110e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801111:	b8 12 00 00 00       	mov    $0x12,%eax
  801116:	89 df                	mov    %ebx,%edi
  801118:	89 de                	mov    %ebx,%esi
  80111a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80111c:	5b                   	pop    %ebx
  80111d:	5e                   	pop    %esi
  80111e:	5f                   	pop    %edi
  80111f:	5d                   	pop    %ebp
  801120:	c3                   	ret    

00801121 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	57                   	push   %edi
  801125:	56                   	push   %esi
  801126:	53                   	push   %ebx
  801127:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80112a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112f:	8b 55 08             	mov    0x8(%ebp),%edx
  801132:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801135:	b8 13 00 00 00       	mov    $0x13,%eax
  80113a:	89 df                	mov    %ebx,%edi
  80113c:	89 de                	mov    %ebx,%esi
  80113e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801140:	85 c0                	test   %eax,%eax
  801142:	7f 08                	jg     80114c <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801144:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801147:	5b                   	pop    %ebx
  801148:	5e                   	pop    %esi
  801149:	5f                   	pop    %edi
  80114a:	5d                   	pop    %ebp
  80114b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80114c:	83 ec 0c             	sub    $0xc,%esp
  80114f:	50                   	push   %eax
  801150:	6a 13                	push   $0x13
  801152:	68 48 31 80 00       	push   $0x803148
  801157:	6a 43                	push   $0x43
  801159:	68 65 31 80 00       	push   $0x803165
  80115e:	e8 e4 f0 ff ff       	call   800247 <_panic>

00801163 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	57                   	push   %edi
  801167:	56                   	push   %esi
  801168:	53                   	push   %ebx
	asm volatile("int %1\n"
  801169:	b9 00 00 00 00       	mov    $0x0,%ecx
  80116e:	8b 55 08             	mov    0x8(%ebp),%edx
  801171:	b8 14 00 00 00       	mov    $0x14,%eax
  801176:	89 cb                	mov    %ecx,%ebx
  801178:	89 cf                	mov    %ecx,%edi
  80117a:	89 ce                	mov    %ecx,%esi
  80117c:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80117e:	5b                   	pop    %ebx
  80117f:	5e                   	pop    %esi
  801180:	5f                   	pop    %edi
  801181:	5d                   	pop    %ebp
  801182:	c3                   	ret    

00801183 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	53                   	push   %ebx
  801187:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  80118a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801191:	f6 c5 04             	test   $0x4,%ch
  801194:	75 45                	jne    8011db <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801196:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80119d:	83 e1 07             	and    $0x7,%ecx
  8011a0:	83 f9 07             	cmp    $0x7,%ecx
  8011a3:	74 6f                	je     801214 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8011a5:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011ac:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8011b2:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8011b8:	0f 84 b6 00 00 00    	je     801274 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8011be:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011c5:	83 e1 05             	and    $0x5,%ecx
  8011c8:	83 f9 05             	cmp    $0x5,%ecx
  8011cb:	0f 84 d7 00 00 00    	je     8012a8 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8011d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8011db:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011e2:	c1 e2 0c             	shl    $0xc,%edx
  8011e5:	83 ec 0c             	sub    $0xc,%esp
  8011e8:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8011ee:	51                   	push   %ecx
  8011ef:	52                   	push   %edx
  8011f0:	50                   	push   %eax
  8011f1:	52                   	push   %edx
  8011f2:	6a 00                	push   $0x0
  8011f4:	e8 d8 fc ff ff       	call   800ed1 <sys_page_map>
		if(r < 0)
  8011f9:	83 c4 20             	add    $0x20,%esp
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	79 d1                	jns    8011d1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801200:	83 ec 04             	sub    $0x4,%esp
  801203:	68 73 31 80 00       	push   $0x803173
  801208:	6a 54                	push   $0x54
  80120a:	68 89 31 80 00       	push   $0x803189
  80120f:	e8 33 f0 ff ff       	call   800247 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801214:	89 d3                	mov    %edx,%ebx
  801216:	c1 e3 0c             	shl    $0xc,%ebx
  801219:	83 ec 0c             	sub    $0xc,%esp
  80121c:	68 05 08 00 00       	push   $0x805
  801221:	53                   	push   %ebx
  801222:	50                   	push   %eax
  801223:	53                   	push   %ebx
  801224:	6a 00                	push   $0x0
  801226:	e8 a6 fc ff ff       	call   800ed1 <sys_page_map>
		if(r < 0)
  80122b:	83 c4 20             	add    $0x20,%esp
  80122e:	85 c0                	test   %eax,%eax
  801230:	78 2e                	js     801260 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801232:	83 ec 0c             	sub    $0xc,%esp
  801235:	68 05 08 00 00       	push   $0x805
  80123a:	53                   	push   %ebx
  80123b:	6a 00                	push   $0x0
  80123d:	53                   	push   %ebx
  80123e:	6a 00                	push   $0x0
  801240:	e8 8c fc ff ff       	call   800ed1 <sys_page_map>
		if(r < 0)
  801245:	83 c4 20             	add    $0x20,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	79 85                	jns    8011d1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80124c:	83 ec 04             	sub    $0x4,%esp
  80124f:	68 73 31 80 00       	push   $0x803173
  801254:	6a 5f                	push   $0x5f
  801256:	68 89 31 80 00       	push   $0x803189
  80125b:	e8 e7 ef ff ff       	call   800247 <_panic>
			panic("sys_page_map() panic\n");
  801260:	83 ec 04             	sub    $0x4,%esp
  801263:	68 73 31 80 00       	push   $0x803173
  801268:	6a 5b                	push   $0x5b
  80126a:	68 89 31 80 00       	push   $0x803189
  80126f:	e8 d3 ef ff ff       	call   800247 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801274:	c1 e2 0c             	shl    $0xc,%edx
  801277:	83 ec 0c             	sub    $0xc,%esp
  80127a:	68 05 08 00 00       	push   $0x805
  80127f:	52                   	push   %edx
  801280:	50                   	push   %eax
  801281:	52                   	push   %edx
  801282:	6a 00                	push   $0x0
  801284:	e8 48 fc ff ff       	call   800ed1 <sys_page_map>
		if(r < 0)
  801289:	83 c4 20             	add    $0x20,%esp
  80128c:	85 c0                	test   %eax,%eax
  80128e:	0f 89 3d ff ff ff    	jns    8011d1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801294:	83 ec 04             	sub    $0x4,%esp
  801297:	68 73 31 80 00       	push   $0x803173
  80129c:	6a 66                	push   $0x66
  80129e:	68 89 31 80 00       	push   $0x803189
  8012a3:	e8 9f ef ff ff       	call   800247 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012a8:	c1 e2 0c             	shl    $0xc,%edx
  8012ab:	83 ec 0c             	sub    $0xc,%esp
  8012ae:	6a 05                	push   $0x5
  8012b0:	52                   	push   %edx
  8012b1:	50                   	push   %eax
  8012b2:	52                   	push   %edx
  8012b3:	6a 00                	push   $0x0
  8012b5:	e8 17 fc ff ff       	call   800ed1 <sys_page_map>
		if(r < 0)
  8012ba:	83 c4 20             	add    $0x20,%esp
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	0f 89 0c ff ff ff    	jns    8011d1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012c5:	83 ec 04             	sub    $0x4,%esp
  8012c8:	68 73 31 80 00       	push   $0x803173
  8012cd:	6a 6d                	push   $0x6d
  8012cf:	68 89 31 80 00       	push   $0x803189
  8012d4:	e8 6e ef ff ff       	call   800247 <_panic>

008012d9 <pgfault>:
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	53                   	push   %ebx
  8012dd:	83 ec 04             	sub    $0x4,%esp
  8012e0:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8012e3:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012e5:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8012e9:	0f 84 99 00 00 00    	je     801388 <pgfault+0xaf>
  8012ef:	89 c2                	mov    %eax,%edx
  8012f1:	c1 ea 16             	shr    $0x16,%edx
  8012f4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012fb:	f6 c2 01             	test   $0x1,%dl
  8012fe:	0f 84 84 00 00 00    	je     801388 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801304:	89 c2                	mov    %eax,%edx
  801306:	c1 ea 0c             	shr    $0xc,%edx
  801309:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801310:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801316:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  80131c:	75 6a                	jne    801388 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  80131e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801323:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801325:	83 ec 04             	sub    $0x4,%esp
  801328:	6a 07                	push   $0x7
  80132a:	68 00 f0 7f 00       	push   $0x7ff000
  80132f:	6a 00                	push   $0x0
  801331:	e8 58 fb ff ff       	call   800e8e <sys_page_alloc>
	if(ret < 0)
  801336:	83 c4 10             	add    $0x10,%esp
  801339:	85 c0                	test   %eax,%eax
  80133b:	78 5f                	js     80139c <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80133d:	83 ec 04             	sub    $0x4,%esp
  801340:	68 00 10 00 00       	push   $0x1000
  801345:	53                   	push   %ebx
  801346:	68 00 f0 7f 00       	push   $0x7ff000
  80134b:	e8 3c f9 ff ff       	call   800c8c <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801350:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801357:	53                   	push   %ebx
  801358:	6a 00                	push   $0x0
  80135a:	68 00 f0 7f 00       	push   $0x7ff000
  80135f:	6a 00                	push   $0x0
  801361:	e8 6b fb ff ff       	call   800ed1 <sys_page_map>
	if(ret < 0)
  801366:	83 c4 20             	add    $0x20,%esp
  801369:	85 c0                	test   %eax,%eax
  80136b:	78 43                	js     8013b0 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  80136d:	83 ec 08             	sub    $0x8,%esp
  801370:	68 00 f0 7f 00       	push   $0x7ff000
  801375:	6a 00                	push   $0x0
  801377:	e8 97 fb ff ff       	call   800f13 <sys_page_unmap>
	if(ret < 0)
  80137c:	83 c4 10             	add    $0x10,%esp
  80137f:	85 c0                	test   %eax,%eax
  801381:	78 41                	js     8013c4 <pgfault+0xeb>
}
  801383:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801386:	c9                   	leave  
  801387:	c3                   	ret    
		panic("panic at pgfault()\n");
  801388:	83 ec 04             	sub    $0x4,%esp
  80138b:	68 94 31 80 00       	push   $0x803194
  801390:	6a 26                	push   $0x26
  801392:	68 89 31 80 00       	push   $0x803189
  801397:	e8 ab ee ff ff       	call   800247 <_panic>
		panic("panic in sys_page_alloc()\n");
  80139c:	83 ec 04             	sub    $0x4,%esp
  80139f:	68 a8 31 80 00       	push   $0x8031a8
  8013a4:	6a 31                	push   $0x31
  8013a6:	68 89 31 80 00       	push   $0x803189
  8013ab:	e8 97 ee ff ff       	call   800247 <_panic>
		panic("panic in sys_page_map()\n");
  8013b0:	83 ec 04             	sub    $0x4,%esp
  8013b3:	68 c3 31 80 00       	push   $0x8031c3
  8013b8:	6a 36                	push   $0x36
  8013ba:	68 89 31 80 00       	push   $0x803189
  8013bf:	e8 83 ee ff ff       	call   800247 <_panic>
		panic("panic in sys_page_unmap()\n");
  8013c4:	83 ec 04             	sub    $0x4,%esp
  8013c7:	68 dc 31 80 00       	push   $0x8031dc
  8013cc:	6a 39                	push   $0x39
  8013ce:	68 89 31 80 00       	push   $0x803189
  8013d3:	e8 6f ee ff ff       	call   800247 <_panic>

008013d8 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	57                   	push   %edi
  8013dc:	56                   	push   %esi
  8013dd:	53                   	push   %ebx
  8013de:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8013e1:	68 d9 12 80 00       	push   $0x8012d9
  8013e6:	e8 2d 14 00 00       	call   802818 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8013eb:	b8 07 00 00 00       	mov    $0x7,%eax
  8013f0:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013f2:	83 c4 10             	add    $0x10,%esp
  8013f5:	85 c0                	test   %eax,%eax
  8013f7:	78 2a                	js     801423 <fork+0x4b>
  8013f9:	89 c6                	mov    %eax,%esi
  8013fb:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013fd:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801402:	75 4b                	jne    80144f <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  801404:	e8 47 fa ff ff       	call   800e50 <sys_getenvid>
  801409:	25 ff 03 00 00       	and    $0x3ff,%eax
  80140e:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801414:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801419:	a3 20 54 80 00       	mov    %eax,0x805420
		return 0;
  80141e:	e9 90 00 00 00       	jmp    8014b3 <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  801423:	83 ec 04             	sub    $0x4,%esp
  801426:	68 f8 31 80 00       	push   $0x8031f8
  80142b:	68 8c 00 00 00       	push   $0x8c
  801430:	68 89 31 80 00       	push   $0x803189
  801435:	e8 0d ee ff ff       	call   800247 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80143a:	89 f8                	mov    %edi,%eax
  80143c:	e8 42 fd ff ff       	call   801183 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801441:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801447:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80144d:	74 26                	je     801475 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  80144f:	89 d8                	mov    %ebx,%eax
  801451:	c1 e8 16             	shr    $0x16,%eax
  801454:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80145b:	a8 01                	test   $0x1,%al
  80145d:	74 e2                	je     801441 <fork+0x69>
  80145f:	89 da                	mov    %ebx,%edx
  801461:	c1 ea 0c             	shr    $0xc,%edx
  801464:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80146b:	83 e0 05             	and    $0x5,%eax
  80146e:	83 f8 05             	cmp    $0x5,%eax
  801471:	75 ce                	jne    801441 <fork+0x69>
  801473:	eb c5                	jmp    80143a <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	6a 07                	push   $0x7
  80147a:	68 00 f0 bf ee       	push   $0xeebff000
  80147f:	56                   	push   %esi
  801480:	e8 09 fa ff ff       	call   800e8e <sys_page_alloc>
	if(ret < 0)
  801485:	83 c4 10             	add    $0x10,%esp
  801488:	85 c0                	test   %eax,%eax
  80148a:	78 31                	js     8014bd <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80148c:	83 ec 08             	sub    $0x8,%esp
  80148f:	68 87 28 80 00       	push   $0x802887
  801494:	56                   	push   %esi
  801495:	e8 3f fb ff ff       	call   800fd9 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80149a:	83 c4 10             	add    $0x10,%esp
  80149d:	85 c0                	test   %eax,%eax
  80149f:	78 33                	js     8014d4 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	6a 02                	push   $0x2
  8014a6:	56                   	push   %esi
  8014a7:	e8 a9 fa ff ff       	call   800f55 <sys_env_set_status>
	if(ret < 0)
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	78 38                	js     8014eb <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8014b3:	89 f0                	mov    %esi,%eax
  8014b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b8:	5b                   	pop    %ebx
  8014b9:	5e                   	pop    %esi
  8014ba:	5f                   	pop    %edi
  8014bb:	5d                   	pop    %ebp
  8014bc:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014bd:	83 ec 04             	sub    $0x4,%esp
  8014c0:	68 a8 31 80 00       	push   $0x8031a8
  8014c5:	68 98 00 00 00       	push   $0x98
  8014ca:	68 89 31 80 00       	push   $0x803189
  8014cf:	e8 73 ed ff ff       	call   800247 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014d4:	83 ec 04             	sub    $0x4,%esp
  8014d7:	68 1c 32 80 00       	push   $0x80321c
  8014dc:	68 9b 00 00 00       	push   $0x9b
  8014e1:	68 89 31 80 00       	push   $0x803189
  8014e6:	e8 5c ed ff ff       	call   800247 <_panic>
		panic("panic in sys_env_set_status()\n");
  8014eb:	83 ec 04             	sub    $0x4,%esp
  8014ee:	68 44 32 80 00       	push   $0x803244
  8014f3:	68 9e 00 00 00       	push   $0x9e
  8014f8:	68 89 31 80 00       	push   $0x803189
  8014fd:	e8 45 ed ff ff       	call   800247 <_panic>

00801502 <sfork>:

// Challenge!
int
sfork(void)
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
  801505:	57                   	push   %edi
  801506:	56                   	push   %esi
  801507:	53                   	push   %ebx
  801508:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  80150b:	68 d9 12 80 00       	push   $0x8012d9
  801510:	e8 03 13 00 00       	call   802818 <set_pgfault_handler>
  801515:	b8 07 00 00 00       	mov    $0x7,%eax
  80151a:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	85 c0                	test   %eax,%eax
  801521:	78 2a                	js     80154d <sfork+0x4b>
  801523:	89 c7                	mov    %eax,%edi
  801525:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801527:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80152c:	75 58                	jne    801586 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  80152e:	e8 1d f9 ff ff       	call   800e50 <sys_getenvid>
  801533:	25 ff 03 00 00       	and    $0x3ff,%eax
  801538:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80153e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801543:	a3 20 54 80 00       	mov    %eax,0x805420
		return 0;
  801548:	e9 d4 00 00 00       	jmp    801621 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  80154d:	83 ec 04             	sub    $0x4,%esp
  801550:	68 f8 31 80 00       	push   $0x8031f8
  801555:	68 af 00 00 00       	push   $0xaf
  80155a:	68 89 31 80 00       	push   $0x803189
  80155f:	e8 e3 ec ff ff       	call   800247 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801564:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801569:	89 f0                	mov    %esi,%eax
  80156b:	e8 13 fc ff ff       	call   801183 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801570:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801576:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80157c:	77 65                	ja     8015e3 <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  80157e:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801584:	74 de                	je     801564 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801586:	89 d8                	mov    %ebx,%eax
  801588:	c1 e8 16             	shr    $0x16,%eax
  80158b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801592:	a8 01                	test   $0x1,%al
  801594:	74 da                	je     801570 <sfork+0x6e>
  801596:	89 da                	mov    %ebx,%edx
  801598:	c1 ea 0c             	shr    $0xc,%edx
  80159b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015a2:	83 e0 05             	and    $0x5,%eax
  8015a5:	83 f8 05             	cmp    $0x5,%eax
  8015a8:	75 c6                	jne    801570 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015aa:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8015b1:	c1 e2 0c             	shl    $0xc,%edx
  8015b4:	83 ec 0c             	sub    $0xc,%esp
  8015b7:	83 e0 07             	and    $0x7,%eax
  8015ba:	50                   	push   %eax
  8015bb:	52                   	push   %edx
  8015bc:	56                   	push   %esi
  8015bd:	52                   	push   %edx
  8015be:	6a 00                	push   $0x0
  8015c0:	e8 0c f9 ff ff       	call   800ed1 <sys_page_map>
  8015c5:	83 c4 20             	add    $0x20,%esp
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	74 a4                	je     801570 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  8015cc:	83 ec 04             	sub    $0x4,%esp
  8015cf:	68 73 31 80 00       	push   $0x803173
  8015d4:	68 ba 00 00 00       	push   $0xba
  8015d9:	68 89 31 80 00       	push   $0x803189
  8015de:	e8 64 ec ff ff       	call   800247 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8015e3:	83 ec 04             	sub    $0x4,%esp
  8015e6:	6a 07                	push   $0x7
  8015e8:	68 00 f0 bf ee       	push   $0xeebff000
  8015ed:	57                   	push   %edi
  8015ee:	e8 9b f8 ff ff       	call   800e8e <sys_page_alloc>
	if(ret < 0)
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	78 31                	js     80162b <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8015fa:	83 ec 08             	sub    $0x8,%esp
  8015fd:	68 87 28 80 00       	push   $0x802887
  801602:	57                   	push   %edi
  801603:	e8 d1 f9 ff ff       	call   800fd9 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801608:	83 c4 10             	add    $0x10,%esp
  80160b:	85 c0                	test   %eax,%eax
  80160d:	78 33                	js     801642 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80160f:	83 ec 08             	sub    $0x8,%esp
  801612:	6a 02                	push   $0x2
  801614:	57                   	push   %edi
  801615:	e8 3b f9 ff ff       	call   800f55 <sys_env_set_status>
	if(ret < 0)
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	85 c0                	test   %eax,%eax
  80161f:	78 38                	js     801659 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801621:	89 f8                	mov    %edi,%eax
  801623:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801626:	5b                   	pop    %ebx
  801627:	5e                   	pop    %esi
  801628:	5f                   	pop    %edi
  801629:	5d                   	pop    %ebp
  80162a:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80162b:	83 ec 04             	sub    $0x4,%esp
  80162e:	68 a8 31 80 00       	push   $0x8031a8
  801633:	68 c0 00 00 00       	push   $0xc0
  801638:	68 89 31 80 00       	push   $0x803189
  80163d:	e8 05 ec ff ff       	call   800247 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801642:	83 ec 04             	sub    $0x4,%esp
  801645:	68 1c 32 80 00       	push   $0x80321c
  80164a:	68 c3 00 00 00       	push   $0xc3
  80164f:	68 89 31 80 00       	push   $0x803189
  801654:	e8 ee eb ff ff       	call   800247 <_panic>
		panic("panic in sys_env_set_status()\n");
  801659:	83 ec 04             	sub    $0x4,%esp
  80165c:	68 44 32 80 00       	push   $0x803244
  801661:	68 c6 00 00 00       	push   $0xc6
  801666:	68 89 31 80 00       	push   $0x803189
  80166b:	e8 d7 eb ff ff       	call   800247 <_panic>

00801670 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	05 00 00 00 30       	add    $0x30000000,%eax
  80167b:	c1 e8 0c             	shr    $0xc,%eax
}
  80167e:	5d                   	pop    %ebp
  80167f:	c3                   	ret    

00801680 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80168b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801690:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801695:	5d                   	pop    %ebp
  801696:	c3                   	ret    

00801697 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80169f:	89 c2                	mov    %eax,%edx
  8016a1:	c1 ea 16             	shr    $0x16,%edx
  8016a4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016ab:	f6 c2 01             	test   $0x1,%dl
  8016ae:	74 2d                	je     8016dd <fd_alloc+0x46>
  8016b0:	89 c2                	mov    %eax,%edx
  8016b2:	c1 ea 0c             	shr    $0xc,%edx
  8016b5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016bc:	f6 c2 01             	test   $0x1,%dl
  8016bf:	74 1c                	je     8016dd <fd_alloc+0x46>
  8016c1:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016c6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016cb:	75 d2                	jne    80169f <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8016d6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8016db:	eb 0a                	jmp    8016e7 <fd_alloc+0x50>
			*fd_store = fd;
  8016dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016e0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e7:	5d                   	pop    %ebp
  8016e8:	c3                   	ret    

008016e9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016ef:	83 f8 1f             	cmp    $0x1f,%eax
  8016f2:	77 30                	ja     801724 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016f4:	c1 e0 0c             	shl    $0xc,%eax
  8016f7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016fc:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801702:	f6 c2 01             	test   $0x1,%dl
  801705:	74 24                	je     80172b <fd_lookup+0x42>
  801707:	89 c2                	mov    %eax,%edx
  801709:	c1 ea 0c             	shr    $0xc,%edx
  80170c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801713:	f6 c2 01             	test   $0x1,%dl
  801716:	74 1a                	je     801732 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801718:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171b:	89 02                	mov    %eax,(%edx)
	return 0;
  80171d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801722:	5d                   	pop    %ebp
  801723:	c3                   	ret    
		return -E_INVAL;
  801724:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801729:	eb f7                	jmp    801722 <fd_lookup+0x39>
		return -E_INVAL;
  80172b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801730:	eb f0                	jmp    801722 <fd_lookup+0x39>
  801732:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801737:	eb e9                	jmp    801722 <fd_lookup+0x39>

00801739 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 08             	sub    $0x8,%esp
  80173f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801742:	ba 00 00 00 00       	mov    $0x0,%edx
  801747:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80174c:	39 08                	cmp    %ecx,(%eax)
  80174e:	74 38                	je     801788 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801750:	83 c2 01             	add    $0x1,%edx
  801753:	8b 04 95 e0 32 80 00 	mov    0x8032e0(,%edx,4),%eax
  80175a:	85 c0                	test   %eax,%eax
  80175c:	75 ee                	jne    80174c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80175e:	a1 20 54 80 00       	mov    0x805420,%eax
  801763:	8b 40 48             	mov    0x48(%eax),%eax
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	51                   	push   %ecx
  80176a:	50                   	push   %eax
  80176b:	68 64 32 80 00       	push   $0x803264
  801770:	e8 c8 eb ff ff       	call   80033d <cprintf>
	*dev = 0;
  801775:	8b 45 0c             	mov    0xc(%ebp),%eax
  801778:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80177e:	83 c4 10             	add    $0x10,%esp
  801781:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    
			*dev = devtab[i];
  801788:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80178b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80178d:	b8 00 00 00 00       	mov    $0x0,%eax
  801792:	eb f2                	jmp    801786 <dev_lookup+0x4d>

00801794 <fd_close>:
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	57                   	push   %edi
  801798:	56                   	push   %esi
  801799:	53                   	push   %ebx
  80179a:	83 ec 24             	sub    $0x24,%esp
  80179d:	8b 75 08             	mov    0x8(%ebp),%esi
  8017a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017a3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017a6:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017a7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017ad:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017b0:	50                   	push   %eax
  8017b1:	e8 33 ff ff ff       	call   8016e9 <fd_lookup>
  8017b6:	89 c3                	mov    %eax,%ebx
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	78 05                	js     8017c4 <fd_close+0x30>
	    || fd != fd2)
  8017bf:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017c2:	74 16                	je     8017da <fd_close+0x46>
		return (must_exist ? r : 0);
  8017c4:	89 f8                	mov    %edi,%eax
  8017c6:	84 c0                	test   %al,%al
  8017c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cd:	0f 44 d8             	cmove  %eax,%ebx
}
  8017d0:	89 d8                	mov    %ebx,%eax
  8017d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017d5:	5b                   	pop    %ebx
  8017d6:	5e                   	pop    %esi
  8017d7:	5f                   	pop    %edi
  8017d8:	5d                   	pop    %ebp
  8017d9:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017da:	83 ec 08             	sub    $0x8,%esp
  8017dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017e0:	50                   	push   %eax
  8017e1:	ff 36                	pushl  (%esi)
  8017e3:	e8 51 ff ff ff       	call   801739 <dev_lookup>
  8017e8:	89 c3                	mov    %eax,%ebx
  8017ea:	83 c4 10             	add    $0x10,%esp
  8017ed:	85 c0                	test   %eax,%eax
  8017ef:	78 1a                	js     80180b <fd_close+0x77>
		if (dev->dev_close)
  8017f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017f4:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8017f7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	74 0b                	je     80180b <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801800:	83 ec 0c             	sub    $0xc,%esp
  801803:	56                   	push   %esi
  801804:	ff d0                	call   *%eax
  801806:	89 c3                	mov    %eax,%ebx
  801808:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80180b:	83 ec 08             	sub    $0x8,%esp
  80180e:	56                   	push   %esi
  80180f:	6a 00                	push   $0x0
  801811:	e8 fd f6 ff ff       	call   800f13 <sys_page_unmap>
	return r;
  801816:	83 c4 10             	add    $0x10,%esp
  801819:	eb b5                	jmp    8017d0 <fd_close+0x3c>

0080181b <close>:

int
close(int fdnum)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801821:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801824:	50                   	push   %eax
  801825:	ff 75 08             	pushl  0x8(%ebp)
  801828:	e8 bc fe ff ff       	call   8016e9 <fd_lookup>
  80182d:	83 c4 10             	add    $0x10,%esp
  801830:	85 c0                	test   %eax,%eax
  801832:	79 02                	jns    801836 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    
		return fd_close(fd, 1);
  801836:	83 ec 08             	sub    $0x8,%esp
  801839:	6a 01                	push   $0x1
  80183b:	ff 75 f4             	pushl  -0xc(%ebp)
  80183e:	e8 51 ff ff ff       	call   801794 <fd_close>
  801843:	83 c4 10             	add    $0x10,%esp
  801846:	eb ec                	jmp    801834 <close+0x19>

00801848 <close_all>:

void
close_all(void)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	53                   	push   %ebx
  80184c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80184f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801854:	83 ec 0c             	sub    $0xc,%esp
  801857:	53                   	push   %ebx
  801858:	e8 be ff ff ff       	call   80181b <close>
	for (i = 0; i < MAXFD; i++)
  80185d:	83 c3 01             	add    $0x1,%ebx
  801860:	83 c4 10             	add    $0x10,%esp
  801863:	83 fb 20             	cmp    $0x20,%ebx
  801866:	75 ec                	jne    801854 <close_all+0xc>
}
  801868:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	57                   	push   %edi
  801871:	56                   	push   %esi
  801872:	53                   	push   %ebx
  801873:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801876:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801879:	50                   	push   %eax
  80187a:	ff 75 08             	pushl  0x8(%ebp)
  80187d:	e8 67 fe ff ff       	call   8016e9 <fd_lookup>
  801882:	89 c3                	mov    %eax,%ebx
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	85 c0                	test   %eax,%eax
  801889:	0f 88 81 00 00 00    	js     801910 <dup+0xa3>
		return r;
	close(newfdnum);
  80188f:	83 ec 0c             	sub    $0xc,%esp
  801892:	ff 75 0c             	pushl  0xc(%ebp)
  801895:	e8 81 ff ff ff       	call   80181b <close>

	newfd = INDEX2FD(newfdnum);
  80189a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80189d:	c1 e6 0c             	shl    $0xc,%esi
  8018a0:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018a6:	83 c4 04             	add    $0x4,%esp
  8018a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018ac:	e8 cf fd ff ff       	call   801680 <fd2data>
  8018b1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018b3:	89 34 24             	mov    %esi,(%esp)
  8018b6:	e8 c5 fd ff ff       	call   801680 <fd2data>
  8018bb:	83 c4 10             	add    $0x10,%esp
  8018be:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018c0:	89 d8                	mov    %ebx,%eax
  8018c2:	c1 e8 16             	shr    $0x16,%eax
  8018c5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018cc:	a8 01                	test   $0x1,%al
  8018ce:	74 11                	je     8018e1 <dup+0x74>
  8018d0:	89 d8                	mov    %ebx,%eax
  8018d2:	c1 e8 0c             	shr    $0xc,%eax
  8018d5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018dc:	f6 c2 01             	test   $0x1,%dl
  8018df:	75 39                	jne    80191a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018e4:	89 d0                	mov    %edx,%eax
  8018e6:	c1 e8 0c             	shr    $0xc,%eax
  8018e9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018f0:	83 ec 0c             	sub    $0xc,%esp
  8018f3:	25 07 0e 00 00       	and    $0xe07,%eax
  8018f8:	50                   	push   %eax
  8018f9:	56                   	push   %esi
  8018fa:	6a 00                	push   $0x0
  8018fc:	52                   	push   %edx
  8018fd:	6a 00                	push   $0x0
  8018ff:	e8 cd f5 ff ff       	call   800ed1 <sys_page_map>
  801904:	89 c3                	mov    %eax,%ebx
  801906:	83 c4 20             	add    $0x20,%esp
  801909:	85 c0                	test   %eax,%eax
  80190b:	78 31                	js     80193e <dup+0xd1>
		goto err;

	return newfdnum;
  80190d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801910:	89 d8                	mov    %ebx,%eax
  801912:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801915:	5b                   	pop    %ebx
  801916:	5e                   	pop    %esi
  801917:	5f                   	pop    %edi
  801918:	5d                   	pop    %ebp
  801919:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80191a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801921:	83 ec 0c             	sub    $0xc,%esp
  801924:	25 07 0e 00 00       	and    $0xe07,%eax
  801929:	50                   	push   %eax
  80192a:	57                   	push   %edi
  80192b:	6a 00                	push   $0x0
  80192d:	53                   	push   %ebx
  80192e:	6a 00                	push   $0x0
  801930:	e8 9c f5 ff ff       	call   800ed1 <sys_page_map>
  801935:	89 c3                	mov    %eax,%ebx
  801937:	83 c4 20             	add    $0x20,%esp
  80193a:	85 c0                	test   %eax,%eax
  80193c:	79 a3                	jns    8018e1 <dup+0x74>
	sys_page_unmap(0, newfd);
  80193e:	83 ec 08             	sub    $0x8,%esp
  801941:	56                   	push   %esi
  801942:	6a 00                	push   $0x0
  801944:	e8 ca f5 ff ff       	call   800f13 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801949:	83 c4 08             	add    $0x8,%esp
  80194c:	57                   	push   %edi
  80194d:	6a 00                	push   $0x0
  80194f:	e8 bf f5 ff ff       	call   800f13 <sys_page_unmap>
	return r;
  801954:	83 c4 10             	add    $0x10,%esp
  801957:	eb b7                	jmp    801910 <dup+0xa3>

00801959 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	53                   	push   %ebx
  80195d:	83 ec 1c             	sub    $0x1c,%esp
  801960:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801963:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801966:	50                   	push   %eax
  801967:	53                   	push   %ebx
  801968:	e8 7c fd ff ff       	call   8016e9 <fd_lookup>
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	85 c0                	test   %eax,%eax
  801972:	78 3f                	js     8019b3 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80197a:	50                   	push   %eax
  80197b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197e:	ff 30                	pushl  (%eax)
  801980:	e8 b4 fd ff ff       	call   801739 <dev_lookup>
  801985:	83 c4 10             	add    $0x10,%esp
  801988:	85 c0                	test   %eax,%eax
  80198a:	78 27                	js     8019b3 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80198c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80198f:	8b 42 08             	mov    0x8(%edx),%eax
  801992:	83 e0 03             	and    $0x3,%eax
  801995:	83 f8 01             	cmp    $0x1,%eax
  801998:	74 1e                	je     8019b8 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80199a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199d:	8b 40 08             	mov    0x8(%eax),%eax
  8019a0:	85 c0                	test   %eax,%eax
  8019a2:	74 35                	je     8019d9 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019a4:	83 ec 04             	sub    $0x4,%esp
  8019a7:	ff 75 10             	pushl  0x10(%ebp)
  8019aa:	ff 75 0c             	pushl  0xc(%ebp)
  8019ad:	52                   	push   %edx
  8019ae:	ff d0                	call   *%eax
  8019b0:	83 c4 10             	add    $0x10,%esp
}
  8019b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019b8:	a1 20 54 80 00       	mov    0x805420,%eax
  8019bd:	8b 40 48             	mov    0x48(%eax),%eax
  8019c0:	83 ec 04             	sub    $0x4,%esp
  8019c3:	53                   	push   %ebx
  8019c4:	50                   	push   %eax
  8019c5:	68 a5 32 80 00       	push   $0x8032a5
  8019ca:	e8 6e e9 ff ff       	call   80033d <cprintf>
		return -E_INVAL;
  8019cf:	83 c4 10             	add    $0x10,%esp
  8019d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019d7:	eb da                	jmp    8019b3 <read+0x5a>
		return -E_NOT_SUPP;
  8019d9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019de:	eb d3                	jmp    8019b3 <read+0x5a>

008019e0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	57                   	push   %edi
  8019e4:	56                   	push   %esi
  8019e5:	53                   	push   %ebx
  8019e6:	83 ec 0c             	sub    $0xc,%esp
  8019e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019ec:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019f4:	39 f3                	cmp    %esi,%ebx
  8019f6:	73 23                	jae    801a1b <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019f8:	83 ec 04             	sub    $0x4,%esp
  8019fb:	89 f0                	mov    %esi,%eax
  8019fd:	29 d8                	sub    %ebx,%eax
  8019ff:	50                   	push   %eax
  801a00:	89 d8                	mov    %ebx,%eax
  801a02:	03 45 0c             	add    0xc(%ebp),%eax
  801a05:	50                   	push   %eax
  801a06:	57                   	push   %edi
  801a07:	e8 4d ff ff ff       	call   801959 <read>
		if (m < 0)
  801a0c:	83 c4 10             	add    $0x10,%esp
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	78 06                	js     801a19 <readn+0x39>
			return m;
		if (m == 0)
  801a13:	74 06                	je     801a1b <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a15:	01 c3                	add    %eax,%ebx
  801a17:	eb db                	jmp    8019f4 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a19:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a1b:	89 d8                	mov    %ebx,%eax
  801a1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a20:	5b                   	pop    %ebx
  801a21:	5e                   	pop    %esi
  801a22:	5f                   	pop    %edi
  801a23:	5d                   	pop    %ebp
  801a24:	c3                   	ret    

00801a25 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	53                   	push   %ebx
  801a29:	83 ec 1c             	sub    $0x1c,%esp
  801a2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a2f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a32:	50                   	push   %eax
  801a33:	53                   	push   %ebx
  801a34:	e8 b0 fc ff ff       	call   8016e9 <fd_lookup>
  801a39:	83 c4 10             	add    $0x10,%esp
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	78 3a                	js     801a7a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a40:	83 ec 08             	sub    $0x8,%esp
  801a43:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a46:	50                   	push   %eax
  801a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4a:	ff 30                	pushl  (%eax)
  801a4c:	e8 e8 fc ff ff       	call   801739 <dev_lookup>
  801a51:	83 c4 10             	add    $0x10,%esp
  801a54:	85 c0                	test   %eax,%eax
  801a56:	78 22                	js     801a7a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a5b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a5f:	74 1e                	je     801a7f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a64:	8b 52 0c             	mov    0xc(%edx),%edx
  801a67:	85 d2                	test   %edx,%edx
  801a69:	74 35                	je     801aa0 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a6b:	83 ec 04             	sub    $0x4,%esp
  801a6e:	ff 75 10             	pushl  0x10(%ebp)
  801a71:	ff 75 0c             	pushl  0xc(%ebp)
  801a74:	50                   	push   %eax
  801a75:	ff d2                	call   *%edx
  801a77:	83 c4 10             	add    $0x10,%esp
}
  801a7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a7f:	a1 20 54 80 00       	mov    0x805420,%eax
  801a84:	8b 40 48             	mov    0x48(%eax),%eax
  801a87:	83 ec 04             	sub    $0x4,%esp
  801a8a:	53                   	push   %ebx
  801a8b:	50                   	push   %eax
  801a8c:	68 c1 32 80 00       	push   $0x8032c1
  801a91:	e8 a7 e8 ff ff       	call   80033d <cprintf>
		return -E_INVAL;
  801a96:	83 c4 10             	add    $0x10,%esp
  801a99:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a9e:	eb da                	jmp    801a7a <write+0x55>
		return -E_NOT_SUPP;
  801aa0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801aa5:	eb d3                	jmp    801a7a <write+0x55>

00801aa7 <seek>:

int
seek(int fdnum, off_t offset)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab0:	50                   	push   %eax
  801ab1:	ff 75 08             	pushl  0x8(%ebp)
  801ab4:	e8 30 fc ff ff       	call   8016e9 <fd_lookup>
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	85 c0                	test   %eax,%eax
  801abe:	78 0e                	js     801ace <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ac9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	53                   	push   %ebx
  801ad4:	83 ec 1c             	sub    $0x1c,%esp
  801ad7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ada:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801add:	50                   	push   %eax
  801ade:	53                   	push   %ebx
  801adf:	e8 05 fc ff ff       	call   8016e9 <fd_lookup>
  801ae4:	83 c4 10             	add    $0x10,%esp
  801ae7:	85 c0                	test   %eax,%eax
  801ae9:	78 37                	js     801b22 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aeb:	83 ec 08             	sub    $0x8,%esp
  801aee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af1:	50                   	push   %eax
  801af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af5:	ff 30                	pushl  (%eax)
  801af7:	e8 3d fc ff ff       	call   801739 <dev_lookup>
  801afc:	83 c4 10             	add    $0x10,%esp
  801aff:	85 c0                	test   %eax,%eax
  801b01:	78 1f                	js     801b22 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b06:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b0a:	74 1b                	je     801b27 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b0f:	8b 52 18             	mov    0x18(%edx),%edx
  801b12:	85 d2                	test   %edx,%edx
  801b14:	74 32                	je     801b48 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b16:	83 ec 08             	sub    $0x8,%esp
  801b19:	ff 75 0c             	pushl  0xc(%ebp)
  801b1c:	50                   	push   %eax
  801b1d:	ff d2                	call   *%edx
  801b1f:	83 c4 10             	add    $0x10,%esp
}
  801b22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b27:	a1 20 54 80 00       	mov    0x805420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b2c:	8b 40 48             	mov    0x48(%eax),%eax
  801b2f:	83 ec 04             	sub    $0x4,%esp
  801b32:	53                   	push   %ebx
  801b33:	50                   	push   %eax
  801b34:	68 84 32 80 00       	push   $0x803284
  801b39:	e8 ff e7 ff ff       	call   80033d <cprintf>
		return -E_INVAL;
  801b3e:	83 c4 10             	add    $0x10,%esp
  801b41:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b46:	eb da                	jmp    801b22 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b48:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b4d:	eb d3                	jmp    801b22 <ftruncate+0x52>

00801b4f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	53                   	push   %ebx
  801b53:	83 ec 1c             	sub    $0x1c,%esp
  801b56:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b59:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b5c:	50                   	push   %eax
  801b5d:	ff 75 08             	pushl  0x8(%ebp)
  801b60:	e8 84 fb ff ff       	call   8016e9 <fd_lookup>
  801b65:	83 c4 10             	add    $0x10,%esp
  801b68:	85 c0                	test   %eax,%eax
  801b6a:	78 4b                	js     801bb7 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b6c:	83 ec 08             	sub    $0x8,%esp
  801b6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b72:	50                   	push   %eax
  801b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b76:	ff 30                	pushl  (%eax)
  801b78:	e8 bc fb ff ff       	call   801739 <dev_lookup>
  801b7d:	83 c4 10             	add    $0x10,%esp
  801b80:	85 c0                	test   %eax,%eax
  801b82:	78 33                	js     801bb7 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b87:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b8b:	74 2f                	je     801bbc <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b8d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b90:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b97:	00 00 00 
	stat->st_isdir = 0;
  801b9a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ba1:	00 00 00 
	stat->st_dev = dev;
  801ba4:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801baa:	83 ec 08             	sub    $0x8,%esp
  801bad:	53                   	push   %ebx
  801bae:	ff 75 f0             	pushl  -0x10(%ebp)
  801bb1:	ff 50 14             	call   *0x14(%eax)
  801bb4:	83 c4 10             	add    $0x10,%esp
}
  801bb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    
		return -E_NOT_SUPP;
  801bbc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bc1:	eb f4                	jmp    801bb7 <fstat+0x68>

00801bc3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	56                   	push   %esi
  801bc7:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bc8:	83 ec 08             	sub    $0x8,%esp
  801bcb:	6a 00                	push   $0x0
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	e8 22 02 00 00       	call   801df7 <open>
  801bd5:	89 c3                	mov    %eax,%ebx
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	85 c0                	test   %eax,%eax
  801bdc:	78 1b                	js     801bf9 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801bde:	83 ec 08             	sub    $0x8,%esp
  801be1:	ff 75 0c             	pushl  0xc(%ebp)
  801be4:	50                   	push   %eax
  801be5:	e8 65 ff ff ff       	call   801b4f <fstat>
  801bea:	89 c6                	mov    %eax,%esi
	close(fd);
  801bec:	89 1c 24             	mov    %ebx,(%esp)
  801bef:	e8 27 fc ff ff       	call   80181b <close>
	return r;
  801bf4:	83 c4 10             	add    $0x10,%esp
  801bf7:	89 f3                	mov    %esi,%ebx
}
  801bf9:	89 d8                	mov    %ebx,%eax
  801bfb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bfe:	5b                   	pop    %ebx
  801bff:	5e                   	pop    %esi
  801c00:	5d                   	pop    %ebp
  801c01:	c3                   	ret    

00801c02 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	56                   	push   %esi
  801c06:	53                   	push   %ebx
  801c07:	89 c6                	mov    %eax,%esi
  801c09:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c0b:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c12:	74 27                	je     801c3b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c14:	6a 07                	push   $0x7
  801c16:	68 00 60 80 00       	push   $0x806000
  801c1b:	56                   	push   %esi
  801c1c:	ff 35 00 50 80 00    	pushl  0x805000
  801c22:	e8 ef 0c 00 00       	call   802916 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c27:	83 c4 0c             	add    $0xc,%esp
  801c2a:	6a 00                	push   $0x0
  801c2c:	53                   	push   %ebx
  801c2d:	6a 00                	push   $0x0
  801c2f:	e8 79 0c 00 00       	call   8028ad <ipc_recv>
}
  801c34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c37:	5b                   	pop    %ebx
  801c38:	5e                   	pop    %esi
  801c39:	5d                   	pop    %ebp
  801c3a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c3b:	83 ec 0c             	sub    $0xc,%esp
  801c3e:	6a 01                	push   $0x1
  801c40:	e8 29 0d 00 00       	call   80296e <ipc_find_env>
  801c45:	a3 00 50 80 00       	mov    %eax,0x805000
  801c4a:	83 c4 10             	add    $0x10,%esp
  801c4d:	eb c5                	jmp    801c14 <fsipc+0x12>

00801c4f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	8b 40 0c             	mov    0xc(%eax),%eax
  801c5b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c63:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c68:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6d:	b8 02 00 00 00       	mov    $0x2,%eax
  801c72:	e8 8b ff ff ff       	call   801c02 <fsipc>
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <devfile_flush>:
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	8b 40 0c             	mov    0xc(%eax),%eax
  801c85:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8f:	b8 06 00 00 00       	mov    $0x6,%eax
  801c94:	e8 69 ff ff ff       	call   801c02 <fsipc>
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <devfile_stat>:
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	53                   	push   %ebx
  801c9f:	83 ec 04             	sub    $0x4,%esp
  801ca2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	8b 40 0c             	mov    0xc(%eax),%eax
  801cab:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cb0:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb5:	b8 05 00 00 00       	mov    $0x5,%eax
  801cba:	e8 43 ff ff ff       	call   801c02 <fsipc>
  801cbf:	85 c0                	test   %eax,%eax
  801cc1:	78 2c                	js     801cef <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cc3:	83 ec 08             	sub    $0x8,%esp
  801cc6:	68 00 60 80 00       	push   $0x806000
  801ccb:	53                   	push   %ebx
  801ccc:	e8 cb ed ff ff       	call   800a9c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cd1:	a1 80 60 80 00       	mov    0x806080,%eax
  801cd6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cdc:	a1 84 60 80 00       	mov    0x806084,%eax
  801ce1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ce7:	83 c4 10             	add    $0x10,%esp
  801cea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <devfile_write>:
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
  801cf7:	53                   	push   %ebx
  801cf8:	83 ec 08             	sub    $0x8,%esp
  801cfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	8b 40 0c             	mov    0xc(%eax),%eax
  801d04:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d09:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d0f:	53                   	push   %ebx
  801d10:	ff 75 0c             	pushl  0xc(%ebp)
  801d13:	68 08 60 80 00       	push   $0x806008
  801d18:	e8 6f ef ff ff       	call   800c8c <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d22:	b8 04 00 00 00       	mov    $0x4,%eax
  801d27:	e8 d6 fe ff ff       	call   801c02 <fsipc>
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	85 c0                	test   %eax,%eax
  801d31:	78 0b                	js     801d3e <devfile_write+0x4a>
	assert(r <= n);
  801d33:	39 d8                	cmp    %ebx,%eax
  801d35:	77 0c                	ja     801d43 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d37:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d3c:	7f 1e                	jg     801d5c <devfile_write+0x68>
}
  801d3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    
	assert(r <= n);
  801d43:	68 f4 32 80 00       	push   $0x8032f4
  801d48:	68 fb 32 80 00       	push   $0x8032fb
  801d4d:	68 98 00 00 00       	push   $0x98
  801d52:	68 10 33 80 00       	push   $0x803310
  801d57:	e8 eb e4 ff ff       	call   800247 <_panic>
	assert(r <= PGSIZE);
  801d5c:	68 1b 33 80 00       	push   $0x80331b
  801d61:	68 fb 32 80 00       	push   $0x8032fb
  801d66:	68 99 00 00 00       	push   $0x99
  801d6b:	68 10 33 80 00       	push   $0x803310
  801d70:	e8 d2 e4 ff ff       	call   800247 <_panic>

00801d75 <devfile_read>:
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	56                   	push   %esi
  801d79:	53                   	push   %ebx
  801d7a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d80:	8b 40 0c             	mov    0xc(%eax),%eax
  801d83:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d88:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d93:	b8 03 00 00 00       	mov    $0x3,%eax
  801d98:	e8 65 fe ff ff       	call   801c02 <fsipc>
  801d9d:	89 c3                	mov    %eax,%ebx
  801d9f:	85 c0                	test   %eax,%eax
  801da1:	78 1f                	js     801dc2 <devfile_read+0x4d>
	assert(r <= n);
  801da3:	39 f0                	cmp    %esi,%eax
  801da5:	77 24                	ja     801dcb <devfile_read+0x56>
	assert(r <= PGSIZE);
  801da7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dac:	7f 33                	jg     801de1 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801dae:	83 ec 04             	sub    $0x4,%esp
  801db1:	50                   	push   %eax
  801db2:	68 00 60 80 00       	push   $0x806000
  801db7:	ff 75 0c             	pushl  0xc(%ebp)
  801dba:	e8 6b ee ff ff       	call   800c2a <memmove>
	return r;
  801dbf:	83 c4 10             	add    $0x10,%esp
}
  801dc2:	89 d8                	mov    %ebx,%eax
  801dc4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5d                   	pop    %ebp
  801dca:	c3                   	ret    
	assert(r <= n);
  801dcb:	68 f4 32 80 00       	push   $0x8032f4
  801dd0:	68 fb 32 80 00       	push   $0x8032fb
  801dd5:	6a 7c                	push   $0x7c
  801dd7:	68 10 33 80 00       	push   $0x803310
  801ddc:	e8 66 e4 ff ff       	call   800247 <_panic>
	assert(r <= PGSIZE);
  801de1:	68 1b 33 80 00       	push   $0x80331b
  801de6:	68 fb 32 80 00       	push   $0x8032fb
  801deb:	6a 7d                	push   $0x7d
  801ded:	68 10 33 80 00       	push   $0x803310
  801df2:	e8 50 e4 ff ff       	call   800247 <_panic>

00801df7 <open>:
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	56                   	push   %esi
  801dfb:	53                   	push   %ebx
  801dfc:	83 ec 1c             	sub    $0x1c,%esp
  801dff:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e02:	56                   	push   %esi
  801e03:	e8 5b ec ff ff       	call   800a63 <strlen>
  801e08:	83 c4 10             	add    $0x10,%esp
  801e0b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e10:	7f 6c                	jg     801e7e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e12:	83 ec 0c             	sub    $0xc,%esp
  801e15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e18:	50                   	push   %eax
  801e19:	e8 79 f8 ff ff       	call   801697 <fd_alloc>
  801e1e:	89 c3                	mov    %eax,%ebx
  801e20:	83 c4 10             	add    $0x10,%esp
  801e23:	85 c0                	test   %eax,%eax
  801e25:	78 3c                	js     801e63 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e27:	83 ec 08             	sub    $0x8,%esp
  801e2a:	56                   	push   %esi
  801e2b:	68 00 60 80 00       	push   $0x806000
  801e30:	e8 67 ec ff ff       	call   800a9c <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e38:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e40:	b8 01 00 00 00       	mov    $0x1,%eax
  801e45:	e8 b8 fd ff ff       	call   801c02 <fsipc>
  801e4a:	89 c3                	mov    %eax,%ebx
  801e4c:	83 c4 10             	add    $0x10,%esp
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	78 19                	js     801e6c <open+0x75>
	return fd2num(fd);
  801e53:	83 ec 0c             	sub    $0xc,%esp
  801e56:	ff 75 f4             	pushl  -0xc(%ebp)
  801e59:	e8 12 f8 ff ff       	call   801670 <fd2num>
  801e5e:	89 c3                	mov    %eax,%ebx
  801e60:	83 c4 10             	add    $0x10,%esp
}
  801e63:	89 d8                	mov    %ebx,%eax
  801e65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e68:	5b                   	pop    %ebx
  801e69:	5e                   	pop    %esi
  801e6a:	5d                   	pop    %ebp
  801e6b:	c3                   	ret    
		fd_close(fd, 0);
  801e6c:	83 ec 08             	sub    $0x8,%esp
  801e6f:	6a 00                	push   $0x0
  801e71:	ff 75 f4             	pushl  -0xc(%ebp)
  801e74:	e8 1b f9 ff ff       	call   801794 <fd_close>
		return r;
  801e79:	83 c4 10             	add    $0x10,%esp
  801e7c:	eb e5                	jmp    801e63 <open+0x6c>
		return -E_BAD_PATH;
  801e7e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e83:	eb de                	jmp    801e63 <open+0x6c>

00801e85 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e90:	b8 08 00 00 00       	mov    $0x8,%eax
  801e95:	e8 68 fd ff ff       	call   801c02 <fsipc>
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ea2:	68 27 33 80 00       	push   $0x803327
  801ea7:	ff 75 0c             	pushl  0xc(%ebp)
  801eaa:	e8 ed eb ff ff       	call   800a9c <strcpy>
	return 0;
}
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <devsock_close>:
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	53                   	push   %ebx
  801eba:	83 ec 10             	sub    $0x10,%esp
  801ebd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ec0:	53                   	push   %ebx
  801ec1:	e8 e7 0a 00 00       	call   8029ad <pageref>
  801ec6:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ec9:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ece:	83 f8 01             	cmp    $0x1,%eax
  801ed1:	74 07                	je     801eda <devsock_close+0x24>
}
  801ed3:	89 d0                	mov    %edx,%eax
  801ed5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801eda:	83 ec 0c             	sub    $0xc,%esp
  801edd:	ff 73 0c             	pushl  0xc(%ebx)
  801ee0:	e8 b9 02 00 00       	call   80219e <nsipc_close>
  801ee5:	89 c2                	mov    %eax,%edx
  801ee7:	83 c4 10             	add    $0x10,%esp
  801eea:	eb e7                	jmp    801ed3 <devsock_close+0x1d>

00801eec <devsock_write>:
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ef2:	6a 00                	push   $0x0
  801ef4:	ff 75 10             	pushl  0x10(%ebp)
  801ef7:	ff 75 0c             	pushl  0xc(%ebp)
  801efa:	8b 45 08             	mov    0x8(%ebp),%eax
  801efd:	ff 70 0c             	pushl  0xc(%eax)
  801f00:	e8 76 03 00 00       	call   80227b <nsipc_send>
}
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <devsock_read>:
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f0d:	6a 00                	push   $0x0
  801f0f:	ff 75 10             	pushl  0x10(%ebp)
  801f12:	ff 75 0c             	pushl  0xc(%ebp)
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	ff 70 0c             	pushl  0xc(%eax)
  801f1b:	e8 ef 02 00 00       	call   80220f <nsipc_recv>
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <fd2sockid>:
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f28:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f2b:	52                   	push   %edx
  801f2c:	50                   	push   %eax
  801f2d:	e8 b7 f7 ff ff       	call   8016e9 <fd_lookup>
  801f32:	83 c4 10             	add    $0x10,%esp
  801f35:	85 c0                	test   %eax,%eax
  801f37:	78 10                	js     801f49 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3c:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f42:	39 08                	cmp    %ecx,(%eax)
  801f44:	75 05                	jne    801f4b <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f46:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    
		return -E_NOT_SUPP;
  801f4b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f50:	eb f7                	jmp    801f49 <fd2sockid+0x27>

00801f52 <alloc_sockfd>:
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	56                   	push   %esi
  801f56:	53                   	push   %ebx
  801f57:	83 ec 1c             	sub    $0x1c,%esp
  801f5a:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f5f:	50                   	push   %eax
  801f60:	e8 32 f7 ff ff       	call   801697 <fd_alloc>
  801f65:	89 c3                	mov    %eax,%ebx
  801f67:	83 c4 10             	add    $0x10,%esp
  801f6a:	85 c0                	test   %eax,%eax
  801f6c:	78 43                	js     801fb1 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f6e:	83 ec 04             	sub    $0x4,%esp
  801f71:	68 07 04 00 00       	push   $0x407
  801f76:	ff 75 f4             	pushl  -0xc(%ebp)
  801f79:	6a 00                	push   $0x0
  801f7b:	e8 0e ef ff ff       	call   800e8e <sys_page_alloc>
  801f80:	89 c3                	mov    %eax,%ebx
  801f82:	83 c4 10             	add    $0x10,%esp
  801f85:	85 c0                	test   %eax,%eax
  801f87:	78 28                	js     801fb1 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8c:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f92:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f97:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f9e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fa1:	83 ec 0c             	sub    $0xc,%esp
  801fa4:	50                   	push   %eax
  801fa5:	e8 c6 f6 ff ff       	call   801670 <fd2num>
  801faa:	89 c3                	mov    %eax,%ebx
  801fac:	83 c4 10             	add    $0x10,%esp
  801faf:	eb 0c                	jmp    801fbd <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fb1:	83 ec 0c             	sub    $0xc,%esp
  801fb4:	56                   	push   %esi
  801fb5:	e8 e4 01 00 00       	call   80219e <nsipc_close>
		return r;
  801fba:	83 c4 10             	add    $0x10,%esp
}
  801fbd:	89 d8                	mov    %ebx,%eax
  801fbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc2:	5b                   	pop    %ebx
  801fc3:	5e                   	pop    %esi
  801fc4:	5d                   	pop    %ebp
  801fc5:	c3                   	ret    

00801fc6 <accept>:
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	e8 4e ff ff ff       	call   801f22 <fd2sockid>
  801fd4:	85 c0                	test   %eax,%eax
  801fd6:	78 1b                	js     801ff3 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fd8:	83 ec 04             	sub    $0x4,%esp
  801fdb:	ff 75 10             	pushl  0x10(%ebp)
  801fde:	ff 75 0c             	pushl  0xc(%ebp)
  801fe1:	50                   	push   %eax
  801fe2:	e8 0e 01 00 00       	call   8020f5 <nsipc_accept>
  801fe7:	83 c4 10             	add    $0x10,%esp
  801fea:	85 c0                	test   %eax,%eax
  801fec:	78 05                	js     801ff3 <accept+0x2d>
	return alloc_sockfd(r);
  801fee:	e8 5f ff ff ff       	call   801f52 <alloc_sockfd>
}
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <bind>:
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	e8 1f ff ff ff       	call   801f22 <fd2sockid>
  802003:	85 c0                	test   %eax,%eax
  802005:	78 12                	js     802019 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802007:	83 ec 04             	sub    $0x4,%esp
  80200a:	ff 75 10             	pushl  0x10(%ebp)
  80200d:	ff 75 0c             	pushl  0xc(%ebp)
  802010:	50                   	push   %eax
  802011:	e8 31 01 00 00       	call   802147 <nsipc_bind>
  802016:	83 c4 10             	add    $0x10,%esp
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <shutdown>:
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	e8 f9 fe ff ff       	call   801f22 <fd2sockid>
  802029:	85 c0                	test   %eax,%eax
  80202b:	78 0f                	js     80203c <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80202d:	83 ec 08             	sub    $0x8,%esp
  802030:	ff 75 0c             	pushl  0xc(%ebp)
  802033:	50                   	push   %eax
  802034:	e8 43 01 00 00       	call   80217c <nsipc_shutdown>
  802039:	83 c4 10             	add    $0x10,%esp
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <connect>:
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	e8 d6 fe ff ff       	call   801f22 <fd2sockid>
  80204c:	85 c0                	test   %eax,%eax
  80204e:	78 12                	js     802062 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802050:	83 ec 04             	sub    $0x4,%esp
  802053:	ff 75 10             	pushl  0x10(%ebp)
  802056:	ff 75 0c             	pushl  0xc(%ebp)
  802059:	50                   	push   %eax
  80205a:	e8 59 01 00 00       	call   8021b8 <nsipc_connect>
  80205f:	83 c4 10             	add    $0x10,%esp
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <listen>:
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	e8 b0 fe ff ff       	call   801f22 <fd2sockid>
  802072:	85 c0                	test   %eax,%eax
  802074:	78 0f                	js     802085 <listen+0x21>
	return nsipc_listen(r, backlog);
  802076:	83 ec 08             	sub    $0x8,%esp
  802079:	ff 75 0c             	pushl  0xc(%ebp)
  80207c:	50                   	push   %eax
  80207d:	e8 6b 01 00 00       	call   8021ed <nsipc_listen>
  802082:	83 c4 10             	add    $0x10,%esp
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <socket>:

int
socket(int domain, int type, int protocol)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80208d:	ff 75 10             	pushl  0x10(%ebp)
  802090:	ff 75 0c             	pushl  0xc(%ebp)
  802093:	ff 75 08             	pushl  0x8(%ebp)
  802096:	e8 3e 02 00 00       	call   8022d9 <nsipc_socket>
  80209b:	83 c4 10             	add    $0x10,%esp
  80209e:	85 c0                	test   %eax,%eax
  8020a0:	78 05                	js     8020a7 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020a2:	e8 ab fe ff ff       	call   801f52 <alloc_sockfd>
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	53                   	push   %ebx
  8020ad:	83 ec 04             	sub    $0x4,%esp
  8020b0:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020b2:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020b9:	74 26                	je     8020e1 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020bb:	6a 07                	push   $0x7
  8020bd:	68 00 70 80 00       	push   $0x807000
  8020c2:	53                   	push   %ebx
  8020c3:	ff 35 04 50 80 00    	pushl  0x805004
  8020c9:	e8 48 08 00 00       	call   802916 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020ce:	83 c4 0c             	add    $0xc,%esp
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	e8 d1 07 00 00       	call   8028ad <ipc_recv>
}
  8020dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020df:	c9                   	leave  
  8020e0:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020e1:	83 ec 0c             	sub    $0xc,%esp
  8020e4:	6a 02                	push   $0x2
  8020e6:	e8 83 08 00 00       	call   80296e <ipc_find_env>
  8020eb:	a3 04 50 80 00       	mov    %eax,0x805004
  8020f0:	83 c4 10             	add    $0x10,%esp
  8020f3:	eb c6                	jmp    8020bb <nsipc+0x12>

008020f5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	56                   	push   %esi
  8020f9:	53                   	push   %ebx
  8020fa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802105:	8b 06                	mov    (%esi),%eax
  802107:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80210c:	b8 01 00 00 00       	mov    $0x1,%eax
  802111:	e8 93 ff ff ff       	call   8020a9 <nsipc>
  802116:	89 c3                	mov    %eax,%ebx
  802118:	85 c0                	test   %eax,%eax
  80211a:	79 09                	jns    802125 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80211c:	89 d8                	mov    %ebx,%eax
  80211e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802121:	5b                   	pop    %ebx
  802122:	5e                   	pop    %esi
  802123:	5d                   	pop    %ebp
  802124:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802125:	83 ec 04             	sub    $0x4,%esp
  802128:	ff 35 10 70 80 00    	pushl  0x807010
  80212e:	68 00 70 80 00       	push   $0x807000
  802133:	ff 75 0c             	pushl  0xc(%ebp)
  802136:	e8 ef ea ff ff       	call   800c2a <memmove>
		*addrlen = ret->ret_addrlen;
  80213b:	a1 10 70 80 00       	mov    0x807010,%eax
  802140:	89 06                	mov    %eax,(%esi)
  802142:	83 c4 10             	add    $0x10,%esp
	return r;
  802145:	eb d5                	jmp    80211c <nsipc_accept+0x27>

00802147 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	53                   	push   %ebx
  80214b:	83 ec 08             	sub    $0x8,%esp
  80214e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802159:	53                   	push   %ebx
  80215a:	ff 75 0c             	pushl  0xc(%ebp)
  80215d:	68 04 70 80 00       	push   $0x807004
  802162:	e8 c3 ea ff ff       	call   800c2a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802167:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80216d:	b8 02 00 00 00       	mov    $0x2,%eax
  802172:	e8 32 ff ff ff       	call   8020a9 <nsipc>
}
  802177:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80218a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218d:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802192:	b8 03 00 00 00       	mov    $0x3,%eax
  802197:	e8 0d ff ff ff       	call   8020a9 <nsipc>
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <nsipc_close>:

int
nsipc_close(int s)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021ac:	b8 04 00 00 00       	mov    $0x4,%eax
  8021b1:	e8 f3 fe ff ff       	call   8020a9 <nsipc>
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	53                   	push   %ebx
  8021bc:	83 ec 08             	sub    $0x8,%esp
  8021bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021ca:	53                   	push   %ebx
  8021cb:	ff 75 0c             	pushl  0xc(%ebp)
  8021ce:	68 04 70 80 00       	push   $0x807004
  8021d3:	e8 52 ea ff ff       	call   800c2a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021d8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021de:	b8 05 00 00 00       	mov    $0x5,%eax
  8021e3:	e8 c1 fe ff ff       	call   8020a9 <nsipc>
}
  8021e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fe:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802203:	b8 06 00 00 00       	mov    $0x6,%eax
  802208:	e8 9c fe ff ff       	call   8020a9 <nsipc>
}
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
  802212:	56                   	push   %esi
  802213:	53                   	push   %ebx
  802214:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80221f:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802225:	8b 45 14             	mov    0x14(%ebp),%eax
  802228:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80222d:	b8 07 00 00 00       	mov    $0x7,%eax
  802232:	e8 72 fe ff ff       	call   8020a9 <nsipc>
  802237:	89 c3                	mov    %eax,%ebx
  802239:	85 c0                	test   %eax,%eax
  80223b:	78 1f                	js     80225c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80223d:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802242:	7f 21                	jg     802265 <nsipc_recv+0x56>
  802244:	39 c6                	cmp    %eax,%esi
  802246:	7c 1d                	jl     802265 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802248:	83 ec 04             	sub    $0x4,%esp
  80224b:	50                   	push   %eax
  80224c:	68 00 70 80 00       	push   $0x807000
  802251:	ff 75 0c             	pushl  0xc(%ebp)
  802254:	e8 d1 e9 ff ff       	call   800c2a <memmove>
  802259:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80225c:	89 d8                	mov    %ebx,%eax
  80225e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802261:	5b                   	pop    %ebx
  802262:	5e                   	pop    %esi
  802263:	5d                   	pop    %ebp
  802264:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802265:	68 33 33 80 00       	push   $0x803333
  80226a:	68 fb 32 80 00       	push   $0x8032fb
  80226f:	6a 62                	push   $0x62
  802271:	68 48 33 80 00       	push   $0x803348
  802276:	e8 cc df ff ff       	call   800247 <_panic>

0080227b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	53                   	push   %ebx
  80227f:	83 ec 04             	sub    $0x4,%esp
  802282:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80228d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802293:	7f 2e                	jg     8022c3 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802295:	83 ec 04             	sub    $0x4,%esp
  802298:	53                   	push   %ebx
  802299:	ff 75 0c             	pushl  0xc(%ebp)
  80229c:	68 0c 70 80 00       	push   $0x80700c
  8022a1:	e8 84 e9 ff ff       	call   800c2a <memmove>
	nsipcbuf.send.req_size = size;
  8022a6:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8022af:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022b4:	b8 08 00 00 00       	mov    $0x8,%eax
  8022b9:	e8 eb fd ff ff       	call   8020a9 <nsipc>
}
  8022be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    
	assert(size < 1600);
  8022c3:	68 54 33 80 00       	push   $0x803354
  8022c8:	68 fb 32 80 00       	push   $0x8032fb
  8022cd:	6a 6d                	push   $0x6d
  8022cf:	68 48 33 80 00       	push   $0x803348
  8022d4:	e8 6e df ff ff       	call   800247 <_panic>

008022d9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ea:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8022ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f2:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022f7:	b8 09 00 00 00       	mov    $0x9,%eax
  8022fc:	e8 a8 fd ff ff       	call   8020a9 <nsipc>
}
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
  802306:	56                   	push   %esi
  802307:	53                   	push   %ebx
  802308:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80230b:	83 ec 0c             	sub    $0xc,%esp
  80230e:	ff 75 08             	pushl  0x8(%ebp)
  802311:	e8 6a f3 ff ff       	call   801680 <fd2data>
  802316:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802318:	83 c4 08             	add    $0x8,%esp
  80231b:	68 60 33 80 00       	push   $0x803360
  802320:	53                   	push   %ebx
  802321:	e8 76 e7 ff ff       	call   800a9c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802326:	8b 46 04             	mov    0x4(%esi),%eax
  802329:	2b 06                	sub    (%esi),%eax
  80232b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802331:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802338:	00 00 00 
	stat->st_dev = &devpipe;
  80233b:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802342:	40 80 00 
	return 0;
}
  802345:	b8 00 00 00 00       	mov    $0x0,%eax
  80234a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80234d:	5b                   	pop    %ebx
  80234e:	5e                   	pop    %esi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    

00802351 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	53                   	push   %ebx
  802355:	83 ec 0c             	sub    $0xc,%esp
  802358:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80235b:	53                   	push   %ebx
  80235c:	6a 00                	push   $0x0
  80235e:	e8 b0 eb ff ff       	call   800f13 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802363:	89 1c 24             	mov    %ebx,(%esp)
  802366:	e8 15 f3 ff ff       	call   801680 <fd2data>
  80236b:	83 c4 08             	add    $0x8,%esp
  80236e:	50                   	push   %eax
  80236f:	6a 00                	push   $0x0
  802371:	e8 9d eb ff ff       	call   800f13 <sys_page_unmap>
}
  802376:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <_pipeisclosed>:
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
  80237e:	57                   	push   %edi
  80237f:	56                   	push   %esi
  802380:	53                   	push   %ebx
  802381:	83 ec 1c             	sub    $0x1c,%esp
  802384:	89 c7                	mov    %eax,%edi
  802386:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802388:	a1 20 54 80 00       	mov    0x805420,%eax
  80238d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802390:	83 ec 0c             	sub    $0xc,%esp
  802393:	57                   	push   %edi
  802394:	e8 14 06 00 00       	call   8029ad <pageref>
  802399:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80239c:	89 34 24             	mov    %esi,(%esp)
  80239f:	e8 09 06 00 00       	call   8029ad <pageref>
		nn = thisenv->env_runs;
  8023a4:	8b 15 20 54 80 00    	mov    0x805420,%edx
  8023aa:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023ad:	83 c4 10             	add    $0x10,%esp
  8023b0:	39 cb                	cmp    %ecx,%ebx
  8023b2:	74 1b                	je     8023cf <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023b4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023b7:	75 cf                	jne    802388 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023b9:	8b 42 58             	mov    0x58(%edx),%eax
  8023bc:	6a 01                	push   $0x1
  8023be:	50                   	push   %eax
  8023bf:	53                   	push   %ebx
  8023c0:	68 67 33 80 00       	push   $0x803367
  8023c5:	e8 73 df ff ff       	call   80033d <cprintf>
  8023ca:	83 c4 10             	add    $0x10,%esp
  8023cd:	eb b9                	jmp    802388 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8023cf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023d2:	0f 94 c0             	sete   %al
  8023d5:	0f b6 c0             	movzbl %al,%eax
}
  8023d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023db:	5b                   	pop    %ebx
  8023dc:	5e                   	pop    %esi
  8023dd:	5f                   	pop    %edi
  8023de:	5d                   	pop    %ebp
  8023df:	c3                   	ret    

008023e0 <devpipe_write>:
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	57                   	push   %edi
  8023e4:	56                   	push   %esi
  8023e5:	53                   	push   %ebx
  8023e6:	83 ec 28             	sub    $0x28,%esp
  8023e9:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8023ec:	56                   	push   %esi
  8023ed:	e8 8e f2 ff ff       	call   801680 <fd2data>
  8023f2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023f4:	83 c4 10             	add    $0x10,%esp
  8023f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8023fc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023ff:	74 4f                	je     802450 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802401:	8b 43 04             	mov    0x4(%ebx),%eax
  802404:	8b 0b                	mov    (%ebx),%ecx
  802406:	8d 51 20             	lea    0x20(%ecx),%edx
  802409:	39 d0                	cmp    %edx,%eax
  80240b:	72 14                	jb     802421 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80240d:	89 da                	mov    %ebx,%edx
  80240f:	89 f0                	mov    %esi,%eax
  802411:	e8 65 ff ff ff       	call   80237b <_pipeisclosed>
  802416:	85 c0                	test   %eax,%eax
  802418:	75 3b                	jne    802455 <devpipe_write+0x75>
			sys_yield();
  80241a:	e8 50 ea ff ff       	call   800e6f <sys_yield>
  80241f:	eb e0                	jmp    802401 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802421:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802424:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802428:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80242b:	89 c2                	mov    %eax,%edx
  80242d:	c1 fa 1f             	sar    $0x1f,%edx
  802430:	89 d1                	mov    %edx,%ecx
  802432:	c1 e9 1b             	shr    $0x1b,%ecx
  802435:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802438:	83 e2 1f             	and    $0x1f,%edx
  80243b:	29 ca                	sub    %ecx,%edx
  80243d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802441:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802445:	83 c0 01             	add    $0x1,%eax
  802448:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80244b:	83 c7 01             	add    $0x1,%edi
  80244e:	eb ac                	jmp    8023fc <devpipe_write+0x1c>
	return i;
  802450:	8b 45 10             	mov    0x10(%ebp),%eax
  802453:	eb 05                	jmp    80245a <devpipe_write+0x7a>
				return 0;
  802455:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80245a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80245d:	5b                   	pop    %ebx
  80245e:	5e                   	pop    %esi
  80245f:	5f                   	pop    %edi
  802460:	5d                   	pop    %ebp
  802461:	c3                   	ret    

00802462 <devpipe_read>:
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
  802465:	57                   	push   %edi
  802466:	56                   	push   %esi
  802467:	53                   	push   %ebx
  802468:	83 ec 18             	sub    $0x18,%esp
  80246b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80246e:	57                   	push   %edi
  80246f:	e8 0c f2 ff ff       	call   801680 <fd2data>
  802474:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802476:	83 c4 10             	add    $0x10,%esp
  802479:	be 00 00 00 00       	mov    $0x0,%esi
  80247e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802481:	75 14                	jne    802497 <devpipe_read+0x35>
	return i;
  802483:	8b 45 10             	mov    0x10(%ebp),%eax
  802486:	eb 02                	jmp    80248a <devpipe_read+0x28>
				return i;
  802488:	89 f0                	mov    %esi,%eax
}
  80248a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80248d:	5b                   	pop    %ebx
  80248e:	5e                   	pop    %esi
  80248f:	5f                   	pop    %edi
  802490:	5d                   	pop    %ebp
  802491:	c3                   	ret    
			sys_yield();
  802492:	e8 d8 e9 ff ff       	call   800e6f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802497:	8b 03                	mov    (%ebx),%eax
  802499:	3b 43 04             	cmp    0x4(%ebx),%eax
  80249c:	75 18                	jne    8024b6 <devpipe_read+0x54>
			if (i > 0)
  80249e:	85 f6                	test   %esi,%esi
  8024a0:	75 e6                	jne    802488 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024a2:	89 da                	mov    %ebx,%edx
  8024a4:	89 f8                	mov    %edi,%eax
  8024a6:	e8 d0 fe ff ff       	call   80237b <_pipeisclosed>
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	74 e3                	je     802492 <devpipe_read+0x30>
				return 0;
  8024af:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b4:	eb d4                	jmp    80248a <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024b6:	99                   	cltd   
  8024b7:	c1 ea 1b             	shr    $0x1b,%edx
  8024ba:	01 d0                	add    %edx,%eax
  8024bc:	83 e0 1f             	and    $0x1f,%eax
  8024bf:	29 d0                	sub    %edx,%eax
  8024c1:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024c9:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024cc:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8024cf:	83 c6 01             	add    $0x1,%esi
  8024d2:	eb aa                	jmp    80247e <devpipe_read+0x1c>

008024d4 <pipe>:
{
  8024d4:	55                   	push   %ebp
  8024d5:	89 e5                	mov    %esp,%ebp
  8024d7:	56                   	push   %esi
  8024d8:	53                   	push   %ebx
  8024d9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8024dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024df:	50                   	push   %eax
  8024e0:	e8 b2 f1 ff ff       	call   801697 <fd_alloc>
  8024e5:	89 c3                	mov    %eax,%ebx
  8024e7:	83 c4 10             	add    $0x10,%esp
  8024ea:	85 c0                	test   %eax,%eax
  8024ec:	0f 88 23 01 00 00    	js     802615 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024f2:	83 ec 04             	sub    $0x4,%esp
  8024f5:	68 07 04 00 00       	push   $0x407
  8024fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8024fd:	6a 00                	push   $0x0
  8024ff:	e8 8a e9 ff ff       	call   800e8e <sys_page_alloc>
  802504:	89 c3                	mov    %eax,%ebx
  802506:	83 c4 10             	add    $0x10,%esp
  802509:	85 c0                	test   %eax,%eax
  80250b:	0f 88 04 01 00 00    	js     802615 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802511:	83 ec 0c             	sub    $0xc,%esp
  802514:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802517:	50                   	push   %eax
  802518:	e8 7a f1 ff ff       	call   801697 <fd_alloc>
  80251d:	89 c3                	mov    %eax,%ebx
  80251f:	83 c4 10             	add    $0x10,%esp
  802522:	85 c0                	test   %eax,%eax
  802524:	0f 88 db 00 00 00    	js     802605 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80252a:	83 ec 04             	sub    $0x4,%esp
  80252d:	68 07 04 00 00       	push   $0x407
  802532:	ff 75 f0             	pushl  -0x10(%ebp)
  802535:	6a 00                	push   $0x0
  802537:	e8 52 e9 ff ff       	call   800e8e <sys_page_alloc>
  80253c:	89 c3                	mov    %eax,%ebx
  80253e:	83 c4 10             	add    $0x10,%esp
  802541:	85 c0                	test   %eax,%eax
  802543:	0f 88 bc 00 00 00    	js     802605 <pipe+0x131>
	va = fd2data(fd0);
  802549:	83 ec 0c             	sub    $0xc,%esp
  80254c:	ff 75 f4             	pushl  -0xc(%ebp)
  80254f:	e8 2c f1 ff ff       	call   801680 <fd2data>
  802554:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802556:	83 c4 0c             	add    $0xc,%esp
  802559:	68 07 04 00 00       	push   $0x407
  80255e:	50                   	push   %eax
  80255f:	6a 00                	push   $0x0
  802561:	e8 28 e9 ff ff       	call   800e8e <sys_page_alloc>
  802566:	89 c3                	mov    %eax,%ebx
  802568:	83 c4 10             	add    $0x10,%esp
  80256b:	85 c0                	test   %eax,%eax
  80256d:	0f 88 82 00 00 00    	js     8025f5 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802573:	83 ec 0c             	sub    $0xc,%esp
  802576:	ff 75 f0             	pushl  -0x10(%ebp)
  802579:	e8 02 f1 ff ff       	call   801680 <fd2data>
  80257e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802585:	50                   	push   %eax
  802586:	6a 00                	push   $0x0
  802588:	56                   	push   %esi
  802589:	6a 00                	push   $0x0
  80258b:	e8 41 e9 ff ff       	call   800ed1 <sys_page_map>
  802590:	89 c3                	mov    %eax,%ebx
  802592:	83 c4 20             	add    $0x20,%esp
  802595:	85 c0                	test   %eax,%eax
  802597:	78 4e                	js     8025e7 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802599:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80259e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025b0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025bc:	83 ec 0c             	sub    $0xc,%esp
  8025bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c2:	e8 a9 f0 ff ff       	call   801670 <fd2num>
  8025c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025ca:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025cc:	83 c4 04             	add    $0x4,%esp
  8025cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8025d2:	e8 99 f0 ff ff       	call   801670 <fd2num>
  8025d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025da:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025dd:	83 c4 10             	add    $0x10,%esp
  8025e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025e5:	eb 2e                	jmp    802615 <pipe+0x141>
	sys_page_unmap(0, va);
  8025e7:	83 ec 08             	sub    $0x8,%esp
  8025ea:	56                   	push   %esi
  8025eb:	6a 00                	push   $0x0
  8025ed:	e8 21 e9 ff ff       	call   800f13 <sys_page_unmap>
  8025f2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8025f5:	83 ec 08             	sub    $0x8,%esp
  8025f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8025fb:	6a 00                	push   $0x0
  8025fd:	e8 11 e9 ff ff       	call   800f13 <sys_page_unmap>
  802602:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802605:	83 ec 08             	sub    $0x8,%esp
  802608:	ff 75 f4             	pushl  -0xc(%ebp)
  80260b:	6a 00                	push   $0x0
  80260d:	e8 01 e9 ff ff       	call   800f13 <sys_page_unmap>
  802612:	83 c4 10             	add    $0x10,%esp
}
  802615:	89 d8                	mov    %ebx,%eax
  802617:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80261a:	5b                   	pop    %ebx
  80261b:	5e                   	pop    %esi
  80261c:	5d                   	pop    %ebp
  80261d:	c3                   	ret    

0080261e <pipeisclosed>:
{
  80261e:	55                   	push   %ebp
  80261f:	89 e5                	mov    %esp,%ebp
  802621:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802624:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802627:	50                   	push   %eax
  802628:	ff 75 08             	pushl  0x8(%ebp)
  80262b:	e8 b9 f0 ff ff       	call   8016e9 <fd_lookup>
  802630:	83 c4 10             	add    $0x10,%esp
  802633:	85 c0                	test   %eax,%eax
  802635:	78 18                	js     80264f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802637:	83 ec 0c             	sub    $0xc,%esp
  80263a:	ff 75 f4             	pushl  -0xc(%ebp)
  80263d:	e8 3e f0 ff ff       	call   801680 <fd2data>
	return _pipeisclosed(fd, p);
  802642:	89 c2                	mov    %eax,%edx
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	e8 2f fd ff ff       	call   80237b <_pipeisclosed>
  80264c:	83 c4 10             	add    $0x10,%esp
}
  80264f:	c9                   	leave  
  802650:	c3                   	ret    

00802651 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
  802654:	56                   	push   %esi
  802655:	53                   	push   %ebx
  802656:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802659:	85 f6                	test   %esi,%esi
  80265b:	74 16                	je     802673 <wait+0x22>
	e = &envs[ENVX(envid)];
  80265d:	89 f3                	mov    %esi,%ebx
  80265f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE){
  802665:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  80266b:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802671:	eb 1b                	jmp    80268e <wait+0x3d>
	assert(envid != 0);
  802673:	68 7f 33 80 00       	push   $0x80337f
  802678:	68 fb 32 80 00       	push   $0x8032fb
  80267d:	6a 09                	push   $0x9
  80267f:	68 8a 33 80 00       	push   $0x80338a
  802684:	e8 be db ff ff       	call   800247 <_panic>
		sys_yield();
  802689:	e8 e1 e7 ff ff       	call   800e6f <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE){
  80268e:	8b 43 48             	mov    0x48(%ebx),%eax
  802691:	39 f0                	cmp    %esi,%eax
  802693:	75 07                	jne    80269c <wait+0x4b>
  802695:	8b 43 54             	mov    0x54(%ebx),%eax
  802698:	85 c0                	test   %eax,%eax
  80269a:	75 ed                	jne    802689 <wait+0x38>
	}
}
  80269c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80269f:	5b                   	pop    %ebx
  8026a0:	5e                   	pop    %esi
  8026a1:	5d                   	pop    %ebp
  8026a2:	c3                   	ret    

008026a3 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a8:	c3                   	ret    

008026a9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026a9:	55                   	push   %ebp
  8026aa:	89 e5                	mov    %esp,%ebp
  8026ac:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026af:	68 95 33 80 00       	push   $0x803395
  8026b4:	ff 75 0c             	pushl  0xc(%ebp)
  8026b7:	e8 e0 e3 ff ff       	call   800a9c <strcpy>
	return 0;
}
  8026bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c1:	c9                   	leave  
  8026c2:	c3                   	ret    

008026c3 <devcons_write>:
{
  8026c3:	55                   	push   %ebp
  8026c4:	89 e5                	mov    %esp,%ebp
  8026c6:	57                   	push   %edi
  8026c7:	56                   	push   %esi
  8026c8:	53                   	push   %ebx
  8026c9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026cf:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026d4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026da:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026dd:	73 31                	jae    802710 <devcons_write+0x4d>
		m = n - tot;
  8026df:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026e2:	29 f3                	sub    %esi,%ebx
  8026e4:	83 fb 7f             	cmp    $0x7f,%ebx
  8026e7:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8026ec:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8026ef:	83 ec 04             	sub    $0x4,%esp
  8026f2:	53                   	push   %ebx
  8026f3:	89 f0                	mov    %esi,%eax
  8026f5:	03 45 0c             	add    0xc(%ebp),%eax
  8026f8:	50                   	push   %eax
  8026f9:	57                   	push   %edi
  8026fa:	e8 2b e5 ff ff       	call   800c2a <memmove>
		sys_cputs(buf, m);
  8026ff:	83 c4 08             	add    $0x8,%esp
  802702:	53                   	push   %ebx
  802703:	57                   	push   %edi
  802704:	e8 c9 e6 ff ff       	call   800dd2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802709:	01 de                	add    %ebx,%esi
  80270b:	83 c4 10             	add    $0x10,%esp
  80270e:	eb ca                	jmp    8026da <devcons_write+0x17>
}
  802710:	89 f0                	mov    %esi,%eax
  802712:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802715:	5b                   	pop    %ebx
  802716:	5e                   	pop    %esi
  802717:	5f                   	pop    %edi
  802718:	5d                   	pop    %ebp
  802719:	c3                   	ret    

0080271a <devcons_read>:
{
  80271a:	55                   	push   %ebp
  80271b:	89 e5                	mov    %esp,%ebp
  80271d:	83 ec 08             	sub    $0x8,%esp
  802720:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802725:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802729:	74 21                	je     80274c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80272b:	e8 c0 e6 ff ff       	call   800df0 <sys_cgetc>
  802730:	85 c0                	test   %eax,%eax
  802732:	75 07                	jne    80273b <devcons_read+0x21>
		sys_yield();
  802734:	e8 36 e7 ff ff       	call   800e6f <sys_yield>
  802739:	eb f0                	jmp    80272b <devcons_read+0x11>
	if (c < 0)
  80273b:	78 0f                	js     80274c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80273d:	83 f8 04             	cmp    $0x4,%eax
  802740:	74 0c                	je     80274e <devcons_read+0x34>
	*(char*)vbuf = c;
  802742:	8b 55 0c             	mov    0xc(%ebp),%edx
  802745:	88 02                	mov    %al,(%edx)
	return 1;
  802747:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80274c:	c9                   	leave  
  80274d:	c3                   	ret    
		return 0;
  80274e:	b8 00 00 00 00       	mov    $0x0,%eax
  802753:	eb f7                	jmp    80274c <devcons_read+0x32>

00802755 <cputchar>:
{
  802755:	55                   	push   %ebp
  802756:	89 e5                	mov    %esp,%ebp
  802758:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80275b:	8b 45 08             	mov    0x8(%ebp),%eax
  80275e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802761:	6a 01                	push   $0x1
  802763:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802766:	50                   	push   %eax
  802767:	e8 66 e6 ff ff       	call   800dd2 <sys_cputs>
}
  80276c:	83 c4 10             	add    $0x10,%esp
  80276f:	c9                   	leave  
  802770:	c3                   	ret    

00802771 <getchar>:
{
  802771:	55                   	push   %ebp
  802772:	89 e5                	mov    %esp,%ebp
  802774:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802777:	6a 01                	push   $0x1
  802779:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80277c:	50                   	push   %eax
  80277d:	6a 00                	push   $0x0
  80277f:	e8 d5 f1 ff ff       	call   801959 <read>
	if (r < 0)
  802784:	83 c4 10             	add    $0x10,%esp
  802787:	85 c0                	test   %eax,%eax
  802789:	78 06                	js     802791 <getchar+0x20>
	if (r < 1)
  80278b:	74 06                	je     802793 <getchar+0x22>
	return c;
  80278d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802791:	c9                   	leave  
  802792:	c3                   	ret    
		return -E_EOF;
  802793:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802798:	eb f7                	jmp    802791 <getchar+0x20>

0080279a <iscons>:
{
  80279a:	55                   	push   %ebp
  80279b:	89 e5                	mov    %esp,%ebp
  80279d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027a3:	50                   	push   %eax
  8027a4:	ff 75 08             	pushl  0x8(%ebp)
  8027a7:	e8 3d ef ff ff       	call   8016e9 <fd_lookup>
  8027ac:	83 c4 10             	add    $0x10,%esp
  8027af:	85 c0                	test   %eax,%eax
  8027b1:	78 11                	js     8027c4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027bc:	39 10                	cmp    %edx,(%eax)
  8027be:	0f 94 c0             	sete   %al
  8027c1:	0f b6 c0             	movzbl %al,%eax
}
  8027c4:	c9                   	leave  
  8027c5:	c3                   	ret    

008027c6 <opencons>:
{
  8027c6:	55                   	push   %ebp
  8027c7:	89 e5                	mov    %esp,%ebp
  8027c9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027cf:	50                   	push   %eax
  8027d0:	e8 c2 ee ff ff       	call   801697 <fd_alloc>
  8027d5:	83 c4 10             	add    $0x10,%esp
  8027d8:	85 c0                	test   %eax,%eax
  8027da:	78 3a                	js     802816 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027dc:	83 ec 04             	sub    $0x4,%esp
  8027df:	68 07 04 00 00       	push   $0x407
  8027e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8027e7:	6a 00                	push   $0x0
  8027e9:	e8 a0 e6 ff ff       	call   800e8e <sys_page_alloc>
  8027ee:	83 c4 10             	add    $0x10,%esp
  8027f1:	85 c0                	test   %eax,%eax
  8027f3:	78 21                	js     802816 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027fe:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80280a:	83 ec 0c             	sub    $0xc,%esp
  80280d:	50                   	push   %eax
  80280e:	e8 5d ee ff ff       	call   801670 <fd2num>
  802813:	83 c4 10             	add    $0x10,%esp
}
  802816:	c9                   	leave  
  802817:	c3                   	ret    

00802818 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802818:	55                   	push   %ebp
  802819:	89 e5                	mov    %esp,%ebp
  80281b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80281e:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802825:	74 0a                	je     802831 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802827:	8b 45 08             	mov    0x8(%ebp),%eax
  80282a:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80282f:	c9                   	leave  
  802830:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802831:	83 ec 04             	sub    $0x4,%esp
  802834:	6a 07                	push   $0x7
  802836:	68 00 f0 bf ee       	push   $0xeebff000
  80283b:	6a 00                	push   $0x0
  80283d:	e8 4c e6 ff ff       	call   800e8e <sys_page_alloc>
		if(r < 0)
  802842:	83 c4 10             	add    $0x10,%esp
  802845:	85 c0                	test   %eax,%eax
  802847:	78 2a                	js     802873 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802849:	83 ec 08             	sub    $0x8,%esp
  80284c:	68 87 28 80 00       	push   $0x802887
  802851:	6a 00                	push   $0x0
  802853:	e8 81 e7 ff ff       	call   800fd9 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802858:	83 c4 10             	add    $0x10,%esp
  80285b:	85 c0                	test   %eax,%eax
  80285d:	79 c8                	jns    802827 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80285f:	83 ec 04             	sub    $0x4,%esp
  802862:	68 d4 33 80 00       	push   $0x8033d4
  802867:	6a 25                	push   $0x25
  802869:	68 10 34 80 00       	push   $0x803410
  80286e:	e8 d4 d9 ff ff       	call   800247 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802873:	83 ec 04             	sub    $0x4,%esp
  802876:	68 a4 33 80 00       	push   $0x8033a4
  80287b:	6a 22                	push   $0x22
  80287d:	68 10 34 80 00       	push   $0x803410
  802882:	e8 c0 d9 ff ff       	call   800247 <_panic>

00802887 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802887:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802888:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80288d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80288f:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802892:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802896:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80289a:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80289d:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80289f:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8028a3:	83 c4 08             	add    $0x8,%esp
	popal
  8028a6:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8028a7:	83 c4 04             	add    $0x4,%esp
	popfl
  8028aa:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8028ab:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8028ac:	c3                   	ret    

008028ad <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028ad:	55                   	push   %ebp
  8028ae:	89 e5                	mov    %esp,%ebp
  8028b0:	56                   	push   %esi
  8028b1:	53                   	push   %ebx
  8028b2:	8b 75 08             	mov    0x8(%ebp),%esi
  8028b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8028bb:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8028bd:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8028c2:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8028c5:	83 ec 0c             	sub    $0xc,%esp
  8028c8:	50                   	push   %eax
  8028c9:	e8 70 e7 ff ff       	call   80103e <sys_ipc_recv>
	if(ret < 0){
  8028ce:	83 c4 10             	add    $0x10,%esp
  8028d1:	85 c0                	test   %eax,%eax
  8028d3:	78 2b                	js     802900 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8028d5:	85 f6                	test   %esi,%esi
  8028d7:	74 0a                	je     8028e3 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8028d9:	a1 20 54 80 00       	mov    0x805420,%eax
  8028de:	8b 40 78             	mov    0x78(%eax),%eax
  8028e1:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8028e3:	85 db                	test   %ebx,%ebx
  8028e5:	74 0a                	je     8028f1 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8028e7:	a1 20 54 80 00       	mov    0x805420,%eax
  8028ec:	8b 40 7c             	mov    0x7c(%eax),%eax
  8028ef:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8028f1:	a1 20 54 80 00       	mov    0x805420,%eax
  8028f6:	8b 40 74             	mov    0x74(%eax),%eax
}
  8028f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028fc:	5b                   	pop    %ebx
  8028fd:	5e                   	pop    %esi
  8028fe:	5d                   	pop    %ebp
  8028ff:	c3                   	ret    
		if(from_env_store)
  802900:	85 f6                	test   %esi,%esi
  802902:	74 06                	je     80290a <ipc_recv+0x5d>
			*from_env_store = 0;
  802904:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80290a:	85 db                	test   %ebx,%ebx
  80290c:	74 eb                	je     8028f9 <ipc_recv+0x4c>
			*perm_store = 0;
  80290e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802914:	eb e3                	jmp    8028f9 <ipc_recv+0x4c>

00802916 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
  802919:	57                   	push   %edi
  80291a:	56                   	push   %esi
  80291b:	53                   	push   %ebx
  80291c:	83 ec 0c             	sub    $0xc,%esp
  80291f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802922:	8b 75 0c             	mov    0xc(%ebp),%esi
  802925:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802928:	85 db                	test   %ebx,%ebx
  80292a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80292f:	0f 44 d8             	cmove  %eax,%ebx
  802932:	eb 05                	jmp    802939 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802934:	e8 36 e5 ff ff       	call   800e6f <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802939:	ff 75 14             	pushl  0x14(%ebp)
  80293c:	53                   	push   %ebx
  80293d:	56                   	push   %esi
  80293e:	57                   	push   %edi
  80293f:	e8 d7 e6 ff ff       	call   80101b <sys_ipc_try_send>
  802944:	83 c4 10             	add    $0x10,%esp
  802947:	85 c0                	test   %eax,%eax
  802949:	74 1b                	je     802966 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80294b:	79 e7                	jns    802934 <ipc_send+0x1e>
  80294d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802950:	74 e2                	je     802934 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802952:	83 ec 04             	sub    $0x4,%esp
  802955:	68 1e 34 80 00       	push   $0x80341e
  80295a:	6a 46                	push   $0x46
  80295c:	68 33 34 80 00       	push   $0x803433
  802961:	e8 e1 d8 ff ff       	call   800247 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802966:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802969:	5b                   	pop    %ebx
  80296a:	5e                   	pop    %esi
  80296b:	5f                   	pop    %edi
  80296c:	5d                   	pop    %ebp
  80296d:	c3                   	ret    

0080296e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80296e:	55                   	push   %ebp
  80296f:	89 e5                	mov    %esp,%ebp
  802971:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802974:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802979:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80297f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802985:	8b 52 50             	mov    0x50(%edx),%edx
  802988:	39 ca                	cmp    %ecx,%edx
  80298a:	74 11                	je     80299d <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80298c:	83 c0 01             	add    $0x1,%eax
  80298f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802994:	75 e3                	jne    802979 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802996:	b8 00 00 00 00       	mov    $0x0,%eax
  80299b:	eb 0e                	jmp    8029ab <ipc_find_env+0x3d>
			return envs[i].env_id;
  80299d:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8029a3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8029a8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8029ab:	5d                   	pop    %ebp
  8029ac:	c3                   	ret    

008029ad <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029ad:	55                   	push   %ebp
  8029ae:	89 e5                	mov    %esp,%ebp
  8029b0:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029b3:	89 d0                	mov    %edx,%eax
  8029b5:	c1 e8 16             	shr    $0x16,%eax
  8029b8:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8029bf:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8029c4:	f6 c1 01             	test   $0x1,%cl
  8029c7:	74 1d                	je     8029e6 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8029c9:	c1 ea 0c             	shr    $0xc,%edx
  8029cc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029d3:	f6 c2 01             	test   $0x1,%dl
  8029d6:	74 0e                	je     8029e6 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029d8:	c1 ea 0c             	shr    $0xc,%edx
  8029db:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029e2:	ef 
  8029e3:	0f b7 c0             	movzwl %ax,%eax
}
  8029e6:	5d                   	pop    %ebp
  8029e7:	c3                   	ret    
  8029e8:	66 90                	xchg   %ax,%ax
  8029ea:	66 90                	xchg   %ax,%ax
  8029ec:	66 90                	xchg   %ax,%ax
  8029ee:	66 90                	xchg   %ax,%ax

008029f0 <__udivdi3>:
  8029f0:	55                   	push   %ebp
  8029f1:	57                   	push   %edi
  8029f2:	56                   	push   %esi
  8029f3:	53                   	push   %ebx
  8029f4:	83 ec 1c             	sub    $0x1c,%esp
  8029f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a03:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802a07:	85 d2                	test   %edx,%edx
  802a09:	75 4d                	jne    802a58 <__udivdi3+0x68>
  802a0b:	39 f3                	cmp    %esi,%ebx
  802a0d:	76 19                	jbe    802a28 <__udivdi3+0x38>
  802a0f:	31 ff                	xor    %edi,%edi
  802a11:	89 e8                	mov    %ebp,%eax
  802a13:	89 f2                	mov    %esi,%edx
  802a15:	f7 f3                	div    %ebx
  802a17:	89 fa                	mov    %edi,%edx
  802a19:	83 c4 1c             	add    $0x1c,%esp
  802a1c:	5b                   	pop    %ebx
  802a1d:	5e                   	pop    %esi
  802a1e:	5f                   	pop    %edi
  802a1f:	5d                   	pop    %ebp
  802a20:	c3                   	ret    
  802a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a28:	89 d9                	mov    %ebx,%ecx
  802a2a:	85 db                	test   %ebx,%ebx
  802a2c:	75 0b                	jne    802a39 <__udivdi3+0x49>
  802a2e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a33:	31 d2                	xor    %edx,%edx
  802a35:	f7 f3                	div    %ebx
  802a37:	89 c1                	mov    %eax,%ecx
  802a39:	31 d2                	xor    %edx,%edx
  802a3b:	89 f0                	mov    %esi,%eax
  802a3d:	f7 f1                	div    %ecx
  802a3f:	89 c6                	mov    %eax,%esi
  802a41:	89 e8                	mov    %ebp,%eax
  802a43:	89 f7                	mov    %esi,%edi
  802a45:	f7 f1                	div    %ecx
  802a47:	89 fa                	mov    %edi,%edx
  802a49:	83 c4 1c             	add    $0x1c,%esp
  802a4c:	5b                   	pop    %ebx
  802a4d:	5e                   	pop    %esi
  802a4e:	5f                   	pop    %edi
  802a4f:	5d                   	pop    %ebp
  802a50:	c3                   	ret    
  802a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a58:	39 f2                	cmp    %esi,%edx
  802a5a:	77 1c                	ja     802a78 <__udivdi3+0x88>
  802a5c:	0f bd fa             	bsr    %edx,%edi
  802a5f:	83 f7 1f             	xor    $0x1f,%edi
  802a62:	75 2c                	jne    802a90 <__udivdi3+0xa0>
  802a64:	39 f2                	cmp    %esi,%edx
  802a66:	72 06                	jb     802a6e <__udivdi3+0x7e>
  802a68:	31 c0                	xor    %eax,%eax
  802a6a:	39 eb                	cmp    %ebp,%ebx
  802a6c:	77 a9                	ja     802a17 <__udivdi3+0x27>
  802a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a73:	eb a2                	jmp    802a17 <__udivdi3+0x27>
  802a75:	8d 76 00             	lea    0x0(%esi),%esi
  802a78:	31 ff                	xor    %edi,%edi
  802a7a:	31 c0                	xor    %eax,%eax
  802a7c:	89 fa                	mov    %edi,%edx
  802a7e:	83 c4 1c             	add    $0x1c,%esp
  802a81:	5b                   	pop    %ebx
  802a82:	5e                   	pop    %esi
  802a83:	5f                   	pop    %edi
  802a84:	5d                   	pop    %ebp
  802a85:	c3                   	ret    
  802a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a8d:	8d 76 00             	lea    0x0(%esi),%esi
  802a90:	89 f9                	mov    %edi,%ecx
  802a92:	b8 20 00 00 00       	mov    $0x20,%eax
  802a97:	29 f8                	sub    %edi,%eax
  802a99:	d3 e2                	shl    %cl,%edx
  802a9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a9f:	89 c1                	mov    %eax,%ecx
  802aa1:	89 da                	mov    %ebx,%edx
  802aa3:	d3 ea                	shr    %cl,%edx
  802aa5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802aa9:	09 d1                	or     %edx,%ecx
  802aab:	89 f2                	mov    %esi,%edx
  802aad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ab1:	89 f9                	mov    %edi,%ecx
  802ab3:	d3 e3                	shl    %cl,%ebx
  802ab5:	89 c1                	mov    %eax,%ecx
  802ab7:	d3 ea                	shr    %cl,%edx
  802ab9:	89 f9                	mov    %edi,%ecx
  802abb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802abf:	89 eb                	mov    %ebp,%ebx
  802ac1:	d3 e6                	shl    %cl,%esi
  802ac3:	89 c1                	mov    %eax,%ecx
  802ac5:	d3 eb                	shr    %cl,%ebx
  802ac7:	09 de                	or     %ebx,%esi
  802ac9:	89 f0                	mov    %esi,%eax
  802acb:	f7 74 24 08          	divl   0x8(%esp)
  802acf:	89 d6                	mov    %edx,%esi
  802ad1:	89 c3                	mov    %eax,%ebx
  802ad3:	f7 64 24 0c          	mull   0xc(%esp)
  802ad7:	39 d6                	cmp    %edx,%esi
  802ad9:	72 15                	jb     802af0 <__udivdi3+0x100>
  802adb:	89 f9                	mov    %edi,%ecx
  802add:	d3 e5                	shl    %cl,%ebp
  802adf:	39 c5                	cmp    %eax,%ebp
  802ae1:	73 04                	jae    802ae7 <__udivdi3+0xf7>
  802ae3:	39 d6                	cmp    %edx,%esi
  802ae5:	74 09                	je     802af0 <__udivdi3+0x100>
  802ae7:	89 d8                	mov    %ebx,%eax
  802ae9:	31 ff                	xor    %edi,%edi
  802aeb:	e9 27 ff ff ff       	jmp    802a17 <__udivdi3+0x27>
  802af0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802af3:	31 ff                	xor    %edi,%edi
  802af5:	e9 1d ff ff ff       	jmp    802a17 <__udivdi3+0x27>
  802afa:	66 90                	xchg   %ax,%ax
  802afc:	66 90                	xchg   %ax,%ax
  802afe:	66 90                	xchg   %ax,%ax

00802b00 <__umoddi3>:
  802b00:	55                   	push   %ebp
  802b01:	57                   	push   %edi
  802b02:	56                   	push   %esi
  802b03:	53                   	push   %ebx
  802b04:	83 ec 1c             	sub    $0x1c,%esp
  802b07:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802b0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b0f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802b13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b17:	89 da                	mov    %ebx,%edx
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	75 43                	jne    802b60 <__umoddi3+0x60>
  802b1d:	39 df                	cmp    %ebx,%edi
  802b1f:	76 17                	jbe    802b38 <__umoddi3+0x38>
  802b21:	89 f0                	mov    %esi,%eax
  802b23:	f7 f7                	div    %edi
  802b25:	89 d0                	mov    %edx,%eax
  802b27:	31 d2                	xor    %edx,%edx
  802b29:	83 c4 1c             	add    $0x1c,%esp
  802b2c:	5b                   	pop    %ebx
  802b2d:	5e                   	pop    %esi
  802b2e:	5f                   	pop    %edi
  802b2f:	5d                   	pop    %ebp
  802b30:	c3                   	ret    
  802b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b38:	89 fd                	mov    %edi,%ebp
  802b3a:	85 ff                	test   %edi,%edi
  802b3c:	75 0b                	jne    802b49 <__umoddi3+0x49>
  802b3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b43:	31 d2                	xor    %edx,%edx
  802b45:	f7 f7                	div    %edi
  802b47:	89 c5                	mov    %eax,%ebp
  802b49:	89 d8                	mov    %ebx,%eax
  802b4b:	31 d2                	xor    %edx,%edx
  802b4d:	f7 f5                	div    %ebp
  802b4f:	89 f0                	mov    %esi,%eax
  802b51:	f7 f5                	div    %ebp
  802b53:	89 d0                	mov    %edx,%eax
  802b55:	eb d0                	jmp    802b27 <__umoddi3+0x27>
  802b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b5e:	66 90                	xchg   %ax,%ax
  802b60:	89 f1                	mov    %esi,%ecx
  802b62:	39 d8                	cmp    %ebx,%eax
  802b64:	76 0a                	jbe    802b70 <__umoddi3+0x70>
  802b66:	89 f0                	mov    %esi,%eax
  802b68:	83 c4 1c             	add    $0x1c,%esp
  802b6b:	5b                   	pop    %ebx
  802b6c:	5e                   	pop    %esi
  802b6d:	5f                   	pop    %edi
  802b6e:	5d                   	pop    %ebp
  802b6f:	c3                   	ret    
  802b70:	0f bd e8             	bsr    %eax,%ebp
  802b73:	83 f5 1f             	xor    $0x1f,%ebp
  802b76:	75 20                	jne    802b98 <__umoddi3+0x98>
  802b78:	39 d8                	cmp    %ebx,%eax
  802b7a:	0f 82 b0 00 00 00    	jb     802c30 <__umoddi3+0x130>
  802b80:	39 f7                	cmp    %esi,%edi
  802b82:	0f 86 a8 00 00 00    	jbe    802c30 <__umoddi3+0x130>
  802b88:	89 c8                	mov    %ecx,%eax
  802b8a:	83 c4 1c             	add    $0x1c,%esp
  802b8d:	5b                   	pop    %ebx
  802b8e:	5e                   	pop    %esi
  802b8f:	5f                   	pop    %edi
  802b90:	5d                   	pop    %ebp
  802b91:	c3                   	ret    
  802b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b98:	89 e9                	mov    %ebp,%ecx
  802b9a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b9f:	29 ea                	sub    %ebp,%edx
  802ba1:	d3 e0                	shl    %cl,%eax
  802ba3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ba7:	89 d1                	mov    %edx,%ecx
  802ba9:	89 f8                	mov    %edi,%eax
  802bab:	d3 e8                	shr    %cl,%eax
  802bad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802bb1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802bb5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802bb9:	09 c1                	or     %eax,%ecx
  802bbb:	89 d8                	mov    %ebx,%eax
  802bbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bc1:	89 e9                	mov    %ebp,%ecx
  802bc3:	d3 e7                	shl    %cl,%edi
  802bc5:	89 d1                	mov    %edx,%ecx
  802bc7:	d3 e8                	shr    %cl,%eax
  802bc9:	89 e9                	mov    %ebp,%ecx
  802bcb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bcf:	d3 e3                	shl    %cl,%ebx
  802bd1:	89 c7                	mov    %eax,%edi
  802bd3:	89 d1                	mov    %edx,%ecx
  802bd5:	89 f0                	mov    %esi,%eax
  802bd7:	d3 e8                	shr    %cl,%eax
  802bd9:	89 e9                	mov    %ebp,%ecx
  802bdb:	89 fa                	mov    %edi,%edx
  802bdd:	d3 e6                	shl    %cl,%esi
  802bdf:	09 d8                	or     %ebx,%eax
  802be1:	f7 74 24 08          	divl   0x8(%esp)
  802be5:	89 d1                	mov    %edx,%ecx
  802be7:	89 f3                	mov    %esi,%ebx
  802be9:	f7 64 24 0c          	mull   0xc(%esp)
  802bed:	89 c6                	mov    %eax,%esi
  802bef:	89 d7                	mov    %edx,%edi
  802bf1:	39 d1                	cmp    %edx,%ecx
  802bf3:	72 06                	jb     802bfb <__umoddi3+0xfb>
  802bf5:	75 10                	jne    802c07 <__umoddi3+0x107>
  802bf7:	39 c3                	cmp    %eax,%ebx
  802bf9:	73 0c                	jae    802c07 <__umoddi3+0x107>
  802bfb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802bff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802c03:	89 d7                	mov    %edx,%edi
  802c05:	89 c6                	mov    %eax,%esi
  802c07:	89 ca                	mov    %ecx,%edx
  802c09:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c0e:	29 f3                	sub    %esi,%ebx
  802c10:	19 fa                	sbb    %edi,%edx
  802c12:	89 d0                	mov    %edx,%eax
  802c14:	d3 e0                	shl    %cl,%eax
  802c16:	89 e9                	mov    %ebp,%ecx
  802c18:	d3 eb                	shr    %cl,%ebx
  802c1a:	d3 ea                	shr    %cl,%edx
  802c1c:	09 d8                	or     %ebx,%eax
  802c1e:	83 c4 1c             	add    $0x1c,%esp
  802c21:	5b                   	pop    %ebx
  802c22:	5e                   	pop    %esi
  802c23:	5f                   	pop    %edi
  802c24:	5d                   	pop    %ebp
  802c25:	c3                   	ret    
  802c26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c2d:	8d 76 00             	lea    0x0(%esi),%esi
  802c30:	89 da                	mov    %ebx,%edx
  802c32:	29 fe                	sub    %edi,%esi
  802c34:	19 c2                	sbb    %eax,%edx
  802c36:	89 f1                	mov    %esi,%ecx
  802c38:	89 c8                	mov    %ecx,%eax
  802c3a:	e9 4b ff ff ff       	jmp    802b8a <__umoddi3+0x8a>
