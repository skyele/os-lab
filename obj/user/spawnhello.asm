
obj/user/spawnhello.debug:     file format elf32-i386


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
  80002c:	e8 4a 00 00 00       	call   80007b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 04 40 80 00       	mov    0x804004,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	50                   	push   %eax
  800042:	68 20 25 80 00       	push   $0x802520
  800047:	e8 cc 01 00 00       	call   800218 <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  80004c:	83 c4 0c             	add    $0xc,%esp
  80004f:	6a 00                	push   $0x0
  800051:	68 3e 25 80 00       	push   $0x80253e
  800056:	68 3e 25 80 00       	push   $0x80253e
  80005b:	e8 1d 14 00 00       	call   80147d <spawnl>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	85 c0                	test   %eax,%eax
  800065:	78 02                	js     800069 <umain+0x36>
		panic("spawn(hello) failed: %e", r);
}
  800067:	c9                   	leave  
  800068:	c3                   	ret    
		panic("spawn(hello) failed: %e", r);
  800069:	50                   	push   %eax
  80006a:	68 44 25 80 00       	push   $0x802544
  80006f:	6a 09                	push   $0x9
  800071:	68 5c 25 80 00       	push   $0x80255c
  800076:	e8 a7 00 00 00       	call   800122 <_panic>

0080007b <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80007b:	55                   	push   %ebp
  80007c:	89 e5                	mov    %esp,%ebp
  80007e:	57                   	push   %edi
  80007f:	56                   	push   %esi
  800080:	53                   	push   %ebx
  800081:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800084:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80008b:	00 00 00 
	envid_t find = sys_getenvid();
  80008e:	e8 98 0c 00 00       	call   800d2b <sys_getenvid>
  800093:	8b 1d 04 40 80 00    	mov    0x804004,%ebx
  800099:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80009e:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000a3:	bf 01 00 00 00       	mov    $0x1,%edi
  8000a8:	eb 0b                	jmp    8000b5 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000aa:	83 c2 01             	add    $0x1,%edx
  8000ad:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000b3:	74 21                	je     8000d6 <libmain+0x5b>
		if(envs[i].env_id == find)
  8000b5:	89 d1                	mov    %edx,%ecx
  8000b7:	c1 e1 07             	shl    $0x7,%ecx
  8000ba:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000c0:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000c3:	39 c1                	cmp    %eax,%ecx
  8000c5:	75 e3                	jne    8000aa <libmain+0x2f>
  8000c7:	89 d3                	mov    %edx,%ebx
  8000c9:	c1 e3 07             	shl    $0x7,%ebx
  8000cc:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000d2:	89 fe                	mov    %edi,%esi
  8000d4:	eb d4                	jmp    8000aa <libmain+0x2f>
  8000d6:	89 f0                	mov    %esi,%eax
  8000d8:	84 c0                	test   %al,%al
  8000da:	74 06                	je     8000e2 <libmain+0x67>
  8000dc:	89 1d 04 40 80 00    	mov    %ebx,0x804004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000e6:	7e 0a                	jle    8000f2 <libmain+0x77>
		binaryname = argv[0];
  8000e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000eb:	8b 00                	mov    (%eax),%eax
  8000ed:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f2:	83 ec 08             	sub    $0x8,%esp
  8000f5:	ff 75 0c             	pushl  0xc(%ebp)
  8000f8:	ff 75 08             	pushl  0x8(%ebp)
  8000fb:	e8 33 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800100:	e8 0b 00 00 00       	call   800110 <exit>
}
  800105:	83 c4 10             	add    $0x10,%esp
  800108:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010b:	5b                   	pop    %ebx
  80010c:	5e                   	pop    %esi
  80010d:	5f                   	pop    %edi
  80010e:	5d                   	pop    %ebp
  80010f:	c3                   	ret    

00800110 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800116:	6a 00                	push   $0x0
  800118:	e8 cd 0b 00 00       	call   800cea <sys_env_destroy>
}
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	c9                   	leave  
  800121:	c3                   	ret    

00800122 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	56                   	push   %esi
  800126:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800127:	a1 04 40 80 00       	mov    0x804004,%eax
  80012c:	8b 40 48             	mov    0x48(%eax),%eax
  80012f:	83 ec 04             	sub    $0x4,%esp
  800132:	68 a8 25 80 00       	push   $0x8025a8
  800137:	50                   	push   %eax
  800138:	68 78 25 80 00       	push   $0x802578
  80013d:	e8 d6 00 00 00       	call   800218 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800142:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800145:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80014b:	e8 db 0b 00 00       	call   800d2b <sys_getenvid>
  800150:	83 c4 04             	add    $0x4,%esp
  800153:	ff 75 0c             	pushl  0xc(%ebp)
  800156:	ff 75 08             	pushl  0x8(%ebp)
  800159:	56                   	push   %esi
  80015a:	50                   	push   %eax
  80015b:	68 84 25 80 00       	push   $0x802584
  800160:	e8 b3 00 00 00       	call   800218 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800165:	83 c4 18             	add    $0x18,%esp
  800168:	53                   	push   %ebx
  800169:	ff 75 10             	pushl  0x10(%ebp)
  80016c:	e8 56 00 00 00       	call   8001c7 <vcprintf>
	cprintf("\n");
  800171:	c7 04 24 06 2b 80 00 	movl   $0x802b06,(%esp)
  800178:	e8 9b 00 00 00       	call   800218 <cprintf>
  80017d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800180:	cc                   	int3   
  800181:	eb fd                	jmp    800180 <_panic+0x5e>

00800183 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800183:	55                   	push   %ebp
  800184:	89 e5                	mov    %esp,%ebp
  800186:	53                   	push   %ebx
  800187:	83 ec 04             	sub    $0x4,%esp
  80018a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80018d:	8b 13                	mov    (%ebx),%edx
  80018f:	8d 42 01             	lea    0x1(%edx),%eax
  800192:	89 03                	mov    %eax,(%ebx)
  800194:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800197:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80019b:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a0:	74 09                	je     8001ab <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a2:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a9:	c9                   	leave  
  8001aa:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001ab:	83 ec 08             	sub    $0x8,%esp
  8001ae:	68 ff 00 00 00       	push   $0xff
  8001b3:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b6:	50                   	push   %eax
  8001b7:	e8 f1 0a 00 00       	call   800cad <sys_cputs>
		b->idx = 0;
  8001bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	eb db                	jmp    8001a2 <putch+0x1f>

008001c7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001d7:	00 00 00 
	b.cnt = 0;
  8001da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e4:	ff 75 0c             	pushl  0xc(%ebp)
  8001e7:	ff 75 08             	pushl  0x8(%ebp)
  8001ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f0:	50                   	push   %eax
  8001f1:	68 83 01 80 00       	push   $0x800183
  8001f6:	e8 4a 01 00 00       	call   800345 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001fb:	83 c4 08             	add    $0x8,%esp
  8001fe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800204:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80020a:	50                   	push   %eax
  80020b:	e8 9d 0a 00 00       	call   800cad <sys_cputs>

	return b.cnt;
}
  800210:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800216:	c9                   	leave  
  800217:	c3                   	ret    

00800218 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80021e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800221:	50                   	push   %eax
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	e8 9d ff ff ff       	call   8001c7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80022a:	c9                   	leave  
  80022b:	c3                   	ret    

0080022c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	57                   	push   %edi
  800230:	56                   	push   %esi
  800231:	53                   	push   %ebx
  800232:	83 ec 1c             	sub    $0x1c,%esp
  800235:	89 c6                	mov    %eax,%esi
  800237:	89 d7                	mov    %edx,%edi
  800239:	8b 45 08             	mov    0x8(%ebp),%eax
  80023c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800242:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800245:	8b 45 10             	mov    0x10(%ebp),%eax
  800248:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80024b:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80024f:	74 2c                	je     80027d <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800251:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800254:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80025b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80025e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800261:	39 c2                	cmp    %eax,%edx
  800263:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800266:	73 43                	jae    8002ab <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800268:	83 eb 01             	sub    $0x1,%ebx
  80026b:	85 db                	test   %ebx,%ebx
  80026d:	7e 6c                	jle    8002db <printnum+0xaf>
				putch(padc, putdat);
  80026f:	83 ec 08             	sub    $0x8,%esp
  800272:	57                   	push   %edi
  800273:	ff 75 18             	pushl  0x18(%ebp)
  800276:	ff d6                	call   *%esi
  800278:	83 c4 10             	add    $0x10,%esp
  80027b:	eb eb                	jmp    800268 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80027d:	83 ec 0c             	sub    $0xc,%esp
  800280:	6a 20                	push   $0x20
  800282:	6a 00                	push   $0x0
  800284:	50                   	push   %eax
  800285:	ff 75 e4             	pushl  -0x1c(%ebp)
  800288:	ff 75 e0             	pushl  -0x20(%ebp)
  80028b:	89 fa                	mov    %edi,%edx
  80028d:	89 f0                	mov    %esi,%eax
  80028f:	e8 98 ff ff ff       	call   80022c <printnum>
		while (--width > 0)
  800294:	83 c4 20             	add    $0x20,%esp
  800297:	83 eb 01             	sub    $0x1,%ebx
  80029a:	85 db                	test   %ebx,%ebx
  80029c:	7e 65                	jle    800303 <printnum+0xd7>
			putch(padc, putdat);
  80029e:	83 ec 08             	sub    $0x8,%esp
  8002a1:	57                   	push   %edi
  8002a2:	6a 20                	push   $0x20
  8002a4:	ff d6                	call   *%esi
  8002a6:	83 c4 10             	add    $0x10,%esp
  8002a9:	eb ec                	jmp    800297 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	ff 75 18             	pushl  0x18(%ebp)
  8002b1:	83 eb 01             	sub    $0x1,%ebx
  8002b4:	53                   	push   %ebx
  8002b5:	50                   	push   %eax
  8002b6:	83 ec 08             	sub    $0x8,%esp
  8002b9:	ff 75 dc             	pushl  -0x24(%ebp)
  8002bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8002bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c2:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c5:	e8 f6 1f 00 00       	call   8022c0 <__udivdi3>
  8002ca:	83 c4 18             	add    $0x18,%esp
  8002cd:	52                   	push   %edx
  8002ce:	50                   	push   %eax
  8002cf:	89 fa                	mov    %edi,%edx
  8002d1:	89 f0                	mov    %esi,%eax
  8002d3:	e8 54 ff ff ff       	call   80022c <printnum>
  8002d8:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	57                   	push   %edi
  8002df:	83 ec 04             	sub    $0x4,%esp
  8002e2:	ff 75 dc             	pushl  -0x24(%ebp)
  8002e5:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002eb:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ee:	e8 dd 20 00 00       	call   8023d0 <__umoddi3>
  8002f3:	83 c4 14             	add    $0x14,%esp
  8002f6:	0f be 80 af 25 80 00 	movsbl 0x8025af(%eax),%eax
  8002fd:	50                   	push   %eax
  8002fe:	ff d6                	call   *%esi
  800300:	83 c4 10             	add    $0x10,%esp
	}
}
  800303:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800306:	5b                   	pop    %ebx
  800307:	5e                   	pop    %esi
  800308:	5f                   	pop    %edi
  800309:	5d                   	pop    %ebp
  80030a:	c3                   	ret    

0080030b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800311:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800315:	8b 10                	mov    (%eax),%edx
  800317:	3b 50 04             	cmp    0x4(%eax),%edx
  80031a:	73 0a                	jae    800326 <sprintputch+0x1b>
		*b->buf++ = ch;
  80031c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80031f:	89 08                	mov    %ecx,(%eax)
  800321:	8b 45 08             	mov    0x8(%ebp),%eax
  800324:	88 02                	mov    %al,(%edx)
}
  800326:	5d                   	pop    %ebp
  800327:	c3                   	ret    

00800328 <printfmt>:
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80032e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800331:	50                   	push   %eax
  800332:	ff 75 10             	pushl  0x10(%ebp)
  800335:	ff 75 0c             	pushl  0xc(%ebp)
  800338:	ff 75 08             	pushl  0x8(%ebp)
  80033b:	e8 05 00 00 00       	call   800345 <vprintfmt>
}
  800340:	83 c4 10             	add    $0x10,%esp
  800343:	c9                   	leave  
  800344:	c3                   	ret    

00800345 <vprintfmt>:
{
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	57                   	push   %edi
  800349:	56                   	push   %esi
  80034a:	53                   	push   %ebx
  80034b:	83 ec 3c             	sub    $0x3c,%esp
  80034e:	8b 75 08             	mov    0x8(%ebp),%esi
  800351:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800354:	8b 7d 10             	mov    0x10(%ebp),%edi
  800357:	e9 32 04 00 00       	jmp    80078e <vprintfmt+0x449>
		padc = ' ';
  80035c:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800360:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800367:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80036e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800375:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80037c:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800383:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800388:	8d 47 01             	lea    0x1(%edi),%eax
  80038b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80038e:	0f b6 17             	movzbl (%edi),%edx
  800391:	8d 42 dd             	lea    -0x23(%edx),%eax
  800394:	3c 55                	cmp    $0x55,%al
  800396:	0f 87 12 05 00 00    	ja     8008ae <vprintfmt+0x569>
  80039c:	0f b6 c0             	movzbl %al,%eax
  80039f:	ff 24 85 80 27 80 00 	jmp    *0x802780(,%eax,4)
  8003a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003a9:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003ad:	eb d9                	jmp    800388 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003b2:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003b6:	eb d0                	jmp    800388 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003b8:	0f b6 d2             	movzbl %dl,%edx
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003be:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c3:	89 75 08             	mov    %esi,0x8(%ebp)
  8003c6:	eb 03                	jmp    8003cb <vprintfmt+0x86>
  8003c8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003cb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ce:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003d2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003d5:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003d8:	83 fe 09             	cmp    $0x9,%esi
  8003db:	76 eb                	jbe    8003c8 <vprintfmt+0x83>
  8003dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8003e3:	eb 14                	jmp    8003f9 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e8:	8b 00                	mov    (%eax),%eax
  8003ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f0:	8d 40 04             	lea    0x4(%eax),%eax
  8003f3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003fd:	79 89                	jns    800388 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800402:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800405:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80040c:	e9 77 ff ff ff       	jmp    800388 <vprintfmt+0x43>
  800411:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800414:	85 c0                	test   %eax,%eax
  800416:	0f 48 c1             	cmovs  %ecx,%eax
  800419:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80041c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80041f:	e9 64 ff ff ff       	jmp    800388 <vprintfmt+0x43>
  800424:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800427:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80042e:	e9 55 ff ff ff       	jmp    800388 <vprintfmt+0x43>
			lflag++;
  800433:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800437:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80043a:	e9 49 ff ff ff       	jmp    800388 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80043f:	8b 45 14             	mov    0x14(%ebp),%eax
  800442:	8d 78 04             	lea    0x4(%eax),%edi
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	53                   	push   %ebx
  800449:	ff 30                	pushl  (%eax)
  80044b:	ff d6                	call   *%esi
			break;
  80044d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800450:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800453:	e9 33 03 00 00       	jmp    80078b <vprintfmt+0x446>
			err = va_arg(ap, int);
  800458:	8b 45 14             	mov    0x14(%ebp),%eax
  80045b:	8d 78 04             	lea    0x4(%eax),%edi
  80045e:	8b 00                	mov    (%eax),%eax
  800460:	99                   	cltd   
  800461:	31 d0                	xor    %edx,%eax
  800463:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800465:	83 f8 0f             	cmp    $0xf,%eax
  800468:	7f 23                	jg     80048d <vprintfmt+0x148>
  80046a:	8b 14 85 e0 28 80 00 	mov    0x8028e0(,%eax,4),%edx
  800471:	85 d2                	test   %edx,%edx
  800473:	74 18                	je     80048d <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800475:	52                   	push   %edx
  800476:	68 77 29 80 00       	push   $0x802977
  80047b:	53                   	push   %ebx
  80047c:	56                   	push   %esi
  80047d:	e8 a6 fe ff ff       	call   800328 <printfmt>
  800482:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800485:	89 7d 14             	mov    %edi,0x14(%ebp)
  800488:	e9 fe 02 00 00       	jmp    80078b <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80048d:	50                   	push   %eax
  80048e:	68 c7 25 80 00       	push   $0x8025c7
  800493:	53                   	push   %ebx
  800494:	56                   	push   %esi
  800495:	e8 8e fe ff ff       	call   800328 <printfmt>
  80049a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80049d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004a0:	e9 e6 02 00 00       	jmp    80078b <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a8:	83 c0 04             	add    $0x4,%eax
  8004ab:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b1:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004b3:	85 c9                	test   %ecx,%ecx
  8004b5:	b8 c0 25 80 00       	mov    $0x8025c0,%eax
  8004ba:	0f 45 c1             	cmovne %ecx,%eax
  8004bd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c4:	7e 06                	jle    8004cc <vprintfmt+0x187>
  8004c6:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004ca:	75 0d                	jne    8004d9 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004cf:	89 c7                	mov    %eax,%edi
  8004d1:	03 45 e0             	add    -0x20(%ebp),%eax
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d7:	eb 53                	jmp    80052c <vprintfmt+0x1e7>
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	ff 75 d8             	pushl  -0x28(%ebp)
  8004df:	50                   	push   %eax
  8004e0:	e8 71 04 00 00       	call   800956 <strnlen>
  8004e5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004e8:	29 c1                	sub    %eax,%ecx
  8004ea:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004ed:	83 c4 10             	add    $0x10,%esp
  8004f0:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004f2:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f9:	eb 0f                	jmp    80050a <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004fb:	83 ec 08             	sub    $0x8,%esp
  8004fe:	53                   	push   %ebx
  8004ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800502:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800504:	83 ef 01             	sub    $0x1,%edi
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	85 ff                	test   %edi,%edi
  80050c:	7f ed                	jg     8004fb <vprintfmt+0x1b6>
  80050e:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800511:	85 c9                	test   %ecx,%ecx
  800513:	b8 00 00 00 00       	mov    $0x0,%eax
  800518:	0f 49 c1             	cmovns %ecx,%eax
  80051b:	29 c1                	sub    %eax,%ecx
  80051d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800520:	eb aa                	jmp    8004cc <vprintfmt+0x187>
					putch(ch, putdat);
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	53                   	push   %ebx
  800526:	52                   	push   %edx
  800527:	ff d6                	call   *%esi
  800529:	83 c4 10             	add    $0x10,%esp
  80052c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80052f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800531:	83 c7 01             	add    $0x1,%edi
  800534:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800538:	0f be d0             	movsbl %al,%edx
  80053b:	85 d2                	test   %edx,%edx
  80053d:	74 4b                	je     80058a <vprintfmt+0x245>
  80053f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800543:	78 06                	js     80054b <vprintfmt+0x206>
  800545:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800549:	78 1e                	js     800569 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80054b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80054f:	74 d1                	je     800522 <vprintfmt+0x1dd>
  800551:	0f be c0             	movsbl %al,%eax
  800554:	83 e8 20             	sub    $0x20,%eax
  800557:	83 f8 5e             	cmp    $0x5e,%eax
  80055a:	76 c6                	jbe    800522 <vprintfmt+0x1dd>
					putch('?', putdat);
  80055c:	83 ec 08             	sub    $0x8,%esp
  80055f:	53                   	push   %ebx
  800560:	6a 3f                	push   $0x3f
  800562:	ff d6                	call   *%esi
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	eb c3                	jmp    80052c <vprintfmt+0x1e7>
  800569:	89 cf                	mov    %ecx,%edi
  80056b:	eb 0e                	jmp    80057b <vprintfmt+0x236>
				putch(' ', putdat);
  80056d:	83 ec 08             	sub    $0x8,%esp
  800570:	53                   	push   %ebx
  800571:	6a 20                	push   $0x20
  800573:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800575:	83 ef 01             	sub    $0x1,%edi
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	85 ff                	test   %edi,%edi
  80057d:	7f ee                	jg     80056d <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80057f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
  800585:	e9 01 02 00 00       	jmp    80078b <vprintfmt+0x446>
  80058a:	89 cf                	mov    %ecx,%edi
  80058c:	eb ed                	jmp    80057b <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80058e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800591:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800598:	e9 eb fd ff ff       	jmp    800388 <vprintfmt+0x43>
	if (lflag >= 2)
  80059d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005a1:	7f 21                	jg     8005c4 <vprintfmt+0x27f>
	else if (lflag)
  8005a3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005a7:	74 68                	je     800611 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005b1:	89 c1                	mov    %eax,%ecx
  8005b3:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bc:	8d 40 04             	lea    0x4(%eax),%eax
  8005bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c2:	eb 17                	jmp    8005db <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8b 50 04             	mov    0x4(%eax),%edx
  8005ca:	8b 00                	mov    (%eax),%eax
  8005cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005cf:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8d 40 08             	lea    0x8(%eax),%eax
  8005d8:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005db:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005e7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005eb:	78 3f                	js     80062c <vprintfmt+0x2e7>
			base = 10;
  8005ed:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005f2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005f6:	0f 84 71 01 00 00    	je     80076d <vprintfmt+0x428>
				putch('+', putdat);
  8005fc:	83 ec 08             	sub    $0x8,%esp
  8005ff:	53                   	push   %ebx
  800600:	6a 2b                	push   $0x2b
  800602:	ff d6                	call   *%esi
  800604:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800607:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060c:	e9 5c 01 00 00       	jmp    80076d <vprintfmt+0x428>
		return va_arg(*ap, int);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8b 00                	mov    (%eax),%eax
  800616:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800619:	89 c1                	mov    %eax,%ecx
  80061b:	c1 f9 1f             	sar    $0x1f,%ecx
  80061e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8d 40 04             	lea    0x4(%eax),%eax
  800627:	89 45 14             	mov    %eax,0x14(%ebp)
  80062a:	eb af                	jmp    8005db <vprintfmt+0x296>
				putch('-', putdat);
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	53                   	push   %ebx
  800630:	6a 2d                	push   $0x2d
  800632:	ff d6                	call   *%esi
				num = -(long long) num;
  800634:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800637:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80063a:	f7 d8                	neg    %eax
  80063c:	83 d2 00             	adc    $0x0,%edx
  80063f:	f7 da                	neg    %edx
  800641:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800644:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800647:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80064a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80064f:	e9 19 01 00 00       	jmp    80076d <vprintfmt+0x428>
	if (lflag >= 2)
  800654:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800658:	7f 29                	jg     800683 <vprintfmt+0x33e>
	else if (lflag)
  80065a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80065e:	74 44                	je     8006a4 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8d 40 04             	lea    0x4(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800679:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067e:	e9 ea 00 00 00       	jmp    80076d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 50 04             	mov    0x4(%eax),%edx
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8d 40 08             	lea    0x8(%eax),%eax
  800697:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069f:	e9 c9 00 00 00       	jmp    80076d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006bd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c2:	e9 a6 00 00 00       	jmp    80076d <vprintfmt+0x428>
			putch('0', putdat);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	53                   	push   %ebx
  8006cb:	6a 30                	push   $0x30
  8006cd:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006d6:	7f 26                	jg     8006fe <vprintfmt+0x3b9>
	else if (lflag)
  8006d8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006dc:	74 3e                	je     80071c <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006eb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8d 40 04             	lea    0x4(%eax),%eax
  8006f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f7:	b8 08 00 00 00       	mov    $0x8,%eax
  8006fc:	eb 6f                	jmp    80076d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8b 50 04             	mov    0x4(%eax),%edx
  800704:	8b 00                	mov    (%eax),%eax
  800706:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800709:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	8d 40 08             	lea    0x8(%eax),%eax
  800712:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800715:	b8 08 00 00 00       	mov    $0x8,%eax
  80071a:	eb 51                	jmp    80076d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	ba 00 00 00 00       	mov    $0x0,%edx
  800726:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800729:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8d 40 04             	lea    0x4(%eax),%eax
  800732:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800735:	b8 08 00 00 00       	mov    $0x8,%eax
  80073a:	eb 31                	jmp    80076d <vprintfmt+0x428>
			putch('0', putdat);
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	53                   	push   %ebx
  800740:	6a 30                	push   $0x30
  800742:	ff d6                	call   *%esi
			putch('x', putdat);
  800744:	83 c4 08             	add    $0x8,%esp
  800747:	53                   	push   %ebx
  800748:	6a 78                	push   $0x78
  80074a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	ba 00 00 00 00       	mov    $0x0,%edx
  800756:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800759:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80075c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8d 40 04             	lea    0x4(%eax),%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800768:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80076d:	83 ec 0c             	sub    $0xc,%esp
  800770:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800774:	52                   	push   %edx
  800775:	ff 75 e0             	pushl  -0x20(%ebp)
  800778:	50                   	push   %eax
  800779:	ff 75 dc             	pushl  -0x24(%ebp)
  80077c:	ff 75 d8             	pushl  -0x28(%ebp)
  80077f:	89 da                	mov    %ebx,%edx
  800781:	89 f0                	mov    %esi,%eax
  800783:	e8 a4 fa ff ff       	call   80022c <printnum>
			break;
  800788:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80078b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80078e:	83 c7 01             	add    $0x1,%edi
  800791:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800795:	83 f8 25             	cmp    $0x25,%eax
  800798:	0f 84 be fb ff ff    	je     80035c <vprintfmt+0x17>
			if (ch == '\0')
  80079e:	85 c0                	test   %eax,%eax
  8007a0:	0f 84 28 01 00 00    	je     8008ce <vprintfmt+0x589>
			putch(ch, putdat);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	53                   	push   %ebx
  8007aa:	50                   	push   %eax
  8007ab:	ff d6                	call   *%esi
  8007ad:	83 c4 10             	add    $0x10,%esp
  8007b0:	eb dc                	jmp    80078e <vprintfmt+0x449>
	if (lflag >= 2)
  8007b2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007b6:	7f 26                	jg     8007de <vprintfmt+0x499>
	else if (lflag)
  8007b8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007bc:	74 41                	je     8007ff <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007be:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c1:	8b 00                	mov    (%eax),%eax
  8007c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8d 40 04             	lea    0x4(%eax),%eax
  8007d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d7:	b8 10 00 00 00       	mov    $0x10,%eax
  8007dc:	eb 8f                	jmp    80076d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8b 50 04             	mov    0x4(%eax),%edx
  8007e4:	8b 00                	mov    (%eax),%eax
  8007e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	8d 40 08             	lea    0x8(%eax),%eax
  8007f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f5:	b8 10 00 00 00       	mov    $0x10,%eax
  8007fa:	e9 6e ff ff ff       	jmp    80076d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	ba 00 00 00 00       	mov    $0x0,%edx
  800809:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	8d 40 04             	lea    0x4(%eax),%eax
  800815:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800818:	b8 10 00 00 00       	mov    $0x10,%eax
  80081d:	e9 4b ff ff ff       	jmp    80076d <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	83 c0 04             	add    $0x4,%eax
  800828:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	85 c0                	test   %eax,%eax
  800832:	74 14                	je     800848 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800834:	8b 13                	mov    (%ebx),%edx
  800836:	83 fa 7f             	cmp    $0x7f,%edx
  800839:	7f 37                	jg     800872 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80083b:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80083d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800840:	89 45 14             	mov    %eax,0x14(%ebp)
  800843:	e9 43 ff ff ff       	jmp    80078b <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800848:	b8 0a 00 00 00       	mov    $0xa,%eax
  80084d:	bf e5 26 80 00       	mov    $0x8026e5,%edi
							putch(ch, putdat);
  800852:	83 ec 08             	sub    $0x8,%esp
  800855:	53                   	push   %ebx
  800856:	50                   	push   %eax
  800857:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800859:	83 c7 01             	add    $0x1,%edi
  80085c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800860:	83 c4 10             	add    $0x10,%esp
  800863:	85 c0                	test   %eax,%eax
  800865:	75 eb                	jne    800852 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800867:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80086a:	89 45 14             	mov    %eax,0x14(%ebp)
  80086d:	e9 19 ff ff ff       	jmp    80078b <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800872:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800874:	b8 0a 00 00 00       	mov    $0xa,%eax
  800879:	bf 1d 27 80 00       	mov    $0x80271d,%edi
							putch(ch, putdat);
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	53                   	push   %ebx
  800882:	50                   	push   %eax
  800883:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800885:	83 c7 01             	add    $0x1,%edi
  800888:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	85 c0                	test   %eax,%eax
  800891:	75 eb                	jne    80087e <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800893:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800896:	89 45 14             	mov    %eax,0x14(%ebp)
  800899:	e9 ed fe ff ff       	jmp    80078b <vprintfmt+0x446>
			putch(ch, putdat);
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	53                   	push   %ebx
  8008a2:	6a 25                	push   $0x25
  8008a4:	ff d6                	call   *%esi
			break;
  8008a6:	83 c4 10             	add    $0x10,%esp
  8008a9:	e9 dd fe ff ff       	jmp    80078b <vprintfmt+0x446>
			putch('%', putdat);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	53                   	push   %ebx
  8008b2:	6a 25                	push   $0x25
  8008b4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008b6:	83 c4 10             	add    $0x10,%esp
  8008b9:	89 f8                	mov    %edi,%eax
  8008bb:	eb 03                	jmp    8008c0 <vprintfmt+0x57b>
  8008bd:	83 e8 01             	sub    $0x1,%eax
  8008c0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008c4:	75 f7                	jne    8008bd <vprintfmt+0x578>
  8008c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008c9:	e9 bd fe ff ff       	jmp    80078b <vprintfmt+0x446>
}
  8008ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008d1:	5b                   	pop    %ebx
  8008d2:	5e                   	pop    %esi
  8008d3:	5f                   	pop    %edi
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	83 ec 18             	sub    $0x18,%esp
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008e5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008e9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008f3:	85 c0                	test   %eax,%eax
  8008f5:	74 26                	je     80091d <vsnprintf+0x47>
  8008f7:	85 d2                	test   %edx,%edx
  8008f9:	7e 22                	jle    80091d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008fb:	ff 75 14             	pushl  0x14(%ebp)
  8008fe:	ff 75 10             	pushl  0x10(%ebp)
  800901:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800904:	50                   	push   %eax
  800905:	68 0b 03 80 00       	push   $0x80030b
  80090a:	e8 36 fa ff ff       	call   800345 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80090f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800912:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800918:	83 c4 10             	add    $0x10,%esp
}
  80091b:	c9                   	leave  
  80091c:	c3                   	ret    
		return -E_INVAL;
  80091d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800922:	eb f7                	jmp    80091b <vsnprintf+0x45>

00800924 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80092a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80092d:	50                   	push   %eax
  80092e:	ff 75 10             	pushl  0x10(%ebp)
  800931:	ff 75 0c             	pushl  0xc(%ebp)
  800934:	ff 75 08             	pushl  0x8(%ebp)
  800937:	e8 9a ff ff ff       	call   8008d6 <vsnprintf>
	va_end(ap);

	return rc;
}
  80093c:	c9                   	leave  
  80093d:	c3                   	ret    

0080093e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800944:	b8 00 00 00 00       	mov    $0x0,%eax
  800949:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80094d:	74 05                	je     800954 <strlen+0x16>
		n++;
  80094f:	83 c0 01             	add    $0x1,%eax
  800952:	eb f5                	jmp    800949 <strlen+0xb>
	return n;
}
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80095f:	ba 00 00 00 00       	mov    $0x0,%edx
  800964:	39 c2                	cmp    %eax,%edx
  800966:	74 0d                	je     800975 <strnlen+0x1f>
  800968:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80096c:	74 05                	je     800973 <strnlen+0x1d>
		n++;
  80096e:	83 c2 01             	add    $0x1,%edx
  800971:	eb f1                	jmp    800964 <strnlen+0xe>
  800973:	89 d0                	mov    %edx,%eax
	return n;
}
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	53                   	push   %ebx
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800981:	ba 00 00 00 00       	mov    $0x0,%edx
  800986:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80098a:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80098d:	83 c2 01             	add    $0x1,%edx
  800990:	84 c9                	test   %cl,%cl
  800992:	75 f2                	jne    800986 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800994:	5b                   	pop    %ebx
  800995:	5d                   	pop    %ebp
  800996:	c3                   	ret    

00800997 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	53                   	push   %ebx
  80099b:	83 ec 10             	sub    $0x10,%esp
  80099e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009a1:	53                   	push   %ebx
  8009a2:	e8 97 ff ff ff       	call   80093e <strlen>
  8009a7:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009aa:	ff 75 0c             	pushl  0xc(%ebp)
  8009ad:	01 d8                	add    %ebx,%eax
  8009af:	50                   	push   %eax
  8009b0:	e8 c2 ff ff ff       	call   800977 <strcpy>
	return dst;
}
  8009b5:	89 d8                	mov    %ebx,%eax
  8009b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    

008009bc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	56                   	push   %esi
  8009c0:	53                   	push   %ebx
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c7:	89 c6                	mov    %eax,%esi
  8009c9:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009cc:	89 c2                	mov    %eax,%edx
  8009ce:	39 f2                	cmp    %esi,%edx
  8009d0:	74 11                	je     8009e3 <strncpy+0x27>
		*dst++ = *src;
  8009d2:	83 c2 01             	add    $0x1,%edx
  8009d5:	0f b6 19             	movzbl (%ecx),%ebx
  8009d8:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009db:	80 fb 01             	cmp    $0x1,%bl
  8009de:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009e1:	eb eb                	jmp    8009ce <strncpy+0x12>
	}
	return ret;
}
  8009e3:	5b                   	pop    %ebx
  8009e4:	5e                   	pop    %esi
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    

008009e7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	56                   	push   %esi
  8009eb:	53                   	push   %ebx
  8009ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f2:	8b 55 10             	mov    0x10(%ebp),%edx
  8009f5:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009f7:	85 d2                	test   %edx,%edx
  8009f9:	74 21                	je     800a1c <strlcpy+0x35>
  8009fb:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009ff:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a01:	39 c2                	cmp    %eax,%edx
  800a03:	74 14                	je     800a19 <strlcpy+0x32>
  800a05:	0f b6 19             	movzbl (%ecx),%ebx
  800a08:	84 db                	test   %bl,%bl
  800a0a:	74 0b                	je     800a17 <strlcpy+0x30>
			*dst++ = *src++;
  800a0c:	83 c1 01             	add    $0x1,%ecx
  800a0f:	83 c2 01             	add    $0x1,%edx
  800a12:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a15:	eb ea                	jmp    800a01 <strlcpy+0x1a>
  800a17:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a19:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a1c:	29 f0                	sub    %esi,%eax
}
  800a1e:	5b                   	pop    %ebx
  800a1f:	5e                   	pop    %esi
  800a20:	5d                   	pop    %ebp
  800a21:	c3                   	ret    

00800a22 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a28:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a2b:	0f b6 01             	movzbl (%ecx),%eax
  800a2e:	84 c0                	test   %al,%al
  800a30:	74 0c                	je     800a3e <strcmp+0x1c>
  800a32:	3a 02                	cmp    (%edx),%al
  800a34:	75 08                	jne    800a3e <strcmp+0x1c>
		p++, q++;
  800a36:	83 c1 01             	add    $0x1,%ecx
  800a39:	83 c2 01             	add    $0x1,%edx
  800a3c:	eb ed                	jmp    800a2b <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a3e:	0f b6 c0             	movzbl %al,%eax
  800a41:	0f b6 12             	movzbl (%edx),%edx
  800a44:	29 d0                	sub    %edx,%eax
}
  800a46:	5d                   	pop    %ebp
  800a47:	c3                   	ret    

00800a48 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	53                   	push   %ebx
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a52:	89 c3                	mov    %eax,%ebx
  800a54:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a57:	eb 06                	jmp    800a5f <strncmp+0x17>
		n--, p++, q++;
  800a59:	83 c0 01             	add    $0x1,%eax
  800a5c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a5f:	39 d8                	cmp    %ebx,%eax
  800a61:	74 16                	je     800a79 <strncmp+0x31>
  800a63:	0f b6 08             	movzbl (%eax),%ecx
  800a66:	84 c9                	test   %cl,%cl
  800a68:	74 04                	je     800a6e <strncmp+0x26>
  800a6a:	3a 0a                	cmp    (%edx),%cl
  800a6c:	74 eb                	je     800a59 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6e:	0f b6 00             	movzbl (%eax),%eax
  800a71:	0f b6 12             	movzbl (%edx),%edx
  800a74:	29 d0                	sub    %edx,%eax
}
  800a76:	5b                   	pop    %ebx
  800a77:	5d                   	pop    %ebp
  800a78:	c3                   	ret    
		return 0;
  800a79:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7e:	eb f6                	jmp    800a76 <strncmp+0x2e>

00800a80 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a8a:	0f b6 10             	movzbl (%eax),%edx
  800a8d:	84 d2                	test   %dl,%dl
  800a8f:	74 09                	je     800a9a <strchr+0x1a>
		if (*s == c)
  800a91:	38 ca                	cmp    %cl,%dl
  800a93:	74 0a                	je     800a9f <strchr+0x1f>
	for (; *s; s++)
  800a95:	83 c0 01             	add    $0x1,%eax
  800a98:	eb f0                	jmp    800a8a <strchr+0xa>
			return (char *) s;
	return 0;
  800a9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aab:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aae:	38 ca                	cmp    %cl,%dl
  800ab0:	74 09                	je     800abb <strfind+0x1a>
  800ab2:	84 d2                	test   %dl,%dl
  800ab4:	74 05                	je     800abb <strfind+0x1a>
	for (; *s; s++)
  800ab6:	83 c0 01             	add    $0x1,%eax
  800ab9:	eb f0                	jmp    800aab <strfind+0xa>
			break;
	return (char *) s;
}
  800abb:	5d                   	pop    %ebp
  800abc:	c3                   	ret    

00800abd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	57                   	push   %edi
  800ac1:	56                   	push   %esi
  800ac2:	53                   	push   %ebx
  800ac3:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ac6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ac9:	85 c9                	test   %ecx,%ecx
  800acb:	74 31                	je     800afe <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800acd:	89 f8                	mov    %edi,%eax
  800acf:	09 c8                	or     %ecx,%eax
  800ad1:	a8 03                	test   $0x3,%al
  800ad3:	75 23                	jne    800af8 <memset+0x3b>
		c &= 0xFF;
  800ad5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ad9:	89 d3                	mov    %edx,%ebx
  800adb:	c1 e3 08             	shl    $0x8,%ebx
  800ade:	89 d0                	mov    %edx,%eax
  800ae0:	c1 e0 18             	shl    $0x18,%eax
  800ae3:	89 d6                	mov    %edx,%esi
  800ae5:	c1 e6 10             	shl    $0x10,%esi
  800ae8:	09 f0                	or     %esi,%eax
  800aea:	09 c2                	or     %eax,%edx
  800aec:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aee:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800af1:	89 d0                	mov    %edx,%eax
  800af3:	fc                   	cld    
  800af4:	f3 ab                	rep stos %eax,%es:(%edi)
  800af6:	eb 06                	jmp    800afe <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	fc                   	cld    
  800afc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800afe:	89 f8                	mov    %edi,%eax
  800b00:	5b                   	pop    %ebx
  800b01:	5e                   	pop    %esi
  800b02:	5f                   	pop    %edi
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    

00800b05 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	57                   	push   %edi
  800b09:	56                   	push   %esi
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b10:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b13:	39 c6                	cmp    %eax,%esi
  800b15:	73 32                	jae    800b49 <memmove+0x44>
  800b17:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b1a:	39 c2                	cmp    %eax,%edx
  800b1c:	76 2b                	jbe    800b49 <memmove+0x44>
		s += n;
		d += n;
  800b1e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b21:	89 fe                	mov    %edi,%esi
  800b23:	09 ce                	or     %ecx,%esi
  800b25:	09 d6                	or     %edx,%esi
  800b27:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b2d:	75 0e                	jne    800b3d <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b2f:	83 ef 04             	sub    $0x4,%edi
  800b32:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b35:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b38:	fd                   	std    
  800b39:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3b:	eb 09                	jmp    800b46 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b3d:	83 ef 01             	sub    $0x1,%edi
  800b40:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b43:	fd                   	std    
  800b44:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b46:	fc                   	cld    
  800b47:	eb 1a                	jmp    800b63 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b49:	89 c2                	mov    %eax,%edx
  800b4b:	09 ca                	or     %ecx,%edx
  800b4d:	09 f2                	or     %esi,%edx
  800b4f:	f6 c2 03             	test   $0x3,%dl
  800b52:	75 0a                	jne    800b5e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b54:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b57:	89 c7                	mov    %eax,%edi
  800b59:	fc                   	cld    
  800b5a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b5c:	eb 05                	jmp    800b63 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b5e:	89 c7                	mov    %eax,%edi
  800b60:	fc                   	cld    
  800b61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b63:	5e                   	pop    %esi
  800b64:	5f                   	pop    %edi
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b6d:	ff 75 10             	pushl  0x10(%ebp)
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	ff 75 08             	pushl  0x8(%ebp)
  800b76:	e8 8a ff ff ff       	call   800b05 <memmove>
}
  800b7b:	c9                   	leave  
  800b7c:	c3                   	ret    

00800b7d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	56                   	push   %esi
  800b81:	53                   	push   %ebx
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b88:	89 c6                	mov    %eax,%esi
  800b8a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b8d:	39 f0                	cmp    %esi,%eax
  800b8f:	74 1c                	je     800bad <memcmp+0x30>
		if (*s1 != *s2)
  800b91:	0f b6 08             	movzbl (%eax),%ecx
  800b94:	0f b6 1a             	movzbl (%edx),%ebx
  800b97:	38 d9                	cmp    %bl,%cl
  800b99:	75 08                	jne    800ba3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b9b:	83 c0 01             	add    $0x1,%eax
  800b9e:	83 c2 01             	add    $0x1,%edx
  800ba1:	eb ea                	jmp    800b8d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ba3:	0f b6 c1             	movzbl %cl,%eax
  800ba6:	0f b6 db             	movzbl %bl,%ebx
  800ba9:	29 d8                	sub    %ebx,%eax
  800bab:	eb 05                	jmp    800bb2 <memcmp+0x35>
	}

	return 0;
  800bad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb2:	5b                   	pop    %ebx
  800bb3:	5e                   	pop    %esi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bbf:	89 c2                	mov    %eax,%edx
  800bc1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bc4:	39 d0                	cmp    %edx,%eax
  800bc6:	73 09                	jae    800bd1 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc8:	38 08                	cmp    %cl,(%eax)
  800bca:	74 05                	je     800bd1 <memfind+0x1b>
	for (; s < ends; s++)
  800bcc:	83 c0 01             	add    $0x1,%eax
  800bcf:	eb f3                	jmp    800bc4 <memfind+0xe>
			break;
	return (void *) s;
}
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	57                   	push   %edi
  800bd7:	56                   	push   %esi
  800bd8:	53                   	push   %ebx
  800bd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bdc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bdf:	eb 03                	jmp    800be4 <strtol+0x11>
		s++;
  800be1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800be4:	0f b6 01             	movzbl (%ecx),%eax
  800be7:	3c 20                	cmp    $0x20,%al
  800be9:	74 f6                	je     800be1 <strtol+0xe>
  800beb:	3c 09                	cmp    $0x9,%al
  800bed:	74 f2                	je     800be1 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bef:	3c 2b                	cmp    $0x2b,%al
  800bf1:	74 2a                	je     800c1d <strtol+0x4a>
	int neg = 0;
  800bf3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bf8:	3c 2d                	cmp    $0x2d,%al
  800bfa:	74 2b                	je     800c27 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bfc:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c02:	75 0f                	jne    800c13 <strtol+0x40>
  800c04:	80 39 30             	cmpb   $0x30,(%ecx)
  800c07:	74 28                	je     800c31 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c09:	85 db                	test   %ebx,%ebx
  800c0b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c10:	0f 44 d8             	cmove  %eax,%ebx
  800c13:	b8 00 00 00 00       	mov    $0x0,%eax
  800c18:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c1b:	eb 50                	jmp    800c6d <strtol+0x9a>
		s++;
  800c1d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c20:	bf 00 00 00 00       	mov    $0x0,%edi
  800c25:	eb d5                	jmp    800bfc <strtol+0x29>
		s++, neg = 1;
  800c27:	83 c1 01             	add    $0x1,%ecx
  800c2a:	bf 01 00 00 00       	mov    $0x1,%edi
  800c2f:	eb cb                	jmp    800bfc <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c31:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c35:	74 0e                	je     800c45 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c37:	85 db                	test   %ebx,%ebx
  800c39:	75 d8                	jne    800c13 <strtol+0x40>
		s++, base = 8;
  800c3b:	83 c1 01             	add    $0x1,%ecx
  800c3e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c43:	eb ce                	jmp    800c13 <strtol+0x40>
		s += 2, base = 16;
  800c45:	83 c1 02             	add    $0x2,%ecx
  800c48:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c4d:	eb c4                	jmp    800c13 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c4f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c52:	89 f3                	mov    %esi,%ebx
  800c54:	80 fb 19             	cmp    $0x19,%bl
  800c57:	77 29                	ja     800c82 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c59:	0f be d2             	movsbl %dl,%edx
  800c5c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c5f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c62:	7d 30                	jge    800c94 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c64:	83 c1 01             	add    $0x1,%ecx
  800c67:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c6b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c6d:	0f b6 11             	movzbl (%ecx),%edx
  800c70:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c73:	89 f3                	mov    %esi,%ebx
  800c75:	80 fb 09             	cmp    $0x9,%bl
  800c78:	77 d5                	ja     800c4f <strtol+0x7c>
			dig = *s - '0';
  800c7a:	0f be d2             	movsbl %dl,%edx
  800c7d:	83 ea 30             	sub    $0x30,%edx
  800c80:	eb dd                	jmp    800c5f <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c82:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c85:	89 f3                	mov    %esi,%ebx
  800c87:	80 fb 19             	cmp    $0x19,%bl
  800c8a:	77 08                	ja     800c94 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c8c:	0f be d2             	movsbl %dl,%edx
  800c8f:	83 ea 37             	sub    $0x37,%edx
  800c92:	eb cb                	jmp    800c5f <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c98:	74 05                	je     800c9f <strtol+0xcc>
		*endptr = (char *) s;
  800c9a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c9d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c9f:	89 c2                	mov    %eax,%edx
  800ca1:	f7 da                	neg    %edx
  800ca3:	85 ff                	test   %edi,%edi
  800ca5:	0f 45 c2             	cmovne %edx,%eax
}
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    

00800cad <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	57                   	push   %edi
  800cb1:	56                   	push   %esi
  800cb2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb3:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbe:	89 c3                	mov    %eax,%ebx
  800cc0:	89 c7                	mov    %eax,%edi
  800cc2:	89 c6                	mov    %eax,%esi
  800cc4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cc6:	5b                   	pop    %ebx
  800cc7:	5e                   	pop    %esi
  800cc8:	5f                   	pop    %edi
  800cc9:	5d                   	pop    %ebp
  800cca:	c3                   	ret    

00800ccb <sys_cgetc>:

int
sys_cgetc(void)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	57                   	push   %edi
  800ccf:	56                   	push   %esi
  800cd0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd6:	b8 01 00 00 00       	mov    $0x1,%eax
  800cdb:	89 d1                	mov    %edx,%ecx
  800cdd:	89 d3                	mov    %edx,%ebx
  800cdf:	89 d7                	mov    %edx,%edi
  800ce1:	89 d6                	mov    %edx,%esi
  800ce3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5f                   	pop    %edi
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	57                   	push   %edi
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
  800cf0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfb:	b8 03 00 00 00       	mov    $0x3,%eax
  800d00:	89 cb                	mov    %ecx,%ebx
  800d02:	89 cf                	mov    %ecx,%edi
  800d04:	89 ce                	mov    %ecx,%esi
  800d06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d08:	85 c0                	test   %eax,%eax
  800d0a:	7f 08                	jg     800d14 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d14:	83 ec 0c             	sub    $0xc,%esp
  800d17:	50                   	push   %eax
  800d18:	6a 03                	push   $0x3
  800d1a:	68 20 29 80 00       	push   $0x802920
  800d1f:	6a 43                	push   $0x43
  800d21:	68 3d 29 80 00       	push   $0x80293d
  800d26:	e8 f7 f3 ff ff       	call   800122 <_panic>

00800d2b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	57                   	push   %edi
  800d2f:	56                   	push   %esi
  800d30:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d31:	ba 00 00 00 00       	mov    $0x0,%edx
  800d36:	b8 02 00 00 00       	mov    $0x2,%eax
  800d3b:	89 d1                	mov    %edx,%ecx
  800d3d:	89 d3                	mov    %edx,%ebx
  800d3f:	89 d7                	mov    %edx,%edi
  800d41:	89 d6                	mov    %edx,%esi
  800d43:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5f                   	pop    %edi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <sys_yield>:

void
sys_yield(void)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d50:	ba 00 00 00 00       	mov    $0x0,%edx
  800d55:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d5a:	89 d1                	mov    %edx,%ecx
  800d5c:	89 d3                	mov    %edx,%ebx
  800d5e:	89 d7                	mov    %edx,%edi
  800d60:	89 d6                	mov    %edx,%esi
  800d62:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	57                   	push   %edi
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
  800d6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d72:	be 00 00 00 00       	mov    $0x0,%esi
  800d77:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7d:	b8 04 00 00 00       	mov    $0x4,%eax
  800d82:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d85:	89 f7                	mov    %esi,%edi
  800d87:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d89:	85 c0                	test   %eax,%eax
  800d8b:	7f 08                	jg     800d95 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d90:	5b                   	pop    %ebx
  800d91:	5e                   	pop    %esi
  800d92:	5f                   	pop    %edi
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d95:	83 ec 0c             	sub    $0xc,%esp
  800d98:	50                   	push   %eax
  800d99:	6a 04                	push   $0x4
  800d9b:	68 20 29 80 00       	push   $0x802920
  800da0:	6a 43                	push   $0x43
  800da2:	68 3d 29 80 00       	push   $0x80293d
  800da7:	e8 76 f3 ff ff       	call   800122 <_panic>

00800dac <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	57                   	push   %edi
  800db0:	56                   	push   %esi
  800db1:	53                   	push   %ebx
  800db2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db5:	8b 55 08             	mov    0x8(%ebp),%edx
  800db8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbb:	b8 05 00 00 00       	mov    $0x5,%eax
  800dc0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc6:	8b 75 18             	mov    0x18(%ebp),%esi
  800dc9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcb:	85 c0                	test   %eax,%eax
  800dcd:	7f 08                	jg     800dd7 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd2:	5b                   	pop    %ebx
  800dd3:	5e                   	pop    %esi
  800dd4:	5f                   	pop    %edi
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd7:	83 ec 0c             	sub    $0xc,%esp
  800dda:	50                   	push   %eax
  800ddb:	6a 05                	push   $0x5
  800ddd:	68 20 29 80 00       	push   $0x802920
  800de2:	6a 43                	push   $0x43
  800de4:	68 3d 29 80 00       	push   $0x80293d
  800de9:	e8 34 f3 ff ff       	call   800122 <_panic>

00800dee <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	57                   	push   %edi
  800df2:	56                   	push   %esi
  800df3:	53                   	push   %ebx
  800df4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e02:	b8 06 00 00 00       	mov    $0x6,%eax
  800e07:	89 df                	mov    %ebx,%edi
  800e09:	89 de                	mov    %ebx,%esi
  800e0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0d:	85 c0                	test   %eax,%eax
  800e0f:	7f 08                	jg     800e19 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e14:	5b                   	pop    %ebx
  800e15:	5e                   	pop    %esi
  800e16:	5f                   	pop    %edi
  800e17:	5d                   	pop    %ebp
  800e18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e19:	83 ec 0c             	sub    $0xc,%esp
  800e1c:	50                   	push   %eax
  800e1d:	6a 06                	push   $0x6
  800e1f:	68 20 29 80 00       	push   $0x802920
  800e24:	6a 43                	push   $0x43
  800e26:	68 3d 29 80 00       	push   $0x80293d
  800e2b:	e8 f2 f2 ff ff       	call   800122 <_panic>

00800e30 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	57                   	push   %edi
  800e34:	56                   	push   %esi
  800e35:	53                   	push   %ebx
  800e36:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e44:	b8 08 00 00 00       	mov    $0x8,%eax
  800e49:	89 df                	mov    %ebx,%edi
  800e4b:	89 de                	mov    %ebx,%esi
  800e4d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	7f 08                	jg     800e5b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e56:	5b                   	pop    %ebx
  800e57:	5e                   	pop    %esi
  800e58:	5f                   	pop    %edi
  800e59:	5d                   	pop    %ebp
  800e5a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5b:	83 ec 0c             	sub    $0xc,%esp
  800e5e:	50                   	push   %eax
  800e5f:	6a 08                	push   $0x8
  800e61:	68 20 29 80 00       	push   $0x802920
  800e66:	6a 43                	push   $0x43
  800e68:	68 3d 29 80 00       	push   $0x80293d
  800e6d:	e8 b0 f2 ff ff       	call   800122 <_panic>

00800e72 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	57                   	push   %edi
  800e76:	56                   	push   %esi
  800e77:	53                   	push   %ebx
  800e78:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e80:	8b 55 08             	mov    0x8(%ebp),%edx
  800e83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e86:	b8 09 00 00 00       	mov    $0x9,%eax
  800e8b:	89 df                	mov    %ebx,%edi
  800e8d:	89 de                	mov    %ebx,%esi
  800e8f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e91:	85 c0                	test   %eax,%eax
  800e93:	7f 08                	jg     800e9d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e98:	5b                   	pop    %ebx
  800e99:	5e                   	pop    %esi
  800e9a:	5f                   	pop    %edi
  800e9b:	5d                   	pop    %ebp
  800e9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9d:	83 ec 0c             	sub    $0xc,%esp
  800ea0:	50                   	push   %eax
  800ea1:	6a 09                	push   $0x9
  800ea3:	68 20 29 80 00       	push   $0x802920
  800ea8:	6a 43                	push   $0x43
  800eaa:	68 3d 29 80 00       	push   $0x80293d
  800eaf:	e8 6e f2 ff ff       	call   800122 <_panic>

00800eb4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	57                   	push   %edi
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
  800eba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ebd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ecd:	89 df                	mov    %ebx,%edi
  800ecf:	89 de                	mov    %ebx,%esi
  800ed1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed3:	85 c0                	test   %eax,%eax
  800ed5:	7f 08                	jg     800edf <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ed7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eda:	5b                   	pop    %ebx
  800edb:	5e                   	pop    %esi
  800edc:	5f                   	pop    %edi
  800edd:	5d                   	pop    %ebp
  800ede:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800edf:	83 ec 0c             	sub    $0xc,%esp
  800ee2:	50                   	push   %eax
  800ee3:	6a 0a                	push   $0xa
  800ee5:	68 20 29 80 00       	push   $0x802920
  800eea:	6a 43                	push   $0x43
  800eec:	68 3d 29 80 00       	push   $0x80293d
  800ef1:	e8 2c f2 ff ff       	call   800122 <_panic>

00800ef6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	57                   	push   %edi
  800efa:	56                   	push   %esi
  800efb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800efc:	8b 55 08             	mov    0x8(%ebp),%edx
  800eff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f02:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f07:	be 00 00 00 00       	mov    $0x0,%esi
  800f0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f12:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f14:	5b                   	pop    %ebx
  800f15:	5e                   	pop    %esi
  800f16:	5f                   	pop    %edi
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    

00800f19 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
  800f1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f22:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f27:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f2f:	89 cb                	mov    %ecx,%ebx
  800f31:	89 cf                	mov    %ecx,%edi
  800f33:	89 ce                	mov    %ecx,%esi
  800f35:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	7f 08                	jg     800f43 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3e:	5b                   	pop    %ebx
  800f3f:	5e                   	pop    %esi
  800f40:	5f                   	pop    %edi
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f43:	83 ec 0c             	sub    $0xc,%esp
  800f46:	50                   	push   %eax
  800f47:	6a 0d                	push   $0xd
  800f49:	68 20 29 80 00       	push   $0x802920
  800f4e:	6a 43                	push   $0x43
  800f50:	68 3d 29 80 00       	push   $0x80293d
  800f55:	e8 c8 f1 ff ff       	call   800122 <_panic>

00800f5a <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	57                   	push   %edi
  800f5e:	56                   	push   %esi
  800f5f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f60:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f65:	8b 55 08             	mov    0x8(%ebp),%edx
  800f68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6b:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f70:	89 df                	mov    %ebx,%edi
  800f72:	89 de                	mov    %ebx,%esi
  800f74:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f76:	5b                   	pop    %ebx
  800f77:	5e                   	pop    %esi
  800f78:	5f                   	pop    %edi
  800f79:	5d                   	pop    %ebp
  800f7a:	c3                   	ret    

00800f7b <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	57                   	push   %edi
  800f7f:	56                   	push   %esi
  800f80:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f81:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f86:	8b 55 08             	mov    0x8(%ebp),%edx
  800f89:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f8e:	89 cb                	mov    %ecx,%ebx
  800f90:	89 cf                	mov    %ecx,%edi
  800f92:	89 ce                	mov    %ecx,%esi
  800f94:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f96:	5b                   	pop    %ebx
  800f97:	5e                   	pop    %esi
  800f98:	5f                   	pop    %edi
  800f99:	5d                   	pop    %ebp
  800f9a:	c3                   	ret    

00800f9b <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	57                   	push   %edi
  800f9f:	56                   	push   %esi
  800fa0:	53                   	push   %ebx
  800fa1:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  800fa7:	6a 00                	push   $0x0
  800fa9:	ff 75 08             	pushl  0x8(%ebp)
  800fac:	e8 64 0c 00 00       	call   801c15 <open>
  800fb1:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  800fb7:	83 c4 10             	add    $0x10,%esp
  800fba:	85 c0                	test   %eax,%eax
  800fbc:	0f 88 71 04 00 00    	js     801433 <spawn+0x498>
  800fc2:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  800fc4:	83 ec 04             	sub    $0x4,%esp
  800fc7:	68 00 02 00 00       	push   $0x200
  800fcc:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  800fd2:	50                   	push   %eax
  800fd3:	52                   	push   %edx
  800fd4:	e8 8c 08 00 00       	call   801865 <readn>
  800fd9:	83 c4 10             	add    $0x10,%esp
  800fdc:	3d 00 02 00 00       	cmp    $0x200,%eax
  800fe1:	75 5f                	jne    801042 <spawn+0xa7>
	    || elf->e_magic != ELF_MAGIC) {
  800fe3:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  800fea:	45 4c 46 
  800fed:	75 53                	jne    801042 <spawn+0xa7>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fef:	b8 07 00 00 00       	mov    $0x7,%eax
  800ff4:	cd 30                	int    $0x30
  800ff6:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  800ffc:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801002:	85 c0                	test   %eax,%eax
  801004:	0f 88 1d 04 00 00    	js     801427 <spawn+0x48c>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80100a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80100f:	89 c6                	mov    %eax,%esi
  801011:	c1 e6 07             	shl    $0x7,%esi
  801014:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80101a:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801020:	b9 11 00 00 00       	mov    $0x11,%ecx
  801025:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801027:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  80102d:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801033:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801038:	be 00 00 00 00       	mov    $0x0,%esi
  80103d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801040:	eb 4b                	jmp    80108d <spawn+0xf2>
		close(fd);
  801042:	83 ec 0c             	sub    $0xc,%esp
  801045:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80104b:	e8 50 06 00 00       	call   8016a0 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801050:	83 c4 0c             	add    $0xc,%esp
  801053:	68 7f 45 4c 46       	push   $0x464c457f
  801058:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80105e:	68 4b 29 80 00       	push   $0x80294b
  801063:	e8 b0 f1 ff ff       	call   800218 <cprintf>
		return -E_NOT_EXEC;
  801068:	83 c4 10             	add    $0x10,%esp
  80106b:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801072:	ff ff ff 
  801075:	e9 b9 03 00 00       	jmp    801433 <spawn+0x498>
		string_size += strlen(argv[argc]) + 1;
  80107a:	83 ec 0c             	sub    $0xc,%esp
  80107d:	50                   	push   %eax
  80107e:	e8 bb f8 ff ff       	call   80093e <strlen>
  801083:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801087:	83 c3 01             	add    $0x1,%ebx
  80108a:	83 c4 10             	add    $0x10,%esp
  80108d:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801094:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801097:	85 c0                	test   %eax,%eax
  801099:	75 df                	jne    80107a <spawn+0xdf>
  80109b:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8010a1:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8010a7:	bf 00 10 40 00       	mov    $0x401000,%edi
  8010ac:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8010ae:	89 fa                	mov    %edi,%edx
  8010b0:	83 e2 fc             	and    $0xfffffffc,%edx
  8010b3:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8010ba:	29 c2                	sub    %eax,%edx
  8010bc:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8010c2:	8d 42 f8             	lea    -0x8(%edx),%eax
  8010c5:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8010ca:	0f 86 86 03 00 00    	jbe    801456 <spawn+0x4bb>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8010d0:	83 ec 04             	sub    $0x4,%esp
  8010d3:	6a 07                	push   $0x7
  8010d5:	68 00 00 40 00       	push   $0x400000
  8010da:	6a 00                	push   $0x0
  8010dc:	e8 88 fc ff ff       	call   800d69 <sys_page_alloc>
  8010e1:	83 c4 10             	add    $0x10,%esp
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	0f 88 6f 03 00 00    	js     80145b <spawn+0x4c0>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8010ec:	be 00 00 00 00       	mov    $0x0,%esi
  8010f1:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8010f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8010fa:	eb 30                	jmp    80112c <spawn+0x191>
		argv_store[i] = UTEMP2USTACK(string_store);
  8010fc:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801102:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801108:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801111:	57                   	push   %edi
  801112:	e8 60 f8 ff ff       	call   800977 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801117:	83 c4 04             	add    $0x4,%esp
  80111a:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80111d:	e8 1c f8 ff ff       	call   80093e <strlen>
  801122:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801126:	83 c6 01             	add    $0x1,%esi
  801129:	83 c4 10             	add    $0x10,%esp
  80112c:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801132:	7f c8                	jg     8010fc <spawn+0x161>
	}
	argv_store[argc] = 0;
  801134:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80113a:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801140:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801147:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80114d:	0f 85 86 00 00 00    	jne    8011d9 <spawn+0x23e>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801153:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801159:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  80115f:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801162:	89 c8                	mov    %ecx,%eax
  801164:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  80116a:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80116d:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801172:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801178:	83 ec 0c             	sub    $0xc,%esp
  80117b:	6a 07                	push   $0x7
  80117d:	68 00 d0 bf ee       	push   $0xeebfd000
  801182:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801188:	68 00 00 40 00       	push   $0x400000
  80118d:	6a 00                	push   $0x0
  80118f:	e8 18 fc ff ff       	call   800dac <sys_page_map>
  801194:	89 c3                	mov    %eax,%ebx
  801196:	83 c4 20             	add    $0x20,%esp
  801199:	85 c0                	test   %eax,%eax
  80119b:	0f 88 c2 02 00 00    	js     801463 <spawn+0x4c8>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8011a1:	83 ec 08             	sub    $0x8,%esp
  8011a4:	68 00 00 40 00       	push   $0x400000
  8011a9:	6a 00                	push   $0x0
  8011ab:	e8 3e fc ff ff       	call   800dee <sys_page_unmap>
  8011b0:	89 c3                	mov    %eax,%ebx
  8011b2:	83 c4 10             	add    $0x10,%esp
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	0f 88 a6 02 00 00    	js     801463 <spawn+0x4c8>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8011bd:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8011c3:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8011ca:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8011d1:	00 00 00 
  8011d4:	e9 4f 01 00 00       	jmp    801328 <spawn+0x38d>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8011d9:	68 d4 29 80 00       	push   $0x8029d4
  8011de:	68 65 29 80 00       	push   $0x802965
  8011e3:	68 f2 00 00 00       	push   $0xf2
  8011e8:	68 7a 29 80 00       	push   $0x80297a
  8011ed:	e8 30 ef ff ff       	call   800122 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8011f2:	83 ec 04             	sub    $0x4,%esp
  8011f5:	6a 07                	push   $0x7
  8011f7:	68 00 00 40 00       	push   $0x400000
  8011fc:	6a 00                	push   $0x0
  8011fe:	e8 66 fb ff ff       	call   800d69 <sys_page_alloc>
  801203:	83 c4 10             	add    $0x10,%esp
  801206:	85 c0                	test   %eax,%eax
  801208:	0f 88 33 02 00 00    	js     801441 <spawn+0x4a6>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80120e:	83 ec 08             	sub    $0x8,%esp
  801211:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801217:	01 f0                	add    %esi,%eax
  801219:	50                   	push   %eax
  80121a:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801220:	e8 07 07 00 00       	call   80192c <seek>
  801225:	83 c4 10             	add    $0x10,%esp
  801228:	85 c0                	test   %eax,%eax
  80122a:	0f 88 18 02 00 00    	js     801448 <spawn+0x4ad>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801230:	83 ec 04             	sub    $0x4,%esp
  801233:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801239:	29 f0                	sub    %esi,%eax
  80123b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801240:	ba 00 10 00 00       	mov    $0x1000,%edx
  801245:	0f 47 c2             	cmova  %edx,%eax
  801248:	50                   	push   %eax
  801249:	68 00 00 40 00       	push   $0x400000
  80124e:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801254:	e8 0c 06 00 00       	call   801865 <readn>
  801259:	83 c4 10             	add    $0x10,%esp
  80125c:	85 c0                	test   %eax,%eax
  80125e:	0f 88 eb 01 00 00    	js     80144f <spawn+0x4b4>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801264:	83 ec 0c             	sub    $0xc,%esp
  801267:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80126d:	53                   	push   %ebx
  80126e:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801274:	68 00 00 40 00       	push   $0x400000
  801279:	6a 00                	push   $0x0
  80127b:	e8 2c fb ff ff       	call   800dac <sys_page_map>
  801280:	83 c4 20             	add    $0x20,%esp
  801283:	85 c0                	test   %eax,%eax
  801285:	78 7c                	js     801303 <spawn+0x368>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	68 00 00 40 00       	push   $0x400000
  80128f:	6a 00                	push   $0x0
  801291:	e8 58 fb ff ff       	call   800dee <sys_page_unmap>
  801296:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801299:	81 c7 00 10 00 00    	add    $0x1000,%edi
  80129f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012a5:	89 fe                	mov    %edi,%esi
  8012a7:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  8012ad:	76 69                	jbe    801318 <spawn+0x37d>
		if (i >= filesz) {
  8012af:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  8012b5:	0f 87 37 ff ff ff    	ja     8011f2 <spawn+0x257>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8012bb:	83 ec 04             	sub    $0x4,%esp
  8012be:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8012c4:	53                   	push   %ebx
  8012c5:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8012cb:	e8 99 fa ff ff       	call   800d69 <sys_page_alloc>
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	79 c2                	jns    801299 <spawn+0x2fe>
  8012d7:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8012d9:	83 ec 0c             	sub    $0xc,%esp
  8012dc:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8012e2:	e8 03 fa ff ff       	call   800cea <sys_env_destroy>
	close(fd);
  8012e7:	83 c4 04             	add    $0x4,%esp
  8012ea:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8012f0:	e8 ab 03 00 00       	call   8016a0 <close>
	return r;
  8012f5:	83 c4 10             	add    $0x10,%esp
  8012f8:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  8012fe:	e9 30 01 00 00       	jmp    801433 <spawn+0x498>
				panic("spawn: sys_page_map data: %e", r);
  801303:	50                   	push   %eax
  801304:	68 86 29 80 00       	push   $0x802986
  801309:	68 25 01 00 00       	push   $0x125
  80130e:	68 7a 29 80 00       	push   $0x80297a
  801313:	e8 0a ee ff ff       	call   800122 <_panic>
  801318:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80131e:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801325:	83 c6 20             	add    $0x20,%esi
  801328:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80132f:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801335:	7e 6d                	jle    8013a4 <spawn+0x409>
		if (ph->p_type != ELF_PROG_LOAD)
  801337:	83 3e 01             	cmpl   $0x1,(%esi)
  80133a:	75 e2                	jne    80131e <spawn+0x383>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80133c:	8b 46 18             	mov    0x18(%esi),%eax
  80133f:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801342:	83 f8 01             	cmp    $0x1,%eax
  801345:	19 c0                	sbb    %eax,%eax
  801347:	83 e0 fe             	and    $0xfffffffe,%eax
  80134a:	83 c0 07             	add    $0x7,%eax
  80134d:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801353:	8b 4e 04             	mov    0x4(%esi),%ecx
  801356:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  80135c:	8b 56 10             	mov    0x10(%esi),%edx
  80135f:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801365:	8b 7e 14             	mov    0x14(%esi),%edi
  801368:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  80136e:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801371:	89 d8                	mov    %ebx,%eax
  801373:	25 ff 0f 00 00       	and    $0xfff,%eax
  801378:	74 1a                	je     801394 <spawn+0x3f9>
		va -= i;
  80137a:	29 c3                	sub    %eax,%ebx
		memsz += i;
  80137c:	01 c7                	add    %eax,%edi
  80137e:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801384:	01 c2                	add    %eax,%edx
  801386:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  80138c:	29 c1                	sub    %eax,%ecx
  80138e:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801394:	bf 00 00 00 00       	mov    $0x0,%edi
  801399:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  80139f:	e9 01 ff ff ff       	jmp    8012a5 <spawn+0x30a>
	close(fd);
  8013a4:	83 ec 0c             	sub    $0xc,%esp
  8013a7:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8013ad:	e8 ee 02 00 00       	call   8016a0 <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  8013b2:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  8013b9:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8013bc:	83 c4 08             	add    $0x8,%esp
  8013bf:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8013c5:	50                   	push   %eax
  8013c6:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8013cc:	e8 a1 fa ff ff       	call   800e72 <sys_env_set_trapframe>
  8013d1:	83 c4 10             	add    $0x10,%esp
  8013d4:	85 c0                	test   %eax,%eax
  8013d6:	78 25                	js     8013fd <spawn+0x462>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8013d8:	83 ec 08             	sub    $0x8,%esp
  8013db:	6a 02                	push   $0x2
  8013dd:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8013e3:	e8 48 fa ff ff       	call   800e30 <sys_env_set_status>
  8013e8:	83 c4 10             	add    $0x10,%esp
  8013eb:	85 c0                	test   %eax,%eax
  8013ed:	78 23                	js     801412 <spawn+0x477>
	return child;
  8013ef:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8013f5:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8013fb:	eb 36                	jmp    801433 <spawn+0x498>
		panic("sys_env_set_trapframe: %e", r);
  8013fd:	50                   	push   %eax
  8013fe:	68 a3 29 80 00       	push   $0x8029a3
  801403:	68 86 00 00 00       	push   $0x86
  801408:	68 7a 29 80 00       	push   $0x80297a
  80140d:	e8 10 ed ff ff       	call   800122 <_panic>
		panic("sys_env_set_status: %e", r);
  801412:	50                   	push   %eax
  801413:	68 bd 29 80 00       	push   $0x8029bd
  801418:	68 89 00 00 00       	push   $0x89
  80141d:	68 7a 29 80 00       	push   $0x80297a
  801422:	e8 fb ec ff ff       	call   800122 <_panic>
		return r;
  801427:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80142d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801433:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801439:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80143c:	5b                   	pop    %ebx
  80143d:	5e                   	pop    %esi
  80143e:	5f                   	pop    %edi
  80143f:	5d                   	pop    %ebp
  801440:	c3                   	ret    
  801441:	89 c7                	mov    %eax,%edi
  801443:	e9 91 fe ff ff       	jmp    8012d9 <spawn+0x33e>
  801448:	89 c7                	mov    %eax,%edi
  80144a:	e9 8a fe ff ff       	jmp    8012d9 <spawn+0x33e>
  80144f:	89 c7                	mov    %eax,%edi
  801451:	e9 83 fe ff ff       	jmp    8012d9 <spawn+0x33e>
		return -E_NO_MEM;
  801456:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80145b:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801461:	eb d0                	jmp    801433 <spawn+0x498>
	sys_page_unmap(0, UTEMP);
  801463:	83 ec 08             	sub    $0x8,%esp
  801466:	68 00 00 40 00       	push   $0x400000
  80146b:	6a 00                	push   $0x0
  80146d:	e8 7c f9 ff ff       	call   800dee <sys_page_unmap>
  801472:	83 c4 10             	add    $0x10,%esp
  801475:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  80147b:	eb b6                	jmp    801433 <spawn+0x498>

0080147d <spawnl>:
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	57                   	push   %edi
  801481:	56                   	push   %esi
  801482:	53                   	push   %ebx
  801483:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801486:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801489:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  80148e:	8d 4a 04             	lea    0x4(%edx),%ecx
  801491:	83 3a 00             	cmpl   $0x0,(%edx)
  801494:	74 07                	je     80149d <spawnl+0x20>
		argc++;
  801496:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801499:	89 ca                	mov    %ecx,%edx
  80149b:	eb f1                	jmp    80148e <spawnl+0x11>
	const char *argv[argc+2];
  80149d:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  8014a4:	83 e2 f0             	and    $0xfffffff0,%edx
  8014a7:	29 d4                	sub    %edx,%esp
  8014a9:	8d 54 24 03          	lea    0x3(%esp),%edx
  8014ad:	c1 ea 02             	shr    $0x2,%edx
  8014b0:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  8014b7:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8014b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014bc:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8014c3:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8014ca:	00 
	va_start(vl, arg0);
  8014cb:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8014ce:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8014d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d5:	eb 0b                	jmp    8014e2 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  8014d7:	83 c0 01             	add    $0x1,%eax
  8014da:	8b 39                	mov    (%ecx),%edi
  8014dc:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8014df:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8014e2:	39 d0                	cmp    %edx,%eax
  8014e4:	75 f1                	jne    8014d7 <spawnl+0x5a>
	return spawn(prog, argv);
  8014e6:	83 ec 08             	sub    $0x8,%esp
  8014e9:	56                   	push   %esi
  8014ea:	ff 75 08             	pushl  0x8(%ebp)
  8014ed:	e8 a9 fa ff ff       	call   800f9b <spawn>
}
  8014f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014f5:	5b                   	pop    %ebx
  8014f6:	5e                   	pop    %esi
  8014f7:	5f                   	pop    %edi
  8014f8:	5d                   	pop    %ebp
  8014f9:	c3                   	ret    

008014fa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	05 00 00 00 30       	add    $0x30000000,%eax
  801505:	c1 e8 0c             	shr    $0xc,%eax
}
  801508:	5d                   	pop    %ebp
  801509:	c3                   	ret    

0080150a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801515:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80151a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80151f:	5d                   	pop    %ebp
  801520:	c3                   	ret    

00801521 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801529:	89 c2                	mov    %eax,%edx
  80152b:	c1 ea 16             	shr    $0x16,%edx
  80152e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801535:	f6 c2 01             	test   $0x1,%dl
  801538:	74 2d                	je     801567 <fd_alloc+0x46>
  80153a:	89 c2                	mov    %eax,%edx
  80153c:	c1 ea 0c             	shr    $0xc,%edx
  80153f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801546:	f6 c2 01             	test   $0x1,%dl
  801549:	74 1c                	je     801567 <fd_alloc+0x46>
  80154b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801550:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801555:	75 d2                	jne    801529 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
  80155a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801560:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801565:	eb 0a                	jmp    801571 <fd_alloc+0x50>
			*fd_store = fd;
  801567:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80156a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801571:	5d                   	pop    %ebp
  801572:	c3                   	ret    

00801573 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801579:	83 f8 1f             	cmp    $0x1f,%eax
  80157c:	77 30                	ja     8015ae <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80157e:	c1 e0 0c             	shl    $0xc,%eax
  801581:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801586:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80158c:	f6 c2 01             	test   $0x1,%dl
  80158f:	74 24                	je     8015b5 <fd_lookup+0x42>
  801591:	89 c2                	mov    %eax,%edx
  801593:	c1 ea 0c             	shr    $0xc,%edx
  801596:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80159d:	f6 c2 01             	test   $0x1,%dl
  8015a0:	74 1a                	je     8015bc <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a5:	89 02                	mov    %eax,(%edx)
	return 0;
  8015a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ac:	5d                   	pop    %ebp
  8015ad:	c3                   	ret    
		return -E_INVAL;
  8015ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b3:	eb f7                	jmp    8015ac <fd_lookup+0x39>
		return -E_INVAL;
  8015b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ba:	eb f0                	jmp    8015ac <fd_lookup+0x39>
  8015bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015c1:	eb e9                	jmp    8015ac <fd_lookup+0x39>

008015c3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	83 ec 08             	sub    $0x8,%esp
  8015c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015cc:	ba 7c 2a 80 00       	mov    $0x802a7c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8015d1:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8015d6:	39 08                	cmp    %ecx,(%eax)
  8015d8:	74 33                	je     80160d <dev_lookup+0x4a>
  8015da:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8015dd:	8b 02                	mov    (%edx),%eax
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	75 f3                	jne    8015d6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015e3:	a1 04 40 80 00       	mov    0x804004,%eax
  8015e8:	8b 40 48             	mov    0x48(%eax),%eax
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	51                   	push   %ecx
  8015ef:	50                   	push   %eax
  8015f0:	68 fc 29 80 00       	push   $0x8029fc
  8015f5:	e8 1e ec ff ff       	call   800218 <cprintf>
	*dev = 0;
  8015fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    
			*dev = devtab[i];
  80160d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801610:	89 01                	mov    %eax,(%ecx)
			return 0;
  801612:	b8 00 00 00 00       	mov    $0x0,%eax
  801617:	eb f2                	jmp    80160b <dev_lookup+0x48>

00801619 <fd_close>:
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	57                   	push   %edi
  80161d:	56                   	push   %esi
  80161e:	53                   	push   %ebx
  80161f:	83 ec 24             	sub    $0x24,%esp
  801622:	8b 75 08             	mov    0x8(%ebp),%esi
  801625:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801628:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80162b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80162c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801632:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801635:	50                   	push   %eax
  801636:	e8 38 ff ff ff       	call   801573 <fd_lookup>
  80163b:	89 c3                	mov    %eax,%ebx
  80163d:	83 c4 10             	add    $0x10,%esp
  801640:	85 c0                	test   %eax,%eax
  801642:	78 05                	js     801649 <fd_close+0x30>
	    || fd != fd2)
  801644:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801647:	74 16                	je     80165f <fd_close+0x46>
		return (must_exist ? r : 0);
  801649:	89 f8                	mov    %edi,%eax
  80164b:	84 c0                	test   %al,%al
  80164d:	b8 00 00 00 00       	mov    $0x0,%eax
  801652:	0f 44 d8             	cmove  %eax,%ebx
}
  801655:	89 d8                	mov    %ebx,%eax
  801657:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80165a:	5b                   	pop    %ebx
  80165b:	5e                   	pop    %esi
  80165c:	5f                   	pop    %edi
  80165d:	5d                   	pop    %ebp
  80165e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80165f:	83 ec 08             	sub    $0x8,%esp
  801662:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801665:	50                   	push   %eax
  801666:	ff 36                	pushl  (%esi)
  801668:	e8 56 ff ff ff       	call   8015c3 <dev_lookup>
  80166d:	89 c3                	mov    %eax,%ebx
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	85 c0                	test   %eax,%eax
  801674:	78 1a                	js     801690 <fd_close+0x77>
		if (dev->dev_close)
  801676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801679:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80167c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801681:	85 c0                	test   %eax,%eax
  801683:	74 0b                	je     801690 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801685:	83 ec 0c             	sub    $0xc,%esp
  801688:	56                   	push   %esi
  801689:	ff d0                	call   *%eax
  80168b:	89 c3                	mov    %eax,%ebx
  80168d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801690:	83 ec 08             	sub    $0x8,%esp
  801693:	56                   	push   %esi
  801694:	6a 00                	push   $0x0
  801696:	e8 53 f7 ff ff       	call   800dee <sys_page_unmap>
	return r;
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	eb b5                	jmp    801655 <fd_close+0x3c>

008016a0 <close>:

int
close(int fdnum)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a9:	50                   	push   %eax
  8016aa:	ff 75 08             	pushl  0x8(%ebp)
  8016ad:	e8 c1 fe ff ff       	call   801573 <fd_lookup>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	79 02                	jns    8016bb <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    
		return fd_close(fd, 1);
  8016bb:	83 ec 08             	sub    $0x8,%esp
  8016be:	6a 01                	push   $0x1
  8016c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c3:	e8 51 ff ff ff       	call   801619 <fd_close>
  8016c8:	83 c4 10             	add    $0x10,%esp
  8016cb:	eb ec                	jmp    8016b9 <close+0x19>

008016cd <close_all>:

void
close_all(void)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	53                   	push   %ebx
  8016d1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016d4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016d9:	83 ec 0c             	sub    $0xc,%esp
  8016dc:	53                   	push   %ebx
  8016dd:	e8 be ff ff ff       	call   8016a0 <close>
	for (i = 0; i < MAXFD; i++)
  8016e2:	83 c3 01             	add    $0x1,%ebx
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	83 fb 20             	cmp    $0x20,%ebx
  8016eb:	75 ec                	jne    8016d9 <close_all+0xc>
}
  8016ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	57                   	push   %edi
  8016f6:	56                   	push   %esi
  8016f7:	53                   	push   %ebx
  8016f8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016fe:	50                   	push   %eax
  8016ff:	ff 75 08             	pushl  0x8(%ebp)
  801702:	e8 6c fe ff ff       	call   801573 <fd_lookup>
  801707:	89 c3                	mov    %eax,%ebx
  801709:	83 c4 10             	add    $0x10,%esp
  80170c:	85 c0                	test   %eax,%eax
  80170e:	0f 88 81 00 00 00    	js     801795 <dup+0xa3>
		return r;
	close(newfdnum);
  801714:	83 ec 0c             	sub    $0xc,%esp
  801717:	ff 75 0c             	pushl  0xc(%ebp)
  80171a:	e8 81 ff ff ff       	call   8016a0 <close>

	newfd = INDEX2FD(newfdnum);
  80171f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801722:	c1 e6 0c             	shl    $0xc,%esi
  801725:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80172b:	83 c4 04             	add    $0x4,%esp
  80172e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801731:	e8 d4 fd ff ff       	call   80150a <fd2data>
  801736:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801738:	89 34 24             	mov    %esi,(%esp)
  80173b:	e8 ca fd ff ff       	call   80150a <fd2data>
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801745:	89 d8                	mov    %ebx,%eax
  801747:	c1 e8 16             	shr    $0x16,%eax
  80174a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801751:	a8 01                	test   $0x1,%al
  801753:	74 11                	je     801766 <dup+0x74>
  801755:	89 d8                	mov    %ebx,%eax
  801757:	c1 e8 0c             	shr    $0xc,%eax
  80175a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801761:	f6 c2 01             	test   $0x1,%dl
  801764:	75 39                	jne    80179f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801766:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801769:	89 d0                	mov    %edx,%eax
  80176b:	c1 e8 0c             	shr    $0xc,%eax
  80176e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801775:	83 ec 0c             	sub    $0xc,%esp
  801778:	25 07 0e 00 00       	and    $0xe07,%eax
  80177d:	50                   	push   %eax
  80177e:	56                   	push   %esi
  80177f:	6a 00                	push   $0x0
  801781:	52                   	push   %edx
  801782:	6a 00                	push   $0x0
  801784:	e8 23 f6 ff ff       	call   800dac <sys_page_map>
  801789:	89 c3                	mov    %eax,%ebx
  80178b:	83 c4 20             	add    $0x20,%esp
  80178e:	85 c0                	test   %eax,%eax
  801790:	78 31                	js     8017c3 <dup+0xd1>
		goto err;

	return newfdnum;
  801792:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801795:	89 d8                	mov    %ebx,%eax
  801797:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80179a:	5b                   	pop    %ebx
  80179b:	5e                   	pop    %esi
  80179c:	5f                   	pop    %edi
  80179d:	5d                   	pop    %ebp
  80179e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80179f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017a6:	83 ec 0c             	sub    $0xc,%esp
  8017a9:	25 07 0e 00 00       	and    $0xe07,%eax
  8017ae:	50                   	push   %eax
  8017af:	57                   	push   %edi
  8017b0:	6a 00                	push   $0x0
  8017b2:	53                   	push   %ebx
  8017b3:	6a 00                	push   $0x0
  8017b5:	e8 f2 f5 ff ff       	call   800dac <sys_page_map>
  8017ba:	89 c3                	mov    %eax,%ebx
  8017bc:	83 c4 20             	add    $0x20,%esp
  8017bf:	85 c0                	test   %eax,%eax
  8017c1:	79 a3                	jns    801766 <dup+0x74>
	sys_page_unmap(0, newfd);
  8017c3:	83 ec 08             	sub    $0x8,%esp
  8017c6:	56                   	push   %esi
  8017c7:	6a 00                	push   $0x0
  8017c9:	e8 20 f6 ff ff       	call   800dee <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017ce:	83 c4 08             	add    $0x8,%esp
  8017d1:	57                   	push   %edi
  8017d2:	6a 00                	push   $0x0
  8017d4:	e8 15 f6 ff ff       	call   800dee <sys_page_unmap>
	return r;
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	eb b7                	jmp    801795 <dup+0xa3>

008017de <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	53                   	push   %ebx
  8017e2:	83 ec 1c             	sub    $0x1c,%esp
  8017e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017eb:	50                   	push   %eax
  8017ec:	53                   	push   %ebx
  8017ed:	e8 81 fd ff ff       	call   801573 <fd_lookup>
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	78 3f                	js     801838 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017f9:	83 ec 08             	sub    $0x8,%esp
  8017fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ff:	50                   	push   %eax
  801800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801803:	ff 30                	pushl  (%eax)
  801805:	e8 b9 fd ff ff       	call   8015c3 <dev_lookup>
  80180a:	83 c4 10             	add    $0x10,%esp
  80180d:	85 c0                	test   %eax,%eax
  80180f:	78 27                	js     801838 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801811:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801814:	8b 42 08             	mov    0x8(%edx),%eax
  801817:	83 e0 03             	and    $0x3,%eax
  80181a:	83 f8 01             	cmp    $0x1,%eax
  80181d:	74 1e                	je     80183d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80181f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801822:	8b 40 08             	mov    0x8(%eax),%eax
  801825:	85 c0                	test   %eax,%eax
  801827:	74 35                	je     80185e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801829:	83 ec 04             	sub    $0x4,%esp
  80182c:	ff 75 10             	pushl  0x10(%ebp)
  80182f:	ff 75 0c             	pushl  0xc(%ebp)
  801832:	52                   	push   %edx
  801833:	ff d0                	call   *%eax
  801835:	83 c4 10             	add    $0x10,%esp
}
  801838:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80183d:	a1 04 40 80 00       	mov    0x804004,%eax
  801842:	8b 40 48             	mov    0x48(%eax),%eax
  801845:	83 ec 04             	sub    $0x4,%esp
  801848:	53                   	push   %ebx
  801849:	50                   	push   %eax
  80184a:	68 40 2a 80 00       	push   $0x802a40
  80184f:	e8 c4 e9 ff ff       	call   800218 <cprintf>
		return -E_INVAL;
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80185c:	eb da                	jmp    801838 <read+0x5a>
		return -E_NOT_SUPP;
  80185e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801863:	eb d3                	jmp    801838 <read+0x5a>

00801865 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	57                   	push   %edi
  801869:	56                   	push   %esi
  80186a:	53                   	push   %ebx
  80186b:	83 ec 0c             	sub    $0xc,%esp
  80186e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801871:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801874:	bb 00 00 00 00       	mov    $0x0,%ebx
  801879:	39 f3                	cmp    %esi,%ebx
  80187b:	73 23                	jae    8018a0 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80187d:	83 ec 04             	sub    $0x4,%esp
  801880:	89 f0                	mov    %esi,%eax
  801882:	29 d8                	sub    %ebx,%eax
  801884:	50                   	push   %eax
  801885:	89 d8                	mov    %ebx,%eax
  801887:	03 45 0c             	add    0xc(%ebp),%eax
  80188a:	50                   	push   %eax
  80188b:	57                   	push   %edi
  80188c:	e8 4d ff ff ff       	call   8017de <read>
		if (m < 0)
  801891:	83 c4 10             	add    $0x10,%esp
  801894:	85 c0                	test   %eax,%eax
  801896:	78 06                	js     80189e <readn+0x39>
			return m;
		if (m == 0)
  801898:	74 06                	je     8018a0 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80189a:	01 c3                	add    %eax,%ebx
  80189c:	eb db                	jmp    801879 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80189e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8018a0:	89 d8                	mov    %ebx,%eax
  8018a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018a5:	5b                   	pop    %ebx
  8018a6:	5e                   	pop    %esi
  8018a7:	5f                   	pop    %edi
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    

008018aa <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	53                   	push   %ebx
  8018ae:	83 ec 1c             	sub    $0x1c,%esp
  8018b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b7:	50                   	push   %eax
  8018b8:	53                   	push   %ebx
  8018b9:	e8 b5 fc ff ff       	call   801573 <fd_lookup>
  8018be:	83 c4 10             	add    $0x10,%esp
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	78 3a                	js     8018ff <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018c5:	83 ec 08             	sub    $0x8,%esp
  8018c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cb:	50                   	push   %eax
  8018cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cf:	ff 30                	pushl  (%eax)
  8018d1:	e8 ed fc ff ff       	call   8015c3 <dev_lookup>
  8018d6:	83 c4 10             	add    $0x10,%esp
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	78 22                	js     8018ff <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018e4:	74 1e                	je     801904 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e9:	8b 52 0c             	mov    0xc(%edx),%edx
  8018ec:	85 d2                	test   %edx,%edx
  8018ee:	74 35                	je     801925 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018f0:	83 ec 04             	sub    $0x4,%esp
  8018f3:	ff 75 10             	pushl  0x10(%ebp)
  8018f6:	ff 75 0c             	pushl  0xc(%ebp)
  8018f9:	50                   	push   %eax
  8018fa:	ff d2                	call   *%edx
  8018fc:	83 c4 10             	add    $0x10,%esp
}
  8018ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801902:	c9                   	leave  
  801903:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801904:	a1 04 40 80 00       	mov    0x804004,%eax
  801909:	8b 40 48             	mov    0x48(%eax),%eax
  80190c:	83 ec 04             	sub    $0x4,%esp
  80190f:	53                   	push   %ebx
  801910:	50                   	push   %eax
  801911:	68 5c 2a 80 00       	push   $0x802a5c
  801916:	e8 fd e8 ff ff       	call   800218 <cprintf>
		return -E_INVAL;
  80191b:	83 c4 10             	add    $0x10,%esp
  80191e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801923:	eb da                	jmp    8018ff <write+0x55>
		return -E_NOT_SUPP;
  801925:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80192a:	eb d3                	jmp    8018ff <write+0x55>

0080192c <seek>:

int
seek(int fdnum, off_t offset)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801932:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801935:	50                   	push   %eax
  801936:	ff 75 08             	pushl  0x8(%ebp)
  801939:	e8 35 fc ff ff       	call   801573 <fd_lookup>
  80193e:	83 c4 10             	add    $0x10,%esp
  801941:	85 c0                	test   %eax,%eax
  801943:	78 0e                	js     801953 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801945:	8b 55 0c             	mov    0xc(%ebp),%edx
  801948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80194e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	53                   	push   %ebx
  801959:	83 ec 1c             	sub    $0x1c,%esp
  80195c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80195f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801962:	50                   	push   %eax
  801963:	53                   	push   %ebx
  801964:	e8 0a fc ff ff       	call   801573 <fd_lookup>
  801969:	83 c4 10             	add    $0x10,%esp
  80196c:	85 c0                	test   %eax,%eax
  80196e:	78 37                	js     8019a7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801970:	83 ec 08             	sub    $0x8,%esp
  801973:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801976:	50                   	push   %eax
  801977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197a:	ff 30                	pushl  (%eax)
  80197c:	e8 42 fc ff ff       	call   8015c3 <dev_lookup>
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	85 c0                	test   %eax,%eax
  801986:	78 1f                	js     8019a7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801988:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80198f:	74 1b                	je     8019ac <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801994:	8b 52 18             	mov    0x18(%edx),%edx
  801997:	85 d2                	test   %edx,%edx
  801999:	74 32                	je     8019cd <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80199b:	83 ec 08             	sub    $0x8,%esp
  80199e:	ff 75 0c             	pushl  0xc(%ebp)
  8019a1:	50                   	push   %eax
  8019a2:	ff d2                	call   *%edx
  8019a4:	83 c4 10             	add    $0x10,%esp
}
  8019a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    
			thisenv->env_id, fdnum);
  8019ac:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019b1:	8b 40 48             	mov    0x48(%eax),%eax
  8019b4:	83 ec 04             	sub    $0x4,%esp
  8019b7:	53                   	push   %ebx
  8019b8:	50                   	push   %eax
  8019b9:	68 1c 2a 80 00       	push   $0x802a1c
  8019be:	e8 55 e8 ff ff       	call   800218 <cprintf>
		return -E_INVAL;
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019cb:	eb da                	jmp    8019a7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8019cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019d2:	eb d3                	jmp    8019a7 <ftruncate+0x52>

008019d4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	53                   	push   %ebx
  8019d8:	83 ec 1c             	sub    $0x1c,%esp
  8019db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019e1:	50                   	push   %eax
  8019e2:	ff 75 08             	pushl  0x8(%ebp)
  8019e5:	e8 89 fb ff ff       	call   801573 <fd_lookup>
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	78 4b                	js     801a3c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019f1:	83 ec 08             	sub    $0x8,%esp
  8019f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f7:	50                   	push   %eax
  8019f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fb:	ff 30                	pushl  (%eax)
  8019fd:	e8 c1 fb ff ff       	call   8015c3 <dev_lookup>
  801a02:	83 c4 10             	add    $0x10,%esp
  801a05:	85 c0                	test   %eax,%eax
  801a07:	78 33                	js     801a3c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a10:	74 2f                	je     801a41 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a12:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a15:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a1c:	00 00 00 
	stat->st_isdir = 0;
  801a1f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a26:	00 00 00 
	stat->st_dev = dev;
  801a29:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a2f:	83 ec 08             	sub    $0x8,%esp
  801a32:	53                   	push   %ebx
  801a33:	ff 75 f0             	pushl  -0x10(%ebp)
  801a36:	ff 50 14             	call   *0x14(%eax)
  801a39:	83 c4 10             	add    $0x10,%esp
}
  801a3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    
		return -E_NOT_SUPP;
  801a41:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a46:	eb f4                	jmp    801a3c <fstat+0x68>

00801a48 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	56                   	push   %esi
  801a4c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a4d:	83 ec 08             	sub    $0x8,%esp
  801a50:	6a 00                	push   $0x0
  801a52:	ff 75 08             	pushl  0x8(%ebp)
  801a55:	e8 bb 01 00 00       	call   801c15 <open>
  801a5a:	89 c3                	mov    %eax,%ebx
  801a5c:	83 c4 10             	add    $0x10,%esp
  801a5f:	85 c0                	test   %eax,%eax
  801a61:	78 1b                	js     801a7e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a63:	83 ec 08             	sub    $0x8,%esp
  801a66:	ff 75 0c             	pushl  0xc(%ebp)
  801a69:	50                   	push   %eax
  801a6a:	e8 65 ff ff ff       	call   8019d4 <fstat>
  801a6f:	89 c6                	mov    %eax,%esi
	close(fd);
  801a71:	89 1c 24             	mov    %ebx,(%esp)
  801a74:	e8 27 fc ff ff       	call   8016a0 <close>
	return r;
  801a79:	83 c4 10             	add    $0x10,%esp
  801a7c:	89 f3                	mov    %esi,%ebx
}
  801a7e:	89 d8                	mov    %ebx,%eax
  801a80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a83:	5b                   	pop    %ebx
  801a84:	5e                   	pop    %esi
  801a85:	5d                   	pop    %ebp
  801a86:	c3                   	ret    

00801a87 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	56                   	push   %esi
  801a8b:	53                   	push   %ebx
  801a8c:	89 c6                	mov    %eax,%esi
  801a8e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a90:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801a97:	74 27                	je     801ac0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a99:	6a 07                	push   $0x7
  801a9b:	68 00 50 80 00       	push   $0x805000
  801aa0:	56                   	push   %esi
  801aa1:	ff 35 00 40 80 00    	pushl  0x804000
  801aa7:	e8 3a 07 00 00       	call   8021e6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801aac:	83 c4 0c             	add    $0xc,%esp
  801aaf:	6a 00                	push   $0x0
  801ab1:	53                   	push   %ebx
  801ab2:	6a 00                	push   $0x0
  801ab4:	e8 c4 06 00 00       	call   80217d <ipc_recv>
}
  801ab9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801abc:	5b                   	pop    %ebx
  801abd:	5e                   	pop    %esi
  801abe:	5d                   	pop    %ebp
  801abf:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ac0:	83 ec 0c             	sub    $0xc,%esp
  801ac3:	6a 01                	push   $0x1
  801ac5:	e8 74 07 00 00       	call   80223e <ipc_find_env>
  801aca:	a3 00 40 80 00       	mov    %eax,0x804000
  801acf:	83 c4 10             	add    $0x10,%esp
  801ad2:	eb c5                	jmp    801a99 <fsipc+0x12>

00801ad4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801aed:	ba 00 00 00 00       	mov    $0x0,%edx
  801af2:	b8 02 00 00 00       	mov    $0x2,%eax
  801af7:	e8 8b ff ff ff       	call   801a87 <fsipc>
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <devfile_flush>:
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	8b 40 0c             	mov    0xc(%eax),%eax
  801b0a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801b0f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b14:	b8 06 00 00 00       	mov    $0x6,%eax
  801b19:	e8 69 ff ff ff       	call   801a87 <fsipc>
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <devfile_stat>:
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	53                   	push   %ebx
  801b24:	83 ec 04             	sub    $0x4,%esp
  801b27:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801b30:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b35:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3a:	b8 05 00 00 00       	mov    $0x5,%eax
  801b3f:	e8 43 ff ff ff       	call   801a87 <fsipc>
  801b44:	85 c0                	test   %eax,%eax
  801b46:	78 2c                	js     801b74 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b48:	83 ec 08             	sub    $0x8,%esp
  801b4b:	68 00 50 80 00       	push   $0x805000
  801b50:	53                   	push   %ebx
  801b51:	e8 21 ee ff ff       	call   800977 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b56:	a1 80 50 80 00       	mov    0x805080,%eax
  801b5b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b61:	a1 84 50 80 00       	mov    0x805084,%eax
  801b66:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b6c:	83 c4 10             	add    $0x10,%esp
  801b6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <devfile_write>:
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801b7f:	68 8c 2a 80 00       	push   $0x802a8c
  801b84:	68 90 00 00 00       	push   $0x90
  801b89:	68 aa 2a 80 00       	push   $0x802aaa
  801b8e:	e8 8f e5 ff ff       	call   800122 <_panic>

00801b93 <devfile_read>:
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	56                   	push   %esi
  801b97:	53                   	push   %ebx
  801b98:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801ba6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bac:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb1:	b8 03 00 00 00       	mov    $0x3,%eax
  801bb6:	e8 cc fe ff ff       	call   801a87 <fsipc>
  801bbb:	89 c3                	mov    %eax,%ebx
  801bbd:	85 c0                	test   %eax,%eax
  801bbf:	78 1f                	js     801be0 <devfile_read+0x4d>
	assert(r <= n);
  801bc1:	39 f0                	cmp    %esi,%eax
  801bc3:	77 24                	ja     801be9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801bc5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bca:	7f 33                	jg     801bff <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801bcc:	83 ec 04             	sub    $0x4,%esp
  801bcf:	50                   	push   %eax
  801bd0:	68 00 50 80 00       	push   $0x805000
  801bd5:	ff 75 0c             	pushl  0xc(%ebp)
  801bd8:	e8 28 ef ff ff       	call   800b05 <memmove>
	return r;
  801bdd:	83 c4 10             	add    $0x10,%esp
}
  801be0:	89 d8                	mov    %ebx,%eax
  801be2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be5:	5b                   	pop    %ebx
  801be6:	5e                   	pop    %esi
  801be7:	5d                   	pop    %ebp
  801be8:	c3                   	ret    
	assert(r <= n);
  801be9:	68 b5 2a 80 00       	push   $0x802ab5
  801bee:	68 65 29 80 00       	push   $0x802965
  801bf3:	6a 7c                	push   $0x7c
  801bf5:	68 aa 2a 80 00       	push   $0x802aaa
  801bfa:	e8 23 e5 ff ff       	call   800122 <_panic>
	assert(r <= PGSIZE);
  801bff:	68 bc 2a 80 00       	push   $0x802abc
  801c04:	68 65 29 80 00       	push   $0x802965
  801c09:	6a 7d                	push   $0x7d
  801c0b:	68 aa 2a 80 00       	push   $0x802aaa
  801c10:	e8 0d e5 ff ff       	call   800122 <_panic>

00801c15 <open>:
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	56                   	push   %esi
  801c19:	53                   	push   %ebx
  801c1a:	83 ec 1c             	sub    $0x1c,%esp
  801c1d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c20:	56                   	push   %esi
  801c21:	e8 18 ed ff ff       	call   80093e <strlen>
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c2e:	7f 6c                	jg     801c9c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801c30:	83 ec 0c             	sub    $0xc,%esp
  801c33:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c36:	50                   	push   %eax
  801c37:	e8 e5 f8 ff ff       	call   801521 <fd_alloc>
  801c3c:	89 c3                	mov    %eax,%ebx
  801c3e:	83 c4 10             	add    $0x10,%esp
  801c41:	85 c0                	test   %eax,%eax
  801c43:	78 3c                	js     801c81 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c45:	83 ec 08             	sub    $0x8,%esp
  801c48:	56                   	push   %esi
  801c49:	68 00 50 80 00       	push   $0x805000
  801c4e:	e8 24 ed ff ff       	call   800977 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c56:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c63:	e8 1f fe ff ff       	call   801a87 <fsipc>
  801c68:	89 c3                	mov    %eax,%ebx
  801c6a:	83 c4 10             	add    $0x10,%esp
  801c6d:	85 c0                	test   %eax,%eax
  801c6f:	78 19                	js     801c8a <open+0x75>
	return fd2num(fd);
  801c71:	83 ec 0c             	sub    $0xc,%esp
  801c74:	ff 75 f4             	pushl  -0xc(%ebp)
  801c77:	e8 7e f8 ff ff       	call   8014fa <fd2num>
  801c7c:	89 c3                	mov    %eax,%ebx
  801c7e:	83 c4 10             	add    $0x10,%esp
}
  801c81:	89 d8                	mov    %ebx,%eax
  801c83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c86:	5b                   	pop    %ebx
  801c87:	5e                   	pop    %esi
  801c88:	5d                   	pop    %ebp
  801c89:	c3                   	ret    
		fd_close(fd, 0);
  801c8a:	83 ec 08             	sub    $0x8,%esp
  801c8d:	6a 00                	push   $0x0
  801c8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801c92:	e8 82 f9 ff ff       	call   801619 <fd_close>
		return r;
  801c97:	83 c4 10             	add    $0x10,%esp
  801c9a:	eb e5                	jmp    801c81 <open+0x6c>
		return -E_BAD_PATH;
  801c9c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ca1:	eb de                	jmp    801c81 <open+0x6c>

00801ca3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ca9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cae:	b8 08 00 00 00       	mov    $0x8,%eax
  801cb3:	e8 cf fd ff ff       	call   801a87 <fsipc>
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	56                   	push   %esi
  801cbe:	53                   	push   %ebx
  801cbf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cc2:	83 ec 0c             	sub    $0xc,%esp
  801cc5:	ff 75 08             	pushl  0x8(%ebp)
  801cc8:	e8 3d f8 ff ff       	call   80150a <fd2data>
  801ccd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ccf:	83 c4 08             	add    $0x8,%esp
  801cd2:	68 c8 2a 80 00       	push   $0x802ac8
  801cd7:	53                   	push   %ebx
  801cd8:	e8 9a ec ff ff       	call   800977 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cdd:	8b 46 04             	mov    0x4(%esi),%eax
  801ce0:	2b 06                	sub    (%esi),%eax
  801ce2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ce8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cef:	00 00 00 
	stat->st_dev = &devpipe;
  801cf2:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801cf9:	30 80 00 
	return 0;
}
  801cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801d01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d04:	5b                   	pop    %ebx
  801d05:	5e                   	pop    %esi
  801d06:	5d                   	pop    %ebp
  801d07:	c3                   	ret    

00801d08 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	53                   	push   %ebx
  801d0c:	83 ec 0c             	sub    $0xc,%esp
  801d0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d12:	53                   	push   %ebx
  801d13:	6a 00                	push   $0x0
  801d15:	e8 d4 f0 ff ff       	call   800dee <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d1a:	89 1c 24             	mov    %ebx,(%esp)
  801d1d:	e8 e8 f7 ff ff       	call   80150a <fd2data>
  801d22:	83 c4 08             	add    $0x8,%esp
  801d25:	50                   	push   %eax
  801d26:	6a 00                	push   $0x0
  801d28:	e8 c1 f0 ff ff       	call   800dee <sys_page_unmap>
}
  801d2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <_pipeisclosed>:
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	57                   	push   %edi
  801d36:	56                   	push   %esi
  801d37:	53                   	push   %ebx
  801d38:	83 ec 1c             	sub    $0x1c,%esp
  801d3b:	89 c7                	mov    %eax,%edi
  801d3d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d3f:	a1 04 40 80 00       	mov    0x804004,%eax
  801d44:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	57                   	push   %edi
  801d4b:	e8 29 05 00 00       	call   802279 <pageref>
  801d50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d53:	89 34 24             	mov    %esi,(%esp)
  801d56:	e8 1e 05 00 00       	call   802279 <pageref>
		nn = thisenv->env_runs;
  801d5b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d61:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d64:	83 c4 10             	add    $0x10,%esp
  801d67:	39 cb                	cmp    %ecx,%ebx
  801d69:	74 1b                	je     801d86 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d6b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d6e:	75 cf                	jne    801d3f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d70:	8b 42 58             	mov    0x58(%edx),%eax
  801d73:	6a 01                	push   $0x1
  801d75:	50                   	push   %eax
  801d76:	53                   	push   %ebx
  801d77:	68 cf 2a 80 00       	push   $0x802acf
  801d7c:	e8 97 e4 ff ff       	call   800218 <cprintf>
  801d81:	83 c4 10             	add    $0x10,%esp
  801d84:	eb b9                	jmp    801d3f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d86:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d89:	0f 94 c0             	sete   %al
  801d8c:	0f b6 c0             	movzbl %al,%eax
}
  801d8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d92:	5b                   	pop    %ebx
  801d93:	5e                   	pop    %esi
  801d94:	5f                   	pop    %edi
  801d95:	5d                   	pop    %ebp
  801d96:	c3                   	ret    

00801d97 <devpipe_write>:
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	57                   	push   %edi
  801d9b:	56                   	push   %esi
  801d9c:	53                   	push   %ebx
  801d9d:	83 ec 28             	sub    $0x28,%esp
  801da0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801da3:	56                   	push   %esi
  801da4:	e8 61 f7 ff ff       	call   80150a <fd2data>
  801da9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dab:	83 c4 10             	add    $0x10,%esp
  801dae:	bf 00 00 00 00       	mov    $0x0,%edi
  801db3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801db6:	74 4f                	je     801e07 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801db8:	8b 43 04             	mov    0x4(%ebx),%eax
  801dbb:	8b 0b                	mov    (%ebx),%ecx
  801dbd:	8d 51 20             	lea    0x20(%ecx),%edx
  801dc0:	39 d0                	cmp    %edx,%eax
  801dc2:	72 14                	jb     801dd8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dc4:	89 da                	mov    %ebx,%edx
  801dc6:	89 f0                	mov    %esi,%eax
  801dc8:	e8 65 ff ff ff       	call   801d32 <_pipeisclosed>
  801dcd:	85 c0                	test   %eax,%eax
  801dcf:	75 3b                	jne    801e0c <devpipe_write+0x75>
			sys_yield();
  801dd1:	e8 74 ef ff ff       	call   800d4a <sys_yield>
  801dd6:	eb e0                	jmp    801db8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ddb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ddf:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801de2:	89 c2                	mov    %eax,%edx
  801de4:	c1 fa 1f             	sar    $0x1f,%edx
  801de7:	89 d1                	mov    %edx,%ecx
  801de9:	c1 e9 1b             	shr    $0x1b,%ecx
  801dec:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801def:	83 e2 1f             	and    $0x1f,%edx
  801df2:	29 ca                	sub    %ecx,%edx
  801df4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801df8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dfc:	83 c0 01             	add    $0x1,%eax
  801dff:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e02:	83 c7 01             	add    $0x1,%edi
  801e05:	eb ac                	jmp    801db3 <devpipe_write+0x1c>
	return i;
  801e07:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0a:	eb 05                	jmp    801e11 <devpipe_write+0x7a>
				return 0;
  801e0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e14:	5b                   	pop    %ebx
  801e15:	5e                   	pop    %esi
  801e16:	5f                   	pop    %edi
  801e17:	5d                   	pop    %ebp
  801e18:	c3                   	ret    

00801e19 <devpipe_read>:
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	57                   	push   %edi
  801e1d:	56                   	push   %esi
  801e1e:	53                   	push   %ebx
  801e1f:	83 ec 18             	sub    $0x18,%esp
  801e22:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e25:	57                   	push   %edi
  801e26:	e8 df f6 ff ff       	call   80150a <fd2data>
  801e2b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e2d:	83 c4 10             	add    $0x10,%esp
  801e30:	be 00 00 00 00       	mov    $0x0,%esi
  801e35:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e38:	75 14                	jne    801e4e <devpipe_read+0x35>
	return i;
  801e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3d:	eb 02                	jmp    801e41 <devpipe_read+0x28>
				return i;
  801e3f:	89 f0                	mov    %esi,%eax
}
  801e41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e44:	5b                   	pop    %ebx
  801e45:	5e                   	pop    %esi
  801e46:	5f                   	pop    %edi
  801e47:	5d                   	pop    %ebp
  801e48:	c3                   	ret    
			sys_yield();
  801e49:	e8 fc ee ff ff       	call   800d4a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e4e:	8b 03                	mov    (%ebx),%eax
  801e50:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e53:	75 18                	jne    801e6d <devpipe_read+0x54>
			if (i > 0)
  801e55:	85 f6                	test   %esi,%esi
  801e57:	75 e6                	jne    801e3f <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e59:	89 da                	mov    %ebx,%edx
  801e5b:	89 f8                	mov    %edi,%eax
  801e5d:	e8 d0 fe ff ff       	call   801d32 <_pipeisclosed>
  801e62:	85 c0                	test   %eax,%eax
  801e64:	74 e3                	je     801e49 <devpipe_read+0x30>
				return 0;
  801e66:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6b:	eb d4                	jmp    801e41 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e6d:	99                   	cltd   
  801e6e:	c1 ea 1b             	shr    $0x1b,%edx
  801e71:	01 d0                	add    %edx,%eax
  801e73:	83 e0 1f             	and    $0x1f,%eax
  801e76:	29 d0                	sub    %edx,%eax
  801e78:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e80:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e83:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e86:	83 c6 01             	add    $0x1,%esi
  801e89:	eb aa                	jmp    801e35 <devpipe_read+0x1c>

00801e8b <pipe>:
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	56                   	push   %esi
  801e8f:	53                   	push   %ebx
  801e90:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e93:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e96:	50                   	push   %eax
  801e97:	e8 85 f6 ff ff       	call   801521 <fd_alloc>
  801e9c:	89 c3                	mov    %eax,%ebx
  801e9e:	83 c4 10             	add    $0x10,%esp
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	0f 88 23 01 00 00    	js     801fcc <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	68 07 04 00 00       	push   $0x407
  801eb1:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb4:	6a 00                	push   $0x0
  801eb6:	e8 ae ee ff ff       	call   800d69 <sys_page_alloc>
  801ebb:	89 c3                	mov    %eax,%ebx
  801ebd:	83 c4 10             	add    $0x10,%esp
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	0f 88 04 01 00 00    	js     801fcc <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ec8:	83 ec 0c             	sub    $0xc,%esp
  801ecb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ece:	50                   	push   %eax
  801ecf:	e8 4d f6 ff ff       	call   801521 <fd_alloc>
  801ed4:	89 c3                	mov    %eax,%ebx
  801ed6:	83 c4 10             	add    $0x10,%esp
  801ed9:	85 c0                	test   %eax,%eax
  801edb:	0f 88 db 00 00 00    	js     801fbc <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee1:	83 ec 04             	sub    $0x4,%esp
  801ee4:	68 07 04 00 00       	push   $0x407
  801ee9:	ff 75 f0             	pushl  -0x10(%ebp)
  801eec:	6a 00                	push   $0x0
  801eee:	e8 76 ee ff ff       	call   800d69 <sys_page_alloc>
  801ef3:	89 c3                	mov    %eax,%ebx
  801ef5:	83 c4 10             	add    $0x10,%esp
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	0f 88 bc 00 00 00    	js     801fbc <pipe+0x131>
	va = fd2data(fd0);
  801f00:	83 ec 0c             	sub    $0xc,%esp
  801f03:	ff 75 f4             	pushl  -0xc(%ebp)
  801f06:	e8 ff f5 ff ff       	call   80150a <fd2data>
  801f0b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f0d:	83 c4 0c             	add    $0xc,%esp
  801f10:	68 07 04 00 00       	push   $0x407
  801f15:	50                   	push   %eax
  801f16:	6a 00                	push   $0x0
  801f18:	e8 4c ee ff ff       	call   800d69 <sys_page_alloc>
  801f1d:	89 c3                	mov    %eax,%ebx
  801f1f:	83 c4 10             	add    $0x10,%esp
  801f22:	85 c0                	test   %eax,%eax
  801f24:	0f 88 82 00 00 00    	js     801fac <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f2a:	83 ec 0c             	sub    $0xc,%esp
  801f2d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f30:	e8 d5 f5 ff ff       	call   80150a <fd2data>
  801f35:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f3c:	50                   	push   %eax
  801f3d:	6a 00                	push   $0x0
  801f3f:	56                   	push   %esi
  801f40:	6a 00                	push   $0x0
  801f42:	e8 65 ee ff ff       	call   800dac <sys_page_map>
  801f47:	89 c3                	mov    %eax,%ebx
  801f49:	83 c4 20             	add    $0x20,%esp
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	78 4e                	js     801f9e <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f50:	a1 20 30 80 00       	mov    0x803020,%eax
  801f55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f58:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f64:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f67:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f73:	83 ec 0c             	sub    $0xc,%esp
  801f76:	ff 75 f4             	pushl  -0xc(%ebp)
  801f79:	e8 7c f5 ff ff       	call   8014fa <fd2num>
  801f7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f81:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f83:	83 c4 04             	add    $0x4,%esp
  801f86:	ff 75 f0             	pushl  -0x10(%ebp)
  801f89:	e8 6c f5 ff ff       	call   8014fa <fd2num>
  801f8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f91:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f94:	83 c4 10             	add    $0x10,%esp
  801f97:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f9c:	eb 2e                	jmp    801fcc <pipe+0x141>
	sys_page_unmap(0, va);
  801f9e:	83 ec 08             	sub    $0x8,%esp
  801fa1:	56                   	push   %esi
  801fa2:	6a 00                	push   $0x0
  801fa4:	e8 45 ee ff ff       	call   800dee <sys_page_unmap>
  801fa9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fac:	83 ec 08             	sub    $0x8,%esp
  801faf:	ff 75 f0             	pushl  -0x10(%ebp)
  801fb2:	6a 00                	push   $0x0
  801fb4:	e8 35 ee ff ff       	call   800dee <sys_page_unmap>
  801fb9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fbc:	83 ec 08             	sub    $0x8,%esp
  801fbf:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc2:	6a 00                	push   $0x0
  801fc4:	e8 25 ee ff ff       	call   800dee <sys_page_unmap>
  801fc9:	83 c4 10             	add    $0x10,%esp
}
  801fcc:	89 d8                	mov    %ebx,%eax
  801fce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fd1:	5b                   	pop    %ebx
  801fd2:	5e                   	pop    %esi
  801fd3:	5d                   	pop    %ebp
  801fd4:	c3                   	ret    

00801fd5 <pipeisclosed>:
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fde:	50                   	push   %eax
  801fdf:	ff 75 08             	pushl  0x8(%ebp)
  801fe2:	e8 8c f5 ff ff       	call   801573 <fd_lookup>
  801fe7:	83 c4 10             	add    $0x10,%esp
  801fea:	85 c0                	test   %eax,%eax
  801fec:	78 18                	js     802006 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fee:	83 ec 0c             	sub    $0xc,%esp
  801ff1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff4:	e8 11 f5 ff ff       	call   80150a <fd2data>
	return _pipeisclosed(fd, p);
  801ff9:	89 c2                	mov    %eax,%edx
  801ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffe:	e8 2f fd ff ff       	call   801d32 <_pipeisclosed>
  802003:	83 c4 10             	add    $0x10,%esp
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802008:	b8 00 00 00 00       	mov    $0x0,%eax
  80200d:	c3                   	ret    

0080200e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802014:	68 e7 2a 80 00       	push   $0x802ae7
  802019:	ff 75 0c             	pushl  0xc(%ebp)
  80201c:	e8 56 e9 ff ff       	call   800977 <strcpy>
	return 0;
}
  802021:	b8 00 00 00 00       	mov    $0x0,%eax
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <devcons_write>:
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	57                   	push   %edi
  80202c:	56                   	push   %esi
  80202d:	53                   	push   %ebx
  80202e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802034:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802039:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80203f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802042:	73 31                	jae    802075 <devcons_write+0x4d>
		m = n - tot;
  802044:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802047:	29 f3                	sub    %esi,%ebx
  802049:	83 fb 7f             	cmp    $0x7f,%ebx
  80204c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802051:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802054:	83 ec 04             	sub    $0x4,%esp
  802057:	53                   	push   %ebx
  802058:	89 f0                	mov    %esi,%eax
  80205a:	03 45 0c             	add    0xc(%ebp),%eax
  80205d:	50                   	push   %eax
  80205e:	57                   	push   %edi
  80205f:	e8 a1 ea ff ff       	call   800b05 <memmove>
		sys_cputs(buf, m);
  802064:	83 c4 08             	add    $0x8,%esp
  802067:	53                   	push   %ebx
  802068:	57                   	push   %edi
  802069:	e8 3f ec ff ff       	call   800cad <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80206e:	01 de                	add    %ebx,%esi
  802070:	83 c4 10             	add    $0x10,%esp
  802073:	eb ca                	jmp    80203f <devcons_write+0x17>
}
  802075:	89 f0                	mov    %esi,%eax
  802077:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80207a:	5b                   	pop    %ebx
  80207b:	5e                   	pop    %esi
  80207c:	5f                   	pop    %edi
  80207d:	5d                   	pop    %ebp
  80207e:	c3                   	ret    

0080207f <devcons_read>:
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 08             	sub    $0x8,%esp
  802085:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80208a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80208e:	74 21                	je     8020b1 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802090:	e8 36 ec ff ff       	call   800ccb <sys_cgetc>
  802095:	85 c0                	test   %eax,%eax
  802097:	75 07                	jne    8020a0 <devcons_read+0x21>
		sys_yield();
  802099:	e8 ac ec ff ff       	call   800d4a <sys_yield>
  80209e:	eb f0                	jmp    802090 <devcons_read+0x11>
	if (c < 0)
  8020a0:	78 0f                	js     8020b1 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020a2:	83 f8 04             	cmp    $0x4,%eax
  8020a5:	74 0c                	je     8020b3 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020aa:	88 02                	mov    %al,(%edx)
	return 1;
  8020ac:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    
		return 0;
  8020b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b8:	eb f7                	jmp    8020b1 <devcons_read+0x32>

008020ba <cputchar>:
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020c6:	6a 01                	push   $0x1
  8020c8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020cb:	50                   	push   %eax
  8020cc:	e8 dc eb ff ff       	call   800cad <sys_cputs>
}
  8020d1:	83 c4 10             	add    $0x10,%esp
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <getchar>:
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020dc:	6a 01                	push   $0x1
  8020de:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020e1:	50                   	push   %eax
  8020e2:	6a 00                	push   $0x0
  8020e4:	e8 f5 f6 ff ff       	call   8017de <read>
	if (r < 0)
  8020e9:	83 c4 10             	add    $0x10,%esp
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	78 06                	js     8020f6 <getchar+0x20>
	if (r < 1)
  8020f0:	74 06                	je     8020f8 <getchar+0x22>
	return c;
  8020f2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    
		return -E_EOF;
  8020f8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020fd:	eb f7                	jmp    8020f6 <getchar+0x20>

008020ff <iscons>:
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802105:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802108:	50                   	push   %eax
  802109:	ff 75 08             	pushl  0x8(%ebp)
  80210c:	e8 62 f4 ff ff       	call   801573 <fd_lookup>
  802111:	83 c4 10             	add    $0x10,%esp
  802114:	85 c0                	test   %eax,%eax
  802116:	78 11                	js     802129 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802121:	39 10                	cmp    %edx,(%eax)
  802123:	0f 94 c0             	sete   %al
  802126:	0f b6 c0             	movzbl %al,%eax
}
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <opencons>:
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802131:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802134:	50                   	push   %eax
  802135:	e8 e7 f3 ff ff       	call   801521 <fd_alloc>
  80213a:	83 c4 10             	add    $0x10,%esp
  80213d:	85 c0                	test   %eax,%eax
  80213f:	78 3a                	js     80217b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802141:	83 ec 04             	sub    $0x4,%esp
  802144:	68 07 04 00 00       	push   $0x407
  802149:	ff 75 f4             	pushl  -0xc(%ebp)
  80214c:	6a 00                	push   $0x0
  80214e:	e8 16 ec ff ff       	call   800d69 <sys_page_alloc>
  802153:	83 c4 10             	add    $0x10,%esp
  802156:	85 c0                	test   %eax,%eax
  802158:	78 21                	js     80217b <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80215a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802163:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802168:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80216f:	83 ec 0c             	sub    $0xc,%esp
  802172:	50                   	push   %eax
  802173:	e8 82 f3 ff ff       	call   8014fa <fd2num>
  802178:	83 c4 10             	add    $0x10,%esp
}
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
  802180:	56                   	push   %esi
  802181:	53                   	push   %ebx
  802182:	8b 75 08             	mov    0x8(%ebp),%esi
  802185:	8b 45 0c             	mov    0xc(%ebp),%eax
  802188:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  80218b:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80218d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802192:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802195:	83 ec 0c             	sub    $0xc,%esp
  802198:	50                   	push   %eax
  802199:	e8 7b ed ff ff       	call   800f19 <sys_ipc_recv>
	if(ret < 0){
  80219e:	83 c4 10             	add    $0x10,%esp
  8021a1:	85 c0                	test   %eax,%eax
  8021a3:	78 2b                	js     8021d0 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021a5:	85 f6                	test   %esi,%esi
  8021a7:	74 0a                	je     8021b3 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8021a9:	a1 04 40 80 00       	mov    0x804004,%eax
  8021ae:	8b 40 74             	mov    0x74(%eax),%eax
  8021b1:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021b3:	85 db                	test   %ebx,%ebx
  8021b5:	74 0a                	je     8021c1 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8021b7:	a1 04 40 80 00       	mov    0x804004,%eax
  8021bc:	8b 40 78             	mov    0x78(%eax),%eax
  8021bf:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8021c1:	a1 04 40 80 00       	mov    0x804004,%eax
  8021c6:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021cc:	5b                   	pop    %ebx
  8021cd:	5e                   	pop    %esi
  8021ce:	5d                   	pop    %ebp
  8021cf:	c3                   	ret    
		if(from_env_store)
  8021d0:	85 f6                	test   %esi,%esi
  8021d2:	74 06                	je     8021da <ipc_recv+0x5d>
			*from_env_store = 0;
  8021d4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021da:	85 db                	test   %ebx,%ebx
  8021dc:	74 eb                	je     8021c9 <ipc_recv+0x4c>
			*perm_store = 0;
  8021de:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021e4:	eb e3                	jmp    8021c9 <ipc_recv+0x4c>

008021e6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	57                   	push   %edi
  8021ea:	56                   	push   %esi
  8021eb:	53                   	push   %ebx
  8021ec:	83 ec 0c             	sub    $0xc,%esp
  8021ef:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021f2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021f8:	85 db                	test   %ebx,%ebx
  8021fa:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021ff:	0f 44 d8             	cmove  %eax,%ebx
  802202:	eb 05                	jmp    802209 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802204:	e8 41 eb ff ff       	call   800d4a <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802209:	ff 75 14             	pushl  0x14(%ebp)
  80220c:	53                   	push   %ebx
  80220d:	56                   	push   %esi
  80220e:	57                   	push   %edi
  80220f:	e8 e2 ec ff ff       	call   800ef6 <sys_ipc_try_send>
  802214:	83 c4 10             	add    $0x10,%esp
  802217:	85 c0                	test   %eax,%eax
  802219:	74 1b                	je     802236 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80221b:	79 e7                	jns    802204 <ipc_send+0x1e>
  80221d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802220:	74 e2                	je     802204 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802222:	83 ec 04             	sub    $0x4,%esp
  802225:	68 f3 2a 80 00       	push   $0x802af3
  80222a:	6a 49                	push   $0x49
  80222c:	68 08 2b 80 00       	push   $0x802b08
  802231:	e8 ec de ff ff       	call   800122 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802236:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802239:	5b                   	pop    %ebx
  80223a:	5e                   	pop    %esi
  80223b:	5f                   	pop    %edi
  80223c:	5d                   	pop    %ebp
  80223d:	c3                   	ret    

0080223e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802244:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802249:	89 c2                	mov    %eax,%edx
  80224b:	c1 e2 07             	shl    $0x7,%edx
  80224e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802254:	8b 52 50             	mov    0x50(%edx),%edx
  802257:	39 ca                	cmp    %ecx,%edx
  802259:	74 11                	je     80226c <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80225b:	83 c0 01             	add    $0x1,%eax
  80225e:	3d 00 04 00 00       	cmp    $0x400,%eax
  802263:	75 e4                	jne    802249 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802265:	b8 00 00 00 00       	mov    $0x0,%eax
  80226a:	eb 0b                	jmp    802277 <ipc_find_env+0x39>
			return envs[i].env_id;
  80226c:	c1 e0 07             	shl    $0x7,%eax
  80226f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802274:	8b 40 48             	mov    0x48(%eax),%eax
}
  802277:	5d                   	pop    %ebp
  802278:	c3                   	ret    

00802279 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80227f:	89 d0                	mov    %edx,%eax
  802281:	c1 e8 16             	shr    $0x16,%eax
  802284:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80228b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802290:	f6 c1 01             	test   $0x1,%cl
  802293:	74 1d                	je     8022b2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802295:	c1 ea 0c             	shr    $0xc,%edx
  802298:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80229f:	f6 c2 01             	test   $0x1,%dl
  8022a2:	74 0e                	je     8022b2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022a4:	c1 ea 0c             	shr    $0xc,%edx
  8022a7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022ae:	ef 
  8022af:	0f b7 c0             	movzwl %ax,%eax
}
  8022b2:	5d                   	pop    %ebp
  8022b3:	c3                   	ret    
  8022b4:	66 90                	xchg   %ax,%ax
  8022b6:	66 90                	xchg   %ax,%ax
  8022b8:	66 90                	xchg   %ax,%ax
  8022ba:	66 90                	xchg   %ax,%ax
  8022bc:	66 90                	xchg   %ax,%ax
  8022be:	66 90                	xchg   %ax,%ax

008022c0 <__udivdi3>:
  8022c0:	55                   	push   %ebp
  8022c1:	57                   	push   %edi
  8022c2:	56                   	push   %esi
  8022c3:	53                   	push   %ebx
  8022c4:	83 ec 1c             	sub    $0x1c,%esp
  8022c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022d7:	85 d2                	test   %edx,%edx
  8022d9:	75 4d                	jne    802328 <__udivdi3+0x68>
  8022db:	39 f3                	cmp    %esi,%ebx
  8022dd:	76 19                	jbe    8022f8 <__udivdi3+0x38>
  8022df:	31 ff                	xor    %edi,%edi
  8022e1:	89 e8                	mov    %ebp,%eax
  8022e3:	89 f2                	mov    %esi,%edx
  8022e5:	f7 f3                	div    %ebx
  8022e7:	89 fa                	mov    %edi,%edx
  8022e9:	83 c4 1c             	add    $0x1c,%esp
  8022ec:	5b                   	pop    %ebx
  8022ed:	5e                   	pop    %esi
  8022ee:	5f                   	pop    %edi
  8022ef:	5d                   	pop    %ebp
  8022f0:	c3                   	ret    
  8022f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022f8:	89 d9                	mov    %ebx,%ecx
  8022fa:	85 db                	test   %ebx,%ebx
  8022fc:	75 0b                	jne    802309 <__udivdi3+0x49>
  8022fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802303:	31 d2                	xor    %edx,%edx
  802305:	f7 f3                	div    %ebx
  802307:	89 c1                	mov    %eax,%ecx
  802309:	31 d2                	xor    %edx,%edx
  80230b:	89 f0                	mov    %esi,%eax
  80230d:	f7 f1                	div    %ecx
  80230f:	89 c6                	mov    %eax,%esi
  802311:	89 e8                	mov    %ebp,%eax
  802313:	89 f7                	mov    %esi,%edi
  802315:	f7 f1                	div    %ecx
  802317:	89 fa                	mov    %edi,%edx
  802319:	83 c4 1c             	add    $0x1c,%esp
  80231c:	5b                   	pop    %ebx
  80231d:	5e                   	pop    %esi
  80231e:	5f                   	pop    %edi
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    
  802321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802328:	39 f2                	cmp    %esi,%edx
  80232a:	77 1c                	ja     802348 <__udivdi3+0x88>
  80232c:	0f bd fa             	bsr    %edx,%edi
  80232f:	83 f7 1f             	xor    $0x1f,%edi
  802332:	75 2c                	jne    802360 <__udivdi3+0xa0>
  802334:	39 f2                	cmp    %esi,%edx
  802336:	72 06                	jb     80233e <__udivdi3+0x7e>
  802338:	31 c0                	xor    %eax,%eax
  80233a:	39 eb                	cmp    %ebp,%ebx
  80233c:	77 a9                	ja     8022e7 <__udivdi3+0x27>
  80233e:	b8 01 00 00 00       	mov    $0x1,%eax
  802343:	eb a2                	jmp    8022e7 <__udivdi3+0x27>
  802345:	8d 76 00             	lea    0x0(%esi),%esi
  802348:	31 ff                	xor    %edi,%edi
  80234a:	31 c0                	xor    %eax,%eax
  80234c:	89 fa                	mov    %edi,%edx
  80234e:	83 c4 1c             	add    $0x1c,%esp
  802351:	5b                   	pop    %ebx
  802352:	5e                   	pop    %esi
  802353:	5f                   	pop    %edi
  802354:	5d                   	pop    %ebp
  802355:	c3                   	ret    
  802356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80235d:	8d 76 00             	lea    0x0(%esi),%esi
  802360:	89 f9                	mov    %edi,%ecx
  802362:	b8 20 00 00 00       	mov    $0x20,%eax
  802367:	29 f8                	sub    %edi,%eax
  802369:	d3 e2                	shl    %cl,%edx
  80236b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80236f:	89 c1                	mov    %eax,%ecx
  802371:	89 da                	mov    %ebx,%edx
  802373:	d3 ea                	shr    %cl,%edx
  802375:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802379:	09 d1                	or     %edx,%ecx
  80237b:	89 f2                	mov    %esi,%edx
  80237d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802381:	89 f9                	mov    %edi,%ecx
  802383:	d3 e3                	shl    %cl,%ebx
  802385:	89 c1                	mov    %eax,%ecx
  802387:	d3 ea                	shr    %cl,%edx
  802389:	89 f9                	mov    %edi,%ecx
  80238b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80238f:	89 eb                	mov    %ebp,%ebx
  802391:	d3 e6                	shl    %cl,%esi
  802393:	89 c1                	mov    %eax,%ecx
  802395:	d3 eb                	shr    %cl,%ebx
  802397:	09 de                	or     %ebx,%esi
  802399:	89 f0                	mov    %esi,%eax
  80239b:	f7 74 24 08          	divl   0x8(%esp)
  80239f:	89 d6                	mov    %edx,%esi
  8023a1:	89 c3                	mov    %eax,%ebx
  8023a3:	f7 64 24 0c          	mull   0xc(%esp)
  8023a7:	39 d6                	cmp    %edx,%esi
  8023a9:	72 15                	jb     8023c0 <__udivdi3+0x100>
  8023ab:	89 f9                	mov    %edi,%ecx
  8023ad:	d3 e5                	shl    %cl,%ebp
  8023af:	39 c5                	cmp    %eax,%ebp
  8023b1:	73 04                	jae    8023b7 <__udivdi3+0xf7>
  8023b3:	39 d6                	cmp    %edx,%esi
  8023b5:	74 09                	je     8023c0 <__udivdi3+0x100>
  8023b7:	89 d8                	mov    %ebx,%eax
  8023b9:	31 ff                	xor    %edi,%edi
  8023bb:	e9 27 ff ff ff       	jmp    8022e7 <__udivdi3+0x27>
  8023c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023c3:	31 ff                	xor    %edi,%edi
  8023c5:	e9 1d ff ff ff       	jmp    8022e7 <__udivdi3+0x27>
  8023ca:	66 90                	xchg   %ax,%ax
  8023cc:	66 90                	xchg   %ax,%ax
  8023ce:	66 90                	xchg   %ax,%ax

008023d0 <__umoddi3>:
  8023d0:	55                   	push   %ebp
  8023d1:	57                   	push   %edi
  8023d2:	56                   	push   %esi
  8023d3:	53                   	push   %ebx
  8023d4:	83 ec 1c             	sub    $0x1c,%esp
  8023d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023e7:	89 da                	mov    %ebx,%edx
  8023e9:	85 c0                	test   %eax,%eax
  8023eb:	75 43                	jne    802430 <__umoddi3+0x60>
  8023ed:	39 df                	cmp    %ebx,%edi
  8023ef:	76 17                	jbe    802408 <__umoddi3+0x38>
  8023f1:	89 f0                	mov    %esi,%eax
  8023f3:	f7 f7                	div    %edi
  8023f5:	89 d0                	mov    %edx,%eax
  8023f7:	31 d2                	xor    %edx,%edx
  8023f9:	83 c4 1c             	add    $0x1c,%esp
  8023fc:	5b                   	pop    %ebx
  8023fd:	5e                   	pop    %esi
  8023fe:	5f                   	pop    %edi
  8023ff:	5d                   	pop    %ebp
  802400:	c3                   	ret    
  802401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802408:	89 fd                	mov    %edi,%ebp
  80240a:	85 ff                	test   %edi,%edi
  80240c:	75 0b                	jne    802419 <__umoddi3+0x49>
  80240e:	b8 01 00 00 00       	mov    $0x1,%eax
  802413:	31 d2                	xor    %edx,%edx
  802415:	f7 f7                	div    %edi
  802417:	89 c5                	mov    %eax,%ebp
  802419:	89 d8                	mov    %ebx,%eax
  80241b:	31 d2                	xor    %edx,%edx
  80241d:	f7 f5                	div    %ebp
  80241f:	89 f0                	mov    %esi,%eax
  802421:	f7 f5                	div    %ebp
  802423:	89 d0                	mov    %edx,%eax
  802425:	eb d0                	jmp    8023f7 <__umoddi3+0x27>
  802427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80242e:	66 90                	xchg   %ax,%ax
  802430:	89 f1                	mov    %esi,%ecx
  802432:	39 d8                	cmp    %ebx,%eax
  802434:	76 0a                	jbe    802440 <__umoddi3+0x70>
  802436:	89 f0                	mov    %esi,%eax
  802438:	83 c4 1c             	add    $0x1c,%esp
  80243b:	5b                   	pop    %ebx
  80243c:	5e                   	pop    %esi
  80243d:	5f                   	pop    %edi
  80243e:	5d                   	pop    %ebp
  80243f:	c3                   	ret    
  802440:	0f bd e8             	bsr    %eax,%ebp
  802443:	83 f5 1f             	xor    $0x1f,%ebp
  802446:	75 20                	jne    802468 <__umoddi3+0x98>
  802448:	39 d8                	cmp    %ebx,%eax
  80244a:	0f 82 b0 00 00 00    	jb     802500 <__umoddi3+0x130>
  802450:	39 f7                	cmp    %esi,%edi
  802452:	0f 86 a8 00 00 00    	jbe    802500 <__umoddi3+0x130>
  802458:	89 c8                	mov    %ecx,%eax
  80245a:	83 c4 1c             	add    $0x1c,%esp
  80245d:	5b                   	pop    %ebx
  80245e:	5e                   	pop    %esi
  80245f:	5f                   	pop    %edi
  802460:	5d                   	pop    %ebp
  802461:	c3                   	ret    
  802462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802468:	89 e9                	mov    %ebp,%ecx
  80246a:	ba 20 00 00 00       	mov    $0x20,%edx
  80246f:	29 ea                	sub    %ebp,%edx
  802471:	d3 e0                	shl    %cl,%eax
  802473:	89 44 24 08          	mov    %eax,0x8(%esp)
  802477:	89 d1                	mov    %edx,%ecx
  802479:	89 f8                	mov    %edi,%eax
  80247b:	d3 e8                	shr    %cl,%eax
  80247d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802481:	89 54 24 04          	mov    %edx,0x4(%esp)
  802485:	8b 54 24 04          	mov    0x4(%esp),%edx
  802489:	09 c1                	or     %eax,%ecx
  80248b:	89 d8                	mov    %ebx,%eax
  80248d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802491:	89 e9                	mov    %ebp,%ecx
  802493:	d3 e7                	shl    %cl,%edi
  802495:	89 d1                	mov    %edx,%ecx
  802497:	d3 e8                	shr    %cl,%eax
  802499:	89 e9                	mov    %ebp,%ecx
  80249b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80249f:	d3 e3                	shl    %cl,%ebx
  8024a1:	89 c7                	mov    %eax,%edi
  8024a3:	89 d1                	mov    %edx,%ecx
  8024a5:	89 f0                	mov    %esi,%eax
  8024a7:	d3 e8                	shr    %cl,%eax
  8024a9:	89 e9                	mov    %ebp,%ecx
  8024ab:	89 fa                	mov    %edi,%edx
  8024ad:	d3 e6                	shl    %cl,%esi
  8024af:	09 d8                	or     %ebx,%eax
  8024b1:	f7 74 24 08          	divl   0x8(%esp)
  8024b5:	89 d1                	mov    %edx,%ecx
  8024b7:	89 f3                	mov    %esi,%ebx
  8024b9:	f7 64 24 0c          	mull   0xc(%esp)
  8024bd:	89 c6                	mov    %eax,%esi
  8024bf:	89 d7                	mov    %edx,%edi
  8024c1:	39 d1                	cmp    %edx,%ecx
  8024c3:	72 06                	jb     8024cb <__umoddi3+0xfb>
  8024c5:	75 10                	jne    8024d7 <__umoddi3+0x107>
  8024c7:	39 c3                	cmp    %eax,%ebx
  8024c9:	73 0c                	jae    8024d7 <__umoddi3+0x107>
  8024cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024d3:	89 d7                	mov    %edx,%edi
  8024d5:	89 c6                	mov    %eax,%esi
  8024d7:	89 ca                	mov    %ecx,%edx
  8024d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024de:	29 f3                	sub    %esi,%ebx
  8024e0:	19 fa                	sbb    %edi,%edx
  8024e2:	89 d0                	mov    %edx,%eax
  8024e4:	d3 e0                	shl    %cl,%eax
  8024e6:	89 e9                	mov    %ebp,%ecx
  8024e8:	d3 eb                	shr    %cl,%ebx
  8024ea:	d3 ea                	shr    %cl,%edx
  8024ec:	09 d8                	or     %ebx,%eax
  8024ee:	83 c4 1c             	add    $0x1c,%esp
  8024f1:	5b                   	pop    %ebx
  8024f2:	5e                   	pop    %esi
  8024f3:	5f                   	pop    %edi
  8024f4:	5d                   	pop    %ebp
  8024f5:	c3                   	ret    
  8024f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024fd:	8d 76 00             	lea    0x0(%esi),%esi
  802500:	89 da                	mov    %ebx,%edx
  802502:	29 fe                	sub    %edi,%esi
  802504:	19 c2                	sbb    %eax,%edx
  802506:	89 f1                	mov    %esi,%ecx
  802508:	89 c8                	mov    %ecx,%eax
  80250a:	e9 4b ff ff ff       	jmp    80245a <__umoddi3+0x8a>
