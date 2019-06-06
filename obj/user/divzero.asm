
obj/user/divzero.debug:     file format elf32-i386


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
  80002c:	e8 2f 00 00 00       	call   800060 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	zero = 0;
  800039:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800040:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800043:	b8 01 00 00 00       	mov    $0x1,%eax
  800048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004d:	99                   	cltd   
  80004e:	f7 f9                	idiv   %ecx
  800050:	50                   	push   %eax
  800051:	68 80 25 80 00       	push   $0x802580
  800056:	e8 a7 01 00 00       	call   800202 <cprintf>
}
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	57                   	push   %edi
  800064:	56                   	push   %esi
  800065:	53                   	push   %ebx
  800066:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800069:	c7 05 0c 40 80 00 00 	movl   $0x0,0x80400c
  800070:	00 00 00 
	envid_t find = sys_getenvid();
  800073:	e8 9d 0c 00 00       	call   800d15 <sys_getenvid>
  800078:	8b 1d 0c 40 80 00    	mov    0x80400c,%ebx
  80007e:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800083:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800088:	bf 01 00 00 00       	mov    $0x1,%edi
  80008d:	eb 0b                	jmp    80009a <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80008f:	83 c2 01             	add    $0x1,%edx
  800092:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800098:	74 21                	je     8000bb <libmain+0x5b>
		if(envs[i].env_id == find)
  80009a:	89 d1                	mov    %edx,%ecx
  80009c:	c1 e1 07             	shl    $0x7,%ecx
  80009f:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000a5:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000a8:	39 c1                	cmp    %eax,%ecx
  8000aa:	75 e3                	jne    80008f <libmain+0x2f>
  8000ac:	89 d3                	mov    %edx,%ebx
  8000ae:	c1 e3 07             	shl    $0x7,%ebx
  8000b1:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000b7:	89 fe                	mov    %edi,%esi
  8000b9:	eb d4                	jmp    80008f <libmain+0x2f>
  8000bb:	89 f0                	mov    %esi,%eax
  8000bd:	84 c0                	test   %al,%al
  8000bf:	74 06                	je     8000c7 <libmain+0x67>
  8000c1:	89 1d 0c 40 80 00    	mov    %ebx,0x80400c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000cb:	7e 0a                	jle    8000d7 <libmain+0x77>
		binaryname = argv[0];
  8000cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d0:	8b 00                	mov    (%eax),%eax
  8000d2:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000d7:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8000dc:	8b 40 48             	mov    0x48(%eax),%eax
  8000df:	83 ec 08             	sub    $0x8,%esp
  8000e2:	50                   	push   %eax
  8000e3:	68 8e 25 80 00       	push   $0x80258e
  8000e8:	e8 15 01 00 00       	call   800202 <cprintf>
	cprintf("before umain\n");
  8000ed:	c7 04 24 ac 25 80 00 	movl   $0x8025ac,(%esp)
  8000f4:	e8 09 01 00 00       	call   800202 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000f9:	83 c4 08             	add    $0x8,%esp
  8000fc:	ff 75 0c             	pushl  0xc(%ebp)
  8000ff:	ff 75 08             	pushl  0x8(%ebp)
  800102:	e8 2c ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800107:	c7 04 24 ba 25 80 00 	movl   $0x8025ba,(%esp)
  80010e:	e8 ef 00 00 00       	call   800202 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800113:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800118:	8b 40 48             	mov    0x48(%eax),%eax
  80011b:	83 c4 08             	add    $0x8,%esp
  80011e:	50                   	push   %eax
  80011f:	68 c7 25 80 00       	push   $0x8025c7
  800124:	e8 d9 00 00 00       	call   800202 <cprintf>
	// exit gracefully
	exit();
  800129:	e8 0b 00 00 00       	call   800139 <exit>
}
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800134:	5b                   	pop    %ebx
  800135:	5e                   	pop    %esi
  800136:	5f                   	pop    %edi
  800137:	5d                   	pop    %ebp
  800138:	c3                   	ret    

00800139 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800139:	55                   	push   %ebp
  80013a:	89 e5                	mov    %esp,%ebp
  80013c:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80013f:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800144:	8b 40 48             	mov    0x48(%eax),%eax
  800147:	68 f4 25 80 00       	push   $0x8025f4
  80014c:	50                   	push   %eax
  80014d:	68 e6 25 80 00       	push   $0x8025e6
  800152:	e8 ab 00 00 00       	call   800202 <cprintf>
	close_all();
  800157:	e8 a4 10 00 00       	call   801200 <close_all>
	sys_env_destroy(0);
  80015c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800163:	e8 6c 0b 00 00       	call   800cd4 <sys_env_destroy>
}
  800168:	83 c4 10             	add    $0x10,%esp
  80016b:	c9                   	leave  
  80016c:	c3                   	ret    

0080016d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80016d:	55                   	push   %ebp
  80016e:	89 e5                	mov    %esp,%ebp
  800170:	53                   	push   %ebx
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800177:	8b 13                	mov    (%ebx),%edx
  800179:	8d 42 01             	lea    0x1(%edx),%eax
  80017c:	89 03                	mov    %eax,(%ebx)
  80017e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800181:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800185:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018a:	74 09                	je     800195 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80018c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800190:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800193:	c9                   	leave  
  800194:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	68 ff 00 00 00       	push   $0xff
  80019d:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a0:	50                   	push   %eax
  8001a1:	e8 f1 0a 00 00       	call   800c97 <sys_cputs>
		b->idx = 0;
  8001a6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001ac:	83 c4 10             	add    $0x10,%esp
  8001af:	eb db                	jmp    80018c <putch+0x1f>

008001b1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ba:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c1:	00 00 00 
	b.cnt = 0;
  8001c4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001cb:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ce:	ff 75 0c             	pushl  0xc(%ebp)
  8001d1:	ff 75 08             	pushl  0x8(%ebp)
  8001d4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001da:	50                   	push   %eax
  8001db:	68 6d 01 80 00       	push   $0x80016d
  8001e0:	e8 4a 01 00 00       	call   80032f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e5:	83 c4 08             	add    $0x8,%esp
  8001e8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001ee:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f4:	50                   	push   %eax
  8001f5:	e8 9d 0a 00 00       	call   800c97 <sys_cputs>

	return b.cnt;
}
  8001fa:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800208:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020b:	50                   	push   %eax
  80020c:	ff 75 08             	pushl  0x8(%ebp)
  80020f:	e8 9d ff ff ff       	call   8001b1 <vcprintf>
	va_end(ap);

	return cnt;
}
  800214:	c9                   	leave  
  800215:	c3                   	ret    

00800216 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	57                   	push   %edi
  80021a:	56                   	push   %esi
  80021b:	53                   	push   %ebx
  80021c:	83 ec 1c             	sub    $0x1c,%esp
  80021f:	89 c6                	mov    %eax,%esi
  800221:	89 d7                	mov    %edx,%edi
  800223:	8b 45 08             	mov    0x8(%ebp),%eax
  800226:	8b 55 0c             	mov    0xc(%ebp),%edx
  800229:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80022c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80022f:	8b 45 10             	mov    0x10(%ebp),%eax
  800232:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800235:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800239:	74 2c                	je     800267 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80023b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80023e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800245:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800248:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80024b:	39 c2                	cmp    %eax,%edx
  80024d:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800250:	73 43                	jae    800295 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800252:	83 eb 01             	sub    $0x1,%ebx
  800255:	85 db                	test   %ebx,%ebx
  800257:	7e 6c                	jle    8002c5 <printnum+0xaf>
				putch(padc, putdat);
  800259:	83 ec 08             	sub    $0x8,%esp
  80025c:	57                   	push   %edi
  80025d:	ff 75 18             	pushl  0x18(%ebp)
  800260:	ff d6                	call   *%esi
  800262:	83 c4 10             	add    $0x10,%esp
  800265:	eb eb                	jmp    800252 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	6a 20                	push   $0x20
  80026c:	6a 00                	push   $0x0
  80026e:	50                   	push   %eax
  80026f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800272:	ff 75 e0             	pushl  -0x20(%ebp)
  800275:	89 fa                	mov    %edi,%edx
  800277:	89 f0                	mov    %esi,%eax
  800279:	e8 98 ff ff ff       	call   800216 <printnum>
		while (--width > 0)
  80027e:	83 c4 20             	add    $0x20,%esp
  800281:	83 eb 01             	sub    $0x1,%ebx
  800284:	85 db                	test   %ebx,%ebx
  800286:	7e 65                	jle    8002ed <printnum+0xd7>
			putch(padc, putdat);
  800288:	83 ec 08             	sub    $0x8,%esp
  80028b:	57                   	push   %edi
  80028c:	6a 20                	push   $0x20
  80028e:	ff d6                	call   *%esi
  800290:	83 c4 10             	add    $0x10,%esp
  800293:	eb ec                	jmp    800281 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	ff 75 18             	pushl  0x18(%ebp)
  80029b:	83 eb 01             	sub    $0x1,%ebx
  80029e:	53                   	push   %ebx
  80029f:	50                   	push   %eax
  8002a0:	83 ec 08             	sub    $0x8,%esp
  8002a3:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a6:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8002af:	e8 6c 20 00 00       	call   802320 <__udivdi3>
  8002b4:	83 c4 18             	add    $0x18,%esp
  8002b7:	52                   	push   %edx
  8002b8:	50                   	push   %eax
  8002b9:	89 fa                	mov    %edi,%edx
  8002bb:	89 f0                	mov    %esi,%eax
  8002bd:	e8 54 ff ff ff       	call   800216 <printnum>
  8002c2:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002c5:	83 ec 08             	sub    $0x8,%esp
  8002c8:	57                   	push   %edi
  8002c9:	83 ec 04             	sub    $0x4,%esp
  8002cc:	ff 75 dc             	pushl  -0x24(%ebp)
  8002cf:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d5:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d8:	e8 53 21 00 00       	call   802430 <__umoddi3>
  8002dd:	83 c4 14             	add    $0x14,%esp
  8002e0:	0f be 80 f9 25 80 00 	movsbl 0x8025f9(%eax),%eax
  8002e7:	50                   	push   %eax
  8002e8:	ff d6                	call   *%esi
  8002ea:	83 c4 10             	add    $0x10,%esp
	}
}
  8002ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f0:	5b                   	pop    %ebx
  8002f1:	5e                   	pop    %esi
  8002f2:	5f                   	pop    %edi
  8002f3:	5d                   	pop    %ebp
  8002f4:	c3                   	ret    

008002f5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002fb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ff:	8b 10                	mov    (%eax),%edx
  800301:	3b 50 04             	cmp    0x4(%eax),%edx
  800304:	73 0a                	jae    800310 <sprintputch+0x1b>
		*b->buf++ = ch;
  800306:	8d 4a 01             	lea    0x1(%edx),%ecx
  800309:	89 08                	mov    %ecx,(%eax)
  80030b:	8b 45 08             	mov    0x8(%ebp),%eax
  80030e:	88 02                	mov    %al,(%edx)
}
  800310:	5d                   	pop    %ebp
  800311:	c3                   	ret    

00800312 <printfmt>:
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800318:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80031b:	50                   	push   %eax
  80031c:	ff 75 10             	pushl  0x10(%ebp)
  80031f:	ff 75 0c             	pushl  0xc(%ebp)
  800322:	ff 75 08             	pushl  0x8(%ebp)
  800325:	e8 05 00 00 00       	call   80032f <vprintfmt>
}
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	c9                   	leave  
  80032e:	c3                   	ret    

0080032f <vprintfmt>:
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	57                   	push   %edi
  800333:	56                   	push   %esi
  800334:	53                   	push   %ebx
  800335:	83 ec 3c             	sub    $0x3c,%esp
  800338:	8b 75 08             	mov    0x8(%ebp),%esi
  80033b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80033e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800341:	e9 32 04 00 00       	jmp    800778 <vprintfmt+0x449>
		padc = ' ';
  800346:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80034a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800351:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800358:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80035f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800366:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80036d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800372:	8d 47 01             	lea    0x1(%edi),%eax
  800375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800378:	0f b6 17             	movzbl (%edi),%edx
  80037b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80037e:	3c 55                	cmp    $0x55,%al
  800380:	0f 87 12 05 00 00    	ja     800898 <vprintfmt+0x569>
  800386:	0f b6 c0             	movzbl %al,%eax
  800389:	ff 24 85 e0 27 80 00 	jmp    *0x8027e0(,%eax,4)
  800390:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800393:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800397:	eb d9                	jmp    800372 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800399:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80039c:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003a0:	eb d0                	jmp    800372 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003a2:	0f b6 d2             	movzbl %dl,%edx
  8003a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ad:	89 75 08             	mov    %esi,0x8(%ebp)
  8003b0:	eb 03                	jmp    8003b5 <vprintfmt+0x86>
  8003b2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003b8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003bc:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003bf:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003c2:	83 fe 09             	cmp    $0x9,%esi
  8003c5:	76 eb                	jbe    8003b2 <vprintfmt+0x83>
  8003c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8003cd:	eb 14                	jmp    8003e3 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003da:	8d 40 04             	lea    0x4(%eax),%eax
  8003dd:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e7:	79 89                	jns    800372 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ef:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003f6:	e9 77 ff ff ff       	jmp    800372 <vprintfmt+0x43>
  8003fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003fe:	85 c0                	test   %eax,%eax
  800400:	0f 48 c1             	cmovs  %ecx,%eax
  800403:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800406:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800409:	e9 64 ff ff ff       	jmp    800372 <vprintfmt+0x43>
  80040e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800411:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800418:	e9 55 ff ff ff       	jmp    800372 <vprintfmt+0x43>
			lflag++;
  80041d:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800421:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800424:	e9 49 ff ff ff       	jmp    800372 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800429:	8b 45 14             	mov    0x14(%ebp),%eax
  80042c:	8d 78 04             	lea    0x4(%eax),%edi
  80042f:	83 ec 08             	sub    $0x8,%esp
  800432:	53                   	push   %ebx
  800433:	ff 30                	pushl  (%eax)
  800435:	ff d6                	call   *%esi
			break;
  800437:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80043a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80043d:	e9 33 03 00 00       	jmp    800775 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800442:	8b 45 14             	mov    0x14(%ebp),%eax
  800445:	8d 78 04             	lea    0x4(%eax),%edi
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	99                   	cltd   
  80044b:	31 d0                	xor    %edx,%eax
  80044d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80044f:	83 f8 11             	cmp    $0x11,%eax
  800452:	7f 23                	jg     800477 <vprintfmt+0x148>
  800454:	8b 14 85 40 29 80 00 	mov    0x802940(,%eax,4),%edx
  80045b:	85 d2                	test   %edx,%edx
  80045d:	74 18                	je     800477 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80045f:	52                   	push   %edx
  800460:	68 5d 2a 80 00       	push   $0x802a5d
  800465:	53                   	push   %ebx
  800466:	56                   	push   %esi
  800467:	e8 a6 fe ff ff       	call   800312 <printfmt>
  80046c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80046f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800472:	e9 fe 02 00 00       	jmp    800775 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800477:	50                   	push   %eax
  800478:	68 11 26 80 00       	push   $0x802611
  80047d:	53                   	push   %ebx
  80047e:	56                   	push   %esi
  80047f:	e8 8e fe ff ff       	call   800312 <printfmt>
  800484:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800487:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80048a:	e9 e6 02 00 00       	jmp    800775 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80048f:	8b 45 14             	mov    0x14(%ebp),%eax
  800492:	83 c0 04             	add    $0x4,%eax
  800495:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800498:	8b 45 14             	mov    0x14(%ebp),%eax
  80049b:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80049d:	85 c9                	test   %ecx,%ecx
  80049f:	b8 0a 26 80 00       	mov    $0x80260a,%eax
  8004a4:	0f 45 c1             	cmovne %ecx,%eax
  8004a7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ae:	7e 06                	jle    8004b6 <vprintfmt+0x187>
  8004b0:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004b4:	75 0d                	jne    8004c3 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004b9:	89 c7                	mov    %eax,%edi
  8004bb:	03 45 e0             	add    -0x20(%ebp),%eax
  8004be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c1:	eb 53                	jmp    800516 <vprintfmt+0x1e7>
  8004c3:	83 ec 08             	sub    $0x8,%esp
  8004c6:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c9:	50                   	push   %eax
  8004ca:	e8 71 04 00 00       	call   800940 <strnlen>
  8004cf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d2:	29 c1                	sub    %eax,%ecx
  8004d4:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004dc:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e3:	eb 0f                	jmp    8004f4 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004e5:	83 ec 08             	sub    $0x8,%esp
  8004e8:	53                   	push   %ebx
  8004e9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ec:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ee:	83 ef 01             	sub    $0x1,%edi
  8004f1:	83 c4 10             	add    $0x10,%esp
  8004f4:	85 ff                	test   %edi,%edi
  8004f6:	7f ed                	jg     8004e5 <vprintfmt+0x1b6>
  8004f8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004fb:	85 c9                	test   %ecx,%ecx
  8004fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800502:	0f 49 c1             	cmovns %ecx,%eax
  800505:	29 c1                	sub    %eax,%ecx
  800507:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80050a:	eb aa                	jmp    8004b6 <vprintfmt+0x187>
					putch(ch, putdat);
  80050c:	83 ec 08             	sub    $0x8,%esp
  80050f:	53                   	push   %ebx
  800510:	52                   	push   %edx
  800511:	ff d6                	call   *%esi
  800513:	83 c4 10             	add    $0x10,%esp
  800516:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800519:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80051b:	83 c7 01             	add    $0x1,%edi
  80051e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800522:	0f be d0             	movsbl %al,%edx
  800525:	85 d2                	test   %edx,%edx
  800527:	74 4b                	je     800574 <vprintfmt+0x245>
  800529:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80052d:	78 06                	js     800535 <vprintfmt+0x206>
  80052f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800533:	78 1e                	js     800553 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800535:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800539:	74 d1                	je     80050c <vprintfmt+0x1dd>
  80053b:	0f be c0             	movsbl %al,%eax
  80053e:	83 e8 20             	sub    $0x20,%eax
  800541:	83 f8 5e             	cmp    $0x5e,%eax
  800544:	76 c6                	jbe    80050c <vprintfmt+0x1dd>
					putch('?', putdat);
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	53                   	push   %ebx
  80054a:	6a 3f                	push   $0x3f
  80054c:	ff d6                	call   *%esi
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	eb c3                	jmp    800516 <vprintfmt+0x1e7>
  800553:	89 cf                	mov    %ecx,%edi
  800555:	eb 0e                	jmp    800565 <vprintfmt+0x236>
				putch(' ', putdat);
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	53                   	push   %ebx
  80055b:	6a 20                	push   $0x20
  80055d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80055f:	83 ef 01             	sub    $0x1,%edi
  800562:	83 c4 10             	add    $0x10,%esp
  800565:	85 ff                	test   %edi,%edi
  800567:	7f ee                	jg     800557 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800569:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80056c:	89 45 14             	mov    %eax,0x14(%ebp)
  80056f:	e9 01 02 00 00       	jmp    800775 <vprintfmt+0x446>
  800574:	89 cf                	mov    %ecx,%edi
  800576:	eb ed                	jmp    800565 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800578:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80057b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800582:	e9 eb fd ff ff       	jmp    800372 <vprintfmt+0x43>
	if (lflag >= 2)
  800587:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80058b:	7f 21                	jg     8005ae <vprintfmt+0x27f>
	else if (lflag)
  80058d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800591:	74 68                	je     8005fb <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	8b 00                	mov    (%eax),%eax
  800598:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80059b:	89 c1                	mov    %eax,%ecx
  80059d:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	8d 40 04             	lea    0x4(%eax),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ac:	eb 17                	jmp    8005c5 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8b 50 04             	mov    0x4(%eax),%edx
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005b9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bf:	8d 40 08             	lea    0x8(%eax),%eax
  8005c2:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005d1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005d5:	78 3f                	js     800616 <vprintfmt+0x2e7>
			base = 10;
  8005d7:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005dc:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005e0:	0f 84 71 01 00 00    	je     800757 <vprintfmt+0x428>
				putch('+', putdat);
  8005e6:	83 ec 08             	sub    $0x8,%esp
  8005e9:	53                   	push   %ebx
  8005ea:	6a 2b                	push   $0x2b
  8005ec:	ff d6                	call   *%esi
  8005ee:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f6:	e9 5c 01 00 00       	jmp    800757 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800603:	89 c1                	mov    %eax,%ecx
  800605:	c1 f9 1f             	sar    $0x1f,%ecx
  800608:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8d 40 04             	lea    0x4(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
  800614:	eb af                	jmp    8005c5 <vprintfmt+0x296>
				putch('-', putdat);
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	53                   	push   %ebx
  80061a:	6a 2d                	push   $0x2d
  80061c:	ff d6                	call   *%esi
				num = -(long long) num;
  80061e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800621:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800624:	f7 d8                	neg    %eax
  800626:	83 d2 00             	adc    $0x0,%edx
  800629:	f7 da                	neg    %edx
  80062b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800631:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800634:	b8 0a 00 00 00       	mov    $0xa,%eax
  800639:	e9 19 01 00 00       	jmp    800757 <vprintfmt+0x428>
	if (lflag >= 2)
  80063e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800642:	7f 29                	jg     80066d <vprintfmt+0x33e>
	else if (lflag)
  800644:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800648:	74 44                	je     80068e <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	ba 00 00 00 00       	mov    $0x0,%edx
  800654:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800657:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8d 40 04             	lea    0x4(%eax),%eax
  800660:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800663:	b8 0a 00 00 00       	mov    $0xa,%eax
  800668:	e9 ea 00 00 00       	jmp    800757 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8b 50 04             	mov    0x4(%eax),%edx
  800673:	8b 00                	mov    (%eax),%eax
  800675:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800678:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8d 40 08             	lea    0x8(%eax),%eax
  800681:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800684:	b8 0a 00 00 00       	mov    $0xa,%eax
  800689:	e9 c9 00 00 00       	jmp    800757 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	ba 00 00 00 00       	mov    $0x0,%edx
  800698:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8d 40 04             	lea    0x4(%eax),%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ac:	e9 a6 00 00 00       	jmp    800757 <vprintfmt+0x428>
			putch('0', putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	53                   	push   %ebx
  8006b5:	6a 30                	push   $0x30
  8006b7:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006b9:	83 c4 10             	add    $0x10,%esp
  8006bc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006c0:	7f 26                	jg     8006e8 <vprintfmt+0x3b9>
	else if (lflag)
  8006c2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006c6:	74 3e                	je     800706 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8d 40 04             	lea    0x4(%eax),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8006e6:	eb 6f                	jmp    800757 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8b 50 04             	mov    0x4(%eax),%edx
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8d 40 08             	lea    0x8(%eax),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ff:	b8 08 00 00 00       	mov    $0x8,%eax
  800704:	eb 51                	jmp    800757 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	ba 00 00 00 00       	mov    $0x0,%edx
  800710:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800713:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8d 40 04             	lea    0x4(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80071f:	b8 08 00 00 00       	mov    $0x8,%eax
  800724:	eb 31                	jmp    800757 <vprintfmt+0x428>
			putch('0', putdat);
  800726:	83 ec 08             	sub    $0x8,%esp
  800729:	53                   	push   %ebx
  80072a:	6a 30                	push   $0x30
  80072c:	ff d6                	call   *%esi
			putch('x', putdat);
  80072e:	83 c4 08             	add    $0x8,%esp
  800731:	53                   	push   %ebx
  800732:	6a 78                	push   $0x78
  800734:	ff d6                	call   *%esi
			num = (unsigned long long)
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	ba 00 00 00 00       	mov    $0x0,%edx
  800740:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800743:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800746:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8d 40 04             	lea    0x4(%eax),%eax
  80074f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800752:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800757:	83 ec 0c             	sub    $0xc,%esp
  80075a:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80075e:	52                   	push   %edx
  80075f:	ff 75 e0             	pushl  -0x20(%ebp)
  800762:	50                   	push   %eax
  800763:	ff 75 dc             	pushl  -0x24(%ebp)
  800766:	ff 75 d8             	pushl  -0x28(%ebp)
  800769:	89 da                	mov    %ebx,%edx
  80076b:	89 f0                	mov    %esi,%eax
  80076d:	e8 a4 fa ff ff       	call   800216 <printnum>
			break;
  800772:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800775:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800778:	83 c7 01             	add    $0x1,%edi
  80077b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80077f:	83 f8 25             	cmp    $0x25,%eax
  800782:	0f 84 be fb ff ff    	je     800346 <vprintfmt+0x17>
			if (ch == '\0')
  800788:	85 c0                	test   %eax,%eax
  80078a:	0f 84 28 01 00 00    	je     8008b8 <vprintfmt+0x589>
			putch(ch, putdat);
  800790:	83 ec 08             	sub    $0x8,%esp
  800793:	53                   	push   %ebx
  800794:	50                   	push   %eax
  800795:	ff d6                	call   *%esi
  800797:	83 c4 10             	add    $0x10,%esp
  80079a:	eb dc                	jmp    800778 <vprintfmt+0x449>
	if (lflag >= 2)
  80079c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007a0:	7f 26                	jg     8007c8 <vprintfmt+0x499>
	else if (lflag)
  8007a2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007a6:	74 41                	je     8007e9 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	8b 00                	mov    (%eax),%eax
  8007ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	8d 40 04             	lea    0x4(%eax),%eax
  8007be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c1:	b8 10 00 00 00       	mov    $0x10,%eax
  8007c6:	eb 8f                	jmp    800757 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	8b 50 04             	mov    0x4(%eax),%edx
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8d 40 08             	lea    0x8(%eax),%eax
  8007dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007df:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e4:	e9 6e ff ff ff       	jmp    800757 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8b 00                	mov    (%eax),%eax
  8007ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8d 40 04             	lea    0x4(%eax),%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800802:	b8 10 00 00 00       	mov    $0x10,%eax
  800807:	e9 4b ff ff ff       	jmp    800757 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80080c:	8b 45 14             	mov    0x14(%ebp),%eax
  80080f:	83 c0 04             	add    $0x4,%eax
  800812:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8b 00                	mov    (%eax),%eax
  80081a:	85 c0                	test   %eax,%eax
  80081c:	74 14                	je     800832 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80081e:	8b 13                	mov    (%ebx),%edx
  800820:	83 fa 7f             	cmp    $0x7f,%edx
  800823:	7f 37                	jg     80085c <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800825:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800827:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80082a:	89 45 14             	mov    %eax,0x14(%ebp)
  80082d:	e9 43 ff ff ff       	jmp    800775 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800832:	b8 0a 00 00 00       	mov    $0xa,%eax
  800837:	bf 2d 27 80 00       	mov    $0x80272d,%edi
							putch(ch, putdat);
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	53                   	push   %ebx
  800840:	50                   	push   %eax
  800841:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800843:	83 c7 01             	add    $0x1,%edi
  800846:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80084a:	83 c4 10             	add    $0x10,%esp
  80084d:	85 c0                	test   %eax,%eax
  80084f:	75 eb                	jne    80083c <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800851:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
  800857:	e9 19 ff ff ff       	jmp    800775 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80085c:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80085e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800863:	bf 65 27 80 00       	mov    $0x802765,%edi
							putch(ch, putdat);
  800868:	83 ec 08             	sub    $0x8,%esp
  80086b:	53                   	push   %ebx
  80086c:	50                   	push   %eax
  80086d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80086f:	83 c7 01             	add    $0x1,%edi
  800872:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800876:	83 c4 10             	add    $0x10,%esp
  800879:	85 c0                	test   %eax,%eax
  80087b:	75 eb                	jne    800868 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80087d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800880:	89 45 14             	mov    %eax,0x14(%ebp)
  800883:	e9 ed fe ff ff       	jmp    800775 <vprintfmt+0x446>
			putch(ch, putdat);
  800888:	83 ec 08             	sub    $0x8,%esp
  80088b:	53                   	push   %ebx
  80088c:	6a 25                	push   $0x25
  80088e:	ff d6                	call   *%esi
			break;
  800890:	83 c4 10             	add    $0x10,%esp
  800893:	e9 dd fe ff ff       	jmp    800775 <vprintfmt+0x446>
			putch('%', putdat);
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	53                   	push   %ebx
  80089c:	6a 25                	push   $0x25
  80089e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008a0:	83 c4 10             	add    $0x10,%esp
  8008a3:	89 f8                	mov    %edi,%eax
  8008a5:	eb 03                	jmp    8008aa <vprintfmt+0x57b>
  8008a7:	83 e8 01             	sub    $0x1,%eax
  8008aa:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008ae:	75 f7                	jne    8008a7 <vprintfmt+0x578>
  8008b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008b3:	e9 bd fe ff ff       	jmp    800775 <vprintfmt+0x446>
}
  8008b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008bb:	5b                   	pop    %ebx
  8008bc:	5e                   	pop    %esi
  8008bd:	5f                   	pop    %edi
  8008be:	5d                   	pop    %ebp
  8008bf:	c3                   	ret    

008008c0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	83 ec 18             	sub    $0x18,%esp
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008cf:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008d3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008dd:	85 c0                	test   %eax,%eax
  8008df:	74 26                	je     800907 <vsnprintf+0x47>
  8008e1:	85 d2                	test   %edx,%edx
  8008e3:	7e 22                	jle    800907 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e5:	ff 75 14             	pushl  0x14(%ebp)
  8008e8:	ff 75 10             	pushl  0x10(%ebp)
  8008eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ee:	50                   	push   %eax
  8008ef:	68 f5 02 80 00       	push   $0x8002f5
  8008f4:	e8 36 fa ff ff       	call   80032f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008fc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800902:	83 c4 10             	add    $0x10,%esp
}
  800905:	c9                   	leave  
  800906:	c3                   	ret    
		return -E_INVAL;
  800907:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80090c:	eb f7                	jmp    800905 <vsnprintf+0x45>

0080090e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800914:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800917:	50                   	push   %eax
  800918:	ff 75 10             	pushl  0x10(%ebp)
  80091b:	ff 75 0c             	pushl  0xc(%ebp)
  80091e:	ff 75 08             	pushl  0x8(%ebp)
  800921:	e8 9a ff ff ff       	call   8008c0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800926:	c9                   	leave  
  800927:	c3                   	ret    

00800928 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80092e:	b8 00 00 00 00       	mov    $0x0,%eax
  800933:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800937:	74 05                	je     80093e <strlen+0x16>
		n++;
  800939:	83 c0 01             	add    $0x1,%eax
  80093c:	eb f5                	jmp    800933 <strlen+0xb>
	return n;
}
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    

00800940 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800946:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800949:	ba 00 00 00 00       	mov    $0x0,%edx
  80094e:	39 c2                	cmp    %eax,%edx
  800950:	74 0d                	je     80095f <strnlen+0x1f>
  800952:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800956:	74 05                	je     80095d <strnlen+0x1d>
		n++;
  800958:	83 c2 01             	add    $0x1,%edx
  80095b:	eb f1                	jmp    80094e <strnlen+0xe>
  80095d:	89 d0                	mov    %edx,%eax
	return n;
}
  80095f:	5d                   	pop    %ebp
  800960:	c3                   	ret    

00800961 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	53                   	push   %ebx
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80096b:	ba 00 00 00 00       	mov    $0x0,%edx
  800970:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800974:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800977:	83 c2 01             	add    $0x1,%edx
  80097a:	84 c9                	test   %cl,%cl
  80097c:	75 f2                	jne    800970 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80097e:	5b                   	pop    %ebx
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	53                   	push   %ebx
  800985:	83 ec 10             	sub    $0x10,%esp
  800988:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80098b:	53                   	push   %ebx
  80098c:	e8 97 ff ff ff       	call   800928 <strlen>
  800991:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800994:	ff 75 0c             	pushl  0xc(%ebp)
  800997:	01 d8                	add    %ebx,%eax
  800999:	50                   	push   %eax
  80099a:	e8 c2 ff ff ff       	call   800961 <strcpy>
	return dst;
}
  80099f:	89 d8                	mov    %ebx,%eax
  8009a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009a4:	c9                   	leave  
  8009a5:	c3                   	ret    

008009a6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	56                   	push   %esi
  8009aa:	53                   	push   %ebx
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b1:	89 c6                	mov    %eax,%esi
  8009b3:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b6:	89 c2                	mov    %eax,%edx
  8009b8:	39 f2                	cmp    %esi,%edx
  8009ba:	74 11                	je     8009cd <strncpy+0x27>
		*dst++ = *src;
  8009bc:	83 c2 01             	add    $0x1,%edx
  8009bf:	0f b6 19             	movzbl (%ecx),%ebx
  8009c2:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009c5:	80 fb 01             	cmp    $0x1,%bl
  8009c8:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009cb:	eb eb                	jmp    8009b8 <strncpy+0x12>
	}
	return ret;
}
  8009cd:	5b                   	pop    %ebx
  8009ce:	5e                   	pop    %esi
  8009cf:	5d                   	pop    %ebp
  8009d0:	c3                   	ret    

008009d1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	56                   	push   %esi
  8009d5:	53                   	push   %ebx
  8009d6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009dc:	8b 55 10             	mov    0x10(%ebp),%edx
  8009df:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009e1:	85 d2                	test   %edx,%edx
  8009e3:	74 21                	je     800a06 <strlcpy+0x35>
  8009e5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009e9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009eb:	39 c2                	cmp    %eax,%edx
  8009ed:	74 14                	je     800a03 <strlcpy+0x32>
  8009ef:	0f b6 19             	movzbl (%ecx),%ebx
  8009f2:	84 db                	test   %bl,%bl
  8009f4:	74 0b                	je     800a01 <strlcpy+0x30>
			*dst++ = *src++;
  8009f6:	83 c1 01             	add    $0x1,%ecx
  8009f9:	83 c2 01             	add    $0x1,%edx
  8009fc:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009ff:	eb ea                	jmp    8009eb <strlcpy+0x1a>
  800a01:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a03:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a06:	29 f0                	sub    %esi,%eax
}
  800a08:	5b                   	pop    %ebx
  800a09:	5e                   	pop    %esi
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a12:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a15:	0f b6 01             	movzbl (%ecx),%eax
  800a18:	84 c0                	test   %al,%al
  800a1a:	74 0c                	je     800a28 <strcmp+0x1c>
  800a1c:	3a 02                	cmp    (%edx),%al
  800a1e:	75 08                	jne    800a28 <strcmp+0x1c>
		p++, q++;
  800a20:	83 c1 01             	add    $0x1,%ecx
  800a23:	83 c2 01             	add    $0x1,%edx
  800a26:	eb ed                	jmp    800a15 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a28:	0f b6 c0             	movzbl %al,%eax
  800a2b:	0f b6 12             	movzbl (%edx),%edx
  800a2e:	29 d0                	sub    %edx,%eax
}
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	53                   	push   %ebx
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3c:	89 c3                	mov    %eax,%ebx
  800a3e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a41:	eb 06                	jmp    800a49 <strncmp+0x17>
		n--, p++, q++;
  800a43:	83 c0 01             	add    $0x1,%eax
  800a46:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a49:	39 d8                	cmp    %ebx,%eax
  800a4b:	74 16                	je     800a63 <strncmp+0x31>
  800a4d:	0f b6 08             	movzbl (%eax),%ecx
  800a50:	84 c9                	test   %cl,%cl
  800a52:	74 04                	je     800a58 <strncmp+0x26>
  800a54:	3a 0a                	cmp    (%edx),%cl
  800a56:	74 eb                	je     800a43 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a58:	0f b6 00             	movzbl (%eax),%eax
  800a5b:	0f b6 12             	movzbl (%edx),%edx
  800a5e:	29 d0                	sub    %edx,%eax
}
  800a60:	5b                   	pop    %ebx
  800a61:	5d                   	pop    %ebp
  800a62:	c3                   	ret    
		return 0;
  800a63:	b8 00 00 00 00       	mov    $0x0,%eax
  800a68:	eb f6                	jmp    800a60 <strncmp+0x2e>

00800a6a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a74:	0f b6 10             	movzbl (%eax),%edx
  800a77:	84 d2                	test   %dl,%dl
  800a79:	74 09                	je     800a84 <strchr+0x1a>
		if (*s == c)
  800a7b:	38 ca                	cmp    %cl,%dl
  800a7d:	74 0a                	je     800a89 <strchr+0x1f>
	for (; *s; s++)
  800a7f:	83 c0 01             	add    $0x1,%eax
  800a82:	eb f0                	jmp    800a74 <strchr+0xa>
			return (char *) s;
	return 0;
  800a84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    

00800a8b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a95:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a98:	38 ca                	cmp    %cl,%dl
  800a9a:	74 09                	je     800aa5 <strfind+0x1a>
  800a9c:	84 d2                	test   %dl,%dl
  800a9e:	74 05                	je     800aa5 <strfind+0x1a>
	for (; *s; s++)
  800aa0:	83 c0 01             	add    $0x1,%eax
  800aa3:	eb f0                	jmp    800a95 <strfind+0xa>
			break;
	return (char *) s;
}
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	57                   	push   %edi
  800aab:	56                   	push   %esi
  800aac:	53                   	push   %ebx
  800aad:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ab0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ab3:	85 c9                	test   %ecx,%ecx
  800ab5:	74 31                	je     800ae8 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ab7:	89 f8                	mov    %edi,%eax
  800ab9:	09 c8                	or     %ecx,%eax
  800abb:	a8 03                	test   $0x3,%al
  800abd:	75 23                	jne    800ae2 <memset+0x3b>
		c &= 0xFF;
  800abf:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac3:	89 d3                	mov    %edx,%ebx
  800ac5:	c1 e3 08             	shl    $0x8,%ebx
  800ac8:	89 d0                	mov    %edx,%eax
  800aca:	c1 e0 18             	shl    $0x18,%eax
  800acd:	89 d6                	mov    %edx,%esi
  800acf:	c1 e6 10             	shl    $0x10,%esi
  800ad2:	09 f0                	or     %esi,%eax
  800ad4:	09 c2                	or     %eax,%edx
  800ad6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ad8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800adb:	89 d0                	mov    %edx,%eax
  800add:	fc                   	cld    
  800ade:	f3 ab                	rep stos %eax,%es:(%edi)
  800ae0:	eb 06                	jmp    800ae8 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae5:	fc                   	cld    
  800ae6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ae8:	89 f8                	mov    %edi,%eax
  800aea:	5b                   	pop    %ebx
  800aeb:	5e                   	pop    %esi
  800aec:	5f                   	pop    %edi
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	57                   	push   %edi
  800af3:	56                   	push   %esi
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800afa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800afd:	39 c6                	cmp    %eax,%esi
  800aff:	73 32                	jae    800b33 <memmove+0x44>
  800b01:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b04:	39 c2                	cmp    %eax,%edx
  800b06:	76 2b                	jbe    800b33 <memmove+0x44>
		s += n;
		d += n;
  800b08:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0b:	89 fe                	mov    %edi,%esi
  800b0d:	09 ce                	or     %ecx,%esi
  800b0f:	09 d6                	or     %edx,%esi
  800b11:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b17:	75 0e                	jne    800b27 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b19:	83 ef 04             	sub    $0x4,%edi
  800b1c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b1f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b22:	fd                   	std    
  800b23:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b25:	eb 09                	jmp    800b30 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b27:	83 ef 01             	sub    $0x1,%edi
  800b2a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b2d:	fd                   	std    
  800b2e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b30:	fc                   	cld    
  800b31:	eb 1a                	jmp    800b4d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b33:	89 c2                	mov    %eax,%edx
  800b35:	09 ca                	or     %ecx,%edx
  800b37:	09 f2                	or     %esi,%edx
  800b39:	f6 c2 03             	test   $0x3,%dl
  800b3c:	75 0a                	jne    800b48 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b3e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b41:	89 c7                	mov    %eax,%edi
  800b43:	fc                   	cld    
  800b44:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b46:	eb 05                	jmp    800b4d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b48:	89 c7                	mov    %eax,%edi
  800b4a:	fc                   	cld    
  800b4b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b4d:	5e                   	pop    %esi
  800b4e:	5f                   	pop    %edi
  800b4f:	5d                   	pop    %ebp
  800b50:	c3                   	ret    

00800b51 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b57:	ff 75 10             	pushl  0x10(%ebp)
  800b5a:	ff 75 0c             	pushl  0xc(%ebp)
  800b5d:	ff 75 08             	pushl  0x8(%ebp)
  800b60:	e8 8a ff ff ff       	call   800aef <memmove>
}
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b72:	89 c6                	mov    %eax,%esi
  800b74:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b77:	39 f0                	cmp    %esi,%eax
  800b79:	74 1c                	je     800b97 <memcmp+0x30>
		if (*s1 != *s2)
  800b7b:	0f b6 08             	movzbl (%eax),%ecx
  800b7e:	0f b6 1a             	movzbl (%edx),%ebx
  800b81:	38 d9                	cmp    %bl,%cl
  800b83:	75 08                	jne    800b8d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b85:	83 c0 01             	add    $0x1,%eax
  800b88:	83 c2 01             	add    $0x1,%edx
  800b8b:	eb ea                	jmp    800b77 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b8d:	0f b6 c1             	movzbl %cl,%eax
  800b90:	0f b6 db             	movzbl %bl,%ebx
  800b93:	29 d8                	sub    %ebx,%eax
  800b95:	eb 05                	jmp    800b9c <memcmp+0x35>
	}

	return 0;
  800b97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b9c:	5b                   	pop    %ebx
  800b9d:	5e                   	pop    %esi
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ba9:	89 c2                	mov    %eax,%edx
  800bab:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bae:	39 d0                	cmp    %edx,%eax
  800bb0:	73 09                	jae    800bbb <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb2:	38 08                	cmp    %cl,(%eax)
  800bb4:	74 05                	je     800bbb <memfind+0x1b>
	for (; s < ends; s++)
  800bb6:	83 c0 01             	add    $0x1,%eax
  800bb9:	eb f3                	jmp    800bae <memfind+0xe>
			break;
	return (void *) s;
}
  800bbb:	5d                   	pop    %ebp
  800bbc:	c3                   	ret    

00800bbd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	57                   	push   %edi
  800bc1:	56                   	push   %esi
  800bc2:	53                   	push   %ebx
  800bc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bc9:	eb 03                	jmp    800bce <strtol+0x11>
		s++;
  800bcb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bce:	0f b6 01             	movzbl (%ecx),%eax
  800bd1:	3c 20                	cmp    $0x20,%al
  800bd3:	74 f6                	je     800bcb <strtol+0xe>
  800bd5:	3c 09                	cmp    $0x9,%al
  800bd7:	74 f2                	je     800bcb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bd9:	3c 2b                	cmp    $0x2b,%al
  800bdb:	74 2a                	je     800c07 <strtol+0x4a>
	int neg = 0;
  800bdd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800be2:	3c 2d                	cmp    $0x2d,%al
  800be4:	74 2b                	je     800c11 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bec:	75 0f                	jne    800bfd <strtol+0x40>
  800bee:	80 39 30             	cmpb   $0x30,(%ecx)
  800bf1:	74 28                	je     800c1b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf3:	85 db                	test   %ebx,%ebx
  800bf5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bfa:	0f 44 d8             	cmove  %eax,%ebx
  800bfd:	b8 00 00 00 00       	mov    $0x0,%eax
  800c02:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c05:	eb 50                	jmp    800c57 <strtol+0x9a>
		s++;
  800c07:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c0a:	bf 00 00 00 00       	mov    $0x0,%edi
  800c0f:	eb d5                	jmp    800be6 <strtol+0x29>
		s++, neg = 1;
  800c11:	83 c1 01             	add    $0x1,%ecx
  800c14:	bf 01 00 00 00       	mov    $0x1,%edi
  800c19:	eb cb                	jmp    800be6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c1b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c1f:	74 0e                	je     800c2f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c21:	85 db                	test   %ebx,%ebx
  800c23:	75 d8                	jne    800bfd <strtol+0x40>
		s++, base = 8;
  800c25:	83 c1 01             	add    $0x1,%ecx
  800c28:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c2d:	eb ce                	jmp    800bfd <strtol+0x40>
		s += 2, base = 16;
  800c2f:	83 c1 02             	add    $0x2,%ecx
  800c32:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c37:	eb c4                	jmp    800bfd <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c39:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c3c:	89 f3                	mov    %esi,%ebx
  800c3e:	80 fb 19             	cmp    $0x19,%bl
  800c41:	77 29                	ja     800c6c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c43:	0f be d2             	movsbl %dl,%edx
  800c46:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c49:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c4c:	7d 30                	jge    800c7e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c4e:	83 c1 01             	add    $0x1,%ecx
  800c51:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c55:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c57:	0f b6 11             	movzbl (%ecx),%edx
  800c5a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c5d:	89 f3                	mov    %esi,%ebx
  800c5f:	80 fb 09             	cmp    $0x9,%bl
  800c62:	77 d5                	ja     800c39 <strtol+0x7c>
			dig = *s - '0';
  800c64:	0f be d2             	movsbl %dl,%edx
  800c67:	83 ea 30             	sub    $0x30,%edx
  800c6a:	eb dd                	jmp    800c49 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c6c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c6f:	89 f3                	mov    %esi,%ebx
  800c71:	80 fb 19             	cmp    $0x19,%bl
  800c74:	77 08                	ja     800c7e <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c76:	0f be d2             	movsbl %dl,%edx
  800c79:	83 ea 37             	sub    $0x37,%edx
  800c7c:	eb cb                	jmp    800c49 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c82:	74 05                	je     800c89 <strtol+0xcc>
		*endptr = (char *) s;
  800c84:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c87:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c89:	89 c2                	mov    %eax,%edx
  800c8b:	f7 da                	neg    %edx
  800c8d:	85 ff                	test   %edi,%edi
  800c8f:	0f 45 c2             	cmovne %edx,%eax
}
  800c92:	5b                   	pop    %ebx
  800c93:	5e                   	pop    %esi
  800c94:	5f                   	pop    %edi
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	57                   	push   %edi
  800c9b:	56                   	push   %esi
  800c9c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca8:	89 c3                	mov    %eax,%ebx
  800caa:	89 c7                	mov    %eax,%edi
  800cac:	89 c6                	mov    %eax,%esi
  800cae:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5f                   	pop    %edi
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    

00800cb5 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	57                   	push   %edi
  800cb9:	56                   	push   %esi
  800cba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc0:	b8 01 00 00 00       	mov    $0x1,%eax
  800cc5:	89 d1                	mov    %edx,%ecx
  800cc7:	89 d3                	mov    %edx,%ebx
  800cc9:	89 d7                	mov    %edx,%edi
  800ccb:	89 d6                	mov    %edx,%esi
  800ccd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5f                   	pop    %edi
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
  800cda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cea:	89 cb                	mov    %ecx,%ebx
  800cec:	89 cf                	mov    %ecx,%edi
  800cee:	89 ce                	mov    %ecx,%esi
  800cf0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf2:	85 c0                	test   %eax,%eax
  800cf4:	7f 08                	jg     800cfe <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf9:	5b                   	pop    %ebx
  800cfa:	5e                   	pop    %esi
  800cfb:	5f                   	pop    %edi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfe:	83 ec 0c             	sub    $0xc,%esp
  800d01:	50                   	push   %eax
  800d02:	6a 03                	push   $0x3
  800d04:	68 88 29 80 00       	push   $0x802988
  800d09:	6a 43                	push   $0x43
  800d0b:	68 a5 29 80 00       	push   $0x8029a5
  800d10:	e8 69 14 00 00       	call   80217e <_panic>

00800d15 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	57                   	push   %edi
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d20:	b8 02 00 00 00       	mov    $0x2,%eax
  800d25:	89 d1                	mov    %edx,%ecx
  800d27:	89 d3                	mov    %edx,%ebx
  800d29:	89 d7                	mov    %edx,%edi
  800d2b:	89 d6                	mov    %edx,%esi
  800d2d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <sys_yield>:

void
sys_yield(void)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d44:	89 d1                	mov    %edx,%ecx
  800d46:	89 d3                	mov    %edx,%ebx
  800d48:	89 d7                	mov    %edx,%edi
  800d4a:	89 d6                	mov    %edx,%esi
  800d4c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    

00800d53 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	57                   	push   %edi
  800d57:	56                   	push   %esi
  800d58:	53                   	push   %ebx
  800d59:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5c:	be 00 00 00 00       	mov    $0x0,%esi
  800d61:	8b 55 08             	mov    0x8(%ebp),%edx
  800d64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d67:	b8 04 00 00 00       	mov    $0x4,%eax
  800d6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6f:	89 f7                	mov    %esi,%edi
  800d71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d73:	85 c0                	test   %eax,%eax
  800d75:	7f 08                	jg     800d7f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7a:	5b                   	pop    %ebx
  800d7b:	5e                   	pop    %esi
  800d7c:	5f                   	pop    %edi
  800d7d:	5d                   	pop    %ebp
  800d7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7f:	83 ec 0c             	sub    $0xc,%esp
  800d82:	50                   	push   %eax
  800d83:	6a 04                	push   $0x4
  800d85:	68 88 29 80 00       	push   $0x802988
  800d8a:	6a 43                	push   $0x43
  800d8c:	68 a5 29 80 00       	push   $0x8029a5
  800d91:	e8 e8 13 00 00       	call   80217e <_panic>

00800d96 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	57                   	push   %edi
  800d9a:	56                   	push   %esi
  800d9b:	53                   	push   %ebx
  800d9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800da2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da5:	b8 05 00 00 00       	mov    $0x5,%eax
  800daa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dad:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db0:	8b 75 18             	mov    0x18(%ebp),%esi
  800db3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db5:	85 c0                	test   %eax,%eax
  800db7:	7f 08                	jg     800dc1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800db9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbc:	5b                   	pop    %ebx
  800dbd:	5e                   	pop    %esi
  800dbe:	5f                   	pop    %edi
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc1:	83 ec 0c             	sub    $0xc,%esp
  800dc4:	50                   	push   %eax
  800dc5:	6a 05                	push   $0x5
  800dc7:	68 88 29 80 00       	push   $0x802988
  800dcc:	6a 43                	push   $0x43
  800dce:	68 a5 29 80 00       	push   $0x8029a5
  800dd3:	e8 a6 13 00 00       	call   80217e <_panic>

00800dd8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	57                   	push   %edi
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
  800dde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dec:	b8 06 00 00 00       	mov    $0x6,%eax
  800df1:	89 df                	mov    %ebx,%edi
  800df3:	89 de                	mov    %ebx,%esi
  800df5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df7:	85 c0                	test   %eax,%eax
  800df9:	7f 08                	jg     800e03 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfe:	5b                   	pop    %ebx
  800dff:	5e                   	pop    %esi
  800e00:	5f                   	pop    %edi
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e03:	83 ec 0c             	sub    $0xc,%esp
  800e06:	50                   	push   %eax
  800e07:	6a 06                	push   $0x6
  800e09:	68 88 29 80 00       	push   $0x802988
  800e0e:	6a 43                	push   $0x43
  800e10:	68 a5 29 80 00       	push   $0x8029a5
  800e15:	e8 64 13 00 00       	call   80217e <_panic>

00800e1a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	57                   	push   %edi
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
  800e20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2e:	b8 08 00 00 00       	mov    $0x8,%eax
  800e33:	89 df                	mov    %ebx,%edi
  800e35:	89 de                	mov    %ebx,%esi
  800e37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	7f 08                	jg     800e45 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e40:	5b                   	pop    %ebx
  800e41:	5e                   	pop    %esi
  800e42:	5f                   	pop    %edi
  800e43:	5d                   	pop    %ebp
  800e44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e45:	83 ec 0c             	sub    $0xc,%esp
  800e48:	50                   	push   %eax
  800e49:	6a 08                	push   $0x8
  800e4b:	68 88 29 80 00       	push   $0x802988
  800e50:	6a 43                	push   $0x43
  800e52:	68 a5 29 80 00       	push   $0x8029a5
  800e57:	e8 22 13 00 00       	call   80217e <_panic>

00800e5c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	57                   	push   %edi
  800e60:	56                   	push   %esi
  800e61:	53                   	push   %ebx
  800e62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e70:	b8 09 00 00 00       	mov    $0x9,%eax
  800e75:	89 df                	mov    %ebx,%edi
  800e77:	89 de                	mov    %ebx,%esi
  800e79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7b:	85 c0                	test   %eax,%eax
  800e7d:	7f 08                	jg     800e87 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e82:	5b                   	pop    %ebx
  800e83:	5e                   	pop    %esi
  800e84:	5f                   	pop    %edi
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	50                   	push   %eax
  800e8b:	6a 09                	push   $0x9
  800e8d:	68 88 29 80 00       	push   $0x802988
  800e92:	6a 43                	push   $0x43
  800e94:	68 a5 29 80 00       	push   $0x8029a5
  800e99:	e8 e0 12 00 00       	call   80217e <_panic>

00800e9e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	57                   	push   %edi
  800ea2:	56                   	push   %esi
  800ea3:	53                   	push   %ebx
  800ea4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eac:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb7:	89 df                	mov    %ebx,%edi
  800eb9:	89 de                	mov    %ebx,%esi
  800ebb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebd:	85 c0                	test   %eax,%eax
  800ebf:	7f 08                	jg     800ec9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ec1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec9:	83 ec 0c             	sub    $0xc,%esp
  800ecc:	50                   	push   %eax
  800ecd:	6a 0a                	push   $0xa
  800ecf:	68 88 29 80 00       	push   $0x802988
  800ed4:	6a 43                	push   $0x43
  800ed6:	68 a5 29 80 00       	push   $0x8029a5
  800edb:	e8 9e 12 00 00       	call   80217e <_panic>

00800ee0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	57                   	push   %edi
  800ee4:	56                   	push   %esi
  800ee5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eec:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef1:	be 00 00 00 00       	mov    $0x0,%esi
  800ef6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800efc:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	57                   	push   %edi
  800f07:	56                   	push   %esi
  800f08:	53                   	push   %ebx
  800f09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f11:	8b 55 08             	mov    0x8(%ebp),%edx
  800f14:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f19:	89 cb                	mov    %ecx,%ebx
  800f1b:	89 cf                	mov    %ecx,%edi
  800f1d:	89 ce                	mov    %ecx,%esi
  800f1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	7f 08                	jg     800f2d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f28:	5b                   	pop    %ebx
  800f29:	5e                   	pop    %esi
  800f2a:	5f                   	pop    %edi
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	83 ec 0c             	sub    $0xc,%esp
  800f30:	50                   	push   %eax
  800f31:	6a 0d                	push   $0xd
  800f33:	68 88 29 80 00       	push   $0x802988
  800f38:	6a 43                	push   $0x43
  800f3a:	68 a5 29 80 00       	push   $0x8029a5
  800f3f:	e8 3a 12 00 00       	call   80217e <_panic>

00800f44 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	57                   	push   %edi
  800f48:	56                   	push   %esi
  800f49:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f55:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f5a:	89 df                	mov    %ebx,%edi
  800f5c:	89 de                	mov    %ebx,%esi
  800f5e:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	57                   	push   %edi
  800f69:	56                   	push   %esi
  800f6a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f70:	8b 55 08             	mov    0x8(%ebp),%edx
  800f73:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f78:	89 cb                	mov    %ecx,%ebx
  800f7a:	89 cf                	mov    %ecx,%edi
  800f7c:	89 ce                	mov    %ecx,%esi
  800f7e:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5f                   	pop    %edi
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    

00800f85 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	57                   	push   %edi
  800f89:	56                   	push   %esi
  800f8a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f90:	b8 10 00 00 00       	mov    $0x10,%eax
  800f95:	89 d1                	mov    %edx,%ecx
  800f97:	89 d3                	mov    %edx,%ebx
  800f99:	89 d7                	mov    %edx,%edi
  800f9b:	89 d6                	mov    %edx,%esi
  800f9d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f9f:	5b                   	pop    %ebx
  800fa0:	5e                   	pop    %esi
  800fa1:	5f                   	pop    %edi
  800fa2:	5d                   	pop    %ebp
  800fa3:	c3                   	ret    

00800fa4 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	57                   	push   %edi
  800fa8:	56                   	push   %esi
  800fa9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800faa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800faf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb5:	b8 11 00 00 00       	mov    $0x11,%eax
  800fba:	89 df                	mov    %ebx,%edi
  800fbc:	89 de                	mov    %ebx,%esi
  800fbe:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fc0:	5b                   	pop    %ebx
  800fc1:	5e                   	pop    %esi
  800fc2:	5f                   	pop    %edi
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    

00800fc5 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	57                   	push   %edi
  800fc9:	56                   	push   %esi
  800fca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd6:	b8 12 00 00 00       	mov    $0x12,%eax
  800fdb:	89 df                	mov    %ebx,%edi
  800fdd:	89 de                	mov    %ebx,%esi
  800fdf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fe1:	5b                   	pop    %ebx
  800fe2:	5e                   	pop    %esi
  800fe3:	5f                   	pop    %edi
  800fe4:	5d                   	pop    %ebp
  800fe5:	c3                   	ret    

00800fe6 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	57                   	push   %edi
  800fea:	56                   	push   %esi
  800feb:	53                   	push   %ebx
  800fec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fef:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffa:	b8 13 00 00 00       	mov    $0x13,%eax
  800fff:	89 df                	mov    %ebx,%edi
  801001:	89 de                	mov    %ebx,%esi
  801003:	cd 30                	int    $0x30
	if(check && ret > 0)
  801005:	85 c0                	test   %eax,%eax
  801007:	7f 08                	jg     801011 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801009:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100c:	5b                   	pop    %ebx
  80100d:	5e                   	pop    %esi
  80100e:	5f                   	pop    %edi
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801011:	83 ec 0c             	sub    $0xc,%esp
  801014:	50                   	push   %eax
  801015:	6a 13                	push   $0x13
  801017:	68 88 29 80 00       	push   $0x802988
  80101c:	6a 43                	push   $0x43
  80101e:	68 a5 29 80 00       	push   $0x8029a5
  801023:	e8 56 11 00 00       	call   80217e <_panic>

00801028 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	05 00 00 00 30       	add    $0x30000000,%eax
  801033:	c1 e8 0c             	shr    $0xc,%eax
}
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    

00801038 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801043:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801048:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801057:	89 c2                	mov    %eax,%edx
  801059:	c1 ea 16             	shr    $0x16,%edx
  80105c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801063:	f6 c2 01             	test   $0x1,%dl
  801066:	74 2d                	je     801095 <fd_alloc+0x46>
  801068:	89 c2                	mov    %eax,%edx
  80106a:	c1 ea 0c             	shr    $0xc,%edx
  80106d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801074:	f6 c2 01             	test   $0x1,%dl
  801077:	74 1c                	je     801095 <fd_alloc+0x46>
  801079:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80107e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801083:	75 d2                	jne    801057 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80108e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801093:	eb 0a                	jmp    80109f <fd_alloc+0x50>
			*fd_store = fd;
  801095:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801098:	89 01                	mov    %eax,(%ecx)
			return 0;
  80109a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    

008010a1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010a7:	83 f8 1f             	cmp    $0x1f,%eax
  8010aa:	77 30                	ja     8010dc <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010ac:	c1 e0 0c             	shl    $0xc,%eax
  8010af:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010b4:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010ba:	f6 c2 01             	test   $0x1,%dl
  8010bd:	74 24                	je     8010e3 <fd_lookup+0x42>
  8010bf:	89 c2                	mov    %eax,%edx
  8010c1:	c1 ea 0c             	shr    $0xc,%edx
  8010c4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010cb:	f6 c2 01             	test   $0x1,%dl
  8010ce:	74 1a                	je     8010ea <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d3:	89 02                	mov    %eax,(%edx)
	return 0;
  8010d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010da:	5d                   	pop    %ebp
  8010db:	c3                   	ret    
		return -E_INVAL;
  8010dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e1:	eb f7                	jmp    8010da <fd_lookup+0x39>
		return -E_INVAL;
  8010e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e8:	eb f0                	jmp    8010da <fd_lookup+0x39>
  8010ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ef:	eb e9                	jmp    8010da <fd_lookup+0x39>

008010f1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	83 ec 08             	sub    $0x8,%esp
  8010f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ff:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801104:	39 08                	cmp    %ecx,(%eax)
  801106:	74 38                	je     801140 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801108:	83 c2 01             	add    $0x1,%edx
  80110b:	8b 04 95 30 2a 80 00 	mov    0x802a30(,%edx,4),%eax
  801112:	85 c0                	test   %eax,%eax
  801114:	75 ee                	jne    801104 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801116:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80111b:	8b 40 48             	mov    0x48(%eax),%eax
  80111e:	83 ec 04             	sub    $0x4,%esp
  801121:	51                   	push   %ecx
  801122:	50                   	push   %eax
  801123:	68 b4 29 80 00       	push   $0x8029b4
  801128:	e8 d5 f0 ff ff       	call   800202 <cprintf>
	*dev = 0;
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801136:	83 c4 10             	add    $0x10,%esp
  801139:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80113e:	c9                   	leave  
  80113f:	c3                   	ret    
			*dev = devtab[i];
  801140:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801143:	89 01                	mov    %eax,(%ecx)
			return 0;
  801145:	b8 00 00 00 00       	mov    $0x0,%eax
  80114a:	eb f2                	jmp    80113e <dev_lookup+0x4d>

0080114c <fd_close>:
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	57                   	push   %edi
  801150:	56                   	push   %esi
  801151:	53                   	push   %ebx
  801152:	83 ec 24             	sub    $0x24,%esp
  801155:	8b 75 08             	mov    0x8(%ebp),%esi
  801158:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80115b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80115e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80115f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801165:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801168:	50                   	push   %eax
  801169:	e8 33 ff ff ff       	call   8010a1 <fd_lookup>
  80116e:	89 c3                	mov    %eax,%ebx
  801170:	83 c4 10             	add    $0x10,%esp
  801173:	85 c0                	test   %eax,%eax
  801175:	78 05                	js     80117c <fd_close+0x30>
	    || fd != fd2)
  801177:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80117a:	74 16                	je     801192 <fd_close+0x46>
		return (must_exist ? r : 0);
  80117c:	89 f8                	mov    %edi,%eax
  80117e:	84 c0                	test   %al,%al
  801180:	b8 00 00 00 00       	mov    $0x0,%eax
  801185:	0f 44 d8             	cmove  %eax,%ebx
}
  801188:	89 d8                	mov    %ebx,%eax
  80118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118d:	5b                   	pop    %ebx
  80118e:	5e                   	pop    %esi
  80118f:	5f                   	pop    %edi
  801190:	5d                   	pop    %ebp
  801191:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801192:	83 ec 08             	sub    $0x8,%esp
  801195:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801198:	50                   	push   %eax
  801199:	ff 36                	pushl  (%esi)
  80119b:	e8 51 ff ff ff       	call   8010f1 <dev_lookup>
  8011a0:	89 c3                	mov    %eax,%ebx
  8011a2:	83 c4 10             	add    $0x10,%esp
  8011a5:	85 c0                	test   %eax,%eax
  8011a7:	78 1a                	js     8011c3 <fd_close+0x77>
		if (dev->dev_close)
  8011a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011ac:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011af:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	74 0b                	je     8011c3 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011b8:	83 ec 0c             	sub    $0xc,%esp
  8011bb:	56                   	push   %esi
  8011bc:	ff d0                	call   *%eax
  8011be:	89 c3                	mov    %eax,%ebx
  8011c0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011c3:	83 ec 08             	sub    $0x8,%esp
  8011c6:	56                   	push   %esi
  8011c7:	6a 00                	push   $0x0
  8011c9:	e8 0a fc ff ff       	call   800dd8 <sys_page_unmap>
	return r;
  8011ce:	83 c4 10             	add    $0x10,%esp
  8011d1:	eb b5                	jmp    801188 <fd_close+0x3c>

008011d3 <close>:

int
close(int fdnum)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011dc:	50                   	push   %eax
  8011dd:	ff 75 08             	pushl  0x8(%ebp)
  8011e0:	e8 bc fe ff ff       	call   8010a1 <fd_lookup>
  8011e5:	83 c4 10             	add    $0x10,%esp
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	79 02                	jns    8011ee <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    
		return fd_close(fd, 1);
  8011ee:	83 ec 08             	sub    $0x8,%esp
  8011f1:	6a 01                	push   $0x1
  8011f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f6:	e8 51 ff ff ff       	call   80114c <fd_close>
  8011fb:	83 c4 10             	add    $0x10,%esp
  8011fe:	eb ec                	jmp    8011ec <close+0x19>

00801200 <close_all>:

void
close_all(void)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	53                   	push   %ebx
  801204:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801207:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80120c:	83 ec 0c             	sub    $0xc,%esp
  80120f:	53                   	push   %ebx
  801210:	e8 be ff ff ff       	call   8011d3 <close>
	for (i = 0; i < MAXFD; i++)
  801215:	83 c3 01             	add    $0x1,%ebx
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	83 fb 20             	cmp    $0x20,%ebx
  80121e:	75 ec                	jne    80120c <close_all+0xc>
}
  801220:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801223:	c9                   	leave  
  801224:	c3                   	ret    

00801225 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
  801228:	57                   	push   %edi
  801229:	56                   	push   %esi
  80122a:	53                   	push   %ebx
  80122b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80122e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801231:	50                   	push   %eax
  801232:	ff 75 08             	pushl  0x8(%ebp)
  801235:	e8 67 fe ff ff       	call   8010a1 <fd_lookup>
  80123a:	89 c3                	mov    %eax,%ebx
  80123c:	83 c4 10             	add    $0x10,%esp
  80123f:	85 c0                	test   %eax,%eax
  801241:	0f 88 81 00 00 00    	js     8012c8 <dup+0xa3>
		return r;
	close(newfdnum);
  801247:	83 ec 0c             	sub    $0xc,%esp
  80124a:	ff 75 0c             	pushl  0xc(%ebp)
  80124d:	e8 81 ff ff ff       	call   8011d3 <close>

	newfd = INDEX2FD(newfdnum);
  801252:	8b 75 0c             	mov    0xc(%ebp),%esi
  801255:	c1 e6 0c             	shl    $0xc,%esi
  801258:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80125e:	83 c4 04             	add    $0x4,%esp
  801261:	ff 75 e4             	pushl  -0x1c(%ebp)
  801264:	e8 cf fd ff ff       	call   801038 <fd2data>
  801269:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80126b:	89 34 24             	mov    %esi,(%esp)
  80126e:	e8 c5 fd ff ff       	call   801038 <fd2data>
  801273:	83 c4 10             	add    $0x10,%esp
  801276:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801278:	89 d8                	mov    %ebx,%eax
  80127a:	c1 e8 16             	shr    $0x16,%eax
  80127d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801284:	a8 01                	test   $0x1,%al
  801286:	74 11                	je     801299 <dup+0x74>
  801288:	89 d8                	mov    %ebx,%eax
  80128a:	c1 e8 0c             	shr    $0xc,%eax
  80128d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801294:	f6 c2 01             	test   $0x1,%dl
  801297:	75 39                	jne    8012d2 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801299:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80129c:	89 d0                	mov    %edx,%eax
  80129e:	c1 e8 0c             	shr    $0xc,%eax
  8012a1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012a8:	83 ec 0c             	sub    $0xc,%esp
  8012ab:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b0:	50                   	push   %eax
  8012b1:	56                   	push   %esi
  8012b2:	6a 00                	push   $0x0
  8012b4:	52                   	push   %edx
  8012b5:	6a 00                	push   $0x0
  8012b7:	e8 da fa ff ff       	call   800d96 <sys_page_map>
  8012bc:	89 c3                	mov    %eax,%ebx
  8012be:	83 c4 20             	add    $0x20,%esp
  8012c1:	85 c0                	test   %eax,%eax
  8012c3:	78 31                	js     8012f6 <dup+0xd1>
		goto err;

	return newfdnum;
  8012c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012c8:	89 d8                	mov    %ebx,%eax
  8012ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012cd:	5b                   	pop    %ebx
  8012ce:	5e                   	pop    %esi
  8012cf:	5f                   	pop    %edi
  8012d0:	5d                   	pop    %ebp
  8012d1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012d2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012d9:	83 ec 0c             	sub    $0xc,%esp
  8012dc:	25 07 0e 00 00       	and    $0xe07,%eax
  8012e1:	50                   	push   %eax
  8012e2:	57                   	push   %edi
  8012e3:	6a 00                	push   $0x0
  8012e5:	53                   	push   %ebx
  8012e6:	6a 00                	push   $0x0
  8012e8:	e8 a9 fa ff ff       	call   800d96 <sys_page_map>
  8012ed:	89 c3                	mov    %eax,%ebx
  8012ef:	83 c4 20             	add    $0x20,%esp
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	79 a3                	jns    801299 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012f6:	83 ec 08             	sub    $0x8,%esp
  8012f9:	56                   	push   %esi
  8012fa:	6a 00                	push   $0x0
  8012fc:	e8 d7 fa ff ff       	call   800dd8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801301:	83 c4 08             	add    $0x8,%esp
  801304:	57                   	push   %edi
  801305:	6a 00                	push   $0x0
  801307:	e8 cc fa ff ff       	call   800dd8 <sys_page_unmap>
	return r;
  80130c:	83 c4 10             	add    $0x10,%esp
  80130f:	eb b7                	jmp    8012c8 <dup+0xa3>

00801311 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	53                   	push   %ebx
  801315:	83 ec 1c             	sub    $0x1c,%esp
  801318:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80131b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80131e:	50                   	push   %eax
  80131f:	53                   	push   %ebx
  801320:	e8 7c fd ff ff       	call   8010a1 <fd_lookup>
  801325:	83 c4 10             	add    $0x10,%esp
  801328:	85 c0                	test   %eax,%eax
  80132a:	78 3f                	js     80136b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80132c:	83 ec 08             	sub    $0x8,%esp
  80132f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801332:	50                   	push   %eax
  801333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801336:	ff 30                	pushl  (%eax)
  801338:	e8 b4 fd ff ff       	call   8010f1 <dev_lookup>
  80133d:	83 c4 10             	add    $0x10,%esp
  801340:	85 c0                	test   %eax,%eax
  801342:	78 27                	js     80136b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801344:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801347:	8b 42 08             	mov    0x8(%edx),%eax
  80134a:	83 e0 03             	and    $0x3,%eax
  80134d:	83 f8 01             	cmp    $0x1,%eax
  801350:	74 1e                	je     801370 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801355:	8b 40 08             	mov    0x8(%eax),%eax
  801358:	85 c0                	test   %eax,%eax
  80135a:	74 35                	je     801391 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80135c:	83 ec 04             	sub    $0x4,%esp
  80135f:	ff 75 10             	pushl  0x10(%ebp)
  801362:	ff 75 0c             	pushl  0xc(%ebp)
  801365:	52                   	push   %edx
  801366:	ff d0                	call   *%eax
  801368:	83 c4 10             	add    $0x10,%esp
}
  80136b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801370:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801375:	8b 40 48             	mov    0x48(%eax),%eax
  801378:	83 ec 04             	sub    $0x4,%esp
  80137b:	53                   	push   %ebx
  80137c:	50                   	push   %eax
  80137d:	68 f5 29 80 00       	push   $0x8029f5
  801382:	e8 7b ee ff ff       	call   800202 <cprintf>
		return -E_INVAL;
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80138f:	eb da                	jmp    80136b <read+0x5a>
		return -E_NOT_SUPP;
  801391:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801396:	eb d3                	jmp    80136b <read+0x5a>

00801398 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	57                   	push   %edi
  80139c:	56                   	push   %esi
  80139d:	53                   	push   %ebx
  80139e:	83 ec 0c             	sub    $0xc,%esp
  8013a1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013a4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ac:	39 f3                	cmp    %esi,%ebx
  8013ae:	73 23                	jae    8013d3 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013b0:	83 ec 04             	sub    $0x4,%esp
  8013b3:	89 f0                	mov    %esi,%eax
  8013b5:	29 d8                	sub    %ebx,%eax
  8013b7:	50                   	push   %eax
  8013b8:	89 d8                	mov    %ebx,%eax
  8013ba:	03 45 0c             	add    0xc(%ebp),%eax
  8013bd:	50                   	push   %eax
  8013be:	57                   	push   %edi
  8013bf:	e8 4d ff ff ff       	call   801311 <read>
		if (m < 0)
  8013c4:	83 c4 10             	add    $0x10,%esp
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	78 06                	js     8013d1 <readn+0x39>
			return m;
		if (m == 0)
  8013cb:	74 06                	je     8013d3 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013cd:	01 c3                	add    %eax,%ebx
  8013cf:	eb db                	jmp    8013ac <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013d1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013d3:	89 d8                	mov    %ebx,%eax
  8013d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d8:	5b                   	pop    %ebx
  8013d9:	5e                   	pop    %esi
  8013da:	5f                   	pop    %edi
  8013db:	5d                   	pop    %ebp
  8013dc:	c3                   	ret    

008013dd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	53                   	push   %ebx
  8013e1:	83 ec 1c             	sub    $0x1c,%esp
  8013e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ea:	50                   	push   %eax
  8013eb:	53                   	push   %ebx
  8013ec:	e8 b0 fc ff ff       	call   8010a1 <fd_lookup>
  8013f1:	83 c4 10             	add    $0x10,%esp
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	78 3a                	js     801432 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013f8:	83 ec 08             	sub    $0x8,%esp
  8013fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fe:	50                   	push   %eax
  8013ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801402:	ff 30                	pushl  (%eax)
  801404:	e8 e8 fc ff ff       	call   8010f1 <dev_lookup>
  801409:	83 c4 10             	add    $0x10,%esp
  80140c:	85 c0                	test   %eax,%eax
  80140e:	78 22                	js     801432 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801413:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801417:	74 1e                	je     801437 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801419:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141c:	8b 52 0c             	mov    0xc(%edx),%edx
  80141f:	85 d2                	test   %edx,%edx
  801421:	74 35                	je     801458 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801423:	83 ec 04             	sub    $0x4,%esp
  801426:	ff 75 10             	pushl  0x10(%ebp)
  801429:	ff 75 0c             	pushl  0xc(%ebp)
  80142c:	50                   	push   %eax
  80142d:	ff d2                	call   *%edx
  80142f:	83 c4 10             	add    $0x10,%esp
}
  801432:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801435:	c9                   	leave  
  801436:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801437:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80143c:	8b 40 48             	mov    0x48(%eax),%eax
  80143f:	83 ec 04             	sub    $0x4,%esp
  801442:	53                   	push   %ebx
  801443:	50                   	push   %eax
  801444:	68 11 2a 80 00       	push   $0x802a11
  801449:	e8 b4 ed ff ff       	call   800202 <cprintf>
		return -E_INVAL;
  80144e:	83 c4 10             	add    $0x10,%esp
  801451:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801456:	eb da                	jmp    801432 <write+0x55>
		return -E_NOT_SUPP;
  801458:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80145d:	eb d3                	jmp    801432 <write+0x55>

0080145f <seek>:

int
seek(int fdnum, off_t offset)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801465:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801468:	50                   	push   %eax
  801469:	ff 75 08             	pushl  0x8(%ebp)
  80146c:	e8 30 fc ff ff       	call   8010a1 <fd_lookup>
  801471:	83 c4 10             	add    $0x10,%esp
  801474:	85 c0                	test   %eax,%eax
  801476:	78 0e                	js     801486 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801478:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801481:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801486:	c9                   	leave  
  801487:	c3                   	ret    

00801488 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	53                   	push   %ebx
  80148c:	83 ec 1c             	sub    $0x1c,%esp
  80148f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801492:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801495:	50                   	push   %eax
  801496:	53                   	push   %ebx
  801497:	e8 05 fc ff ff       	call   8010a1 <fd_lookup>
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	78 37                	js     8014da <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a3:	83 ec 08             	sub    $0x8,%esp
  8014a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a9:	50                   	push   %eax
  8014aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ad:	ff 30                	pushl  (%eax)
  8014af:	e8 3d fc ff ff       	call   8010f1 <dev_lookup>
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	78 1f                	js     8014da <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014be:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014c2:	74 1b                	je     8014df <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c7:	8b 52 18             	mov    0x18(%edx),%edx
  8014ca:	85 d2                	test   %edx,%edx
  8014cc:	74 32                	je     801500 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014ce:	83 ec 08             	sub    $0x8,%esp
  8014d1:	ff 75 0c             	pushl  0xc(%ebp)
  8014d4:	50                   	push   %eax
  8014d5:	ff d2                	call   *%edx
  8014d7:	83 c4 10             	add    $0x10,%esp
}
  8014da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014df:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014e4:	8b 40 48             	mov    0x48(%eax),%eax
  8014e7:	83 ec 04             	sub    $0x4,%esp
  8014ea:	53                   	push   %ebx
  8014eb:	50                   	push   %eax
  8014ec:	68 d4 29 80 00       	push   $0x8029d4
  8014f1:	e8 0c ed ff ff       	call   800202 <cprintf>
		return -E_INVAL;
  8014f6:	83 c4 10             	add    $0x10,%esp
  8014f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fe:	eb da                	jmp    8014da <ftruncate+0x52>
		return -E_NOT_SUPP;
  801500:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801505:	eb d3                	jmp    8014da <ftruncate+0x52>

00801507 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	53                   	push   %ebx
  80150b:	83 ec 1c             	sub    $0x1c,%esp
  80150e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801511:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801514:	50                   	push   %eax
  801515:	ff 75 08             	pushl  0x8(%ebp)
  801518:	e8 84 fb ff ff       	call   8010a1 <fd_lookup>
  80151d:	83 c4 10             	add    $0x10,%esp
  801520:	85 c0                	test   %eax,%eax
  801522:	78 4b                	js     80156f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801524:	83 ec 08             	sub    $0x8,%esp
  801527:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152a:	50                   	push   %eax
  80152b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152e:	ff 30                	pushl  (%eax)
  801530:	e8 bc fb ff ff       	call   8010f1 <dev_lookup>
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	85 c0                	test   %eax,%eax
  80153a:	78 33                	js     80156f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80153c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801543:	74 2f                	je     801574 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801545:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801548:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80154f:	00 00 00 
	stat->st_isdir = 0;
  801552:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801559:	00 00 00 
	stat->st_dev = dev;
  80155c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801562:	83 ec 08             	sub    $0x8,%esp
  801565:	53                   	push   %ebx
  801566:	ff 75 f0             	pushl  -0x10(%ebp)
  801569:	ff 50 14             	call   *0x14(%eax)
  80156c:	83 c4 10             	add    $0x10,%esp
}
  80156f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801572:	c9                   	leave  
  801573:	c3                   	ret    
		return -E_NOT_SUPP;
  801574:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801579:	eb f4                	jmp    80156f <fstat+0x68>

0080157b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	56                   	push   %esi
  80157f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801580:	83 ec 08             	sub    $0x8,%esp
  801583:	6a 00                	push   $0x0
  801585:	ff 75 08             	pushl  0x8(%ebp)
  801588:	e8 22 02 00 00       	call   8017af <open>
  80158d:	89 c3                	mov    %eax,%ebx
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	85 c0                	test   %eax,%eax
  801594:	78 1b                	js     8015b1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801596:	83 ec 08             	sub    $0x8,%esp
  801599:	ff 75 0c             	pushl  0xc(%ebp)
  80159c:	50                   	push   %eax
  80159d:	e8 65 ff ff ff       	call   801507 <fstat>
  8015a2:	89 c6                	mov    %eax,%esi
	close(fd);
  8015a4:	89 1c 24             	mov    %ebx,(%esp)
  8015a7:	e8 27 fc ff ff       	call   8011d3 <close>
	return r;
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	89 f3                	mov    %esi,%ebx
}
  8015b1:	89 d8                	mov    %ebx,%eax
  8015b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b6:	5b                   	pop    %ebx
  8015b7:	5e                   	pop    %esi
  8015b8:	5d                   	pop    %ebp
  8015b9:	c3                   	ret    

008015ba <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	56                   	push   %esi
  8015be:	53                   	push   %ebx
  8015bf:	89 c6                	mov    %eax,%esi
  8015c1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015c3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015ca:	74 27                	je     8015f3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015cc:	6a 07                	push   $0x7
  8015ce:	68 00 50 80 00       	push   $0x805000
  8015d3:	56                   	push   %esi
  8015d4:	ff 35 00 40 80 00    	pushl  0x804000
  8015da:	e8 69 0c 00 00       	call   802248 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015df:	83 c4 0c             	add    $0xc,%esp
  8015e2:	6a 00                	push   $0x0
  8015e4:	53                   	push   %ebx
  8015e5:	6a 00                	push   $0x0
  8015e7:	e8 f3 0b 00 00       	call   8021df <ipc_recv>
}
  8015ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ef:	5b                   	pop    %ebx
  8015f0:	5e                   	pop    %esi
  8015f1:	5d                   	pop    %ebp
  8015f2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015f3:	83 ec 0c             	sub    $0xc,%esp
  8015f6:	6a 01                	push   $0x1
  8015f8:	e8 a3 0c 00 00       	call   8022a0 <ipc_find_env>
  8015fd:	a3 00 40 80 00       	mov    %eax,0x804000
  801602:	83 c4 10             	add    $0x10,%esp
  801605:	eb c5                	jmp    8015cc <fsipc+0x12>

00801607 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	8b 40 0c             	mov    0xc(%eax),%eax
  801613:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801618:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801620:	ba 00 00 00 00       	mov    $0x0,%edx
  801625:	b8 02 00 00 00       	mov    $0x2,%eax
  80162a:	e8 8b ff ff ff       	call   8015ba <fsipc>
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <devfile_flush>:
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	8b 40 0c             	mov    0xc(%eax),%eax
  80163d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801642:	ba 00 00 00 00       	mov    $0x0,%edx
  801647:	b8 06 00 00 00       	mov    $0x6,%eax
  80164c:	e8 69 ff ff ff       	call   8015ba <fsipc>
}
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <devfile_stat>:
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	53                   	push   %ebx
  801657:	83 ec 04             	sub    $0x4,%esp
  80165a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8b 40 0c             	mov    0xc(%eax),%eax
  801663:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801668:	ba 00 00 00 00       	mov    $0x0,%edx
  80166d:	b8 05 00 00 00       	mov    $0x5,%eax
  801672:	e8 43 ff ff ff       	call   8015ba <fsipc>
  801677:	85 c0                	test   %eax,%eax
  801679:	78 2c                	js     8016a7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	68 00 50 80 00       	push   $0x805000
  801683:	53                   	push   %ebx
  801684:	e8 d8 f2 ff ff       	call   800961 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801689:	a1 80 50 80 00       	mov    0x805080,%eax
  80168e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801694:	a1 84 50 80 00       	mov    0x805084,%eax
  801699:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <devfile_write>:
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	53                   	push   %ebx
  8016b0:	83 ec 08             	sub    $0x8,%esp
  8016b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8016bc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016c1:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016c7:	53                   	push   %ebx
  8016c8:	ff 75 0c             	pushl  0xc(%ebp)
  8016cb:	68 08 50 80 00       	push   $0x805008
  8016d0:	e8 7c f4 ff ff       	call   800b51 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016da:	b8 04 00 00 00       	mov    $0x4,%eax
  8016df:	e8 d6 fe ff ff       	call   8015ba <fsipc>
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	78 0b                	js     8016f6 <devfile_write+0x4a>
	assert(r <= n);
  8016eb:	39 d8                	cmp    %ebx,%eax
  8016ed:	77 0c                	ja     8016fb <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016ef:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016f4:	7f 1e                	jg     801714 <devfile_write+0x68>
}
  8016f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    
	assert(r <= n);
  8016fb:	68 44 2a 80 00       	push   $0x802a44
  801700:	68 4b 2a 80 00       	push   $0x802a4b
  801705:	68 98 00 00 00       	push   $0x98
  80170a:	68 60 2a 80 00       	push   $0x802a60
  80170f:	e8 6a 0a 00 00       	call   80217e <_panic>
	assert(r <= PGSIZE);
  801714:	68 6b 2a 80 00       	push   $0x802a6b
  801719:	68 4b 2a 80 00       	push   $0x802a4b
  80171e:	68 99 00 00 00       	push   $0x99
  801723:	68 60 2a 80 00       	push   $0x802a60
  801728:	e8 51 0a 00 00       	call   80217e <_panic>

0080172d <devfile_read>:
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	56                   	push   %esi
  801731:	53                   	push   %ebx
  801732:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	8b 40 0c             	mov    0xc(%eax),%eax
  80173b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801740:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801746:	ba 00 00 00 00       	mov    $0x0,%edx
  80174b:	b8 03 00 00 00       	mov    $0x3,%eax
  801750:	e8 65 fe ff ff       	call   8015ba <fsipc>
  801755:	89 c3                	mov    %eax,%ebx
  801757:	85 c0                	test   %eax,%eax
  801759:	78 1f                	js     80177a <devfile_read+0x4d>
	assert(r <= n);
  80175b:	39 f0                	cmp    %esi,%eax
  80175d:	77 24                	ja     801783 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80175f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801764:	7f 33                	jg     801799 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	50                   	push   %eax
  80176a:	68 00 50 80 00       	push   $0x805000
  80176f:	ff 75 0c             	pushl  0xc(%ebp)
  801772:	e8 78 f3 ff ff       	call   800aef <memmove>
	return r;
  801777:	83 c4 10             	add    $0x10,%esp
}
  80177a:	89 d8                	mov    %ebx,%eax
  80177c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177f:	5b                   	pop    %ebx
  801780:	5e                   	pop    %esi
  801781:	5d                   	pop    %ebp
  801782:	c3                   	ret    
	assert(r <= n);
  801783:	68 44 2a 80 00       	push   $0x802a44
  801788:	68 4b 2a 80 00       	push   $0x802a4b
  80178d:	6a 7c                	push   $0x7c
  80178f:	68 60 2a 80 00       	push   $0x802a60
  801794:	e8 e5 09 00 00       	call   80217e <_panic>
	assert(r <= PGSIZE);
  801799:	68 6b 2a 80 00       	push   $0x802a6b
  80179e:	68 4b 2a 80 00       	push   $0x802a4b
  8017a3:	6a 7d                	push   $0x7d
  8017a5:	68 60 2a 80 00       	push   $0x802a60
  8017aa:	e8 cf 09 00 00       	call   80217e <_panic>

008017af <open>:
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	56                   	push   %esi
  8017b3:	53                   	push   %ebx
  8017b4:	83 ec 1c             	sub    $0x1c,%esp
  8017b7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017ba:	56                   	push   %esi
  8017bb:	e8 68 f1 ff ff       	call   800928 <strlen>
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017c8:	7f 6c                	jg     801836 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017ca:	83 ec 0c             	sub    $0xc,%esp
  8017cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d0:	50                   	push   %eax
  8017d1:	e8 79 f8 ff ff       	call   80104f <fd_alloc>
  8017d6:	89 c3                	mov    %eax,%ebx
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	78 3c                	js     80181b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017df:	83 ec 08             	sub    $0x8,%esp
  8017e2:	56                   	push   %esi
  8017e3:	68 00 50 80 00       	push   $0x805000
  8017e8:	e8 74 f1 ff ff       	call   800961 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f8:	b8 01 00 00 00       	mov    $0x1,%eax
  8017fd:	e8 b8 fd ff ff       	call   8015ba <fsipc>
  801802:	89 c3                	mov    %eax,%ebx
  801804:	83 c4 10             	add    $0x10,%esp
  801807:	85 c0                	test   %eax,%eax
  801809:	78 19                	js     801824 <open+0x75>
	return fd2num(fd);
  80180b:	83 ec 0c             	sub    $0xc,%esp
  80180e:	ff 75 f4             	pushl  -0xc(%ebp)
  801811:	e8 12 f8 ff ff       	call   801028 <fd2num>
  801816:	89 c3                	mov    %eax,%ebx
  801818:	83 c4 10             	add    $0x10,%esp
}
  80181b:	89 d8                	mov    %ebx,%eax
  80181d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801820:	5b                   	pop    %ebx
  801821:	5e                   	pop    %esi
  801822:	5d                   	pop    %ebp
  801823:	c3                   	ret    
		fd_close(fd, 0);
  801824:	83 ec 08             	sub    $0x8,%esp
  801827:	6a 00                	push   $0x0
  801829:	ff 75 f4             	pushl  -0xc(%ebp)
  80182c:	e8 1b f9 ff ff       	call   80114c <fd_close>
		return r;
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	eb e5                	jmp    80181b <open+0x6c>
		return -E_BAD_PATH;
  801836:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80183b:	eb de                	jmp    80181b <open+0x6c>

0080183d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801843:	ba 00 00 00 00       	mov    $0x0,%edx
  801848:	b8 08 00 00 00       	mov    $0x8,%eax
  80184d:	e8 68 fd ff ff       	call   8015ba <fsipc>
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80185a:	68 77 2a 80 00       	push   $0x802a77
  80185f:	ff 75 0c             	pushl  0xc(%ebp)
  801862:	e8 fa f0 ff ff       	call   800961 <strcpy>
	return 0;
}
  801867:	b8 00 00 00 00       	mov    $0x0,%eax
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <devsock_close>:
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	53                   	push   %ebx
  801872:	83 ec 10             	sub    $0x10,%esp
  801875:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801878:	53                   	push   %ebx
  801879:	e8 5d 0a 00 00       	call   8022db <pageref>
  80187e:	83 c4 10             	add    $0x10,%esp
		return 0;
  801881:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801886:	83 f8 01             	cmp    $0x1,%eax
  801889:	74 07                	je     801892 <devsock_close+0x24>
}
  80188b:	89 d0                	mov    %edx,%eax
  80188d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801890:	c9                   	leave  
  801891:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801892:	83 ec 0c             	sub    $0xc,%esp
  801895:	ff 73 0c             	pushl  0xc(%ebx)
  801898:	e8 b9 02 00 00       	call   801b56 <nsipc_close>
  80189d:	89 c2                	mov    %eax,%edx
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	eb e7                	jmp    80188b <devsock_close+0x1d>

008018a4 <devsock_write>:
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018aa:	6a 00                	push   $0x0
  8018ac:	ff 75 10             	pushl  0x10(%ebp)
  8018af:	ff 75 0c             	pushl  0xc(%ebp)
  8018b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b5:	ff 70 0c             	pushl  0xc(%eax)
  8018b8:	e8 76 03 00 00       	call   801c33 <nsipc_send>
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <devsock_read>:
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018c5:	6a 00                	push   $0x0
  8018c7:	ff 75 10             	pushl  0x10(%ebp)
  8018ca:	ff 75 0c             	pushl  0xc(%ebp)
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	ff 70 0c             	pushl  0xc(%eax)
  8018d3:	e8 ef 02 00 00       	call   801bc7 <nsipc_recv>
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <fd2sockid>:
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018e0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018e3:	52                   	push   %edx
  8018e4:	50                   	push   %eax
  8018e5:	e8 b7 f7 ff ff       	call   8010a1 <fd_lookup>
  8018ea:	83 c4 10             	add    $0x10,%esp
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	78 10                	js     801901 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f4:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018fa:	39 08                	cmp    %ecx,(%eax)
  8018fc:	75 05                	jne    801903 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018fe:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    
		return -E_NOT_SUPP;
  801903:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801908:	eb f7                	jmp    801901 <fd2sockid+0x27>

0080190a <alloc_sockfd>:
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	56                   	push   %esi
  80190e:	53                   	push   %ebx
  80190f:	83 ec 1c             	sub    $0x1c,%esp
  801912:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801914:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801917:	50                   	push   %eax
  801918:	e8 32 f7 ff ff       	call   80104f <fd_alloc>
  80191d:	89 c3                	mov    %eax,%ebx
  80191f:	83 c4 10             	add    $0x10,%esp
  801922:	85 c0                	test   %eax,%eax
  801924:	78 43                	js     801969 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	68 07 04 00 00       	push   $0x407
  80192e:	ff 75 f4             	pushl  -0xc(%ebp)
  801931:	6a 00                	push   $0x0
  801933:	e8 1b f4 ff ff       	call   800d53 <sys_page_alloc>
  801938:	89 c3                	mov    %eax,%ebx
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	85 c0                	test   %eax,%eax
  80193f:	78 28                	js     801969 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801944:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80194a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80194c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801956:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801959:	83 ec 0c             	sub    $0xc,%esp
  80195c:	50                   	push   %eax
  80195d:	e8 c6 f6 ff ff       	call   801028 <fd2num>
  801962:	89 c3                	mov    %eax,%ebx
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	eb 0c                	jmp    801975 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801969:	83 ec 0c             	sub    $0xc,%esp
  80196c:	56                   	push   %esi
  80196d:	e8 e4 01 00 00       	call   801b56 <nsipc_close>
		return r;
  801972:	83 c4 10             	add    $0x10,%esp
}
  801975:	89 d8                	mov    %ebx,%eax
  801977:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197a:	5b                   	pop    %ebx
  80197b:	5e                   	pop    %esi
  80197c:	5d                   	pop    %ebp
  80197d:	c3                   	ret    

0080197e <accept>:
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	e8 4e ff ff ff       	call   8018da <fd2sockid>
  80198c:	85 c0                	test   %eax,%eax
  80198e:	78 1b                	js     8019ab <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801990:	83 ec 04             	sub    $0x4,%esp
  801993:	ff 75 10             	pushl  0x10(%ebp)
  801996:	ff 75 0c             	pushl  0xc(%ebp)
  801999:	50                   	push   %eax
  80199a:	e8 0e 01 00 00       	call   801aad <nsipc_accept>
  80199f:	83 c4 10             	add    $0x10,%esp
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	78 05                	js     8019ab <accept+0x2d>
	return alloc_sockfd(r);
  8019a6:	e8 5f ff ff ff       	call   80190a <alloc_sockfd>
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <bind>:
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
  8019b0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	e8 1f ff ff ff       	call   8018da <fd2sockid>
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	78 12                	js     8019d1 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019bf:	83 ec 04             	sub    $0x4,%esp
  8019c2:	ff 75 10             	pushl  0x10(%ebp)
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	50                   	push   %eax
  8019c9:	e8 31 01 00 00       	call   801aff <nsipc_bind>
  8019ce:	83 c4 10             	add    $0x10,%esp
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <shutdown>:
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	e8 f9 fe ff ff       	call   8018da <fd2sockid>
  8019e1:	85 c0                	test   %eax,%eax
  8019e3:	78 0f                	js     8019f4 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019e5:	83 ec 08             	sub    $0x8,%esp
  8019e8:	ff 75 0c             	pushl  0xc(%ebp)
  8019eb:	50                   	push   %eax
  8019ec:	e8 43 01 00 00       	call   801b34 <nsipc_shutdown>
  8019f1:	83 c4 10             	add    $0x10,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <connect>:
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	e8 d6 fe ff ff       	call   8018da <fd2sockid>
  801a04:	85 c0                	test   %eax,%eax
  801a06:	78 12                	js     801a1a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a08:	83 ec 04             	sub    $0x4,%esp
  801a0b:	ff 75 10             	pushl  0x10(%ebp)
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	50                   	push   %eax
  801a12:	e8 59 01 00 00       	call   801b70 <nsipc_connect>
  801a17:	83 c4 10             	add    $0x10,%esp
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <listen>:
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	e8 b0 fe ff ff       	call   8018da <fd2sockid>
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 0f                	js     801a3d <listen+0x21>
	return nsipc_listen(r, backlog);
  801a2e:	83 ec 08             	sub    $0x8,%esp
  801a31:	ff 75 0c             	pushl  0xc(%ebp)
  801a34:	50                   	push   %eax
  801a35:	e8 6b 01 00 00       	call   801ba5 <nsipc_listen>
  801a3a:	83 c4 10             	add    $0x10,%esp
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <socket>:

int
socket(int domain, int type, int protocol)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a45:	ff 75 10             	pushl  0x10(%ebp)
  801a48:	ff 75 0c             	pushl  0xc(%ebp)
  801a4b:	ff 75 08             	pushl  0x8(%ebp)
  801a4e:	e8 3e 02 00 00       	call   801c91 <nsipc_socket>
  801a53:	83 c4 10             	add    $0x10,%esp
  801a56:	85 c0                	test   %eax,%eax
  801a58:	78 05                	js     801a5f <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a5a:	e8 ab fe ff ff       	call   80190a <alloc_sockfd>
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	53                   	push   %ebx
  801a65:	83 ec 04             	sub    $0x4,%esp
  801a68:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a6a:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a71:	74 26                	je     801a99 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a73:	6a 07                	push   $0x7
  801a75:	68 00 60 80 00       	push   $0x806000
  801a7a:	53                   	push   %ebx
  801a7b:	ff 35 04 40 80 00    	pushl  0x804004
  801a81:	e8 c2 07 00 00       	call   802248 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a86:	83 c4 0c             	add    $0xc,%esp
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	e8 4b 07 00 00       	call   8021df <ipc_recv>
}
  801a94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a99:	83 ec 0c             	sub    $0xc,%esp
  801a9c:	6a 02                	push   $0x2
  801a9e:	e8 fd 07 00 00       	call   8022a0 <ipc_find_env>
  801aa3:	a3 04 40 80 00       	mov    %eax,0x804004
  801aa8:	83 c4 10             	add    $0x10,%esp
  801aab:	eb c6                	jmp    801a73 <nsipc+0x12>

00801aad <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	56                   	push   %esi
  801ab1:	53                   	push   %ebx
  801ab2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801abd:	8b 06                	mov    (%esi),%eax
  801abf:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ac4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac9:	e8 93 ff ff ff       	call   801a61 <nsipc>
  801ace:	89 c3                	mov    %eax,%ebx
  801ad0:	85 c0                	test   %eax,%eax
  801ad2:	79 09                	jns    801add <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ad4:	89 d8                	mov    %ebx,%eax
  801ad6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad9:	5b                   	pop    %ebx
  801ada:	5e                   	pop    %esi
  801adb:	5d                   	pop    %ebp
  801adc:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801add:	83 ec 04             	sub    $0x4,%esp
  801ae0:	ff 35 10 60 80 00    	pushl  0x806010
  801ae6:	68 00 60 80 00       	push   $0x806000
  801aeb:	ff 75 0c             	pushl  0xc(%ebp)
  801aee:	e8 fc ef ff ff       	call   800aef <memmove>
		*addrlen = ret->ret_addrlen;
  801af3:	a1 10 60 80 00       	mov    0x806010,%eax
  801af8:	89 06                	mov    %eax,(%esi)
  801afa:	83 c4 10             	add    $0x10,%esp
	return r;
  801afd:	eb d5                	jmp    801ad4 <nsipc_accept+0x27>

00801aff <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	53                   	push   %ebx
  801b03:	83 ec 08             	sub    $0x8,%esp
  801b06:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b11:	53                   	push   %ebx
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	68 04 60 80 00       	push   $0x806004
  801b1a:	e8 d0 ef ff ff       	call   800aef <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b1f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b25:	b8 02 00 00 00       	mov    $0x2,%eax
  801b2a:	e8 32 ff ff ff       	call   801a61 <nsipc>
}
  801b2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
  801b37:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b45:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b4a:	b8 03 00 00 00       	mov    $0x3,%eax
  801b4f:	e8 0d ff ff ff       	call   801a61 <nsipc>
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <nsipc_close>:

int
nsipc_close(int s)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b64:	b8 04 00 00 00       	mov    $0x4,%eax
  801b69:	e8 f3 fe ff ff       	call   801a61 <nsipc>
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	53                   	push   %ebx
  801b74:	83 ec 08             	sub    $0x8,%esp
  801b77:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b82:	53                   	push   %ebx
  801b83:	ff 75 0c             	pushl  0xc(%ebp)
  801b86:	68 04 60 80 00       	push   $0x806004
  801b8b:	e8 5f ef ff ff       	call   800aef <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b90:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b96:	b8 05 00 00 00       	mov    $0x5,%eax
  801b9b:	e8 c1 fe ff ff       	call   801a61 <nsipc>
}
  801ba0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bbb:	b8 06 00 00 00       	mov    $0x6,%eax
  801bc0:	e8 9c fe ff ff       	call   801a61 <nsipc>
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	56                   	push   %esi
  801bcb:	53                   	push   %ebx
  801bcc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bd7:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bdd:	8b 45 14             	mov    0x14(%ebp),%eax
  801be0:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801be5:	b8 07 00 00 00       	mov    $0x7,%eax
  801bea:	e8 72 fe ff ff       	call   801a61 <nsipc>
  801bef:	89 c3                	mov    %eax,%ebx
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	78 1f                	js     801c14 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bf5:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bfa:	7f 21                	jg     801c1d <nsipc_recv+0x56>
  801bfc:	39 c6                	cmp    %eax,%esi
  801bfe:	7c 1d                	jl     801c1d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	50                   	push   %eax
  801c04:	68 00 60 80 00       	push   $0x806000
  801c09:	ff 75 0c             	pushl  0xc(%ebp)
  801c0c:	e8 de ee ff ff       	call   800aef <memmove>
  801c11:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c14:	89 d8                	mov    %ebx,%eax
  801c16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c19:	5b                   	pop    %ebx
  801c1a:	5e                   	pop    %esi
  801c1b:	5d                   	pop    %ebp
  801c1c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c1d:	68 83 2a 80 00       	push   $0x802a83
  801c22:	68 4b 2a 80 00       	push   $0x802a4b
  801c27:	6a 62                	push   $0x62
  801c29:	68 98 2a 80 00       	push   $0x802a98
  801c2e:	e8 4b 05 00 00       	call   80217e <_panic>

00801c33 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	53                   	push   %ebx
  801c37:	83 ec 04             	sub    $0x4,%esp
  801c3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c45:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c4b:	7f 2e                	jg     801c7b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c4d:	83 ec 04             	sub    $0x4,%esp
  801c50:	53                   	push   %ebx
  801c51:	ff 75 0c             	pushl  0xc(%ebp)
  801c54:	68 0c 60 80 00       	push   $0x80600c
  801c59:	e8 91 ee ff ff       	call   800aef <memmove>
	nsipcbuf.send.req_size = size;
  801c5e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c64:	8b 45 14             	mov    0x14(%ebp),%eax
  801c67:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c6c:	b8 08 00 00 00       	mov    $0x8,%eax
  801c71:	e8 eb fd ff ff       	call   801a61 <nsipc>
}
  801c76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    
	assert(size < 1600);
  801c7b:	68 a4 2a 80 00       	push   $0x802aa4
  801c80:	68 4b 2a 80 00       	push   $0x802a4b
  801c85:	6a 6d                	push   $0x6d
  801c87:	68 98 2a 80 00       	push   $0x802a98
  801c8c:	e8 ed 04 00 00       	call   80217e <_panic>

00801c91 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca2:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ca7:	8b 45 10             	mov    0x10(%ebp),%eax
  801caa:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801caf:	b8 09 00 00 00       	mov    $0x9,%eax
  801cb4:	e8 a8 fd ff ff       	call   801a61 <nsipc>
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	56                   	push   %esi
  801cbf:	53                   	push   %ebx
  801cc0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cc3:	83 ec 0c             	sub    $0xc,%esp
  801cc6:	ff 75 08             	pushl  0x8(%ebp)
  801cc9:	e8 6a f3 ff ff       	call   801038 <fd2data>
  801cce:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cd0:	83 c4 08             	add    $0x8,%esp
  801cd3:	68 b0 2a 80 00       	push   $0x802ab0
  801cd8:	53                   	push   %ebx
  801cd9:	e8 83 ec ff ff       	call   800961 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cde:	8b 46 04             	mov    0x4(%esi),%eax
  801ce1:	2b 06                	sub    (%esi),%eax
  801ce3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ce9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cf0:	00 00 00 
	stat->st_dev = &devpipe;
  801cf3:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cfa:	30 80 00 
	return 0;
}
  801cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801d02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d05:	5b                   	pop    %ebx
  801d06:	5e                   	pop    %esi
  801d07:	5d                   	pop    %ebp
  801d08:	c3                   	ret    

00801d09 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	53                   	push   %ebx
  801d0d:	83 ec 0c             	sub    $0xc,%esp
  801d10:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d13:	53                   	push   %ebx
  801d14:	6a 00                	push   $0x0
  801d16:	e8 bd f0 ff ff       	call   800dd8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d1b:	89 1c 24             	mov    %ebx,(%esp)
  801d1e:	e8 15 f3 ff ff       	call   801038 <fd2data>
  801d23:	83 c4 08             	add    $0x8,%esp
  801d26:	50                   	push   %eax
  801d27:	6a 00                	push   $0x0
  801d29:	e8 aa f0 ff ff       	call   800dd8 <sys_page_unmap>
}
  801d2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <_pipeisclosed>:
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	57                   	push   %edi
  801d37:	56                   	push   %esi
  801d38:	53                   	push   %ebx
  801d39:	83 ec 1c             	sub    $0x1c,%esp
  801d3c:	89 c7                	mov    %eax,%edi
  801d3e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d40:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801d45:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d48:	83 ec 0c             	sub    $0xc,%esp
  801d4b:	57                   	push   %edi
  801d4c:	e8 8a 05 00 00       	call   8022db <pageref>
  801d51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d54:	89 34 24             	mov    %esi,(%esp)
  801d57:	e8 7f 05 00 00       	call   8022db <pageref>
		nn = thisenv->env_runs;
  801d5c:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801d62:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d65:	83 c4 10             	add    $0x10,%esp
  801d68:	39 cb                	cmp    %ecx,%ebx
  801d6a:	74 1b                	je     801d87 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d6c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d6f:	75 cf                	jne    801d40 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d71:	8b 42 58             	mov    0x58(%edx),%eax
  801d74:	6a 01                	push   $0x1
  801d76:	50                   	push   %eax
  801d77:	53                   	push   %ebx
  801d78:	68 b7 2a 80 00       	push   $0x802ab7
  801d7d:	e8 80 e4 ff ff       	call   800202 <cprintf>
  801d82:	83 c4 10             	add    $0x10,%esp
  801d85:	eb b9                	jmp    801d40 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d87:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d8a:	0f 94 c0             	sete   %al
  801d8d:	0f b6 c0             	movzbl %al,%eax
}
  801d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d93:	5b                   	pop    %ebx
  801d94:	5e                   	pop    %esi
  801d95:	5f                   	pop    %edi
  801d96:	5d                   	pop    %ebp
  801d97:	c3                   	ret    

00801d98 <devpipe_write>:
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	57                   	push   %edi
  801d9c:	56                   	push   %esi
  801d9d:	53                   	push   %ebx
  801d9e:	83 ec 28             	sub    $0x28,%esp
  801da1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801da4:	56                   	push   %esi
  801da5:	e8 8e f2 ff ff       	call   801038 <fd2data>
  801daa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dac:	83 c4 10             	add    $0x10,%esp
  801daf:	bf 00 00 00 00       	mov    $0x0,%edi
  801db4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801db7:	74 4f                	je     801e08 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801db9:	8b 43 04             	mov    0x4(%ebx),%eax
  801dbc:	8b 0b                	mov    (%ebx),%ecx
  801dbe:	8d 51 20             	lea    0x20(%ecx),%edx
  801dc1:	39 d0                	cmp    %edx,%eax
  801dc3:	72 14                	jb     801dd9 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dc5:	89 da                	mov    %ebx,%edx
  801dc7:	89 f0                	mov    %esi,%eax
  801dc9:	e8 65 ff ff ff       	call   801d33 <_pipeisclosed>
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	75 3b                	jne    801e0d <devpipe_write+0x75>
			sys_yield();
  801dd2:	e8 5d ef ff ff       	call   800d34 <sys_yield>
  801dd7:	eb e0                	jmp    801db9 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ddc:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801de0:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801de3:	89 c2                	mov    %eax,%edx
  801de5:	c1 fa 1f             	sar    $0x1f,%edx
  801de8:	89 d1                	mov    %edx,%ecx
  801dea:	c1 e9 1b             	shr    $0x1b,%ecx
  801ded:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801df0:	83 e2 1f             	and    $0x1f,%edx
  801df3:	29 ca                	sub    %ecx,%edx
  801df5:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801df9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dfd:	83 c0 01             	add    $0x1,%eax
  801e00:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e03:	83 c7 01             	add    $0x1,%edi
  801e06:	eb ac                	jmp    801db4 <devpipe_write+0x1c>
	return i;
  801e08:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0b:	eb 05                	jmp    801e12 <devpipe_write+0x7a>
				return 0;
  801e0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e15:	5b                   	pop    %ebx
  801e16:	5e                   	pop    %esi
  801e17:	5f                   	pop    %edi
  801e18:	5d                   	pop    %ebp
  801e19:	c3                   	ret    

00801e1a <devpipe_read>:
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	57                   	push   %edi
  801e1e:	56                   	push   %esi
  801e1f:	53                   	push   %ebx
  801e20:	83 ec 18             	sub    $0x18,%esp
  801e23:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e26:	57                   	push   %edi
  801e27:	e8 0c f2 ff ff       	call   801038 <fd2data>
  801e2c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e2e:	83 c4 10             	add    $0x10,%esp
  801e31:	be 00 00 00 00       	mov    $0x0,%esi
  801e36:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e39:	75 14                	jne    801e4f <devpipe_read+0x35>
	return i;
  801e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3e:	eb 02                	jmp    801e42 <devpipe_read+0x28>
				return i;
  801e40:	89 f0                	mov    %esi,%eax
}
  801e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e45:	5b                   	pop    %ebx
  801e46:	5e                   	pop    %esi
  801e47:	5f                   	pop    %edi
  801e48:	5d                   	pop    %ebp
  801e49:	c3                   	ret    
			sys_yield();
  801e4a:	e8 e5 ee ff ff       	call   800d34 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e4f:	8b 03                	mov    (%ebx),%eax
  801e51:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e54:	75 18                	jne    801e6e <devpipe_read+0x54>
			if (i > 0)
  801e56:	85 f6                	test   %esi,%esi
  801e58:	75 e6                	jne    801e40 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e5a:	89 da                	mov    %ebx,%edx
  801e5c:	89 f8                	mov    %edi,%eax
  801e5e:	e8 d0 fe ff ff       	call   801d33 <_pipeisclosed>
  801e63:	85 c0                	test   %eax,%eax
  801e65:	74 e3                	je     801e4a <devpipe_read+0x30>
				return 0;
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6c:	eb d4                	jmp    801e42 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e6e:	99                   	cltd   
  801e6f:	c1 ea 1b             	shr    $0x1b,%edx
  801e72:	01 d0                	add    %edx,%eax
  801e74:	83 e0 1f             	and    $0x1f,%eax
  801e77:	29 d0                	sub    %edx,%eax
  801e79:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e81:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e84:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e87:	83 c6 01             	add    $0x1,%esi
  801e8a:	eb aa                	jmp    801e36 <devpipe_read+0x1c>

00801e8c <pipe>:
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	56                   	push   %esi
  801e90:	53                   	push   %ebx
  801e91:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e94:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e97:	50                   	push   %eax
  801e98:	e8 b2 f1 ff ff       	call   80104f <fd_alloc>
  801e9d:	89 c3                	mov    %eax,%ebx
  801e9f:	83 c4 10             	add    $0x10,%esp
  801ea2:	85 c0                	test   %eax,%eax
  801ea4:	0f 88 23 01 00 00    	js     801fcd <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eaa:	83 ec 04             	sub    $0x4,%esp
  801ead:	68 07 04 00 00       	push   $0x407
  801eb2:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb5:	6a 00                	push   $0x0
  801eb7:	e8 97 ee ff ff       	call   800d53 <sys_page_alloc>
  801ebc:	89 c3                	mov    %eax,%ebx
  801ebe:	83 c4 10             	add    $0x10,%esp
  801ec1:	85 c0                	test   %eax,%eax
  801ec3:	0f 88 04 01 00 00    	js     801fcd <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ec9:	83 ec 0c             	sub    $0xc,%esp
  801ecc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ecf:	50                   	push   %eax
  801ed0:	e8 7a f1 ff ff       	call   80104f <fd_alloc>
  801ed5:	89 c3                	mov    %eax,%ebx
  801ed7:	83 c4 10             	add    $0x10,%esp
  801eda:	85 c0                	test   %eax,%eax
  801edc:	0f 88 db 00 00 00    	js     801fbd <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee2:	83 ec 04             	sub    $0x4,%esp
  801ee5:	68 07 04 00 00       	push   $0x407
  801eea:	ff 75 f0             	pushl  -0x10(%ebp)
  801eed:	6a 00                	push   $0x0
  801eef:	e8 5f ee ff ff       	call   800d53 <sys_page_alloc>
  801ef4:	89 c3                	mov    %eax,%ebx
  801ef6:	83 c4 10             	add    $0x10,%esp
  801ef9:	85 c0                	test   %eax,%eax
  801efb:	0f 88 bc 00 00 00    	js     801fbd <pipe+0x131>
	va = fd2data(fd0);
  801f01:	83 ec 0c             	sub    $0xc,%esp
  801f04:	ff 75 f4             	pushl  -0xc(%ebp)
  801f07:	e8 2c f1 ff ff       	call   801038 <fd2data>
  801f0c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f0e:	83 c4 0c             	add    $0xc,%esp
  801f11:	68 07 04 00 00       	push   $0x407
  801f16:	50                   	push   %eax
  801f17:	6a 00                	push   $0x0
  801f19:	e8 35 ee ff ff       	call   800d53 <sys_page_alloc>
  801f1e:	89 c3                	mov    %eax,%ebx
  801f20:	83 c4 10             	add    $0x10,%esp
  801f23:	85 c0                	test   %eax,%eax
  801f25:	0f 88 82 00 00 00    	js     801fad <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	ff 75 f0             	pushl  -0x10(%ebp)
  801f31:	e8 02 f1 ff ff       	call   801038 <fd2data>
  801f36:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f3d:	50                   	push   %eax
  801f3e:	6a 00                	push   $0x0
  801f40:	56                   	push   %esi
  801f41:	6a 00                	push   $0x0
  801f43:	e8 4e ee ff ff       	call   800d96 <sys_page_map>
  801f48:	89 c3                	mov    %eax,%ebx
  801f4a:	83 c4 20             	add    $0x20,%esp
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	78 4e                	js     801f9f <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f51:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f59:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f68:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f74:	83 ec 0c             	sub    $0xc,%esp
  801f77:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7a:	e8 a9 f0 ff ff       	call   801028 <fd2num>
  801f7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f82:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f84:	83 c4 04             	add    $0x4,%esp
  801f87:	ff 75 f0             	pushl  -0x10(%ebp)
  801f8a:	e8 99 f0 ff ff       	call   801028 <fd2num>
  801f8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f92:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f95:	83 c4 10             	add    $0x10,%esp
  801f98:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f9d:	eb 2e                	jmp    801fcd <pipe+0x141>
	sys_page_unmap(0, va);
  801f9f:	83 ec 08             	sub    $0x8,%esp
  801fa2:	56                   	push   %esi
  801fa3:	6a 00                	push   $0x0
  801fa5:	e8 2e ee ff ff       	call   800dd8 <sys_page_unmap>
  801faa:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fad:	83 ec 08             	sub    $0x8,%esp
  801fb0:	ff 75 f0             	pushl  -0x10(%ebp)
  801fb3:	6a 00                	push   $0x0
  801fb5:	e8 1e ee ff ff       	call   800dd8 <sys_page_unmap>
  801fba:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fbd:	83 ec 08             	sub    $0x8,%esp
  801fc0:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc3:	6a 00                	push   $0x0
  801fc5:	e8 0e ee ff ff       	call   800dd8 <sys_page_unmap>
  801fca:	83 c4 10             	add    $0x10,%esp
}
  801fcd:	89 d8                	mov    %ebx,%eax
  801fcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fd2:	5b                   	pop    %ebx
  801fd3:	5e                   	pop    %esi
  801fd4:	5d                   	pop    %ebp
  801fd5:	c3                   	ret    

00801fd6 <pipeisclosed>:
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fdf:	50                   	push   %eax
  801fe0:	ff 75 08             	pushl  0x8(%ebp)
  801fe3:	e8 b9 f0 ff ff       	call   8010a1 <fd_lookup>
  801fe8:	83 c4 10             	add    $0x10,%esp
  801feb:	85 c0                	test   %eax,%eax
  801fed:	78 18                	js     802007 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fef:	83 ec 0c             	sub    $0xc,%esp
  801ff2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff5:	e8 3e f0 ff ff       	call   801038 <fd2data>
	return _pipeisclosed(fd, p);
  801ffa:	89 c2                	mov    %eax,%edx
  801ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fff:	e8 2f fd ff ff       	call   801d33 <_pipeisclosed>
  802004:	83 c4 10             	add    $0x10,%esp
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802009:	b8 00 00 00 00       	mov    $0x0,%eax
  80200e:	c3                   	ret    

0080200f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802015:	68 cf 2a 80 00       	push   $0x802acf
  80201a:	ff 75 0c             	pushl  0xc(%ebp)
  80201d:	e8 3f e9 ff ff       	call   800961 <strcpy>
	return 0;
}
  802022:	b8 00 00 00 00       	mov    $0x0,%eax
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <devcons_write>:
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
  80202c:	57                   	push   %edi
  80202d:	56                   	push   %esi
  80202e:	53                   	push   %ebx
  80202f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802035:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80203a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802040:	3b 75 10             	cmp    0x10(%ebp),%esi
  802043:	73 31                	jae    802076 <devcons_write+0x4d>
		m = n - tot;
  802045:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802048:	29 f3                	sub    %esi,%ebx
  80204a:	83 fb 7f             	cmp    $0x7f,%ebx
  80204d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802052:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802055:	83 ec 04             	sub    $0x4,%esp
  802058:	53                   	push   %ebx
  802059:	89 f0                	mov    %esi,%eax
  80205b:	03 45 0c             	add    0xc(%ebp),%eax
  80205e:	50                   	push   %eax
  80205f:	57                   	push   %edi
  802060:	e8 8a ea ff ff       	call   800aef <memmove>
		sys_cputs(buf, m);
  802065:	83 c4 08             	add    $0x8,%esp
  802068:	53                   	push   %ebx
  802069:	57                   	push   %edi
  80206a:	e8 28 ec ff ff       	call   800c97 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80206f:	01 de                	add    %ebx,%esi
  802071:	83 c4 10             	add    $0x10,%esp
  802074:	eb ca                	jmp    802040 <devcons_write+0x17>
}
  802076:	89 f0                	mov    %esi,%eax
  802078:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80207b:	5b                   	pop    %ebx
  80207c:	5e                   	pop    %esi
  80207d:	5f                   	pop    %edi
  80207e:	5d                   	pop    %ebp
  80207f:	c3                   	ret    

00802080 <devcons_read>:
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 08             	sub    $0x8,%esp
  802086:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80208b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80208f:	74 21                	je     8020b2 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802091:	e8 1f ec ff ff       	call   800cb5 <sys_cgetc>
  802096:	85 c0                	test   %eax,%eax
  802098:	75 07                	jne    8020a1 <devcons_read+0x21>
		sys_yield();
  80209a:	e8 95 ec ff ff       	call   800d34 <sys_yield>
  80209f:	eb f0                	jmp    802091 <devcons_read+0x11>
	if (c < 0)
  8020a1:	78 0f                	js     8020b2 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020a3:	83 f8 04             	cmp    $0x4,%eax
  8020a6:	74 0c                	je     8020b4 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ab:	88 02                	mov    %al,(%edx)
	return 1;
  8020ad:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    
		return 0;
  8020b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b9:	eb f7                	jmp    8020b2 <devcons_read+0x32>

008020bb <cputchar>:
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020c7:	6a 01                	push   $0x1
  8020c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020cc:	50                   	push   %eax
  8020cd:	e8 c5 eb ff ff       	call   800c97 <sys_cputs>
}
  8020d2:	83 c4 10             	add    $0x10,%esp
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <getchar>:
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020dd:	6a 01                	push   $0x1
  8020df:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020e2:	50                   	push   %eax
  8020e3:	6a 00                	push   $0x0
  8020e5:	e8 27 f2 ff ff       	call   801311 <read>
	if (r < 0)
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	78 06                	js     8020f7 <getchar+0x20>
	if (r < 1)
  8020f1:	74 06                	je     8020f9 <getchar+0x22>
	return c;
  8020f3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    
		return -E_EOF;
  8020f9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020fe:	eb f7                	jmp    8020f7 <getchar+0x20>

00802100 <iscons>:
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802106:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802109:	50                   	push   %eax
  80210a:	ff 75 08             	pushl  0x8(%ebp)
  80210d:	e8 8f ef ff ff       	call   8010a1 <fd_lookup>
  802112:	83 c4 10             	add    $0x10,%esp
  802115:	85 c0                	test   %eax,%eax
  802117:	78 11                	js     80212a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802122:	39 10                	cmp    %edx,(%eax)
  802124:	0f 94 c0             	sete   %al
  802127:	0f b6 c0             	movzbl %al,%eax
}
  80212a:	c9                   	leave  
  80212b:	c3                   	ret    

0080212c <opencons>:
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802132:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802135:	50                   	push   %eax
  802136:	e8 14 ef ff ff       	call   80104f <fd_alloc>
  80213b:	83 c4 10             	add    $0x10,%esp
  80213e:	85 c0                	test   %eax,%eax
  802140:	78 3a                	js     80217c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802142:	83 ec 04             	sub    $0x4,%esp
  802145:	68 07 04 00 00       	push   $0x407
  80214a:	ff 75 f4             	pushl  -0xc(%ebp)
  80214d:	6a 00                	push   $0x0
  80214f:	e8 ff eb ff ff       	call   800d53 <sys_page_alloc>
  802154:	83 c4 10             	add    $0x10,%esp
  802157:	85 c0                	test   %eax,%eax
  802159:	78 21                	js     80217c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80215b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802164:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802169:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802170:	83 ec 0c             	sub    $0xc,%esp
  802173:	50                   	push   %eax
  802174:	e8 af ee ff ff       	call   801028 <fd2num>
  802179:	83 c4 10             	add    $0x10,%esp
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	56                   	push   %esi
  802182:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802183:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802188:	8b 40 48             	mov    0x48(%eax),%eax
  80218b:	83 ec 04             	sub    $0x4,%esp
  80218e:	68 00 2b 80 00       	push   $0x802b00
  802193:	50                   	push   %eax
  802194:	68 e6 25 80 00       	push   $0x8025e6
  802199:	e8 64 e0 ff ff       	call   800202 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80219e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021a1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021a7:	e8 69 eb ff ff       	call   800d15 <sys_getenvid>
  8021ac:	83 c4 04             	add    $0x4,%esp
  8021af:	ff 75 0c             	pushl  0xc(%ebp)
  8021b2:	ff 75 08             	pushl  0x8(%ebp)
  8021b5:	56                   	push   %esi
  8021b6:	50                   	push   %eax
  8021b7:	68 dc 2a 80 00       	push   $0x802adc
  8021bc:	e8 41 e0 ff ff       	call   800202 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021c1:	83 c4 18             	add    $0x18,%esp
  8021c4:	53                   	push   %ebx
  8021c5:	ff 75 10             	pushl  0x10(%ebp)
  8021c8:	e8 e4 df ff ff       	call   8001b1 <vcprintf>
	cprintf("\n");
  8021cd:	c7 04 24 aa 25 80 00 	movl   $0x8025aa,(%esp)
  8021d4:	e8 29 e0 ff ff       	call   800202 <cprintf>
  8021d9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021dc:	cc                   	int3   
  8021dd:	eb fd                	jmp    8021dc <_panic+0x5e>

008021df <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	56                   	push   %esi
  8021e3:	53                   	push   %ebx
  8021e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8021e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021ed:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021ef:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021f4:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021f7:	83 ec 0c             	sub    $0xc,%esp
  8021fa:	50                   	push   %eax
  8021fb:	e8 03 ed ff ff       	call   800f03 <sys_ipc_recv>
	if(ret < 0){
  802200:	83 c4 10             	add    $0x10,%esp
  802203:	85 c0                	test   %eax,%eax
  802205:	78 2b                	js     802232 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802207:	85 f6                	test   %esi,%esi
  802209:	74 0a                	je     802215 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80220b:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802210:	8b 40 74             	mov    0x74(%eax),%eax
  802213:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802215:	85 db                	test   %ebx,%ebx
  802217:	74 0a                	je     802223 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802219:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80221e:	8b 40 78             	mov    0x78(%eax),%eax
  802221:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802223:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802228:	8b 40 70             	mov    0x70(%eax),%eax
}
  80222b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80222e:	5b                   	pop    %ebx
  80222f:	5e                   	pop    %esi
  802230:	5d                   	pop    %ebp
  802231:	c3                   	ret    
		if(from_env_store)
  802232:	85 f6                	test   %esi,%esi
  802234:	74 06                	je     80223c <ipc_recv+0x5d>
			*from_env_store = 0;
  802236:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80223c:	85 db                	test   %ebx,%ebx
  80223e:	74 eb                	je     80222b <ipc_recv+0x4c>
			*perm_store = 0;
  802240:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802246:	eb e3                	jmp    80222b <ipc_recv+0x4c>

00802248 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
  80224b:	57                   	push   %edi
  80224c:	56                   	push   %esi
  80224d:	53                   	push   %ebx
  80224e:	83 ec 0c             	sub    $0xc,%esp
  802251:	8b 7d 08             	mov    0x8(%ebp),%edi
  802254:	8b 75 0c             	mov    0xc(%ebp),%esi
  802257:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80225a:	85 db                	test   %ebx,%ebx
  80225c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802261:	0f 44 d8             	cmove  %eax,%ebx
  802264:	eb 05                	jmp    80226b <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802266:	e8 c9 ea ff ff       	call   800d34 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80226b:	ff 75 14             	pushl  0x14(%ebp)
  80226e:	53                   	push   %ebx
  80226f:	56                   	push   %esi
  802270:	57                   	push   %edi
  802271:	e8 6a ec ff ff       	call   800ee0 <sys_ipc_try_send>
  802276:	83 c4 10             	add    $0x10,%esp
  802279:	85 c0                	test   %eax,%eax
  80227b:	74 1b                	je     802298 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80227d:	79 e7                	jns    802266 <ipc_send+0x1e>
  80227f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802282:	74 e2                	je     802266 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802284:	83 ec 04             	sub    $0x4,%esp
  802287:	68 07 2b 80 00       	push   $0x802b07
  80228c:	6a 46                	push   $0x46
  80228e:	68 1c 2b 80 00       	push   $0x802b1c
  802293:	e8 e6 fe ff ff       	call   80217e <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802298:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80229b:	5b                   	pop    %ebx
  80229c:	5e                   	pop    %esi
  80229d:	5f                   	pop    %edi
  80229e:	5d                   	pop    %ebp
  80229f:	c3                   	ret    

008022a0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
  8022a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022a6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022ab:	89 c2                	mov    %eax,%edx
  8022ad:	c1 e2 07             	shl    $0x7,%edx
  8022b0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022b6:	8b 52 50             	mov    0x50(%edx),%edx
  8022b9:	39 ca                	cmp    %ecx,%edx
  8022bb:	74 11                	je     8022ce <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022bd:	83 c0 01             	add    $0x1,%eax
  8022c0:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022c5:	75 e4                	jne    8022ab <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cc:	eb 0b                	jmp    8022d9 <ipc_find_env+0x39>
			return envs[i].env_id;
  8022ce:	c1 e0 07             	shl    $0x7,%eax
  8022d1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022d6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022d9:	5d                   	pop    %ebp
  8022da:	c3                   	ret    

008022db <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022e1:	89 d0                	mov    %edx,%eax
  8022e3:	c1 e8 16             	shr    $0x16,%eax
  8022e6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022ed:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022f2:	f6 c1 01             	test   $0x1,%cl
  8022f5:	74 1d                	je     802314 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022f7:	c1 ea 0c             	shr    $0xc,%edx
  8022fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802301:	f6 c2 01             	test   $0x1,%dl
  802304:	74 0e                	je     802314 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802306:	c1 ea 0c             	shr    $0xc,%edx
  802309:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802310:	ef 
  802311:	0f b7 c0             	movzwl %ax,%eax
}
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    
  802316:	66 90                	xchg   %ax,%ax
  802318:	66 90                	xchg   %ax,%ax
  80231a:	66 90                	xchg   %ax,%ax
  80231c:	66 90                	xchg   %ax,%ax
  80231e:	66 90                	xchg   %ax,%ax

00802320 <__udivdi3>:
  802320:	55                   	push   %ebp
  802321:	57                   	push   %edi
  802322:	56                   	push   %esi
  802323:	53                   	push   %ebx
  802324:	83 ec 1c             	sub    $0x1c,%esp
  802327:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80232b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80232f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802333:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802337:	85 d2                	test   %edx,%edx
  802339:	75 4d                	jne    802388 <__udivdi3+0x68>
  80233b:	39 f3                	cmp    %esi,%ebx
  80233d:	76 19                	jbe    802358 <__udivdi3+0x38>
  80233f:	31 ff                	xor    %edi,%edi
  802341:	89 e8                	mov    %ebp,%eax
  802343:	89 f2                	mov    %esi,%edx
  802345:	f7 f3                	div    %ebx
  802347:	89 fa                	mov    %edi,%edx
  802349:	83 c4 1c             	add    $0x1c,%esp
  80234c:	5b                   	pop    %ebx
  80234d:	5e                   	pop    %esi
  80234e:	5f                   	pop    %edi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
  802351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802358:	89 d9                	mov    %ebx,%ecx
  80235a:	85 db                	test   %ebx,%ebx
  80235c:	75 0b                	jne    802369 <__udivdi3+0x49>
  80235e:	b8 01 00 00 00       	mov    $0x1,%eax
  802363:	31 d2                	xor    %edx,%edx
  802365:	f7 f3                	div    %ebx
  802367:	89 c1                	mov    %eax,%ecx
  802369:	31 d2                	xor    %edx,%edx
  80236b:	89 f0                	mov    %esi,%eax
  80236d:	f7 f1                	div    %ecx
  80236f:	89 c6                	mov    %eax,%esi
  802371:	89 e8                	mov    %ebp,%eax
  802373:	89 f7                	mov    %esi,%edi
  802375:	f7 f1                	div    %ecx
  802377:	89 fa                	mov    %edi,%edx
  802379:	83 c4 1c             	add    $0x1c,%esp
  80237c:	5b                   	pop    %ebx
  80237d:	5e                   	pop    %esi
  80237e:	5f                   	pop    %edi
  80237f:	5d                   	pop    %ebp
  802380:	c3                   	ret    
  802381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802388:	39 f2                	cmp    %esi,%edx
  80238a:	77 1c                	ja     8023a8 <__udivdi3+0x88>
  80238c:	0f bd fa             	bsr    %edx,%edi
  80238f:	83 f7 1f             	xor    $0x1f,%edi
  802392:	75 2c                	jne    8023c0 <__udivdi3+0xa0>
  802394:	39 f2                	cmp    %esi,%edx
  802396:	72 06                	jb     80239e <__udivdi3+0x7e>
  802398:	31 c0                	xor    %eax,%eax
  80239a:	39 eb                	cmp    %ebp,%ebx
  80239c:	77 a9                	ja     802347 <__udivdi3+0x27>
  80239e:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a3:	eb a2                	jmp    802347 <__udivdi3+0x27>
  8023a5:	8d 76 00             	lea    0x0(%esi),%esi
  8023a8:	31 ff                	xor    %edi,%edi
  8023aa:	31 c0                	xor    %eax,%eax
  8023ac:	89 fa                	mov    %edi,%edx
  8023ae:	83 c4 1c             	add    $0x1c,%esp
  8023b1:	5b                   	pop    %ebx
  8023b2:	5e                   	pop    %esi
  8023b3:	5f                   	pop    %edi
  8023b4:	5d                   	pop    %ebp
  8023b5:	c3                   	ret    
  8023b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023bd:	8d 76 00             	lea    0x0(%esi),%esi
  8023c0:	89 f9                	mov    %edi,%ecx
  8023c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023c7:	29 f8                	sub    %edi,%eax
  8023c9:	d3 e2                	shl    %cl,%edx
  8023cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023cf:	89 c1                	mov    %eax,%ecx
  8023d1:	89 da                	mov    %ebx,%edx
  8023d3:	d3 ea                	shr    %cl,%edx
  8023d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023d9:	09 d1                	or     %edx,%ecx
  8023db:	89 f2                	mov    %esi,%edx
  8023dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023e1:	89 f9                	mov    %edi,%ecx
  8023e3:	d3 e3                	shl    %cl,%ebx
  8023e5:	89 c1                	mov    %eax,%ecx
  8023e7:	d3 ea                	shr    %cl,%edx
  8023e9:	89 f9                	mov    %edi,%ecx
  8023eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023ef:	89 eb                	mov    %ebp,%ebx
  8023f1:	d3 e6                	shl    %cl,%esi
  8023f3:	89 c1                	mov    %eax,%ecx
  8023f5:	d3 eb                	shr    %cl,%ebx
  8023f7:	09 de                	or     %ebx,%esi
  8023f9:	89 f0                	mov    %esi,%eax
  8023fb:	f7 74 24 08          	divl   0x8(%esp)
  8023ff:	89 d6                	mov    %edx,%esi
  802401:	89 c3                	mov    %eax,%ebx
  802403:	f7 64 24 0c          	mull   0xc(%esp)
  802407:	39 d6                	cmp    %edx,%esi
  802409:	72 15                	jb     802420 <__udivdi3+0x100>
  80240b:	89 f9                	mov    %edi,%ecx
  80240d:	d3 e5                	shl    %cl,%ebp
  80240f:	39 c5                	cmp    %eax,%ebp
  802411:	73 04                	jae    802417 <__udivdi3+0xf7>
  802413:	39 d6                	cmp    %edx,%esi
  802415:	74 09                	je     802420 <__udivdi3+0x100>
  802417:	89 d8                	mov    %ebx,%eax
  802419:	31 ff                	xor    %edi,%edi
  80241b:	e9 27 ff ff ff       	jmp    802347 <__udivdi3+0x27>
  802420:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802423:	31 ff                	xor    %edi,%edi
  802425:	e9 1d ff ff ff       	jmp    802347 <__udivdi3+0x27>
  80242a:	66 90                	xchg   %ax,%ax
  80242c:	66 90                	xchg   %ax,%ax
  80242e:	66 90                	xchg   %ax,%ax

00802430 <__umoddi3>:
  802430:	55                   	push   %ebp
  802431:	57                   	push   %edi
  802432:	56                   	push   %esi
  802433:	53                   	push   %ebx
  802434:	83 ec 1c             	sub    $0x1c,%esp
  802437:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80243b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80243f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802443:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802447:	89 da                	mov    %ebx,%edx
  802449:	85 c0                	test   %eax,%eax
  80244b:	75 43                	jne    802490 <__umoddi3+0x60>
  80244d:	39 df                	cmp    %ebx,%edi
  80244f:	76 17                	jbe    802468 <__umoddi3+0x38>
  802451:	89 f0                	mov    %esi,%eax
  802453:	f7 f7                	div    %edi
  802455:	89 d0                	mov    %edx,%eax
  802457:	31 d2                	xor    %edx,%edx
  802459:	83 c4 1c             	add    $0x1c,%esp
  80245c:	5b                   	pop    %ebx
  80245d:	5e                   	pop    %esi
  80245e:	5f                   	pop    %edi
  80245f:	5d                   	pop    %ebp
  802460:	c3                   	ret    
  802461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802468:	89 fd                	mov    %edi,%ebp
  80246a:	85 ff                	test   %edi,%edi
  80246c:	75 0b                	jne    802479 <__umoddi3+0x49>
  80246e:	b8 01 00 00 00       	mov    $0x1,%eax
  802473:	31 d2                	xor    %edx,%edx
  802475:	f7 f7                	div    %edi
  802477:	89 c5                	mov    %eax,%ebp
  802479:	89 d8                	mov    %ebx,%eax
  80247b:	31 d2                	xor    %edx,%edx
  80247d:	f7 f5                	div    %ebp
  80247f:	89 f0                	mov    %esi,%eax
  802481:	f7 f5                	div    %ebp
  802483:	89 d0                	mov    %edx,%eax
  802485:	eb d0                	jmp    802457 <__umoddi3+0x27>
  802487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80248e:	66 90                	xchg   %ax,%ax
  802490:	89 f1                	mov    %esi,%ecx
  802492:	39 d8                	cmp    %ebx,%eax
  802494:	76 0a                	jbe    8024a0 <__umoddi3+0x70>
  802496:	89 f0                	mov    %esi,%eax
  802498:	83 c4 1c             	add    $0x1c,%esp
  80249b:	5b                   	pop    %ebx
  80249c:	5e                   	pop    %esi
  80249d:	5f                   	pop    %edi
  80249e:	5d                   	pop    %ebp
  80249f:	c3                   	ret    
  8024a0:	0f bd e8             	bsr    %eax,%ebp
  8024a3:	83 f5 1f             	xor    $0x1f,%ebp
  8024a6:	75 20                	jne    8024c8 <__umoddi3+0x98>
  8024a8:	39 d8                	cmp    %ebx,%eax
  8024aa:	0f 82 b0 00 00 00    	jb     802560 <__umoddi3+0x130>
  8024b0:	39 f7                	cmp    %esi,%edi
  8024b2:	0f 86 a8 00 00 00    	jbe    802560 <__umoddi3+0x130>
  8024b8:	89 c8                	mov    %ecx,%eax
  8024ba:	83 c4 1c             	add    $0x1c,%esp
  8024bd:	5b                   	pop    %ebx
  8024be:	5e                   	pop    %esi
  8024bf:	5f                   	pop    %edi
  8024c0:	5d                   	pop    %ebp
  8024c1:	c3                   	ret    
  8024c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024c8:	89 e9                	mov    %ebp,%ecx
  8024ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8024cf:	29 ea                	sub    %ebp,%edx
  8024d1:	d3 e0                	shl    %cl,%eax
  8024d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024d7:	89 d1                	mov    %edx,%ecx
  8024d9:	89 f8                	mov    %edi,%eax
  8024db:	d3 e8                	shr    %cl,%eax
  8024dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024e9:	09 c1                	or     %eax,%ecx
  8024eb:	89 d8                	mov    %ebx,%eax
  8024ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024f1:	89 e9                	mov    %ebp,%ecx
  8024f3:	d3 e7                	shl    %cl,%edi
  8024f5:	89 d1                	mov    %edx,%ecx
  8024f7:	d3 e8                	shr    %cl,%eax
  8024f9:	89 e9                	mov    %ebp,%ecx
  8024fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024ff:	d3 e3                	shl    %cl,%ebx
  802501:	89 c7                	mov    %eax,%edi
  802503:	89 d1                	mov    %edx,%ecx
  802505:	89 f0                	mov    %esi,%eax
  802507:	d3 e8                	shr    %cl,%eax
  802509:	89 e9                	mov    %ebp,%ecx
  80250b:	89 fa                	mov    %edi,%edx
  80250d:	d3 e6                	shl    %cl,%esi
  80250f:	09 d8                	or     %ebx,%eax
  802511:	f7 74 24 08          	divl   0x8(%esp)
  802515:	89 d1                	mov    %edx,%ecx
  802517:	89 f3                	mov    %esi,%ebx
  802519:	f7 64 24 0c          	mull   0xc(%esp)
  80251d:	89 c6                	mov    %eax,%esi
  80251f:	89 d7                	mov    %edx,%edi
  802521:	39 d1                	cmp    %edx,%ecx
  802523:	72 06                	jb     80252b <__umoddi3+0xfb>
  802525:	75 10                	jne    802537 <__umoddi3+0x107>
  802527:	39 c3                	cmp    %eax,%ebx
  802529:	73 0c                	jae    802537 <__umoddi3+0x107>
  80252b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80252f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802533:	89 d7                	mov    %edx,%edi
  802535:	89 c6                	mov    %eax,%esi
  802537:	89 ca                	mov    %ecx,%edx
  802539:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80253e:	29 f3                	sub    %esi,%ebx
  802540:	19 fa                	sbb    %edi,%edx
  802542:	89 d0                	mov    %edx,%eax
  802544:	d3 e0                	shl    %cl,%eax
  802546:	89 e9                	mov    %ebp,%ecx
  802548:	d3 eb                	shr    %cl,%ebx
  80254a:	d3 ea                	shr    %cl,%edx
  80254c:	09 d8                	or     %ebx,%eax
  80254e:	83 c4 1c             	add    $0x1c,%esp
  802551:	5b                   	pop    %ebx
  802552:	5e                   	pop    %esi
  802553:	5f                   	pop    %edi
  802554:	5d                   	pop    %ebp
  802555:	c3                   	ret    
  802556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80255d:	8d 76 00             	lea    0x0(%esi),%esi
  802560:	89 da                	mov    %ebx,%edx
  802562:	29 fe                	sub    %edi,%esi
  802564:	19 c2                	sbb    %eax,%edx
  802566:	89 f1                	mov    %esi,%ecx
  802568:	89 c8                	mov    %ecx,%eax
  80256a:	e9 4b ff ff ff       	jmp    8024ba <__umoddi3+0x8a>
