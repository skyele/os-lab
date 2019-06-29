
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 70 00 00 00       	call   8000a1 <libmain>
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
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 86 0c 00 00       	call   800cc6 <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 08 40 80 00 84 	cmpl   $0xeec00084,0x804008
  800049:	00 c0 ee 
  80004c:	74 2d                	je     80007b <umain+0x48>
		while (1) {
			ipc_recv(&who, 0, 0);
			cprintf("%x recv from %x\n", id, who);
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  80004e:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	53                   	push   %ebx
  800058:	68 51 25 80 00       	push   $0x802551
  80005d:	e8 51 01 00 00       	call   8001b3 <cprintf>
  800062:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  800065:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  80006a:	6a 00                	push   $0x0
  80006c:	6a 00                	push   $0x0
  80006e:	6a 00                	push   $0x0
  800070:	50                   	push   %eax
  800071:	e8 ec 0f 00 00       	call   801062 <ipc_send>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	eb ea                	jmp    800065 <umain+0x32>
			ipc_recv(&who, 0, 0);
  80007b:	8d 75 f4             	lea    -0xc(%ebp),%esi
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	6a 00                	push   $0x0
  800083:	6a 00                	push   $0x0
  800085:	56                   	push   %esi
  800086:	e8 6e 0f 00 00       	call   800ff9 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80008b:	83 c4 0c             	add    $0xc,%esp
  80008e:	ff 75 f4             	pushl  -0xc(%ebp)
  800091:	53                   	push   %ebx
  800092:	68 40 25 80 00       	push   $0x802540
  800097:	e8 17 01 00 00       	call   8001b3 <cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	eb dd                	jmp    80007e <umain+0x4b>

008000a1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
  8000a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8000ac:	e8 15 0c 00 00       	call   800cc6 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8000b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b6:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000bc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c1:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c6:	85 db                	test   %ebx,%ebx
  8000c8:	7e 07                	jle    8000d1 <libmain+0x30>
		binaryname = argv[0];
  8000ca:	8b 06                	mov    (%esi),%eax
  8000cc:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000d1:	83 ec 08             	sub    $0x8,%esp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	e8 58 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000db:	e8 0a 00 00 00       	call   8000ea <exit>
}
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5d                   	pop    %ebp
  8000e9:	c3                   	ret    

008000ea <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8000f0:	a1 08 40 80 00       	mov    0x804008,%eax
  8000f5:	8b 40 48             	mov    0x48(%eax),%eax
  8000f8:	68 80 25 80 00       	push   $0x802580
  8000fd:	50                   	push   %eax
  8000fe:	68 72 25 80 00       	push   $0x802572
  800103:	e8 ab 00 00 00       	call   8001b3 <cprintf>
	close_all();
  800108:	e8 c4 11 00 00       	call   8012d1 <close_all>
	sys_env_destroy(0);
  80010d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800114:	e8 6c 0b 00 00       	call   800c85 <sys_env_destroy>
}
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	c9                   	leave  
  80011d:	c3                   	ret    

0080011e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80011e:	55                   	push   %ebp
  80011f:	89 e5                	mov    %esp,%ebp
  800121:	53                   	push   %ebx
  800122:	83 ec 04             	sub    $0x4,%esp
  800125:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800128:	8b 13                	mov    (%ebx),%edx
  80012a:	8d 42 01             	lea    0x1(%edx),%eax
  80012d:	89 03                	mov    %eax,(%ebx)
  80012f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800132:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800136:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013b:	74 09                	je     800146 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80013d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800141:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800144:	c9                   	leave  
  800145:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800146:	83 ec 08             	sub    $0x8,%esp
  800149:	68 ff 00 00 00       	push   $0xff
  80014e:	8d 43 08             	lea    0x8(%ebx),%eax
  800151:	50                   	push   %eax
  800152:	e8 f1 0a 00 00       	call   800c48 <sys_cputs>
		b->idx = 0;
  800157:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80015d:	83 c4 10             	add    $0x10,%esp
  800160:	eb db                	jmp    80013d <putch+0x1f>

00800162 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80016b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800172:	00 00 00 
	b.cnt = 0;
  800175:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80017f:	ff 75 0c             	pushl  0xc(%ebp)
  800182:	ff 75 08             	pushl  0x8(%ebp)
  800185:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80018b:	50                   	push   %eax
  80018c:	68 1e 01 80 00       	push   $0x80011e
  800191:	e8 4a 01 00 00       	call   8002e0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800196:	83 c4 08             	add    $0x8,%esp
  800199:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80019f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a5:	50                   	push   %eax
  8001a6:	e8 9d 0a 00 00       	call   800c48 <sys_cputs>

	return b.cnt;
}
  8001ab:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001b1:	c9                   	leave  
  8001b2:	c3                   	ret    

008001b3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001bc:	50                   	push   %eax
  8001bd:	ff 75 08             	pushl  0x8(%ebp)
  8001c0:	e8 9d ff ff ff       	call   800162 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c5:	c9                   	leave  
  8001c6:	c3                   	ret    

008001c7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	57                   	push   %edi
  8001cb:	56                   	push   %esi
  8001cc:	53                   	push   %ebx
  8001cd:	83 ec 1c             	sub    $0x1c,%esp
  8001d0:	89 c6                	mov    %eax,%esi
  8001d2:	89 d7                	mov    %edx,%edi
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e3:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001e6:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001ea:	74 2c                	je     800218 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ef:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001f9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001fc:	39 c2                	cmp    %eax,%edx
  8001fe:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800201:	73 43                	jae    800246 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800203:	83 eb 01             	sub    $0x1,%ebx
  800206:	85 db                	test   %ebx,%ebx
  800208:	7e 6c                	jle    800276 <printnum+0xaf>
				putch(padc, putdat);
  80020a:	83 ec 08             	sub    $0x8,%esp
  80020d:	57                   	push   %edi
  80020e:	ff 75 18             	pushl  0x18(%ebp)
  800211:	ff d6                	call   *%esi
  800213:	83 c4 10             	add    $0x10,%esp
  800216:	eb eb                	jmp    800203 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800218:	83 ec 0c             	sub    $0xc,%esp
  80021b:	6a 20                	push   $0x20
  80021d:	6a 00                	push   $0x0
  80021f:	50                   	push   %eax
  800220:	ff 75 e4             	pushl  -0x1c(%ebp)
  800223:	ff 75 e0             	pushl  -0x20(%ebp)
  800226:	89 fa                	mov    %edi,%edx
  800228:	89 f0                	mov    %esi,%eax
  80022a:	e8 98 ff ff ff       	call   8001c7 <printnum>
		while (--width > 0)
  80022f:	83 c4 20             	add    $0x20,%esp
  800232:	83 eb 01             	sub    $0x1,%ebx
  800235:	85 db                	test   %ebx,%ebx
  800237:	7e 65                	jle    80029e <printnum+0xd7>
			putch(padc, putdat);
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	57                   	push   %edi
  80023d:	6a 20                	push   $0x20
  80023f:	ff d6                	call   *%esi
  800241:	83 c4 10             	add    $0x10,%esp
  800244:	eb ec                	jmp    800232 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	ff 75 18             	pushl  0x18(%ebp)
  80024c:	83 eb 01             	sub    $0x1,%ebx
  80024f:	53                   	push   %ebx
  800250:	50                   	push   %eax
  800251:	83 ec 08             	sub    $0x8,%esp
  800254:	ff 75 dc             	pushl  -0x24(%ebp)
  800257:	ff 75 d8             	pushl  -0x28(%ebp)
  80025a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025d:	ff 75 e0             	pushl  -0x20(%ebp)
  800260:	e8 8b 20 00 00       	call   8022f0 <__udivdi3>
  800265:	83 c4 18             	add    $0x18,%esp
  800268:	52                   	push   %edx
  800269:	50                   	push   %eax
  80026a:	89 fa                	mov    %edi,%edx
  80026c:	89 f0                	mov    %esi,%eax
  80026e:	e8 54 ff ff ff       	call   8001c7 <printnum>
  800273:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800276:	83 ec 08             	sub    $0x8,%esp
  800279:	57                   	push   %edi
  80027a:	83 ec 04             	sub    $0x4,%esp
  80027d:	ff 75 dc             	pushl  -0x24(%ebp)
  800280:	ff 75 d8             	pushl  -0x28(%ebp)
  800283:	ff 75 e4             	pushl  -0x1c(%ebp)
  800286:	ff 75 e0             	pushl  -0x20(%ebp)
  800289:	e8 72 21 00 00       	call   802400 <__umoddi3>
  80028e:	83 c4 14             	add    $0x14,%esp
  800291:	0f be 80 85 25 80 00 	movsbl 0x802585(%eax),%eax
  800298:	50                   	push   %eax
  800299:	ff d6                	call   *%esi
  80029b:	83 c4 10             	add    $0x10,%esp
	}
}
  80029e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a1:	5b                   	pop    %ebx
  8002a2:	5e                   	pop    %esi
  8002a3:	5f                   	pop    %edi
  8002a4:	5d                   	pop    %ebp
  8002a5:	c3                   	ret    

008002a6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ac:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002b0:	8b 10                	mov    (%eax),%edx
  8002b2:	3b 50 04             	cmp    0x4(%eax),%edx
  8002b5:	73 0a                	jae    8002c1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ba:	89 08                	mov    %ecx,(%eax)
  8002bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bf:	88 02                	mov    %al,(%edx)
}
  8002c1:	5d                   	pop    %ebp
  8002c2:	c3                   	ret    

008002c3 <printfmt>:
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002c9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002cc:	50                   	push   %eax
  8002cd:	ff 75 10             	pushl  0x10(%ebp)
  8002d0:	ff 75 0c             	pushl  0xc(%ebp)
  8002d3:	ff 75 08             	pushl  0x8(%ebp)
  8002d6:	e8 05 00 00 00       	call   8002e0 <vprintfmt>
}
  8002db:	83 c4 10             	add    $0x10,%esp
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <vprintfmt>:
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	57                   	push   %edi
  8002e4:	56                   	push   %esi
  8002e5:	53                   	push   %ebx
  8002e6:	83 ec 3c             	sub    $0x3c,%esp
  8002e9:	8b 75 08             	mov    0x8(%ebp),%esi
  8002ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002f2:	e9 32 04 00 00       	jmp    800729 <vprintfmt+0x449>
		padc = ' ';
  8002f7:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002fb:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800302:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800309:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800310:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800317:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80031e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800323:	8d 47 01             	lea    0x1(%edi),%eax
  800326:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800329:	0f b6 17             	movzbl (%edi),%edx
  80032c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80032f:	3c 55                	cmp    $0x55,%al
  800331:	0f 87 12 05 00 00    	ja     800849 <vprintfmt+0x569>
  800337:	0f b6 c0             	movzbl %al,%eax
  80033a:	ff 24 85 60 27 80 00 	jmp    *0x802760(,%eax,4)
  800341:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800344:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800348:	eb d9                	jmp    800323 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80034a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80034d:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800351:	eb d0                	jmp    800323 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800353:	0f b6 d2             	movzbl %dl,%edx
  800356:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800359:	b8 00 00 00 00       	mov    $0x0,%eax
  80035e:	89 75 08             	mov    %esi,0x8(%ebp)
  800361:	eb 03                	jmp    800366 <vprintfmt+0x86>
  800363:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800366:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800369:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80036d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800370:	8d 72 d0             	lea    -0x30(%edx),%esi
  800373:	83 fe 09             	cmp    $0x9,%esi
  800376:	76 eb                	jbe    800363 <vprintfmt+0x83>
  800378:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80037b:	8b 75 08             	mov    0x8(%ebp),%esi
  80037e:	eb 14                	jmp    800394 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800380:	8b 45 14             	mov    0x14(%ebp),%eax
  800383:	8b 00                	mov    (%eax),%eax
  800385:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800388:	8b 45 14             	mov    0x14(%ebp),%eax
  80038b:	8d 40 04             	lea    0x4(%eax),%eax
  80038e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800394:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800398:	79 89                	jns    800323 <vprintfmt+0x43>
				width = precision, precision = -1;
  80039a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80039d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003a7:	e9 77 ff ff ff       	jmp    800323 <vprintfmt+0x43>
  8003ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003af:	85 c0                	test   %eax,%eax
  8003b1:	0f 48 c1             	cmovs  %ecx,%eax
  8003b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ba:	e9 64 ff ff ff       	jmp    800323 <vprintfmt+0x43>
  8003bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003c9:	e9 55 ff ff ff       	jmp    800323 <vprintfmt+0x43>
			lflag++;
  8003ce:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003d5:	e9 49 ff ff ff       	jmp    800323 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003da:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dd:	8d 78 04             	lea    0x4(%eax),%edi
  8003e0:	83 ec 08             	sub    $0x8,%esp
  8003e3:	53                   	push   %ebx
  8003e4:	ff 30                	pushl  (%eax)
  8003e6:	ff d6                	call   *%esi
			break;
  8003e8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003eb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ee:	e9 33 03 00 00       	jmp    800726 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f6:	8d 78 04             	lea    0x4(%eax),%edi
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	99                   	cltd   
  8003fc:	31 d0                	xor    %edx,%eax
  8003fe:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800400:	83 f8 11             	cmp    $0x11,%eax
  800403:	7f 23                	jg     800428 <vprintfmt+0x148>
  800405:	8b 14 85 c0 28 80 00 	mov    0x8028c0(,%eax,4),%edx
  80040c:	85 d2                	test   %edx,%edx
  80040e:	74 18                	je     800428 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800410:	52                   	push   %edx
  800411:	68 fd 29 80 00       	push   $0x8029fd
  800416:	53                   	push   %ebx
  800417:	56                   	push   %esi
  800418:	e8 a6 fe ff ff       	call   8002c3 <printfmt>
  80041d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800420:	89 7d 14             	mov    %edi,0x14(%ebp)
  800423:	e9 fe 02 00 00       	jmp    800726 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800428:	50                   	push   %eax
  800429:	68 9d 25 80 00       	push   $0x80259d
  80042e:	53                   	push   %ebx
  80042f:	56                   	push   %esi
  800430:	e8 8e fe ff ff       	call   8002c3 <printfmt>
  800435:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800438:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80043b:	e9 e6 02 00 00       	jmp    800726 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800440:	8b 45 14             	mov    0x14(%ebp),%eax
  800443:	83 c0 04             	add    $0x4,%eax
  800446:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800449:	8b 45 14             	mov    0x14(%ebp),%eax
  80044c:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80044e:	85 c9                	test   %ecx,%ecx
  800450:	b8 96 25 80 00       	mov    $0x802596,%eax
  800455:	0f 45 c1             	cmovne %ecx,%eax
  800458:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80045b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045f:	7e 06                	jle    800467 <vprintfmt+0x187>
  800461:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800465:	75 0d                	jne    800474 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800467:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80046a:	89 c7                	mov    %eax,%edi
  80046c:	03 45 e0             	add    -0x20(%ebp),%eax
  80046f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800472:	eb 53                	jmp    8004c7 <vprintfmt+0x1e7>
  800474:	83 ec 08             	sub    $0x8,%esp
  800477:	ff 75 d8             	pushl  -0x28(%ebp)
  80047a:	50                   	push   %eax
  80047b:	e8 71 04 00 00       	call   8008f1 <strnlen>
  800480:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800483:	29 c1                	sub    %eax,%ecx
  800485:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80048d:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800491:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800494:	eb 0f                	jmp    8004a5 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	53                   	push   %ebx
  80049a:	ff 75 e0             	pushl  -0x20(%ebp)
  80049d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80049f:	83 ef 01             	sub    $0x1,%edi
  8004a2:	83 c4 10             	add    $0x10,%esp
  8004a5:	85 ff                	test   %edi,%edi
  8004a7:	7f ed                	jg     800496 <vprintfmt+0x1b6>
  8004a9:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004ac:	85 c9                	test   %ecx,%ecx
  8004ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b3:	0f 49 c1             	cmovns %ecx,%eax
  8004b6:	29 c1                	sub    %eax,%ecx
  8004b8:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004bb:	eb aa                	jmp    800467 <vprintfmt+0x187>
					putch(ch, putdat);
  8004bd:	83 ec 08             	sub    $0x8,%esp
  8004c0:	53                   	push   %ebx
  8004c1:	52                   	push   %edx
  8004c2:	ff d6                	call   *%esi
  8004c4:	83 c4 10             	add    $0x10,%esp
  8004c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ca:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004cc:	83 c7 01             	add    $0x1,%edi
  8004cf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004d3:	0f be d0             	movsbl %al,%edx
  8004d6:	85 d2                	test   %edx,%edx
  8004d8:	74 4b                	je     800525 <vprintfmt+0x245>
  8004da:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004de:	78 06                	js     8004e6 <vprintfmt+0x206>
  8004e0:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004e4:	78 1e                	js     800504 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004ea:	74 d1                	je     8004bd <vprintfmt+0x1dd>
  8004ec:	0f be c0             	movsbl %al,%eax
  8004ef:	83 e8 20             	sub    $0x20,%eax
  8004f2:	83 f8 5e             	cmp    $0x5e,%eax
  8004f5:	76 c6                	jbe    8004bd <vprintfmt+0x1dd>
					putch('?', putdat);
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	53                   	push   %ebx
  8004fb:	6a 3f                	push   $0x3f
  8004fd:	ff d6                	call   *%esi
  8004ff:	83 c4 10             	add    $0x10,%esp
  800502:	eb c3                	jmp    8004c7 <vprintfmt+0x1e7>
  800504:	89 cf                	mov    %ecx,%edi
  800506:	eb 0e                	jmp    800516 <vprintfmt+0x236>
				putch(' ', putdat);
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	53                   	push   %ebx
  80050c:	6a 20                	push   $0x20
  80050e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800510:	83 ef 01             	sub    $0x1,%edi
  800513:	83 c4 10             	add    $0x10,%esp
  800516:	85 ff                	test   %edi,%edi
  800518:	7f ee                	jg     800508 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80051a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80051d:	89 45 14             	mov    %eax,0x14(%ebp)
  800520:	e9 01 02 00 00       	jmp    800726 <vprintfmt+0x446>
  800525:	89 cf                	mov    %ecx,%edi
  800527:	eb ed                	jmp    800516 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800529:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80052c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800533:	e9 eb fd ff ff       	jmp    800323 <vprintfmt+0x43>
	if (lflag >= 2)
  800538:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80053c:	7f 21                	jg     80055f <vprintfmt+0x27f>
	else if (lflag)
  80053e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800542:	74 68                	je     8005ac <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	8b 00                	mov    (%eax),%eax
  800549:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80054c:	89 c1                	mov    %eax,%ecx
  80054e:	c1 f9 1f             	sar    $0x1f,%ecx
  800551:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	8d 40 04             	lea    0x4(%eax),%eax
  80055a:	89 45 14             	mov    %eax,0x14(%ebp)
  80055d:	eb 17                	jmp    800576 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8b 50 04             	mov    0x4(%eax),%edx
  800565:	8b 00                	mov    (%eax),%eax
  800567:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80056a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80056d:	8b 45 14             	mov    0x14(%ebp),%eax
  800570:	8d 40 08             	lea    0x8(%eax),%eax
  800573:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800576:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800579:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80057c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800582:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800586:	78 3f                	js     8005c7 <vprintfmt+0x2e7>
			base = 10;
  800588:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80058d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800591:	0f 84 71 01 00 00    	je     800708 <vprintfmt+0x428>
				putch('+', putdat);
  800597:	83 ec 08             	sub    $0x8,%esp
  80059a:	53                   	push   %ebx
  80059b:	6a 2b                	push   $0x2b
  80059d:	ff d6                	call   *%esi
  80059f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a7:	e9 5c 01 00 00       	jmp    800708 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005b4:	89 c1                	mov    %eax,%ecx
  8005b6:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bf:	8d 40 04             	lea    0x4(%eax),%eax
  8005c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c5:	eb af                	jmp    800576 <vprintfmt+0x296>
				putch('-', putdat);
  8005c7:	83 ec 08             	sub    $0x8,%esp
  8005ca:	53                   	push   %ebx
  8005cb:	6a 2d                	push   $0x2d
  8005cd:	ff d6                	call   *%esi
				num = -(long long) num;
  8005cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005d2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005d5:	f7 d8                	neg    %eax
  8005d7:	83 d2 00             	adc    $0x0,%edx
  8005da:	f7 da                	neg    %edx
  8005dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ea:	e9 19 01 00 00       	jmp    800708 <vprintfmt+0x428>
	if (lflag >= 2)
  8005ef:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005f3:	7f 29                	jg     80061e <vprintfmt+0x33e>
	else if (lflag)
  8005f5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005f9:	74 44                	je     80063f <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	ba 00 00 00 00       	mov    $0x0,%edx
  800605:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800608:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8d 40 04             	lea    0x4(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800614:	b8 0a 00 00 00       	mov    $0xa,%eax
  800619:	e9 ea 00 00 00       	jmp    800708 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8b 50 04             	mov    0x4(%eax),%edx
  800624:	8b 00                	mov    (%eax),%eax
  800626:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800629:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8d 40 08             	lea    0x8(%eax),%eax
  800632:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800635:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063a:	e9 c9 00 00 00       	jmp    800708 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8b 00                	mov    (%eax),%eax
  800644:	ba 00 00 00 00       	mov    $0x0,%edx
  800649:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8d 40 04             	lea    0x4(%eax),%eax
  800655:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800658:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065d:	e9 a6 00 00 00       	jmp    800708 <vprintfmt+0x428>
			putch('0', putdat);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	53                   	push   %ebx
  800666:	6a 30                	push   $0x30
  800668:	ff d6                	call   *%esi
	if (lflag >= 2)
  80066a:	83 c4 10             	add    $0x10,%esp
  80066d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800671:	7f 26                	jg     800699 <vprintfmt+0x3b9>
	else if (lflag)
  800673:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800677:	74 3e                	je     8006b7 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	ba 00 00 00 00       	mov    $0x0,%edx
  800683:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800686:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8d 40 04             	lea    0x4(%eax),%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800692:	b8 08 00 00 00       	mov    $0x8,%eax
  800697:	eb 6f                	jmp    800708 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8b 50 04             	mov    0x4(%eax),%edx
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8d 40 08             	lea    0x8(%eax),%eax
  8006ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b0:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b5:	eb 51                	jmp    800708 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8d 40 04             	lea    0x4(%eax),%eax
  8006cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d0:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d5:	eb 31                	jmp    800708 <vprintfmt+0x428>
			putch('0', putdat);
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	53                   	push   %ebx
  8006db:	6a 30                	push   $0x30
  8006dd:	ff d6                	call   *%esi
			putch('x', putdat);
  8006df:	83 c4 08             	add    $0x8,%esp
  8006e2:	53                   	push   %ebx
  8006e3:	6a 78                	push   $0x78
  8006e5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006f7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8d 40 04             	lea    0x4(%eax),%eax
  800700:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800703:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800708:	83 ec 0c             	sub    $0xc,%esp
  80070b:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80070f:	52                   	push   %edx
  800710:	ff 75 e0             	pushl  -0x20(%ebp)
  800713:	50                   	push   %eax
  800714:	ff 75 dc             	pushl  -0x24(%ebp)
  800717:	ff 75 d8             	pushl  -0x28(%ebp)
  80071a:	89 da                	mov    %ebx,%edx
  80071c:	89 f0                	mov    %esi,%eax
  80071e:	e8 a4 fa ff ff       	call   8001c7 <printnum>
			break;
  800723:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800726:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800729:	83 c7 01             	add    $0x1,%edi
  80072c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800730:	83 f8 25             	cmp    $0x25,%eax
  800733:	0f 84 be fb ff ff    	je     8002f7 <vprintfmt+0x17>
			if (ch == '\0')
  800739:	85 c0                	test   %eax,%eax
  80073b:	0f 84 28 01 00 00    	je     800869 <vprintfmt+0x589>
			putch(ch, putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	53                   	push   %ebx
  800745:	50                   	push   %eax
  800746:	ff d6                	call   *%esi
  800748:	83 c4 10             	add    $0x10,%esp
  80074b:	eb dc                	jmp    800729 <vprintfmt+0x449>
	if (lflag >= 2)
  80074d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800751:	7f 26                	jg     800779 <vprintfmt+0x499>
	else if (lflag)
  800753:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800757:	74 41                	je     80079a <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	ba 00 00 00 00       	mov    $0x0,%edx
  800763:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800766:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8d 40 04             	lea    0x4(%eax),%eax
  80076f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800772:	b8 10 00 00 00       	mov    $0x10,%eax
  800777:	eb 8f                	jmp    800708 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8b 50 04             	mov    0x4(%eax),%edx
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800784:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8d 40 08             	lea    0x8(%eax),%eax
  80078d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800790:	b8 10 00 00 00       	mov    $0x10,%eax
  800795:	e9 6e ff ff ff       	jmp    800708 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80079a:	8b 45 14             	mov    0x14(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8d 40 04             	lea    0x4(%eax),%eax
  8007b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b3:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b8:	e9 4b ff ff ff       	jmp    800708 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	83 c0 04             	add    $0x4,%eax
  8007c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	85 c0                	test   %eax,%eax
  8007cd:	74 14                	je     8007e3 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007cf:	8b 13                	mov    (%ebx),%edx
  8007d1:	83 fa 7f             	cmp    $0x7f,%edx
  8007d4:	7f 37                	jg     80080d <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007d6:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
  8007de:	e9 43 ff ff ff       	jmp    800726 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007e3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e8:	bf b9 26 80 00       	mov    $0x8026b9,%edi
							putch(ch, putdat);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	53                   	push   %ebx
  8007f1:	50                   	push   %eax
  8007f2:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007f4:	83 c7 01             	add    $0x1,%edi
  8007f7:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007fb:	83 c4 10             	add    $0x10,%esp
  8007fe:	85 c0                	test   %eax,%eax
  800800:	75 eb                	jne    8007ed <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800802:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800805:	89 45 14             	mov    %eax,0x14(%ebp)
  800808:	e9 19 ff ff ff       	jmp    800726 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80080d:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80080f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800814:	bf f1 26 80 00       	mov    $0x8026f1,%edi
							putch(ch, putdat);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	53                   	push   %ebx
  80081d:	50                   	push   %eax
  80081e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800820:	83 c7 01             	add    $0x1,%edi
  800823:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800827:	83 c4 10             	add    $0x10,%esp
  80082a:	85 c0                	test   %eax,%eax
  80082c:	75 eb                	jne    800819 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80082e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800831:	89 45 14             	mov    %eax,0x14(%ebp)
  800834:	e9 ed fe ff ff       	jmp    800726 <vprintfmt+0x446>
			putch(ch, putdat);
  800839:	83 ec 08             	sub    $0x8,%esp
  80083c:	53                   	push   %ebx
  80083d:	6a 25                	push   $0x25
  80083f:	ff d6                	call   *%esi
			break;
  800841:	83 c4 10             	add    $0x10,%esp
  800844:	e9 dd fe ff ff       	jmp    800726 <vprintfmt+0x446>
			putch('%', putdat);
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	53                   	push   %ebx
  80084d:	6a 25                	push   $0x25
  80084f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800851:	83 c4 10             	add    $0x10,%esp
  800854:	89 f8                	mov    %edi,%eax
  800856:	eb 03                	jmp    80085b <vprintfmt+0x57b>
  800858:	83 e8 01             	sub    $0x1,%eax
  80085b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80085f:	75 f7                	jne    800858 <vprintfmt+0x578>
  800861:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800864:	e9 bd fe ff ff       	jmp    800726 <vprintfmt+0x446>
}
  800869:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80086c:	5b                   	pop    %ebx
  80086d:	5e                   	pop    %esi
  80086e:	5f                   	pop    %edi
  80086f:	5d                   	pop    %ebp
  800870:	c3                   	ret    

00800871 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800871:	55                   	push   %ebp
  800872:	89 e5                	mov    %esp,%ebp
  800874:	83 ec 18             	sub    $0x18,%esp
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80087d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800880:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800884:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800887:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80088e:	85 c0                	test   %eax,%eax
  800890:	74 26                	je     8008b8 <vsnprintf+0x47>
  800892:	85 d2                	test   %edx,%edx
  800894:	7e 22                	jle    8008b8 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800896:	ff 75 14             	pushl  0x14(%ebp)
  800899:	ff 75 10             	pushl  0x10(%ebp)
  80089c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80089f:	50                   	push   %eax
  8008a0:	68 a6 02 80 00       	push   $0x8002a6
  8008a5:	e8 36 fa ff ff       	call   8002e0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ad:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008b3:	83 c4 10             	add    $0x10,%esp
}
  8008b6:	c9                   	leave  
  8008b7:	c3                   	ret    
		return -E_INVAL;
  8008b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008bd:	eb f7                	jmp    8008b6 <vsnprintf+0x45>

008008bf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
  8008c2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008c5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008c8:	50                   	push   %eax
  8008c9:	ff 75 10             	pushl  0x10(%ebp)
  8008cc:	ff 75 0c             	pushl  0xc(%ebp)
  8008cf:	ff 75 08             	pushl  0x8(%ebp)
  8008d2:	e8 9a ff ff ff       	call   800871 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008d7:	c9                   	leave  
  8008d8:	c3                   	ret    

008008d9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008df:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e8:	74 05                	je     8008ef <strlen+0x16>
		n++;
  8008ea:	83 c0 01             	add    $0x1,%eax
  8008ed:	eb f5                	jmp    8008e4 <strlen+0xb>
	return n;
}
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f7:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ff:	39 c2                	cmp    %eax,%edx
  800901:	74 0d                	je     800910 <strnlen+0x1f>
  800903:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800907:	74 05                	je     80090e <strnlen+0x1d>
		n++;
  800909:	83 c2 01             	add    $0x1,%edx
  80090c:	eb f1                	jmp    8008ff <strnlen+0xe>
  80090e:	89 d0                	mov    %edx,%eax
	return n;
}
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	53                   	push   %ebx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80091c:	ba 00 00 00 00       	mov    $0x0,%edx
  800921:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800925:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800928:	83 c2 01             	add    $0x1,%edx
  80092b:	84 c9                	test   %cl,%cl
  80092d:	75 f2                	jne    800921 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80092f:	5b                   	pop    %ebx
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    

00800932 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	53                   	push   %ebx
  800936:	83 ec 10             	sub    $0x10,%esp
  800939:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80093c:	53                   	push   %ebx
  80093d:	e8 97 ff ff ff       	call   8008d9 <strlen>
  800942:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	01 d8                	add    %ebx,%eax
  80094a:	50                   	push   %eax
  80094b:	e8 c2 ff ff ff       	call   800912 <strcpy>
	return dst;
}
  800950:	89 d8                	mov    %ebx,%eax
  800952:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800955:	c9                   	leave  
  800956:	c3                   	ret    

00800957 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	56                   	push   %esi
  80095b:	53                   	push   %ebx
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800962:	89 c6                	mov    %eax,%esi
  800964:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800967:	89 c2                	mov    %eax,%edx
  800969:	39 f2                	cmp    %esi,%edx
  80096b:	74 11                	je     80097e <strncpy+0x27>
		*dst++ = *src;
  80096d:	83 c2 01             	add    $0x1,%edx
  800970:	0f b6 19             	movzbl (%ecx),%ebx
  800973:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800976:	80 fb 01             	cmp    $0x1,%bl
  800979:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80097c:	eb eb                	jmp    800969 <strncpy+0x12>
	}
	return ret;
}
  80097e:	5b                   	pop    %ebx
  80097f:	5e                   	pop    %esi
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	56                   	push   %esi
  800986:	53                   	push   %ebx
  800987:	8b 75 08             	mov    0x8(%ebp),%esi
  80098a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80098d:	8b 55 10             	mov    0x10(%ebp),%edx
  800990:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800992:	85 d2                	test   %edx,%edx
  800994:	74 21                	je     8009b7 <strlcpy+0x35>
  800996:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80099a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80099c:	39 c2                	cmp    %eax,%edx
  80099e:	74 14                	je     8009b4 <strlcpy+0x32>
  8009a0:	0f b6 19             	movzbl (%ecx),%ebx
  8009a3:	84 db                	test   %bl,%bl
  8009a5:	74 0b                	je     8009b2 <strlcpy+0x30>
			*dst++ = *src++;
  8009a7:	83 c1 01             	add    $0x1,%ecx
  8009aa:	83 c2 01             	add    $0x1,%edx
  8009ad:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009b0:	eb ea                	jmp    80099c <strlcpy+0x1a>
  8009b2:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009b4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009b7:	29 f0                	sub    %esi,%eax
}
  8009b9:	5b                   	pop    %ebx
  8009ba:	5e                   	pop    %esi
  8009bb:	5d                   	pop    %ebp
  8009bc:	c3                   	ret    

008009bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009c6:	0f b6 01             	movzbl (%ecx),%eax
  8009c9:	84 c0                	test   %al,%al
  8009cb:	74 0c                	je     8009d9 <strcmp+0x1c>
  8009cd:	3a 02                	cmp    (%edx),%al
  8009cf:	75 08                	jne    8009d9 <strcmp+0x1c>
		p++, q++;
  8009d1:	83 c1 01             	add    $0x1,%ecx
  8009d4:	83 c2 01             	add    $0x1,%edx
  8009d7:	eb ed                	jmp    8009c6 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d9:	0f b6 c0             	movzbl %al,%eax
  8009dc:	0f b6 12             	movzbl (%edx),%edx
  8009df:	29 d0                	sub    %edx,%eax
}
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    

008009e3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	53                   	push   %ebx
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ed:	89 c3                	mov    %eax,%ebx
  8009ef:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009f2:	eb 06                	jmp    8009fa <strncmp+0x17>
		n--, p++, q++;
  8009f4:	83 c0 01             	add    $0x1,%eax
  8009f7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009fa:	39 d8                	cmp    %ebx,%eax
  8009fc:	74 16                	je     800a14 <strncmp+0x31>
  8009fe:	0f b6 08             	movzbl (%eax),%ecx
  800a01:	84 c9                	test   %cl,%cl
  800a03:	74 04                	je     800a09 <strncmp+0x26>
  800a05:	3a 0a                	cmp    (%edx),%cl
  800a07:	74 eb                	je     8009f4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a09:	0f b6 00             	movzbl (%eax),%eax
  800a0c:	0f b6 12             	movzbl (%edx),%edx
  800a0f:	29 d0                	sub    %edx,%eax
}
  800a11:	5b                   	pop    %ebx
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    
		return 0;
  800a14:	b8 00 00 00 00       	mov    $0x0,%eax
  800a19:	eb f6                	jmp    800a11 <strncmp+0x2e>

00800a1b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a25:	0f b6 10             	movzbl (%eax),%edx
  800a28:	84 d2                	test   %dl,%dl
  800a2a:	74 09                	je     800a35 <strchr+0x1a>
		if (*s == c)
  800a2c:	38 ca                	cmp    %cl,%dl
  800a2e:	74 0a                	je     800a3a <strchr+0x1f>
	for (; *s; s++)
  800a30:	83 c0 01             	add    $0x1,%eax
  800a33:	eb f0                	jmp    800a25 <strchr+0xa>
			return (char *) s;
	return 0;
  800a35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a3a:	5d                   	pop    %ebp
  800a3b:	c3                   	ret    

00800a3c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a46:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a49:	38 ca                	cmp    %cl,%dl
  800a4b:	74 09                	je     800a56 <strfind+0x1a>
  800a4d:	84 d2                	test   %dl,%dl
  800a4f:	74 05                	je     800a56 <strfind+0x1a>
	for (; *s; s++)
  800a51:	83 c0 01             	add    $0x1,%eax
  800a54:	eb f0                	jmp    800a46 <strfind+0xa>
			break;
	return (char *) s;
}
  800a56:	5d                   	pop    %ebp
  800a57:	c3                   	ret    

00800a58 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	57                   	push   %edi
  800a5c:	56                   	push   %esi
  800a5d:	53                   	push   %ebx
  800a5e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a61:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a64:	85 c9                	test   %ecx,%ecx
  800a66:	74 31                	je     800a99 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a68:	89 f8                	mov    %edi,%eax
  800a6a:	09 c8                	or     %ecx,%eax
  800a6c:	a8 03                	test   $0x3,%al
  800a6e:	75 23                	jne    800a93 <memset+0x3b>
		c &= 0xFF;
  800a70:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a74:	89 d3                	mov    %edx,%ebx
  800a76:	c1 e3 08             	shl    $0x8,%ebx
  800a79:	89 d0                	mov    %edx,%eax
  800a7b:	c1 e0 18             	shl    $0x18,%eax
  800a7e:	89 d6                	mov    %edx,%esi
  800a80:	c1 e6 10             	shl    $0x10,%esi
  800a83:	09 f0                	or     %esi,%eax
  800a85:	09 c2                	or     %eax,%edx
  800a87:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a89:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a8c:	89 d0                	mov    %edx,%eax
  800a8e:	fc                   	cld    
  800a8f:	f3 ab                	rep stos %eax,%es:(%edi)
  800a91:	eb 06                	jmp    800a99 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a96:	fc                   	cld    
  800a97:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a99:	89 f8                	mov    %edi,%eax
  800a9b:	5b                   	pop    %ebx
  800a9c:	5e                   	pop    %esi
  800a9d:	5f                   	pop    %edi
  800a9e:	5d                   	pop    %ebp
  800a9f:	c3                   	ret    

00800aa0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	57                   	push   %edi
  800aa4:	56                   	push   %esi
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aab:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aae:	39 c6                	cmp    %eax,%esi
  800ab0:	73 32                	jae    800ae4 <memmove+0x44>
  800ab2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ab5:	39 c2                	cmp    %eax,%edx
  800ab7:	76 2b                	jbe    800ae4 <memmove+0x44>
		s += n;
		d += n;
  800ab9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abc:	89 fe                	mov    %edi,%esi
  800abe:	09 ce                	or     %ecx,%esi
  800ac0:	09 d6                	or     %edx,%esi
  800ac2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac8:	75 0e                	jne    800ad8 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aca:	83 ef 04             	sub    $0x4,%edi
  800acd:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ad0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ad3:	fd                   	std    
  800ad4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad6:	eb 09                	jmp    800ae1 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ad8:	83 ef 01             	sub    $0x1,%edi
  800adb:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ade:	fd                   	std    
  800adf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ae1:	fc                   	cld    
  800ae2:	eb 1a                	jmp    800afe <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae4:	89 c2                	mov    %eax,%edx
  800ae6:	09 ca                	or     %ecx,%edx
  800ae8:	09 f2                	or     %esi,%edx
  800aea:	f6 c2 03             	test   $0x3,%dl
  800aed:	75 0a                	jne    800af9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aef:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800af2:	89 c7                	mov    %eax,%edi
  800af4:	fc                   	cld    
  800af5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af7:	eb 05                	jmp    800afe <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800af9:	89 c7                	mov    %eax,%edi
  800afb:	fc                   	cld    
  800afc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800afe:	5e                   	pop    %esi
  800aff:	5f                   	pop    %edi
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b08:	ff 75 10             	pushl  0x10(%ebp)
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	ff 75 08             	pushl  0x8(%ebp)
  800b11:	e8 8a ff ff ff       	call   800aa0 <memmove>
}
  800b16:	c9                   	leave  
  800b17:	c3                   	ret    

00800b18 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	56                   	push   %esi
  800b1c:	53                   	push   %ebx
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b23:	89 c6                	mov    %eax,%esi
  800b25:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b28:	39 f0                	cmp    %esi,%eax
  800b2a:	74 1c                	je     800b48 <memcmp+0x30>
		if (*s1 != *s2)
  800b2c:	0f b6 08             	movzbl (%eax),%ecx
  800b2f:	0f b6 1a             	movzbl (%edx),%ebx
  800b32:	38 d9                	cmp    %bl,%cl
  800b34:	75 08                	jne    800b3e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b36:	83 c0 01             	add    $0x1,%eax
  800b39:	83 c2 01             	add    $0x1,%edx
  800b3c:	eb ea                	jmp    800b28 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b3e:	0f b6 c1             	movzbl %cl,%eax
  800b41:	0f b6 db             	movzbl %bl,%ebx
  800b44:	29 d8                	sub    %ebx,%eax
  800b46:	eb 05                	jmp    800b4d <memcmp+0x35>
	}

	return 0;
  800b48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b4d:	5b                   	pop    %ebx
  800b4e:	5e                   	pop    %esi
  800b4f:	5d                   	pop    %ebp
  800b50:	c3                   	ret    

00800b51 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b5a:	89 c2                	mov    %eax,%edx
  800b5c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b5f:	39 d0                	cmp    %edx,%eax
  800b61:	73 09                	jae    800b6c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b63:	38 08                	cmp    %cl,(%eax)
  800b65:	74 05                	je     800b6c <memfind+0x1b>
	for (; s < ends; s++)
  800b67:	83 c0 01             	add    $0x1,%eax
  800b6a:	eb f3                	jmp    800b5f <memfind+0xe>
			break;
	return (void *) s;
}
  800b6c:	5d                   	pop    %ebp
  800b6d:	c3                   	ret    

00800b6e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	57                   	push   %edi
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
  800b74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b77:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b7a:	eb 03                	jmp    800b7f <strtol+0x11>
		s++;
  800b7c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b7f:	0f b6 01             	movzbl (%ecx),%eax
  800b82:	3c 20                	cmp    $0x20,%al
  800b84:	74 f6                	je     800b7c <strtol+0xe>
  800b86:	3c 09                	cmp    $0x9,%al
  800b88:	74 f2                	je     800b7c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b8a:	3c 2b                	cmp    $0x2b,%al
  800b8c:	74 2a                	je     800bb8 <strtol+0x4a>
	int neg = 0;
  800b8e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b93:	3c 2d                	cmp    $0x2d,%al
  800b95:	74 2b                	je     800bc2 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b97:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b9d:	75 0f                	jne    800bae <strtol+0x40>
  800b9f:	80 39 30             	cmpb   $0x30,(%ecx)
  800ba2:	74 28                	je     800bcc <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ba4:	85 db                	test   %ebx,%ebx
  800ba6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bab:	0f 44 d8             	cmove  %eax,%ebx
  800bae:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bb6:	eb 50                	jmp    800c08 <strtol+0x9a>
		s++;
  800bb8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bbb:	bf 00 00 00 00       	mov    $0x0,%edi
  800bc0:	eb d5                	jmp    800b97 <strtol+0x29>
		s++, neg = 1;
  800bc2:	83 c1 01             	add    $0x1,%ecx
  800bc5:	bf 01 00 00 00       	mov    $0x1,%edi
  800bca:	eb cb                	jmp    800b97 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bcc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bd0:	74 0e                	je     800be0 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bd2:	85 db                	test   %ebx,%ebx
  800bd4:	75 d8                	jne    800bae <strtol+0x40>
		s++, base = 8;
  800bd6:	83 c1 01             	add    $0x1,%ecx
  800bd9:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bde:	eb ce                	jmp    800bae <strtol+0x40>
		s += 2, base = 16;
  800be0:	83 c1 02             	add    $0x2,%ecx
  800be3:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be8:	eb c4                	jmp    800bae <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bea:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bed:	89 f3                	mov    %esi,%ebx
  800bef:	80 fb 19             	cmp    $0x19,%bl
  800bf2:	77 29                	ja     800c1d <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bf4:	0f be d2             	movsbl %dl,%edx
  800bf7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bfa:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bfd:	7d 30                	jge    800c2f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bff:	83 c1 01             	add    $0x1,%ecx
  800c02:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c06:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c08:	0f b6 11             	movzbl (%ecx),%edx
  800c0b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c0e:	89 f3                	mov    %esi,%ebx
  800c10:	80 fb 09             	cmp    $0x9,%bl
  800c13:	77 d5                	ja     800bea <strtol+0x7c>
			dig = *s - '0';
  800c15:	0f be d2             	movsbl %dl,%edx
  800c18:	83 ea 30             	sub    $0x30,%edx
  800c1b:	eb dd                	jmp    800bfa <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c1d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c20:	89 f3                	mov    %esi,%ebx
  800c22:	80 fb 19             	cmp    $0x19,%bl
  800c25:	77 08                	ja     800c2f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c27:	0f be d2             	movsbl %dl,%edx
  800c2a:	83 ea 37             	sub    $0x37,%edx
  800c2d:	eb cb                	jmp    800bfa <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c33:	74 05                	je     800c3a <strtol+0xcc>
		*endptr = (char *) s;
  800c35:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c38:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c3a:	89 c2                	mov    %eax,%edx
  800c3c:	f7 da                	neg    %edx
  800c3e:	85 ff                	test   %edi,%edi
  800c40:	0f 45 c2             	cmovne %edx,%eax
}
  800c43:	5b                   	pop    %ebx
  800c44:	5e                   	pop    %esi
  800c45:	5f                   	pop    %edi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	57                   	push   %edi
  800c4c:	56                   	push   %esi
  800c4d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c53:	8b 55 08             	mov    0x8(%ebp),%edx
  800c56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c59:	89 c3                	mov    %eax,%ebx
  800c5b:	89 c7                	mov    %eax,%edi
  800c5d:	89 c6                	mov    %eax,%esi
  800c5f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c61:	5b                   	pop    %ebx
  800c62:	5e                   	pop    %esi
  800c63:	5f                   	pop    %edi
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	57                   	push   %edi
  800c6a:	56                   	push   %esi
  800c6b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c71:	b8 01 00 00 00       	mov    $0x1,%eax
  800c76:	89 d1                	mov    %edx,%ecx
  800c78:	89 d3                	mov    %edx,%ebx
  800c7a:	89 d7                	mov    %edx,%edi
  800c7c:	89 d6                	mov    %edx,%esi
  800c7e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c80:	5b                   	pop    %ebx
  800c81:	5e                   	pop    %esi
  800c82:	5f                   	pop    %edi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	53                   	push   %ebx
  800c8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c93:	8b 55 08             	mov    0x8(%ebp),%edx
  800c96:	b8 03 00 00 00       	mov    $0x3,%eax
  800c9b:	89 cb                	mov    %ecx,%ebx
  800c9d:	89 cf                	mov    %ecx,%edi
  800c9f:	89 ce                	mov    %ecx,%esi
  800ca1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca3:	85 c0                	test   %eax,%eax
  800ca5:	7f 08                	jg     800caf <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ca7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800caa:	5b                   	pop    %ebx
  800cab:	5e                   	pop    %esi
  800cac:	5f                   	pop    %edi
  800cad:	5d                   	pop    %ebp
  800cae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800caf:	83 ec 0c             	sub    $0xc,%esp
  800cb2:	50                   	push   %eax
  800cb3:	6a 03                	push   $0x3
  800cb5:	68 08 29 80 00       	push   $0x802908
  800cba:	6a 43                	push   $0x43
  800cbc:	68 25 29 80 00       	push   $0x802925
  800cc1:	e8 89 15 00 00       	call   80224f <_panic>

00800cc6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	57                   	push   %edi
  800cca:	56                   	push   %esi
  800ccb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ccc:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd1:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd6:	89 d1                	mov    %edx,%ecx
  800cd8:	89 d3                	mov    %edx,%ebx
  800cda:	89 d7                	mov    %edx,%edi
  800cdc:	89 d6                	mov    %edx,%esi
  800cde:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ce0:	5b                   	pop    %ebx
  800ce1:	5e                   	pop    %esi
  800ce2:	5f                   	pop    %edi
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    

00800ce5 <sys_yield>:

void
sys_yield(void)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	57                   	push   %edi
  800ce9:	56                   	push   %esi
  800cea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ceb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cf5:	89 d1                	mov    %edx,%ecx
  800cf7:	89 d3                	mov    %edx,%ebx
  800cf9:	89 d7                	mov    %edx,%edi
  800cfb:	89 d6                	mov    %edx,%esi
  800cfd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cff:	5b                   	pop    %ebx
  800d00:	5e                   	pop    %esi
  800d01:	5f                   	pop    %edi
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    

00800d04 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	57                   	push   %edi
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
  800d0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0d:	be 00 00 00 00       	mov    $0x0,%esi
  800d12:	8b 55 08             	mov    0x8(%ebp),%edx
  800d15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d18:	b8 04 00 00 00       	mov    $0x4,%eax
  800d1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d20:	89 f7                	mov    %esi,%edi
  800d22:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d24:	85 c0                	test   %eax,%eax
  800d26:	7f 08                	jg     800d30 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2b:	5b                   	pop    %ebx
  800d2c:	5e                   	pop    %esi
  800d2d:	5f                   	pop    %edi
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d30:	83 ec 0c             	sub    $0xc,%esp
  800d33:	50                   	push   %eax
  800d34:	6a 04                	push   $0x4
  800d36:	68 08 29 80 00       	push   $0x802908
  800d3b:	6a 43                	push   $0x43
  800d3d:	68 25 29 80 00       	push   $0x802925
  800d42:	e8 08 15 00 00       	call   80224f <_panic>

00800d47 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	57                   	push   %edi
  800d4b:	56                   	push   %esi
  800d4c:	53                   	push   %ebx
  800d4d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d50:	8b 55 08             	mov    0x8(%ebp),%edx
  800d53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d56:	b8 05 00 00 00       	mov    $0x5,%eax
  800d5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d61:	8b 75 18             	mov    0x18(%ebp),%esi
  800d64:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d66:	85 c0                	test   %eax,%eax
  800d68:	7f 08                	jg     800d72 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6d:	5b                   	pop    %ebx
  800d6e:	5e                   	pop    %esi
  800d6f:	5f                   	pop    %edi
  800d70:	5d                   	pop    %ebp
  800d71:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d72:	83 ec 0c             	sub    $0xc,%esp
  800d75:	50                   	push   %eax
  800d76:	6a 05                	push   $0x5
  800d78:	68 08 29 80 00       	push   $0x802908
  800d7d:	6a 43                	push   $0x43
  800d7f:	68 25 29 80 00       	push   $0x802925
  800d84:	e8 c6 14 00 00       	call   80224f <_panic>

00800d89 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	57                   	push   %edi
  800d8d:	56                   	push   %esi
  800d8e:	53                   	push   %ebx
  800d8f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d92:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d97:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9d:	b8 06 00 00 00       	mov    $0x6,%eax
  800da2:	89 df                	mov    %ebx,%edi
  800da4:	89 de                	mov    %ebx,%esi
  800da6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da8:	85 c0                	test   %eax,%eax
  800daa:	7f 08                	jg     800db4 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800daf:	5b                   	pop    %ebx
  800db0:	5e                   	pop    %esi
  800db1:	5f                   	pop    %edi
  800db2:	5d                   	pop    %ebp
  800db3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db4:	83 ec 0c             	sub    $0xc,%esp
  800db7:	50                   	push   %eax
  800db8:	6a 06                	push   $0x6
  800dba:	68 08 29 80 00       	push   $0x802908
  800dbf:	6a 43                	push   $0x43
  800dc1:	68 25 29 80 00       	push   $0x802925
  800dc6:	e8 84 14 00 00       	call   80224f <_panic>

00800dcb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	57                   	push   %edi
  800dcf:	56                   	push   %esi
  800dd0:	53                   	push   %ebx
  800dd1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddf:	b8 08 00 00 00       	mov    $0x8,%eax
  800de4:	89 df                	mov    %ebx,%edi
  800de6:	89 de                	mov    %ebx,%esi
  800de8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dea:	85 c0                	test   %eax,%eax
  800dec:	7f 08                	jg     800df6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df1:	5b                   	pop    %ebx
  800df2:	5e                   	pop    %esi
  800df3:	5f                   	pop    %edi
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df6:	83 ec 0c             	sub    $0xc,%esp
  800df9:	50                   	push   %eax
  800dfa:	6a 08                	push   $0x8
  800dfc:	68 08 29 80 00       	push   $0x802908
  800e01:	6a 43                	push   $0x43
  800e03:	68 25 29 80 00       	push   $0x802925
  800e08:	e8 42 14 00 00       	call   80224f <_panic>

00800e0d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	57                   	push   %edi
  800e11:	56                   	push   %esi
  800e12:	53                   	push   %ebx
  800e13:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e21:	b8 09 00 00 00       	mov    $0x9,%eax
  800e26:	89 df                	mov    %ebx,%edi
  800e28:	89 de                	mov    %ebx,%esi
  800e2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2c:	85 c0                	test   %eax,%eax
  800e2e:	7f 08                	jg     800e38 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e33:	5b                   	pop    %ebx
  800e34:	5e                   	pop    %esi
  800e35:	5f                   	pop    %edi
  800e36:	5d                   	pop    %ebp
  800e37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e38:	83 ec 0c             	sub    $0xc,%esp
  800e3b:	50                   	push   %eax
  800e3c:	6a 09                	push   $0x9
  800e3e:	68 08 29 80 00       	push   $0x802908
  800e43:	6a 43                	push   $0x43
  800e45:	68 25 29 80 00       	push   $0x802925
  800e4a:	e8 00 14 00 00       	call   80224f <_panic>

00800e4f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	57                   	push   %edi
  800e53:	56                   	push   %esi
  800e54:	53                   	push   %ebx
  800e55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e58:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e63:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e68:	89 df                	mov    %ebx,%edi
  800e6a:	89 de                	mov    %ebx,%esi
  800e6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	7f 08                	jg     800e7a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5f                   	pop    %edi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7a:	83 ec 0c             	sub    $0xc,%esp
  800e7d:	50                   	push   %eax
  800e7e:	6a 0a                	push   $0xa
  800e80:	68 08 29 80 00       	push   $0x802908
  800e85:	6a 43                	push   $0x43
  800e87:	68 25 29 80 00       	push   $0x802925
  800e8c:	e8 be 13 00 00       	call   80224f <_panic>

00800e91 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	57                   	push   %edi
  800e95:	56                   	push   %esi
  800e96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e97:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ea2:	be 00 00 00 00       	mov    $0x0,%esi
  800ea7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eaa:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ead:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eaf:	5b                   	pop    %ebx
  800eb0:	5e                   	pop    %esi
  800eb1:	5f                   	pop    %edi
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    

00800eb4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	57                   	push   %edi
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
  800eba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ebd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec5:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eca:	89 cb                	mov    %ecx,%ebx
  800ecc:	89 cf                	mov    %ecx,%edi
  800ece:	89 ce                	mov    %ecx,%esi
  800ed0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	7f 08                	jg     800ede <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ed6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed9:	5b                   	pop    %ebx
  800eda:	5e                   	pop    %esi
  800edb:	5f                   	pop    %edi
  800edc:	5d                   	pop    %ebp
  800edd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ede:	83 ec 0c             	sub    $0xc,%esp
  800ee1:	50                   	push   %eax
  800ee2:	6a 0d                	push   $0xd
  800ee4:	68 08 29 80 00       	push   $0x802908
  800ee9:	6a 43                	push   $0x43
  800eeb:	68 25 29 80 00       	push   $0x802925
  800ef0:	e8 5a 13 00 00       	call   80224f <_panic>

00800ef5 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	57                   	push   %edi
  800ef9:	56                   	push   %esi
  800efa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800efb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f00:	8b 55 08             	mov    0x8(%ebp),%edx
  800f03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f06:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f0b:	89 df                	mov    %ebx,%edi
  800f0d:	89 de                	mov    %ebx,%esi
  800f0f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f11:	5b                   	pop    %ebx
  800f12:	5e                   	pop    %esi
  800f13:	5f                   	pop    %edi
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    

00800f16 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	57                   	push   %edi
  800f1a:	56                   	push   %esi
  800f1b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f29:	89 cb                	mov    %ecx,%ebx
  800f2b:	89 cf                	mov    %ecx,%edi
  800f2d:	89 ce                	mov    %ecx,%esi
  800f2f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f31:	5b                   	pop    %ebx
  800f32:	5e                   	pop    %esi
  800f33:	5f                   	pop    %edi
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    

00800f36 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	57                   	push   %edi
  800f3a:	56                   	push   %esi
  800f3b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f41:	b8 10 00 00 00       	mov    $0x10,%eax
  800f46:	89 d1                	mov    %edx,%ecx
  800f48:	89 d3                	mov    %edx,%ebx
  800f4a:	89 d7                	mov    %edx,%edi
  800f4c:	89 d6                	mov    %edx,%esi
  800f4e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f50:	5b                   	pop    %ebx
  800f51:	5e                   	pop    %esi
  800f52:	5f                   	pop    %edi
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    

00800f55 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	57                   	push   %edi
  800f59:	56                   	push   %esi
  800f5a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f60:	8b 55 08             	mov    0x8(%ebp),%edx
  800f63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f66:	b8 11 00 00 00       	mov    $0x11,%eax
  800f6b:	89 df                	mov    %ebx,%edi
  800f6d:	89 de                	mov    %ebx,%esi
  800f6f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5f                   	pop    %edi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	57                   	push   %edi
  800f7a:	56                   	push   %esi
  800f7b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f81:	8b 55 08             	mov    0x8(%ebp),%edx
  800f84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f87:	b8 12 00 00 00       	mov    $0x12,%eax
  800f8c:	89 df                	mov    %ebx,%edi
  800f8e:	89 de                	mov    %ebx,%esi
  800f90:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f92:	5b                   	pop    %ebx
  800f93:	5e                   	pop    %esi
  800f94:	5f                   	pop    %edi
  800f95:	5d                   	pop    %ebp
  800f96:	c3                   	ret    

00800f97 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
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
  800fab:	b8 13 00 00 00       	mov    $0x13,%eax
  800fb0:	89 df                	mov    %ebx,%edi
  800fb2:	89 de                	mov    %ebx,%esi
  800fb4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	7f 08                	jg     800fc2 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800fc6:	6a 13                	push   $0x13
  800fc8:	68 08 29 80 00       	push   $0x802908
  800fcd:	6a 43                	push   $0x43
  800fcf:	68 25 29 80 00       	push   $0x802925
  800fd4:	e8 76 12 00 00       	call   80224f <_panic>

00800fd9 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fdf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe7:	b8 14 00 00 00       	mov    $0x14,%eax
  800fec:	89 cb                	mov    %ecx,%ebx
  800fee:	89 cf                	mov    %ecx,%edi
  800ff0:	89 ce                	mov    %ecx,%esi
  800ff2:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  800ff4:	5b                   	pop    %ebx
  800ff5:	5e                   	pop    %esi
  800ff6:	5f                   	pop    %edi
  800ff7:	5d                   	pop    %ebp
  800ff8:	c3                   	ret    

00800ff9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	56                   	push   %esi
  800ffd:	53                   	push   %ebx
  800ffe:	8b 75 08             	mov    0x8(%ebp),%esi
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801007:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801009:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80100e:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801011:	83 ec 0c             	sub    $0xc,%esp
  801014:	50                   	push   %eax
  801015:	e8 9a fe ff ff       	call   800eb4 <sys_ipc_recv>
	if(ret < 0){
  80101a:	83 c4 10             	add    $0x10,%esp
  80101d:	85 c0                	test   %eax,%eax
  80101f:	78 2b                	js     80104c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801021:	85 f6                	test   %esi,%esi
  801023:	74 0a                	je     80102f <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801025:	a1 08 40 80 00       	mov    0x804008,%eax
  80102a:	8b 40 78             	mov    0x78(%eax),%eax
  80102d:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80102f:	85 db                	test   %ebx,%ebx
  801031:	74 0a                	je     80103d <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801033:	a1 08 40 80 00       	mov    0x804008,%eax
  801038:	8b 40 7c             	mov    0x7c(%eax),%eax
  80103b:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80103d:	a1 08 40 80 00       	mov    0x804008,%eax
  801042:	8b 40 74             	mov    0x74(%eax),%eax
}
  801045:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5d                   	pop    %ebp
  80104b:	c3                   	ret    
		if(from_env_store)
  80104c:	85 f6                	test   %esi,%esi
  80104e:	74 06                	je     801056 <ipc_recv+0x5d>
			*from_env_store = 0;
  801050:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801056:	85 db                	test   %ebx,%ebx
  801058:	74 eb                	je     801045 <ipc_recv+0x4c>
			*perm_store = 0;
  80105a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801060:	eb e3                	jmp    801045 <ipc_recv+0x4c>

00801062 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	57                   	push   %edi
  801066:	56                   	push   %esi
  801067:	53                   	push   %ebx
  801068:	83 ec 0c             	sub    $0xc,%esp
  80106b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80106e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801071:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801074:	85 db                	test   %ebx,%ebx
  801076:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80107b:	0f 44 d8             	cmove  %eax,%ebx
  80107e:	eb 05                	jmp    801085 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801080:	e8 60 fc ff ff       	call   800ce5 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801085:	ff 75 14             	pushl  0x14(%ebp)
  801088:	53                   	push   %ebx
  801089:	56                   	push   %esi
  80108a:	57                   	push   %edi
  80108b:	e8 01 fe ff ff       	call   800e91 <sys_ipc_try_send>
  801090:	83 c4 10             	add    $0x10,%esp
  801093:	85 c0                	test   %eax,%eax
  801095:	74 1b                	je     8010b2 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801097:	79 e7                	jns    801080 <ipc_send+0x1e>
  801099:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80109c:	74 e2                	je     801080 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80109e:	83 ec 04             	sub    $0x4,%esp
  8010a1:	68 33 29 80 00       	push   $0x802933
  8010a6:	6a 46                	push   $0x46
  8010a8:	68 48 29 80 00       	push   $0x802948
  8010ad:	e8 9d 11 00 00       	call   80224f <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8010b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b5:	5b                   	pop    %ebx
  8010b6:	5e                   	pop    %esi
  8010b7:	5f                   	pop    %edi
  8010b8:	5d                   	pop    %ebp
  8010b9:	c3                   	ret    

008010ba <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8010c0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8010c5:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8010cb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8010d1:	8b 52 50             	mov    0x50(%edx),%edx
  8010d4:	39 ca                	cmp    %ecx,%edx
  8010d6:	74 11                	je     8010e9 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8010d8:	83 c0 01             	add    $0x1,%eax
  8010db:	3d 00 04 00 00       	cmp    $0x400,%eax
  8010e0:	75 e3                	jne    8010c5 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8010e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e7:	eb 0e                	jmp    8010f7 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8010e9:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8010ef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010f4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8010f7:	5d                   	pop    %ebp
  8010f8:	c3                   	ret    

008010f9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	05 00 00 00 30       	add    $0x30000000,%eax
  801104:	c1 e8 0c             	shr    $0xc,%eax
}
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    

00801109 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801114:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801119:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80111e:	5d                   	pop    %ebp
  80111f:	c3                   	ret    

00801120 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801128:	89 c2                	mov    %eax,%edx
  80112a:	c1 ea 16             	shr    $0x16,%edx
  80112d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801134:	f6 c2 01             	test   $0x1,%dl
  801137:	74 2d                	je     801166 <fd_alloc+0x46>
  801139:	89 c2                	mov    %eax,%edx
  80113b:	c1 ea 0c             	shr    $0xc,%edx
  80113e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801145:	f6 c2 01             	test   $0x1,%dl
  801148:	74 1c                	je     801166 <fd_alloc+0x46>
  80114a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80114f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801154:	75 d2                	jne    801128 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80115f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801164:	eb 0a                	jmp    801170 <fd_alloc+0x50>
			*fd_store = fd;
  801166:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801169:	89 01                	mov    %eax,(%ecx)
			return 0;
  80116b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801170:	5d                   	pop    %ebp
  801171:	c3                   	ret    

00801172 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801172:	55                   	push   %ebp
  801173:	89 e5                	mov    %esp,%ebp
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801178:	83 f8 1f             	cmp    $0x1f,%eax
  80117b:	77 30                	ja     8011ad <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80117d:	c1 e0 0c             	shl    $0xc,%eax
  801180:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801185:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80118b:	f6 c2 01             	test   $0x1,%dl
  80118e:	74 24                	je     8011b4 <fd_lookup+0x42>
  801190:	89 c2                	mov    %eax,%edx
  801192:	c1 ea 0c             	shr    $0xc,%edx
  801195:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80119c:	f6 c2 01             	test   $0x1,%dl
  80119f:	74 1a                	je     8011bb <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a4:	89 02                	mov    %eax,(%edx)
	return 0;
  8011a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ab:	5d                   	pop    %ebp
  8011ac:	c3                   	ret    
		return -E_INVAL;
  8011ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011b2:	eb f7                	jmp    8011ab <fd_lookup+0x39>
		return -E_INVAL;
  8011b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011b9:	eb f0                	jmp    8011ab <fd_lookup+0x39>
  8011bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c0:	eb e9                	jmp    8011ab <fd_lookup+0x39>

008011c2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011c2:	55                   	push   %ebp
  8011c3:	89 e5                	mov    %esp,%ebp
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d0:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011d5:	39 08                	cmp    %ecx,(%eax)
  8011d7:	74 38                	je     801211 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011d9:	83 c2 01             	add    $0x1,%edx
  8011dc:	8b 04 95 d0 29 80 00 	mov    0x8029d0(,%edx,4),%eax
  8011e3:	85 c0                	test   %eax,%eax
  8011e5:	75 ee                	jne    8011d5 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011e7:	a1 08 40 80 00       	mov    0x804008,%eax
  8011ec:	8b 40 48             	mov    0x48(%eax),%eax
  8011ef:	83 ec 04             	sub    $0x4,%esp
  8011f2:	51                   	push   %ecx
  8011f3:	50                   	push   %eax
  8011f4:	68 54 29 80 00       	push   $0x802954
  8011f9:	e8 b5 ef ff ff       	call   8001b3 <cprintf>
	*dev = 0;
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801207:	83 c4 10             	add    $0x10,%esp
  80120a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80120f:	c9                   	leave  
  801210:	c3                   	ret    
			*dev = devtab[i];
  801211:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801214:	89 01                	mov    %eax,(%ecx)
			return 0;
  801216:	b8 00 00 00 00       	mov    $0x0,%eax
  80121b:	eb f2                	jmp    80120f <dev_lookup+0x4d>

0080121d <fd_close>:
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	57                   	push   %edi
  801221:	56                   	push   %esi
  801222:	53                   	push   %ebx
  801223:	83 ec 24             	sub    $0x24,%esp
  801226:	8b 75 08             	mov    0x8(%ebp),%esi
  801229:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80122c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80122f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801230:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801236:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801239:	50                   	push   %eax
  80123a:	e8 33 ff ff ff       	call   801172 <fd_lookup>
  80123f:	89 c3                	mov    %eax,%ebx
  801241:	83 c4 10             	add    $0x10,%esp
  801244:	85 c0                	test   %eax,%eax
  801246:	78 05                	js     80124d <fd_close+0x30>
	    || fd != fd2)
  801248:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80124b:	74 16                	je     801263 <fd_close+0x46>
		return (must_exist ? r : 0);
  80124d:	89 f8                	mov    %edi,%eax
  80124f:	84 c0                	test   %al,%al
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
  801256:	0f 44 d8             	cmove  %eax,%ebx
}
  801259:	89 d8                	mov    %ebx,%eax
  80125b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125e:	5b                   	pop    %ebx
  80125f:	5e                   	pop    %esi
  801260:	5f                   	pop    %edi
  801261:	5d                   	pop    %ebp
  801262:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801263:	83 ec 08             	sub    $0x8,%esp
  801266:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801269:	50                   	push   %eax
  80126a:	ff 36                	pushl  (%esi)
  80126c:	e8 51 ff ff ff       	call   8011c2 <dev_lookup>
  801271:	89 c3                	mov    %eax,%ebx
  801273:	83 c4 10             	add    $0x10,%esp
  801276:	85 c0                	test   %eax,%eax
  801278:	78 1a                	js     801294 <fd_close+0x77>
		if (dev->dev_close)
  80127a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80127d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801280:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801285:	85 c0                	test   %eax,%eax
  801287:	74 0b                	je     801294 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801289:	83 ec 0c             	sub    $0xc,%esp
  80128c:	56                   	push   %esi
  80128d:	ff d0                	call   *%eax
  80128f:	89 c3                	mov    %eax,%ebx
  801291:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801294:	83 ec 08             	sub    $0x8,%esp
  801297:	56                   	push   %esi
  801298:	6a 00                	push   $0x0
  80129a:	e8 ea fa ff ff       	call   800d89 <sys_page_unmap>
	return r;
  80129f:	83 c4 10             	add    $0x10,%esp
  8012a2:	eb b5                	jmp    801259 <fd_close+0x3c>

008012a4 <close>:

int
close(int fdnum)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ad:	50                   	push   %eax
  8012ae:	ff 75 08             	pushl  0x8(%ebp)
  8012b1:	e8 bc fe ff ff       	call   801172 <fd_lookup>
  8012b6:	83 c4 10             	add    $0x10,%esp
  8012b9:	85 c0                	test   %eax,%eax
  8012bb:	79 02                	jns    8012bf <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    
		return fd_close(fd, 1);
  8012bf:	83 ec 08             	sub    $0x8,%esp
  8012c2:	6a 01                	push   $0x1
  8012c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c7:	e8 51 ff ff ff       	call   80121d <fd_close>
  8012cc:	83 c4 10             	add    $0x10,%esp
  8012cf:	eb ec                	jmp    8012bd <close+0x19>

008012d1 <close_all>:

void
close_all(void)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	53                   	push   %ebx
  8012d5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012d8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012dd:	83 ec 0c             	sub    $0xc,%esp
  8012e0:	53                   	push   %ebx
  8012e1:	e8 be ff ff ff       	call   8012a4 <close>
	for (i = 0; i < MAXFD; i++)
  8012e6:	83 c3 01             	add    $0x1,%ebx
  8012e9:	83 c4 10             	add    $0x10,%esp
  8012ec:	83 fb 20             	cmp    $0x20,%ebx
  8012ef:	75 ec                	jne    8012dd <close_all+0xc>
}
  8012f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f4:	c9                   	leave  
  8012f5:	c3                   	ret    

008012f6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	57                   	push   %edi
  8012fa:	56                   	push   %esi
  8012fb:	53                   	push   %ebx
  8012fc:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801302:	50                   	push   %eax
  801303:	ff 75 08             	pushl  0x8(%ebp)
  801306:	e8 67 fe ff ff       	call   801172 <fd_lookup>
  80130b:	89 c3                	mov    %eax,%ebx
  80130d:	83 c4 10             	add    $0x10,%esp
  801310:	85 c0                	test   %eax,%eax
  801312:	0f 88 81 00 00 00    	js     801399 <dup+0xa3>
		return r;
	close(newfdnum);
  801318:	83 ec 0c             	sub    $0xc,%esp
  80131b:	ff 75 0c             	pushl  0xc(%ebp)
  80131e:	e8 81 ff ff ff       	call   8012a4 <close>

	newfd = INDEX2FD(newfdnum);
  801323:	8b 75 0c             	mov    0xc(%ebp),%esi
  801326:	c1 e6 0c             	shl    $0xc,%esi
  801329:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80132f:	83 c4 04             	add    $0x4,%esp
  801332:	ff 75 e4             	pushl  -0x1c(%ebp)
  801335:	e8 cf fd ff ff       	call   801109 <fd2data>
  80133a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80133c:	89 34 24             	mov    %esi,(%esp)
  80133f:	e8 c5 fd ff ff       	call   801109 <fd2data>
  801344:	83 c4 10             	add    $0x10,%esp
  801347:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801349:	89 d8                	mov    %ebx,%eax
  80134b:	c1 e8 16             	shr    $0x16,%eax
  80134e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801355:	a8 01                	test   $0x1,%al
  801357:	74 11                	je     80136a <dup+0x74>
  801359:	89 d8                	mov    %ebx,%eax
  80135b:	c1 e8 0c             	shr    $0xc,%eax
  80135e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801365:	f6 c2 01             	test   $0x1,%dl
  801368:	75 39                	jne    8013a3 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80136a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80136d:	89 d0                	mov    %edx,%eax
  80136f:	c1 e8 0c             	shr    $0xc,%eax
  801372:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801379:	83 ec 0c             	sub    $0xc,%esp
  80137c:	25 07 0e 00 00       	and    $0xe07,%eax
  801381:	50                   	push   %eax
  801382:	56                   	push   %esi
  801383:	6a 00                	push   $0x0
  801385:	52                   	push   %edx
  801386:	6a 00                	push   $0x0
  801388:	e8 ba f9 ff ff       	call   800d47 <sys_page_map>
  80138d:	89 c3                	mov    %eax,%ebx
  80138f:	83 c4 20             	add    $0x20,%esp
  801392:	85 c0                	test   %eax,%eax
  801394:	78 31                	js     8013c7 <dup+0xd1>
		goto err;

	return newfdnum;
  801396:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801399:	89 d8                	mov    %ebx,%eax
  80139b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80139e:	5b                   	pop    %ebx
  80139f:	5e                   	pop    %esi
  8013a0:	5f                   	pop    %edi
  8013a1:	5d                   	pop    %ebp
  8013a2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013a3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013aa:	83 ec 0c             	sub    $0xc,%esp
  8013ad:	25 07 0e 00 00       	and    $0xe07,%eax
  8013b2:	50                   	push   %eax
  8013b3:	57                   	push   %edi
  8013b4:	6a 00                	push   $0x0
  8013b6:	53                   	push   %ebx
  8013b7:	6a 00                	push   $0x0
  8013b9:	e8 89 f9 ff ff       	call   800d47 <sys_page_map>
  8013be:	89 c3                	mov    %eax,%ebx
  8013c0:	83 c4 20             	add    $0x20,%esp
  8013c3:	85 c0                	test   %eax,%eax
  8013c5:	79 a3                	jns    80136a <dup+0x74>
	sys_page_unmap(0, newfd);
  8013c7:	83 ec 08             	sub    $0x8,%esp
  8013ca:	56                   	push   %esi
  8013cb:	6a 00                	push   $0x0
  8013cd:	e8 b7 f9 ff ff       	call   800d89 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013d2:	83 c4 08             	add    $0x8,%esp
  8013d5:	57                   	push   %edi
  8013d6:	6a 00                	push   $0x0
  8013d8:	e8 ac f9 ff ff       	call   800d89 <sys_page_unmap>
	return r;
  8013dd:	83 c4 10             	add    $0x10,%esp
  8013e0:	eb b7                	jmp    801399 <dup+0xa3>

008013e2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
  8013e5:	53                   	push   %ebx
  8013e6:	83 ec 1c             	sub    $0x1c,%esp
  8013e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ef:	50                   	push   %eax
  8013f0:	53                   	push   %ebx
  8013f1:	e8 7c fd ff ff       	call   801172 <fd_lookup>
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	78 3f                	js     80143c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013fd:	83 ec 08             	sub    $0x8,%esp
  801400:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801403:	50                   	push   %eax
  801404:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801407:	ff 30                	pushl  (%eax)
  801409:	e8 b4 fd ff ff       	call   8011c2 <dev_lookup>
  80140e:	83 c4 10             	add    $0x10,%esp
  801411:	85 c0                	test   %eax,%eax
  801413:	78 27                	js     80143c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801415:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801418:	8b 42 08             	mov    0x8(%edx),%eax
  80141b:	83 e0 03             	and    $0x3,%eax
  80141e:	83 f8 01             	cmp    $0x1,%eax
  801421:	74 1e                	je     801441 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801426:	8b 40 08             	mov    0x8(%eax),%eax
  801429:	85 c0                	test   %eax,%eax
  80142b:	74 35                	je     801462 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80142d:	83 ec 04             	sub    $0x4,%esp
  801430:	ff 75 10             	pushl  0x10(%ebp)
  801433:	ff 75 0c             	pushl  0xc(%ebp)
  801436:	52                   	push   %edx
  801437:	ff d0                	call   *%eax
  801439:	83 c4 10             	add    $0x10,%esp
}
  80143c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80143f:	c9                   	leave  
  801440:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801441:	a1 08 40 80 00       	mov    0x804008,%eax
  801446:	8b 40 48             	mov    0x48(%eax),%eax
  801449:	83 ec 04             	sub    $0x4,%esp
  80144c:	53                   	push   %ebx
  80144d:	50                   	push   %eax
  80144e:	68 95 29 80 00       	push   $0x802995
  801453:	e8 5b ed ff ff       	call   8001b3 <cprintf>
		return -E_INVAL;
  801458:	83 c4 10             	add    $0x10,%esp
  80145b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801460:	eb da                	jmp    80143c <read+0x5a>
		return -E_NOT_SUPP;
  801462:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801467:	eb d3                	jmp    80143c <read+0x5a>

00801469 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
  80146c:	57                   	push   %edi
  80146d:	56                   	push   %esi
  80146e:	53                   	push   %ebx
  80146f:	83 ec 0c             	sub    $0xc,%esp
  801472:	8b 7d 08             	mov    0x8(%ebp),%edi
  801475:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801478:	bb 00 00 00 00       	mov    $0x0,%ebx
  80147d:	39 f3                	cmp    %esi,%ebx
  80147f:	73 23                	jae    8014a4 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801481:	83 ec 04             	sub    $0x4,%esp
  801484:	89 f0                	mov    %esi,%eax
  801486:	29 d8                	sub    %ebx,%eax
  801488:	50                   	push   %eax
  801489:	89 d8                	mov    %ebx,%eax
  80148b:	03 45 0c             	add    0xc(%ebp),%eax
  80148e:	50                   	push   %eax
  80148f:	57                   	push   %edi
  801490:	e8 4d ff ff ff       	call   8013e2 <read>
		if (m < 0)
  801495:	83 c4 10             	add    $0x10,%esp
  801498:	85 c0                	test   %eax,%eax
  80149a:	78 06                	js     8014a2 <readn+0x39>
			return m;
		if (m == 0)
  80149c:	74 06                	je     8014a4 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80149e:	01 c3                	add    %eax,%ebx
  8014a0:	eb db                	jmp    80147d <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014a2:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014a4:	89 d8                	mov    %ebx,%eax
  8014a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a9:	5b                   	pop    %ebx
  8014aa:	5e                   	pop    %esi
  8014ab:	5f                   	pop    %edi
  8014ac:	5d                   	pop    %ebp
  8014ad:	c3                   	ret    

008014ae <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	53                   	push   %ebx
  8014b2:	83 ec 1c             	sub    $0x1c,%esp
  8014b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014bb:	50                   	push   %eax
  8014bc:	53                   	push   %ebx
  8014bd:	e8 b0 fc ff ff       	call   801172 <fd_lookup>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	78 3a                	js     801503 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c9:	83 ec 08             	sub    $0x8,%esp
  8014cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014cf:	50                   	push   %eax
  8014d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d3:	ff 30                	pushl  (%eax)
  8014d5:	e8 e8 fc ff ff       	call   8011c2 <dev_lookup>
  8014da:	83 c4 10             	add    $0x10,%esp
  8014dd:	85 c0                	test   %eax,%eax
  8014df:	78 22                	js     801503 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014e8:	74 1e                	je     801508 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ed:	8b 52 0c             	mov    0xc(%edx),%edx
  8014f0:	85 d2                	test   %edx,%edx
  8014f2:	74 35                	je     801529 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014f4:	83 ec 04             	sub    $0x4,%esp
  8014f7:	ff 75 10             	pushl  0x10(%ebp)
  8014fa:	ff 75 0c             	pushl  0xc(%ebp)
  8014fd:	50                   	push   %eax
  8014fe:	ff d2                	call   *%edx
  801500:	83 c4 10             	add    $0x10,%esp
}
  801503:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801506:	c9                   	leave  
  801507:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801508:	a1 08 40 80 00       	mov    0x804008,%eax
  80150d:	8b 40 48             	mov    0x48(%eax),%eax
  801510:	83 ec 04             	sub    $0x4,%esp
  801513:	53                   	push   %ebx
  801514:	50                   	push   %eax
  801515:	68 b1 29 80 00       	push   $0x8029b1
  80151a:	e8 94 ec ff ff       	call   8001b3 <cprintf>
		return -E_INVAL;
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801527:	eb da                	jmp    801503 <write+0x55>
		return -E_NOT_SUPP;
  801529:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80152e:	eb d3                	jmp    801503 <write+0x55>

00801530 <seek>:

int
seek(int fdnum, off_t offset)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801536:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801539:	50                   	push   %eax
  80153a:	ff 75 08             	pushl  0x8(%ebp)
  80153d:	e8 30 fc ff ff       	call   801172 <fd_lookup>
  801542:	83 c4 10             	add    $0x10,%esp
  801545:	85 c0                	test   %eax,%eax
  801547:	78 0e                	js     801557 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801549:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801552:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	53                   	push   %ebx
  80155d:	83 ec 1c             	sub    $0x1c,%esp
  801560:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801563:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801566:	50                   	push   %eax
  801567:	53                   	push   %ebx
  801568:	e8 05 fc ff ff       	call   801172 <fd_lookup>
  80156d:	83 c4 10             	add    $0x10,%esp
  801570:	85 c0                	test   %eax,%eax
  801572:	78 37                	js     8015ab <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801574:	83 ec 08             	sub    $0x8,%esp
  801577:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80157a:	50                   	push   %eax
  80157b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157e:	ff 30                	pushl  (%eax)
  801580:	e8 3d fc ff ff       	call   8011c2 <dev_lookup>
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	85 c0                	test   %eax,%eax
  80158a:	78 1f                	js     8015ab <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80158c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801593:	74 1b                	je     8015b0 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801595:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801598:	8b 52 18             	mov    0x18(%edx),%edx
  80159b:	85 d2                	test   %edx,%edx
  80159d:	74 32                	je     8015d1 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	ff 75 0c             	pushl  0xc(%ebp)
  8015a5:	50                   	push   %eax
  8015a6:	ff d2                	call   *%edx
  8015a8:	83 c4 10             	add    $0x10,%esp
}
  8015ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015b0:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015b5:	8b 40 48             	mov    0x48(%eax),%eax
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	53                   	push   %ebx
  8015bc:	50                   	push   %eax
  8015bd:	68 74 29 80 00       	push   $0x802974
  8015c2:	e8 ec eb ff ff       	call   8001b3 <cprintf>
		return -E_INVAL;
  8015c7:	83 c4 10             	add    $0x10,%esp
  8015ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015cf:	eb da                	jmp    8015ab <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015d6:	eb d3                	jmp    8015ab <ftruncate+0x52>

008015d8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	53                   	push   %ebx
  8015dc:	83 ec 1c             	sub    $0x1c,%esp
  8015df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e5:	50                   	push   %eax
  8015e6:	ff 75 08             	pushl  0x8(%ebp)
  8015e9:	e8 84 fb ff ff       	call   801172 <fd_lookup>
  8015ee:	83 c4 10             	add    $0x10,%esp
  8015f1:	85 c0                	test   %eax,%eax
  8015f3:	78 4b                	js     801640 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f5:	83 ec 08             	sub    $0x8,%esp
  8015f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fb:	50                   	push   %eax
  8015fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ff:	ff 30                	pushl  (%eax)
  801601:	e8 bc fb ff ff       	call   8011c2 <dev_lookup>
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	85 c0                	test   %eax,%eax
  80160b:	78 33                	js     801640 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80160d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801610:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801614:	74 2f                	je     801645 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801616:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801619:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801620:	00 00 00 
	stat->st_isdir = 0;
  801623:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80162a:	00 00 00 
	stat->st_dev = dev;
  80162d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801633:	83 ec 08             	sub    $0x8,%esp
  801636:	53                   	push   %ebx
  801637:	ff 75 f0             	pushl  -0x10(%ebp)
  80163a:	ff 50 14             	call   *0x14(%eax)
  80163d:	83 c4 10             	add    $0x10,%esp
}
  801640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801643:	c9                   	leave  
  801644:	c3                   	ret    
		return -E_NOT_SUPP;
  801645:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80164a:	eb f4                	jmp    801640 <fstat+0x68>

0080164c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	56                   	push   %esi
  801650:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801651:	83 ec 08             	sub    $0x8,%esp
  801654:	6a 00                	push   $0x0
  801656:	ff 75 08             	pushl  0x8(%ebp)
  801659:	e8 22 02 00 00       	call   801880 <open>
  80165e:	89 c3                	mov    %eax,%ebx
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	85 c0                	test   %eax,%eax
  801665:	78 1b                	js     801682 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801667:	83 ec 08             	sub    $0x8,%esp
  80166a:	ff 75 0c             	pushl  0xc(%ebp)
  80166d:	50                   	push   %eax
  80166e:	e8 65 ff ff ff       	call   8015d8 <fstat>
  801673:	89 c6                	mov    %eax,%esi
	close(fd);
  801675:	89 1c 24             	mov    %ebx,(%esp)
  801678:	e8 27 fc ff ff       	call   8012a4 <close>
	return r;
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	89 f3                	mov    %esi,%ebx
}
  801682:	89 d8                	mov    %ebx,%eax
  801684:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801687:	5b                   	pop    %ebx
  801688:	5e                   	pop    %esi
  801689:	5d                   	pop    %ebp
  80168a:	c3                   	ret    

0080168b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	56                   	push   %esi
  80168f:	53                   	push   %ebx
  801690:	89 c6                	mov    %eax,%esi
  801692:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801694:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80169b:	74 27                	je     8016c4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80169d:	6a 07                	push   $0x7
  80169f:	68 00 50 80 00       	push   $0x805000
  8016a4:	56                   	push   %esi
  8016a5:	ff 35 00 40 80 00    	pushl  0x804000
  8016ab:	e8 b2 f9 ff ff       	call   801062 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016b0:	83 c4 0c             	add    $0xc,%esp
  8016b3:	6a 00                	push   $0x0
  8016b5:	53                   	push   %ebx
  8016b6:	6a 00                	push   $0x0
  8016b8:	e8 3c f9 ff ff       	call   800ff9 <ipc_recv>
}
  8016bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c0:	5b                   	pop    %ebx
  8016c1:	5e                   	pop    %esi
  8016c2:	5d                   	pop    %ebp
  8016c3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016c4:	83 ec 0c             	sub    $0xc,%esp
  8016c7:	6a 01                	push   $0x1
  8016c9:	e8 ec f9 ff ff       	call   8010ba <ipc_find_env>
  8016ce:	a3 00 40 80 00       	mov    %eax,0x804000
  8016d3:	83 c4 10             	add    $0x10,%esp
  8016d6:	eb c5                	jmp    80169d <fsipc+0x12>

008016d8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ec:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f6:	b8 02 00 00 00       	mov    $0x2,%eax
  8016fb:	e8 8b ff ff ff       	call   80168b <fsipc>
}
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <devfile_flush>:
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	8b 40 0c             	mov    0xc(%eax),%eax
  80170e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801713:	ba 00 00 00 00       	mov    $0x0,%edx
  801718:	b8 06 00 00 00       	mov    $0x6,%eax
  80171d:	e8 69 ff ff ff       	call   80168b <fsipc>
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <devfile_stat>:
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
  801727:	53                   	push   %ebx
  801728:	83 ec 04             	sub    $0x4,%esp
  80172b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
  801731:	8b 40 0c             	mov    0xc(%eax),%eax
  801734:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801739:	ba 00 00 00 00       	mov    $0x0,%edx
  80173e:	b8 05 00 00 00       	mov    $0x5,%eax
  801743:	e8 43 ff ff ff       	call   80168b <fsipc>
  801748:	85 c0                	test   %eax,%eax
  80174a:	78 2c                	js     801778 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80174c:	83 ec 08             	sub    $0x8,%esp
  80174f:	68 00 50 80 00       	push   $0x805000
  801754:	53                   	push   %ebx
  801755:	e8 b8 f1 ff ff       	call   800912 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80175a:	a1 80 50 80 00       	mov    0x805080,%eax
  80175f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801765:	a1 84 50 80 00       	mov    0x805084,%eax
  80176a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801770:	83 c4 10             	add    $0x10,%esp
  801773:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801778:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <devfile_write>:
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	53                   	push   %ebx
  801781:	83 ec 08             	sub    $0x8,%esp
  801784:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
  80178a:	8b 40 0c             	mov    0xc(%eax),%eax
  80178d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801792:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801798:	53                   	push   %ebx
  801799:	ff 75 0c             	pushl  0xc(%ebp)
  80179c:	68 08 50 80 00       	push   $0x805008
  8017a1:	e8 5c f3 ff ff       	call   800b02 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ab:	b8 04 00 00 00       	mov    $0x4,%eax
  8017b0:	e8 d6 fe ff ff       	call   80168b <fsipc>
  8017b5:	83 c4 10             	add    $0x10,%esp
  8017b8:	85 c0                	test   %eax,%eax
  8017ba:	78 0b                	js     8017c7 <devfile_write+0x4a>
	assert(r <= n);
  8017bc:	39 d8                	cmp    %ebx,%eax
  8017be:	77 0c                	ja     8017cc <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017c0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017c5:	7f 1e                	jg     8017e5 <devfile_write+0x68>
}
  8017c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    
	assert(r <= n);
  8017cc:	68 e4 29 80 00       	push   $0x8029e4
  8017d1:	68 eb 29 80 00       	push   $0x8029eb
  8017d6:	68 98 00 00 00       	push   $0x98
  8017db:	68 00 2a 80 00       	push   $0x802a00
  8017e0:	e8 6a 0a 00 00       	call   80224f <_panic>
	assert(r <= PGSIZE);
  8017e5:	68 0b 2a 80 00       	push   $0x802a0b
  8017ea:	68 eb 29 80 00       	push   $0x8029eb
  8017ef:	68 99 00 00 00       	push   $0x99
  8017f4:	68 00 2a 80 00       	push   $0x802a00
  8017f9:	e8 51 0a 00 00       	call   80224f <_panic>

008017fe <devfile_read>:
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	56                   	push   %esi
  801802:	53                   	push   %ebx
  801803:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	8b 40 0c             	mov    0xc(%eax),%eax
  80180c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801811:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801817:	ba 00 00 00 00       	mov    $0x0,%edx
  80181c:	b8 03 00 00 00       	mov    $0x3,%eax
  801821:	e8 65 fe ff ff       	call   80168b <fsipc>
  801826:	89 c3                	mov    %eax,%ebx
  801828:	85 c0                	test   %eax,%eax
  80182a:	78 1f                	js     80184b <devfile_read+0x4d>
	assert(r <= n);
  80182c:	39 f0                	cmp    %esi,%eax
  80182e:	77 24                	ja     801854 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801830:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801835:	7f 33                	jg     80186a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801837:	83 ec 04             	sub    $0x4,%esp
  80183a:	50                   	push   %eax
  80183b:	68 00 50 80 00       	push   $0x805000
  801840:	ff 75 0c             	pushl  0xc(%ebp)
  801843:	e8 58 f2 ff ff       	call   800aa0 <memmove>
	return r;
  801848:	83 c4 10             	add    $0x10,%esp
}
  80184b:	89 d8                	mov    %ebx,%eax
  80184d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801850:	5b                   	pop    %ebx
  801851:	5e                   	pop    %esi
  801852:	5d                   	pop    %ebp
  801853:	c3                   	ret    
	assert(r <= n);
  801854:	68 e4 29 80 00       	push   $0x8029e4
  801859:	68 eb 29 80 00       	push   $0x8029eb
  80185e:	6a 7c                	push   $0x7c
  801860:	68 00 2a 80 00       	push   $0x802a00
  801865:	e8 e5 09 00 00       	call   80224f <_panic>
	assert(r <= PGSIZE);
  80186a:	68 0b 2a 80 00       	push   $0x802a0b
  80186f:	68 eb 29 80 00       	push   $0x8029eb
  801874:	6a 7d                	push   $0x7d
  801876:	68 00 2a 80 00       	push   $0x802a00
  80187b:	e8 cf 09 00 00       	call   80224f <_panic>

00801880 <open>:
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	56                   	push   %esi
  801884:	53                   	push   %ebx
  801885:	83 ec 1c             	sub    $0x1c,%esp
  801888:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80188b:	56                   	push   %esi
  80188c:	e8 48 f0 ff ff       	call   8008d9 <strlen>
  801891:	83 c4 10             	add    $0x10,%esp
  801894:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801899:	7f 6c                	jg     801907 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80189b:	83 ec 0c             	sub    $0xc,%esp
  80189e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a1:	50                   	push   %eax
  8018a2:	e8 79 f8 ff ff       	call   801120 <fd_alloc>
  8018a7:	89 c3                	mov    %eax,%ebx
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 3c                	js     8018ec <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018b0:	83 ec 08             	sub    $0x8,%esp
  8018b3:	56                   	push   %esi
  8018b4:	68 00 50 80 00       	push   $0x805000
  8018b9:	e8 54 f0 ff ff       	call   800912 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c1:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ce:	e8 b8 fd ff ff       	call   80168b <fsipc>
  8018d3:	89 c3                	mov    %eax,%ebx
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	78 19                	js     8018f5 <open+0x75>
	return fd2num(fd);
  8018dc:	83 ec 0c             	sub    $0xc,%esp
  8018df:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e2:	e8 12 f8 ff ff       	call   8010f9 <fd2num>
  8018e7:	89 c3                	mov    %eax,%ebx
  8018e9:	83 c4 10             	add    $0x10,%esp
}
  8018ec:	89 d8                	mov    %ebx,%eax
  8018ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f1:	5b                   	pop    %ebx
  8018f2:	5e                   	pop    %esi
  8018f3:	5d                   	pop    %ebp
  8018f4:	c3                   	ret    
		fd_close(fd, 0);
  8018f5:	83 ec 08             	sub    $0x8,%esp
  8018f8:	6a 00                	push   $0x0
  8018fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8018fd:	e8 1b f9 ff ff       	call   80121d <fd_close>
		return r;
  801902:	83 c4 10             	add    $0x10,%esp
  801905:	eb e5                	jmp    8018ec <open+0x6c>
		return -E_BAD_PATH;
  801907:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80190c:	eb de                	jmp    8018ec <open+0x6c>

0080190e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801914:	ba 00 00 00 00       	mov    $0x0,%edx
  801919:	b8 08 00 00 00       	mov    $0x8,%eax
  80191e:	e8 68 fd ff ff       	call   80168b <fsipc>
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80192b:	68 17 2a 80 00       	push   $0x802a17
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	e8 da ef ff ff       	call   800912 <strcpy>
	return 0;
}
  801938:	b8 00 00 00 00       	mov    $0x0,%eax
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <devsock_close>:
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
  801942:	53                   	push   %ebx
  801943:	83 ec 10             	sub    $0x10,%esp
  801946:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801949:	53                   	push   %ebx
  80194a:	e8 61 09 00 00       	call   8022b0 <pageref>
  80194f:	83 c4 10             	add    $0x10,%esp
		return 0;
  801952:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801957:	83 f8 01             	cmp    $0x1,%eax
  80195a:	74 07                	je     801963 <devsock_close+0x24>
}
  80195c:	89 d0                	mov    %edx,%eax
  80195e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801961:	c9                   	leave  
  801962:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801963:	83 ec 0c             	sub    $0xc,%esp
  801966:	ff 73 0c             	pushl  0xc(%ebx)
  801969:	e8 b9 02 00 00       	call   801c27 <nsipc_close>
  80196e:	89 c2                	mov    %eax,%edx
  801970:	83 c4 10             	add    $0x10,%esp
  801973:	eb e7                	jmp    80195c <devsock_close+0x1d>

00801975 <devsock_write>:
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80197b:	6a 00                	push   $0x0
  80197d:	ff 75 10             	pushl  0x10(%ebp)
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	ff 70 0c             	pushl  0xc(%eax)
  801989:	e8 76 03 00 00       	call   801d04 <nsipc_send>
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <devsock_read>:
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801996:	6a 00                	push   $0x0
  801998:	ff 75 10             	pushl  0x10(%ebp)
  80199b:	ff 75 0c             	pushl  0xc(%ebp)
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	ff 70 0c             	pushl  0xc(%eax)
  8019a4:	e8 ef 02 00 00       	call   801c98 <nsipc_recv>
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <fd2sockid>:
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019b1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019b4:	52                   	push   %edx
  8019b5:	50                   	push   %eax
  8019b6:	e8 b7 f7 ff ff       	call   801172 <fd_lookup>
  8019bb:	83 c4 10             	add    $0x10,%esp
  8019be:	85 c0                	test   %eax,%eax
  8019c0:	78 10                	js     8019d2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8019c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8019cb:	39 08                	cmp    %ecx,(%eax)
  8019cd:	75 05                	jne    8019d4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8019cf:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    
		return -E_NOT_SUPP;
  8019d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019d9:	eb f7                	jmp    8019d2 <fd2sockid+0x27>

008019db <alloc_sockfd>:
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	56                   	push   %esi
  8019df:	53                   	push   %ebx
  8019e0:	83 ec 1c             	sub    $0x1c,%esp
  8019e3:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8019e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e8:	50                   	push   %eax
  8019e9:	e8 32 f7 ff ff       	call   801120 <fd_alloc>
  8019ee:	89 c3                	mov    %eax,%ebx
  8019f0:	83 c4 10             	add    $0x10,%esp
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	78 43                	js     801a3a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019f7:	83 ec 04             	sub    $0x4,%esp
  8019fa:	68 07 04 00 00       	push   $0x407
  8019ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801a02:	6a 00                	push   $0x0
  801a04:	e8 fb f2 ff ff       	call   800d04 <sys_page_alloc>
  801a09:	89 c3                	mov    %eax,%ebx
  801a0b:	83 c4 10             	add    $0x10,%esp
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	78 28                	js     801a3a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a15:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a1b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a20:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a27:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a2a:	83 ec 0c             	sub    $0xc,%esp
  801a2d:	50                   	push   %eax
  801a2e:	e8 c6 f6 ff ff       	call   8010f9 <fd2num>
  801a33:	89 c3                	mov    %eax,%ebx
  801a35:	83 c4 10             	add    $0x10,%esp
  801a38:	eb 0c                	jmp    801a46 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a3a:	83 ec 0c             	sub    $0xc,%esp
  801a3d:	56                   	push   %esi
  801a3e:	e8 e4 01 00 00       	call   801c27 <nsipc_close>
		return r;
  801a43:	83 c4 10             	add    $0x10,%esp
}
  801a46:	89 d8                	mov    %ebx,%eax
  801a48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4b:	5b                   	pop    %ebx
  801a4c:	5e                   	pop    %esi
  801a4d:	5d                   	pop    %ebp
  801a4e:	c3                   	ret    

00801a4f <accept>:
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a55:	8b 45 08             	mov    0x8(%ebp),%eax
  801a58:	e8 4e ff ff ff       	call   8019ab <fd2sockid>
  801a5d:	85 c0                	test   %eax,%eax
  801a5f:	78 1b                	js     801a7c <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a61:	83 ec 04             	sub    $0x4,%esp
  801a64:	ff 75 10             	pushl  0x10(%ebp)
  801a67:	ff 75 0c             	pushl  0xc(%ebp)
  801a6a:	50                   	push   %eax
  801a6b:	e8 0e 01 00 00       	call   801b7e <nsipc_accept>
  801a70:	83 c4 10             	add    $0x10,%esp
  801a73:	85 c0                	test   %eax,%eax
  801a75:	78 05                	js     801a7c <accept+0x2d>
	return alloc_sockfd(r);
  801a77:	e8 5f ff ff ff       	call   8019db <alloc_sockfd>
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <bind>:
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
  801a87:	e8 1f ff ff ff       	call   8019ab <fd2sockid>
  801a8c:	85 c0                	test   %eax,%eax
  801a8e:	78 12                	js     801aa2 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a90:	83 ec 04             	sub    $0x4,%esp
  801a93:	ff 75 10             	pushl  0x10(%ebp)
  801a96:	ff 75 0c             	pushl  0xc(%ebp)
  801a99:	50                   	push   %eax
  801a9a:	e8 31 01 00 00       	call   801bd0 <nsipc_bind>
  801a9f:	83 c4 10             	add    $0x10,%esp
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <shutdown>:
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	e8 f9 fe ff ff       	call   8019ab <fd2sockid>
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	78 0f                	js     801ac5 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ab6:	83 ec 08             	sub    $0x8,%esp
  801ab9:	ff 75 0c             	pushl  0xc(%ebp)
  801abc:	50                   	push   %eax
  801abd:	e8 43 01 00 00       	call   801c05 <nsipc_shutdown>
  801ac2:	83 c4 10             	add    $0x10,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <connect>:
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	e8 d6 fe ff ff       	call   8019ab <fd2sockid>
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	78 12                	js     801aeb <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ad9:	83 ec 04             	sub    $0x4,%esp
  801adc:	ff 75 10             	pushl  0x10(%ebp)
  801adf:	ff 75 0c             	pushl  0xc(%ebp)
  801ae2:	50                   	push   %eax
  801ae3:	e8 59 01 00 00       	call   801c41 <nsipc_connect>
  801ae8:	83 c4 10             	add    $0x10,%esp
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <listen>:
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
  801af0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	e8 b0 fe ff ff       	call   8019ab <fd2sockid>
  801afb:	85 c0                	test   %eax,%eax
  801afd:	78 0f                	js     801b0e <listen+0x21>
	return nsipc_listen(r, backlog);
  801aff:	83 ec 08             	sub    $0x8,%esp
  801b02:	ff 75 0c             	pushl  0xc(%ebp)
  801b05:	50                   	push   %eax
  801b06:	e8 6b 01 00 00       	call   801c76 <nsipc_listen>
  801b0b:	83 c4 10             	add    $0x10,%esp
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b16:	ff 75 10             	pushl  0x10(%ebp)
  801b19:	ff 75 0c             	pushl  0xc(%ebp)
  801b1c:	ff 75 08             	pushl  0x8(%ebp)
  801b1f:	e8 3e 02 00 00       	call   801d62 <nsipc_socket>
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	85 c0                	test   %eax,%eax
  801b29:	78 05                	js     801b30 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b2b:	e8 ab fe ff ff       	call   8019db <alloc_sockfd>
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	53                   	push   %ebx
  801b36:	83 ec 04             	sub    $0x4,%esp
  801b39:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b3b:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b42:	74 26                	je     801b6a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b44:	6a 07                	push   $0x7
  801b46:	68 00 60 80 00       	push   $0x806000
  801b4b:	53                   	push   %ebx
  801b4c:	ff 35 04 40 80 00    	pushl  0x804004
  801b52:	e8 0b f5 ff ff       	call   801062 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b57:	83 c4 0c             	add    $0xc,%esp
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	e8 94 f4 ff ff       	call   800ff9 <ipc_recv>
}
  801b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b6a:	83 ec 0c             	sub    $0xc,%esp
  801b6d:	6a 02                	push   $0x2
  801b6f:	e8 46 f5 ff ff       	call   8010ba <ipc_find_env>
  801b74:	a3 04 40 80 00       	mov    %eax,0x804004
  801b79:	83 c4 10             	add    $0x10,%esp
  801b7c:	eb c6                	jmp    801b44 <nsipc+0x12>

00801b7e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	56                   	push   %esi
  801b82:	53                   	push   %ebx
  801b83:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b8e:	8b 06                	mov    (%esi),%eax
  801b90:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b95:	b8 01 00 00 00       	mov    $0x1,%eax
  801b9a:	e8 93 ff ff ff       	call   801b32 <nsipc>
  801b9f:	89 c3                	mov    %eax,%ebx
  801ba1:	85 c0                	test   %eax,%eax
  801ba3:	79 09                	jns    801bae <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ba5:	89 d8                	mov    %ebx,%eax
  801ba7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801baa:	5b                   	pop    %ebx
  801bab:	5e                   	pop    %esi
  801bac:	5d                   	pop    %ebp
  801bad:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bae:	83 ec 04             	sub    $0x4,%esp
  801bb1:	ff 35 10 60 80 00    	pushl  0x806010
  801bb7:	68 00 60 80 00       	push   $0x806000
  801bbc:	ff 75 0c             	pushl  0xc(%ebp)
  801bbf:	e8 dc ee ff ff       	call   800aa0 <memmove>
		*addrlen = ret->ret_addrlen;
  801bc4:	a1 10 60 80 00       	mov    0x806010,%eax
  801bc9:	89 06                	mov    %eax,(%esi)
  801bcb:	83 c4 10             	add    $0x10,%esp
	return r;
  801bce:	eb d5                	jmp    801ba5 <nsipc_accept+0x27>

00801bd0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	53                   	push   %ebx
  801bd4:	83 ec 08             	sub    $0x8,%esp
  801bd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801be2:	53                   	push   %ebx
  801be3:	ff 75 0c             	pushl  0xc(%ebp)
  801be6:	68 04 60 80 00       	push   $0x806004
  801beb:	e8 b0 ee ff ff       	call   800aa0 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801bf0:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801bf6:	b8 02 00 00 00       	mov    $0x2,%eax
  801bfb:	e8 32 ff ff ff       	call   801b32 <nsipc>
}
  801c00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c16:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c1b:	b8 03 00 00 00       	mov    $0x3,%eax
  801c20:	e8 0d ff ff ff       	call   801b32 <nsipc>
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <nsipc_close>:

int
nsipc_close(int s)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c35:	b8 04 00 00 00       	mov    $0x4,%eax
  801c3a:	e8 f3 fe ff ff       	call   801b32 <nsipc>
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	53                   	push   %ebx
  801c45:	83 ec 08             	sub    $0x8,%esp
  801c48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c53:	53                   	push   %ebx
  801c54:	ff 75 0c             	pushl  0xc(%ebp)
  801c57:	68 04 60 80 00       	push   $0x806004
  801c5c:	e8 3f ee ff ff       	call   800aa0 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c61:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c67:	b8 05 00 00 00       	mov    $0x5,%eax
  801c6c:	e8 c1 fe ff ff       	call   801b32 <nsipc>
}
  801c71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c87:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c8c:	b8 06 00 00 00       	mov    $0x6,%eax
  801c91:	e8 9c fe ff ff       	call   801b32 <nsipc>
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	56                   	push   %esi
  801c9c:	53                   	push   %ebx
  801c9d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801ca8:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801cae:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb1:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cb6:	b8 07 00 00 00       	mov    $0x7,%eax
  801cbb:	e8 72 fe ff ff       	call   801b32 <nsipc>
  801cc0:	89 c3                	mov    %eax,%ebx
  801cc2:	85 c0                	test   %eax,%eax
  801cc4:	78 1f                	js     801ce5 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801cc6:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ccb:	7f 21                	jg     801cee <nsipc_recv+0x56>
  801ccd:	39 c6                	cmp    %eax,%esi
  801ccf:	7c 1d                	jl     801cee <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801cd1:	83 ec 04             	sub    $0x4,%esp
  801cd4:	50                   	push   %eax
  801cd5:	68 00 60 80 00       	push   $0x806000
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	e8 be ed ff ff       	call   800aa0 <memmove>
  801ce2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ce5:	89 d8                	mov    %ebx,%eax
  801ce7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cea:	5b                   	pop    %ebx
  801ceb:	5e                   	pop    %esi
  801cec:	5d                   	pop    %ebp
  801ced:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801cee:	68 23 2a 80 00       	push   $0x802a23
  801cf3:	68 eb 29 80 00       	push   $0x8029eb
  801cf8:	6a 62                	push   $0x62
  801cfa:	68 38 2a 80 00       	push   $0x802a38
  801cff:	e8 4b 05 00 00       	call   80224f <_panic>

00801d04 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	53                   	push   %ebx
  801d08:	83 ec 04             	sub    $0x4,%esp
  801d0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d16:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d1c:	7f 2e                	jg     801d4c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d1e:	83 ec 04             	sub    $0x4,%esp
  801d21:	53                   	push   %ebx
  801d22:	ff 75 0c             	pushl  0xc(%ebp)
  801d25:	68 0c 60 80 00       	push   $0x80600c
  801d2a:	e8 71 ed ff ff       	call   800aa0 <memmove>
	nsipcbuf.send.req_size = size;
  801d2f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d35:	8b 45 14             	mov    0x14(%ebp),%eax
  801d38:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d3d:	b8 08 00 00 00       	mov    $0x8,%eax
  801d42:	e8 eb fd ff ff       	call   801b32 <nsipc>
}
  801d47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    
	assert(size < 1600);
  801d4c:	68 44 2a 80 00       	push   $0x802a44
  801d51:	68 eb 29 80 00       	push   $0x8029eb
  801d56:	6a 6d                	push   $0x6d
  801d58:	68 38 2a 80 00       	push   $0x802a38
  801d5d:	e8 ed 04 00 00       	call   80224f <_panic>

00801d62 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d73:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d78:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d80:	b8 09 00 00 00       	mov    $0x9,%eax
  801d85:	e8 a8 fd ff ff       	call   801b32 <nsipc>
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	56                   	push   %esi
  801d90:	53                   	push   %ebx
  801d91:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d94:	83 ec 0c             	sub    $0xc,%esp
  801d97:	ff 75 08             	pushl  0x8(%ebp)
  801d9a:	e8 6a f3 ff ff       	call   801109 <fd2data>
  801d9f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801da1:	83 c4 08             	add    $0x8,%esp
  801da4:	68 50 2a 80 00       	push   $0x802a50
  801da9:	53                   	push   %ebx
  801daa:	e8 63 eb ff ff       	call   800912 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801daf:	8b 46 04             	mov    0x4(%esi),%eax
  801db2:	2b 06                	sub    (%esi),%eax
  801db4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801dba:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dc1:	00 00 00 
	stat->st_dev = &devpipe;
  801dc4:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801dcb:	30 80 00 
	return 0;
}
  801dce:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd6:	5b                   	pop    %ebx
  801dd7:	5e                   	pop    %esi
  801dd8:	5d                   	pop    %ebp
  801dd9:	c3                   	ret    

00801dda <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	53                   	push   %ebx
  801dde:	83 ec 0c             	sub    $0xc,%esp
  801de1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801de4:	53                   	push   %ebx
  801de5:	6a 00                	push   $0x0
  801de7:	e8 9d ef ff ff       	call   800d89 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dec:	89 1c 24             	mov    %ebx,(%esp)
  801def:	e8 15 f3 ff ff       	call   801109 <fd2data>
  801df4:	83 c4 08             	add    $0x8,%esp
  801df7:	50                   	push   %eax
  801df8:	6a 00                	push   $0x0
  801dfa:	e8 8a ef ff ff       	call   800d89 <sys_page_unmap>
}
  801dff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <_pipeisclosed>:
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	57                   	push   %edi
  801e08:	56                   	push   %esi
  801e09:	53                   	push   %ebx
  801e0a:	83 ec 1c             	sub    $0x1c,%esp
  801e0d:	89 c7                	mov    %eax,%edi
  801e0f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e11:	a1 08 40 80 00       	mov    0x804008,%eax
  801e16:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e19:	83 ec 0c             	sub    $0xc,%esp
  801e1c:	57                   	push   %edi
  801e1d:	e8 8e 04 00 00       	call   8022b0 <pageref>
  801e22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e25:	89 34 24             	mov    %esi,(%esp)
  801e28:	e8 83 04 00 00       	call   8022b0 <pageref>
		nn = thisenv->env_runs;
  801e2d:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e33:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e36:	83 c4 10             	add    $0x10,%esp
  801e39:	39 cb                	cmp    %ecx,%ebx
  801e3b:	74 1b                	je     801e58 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e3d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e40:	75 cf                	jne    801e11 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e42:	8b 42 58             	mov    0x58(%edx),%eax
  801e45:	6a 01                	push   $0x1
  801e47:	50                   	push   %eax
  801e48:	53                   	push   %ebx
  801e49:	68 57 2a 80 00       	push   $0x802a57
  801e4e:	e8 60 e3 ff ff       	call   8001b3 <cprintf>
  801e53:	83 c4 10             	add    $0x10,%esp
  801e56:	eb b9                	jmp    801e11 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e58:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e5b:	0f 94 c0             	sete   %al
  801e5e:	0f b6 c0             	movzbl %al,%eax
}
  801e61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e64:	5b                   	pop    %ebx
  801e65:	5e                   	pop    %esi
  801e66:	5f                   	pop    %edi
  801e67:	5d                   	pop    %ebp
  801e68:	c3                   	ret    

00801e69 <devpipe_write>:
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	57                   	push   %edi
  801e6d:	56                   	push   %esi
  801e6e:	53                   	push   %ebx
  801e6f:	83 ec 28             	sub    $0x28,%esp
  801e72:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e75:	56                   	push   %esi
  801e76:	e8 8e f2 ff ff       	call   801109 <fd2data>
  801e7b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e7d:	83 c4 10             	add    $0x10,%esp
  801e80:	bf 00 00 00 00       	mov    $0x0,%edi
  801e85:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e88:	74 4f                	je     801ed9 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e8a:	8b 43 04             	mov    0x4(%ebx),%eax
  801e8d:	8b 0b                	mov    (%ebx),%ecx
  801e8f:	8d 51 20             	lea    0x20(%ecx),%edx
  801e92:	39 d0                	cmp    %edx,%eax
  801e94:	72 14                	jb     801eaa <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e96:	89 da                	mov    %ebx,%edx
  801e98:	89 f0                	mov    %esi,%eax
  801e9a:	e8 65 ff ff ff       	call   801e04 <_pipeisclosed>
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	75 3b                	jne    801ede <devpipe_write+0x75>
			sys_yield();
  801ea3:	e8 3d ee ff ff       	call   800ce5 <sys_yield>
  801ea8:	eb e0                	jmp    801e8a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801eaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ead:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801eb1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801eb4:	89 c2                	mov    %eax,%edx
  801eb6:	c1 fa 1f             	sar    $0x1f,%edx
  801eb9:	89 d1                	mov    %edx,%ecx
  801ebb:	c1 e9 1b             	shr    $0x1b,%ecx
  801ebe:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ec1:	83 e2 1f             	and    $0x1f,%edx
  801ec4:	29 ca                	sub    %ecx,%edx
  801ec6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801eca:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ece:	83 c0 01             	add    $0x1,%eax
  801ed1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ed4:	83 c7 01             	add    $0x1,%edi
  801ed7:	eb ac                	jmp    801e85 <devpipe_write+0x1c>
	return i;
  801ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  801edc:	eb 05                	jmp    801ee3 <devpipe_write+0x7a>
				return 0;
  801ede:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ee6:	5b                   	pop    %ebx
  801ee7:	5e                   	pop    %esi
  801ee8:	5f                   	pop    %edi
  801ee9:	5d                   	pop    %ebp
  801eea:	c3                   	ret    

00801eeb <devpipe_read>:
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	57                   	push   %edi
  801eef:	56                   	push   %esi
  801ef0:	53                   	push   %ebx
  801ef1:	83 ec 18             	sub    $0x18,%esp
  801ef4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ef7:	57                   	push   %edi
  801ef8:	e8 0c f2 ff ff       	call   801109 <fd2data>
  801efd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801eff:	83 c4 10             	add    $0x10,%esp
  801f02:	be 00 00 00 00       	mov    $0x0,%esi
  801f07:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f0a:	75 14                	jne    801f20 <devpipe_read+0x35>
	return i;
  801f0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0f:	eb 02                	jmp    801f13 <devpipe_read+0x28>
				return i;
  801f11:	89 f0                	mov    %esi,%eax
}
  801f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f16:	5b                   	pop    %ebx
  801f17:	5e                   	pop    %esi
  801f18:	5f                   	pop    %edi
  801f19:	5d                   	pop    %ebp
  801f1a:	c3                   	ret    
			sys_yield();
  801f1b:	e8 c5 ed ff ff       	call   800ce5 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f20:	8b 03                	mov    (%ebx),%eax
  801f22:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f25:	75 18                	jne    801f3f <devpipe_read+0x54>
			if (i > 0)
  801f27:	85 f6                	test   %esi,%esi
  801f29:	75 e6                	jne    801f11 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f2b:	89 da                	mov    %ebx,%edx
  801f2d:	89 f8                	mov    %edi,%eax
  801f2f:	e8 d0 fe ff ff       	call   801e04 <_pipeisclosed>
  801f34:	85 c0                	test   %eax,%eax
  801f36:	74 e3                	je     801f1b <devpipe_read+0x30>
				return 0;
  801f38:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3d:	eb d4                	jmp    801f13 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f3f:	99                   	cltd   
  801f40:	c1 ea 1b             	shr    $0x1b,%edx
  801f43:	01 d0                	add    %edx,%eax
  801f45:	83 e0 1f             	and    $0x1f,%eax
  801f48:	29 d0                	sub    %edx,%eax
  801f4a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f52:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f55:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f58:	83 c6 01             	add    $0x1,%esi
  801f5b:	eb aa                	jmp    801f07 <devpipe_read+0x1c>

00801f5d <pipe>:
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	56                   	push   %esi
  801f61:	53                   	push   %ebx
  801f62:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f68:	50                   	push   %eax
  801f69:	e8 b2 f1 ff ff       	call   801120 <fd_alloc>
  801f6e:	89 c3                	mov    %eax,%ebx
  801f70:	83 c4 10             	add    $0x10,%esp
  801f73:	85 c0                	test   %eax,%eax
  801f75:	0f 88 23 01 00 00    	js     80209e <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f7b:	83 ec 04             	sub    $0x4,%esp
  801f7e:	68 07 04 00 00       	push   $0x407
  801f83:	ff 75 f4             	pushl  -0xc(%ebp)
  801f86:	6a 00                	push   $0x0
  801f88:	e8 77 ed ff ff       	call   800d04 <sys_page_alloc>
  801f8d:	89 c3                	mov    %eax,%ebx
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	85 c0                	test   %eax,%eax
  801f94:	0f 88 04 01 00 00    	js     80209e <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f9a:	83 ec 0c             	sub    $0xc,%esp
  801f9d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fa0:	50                   	push   %eax
  801fa1:	e8 7a f1 ff ff       	call   801120 <fd_alloc>
  801fa6:	89 c3                	mov    %eax,%ebx
  801fa8:	83 c4 10             	add    $0x10,%esp
  801fab:	85 c0                	test   %eax,%eax
  801fad:	0f 88 db 00 00 00    	js     80208e <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb3:	83 ec 04             	sub    $0x4,%esp
  801fb6:	68 07 04 00 00       	push   $0x407
  801fbb:	ff 75 f0             	pushl  -0x10(%ebp)
  801fbe:	6a 00                	push   $0x0
  801fc0:	e8 3f ed ff ff       	call   800d04 <sys_page_alloc>
  801fc5:	89 c3                	mov    %eax,%ebx
  801fc7:	83 c4 10             	add    $0x10,%esp
  801fca:	85 c0                	test   %eax,%eax
  801fcc:	0f 88 bc 00 00 00    	js     80208e <pipe+0x131>
	va = fd2data(fd0);
  801fd2:	83 ec 0c             	sub    $0xc,%esp
  801fd5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd8:	e8 2c f1 ff ff       	call   801109 <fd2data>
  801fdd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fdf:	83 c4 0c             	add    $0xc,%esp
  801fe2:	68 07 04 00 00       	push   $0x407
  801fe7:	50                   	push   %eax
  801fe8:	6a 00                	push   $0x0
  801fea:	e8 15 ed ff ff       	call   800d04 <sys_page_alloc>
  801fef:	89 c3                	mov    %eax,%ebx
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	0f 88 82 00 00 00    	js     80207e <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ffc:	83 ec 0c             	sub    $0xc,%esp
  801fff:	ff 75 f0             	pushl  -0x10(%ebp)
  802002:	e8 02 f1 ff ff       	call   801109 <fd2data>
  802007:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80200e:	50                   	push   %eax
  80200f:	6a 00                	push   $0x0
  802011:	56                   	push   %esi
  802012:	6a 00                	push   $0x0
  802014:	e8 2e ed ff ff       	call   800d47 <sys_page_map>
  802019:	89 c3                	mov    %eax,%ebx
  80201b:	83 c4 20             	add    $0x20,%esp
  80201e:	85 c0                	test   %eax,%eax
  802020:	78 4e                	js     802070 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802022:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802027:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80202c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802036:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802039:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80203b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802045:	83 ec 0c             	sub    $0xc,%esp
  802048:	ff 75 f4             	pushl  -0xc(%ebp)
  80204b:	e8 a9 f0 ff ff       	call   8010f9 <fd2num>
  802050:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802053:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802055:	83 c4 04             	add    $0x4,%esp
  802058:	ff 75 f0             	pushl  -0x10(%ebp)
  80205b:	e8 99 f0 ff ff       	call   8010f9 <fd2num>
  802060:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802063:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	bb 00 00 00 00       	mov    $0x0,%ebx
  80206e:	eb 2e                	jmp    80209e <pipe+0x141>
	sys_page_unmap(0, va);
  802070:	83 ec 08             	sub    $0x8,%esp
  802073:	56                   	push   %esi
  802074:	6a 00                	push   $0x0
  802076:	e8 0e ed ff ff       	call   800d89 <sys_page_unmap>
  80207b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80207e:	83 ec 08             	sub    $0x8,%esp
  802081:	ff 75 f0             	pushl  -0x10(%ebp)
  802084:	6a 00                	push   $0x0
  802086:	e8 fe ec ff ff       	call   800d89 <sys_page_unmap>
  80208b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80208e:	83 ec 08             	sub    $0x8,%esp
  802091:	ff 75 f4             	pushl  -0xc(%ebp)
  802094:	6a 00                	push   $0x0
  802096:	e8 ee ec ff ff       	call   800d89 <sys_page_unmap>
  80209b:	83 c4 10             	add    $0x10,%esp
}
  80209e:	89 d8                	mov    %ebx,%eax
  8020a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020a3:	5b                   	pop    %ebx
  8020a4:	5e                   	pop    %esi
  8020a5:	5d                   	pop    %ebp
  8020a6:	c3                   	ret    

008020a7 <pipeisclosed>:
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020b0:	50                   	push   %eax
  8020b1:	ff 75 08             	pushl  0x8(%ebp)
  8020b4:	e8 b9 f0 ff ff       	call   801172 <fd_lookup>
  8020b9:	83 c4 10             	add    $0x10,%esp
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	78 18                	js     8020d8 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020c0:	83 ec 0c             	sub    $0xc,%esp
  8020c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c6:	e8 3e f0 ff ff       	call   801109 <fd2data>
	return _pipeisclosed(fd, p);
  8020cb:	89 c2                	mov    %eax,%edx
  8020cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d0:	e8 2f fd ff ff       	call   801e04 <_pipeisclosed>
  8020d5:	83 c4 10             	add    $0x10,%esp
}
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020da:	b8 00 00 00 00       	mov    $0x0,%eax
  8020df:	c3                   	ret    

008020e0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020e6:	68 6f 2a 80 00       	push   $0x802a6f
  8020eb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ee:	e8 1f e8 ff ff       	call   800912 <strcpy>
	return 0;
}
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <devcons_write>:
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	57                   	push   %edi
  8020fe:	56                   	push   %esi
  8020ff:	53                   	push   %ebx
  802100:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802106:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80210b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802111:	3b 75 10             	cmp    0x10(%ebp),%esi
  802114:	73 31                	jae    802147 <devcons_write+0x4d>
		m = n - tot;
  802116:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802119:	29 f3                	sub    %esi,%ebx
  80211b:	83 fb 7f             	cmp    $0x7f,%ebx
  80211e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802123:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802126:	83 ec 04             	sub    $0x4,%esp
  802129:	53                   	push   %ebx
  80212a:	89 f0                	mov    %esi,%eax
  80212c:	03 45 0c             	add    0xc(%ebp),%eax
  80212f:	50                   	push   %eax
  802130:	57                   	push   %edi
  802131:	e8 6a e9 ff ff       	call   800aa0 <memmove>
		sys_cputs(buf, m);
  802136:	83 c4 08             	add    $0x8,%esp
  802139:	53                   	push   %ebx
  80213a:	57                   	push   %edi
  80213b:	e8 08 eb ff ff       	call   800c48 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802140:	01 de                	add    %ebx,%esi
  802142:	83 c4 10             	add    $0x10,%esp
  802145:	eb ca                	jmp    802111 <devcons_write+0x17>
}
  802147:	89 f0                	mov    %esi,%eax
  802149:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80214c:	5b                   	pop    %ebx
  80214d:	5e                   	pop    %esi
  80214e:	5f                   	pop    %edi
  80214f:	5d                   	pop    %ebp
  802150:	c3                   	ret    

00802151 <devcons_read>:
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	83 ec 08             	sub    $0x8,%esp
  802157:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80215c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802160:	74 21                	je     802183 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802162:	e8 ff ea ff ff       	call   800c66 <sys_cgetc>
  802167:	85 c0                	test   %eax,%eax
  802169:	75 07                	jne    802172 <devcons_read+0x21>
		sys_yield();
  80216b:	e8 75 eb ff ff       	call   800ce5 <sys_yield>
  802170:	eb f0                	jmp    802162 <devcons_read+0x11>
	if (c < 0)
  802172:	78 0f                	js     802183 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802174:	83 f8 04             	cmp    $0x4,%eax
  802177:	74 0c                	je     802185 <devcons_read+0x34>
	*(char*)vbuf = c;
  802179:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217c:	88 02                	mov    %al,(%edx)
	return 1;
  80217e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    
		return 0;
  802185:	b8 00 00 00 00       	mov    $0x0,%eax
  80218a:	eb f7                	jmp    802183 <devcons_read+0x32>

0080218c <cputchar>:
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802198:	6a 01                	push   $0x1
  80219a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80219d:	50                   	push   %eax
  80219e:	e8 a5 ea ff ff       	call   800c48 <sys_cputs>
}
  8021a3:	83 c4 10             	add    $0x10,%esp
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <getchar>:
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021ae:	6a 01                	push   $0x1
  8021b0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021b3:	50                   	push   %eax
  8021b4:	6a 00                	push   $0x0
  8021b6:	e8 27 f2 ff ff       	call   8013e2 <read>
	if (r < 0)
  8021bb:	83 c4 10             	add    $0x10,%esp
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	78 06                	js     8021c8 <getchar+0x20>
	if (r < 1)
  8021c2:	74 06                	je     8021ca <getchar+0x22>
	return c;
  8021c4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    
		return -E_EOF;
  8021ca:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021cf:	eb f7                	jmp    8021c8 <getchar+0x20>

008021d1 <iscons>:
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021da:	50                   	push   %eax
  8021db:	ff 75 08             	pushl  0x8(%ebp)
  8021de:	e8 8f ef ff ff       	call   801172 <fd_lookup>
  8021e3:	83 c4 10             	add    $0x10,%esp
  8021e6:	85 c0                	test   %eax,%eax
  8021e8:	78 11                	js     8021fb <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021f3:	39 10                	cmp    %edx,(%eax)
  8021f5:	0f 94 c0             	sete   %al
  8021f8:	0f b6 c0             	movzbl %al,%eax
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <opencons>:
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802203:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802206:	50                   	push   %eax
  802207:	e8 14 ef ff ff       	call   801120 <fd_alloc>
  80220c:	83 c4 10             	add    $0x10,%esp
  80220f:	85 c0                	test   %eax,%eax
  802211:	78 3a                	js     80224d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802213:	83 ec 04             	sub    $0x4,%esp
  802216:	68 07 04 00 00       	push   $0x407
  80221b:	ff 75 f4             	pushl  -0xc(%ebp)
  80221e:	6a 00                	push   $0x0
  802220:	e8 df ea ff ff       	call   800d04 <sys_page_alloc>
  802225:	83 c4 10             	add    $0x10,%esp
  802228:	85 c0                	test   %eax,%eax
  80222a:	78 21                	js     80224d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80222c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802235:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802241:	83 ec 0c             	sub    $0xc,%esp
  802244:	50                   	push   %eax
  802245:	e8 af ee ff ff       	call   8010f9 <fd2num>
  80224a:	83 c4 10             	add    $0x10,%esp
}
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	56                   	push   %esi
  802253:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802254:	a1 08 40 80 00       	mov    0x804008,%eax
  802259:	8b 40 48             	mov    0x48(%eax),%eax
  80225c:	83 ec 04             	sub    $0x4,%esp
  80225f:	68 a0 2a 80 00       	push   $0x802aa0
  802264:	50                   	push   %eax
  802265:	68 72 25 80 00       	push   $0x802572
  80226a:	e8 44 df ff ff       	call   8001b3 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80226f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802272:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802278:	e8 49 ea ff ff       	call   800cc6 <sys_getenvid>
  80227d:	83 c4 04             	add    $0x4,%esp
  802280:	ff 75 0c             	pushl  0xc(%ebp)
  802283:	ff 75 08             	pushl  0x8(%ebp)
  802286:	56                   	push   %esi
  802287:	50                   	push   %eax
  802288:	68 7c 2a 80 00       	push   $0x802a7c
  80228d:	e8 21 df ff ff       	call   8001b3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802292:	83 c4 18             	add    $0x18,%esp
  802295:	53                   	push   %ebx
  802296:	ff 75 10             	pushl  0x10(%ebp)
  802299:	e8 c4 de ff ff       	call   800162 <vcprintf>
	cprintf("\n");
  80229e:	c7 04 24 46 29 80 00 	movl   $0x802946,(%esp)
  8022a5:	e8 09 df ff ff       	call   8001b3 <cprintf>
  8022aa:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8022ad:	cc                   	int3   
  8022ae:	eb fd                	jmp    8022ad <_panic+0x5e>

008022b0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022b6:	89 d0                	mov    %edx,%eax
  8022b8:	c1 e8 16             	shr    $0x16,%eax
  8022bb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022c2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022c7:	f6 c1 01             	test   $0x1,%cl
  8022ca:	74 1d                	je     8022e9 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022cc:	c1 ea 0c             	shr    $0xc,%edx
  8022cf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022d6:	f6 c2 01             	test   $0x1,%dl
  8022d9:	74 0e                	je     8022e9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022db:	c1 ea 0c             	shr    $0xc,%edx
  8022de:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022e5:	ef 
  8022e6:	0f b7 c0             	movzwl %ax,%eax
}
  8022e9:	5d                   	pop    %ebp
  8022ea:	c3                   	ret    
  8022eb:	66 90                	xchg   %ax,%ax
  8022ed:	66 90                	xchg   %ax,%ax
  8022ef:	90                   	nop

008022f0 <__udivdi3>:
  8022f0:	55                   	push   %ebp
  8022f1:	57                   	push   %edi
  8022f2:	56                   	push   %esi
  8022f3:	53                   	push   %ebx
  8022f4:	83 ec 1c             	sub    $0x1c,%esp
  8022f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802303:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802307:	85 d2                	test   %edx,%edx
  802309:	75 4d                	jne    802358 <__udivdi3+0x68>
  80230b:	39 f3                	cmp    %esi,%ebx
  80230d:	76 19                	jbe    802328 <__udivdi3+0x38>
  80230f:	31 ff                	xor    %edi,%edi
  802311:	89 e8                	mov    %ebp,%eax
  802313:	89 f2                	mov    %esi,%edx
  802315:	f7 f3                	div    %ebx
  802317:	89 fa                	mov    %edi,%edx
  802319:	83 c4 1c             	add    $0x1c,%esp
  80231c:	5b                   	pop    %ebx
  80231d:	5e                   	pop    %esi
  80231e:	5f                   	pop    %edi
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    
  802321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802328:	89 d9                	mov    %ebx,%ecx
  80232a:	85 db                	test   %ebx,%ebx
  80232c:	75 0b                	jne    802339 <__udivdi3+0x49>
  80232e:	b8 01 00 00 00       	mov    $0x1,%eax
  802333:	31 d2                	xor    %edx,%edx
  802335:	f7 f3                	div    %ebx
  802337:	89 c1                	mov    %eax,%ecx
  802339:	31 d2                	xor    %edx,%edx
  80233b:	89 f0                	mov    %esi,%eax
  80233d:	f7 f1                	div    %ecx
  80233f:	89 c6                	mov    %eax,%esi
  802341:	89 e8                	mov    %ebp,%eax
  802343:	89 f7                	mov    %esi,%edi
  802345:	f7 f1                	div    %ecx
  802347:	89 fa                	mov    %edi,%edx
  802349:	83 c4 1c             	add    $0x1c,%esp
  80234c:	5b                   	pop    %ebx
  80234d:	5e                   	pop    %esi
  80234e:	5f                   	pop    %edi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
  802351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802358:	39 f2                	cmp    %esi,%edx
  80235a:	77 1c                	ja     802378 <__udivdi3+0x88>
  80235c:	0f bd fa             	bsr    %edx,%edi
  80235f:	83 f7 1f             	xor    $0x1f,%edi
  802362:	75 2c                	jne    802390 <__udivdi3+0xa0>
  802364:	39 f2                	cmp    %esi,%edx
  802366:	72 06                	jb     80236e <__udivdi3+0x7e>
  802368:	31 c0                	xor    %eax,%eax
  80236a:	39 eb                	cmp    %ebp,%ebx
  80236c:	77 a9                	ja     802317 <__udivdi3+0x27>
  80236e:	b8 01 00 00 00       	mov    $0x1,%eax
  802373:	eb a2                	jmp    802317 <__udivdi3+0x27>
  802375:	8d 76 00             	lea    0x0(%esi),%esi
  802378:	31 ff                	xor    %edi,%edi
  80237a:	31 c0                	xor    %eax,%eax
  80237c:	89 fa                	mov    %edi,%edx
  80237e:	83 c4 1c             	add    $0x1c,%esp
  802381:	5b                   	pop    %ebx
  802382:	5e                   	pop    %esi
  802383:	5f                   	pop    %edi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    
  802386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80238d:	8d 76 00             	lea    0x0(%esi),%esi
  802390:	89 f9                	mov    %edi,%ecx
  802392:	b8 20 00 00 00       	mov    $0x20,%eax
  802397:	29 f8                	sub    %edi,%eax
  802399:	d3 e2                	shl    %cl,%edx
  80239b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80239f:	89 c1                	mov    %eax,%ecx
  8023a1:	89 da                	mov    %ebx,%edx
  8023a3:	d3 ea                	shr    %cl,%edx
  8023a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023a9:	09 d1                	or     %edx,%ecx
  8023ab:	89 f2                	mov    %esi,%edx
  8023ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023b1:	89 f9                	mov    %edi,%ecx
  8023b3:	d3 e3                	shl    %cl,%ebx
  8023b5:	89 c1                	mov    %eax,%ecx
  8023b7:	d3 ea                	shr    %cl,%edx
  8023b9:	89 f9                	mov    %edi,%ecx
  8023bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023bf:	89 eb                	mov    %ebp,%ebx
  8023c1:	d3 e6                	shl    %cl,%esi
  8023c3:	89 c1                	mov    %eax,%ecx
  8023c5:	d3 eb                	shr    %cl,%ebx
  8023c7:	09 de                	or     %ebx,%esi
  8023c9:	89 f0                	mov    %esi,%eax
  8023cb:	f7 74 24 08          	divl   0x8(%esp)
  8023cf:	89 d6                	mov    %edx,%esi
  8023d1:	89 c3                	mov    %eax,%ebx
  8023d3:	f7 64 24 0c          	mull   0xc(%esp)
  8023d7:	39 d6                	cmp    %edx,%esi
  8023d9:	72 15                	jb     8023f0 <__udivdi3+0x100>
  8023db:	89 f9                	mov    %edi,%ecx
  8023dd:	d3 e5                	shl    %cl,%ebp
  8023df:	39 c5                	cmp    %eax,%ebp
  8023e1:	73 04                	jae    8023e7 <__udivdi3+0xf7>
  8023e3:	39 d6                	cmp    %edx,%esi
  8023e5:	74 09                	je     8023f0 <__udivdi3+0x100>
  8023e7:	89 d8                	mov    %ebx,%eax
  8023e9:	31 ff                	xor    %edi,%edi
  8023eb:	e9 27 ff ff ff       	jmp    802317 <__udivdi3+0x27>
  8023f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023f3:	31 ff                	xor    %edi,%edi
  8023f5:	e9 1d ff ff ff       	jmp    802317 <__udivdi3+0x27>
  8023fa:	66 90                	xchg   %ax,%ax
  8023fc:	66 90                	xchg   %ax,%ax
  8023fe:	66 90                	xchg   %ax,%ax

00802400 <__umoddi3>:
  802400:	55                   	push   %ebp
  802401:	57                   	push   %edi
  802402:	56                   	push   %esi
  802403:	53                   	push   %ebx
  802404:	83 ec 1c             	sub    $0x1c,%esp
  802407:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80240b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80240f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802413:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802417:	89 da                	mov    %ebx,%edx
  802419:	85 c0                	test   %eax,%eax
  80241b:	75 43                	jne    802460 <__umoddi3+0x60>
  80241d:	39 df                	cmp    %ebx,%edi
  80241f:	76 17                	jbe    802438 <__umoddi3+0x38>
  802421:	89 f0                	mov    %esi,%eax
  802423:	f7 f7                	div    %edi
  802425:	89 d0                	mov    %edx,%eax
  802427:	31 d2                	xor    %edx,%edx
  802429:	83 c4 1c             	add    $0x1c,%esp
  80242c:	5b                   	pop    %ebx
  80242d:	5e                   	pop    %esi
  80242e:	5f                   	pop    %edi
  80242f:	5d                   	pop    %ebp
  802430:	c3                   	ret    
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	89 fd                	mov    %edi,%ebp
  80243a:	85 ff                	test   %edi,%edi
  80243c:	75 0b                	jne    802449 <__umoddi3+0x49>
  80243e:	b8 01 00 00 00       	mov    $0x1,%eax
  802443:	31 d2                	xor    %edx,%edx
  802445:	f7 f7                	div    %edi
  802447:	89 c5                	mov    %eax,%ebp
  802449:	89 d8                	mov    %ebx,%eax
  80244b:	31 d2                	xor    %edx,%edx
  80244d:	f7 f5                	div    %ebp
  80244f:	89 f0                	mov    %esi,%eax
  802451:	f7 f5                	div    %ebp
  802453:	89 d0                	mov    %edx,%eax
  802455:	eb d0                	jmp    802427 <__umoddi3+0x27>
  802457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80245e:	66 90                	xchg   %ax,%ax
  802460:	89 f1                	mov    %esi,%ecx
  802462:	39 d8                	cmp    %ebx,%eax
  802464:	76 0a                	jbe    802470 <__umoddi3+0x70>
  802466:	89 f0                	mov    %esi,%eax
  802468:	83 c4 1c             	add    $0x1c,%esp
  80246b:	5b                   	pop    %ebx
  80246c:	5e                   	pop    %esi
  80246d:	5f                   	pop    %edi
  80246e:	5d                   	pop    %ebp
  80246f:	c3                   	ret    
  802470:	0f bd e8             	bsr    %eax,%ebp
  802473:	83 f5 1f             	xor    $0x1f,%ebp
  802476:	75 20                	jne    802498 <__umoddi3+0x98>
  802478:	39 d8                	cmp    %ebx,%eax
  80247a:	0f 82 b0 00 00 00    	jb     802530 <__umoddi3+0x130>
  802480:	39 f7                	cmp    %esi,%edi
  802482:	0f 86 a8 00 00 00    	jbe    802530 <__umoddi3+0x130>
  802488:	89 c8                	mov    %ecx,%eax
  80248a:	83 c4 1c             	add    $0x1c,%esp
  80248d:	5b                   	pop    %ebx
  80248e:	5e                   	pop    %esi
  80248f:	5f                   	pop    %edi
  802490:	5d                   	pop    %ebp
  802491:	c3                   	ret    
  802492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802498:	89 e9                	mov    %ebp,%ecx
  80249a:	ba 20 00 00 00       	mov    $0x20,%edx
  80249f:	29 ea                	sub    %ebp,%edx
  8024a1:	d3 e0                	shl    %cl,%eax
  8024a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024a7:	89 d1                	mov    %edx,%ecx
  8024a9:	89 f8                	mov    %edi,%eax
  8024ab:	d3 e8                	shr    %cl,%eax
  8024ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024b9:	09 c1                	or     %eax,%ecx
  8024bb:	89 d8                	mov    %ebx,%eax
  8024bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024c1:	89 e9                	mov    %ebp,%ecx
  8024c3:	d3 e7                	shl    %cl,%edi
  8024c5:	89 d1                	mov    %edx,%ecx
  8024c7:	d3 e8                	shr    %cl,%eax
  8024c9:	89 e9                	mov    %ebp,%ecx
  8024cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024cf:	d3 e3                	shl    %cl,%ebx
  8024d1:	89 c7                	mov    %eax,%edi
  8024d3:	89 d1                	mov    %edx,%ecx
  8024d5:	89 f0                	mov    %esi,%eax
  8024d7:	d3 e8                	shr    %cl,%eax
  8024d9:	89 e9                	mov    %ebp,%ecx
  8024db:	89 fa                	mov    %edi,%edx
  8024dd:	d3 e6                	shl    %cl,%esi
  8024df:	09 d8                	or     %ebx,%eax
  8024e1:	f7 74 24 08          	divl   0x8(%esp)
  8024e5:	89 d1                	mov    %edx,%ecx
  8024e7:	89 f3                	mov    %esi,%ebx
  8024e9:	f7 64 24 0c          	mull   0xc(%esp)
  8024ed:	89 c6                	mov    %eax,%esi
  8024ef:	89 d7                	mov    %edx,%edi
  8024f1:	39 d1                	cmp    %edx,%ecx
  8024f3:	72 06                	jb     8024fb <__umoddi3+0xfb>
  8024f5:	75 10                	jne    802507 <__umoddi3+0x107>
  8024f7:	39 c3                	cmp    %eax,%ebx
  8024f9:	73 0c                	jae    802507 <__umoddi3+0x107>
  8024fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802503:	89 d7                	mov    %edx,%edi
  802505:	89 c6                	mov    %eax,%esi
  802507:	89 ca                	mov    %ecx,%edx
  802509:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80250e:	29 f3                	sub    %esi,%ebx
  802510:	19 fa                	sbb    %edi,%edx
  802512:	89 d0                	mov    %edx,%eax
  802514:	d3 e0                	shl    %cl,%eax
  802516:	89 e9                	mov    %ebp,%ecx
  802518:	d3 eb                	shr    %cl,%ebx
  80251a:	d3 ea                	shr    %cl,%edx
  80251c:	09 d8                	or     %ebx,%eax
  80251e:	83 c4 1c             	add    $0x1c,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    
  802526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80252d:	8d 76 00             	lea    0x0(%esi),%esi
  802530:	89 da                	mov    %ebx,%edx
  802532:	29 fe                	sub    %edi,%esi
  802534:	19 c2                	sbb    %eax,%edx
  802536:	89 f1                	mov    %esi,%ecx
  802538:	89 c8                	mov    %ecx,%eax
  80253a:	e9 4b ff ff ff       	jmp    80248a <__umoddi3+0x8a>
