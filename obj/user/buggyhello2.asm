
obj/user/buggyhello2.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs(hello, 1024*1024);
  800039:	68 00 00 10 00       	push   $0x100000
  80003e:	ff 35 00 30 80 00    	pushl  0x803000
  800044:	e8 ac 0b 00 00       	call   800bf5 <sys_cputs>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800059:	e8 15 0c 00 00       	call   800c73 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800069:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006e:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800073:	85 db                	test   %ebx,%ebx
  800075:	7e 07                	jle    80007e <libmain+0x30>
		binaryname = argv[0];
  800077:	8b 06                	mov    (%esi),%eax
  800079:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  80007e:	83 ec 08             	sub    $0x8,%esp
  800081:	56                   	push   %esi
  800082:	53                   	push   %ebx
  800083:	e8 ab ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800088:	e8 0a 00 00 00       	call   800097 <exit>
}
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800093:	5b                   	pop    %ebx
  800094:	5e                   	pop    %esi
  800095:	5d                   	pop    %ebp
  800096:	c3                   	ret    

00800097 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800097:	55                   	push   %ebp
  800098:	89 e5                	mov    %esp,%ebp
  80009a:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80009d:	a1 08 40 80 00       	mov    0x804008,%eax
  8000a2:	8b 40 48             	mov    0x48(%eax),%eax
  8000a5:	68 24 25 80 00       	push   $0x802524
  8000aa:	50                   	push   %eax
  8000ab:	68 18 25 80 00       	push   $0x802518
  8000b0:	e8 ab 00 00 00       	call   800160 <cprintf>
	close_all();
  8000b5:	e8 c4 10 00 00       	call   80117e <close_all>
	sys_env_destroy(0);
  8000ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000c1:	e8 6c 0b 00 00       	call   800c32 <sys_env_destroy>
}
  8000c6:	83 c4 10             	add    $0x10,%esp
  8000c9:	c9                   	leave  
  8000ca:	c3                   	ret    

008000cb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000cb:	55                   	push   %ebp
  8000cc:	89 e5                	mov    %esp,%ebp
  8000ce:	53                   	push   %ebx
  8000cf:	83 ec 04             	sub    $0x4,%esp
  8000d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d5:	8b 13                	mov    (%ebx),%edx
  8000d7:	8d 42 01             	lea    0x1(%edx),%eax
  8000da:	89 03                	mov    %eax,(%ebx)
  8000dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000df:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000e3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000e8:	74 09                	je     8000f3 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000ea:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f1:	c9                   	leave  
  8000f2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000f3:	83 ec 08             	sub    $0x8,%esp
  8000f6:	68 ff 00 00 00       	push   $0xff
  8000fb:	8d 43 08             	lea    0x8(%ebx),%eax
  8000fe:	50                   	push   %eax
  8000ff:	e8 f1 0a 00 00       	call   800bf5 <sys_cputs>
		b->idx = 0;
  800104:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	eb db                	jmp    8000ea <putch+0x1f>

0080010f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80010f:	55                   	push   %ebp
  800110:	89 e5                	mov    %esp,%ebp
  800112:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800118:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80011f:	00 00 00 
	b.cnt = 0;
  800122:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800129:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80012c:	ff 75 0c             	pushl  0xc(%ebp)
  80012f:	ff 75 08             	pushl  0x8(%ebp)
  800132:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800138:	50                   	push   %eax
  800139:	68 cb 00 80 00       	push   $0x8000cb
  80013e:	e8 4a 01 00 00       	call   80028d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800143:	83 c4 08             	add    $0x8,%esp
  800146:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80014c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800152:	50                   	push   %eax
  800153:	e8 9d 0a 00 00       	call   800bf5 <sys_cputs>

	return b.cnt;
}
  800158:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80015e:	c9                   	leave  
  80015f:	c3                   	ret    

00800160 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800166:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800169:	50                   	push   %eax
  80016a:	ff 75 08             	pushl  0x8(%ebp)
  80016d:	e8 9d ff ff ff       	call   80010f <vcprintf>
	va_end(ap);

	return cnt;
}
  800172:	c9                   	leave  
  800173:	c3                   	ret    

00800174 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	57                   	push   %edi
  800178:	56                   	push   %esi
  800179:	53                   	push   %ebx
  80017a:	83 ec 1c             	sub    $0x1c,%esp
  80017d:	89 c6                	mov    %eax,%esi
  80017f:	89 d7                	mov    %edx,%edi
  800181:	8b 45 08             	mov    0x8(%ebp),%eax
  800184:	8b 55 0c             	mov    0xc(%ebp),%edx
  800187:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80018a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80018d:	8b 45 10             	mov    0x10(%ebp),%eax
  800190:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800193:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800197:	74 2c                	je     8001c5 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800199:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80019c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001a6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001a9:	39 c2                	cmp    %eax,%edx
  8001ab:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001ae:	73 43                	jae    8001f3 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001b0:	83 eb 01             	sub    $0x1,%ebx
  8001b3:	85 db                	test   %ebx,%ebx
  8001b5:	7e 6c                	jle    800223 <printnum+0xaf>
				putch(padc, putdat);
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	57                   	push   %edi
  8001bb:	ff 75 18             	pushl  0x18(%ebp)
  8001be:	ff d6                	call   *%esi
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	eb eb                	jmp    8001b0 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	6a 20                	push   $0x20
  8001ca:	6a 00                	push   $0x0
  8001cc:	50                   	push   %eax
  8001cd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d0:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d3:	89 fa                	mov    %edi,%edx
  8001d5:	89 f0                	mov    %esi,%eax
  8001d7:	e8 98 ff ff ff       	call   800174 <printnum>
		while (--width > 0)
  8001dc:	83 c4 20             	add    $0x20,%esp
  8001df:	83 eb 01             	sub    $0x1,%ebx
  8001e2:	85 db                	test   %ebx,%ebx
  8001e4:	7e 65                	jle    80024b <printnum+0xd7>
			putch(padc, putdat);
  8001e6:	83 ec 08             	sub    $0x8,%esp
  8001e9:	57                   	push   %edi
  8001ea:	6a 20                	push   $0x20
  8001ec:	ff d6                	call   *%esi
  8001ee:	83 c4 10             	add    $0x10,%esp
  8001f1:	eb ec                	jmp    8001df <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	ff 75 18             	pushl  0x18(%ebp)
  8001f9:	83 eb 01             	sub    $0x1,%ebx
  8001fc:	53                   	push   %ebx
  8001fd:	50                   	push   %eax
  8001fe:	83 ec 08             	sub    $0x8,%esp
  800201:	ff 75 dc             	pushl  -0x24(%ebp)
  800204:	ff 75 d8             	pushl  -0x28(%ebp)
  800207:	ff 75 e4             	pushl  -0x1c(%ebp)
  80020a:	ff 75 e0             	pushl  -0x20(%ebp)
  80020d:	e8 8e 20 00 00       	call   8022a0 <__udivdi3>
  800212:	83 c4 18             	add    $0x18,%esp
  800215:	52                   	push   %edx
  800216:	50                   	push   %eax
  800217:	89 fa                	mov    %edi,%edx
  800219:	89 f0                	mov    %esi,%eax
  80021b:	e8 54 ff ff ff       	call   800174 <printnum>
  800220:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800223:	83 ec 08             	sub    $0x8,%esp
  800226:	57                   	push   %edi
  800227:	83 ec 04             	sub    $0x4,%esp
  80022a:	ff 75 dc             	pushl  -0x24(%ebp)
  80022d:	ff 75 d8             	pushl  -0x28(%ebp)
  800230:	ff 75 e4             	pushl  -0x1c(%ebp)
  800233:	ff 75 e0             	pushl  -0x20(%ebp)
  800236:	e8 75 21 00 00       	call   8023b0 <__umoddi3>
  80023b:	83 c4 14             	add    $0x14,%esp
  80023e:	0f be 80 29 25 80 00 	movsbl 0x802529(%eax),%eax
  800245:	50                   	push   %eax
  800246:	ff d6                	call   *%esi
  800248:	83 c4 10             	add    $0x10,%esp
	}
}
  80024b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024e:	5b                   	pop    %ebx
  80024f:	5e                   	pop    %esi
  800250:	5f                   	pop    %edi
  800251:	5d                   	pop    %ebp
  800252:	c3                   	ret    

00800253 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800259:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80025d:	8b 10                	mov    (%eax),%edx
  80025f:	3b 50 04             	cmp    0x4(%eax),%edx
  800262:	73 0a                	jae    80026e <sprintputch+0x1b>
		*b->buf++ = ch;
  800264:	8d 4a 01             	lea    0x1(%edx),%ecx
  800267:	89 08                	mov    %ecx,(%eax)
  800269:	8b 45 08             	mov    0x8(%ebp),%eax
  80026c:	88 02                	mov    %al,(%edx)
}
  80026e:	5d                   	pop    %ebp
  80026f:	c3                   	ret    

00800270 <printfmt>:
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800276:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800279:	50                   	push   %eax
  80027a:	ff 75 10             	pushl  0x10(%ebp)
  80027d:	ff 75 0c             	pushl  0xc(%ebp)
  800280:	ff 75 08             	pushl  0x8(%ebp)
  800283:	e8 05 00 00 00       	call   80028d <vprintfmt>
}
  800288:	83 c4 10             	add    $0x10,%esp
  80028b:	c9                   	leave  
  80028c:	c3                   	ret    

0080028d <vprintfmt>:
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	57                   	push   %edi
  800291:	56                   	push   %esi
  800292:	53                   	push   %ebx
  800293:	83 ec 3c             	sub    $0x3c,%esp
  800296:	8b 75 08             	mov    0x8(%ebp),%esi
  800299:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80029c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80029f:	e9 32 04 00 00       	jmp    8006d6 <vprintfmt+0x449>
		padc = ' ';
  8002a4:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002a8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002af:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002b6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002c4:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8002cb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002d0:	8d 47 01             	lea    0x1(%edi),%eax
  8002d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002d6:	0f b6 17             	movzbl (%edi),%edx
  8002d9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002dc:	3c 55                	cmp    $0x55,%al
  8002de:	0f 87 12 05 00 00    	ja     8007f6 <vprintfmt+0x569>
  8002e4:	0f b6 c0             	movzbl %al,%eax
  8002e7:	ff 24 85 00 27 80 00 	jmp    *0x802700(,%eax,4)
  8002ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002f1:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8002f5:	eb d9                	jmp    8002d0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8002f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002fa:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8002fe:	eb d0                	jmp    8002d0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800300:	0f b6 d2             	movzbl %dl,%edx
  800303:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800306:	b8 00 00 00 00       	mov    $0x0,%eax
  80030b:	89 75 08             	mov    %esi,0x8(%ebp)
  80030e:	eb 03                	jmp    800313 <vprintfmt+0x86>
  800310:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800313:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800316:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80031a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80031d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800320:	83 fe 09             	cmp    $0x9,%esi
  800323:	76 eb                	jbe    800310 <vprintfmt+0x83>
  800325:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800328:	8b 75 08             	mov    0x8(%ebp),%esi
  80032b:	eb 14                	jmp    800341 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80032d:	8b 45 14             	mov    0x14(%ebp),%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800335:	8b 45 14             	mov    0x14(%ebp),%eax
  800338:	8d 40 04             	lea    0x4(%eax),%eax
  80033b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80033e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800341:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800345:	79 89                	jns    8002d0 <vprintfmt+0x43>
				width = precision, precision = -1;
  800347:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80034a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80034d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800354:	e9 77 ff ff ff       	jmp    8002d0 <vprintfmt+0x43>
  800359:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80035c:	85 c0                	test   %eax,%eax
  80035e:	0f 48 c1             	cmovs  %ecx,%eax
  800361:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800364:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800367:	e9 64 ff ff ff       	jmp    8002d0 <vprintfmt+0x43>
  80036c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80036f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800376:	e9 55 ff ff ff       	jmp    8002d0 <vprintfmt+0x43>
			lflag++;
  80037b:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80037f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800382:	e9 49 ff ff ff       	jmp    8002d0 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800387:	8b 45 14             	mov    0x14(%ebp),%eax
  80038a:	8d 78 04             	lea    0x4(%eax),%edi
  80038d:	83 ec 08             	sub    $0x8,%esp
  800390:	53                   	push   %ebx
  800391:	ff 30                	pushl  (%eax)
  800393:	ff d6                	call   *%esi
			break;
  800395:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800398:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80039b:	e9 33 03 00 00       	jmp    8006d3 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a3:	8d 78 04             	lea    0x4(%eax),%edi
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	99                   	cltd   
  8003a9:	31 d0                	xor    %edx,%eax
  8003ab:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003ad:	83 f8 11             	cmp    $0x11,%eax
  8003b0:	7f 23                	jg     8003d5 <vprintfmt+0x148>
  8003b2:	8b 14 85 60 28 80 00 	mov    0x802860(,%eax,4),%edx
  8003b9:	85 d2                	test   %edx,%edx
  8003bb:	74 18                	je     8003d5 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003bd:	52                   	push   %edx
  8003be:	68 7d 29 80 00       	push   $0x80297d
  8003c3:	53                   	push   %ebx
  8003c4:	56                   	push   %esi
  8003c5:	e8 a6 fe ff ff       	call   800270 <printfmt>
  8003ca:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003cd:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003d0:	e9 fe 02 00 00       	jmp    8006d3 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8003d5:	50                   	push   %eax
  8003d6:	68 41 25 80 00       	push   $0x802541
  8003db:	53                   	push   %ebx
  8003dc:	56                   	push   %esi
  8003dd:	e8 8e fe ff ff       	call   800270 <printfmt>
  8003e2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003e8:	e9 e6 02 00 00       	jmp    8006d3 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8003ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f0:	83 c0 04             	add    $0x4,%eax
  8003f3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8003f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f9:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8003fb:	85 c9                	test   %ecx,%ecx
  8003fd:	b8 3a 25 80 00       	mov    $0x80253a,%eax
  800402:	0f 45 c1             	cmovne %ecx,%eax
  800405:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800408:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80040c:	7e 06                	jle    800414 <vprintfmt+0x187>
  80040e:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800412:	75 0d                	jne    800421 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800414:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800417:	89 c7                	mov    %eax,%edi
  800419:	03 45 e0             	add    -0x20(%ebp),%eax
  80041c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80041f:	eb 53                	jmp    800474 <vprintfmt+0x1e7>
  800421:	83 ec 08             	sub    $0x8,%esp
  800424:	ff 75 d8             	pushl  -0x28(%ebp)
  800427:	50                   	push   %eax
  800428:	e8 71 04 00 00       	call   80089e <strnlen>
  80042d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800430:	29 c1                	sub    %eax,%ecx
  800432:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80043a:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80043e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800441:	eb 0f                	jmp    800452 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800443:	83 ec 08             	sub    $0x8,%esp
  800446:	53                   	push   %ebx
  800447:	ff 75 e0             	pushl  -0x20(%ebp)
  80044a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80044c:	83 ef 01             	sub    $0x1,%edi
  80044f:	83 c4 10             	add    $0x10,%esp
  800452:	85 ff                	test   %edi,%edi
  800454:	7f ed                	jg     800443 <vprintfmt+0x1b6>
  800456:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800459:	85 c9                	test   %ecx,%ecx
  80045b:	b8 00 00 00 00       	mov    $0x0,%eax
  800460:	0f 49 c1             	cmovns %ecx,%eax
  800463:	29 c1                	sub    %eax,%ecx
  800465:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800468:	eb aa                	jmp    800414 <vprintfmt+0x187>
					putch(ch, putdat);
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	53                   	push   %ebx
  80046e:	52                   	push   %edx
  80046f:	ff d6                	call   *%esi
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800477:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800479:	83 c7 01             	add    $0x1,%edi
  80047c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800480:	0f be d0             	movsbl %al,%edx
  800483:	85 d2                	test   %edx,%edx
  800485:	74 4b                	je     8004d2 <vprintfmt+0x245>
  800487:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80048b:	78 06                	js     800493 <vprintfmt+0x206>
  80048d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800491:	78 1e                	js     8004b1 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800493:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800497:	74 d1                	je     80046a <vprintfmt+0x1dd>
  800499:	0f be c0             	movsbl %al,%eax
  80049c:	83 e8 20             	sub    $0x20,%eax
  80049f:	83 f8 5e             	cmp    $0x5e,%eax
  8004a2:	76 c6                	jbe    80046a <vprintfmt+0x1dd>
					putch('?', putdat);
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	53                   	push   %ebx
  8004a8:	6a 3f                	push   $0x3f
  8004aa:	ff d6                	call   *%esi
  8004ac:	83 c4 10             	add    $0x10,%esp
  8004af:	eb c3                	jmp    800474 <vprintfmt+0x1e7>
  8004b1:	89 cf                	mov    %ecx,%edi
  8004b3:	eb 0e                	jmp    8004c3 <vprintfmt+0x236>
				putch(' ', putdat);
  8004b5:	83 ec 08             	sub    $0x8,%esp
  8004b8:	53                   	push   %ebx
  8004b9:	6a 20                	push   $0x20
  8004bb:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004bd:	83 ef 01             	sub    $0x1,%edi
  8004c0:	83 c4 10             	add    $0x10,%esp
  8004c3:	85 ff                	test   %edi,%edi
  8004c5:	7f ee                	jg     8004b5 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8004cd:	e9 01 02 00 00       	jmp    8006d3 <vprintfmt+0x446>
  8004d2:	89 cf                	mov    %ecx,%edi
  8004d4:	eb ed                	jmp    8004c3 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8004d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8004d9:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8004e0:	e9 eb fd ff ff       	jmp    8002d0 <vprintfmt+0x43>
	if (lflag >= 2)
  8004e5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8004e9:	7f 21                	jg     80050c <vprintfmt+0x27f>
	else if (lflag)
  8004eb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8004ef:	74 68                	je     800559 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004f9:	89 c1                	mov    %eax,%ecx
  8004fb:	c1 f9 1f             	sar    $0x1f,%ecx
  8004fe:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8d 40 04             	lea    0x4(%eax),%eax
  800507:	89 45 14             	mov    %eax,0x14(%ebp)
  80050a:	eb 17                	jmp    800523 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80050c:	8b 45 14             	mov    0x14(%ebp),%eax
  80050f:	8b 50 04             	mov    0x4(%eax),%edx
  800512:	8b 00                	mov    (%eax),%eax
  800514:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800517:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80051a:	8b 45 14             	mov    0x14(%ebp),%eax
  80051d:	8d 40 08             	lea    0x8(%eax),%eax
  800520:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800523:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800526:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800529:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80052f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800533:	78 3f                	js     800574 <vprintfmt+0x2e7>
			base = 10;
  800535:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80053a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80053e:	0f 84 71 01 00 00    	je     8006b5 <vprintfmt+0x428>
				putch('+', putdat);
  800544:	83 ec 08             	sub    $0x8,%esp
  800547:	53                   	push   %ebx
  800548:	6a 2b                	push   $0x2b
  80054a:	ff d6                	call   *%esi
  80054c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80054f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800554:	e9 5c 01 00 00       	jmp    8006b5 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8b 00                	mov    (%eax),%eax
  80055e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800561:	89 c1                	mov    %eax,%ecx
  800563:	c1 f9 1f             	sar    $0x1f,%ecx
  800566:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	8d 40 04             	lea    0x4(%eax),%eax
  80056f:	89 45 14             	mov    %eax,0x14(%ebp)
  800572:	eb af                	jmp    800523 <vprintfmt+0x296>
				putch('-', putdat);
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	53                   	push   %ebx
  800578:	6a 2d                	push   $0x2d
  80057a:	ff d6                	call   *%esi
				num = -(long long) num;
  80057c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80057f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800582:	f7 d8                	neg    %eax
  800584:	83 d2 00             	adc    $0x0,%edx
  800587:	f7 da                	neg    %edx
  800589:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800592:	b8 0a 00 00 00       	mov    $0xa,%eax
  800597:	e9 19 01 00 00       	jmp    8006b5 <vprintfmt+0x428>
	if (lflag >= 2)
  80059c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005a0:	7f 29                	jg     8005cb <vprintfmt+0x33e>
	else if (lflag)
  8005a2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005a6:	74 44                	je     8005ec <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8b 00                	mov    (%eax),%eax
  8005ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8d 40 04             	lea    0x4(%eax),%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c6:	e9 ea 00 00 00       	jmp    8006b5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	8b 50 04             	mov    0x4(%eax),%edx
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8d 40 08             	lea    0x8(%eax),%eax
  8005df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e7:	e9 c9 00 00 00       	jmp    8006b5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8d 40 04             	lea    0x4(%eax),%eax
  800602:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800605:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060a:	e9 a6 00 00 00       	jmp    8006b5 <vprintfmt+0x428>
			putch('0', putdat);
  80060f:	83 ec 08             	sub    $0x8,%esp
  800612:	53                   	push   %ebx
  800613:	6a 30                	push   $0x30
  800615:	ff d6                	call   *%esi
	if (lflag >= 2)
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80061e:	7f 26                	jg     800646 <vprintfmt+0x3b9>
	else if (lflag)
  800620:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800624:	74 3e                	je     800664 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	ba 00 00 00 00       	mov    $0x0,%edx
  800630:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800633:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8d 40 04             	lea    0x4(%eax),%eax
  80063c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80063f:	b8 08 00 00 00       	mov    $0x8,%eax
  800644:	eb 6f                	jmp    8006b5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8b 50 04             	mov    0x4(%eax),%edx
  80064c:	8b 00                	mov    (%eax),%eax
  80064e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800651:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8d 40 08             	lea    0x8(%eax),%eax
  80065a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80065d:	b8 08 00 00 00       	mov    $0x8,%eax
  800662:	eb 51                	jmp    8006b5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8b 00                	mov    (%eax),%eax
  800669:	ba 00 00 00 00       	mov    $0x0,%edx
  80066e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800671:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8d 40 04             	lea    0x4(%eax),%eax
  80067a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067d:	b8 08 00 00 00       	mov    $0x8,%eax
  800682:	eb 31                	jmp    8006b5 <vprintfmt+0x428>
			putch('0', putdat);
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	53                   	push   %ebx
  800688:	6a 30                	push   $0x30
  80068a:	ff d6                	call   *%esi
			putch('x', putdat);
  80068c:	83 c4 08             	add    $0x8,%esp
  80068f:	53                   	push   %ebx
  800690:	6a 78                	push   $0x78
  800692:	ff d6                	call   *%esi
			num = (unsigned long long)
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	ba 00 00 00 00       	mov    $0x0,%edx
  80069e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006a4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8d 40 04             	lea    0x4(%eax),%eax
  8006ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006b5:	83 ec 0c             	sub    $0xc,%esp
  8006b8:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006bc:	52                   	push   %edx
  8006bd:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c0:	50                   	push   %eax
  8006c1:	ff 75 dc             	pushl  -0x24(%ebp)
  8006c4:	ff 75 d8             	pushl  -0x28(%ebp)
  8006c7:	89 da                	mov    %ebx,%edx
  8006c9:	89 f0                	mov    %esi,%eax
  8006cb:	e8 a4 fa ff ff       	call   800174 <printnum>
			break;
  8006d0:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006d6:	83 c7 01             	add    $0x1,%edi
  8006d9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006dd:	83 f8 25             	cmp    $0x25,%eax
  8006e0:	0f 84 be fb ff ff    	je     8002a4 <vprintfmt+0x17>
			if (ch == '\0')
  8006e6:	85 c0                	test   %eax,%eax
  8006e8:	0f 84 28 01 00 00    	je     800816 <vprintfmt+0x589>
			putch(ch, putdat);
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	53                   	push   %ebx
  8006f2:	50                   	push   %eax
  8006f3:	ff d6                	call   *%esi
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	eb dc                	jmp    8006d6 <vprintfmt+0x449>
	if (lflag >= 2)
  8006fa:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006fe:	7f 26                	jg     800726 <vprintfmt+0x499>
	else if (lflag)
  800700:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800704:	74 41                	je     800747 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	ba 00 00 00 00       	mov    $0x0,%edx
  800710:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800713:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8d 40 04             	lea    0x4(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071f:	b8 10 00 00 00       	mov    $0x10,%eax
  800724:	eb 8f                	jmp    8006b5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 50 04             	mov    0x4(%eax),%edx
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800731:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8d 40 08             	lea    0x8(%eax),%eax
  80073a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073d:	b8 10 00 00 00       	mov    $0x10,%eax
  800742:	e9 6e ff ff ff       	jmp    8006b5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	ba 00 00 00 00       	mov    $0x0,%edx
  800751:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800754:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	8d 40 04             	lea    0x4(%eax),%eax
  80075d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800760:	b8 10 00 00 00       	mov    $0x10,%eax
  800765:	e9 4b ff ff ff       	jmp    8006b5 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	83 c0 04             	add    $0x4,%eax
  800770:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	85 c0                	test   %eax,%eax
  80077a:	74 14                	je     800790 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80077c:	8b 13                	mov    (%ebx),%edx
  80077e:	83 fa 7f             	cmp    $0x7f,%edx
  800781:	7f 37                	jg     8007ba <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800783:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800785:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800788:	89 45 14             	mov    %eax,0x14(%ebp)
  80078b:	e9 43 ff ff ff       	jmp    8006d3 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800790:	b8 0a 00 00 00       	mov    $0xa,%eax
  800795:	bf 5d 26 80 00       	mov    $0x80265d,%edi
							putch(ch, putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	53                   	push   %ebx
  80079e:	50                   	push   %eax
  80079f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007a1:	83 c7 01             	add    $0x1,%edi
  8007a4:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	85 c0                	test   %eax,%eax
  8007ad:	75 eb                	jne    80079a <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b5:	e9 19 ff ff ff       	jmp    8006d3 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007ba:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007bc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c1:	bf 95 26 80 00       	mov    $0x802695,%edi
							putch(ch, putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	53                   	push   %ebx
  8007ca:	50                   	push   %eax
  8007cb:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007cd:	83 c7 01             	add    $0x1,%edi
  8007d0:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007d4:	83 c4 10             	add    $0x10,%esp
  8007d7:	85 c0                	test   %eax,%eax
  8007d9:	75 eb                	jne    8007c6 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8007db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007de:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e1:	e9 ed fe ff ff       	jmp    8006d3 <vprintfmt+0x446>
			putch(ch, putdat);
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	53                   	push   %ebx
  8007ea:	6a 25                	push   $0x25
  8007ec:	ff d6                	call   *%esi
			break;
  8007ee:	83 c4 10             	add    $0x10,%esp
  8007f1:	e9 dd fe ff ff       	jmp    8006d3 <vprintfmt+0x446>
			putch('%', putdat);
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	53                   	push   %ebx
  8007fa:	6a 25                	push   $0x25
  8007fc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007fe:	83 c4 10             	add    $0x10,%esp
  800801:	89 f8                	mov    %edi,%eax
  800803:	eb 03                	jmp    800808 <vprintfmt+0x57b>
  800805:	83 e8 01             	sub    $0x1,%eax
  800808:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80080c:	75 f7                	jne    800805 <vprintfmt+0x578>
  80080e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800811:	e9 bd fe ff ff       	jmp    8006d3 <vprintfmt+0x446>
}
  800816:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800819:	5b                   	pop    %ebx
  80081a:	5e                   	pop    %esi
  80081b:	5f                   	pop    %edi
  80081c:	5d                   	pop    %ebp
  80081d:	c3                   	ret    

0080081e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	83 ec 18             	sub    $0x18,%esp
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80082a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80082d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800831:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800834:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80083b:	85 c0                	test   %eax,%eax
  80083d:	74 26                	je     800865 <vsnprintf+0x47>
  80083f:	85 d2                	test   %edx,%edx
  800841:	7e 22                	jle    800865 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800843:	ff 75 14             	pushl  0x14(%ebp)
  800846:	ff 75 10             	pushl  0x10(%ebp)
  800849:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80084c:	50                   	push   %eax
  80084d:	68 53 02 80 00       	push   $0x800253
  800852:	e8 36 fa ff ff       	call   80028d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800857:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80085a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80085d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800860:	83 c4 10             	add    $0x10,%esp
}
  800863:	c9                   	leave  
  800864:	c3                   	ret    
		return -E_INVAL;
  800865:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80086a:	eb f7                	jmp    800863 <vsnprintf+0x45>

0080086c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800872:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800875:	50                   	push   %eax
  800876:	ff 75 10             	pushl  0x10(%ebp)
  800879:	ff 75 0c             	pushl  0xc(%ebp)
  80087c:	ff 75 08             	pushl  0x8(%ebp)
  80087f:	e8 9a ff ff ff       	call   80081e <vsnprintf>
	va_end(ap);

	return rc;
}
  800884:	c9                   	leave  
  800885:	c3                   	ret    

00800886 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80088c:	b8 00 00 00 00       	mov    $0x0,%eax
  800891:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800895:	74 05                	je     80089c <strlen+0x16>
		n++;
  800897:	83 c0 01             	add    $0x1,%eax
  80089a:	eb f5                	jmp    800891 <strlen+0xb>
	return n;
}
  80089c:	5d                   	pop    %ebp
  80089d:	c3                   	ret    

0080089e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a4:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ac:	39 c2                	cmp    %eax,%edx
  8008ae:	74 0d                	je     8008bd <strnlen+0x1f>
  8008b0:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008b4:	74 05                	je     8008bb <strnlen+0x1d>
		n++;
  8008b6:	83 c2 01             	add    $0x1,%edx
  8008b9:	eb f1                	jmp    8008ac <strnlen+0xe>
  8008bb:	89 d0                	mov    %edx,%eax
	return n;
}
  8008bd:	5d                   	pop    %ebp
  8008be:	c3                   	ret    

008008bf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
  8008c2:	53                   	push   %ebx
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ce:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008d2:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008d5:	83 c2 01             	add    $0x1,%edx
  8008d8:	84 c9                	test   %cl,%cl
  8008da:	75 f2                	jne    8008ce <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008dc:	5b                   	pop    %ebx
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	53                   	push   %ebx
  8008e3:	83 ec 10             	sub    $0x10,%esp
  8008e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008e9:	53                   	push   %ebx
  8008ea:	e8 97 ff ff ff       	call   800886 <strlen>
  8008ef:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	01 d8                	add    %ebx,%eax
  8008f7:	50                   	push   %eax
  8008f8:	e8 c2 ff ff ff       	call   8008bf <strcpy>
	return dst;
}
  8008fd:	89 d8                	mov    %ebx,%eax
  8008ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800902:	c9                   	leave  
  800903:	c3                   	ret    

00800904 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	56                   	push   %esi
  800908:	53                   	push   %ebx
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80090f:	89 c6                	mov    %eax,%esi
  800911:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800914:	89 c2                	mov    %eax,%edx
  800916:	39 f2                	cmp    %esi,%edx
  800918:	74 11                	je     80092b <strncpy+0x27>
		*dst++ = *src;
  80091a:	83 c2 01             	add    $0x1,%edx
  80091d:	0f b6 19             	movzbl (%ecx),%ebx
  800920:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800923:	80 fb 01             	cmp    $0x1,%bl
  800926:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800929:	eb eb                	jmp    800916 <strncpy+0x12>
	}
	return ret;
}
  80092b:	5b                   	pop    %ebx
  80092c:	5e                   	pop    %esi
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	56                   	push   %esi
  800933:	53                   	push   %ebx
  800934:	8b 75 08             	mov    0x8(%ebp),%esi
  800937:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80093a:	8b 55 10             	mov    0x10(%ebp),%edx
  80093d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80093f:	85 d2                	test   %edx,%edx
  800941:	74 21                	je     800964 <strlcpy+0x35>
  800943:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800947:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800949:	39 c2                	cmp    %eax,%edx
  80094b:	74 14                	je     800961 <strlcpy+0x32>
  80094d:	0f b6 19             	movzbl (%ecx),%ebx
  800950:	84 db                	test   %bl,%bl
  800952:	74 0b                	je     80095f <strlcpy+0x30>
			*dst++ = *src++;
  800954:	83 c1 01             	add    $0x1,%ecx
  800957:	83 c2 01             	add    $0x1,%edx
  80095a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80095d:	eb ea                	jmp    800949 <strlcpy+0x1a>
  80095f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800961:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800964:	29 f0                	sub    %esi,%eax
}
  800966:	5b                   	pop    %ebx
  800967:	5e                   	pop    %esi
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800970:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800973:	0f b6 01             	movzbl (%ecx),%eax
  800976:	84 c0                	test   %al,%al
  800978:	74 0c                	je     800986 <strcmp+0x1c>
  80097a:	3a 02                	cmp    (%edx),%al
  80097c:	75 08                	jne    800986 <strcmp+0x1c>
		p++, q++;
  80097e:	83 c1 01             	add    $0x1,%ecx
  800981:	83 c2 01             	add    $0x1,%edx
  800984:	eb ed                	jmp    800973 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800986:	0f b6 c0             	movzbl %al,%eax
  800989:	0f b6 12             	movzbl (%edx),%edx
  80098c:	29 d0                	sub    %edx,%eax
}
  80098e:	5d                   	pop    %ebp
  80098f:	c3                   	ret    

00800990 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	53                   	push   %ebx
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099a:	89 c3                	mov    %eax,%ebx
  80099c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80099f:	eb 06                	jmp    8009a7 <strncmp+0x17>
		n--, p++, q++;
  8009a1:	83 c0 01             	add    $0x1,%eax
  8009a4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009a7:	39 d8                	cmp    %ebx,%eax
  8009a9:	74 16                	je     8009c1 <strncmp+0x31>
  8009ab:	0f b6 08             	movzbl (%eax),%ecx
  8009ae:	84 c9                	test   %cl,%cl
  8009b0:	74 04                	je     8009b6 <strncmp+0x26>
  8009b2:	3a 0a                	cmp    (%edx),%cl
  8009b4:	74 eb                	je     8009a1 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b6:	0f b6 00             	movzbl (%eax),%eax
  8009b9:	0f b6 12             	movzbl (%edx),%edx
  8009bc:	29 d0                	sub    %edx,%eax
}
  8009be:	5b                   	pop    %ebx
  8009bf:	5d                   	pop    %ebp
  8009c0:	c3                   	ret    
		return 0;
  8009c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c6:	eb f6                	jmp    8009be <strncmp+0x2e>

008009c8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009d2:	0f b6 10             	movzbl (%eax),%edx
  8009d5:	84 d2                	test   %dl,%dl
  8009d7:	74 09                	je     8009e2 <strchr+0x1a>
		if (*s == c)
  8009d9:	38 ca                	cmp    %cl,%dl
  8009db:	74 0a                	je     8009e7 <strchr+0x1f>
	for (; *s; s++)
  8009dd:	83 c0 01             	add    $0x1,%eax
  8009e0:	eb f0                	jmp    8009d2 <strchr+0xa>
			return (char *) s;
	return 0;
  8009e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e7:	5d                   	pop    %ebp
  8009e8:	c3                   	ret    

008009e9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009f6:	38 ca                	cmp    %cl,%dl
  8009f8:	74 09                	je     800a03 <strfind+0x1a>
  8009fa:	84 d2                	test   %dl,%dl
  8009fc:	74 05                	je     800a03 <strfind+0x1a>
	for (; *s; s++)
  8009fe:	83 c0 01             	add    $0x1,%eax
  800a01:	eb f0                	jmp    8009f3 <strfind+0xa>
			break;
	return (char *) s;
}
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    

00800a05 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	57                   	push   %edi
  800a09:	56                   	push   %esi
  800a0a:	53                   	push   %ebx
  800a0b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a11:	85 c9                	test   %ecx,%ecx
  800a13:	74 31                	je     800a46 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a15:	89 f8                	mov    %edi,%eax
  800a17:	09 c8                	or     %ecx,%eax
  800a19:	a8 03                	test   $0x3,%al
  800a1b:	75 23                	jne    800a40 <memset+0x3b>
		c &= 0xFF;
  800a1d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a21:	89 d3                	mov    %edx,%ebx
  800a23:	c1 e3 08             	shl    $0x8,%ebx
  800a26:	89 d0                	mov    %edx,%eax
  800a28:	c1 e0 18             	shl    $0x18,%eax
  800a2b:	89 d6                	mov    %edx,%esi
  800a2d:	c1 e6 10             	shl    $0x10,%esi
  800a30:	09 f0                	or     %esi,%eax
  800a32:	09 c2                	or     %eax,%edx
  800a34:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a36:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a39:	89 d0                	mov    %edx,%eax
  800a3b:	fc                   	cld    
  800a3c:	f3 ab                	rep stos %eax,%es:(%edi)
  800a3e:	eb 06                	jmp    800a46 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a43:	fc                   	cld    
  800a44:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a46:	89 f8                	mov    %edi,%eax
  800a48:	5b                   	pop    %ebx
  800a49:	5e                   	pop    %esi
  800a4a:	5f                   	pop    %edi
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    

00800a4d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	57                   	push   %edi
  800a51:	56                   	push   %esi
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a58:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a5b:	39 c6                	cmp    %eax,%esi
  800a5d:	73 32                	jae    800a91 <memmove+0x44>
  800a5f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a62:	39 c2                	cmp    %eax,%edx
  800a64:	76 2b                	jbe    800a91 <memmove+0x44>
		s += n;
		d += n;
  800a66:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a69:	89 fe                	mov    %edi,%esi
  800a6b:	09 ce                	or     %ecx,%esi
  800a6d:	09 d6                	or     %edx,%esi
  800a6f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a75:	75 0e                	jne    800a85 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a77:	83 ef 04             	sub    $0x4,%edi
  800a7a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a7d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a80:	fd                   	std    
  800a81:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a83:	eb 09                	jmp    800a8e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a85:	83 ef 01             	sub    $0x1,%edi
  800a88:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a8b:	fd                   	std    
  800a8c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a8e:	fc                   	cld    
  800a8f:	eb 1a                	jmp    800aab <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a91:	89 c2                	mov    %eax,%edx
  800a93:	09 ca                	or     %ecx,%edx
  800a95:	09 f2                	or     %esi,%edx
  800a97:	f6 c2 03             	test   $0x3,%dl
  800a9a:	75 0a                	jne    800aa6 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a9c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a9f:	89 c7                	mov    %eax,%edi
  800aa1:	fc                   	cld    
  800aa2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa4:	eb 05                	jmp    800aab <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800aa6:	89 c7                	mov    %eax,%edi
  800aa8:	fc                   	cld    
  800aa9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aab:	5e                   	pop    %esi
  800aac:	5f                   	pop    %edi
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    

00800aaf <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ab5:	ff 75 10             	pushl  0x10(%ebp)
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	ff 75 08             	pushl  0x8(%ebp)
  800abe:	e8 8a ff ff ff       	call   800a4d <memmove>
}
  800ac3:	c9                   	leave  
  800ac4:	c3                   	ret    

00800ac5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	56                   	push   %esi
  800ac9:	53                   	push   %ebx
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad0:	89 c6                	mov    %eax,%esi
  800ad2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ad5:	39 f0                	cmp    %esi,%eax
  800ad7:	74 1c                	je     800af5 <memcmp+0x30>
		if (*s1 != *s2)
  800ad9:	0f b6 08             	movzbl (%eax),%ecx
  800adc:	0f b6 1a             	movzbl (%edx),%ebx
  800adf:	38 d9                	cmp    %bl,%cl
  800ae1:	75 08                	jne    800aeb <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ae3:	83 c0 01             	add    $0x1,%eax
  800ae6:	83 c2 01             	add    $0x1,%edx
  800ae9:	eb ea                	jmp    800ad5 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800aeb:	0f b6 c1             	movzbl %cl,%eax
  800aee:	0f b6 db             	movzbl %bl,%ebx
  800af1:	29 d8                	sub    %ebx,%eax
  800af3:	eb 05                	jmp    800afa <memcmp+0x35>
	}

	return 0;
  800af5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800afa:	5b                   	pop    %ebx
  800afb:	5e                   	pop    %esi
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b07:	89 c2                	mov    %eax,%edx
  800b09:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b0c:	39 d0                	cmp    %edx,%eax
  800b0e:	73 09                	jae    800b19 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b10:	38 08                	cmp    %cl,(%eax)
  800b12:	74 05                	je     800b19 <memfind+0x1b>
	for (; s < ends; s++)
  800b14:	83 c0 01             	add    $0x1,%eax
  800b17:	eb f3                	jmp    800b0c <memfind+0xe>
			break;
	return (void *) s;
}
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    

00800b1b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	57                   	push   %edi
  800b1f:	56                   	push   %esi
  800b20:	53                   	push   %ebx
  800b21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b24:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b27:	eb 03                	jmp    800b2c <strtol+0x11>
		s++;
  800b29:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b2c:	0f b6 01             	movzbl (%ecx),%eax
  800b2f:	3c 20                	cmp    $0x20,%al
  800b31:	74 f6                	je     800b29 <strtol+0xe>
  800b33:	3c 09                	cmp    $0x9,%al
  800b35:	74 f2                	je     800b29 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b37:	3c 2b                	cmp    $0x2b,%al
  800b39:	74 2a                	je     800b65 <strtol+0x4a>
	int neg = 0;
  800b3b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b40:	3c 2d                	cmp    $0x2d,%al
  800b42:	74 2b                	je     800b6f <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b44:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b4a:	75 0f                	jne    800b5b <strtol+0x40>
  800b4c:	80 39 30             	cmpb   $0x30,(%ecx)
  800b4f:	74 28                	je     800b79 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b51:	85 db                	test   %ebx,%ebx
  800b53:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b58:	0f 44 d8             	cmove  %eax,%ebx
  800b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b60:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b63:	eb 50                	jmp    800bb5 <strtol+0x9a>
		s++;
  800b65:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b68:	bf 00 00 00 00       	mov    $0x0,%edi
  800b6d:	eb d5                	jmp    800b44 <strtol+0x29>
		s++, neg = 1;
  800b6f:	83 c1 01             	add    $0x1,%ecx
  800b72:	bf 01 00 00 00       	mov    $0x1,%edi
  800b77:	eb cb                	jmp    800b44 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b79:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b7d:	74 0e                	je     800b8d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b7f:	85 db                	test   %ebx,%ebx
  800b81:	75 d8                	jne    800b5b <strtol+0x40>
		s++, base = 8;
  800b83:	83 c1 01             	add    $0x1,%ecx
  800b86:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b8b:	eb ce                	jmp    800b5b <strtol+0x40>
		s += 2, base = 16;
  800b8d:	83 c1 02             	add    $0x2,%ecx
  800b90:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b95:	eb c4                	jmp    800b5b <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b97:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b9a:	89 f3                	mov    %esi,%ebx
  800b9c:	80 fb 19             	cmp    $0x19,%bl
  800b9f:	77 29                	ja     800bca <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ba1:	0f be d2             	movsbl %dl,%edx
  800ba4:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ba7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800baa:	7d 30                	jge    800bdc <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bac:	83 c1 01             	add    $0x1,%ecx
  800baf:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bb3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bb5:	0f b6 11             	movzbl (%ecx),%edx
  800bb8:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bbb:	89 f3                	mov    %esi,%ebx
  800bbd:	80 fb 09             	cmp    $0x9,%bl
  800bc0:	77 d5                	ja     800b97 <strtol+0x7c>
			dig = *s - '0';
  800bc2:	0f be d2             	movsbl %dl,%edx
  800bc5:	83 ea 30             	sub    $0x30,%edx
  800bc8:	eb dd                	jmp    800ba7 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bca:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bcd:	89 f3                	mov    %esi,%ebx
  800bcf:	80 fb 19             	cmp    $0x19,%bl
  800bd2:	77 08                	ja     800bdc <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bd4:	0f be d2             	movsbl %dl,%edx
  800bd7:	83 ea 37             	sub    $0x37,%edx
  800bda:	eb cb                	jmp    800ba7 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be0:	74 05                	je     800be7 <strtol+0xcc>
		*endptr = (char *) s;
  800be2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800be7:	89 c2                	mov    %eax,%edx
  800be9:	f7 da                	neg    %edx
  800beb:	85 ff                	test   %edi,%edi
  800bed:	0f 45 c2             	cmovne %edx,%eax
}
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5f                   	pop    %edi
  800bf3:	5d                   	pop    %ebp
  800bf4:	c3                   	ret    

00800bf5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	57                   	push   %edi
  800bf9:	56                   	push   %esi
  800bfa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800c00:	8b 55 08             	mov    0x8(%ebp),%edx
  800c03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c06:	89 c3                	mov    %eax,%ebx
  800c08:	89 c7                	mov    %eax,%edi
  800c0a:	89 c6                	mov    %eax,%esi
  800c0c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c0e:	5b                   	pop    %ebx
  800c0f:	5e                   	pop    %esi
  800c10:	5f                   	pop    %edi
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    

00800c13 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	57                   	push   %edi
  800c17:	56                   	push   %esi
  800c18:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c19:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1e:	b8 01 00 00 00       	mov    $0x1,%eax
  800c23:	89 d1                	mov    %edx,%ecx
  800c25:	89 d3                	mov    %edx,%ebx
  800c27:	89 d7                	mov    %edx,%edi
  800c29:	89 d6                	mov    %edx,%esi
  800c2b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c2d:	5b                   	pop    %ebx
  800c2e:	5e                   	pop    %esi
  800c2f:	5f                   	pop    %edi
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	57                   	push   %edi
  800c36:	56                   	push   %esi
  800c37:	53                   	push   %ebx
  800c38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c40:	8b 55 08             	mov    0x8(%ebp),%edx
  800c43:	b8 03 00 00 00       	mov    $0x3,%eax
  800c48:	89 cb                	mov    %ecx,%ebx
  800c4a:	89 cf                	mov    %ecx,%edi
  800c4c:	89 ce                	mov    %ecx,%esi
  800c4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c50:	85 c0                	test   %eax,%eax
  800c52:	7f 08                	jg     800c5c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c57:	5b                   	pop    %ebx
  800c58:	5e                   	pop    %esi
  800c59:	5f                   	pop    %edi
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5c:	83 ec 0c             	sub    $0xc,%esp
  800c5f:	50                   	push   %eax
  800c60:	6a 03                	push   $0x3
  800c62:	68 a8 28 80 00       	push   $0x8028a8
  800c67:	6a 43                	push   $0x43
  800c69:	68 c5 28 80 00       	push   $0x8028c5
  800c6e:	e8 89 14 00 00       	call   8020fc <_panic>

00800c73 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	57                   	push   %edi
  800c77:	56                   	push   %esi
  800c78:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c79:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7e:	b8 02 00 00 00       	mov    $0x2,%eax
  800c83:	89 d1                	mov    %edx,%ecx
  800c85:	89 d3                	mov    %edx,%ebx
  800c87:	89 d7                	mov    %edx,%edi
  800c89:	89 d6                	mov    %edx,%esi
  800c8b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c8d:	5b                   	pop    %ebx
  800c8e:	5e                   	pop    %esi
  800c8f:	5f                   	pop    %edi
  800c90:	5d                   	pop    %ebp
  800c91:	c3                   	ret    

00800c92 <sys_yield>:

void
sys_yield(void)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	57                   	push   %edi
  800c96:	56                   	push   %esi
  800c97:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c98:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ca2:	89 d1                	mov    %edx,%ecx
  800ca4:	89 d3                	mov    %edx,%ebx
  800ca6:	89 d7                	mov    %edx,%edi
  800ca8:	89 d6                	mov    %edx,%esi
  800caa:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cac:	5b                   	pop    %ebx
  800cad:	5e                   	pop    %esi
  800cae:	5f                   	pop    %edi
  800caf:	5d                   	pop    %ebp
  800cb0:	c3                   	ret    

00800cb1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	57                   	push   %edi
  800cb5:	56                   	push   %esi
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cba:	be 00 00 00 00       	mov    $0x0,%esi
  800cbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc5:	b8 04 00 00 00       	mov    $0x4,%eax
  800cca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ccd:	89 f7                	mov    %esi,%edi
  800ccf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd1:	85 c0                	test   %eax,%eax
  800cd3:	7f 08                	jg     800cdd <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd8:	5b                   	pop    %ebx
  800cd9:	5e                   	pop    %esi
  800cda:	5f                   	pop    %edi
  800cdb:	5d                   	pop    %ebp
  800cdc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdd:	83 ec 0c             	sub    $0xc,%esp
  800ce0:	50                   	push   %eax
  800ce1:	6a 04                	push   $0x4
  800ce3:	68 a8 28 80 00       	push   $0x8028a8
  800ce8:	6a 43                	push   $0x43
  800cea:	68 c5 28 80 00       	push   $0x8028c5
  800cef:	e8 08 14 00 00       	call   8020fc <_panic>

00800cf4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	57                   	push   %edi
  800cf8:	56                   	push   %esi
  800cf9:	53                   	push   %ebx
  800cfa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800d00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d03:	b8 05 00 00 00       	mov    $0x5,%eax
  800d08:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d0e:	8b 75 18             	mov    0x18(%ebp),%esi
  800d11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	7f 08                	jg     800d1f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1a:	5b                   	pop    %ebx
  800d1b:	5e                   	pop    %esi
  800d1c:	5f                   	pop    %edi
  800d1d:	5d                   	pop    %ebp
  800d1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1f:	83 ec 0c             	sub    $0xc,%esp
  800d22:	50                   	push   %eax
  800d23:	6a 05                	push   $0x5
  800d25:	68 a8 28 80 00       	push   $0x8028a8
  800d2a:	6a 43                	push   $0x43
  800d2c:	68 c5 28 80 00       	push   $0x8028c5
  800d31:	e8 c6 13 00 00       	call   8020fc <_panic>

00800d36 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	57                   	push   %edi
  800d3a:	56                   	push   %esi
  800d3b:	53                   	push   %ebx
  800d3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d44:	8b 55 08             	mov    0x8(%ebp),%edx
  800d47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4a:	b8 06 00 00 00       	mov    $0x6,%eax
  800d4f:	89 df                	mov    %ebx,%edi
  800d51:	89 de                	mov    %ebx,%esi
  800d53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d55:	85 c0                	test   %eax,%eax
  800d57:	7f 08                	jg     800d61 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5c:	5b                   	pop    %ebx
  800d5d:	5e                   	pop    %esi
  800d5e:	5f                   	pop    %edi
  800d5f:	5d                   	pop    %ebp
  800d60:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d61:	83 ec 0c             	sub    $0xc,%esp
  800d64:	50                   	push   %eax
  800d65:	6a 06                	push   $0x6
  800d67:	68 a8 28 80 00       	push   $0x8028a8
  800d6c:	6a 43                	push   $0x43
  800d6e:	68 c5 28 80 00       	push   $0x8028c5
  800d73:	e8 84 13 00 00       	call   8020fc <_panic>

00800d78 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	57                   	push   %edi
  800d7c:	56                   	push   %esi
  800d7d:	53                   	push   %ebx
  800d7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
  800d89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8c:	b8 08 00 00 00       	mov    $0x8,%eax
  800d91:	89 df                	mov    %ebx,%edi
  800d93:	89 de                	mov    %ebx,%esi
  800d95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d97:	85 c0                	test   %eax,%eax
  800d99:	7f 08                	jg     800da3 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9e:	5b                   	pop    %ebx
  800d9f:	5e                   	pop    %esi
  800da0:	5f                   	pop    %edi
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da3:	83 ec 0c             	sub    $0xc,%esp
  800da6:	50                   	push   %eax
  800da7:	6a 08                	push   $0x8
  800da9:	68 a8 28 80 00       	push   $0x8028a8
  800dae:	6a 43                	push   $0x43
  800db0:	68 c5 28 80 00       	push   $0x8028c5
  800db5:	e8 42 13 00 00       	call   8020fc <_panic>

00800dba <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	57                   	push   %edi
  800dbe:	56                   	push   %esi
  800dbf:	53                   	push   %ebx
  800dc0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dce:	b8 09 00 00 00       	mov    $0x9,%eax
  800dd3:	89 df                	mov    %ebx,%edi
  800dd5:	89 de                	mov    %ebx,%esi
  800dd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	7f 08                	jg     800de5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de0:	5b                   	pop    %ebx
  800de1:	5e                   	pop    %esi
  800de2:	5f                   	pop    %edi
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de5:	83 ec 0c             	sub    $0xc,%esp
  800de8:	50                   	push   %eax
  800de9:	6a 09                	push   $0x9
  800deb:	68 a8 28 80 00       	push   $0x8028a8
  800df0:	6a 43                	push   $0x43
  800df2:	68 c5 28 80 00       	push   $0x8028c5
  800df7:	e8 00 13 00 00       	call   8020fc <_panic>

00800dfc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
  800e02:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e05:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e10:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e15:	89 df                	mov    %ebx,%edi
  800e17:	89 de                	mov    %ebx,%esi
  800e19:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	7f 08                	jg     800e27 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e22:	5b                   	pop    %ebx
  800e23:	5e                   	pop    %esi
  800e24:	5f                   	pop    %edi
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e27:	83 ec 0c             	sub    $0xc,%esp
  800e2a:	50                   	push   %eax
  800e2b:	6a 0a                	push   $0xa
  800e2d:	68 a8 28 80 00       	push   $0x8028a8
  800e32:	6a 43                	push   $0x43
  800e34:	68 c5 28 80 00       	push   $0x8028c5
  800e39:	e8 be 12 00 00       	call   8020fc <_panic>

00800e3e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	57                   	push   %edi
  800e42:	56                   	push   %esi
  800e43:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e4f:	be 00 00 00 00       	mov    $0x0,%esi
  800e54:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e57:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e5a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e5c:	5b                   	pop    %ebx
  800e5d:	5e                   	pop    %esi
  800e5e:	5f                   	pop    %edi
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    

00800e61 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	57                   	push   %edi
  800e65:	56                   	push   %esi
  800e66:	53                   	push   %ebx
  800e67:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e72:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e77:	89 cb                	mov    %ecx,%ebx
  800e79:	89 cf                	mov    %ecx,%edi
  800e7b:	89 ce                	mov    %ecx,%esi
  800e7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	7f 08                	jg     800e8b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e86:	5b                   	pop    %ebx
  800e87:	5e                   	pop    %esi
  800e88:	5f                   	pop    %edi
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8b:	83 ec 0c             	sub    $0xc,%esp
  800e8e:	50                   	push   %eax
  800e8f:	6a 0d                	push   $0xd
  800e91:	68 a8 28 80 00       	push   $0x8028a8
  800e96:	6a 43                	push   $0x43
  800e98:	68 c5 28 80 00       	push   $0x8028c5
  800e9d:	e8 5a 12 00 00       	call   8020fc <_panic>

00800ea2 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	57                   	push   %edi
  800ea6:	56                   	push   %esi
  800ea7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ead:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb3:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eb8:	89 df                	mov    %ebx,%edi
  800eba:	89 de                	mov    %ebx,%esi
  800ebc:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	57                   	push   %edi
  800ec7:	56                   	push   %esi
  800ec8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ece:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed1:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ed6:	89 cb                	mov    %ecx,%ebx
  800ed8:	89 cf                	mov    %ecx,%edi
  800eda:	89 ce                	mov    %ecx,%esi
  800edc:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ede:	5b                   	pop    %ebx
  800edf:	5e                   	pop    %esi
  800ee0:	5f                   	pop    %edi
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    

00800ee3 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	57                   	push   %edi
  800ee7:	56                   	push   %esi
  800ee8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee9:	ba 00 00 00 00       	mov    $0x0,%edx
  800eee:	b8 10 00 00 00       	mov    $0x10,%eax
  800ef3:	89 d1                	mov    %edx,%ecx
  800ef5:	89 d3                	mov    %edx,%ebx
  800ef7:	89 d7                	mov    %edx,%edi
  800ef9:	89 d6                	mov    %edx,%esi
  800efb:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800efd:	5b                   	pop    %ebx
  800efe:	5e                   	pop    %esi
  800eff:	5f                   	pop    %edi
  800f00:	5d                   	pop    %ebp
  800f01:	c3                   	ret    

00800f02 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	57                   	push   %edi
  800f06:	56                   	push   %esi
  800f07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f08:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f13:	b8 11 00 00 00       	mov    $0x11,%eax
  800f18:	89 df                	mov    %ebx,%edi
  800f1a:	89 de                	mov    %ebx,%esi
  800f1c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f1e:	5b                   	pop    %ebx
  800f1f:	5e                   	pop    %esi
  800f20:	5f                   	pop    %edi
  800f21:	5d                   	pop    %ebp
  800f22:	c3                   	ret    

00800f23 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	57                   	push   %edi
  800f27:	56                   	push   %esi
  800f28:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f29:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f34:	b8 12 00 00 00       	mov    $0x12,%eax
  800f39:	89 df                	mov    %ebx,%edi
  800f3b:	89 de                	mov    %ebx,%esi
  800f3d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f3f:	5b                   	pop    %ebx
  800f40:	5e                   	pop    %esi
  800f41:	5f                   	pop    %edi
  800f42:	5d                   	pop    %ebp
  800f43:	c3                   	ret    

00800f44 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	57                   	push   %edi
  800f48:	56                   	push   %esi
  800f49:	53                   	push   %ebx
  800f4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f52:	8b 55 08             	mov    0x8(%ebp),%edx
  800f55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f58:	b8 13 00 00 00       	mov    $0x13,%eax
  800f5d:	89 df                	mov    %ebx,%edi
  800f5f:	89 de                	mov    %ebx,%esi
  800f61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f63:	85 c0                	test   %eax,%eax
  800f65:	7f 08                	jg     800f6f <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6a:	5b                   	pop    %ebx
  800f6b:	5e                   	pop    %esi
  800f6c:	5f                   	pop    %edi
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6f:	83 ec 0c             	sub    $0xc,%esp
  800f72:	50                   	push   %eax
  800f73:	6a 13                	push   $0x13
  800f75:	68 a8 28 80 00       	push   $0x8028a8
  800f7a:	6a 43                	push   $0x43
  800f7c:	68 c5 28 80 00       	push   $0x8028c5
  800f81:	e8 76 11 00 00       	call   8020fc <_panic>

00800f86 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	57                   	push   %edi
  800f8a:	56                   	push   %esi
  800f8b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f91:	8b 55 08             	mov    0x8(%ebp),%edx
  800f94:	b8 14 00 00 00       	mov    $0x14,%eax
  800f99:	89 cb                	mov    %ecx,%ebx
  800f9b:	89 cf                	mov    %ecx,%edi
  800f9d:	89 ce                	mov    %ecx,%esi
  800f9f:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5f                   	pop    %edi
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    

00800fa6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	05 00 00 00 30       	add    $0x30000000,%eax
  800fb1:	c1 e8 0c             	shr    $0xc,%eax
}
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fc1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fc6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    

00800fcd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fd5:	89 c2                	mov    %eax,%edx
  800fd7:	c1 ea 16             	shr    $0x16,%edx
  800fda:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fe1:	f6 c2 01             	test   $0x1,%dl
  800fe4:	74 2d                	je     801013 <fd_alloc+0x46>
  800fe6:	89 c2                	mov    %eax,%edx
  800fe8:	c1 ea 0c             	shr    $0xc,%edx
  800feb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ff2:	f6 c2 01             	test   $0x1,%dl
  800ff5:	74 1c                	je     801013 <fd_alloc+0x46>
  800ff7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ffc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801001:	75 d2                	jne    800fd5 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80100c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801011:	eb 0a                	jmp    80101d <fd_alloc+0x50>
			*fd_store = fd;
  801013:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801016:	89 01                	mov    %eax,(%ecx)
			return 0;
  801018:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80101d:	5d                   	pop    %ebp
  80101e:	c3                   	ret    

0080101f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801025:	83 f8 1f             	cmp    $0x1f,%eax
  801028:	77 30                	ja     80105a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80102a:	c1 e0 0c             	shl    $0xc,%eax
  80102d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801032:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801038:	f6 c2 01             	test   $0x1,%dl
  80103b:	74 24                	je     801061 <fd_lookup+0x42>
  80103d:	89 c2                	mov    %eax,%edx
  80103f:	c1 ea 0c             	shr    $0xc,%edx
  801042:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801049:	f6 c2 01             	test   $0x1,%dl
  80104c:	74 1a                	je     801068 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80104e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801051:	89 02                	mov    %eax,(%edx)
	return 0;
  801053:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801058:	5d                   	pop    %ebp
  801059:	c3                   	ret    
		return -E_INVAL;
  80105a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80105f:	eb f7                	jmp    801058 <fd_lookup+0x39>
		return -E_INVAL;
  801061:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801066:	eb f0                	jmp    801058 <fd_lookup+0x39>
  801068:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80106d:	eb e9                	jmp    801058 <fd_lookup+0x39>

0080106f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	83 ec 08             	sub    $0x8,%esp
  801075:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801078:	ba 00 00 00 00       	mov    $0x0,%edx
  80107d:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801082:	39 08                	cmp    %ecx,(%eax)
  801084:	74 38                	je     8010be <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801086:	83 c2 01             	add    $0x1,%edx
  801089:	8b 04 95 50 29 80 00 	mov    0x802950(,%edx,4),%eax
  801090:	85 c0                	test   %eax,%eax
  801092:	75 ee                	jne    801082 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801094:	a1 08 40 80 00       	mov    0x804008,%eax
  801099:	8b 40 48             	mov    0x48(%eax),%eax
  80109c:	83 ec 04             	sub    $0x4,%esp
  80109f:	51                   	push   %ecx
  8010a0:	50                   	push   %eax
  8010a1:	68 d4 28 80 00       	push   $0x8028d4
  8010a6:	e8 b5 f0 ff ff       	call   800160 <cprintf>
	*dev = 0;
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010b4:	83 c4 10             	add    $0x10,%esp
  8010b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010bc:	c9                   	leave  
  8010bd:	c3                   	ret    
			*dev = devtab[i];
  8010be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c8:	eb f2                	jmp    8010bc <dev_lookup+0x4d>

008010ca <fd_close>:
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	57                   	push   %edi
  8010ce:	56                   	push   %esi
  8010cf:	53                   	push   %ebx
  8010d0:	83 ec 24             	sub    $0x24,%esp
  8010d3:	8b 75 08             	mov    0x8(%ebp),%esi
  8010d6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010d9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010dc:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010dd:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010e3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010e6:	50                   	push   %eax
  8010e7:	e8 33 ff ff ff       	call   80101f <fd_lookup>
  8010ec:	89 c3                	mov    %eax,%ebx
  8010ee:	83 c4 10             	add    $0x10,%esp
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	78 05                	js     8010fa <fd_close+0x30>
	    || fd != fd2)
  8010f5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010f8:	74 16                	je     801110 <fd_close+0x46>
		return (must_exist ? r : 0);
  8010fa:	89 f8                	mov    %edi,%eax
  8010fc:	84 c0                	test   %al,%al
  8010fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801103:	0f 44 d8             	cmove  %eax,%ebx
}
  801106:	89 d8                	mov    %ebx,%eax
  801108:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110b:	5b                   	pop    %ebx
  80110c:	5e                   	pop    %esi
  80110d:	5f                   	pop    %edi
  80110e:	5d                   	pop    %ebp
  80110f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801110:	83 ec 08             	sub    $0x8,%esp
  801113:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801116:	50                   	push   %eax
  801117:	ff 36                	pushl  (%esi)
  801119:	e8 51 ff ff ff       	call   80106f <dev_lookup>
  80111e:	89 c3                	mov    %eax,%ebx
  801120:	83 c4 10             	add    $0x10,%esp
  801123:	85 c0                	test   %eax,%eax
  801125:	78 1a                	js     801141 <fd_close+0x77>
		if (dev->dev_close)
  801127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80112a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80112d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801132:	85 c0                	test   %eax,%eax
  801134:	74 0b                	je     801141 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801136:	83 ec 0c             	sub    $0xc,%esp
  801139:	56                   	push   %esi
  80113a:	ff d0                	call   *%eax
  80113c:	89 c3                	mov    %eax,%ebx
  80113e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801141:	83 ec 08             	sub    $0x8,%esp
  801144:	56                   	push   %esi
  801145:	6a 00                	push   $0x0
  801147:	e8 ea fb ff ff       	call   800d36 <sys_page_unmap>
	return r;
  80114c:	83 c4 10             	add    $0x10,%esp
  80114f:	eb b5                	jmp    801106 <fd_close+0x3c>

00801151 <close>:

int
close(int fdnum)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801157:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80115a:	50                   	push   %eax
  80115b:	ff 75 08             	pushl  0x8(%ebp)
  80115e:	e8 bc fe ff ff       	call   80101f <fd_lookup>
  801163:	83 c4 10             	add    $0x10,%esp
  801166:	85 c0                	test   %eax,%eax
  801168:	79 02                	jns    80116c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    
		return fd_close(fd, 1);
  80116c:	83 ec 08             	sub    $0x8,%esp
  80116f:	6a 01                	push   $0x1
  801171:	ff 75 f4             	pushl  -0xc(%ebp)
  801174:	e8 51 ff ff ff       	call   8010ca <fd_close>
  801179:	83 c4 10             	add    $0x10,%esp
  80117c:	eb ec                	jmp    80116a <close+0x19>

0080117e <close_all>:

void
close_all(void)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	53                   	push   %ebx
  801182:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801185:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80118a:	83 ec 0c             	sub    $0xc,%esp
  80118d:	53                   	push   %ebx
  80118e:	e8 be ff ff ff       	call   801151 <close>
	for (i = 0; i < MAXFD; i++)
  801193:	83 c3 01             	add    $0x1,%ebx
  801196:	83 c4 10             	add    $0x10,%esp
  801199:	83 fb 20             	cmp    $0x20,%ebx
  80119c:	75 ec                	jne    80118a <close_all+0xc>
}
  80119e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a1:	c9                   	leave  
  8011a2:	c3                   	ret    

008011a3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	57                   	push   %edi
  8011a7:	56                   	push   %esi
  8011a8:	53                   	push   %ebx
  8011a9:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011af:	50                   	push   %eax
  8011b0:	ff 75 08             	pushl  0x8(%ebp)
  8011b3:	e8 67 fe ff ff       	call   80101f <fd_lookup>
  8011b8:	89 c3                	mov    %eax,%ebx
  8011ba:	83 c4 10             	add    $0x10,%esp
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	0f 88 81 00 00 00    	js     801246 <dup+0xa3>
		return r;
	close(newfdnum);
  8011c5:	83 ec 0c             	sub    $0xc,%esp
  8011c8:	ff 75 0c             	pushl  0xc(%ebp)
  8011cb:	e8 81 ff ff ff       	call   801151 <close>

	newfd = INDEX2FD(newfdnum);
  8011d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011d3:	c1 e6 0c             	shl    $0xc,%esi
  8011d6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011dc:	83 c4 04             	add    $0x4,%esp
  8011df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011e2:	e8 cf fd ff ff       	call   800fb6 <fd2data>
  8011e7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011e9:	89 34 24             	mov    %esi,(%esp)
  8011ec:	e8 c5 fd ff ff       	call   800fb6 <fd2data>
  8011f1:	83 c4 10             	add    $0x10,%esp
  8011f4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011f6:	89 d8                	mov    %ebx,%eax
  8011f8:	c1 e8 16             	shr    $0x16,%eax
  8011fb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801202:	a8 01                	test   $0x1,%al
  801204:	74 11                	je     801217 <dup+0x74>
  801206:	89 d8                	mov    %ebx,%eax
  801208:	c1 e8 0c             	shr    $0xc,%eax
  80120b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801212:	f6 c2 01             	test   $0x1,%dl
  801215:	75 39                	jne    801250 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801217:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80121a:	89 d0                	mov    %edx,%eax
  80121c:	c1 e8 0c             	shr    $0xc,%eax
  80121f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801226:	83 ec 0c             	sub    $0xc,%esp
  801229:	25 07 0e 00 00       	and    $0xe07,%eax
  80122e:	50                   	push   %eax
  80122f:	56                   	push   %esi
  801230:	6a 00                	push   $0x0
  801232:	52                   	push   %edx
  801233:	6a 00                	push   $0x0
  801235:	e8 ba fa ff ff       	call   800cf4 <sys_page_map>
  80123a:	89 c3                	mov    %eax,%ebx
  80123c:	83 c4 20             	add    $0x20,%esp
  80123f:	85 c0                	test   %eax,%eax
  801241:	78 31                	js     801274 <dup+0xd1>
		goto err;

	return newfdnum;
  801243:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801246:	89 d8                	mov    %ebx,%eax
  801248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124b:	5b                   	pop    %ebx
  80124c:	5e                   	pop    %esi
  80124d:	5f                   	pop    %edi
  80124e:	5d                   	pop    %ebp
  80124f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801250:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801257:	83 ec 0c             	sub    $0xc,%esp
  80125a:	25 07 0e 00 00       	and    $0xe07,%eax
  80125f:	50                   	push   %eax
  801260:	57                   	push   %edi
  801261:	6a 00                	push   $0x0
  801263:	53                   	push   %ebx
  801264:	6a 00                	push   $0x0
  801266:	e8 89 fa ff ff       	call   800cf4 <sys_page_map>
  80126b:	89 c3                	mov    %eax,%ebx
  80126d:	83 c4 20             	add    $0x20,%esp
  801270:	85 c0                	test   %eax,%eax
  801272:	79 a3                	jns    801217 <dup+0x74>
	sys_page_unmap(0, newfd);
  801274:	83 ec 08             	sub    $0x8,%esp
  801277:	56                   	push   %esi
  801278:	6a 00                	push   $0x0
  80127a:	e8 b7 fa ff ff       	call   800d36 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80127f:	83 c4 08             	add    $0x8,%esp
  801282:	57                   	push   %edi
  801283:	6a 00                	push   $0x0
  801285:	e8 ac fa ff ff       	call   800d36 <sys_page_unmap>
	return r;
  80128a:	83 c4 10             	add    $0x10,%esp
  80128d:	eb b7                	jmp    801246 <dup+0xa3>

0080128f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	53                   	push   %ebx
  801293:	83 ec 1c             	sub    $0x1c,%esp
  801296:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801299:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80129c:	50                   	push   %eax
  80129d:	53                   	push   %ebx
  80129e:	e8 7c fd ff ff       	call   80101f <fd_lookup>
  8012a3:	83 c4 10             	add    $0x10,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	78 3f                	js     8012e9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012aa:	83 ec 08             	sub    $0x8,%esp
  8012ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b0:	50                   	push   %eax
  8012b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b4:	ff 30                	pushl  (%eax)
  8012b6:	e8 b4 fd ff ff       	call   80106f <dev_lookup>
  8012bb:	83 c4 10             	add    $0x10,%esp
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	78 27                	js     8012e9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012c5:	8b 42 08             	mov    0x8(%edx),%eax
  8012c8:	83 e0 03             	and    $0x3,%eax
  8012cb:	83 f8 01             	cmp    $0x1,%eax
  8012ce:	74 1e                	je     8012ee <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d3:	8b 40 08             	mov    0x8(%eax),%eax
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	74 35                	je     80130f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012da:	83 ec 04             	sub    $0x4,%esp
  8012dd:	ff 75 10             	pushl  0x10(%ebp)
  8012e0:	ff 75 0c             	pushl  0xc(%ebp)
  8012e3:	52                   	push   %edx
  8012e4:	ff d0                	call   *%eax
  8012e6:	83 c4 10             	add    $0x10,%esp
}
  8012e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012ee:	a1 08 40 80 00       	mov    0x804008,%eax
  8012f3:	8b 40 48             	mov    0x48(%eax),%eax
  8012f6:	83 ec 04             	sub    $0x4,%esp
  8012f9:	53                   	push   %ebx
  8012fa:	50                   	push   %eax
  8012fb:	68 15 29 80 00       	push   $0x802915
  801300:	e8 5b ee ff ff       	call   800160 <cprintf>
		return -E_INVAL;
  801305:	83 c4 10             	add    $0x10,%esp
  801308:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130d:	eb da                	jmp    8012e9 <read+0x5a>
		return -E_NOT_SUPP;
  80130f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801314:	eb d3                	jmp    8012e9 <read+0x5a>

00801316 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	57                   	push   %edi
  80131a:	56                   	push   %esi
  80131b:	53                   	push   %ebx
  80131c:	83 ec 0c             	sub    $0xc,%esp
  80131f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801322:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801325:	bb 00 00 00 00       	mov    $0x0,%ebx
  80132a:	39 f3                	cmp    %esi,%ebx
  80132c:	73 23                	jae    801351 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80132e:	83 ec 04             	sub    $0x4,%esp
  801331:	89 f0                	mov    %esi,%eax
  801333:	29 d8                	sub    %ebx,%eax
  801335:	50                   	push   %eax
  801336:	89 d8                	mov    %ebx,%eax
  801338:	03 45 0c             	add    0xc(%ebp),%eax
  80133b:	50                   	push   %eax
  80133c:	57                   	push   %edi
  80133d:	e8 4d ff ff ff       	call   80128f <read>
		if (m < 0)
  801342:	83 c4 10             	add    $0x10,%esp
  801345:	85 c0                	test   %eax,%eax
  801347:	78 06                	js     80134f <readn+0x39>
			return m;
		if (m == 0)
  801349:	74 06                	je     801351 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80134b:	01 c3                	add    %eax,%ebx
  80134d:	eb db                	jmp    80132a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80134f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801351:	89 d8                	mov    %ebx,%eax
  801353:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801356:	5b                   	pop    %ebx
  801357:	5e                   	pop    %esi
  801358:	5f                   	pop    %edi
  801359:	5d                   	pop    %ebp
  80135a:	c3                   	ret    

0080135b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	53                   	push   %ebx
  80135f:	83 ec 1c             	sub    $0x1c,%esp
  801362:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801365:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801368:	50                   	push   %eax
  801369:	53                   	push   %ebx
  80136a:	e8 b0 fc ff ff       	call   80101f <fd_lookup>
  80136f:	83 c4 10             	add    $0x10,%esp
  801372:	85 c0                	test   %eax,%eax
  801374:	78 3a                	js     8013b0 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801376:	83 ec 08             	sub    $0x8,%esp
  801379:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80137c:	50                   	push   %eax
  80137d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801380:	ff 30                	pushl  (%eax)
  801382:	e8 e8 fc ff ff       	call   80106f <dev_lookup>
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	85 c0                	test   %eax,%eax
  80138c:	78 22                	js     8013b0 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80138e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801391:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801395:	74 1e                	je     8013b5 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801397:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139a:	8b 52 0c             	mov    0xc(%edx),%edx
  80139d:	85 d2                	test   %edx,%edx
  80139f:	74 35                	je     8013d6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013a1:	83 ec 04             	sub    $0x4,%esp
  8013a4:	ff 75 10             	pushl  0x10(%ebp)
  8013a7:	ff 75 0c             	pushl  0xc(%ebp)
  8013aa:	50                   	push   %eax
  8013ab:	ff d2                	call   *%edx
  8013ad:	83 c4 10             	add    $0x10,%esp
}
  8013b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013b5:	a1 08 40 80 00       	mov    0x804008,%eax
  8013ba:	8b 40 48             	mov    0x48(%eax),%eax
  8013bd:	83 ec 04             	sub    $0x4,%esp
  8013c0:	53                   	push   %ebx
  8013c1:	50                   	push   %eax
  8013c2:	68 31 29 80 00       	push   $0x802931
  8013c7:	e8 94 ed ff ff       	call   800160 <cprintf>
		return -E_INVAL;
  8013cc:	83 c4 10             	add    $0x10,%esp
  8013cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013d4:	eb da                	jmp    8013b0 <write+0x55>
		return -E_NOT_SUPP;
  8013d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013db:	eb d3                	jmp    8013b0 <write+0x55>

008013dd <seek>:

int
seek(int fdnum, off_t offset)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e6:	50                   	push   %eax
  8013e7:	ff 75 08             	pushl  0x8(%ebp)
  8013ea:	e8 30 fc ff ff       	call   80101f <fd_lookup>
  8013ef:	83 c4 10             	add    $0x10,%esp
  8013f2:	85 c0                	test   %eax,%eax
  8013f4:	78 0e                	js     801404 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8013f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fc:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	53                   	push   %ebx
  80140a:	83 ec 1c             	sub    $0x1c,%esp
  80140d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801410:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801413:	50                   	push   %eax
  801414:	53                   	push   %ebx
  801415:	e8 05 fc ff ff       	call   80101f <fd_lookup>
  80141a:	83 c4 10             	add    $0x10,%esp
  80141d:	85 c0                	test   %eax,%eax
  80141f:	78 37                	js     801458 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801421:	83 ec 08             	sub    $0x8,%esp
  801424:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801427:	50                   	push   %eax
  801428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142b:	ff 30                	pushl  (%eax)
  80142d:	e8 3d fc ff ff       	call   80106f <dev_lookup>
  801432:	83 c4 10             	add    $0x10,%esp
  801435:	85 c0                	test   %eax,%eax
  801437:	78 1f                	js     801458 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801440:	74 1b                	je     80145d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801442:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801445:	8b 52 18             	mov    0x18(%edx),%edx
  801448:	85 d2                	test   %edx,%edx
  80144a:	74 32                	je     80147e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	50                   	push   %eax
  801453:	ff d2                	call   *%edx
  801455:	83 c4 10             	add    $0x10,%esp
}
  801458:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80145d:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801462:	8b 40 48             	mov    0x48(%eax),%eax
  801465:	83 ec 04             	sub    $0x4,%esp
  801468:	53                   	push   %ebx
  801469:	50                   	push   %eax
  80146a:	68 f4 28 80 00       	push   $0x8028f4
  80146f:	e8 ec ec ff ff       	call   800160 <cprintf>
		return -E_INVAL;
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80147c:	eb da                	jmp    801458 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80147e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801483:	eb d3                	jmp    801458 <ftruncate+0x52>

00801485 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	53                   	push   %ebx
  801489:	83 ec 1c             	sub    $0x1c,%esp
  80148c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80148f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801492:	50                   	push   %eax
  801493:	ff 75 08             	pushl  0x8(%ebp)
  801496:	e8 84 fb ff ff       	call   80101f <fd_lookup>
  80149b:	83 c4 10             	add    $0x10,%esp
  80149e:	85 c0                	test   %eax,%eax
  8014a0:	78 4b                	js     8014ed <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a2:	83 ec 08             	sub    $0x8,%esp
  8014a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a8:	50                   	push   %eax
  8014a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ac:	ff 30                	pushl  (%eax)
  8014ae:	e8 bc fb ff ff       	call   80106f <dev_lookup>
  8014b3:	83 c4 10             	add    $0x10,%esp
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	78 33                	js     8014ed <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bd:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014c1:	74 2f                	je     8014f2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014c3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014c6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014cd:	00 00 00 
	stat->st_isdir = 0;
  8014d0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014d7:	00 00 00 
	stat->st_dev = dev;
  8014da:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014e0:	83 ec 08             	sub    $0x8,%esp
  8014e3:	53                   	push   %ebx
  8014e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8014e7:	ff 50 14             	call   *0x14(%eax)
  8014ea:	83 c4 10             	add    $0x10,%esp
}
  8014ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    
		return -E_NOT_SUPP;
  8014f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014f7:	eb f4                	jmp    8014ed <fstat+0x68>

008014f9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	56                   	push   %esi
  8014fd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014fe:	83 ec 08             	sub    $0x8,%esp
  801501:	6a 00                	push   $0x0
  801503:	ff 75 08             	pushl  0x8(%ebp)
  801506:	e8 22 02 00 00       	call   80172d <open>
  80150b:	89 c3                	mov    %eax,%ebx
  80150d:	83 c4 10             	add    $0x10,%esp
  801510:	85 c0                	test   %eax,%eax
  801512:	78 1b                	js     80152f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801514:	83 ec 08             	sub    $0x8,%esp
  801517:	ff 75 0c             	pushl  0xc(%ebp)
  80151a:	50                   	push   %eax
  80151b:	e8 65 ff ff ff       	call   801485 <fstat>
  801520:	89 c6                	mov    %eax,%esi
	close(fd);
  801522:	89 1c 24             	mov    %ebx,(%esp)
  801525:	e8 27 fc ff ff       	call   801151 <close>
	return r;
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	89 f3                	mov    %esi,%ebx
}
  80152f:	89 d8                	mov    %ebx,%eax
  801531:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801534:	5b                   	pop    %ebx
  801535:	5e                   	pop    %esi
  801536:	5d                   	pop    %ebp
  801537:	c3                   	ret    

00801538 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	56                   	push   %esi
  80153c:	53                   	push   %ebx
  80153d:	89 c6                	mov    %eax,%esi
  80153f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801541:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801548:	74 27                	je     801571 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80154a:	6a 07                	push   $0x7
  80154c:	68 00 50 80 00       	push   $0x805000
  801551:	56                   	push   %esi
  801552:	ff 35 00 40 80 00    	pushl  0x804000
  801558:	e8 69 0c 00 00       	call   8021c6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80155d:	83 c4 0c             	add    $0xc,%esp
  801560:	6a 00                	push   $0x0
  801562:	53                   	push   %ebx
  801563:	6a 00                	push   $0x0
  801565:	e8 f3 0b 00 00       	call   80215d <ipc_recv>
}
  80156a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80156d:	5b                   	pop    %ebx
  80156e:	5e                   	pop    %esi
  80156f:	5d                   	pop    %ebp
  801570:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801571:	83 ec 0c             	sub    $0xc,%esp
  801574:	6a 01                	push   $0x1
  801576:	e8 a3 0c 00 00       	call   80221e <ipc_find_env>
  80157b:	a3 00 40 80 00       	mov    %eax,0x804000
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	eb c5                	jmp    80154a <fsipc+0x12>

00801585 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8b 40 0c             	mov    0xc(%eax),%eax
  801591:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801596:	8b 45 0c             	mov    0xc(%ebp),%eax
  801599:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80159e:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a3:	b8 02 00 00 00       	mov    $0x2,%eax
  8015a8:	e8 8b ff ff ff       	call   801538 <fsipc>
}
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <devfile_flush>:
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
  8015b2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8015bb:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c5:	b8 06 00 00 00       	mov    $0x6,%eax
  8015ca:	e8 69 ff ff ff       	call   801538 <fsipc>
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <devfile_stat>:
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	53                   	push   %ebx
  8015d5:	83 ec 04             	sub    $0x4,%esp
  8015d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8015eb:	b8 05 00 00 00       	mov    $0x5,%eax
  8015f0:	e8 43 ff ff ff       	call   801538 <fsipc>
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	78 2c                	js     801625 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015f9:	83 ec 08             	sub    $0x8,%esp
  8015fc:	68 00 50 80 00       	push   $0x805000
  801601:	53                   	push   %ebx
  801602:	e8 b8 f2 ff ff       	call   8008bf <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801607:	a1 80 50 80 00       	mov    0x805080,%eax
  80160c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801612:	a1 84 50 80 00       	mov    0x805084,%eax
  801617:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80161d:	83 c4 10             	add    $0x10,%esp
  801620:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801625:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <devfile_write>:
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	53                   	push   %ebx
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	8b 40 0c             	mov    0xc(%eax),%eax
  80163a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80163f:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801645:	53                   	push   %ebx
  801646:	ff 75 0c             	pushl  0xc(%ebp)
  801649:	68 08 50 80 00       	push   $0x805008
  80164e:	e8 5c f4 ff ff       	call   800aaf <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801653:	ba 00 00 00 00       	mov    $0x0,%edx
  801658:	b8 04 00 00 00       	mov    $0x4,%eax
  80165d:	e8 d6 fe ff ff       	call   801538 <fsipc>
  801662:	83 c4 10             	add    $0x10,%esp
  801665:	85 c0                	test   %eax,%eax
  801667:	78 0b                	js     801674 <devfile_write+0x4a>
	assert(r <= n);
  801669:	39 d8                	cmp    %ebx,%eax
  80166b:	77 0c                	ja     801679 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80166d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801672:	7f 1e                	jg     801692 <devfile_write+0x68>
}
  801674:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801677:	c9                   	leave  
  801678:	c3                   	ret    
	assert(r <= n);
  801679:	68 64 29 80 00       	push   $0x802964
  80167e:	68 6b 29 80 00       	push   $0x80296b
  801683:	68 98 00 00 00       	push   $0x98
  801688:	68 80 29 80 00       	push   $0x802980
  80168d:	e8 6a 0a 00 00       	call   8020fc <_panic>
	assert(r <= PGSIZE);
  801692:	68 8b 29 80 00       	push   $0x80298b
  801697:	68 6b 29 80 00       	push   $0x80296b
  80169c:	68 99 00 00 00       	push   $0x99
  8016a1:	68 80 29 80 00       	push   $0x802980
  8016a6:	e8 51 0a 00 00       	call   8020fc <_panic>

008016ab <devfile_read>:
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	56                   	push   %esi
  8016af:	53                   	push   %ebx
  8016b0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016be:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c9:	b8 03 00 00 00       	mov    $0x3,%eax
  8016ce:	e8 65 fe ff ff       	call   801538 <fsipc>
  8016d3:	89 c3                	mov    %eax,%ebx
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	78 1f                	js     8016f8 <devfile_read+0x4d>
	assert(r <= n);
  8016d9:	39 f0                	cmp    %esi,%eax
  8016db:	77 24                	ja     801701 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016dd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016e2:	7f 33                	jg     801717 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016e4:	83 ec 04             	sub    $0x4,%esp
  8016e7:	50                   	push   %eax
  8016e8:	68 00 50 80 00       	push   $0x805000
  8016ed:	ff 75 0c             	pushl  0xc(%ebp)
  8016f0:	e8 58 f3 ff ff       	call   800a4d <memmove>
	return r;
  8016f5:	83 c4 10             	add    $0x10,%esp
}
  8016f8:	89 d8                	mov    %ebx,%eax
  8016fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016fd:	5b                   	pop    %ebx
  8016fe:	5e                   	pop    %esi
  8016ff:	5d                   	pop    %ebp
  801700:	c3                   	ret    
	assert(r <= n);
  801701:	68 64 29 80 00       	push   $0x802964
  801706:	68 6b 29 80 00       	push   $0x80296b
  80170b:	6a 7c                	push   $0x7c
  80170d:	68 80 29 80 00       	push   $0x802980
  801712:	e8 e5 09 00 00       	call   8020fc <_panic>
	assert(r <= PGSIZE);
  801717:	68 8b 29 80 00       	push   $0x80298b
  80171c:	68 6b 29 80 00       	push   $0x80296b
  801721:	6a 7d                	push   $0x7d
  801723:	68 80 29 80 00       	push   $0x802980
  801728:	e8 cf 09 00 00       	call   8020fc <_panic>

0080172d <open>:
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	56                   	push   %esi
  801731:	53                   	push   %ebx
  801732:	83 ec 1c             	sub    $0x1c,%esp
  801735:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801738:	56                   	push   %esi
  801739:	e8 48 f1 ff ff       	call   800886 <strlen>
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801746:	7f 6c                	jg     8017b4 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801748:	83 ec 0c             	sub    $0xc,%esp
  80174b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174e:	50                   	push   %eax
  80174f:	e8 79 f8 ff ff       	call   800fcd <fd_alloc>
  801754:	89 c3                	mov    %eax,%ebx
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	85 c0                	test   %eax,%eax
  80175b:	78 3c                	js     801799 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80175d:	83 ec 08             	sub    $0x8,%esp
  801760:	56                   	push   %esi
  801761:	68 00 50 80 00       	push   $0x805000
  801766:	e8 54 f1 ff ff       	call   8008bf <strcpy>
	fsipcbuf.open.req_omode = mode;
  80176b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801773:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801776:	b8 01 00 00 00       	mov    $0x1,%eax
  80177b:	e8 b8 fd ff ff       	call   801538 <fsipc>
  801780:	89 c3                	mov    %eax,%ebx
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	85 c0                	test   %eax,%eax
  801787:	78 19                	js     8017a2 <open+0x75>
	return fd2num(fd);
  801789:	83 ec 0c             	sub    $0xc,%esp
  80178c:	ff 75 f4             	pushl  -0xc(%ebp)
  80178f:	e8 12 f8 ff ff       	call   800fa6 <fd2num>
  801794:	89 c3                	mov    %eax,%ebx
  801796:	83 c4 10             	add    $0x10,%esp
}
  801799:	89 d8                	mov    %ebx,%eax
  80179b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80179e:	5b                   	pop    %ebx
  80179f:	5e                   	pop    %esi
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    
		fd_close(fd, 0);
  8017a2:	83 ec 08             	sub    $0x8,%esp
  8017a5:	6a 00                	push   $0x0
  8017a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017aa:	e8 1b f9 ff ff       	call   8010ca <fd_close>
		return r;
  8017af:	83 c4 10             	add    $0x10,%esp
  8017b2:	eb e5                	jmp    801799 <open+0x6c>
		return -E_BAD_PATH;
  8017b4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017b9:	eb de                	jmp    801799 <open+0x6c>

008017bb <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c6:	b8 08 00 00 00       	mov    $0x8,%eax
  8017cb:	e8 68 fd ff ff       	call   801538 <fsipc>
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017d8:	68 97 29 80 00       	push   $0x802997
  8017dd:	ff 75 0c             	pushl  0xc(%ebp)
  8017e0:	e8 da f0 ff ff       	call   8008bf <strcpy>
	return 0;
}
  8017e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <devsock_close>:
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	53                   	push   %ebx
  8017f0:	83 ec 10             	sub    $0x10,%esp
  8017f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017f6:	53                   	push   %ebx
  8017f7:	e8 61 0a 00 00       	call   80225d <pageref>
  8017fc:	83 c4 10             	add    $0x10,%esp
		return 0;
  8017ff:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801804:	83 f8 01             	cmp    $0x1,%eax
  801807:	74 07                	je     801810 <devsock_close+0x24>
}
  801809:	89 d0                	mov    %edx,%eax
  80180b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801810:	83 ec 0c             	sub    $0xc,%esp
  801813:	ff 73 0c             	pushl  0xc(%ebx)
  801816:	e8 b9 02 00 00       	call   801ad4 <nsipc_close>
  80181b:	89 c2                	mov    %eax,%edx
  80181d:	83 c4 10             	add    $0x10,%esp
  801820:	eb e7                	jmp    801809 <devsock_close+0x1d>

00801822 <devsock_write>:
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801828:	6a 00                	push   $0x0
  80182a:	ff 75 10             	pushl  0x10(%ebp)
  80182d:	ff 75 0c             	pushl  0xc(%ebp)
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	ff 70 0c             	pushl  0xc(%eax)
  801836:	e8 76 03 00 00       	call   801bb1 <nsipc_send>
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <devsock_read>:
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801843:	6a 00                	push   $0x0
  801845:	ff 75 10             	pushl  0x10(%ebp)
  801848:	ff 75 0c             	pushl  0xc(%ebp)
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	ff 70 0c             	pushl  0xc(%eax)
  801851:	e8 ef 02 00 00       	call   801b45 <nsipc_recv>
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <fd2sockid>:
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80185e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801861:	52                   	push   %edx
  801862:	50                   	push   %eax
  801863:	e8 b7 f7 ff ff       	call   80101f <fd_lookup>
  801868:	83 c4 10             	add    $0x10,%esp
  80186b:	85 c0                	test   %eax,%eax
  80186d:	78 10                	js     80187f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80186f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801872:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801878:	39 08                	cmp    %ecx,(%eax)
  80187a:	75 05                	jne    801881 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80187c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    
		return -E_NOT_SUPP;
  801881:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801886:	eb f7                	jmp    80187f <fd2sockid+0x27>

00801888 <alloc_sockfd>:
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	56                   	push   %esi
  80188c:	53                   	push   %ebx
  80188d:	83 ec 1c             	sub    $0x1c,%esp
  801890:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801892:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801895:	50                   	push   %eax
  801896:	e8 32 f7 ff ff       	call   800fcd <fd_alloc>
  80189b:	89 c3                	mov    %eax,%ebx
  80189d:	83 c4 10             	add    $0x10,%esp
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	78 43                	js     8018e7 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018a4:	83 ec 04             	sub    $0x4,%esp
  8018a7:	68 07 04 00 00       	push   $0x407
  8018ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8018af:	6a 00                	push   $0x0
  8018b1:	e8 fb f3 ff ff       	call   800cb1 <sys_page_alloc>
  8018b6:	89 c3                	mov    %eax,%ebx
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	78 28                	js     8018e7 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c2:	8b 15 24 30 80 00    	mov    0x803024,%edx
  8018c8:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018d4:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018d7:	83 ec 0c             	sub    $0xc,%esp
  8018da:	50                   	push   %eax
  8018db:	e8 c6 f6 ff ff       	call   800fa6 <fd2num>
  8018e0:	89 c3                	mov    %eax,%ebx
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	eb 0c                	jmp    8018f3 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018e7:	83 ec 0c             	sub    $0xc,%esp
  8018ea:	56                   	push   %esi
  8018eb:	e8 e4 01 00 00       	call   801ad4 <nsipc_close>
		return r;
  8018f0:	83 c4 10             	add    $0x10,%esp
}
  8018f3:	89 d8                	mov    %ebx,%eax
  8018f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f8:	5b                   	pop    %ebx
  8018f9:	5e                   	pop    %esi
  8018fa:	5d                   	pop    %ebp
  8018fb:	c3                   	ret    

008018fc <accept>:
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	e8 4e ff ff ff       	call   801858 <fd2sockid>
  80190a:	85 c0                	test   %eax,%eax
  80190c:	78 1b                	js     801929 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80190e:	83 ec 04             	sub    $0x4,%esp
  801911:	ff 75 10             	pushl  0x10(%ebp)
  801914:	ff 75 0c             	pushl  0xc(%ebp)
  801917:	50                   	push   %eax
  801918:	e8 0e 01 00 00       	call   801a2b <nsipc_accept>
  80191d:	83 c4 10             	add    $0x10,%esp
  801920:	85 c0                	test   %eax,%eax
  801922:	78 05                	js     801929 <accept+0x2d>
	return alloc_sockfd(r);
  801924:	e8 5f ff ff ff       	call   801888 <alloc_sockfd>
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <bind>:
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	e8 1f ff ff ff       	call   801858 <fd2sockid>
  801939:	85 c0                	test   %eax,%eax
  80193b:	78 12                	js     80194f <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80193d:	83 ec 04             	sub    $0x4,%esp
  801940:	ff 75 10             	pushl  0x10(%ebp)
  801943:	ff 75 0c             	pushl  0xc(%ebp)
  801946:	50                   	push   %eax
  801947:	e8 31 01 00 00       	call   801a7d <nsipc_bind>
  80194c:	83 c4 10             	add    $0x10,%esp
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <shutdown>:
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	e8 f9 fe ff ff       	call   801858 <fd2sockid>
  80195f:	85 c0                	test   %eax,%eax
  801961:	78 0f                	js     801972 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801963:	83 ec 08             	sub    $0x8,%esp
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	50                   	push   %eax
  80196a:	e8 43 01 00 00       	call   801ab2 <nsipc_shutdown>
  80196f:	83 c4 10             	add    $0x10,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <connect>:
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	e8 d6 fe ff ff       	call   801858 <fd2sockid>
  801982:	85 c0                	test   %eax,%eax
  801984:	78 12                	js     801998 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801986:	83 ec 04             	sub    $0x4,%esp
  801989:	ff 75 10             	pushl  0x10(%ebp)
  80198c:	ff 75 0c             	pushl  0xc(%ebp)
  80198f:	50                   	push   %eax
  801990:	e8 59 01 00 00       	call   801aee <nsipc_connect>
  801995:	83 c4 10             	add    $0x10,%esp
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <listen>:
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	e8 b0 fe ff ff       	call   801858 <fd2sockid>
  8019a8:	85 c0                	test   %eax,%eax
  8019aa:	78 0f                	js     8019bb <listen+0x21>
	return nsipc_listen(r, backlog);
  8019ac:	83 ec 08             	sub    $0x8,%esp
  8019af:	ff 75 0c             	pushl  0xc(%ebp)
  8019b2:	50                   	push   %eax
  8019b3:	e8 6b 01 00 00       	call   801b23 <nsipc_listen>
  8019b8:	83 c4 10             	add    $0x10,%esp
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <socket>:

int
socket(int domain, int type, int protocol)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019c3:	ff 75 10             	pushl  0x10(%ebp)
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	ff 75 08             	pushl  0x8(%ebp)
  8019cc:	e8 3e 02 00 00       	call   801c0f <nsipc_socket>
  8019d1:	83 c4 10             	add    $0x10,%esp
  8019d4:	85 c0                	test   %eax,%eax
  8019d6:	78 05                	js     8019dd <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019d8:	e8 ab fe ff ff       	call   801888 <alloc_sockfd>
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	53                   	push   %ebx
  8019e3:	83 ec 04             	sub    $0x4,%esp
  8019e6:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019e8:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019ef:	74 26                	je     801a17 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019f1:	6a 07                	push   $0x7
  8019f3:	68 00 60 80 00       	push   $0x806000
  8019f8:	53                   	push   %ebx
  8019f9:	ff 35 04 40 80 00    	pushl  0x804004
  8019ff:	e8 c2 07 00 00       	call   8021c6 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a04:	83 c4 0c             	add    $0xc,%esp
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	e8 4b 07 00 00       	call   80215d <ipc_recv>
}
  801a12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a17:	83 ec 0c             	sub    $0xc,%esp
  801a1a:	6a 02                	push   $0x2
  801a1c:	e8 fd 07 00 00       	call   80221e <ipc_find_env>
  801a21:	a3 04 40 80 00       	mov    %eax,0x804004
  801a26:	83 c4 10             	add    $0x10,%esp
  801a29:	eb c6                	jmp    8019f1 <nsipc+0x12>

00801a2b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	56                   	push   %esi
  801a2f:	53                   	push   %ebx
  801a30:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a3b:	8b 06                	mov    (%esi),%eax
  801a3d:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a42:	b8 01 00 00 00       	mov    $0x1,%eax
  801a47:	e8 93 ff ff ff       	call   8019df <nsipc>
  801a4c:	89 c3                	mov    %eax,%ebx
  801a4e:	85 c0                	test   %eax,%eax
  801a50:	79 09                	jns    801a5b <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a52:	89 d8                	mov    %ebx,%eax
  801a54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5d                   	pop    %ebp
  801a5a:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a5b:	83 ec 04             	sub    $0x4,%esp
  801a5e:	ff 35 10 60 80 00    	pushl  0x806010
  801a64:	68 00 60 80 00       	push   $0x806000
  801a69:	ff 75 0c             	pushl  0xc(%ebp)
  801a6c:	e8 dc ef ff ff       	call   800a4d <memmove>
		*addrlen = ret->ret_addrlen;
  801a71:	a1 10 60 80 00       	mov    0x806010,%eax
  801a76:	89 06                	mov    %eax,(%esi)
  801a78:	83 c4 10             	add    $0x10,%esp
	return r;
  801a7b:	eb d5                	jmp    801a52 <nsipc_accept+0x27>

00801a7d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	53                   	push   %ebx
  801a81:	83 ec 08             	sub    $0x8,%esp
  801a84:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a8f:	53                   	push   %ebx
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	68 04 60 80 00       	push   $0x806004
  801a98:	e8 b0 ef ff ff       	call   800a4d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a9d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801aa3:	b8 02 00 00 00       	mov    $0x2,%eax
  801aa8:	e8 32 ff ff ff       	call   8019df <nsipc>
}
  801aad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ac0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac3:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ac8:	b8 03 00 00 00       	mov    $0x3,%eax
  801acd:	e8 0d ff ff ff       	call   8019df <nsipc>
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <nsipc_close>:

int
nsipc_close(int s)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ae2:	b8 04 00 00 00       	mov    $0x4,%eax
  801ae7:	e8 f3 fe ff ff       	call   8019df <nsipc>
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	53                   	push   %ebx
  801af2:	83 ec 08             	sub    $0x8,%esp
  801af5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801af8:	8b 45 08             	mov    0x8(%ebp),%eax
  801afb:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b00:	53                   	push   %ebx
  801b01:	ff 75 0c             	pushl  0xc(%ebp)
  801b04:	68 04 60 80 00       	push   $0x806004
  801b09:	e8 3f ef ff ff       	call   800a4d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b0e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b14:	b8 05 00 00 00       	mov    $0x5,%eax
  801b19:	e8 c1 fe ff ff       	call   8019df <nsipc>
}
  801b1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
  801b26:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b34:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b39:	b8 06 00 00 00       	mov    $0x6,%eax
  801b3e:	e8 9c fe ff ff       	call   8019df <nsipc>
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	56                   	push   %esi
  801b49:	53                   	push   %ebx
  801b4a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b55:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b5b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5e:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b63:	b8 07 00 00 00       	mov    $0x7,%eax
  801b68:	e8 72 fe ff ff       	call   8019df <nsipc>
  801b6d:	89 c3                	mov    %eax,%ebx
  801b6f:	85 c0                	test   %eax,%eax
  801b71:	78 1f                	js     801b92 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b73:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b78:	7f 21                	jg     801b9b <nsipc_recv+0x56>
  801b7a:	39 c6                	cmp    %eax,%esi
  801b7c:	7c 1d                	jl     801b9b <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b7e:	83 ec 04             	sub    $0x4,%esp
  801b81:	50                   	push   %eax
  801b82:	68 00 60 80 00       	push   $0x806000
  801b87:	ff 75 0c             	pushl  0xc(%ebp)
  801b8a:	e8 be ee ff ff       	call   800a4d <memmove>
  801b8f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b92:	89 d8                	mov    %ebx,%eax
  801b94:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b97:	5b                   	pop    %ebx
  801b98:	5e                   	pop    %esi
  801b99:	5d                   	pop    %ebp
  801b9a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801b9b:	68 a3 29 80 00       	push   $0x8029a3
  801ba0:	68 6b 29 80 00       	push   $0x80296b
  801ba5:	6a 62                	push   $0x62
  801ba7:	68 b8 29 80 00       	push   $0x8029b8
  801bac:	e8 4b 05 00 00       	call   8020fc <_panic>

00801bb1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	53                   	push   %ebx
  801bb5:	83 ec 04             	sub    $0x4,%esp
  801bb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bc3:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bc9:	7f 2e                	jg     801bf9 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bcb:	83 ec 04             	sub    $0x4,%esp
  801bce:	53                   	push   %ebx
  801bcf:	ff 75 0c             	pushl  0xc(%ebp)
  801bd2:	68 0c 60 80 00       	push   $0x80600c
  801bd7:	e8 71 ee ff ff       	call   800a4d <memmove>
	nsipcbuf.send.req_size = size;
  801bdc:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801be2:	8b 45 14             	mov    0x14(%ebp),%eax
  801be5:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801bea:	b8 08 00 00 00       	mov    $0x8,%eax
  801bef:	e8 eb fd ff ff       	call   8019df <nsipc>
}
  801bf4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    
	assert(size < 1600);
  801bf9:	68 c4 29 80 00       	push   $0x8029c4
  801bfe:	68 6b 29 80 00       	push   $0x80296b
  801c03:	6a 6d                	push   $0x6d
  801c05:	68 b8 29 80 00       	push   $0x8029b8
  801c0a:	e8 ed 04 00 00       	call   8020fc <_panic>

00801c0f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
  801c12:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c20:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c25:	8b 45 10             	mov    0x10(%ebp),%eax
  801c28:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c2d:	b8 09 00 00 00       	mov    $0x9,%eax
  801c32:	e8 a8 fd ff ff       	call   8019df <nsipc>
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	56                   	push   %esi
  801c3d:	53                   	push   %ebx
  801c3e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c41:	83 ec 0c             	sub    $0xc,%esp
  801c44:	ff 75 08             	pushl  0x8(%ebp)
  801c47:	e8 6a f3 ff ff       	call   800fb6 <fd2data>
  801c4c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c4e:	83 c4 08             	add    $0x8,%esp
  801c51:	68 d0 29 80 00       	push   $0x8029d0
  801c56:	53                   	push   %ebx
  801c57:	e8 63 ec ff ff       	call   8008bf <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c5c:	8b 46 04             	mov    0x4(%esi),%eax
  801c5f:	2b 06                	sub    (%esi),%eax
  801c61:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c67:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c6e:	00 00 00 
	stat->st_dev = &devpipe;
  801c71:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  801c78:	30 80 00 
	return 0;
}
  801c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c83:	5b                   	pop    %ebx
  801c84:	5e                   	pop    %esi
  801c85:	5d                   	pop    %ebp
  801c86:	c3                   	ret    

00801c87 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	53                   	push   %ebx
  801c8b:	83 ec 0c             	sub    $0xc,%esp
  801c8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c91:	53                   	push   %ebx
  801c92:	6a 00                	push   $0x0
  801c94:	e8 9d f0 ff ff       	call   800d36 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c99:	89 1c 24             	mov    %ebx,(%esp)
  801c9c:	e8 15 f3 ff ff       	call   800fb6 <fd2data>
  801ca1:	83 c4 08             	add    $0x8,%esp
  801ca4:	50                   	push   %eax
  801ca5:	6a 00                	push   $0x0
  801ca7:	e8 8a f0 ff ff       	call   800d36 <sys_page_unmap>
}
  801cac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <_pipeisclosed>:
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	57                   	push   %edi
  801cb5:	56                   	push   %esi
  801cb6:	53                   	push   %ebx
  801cb7:	83 ec 1c             	sub    $0x1c,%esp
  801cba:	89 c7                	mov    %eax,%edi
  801cbc:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cbe:	a1 08 40 80 00       	mov    0x804008,%eax
  801cc3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cc6:	83 ec 0c             	sub    $0xc,%esp
  801cc9:	57                   	push   %edi
  801cca:	e8 8e 05 00 00       	call   80225d <pageref>
  801ccf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cd2:	89 34 24             	mov    %esi,(%esp)
  801cd5:	e8 83 05 00 00       	call   80225d <pageref>
		nn = thisenv->env_runs;
  801cda:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ce0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ce3:	83 c4 10             	add    $0x10,%esp
  801ce6:	39 cb                	cmp    %ecx,%ebx
  801ce8:	74 1b                	je     801d05 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cea:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ced:	75 cf                	jne    801cbe <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cef:	8b 42 58             	mov    0x58(%edx),%eax
  801cf2:	6a 01                	push   $0x1
  801cf4:	50                   	push   %eax
  801cf5:	53                   	push   %ebx
  801cf6:	68 d7 29 80 00       	push   $0x8029d7
  801cfb:	e8 60 e4 ff ff       	call   800160 <cprintf>
  801d00:	83 c4 10             	add    $0x10,%esp
  801d03:	eb b9                	jmp    801cbe <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d05:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d08:	0f 94 c0             	sete   %al
  801d0b:	0f b6 c0             	movzbl %al,%eax
}
  801d0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d11:	5b                   	pop    %ebx
  801d12:	5e                   	pop    %esi
  801d13:	5f                   	pop    %edi
  801d14:	5d                   	pop    %ebp
  801d15:	c3                   	ret    

00801d16 <devpipe_write>:
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	57                   	push   %edi
  801d1a:	56                   	push   %esi
  801d1b:	53                   	push   %ebx
  801d1c:	83 ec 28             	sub    $0x28,%esp
  801d1f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d22:	56                   	push   %esi
  801d23:	e8 8e f2 ff ff       	call   800fb6 <fd2data>
  801d28:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d2a:	83 c4 10             	add    $0x10,%esp
  801d2d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d32:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d35:	74 4f                	je     801d86 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d37:	8b 43 04             	mov    0x4(%ebx),%eax
  801d3a:	8b 0b                	mov    (%ebx),%ecx
  801d3c:	8d 51 20             	lea    0x20(%ecx),%edx
  801d3f:	39 d0                	cmp    %edx,%eax
  801d41:	72 14                	jb     801d57 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d43:	89 da                	mov    %ebx,%edx
  801d45:	89 f0                	mov    %esi,%eax
  801d47:	e8 65 ff ff ff       	call   801cb1 <_pipeisclosed>
  801d4c:	85 c0                	test   %eax,%eax
  801d4e:	75 3b                	jne    801d8b <devpipe_write+0x75>
			sys_yield();
  801d50:	e8 3d ef ff ff       	call   800c92 <sys_yield>
  801d55:	eb e0                	jmp    801d37 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d5a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d5e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d61:	89 c2                	mov    %eax,%edx
  801d63:	c1 fa 1f             	sar    $0x1f,%edx
  801d66:	89 d1                	mov    %edx,%ecx
  801d68:	c1 e9 1b             	shr    $0x1b,%ecx
  801d6b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d6e:	83 e2 1f             	and    $0x1f,%edx
  801d71:	29 ca                	sub    %ecx,%edx
  801d73:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d77:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d7b:	83 c0 01             	add    $0x1,%eax
  801d7e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d81:	83 c7 01             	add    $0x1,%edi
  801d84:	eb ac                	jmp    801d32 <devpipe_write+0x1c>
	return i;
  801d86:	8b 45 10             	mov    0x10(%ebp),%eax
  801d89:	eb 05                	jmp    801d90 <devpipe_write+0x7a>
				return 0;
  801d8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d93:	5b                   	pop    %ebx
  801d94:	5e                   	pop    %esi
  801d95:	5f                   	pop    %edi
  801d96:	5d                   	pop    %ebp
  801d97:	c3                   	ret    

00801d98 <devpipe_read>:
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	57                   	push   %edi
  801d9c:	56                   	push   %esi
  801d9d:	53                   	push   %ebx
  801d9e:	83 ec 18             	sub    $0x18,%esp
  801da1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801da4:	57                   	push   %edi
  801da5:	e8 0c f2 ff ff       	call   800fb6 <fd2data>
  801daa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dac:	83 c4 10             	add    $0x10,%esp
  801daf:	be 00 00 00 00       	mov    $0x0,%esi
  801db4:	3b 75 10             	cmp    0x10(%ebp),%esi
  801db7:	75 14                	jne    801dcd <devpipe_read+0x35>
	return i;
  801db9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dbc:	eb 02                	jmp    801dc0 <devpipe_read+0x28>
				return i;
  801dbe:	89 f0                	mov    %esi,%eax
}
  801dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dc3:	5b                   	pop    %ebx
  801dc4:	5e                   	pop    %esi
  801dc5:	5f                   	pop    %edi
  801dc6:	5d                   	pop    %ebp
  801dc7:	c3                   	ret    
			sys_yield();
  801dc8:	e8 c5 ee ff ff       	call   800c92 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801dcd:	8b 03                	mov    (%ebx),%eax
  801dcf:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dd2:	75 18                	jne    801dec <devpipe_read+0x54>
			if (i > 0)
  801dd4:	85 f6                	test   %esi,%esi
  801dd6:	75 e6                	jne    801dbe <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801dd8:	89 da                	mov    %ebx,%edx
  801dda:	89 f8                	mov    %edi,%eax
  801ddc:	e8 d0 fe ff ff       	call   801cb1 <_pipeisclosed>
  801de1:	85 c0                	test   %eax,%eax
  801de3:	74 e3                	je     801dc8 <devpipe_read+0x30>
				return 0;
  801de5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dea:	eb d4                	jmp    801dc0 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dec:	99                   	cltd   
  801ded:	c1 ea 1b             	shr    $0x1b,%edx
  801df0:	01 d0                	add    %edx,%eax
  801df2:	83 e0 1f             	and    $0x1f,%eax
  801df5:	29 d0                	sub    %edx,%eax
  801df7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801dfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dff:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e02:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e05:	83 c6 01             	add    $0x1,%esi
  801e08:	eb aa                	jmp    801db4 <devpipe_read+0x1c>

00801e0a <pipe>:
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	56                   	push   %esi
  801e0e:	53                   	push   %ebx
  801e0f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e12:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e15:	50                   	push   %eax
  801e16:	e8 b2 f1 ff ff       	call   800fcd <fd_alloc>
  801e1b:	89 c3                	mov    %eax,%ebx
  801e1d:	83 c4 10             	add    $0x10,%esp
  801e20:	85 c0                	test   %eax,%eax
  801e22:	0f 88 23 01 00 00    	js     801f4b <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e28:	83 ec 04             	sub    $0x4,%esp
  801e2b:	68 07 04 00 00       	push   $0x407
  801e30:	ff 75 f4             	pushl  -0xc(%ebp)
  801e33:	6a 00                	push   $0x0
  801e35:	e8 77 ee ff ff       	call   800cb1 <sys_page_alloc>
  801e3a:	89 c3                	mov    %eax,%ebx
  801e3c:	83 c4 10             	add    $0x10,%esp
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	0f 88 04 01 00 00    	js     801f4b <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e47:	83 ec 0c             	sub    $0xc,%esp
  801e4a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e4d:	50                   	push   %eax
  801e4e:	e8 7a f1 ff ff       	call   800fcd <fd_alloc>
  801e53:	89 c3                	mov    %eax,%ebx
  801e55:	83 c4 10             	add    $0x10,%esp
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	0f 88 db 00 00 00    	js     801f3b <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e60:	83 ec 04             	sub    $0x4,%esp
  801e63:	68 07 04 00 00       	push   $0x407
  801e68:	ff 75 f0             	pushl  -0x10(%ebp)
  801e6b:	6a 00                	push   $0x0
  801e6d:	e8 3f ee ff ff       	call   800cb1 <sys_page_alloc>
  801e72:	89 c3                	mov    %eax,%ebx
  801e74:	83 c4 10             	add    $0x10,%esp
  801e77:	85 c0                	test   %eax,%eax
  801e79:	0f 88 bc 00 00 00    	js     801f3b <pipe+0x131>
	va = fd2data(fd0);
  801e7f:	83 ec 0c             	sub    $0xc,%esp
  801e82:	ff 75 f4             	pushl  -0xc(%ebp)
  801e85:	e8 2c f1 ff ff       	call   800fb6 <fd2data>
  801e8a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e8c:	83 c4 0c             	add    $0xc,%esp
  801e8f:	68 07 04 00 00       	push   $0x407
  801e94:	50                   	push   %eax
  801e95:	6a 00                	push   $0x0
  801e97:	e8 15 ee ff ff       	call   800cb1 <sys_page_alloc>
  801e9c:	89 c3                	mov    %eax,%ebx
  801e9e:	83 c4 10             	add    $0x10,%esp
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	0f 88 82 00 00 00    	js     801f2b <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea9:	83 ec 0c             	sub    $0xc,%esp
  801eac:	ff 75 f0             	pushl  -0x10(%ebp)
  801eaf:	e8 02 f1 ff ff       	call   800fb6 <fd2data>
  801eb4:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ebb:	50                   	push   %eax
  801ebc:	6a 00                	push   $0x0
  801ebe:	56                   	push   %esi
  801ebf:	6a 00                	push   $0x0
  801ec1:	e8 2e ee ff ff       	call   800cf4 <sys_page_map>
  801ec6:	89 c3                	mov    %eax,%ebx
  801ec8:	83 c4 20             	add    $0x20,%esp
  801ecb:	85 c0                	test   %eax,%eax
  801ecd:	78 4e                	js     801f1d <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ecf:	a1 40 30 80 00       	mov    0x803040,%eax
  801ed4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed7:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edc:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ee3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ee6:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eeb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ef2:	83 ec 0c             	sub    $0xc,%esp
  801ef5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef8:	e8 a9 f0 ff ff       	call   800fa6 <fd2num>
  801efd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f00:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f02:	83 c4 04             	add    $0x4,%esp
  801f05:	ff 75 f0             	pushl  -0x10(%ebp)
  801f08:	e8 99 f0 ff ff       	call   800fa6 <fd2num>
  801f0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f10:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f13:	83 c4 10             	add    $0x10,%esp
  801f16:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f1b:	eb 2e                	jmp    801f4b <pipe+0x141>
	sys_page_unmap(0, va);
  801f1d:	83 ec 08             	sub    $0x8,%esp
  801f20:	56                   	push   %esi
  801f21:	6a 00                	push   $0x0
  801f23:	e8 0e ee ff ff       	call   800d36 <sys_page_unmap>
  801f28:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f2b:	83 ec 08             	sub    $0x8,%esp
  801f2e:	ff 75 f0             	pushl  -0x10(%ebp)
  801f31:	6a 00                	push   $0x0
  801f33:	e8 fe ed ff ff       	call   800d36 <sys_page_unmap>
  801f38:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f3b:	83 ec 08             	sub    $0x8,%esp
  801f3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f41:	6a 00                	push   $0x0
  801f43:	e8 ee ed ff ff       	call   800d36 <sys_page_unmap>
  801f48:	83 c4 10             	add    $0x10,%esp
}
  801f4b:	89 d8                	mov    %ebx,%eax
  801f4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f50:	5b                   	pop    %ebx
  801f51:	5e                   	pop    %esi
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    

00801f54 <pipeisclosed>:
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f5d:	50                   	push   %eax
  801f5e:	ff 75 08             	pushl  0x8(%ebp)
  801f61:	e8 b9 f0 ff ff       	call   80101f <fd_lookup>
  801f66:	83 c4 10             	add    $0x10,%esp
  801f69:	85 c0                	test   %eax,%eax
  801f6b:	78 18                	js     801f85 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f6d:	83 ec 0c             	sub    $0xc,%esp
  801f70:	ff 75 f4             	pushl  -0xc(%ebp)
  801f73:	e8 3e f0 ff ff       	call   800fb6 <fd2data>
	return _pipeisclosed(fd, p);
  801f78:	89 c2                	mov    %eax,%edx
  801f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7d:	e8 2f fd ff ff       	call   801cb1 <_pipeisclosed>
  801f82:	83 c4 10             	add    $0x10,%esp
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8c:	c3                   	ret    

00801f8d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f93:	68 ef 29 80 00       	push   $0x8029ef
  801f98:	ff 75 0c             	pushl  0xc(%ebp)
  801f9b:	e8 1f e9 ff ff       	call   8008bf <strcpy>
	return 0;
}
  801fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <devcons_write>:
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	57                   	push   %edi
  801fab:	56                   	push   %esi
  801fac:	53                   	push   %ebx
  801fad:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fb3:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fb8:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fbe:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fc1:	73 31                	jae    801ff4 <devcons_write+0x4d>
		m = n - tot;
  801fc3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fc6:	29 f3                	sub    %esi,%ebx
  801fc8:	83 fb 7f             	cmp    $0x7f,%ebx
  801fcb:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fd0:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fd3:	83 ec 04             	sub    $0x4,%esp
  801fd6:	53                   	push   %ebx
  801fd7:	89 f0                	mov    %esi,%eax
  801fd9:	03 45 0c             	add    0xc(%ebp),%eax
  801fdc:	50                   	push   %eax
  801fdd:	57                   	push   %edi
  801fde:	e8 6a ea ff ff       	call   800a4d <memmove>
		sys_cputs(buf, m);
  801fe3:	83 c4 08             	add    $0x8,%esp
  801fe6:	53                   	push   %ebx
  801fe7:	57                   	push   %edi
  801fe8:	e8 08 ec ff ff       	call   800bf5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fed:	01 de                	add    %ebx,%esi
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	eb ca                	jmp    801fbe <devcons_write+0x17>
}
  801ff4:	89 f0                	mov    %esi,%eax
  801ff6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ff9:	5b                   	pop    %ebx
  801ffa:	5e                   	pop    %esi
  801ffb:	5f                   	pop    %edi
  801ffc:	5d                   	pop    %ebp
  801ffd:	c3                   	ret    

00801ffe <devcons_read>:
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 08             	sub    $0x8,%esp
  802004:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802009:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80200d:	74 21                	je     802030 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80200f:	e8 ff eb ff ff       	call   800c13 <sys_cgetc>
  802014:	85 c0                	test   %eax,%eax
  802016:	75 07                	jne    80201f <devcons_read+0x21>
		sys_yield();
  802018:	e8 75 ec ff ff       	call   800c92 <sys_yield>
  80201d:	eb f0                	jmp    80200f <devcons_read+0x11>
	if (c < 0)
  80201f:	78 0f                	js     802030 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802021:	83 f8 04             	cmp    $0x4,%eax
  802024:	74 0c                	je     802032 <devcons_read+0x34>
	*(char*)vbuf = c;
  802026:	8b 55 0c             	mov    0xc(%ebp),%edx
  802029:	88 02                	mov    %al,(%edx)
	return 1;
  80202b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    
		return 0;
  802032:	b8 00 00 00 00       	mov    $0x0,%eax
  802037:	eb f7                	jmp    802030 <devcons_read+0x32>

00802039 <cputchar>:
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802045:	6a 01                	push   $0x1
  802047:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80204a:	50                   	push   %eax
  80204b:	e8 a5 eb ff ff       	call   800bf5 <sys_cputs>
}
  802050:	83 c4 10             	add    $0x10,%esp
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <getchar>:
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80205b:	6a 01                	push   $0x1
  80205d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802060:	50                   	push   %eax
  802061:	6a 00                	push   $0x0
  802063:	e8 27 f2 ff ff       	call   80128f <read>
	if (r < 0)
  802068:	83 c4 10             	add    $0x10,%esp
  80206b:	85 c0                	test   %eax,%eax
  80206d:	78 06                	js     802075 <getchar+0x20>
	if (r < 1)
  80206f:	74 06                	je     802077 <getchar+0x22>
	return c;
  802071:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    
		return -E_EOF;
  802077:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80207c:	eb f7                	jmp    802075 <getchar+0x20>

0080207e <iscons>:
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802084:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802087:	50                   	push   %eax
  802088:	ff 75 08             	pushl  0x8(%ebp)
  80208b:	e8 8f ef ff ff       	call   80101f <fd_lookup>
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	85 c0                	test   %eax,%eax
  802095:	78 11                	js     8020a8 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209a:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8020a0:	39 10                	cmp    %edx,(%eax)
  8020a2:	0f 94 c0             	sete   %al
  8020a5:	0f b6 c0             	movzbl %al,%eax
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <opencons>:
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020b3:	50                   	push   %eax
  8020b4:	e8 14 ef ff ff       	call   800fcd <fd_alloc>
  8020b9:	83 c4 10             	add    $0x10,%esp
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	78 3a                	js     8020fa <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020c0:	83 ec 04             	sub    $0x4,%esp
  8020c3:	68 07 04 00 00       	push   $0x407
  8020c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8020cb:	6a 00                	push   $0x0
  8020cd:	e8 df eb ff ff       	call   800cb1 <sys_page_alloc>
  8020d2:	83 c4 10             	add    $0x10,%esp
  8020d5:	85 c0                	test   %eax,%eax
  8020d7:	78 21                	js     8020fa <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8020e2:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020ee:	83 ec 0c             	sub    $0xc,%esp
  8020f1:	50                   	push   %eax
  8020f2:	e8 af ee ff ff       	call   800fa6 <fd2num>
  8020f7:	83 c4 10             	add    $0x10,%esp
}
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
  8020ff:	56                   	push   %esi
  802100:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802101:	a1 08 40 80 00       	mov    0x804008,%eax
  802106:	8b 40 48             	mov    0x48(%eax),%eax
  802109:	83 ec 04             	sub    $0x4,%esp
  80210c:	68 20 2a 80 00       	push   $0x802a20
  802111:	50                   	push   %eax
  802112:	68 18 25 80 00       	push   $0x802518
  802117:	e8 44 e0 ff ff       	call   800160 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80211c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80211f:	8b 35 04 30 80 00    	mov    0x803004,%esi
  802125:	e8 49 eb ff ff       	call   800c73 <sys_getenvid>
  80212a:	83 c4 04             	add    $0x4,%esp
  80212d:	ff 75 0c             	pushl  0xc(%ebp)
  802130:	ff 75 08             	pushl  0x8(%ebp)
  802133:	56                   	push   %esi
  802134:	50                   	push   %eax
  802135:	68 fc 29 80 00       	push   $0x8029fc
  80213a:	e8 21 e0 ff ff       	call   800160 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80213f:	83 c4 18             	add    $0x18,%esp
  802142:	53                   	push   %ebx
  802143:	ff 75 10             	pushl  0x10(%ebp)
  802146:	e8 c4 df ff ff       	call   80010f <vcprintf>
	cprintf("\n");
  80214b:	c7 04 24 3a 2a 80 00 	movl   $0x802a3a,(%esp)
  802152:	e8 09 e0 ff ff       	call   800160 <cprintf>
  802157:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80215a:	cc                   	int3   
  80215b:	eb fd                	jmp    80215a <_panic+0x5e>

0080215d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	56                   	push   %esi
  802161:	53                   	push   %ebx
  802162:	8b 75 08             	mov    0x8(%ebp),%esi
  802165:	8b 45 0c             	mov    0xc(%ebp),%eax
  802168:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80216b:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80216d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802172:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802175:	83 ec 0c             	sub    $0xc,%esp
  802178:	50                   	push   %eax
  802179:	e8 e3 ec ff ff       	call   800e61 <sys_ipc_recv>
	if(ret < 0){
  80217e:	83 c4 10             	add    $0x10,%esp
  802181:	85 c0                	test   %eax,%eax
  802183:	78 2b                	js     8021b0 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802185:	85 f6                	test   %esi,%esi
  802187:	74 0a                	je     802193 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802189:	a1 08 40 80 00       	mov    0x804008,%eax
  80218e:	8b 40 78             	mov    0x78(%eax),%eax
  802191:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802193:	85 db                	test   %ebx,%ebx
  802195:	74 0a                	je     8021a1 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802197:	a1 08 40 80 00       	mov    0x804008,%eax
  80219c:	8b 40 7c             	mov    0x7c(%eax),%eax
  80219f:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8021a1:	a1 08 40 80 00       	mov    0x804008,%eax
  8021a6:	8b 40 74             	mov    0x74(%eax),%eax
}
  8021a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ac:	5b                   	pop    %ebx
  8021ad:	5e                   	pop    %esi
  8021ae:	5d                   	pop    %ebp
  8021af:	c3                   	ret    
		if(from_env_store)
  8021b0:	85 f6                	test   %esi,%esi
  8021b2:	74 06                	je     8021ba <ipc_recv+0x5d>
			*from_env_store = 0;
  8021b4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021ba:	85 db                	test   %ebx,%ebx
  8021bc:	74 eb                	je     8021a9 <ipc_recv+0x4c>
			*perm_store = 0;
  8021be:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021c4:	eb e3                	jmp    8021a9 <ipc_recv+0x4c>

008021c6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	57                   	push   %edi
  8021ca:	56                   	push   %esi
  8021cb:	53                   	push   %ebx
  8021cc:	83 ec 0c             	sub    $0xc,%esp
  8021cf:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021d2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021d8:	85 db                	test   %ebx,%ebx
  8021da:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021df:	0f 44 d8             	cmove  %eax,%ebx
  8021e2:	eb 05                	jmp    8021e9 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8021e4:	e8 a9 ea ff ff       	call   800c92 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8021e9:	ff 75 14             	pushl  0x14(%ebp)
  8021ec:	53                   	push   %ebx
  8021ed:	56                   	push   %esi
  8021ee:	57                   	push   %edi
  8021ef:	e8 4a ec ff ff       	call   800e3e <sys_ipc_try_send>
  8021f4:	83 c4 10             	add    $0x10,%esp
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	74 1b                	je     802216 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8021fb:	79 e7                	jns    8021e4 <ipc_send+0x1e>
  8021fd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802200:	74 e2                	je     8021e4 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802202:	83 ec 04             	sub    $0x4,%esp
  802205:	68 27 2a 80 00       	push   $0x802a27
  80220a:	6a 46                	push   $0x46
  80220c:	68 3c 2a 80 00       	push   $0x802a3c
  802211:	e8 e6 fe ff ff       	call   8020fc <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802216:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802219:	5b                   	pop    %ebx
  80221a:	5e                   	pop    %esi
  80221b:	5f                   	pop    %edi
  80221c:	5d                   	pop    %ebp
  80221d:	c3                   	ret    

0080221e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802224:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802229:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80222f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802235:	8b 52 50             	mov    0x50(%edx),%edx
  802238:	39 ca                	cmp    %ecx,%edx
  80223a:	74 11                	je     80224d <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80223c:	83 c0 01             	add    $0x1,%eax
  80223f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802244:	75 e3                	jne    802229 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802246:	b8 00 00 00 00       	mov    $0x0,%eax
  80224b:	eb 0e                	jmp    80225b <ipc_find_env+0x3d>
			return envs[i].env_id;
  80224d:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802253:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802258:	8b 40 48             	mov    0x48(%eax),%eax
}
  80225b:	5d                   	pop    %ebp
  80225c:	c3                   	ret    

0080225d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802263:	89 d0                	mov    %edx,%eax
  802265:	c1 e8 16             	shr    $0x16,%eax
  802268:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80226f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802274:	f6 c1 01             	test   $0x1,%cl
  802277:	74 1d                	je     802296 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802279:	c1 ea 0c             	shr    $0xc,%edx
  80227c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802283:	f6 c2 01             	test   $0x1,%dl
  802286:	74 0e                	je     802296 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802288:	c1 ea 0c             	shr    $0xc,%edx
  80228b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802292:	ef 
  802293:	0f b7 c0             	movzwl %ax,%eax
}
  802296:	5d                   	pop    %ebp
  802297:	c3                   	ret    
  802298:	66 90                	xchg   %ax,%ax
  80229a:	66 90                	xchg   %ax,%ax
  80229c:	66 90                	xchg   %ax,%ax
  80229e:	66 90                	xchg   %ax,%ax

008022a0 <__udivdi3>:
  8022a0:	55                   	push   %ebp
  8022a1:	57                   	push   %edi
  8022a2:	56                   	push   %esi
  8022a3:	53                   	push   %ebx
  8022a4:	83 ec 1c             	sub    $0x1c,%esp
  8022a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022b7:	85 d2                	test   %edx,%edx
  8022b9:	75 4d                	jne    802308 <__udivdi3+0x68>
  8022bb:	39 f3                	cmp    %esi,%ebx
  8022bd:	76 19                	jbe    8022d8 <__udivdi3+0x38>
  8022bf:	31 ff                	xor    %edi,%edi
  8022c1:	89 e8                	mov    %ebp,%eax
  8022c3:	89 f2                	mov    %esi,%edx
  8022c5:	f7 f3                	div    %ebx
  8022c7:	89 fa                	mov    %edi,%edx
  8022c9:	83 c4 1c             	add    $0x1c,%esp
  8022cc:	5b                   	pop    %ebx
  8022cd:	5e                   	pop    %esi
  8022ce:	5f                   	pop    %edi
  8022cf:	5d                   	pop    %ebp
  8022d0:	c3                   	ret    
  8022d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022d8:	89 d9                	mov    %ebx,%ecx
  8022da:	85 db                	test   %ebx,%ebx
  8022dc:	75 0b                	jne    8022e9 <__udivdi3+0x49>
  8022de:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e3:	31 d2                	xor    %edx,%edx
  8022e5:	f7 f3                	div    %ebx
  8022e7:	89 c1                	mov    %eax,%ecx
  8022e9:	31 d2                	xor    %edx,%edx
  8022eb:	89 f0                	mov    %esi,%eax
  8022ed:	f7 f1                	div    %ecx
  8022ef:	89 c6                	mov    %eax,%esi
  8022f1:	89 e8                	mov    %ebp,%eax
  8022f3:	89 f7                	mov    %esi,%edi
  8022f5:	f7 f1                	div    %ecx
  8022f7:	89 fa                	mov    %edi,%edx
  8022f9:	83 c4 1c             	add    $0x1c,%esp
  8022fc:	5b                   	pop    %ebx
  8022fd:	5e                   	pop    %esi
  8022fe:	5f                   	pop    %edi
  8022ff:	5d                   	pop    %ebp
  802300:	c3                   	ret    
  802301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802308:	39 f2                	cmp    %esi,%edx
  80230a:	77 1c                	ja     802328 <__udivdi3+0x88>
  80230c:	0f bd fa             	bsr    %edx,%edi
  80230f:	83 f7 1f             	xor    $0x1f,%edi
  802312:	75 2c                	jne    802340 <__udivdi3+0xa0>
  802314:	39 f2                	cmp    %esi,%edx
  802316:	72 06                	jb     80231e <__udivdi3+0x7e>
  802318:	31 c0                	xor    %eax,%eax
  80231a:	39 eb                	cmp    %ebp,%ebx
  80231c:	77 a9                	ja     8022c7 <__udivdi3+0x27>
  80231e:	b8 01 00 00 00       	mov    $0x1,%eax
  802323:	eb a2                	jmp    8022c7 <__udivdi3+0x27>
  802325:	8d 76 00             	lea    0x0(%esi),%esi
  802328:	31 ff                	xor    %edi,%edi
  80232a:	31 c0                	xor    %eax,%eax
  80232c:	89 fa                	mov    %edi,%edx
  80232e:	83 c4 1c             	add    $0x1c,%esp
  802331:	5b                   	pop    %ebx
  802332:	5e                   	pop    %esi
  802333:	5f                   	pop    %edi
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    
  802336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80233d:	8d 76 00             	lea    0x0(%esi),%esi
  802340:	89 f9                	mov    %edi,%ecx
  802342:	b8 20 00 00 00       	mov    $0x20,%eax
  802347:	29 f8                	sub    %edi,%eax
  802349:	d3 e2                	shl    %cl,%edx
  80234b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80234f:	89 c1                	mov    %eax,%ecx
  802351:	89 da                	mov    %ebx,%edx
  802353:	d3 ea                	shr    %cl,%edx
  802355:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802359:	09 d1                	or     %edx,%ecx
  80235b:	89 f2                	mov    %esi,%edx
  80235d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802361:	89 f9                	mov    %edi,%ecx
  802363:	d3 e3                	shl    %cl,%ebx
  802365:	89 c1                	mov    %eax,%ecx
  802367:	d3 ea                	shr    %cl,%edx
  802369:	89 f9                	mov    %edi,%ecx
  80236b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80236f:	89 eb                	mov    %ebp,%ebx
  802371:	d3 e6                	shl    %cl,%esi
  802373:	89 c1                	mov    %eax,%ecx
  802375:	d3 eb                	shr    %cl,%ebx
  802377:	09 de                	or     %ebx,%esi
  802379:	89 f0                	mov    %esi,%eax
  80237b:	f7 74 24 08          	divl   0x8(%esp)
  80237f:	89 d6                	mov    %edx,%esi
  802381:	89 c3                	mov    %eax,%ebx
  802383:	f7 64 24 0c          	mull   0xc(%esp)
  802387:	39 d6                	cmp    %edx,%esi
  802389:	72 15                	jb     8023a0 <__udivdi3+0x100>
  80238b:	89 f9                	mov    %edi,%ecx
  80238d:	d3 e5                	shl    %cl,%ebp
  80238f:	39 c5                	cmp    %eax,%ebp
  802391:	73 04                	jae    802397 <__udivdi3+0xf7>
  802393:	39 d6                	cmp    %edx,%esi
  802395:	74 09                	je     8023a0 <__udivdi3+0x100>
  802397:	89 d8                	mov    %ebx,%eax
  802399:	31 ff                	xor    %edi,%edi
  80239b:	e9 27 ff ff ff       	jmp    8022c7 <__udivdi3+0x27>
  8023a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023a3:	31 ff                	xor    %edi,%edi
  8023a5:	e9 1d ff ff ff       	jmp    8022c7 <__udivdi3+0x27>
  8023aa:	66 90                	xchg   %ax,%ax
  8023ac:	66 90                	xchg   %ax,%ax
  8023ae:	66 90                	xchg   %ax,%ax

008023b0 <__umoddi3>:
  8023b0:	55                   	push   %ebp
  8023b1:	57                   	push   %edi
  8023b2:	56                   	push   %esi
  8023b3:	53                   	push   %ebx
  8023b4:	83 ec 1c             	sub    $0x1c,%esp
  8023b7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023c7:	89 da                	mov    %ebx,%edx
  8023c9:	85 c0                	test   %eax,%eax
  8023cb:	75 43                	jne    802410 <__umoddi3+0x60>
  8023cd:	39 df                	cmp    %ebx,%edi
  8023cf:	76 17                	jbe    8023e8 <__umoddi3+0x38>
  8023d1:	89 f0                	mov    %esi,%eax
  8023d3:	f7 f7                	div    %edi
  8023d5:	89 d0                	mov    %edx,%eax
  8023d7:	31 d2                	xor    %edx,%edx
  8023d9:	83 c4 1c             	add    $0x1c,%esp
  8023dc:	5b                   	pop    %ebx
  8023dd:	5e                   	pop    %esi
  8023de:	5f                   	pop    %edi
  8023df:	5d                   	pop    %ebp
  8023e0:	c3                   	ret    
  8023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023e8:	89 fd                	mov    %edi,%ebp
  8023ea:	85 ff                	test   %edi,%edi
  8023ec:	75 0b                	jne    8023f9 <__umoddi3+0x49>
  8023ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f3:	31 d2                	xor    %edx,%edx
  8023f5:	f7 f7                	div    %edi
  8023f7:	89 c5                	mov    %eax,%ebp
  8023f9:	89 d8                	mov    %ebx,%eax
  8023fb:	31 d2                	xor    %edx,%edx
  8023fd:	f7 f5                	div    %ebp
  8023ff:	89 f0                	mov    %esi,%eax
  802401:	f7 f5                	div    %ebp
  802403:	89 d0                	mov    %edx,%eax
  802405:	eb d0                	jmp    8023d7 <__umoddi3+0x27>
  802407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80240e:	66 90                	xchg   %ax,%ax
  802410:	89 f1                	mov    %esi,%ecx
  802412:	39 d8                	cmp    %ebx,%eax
  802414:	76 0a                	jbe    802420 <__umoddi3+0x70>
  802416:	89 f0                	mov    %esi,%eax
  802418:	83 c4 1c             	add    $0x1c,%esp
  80241b:	5b                   	pop    %ebx
  80241c:	5e                   	pop    %esi
  80241d:	5f                   	pop    %edi
  80241e:	5d                   	pop    %ebp
  80241f:	c3                   	ret    
  802420:	0f bd e8             	bsr    %eax,%ebp
  802423:	83 f5 1f             	xor    $0x1f,%ebp
  802426:	75 20                	jne    802448 <__umoddi3+0x98>
  802428:	39 d8                	cmp    %ebx,%eax
  80242a:	0f 82 b0 00 00 00    	jb     8024e0 <__umoddi3+0x130>
  802430:	39 f7                	cmp    %esi,%edi
  802432:	0f 86 a8 00 00 00    	jbe    8024e0 <__umoddi3+0x130>
  802438:	89 c8                	mov    %ecx,%eax
  80243a:	83 c4 1c             	add    $0x1c,%esp
  80243d:	5b                   	pop    %ebx
  80243e:	5e                   	pop    %esi
  80243f:	5f                   	pop    %edi
  802440:	5d                   	pop    %ebp
  802441:	c3                   	ret    
  802442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802448:	89 e9                	mov    %ebp,%ecx
  80244a:	ba 20 00 00 00       	mov    $0x20,%edx
  80244f:	29 ea                	sub    %ebp,%edx
  802451:	d3 e0                	shl    %cl,%eax
  802453:	89 44 24 08          	mov    %eax,0x8(%esp)
  802457:	89 d1                	mov    %edx,%ecx
  802459:	89 f8                	mov    %edi,%eax
  80245b:	d3 e8                	shr    %cl,%eax
  80245d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802461:	89 54 24 04          	mov    %edx,0x4(%esp)
  802465:	8b 54 24 04          	mov    0x4(%esp),%edx
  802469:	09 c1                	or     %eax,%ecx
  80246b:	89 d8                	mov    %ebx,%eax
  80246d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802471:	89 e9                	mov    %ebp,%ecx
  802473:	d3 e7                	shl    %cl,%edi
  802475:	89 d1                	mov    %edx,%ecx
  802477:	d3 e8                	shr    %cl,%eax
  802479:	89 e9                	mov    %ebp,%ecx
  80247b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80247f:	d3 e3                	shl    %cl,%ebx
  802481:	89 c7                	mov    %eax,%edi
  802483:	89 d1                	mov    %edx,%ecx
  802485:	89 f0                	mov    %esi,%eax
  802487:	d3 e8                	shr    %cl,%eax
  802489:	89 e9                	mov    %ebp,%ecx
  80248b:	89 fa                	mov    %edi,%edx
  80248d:	d3 e6                	shl    %cl,%esi
  80248f:	09 d8                	or     %ebx,%eax
  802491:	f7 74 24 08          	divl   0x8(%esp)
  802495:	89 d1                	mov    %edx,%ecx
  802497:	89 f3                	mov    %esi,%ebx
  802499:	f7 64 24 0c          	mull   0xc(%esp)
  80249d:	89 c6                	mov    %eax,%esi
  80249f:	89 d7                	mov    %edx,%edi
  8024a1:	39 d1                	cmp    %edx,%ecx
  8024a3:	72 06                	jb     8024ab <__umoddi3+0xfb>
  8024a5:	75 10                	jne    8024b7 <__umoddi3+0x107>
  8024a7:	39 c3                	cmp    %eax,%ebx
  8024a9:	73 0c                	jae    8024b7 <__umoddi3+0x107>
  8024ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024b3:	89 d7                	mov    %edx,%edi
  8024b5:	89 c6                	mov    %eax,%esi
  8024b7:	89 ca                	mov    %ecx,%edx
  8024b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024be:	29 f3                	sub    %esi,%ebx
  8024c0:	19 fa                	sbb    %edi,%edx
  8024c2:	89 d0                	mov    %edx,%eax
  8024c4:	d3 e0                	shl    %cl,%eax
  8024c6:	89 e9                	mov    %ebp,%ecx
  8024c8:	d3 eb                	shr    %cl,%ebx
  8024ca:	d3 ea                	shr    %cl,%edx
  8024cc:	09 d8                	or     %ebx,%eax
  8024ce:	83 c4 1c             	add    $0x1c,%esp
  8024d1:	5b                   	pop    %ebx
  8024d2:	5e                   	pop    %esi
  8024d3:	5f                   	pop    %edi
  8024d4:	5d                   	pop    %ebp
  8024d5:	c3                   	ret    
  8024d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024dd:	8d 76 00             	lea    0x0(%esi),%esi
  8024e0:	89 da                	mov    %ebx,%edx
  8024e2:	29 fe                	sub    %edi,%esi
  8024e4:	19 c2                	sbb    %eax,%edx
  8024e6:	89 f1                	mov    %esi,%ecx
  8024e8:	89 c8                	mov    %ecx,%eax
  8024ea:	e9 4b ff ff ff       	jmp    80243a <__umoddi3+0x8a>
