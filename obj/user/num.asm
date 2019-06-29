
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 50 01 00 00       	call   800181 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	eb 43                	jmp    800086 <num+0x53>
		if (bol) {
			printf("%5d ", ++line);
  800043:	a1 00 40 80 00       	mov    0x804000,%eax
  800048:	83 c0 01             	add    $0x1,%eax
  80004b:	a3 00 40 80 00       	mov    %eax,0x804000
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	50                   	push   %eax
  800054:	68 40 27 80 00       	push   $0x802740
  800059:	e8 06 1a 00 00       	call   801a64 <printf>
			bol = 0;
  80005e:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800065:	00 00 00 
  800068:	83 c4 10             	add    $0x10,%esp
		}
		if ((r = write(1, &c, 1)) != 1)
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	6a 01                	push   $0x1
  800070:	53                   	push   %ebx
  800071:	6a 01                	push   $0x1
  800073:	e8 77 14 00 00       	call   8014ef <write>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	83 f8 01             	cmp    $0x1,%eax
  80007e:	75 24                	jne    8000a4 <num+0x71>
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
  800080:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  800084:	74 36                	je     8000bc <num+0x89>
	while ((n = read(f, &c, 1)) > 0) {
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	6a 01                	push   $0x1
  80008b:	53                   	push   %ebx
  80008c:	56                   	push   %esi
  80008d:	e8 91 13 00 00       	call   801423 <read>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	85 c0                	test   %eax,%eax
  800097:	7e 2f                	jle    8000c8 <num+0x95>
		if (bol) {
  800099:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  8000a0:	74 c9                	je     80006b <num+0x38>
  8000a2:	eb 9f                	jmp    800043 <num+0x10>
			panic("write error copying %s: %e", s, r);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	50                   	push   %eax
  8000a8:	ff 75 0c             	pushl  0xc(%ebp)
  8000ab:	68 45 27 80 00       	push   $0x802745
  8000b0:	6a 13                	push   $0x13
  8000b2:	68 60 27 80 00       	push   $0x802760
  8000b7:	e8 42 01 00 00       	call   8001fe <_panic>
			bol = 1;
  8000bc:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c3:	00 00 00 
  8000c6:	eb be                	jmp    800086 <num+0x53>
	}
	if (n < 0)
  8000c8:	78 07                	js     8000d1 <num+0x9e>
		panic("error reading %s: %e", s, n);
}
  8000ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	50                   	push   %eax
  8000d5:	ff 75 0c             	pushl  0xc(%ebp)
  8000d8:	68 6b 27 80 00       	push   $0x80276b
  8000dd:	6a 18                	push   $0x18
  8000df:	68 60 27 80 00       	push   $0x802760
  8000e4:	e8 15 01 00 00       	call   8001fe <_panic>

008000e9 <umain>:

void
umain(int argc, char **argv)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	83 ec 1c             	sub    $0x1c,%esp
	int f, i;

	binaryname = "num";
  8000f2:	c7 05 04 30 80 00 80 	movl   $0x802780,0x803004
  8000f9:	27 80 00 
	if (argc == 1)
  8000fc:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800100:	74 46                	je     800148 <umain+0x5f>
  800102:	8b 45 0c             	mov    0xc(%ebp),%eax
  800105:	8d 58 04             	lea    0x4(%eax),%ebx
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800108:	bf 01 00 00 00       	mov    $0x1,%edi
  80010d:	3b 7d 08             	cmp    0x8(%ebp),%edi
  800110:	7d 48                	jge    80015a <umain+0x71>
			f = open(argv[i], O_RDONLY);
  800112:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800115:	83 ec 08             	sub    $0x8,%esp
  800118:	6a 00                	push   $0x0
  80011a:	ff 33                	pushl  (%ebx)
  80011c:	e8 a0 17 00 00       	call   8018c1 <open>
  800121:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800123:	83 c4 10             	add    $0x10,%esp
  800126:	85 c0                	test   %eax,%eax
  800128:	78 3d                	js     800167 <umain+0x7e>
				panic("can't open %s: %e", argv[i], f);
			else {
				num(f, argv[i]);
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	ff 33                	pushl  (%ebx)
  80012f:	50                   	push   %eax
  800130:	e8 fe fe ff ff       	call   800033 <num>
				close(f);
  800135:	89 34 24             	mov    %esi,(%esp)
  800138:	e8 a8 11 00 00       	call   8012e5 <close>
		for (i = 1; i < argc; i++) {
  80013d:	83 c7 01             	add    $0x1,%edi
  800140:	83 c3 04             	add    $0x4,%ebx
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	eb c5                	jmp    80010d <umain+0x24>
		num(0, "<stdin>");
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 84 27 80 00       	push   $0x802784
  800150:	6a 00                	push   $0x0
  800152:	e8 dc fe ff ff       	call   800033 <num>
  800157:	83 c4 10             	add    $0x10,%esp
			}
		}
	exit();
  80015a:	e8 6b 00 00 00       	call   8001ca <exit>
}
  80015f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800162:	5b                   	pop    %ebx
  800163:	5e                   	pop    %esi
  800164:	5f                   	pop    %edi
  800165:	5d                   	pop    %ebp
  800166:	c3                   	ret    
				panic("can't open %s: %e", argv[i], f);
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	50                   	push   %eax
  80016b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016e:	ff 30                	pushl  (%eax)
  800170:	68 8c 27 80 00       	push   $0x80278c
  800175:	6a 27                	push   $0x27
  800177:	68 60 27 80 00       	push   $0x802760
  80017c:	e8 7d 00 00 00       	call   8001fe <_panic>

00800181 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	56                   	push   %esi
  800185:	53                   	push   %ebx
  800186:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800189:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  80018c:	e8 76 0c 00 00       	call   800e07 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800191:	25 ff 03 00 00       	and    $0x3ff,%eax
  800196:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80019c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a1:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a6:	85 db                	test   %ebx,%ebx
  8001a8:	7e 07                	jle    8001b1 <libmain+0x30>
		binaryname = argv[0];
  8001aa:	8b 06                	mov    (%esi),%eax
  8001ac:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	56                   	push   %esi
  8001b5:	53                   	push   %ebx
  8001b6:	e8 2e ff ff ff       	call   8000e9 <umain>

	// exit gracefully
	exit();
  8001bb:	e8 0a 00 00 00       	call   8001ca <exit>
}
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001c6:	5b                   	pop    %ebx
  8001c7:	5e                   	pop    %esi
  8001c8:	5d                   	pop    %ebp
  8001c9:	c3                   	ret    

008001ca <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001d0:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8001d5:	8b 40 48             	mov    0x48(%eax),%eax
  8001d8:	68 b4 27 80 00       	push   $0x8027b4
  8001dd:	50                   	push   %eax
  8001de:	68 a8 27 80 00       	push   $0x8027a8
  8001e3:	e8 0c 01 00 00       	call   8002f4 <cprintf>
	close_all();
  8001e8:	e8 25 11 00 00       	call   801312 <close_all>
	sys_env_destroy(0);
  8001ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001f4:	e8 cd 0b 00 00       	call   800dc6 <sys_env_destroy>
}
  8001f9:	83 c4 10             	add    $0x10,%esp
  8001fc:	c9                   	leave  
  8001fd:	c3                   	ret    

008001fe <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	56                   	push   %esi
  800202:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800203:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800208:	8b 40 48             	mov    0x48(%eax),%eax
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 e0 27 80 00       	push   $0x8027e0
  800213:	50                   	push   %eax
  800214:	68 a8 27 80 00       	push   $0x8027a8
  800219:	e8 d6 00 00 00       	call   8002f4 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80021e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800221:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800227:	e8 db 0b 00 00       	call   800e07 <sys_getenvid>
  80022c:	83 c4 04             	add    $0x4,%esp
  80022f:	ff 75 0c             	pushl  0xc(%ebp)
  800232:	ff 75 08             	pushl  0x8(%ebp)
  800235:	56                   	push   %esi
  800236:	50                   	push   %eax
  800237:	68 bc 27 80 00       	push   $0x8027bc
  80023c:	e8 b3 00 00 00       	call   8002f4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800241:	83 c4 18             	add    $0x18,%esp
  800244:	53                   	push   %ebx
  800245:	ff 75 10             	pushl  0x10(%ebp)
  800248:	e8 56 00 00 00       	call   8002a3 <vcprintf>
	cprintf("\n");
  80024d:	c7 04 24 d2 2c 80 00 	movl   $0x802cd2,(%esp)
  800254:	e8 9b 00 00 00       	call   8002f4 <cprintf>
  800259:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80025c:	cc                   	int3   
  80025d:	eb fd                	jmp    80025c <_panic+0x5e>

0080025f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	53                   	push   %ebx
  800263:	83 ec 04             	sub    $0x4,%esp
  800266:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800269:	8b 13                	mov    (%ebx),%edx
  80026b:	8d 42 01             	lea    0x1(%edx),%eax
  80026e:	89 03                	mov    %eax,(%ebx)
  800270:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800273:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800277:	3d ff 00 00 00       	cmp    $0xff,%eax
  80027c:	74 09                	je     800287 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80027e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800282:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800285:	c9                   	leave  
  800286:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800287:	83 ec 08             	sub    $0x8,%esp
  80028a:	68 ff 00 00 00       	push   $0xff
  80028f:	8d 43 08             	lea    0x8(%ebx),%eax
  800292:	50                   	push   %eax
  800293:	e8 f1 0a 00 00       	call   800d89 <sys_cputs>
		b->idx = 0;
  800298:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80029e:	83 c4 10             	add    $0x10,%esp
  8002a1:	eb db                	jmp    80027e <putch+0x1f>

008002a3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002ac:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002b3:	00 00 00 
	b.cnt = 0;
  8002b6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002bd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002c0:	ff 75 0c             	pushl  0xc(%ebp)
  8002c3:	ff 75 08             	pushl  0x8(%ebp)
  8002c6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002cc:	50                   	push   %eax
  8002cd:	68 5f 02 80 00       	push   $0x80025f
  8002d2:	e8 4a 01 00 00       	call   800421 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002d7:	83 c4 08             	add    $0x8,%esp
  8002da:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002e0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002e6:	50                   	push   %eax
  8002e7:	e8 9d 0a 00 00       	call   800d89 <sys_cputs>

	return b.cnt;
}
  8002ec:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002f2:	c9                   	leave  
  8002f3:	c3                   	ret    

008002f4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002fa:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002fd:	50                   	push   %eax
  8002fe:	ff 75 08             	pushl  0x8(%ebp)
  800301:	e8 9d ff ff ff       	call   8002a3 <vcprintf>
	va_end(ap);

	return cnt;
}
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	57                   	push   %edi
  80030c:	56                   	push   %esi
  80030d:	53                   	push   %ebx
  80030e:	83 ec 1c             	sub    $0x1c,%esp
  800311:	89 c6                	mov    %eax,%esi
  800313:	89 d7                	mov    %edx,%edi
  800315:	8b 45 08             	mov    0x8(%ebp),%eax
  800318:	8b 55 0c             	mov    0xc(%ebp),%edx
  80031b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80031e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800321:	8b 45 10             	mov    0x10(%ebp),%eax
  800324:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800327:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80032b:	74 2c                	je     800359 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80032d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800330:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800337:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80033a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80033d:	39 c2                	cmp    %eax,%edx
  80033f:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800342:	73 43                	jae    800387 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800344:	83 eb 01             	sub    $0x1,%ebx
  800347:	85 db                	test   %ebx,%ebx
  800349:	7e 6c                	jle    8003b7 <printnum+0xaf>
				putch(padc, putdat);
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	57                   	push   %edi
  80034f:	ff 75 18             	pushl  0x18(%ebp)
  800352:	ff d6                	call   *%esi
  800354:	83 c4 10             	add    $0x10,%esp
  800357:	eb eb                	jmp    800344 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	6a 20                	push   $0x20
  80035e:	6a 00                	push   $0x0
  800360:	50                   	push   %eax
  800361:	ff 75 e4             	pushl  -0x1c(%ebp)
  800364:	ff 75 e0             	pushl  -0x20(%ebp)
  800367:	89 fa                	mov    %edi,%edx
  800369:	89 f0                	mov    %esi,%eax
  80036b:	e8 98 ff ff ff       	call   800308 <printnum>
		while (--width > 0)
  800370:	83 c4 20             	add    $0x20,%esp
  800373:	83 eb 01             	sub    $0x1,%ebx
  800376:	85 db                	test   %ebx,%ebx
  800378:	7e 65                	jle    8003df <printnum+0xd7>
			putch(padc, putdat);
  80037a:	83 ec 08             	sub    $0x8,%esp
  80037d:	57                   	push   %edi
  80037e:	6a 20                	push   $0x20
  800380:	ff d6                	call   *%esi
  800382:	83 c4 10             	add    $0x10,%esp
  800385:	eb ec                	jmp    800373 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	ff 75 18             	pushl  0x18(%ebp)
  80038d:	83 eb 01             	sub    $0x1,%ebx
  800390:	53                   	push   %ebx
  800391:	50                   	push   %eax
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	ff 75 dc             	pushl  -0x24(%ebp)
  800398:	ff 75 d8             	pushl  -0x28(%ebp)
  80039b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039e:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a1:	e8 3a 21 00 00       	call   8024e0 <__udivdi3>
  8003a6:	83 c4 18             	add    $0x18,%esp
  8003a9:	52                   	push   %edx
  8003aa:	50                   	push   %eax
  8003ab:	89 fa                	mov    %edi,%edx
  8003ad:	89 f0                	mov    %esi,%eax
  8003af:	e8 54 ff ff ff       	call   800308 <printnum>
  8003b4:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003b7:	83 ec 08             	sub    $0x8,%esp
  8003ba:	57                   	push   %edi
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8003c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ca:	e8 21 22 00 00       	call   8025f0 <__umoddi3>
  8003cf:	83 c4 14             	add    $0x14,%esp
  8003d2:	0f be 80 e7 27 80 00 	movsbl 0x8027e7(%eax),%eax
  8003d9:	50                   	push   %eax
  8003da:	ff d6                	call   *%esi
  8003dc:	83 c4 10             	add    $0x10,%esp
	}
}
  8003df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e2:	5b                   	pop    %ebx
  8003e3:	5e                   	pop    %esi
  8003e4:	5f                   	pop    %edi
  8003e5:	5d                   	pop    %ebp
  8003e6:	c3                   	ret    

008003e7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ed:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f1:	8b 10                	mov    (%eax),%edx
  8003f3:	3b 50 04             	cmp    0x4(%eax),%edx
  8003f6:	73 0a                	jae    800402 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003f8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003fb:	89 08                	mov    %ecx,(%eax)
  8003fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800400:	88 02                	mov    %al,(%edx)
}
  800402:	5d                   	pop    %ebp
  800403:	c3                   	ret    

00800404 <printfmt>:
{
  800404:	55                   	push   %ebp
  800405:	89 e5                	mov    %esp,%ebp
  800407:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80040a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80040d:	50                   	push   %eax
  80040e:	ff 75 10             	pushl  0x10(%ebp)
  800411:	ff 75 0c             	pushl  0xc(%ebp)
  800414:	ff 75 08             	pushl  0x8(%ebp)
  800417:	e8 05 00 00 00       	call   800421 <vprintfmt>
}
  80041c:	83 c4 10             	add    $0x10,%esp
  80041f:	c9                   	leave  
  800420:	c3                   	ret    

00800421 <vprintfmt>:
{
  800421:	55                   	push   %ebp
  800422:	89 e5                	mov    %esp,%ebp
  800424:	57                   	push   %edi
  800425:	56                   	push   %esi
  800426:	53                   	push   %ebx
  800427:	83 ec 3c             	sub    $0x3c,%esp
  80042a:	8b 75 08             	mov    0x8(%ebp),%esi
  80042d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800430:	8b 7d 10             	mov    0x10(%ebp),%edi
  800433:	e9 32 04 00 00       	jmp    80086a <vprintfmt+0x449>
		padc = ' ';
  800438:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80043c:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800443:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80044a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800451:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800458:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80045f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800464:	8d 47 01             	lea    0x1(%edi),%eax
  800467:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80046a:	0f b6 17             	movzbl (%edi),%edx
  80046d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800470:	3c 55                	cmp    $0x55,%al
  800472:	0f 87 12 05 00 00    	ja     80098a <vprintfmt+0x569>
  800478:	0f b6 c0             	movzbl %al,%eax
  80047b:	ff 24 85 c0 29 80 00 	jmp    *0x8029c0(,%eax,4)
  800482:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800485:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800489:	eb d9                	jmp    800464 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80048b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80048e:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800492:	eb d0                	jmp    800464 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800494:	0f b6 d2             	movzbl %dl,%edx
  800497:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80049a:	b8 00 00 00 00       	mov    $0x0,%eax
  80049f:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a2:	eb 03                	jmp    8004a7 <vprintfmt+0x86>
  8004a4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004a7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004aa:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004ae:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004b1:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004b4:	83 fe 09             	cmp    $0x9,%esi
  8004b7:	76 eb                	jbe    8004a4 <vprintfmt+0x83>
  8004b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8004bf:	eb 14                	jmp    8004d5 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cc:	8d 40 04             	lea    0x4(%eax),%eax
  8004cf:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d9:	79 89                	jns    800464 <vprintfmt+0x43>
				width = precision, precision = -1;
  8004db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004e1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004e8:	e9 77 ff ff ff       	jmp    800464 <vprintfmt+0x43>
  8004ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f0:	85 c0                	test   %eax,%eax
  8004f2:	0f 48 c1             	cmovs  %ecx,%eax
  8004f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004fb:	e9 64 ff ff ff       	jmp    800464 <vprintfmt+0x43>
  800500:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800503:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80050a:	e9 55 ff ff ff       	jmp    800464 <vprintfmt+0x43>
			lflag++;
  80050f:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800513:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800516:	e9 49 ff ff ff       	jmp    800464 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	8d 78 04             	lea    0x4(%eax),%edi
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	53                   	push   %ebx
  800525:	ff 30                	pushl  (%eax)
  800527:	ff d6                	call   *%esi
			break;
  800529:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80052c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80052f:	e9 33 03 00 00       	jmp    800867 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8d 78 04             	lea    0x4(%eax),%edi
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	99                   	cltd   
  80053d:	31 d0                	xor    %edx,%eax
  80053f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800541:	83 f8 11             	cmp    $0x11,%eax
  800544:	7f 23                	jg     800569 <vprintfmt+0x148>
  800546:	8b 14 85 20 2b 80 00 	mov    0x802b20(,%eax,4),%edx
  80054d:	85 d2                	test   %edx,%edx
  80054f:	74 18                	je     800569 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800551:	52                   	push   %edx
  800552:	68 41 2c 80 00       	push   $0x802c41
  800557:	53                   	push   %ebx
  800558:	56                   	push   %esi
  800559:	e8 a6 fe ff ff       	call   800404 <printfmt>
  80055e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800561:	89 7d 14             	mov    %edi,0x14(%ebp)
  800564:	e9 fe 02 00 00       	jmp    800867 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800569:	50                   	push   %eax
  80056a:	68 ff 27 80 00       	push   $0x8027ff
  80056f:	53                   	push   %ebx
  800570:	56                   	push   %esi
  800571:	e8 8e fe ff ff       	call   800404 <printfmt>
  800576:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800579:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80057c:	e9 e6 02 00 00       	jmp    800867 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	83 c0 04             	add    $0x4,%eax
  800587:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80058f:	85 c9                	test   %ecx,%ecx
  800591:	b8 f8 27 80 00       	mov    $0x8027f8,%eax
  800596:	0f 45 c1             	cmovne %ecx,%eax
  800599:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80059c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a0:	7e 06                	jle    8005a8 <vprintfmt+0x187>
  8005a2:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005a6:	75 0d                	jne    8005b5 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005ab:	89 c7                	mov    %eax,%edi
  8005ad:	03 45 e0             	add    -0x20(%ebp),%eax
  8005b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b3:	eb 53                	jmp    800608 <vprintfmt+0x1e7>
  8005b5:	83 ec 08             	sub    $0x8,%esp
  8005b8:	ff 75 d8             	pushl  -0x28(%ebp)
  8005bb:	50                   	push   %eax
  8005bc:	e8 71 04 00 00       	call   800a32 <strnlen>
  8005c1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005c4:	29 c1                	sub    %eax,%ecx
  8005c6:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005c9:	83 c4 10             	add    $0x10,%esp
  8005cc:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005ce:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d5:	eb 0f                	jmp    8005e6 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005d7:	83 ec 08             	sub    $0x8,%esp
  8005da:	53                   	push   %ebx
  8005db:	ff 75 e0             	pushl  -0x20(%ebp)
  8005de:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e0:	83 ef 01             	sub    $0x1,%edi
  8005e3:	83 c4 10             	add    $0x10,%esp
  8005e6:	85 ff                	test   %edi,%edi
  8005e8:	7f ed                	jg     8005d7 <vprintfmt+0x1b6>
  8005ea:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005ed:	85 c9                	test   %ecx,%ecx
  8005ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f4:	0f 49 c1             	cmovns %ecx,%eax
  8005f7:	29 c1                	sub    %eax,%ecx
  8005f9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005fc:	eb aa                	jmp    8005a8 <vprintfmt+0x187>
					putch(ch, putdat);
  8005fe:	83 ec 08             	sub    $0x8,%esp
  800601:	53                   	push   %ebx
  800602:	52                   	push   %edx
  800603:	ff d6                	call   *%esi
  800605:	83 c4 10             	add    $0x10,%esp
  800608:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80060b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80060d:	83 c7 01             	add    $0x1,%edi
  800610:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800614:	0f be d0             	movsbl %al,%edx
  800617:	85 d2                	test   %edx,%edx
  800619:	74 4b                	je     800666 <vprintfmt+0x245>
  80061b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80061f:	78 06                	js     800627 <vprintfmt+0x206>
  800621:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800625:	78 1e                	js     800645 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800627:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80062b:	74 d1                	je     8005fe <vprintfmt+0x1dd>
  80062d:	0f be c0             	movsbl %al,%eax
  800630:	83 e8 20             	sub    $0x20,%eax
  800633:	83 f8 5e             	cmp    $0x5e,%eax
  800636:	76 c6                	jbe    8005fe <vprintfmt+0x1dd>
					putch('?', putdat);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	53                   	push   %ebx
  80063c:	6a 3f                	push   $0x3f
  80063e:	ff d6                	call   *%esi
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	eb c3                	jmp    800608 <vprintfmt+0x1e7>
  800645:	89 cf                	mov    %ecx,%edi
  800647:	eb 0e                	jmp    800657 <vprintfmt+0x236>
				putch(' ', putdat);
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	53                   	push   %ebx
  80064d:	6a 20                	push   $0x20
  80064f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800651:	83 ef 01             	sub    $0x1,%edi
  800654:	83 c4 10             	add    $0x10,%esp
  800657:	85 ff                	test   %edi,%edi
  800659:	7f ee                	jg     800649 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80065b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
  800661:	e9 01 02 00 00       	jmp    800867 <vprintfmt+0x446>
  800666:	89 cf                	mov    %ecx,%edi
  800668:	eb ed                	jmp    800657 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80066a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80066d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800674:	e9 eb fd ff ff       	jmp    800464 <vprintfmt+0x43>
	if (lflag >= 2)
  800679:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80067d:	7f 21                	jg     8006a0 <vprintfmt+0x27f>
	else if (lflag)
  80067f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800683:	74 68                	je     8006ed <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80068d:	89 c1                	mov    %eax,%ecx
  80068f:	c1 f9 1f             	sar    $0x1f,%ecx
  800692:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 40 04             	lea    0x4(%eax),%eax
  80069b:	89 45 14             	mov    %eax,0x14(%ebp)
  80069e:	eb 17                	jmp    8006b7 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8b 50 04             	mov    0x4(%eax),%edx
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006ab:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8d 40 08             	lea    0x8(%eax),%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006ba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006c3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006c7:	78 3f                	js     800708 <vprintfmt+0x2e7>
			base = 10;
  8006c9:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006ce:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006d2:	0f 84 71 01 00 00    	je     800849 <vprintfmt+0x428>
				putch('+', putdat);
  8006d8:	83 ec 08             	sub    $0x8,%esp
  8006db:	53                   	push   %ebx
  8006dc:	6a 2b                	push   $0x2b
  8006de:	ff d6                	call   *%esi
  8006e0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006e3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e8:	e9 5c 01 00 00       	jmp    800849 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006f5:	89 c1                	mov    %eax,%ecx
  8006f7:	c1 f9 1f             	sar    $0x1f,%ecx
  8006fa:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8d 40 04             	lea    0x4(%eax),%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
  800706:	eb af                	jmp    8006b7 <vprintfmt+0x296>
				putch('-', putdat);
  800708:	83 ec 08             	sub    $0x8,%esp
  80070b:	53                   	push   %ebx
  80070c:	6a 2d                	push   $0x2d
  80070e:	ff d6                	call   *%esi
				num = -(long long) num;
  800710:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800713:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800716:	f7 d8                	neg    %eax
  800718:	83 d2 00             	adc    $0x0,%edx
  80071b:	f7 da                	neg    %edx
  80071d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800720:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800723:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800726:	b8 0a 00 00 00       	mov    $0xa,%eax
  80072b:	e9 19 01 00 00       	jmp    800849 <vprintfmt+0x428>
	if (lflag >= 2)
  800730:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800734:	7f 29                	jg     80075f <vprintfmt+0x33e>
	else if (lflag)
  800736:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80073a:	74 44                	je     800780 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	ba 00 00 00 00       	mov    $0x0,%edx
  800746:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800749:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8d 40 04             	lea    0x4(%eax),%eax
  800752:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800755:	b8 0a 00 00 00       	mov    $0xa,%eax
  80075a:	e9 ea 00 00 00       	jmp    800849 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8b 50 04             	mov    0x4(%eax),%edx
  800765:	8b 00                	mov    (%eax),%eax
  800767:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8d 40 08             	lea    0x8(%eax),%eax
  800773:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800776:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077b:	e9 c9 00 00 00       	jmp    800849 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	ba 00 00 00 00       	mov    $0x0,%edx
  80078a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	8d 40 04             	lea    0x4(%eax),%eax
  800796:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800799:	b8 0a 00 00 00       	mov    $0xa,%eax
  80079e:	e9 a6 00 00 00       	jmp    800849 <vprintfmt+0x428>
			putch('0', putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	53                   	push   %ebx
  8007a7:	6a 30                	push   $0x30
  8007a9:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007ab:	83 c4 10             	add    $0x10,%esp
  8007ae:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007b2:	7f 26                	jg     8007da <vprintfmt+0x3b9>
	else if (lflag)
  8007b4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007b8:	74 3e                	je     8007f8 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8d 40 04             	lea    0x4(%eax),%eax
  8007d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007d3:	b8 08 00 00 00       	mov    $0x8,%eax
  8007d8:	eb 6f                	jmp    800849 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8b 50 04             	mov    0x4(%eax),%edx
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8d 40 08             	lea    0x8(%eax),%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007f1:	b8 08 00 00 00       	mov    $0x8,%eax
  8007f6:	eb 51                	jmp    800849 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	8b 00                	mov    (%eax),%eax
  8007fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800802:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800805:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8d 40 04             	lea    0x4(%eax),%eax
  80080e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800811:	b8 08 00 00 00       	mov    $0x8,%eax
  800816:	eb 31                	jmp    800849 <vprintfmt+0x428>
			putch('0', putdat);
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	53                   	push   %ebx
  80081c:	6a 30                	push   $0x30
  80081e:	ff d6                	call   *%esi
			putch('x', putdat);
  800820:	83 c4 08             	add    $0x8,%esp
  800823:	53                   	push   %ebx
  800824:	6a 78                	push   $0x78
  800826:	ff d6                	call   *%esi
			num = (unsigned long long)
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	8b 00                	mov    (%eax),%eax
  80082d:	ba 00 00 00 00       	mov    $0x0,%edx
  800832:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800835:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800838:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	8d 40 04             	lea    0x4(%eax),%eax
  800841:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800844:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800849:	83 ec 0c             	sub    $0xc,%esp
  80084c:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800850:	52                   	push   %edx
  800851:	ff 75 e0             	pushl  -0x20(%ebp)
  800854:	50                   	push   %eax
  800855:	ff 75 dc             	pushl  -0x24(%ebp)
  800858:	ff 75 d8             	pushl  -0x28(%ebp)
  80085b:	89 da                	mov    %ebx,%edx
  80085d:	89 f0                	mov    %esi,%eax
  80085f:	e8 a4 fa ff ff       	call   800308 <printnum>
			break;
  800864:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800867:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80086a:	83 c7 01             	add    $0x1,%edi
  80086d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800871:	83 f8 25             	cmp    $0x25,%eax
  800874:	0f 84 be fb ff ff    	je     800438 <vprintfmt+0x17>
			if (ch == '\0')
  80087a:	85 c0                	test   %eax,%eax
  80087c:	0f 84 28 01 00 00    	je     8009aa <vprintfmt+0x589>
			putch(ch, putdat);
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	53                   	push   %ebx
  800886:	50                   	push   %eax
  800887:	ff d6                	call   *%esi
  800889:	83 c4 10             	add    $0x10,%esp
  80088c:	eb dc                	jmp    80086a <vprintfmt+0x449>
	if (lflag >= 2)
  80088e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800892:	7f 26                	jg     8008ba <vprintfmt+0x499>
	else if (lflag)
  800894:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800898:	74 41                	je     8008db <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	8d 40 04             	lea    0x4(%eax),%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b3:	b8 10 00 00 00       	mov    $0x10,%eax
  8008b8:	eb 8f                	jmp    800849 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	8b 50 04             	mov    0x4(%eax),%edx
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cb:	8d 40 08             	lea    0x8(%eax),%eax
  8008ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d1:	b8 10 00 00 00       	mov    $0x10,%eax
  8008d6:	e9 6e ff ff ff       	jmp    800849 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008db:	8b 45 14             	mov    0x14(%ebp),%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	8d 40 04             	lea    0x4(%eax),%eax
  8008f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f4:	b8 10 00 00 00       	mov    $0x10,%eax
  8008f9:	e9 4b ff ff ff       	jmp    800849 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	83 c0 04             	add    $0x4,%eax
  800904:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	8b 00                	mov    (%eax),%eax
  80090c:	85 c0                	test   %eax,%eax
  80090e:	74 14                	je     800924 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800910:	8b 13                	mov    (%ebx),%edx
  800912:	83 fa 7f             	cmp    $0x7f,%edx
  800915:	7f 37                	jg     80094e <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800917:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800919:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80091c:	89 45 14             	mov    %eax,0x14(%ebp)
  80091f:	e9 43 ff ff ff       	jmp    800867 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800924:	b8 0a 00 00 00       	mov    $0xa,%eax
  800929:	bf 1d 29 80 00       	mov    $0x80291d,%edi
							putch(ch, putdat);
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	53                   	push   %ebx
  800932:	50                   	push   %eax
  800933:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800935:	83 c7 01             	add    $0x1,%edi
  800938:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80093c:	83 c4 10             	add    $0x10,%esp
  80093f:	85 c0                	test   %eax,%eax
  800941:	75 eb                	jne    80092e <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800943:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
  800949:	e9 19 ff ff ff       	jmp    800867 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80094e:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800950:	b8 0a 00 00 00       	mov    $0xa,%eax
  800955:	bf 55 29 80 00       	mov    $0x802955,%edi
							putch(ch, putdat);
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	53                   	push   %ebx
  80095e:	50                   	push   %eax
  80095f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800961:	83 c7 01             	add    $0x1,%edi
  800964:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800968:	83 c4 10             	add    $0x10,%esp
  80096b:	85 c0                	test   %eax,%eax
  80096d:	75 eb                	jne    80095a <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80096f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800972:	89 45 14             	mov    %eax,0x14(%ebp)
  800975:	e9 ed fe ff ff       	jmp    800867 <vprintfmt+0x446>
			putch(ch, putdat);
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	53                   	push   %ebx
  80097e:	6a 25                	push   $0x25
  800980:	ff d6                	call   *%esi
			break;
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	e9 dd fe ff ff       	jmp    800867 <vprintfmt+0x446>
			putch('%', putdat);
  80098a:	83 ec 08             	sub    $0x8,%esp
  80098d:	53                   	push   %ebx
  80098e:	6a 25                	push   $0x25
  800990:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	89 f8                	mov    %edi,%eax
  800997:	eb 03                	jmp    80099c <vprintfmt+0x57b>
  800999:	83 e8 01             	sub    $0x1,%eax
  80099c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009a0:	75 f7                	jne    800999 <vprintfmt+0x578>
  8009a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009a5:	e9 bd fe ff ff       	jmp    800867 <vprintfmt+0x446>
}
  8009aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009ad:	5b                   	pop    %ebx
  8009ae:	5e                   	pop    %esi
  8009af:	5f                   	pop    %edi
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    

008009b2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	83 ec 18             	sub    $0x18,%esp
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009c1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009c5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009cf:	85 c0                	test   %eax,%eax
  8009d1:	74 26                	je     8009f9 <vsnprintf+0x47>
  8009d3:	85 d2                	test   %edx,%edx
  8009d5:	7e 22                	jle    8009f9 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009d7:	ff 75 14             	pushl  0x14(%ebp)
  8009da:	ff 75 10             	pushl  0x10(%ebp)
  8009dd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009e0:	50                   	push   %eax
  8009e1:	68 e7 03 80 00       	push   $0x8003e7
  8009e6:	e8 36 fa ff ff       	call   800421 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ee:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f4:	83 c4 10             	add    $0x10,%esp
}
  8009f7:	c9                   	leave  
  8009f8:	c3                   	ret    
		return -E_INVAL;
  8009f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009fe:	eb f7                	jmp    8009f7 <vsnprintf+0x45>

00800a00 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a06:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a09:	50                   	push   %eax
  800a0a:	ff 75 10             	pushl  0x10(%ebp)
  800a0d:	ff 75 0c             	pushl  0xc(%ebp)
  800a10:	ff 75 08             	pushl  0x8(%ebp)
  800a13:	e8 9a ff ff ff       	call   8009b2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a18:	c9                   	leave  
  800a19:	c3                   	ret    

00800a1a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a20:	b8 00 00 00 00       	mov    $0x0,%eax
  800a25:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a29:	74 05                	je     800a30 <strlen+0x16>
		n++;
  800a2b:	83 c0 01             	add    $0x1,%eax
  800a2e:	eb f5                	jmp    800a25 <strlen+0xb>
	return n;
}
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a38:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a40:	39 c2                	cmp    %eax,%edx
  800a42:	74 0d                	je     800a51 <strnlen+0x1f>
  800a44:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a48:	74 05                	je     800a4f <strnlen+0x1d>
		n++;
  800a4a:	83 c2 01             	add    $0x1,%edx
  800a4d:	eb f1                	jmp    800a40 <strnlen+0xe>
  800a4f:	89 d0                	mov    %edx,%eax
	return n;
}
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	53                   	push   %ebx
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a62:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a66:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a69:	83 c2 01             	add    $0x1,%edx
  800a6c:	84 c9                	test   %cl,%cl
  800a6e:	75 f2                	jne    800a62 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a70:	5b                   	pop    %ebx
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	53                   	push   %ebx
  800a77:	83 ec 10             	sub    $0x10,%esp
  800a7a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a7d:	53                   	push   %ebx
  800a7e:	e8 97 ff ff ff       	call   800a1a <strlen>
  800a83:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	01 d8                	add    %ebx,%eax
  800a8b:	50                   	push   %eax
  800a8c:	e8 c2 ff ff ff       	call   800a53 <strcpy>
	return dst;
}
  800a91:	89 d8                	mov    %ebx,%eax
  800a93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a96:	c9                   	leave  
  800a97:	c3                   	ret    

00800a98 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	56                   	push   %esi
  800a9c:	53                   	push   %ebx
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa3:	89 c6                	mov    %eax,%esi
  800aa5:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aa8:	89 c2                	mov    %eax,%edx
  800aaa:	39 f2                	cmp    %esi,%edx
  800aac:	74 11                	je     800abf <strncpy+0x27>
		*dst++ = *src;
  800aae:	83 c2 01             	add    $0x1,%edx
  800ab1:	0f b6 19             	movzbl (%ecx),%ebx
  800ab4:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ab7:	80 fb 01             	cmp    $0x1,%bl
  800aba:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800abd:	eb eb                	jmp    800aaa <strncpy+0x12>
	}
	return ret;
}
  800abf:	5b                   	pop    %ebx
  800ac0:	5e                   	pop    %esi
  800ac1:	5d                   	pop    %ebp
  800ac2:	c3                   	ret    

00800ac3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	56                   	push   %esi
  800ac7:	53                   	push   %ebx
  800ac8:	8b 75 08             	mov    0x8(%ebp),%esi
  800acb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ace:	8b 55 10             	mov    0x10(%ebp),%edx
  800ad1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ad3:	85 d2                	test   %edx,%edx
  800ad5:	74 21                	je     800af8 <strlcpy+0x35>
  800ad7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800adb:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800add:	39 c2                	cmp    %eax,%edx
  800adf:	74 14                	je     800af5 <strlcpy+0x32>
  800ae1:	0f b6 19             	movzbl (%ecx),%ebx
  800ae4:	84 db                	test   %bl,%bl
  800ae6:	74 0b                	je     800af3 <strlcpy+0x30>
			*dst++ = *src++;
  800ae8:	83 c1 01             	add    $0x1,%ecx
  800aeb:	83 c2 01             	add    $0x1,%edx
  800aee:	88 5a ff             	mov    %bl,-0x1(%edx)
  800af1:	eb ea                	jmp    800add <strlcpy+0x1a>
  800af3:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800af5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800af8:	29 f0                	sub    %esi,%eax
}
  800afa:	5b                   	pop    %ebx
  800afb:	5e                   	pop    %esi
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b04:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b07:	0f b6 01             	movzbl (%ecx),%eax
  800b0a:	84 c0                	test   %al,%al
  800b0c:	74 0c                	je     800b1a <strcmp+0x1c>
  800b0e:	3a 02                	cmp    (%edx),%al
  800b10:	75 08                	jne    800b1a <strcmp+0x1c>
		p++, q++;
  800b12:	83 c1 01             	add    $0x1,%ecx
  800b15:	83 c2 01             	add    $0x1,%edx
  800b18:	eb ed                	jmp    800b07 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b1a:	0f b6 c0             	movzbl %al,%eax
  800b1d:	0f b6 12             	movzbl (%edx),%edx
  800b20:	29 d0                	sub    %edx,%eax
}
  800b22:	5d                   	pop    %ebp
  800b23:	c3                   	ret    

00800b24 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	53                   	push   %ebx
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2e:	89 c3                	mov    %eax,%ebx
  800b30:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b33:	eb 06                	jmp    800b3b <strncmp+0x17>
		n--, p++, q++;
  800b35:	83 c0 01             	add    $0x1,%eax
  800b38:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b3b:	39 d8                	cmp    %ebx,%eax
  800b3d:	74 16                	je     800b55 <strncmp+0x31>
  800b3f:	0f b6 08             	movzbl (%eax),%ecx
  800b42:	84 c9                	test   %cl,%cl
  800b44:	74 04                	je     800b4a <strncmp+0x26>
  800b46:	3a 0a                	cmp    (%edx),%cl
  800b48:	74 eb                	je     800b35 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4a:	0f b6 00             	movzbl (%eax),%eax
  800b4d:	0f b6 12             	movzbl (%edx),%edx
  800b50:	29 d0                	sub    %edx,%eax
}
  800b52:	5b                   	pop    %ebx
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    
		return 0;
  800b55:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5a:	eb f6                	jmp    800b52 <strncmp+0x2e>

00800b5c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b66:	0f b6 10             	movzbl (%eax),%edx
  800b69:	84 d2                	test   %dl,%dl
  800b6b:	74 09                	je     800b76 <strchr+0x1a>
		if (*s == c)
  800b6d:	38 ca                	cmp    %cl,%dl
  800b6f:	74 0a                	je     800b7b <strchr+0x1f>
	for (; *s; s++)
  800b71:	83 c0 01             	add    $0x1,%eax
  800b74:	eb f0                	jmp    800b66 <strchr+0xa>
			return (char *) s;
	return 0;
  800b76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b87:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b8a:	38 ca                	cmp    %cl,%dl
  800b8c:	74 09                	je     800b97 <strfind+0x1a>
  800b8e:	84 d2                	test   %dl,%dl
  800b90:	74 05                	je     800b97 <strfind+0x1a>
	for (; *s; s++)
  800b92:	83 c0 01             	add    $0x1,%eax
  800b95:	eb f0                	jmp    800b87 <strfind+0xa>
			break;
	return (char *) s;
}
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	57                   	push   %edi
  800b9d:	56                   	push   %esi
  800b9e:	53                   	push   %ebx
  800b9f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ba2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ba5:	85 c9                	test   %ecx,%ecx
  800ba7:	74 31                	je     800bda <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ba9:	89 f8                	mov    %edi,%eax
  800bab:	09 c8                	or     %ecx,%eax
  800bad:	a8 03                	test   $0x3,%al
  800baf:	75 23                	jne    800bd4 <memset+0x3b>
		c &= 0xFF;
  800bb1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb5:	89 d3                	mov    %edx,%ebx
  800bb7:	c1 e3 08             	shl    $0x8,%ebx
  800bba:	89 d0                	mov    %edx,%eax
  800bbc:	c1 e0 18             	shl    $0x18,%eax
  800bbf:	89 d6                	mov    %edx,%esi
  800bc1:	c1 e6 10             	shl    $0x10,%esi
  800bc4:	09 f0                	or     %esi,%eax
  800bc6:	09 c2                	or     %eax,%edx
  800bc8:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bca:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bcd:	89 d0                	mov    %edx,%eax
  800bcf:	fc                   	cld    
  800bd0:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd2:	eb 06                	jmp    800bda <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	fc                   	cld    
  800bd8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bda:	89 f8                	mov    %edi,%eax
  800bdc:	5b                   	pop    %ebx
  800bdd:	5e                   	pop    %esi
  800bde:	5f                   	pop    %edi
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	57                   	push   %edi
  800be5:	56                   	push   %esi
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bec:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bef:	39 c6                	cmp    %eax,%esi
  800bf1:	73 32                	jae    800c25 <memmove+0x44>
  800bf3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bf6:	39 c2                	cmp    %eax,%edx
  800bf8:	76 2b                	jbe    800c25 <memmove+0x44>
		s += n;
		d += n;
  800bfa:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bfd:	89 fe                	mov    %edi,%esi
  800bff:	09 ce                	or     %ecx,%esi
  800c01:	09 d6                	or     %edx,%esi
  800c03:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c09:	75 0e                	jne    800c19 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c0b:	83 ef 04             	sub    $0x4,%edi
  800c0e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c11:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c14:	fd                   	std    
  800c15:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c17:	eb 09                	jmp    800c22 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c19:	83 ef 01             	sub    $0x1,%edi
  800c1c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c1f:	fd                   	std    
  800c20:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c22:	fc                   	cld    
  800c23:	eb 1a                	jmp    800c3f <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c25:	89 c2                	mov    %eax,%edx
  800c27:	09 ca                	or     %ecx,%edx
  800c29:	09 f2                	or     %esi,%edx
  800c2b:	f6 c2 03             	test   $0x3,%dl
  800c2e:	75 0a                	jne    800c3a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c30:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c33:	89 c7                	mov    %eax,%edi
  800c35:	fc                   	cld    
  800c36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c38:	eb 05                	jmp    800c3f <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c3a:	89 c7                	mov    %eax,%edi
  800c3c:	fc                   	cld    
  800c3d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c3f:	5e                   	pop    %esi
  800c40:	5f                   	pop    %edi
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c49:	ff 75 10             	pushl  0x10(%ebp)
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	ff 75 08             	pushl  0x8(%ebp)
  800c52:	e8 8a ff ff ff       	call   800be1 <memmove>
}
  800c57:	c9                   	leave  
  800c58:	c3                   	ret    

00800c59 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	56                   	push   %esi
  800c5d:	53                   	push   %ebx
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c64:	89 c6                	mov    %eax,%esi
  800c66:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c69:	39 f0                	cmp    %esi,%eax
  800c6b:	74 1c                	je     800c89 <memcmp+0x30>
		if (*s1 != *s2)
  800c6d:	0f b6 08             	movzbl (%eax),%ecx
  800c70:	0f b6 1a             	movzbl (%edx),%ebx
  800c73:	38 d9                	cmp    %bl,%cl
  800c75:	75 08                	jne    800c7f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c77:	83 c0 01             	add    $0x1,%eax
  800c7a:	83 c2 01             	add    $0x1,%edx
  800c7d:	eb ea                	jmp    800c69 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c7f:	0f b6 c1             	movzbl %cl,%eax
  800c82:	0f b6 db             	movzbl %bl,%ebx
  800c85:	29 d8                	sub    %ebx,%eax
  800c87:	eb 05                	jmp    800c8e <memcmp+0x35>
	}

	return 0;
  800c89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c8e:	5b                   	pop    %ebx
  800c8f:	5e                   	pop    %esi
  800c90:	5d                   	pop    %ebp
  800c91:	c3                   	ret    

00800c92 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c9b:	89 c2                	mov    %eax,%edx
  800c9d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ca0:	39 d0                	cmp    %edx,%eax
  800ca2:	73 09                	jae    800cad <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ca4:	38 08                	cmp    %cl,(%eax)
  800ca6:	74 05                	je     800cad <memfind+0x1b>
	for (; s < ends; s++)
  800ca8:	83 c0 01             	add    $0x1,%eax
  800cab:	eb f3                	jmp    800ca0 <memfind+0xe>
			break;
	return (void *) s;
}
  800cad:	5d                   	pop    %ebp
  800cae:	c3                   	ret    

00800caf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	57                   	push   %edi
  800cb3:	56                   	push   %esi
  800cb4:	53                   	push   %ebx
  800cb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cbb:	eb 03                	jmp    800cc0 <strtol+0x11>
		s++;
  800cbd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cc0:	0f b6 01             	movzbl (%ecx),%eax
  800cc3:	3c 20                	cmp    $0x20,%al
  800cc5:	74 f6                	je     800cbd <strtol+0xe>
  800cc7:	3c 09                	cmp    $0x9,%al
  800cc9:	74 f2                	je     800cbd <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ccb:	3c 2b                	cmp    $0x2b,%al
  800ccd:	74 2a                	je     800cf9 <strtol+0x4a>
	int neg = 0;
  800ccf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cd4:	3c 2d                	cmp    $0x2d,%al
  800cd6:	74 2b                	je     800d03 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cd8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cde:	75 0f                	jne    800cef <strtol+0x40>
  800ce0:	80 39 30             	cmpb   $0x30,(%ecx)
  800ce3:	74 28                	je     800d0d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ce5:	85 db                	test   %ebx,%ebx
  800ce7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cec:	0f 44 d8             	cmove  %eax,%ebx
  800cef:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cf7:	eb 50                	jmp    800d49 <strtol+0x9a>
		s++;
  800cf9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cfc:	bf 00 00 00 00       	mov    $0x0,%edi
  800d01:	eb d5                	jmp    800cd8 <strtol+0x29>
		s++, neg = 1;
  800d03:	83 c1 01             	add    $0x1,%ecx
  800d06:	bf 01 00 00 00       	mov    $0x1,%edi
  800d0b:	eb cb                	jmp    800cd8 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d0d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d11:	74 0e                	je     800d21 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d13:	85 db                	test   %ebx,%ebx
  800d15:	75 d8                	jne    800cef <strtol+0x40>
		s++, base = 8;
  800d17:	83 c1 01             	add    $0x1,%ecx
  800d1a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d1f:	eb ce                	jmp    800cef <strtol+0x40>
		s += 2, base = 16;
  800d21:	83 c1 02             	add    $0x2,%ecx
  800d24:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d29:	eb c4                	jmp    800cef <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d2b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d2e:	89 f3                	mov    %esi,%ebx
  800d30:	80 fb 19             	cmp    $0x19,%bl
  800d33:	77 29                	ja     800d5e <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d35:	0f be d2             	movsbl %dl,%edx
  800d38:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d3b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d3e:	7d 30                	jge    800d70 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d40:	83 c1 01             	add    $0x1,%ecx
  800d43:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d47:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d49:	0f b6 11             	movzbl (%ecx),%edx
  800d4c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d4f:	89 f3                	mov    %esi,%ebx
  800d51:	80 fb 09             	cmp    $0x9,%bl
  800d54:	77 d5                	ja     800d2b <strtol+0x7c>
			dig = *s - '0';
  800d56:	0f be d2             	movsbl %dl,%edx
  800d59:	83 ea 30             	sub    $0x30,%edx
  800d5c:	eb dd                	jmp    800d3b <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d5e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d61:	89 f3                	mov    %esi,%ebx
  800d63:	80 fb 19             	cmp    $0x19,%bl
  800d66:	77 08                	ja     800d70 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d68:	0f be d2             	movsbl %dl,%edx
  800d6b:	83 ea 37             	sub    $0x37,%edx
  800d6e:	eb cb                	jmp    800d3b <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d74:	74 05                	je     800d7b <strtol+0xcc>
		*endptr = (char *) s;
  800d76:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d79:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d7b:	89 c2                	mov    %eax,%edx
  800d7d:	f7 da                	neg    %edx
  800d7f:	85 ff                	test   %edi,%edi
  800d81:	0f 45 c2             	cmovne %edx,%eax
}
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5f                   	pop    %edi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    

00800d89 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	57                   	push   %edi
  800d8d:	56                   	push   %esi
  800d8e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d94:	8b 55 08             	mov    0x8(%ebp),%edx
  800d97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9a:	89 c3                	mov    %eax,%ebx
  800d9c:	89 c7                	mov    %eax,%edi
  800d9e:	89 c6                	mov    %eax,%esi
  800da0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800da2:	5b                   	pop    %ebx
  800da3:	5e                   	pop    %esi
  800da4:	5f                   	pop    %edi
  800da5:	5d                   	pop    %ebp
  800da6:	c3                   	ret    

00800da7 <sys_cgetc>:

int
sys_cgetc(void)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	57                   	push   %edi
  800dab:	56                   	push   %esi
  800dac:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dad:	ba 00 00 00 00       	mov    $0x0,%edx
  800db2:	b8 01 00 00 00       	mov    $0x1,%eax
  800db7:	89 d1                	mov    %edx,%ecx
  800db9:	89 d3                	mov    %edx,%ebx
  800dbb:	89 d7                	mov    %edx,%edi
  800dbd:	89 d6                	mov    %edx,%esi
  800dbf:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dc1:	5b                   	pop    %ebx
  800dc2:	5e                   	pop    %esi
  800dc3:	5f                   	pop    %edi
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    

00800dc6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	57                   	push   %edi
  800dca:	56                   	push   %esi
  800dcb:	53                   	push   %ebx
  800dcc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd7:	b8 03 00 00 00       	mov    $0x3,%eax
  800ddc:	89 cb                	mov    %ecx,%ebx
  800dde:	89 cf                	mov    %ecx,%edi
  800de0:	89 ce                	mov    %ecx,%esi
  800de2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de4:	85 c0                	test   %eax,%eax
  800de6:	7f 08                	jg     800df0 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800deb:	5b                   	pop    %ebx
  800dec:	5e                   	pop    %esi
  800ded:	5f                   	pop    %edi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df0:	83 ec 0c             	sub    $0xc,%esp
  800df3:	50                   	push   %eax
  800df4:	6a 03                	push   $0x3
  800df6:	68 68 2b 80 00       	push   $0x802b68
  800dfb:	6a 43                	push   $0x43
  800dfd:	68 85 2b 80 00       	push   $0x802b85
  800e02:	e8 f7 f3 ff ff       	call   8001fe <_panic>

00800e07 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	57                   	push   %edi
  800e0b:	56                   	push   %esi
  800e0c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e12:	b8 02 00 00 00       	mov    $0x2,%eax
  800e17:	89 d1                	mov    %edx,%ecx
  800e19:	89 d3                	mov    %edx,%ebx
  800e1b:	89 d7                	mov    %edx,%edi
  800e1d:	89 d6                	mov    %edx,%esi
  800e1f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e21:	5b                   	pop    %ebx
  800e22:	5e                   	pop    %esi
  800e23:	5f                   	pop    %edi
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    

00800e26 <sys_yield>:

void
sys_yield(void)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	57                   	push   %edi
  800e2a:	56                   	push   %esi
  800e2b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e31:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e36:	89 d1                	mov    %edx,%ecx
  800e38:	89 d3                	mov    %edx,%ebx
  800e3a:	89 d7                	mov    %edx,%edi
  800e3c:	89 d6                	mov    %edx,%esi
  800e3e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e40:	5b                   	pop    %ebx
  800e41:	5e                   	pop    %esi
  800e42:	5f                   	pop    %edi
  800e43:	5d                   	pop    %ebp
  800e44:	c3                   	ret    

00800e45 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	57                   	push   %edi
  800e49:	56                   	push   %esi
  800e4a:	53                   	push   %ebx
  800e4b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4e:	be 00 00 00 00       	mov    $0x0,%esi
  800e53:	8b 55 08             	mov    0x8(%ebp),%edx
  800e56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e59:	b8 04 00 00 00       	mov    $0x4,%eax
  800e5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e61:	89 f7                	mov    %esi,%edi
  800e63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e65:	85 c0                	test   %eax,%eax
  800e67:	7f 08                	jg     800e71 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6c:	5b                   	pop    %ebx
  800e6d:	5e                   	pop    %esi
  800e6e:	5f                   	pop    %edi
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e71:	83 ec 0c             	sub    $0xc,%esp
  800e74:	50                   	push   %eax
  800e75:	6a 04                	push   $0x4
  800e77:	68 68 2b 80 00       	push   $0x802b68
  800e7c:	6a 43                	push   $0x43
  800e7e:	68 85 2b 80 00       	push   $0x802b85
  800e83:	e8 76 f3 ff ff       	call   8001fe <_panic>

00800e88 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	57                   	push   %edi
  800e8c:	56                   	push   %esi
  800e8d:	53                   	push   %ebx
  800e8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e91:	8b 55 08             	mov    0x8(%ebp),%edx
  800e94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e97:	b8 05 00 00 00       	mov    $0x5,%eax
  800e9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ea2:	8b 75 18             	mov    0x18(%ebp),%esi
  800ea5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea7:	85 c0                	test   %eax,%eax
  800ea9:	7f 08                	jg     800eb3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800eab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eae:	5b                   	pop    %ebx
  800eaf:	5e                   	pop    %esi
  800eb0:	5f                   	pop    %edi
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb3:	83 ec 0c             	sub    $0xc,%esp
  800eb6:	50                   	push   %eax
  800eb7:	6a 05                	push   $0x5
  800eb9:	68 68 2b 80 00       	push   $0x802b68
  800ebe:	6a 43                	push   $0x43
  800ec0:	68 85 2b 80 00       	push   $0x802b85
  800ec5:	e8 34 f3 ff ff       	call   8001fe <_panic>

00800eca <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	57                   	push   %edi
  800ece:	56                   	push   %esi
  800ecf:	53                   	push   %ebx
  800ed0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed8:	8b 55 08             	mov    0x8(%ebp),%edx
  800edb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ede:	b8 06 00 00 00       	mov    $0x6,%eax
  800ee3:	89 df                	mov    %ebx,%edi
  800ee5:	89 de                	mov    %ebx,%esi
  800ee7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee9:	85 c0                	test   %eax,%eax
  800eeb:	7f 08                	jg     800ef5 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef0:	5b                   	pop    %ebx
  800ef1:	5e                   	pop    %esi
  800ef2:	5f                   	pop    %edi
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef5:	83 ec 0c             	sub    $0xc,%esp
  800ef8:	50                   	push   %eax
  800ef9:	6a 06                	push   $0x6
  800efb:	68 68 2b 80 00       	push   $0x802b68
  800f00:	6a 43                	push   $0x43
  800f02:	68 85 2b 80 00       	push   $0x802b85
  800f07:	e8 f2 f2 ff ff       	call   8001fe <_panic>

00800f0c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	57                   	push   %edi
  800f10:	56                   	push   %esi
  800f11:	53                   	push   %ebx
  800f12:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f15:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f20:	b8 08 00 00 00       	mov    $0x8,%eax
  800f25:	89 df                	mov    %ebx,%edi
  800f27:	89 de                	mov    %ebx,%esi
  800f29:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	7f 08                	jg     800f37 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f32:	5b                   	pop    %ebx
  800f33:	5e                   	pop    %esi
  800f34:	5f                   	pop    %edi
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f37:	83 ec 0c             	sub    $0xc,%esp
  800f3a:	50                   	push   %eax
  800f3b:	6a 08                	push   $0x8
  800f3d:	68 68 2b 80 00       	push   $0x802b68
  800f42:	6a 43                	push   $0x43
  800f44:	68 85 2b 80 00       	push   $0x802b85
  800f49:	e8 b0 f2 ff ff       	call   8001fe <_panic>

00800f4e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	57                   	push   %edi
  800f52:	56                   	push   %esi
  800f53:	53                   	push   %ebx
  800f54:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f57:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f62:	b8 09 00 00 00       	mov    $0x9,%eax
  800f67:	89 df                	mov    %ebx,%edi
  800f69:	89 de                	mov    %ebx,%esi
  800f6b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	7f 08                	jg     800f79 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f79:	83 ec 0c             	sub    $0xc,%esp
  800f7c:	50                   	push   %eax
  800f7d:	6a 09                	push   $0x9
  800f7f:	68 68 2b 80 00       	push   $0x802b68
  800f84:	6a 43                	push   $0x43
  800f86:	68 85 2b 80 00       	push   $0x802b85
  800f8b:	e8 6e f2 ff ff       	call   8001fe <_panic>

00800f90 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	57                   	push   %edi
  800f94:	56                   	push   %esi
  800f95:	53                   	push   %ebx
  800f96:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fa9:	89 df                	mov    %ebx,%edi
  800fab:	89 de                	mov    %ebx,%esi
  800fad:	cd 30                	int    $0x30
	if(check && ret > 0)
  800faf:	85 c0                	test   %eax,%eax
  800fb1:	7f 08                	jg     800fbb <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb6:	5b                   	pop    %ebx
  800fb7:	5e                   	pop    %esi
  800fb8:	5f                   	pop    %edi
  800fb9:	5d                   	pop    %ebp
  800fba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbb:	83 ec 0c             	sub    $0xc,%esp
  800fbe:	50                   	push   %eax
  800fbf:	6a 0a                	push   $0xa
  800fc1:	68 68 2b 80 00       	push   $0x802b68
  800fc6:	6a 43                	push   $0x43
  800fc8:	68 85 2b 80 00       	push   $0x802b85
  800fcd:	e8 2c f2 ff ff       	call   8001fe <_panic>

00800fd2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	57                   	push   %edi
  800fd6:	56                   	push   %esi
  800fd7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fde:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fe3:	be 00 00 00 00       	mov    $0x0,%esi
  800fe8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800feb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fee:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ff0:	5b                   	pop    %ebx
  800ff1:	5e                   	pop    %esi
  800ff2:	5f                   	pop    %edi
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    

00800ff5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
  800ff8:	57                   	push   %edi
  800ff9:	56                   	push   %esi
  800ffa:	53                   	push   %ebx
  800ffb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ffe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801003:	8b 55 08             	mov    0x8(%ebp),%edx
  801006:	b8 0d 00 00 00       	mov    $0xd,%eax
  80100b:	89 cb                	mov    %ecx,%ebx
  80100d:	89 cf                	mov    %ecx,%edi
  80100f:	89 ce                	mov    %ecx,%esi
  801011:	cd 30                	int    $0x30
	if(check && ret > 0)
  801013:	85 c0                	test   %eax,%eax
  801015:	7f 08                	jg     80101f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801017:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80101a:	5b                   	pop    %ebx
  80101b:	5e                   	pop    %esi
  80101c:	5f                   	pop    %edi
  80101d:	5d                   	pop    %ebp
  80101e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80101f:	83 ec 0c             	sub    $0xc,%esp
  801022:	50                   	push   %eax
  801023:	6a 0d                	push   $0xd
  801025:	68 68 2b 80 00       	push   $0x802b68
  80102a:	6a 43                	push   $0x43
  80102c:	68 85 2b 80 00       	push   $0x802b85
  801031:	e8 c8 f1 ff ff       	call   8001fe <_panic>

00801036 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	57                   	push   %edi
  80103a:	56                   	push   %esi
  80103b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80103c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801041:	8b 55 08             	mov    0x8(%ebp),%edx
  801044:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801047:	b8 0e 00 00 00       	mov    $0xe,%eax
  80104c:	89 df                	mov    %ebx,%edi
  80104e:	89 de                	mov    %ebx,%esi
  801050:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801052:	5b                   	pop    %ebx
  801053:	5e                   	pop    %esi
  801054:	5f                   	pop    %edi
  801055:	5d                   	pop    %ebp
  801056:	c3                   	ret    

00801057 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	57                   	push   %edi
  80105b:	56                   	push   %esi
  80105c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80105d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801062:	8b 55 08             	mov    0x8(%ebp),%edx
  801065:	b8 0f 00 00 00       	mov    $0xf,%eax
  80106a:	89 cb                	mov    %ecx,%ebx
  80106c:	89 cf                	mov    %ecx,%edi
  80106e:	89 ce                	mov    %ecx,%esi
  801070:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801072:	5b                   	pop    %ebx
  801073:	5e                   	pop    %esi
  801074:	5f                   	pop    %edi
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	57                   	push   %edi
  80107b:	56                   	push   %esi
  80107c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80107d:	ba 00 00 00 00       	mov    $0x0,%edx
  801082:	b8 10 00 00 00       	mov    $0x10,%eax
  801087:	89 d1                	mov    %edx,%ecx
  801089:	89 d3                	mov    %edx,%ebx
  80108b:	89 d7                	mov    %edx,%edi
  80108d:	89 d6                	mov    %edx,%esi
  80108f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801091:	5b                   	pop    %ebx
  801092:	5e                   	pop    %esi
  801093:	5f                   	pop    %edi
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    

00801096 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	57                   	push   %edi
  80109a:	56                   	push   %esi
  80109b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80109c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a7:	b8 11 00 00 00       	mov    $0x11,%eax
  8010ac:	89 df                	mov    %ebx,%edi
  8010ae:	89 de                	mov    %ebx,%esi
  8010b0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010b2:	5b                   	pop    %ebx
  8010b3:	5e                   	pop    %esi
  8010b4:	5f                   	pop    %edi
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    

008010b7 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	57                   	push   %edi
  8010bb:	56                   	push   %esi
  8010bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c8:	b8 12 00 00 00       	mov    $0x12,%eax
  8010cd:	89 df                	mov    %ebx,%edi
  8010cf:	89 de                	mov    %ebx,%esi
  8010d1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010d3:	5b                   	pop    %ebx
  8010d4:	5e                   	pop    %esi
  8010d5:	5f                   	pop    %edi
  8010d6:	5d                   	pop    %ebp
  8010d7:	c3                   	ret    

008010d8 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010d8:	55                   	push   %ebp
  8010d9:	89 e5                	mov    %esp,%ebp
  8010db:	57                   	push   %edi
  8010dc:	56                   	push   %esi
  8010dd:	53                   	push   %ebx
  8010de:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ec:	b8 13 00 00 00       	mov    $0x13,%eax
  8010f1:	89 df                	mov    %ebx,%edi
  8010f3:	89 de                	mov    %ebx,%esi
  8010f5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	7f 08                	jg     801103 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010fe:	5b                   	pop    %ebx
  8010ff:	5e                   	pop    %esi
  801100:	5f                   	pop    %edi
  801101:	5d                   	pop    %ebp
  801102:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801103:	83 ec 0c             	sub    $0xc,%esp
  801106:	50                   	push   %eax
  801107:	6a 13                	push   $0x13
  801109:	68 68 2b 80 00       	push   $0x802b68
  80110e:	6a 43                	push   $0x43
  801110:	68 85 2b 80 00       	push   $0x802b85
  801115:	e8 e4 f0 ff ff       	call   8001fe <_panic>

0080111a <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	57                   	push   %edi
  80111e:	56                   	push   %esi
  80111f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801120:	b9 00 00 00 00       	mov    $0x0,%ecx
  801125:	8b 55 08             	mov    0x8(%ebp),%edx
  801128:	b8 14 00 00 00       	mov    $0x14,%eax
  80112d:	89 cb                	mov    %ecx,%ebx
  80112f:	89 cf                	mov    %ecx,%edi
  801131:	89 ce                	mov    %ecx,%esi
  801133:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801135:	5b                   	pop    %ebx
  801136:	5e                   	pop    %esi
  801137:	5f                   	pop    %edi
  801138:	5d                   	pop    %ebp
  801139:	c3                   	ret    

0080113a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	05 00 00 00 30       	add    $0x30000000,%eax
  801145:	c1 e8 0c             	shr    $0xc,%eax
}
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    

0080114a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801155:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80115a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80115f:	5d                   	pop    %ebp
  801160:	c3                   	ret    

00801161 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
  801164:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801169:	89 c2                	mov    %eax,%edx
  80116b:	c1 ea 16             	shr    $0x16,%edx
  80116e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801175:	f6 c2 01             	test   $0x1,%dl
  801178:	74 2d                	je     8011a7 <fd_alloc+0x46>
  80117a:	89 c2                	mov    %eax,%edx
  80117c:	c1 ea 0c             	shr    $0xc,%edx
  80117f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801186:	f6 c2 01             	test   $0x1,%dl
  801189:	74 1c                	je     8011a7 <fd_alloc+0x46>
  80118b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801190:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801195:	75 d2                	jne    801169 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011a0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011a5:	eb 0a                	jmp    8011b1 <fd_alloc+0x50>
			*fd_store = fd;
  8011a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011aa:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b1:	5d                   	pop    %ebp
  8011b2:	c3                   	ret    

008011b3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011b9:	83 f8 1f             	cmp    $0x1f,%eax
  8011bc:	77 30                	ja     8011ee <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011be:	c1 e0 0c             	shl    $0xc,%eax
  8011c1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011c6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011cc:	f6 c2 01             	test   $0x1,%dl
  8011cf:	74 24                	je     8011f5 <fd_lookup+0x42>
  8011d1:	89 c2                	mov    %eax,%edx
  8011d3:	c1 ea 0c             	shr    $0xc,%edx
  8011d6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011dd:	f6 c2 01             	test   $0x1,%dl
  8011e0:	74 1a                	je     8011fc <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e5:	89 02                	mov    %eax,(%edx)
	return 0;
  8011e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ec:	5d                   	pop    %ebp
  8011ed:	c3                   	ret    
		return -E_INVAL;
  8011ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f3:	eb f7                	jmp    8011ec <fd_lookup+0x39>
		return -E_INVAL;
  8011f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011fa:	eb f0                	jmp    8011ec <fd_lookup+0x39>
  8011fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801201:	eb e9                	jmp    8011ec <fd_lookup+0x39>

00801203 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	83 ec 08             	sub    $0x8,%esp
  801209:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80120c:	ba 00 00 00 00       	mov    $0x0,%edx
  801211:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801216:	39 08                	cmp    %ecx,(%eax)
  801218:	74 38                	je     801252 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80121a:	83 c2 01             	add    $0x1,%edx
  80121d:	8b 04 95 14 2c 80 00 	mov    0x802c14(,%edx,4),%eax
  801224:	85 c0                	test   %eax,%eax
  801226:	75 ee                	jne    801216 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801228:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80122d:	8b 40 48             	mov    0x48(%eax),%eax
  801230:	83 ec 04             	sub    $0x4,%esp
  801233:	51                   	push   %ecx
  801234:	50                   	push   %eax
  801235:	68 94 2b 80 00       	push   $0x802b94
  80123a:	e8 b5 f0 ff ff       	call   8002f4 <cprintf>
	*dev = 0;
  80123f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801242:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801248:	83 c4 10             	add    $0x10,%esp
  80124b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801250:	c9                   	leave  
  801251:	c3                   	ret    
			*dev = devtab[i];
  801252:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801255:	89 01                	mov    %eax,(%ecx)
			return 0;
  801257:	b8 00 00 00 00       	mov    $0x0,%eax
  80125c:	eb f2                	jmp    801250 <dev_lookup+0x4d>

0080125e <fd_close>:
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	57                   	push   %edi
  801262:	56                   	push   %esi
  801263:	53                   	push   %ebx
  801264:	83 ec 24             	sub    $0x24,%esp
  801267:	8b 75 08             	mov    0x8(%ebp),%esi
  80126a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80126d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801270:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801271:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801277:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80127a:	50                   	push   %eax
  80127b:	e8 33 ff ff ff       	call   8011b3 <fd_lookup>
  801280:	89 c3                	mov    %eax,%ebx
  801282:	83 c4 10             	add    $0x10,%esp
  801285:	85 c0                	test   %eax,%eax
  801287:	78 05                	js     80128e <fd_close+0x30>
	    || fd != fd2)
  801289:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80128c:	74 16                	je     8012a4 <fd_close+0x46>
		return (must_exist ? r : 0);
  80128e:	89 f8                	mov    %edi,%eax
  801290:	84 c0                	test   %al,%al
  801292:	b8 00 00 00 00       	mov    $0x0,%eax
  801297:	0f 44 d8             	cmove  %eax,%ebx
}
  80129a:	89 d8                	mov    %ebx,%eax
  80129c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80129f:	5b                   	pop    %ebx
  8012a0:	5e                   	pop    %esi
  8012a1:	5f                   	pop    %edi
  8012a2:	5d                   	pop    %ebp
  8012a3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012a4:	83 ec 08             	sub    $0x8,%esp
  8012a7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012aa:	50                   	push   %eax
  8012ab:	ff 36                	pushl  (%esi)
  8012ad:	e8 51 ff ff ff       	call   801203 <dev_lookup>
  8012b2:	89 c3                	mov    %eax,%ebx
  8012b4:	83 c4 10             	add    $0x10,%esp
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	78 1a                	js     8012d5 <fd_close+0x77>
		if (dev->dev_close)
  8012bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012be:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	74 0b                	je     8012d5 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012ca:	83 ec 0c             	sub    $0xc,%esp
  8012cd:	56                   	push   %esi
  8012ce:	ff d0                	call   *%eax
  8012d0:	89 c3                	mov    %eax,%ebx
  8012d2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012d5:	83 ec 08             	sub    $0x8,%esp
  8012d8:	56                   	push   %esi
  8012d9:	6a 00                	push   $0x0
  8012db:	e8 ea fb ff ff       	call   800eca <sys_page_unmap>
	return r;
  8012e0:	83 c4 10             	add    $0x10,%esp
  8012e3:	eb b5                	jmp    80129a <fd_close+0x3c>

008012e5 <close>:

int
close(int fdnum)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ee:	50                   	push   %eax
  8012ef:	ff 75 08             	pushl  0x8(%ebp)
  8012f2:	e8 bc fe ff ff       	call   8011b3 <fd_lookup>
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	79 02                	jns    801300 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    
		return fd_close(fd, 1);
  801300:	83 ec 08             	sub    $0x8,%esp
  801303:	6a 01                	push   $0x1
  801305:	ff 75 f4             	pushl  -0xc(%ebp)
  801308:	e8 51 ff ff ff       	call   80125e <fd_close>
  80130d:	83 c4 10             	add    $0x10,%esp
  801310:	eb ec                	jmp    8012fe <close+0x19>

00801312 <close_all>:

void
close_all(void)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	53                   	push   %ebx
  801316:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801319:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80131e:	83 ec 0c             	sub    $0xc,%esp
  801321:	53                   	push   %ebx
  801322:	e8 be ff ff ff       	call   8012e5 <close>
	for (i = 0; i < MAXFD; i++)
  801327:	83 c3 01             	add    $0x1,%ebx
  80132a:	83 c4 10             	add    $0x10,%esp
  80132d:	83 fb 20             	cmp    $0x20,%ebx
  801330:	75 ec                	jne    80131e <close_all+0xc>
}
  801332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	57                   	push   %edi
  80133b:	56                   	push   %esi
  80133c:	53                   	push   %ebx
  80133d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801340:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801343:	50                   	push   %eax
  801344:	ff 75 08             	pushl  0x8(%ebp)
  801347:	e8 67 fe ff ff       	call   8011b3 <fd_lookup>
  80134c:	89 c3                	mov    %eax,%ebx
  80134e:	83 c4 10             	add    $0x10,%esp
  801351:	85 c0                	test   %eax,%eax
  801353:	0f 88 81 00 00 00    	js     8013da <dup+0xa3>
		return r;
	close(newfdnum);
  801359:	83 ec 0c             	sub    $0xc,%esp
  80135c:	ff 75 0c             	pushl  0xc(%ebp)
  80135f:	e8 81 ff ff ff       	call   8012e5 <close>

	newfd = INDEX2FD(newfdnum);
  801364:	8b 75 0c             	mov    0xc(%ebp),%esi
  801367:	c1 e6 0c             	shl    $0xc,%esi
  80136a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801370:	83 c4 04             	add    $0x4,%esp
  801373:	ff 75 e4             	pushl  -0x1c(%ebp)
  801376:	e8 cf fd ff ff       	call   80114a <fd2data>
  80137b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80137d:	89 34 24             	mov    %esi,(%esp)
  801380:	e8 c5 fd ff ff       	call   80114a <fd2data>
  801385:	83 c4 10             	add    $0x10,%esp
  801388:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80138a:	89 d8                	mov    %ebx,%eax
  80138c:	c1 e8 16             	shr    $0x16,%eax
  80138f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801396:	a8 01                	test   $0x1,%al
  801398:	74 11                	je     8013ab <dup+0x74>
  80139a:	89 d8                	mov    %ebx,%eax
  80139c:	c1 e8 0c             	shr    $0xc,%eax
  80139f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013a6:	f6 c2 01             	test   $0x1,%dl
  8013a9:	75 39                	jne    8013e4 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013ae:	89 d0                	mov    %edx,%eax
  8013b0:	c1 e8 0c             	shr    $0xc,%eax
  8013b3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013ba:	83 ec 0c             	sub    $0xc,%esp
  8013bd:	25 07 0e 00 00       	and    $0xe07,%eax
  8013c2:	50                   	push   %eax
  8013c3:	56                   	push   %esi
  8013c4:	6a 00                	push   $0x0
  8013c6:	52                   	push   %edx
  8013c7:	6a 00                	push   $0x0
  8013c9:	e8 ba fa ff ff       	call   800e88 <sys_page_map>
  8013ce:	89 c3                	mov    %eax,%ebx
  8013d0:	83 c4 20             	add    $0x20,%esp
  8013d3:	85 c0                	test   %eax,%eax
  8013d5:	78 31                	js     801408 <dup+0xd1>
		goto err;

	return newfdnum;
  8013d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013da:	89 d8                	mov    %ebx,%eax
  8013dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013df:	5b                   	pop    %ebx
  8013e0:	5e                   	pop    %esi
  8013e1:	5f                   	pop    %edi
  8013e2:	5d                   	pop    %ebp
  8013e3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013e4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013eb:	83 ec 0c             	sub    $0xc,%esp
  8013ee:	25 07 0e 00 00       	and    $0xe07,%eax
  8013f3:	50                   	push   %eax
  8013f4:	57                   	push   %edi
  8013f5:	6a 00                	push   $0x0
  8013f7:	53                   	push   %ebx
  8013f8:	6a 00                	push   $0x0
  8013fa:	e8 89 fa ff ff       	call   800e88 <sys_page_map>
  8013ff:	89 c3                	mov    %eax,%ebx
  801401:	83 c4 20             	add    $0x20,%esp
  801404:	85 c0                	test   %eax,%eax
  801406:	79 a3                	jns    8013ab <dup+0x74>
	sys_page_unmap(0, newfd);
  801408:	83 ec 08             	sub    $0x8,%esp
  80140b:	56                   	push   %esi
  80140c:	6a 00                	push   $0x0
  80140e:	e8 b7 fa ff ff       	call   800eca <sys_page_unmap>
	sys_page_unmap(0, nva);
  801413:	83 c4 08             	add    $0x8,%esp
  801416:	57                   	push   %edi
  801417:	6a 00                	push   $0x0
  801419:	e8 ac fa ff ff       	call   800eca <sys_page_unmap>
	return r;
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	eb b7                	jmp    8013da <dup+0xa3>

00801423 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
  801426:	53                   	push   %ebx
  801427:	83 ec 1c             	sub    $0x1c,%esp
  80142a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801430:	50                   	push   %eax
  801431:	53                   	push   %ebx
  801432:	e8 7c fd ff ff       	call   8011b3 <fd_lookup>
  801437:	83 c4 10             	add    $0x10,%esp
  80143a:	85 c0                	test   %eax,%eax
  80143c:	78 3f                	js     80147d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143e:	83 ec 08             	sub    $0x8,%esp
  801441:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801444:	50                   	push   %eax
  801445:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801448:	ff 30                	pushl  (%eax)
  80144a:	e8 b4 fd ff ff       	call   801203 <dev_lookup>
  80144f:	83 c4 10             	add    $0x10,%esp
  801452:	85 c0                	test   %eax,%eax
  801454:	78 27                	js     80147d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801456:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801459:	8b 42 08             	mov    0x8(%edx),%eax
  80145c:	83 e0 03             	and    $0x3,%eax
  80145f:	83 f8 01             	cmp    $0x1,%eax
  801462:	74 1e                	je     801482 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801467:	8b 40 08             	mov    0x8(%eax),%eax
  80146a:	85 c0                	test   %eax,%eax
  80146c:	74 35                	je     8014a3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80146e:	83 ec 04             	sub    $0x4,%esp
  801471:	ff 75 10             	pushl  0x10(%ebp)
  801474:	ff 75 0c             	pushl  0xc(%ebp)
  801477:	52                   	push   %edx
  801478:	ff d0                	call   *%eax
  80147a:	83 c4 10             	add    $0x10,%esp
}
  80147d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801480:	c9                   	leave  
  801481:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801482:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801487:	8b 40 48             	mov    0x48(%eax),%eax
  80148a:	83 ec 04             	sub    $0x4,%esp
  80148d:	53                   	push   %ebx
  80148e:	50                   	push   %eax
  80148f:	68 d8 2b 80 00       	push   $0x802bd8
  801494:	e8 5b ee ff ff       	call   8002f4 <cprintf>
		return -E_INVAL;
  801499:	83 c4 10             	add    $0x10,%esp
  80149c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a1:	eb da                	jmp    80147d <read+0x5a>
		return -E_NOT_SUPP;
  8014a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a8:	eb d3                	jmp    80147d <read+0x5a>

008014aa <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	57                   	push   %edi
  8014ae:	56                   	push   %esi
  8014af:	53                   	push   %ebx
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014b6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014be:	39 f3                	cmp    %esi,%ebx
  8014c0:	73 23                	jae    8014e5 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014c2:	83 ec 04             	sub    $0x4,%esp
  8014c5:	89 f0                	mov    %esi,%eax
  8014c7:	29 d8                	sub    %ebx,%eax
  8014c9:	50                   	push   %eax
  8014ca:	89 d8                	mov    %ebx,%eax
  8014cc:	03 45 0c             	add    0xc(%ebp),%eax
  8014cf:	50                   	push   %eax
  8014d0:	57                   	push   %edi
  8014d1:	e8 4d ff ff ff       	call   801423 <read>
		if (m < 0)
  8014d6:	83 c4 10             	add    $0x10,%esp
  8014d9:	85 c0                	test   %eax,%eax
  8014db:	78 06                	js     8014e3 <readn+0x39>
			return m;
		if (m == 0)
  8014dd:	74 06                	je     8014e5 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014df:	01 c3                	add    %eax,%ebx
  8014e1:	eb db                	jmp    8014be <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014e3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014e5:	89 d8                	mov    %ebx,%eax
  8014e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014ea:	5b                   	pop    %ebx
  8014eb:	5e                   	pop    %esi
  8014ec:	5f                   	pop    %edi
  8014ed:	5d                   	pop    %ebp
  8014ee:	c3                   	ret    

008014ef <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	53                   	push   %ebx
  8014f3:	83 ec 1c             	sub    $0x1c,%esp
  8014f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014fc:	50                   	push   %eax
  8014fd:	53                   	push   %ebx
  8014fe:	e8 b0 fc ff ff       	call   8011b3 <fd_lookup>
  801503:	83 c4 10             	add    $0x10,%esp
  801506:	85 c0                	test   %eax,%eax
  801508:	78 3a                	js     801544 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150a:	83 ec 08             	sub    $0x8,%esp
  80150d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801510:	50                   	push   %eax
  801511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801514:	ff 30                	pushl  (%eax)
  801516:	e8 e8 fc ff ff       	call   801203 <dev_lookup>
  80151b:	83 c4 10             	add    $0x10,%esp
  80151e:	85 c0                	test   %eax,%eax
  801520:	78 22                	js     801544 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801525:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801529:	74 1e                	je     801549 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80152b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80152e:	8b 52 0c             	mov    0xc(%edx),%edx
  801531:	85 d2                	test   %edx,%edx
  801533:	74 35                	je     80156a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801535:	83 ec 04             	sub    $0x4,%esp
  801538:	ff 75 10             	pushl  0x10(%ebp)
  80153b:	ff 75 0c             	pushl  0xc(%ebp)
  80153e:	50                   	push   %eax
  80153f:	ff d2                	call   *%edx
  801541:	83 c4 10             	add    $0x10,%esp
}
  801544:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801547:	c9                   	leave  
  801548:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801549:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80154e:	8b 40 48             	mov    0x48(%eax),%eax
  801551:	83 ec 04             	sub    $0x4,%esp
  801554:	53                   	push   %ebx
  801555:	50                   	push   %eax
  801556:	68 f4 2b 80 00       	push   $0x802bf4
  80155b:	e8 94 ed ff ff       	call   8002f4 <cprintf>
		return -E_INVAL;
  801560:	83 c4 10             	add    $0x10,%esp
  801563:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801568:	eb da                	jmp    801544 <write+0x55>
		return -E_NOT_SUPP;
  80156a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80156f:	eb d3                	jmp    801544 <write+0x55>

00801571 <seek>:

int
seek(int fdnum, off_t offset)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801577:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80157a:	50                   	push   %eax
  80157b:	ff 75 08             	pushl  0x8(%ebp)
  80157e:	e8 30 fc ff ff       	call   8011b3 <fd_lookup>
  801583:	83 c4 10             	add    $0x10,%esp
  801586:	85 c0                	test   %eax,%eax
  801588:	78 0e                	js     801598 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80158a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801590:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801593:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	53                   	push   %ebx
  80159e:	83 ec 1c             	sub    $0x1c,%esp
  8015a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a7:	50                   	push   %eax
  8015a8:	53                   	push   %ebx
  8015a9:	e8 05 fc ff ff       	call   8011b3 <fd_lookup>
  8015ae:	83 c4 10             	add    $0x10,%esp
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	78 37                	js     8015ec <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b5:	83 ec 08             	sub    $0x8,%esp
  8015b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015bb:	50                   	push   %eax
  8015bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bf:	ff 30                	pushl  (%eax)
  8015c1:	e8 3d fc ff ff       	call   801203 <dev_lookup>
  8015c6:	83 c4 10             	add    $0x10,%esp
  8015c9:	85 c0                	test   %eax,%eax
  8015cb:	78 1f                	js     8015ec <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015d4:	74 1b                	je     8015f1 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d9:	8b 52 18             	mov    0x18(%edx),%edx
  8015dc:	85 d2                	test   %edx,%edx
  8015de:	74 32                	je     801612 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015e0:	83 ec 08             	sub    $0x8,%esp
  8015e3:	ff 75 0c             	pushl  0xc(%ebp)
  8015e6:	50                   	push   %eax
  8015e7:	ff d2                	call   *%edx
  8015e9:	83 c4 10             	add    $0x10,%esp
}
  8015ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015f1:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015f6:	8b 40 48             	mov    0x48(%eax),%eax
  8015f9:	83 ec 04             	sub    $0x4,%esp
  8015fc:	53                   	push   %ebx
  8015fd:	50                   	push   %eax
  8015fe:	68 b4 2b 80 00       	push   $0x802bb4
  801603:	e8 ec ec ff ff       	call   8002f4 <cprintf>
		return -E_INVAL;
  801608:	83 c4 10             	add    $0x10,%esp
  80160b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801610:	eb da                	jmp    8015ec <ftruncate+0x52>
		return -E_NOT_SUPP;
  801612:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801617:	eb d3                	jmp    8015ec <ftruncate+0x52>

00801619 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	53                   	push   %ebx
  80161d:	83 ec 1c             	sub    $0x1c,%esp
  801620:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801623:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801626:	50                   	push   %eax
  801627:	ff 75 08             	pushl  0x8(%ebp)
  80162a:	e8 84 fb ff ff       	call   8011b3 <fd_lookup>
  80162f:	83 c4 10             	add    $0x10,%esp
  801632:	85 c0                	test   %eax,%eax
  801634:	78 4b                	js     801681 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801636:	83 ec 08             	sub    $0x8,%esp
  801639:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163c:	50                   	push   %eax
  80163d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801640:	ff 30                	pushl  (%eax)
  801642:	e8 bc fb ff ff       	call   801203 <dev_lookup>
  801647:	83 c4 10             	add    $0x10,%esp
  80164a:	85 c0                	test   %eax,%eax
  80164c:	78 33                	js     801681 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80164e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801651:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801655:	74 2f                	je     801686 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801657:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80165a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801661:	00 00 00 
	stat->st_isdir = 0;
  801664:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80166b:	00 00 00 
	stat->st_dev = dev;
  80166e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801674:	83 ec 08             	sub    $0x8,%esp
  801677:	53                   	push   %ebx
  801678:	ff 75 f0             	pushl  -0x10(%ebp)
  80167b:	ff 50 14             	call   *0x14(%eax)
  80167e:	83 c4 10             	add    $0x10,%esp
}
  801681:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801684:	c9                   	leave  
  801685:	c3                   	ret    
		return -E_NOT_SUPP;
  801686:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80168b:	eb f4                	jmp    801681 <fstat+0x68>

0080168d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	56                   	push   %esi
  801691:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801692:	83 ec 08             	sub    $0x8,%esp
  801695:	6a 00                	push   $0x0
  801697:	ff 75 08             	pushl  0x8(%ebp)
  80169a:	e8 22 02 00 00       	call   8018c1 <open>
  80169f:	89 c3                	mov    %eax,%ebx
  8016a1:	83 c4 10             	add    $0x10,%esp
  8016a4:	85 c0                	test   %eax,%eax
  8016a6:	78 1b                	js     8016c3 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016a8:	83 ec 08             	sub    $0x8,%esp
  8016ab:	ff 75 0c             	pushl  0xc(%ebp)
  8016ae:	50                   	push   %eax
  8016af:	e8 65 ff ff ff       	call   801619 <fstat>
  8016b4:	89 c6                	mov    %eax,%esi
	close(fd);
  8016b6:	89 1c 24             	mov    %ebx,(%esp)
  8016b9:	e8 27 fc ff ff       	call   8012e5 <close>
	return r;
  8016be:	83 c4 10             	add    $0x10,%esp
  8016c1:	89 f3                	mov    %esi,%ebx
}
  8016c3:	89 d8                	mov    %ebx,%eax
  8016c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c8:	5b                   	pop    %ebx
  8016c9:	5e                   	pop    %esi
  8016ca:	5d                   	pop    %ebp
  8016cb:	c3                   	ret    

008016cc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	56                   	push   %esi
  8016d0:	53                   	push   %ebx
  8016d1:	89 c6                	mov    %eax,%esi
  8016d3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016d5:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8016dc:	74 27                	je     801705 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016de:	6a 07                	push   $0x7
  8016e0:	68 00 50 80 00       	push   $0x805000
  8016e5:	56                   	push   %esi
  8016e6:	ff 35 04 40 80 00    	pushl  0x804004
  8016ec:	e8 1c 0d 00 00       	call   80240d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016f1:	83 c4 0c             	add    $0xc,%esp
  8016f4:	6a 00                	push   $0x0
  8016f6:	53                   	push   %ebx
  8016f7:	6a 00                	push   $0x0
  8016f9:	e8 a6 0c 00 00       	call   8023a4 <ipc_recv>
}
  8016fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801701:	5b                   	pop    %ebx
  801702:	5e                   	pop    %esi
  801703:	5d                   	pop    %ebp
  801704:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801705:	83 ec 0c             	sub    $0xc,%esp
  801708:	6a 01                	push   $0x1
  80170a:	e8 56 0d 00 00       	call   802465 <ipc_find_env>
  80170f:	a3 04 40 80 00       	mov    %eax,0x804004
  801714:	83 c4 10             	add    $0x10,%esp
  801717:	eb c5                	jmp    8016de <fsipc+0x12>

00801719 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
  801722:	8b 40 0c             	mov    0xc(%eax),%eax
  801725:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80172a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801732:	ba 00 00 00 00       	mov    $0x0,%edx
  801737:	b8 02 00 00 00       	mov    $0x2,%eax
  80173c:	e8 8b ff ff ff       	call   8016cc <fsipc>
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <devfile_flush>:
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	8b 40 0c             	mov    0xc(%eax),%eax
  80174f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801754:	ba 00 00 00 00       	mov    $0x0,%edx
  801759:	b8 06 00 00 00       	mov    $0x6,%eax
  80175e:	e8 69 ff ff ff       	call   8016cc <fsipc>
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <devfile_stat>:
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	53                   	push   %ebx
  801769:	83 ec 04             	sub    $0x4,%esp
  80176c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8b 40 0c             	mov    0xc(%eax),%eax
  801775:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80177a:	ba 00 00 00 00       	mov    $0x0,%edx
  80177f:	b8 05 00 00 00       	mov    $0x5,%eax
  801784:	e8 43 ff ff ff       	call   8016cc <fsipc>
  801789:	85 c0                	test   %eax,%eax
  80178b:	78 2c                	js     8017b9 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80178d:	83 ec 08             	sub    $0x8,%esp
  801790:	68 00 50 80 00       	push   $0x805000
  801795:	53                   	push   %ebx
  801796:	e8 b8 f2 ff ff       	call   800a53 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80179b:	a1 80 50 80 00       	mov    0x805080,%eax
  8017a0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017a6:	a1 84 50 80 00       	mov    0x805084,%eax
  8017ab:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017b1:	83 c4 10             	add    $0x10,%esp
  8017b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <devfile_write>:
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	53                   	push   %ebx
  8017c2:	83 ec 08             	sub    $0x8,%esp
  8017c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ce:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8017d3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017d9:	53                   	push   %ebx
  8017da:	ff 75 0c             	pushl  0xc(%ebp)
  8017dd:	68 08 50 80 00       	push   $0x805008
  8017e2:	e8 5c f4 ff ff       	call   800c43 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ec:	b8 04 00 00 00       	mov    $0x4,%eax
  8017f1:	e8 d6 fe ff ff       	call   8016cc <fsipc>
  8017f6:	83 c4 10             	add    $0x10,%esp
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	78 0b                	js     801808 <devfile_write+0x4a>
	assert(r <= n);
  8017fd:	39 d8                	cmp    %ebx,%eax
  8017ff:	77 0c                	ja     80180d <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801801:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801806:	7f 1e                	jg     801826 <devfile_write+0x68>
}
  801808:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    
	assert(r <= n);
  80180d:	68 28 2c 80 00       	push   $0x802c28
  801812:	68 2f 2c 80 00       	push   $0x802c2f
  801817:	68 98 00 00 00       	push   $0x98
  80181c:	68 44 2c 80 00       	push   $0x802c44
  801821:	e8 d8 e9 ff ff       	call   8001fe <_panic>
	assert(r <= PGSIZE);
  801826:	68 4f 2c 80 00       	push   $0x802c4f
  80182b:	68 2f 2c 80 00       	push   $0x802c2f
  801830:	68 99 00 00 00       	push   $0x99
  801835:	68 44 2c 80 00       	push   $0x802c44
  80183a:	e8 bf e9 ff ff       	call   8001fe <_panic>

0080183f <devfile_read>:
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	56                   	push   %esi
  801843:	53                   	push   %ebx
  801844:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8b 40 0c             	mov    0xc(%eax),%eax
  80184d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801852:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801858:	ba 00 00 00 00       	mov    $0x0,%edx
  80185d:	b8 03 00 00 00       	mov    $0x3,%eax
  801862:	e8 65 fe ff ff       	call   8016cc <fsipc>
  801867:	89 c3                	mov    %eax,%ebx
  801869:	85 c0                	test   %eax,%eax
  80186b:	78 1f                	js     80188c <devfile_read+0x4d>
	assert(r <= n);
  80186d:	39 f0                	cmp    %esi,%eax
  80186f:	77 24                	ja     801895 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801871:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801876:	7f 33                	jg     8018ab <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801878:	83 ec 04             	sub    $0x4,%esp
  80187b:	50                   	push   %eax
  80187c:	68 00 50 80 00       	push   $0x805000
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	e8 58 f3 ff ff       	call   800be1 <memmove>
	return r;
  801889:	83 c4 10             	add    $0x10,%esp
}
  80188c:	89 d8                	mov    %ebx,%eax
  80188e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801891:	5b                   	pop    %ebx
  801892:	5e                   	pop    %esi
  801893:	5d                   	pop    %ebp
  801894:	c3                   	ret    
	assert(r <= n);
  801895:	68 28 2c 80 00       	push   $0x802c28
  80189a:	68 2f 2c 80 00       	push   $0x802c2f
  80189f:	6a 7c                	push   $0x7c
  8018a1:	68 44 2c 80 00       	push   $0x802c44
  8018a6:	e8 53 e9 ff ff       	call   8001fe <_panic>
	assert(r <= PGSIZE);
  8018ab:	68 4f 2c 80 00       	push   $0x802c4f
  8018b0:	68 2f 2c 80 00       	push   $0x802c2f
  8018b5:	6a 7d                	push   $0x7d
  8018b7:	68 44 2c 80 00       	push   $0x802c44
  8018bc:	e8 3d e9 ff ff       	call   8001fe <_panic>

008018c1 <open>:
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	56                   	push   %esi
  8018c5:	53                   	push   %ebx
  8018c6:	83 ec 1c             	sub    $0x1c,%esp
  8018c9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018cc:	56                   	push   %esi
  8018cd:	e8 48 f1 ff ff       	call   800a1a <strlen>
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018da:	7f 6c                	jg     801948 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018dc:	83 ec 0c             	sub    $0xc,%esp
  8018df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e2:	50                   	push   %eax
  8018e3:	e8 79 f8 ff ff       	call   801161 <fd_alloc>
  8018e8:	89 c3                	mov    %eax,%ebx
  8018ea:	83 c4 10             	add    $0x10,%esp
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	78 3c                	js     80192d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018f1:	83 ec 08             	sub    $0x8,%esp
  8018f4:	56                   	push   %esi
  8018f5:	68 00 50 80 00       	push   $0x805000
  8018fa:	e8 54 f1 ff ff       	call   800a53 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801902:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801907:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80190a:	b8 01 00 00 00       	mov    $0x1,%eax
  80190f:	e8 b8 fd ff ff       	call   8016cc <fsipc>
  801914:	89 c3                	mov    %eax,%ebx
  801916:	83 c4 10             	add    $0x10,%esp
  801919:	85 c0                	test   %eax,%eax
  80191b:	78 19                	js     801936 <open+0x75>
	return fd2num(fd);
  80191d:	83 ec 0c             	sub    $0xc,%esp
  801920:	ff 75 f4             	pushl  -0xc(%ebp)
  801923:	e8 12 f8 ff ff       	call   80113a <fd2num>
  801928:	89 c3                	mov    %eax,%ebx
  80192a:	83 c4 10             	add    $0x10,%esp
}
  80192d:	89 d8                	mov    %ebx,%eax
  80192f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801932:	5b                   	pop    %ebx
  801933:	5e                   	pop    %esi
  801934:	5d                   	pop    %ebp
  801935:	c3                   	ret    
		fd_close(fd, 0);
  801936:	83 ec 08             	sub    $0x8,%esp
  801939:	6a 00                	push   $0x0
  80193b:	ff 75 f4             	pushl  -0xc(%ebp)
  80193e:	e8 1b f9 ff ff       	call   80125e <fd_close>
		return r;
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	eb e5                	jmp    80192d <open+0x6c>
		return -E_BAD_PATH;
  801948:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80194d:	eb de                	jmp    80192d <open+0x6c>

0080194f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801955:	ba 00 00 00 00       	mov    $0x0,%edx
  80195a:	b8 08 00 00 00       	mov    $0x8,%eax
  80195f:	e8 68 fd ff ff       	call   8016cc <fsipc>
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801966:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  80196a:	7f 01                	jg     80196d <writebuf+0x7>
  80196c:	c3                   	ret    
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	53                   	push   %ebx
  801971:	83 ec 08             	sub    $0x8,%esp
  801974:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801976:	ff 70 04             	pushl  0x4(%eax)
  801979:	8d 40 10             	lea    0x10(%eax),%eax
  80197c:	50                   	push   %eax
  80197d:	ff 33                	pushl  (%ebx)
  80197f:	e8 6b fb ff ff       	call   8014ef <write>
		if (result > 0)
  801984:	83 c4 10             	add    $0x10,%esp
  801987:	85 c0                	test   %eax,%eax
  801989:	7e 03                	jle    80198e <writebuf+0x28>
			b->result += result;
  80198b:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80198e:	39 43 04             	cmp    %eax,0x4(%ebx)
  801991:	74 0d                	je     8019a0 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801993:	85 c0                	test   %eax,%eax
  801995:	ba 00 00 00 00       	mov    $0x0,%edx
  80199a:	0f 4f c2             	cmovg  %edx,%eax
  80199d:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8019a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <putch>:

static void
putch(int ch, void *thunk)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	53                   	push   %ebx
  8019a9:	83 ec 04             	sub    $0x4,%esp
  8019ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019af:	8b 53 04             	mov    0x4(%ebx),%edx
  8019b2:	8d 42 01             	lea    0x1(%edx),%eax
  8019b5:	89 43 04             	mov    %eax,0x4(%ebx)
  8019b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019bb:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019bf:	3d 00 01 00 00       	cmp    $0x100,%eax
  8019c4:	74 06                	je     8019cc <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8019c6:	83 c4 04             	add    $0x4,%esp
  8019c9:	5b                   	pop    %ebx
  8019ca:	5d                   	pop    %ebp
  8019cb:	c3                   	ret    
		writebuf(b);
  8019cc:	89 d8                	mov    %ebx,%eax
  8019ce:	e8 93 ff ff ff       	call   801966 <writebuf>
		b->idx = 0;
  8019d3:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8019da:	eb ea                	jmp    8019c6 <putch+0x21>

008019dc <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8019ee:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8019f5:	00 00 00 
	b.result = 0;
  8019f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8019ff:	00 00 00 
	b.error = 1;
  801a02:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a09:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a0c:	ff 75 10             	pushl  0x10(%ebp)
  801a0f:	ff 75 0c             	pushl  0xc(%ebp)
  801a12:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a18:	50                   	push   %eax
  801a19:	68 a5 19 80 00       	push   $0x8019a5
  801a1e:	e8 fe e9 ff ff       	call   800421 <vprintfmt>
	if (b.idx > 0)
  801a23:	83 c4 10             	add    $0x10,%esp
  801a26:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a2d:	7f 11                	jg     801a40 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801a2f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a35:	85 c0                	test   %eax,%eax
  801a37:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    
		writebuf(&b);
  801a40:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a46:	e8 1b ff ff ff       	call   801966 <writebuf>
  801a4b:	eb e2                	jmp    801a2f <vfprintf+0x53>

00801a4d <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a53:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a56:	50                   	push   %eax
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	ff 75 08             	pushl  0x8(%ebp)
  801a5d:	e8 7a ff ff ff       	call   8019dc <vfprintf>
	va_end(ap);

	return cnt;
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <printf>:

int
printf(const char *fmt, ...)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a6a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a6d:	50                   	push   %eax
  801a6e:	ff 75 08             	pushl  0x8(%ebp)
  801a71:	6a 01                	push   $0x1
  801a73:	e8 64 ff ff ff       	call   8019dc <vfprintf>
	va_end(ap);

	return cnt;
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a80:	68 5b 2c 80 00       	push   $0x802c5b
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	e8 c6 ef ff ff       	call   800a53 <strcpy>
	return 0;
}
  801a8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <devsock_close>:
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	53                   	push   %ebx
  801a98:	83 ec 10             	sub    $0x10,%esp
  801a9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a9e:	53                   	push   %ebx
  801a9f:	e8 00 0a 00 00       	call   8024a4 <pageref>
  801aa4:	83 c4 10             	add    $0x10,%esp
		return 0;
  801aa7:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801aac:	83 f8 01             	cmp    $0x1,%eax
  801aaf:	74 07                	je     801ab8 <devsock_close+0x24>
}
  801ab1:	89 d0                	mov    %edx,%eax
  801ab3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ab8:	83 ec 0c             	sub    $0xc,%esp
  801abb:	ff 73 0c             	pushl  0xc(%ebx)
  801abe:	e8 b9 02 00 00       	call   801d7c <nsipc_close>
  801ac3:	89 c2                	mov    %eax,%edx
  801ac5:	83 c4 10             	add    $0x10,%esp
  801ac8:	eb e7                	jmp    801ab1 <devsock_close+0x1d>

00801aca <devsock_write>:
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ad0:	6a 00                	push   $0x0
  801ad2:	ff 75 10             	pushl  0x10(%ebp)
  801ad5:	ff 75 0c             	pushl  0xc(%ebp)
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	ff 70 0c             	pushl  0xc(%eax)
  801ade:	e8 76 03 00 00       	call   801e59 <nsipc_send>
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <devsock_read>:
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801aeb:	6a 00                	push   $0x0
  801aed:	ff 75 10             	pushl  0x10(%ebp)
  801af0:	ff 75 0c             	pushl  0xc(%ebp)
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	ff 70 0c             	pushl  0xc(%eax)
  801af9:	e8 ef 02 00 00       	call   801ded <nsipc_recv>
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <fd2sockid>:
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b06:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b09:	52                   	push   %edx
  801b0a:	50                   	push   %eax
  801b0b:	e8 a3 f6 ff ff       	call   8011b3 <fd_lookup>
  801b10:	83 c4 10             	add    $0x10,%esp
  801b13:	85 c0                	test   %eax,%eax
  801b15:	78 10                	js     801b27 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1a:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801b20:	39 08                	cmp    %ecx,(%eax)
  801b22:	75 05                	jne    801b29 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b24:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    
		return -E_NOT_SUPP;
  801b29:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b2e:	eb f7                	jmp    801b27 <fd2sockid+0x27>

00801b30 <alloc_sockfd>:
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	56                   	push   %esi
  801b34:	53                   	push   %ebx
  801b35:	83 ec 1c             	sub    $0x1c,%esp
  801b38:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3d:	50                   	push   %eax
  801b3e:	e8 1e f6 ff ff       	call   801161 <fd_alloc>
  801b43:	89 c3                	mov    %eax,%ebx
  801b45:	83 c4 10             	add    $0x10,%esp
  801b48:	85 c0                	test   %eax,%eax
  801b4a:	78 43                	js     801b8f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b4c:	83 ec 04             	sub    $0x4,%esp
  801b4f:	68 07 04 00 00       	push   $0x407
  801b54:	ff 75 f4             	pushl  -0xc(%ebp)
  801b57:	6a 00                	push   $0x0
  801b59:	e8 e7 f2 ff ff       	call   800e45 <sys_page_alloc>
  801b5e:	89 c3                	mov    %eax,%ebx
  801b60:	83 c4 10             	add    $0x10,%esp
  801b63:	85 c0                	test   %eax,%eax
  801b65:	78 28                	js     801b8f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6a:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801b70:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b75:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b7c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b7f:	83 ec 0c             	sub    $0xc,%esp
  801b82:	50                   	push   %eax
  801b83:	e8 b2 f5 ff ff       	call   80113a <fd2num>
  801b88:	89 c3                	mov    %eax,%ebx
  801b8a:	83 c4 10             	add    $0x10,%esp
  801b8d:	eb 0c                	jmp    801b9b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b8f:	83 ec 0c             	sub    $0xc,%esp
  801b92:	56                   	push   %esi
  801b93:	e8 e4 01 00 00       	call   801d7c <nsipc_close>
		return r;
  801b98:	83 c4 10             	add    $0x10,%esp
}
  801b9b:	89 d8                	mov    %ebx,%eax
  801b9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba0:	5b                   	pop    %ebx
  801ba1:	5e                   	pop    %esi
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    

00801ba4 <accept>:
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	e8 4e ff ff ff       	call   801b00 <fd2sockid>
  801bb2:	85 c0                	test   %eax,%eax
  801bb4:	78 1b                	js     801bd1 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801bb6:	83 ec 04             	sub    $0x4,%esp
  801bb9:	ff 75 10             	pushl  0x10(%ebp)
  801bbc:	ff 75 0c             	pushl  0xc(%ebp)
  801bbf:	50                   	push   %eax
  801bc0:	e8 0e 01 00 00       	call   801cd3 <nsipc_accept>
  801bc5:	83 c4 10             	add    $0x10,%esp
  801bc8:	85 c0                	test   %eax,%eax
  801bca:	78 05                	js     801bd1 <accept+0x2d>
	return alloc_sockfd(r);
  801bcc:	e8 5f ff ff ff       	call   801b30 <alloc_sockfd>
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <bind>:
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	e8 1f ff ff ff       	call   801b00 <fd2sockid>
  801be1:	85 c0                	test   %eax,%eax
  801be3:	78 12                	js     801bf7 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801be5:	83 ec 04             	sub    $0x4,%esp
  801be8:	ff 75 10             	pushl  0x10(%ebp)
  801beb:	ff 75 0c             	pushl  0xc(%ebp)
  801bee:	50                   	push   %eax
  801bef:	e8 31 01 00 00       	call   801d25 <nsipc_bind>
  801bf4:	83 c4 10             	add    $0x10,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <shutdown>:
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	e8 f9 fe ff ff       	call   801b00 <fd2sockid>
  801c07:	85 c0                	test   %eax,%eax
  801c09:	78 0f                	js     801c1a <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c0b:	83 ec 08             	sub    $0x8,%esp
  801c0e:	ff 75 0c             	pushl  0xc(%ebp)
  801c11:	50                   	push   %eax
  801c12:	e8 43 01 00 00       	call   801d5a <nsipc_shutdown>
  801c17:	83 c4 10             	add    $0x10,%esp
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <connect>:
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
  801c1f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	e8 d6 fe ff ff       	call   801b00 <fd2sockid>
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	78 12                	js     801c40 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c2e:	83 ec 04             	sub    $0x4,%esp
  801c31:	ff 75 10             	pushl  0x10(%ebp)
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	50                   	push   %eax
  801c38:	e8 59 01 00 00       	call   801d96 <nsipc_connect>
  801c3d:	83 c4 10             	add    $0x10,%esp
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <listen>:
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	e8 b0 fe ff ff       	call   801b00 <fd2sockid>
  801c50:	85 c0                	test   %eax,%eax
  801c52:	78 0f                	js     801c63 <listen+0x21>
	return nsipc_listen(r, backlog);
  801c54:	83 ec 08             	sub    $0x8,%esp
  801c57:	ff 75 0c             	pushl  0xc(%ebp)
  801c5a:	50                   	push   %eax
  801c5b:	e8 6b 01 00 00       	call   801dcb <nsipc_listen>
  801c60:	83 c4 10             	add    $0x10,%esp
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <socket>:

int
socket(int domain, int type, int protocol)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c6b:	ff 75 10             	pushl  0x10(%ebp)
  801c6e:	ff 75 0c             	pushl  0xc(%ebp)
  801c71:	ff 75 08             	pushl  0x8(%ebp)
  801c74:	e8 3e 02 00 00       	call   801eb7 <nsipc_socket>
  801c79:	83 c4 10             	add    $0x10,%esp
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	78 05                	js     801c85 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c80:	e8 ab fe ff ff       	call   801b30 <alloc_sockfd>
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	53                   	push   %ebx
  801c8b:	83 ec 04             	sub    $0x4,%esp
  801c8e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c90:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801c97:	74 26                	je     801cbf <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c99:	6a 07                	push   $0x7
  801c9b:	68 00 60 80 00       	push   $0x806000
  801ca0:	53                   	push   %ebx
  801ca1:	ff 35 08 40 80 00    	pushl  0x804008
  801ca7:	e8 61 07 00 00       	call   80240d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801cac:	83 c4 0c             	add    $0xc,%esp
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	e8 ea 06 00 00       	call   8023a4 <ipc_recv>
}
  801cba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801cbf:	83 ec 0c             	sub    $0xc,%esp
  801cc2:	6a 02                	push   $0x2
  801cc4:	e8 9c 07 00 00       	call   802465 <ipc_find_env>
  801cc9:	a3 08 40 80 00       	mov    %eax,0x804008
  801cce:	83 c4 10             	add    $0x10,%esp
  801cd1:	eb c6                	jmp    801c99 <nsipc+0x12>

00801cd3 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	56                   	push   %esi
  801cd7:	53                   	push   %ebx
  801cd8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ce3:	8b 06                	mov    (%esi),%eax
  801ce5:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801cea:	b8 01 00 00 00       	mov    $0x1,%eax
  801cef:	e8 93 ff ff ff       	call   801c87 <nsipc>
  801cf4:	89 c3                	mov    %eax,%ebx
  801cf6:	85 c0                	test   %eax,%eax
  801cf8:	79 09                	jns    801d03 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801cfa:	89 d8                	mov    %ebx,%eax
  801cfc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cff:	5b                   	pop    %ebx
  801d00:	5e                   	pop    %esi
  801d01:	5d                   	pop    %ebp
  801d02:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d03:	83 ec 04             	sub    $0x4,%esp
  801d06:	ff 35 10 60 80 00    	pushl  0x806010
  801d0c:	68 00 60 80 00       	push   $0x806000
  801d11:	ff 75 0c             	pushl  0xc(%ebp)
  801d14:	e8 c8 ee ff ff       	call   800be1 <memmove>
		*addrlen = ret->ret_addrlen;
  801d19:	a1 10 60 80 00       	mov    0x806010,%eax
  801d1e:	89 06                	mov    %eax,(%esi)
  801d20:	83 c4 10             	add    $0x10,%esp
	return r;
  801d23:	eb d5                	jmp    801cfa <nsipc_accept+0x27>

00801d25 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	53                   	push   %ebx
  801d29:	83 ec 08             	sub    $0x8,%esp
  801d2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d37:	53                   	push   %ebx
  801d38:	ff 75 0c             	pushl  0xc(%ebp)
  801d3b:	68 04 60 80 00       	push   $0x806004
  801d40:	e8 9c ee ff ff       	call   800be1 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d45:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d4b:	b8 02 00 00 00       	mov    $0x2,%eax
  801d50:	e8 32 ff ff ff       	call   801c87 <nsipc>
}
  801d55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d6b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d70:	b8 03 00 00 00       	mov    $0x3,%eax
  801d75:	e8 0d ff ff ff       	call   801c87 <nsipc>
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <nsipc_close>:

int
nsipc_close(int s)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d8a:	b8 04 00 00 00       	mov    $0x4,%eax
  801d8f:	e8 f3 fe ff ff       	call   801c87 <nsipc>
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	53                   	push   %ebx
  801d9a:	83 ec 08             	sub    $0x8,%esp
  801d9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801da8:	53                   	push   %ebx
  801da9:	ff 75 0c             	pushl  0xc(%ebp)
  801dac:	68 04 60 80 00       	push   $0x806004
  801db1:	e8 2b ee ff ff       	call   800be1 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801db6:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801dbc:	b8 05 00 00 00       	mov    $0x5,%eax
  801dc1:	e8 c1 fe ff ff       	call   801c87 <nsipc>
}
  801dc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddc:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801de1:	b8 06 00 00 00       	mov    $0x6,%eax
  801de6:	e8 9c fe ff ff       	call   801c87 <nsipc>
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	56                   	push   %esi
  801df1:	53                   	push   %ebx
  801df2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801dfd:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e03:	8b 45 14             	mov    0x14(%ebp),%eax
  801e06:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e0b:	b8 07 00 00 00       	mov    $0x7,%eax
  801e10:	e8 72 fe ff ff       	call   801c87 <nsipc>
  801e15:	89 c3                	mov    %eax,%ebx
  801e17:	85 c0                	test   %eax,%eax
  801e19:	78 1f                	js     801e3a <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801e1b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e20:	7f 21                	jg     801e43 <nsipc_recv+0x56>
  801e22:	39 c6                	cmp    %eax,%esi
  801e24:	7c 1d                	jl     801e43 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e26:	83 ec 04             	sub    $0x4,%esp
  801e29:	50                   	push   %eax
  801e2a:	68 00 60 80 00       	push   $0x806000
  801e2f:	ff 75 0c             	pushl  0xc(%ebp)
  801e32:	e8 aa ed ff ff       	call   800be1 <memmove>
  801e37:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e3a:	89 d8                	mov    %ebx,%eax
  801e3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e3f:	5b                   	pop    %ebx
  801e40:	5e                   	pop    %esi
  801e41:	5d                   	pop    %ebp
  801e42:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e43:	68 67 2c 80 00       	push   $0x802c67
  801e48:	68 2f 2c 80 00       	push   $0x802c2f
  801e4d:	6a 62                	push   $0x62
  801e4f:	68 7c 2c 80 00       	push   $0x802c7c
  801e54:	e8 a5 e3 ff ff       	call   8001fe <_panic>

00801e59 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	53                   	push   %ebx
  801e5d:	83 ec 04             	sub    $0x4,%esp
  801e60:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e63:	8b 45 08             	mov    0x8(%ebp),%eax
  801e66:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e6b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e71:	7f 2e                	jg     801ea1 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e73:	83 ec 04             	sub    $0x4,%esp
  801e76:	53                   	push   %ebx
  801e77:	ff 75 0c             	pushl  0xc(%ebp)
  801e7a:	68 0c 60 80 00       	push   $0x80600c
  801e7f:	e8 5d ed ff ff       	call   800be1 <memmove>
	nsipcbuf.send.req_size = size;
  801e84:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e8a:	8b 45 14             	mov    0x14(%ebp),%eax
  801e8d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e92:	b8 08 00 00 00       	mov    $0x8,%eax
  801e97:	e8 eb fd ff ff       	call   801c87 <nsipc>
}
  801e9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    
	assert(size < 1600);
  801ea1:	68 88 2c 80 00       	push   $0x802c88
  801ea6:	68 2f 2c 80 00       	push   $0x802c2f
  801eab:	6a 6d                	push   $0x6d
  801ead:	68 7c 2c 80 00       	push   $0x802c7c
  801eb2:	e8 47 e3 ff ff       	call   8001fe <_panic>

00801eb7 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec8:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ecd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed0:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ed5:	b8 09 00 00 00       	mov    $0x9,%eax
  801eda:	e8 a8 fd ff ff       	call   801c87 <nsipc>
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	56                   	push   %esi
  801ee5:	53                   	push   %ebx
  801ee6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ee9:	83 ec 0c             	sub    $0xc,%esp
  801eec:	ff 75 08             	pushl  0x8(%ebp)
  801eef:	e8 56 f2 ff ff       	call   80114a <fd2data>
  801ef4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ef6:	83 c4 08             	add    $0x8,%esp
  801ef9:	68 94 2c 80 00       	push   $0x802c94
  801efe:	53                   	push   %ebx
  801eff:	e8 4f eb ff ff       	call   800a53 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f04:	8b 46 04             	mov    0x4(%esi),%eax
  801f07:	2b 06                	sub    (%esi),%eax
  801f09:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f0f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f16:	00 00 00 
	stat->st_dev = &devpipe;
  801f19:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  801f20:	30 80 00 
	return 0;
}
  801f23:	b8 00 00 00 00       	mov    $0x0,%eax
  801f28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f2b:	5b                   	pop    %ebx
  801f2c:	5e                   	pop    %esi
  801f2d:	5d                   	pop    %ebp
  801f2e:	c3                   	ret    

00801f2f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	53                   	push   %ebx
  801f33:	83 ec 0c             	sub    $0xc,%esp
  801f36:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f39:	53                   	push   %ebx
  801f3a:	6a 00                	push   $0x0
  801f3c:	e8 89 ef ff ff       	call   800eca <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f41:	89 1c 24             	mov    %ebx,(%esp)
  801f44:	e8 01 f2 ff ff       	call   80114a <fd2data>
  801f49:	83 c4 08             	add    $0x8,%esp
  801f4c:	50                   	push   %eax
  801f4d:	6a 00                	push   $0x0
  801f4f:	e8 76 ef ff ff       	call   800eca <sys_page_unmap>
}
  801f54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <_pipeisclosed>:
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	57                   	push   %edi
  801f5d:	56                   	push   %esi
  801f5e:	53                   	push   %ebx
  801f5f:	83 ec 1c             	sub    $0x1c,%esp
  801f62:	89 c7                	mov    %eax,%edi
  801f64:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f66:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801f6b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f6e:	83 ec 0c             	sub    $0xc,%esp
  801f71:	57                   	push   %edi
  801f72:	e8 2d 05 00 00       	call   8024a4 <pageref>
  801f77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f7a:	89 34 24             	mov    %esi,(%esp)
  801f7d:	e8 22 05 00 00       	call   8024a4 <pageref>
		nn = thisenv->env_runs;
  801f82:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801f88:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f8b:	83 c4 10             	add    $0x10,%esp
  801f8e:	39 cb                	cmp    %ecx,%ebx
  801f90:	74 1b                	je     801fad <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f92:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f95:	75 cf                	jne    801f66 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f97:	8b 42 58             	mov    0x58(%edx),%eax
  801f9a:	6a 01                	push   $0x1
  801f9c:	50                   	push   %eax
  801f9d:	53                   	push   %ebx
  801f9e:	68 9b 2c 80 00       	push   $0x802c9b
  801fa3:	e8 4c e3 ff ff       	call   8002f4 <cprintf>
  801fa8:	83 c4 10             	add    $0x10,%esp
  801fab:	eb b9                	jmp    801f66 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801fad:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fb0:	0f 94 c0             	sete   %al
  801fb3:	0f b6 c0             	movzbl %al,%eax
}
  801fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fb9:	5b                   	pop    %ebx
  801fba:	5e                   	pop    %esi
  801fbb:	5f                   	pop    %edi
  801fbc:	5d                   	pop    %ebp
  801fbd:	c3                   	ret    

00801fbe <devpipe_write>:
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	57                   	push   %edi
  801fc2:	56                   	push   %esi
  801fc3:	53                   	push   %ebx
  801fc4:	83 ec 28             	sub    $0x28,%esp
  801fc7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801fca:	56                   	push   %esi
  801fcb:	e8 7a f1 ff ff       	call   80114a <fd2data>
  801fd0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fd2:	83 c4 10             	add    $0x10,%esp
  801fd5:	bf 00 00 00 00       	mov    $0x0,%edi
  801fda:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fdd:	74 4f                	je     80202e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fdf:	8b 43 04             	mov    0x4(%ebx),%eax
  801fe2:	8b 0b                	mov    (%ebx),%ecx
  801fe4:	8d 51 20             	lea    0x20(%ecx),%edx
  801fe7:	39 d0                	cmp    %edx,%eax
  801fe9:	72 14                	jb     801fff <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801feb:	89 da                	mov    %ebx,%edx
  801fed:	89 f0                	mov    %esi,%eax
  801fef:	e8 65 ff ff ff       	call   801f59 <_pipeisclosed>
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	75 3b                	jne    802033 <devpipe_write+0x75>
			sys_yield();
  801ff8:	e8 29 ee ff ff       	call   800e26 <sys_yield>
  801ffd:	eb e0                	jmp    801fdf <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802002:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802006:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802009:	89 c2                	mov    %eax,%edx
  80200b:	c1 fa 1f             	sar    $0x1f,%edx
  80200e:	89 d1                	mov    %edx,%ecx
  802010:	c1 e9 1b             	shr    $0x1b,%ecx
  802013:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802016:	83 e2 1f             	and    $0x1f,%edx
  802019:	29 ca                	sub    %ecx,%edx
  80201b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80201f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802023:	83 c0 01             	add    $0x1,%eax
  802026:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802029:	83 c7 01             	add    $0x1,%edi
  80202c:	eb ac                	jmp    801fda <devpipe_write+0x1c>
	return i;
  80202e:	8b 45 10             	mov    0x10(%ebp),%eax
  802031:	eb 05                	jmp    802038 <devpipe_write+0x7a>
				return 0;
  802033:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802038:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80203b:	5b                   	pop    %ebx
  80203c:	5e                   	pop    %esi
  80203d:	5f                   	pop    %edi
  80203e:	5d                   	pop    %ebp
  80203f:	c3                   	ret    

00802040 <devpipe_read>:
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	57                   	push   %edi
  802044:	56                   	push   %esi
  802045:	53                   	push   %ebx
  802046:	83 ec 18             	sub    $0x18,%esp
  802049:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80204c:	57                   	push   %edi
  80204d:	e8 f8 f0 ff ff       	call   80114a <fd2data>
  802052:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802054:	83 c4 10             	add    $0x10,%esp
  802057:	be 00 00 00 00       	mov    $0x0,%esi
  80205c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80205f:	75 14                	jne    802075 <devpipe_read+0x35>
	return i;
  802061:	8b 45 10             	mov    0x10(%ebp),%eax
  802064:	eb 02                	jmp    802068 <devpipe_read+0x28>
				return i;
  802066:	89 f0                	mov    %esi,%eax
}
  802068:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80206b:	5b                   	pop    %ebx
  80206c:	5e                   	pop    %esi
  80206d:	5f                   	pop    %edi
  80206e:	5d                   	pop    %ebp
  80206f:	c3                   	ret    
			sys_yield();
  802070:	e8 b1 ed ff ff       	call   800e26 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802075:	8b 03                	mov    (%ebx),%eax
  802077:	3b 43 04             	cmp    0x4(%ebx),%eax
  80207a:	75 18                	jne    802094 <devpipe_read+0x54>
			if (i > 0)
  80207c:	85 f6                	test   %esi,%esi
  80207e:	75 e6                	jne    802066 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802080:	89 da                	mov    %ebx,%edx
  802082:	89 f8                	mov    %edi,%eax
  802084:	e8 d0 fe ff ff       	call   801f59 <_pipeisclosed>
  802089:	85 c0                	test   %eax,%eax
  80208b:	74 e3                	je     802070 <devpipe_read+0x30>
				return 0;
  80208d:	b8 00 00 00 00       	mov    $0x0,%eax
  802092:	eb d4                	jmp    802068 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802094:	99                   	cltd   
  802095:	c1 ea 1b             	shr    $0x1b,%edx
  802098:	01 d0                	add    %edx,%eax
  80209a:	83 e0 1f             	and    $0x1f,%eax
  80209d:	29 d0                	sub    %edx,%eax
  80209f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020a7:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020aa:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8020ad:	83 c6 01             	add    $0x1,%esi
  8020b0:	eb aa                	jmp    80205c <devpipe_read+0x1c>

008020b2 <pipe>:
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	56                   	push   %esi
  8020b6:	53                   	push   %ebx
  8020b7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8020ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020bd:	50                   	push   %eax
  8020be:	e8 9e f0 ff ff       	call   801161 <fd_alloc>
  8020c3:	89 c3                	mov    %eax,%ebx
  8020c5:	83 c4 10             	add    $0x10,%esp
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	0f 88 23 01 00 00    	js     8021f3 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020d0:	83 ec 04             	sub    $0x4,%esp
  8020d3:	68 07 04 00 00       	push   $0x407
  8020d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8020db:	6a 00                	push   $0x0
  8020dd:	e8 63 ed ff ff       	call   800e45 <sys_page_alloc>
  8020e2:	89 c3                	mov    %eax,%ebx
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	0f 88 04 01 00 00    	js     8021f3 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8020ef:	83 ec 0c             	sub    $0xc,%esp
  8020f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020f5:	50                   	push   %eax
  8020f6:	e8 66 f0 ff ff       	call   801161 <fd_alloc>
  8020fb:	89 c3                	mov    %eax,%ebx
  8020fd:	83 c4 10             	add    $0x10,%esp
  802100:	85 c0                	test   %eax,%eax
  802102:	0f 88 db 00 00 00    	js     8021e3 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802108:	83 ec 04             	sub    $0x4,%esp
  80210b:	68 07 04 00 00       	push   $0x407
  802110:	ff 75 f0             	pushl  -0x10(%ebp)
  802113:	6a 00                	push   $0x0
  802115:	e8 2b ed ff ff       	call   800e45 <sys_page_alloc>
  80211a:	89 c3                	mov    %eax,%ebx
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	85 c0                	test   %eax,%eax
  802121:	0f 88 bc 00 00 00    	js     8021e3 <pipe+0x131>
	va = fd2data(fd0);
  802127:	83 ec 0c             	sub    $0xc,%esp
  80212a:	ff 75 f4             	pushl  -0xc(%ebp)
  80212d:	e8 18 f0 ff ff       	call   80114a <fd2data>
  802132:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802134:	83 c4 0c             	add    $0xc,%esp
  802137:	68 07 04 00 00       	push   $0x407
  80213c:	50                   	push   %eax
  80213d:	6a 00                	push   $0x0
  80213f:	e8 01 ed ff ff       	call   800e45 <sys_page_alloc>
  802144:	89 c3                	mov    %eax,%ebx
  802146:	83 c4 10             	add    $0x10,%esp
  802149:	85 c0                	test   %eax,%eax
  80214b:	0f 88 82 00 00 00    	js     8021d3 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802151:	83 ec 0c             	sub    $0xc,%esp
  802154:	ff 75 f0             	pushl  -0x10(%ebp)
  802157:	e8 ee ef ff ff       	call   80114a <fd2data>
  80215c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802163:	50                   	push   %eax
  802164:	6a 00                	push   $0x0
  802166:	56                   	push   %esi
  802167:	6a 00                	push   $0x0
  802169:	e8 1a ed ff ff       	call   800e88 <sys_page_map>
  80216e:	89 c3                	mov    %eax,%ebx
  802170:	83 c4 20             	add    $0x20,%esp
  802173:	85 c0                	test   %eax,%eax
  802175:	78 4e                	js     8021c5 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802177:	a1 40 30 80 00       	mov    0x803040,%eax
  80217c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802181:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802184:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80218b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80218e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802193:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80219a:	83 ec 0c             	sub    $0xc,%esp
  80219d:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a0:	e8 95 ef ff ff       	call   80113a <fd2num>
  8021a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021a8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021aa:	83 c4 04             	add    $0x4,%esp
  8021ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8021b0:	e8 85 ef ff ff       	call   80113a <fd2num>
  8021b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021b8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021bb:	83 c4 10             	add    $0x10,%esp
  8021be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021c3:	eb 2e                	jmp    8021f3 <pipe+0x141>
	sys_page_unmap(0, va);
  8021c5:	83 ec 08             	sub    $0x8,%esp
  8021c8:	56                   	push   %esi
  8021c9:	6a 00                	push   $0x0
  8021cb:	e8 fa ec ff ff       	call   800eca <sys_page_unmap>
  8021d0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8021d3:	83 ec 08             	sub    $0x8,%esp
  8021d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8021d9:	6a 00                	push   $0x0
  8021db:	e8 ea ec ff ff       	call   800eca <sys_page_unmap>
  8021e0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8021e3:	83 ec 08             	sub    $0x8,%esp
  8021e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e9:	6a 00                	push   $0x0
  8021eb:	e8 da ec ff ff       	call   800eca <sys_page_unmap>
  8021f0:	83 c4 10             	add    $0x10,%esp
}
  8021f3:	89 d8                	mov    %ebx,%eax
  8021f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f8:	5b                   	pop    %ebx
  8021f9:	5e                   	pop    %esi
  8021fa:	5d                   	pop    %ebp
  8021fb:	c3                   	ret    

008021fc <pipeisclosed>:
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802202:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802205:	50                   	push   %eax
  802206:	ff 75 08             	pushl  0x8(%ebp)
  802209:	e8 a5 ef ff ff       	call   8011b3 <fd_lookup>
  80220e:	83 c4 10             	add    $0x10,%esp
  802211:	85 c0                	test   %eax,%eax
  802213:	78 18                	js     80222d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802215:	83 ec 0c             	sub    $0xc,%esp
  802218:	ff 75 f4             	pushl  -0xc(%ebp)
  80221b:	e8 2a ef ff ff       	call   80114a <fd2data>
	return _pipeisclosed(fd, p);
  802220:	89 c2                	mov    %eax,%edx
  802222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802225:	e8 2f fd ff ff       	call   801f59 <_pipeisclosed>
  80222a:	83 c4 10             	add    $0x10,%esp
}
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80222f:	b8 00 00 00 00       	mov    $0x0,%eax
  802234:	c3                   	ret    

00802235 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80223b:	68 b3 2c 80 00       	push   $0x802cb3
  802240:	ff 75 0c             	pushl  0xc(%ebp)
  802243:	e8 0b e8 ff ff       	call   800a53 <strcpy>
	return 0;
}
  802248:	b8 00 00 00 00       	mov    $0x0,%eax
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <devcons_write>:
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	57                   	push   %edi
  802253:	56                   	push   %esi
  802254:	53                   	push   %ebx
  802255:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80225b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802260:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802266:	3b 75 10             	cmp    0x10(%ebp),%esi
  802269:	73 31                	jae    80229c <devcons_write+0x4d>
		m = n - tot;
  80226b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80226e:	29 f3                	sub    %esi,%ebx
  802270:	83 fb 7f             	cmp    $0x7f,%ebx
  802273:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802278:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80227b:	83 ec 04             	sub    $0x4,%esp
  80227e:	53                   	push   %ebx
  80227f:	89 f0                	mov    %esi,%eax
  802281:	03 45 0c             	add    0xc(%ebp),%eax
  802284:	50                   	push   %eax
  802285:	57                   	push   %edi
  802286:	e8 56 e9 ff ff       	call   800be1 <memmove>
		sys_cputs(buf, m);
  80228b:	83 c4 08             	add    $0x8,%esp
  80228e:	53                   	push   %ebx
  80228f:	57                   	push   %edi
  802290:	e8 f4 ea ff ff       	call   800d89 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802295:	01 de                	add    %ebx,%esi
  802297:	83 c4 10             	add    $0x10,%esp
  80229a:	eb ca                	jmp    802266 <devcons_write+0x17>
}
  80229c:	89 f0                	mov    %esi,%eax
  80229e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022a1:	5b                   	pop    %ebx
  8022a2:	5e                   	pop    %esi
  8022a3:	5f                   	pop    %edi
  8022a4:	5d                   	pop    %ebp
  8022a5:	c3                   	ret    

008022a6 <devcons_read>:
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 08             	sub    $0x8,%esp
  8022ac:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022b5:	74 21                	je     8022d8 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8022b7:	e8 eb ea ff ff       	call   800da7 <sys_cgetc>
  8022bc:	85 c0                	test   %eax,%eax
  8022be:	75 07                	jne    8022c7 <devcons_read+0x21>
		sys_yield();
  8022c0:	e8 61 eb ff ff       	call   800e26 <sys_yield>
  8022c5:	eb f0                	jmp    8022b7 <devcons_read+0x11>
	if (c < 0)
  8022c7:	78 0f                	js     8022d8 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8022c9:	83 f8 04             	cmp    $0x4,%eax
  8022cc:	74 0c                	je     8022da <devcons_read+0x34>
	*(char*)vbuf = c;
  8022ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d1:	88 02                	mov    %al,(%edx)
	return 1;
  8022d3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    
		return 0;
  8022da:	b8 00 00 00 00       	mov    $0x0,%eax
  8022df:	eb f7                	jmp    8022d8 <devcons_read+0x32>

008022e1 <cputchar>:
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
  8022e4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8022ed:	6a 01                	push   $0x1
  8022ef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022f2:	50                   	push   %eax
  8022f3:	e8 91 ea ff ff       	call   800d89 <sys_cputs>
}
  8022f8:	83 c4 10             	add    $0x10,%esp
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <getchar>:
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802303:	6a 01                	push   $0x1
  802305:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802308:	50                   	push   %eax
  802309:	6a 00                	push   $0x0
  80230b:	e8 13 f1 ff ff       	call   801423 <read>
	if (r < 0)
  802310:	83 c4 10             	add    $0x10,%esp
  802313:	85 c0                	test   %eax,%eax
  802315:	78 06                	js     80231d <getchar+0x20>
	if (r < 1)
  802317:	74 06                	je     80231f <getchar+0x22>
	return c;
  802319:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80231d:	c9                   	leave  
  80231e:	c3                   	ret    
		return -E_EOF;
  80231f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802324:	eb f7                	jmp    80231d <getchar+0x20>

00802326 <iscons>:
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
  802329:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80232c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80232f:	50                   	push   %eax
  802330:	ff 75 08             	pushl  0x8(%ebp)
  802333:	e8 7b ee ff ff       	call   8011b3 <fd_lookup>
  802338:	83 c4 10             	add    $0x10,%esp
  80233b:	85 c0                	test   %eax,%eax
  80233d:	78 11                	js     802350 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80233f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802342:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802348:	39 10                	cmp    %edx,(%eax)
  80234a:	0f 94 c0             	sete   %al
  80234d:	0f b6 c0             	movzbl %al,%eax
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <opencons>:
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802358:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80235b:	50                   	push   %eax
  80235c:	e8 00 ee ff ff       	call   801161 <fd_alloc>
  802361:	83 c4 10             	add    $0x10,%esp
  802364:	85 c0                	test   %eax,%eax
  802366:	78 3a                	js     8023a2 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802368:	83 ec 04             	sub    $0x4,%esp
  80236b:	68 07 04 00 00       	push   $0x407
  802370:	ff 75 f4             	pushl  -0xc(%ebp)
  802373:	6a 00                	push   $0x0
  802375:	e8 cb ea ff ff       	call   800e45 <sys_page_alloc>
  80237a:	83 c4 10             	add    $0x10,%esp
  80237d:	85 c0                	test   %eax,%eax
  80237f:	78 21                	js     8023a2 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  80238a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802396:	83 ec 0c             	sub    $0xc,%esp
  802399:	50                   	push   %eax
  80239a:	e8 9b ed ff ff       	call   80113a <fd2num>
  80239f:	83 c4 10             	add    $0x10,%esp
}
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
  8023a7:	56                   	push   %esi
  8023a8:	53                   	push   %ebx
  8023a9:	8b 75 08             	mov    0x8(%ebp),%esi
  8023ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023af:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8023b2:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8023b4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8023b9:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8023bc:	83 ec 0c             	sub    $0xc,%esp
  8023bf:	50                   	push   %eax
  8023c0:	e8 30 ec ff ff       	call   800ff5 <sys_ipc_recv>
	if(ret < 0){
  8023c5:	83 c4 10             	add    $0x10,%esp
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	78 2b                	js     8023f7 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8023cc:	85 f6                	test   %esi,%esi
  8023ce:	74 0a                	je     8023da <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8023d0:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8023d5:	8b 40 78             	mov    0x78(%eax),%eax
  8023d8:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8023da:	85 db                	test   %ebx,%ebx
  8023dc:	74 0a                	je     8023e8 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8023de:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8023e3:	8b 40 7c             	mov    0x7c(%eax),%eax
  8023e6:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8023e8:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8023ed:	8b 40 74             	mov    0x74(%eax),%eax
}
  8023f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023f3:	5b                   	pop    %ebx
  8023f4:	5e                   	pop    %esi
  8023f5:	5d                   	pop    %ebp
  8023f6:	c3                   	ret    
		if(from_env_store)
  8023f7:	85 f6                	test   %esi,%esi
  8023f9:	74 06                	je     802401 <ipc_recv+0x5d>
			*from_env_store = 0;
  8023fb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802401:	85 db                	test   %ebx,%ebx
  802403:	74 eb                	je     8023f0 <ipc_recv+0x4c>
			*perm_store = 0;
  802405:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80240b:	eb e3                	jmp    8023f0 <ipc_recv+0x4c>

0080240d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
  802410:	57                   	push   %edi
  802411:	56                   	push   %esi
  802412:	53                   	push   %ebx
  802413:	83 ec 0c             	sub    $0xc,%esp
  802416:	8b 7d 08             	mov    0x8(%ebp),%edi
  802419:	8b 75 0c             	mov    0xc(%ebp),%esi
  80241c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80241f:	85 db                	test   %ebx,%ebx
  802421:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802426:	0f 44 d8             	cmove  %eax,%ebx
  802429:	eb 05                	jmp    802430 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80242b:	e8 f6 e9 ff ff       	call   800e26 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802430:	ff 75 14             	pushl  0x14(%ebp)
  802433:	53                   	push   %ebx
  802434:	56                   	push   %esi
  802435:	57                   	push   %edi
  802436:	e8 97 eb ff ff       	call   800fd2 <sys_ipc_try_send>
  80243b:	83 c4 10             	add    $0x10,%esp
  80243e:	85 c0                	test   %eax,%eax
  802440:	74 1b                	je     80245d <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802442:	79 e7                	jns    80242b <ipc_send+0x1e>
  802444:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802447:	74 e2                	je     80242b <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802449:	83 ec 04             	sub    $0x4,%esp
  80244c:	68 bf 2c 80 00       	push   $0x802cbf
  802451:	6a 46                	push   $0x46
  802453:	68 d4 2c 80 00       	push   $0x802cd4
  802458:	e8 a1 dd ff ff       	call   8001fe <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80245d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802460:	5b                   	pop    %ebx
  802461:	5e                   	pop    %esi
  802462:	5f                   	pop    %edi
  802463:	5d                   	pop    %ebp
  802464:	c3                   	ret    

00802465 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
  802468:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80246b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802470:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802476:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80247c:	8b 52 50             	mov    0x50(%edx),%edx
  80247f:	39 ca                	cmp    %ecx,%edx
  802481:	74 11                	je     802494 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802483:	83 c0 01             	add    $0x1,%eax
  802486:	3d 00 04 00 00       	cmp    $0x400,%eax
  80248b:	75 e3                	jne    802470 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80248d:	b8 00 00 00 00       	mov    $0x0,%eax
  802492:	eb 0e                	jmp    8024a2 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802494:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80249a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80249f:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024a2:	5d                   	pop    %ebp
  8024a3:	c3                   	ret    

008024a4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
  8024a7:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024aa:	89 d0                	mov    %edx,%eax
  8024ac:	c1 e8 16             	shr    $0x16,%eax
  8024af:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024b6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024bb:	f6 c1 01             	test   $0x1,%cl
  8024be:	74 1d                	je     8024dd <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024c0:	c1 ea 0c             	shr    $0xc,%edx
  8024c3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024ca:	f6 c2 01             	test   $0x1,%dl
  8024cd:	74 0e                	je     8024dd <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024cf:	c1 ea 0c             	shr    $0xc,%edx
  8024d2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024d9:	ef 
  8024da:	0f b7 c0             	movzwl %ax,%eax
}
  8024dd:	5d                   	pop    %ebp
  8024de:	c3                   	ret    
  8024df:	90                   	nop

008024e0 <__udivdi3>:
  8024e0:	55                   	push   %ebp
  8024e1:	57                   	push   %edi
  8024e2:	56                   	push   %esi
  8024e3:	53                   	push   %ebx
  8024e4:	83 ec 1c             	sub    $0x1c,%esp
  8024e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8024eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8024ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024f7:	85 d2                	test   %edx,%edx
  8024f9:	75 4d                	jne    802548 <__udivdi3+0x68>
  8024fb:	39 f3                	cmp    %esi,%ebx
  8024fd:	76 19                	jbe    802518 <__udivdi3+0x38>
  8024ff:	31 ff                	xor    %edi,%edi
  802501:	89 e8                	mov    %ebp,%eax
  802503:	89 f2                	mov    %esi,%edx
  802505:	f7 f3                	div    %ebx
  802507:	89 fa                	mov    %edi,%edx
  802509:	83 c4 1c             	add    $0x1c,%esp
  80250c:	5b                   	pop    %ebx
  80250d:	5e                   	pop    %esi
  80250e:	5f                   	pop    %edi
  80250f:	5d                   	pop    %ebp
  802510:	c3                   	ret    
  802511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802518:	89 d9                	mov    %ebx,%ecx
  80251a:	85 db                	test   %ebx,%ebx
  80251c:	75 0b                	jne    802529 <__udivdi3+0x49>
  80251e:	b8 01 00 00 00       	mov    $0x1,%eax
  802523:	31 d2                	xor    %edx,%edx
  802525:	f7 f3                	div    %ebx
  802527:	89 c1                	mov    %eax,%ecx
  802529:	31 d2                	xor    %edx,%edx
  80252b:	89 f0                	mov    %esi,%eax
  80252d:	f7 f1                	div    %ecx
  80252f:	89 c6                	mov    %eax,%esi
  802531:	89 e8                	mov    %ebp,%eax
  802533:	89 f7                	mov    %esi,%edi
  802535:	f7 f1                	div    %ecx
  802537:	89 fa                	mov    %edi,%edx
  802539:	83 c4 1c             	add    $0x1c,%esp
  80253c:	5b                   	pop    %ebx
  80253d:	5e                   	pop    %esi
  80253e:	5f                   	pop    %edi
  80253f:	5d                   	pop    %ebp
  802540:	c3                   	ret    
  802541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802548:	39 f2                	cmp    %esi,%edx
  80254a:	77 1c                	ja     802568 <__udivdi3+0x88>
  80254c:	0f bd fa             	bsr    %edx,%edi
  80254f:	83 f7 1f             	xor    $0x1f,%edi
  802552:	75 2c                	jne    802580 <__udivdi3+0xa0>
  802554:	39 f2                	cmp    %esi,%edx
  802556:	72 06                	jb     80255e <__udivdi3+0x7e>
  802558:	31 c0                	xor    %eax,%eax
  80255a:	39 eb                	cmp    %ebp,%ebx
  80255c:	77 a9                	ja     802507 <__udivdi3+0x27>
  80255e:	b8 01 00 00 00       	mov    $0x1,%eax
  802563:	eb a2                	jmp    802507 <__udivdi3+0x27>
  802565:	8d 76 00             	lea    0x0(%esi),%esi
  802568:	31 ff                	xor    %edi,%edi
  80256a:	31 c0                	xor    %eax,%eax
  80256c:	89 fa                	mov    %edi,%edx
  80256e:	83 c4 1c             	add    $0x1c,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    
  802576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80257d:	8d 76 00             	lea    0x0(%esi),%esi
  802580:	89 f9                	mov    %edi,%ecx
  802582:	b8 20 00 00 00       	mov    $0x20,%eax
  802587:	29 f8                	sub    %edi,%eax
  802589:	d3 e2                	shl    %cl,%edx
  80258b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80258f:	89 c1                	mov    %eax,%ecx
  802591:	89 da                	mov    %ebx,%edx
  802593:	d3 ea                	shr    %cl,%edx
  802595:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802599:	09 d1                	or     %edx,%ecx
  80259b:	89 f2                	mov    %esi,%edx
  80259d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025a1:	89 f9                	mov    %edi,%ecx
  8025a3:	d3 e3                	shl    %cl,%ebx
  8025a5:	89 c1                	mov    %eax,%ecx
  8025a7:	d3 ea                	shr    %cl,%edx
  8025a9:	89 f9                	mov    %edi,%ecx
  8025ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025af:	89 eb                	mov    %ebp,%ebx
  8025b1:	d3 e6                	shl    %cl,%esi
  8025b3:	89 c1                	mov    %eax,%ecx
  8025b5:	d3 eb                	shr    %cl,%ebx
  8025b7:	09 de                	or     %ebx,%esi
  8025b9:	89 f0                	mov    %esi,%eax
  8025bb:	f7 74 24 08          	divl   0x8(%esp)
  8025bf:	89 d6                	mov    %edx,%esi
  8025c1:	89 c3                	mov    %eax,%ebx
  8025c3:	f7 64 24 0c          	mull   0xc(%esp)
  8025c7:	39 d6                	cmp    %edx,%esi
  8025c9:	72 15                	jb     8025e0 <__udivdi3+0x100>
  8025cb:	89 f9                	mov    %edi,%ecx
  8025cd:	d3 e5                	shl    %cl,%ebp
  8025cf:	39 c5                	cmp    %eax,%ebp
  8025d1:	73 04                	jae    8025d7 <__udivdi3+0xf7>
  8025d3:	39 d6                	cmp    %edx,%esi
  8025d5:	74 09                	je     8025e0 <__udivdi3+0x100>
  8025d7:	89 d8                	mov    %ebx,%eax
  8025d9:	31 ff                	xor    %edi,%edi
  8025db:	e9 27 ff ff ff       	jmp    802507 <__udivdi3+0x27>
  8025e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025e3:	31 ff                	xor    %edi,%edi
  8025e5:	e9 1d ff ff ff       	jmp    802507 <__udivdi3+0x27>
  8025ea:	66 90                	xchg   %ax,%ax
  8025ec:	66 90                	xchg   %ax,%ax
  8025ee:	66 90                	xchg   %ax,%ax

008025f0 <__umoddi3>:
  8025f0:	55                   	push   %ebp
  8025f1:	57                   	push   %edi
  8025f2:	56                   	push   %esi
  8025f3:	53                   	push   %ebx
  8025f4:	83 ec 1c             	sub    $0x1c,%esp
  8025f7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8025ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802603:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802607:	89 da                	mov    %ebx,%edx
  802609:	85 c0                	test   %eax,%eax
  80260b:	75 43                	jne    802650 <__umoddi3+0x60>
  80260d:	39 df                	cmp    %ebx,%edi
  80260f:	76 17                	jbe    802628 <__umoddi3+0x38>
  802611:	89 f0                	mov    %esi,%eax
  802613:	f7 f7                	div    %edi
  802615:	89 d0                	mov    %edx,%eax
  802617:	31 d2                	xor    %edx,%edx
  802619:	83 c4 1c             	add    $0x1c,%esp
  80261c:	5b                   	pop    %ebx
  80261d:	5e                   	pop    %esi
  80261e:	5f                   	pop    %edi
  80261f:	5d                   	pop    %ebp
  802620:	c3                   	ret    
  802621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802628:	89 fd                	mov    %edi,%ebp
  80262a:	85 ff                	test   %edi,%edi
  80262c:	75 0b                	jne    802639 <__umoddi3+0x49>
  80262e:	b8 01 00 00 00       	mov    $0x1,%eax
  802633:	31 d2                	xor    %edx,%edx
  802635:	f7 f7                	div    %edi
  802637:	89 c5                	mov    %eax,%ebp
  802639:	89 d8                	mov    %ebx,%eax
  80263b:	31 d2                	xor    %edx,%edx
  80263d:	f7 f5                	div    %ebp
  80263f:	89 f0                	mov    %esi,%eax
  802641:	f7 f5                	div    %ebp
  802643:	89 d0                	mov    %edx,%eax
  802645:	eb d0                	jmp    802617 <__umoddi3+0x27>
  802647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80264e:	66 90                	xchg   %ax,%ax
  802650:	89 f1                	mov    %esi,%ecx
  802652:	39 d8                	cmp    %ebx,%eax
  802654:	76 0a                	jbe    802660 <__umoddi3+0x70>
  802656:	89 f0                	mov    %esi,%eax
  802658:	83 c4 1c             	add    $0x1c,%esp
  80265b:	5b                   	pop    %ebx
  80265c:	5e                   	pop    %esi
  80265d:	5f                   	pop    %edi
  80265e:	5d                   	pop    %ebp
  80265f:	c3                   	ret    
  802660:	0f bd e8             	bsr    %eax,%ebp
  802663:	83 f5 1f             	xor    $0x1f,%ebp
  802666:	75 20                	jne    802688 <__umoddi3+0x98>
  802668:	39 d8                	cmp    %ebx,%eax
  80266a:	0f 82 b0 00 00 00    	jb     802720 <__umoddi3+0x130>
  802670:	39 f7                	cmp    %esi,%edi
  802672:	0f 86 a8 00 00 00    	jbe    802720 <__umoddi3+0x130>
  802678:	89 c8                	mov    %ecx,%eax
  80267a:	83 c4 1c             	add    $0x1c,%esp
  80267d:	5b                   	pop    %ebx
  80267e:	5e                   	pop    %esi
  80267f:	5f                   	pop    %edi
  802680:	5d                   	pop    %ebp
  802681:	c3                   	ret    
  802682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802688:	89 e9                	mov    %ebp,%ecx
  80268a:	ba 20 00 00 00       	mov    $0x20,%edx
  80268f:	29 ea                	sub    %ebp,%edx
  802691:	d3 e0                	shl    %cl,%eax
  802693:	89 44 24 08          	mov    %eax,0x8(%esp)
  802697:	89 d1                	mov    %edx,%ecx
  802699:	89 f8                	mov    %edi,%eax
  80269b:	d3 e8                	shr    %cl,%eax
  80269d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026a9:	09 c1                	or     %eax,%ecx
  8026ab:	89 d8                	mov    %ebx,%eax
  8026ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026b1:	89 e9                	mov    %ebp,%ecx
  8026b3:	d3 e7                	shl    %cl,%edi
  8026b5:	89 d1                	mov    %edx,%ecx
  8026b7:	d3 e8                	shr    %cl,%eax
  8026b9:	89 e9                	mov    %ebp,%ecx
  8026bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026bf:	d3 e3                	shl    %cl,%ebx
  8026c1:	89 c7                	mov    %eax,%edi
  8026c3:	89 d1                	mov    %edx,%ecx
  8026c5:	89 f0                	mov    %esi,%eax
  8026c7:	d3 e8                	shr    %cl,%eax
  8026c9:	89 e9                	mov    %ebp,%ecx
  8026cb:	89 fa                	mov    %edi,%edx
  8026cd:	d3 e6                	shl    %cl,%esi
  8026cf:	09 d8                	or     %ebx,%eax
  8026d1:	f7 74 24 08          	divl   0x8(%esp)
  8026d5:	89 d1                	mov    %edx,%ecx
  8026d7:	89 f3                	mov    %esi,%ebx
  8026d9:	f7 64 24 0c          	mull   0xc(%esp)
  8026dd:	89 c6                	mov    %eax,%esi
  8026df:	89 d7                	mov    %edx,%edi
  8026e1:	39 d1                	cmp    %edx,%ecx
  8026e3:	72 06                	jb     8026eb <__umoddi3+0xfb>
  8026e5:	75 10                	jne    8026f7 <__umoddi3+0x107>
  8026e7:	39 c3                	cmp    %eax,%ebx
  8026e9:	73 0c                	jae    8026f7 <__umoddi3+0x107>
  8026eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8026ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8026f3:	89 d7                	mov    %edx,%edi
  8026f5:	89 c6                	mov    %eax,%esi
  8026f7:	89 ca                	mov    %ecx,%edx
  8026f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026fe:	29 f3                	sub    %esi,%ebx
  802700:	19 fa                	sbb    %edi,%edx
  802702:	89 d0                	mov    %edx,%eax
  802704:	d3 e0                	shl    %cl,%eax
  802706:	89 e9                	mov    %ebp,%ecx
  802708:	d3 eb                	shr    %cl,%ebx
  80270a:	d3 ea                	shr    %cl,%edx
  80270c:	09 d8                	or     %ebx,%eax
  80270e:	83 c4 1c             	add    $0x1c,%esp
  802711:	5b                   	pop    %ebx
  802712:	5e                   	pop    %esi
  802713:	5f                   	pop    %edi
  802714:	5d                   	pop    %ebp
  802715:	c3                   	ret    
  802716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80271d:	8d 76 00             	lea    0x0(%esi),%esi
  802720:	89 da                	mov    %ebx,%edx
  802722:	29 fe                	sub    %edi,%esi
  802724:	19 c2                	sbb    %eax,%edx
  802726:	89 f1                	mov    %esi,%ecx
  802728:	89 c8                	mov    %ecx,%eax
  80272a:	e9 4b ff ff ff       	jmp    80267a <__umoddi3+0x8a>
