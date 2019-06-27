
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
  800051:	68 a0 25 80 00       	push   $0x8025a0
  800056:	e8 a9 01 00 00       	call   800204 <cprintf>
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
  800073:	e8 9f 0c 00 00       	call   800d17 <sys_getenvid>
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
  800098:	74 23                	je     8000bd <libmain+0x5d>
		if(envs[i].env_id == find)
  80009a:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  8000a0:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000a6:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000a9:	39 c1                	cmp    %eax,%ecx
  8000ab:	75 e2                	jne    80008f <libmain+0x2f>
  8000ad:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8000b3:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000b9:	89 fe                	mov    %edi,%esi
  8000bb:	eb d2                	jmp    80008f <libmain+0x2f>
  8000bd:	89 f0                	mov    %esi,%eax
  8000bf:	84 c0                	test   %al,%al
  8000c1:	74 06                	je     8000c9 <libmain+0x69>
  8000c3:	89 1d 0c 40 80 00    	mov    %ebx,0x80400c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000cd:	7e 0a                	jle    8000d9 <libmain+0x79>
		binaryname = argv[0];
  8000cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d2:	8b 00                	mov    (%eax),%eax
  8000d4:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000d9:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8000de:	8b 40 48             	mov    0x48(%eax),%eax
  8000e1:	83 ec 08             	sub    $0x8,%esp
  8000e4:	50                   	push   %eax
  8000e5:	68 ae 25 80 00       	push   $0x8025ae
  8000ea:	e8 15 01 00 00       	call   800204 <cprintf>
	cprintf("before umain\n");
  8000ef:	c7 04 24 cc 25 80 00 	movl   $0x8025cc,(%esp)
  8000f6:	e8 09 01 00 00       	call   800204 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000fb:	83 c4 08             	add    $0x8,%esp
  8000fe:	ff 75 0c             	pushl  0xc(%ebp)
  800101:	ff 75 08             	pushl  0x8(%ebp)
  800104:	e8 2a ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800109:	c7 04 24 da 25 80 00 	movl   $0x8025da,(%esp)
  800110:	e8 ef 00 00 00       	call   800204 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800115:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80011a:	8b 40 48             	mov    0x48(%eax),%eax
  80011d:	83 c4 08             	add    $0x8,%esp
  800120:	50                   	push   %eax
  800121:	68 e7 25 80 00       	push   $0x8025e7
  800126:	e8 d9 00 00 00       	call   800204 <cprintf>
	// exit gracefully
	exit();
  80012b:	e8 0b 00 00 00       	call   80013b <exit>
}
  800130:	83 c4 10             	add    $0x10,%esp
  800133:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800136:	5b                   	pop    %ebx
  800137:	5e                   	pop    %esi
  800138:	5f                   	pop    %edi
  800139:	5d                   	pop    %ebp
  80013a:	c3                   	ret    

0080013b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800141:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800146:	8b 40 48             	mov    0x48(%eax),%eax
  800149:	68 14 26 80 00       	push   $0x802614
  80014e:	50                   	push   %eax
  80014f:	68 06 26 80 00       	push   $0x802606
  800154:	e8 ab 00 00 00       	call   800204 <cprintf>
	close_all();
  800159:	e8 c4 10 00 00       	call   801222 <close_all>
	sys_env_destroy(0);
  80015e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800165:	e8 6c 0b 00 00       	call   800cd6 <sys_env_destroy>
}
  80016a:	83 c4 10             	add    $0x10,%esp
  80016d:	c9                   	leave  
  80016e:	c3                   	ret    

0080016f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80016f:	55                   	push   %ebp
  800170:	89 e5                	mov    %esp,%ebp
  800172:	53                   	push   %ebx
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800179:	8b 13                	mov    (%ebx),%edx
  80017b:	8d 42 01             	lea    0x1(%edx),%eax
  80017e:	89 03                	mov    %eax,(%ebx)
  800180:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800183:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800187:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018c:	74 09                	je     800197 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80018e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800192:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800195:	c9                   	leave  
  800196:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	68 ff 00 00 00       	push   $0xff
  80019f:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a2:	50                   	push   %eax
  8001a3:	e8 f1 0a 00 00       	call   800c99 <sys_cputs>
		b->idx = 0;
  8001a8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001ae:	83 c4 10             	add    $0x10,%esp
  8001b1:	eb db                	jmp    80018e <putch+0x1f>

008001b3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001bc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c3:	00 00 00 
	b.cnt = 0;
  8001c6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001cd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d0:	ff 75 0c             	pushl  0xc(%ebp)
  8001d3:	ff 75 08             	pushl  0x8(%ebp)
  8001d6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001dc:	50                   	push   %eax
  8001dd:	68 6f 01 80 00       	push   $0x80016f
  8001e2:	e8 4a 01 00 00       	call   800331 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e7:	83 c4 08             	add    $0x8,%esp
  8001ea:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f6:	50                   	push   %eax
  8001f7:	e8 9d 0a 00 00       	call   800c99 <sys_cputs>

	return b.cnt;
}
  8001fc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020d:	50                   	push   %eax
  80020e:	ff 75 08             	pushl  0x8(%ebp)
  800211:	e8 9d ff ff ff       	call   8001b3 <vcprintf>
	va_end(ap);

	return cnt;
}
  800216:	c9                   	leave  
  800217:	c3                   	ret    

00800218 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	57                   	push   %edi
  80021c:	56                   	push   %esi
  80021d:	53                   	push   %ebx
  80021e:	83 ec 1c             	sub    $0x1c,%esp
  800221:	89 c6                	mov    %eax,%esi
  800223:	89 d7                	mov    %edx,%edi
  800225:	8b 45 08             	mov    0x8(%ebp),%eax
  800228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80022e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800231:	8b 45 10             	mov    0x10(%ebp),%eax
  800234:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800237:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80023b:	74 2c                	je     800269 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80023d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800240:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800247:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80024a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80024d:	39 c2                	cmp    %eax,%edx
  80024f:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800252:	73 43                	jae    800297 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800254:	83 eb 01             	sub    $0x1,%ebx
  800257:	85 db                	test   %ebx,%ebx
  800259:	7e 6c                	jle    8002c7 <printnum+0xaf>
				putch(padc, putdat);
  80025b:	83 ec 08             	sub    $0x8,%esp
  80025e:	57                   	push   %edi
  80025f:	ff 75 18             	pushl  0x18(%ebp)
  800262:	ff d6                	call   *%esi
  800264:	83 c4 10             	add    $0x10,%esp
  800267:	eb eb                	jmp    800254 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	6a 20                	push   $0x20
  80026e:	6a 00                	push   $0x0
  800270:	50                   	push   %eax
  800271:	ff 75 e4             	pushl  -0x1c(%ebp)
  800274:	ff 75 e0             	pushl  -0x20(%ebp)
  800277:	89 fa                	mov    %edi,%edx
  800279:	89 f0                	mov    %esi,%eax
  80027b:	e8 98 ff ff ff       	call   800218 <printnum>
		while (--width > 0)
  800280:	83 c4 20             	add    $0x20,%esp
  800283:	83 eb 01             	sub    $0x1,%ebx
  800286:	85 db                	test   %ebx,%ebx
  800288:	7e 65                	jle    8002ef <printnum+0xd7>
			putch(padc, putdat);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	57                   	push   %edi
  80028e:	6a 20                	push   $0x20
  800290:	ff d6                	call   *%esi
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	eb ec                	jmp    800283 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	ff 75 18             	pushl  0x18(%ebp)
  80029d:	83 eb 01             	sub    $0x1,%ebx
  8002a0:	53                   	push   %ebx
  8002a1:	50                   	push   %eax
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b1:	e8 8a 20 00 00       	call   802340 <__udivdi3>
  8002b6:	83 c4 18             	add    $0x18,%esp
  8002b9:	52                   	push   %edx
  8002ba:	50                   	push   %eax
  8002bb:	89 fa                	mov    %edi,%edx
  8002bd:	89 f0                	mov    %esi,%eax
  8002bf:	e8 54 ff ff ff       	call   800218 <printnum>
  8002c4:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002c7:	83 ec 08             	sub    $0x8,%esp
  8002ca:	57                   	push   %edi
  8002cb:	83 ec 04             	sub    $0x4,%esp
  8002ce:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002da:	e8 71 21 00 00       	call   802450 <__umoddi3>
  8002df:	83 c4 14             	add    $0x14,%esp
  8002e2:	0f be 80 19 26 80 00 	movsbl 0x802619(%eax),%eax
  8002e9:	50                   	push   %eax
  8002ea:	ff d6                	call   *%esi
  8002ec:	83 c4 10             	add    $0x10,%esp
	}
}
  8002ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f2:	5b                   	pop    %ebx
  8002f3:	5e                   	pop    %esi
  8002f4:	5f                   	pop    %edi
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    

008002f7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002fd:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800301:	8b 10                	mov    (%eax),%edx
  800303:	3b 50 04             	cmp    0x4(%eax),%edx
  800306:	73 0a                	jae    800312 <sprintputch+0x1b>
		*b->buf++ = ch;
  800308:	8d 4a 01             	lea    0x1(%edx),%ecx
  80030b:	89 08                	mov    %ecx,(%eax)
  80030d:	8b 45 08             	mov    0x8(%ebp),%eax
  800310:	88 02                	mov    %al,(%edx)
}
  800312:	5d                   	pop    %ebp
  800313:	c3                   	ret    

00800314 <printfmt>:
{
  800314:	55                   	push   %ebp
  800315:	89 e5                	mov    %esp,%ebp
  800317:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80031a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80031d:	50                   	push   %eax
  80031e:	ff 75 10             	pushl  0x10(%ebp)
  800321:	ff 75 0c             	pushl  0xc(%ebp)
  800324:	ff 75 08             	pushl  0x8(%ebp)
  800327:	e8 05 00 00 00       	call   800331 <vprintfmt>
}
  80032c:	83 c4 10             	add    $0x10,%esp
  80032f:	c9                   	leave  
  800330:	c3                   	ret    

00800331 <vprintfmt>:
{
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	57                   	push   %edi
  800335:	56                   	push   %esi
  800336:	53                   	push   %ebx
  800337:	83 ec 3c             	sub    $0x3c,%esp
  80033a:	8b 75 08             	mov    0x8(%ebp),%esi
  80033d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800340:	8b 7d 10             	mov    0x10(%ebp),%edi
  800343:	e9 32 04 00 00       	jmp    80077a <vprintfmt+0x449>
		padc = ' ';
  800348:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80034c:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800353:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80035a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800361:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800368:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80036f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800374:	8d 47 01             	lea    0x1(%edi),%eax
  800377:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80037a:	0f b6 17             	movzbl (%edi),%edx
  80037d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800380:	3c 55                	cmp    $0x55,%al
  800382:	0f 87 12 05 00 00    	ja     80089a <vprintfmt+0x569>
  800388:	0f b6 c0             	movzbl %al,%eax
  80038b:	ff 24 85 00 28 80 00 	jmp    *0x802800(,%eax,4)
  800392:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800395:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800399:	eb d9                	jmp    800374 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80039b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80039e:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003a2:	eb d0                	jmp    800374 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003a4:	0f b6 d2             	movzbl %dl,%edx
  8003a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8003af:	89 75 08             	mov    %esi,0x8(%ebp)
  8003b2:	eb 03                	jmp    8003b7 <vprintfmt+0x86>
  8003b4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ba:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003be:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003c1:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003c4:	83 fe 09             	cmp    $0x9,%esi
  8003c7:	76 eb                	jbe    8003b4 <vprintfmt+0x83>
  8003c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8003cf:	eb 14                	jmp    8003e5 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dc:	8d 40 04             	lea    0x4(%eax),%eax
  8003df:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e9:	79 89                	jns    800374 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003f8:	e9 77 ff ff ff       	jmp    800374 <vprintfmt+0x43>
  8003fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800400:	85 c0                	test   %eax,%eax
  800402:	0f 48 c1             	cmovs  %ecx,%eax
  800405:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800408:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80040b:	e9 64 ff ff ff       	jmp    800374 <vprintfmt+0x43>
  800410:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800413:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80041a:	e9 55 ff ff ff       	jmp    800374 <vprintfmt+0x43>
			lflag++;
  80041f:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800423:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800426:	e9 49 ff ff ff       	jmp    800374 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80042b:	8b 45 14             	mov    0x14(%ebp),%eax
  80042e:	8d 78 04             	lea    0x4(%eax),%edi
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	53                   	push   %ebx
  800435:	ff 30                	pushl  (%eax)
  800437:	ff d6                	call   *%esi
			break;
  800439:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80043c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80043f:	e9 33 03 00 00       	jmp    800777 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800444:	8b 45 14             	mov    0x14(%ebp),%eax
  800447:	8d 78 04             	lea    0x4(%eax),%edi
  80044a:	8b 00                	mov    (%eax),%eax
  80044c:	99                   	cltd   
  80044d:	31 d0                	xor    %edx,%eax
  80044f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800451:	83 f8 11             	cmp    $0x11,%eax
  800454:	7f 23                	jg     800479 <vprintfmt+0x148>
  800456:	8b 14 85 60 29 80 00 	mov    0x802960(,%eax,4),%edx
  80045d:	85 d2                	test   %edx,%edx
  80045f:	74 18                	je     800479 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800461:	52                   	push   %edx
  800462:	68 7d 2a 80 00       	push   $0x802a7d
  800467:	53                   	push   %ebx
  800468:	56                   	push   %esi
  800469:	e8 a6 fe ff ff       	call   800314 <printfmt>
  80046e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800471:	89 7d 14             	mov    %edi,0x14(%ebp)
  800474:	e9 fe 02 00 00       	jmp    800777 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800479:	50                   	push   %eax
  80047a:	68 31 26 80 00       	push   $0x802631
  80047f:	53                   	push   %ebx
  800480:	56                   	push   %esi
  800481:	e8 8e fe ff ff       	call   800314 <printfmt>
  800486:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800489:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80048c:	e9 e6 02 00 00       	jmp    800777 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800491:	8b 45 14             	mov    0x14(%ebp),%eax
  800494:	83 c0 04             	add    $0x4,%eax
  800497:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80049a:	8b 45 14             	mov    0x14(%ebp),%eax
  80049d:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80049f:	85 c9                	test   %ecx,%ecx
  8004a1:	b8 2a 26 80 00       	mov    $0x80262a,%eax
  8004a6:	0f 45 c1             	cmovne %ecx,%eax
  8004a9:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b0:	7e 06                	jle    8004b8 <vprintfmt+0x187>
  8004b2:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004b6:	75 0d                	jne    8004c5 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004bb:	89 c7                	mov    %eax,%edi
  8004bd:	03 45 e0             	add    -0x20(%ebp),%eax
  8004c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c3:	eb 53                	jmp    800518 <vprintfmt+0x1e7>
  8004c5:	83 ec 08             	sub    $0x8,%esp
  8004c8:	ff 75 d8             	pushl  -0x28(%ebp)
  8004cb:	50                   	push   %eax
  8004cc:	e8 71 04 00 00       	call   800942 <strnlen>
  8004d1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d4:	29 c1                	sub    %eax,%ecx
  8004d6:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004d9:	83 c4 10             	add    $0x10,%esp
  8004dc:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004de:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e5:	eb 0f                	jmp    8004f6 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004e7:	83 ec 08             	sub    $0x8,%esp
  8004ea:	53                   	push   %ebx
  8004eb:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ee:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f0:	83 ef 01             	sub    $0x1,%edi
  8004f3:	83 c4 10             	add    $0x10,%esp
  8004f6:	85 ff                	test   %edi,%edi
  8004f8:	7f ed                	jg     8004e7 <vprintfmt+0x1b6>
  8004fa:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004fd:	85 c9                	test   %ecx,%ecx
  8004ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800504:	0f 49 c1             	cmovns %ecx,%eax
  800507:	29 c1                	sub    %eax,%ecx
  800509:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80050c:	eb aa                	jmp    8004b8 <vprintfmt+0x187>
					putch(ch, putdat);
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	53                   	push   %ebx
  800512:	52                   	push   %edx
  800513:	ff d6                	call   *%esi
  800515:	83 c4 10             	add    $0x10,%esp
  800518:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80051b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80051d:	83 c7 01             	add    $0x1,%edi
  800520:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800524:	0f be d0             	movsbl %al,%edx
  800527:	85 d2                	test   %edx,%edx
  800529:	74 4b                	je     800576 <vprintfmt+0x245>
  80052b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80052f:	78 06                	js     800537 <vprintfmt+0x206>
  800531:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800535:	78 1e                	js     800555 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800537:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80053b:	74 d1                	je     80050e <vprintfmt+0x1dd>
  80053d:	0f be c0             	movsbl %al,%eax
  800540:	83 e8 20             	sub    $0x20,%eax
  800543:	83 f8 5e             	cmp    $0x5e,%eax
  800546:	76 c6                	jbe    80050e <vprintfmt+0x1dd>
					putch('?', putdat);
  800548:	83 ec 08             	sub    $0x8,%esp
  80054b:	53                   	push   %ebx
  80054c:	6a 3f                	push   $0x3f
  80054e:	ff d6                	call   *%esi
  800550:	83 c4 10             	add    $0x10,%esp
  800553:	eb c3                	jmp    800518 <vprintfmt+0x1e7>
  800555:	89 cf                	mov    %ecx,%edi
  800557:	eb 0e                	jmp    800567 <vprintfmt+0x236>
				putch(' ', putdat);
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	53                   	push   %ebx
  80055d:	6a 20                	push   $0x20
  80055f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800561:	83 ef 01             	sub    $0x1,%edi
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	85 ff                	test   %edi,%edi
  800569:	7f ee                	jg     800559 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80056b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80056e:	89 45 14             	mov    %eax,0x14(%ebp)
  800571:	e9 01 02 00 00       	jmp    800777 <vprintfmt+0x446>
  800576:	89 cf                	mov    %ecx,%edi
  800578:	eb ed                	jmp    800567 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80057d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800584:	e9 eb fd ff ff       	jmp    800374 <vprintfmt+0x43>
	if (lflag >= 2)
  800589:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80058d:	7f 21                	jg     8005b0 <vprintfmt+0x27f>
	else if (lflag)
  80058f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800593:	74 68                	je     8005fd <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80059d:	89 c1                	mov    %eax,%ecx
  80059f:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8d 40 04             	lea    0x4(%eax),%eax
  8005ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ae:	eb 17                	jmp    8005c7 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b3:	8b 50 04             	mov    0x4(%eax),%edx
  8005b6:	8b 00                	mov    (%eax),%eax
  8005b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005bb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8d 40 08             	lea    0x8(%eax),%eax
  8005c4:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005d3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005d7:	78 3f                	js     800618 <vprintfmt+0x2e7>
			base = 10;
  8005d9:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005de:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005e2:	0f 84 71 01 00 00    	je     800759 <vprintfmt+0x428>
				putch('+', putdat);
  8005e8:	83 ec 08             	sub    $0x8,%esp
  8005eb:	53                   	push   %ebx
  8005ec:	6a 2b                	push   $0x2b
  8005ee:	ff d6                	call   *%esi
  8005f0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f8:	e9 5c 01 00 00       	jmp    800759 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 00                	mov    (%eax),%eax
  800602:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800605:	89 c1                	mov    %eax,%ecx
  800607:	c1 f9 1f             	sar    $0x1f,%ecx
  80060a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	8d 40 04             	lea    0x4(%eax),%eax
  800613:	89 45 14             	mov    %eax,0x14(%ebp)
  800616:	eb af                	jmp    8005c7 <vprintfmt+0x296>
				putch('-', putdat);
  800618:	83 ec 08             	sub    $0x8,%esp
  80061b:	53                   	push   %ebx
  80061c:	6a 2d                	push   $0x2d
  80061e:	ff d6                	call   *%esi
				num = -(long long) num;
  800620:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800623:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800626:	f7 d8                	neg    %eax
  800628:	83 d2 00             	adc    $0x0,%edx
  80062b:	f7 da                	neg    %edx
  80062d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800630:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800633:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800636:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063b:	e9 19 01 00 00       	jmp    800759 <vprintfmt+0x428>
	if (lflag >= 2)
  800640:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800644:	7f 29                	jg     80066f <vprintfmt+0x33e>
	else if (lflag)
  800646:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80064a:	74 44                	je     800690 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	ba 00 00 00 00       	mov    $0x0,%edx
  800656:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800659:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8d 40 04             	lea    0x4(%eax),%eax
  800662:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800665:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066a:	e9 ea 00 00 00       	jmp    800759 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8b 50 04             	mov    0x4(%eax),%edx
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8d 40 08             	lea    0x8(%eax),%eax
  800683:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800686:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068b:	e9 c9 00 00 00       	jmp    800759 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	ba 00 00 00 00       	mov    $0x0,%edx
  80069a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8d 40 04             	lea    0x4(%eax),%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ae:	e9 a6 00 00 00       	jmp    800759 <vprintfmt+0x428>
			putch('0', putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	53                   	push   %ebx
  8006b7:	6a 30                	push   $0x30
  8006b9:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006c2:	7f 26                	jg     8006ea <vprintfmt+0x3b9>
	else if (lflag)
  8006c4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006c8:	74 3e                	je     800708 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8d 40 04             	lea    0x4(%eax),%eax
  8006e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e3:	b8 08 00 00 00       	mov    $0x8,%eax
  8006e8:	eb 6f                	jmp    800759 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8b 50 04             	mov    0x4(%eax),%edx
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8d 40 08             	lea    0x8(%eax),%eax
  8006fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800701:	b8 08 00 00 00       	mov    $0x8,%eax
  800706:	eb 51                	jmp    800759 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	ba 00 00 00 00       	mov    $0x0,%edx
  800712:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800715:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	8d 40 04             	lea    0x4(%eax),%eax
  80071e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800721:	b8 08 00 00 00       	mov    $0x8,%eax
  800726:	eb 31                	jmp    800759 <vprintfmt+0x428>
			putch('0', putdat);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	53                   	push   %ebx
  80072c:	6a 30                	push   $0x30
  80072e:	ff d6                	call   *%esi
			putch('x', putdat);
  800730:	83 c4 08             	add    $0x8,%esp
  800733:	53                   	push   %ebx
  800734:	6a 78                	push   $0x78
  800736:	ff d6                	call   *%esi
			num = (unsigned long long)
  800738:	8b 45 14             	mov    0x14(%ebp),%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	ba 00 00 00 00       	mov    $0x0,%edx
  800742:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800745:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800748:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	8d 40 04             	lea    0x4(%eax),%eax
  800751:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800754:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800759:	83 ec 0c             	sub    $0xc,%esp
  80075c:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800760:	52                   	push   %edx
  800761:	ff 75 e0             	pushl  -0x20(%ebp)
  800764:	50                   	push   %eax
  800765:	ff 75 dc             	pushl  -0x24(%ebp)
  800768:	ff 75 d8             	pushl  -0x28(%ebp)
  80076b:	89 da                	mov    %ebx,%edx
  80076d:	89 f0                	mov    %esi,%eax
  80076f:	e8 a4 fa ff ff       	call   800218 <printnum>
			break;
  800774:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800777:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077a:	83 c7 01             	add    $0x1,%edi
  80077d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800781:	83 f8 25             	cmp    $0x25,%eax
  800784:	0f 84 be fb ff ff    	je     800348 <vprintfmt+0x17>
			if (ch == '\0')
  80078a:	85 c0                	test   %eax,%eax
  80078c:	0f 84 28 01 00 00    	je     8008ba <vprintfmt+0x589>
			putch(ch, putdat);
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	53                   	push   %ebx
  800796:	50                   	push   %eax
  800797:	ff d6                	call   *%esi
  800799:	83 c4 10             	add    $0x10,%esp
  80079c:	eb dc                	jmp    80077a <vprintfmt+0x449>
	if (lflag >= 2)
  80079e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007a2:	7f 26                	jg     8007ca <vprintfmt+0x499>
	else if (lflag)
  8007a4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007a8:	74 41                	je     8007eb <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	8d 40 04             	lea    0x4(%eax),%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c3:	b8 10 00 00 00       	mov    $0x10,%eax
  8007c8:	eb 8f                	jmp    800759 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8b 50 04             	mov    0x4(%eax),%edx
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	8d 40 08             	lea    0x8(%eax),%eax
  8007de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e1:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e6:	e9 6e ff ff ff       	jmp    800759 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8d 40 04             	lea    0x4(%eax),%eax
  800801:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800804:	b8 10 00 00 00       	mov    $0x10,%eax
  800809:	e9 4b ff ff ff       	jmp    800759 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80080e:	8b 45 14             	mov    0x14(%ebp),%eax
  800811:	83 c0 04             	add    $0x4,%eax
  800814:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800817:	8b 45 14             	mov    0x14(%ebp),%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	85 c0                	test   %eax,%eax
  80081e:	74 14                	je     800834 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800820:	8b 13                	mov    (%ebx),%edx
  800822:	83 fa 7f             	cmp    $0x7f,%edx
  800825:	7f 37                	jg     80085e <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800827:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800829:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80082c:	89 45 14             	mov    %eax,0x14(%ebp)
  80082f:	e9 43 ff ff ff       	jmp    800777 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800834:	b8 0a 00 00 00       	mov    $0xa,%eax
  800839:	bf 4d 27 80 00       	mov    $0x80274d,%edi
							putch(ch, putdat);
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	53                   	push   %ebx
  800842:	50                   	push   %eax
  800843:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800845:	83 c7 01             	add    $0x1,%edi
  800848:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80084c:	83 c4 10             	add    $0x10,%esp
  80084f:	85 c0                	test   %eax,%eax
  800851:	75 eb                	jne    80083e <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800853:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
  800859:	e9 19 ff ff ff       	jmp    800777 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80085e:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800860:	b8 0a 00 00 00       	mov    $0xa,%eax
  800865:	bf 85 27 80 00       	mov    $0x802785,%edi
							putch(ch, putdat);
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	53                   	push   %ebx
  80086e:	50                   	push   %eax
  80086f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800871:	83 c7 01             	add    $0x1,%edi
  800874:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800878:	83 c4 10             	add    $0x10,%esp
  80087b:	85 c0                	test   %eax,%eax
  80087d:	75 eb                	jne    80086a <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80087f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800882:	89 45 14             	mov    %eax,0x14(%ebp)
  800885:	e9 ed fe ff ff       	jmp    800777 <vprintfmt+0x446>
			putch(ch, putdat);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	53                   	push   %ebx
  80088e:	6a 25                	push   $0x25
  800890:	ff d6                	call   *%esi
			break;
  800892:	83 c4 10             	add    $0x10,%esp
  800895:	e9 dd fe ff ff       	jmp    800777 <vprintfmt+0x446>
			putch('%', putdat);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	53                   	push   %ebx
  80089e:	6a 25                	push   $0x25
  8008a0:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	89 f8                	mov    %edi,%eax
  8008a7:	eb 03                	jmp    8008ac <vprintfmt+0x57b>
  8008a9:	83 e8 01             	sub    $0x1,%eax
  8008ac:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008b0:	75 f7                	jne    8008a9 <vprintfmt+0x578>
  8008b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008b5:	e9 bd fe ff ff       	jmp    800777 <vprintfmt+0x446>
}
  8008ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008bd:	5b                   	pop    %ebx
  8008be:	5e                   	pop    %esi
  8008bf:	5f                   	pop    %edi
  8008c0:	5d                   	pop    %ebp
  8008c1:	c3                   	ret    

008008c2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	83 ec 18             	sub    $0x18,%esp
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008d1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008d5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008df:	85 c0                	test   %eax,%eax
  8008e1:	74 26                	je     800909 <vsnprintf+0x47>
  8008e3:	85 d2                	test   %edx,%edx
  8008e5:	7e 22                	jle    800909 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e7:	ff 75 14             	pushl  0x14(%ebp)
  8008ea:	ff 75 10             	pushl  0x10(%ebp)
  8008ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008f0:	50                   	push   %eax
  8008f1:	68 f7 02 80 00       	push   $0x8002f7
  8008f6:	e8 36 fa ff ff       	call   800331 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008fe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800904:	83 c4 10             	add    $0x10,%esp
}
  800907:	c9                   	leave  
  800908:	c3                   	ret    
		return -E_INVAL;
  800909:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80090e:	eb f7                	jmp    800907 <vsnprintf+0x45>

00800910 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800916:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800919:	50                   	push   %eax
  80091a:	ff 75 10             	pushl  0x10(%ebp)
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	ff 75 08             	pushl  0x8(%ebp)
  800923:	e8 9a ff ff ff       	call   8008c2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800930:	b8 00 00 00 00       	mov    $0x0,%eax
  800935:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800939:	74 05                	je     800940 <strlen+0x16>
		n++;
  80093b:	83 c0 01             	add    $0x1,%eax
  80093e:	eb f5                	jmp    800935 <strlen+0xb>
	return n;
}
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80094b:	ba 00 00 00 00       	mov    $0x0,%edx
  800950:	39 c2                	cmp    %eax,%edx
  800952:	74 0d                	je     800961 <strnlen+0x1f>
  800954:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800958:	74 05                	je     80095f <strnlen+0x1d>
		n++;
  80095a:	83 c2 01             	add    $0x1,%edx
  80095d:	eb f1                	jmp    800950 <strnlen+0xe>
  80095f:	89 d0                	mov    %edx,%eax
	return n;
}
  800961:	5d                   	pop    %ebp
  800962:	c3                   	ret    

00800963 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	53                   	push   %ebx
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80096d:	ba 00 00 00 00       	mov    $0x0,%edx
  800972:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800976:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800979:	83 c2 01             	add    $0x1,%edx
  80097c:	84 c9                	test   %cl,%cl
  80097e:	75 f2                	jne    800972 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800980:	5b                   	pop    %ebx
  800981:	5d                   	pop    %ebp
  800982:	c3                   	ret    

00800983 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	53                   	push   %ebx
  800987:	83 ec 10             	sub    $0x10,%esp
  80098a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80098d:	53                   	push   %ebx
  80098e:	e8 97 ff ff ff       	call   80092a <strlen>
  800993:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800996:	ff 75 0c             	pushl  0xc(%ebp)
  800999:	01 d8                	add    %ebx,%eax
  80099b:	50                   	push   %eax
  80099c:	e8 c2 ff ff ff       	call   800963 <strcpy>
	return dst;
}
  8009a1:	89 d8                	mov    %ebx,%eax
  8009a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009a6:	c9                   	leave  
  8009a7:	c3                   	ret    

008009a8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	56                   	push   %esi
  8009ac:	53                   	push   %ebx
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b3:	89 c6                	mov    %eax,%esi
  8009b5:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b8:	89 c2                	mov    %eax,%edx
  8009ba:	39 f2                	cmp    %esi,%edx
  8009bc:	74 11                	je     8009cf <strncpy+0x27>
		*dst++ = *src;
  8009be:	83 c2 01             	add    $0x1,%edx
  8009c1:	0f b6 19             	movzbl (%ecx),%ebx
  8009c4:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009c7:	80 fb 01             	cmp    $0x1,%bl
  8009ca:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009cd:	eb eb                	jmp    8009ba <strncpy+0x12>
	}
	return ret;
}
  8009cf:	5b                   	pop    %ebx
  8009d0:	5e                   	pop    %esi
  8009d1:	5d                   	pop    %ebp
  8009d2:	c3                   	ret    

008009d3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	56                   	push   %esi
  8009d7:	53                   	push   %ebx
  8009d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8009db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009de:	8b 55 10             	mov    0x10(%ebp),%edx
  8009e1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009e3:	85 d2                	test   %edx,%edx
  8009e5:	74 21                	je     800a08 <strlcpy+0x35>
  8009e7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009eb:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009ed:	39 c2                	cmp    %eax,%edx
  8009ef:	74 14                	je     800a05 <strlcpy+0x32>
  8009f1:	0f b6 19             	movzbl (%ecx),%ebx
  8009f4:	84 db                	test   %bl,%bl
  8009f6:	74 0b                	je     800a03 <strlcpy+0x30>
			*dst++ = *src++;
  8009f8:	83 c1 01             	add    $0x1,%ecx
  8009fb:	83 c2 01             	add    $0x1,%edx
  8009fe:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a01:	eb ea                	jmp    8009ed <strlcpy+0x1a>
  800a03:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a05:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a08:	29 f0                	sub    %esi,%eax
}
  800a0a:	5b                   	pop    %ebx
  800a0b:	5e                   	pop    %esi
  800a0c:	5d                   	pop    %ebp
  800a0d:	c3                   	ret    

00800a0e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a14:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a17:	0f b6 01             	movzbl (%ecx),%eax
  800a1a:	84 c0                	test   %al,%al
  800a1c:	74 0c                	je     800a2a <strcmp+0x1c>
  800a1e:	3a 02                	cmp    (%edx),%al
  800a20:	75 08                	jne    800a2a <strcmp+0x1c>
		p++, q++;
  800a22:	83 c1 01             	add    $0x1,%ecx
  800a25:	83 c2 01             	add    $0x1,%edx
  800a28:	eb ed                	jmp    800a17 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2a:	0f b6 c0             	movzbl %al,%eax
  800a2d:	0f b6 12             	movzbl (%edx),%edx
  800a30:	29 d0                	sub    %edx,%eax
}
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	53                   	push   %ebx
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3e:	89 c3                	mov    %eax,%ebx
  800a40:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a43:	eb 06                	jmp    800a4b <strncmp+0x17>
		n--, p++, q++;
  800a45:	83 c0 01             	add    $0x1,%eax
  800a48:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a4b:	39 d8                	cmp    %ebx,%eax
  800a4d:	74 16                	je     800a65 <strncmp+0x31>
  800a4f:	0f b6 08             	movzbl (%eax),%ecx
  800a52:	84 c9                	test   %cl,%cl
  800a54:	74 04                	je     800a5a <strncmp+0x26>
  800a56:	3a 0a                	cmp    (%edx),%cl
  800a58:	74 eb                	je     800a45 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a5a:	0f b6 00             	movzbl (%eax),%eax
  800a5d:	0f b6 12             	movzbl (%edx),%edx
  800a60:	29 d0                	sub    %edx,%eax
}
  800a62:	5b                   	pop    %ebx
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    
		return 0;
  800a65:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6a:	eb f6                	jmp    800a62 <strncmp+0x2e>

00800a6c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a76:	0f b6 10             	movzbl (%eax),%edx
  800a79:	84 d2                	test   %dl,%dl
  800a7b:	74 09                	je     800a86 <strchr+0x1a>
		if (*s == c)
  800a7d:	38 ca                	cmp    %cl,%dl
  800a7f:	74 0a                	je     800a8b <strchr+0x1f>
	for (; *s; s++)
  800a81:	83 c0 01             	add    $0x1,%eax
  800a84:	eb f0                	jmp    800a76 <strchr+0xa>
			return (char *) s;
	return 0;
  800a86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a8b:	5d                   	pop    %ebp
  800a8c:	c3                   	ret    

00800a8d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a97:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a9a:	38 ca                	cmp    %cl,%dl
  800a9c:	74 09                	je     800aa7 <strfind+0x1a>
  800a9e:	84 d2                	test   %dl,%dl
  800aa0:	74 05                	je     800aa7 <strfind+0x1a>
	for (; *s; s++)
  800aa2:	83 c0 01             	add    $0x1,%eax
  800aa5:	eb f0                	jmp    800a97 <strfind+0xa>
			break;
	return (char *) s;
}
  800aa7:	5d                   	pop    %ebp
  800aa8:	c3                   	ret    

00800aa9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	57                   	push   %edi
  800aad:	56                   	push   %esi
  800aae:	53                   	push   %ebx
  800aaf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ab2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ab5:	85 c9                	test   %ecx,%ecx
  800ab7:	74 31                	je     800aea <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ab9:	89 f8                	mov    %edi,%eax
  800abb:	09 c8                	or     %ecx,%eax
  800abd:	a8 03                	test   $0x3,%al
  800abf:	75 23                	jne    800ae4 <memset+0x3b>
		c &= 0xFF;
  800ac1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac5:	89 d3                	mov    %edx,%ebx
  800ac7:	c1 e3 08             	shl    $0x8,%ebx
  800aca:	89 d0                	mov    %edx,%eax
  800acc:	c1 e0 18             	shl    $0x18,%eax
  800acf:	89 d6                	mov    %edx,%esi
  800ad1:	c1 e6 10             	shl    $0x10,%esi
  800ad4:	09 f0                	or     %esi,%eax
  800ad6:	09 c2                	or     %eax,%edx
  800ad8:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ada:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800add:	89 d0                	mov    %edx,%eax
  800adf:	fc                   	cld    
  800ae0:	f3 ab                	rep stos %eax,%es:(%edi)
  800ae2:	eb 06                	jmp    800aea <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae7:	fc                   	cld    
  800ae8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aea:	89 f8                	mov    %edi,%eax
  800aec:	5b                   	pop    %ebx
  800aed:	5e                   	pop    %esi
  800aee:	5f                   	pop    %edi
  800aef:	5d                   	pop    %ebp
  800af0:	c3                   	ret    

00800af1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	57                   	push   %edi
  800af5:	56                   	push   %esi
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800afc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aff:	39 c6                	cmp    %eax,%esi
  800b01:	73 32                	jae    800b35 <memmove+0x44>
  800b03:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b06:	39 c2                	cmp    %eax,%edx
  800b08:	76 2b                	jbe    800b35 <memmove+0x44>
		s += n;
		d += n;
  800b0a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0d:	89 fe                	mov    %edi,%esi
  800b0f:	09 ce                	or     %ecx,%esi
  800b11:	09 d6                	or     %edx,%esi
  800b13:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b19:	75 0e                	jne    800b29 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b1b:	83 ef 04             	sub    $0x4,%edi
  800b1e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b21:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b24:	fd                   	std    
  800b25:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b27:	eb 09                	jmp    800b32 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b29:	83 ef 01             	sub    $0x1,%edi
  800b2c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b2f:	fd                   	std    
  800b30:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b32:	fc                   	cld    
  800b33:	eb 1a                	jmp    800b4f <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b35:	89 c2                	mov    %eax,%edx
  800b37:	09 ca                	or     %ecx,%edx
  800b39:	09 f2                	or     %esi,%edx
  800b3b:	f6 c2 03             	test   $0x3,%dl
  800b3e:	75 0a                	jne    800b4a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b40:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b43:	89 c7                	mov    %eax,%edi
  800b45:	fc                   	cld    
  800b46:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b48:	eb 05                	jmp    800b4f <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b4a:	89 c7                	mov    %eax,%edi
  800b4c:	fc                   	cld    
  800b4d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b4f:	5e                   	pop    %esi
  800b50:	5f                   	pop    %edi
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b59:	ff 75 10             	pushl  0x10(%ebp)
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	ff 75 08             	pushl  0x8(%ebp)
  800b62:	e8 8a ff ff ff       	call   800af1 <memmove>
}
  800b67:	c9                   	leave  
  800b68:	c3                   	ret    

00800b69 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	56                   	push   %esi
  800b6d:	53                   	push   %ebx
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b74:	89 c6                	mov    %eax,%esi
  800b76:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b79:	39 f0                	cmp    %esi,%eax
  800b7b:	74 1c                	je     800b99 <memcmp+0x30>
		if (*s1 != *s2)
  800b7d:	0f b6 08             	movzbl (%eax),%ecx
  800b80:	0f b6 1a             	movzbl (%edx),%ebx
  800b83:	38 d9                	cmp    %bl,%cl
  800b85:	75 08                	jne    800b8f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b87:	83 c0 01             	add    $0x1,%eax
  800b8a:	83 c2 01             	add    $0x1,%edx
  800b8d:	eb ea                	jmp    800b79 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b8f:	0f b6 c1             	movzbl %cl,%eax
  800b92:	0f b6 db             	movzbl %bl,%ebx
  800b95:	29 d8                	sub    %ebx,%eax
  800b97:	eb 05                	jmp    800b9e <memcmp+0x35>
	}

	return 0;
  800b99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b9e:	5b                   	pop    %ebx
  800b9f:	5e                   	pop    %esi
  800ba0:	5d                   	pop    %ebp
  800ba1:	c3                   	ret    

00800ba2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bab:	89 c2                	mov    %eax,%edx
  800bad:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bb0:	39 d0                	cmp    %edx,%eax
  800bb2:	73 09                	jae    800bbd <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb4:	38 08                	cmp    %cl,(%eax)
  800bb6:	74 05                	je     800bbd <memfind+0x1b>
	for (; s < ends; s++)
  800bb8:	83 c0 01             	add    $0x1,%eax
  800bbb:	eb f3                	jmp    800bb0 <memfind+0xe>
			break;
	return (void *) s;
}
  800bbd:	5d                   	pop    %ebp
  800bbe:	c3                   	ret    

00800bbf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	57                   	push   %edi
  800bc3:	56                   	push   %esi
  800bc4:	53                   	push   %ebx
  800bc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bcb:	eb 03                	jmp    800bd0 <strtol+0x11>
		s++;
  800bcd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bd0:	0f b6 01             	movzbl (%ecx),%eax
  800bd3:	3c 20                	cmp    $0x20,%al
  800bd5:	74 f6                	je     800bcd <strtol+0xe>
  800bd7:	3c 09                	cmp    $0x9,%al
  800bd9:	74 f2                	je     800bcd <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bdb:	3c 2b                	cmp    $0x2b,%al
  800bdd:	74 2a                	je     800c09 <strtol+0x4a>
	int neg = 0;
  800bdf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800be4:	3c 2d                	cmp    $0x2d,%al
  800be6:	74 2b                	je     800c13 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bee:	75 0f                	jne    800bff <strtol+0x40>
  800bf0:	80 39 30             	cmpb   $0x30,(%ecx)
  800bf3:	74 28                	je     800c1d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf5:	85 db                	test   %ebx,%ebx
  800bf7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bfc:	0f 44 d8             	cmove  %eax,%ebx
  800bff:	b8 00 00 00 00       	mov    $0x0,%eax
  800c04:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c07:	eb 50                	jmp    800c59 <strtol+0x9a>
		s++;
  800c09:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c0c:	bf 00 00 00 00       	mov    $0x0,%edi
  800c11:	eb d5                	jmp    800be8 <strtol+0x29>
		s++, neg = 1;
  800c13:	83 c1 01             	add    $0x1,%ecx
  800c16:	bf 01 00 00 00       	mov    $0x1,%edi
  800c1b:	eb cb                	jmp    800be8 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c1d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c21:	74 0e                	je     800c31 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c23:	85 db                	test   %ebx,%ebx
  800c25:	75 d8                	jne    800bff <strtol+0x40>
		s++, base = 8;
  800c27:	83 c1 01             	add    $0x1,%ecx
  800c2a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c2f:	eb ce                	jmp    800bff <strtol+0x40>
		s += 2, base = 16;
  800c31:	83 c1 02             	add    $0x2,%ecx
  800c34:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c39:	eb c4                	jmp    800bff <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c3b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c3e:	89 f3                	mov    %esi,%ebx
  800c40:	80 fb 19             	cmp    $0x19,%bl
  800c43:	77 29                	ja     800c6e <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c45:	0f be d2             	movsbl %dl,%edx
  800c48:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c4b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c4e:	7d 30                	jge    800c80 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c50:	83 c1 01             	add    $0x1,%ecx
  800c53:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c57:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c59:	0f b6 11             	movzbl (%ecx),%edx
  800c5c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c5f:	89 f3                	mov    %esi,%ebx
  800c61:	80 fb 09             	cmp    $0x9,%bl
  800c64:	77 d5                	ja     800c3b <strtol+0x7c>
			dig = *s - '0';
  800c66:	0f be d2             	movsbl %dl,%edx
  800c69:	83 ea 30             	sub    $0x30,%edx
  800c6c:	eb dd                	jmp    800c4b <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c6e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c71:	89 f3                	mov    %esi,%ebx
  800c73:	80 fb 19             	cmp    $0x19,%bl
  800c76:	77 08                	ja     800c80 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c78:	0f be d2             	movsbl %dl,%edx
  800c7b:	83 ea 37             	sub    $0x37,%edx
  800c7e:	eb cb                	jmp    800c4b <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c84:	74 05                	je     800c8b <strtol+0xcc>
		*endptr = (char *) s;
  800c86:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c89:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c8b:	89 c2                	mov    %eax,%edx
  800c8d:	f7 da                	neg    %edx
  800c8f:	85 ff                	test   %edi,%edi
  800c91:	0f 45 c2             	cmovne %edx,%eax
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	57                   	push   %edi
  800c9d:	56                   	push   %esi
  800c9e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caa:	89 c3                	mov    %eax,%ebx
  800cac:	89 c7                	mov    %eax,%edi
  800cae:	89 c6                	mov    %eax,%esi
  800cb0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb2:	5b                   	pop    %ebx
  800cb3:	5e                   	pop    %esi
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	57                   	push   %edi
  800cbb:	56                   	push   %esi
  800cbc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc2:	b8 01 00 00 00       	mov    $0x1,%eax
  800cc7:	89 d1                	mov    %edx,%ecx
  800cc9:	89 d3                	mov    %edx,%ebx
  800ccb:	89 d7                	mov    %edx,%edi
  800ccd:	89 d6                	mov    %edx,%esi
  800ccf:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5f                   	pop    %edi
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    

00800cd6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	57                   	push   %edi
  800cda:	56                   	push   %esi
  800cdb:	53                   	push   %ebx
  800cdc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce7:	b8 03 00 00 00       	mov    $0x3,%eax
  800cec:	89 cb                	mov    %ecx,%ebx
  800cee:	89 cf                	mov    %ecx,%edi
  800cf0:	89 ce                	mov    %ecx,%esi
  800cf2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf4:	85 c0                	test   %eax,%eax
  800cf6:	7f 08                	jg     800d00 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d00:	83 ec 0c             	sub    $0xc,%esp
  800d03:	50                   	push   %eax
  800d04:	6a 03                	push   $0x3
  800d06:	68 a8 29 80 00       	push   $0x8029a8
  800d0b:	6a 43                	push   $0x43
  800d0d:	68 c5 29 80 00       	push   $0x8029c5
  800d12:	e8 89 14 00 00       	call   8021a0 <_panic>

00800d17 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d22:	b8 02 00 00 00       	mov    $0x2,%eax
  800d27:	89 d1                	mov    %edx,%ecx
  800d29:	89 d3                	mov    %edx,%ebx
  800d2b:	89 d7                	mov    %edx,%edi
  800d2d:	89 d6                	mov    %edx,%esi
  800d2f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5f                   	pop    %edi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    

00800d36 <sys_yield>:

void
sys_yield(void)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	57                   	push   %edi
  800d3a:	56                   	push   %esi
  800d3b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d41:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d46:	89 d1                	mov    %edx,%ecx
  800d48:	89 d3                	mov    %edx,%ebx
  800d4a:	89 d7                	mov    %edx,%edi
  800d4c:	89 d6                	mov    %edx,%esi
  800d4e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    

00800d55 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	57                   	push   %edi
  800d59:	56                   	push   %esi
  800d5a:	53                   	push   %ebx
  800d5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5e:	be 00 00 00 00       	mov    $0x0,%esi
  800d63:	8b 55 08             	mov    0x8(%ebp),%edx
  800d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d69:	b8 04 00 00 00       	mov    $0x4,%eax
  800d6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d71:	89 f7                	mov    %esi,%edi
  800d73:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d75:	85 c0                	test   %eax,%eax
  800d77:	7f 08                	jg     800d81 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7c:	5b                   	pop    %ebx
  800d7d:	5e                   	pop    %esi
  800d7e:	5f                   	pop    %edi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d81:	83 ec 0c             	sub    $0xc,%esp
  800d84:	50                   	push   %eax
  800d85:	6a 04                	push   $0x4
  800d87:	68 a8 29 80 00       	push   $0x8029a8
  800d8c:	6a 43                	push   $0x43
  800d8e:	68 c5 29 80 00       	push   $0x8029c5
  800d93:	e8 08 14 00 00       	call   8021a0 <_panic>

00800d98 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	57                   	push   %edi
  800d9c:	56                   	push   %esi
  800d9d:	53                   	push   %ebx
  800d9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da1:	8b 55 08             	mov    0x8(%ebp),%edx
  800da4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da7:	b8 05 00 00 00       	mov    $0x5,%eax
  800dac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800daf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db2:	8b 75 18             	mov    0x18(%ebp),%esi
  800db5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db7:	85 c0                	test   %eax,%eax
  800db9:	7f 08                	jg     800dc3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc3:	83 ec 0c             	sub    $0xc,%esp
  800dc6:	50                   	push   %eax
  800dc7:	6a 05                	push   $0x5
  800dc9:	68 a8 29 80 00       	push   $0x8029a8
  800dce:	6a 43                	push   $0x43
  800dd0:	68 c5 29 80 00       	push   $0x8029c5
  800dd5:	e8 c6 13 00 00       	call   8021a0 <_panic>

00800dda <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	57                   	push   %edi
  800dde:	56                   	push   %esi
  800ddf:	53                   	push   %ebx
  800de0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dee:	b8 06 00 00 00       	mov    $0x6,%eax
  800df3:	89 df                	mov    %ebx,%edi
  800df5:	89 de                	mov    %ebx,%esi
  800df7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	7f 08                	jg     800e05 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e00:	5b                   	pop    %ebx
  800e01:	5e                   	pop    %esi
  800e02:	5f                   	pop    %edi
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e05:	83 ec 0c             	sub    $0xc,%esp
  800e08:	50                   	push   %eax
  800e09:	6a 06                	push   $0x6
  800e0b:	68 a8 29 80 00       	push   $0x8029a8
  800e10:	6a 43                	push   $0x43
  800e12:	68 c5 29 80 00       	push   $0x8029c5
  800e17:	e8 84 13 00 00       	call   8021a0 <_panic>

00800e1c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	57                   	push   %edi
  800e20:	56                   	push   %esi
  800e21:	53                   	push   %ebx
  800e22:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e25:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e30:	b8 08 00 00 00       	mov    $0x8,%eax
  800e35:	89 df                	mov    %ebx,%edi
  800e37:	89 de                	mov    %ebx,%esi
  800e39:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3b:	85 c0                	test   %eax,%eax
  800e3d:	7f 08                	jg     800e47 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e42:	5b                   	pop    %ebx
  800e43:	5e                   	pop    %esi
  800e44:	5f                   	pop    %edi
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e47:	83 ec 0c             	sub    $0xc,%esp
  800e4a:	50                   	push   %eax
  800e4b:	6a 08                	push   $0x8
  800e4d:	68 a8 29 80 00       	push   $0x8029a8
  800e52:	6a 43                	push   $0x43
  800e54:	68 c5 29 80 00       	push   $0x8029c5
  800e59:	e8 42 13 00 00       	call   8021a0 <_panic>

00800e5e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	57                   	push   %edi
  800e62:	56                   	push   %esi
  800e63:	53                   	push   %ebx
  800e64:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e67:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e72:	b8 09 00 00 00       	mov    $0x9,%eax
  800e77:	89 df                	mov    %ebx,%edi
  800e79:	89 de                	mov    %ebx,%esi
  800e7b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7d:	85 c0                	test   %eax,%eax
  800e7f:	7f 08                	jg     800e89 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e84:	5b                   	pop    %ebx
  800e85:	5e                   	pop    %esi
  800e86:	5f                   	pop    %edi
  800e87:	5d                   	pop    %ebp
  800e88:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e89:	83 ec 0c             	sub    $0xc,%esp
  800e8c:	50                   	push   %eax
  800e8d:	6a 09                	push   $0x9
  800e8f:	68 a8 29 80 00       	push   $0x8029a8
  800e94:	6a 43                	push   $0x43
  800e96:	68 c5 29 80 00       	push   $0x8029c5
  800e9b:	e8 00 13 00 00       	call   8021a0 <_panic>

00800ea0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	57                   	push   %edi
  800ea4:	56                   	push   %esi
  800ea5:	53                   	push   %ebx
  800ea6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eae:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb9:	89 df                	mov    %ebx,%edi
  800ebb:	89 de                	mov    %ebx,%esi
  800ebd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	7f 08                	jg     800ecb <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecb:	83 ec 0c             	sub    $0xc,%esp
  800ece:	50                   	push   %eax
  800ecf:	6a 0a                	push   $0xa
  800ed1:	68 a8 29 80 00       	push   $0x8029a8
  800ed6:	6a 43                	push   $0x43
  800ed8:	68 c5 29 80 00       	push   $0x8029c5
  800edd:	e8 be 12 00 00       	call   8021a0 <_panic>

00800ee2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	57                   	push   %edi
  800ee6:	56                   	push   %esi
  800ee7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eee:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef3:	be 00 00 00 00       	mov    $0x0,%esi
  800ef8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800efb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800efe:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5f                   	pop    %edi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    

00800f05 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	57                   	push   %edi
  800f09:	56                   	push   %esi
  800f0a:	53                   	push   %ebx
  800f0b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f13:	8b 55 08             	mov    0x8(%ebp),%edx
  800f16:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f1b:	89 cb                	mov    %ecx,%ebx
  800f1d:	89 cf                	mov    %ecx,%edi
  800f1f:	89 ce                	mov    %ecx,%esi
  800f21:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f23:	85 c0                	test   %eax,%eax
  800f25:	7f 08                	jg     800f2f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2a:	5b                   	pop    %ebx
  800f2b:	5e                   	pop    %esi
  800f2c:	5f                   	pop    %edi
  800f2d:	5d                   	pop    %ebp
  800f2e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2f:	83 ec 0c             	sub    $0xc,%esp
  800f32:	50                   	push   %eax
  800f33:	6a 0d                	push   $0xd
  800f35:	68 a8 29 80 00       	push   $0x8029a8
  800f3a:	6a 43                	push   $0x43
  800f3c:	68 c5 29 80 00       	push   $0x8029c5
  800f41:	e8 5a 12 00 00       	call   8021a0 <_panic>

00800f46 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	57                   	push   %edi
  800f4a:	56                   	push   %esi
  800f4b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f51:	8b 55 08             	mov    0x8(%ebp),%edx
  800f54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f57:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f5c:	89 df                	mov    %ebx,%edi
  800f5e:	89 de                	mov    %ebx,%esi
  800f60:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f62:	5b                   	pop    %ebx
  800f63:	5e                   	pop    %esi
  800f64:	5f                   	pop    %edi
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    

00800f67 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	57                   	push   %edi
  800f6b:	56                   	push   %esi
  800f6c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f72:	8b 55 08             	mov    0x8(%ebp),%edx
  800f75:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f7a:	89 cb                	mov    %ecx,%ebx
  800f7c:	89 cf                	mov    %ecx,%edi
  800f7e:	89 ce                	mov    %ecx,%esi
  800f80:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f82:	5b                   	pop    %ebx
  800f83:	5e                   	pop    %esi
  800f84:	5f                   	pop    %edi
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    

00800f87 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	57                   	push   %edi
  800f8b:	56                   	push   %esi
  800f8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f92:	b8 10 00 00 00       	mov    $0x10,%eax
  800f97:	89 d1                	mov    %edx,%ecx
  800f99:	89 d3                	mov    %edx,%ebx
  800f9b:	89 d7                	mov    %edx,%edi
  800f9d:	89 d6                	mov    %edx,%esi
  800f9f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5f                   	pop    %edi
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    

00800fa6 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	57                   	push   %edi
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb7:	b8 11 00 00 00       	mov    $0x11,%eax
  800fbc:	89 df                	mov    %ebx,%edi
  800fbe:	89 de                	mov    %ebx,%esi
  800fc0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fc2:	5b                   	pop    %ebx
  800fc3:	5e                   	pop    %esi
  800fc4:	5f                   	pop    %edi
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	57                   	push   %edi
  800fcb:	56                   	push   %esi
  800fcc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd8:	b8 12 00 00 00       	mov    $0x12,%eax
  800fdd:	89 df                	mov    %ebx,%edi
  800fdf:	89 de                	mov    %ebx,%esi
  800fe1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fe3:	5b                   	pop    %ebx
  800fe4:	5e                   	pop    %esi
  800fe5:	5f                   	pop    %edi
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    

00800fe8 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	57                   	push   %edi
  800fec:	56                   	push   %esi
  800fed:	53                   	push   %ebx
  800fee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffc:	b8 13 00 00 00       	mov    $0x13,%eax
  801001:	89 df                	mov    %ebx,%edi
  801003:	89 de                	mov    %ebx,%esi
  801005:	cd 30                	int    $0x30
	if(check && ret > 0)
  801007:	85 c0                	test   %eax,%eax
  801009:	7f 08                	jg     801013 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80100b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100e:	5b                   	pop    %ebx
  80100f:	5e                   	pop    %esi
  801010:	5f                   	pop    %edi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801013:	83 ec 0c             	sub    $0xc,%esp
  801016:	50                   	push   %eax
  801017:	6a 13                	push   $0x13
  801019:	68 a8 29 80 00       	push   $0x8029a8
  80101e:	6a 43                	push   $0x43
  801020:	68 c5 29 80 00       	push   $0x8029c5
  801025:	e8 76 11 00 00       	call   8021a0 <_panic>

0080102a <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	57                   	push   %edi
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801030:	b9 00 00 00 00       	mov    $0x0,%ecx
  801035:	8b 55 08             	mov    0x8(%ebp),%edx
  801038:	b8 14 00 00 00       	mov    $0x14,%eax
  80103d:	89 cb                	mov    %ecx,%ebx
  80103f:	89 cf                	mov    %ecx,%edi
  801041:	89 ce                	mov    %ecx,%esi
  801043:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801045:	5b                   	pop    %ebx
  801046:	5e                   	pop    %esi
  801047:	5f                   	pop    %edi
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    

0080104a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	05 00 00 00 30       	add    $0x30000000,%eax
  801055:	c1 e8 0c             	shr    $0xc,%eax
}
  801058:	5d                   	pop    %ebp
  801059:	c3                   	ret    

0080105a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801065:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80106a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    

00801071 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801079:	89 c2                	mov    %eax,%edx
  80107b:	c1 ea 16             	shr    $0x16,%edx
  80107e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801085:	f6 c2 01             	test   $0x1,%dl
  801088:	74 2d                	je     8010b7 <fd_alloc+0x46>
  80108a:	89 c2                	mov    %eax,%edx
  80108c:	c1 ea 0c             	shr    $0xc,%edx
  80108f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801096:	f6 c2 01             	test   $0x1,%dl
  801099:	74 1c                	je     8010b7 <fd_alloc+0x46>
  80109b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010a0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010a5:	75 d2                	jne    801079 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010b0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010b5:	eb 0a                	jmp    8010c1 <fd_alloc+0x50>
			*fd_store = fd;
  8010b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ba:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c1:	5d                   	pop    %ebp
  8010c2:	c3                   	ret    

008010c3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010c9:	83 f8 1f             	cmp    $0x1f,%eax
  8010cc:	77 30                	ja     8010fe <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010ce:	c1 e0 0c             	shl    $0xc,%eax
  8010d1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010d6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010dc:	f6 c2 01             	test   $0x1,%dl
  8010df:	74 24                	je     801105 <fd_lookup+0x42>
  8010e1:	89 c2                	mov    %eax,%edx
  8010e3:	c1 ea 0c             	shr    $0xc,%edx
  8010e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010ed:	f6 c2 01             	test   $0x1,%dl
  8010f0:	74 1a                	je     80110c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f5:	89 02                	mov    %eax,(%edx)
	return 0;
  8010f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010fc:	5d                   	pop    %ebp
  8010fd:	c3                   	ret    
		return -E_INVAL;
  8010fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801103:	eb f7                	jmp    8010fc <fd_lookup+0x39>
		return -E_INVAL;
  801105:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80110a:	eb f0                	jmp    8010fc <fd_lookup+0x39>
  80110c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801111:	eb e9                	jmp    8010fc <fd_lookup+0x39>

00801113 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	83 ec 08             	sub    $0x8,%esp
  801119:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80111c:	ba 00 00 00 00       	mov    $0x0,%edx
  801121:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801126:	39 08                	cmp    %ecx,(%eax)
  801128:	74 38                	je     801162 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80112a:	83 c2 01             	add    $0x1,%edx
  80112d:	8b 04 95 50 2a 80 00 	mov    0x802a50(,%edx,4),%eax
  801134:	85 c0                	test   %eax,%eax
  801136:	75 ee                	jne    801126 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801138:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80113d:	8b 40 48             	mov    0x48(%eax),%eax
  801140:	83 ec 04             	sub    $0x4,%esp
  801143:	51                   	push   %ecx
  801144:	50                   	push   %eax
  801145:	68 d4 29 80 00       	push   $0x8029d4
  80114a:	e8 b5 f0 ff ff       	call   800204 <cprintf>
	*dev = 0;
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801158:	83 c4 10             	add    $0x10,%esp
  80115b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801160:	c9                   	leave  
  801161:	c3                   	ret    
			*dev = devtab[i];
  801162:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801165:	89 01                	mov    %eax,(%ecx)
			return 0;
  801167:	b8 00 00 00 00       	mov    $0x0,%eax
  80116c:	eb f2                	jmp    801160 <dev_lookup+0x4d>

0080116e <fd_close>:
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	57                   	push   %edi
  801172:	56                   	push   %esi
  801173:	53                   	push   %ebx
  801174:	83 ec 24             	sub    $0x24,%esp
  801177:	8b 75 08             	mov    0x8(%ebp),%esi
  80117a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80117d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801180:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801181:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801187:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80118a:	50                   	push   %eax
  80118b:	e8 33 ff ff ff       	call   8010c3 <fd_lookup>
  801190:	89 c3                	mov    %eax,%ebx
  801192:	83 c4 10             	add    $0x10,%esp
  801195:	85 c0                	test   %eax,%eax
  801197:	78 05                	js     80119e <fd_close+0x30>
	    || fd != fd2)
  801199:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80119c:	74 16                	je     8011b4 <fd_close+0x46>
		return (must_exist ? r : 0);
  80119e:	89 f8                	mov    %edi,%eax
  8011a0:	84 c0                	test   %al,%al
  8011a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a7:	0f 44 d8             	cmove  %eax,%ebx
}
  8011aa:	89 d8                	mov    %ebx,%eax
  8011ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011af:	5b                   	pop    %ebx
  8011b0:	5e                   	pop    %esi
  8011b1:	5f                   	pop    %edi
  8011b2:	5d                   	pop    %ebp
  8011b3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011b4:	83 ec 08             	sub    $0x8,%esp
  8011b7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011ba:	50                   	push   %eax
  8011bb:	ff 36                	pushl  (%esi)
  8011bd:	e8 51 ff ff ff       	call   801113 <dev_lookup>
  8011c2:	89 c3                	mov    %eax,%ebx
  8011c4:	83 c4 10             	add    $0x10,%esp
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	78 1a                	js     8011e5 <fd_close+0x77>
		if (dev->dev_close)
  8011cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011ce:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	74 0b                	je     8011e5 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011da:	83 ec 0c             	sub    $0xc,%esp
  8011dd:	56                   	push   %esi
  8011de:	ff d0                	call   *%eax
  8011e0:	89 c3                	mov    %eax,%ebx
  8011e2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011e5:	83 ec 08             	sub    $0x8,%esp
  8011e8:	56                   	push   %esi
  8011e9:	6a 00                	push   $0x0
  8011eb:	e8 ea fb ff ff       	call   800dda <sys_page_unmap>
	return r;
  8011f0:	83 c4 10             	add    $0x10,%esp
  8011f3:	eb b5                	jmp    8011aa <fd_close+0x3c>

008011f5 <close>:

int
close(int fdnum)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011fe:	50                   	push   %eax
  8011ff:	ff 75 08             	pushl  0x8(%ebp)
  801202:	e8 bc fe ff ff       	call   8010c3 <fd_lookup>
  801207:	83 c4 10             	add    $0x10,%esp
  80120a:	85 c0                	test   %eax,%eax
  80120c:	79 02                	jns    801210 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80120e:	c9                   	leave  
  80120f:	c3                   	ret    
		return fd_close(fd, 1);
  801210:	83 ec 08             	sub    $0x8,%esp
  801213:	6a 01                	push   $0x1
  801215:	ff 75 f4             	pushl  -0xc(%ebp)
  801218:	e8 51 ff ff ff       	call   80116e <fd_close>
  80121d:	83 c4 10             	add    $0x10,%esp
  801220:	eb ec                	jmp    80120e <close+0x19>

00801222 <close_all>:

void
close_all(void)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	53                   	push   %ebx
  801226:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801229:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80122e:	83 ec 0c             	sub    $0xc,%esp
  801231:	53                   	push   %ebx
  801232:	e8 be ff ff ff       	call   8011f5 <close>
	for (i = 0; i < MAXFD; i++)
  801237:	83 c3 01             	add    $0x1,%ebx
  80123a:	83 c4 10             	add    $0x10,%esp
  80123d:	83 fb 20             	cmp    $0x20,%ebx
  801240:	75 ec                	jne    80122e <close_all+0xc>
}
  801242:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801245:	c9                   	leave  
  801246:	c3                   	ret    

00801247 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
  80124a:	57                   	push   %edi
  80124b:	56                   	push   %esi
  80124c:	53                   	push   %ebx
  80124d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801250:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801253:	50                   	push   %eax
  801254:	ff 75 08             	pushl  0x8(%ebp)
  801257:	e8 67 fe ff ff       	call   8010c3 <fd_lookup>
  80125c:	89 c3                	mov    %eax,%ebx
  80125e:	83 c4 10             	add    $0x10,%esp
  801261:	85 c0                	test   %eax,%eax
  801263:	0f 88 81 00 00 00    	js     8012ea <dup+0xa3>
		return r;
	close(newfdnum);
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	ff 75 0c             	pushl  0xc(%ebp)
  80126f:	e8 81 ff ff ff       	call   8011f5 <close>

	newfd = INDEX2FD(newfdnum);
  801274:	8b 75 0c             	mov    0xc(%ebp),%esi
  801277:	c1 e6 0c             	shl    $0xc,%esi
  80127a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801280:	83 c4 04             	add    $0x4,%esp
  801283:	ff 75 e4             	pushl  -0x1c(%ebp)
  801286:	e8 cf fd ff ff       	call   80105a <fd2data>
  80128b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80128d:	89 34 24             	mov    %esi,(%esp)
  801290:	e8 c5 fd ff ff       	call   80105a <fd2data>
  801295:	83 c4 10             	add    $0x10,%esp
  801298:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80129a:	89 d8                	mov    %ebx,%eax
  80129c:	c1 e8 16             	shr    $0x16,%eax
  80129f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012a6:	a8 01                	test   $0x1,%al
  8012a8:	74 11                	je     8012bb <dup+0x74>
  8012aa:	89 d8                	mov    %ebx,%eax
  8012ac:	c1 e8 0c             	shr    $0xc,%eax
  8012af:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012b6:	f6 c2 01             	test   $0x1,%dl
  8012b9:	75 39                	jne    8012f4 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012be:	89 d0                	mov    %edx,%eax
  8012c0:	c1 e8 0c             	shr    $0xc,%eax
  8012c3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012ca:	83 ec 0c             	sub    $0xc,%esp
  8012cd:	25 07 0e 00 00       	and    $0xe07,%eax
  8012d2:	50                   	push   %eax
  8012d3:	56                   	push   %esi
  8012d4:	6a 00                	push   $0x0
  8012d6:	52                   	push   %edx
  8012d7:	6a 00                	push   $0x0
  8012d9:	e8 ba fa ff ff       	call   800d98 <sys_page_map>
  8012de:	89 c3                	mov    %eax,%ebx
  8012e0:	83 c4 20             	add    $0x20,%esp
  8012e3:	85 c0                	test   %eax,%eax
  8012e5:	78 31                	js     801318 <dup+0xd1>
		goto err;

	return newfdnum;
  8012e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012ea:	89 d8                	mov    %ebx,%eax
  8012ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ef:	5b                   	pop    %ebx
  8012f0:	5e                   	pop    %esi
  8012f1:	5f                   	pop    %edi
  8012f2:	5d                   	pop    %ebp
  8012f3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012f4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012fb:	83 ec 0c             	sub    $0xc,%esp
  8012fe:	25 07 0e 00 00       	and    $0xe07,%eax
  801303:	50                   	push   %eax
  801304:	57                   	push   %edi
  801305:	6a 00                	push   $0x0
  801307:	53                   	push   %ebx
  801308:	6a 00                	push   $0x0
  80130a:	e8 89 fa ff ff       	call   800d98 <sys_page_map>
  80130f:	89 c3                	mov    %eax,%ebx
  801311:	83 c4 20             	add    $0x20,%esp
  801314:	85 c0                	test   %eax,%eax
  801316:	79 a3                	jns    8012bb <dup+0x74>
	sys_page_unmap(0, newfd);
  801318:	83 ec 08             	sub    $0x8,%esp
  80131b:	56                   	push   %esi
  80131c:	6a 00                	push   $0x0
  80131e:	e8 b7 fa ff ff       	call   800dda <sys_page_unmap>
	sys_page_unmap(0, nva);
  801323:	83 c4 08             	add    $0x8,%esp
  801326:	57                   	push   %edi
  801327:	6a 00                	push   $0x0
  801329:	e8 ac fa ff ff       	call   800dda <sys_page_unmap>
	return r;
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	eb b7                	jmp    8012ea <dup+0xa3>

00801333 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	53                   	push   %ebx
  801337:	83 ec 1c             	sub    $0x1c,%esp
  80133a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80133d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801340:	50                   	push   %eax
  801341:	53                   	push   %ebx
  801342:	e8 7c fd ff ff       	call   8010c3 <fd_lookup>
  801347:	83 c4 10             	add    $0x10,%esp
  80134a:	85 c0                	test   %eax,%eax
  80134c:	78 3f                	js     80138d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80134e:	83 ec 08             	sub    $0x8,%esp
  801351:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801354:	50                   	push   %eax
  801355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801358:	ff 30                	pushl  (%eax)
  80135a:	e8 b4 fd ff ff       	call   801113 <dev_lookup>
  80135f:	83 c4 10             	add    $0x10,%esp
  801362:	85 c0                	test   %eax,%eax
  801364:	78 27                	js     80138d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801366:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801369:	8b 42 08             	mov    0x8(%edx),%eax
  80136c:	83 e0 03             	and    $0x3,%eax
  80136f:	83 f8 01             	cmp    $0x1,%eax
  801372:	74 1e                	je     801392 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801377:	8b 40 08             	mov    0x8(%eax),%eax
  80137a:	85 c0                	test   %eax,%eax
  80137c:	74 35                	je     8013b3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80137e:	83 ec 04             	sub    $0x4,%esp
  801381:	ff 75 10             	pushl  0x10(%ebp)
  801384:	ff 75 0c             	pushl  0xc(%ebp)
  801387:	52                   	push   %edx
  801388:	ff d0                	call   *%eax
  80138a:	83 c4 10             	add    $0x10,%esp
}
  80138d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801390:	c9                   	leave  
  801391:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801392:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801397:	8b 40 48             	mov    0x48(%eax),%eax
  80139a:	83 ec 04             	sub    $0x4,%esp
  80139d:	53                   	push   %ebx
  80139e:	50                   	push   %eax
  80139f:	68 15 2a 80 00       	push   $0x802a15
  8013a4:	e8 5b ee ff ff       	call   800204 <cprintf>
		return -E_INVAL;
  8013a9:	83 c4 10             	add    $0x10,%esp
  8013ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b1:	eb da                	jmp    80138d <read+0x5a>
		return -E_NOT_SUPP;
  8013b3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013b8:	eb d3                	jmp    80138d <read+0x5a>

008013ba <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	57                   	push   %edi
  8013be:	56                   	push   %esi
  8013bf:	53                   	push   %ebx
  8013c0:	83 ec 0c             	sub    $0xc,%esp
  8013c3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013c6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ce:	39 f3                	cmp    %esi,%ebx
  8013d0:	73 23                	jae    8013f5 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013d2:	83 ec 04             	sub    $0x4,%esp
  8013d5:	89 f0                	mov    %esi,%eax
  8013d7:	29 d8                	sub    %ebx,%eax
  8013d9:	50                   	push   %eax
  8013da:	89 d8                	mov    %ebx,%eax
  8013dc:	03 45 0c             	add    0xc(%ebp),%eax
  8013df:	50                   	push   %eax
  8013e0:	57                   	push   %edi
  8013e1:	e8 4d ff ff ff       	call   801333 <read>
		if (m < 0)
  8013e6:	83 c4 10             	add    $0x10,%esp
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	78 06                	js     8013f3 <readn+0x39>
			return m;
		if (m == 0)
  8013ed:	74 06                	je     8013f5 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013ef:	01 c3                	add    %eax,%ebx
  8013f1:	eb db                	jmp    8013ce <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013f3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013f5:	89 d8                	mov    %ebx,%eax
  8013f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013fa:	5b                   	pop    %ebx
  8013fb:	5e                   	pop    %esi
  8013fc:	5f                   	pop    %edi
  8013fd:	5d                   	pop    %ebp
  8013fe:	c3                   	ret    

008013ff <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	53                   	push   %ebx
  801403:	83 ec 1c             	sub    $0x1c,%esp
  801406:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801409:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80140c:	50                   	push   %eax
  80140d:	53                   	push   %ebx
  80140e:	e8 b0 fc ff ff       	call   8010c3 <fd_lookup>
  801413:	83 c4 10             	add    $0x10,%esp
  801416:	85 c0                	test   %eax,%eax
  801418:	78 3a                	js     801454 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80141a:	83 ec 08             	sub    $0x8,%esp
  80141d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801420:	50                   	push   %eax
  801421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801424:	ff 30                	pushl  (%eax)
  801426:	e8 e8 fc ff ff       	call   801113 <dev_lookup>
  80142b:	83 c4 10             	add    $0x10,%esp
  80142e:	85 c0                	test   %eax,%eax
  801430:	78 22                	js     801454 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801435:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801439:	74 1e                	je     801459 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80143b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143e:	8b 52 0c             	mov    0xc(%edx),%edx
  801441:	85 d2                	test   %edx,%edx
  801443:	74 35                	je     80147a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801445:	83 ec 04             	sub    $0x4,%esp
  801448:	ff 75 10             	pushl  0x10(%ebp)
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	50                   	push   %eax
  80144f:	ff d2                	call   *%edx
  801451:	83 c4 10             	add    $0x10,%esp
}
  801454:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801457:	c9                   	leave  
  801458:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801459:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80145e:	8b 40 48             	mov    0x48(%eax),%eax
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	53                   	push   %ebx
  801465:	50                   	push   %eax
  801466:	68 31 2a 80 00       	push   $0x802a31
  80146b:	e8 94 ed ff ff       	call   800204 <cprintf>
		return -E_INVAL;
  801470:	83 c4 10             	add    $0x10,%esp
  801473:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801478:	eb da                	jmp    801454 <write+0x55>
		return -E_NOT_SUPP;
  80147a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80147f:	eb d3                	jmp    801454 <write+0x55>

00801481 <seek>:

int
seek(int fdnum, off_t offset)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801487:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148a:	50                   	push   %eax
  80148b:	ff 75 08             	pushl  0x8(%ebp)
  80148e:	e8 30 fc ff ff       	call   8010c3 <fd_lookup>
  801493:	83 c4 10             	add    $0x10,%esp
  801496:	85 c0                	test   %eax,%eax
  801498:	78 0e                	js     8014a8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80149a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	53                   	push   %ebx
  8014ae:	83 ec 1c             	sub    $0x1c,%esp
  8014b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b7:	50                   	push   %eax
  8014b8:	53                   	push   %ebx
  8014b9:	e8 05 fc ff ff       	call   8010c3 <fd_lookup>
  8014be:	83 c4 10             	add    $0x10,%esp
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	78 37                	js     8014fc <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c5:	83 ec 08             	sub    $0x8,%esp
  8014c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014cb:	50                   	push   %eax
  8014cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cf:	ff 30                	pushl  (%eax)
  8014d1:	e8 3d fc ff ff       	call   801113 <dev_lookup>
  8014d6:	83 c4 10             	add    $0x10,%esp
  8014d9:	85 c0                	test   %eax,%eax
  8014db:	78 1f                	js     8014fc <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014e4:	74 1b                	je     801501 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014e9:	8b 52 18             	mov    0x18(%edx),%edx
  8014ec:	85 d2                	test   %edx,%edx
  8014ee:	74 32                	je     801522 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014f0:	83 ec 08             	sub    $0x8,%esp
  8014f3:	ff 75 0c             	pushl  0xc(%ebp)
  8014f6:	50                   	push   %eax
  8014f7:	ff d2                	call   *%edx
  8014f9:	83 c4 10             	add    $0x10,%esp
}
  8014fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    
			thisenv->env_id, fdnum);
  801501:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801506:	8b 40 48             	mov    0x48(%eax),%eax
  801509:	83 ec 04             	sub    $0x4,%esp
  80150c:	53                   	push   %ebx
  80150d:	50                   	push   %eax
  80150e:	68 f4 29 80 00       	push   $0x8029f4
  801513:	e8 ec ec ff ff       	call   800204 <cprintf>
		return -E_INVAL;
  801518:	83 c4 10             	add    $0x10,%esp
  80151b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801520:	eb da                	jmp    8014fc <ftruncate+0x52>
		return -E_NOT_SUPP;
  801522:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801527:	eb d3                	jmp    8014fc <ftruncate+0x52>

00801529 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	53                   	push   %ebx
  80152d:	83 ec 1c             	sub    $0x1c,%esp
  801530:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801533:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801536:	50                   	push   %eax
  801537:	ff 75 08             	pushl  0x8(%ebp)
  80153a:	e8 84 fb ff ff       	call   8010c3 <fd_lookup>
  80153f:	83 c4 10             	add    $0x10,%esp
  801542:	85 c0                	test   %eax,%eax
  801544:	78 4b                	js     801591 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801546:	83 ec 08             	sub    $0x8,%esp
  801549:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154c:	50                   	push   %eax
  80154d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801550:	ff 30                	pushl  (%eax)
  801552:	e8 bc fb ff ff       	call   801113 <dev_lookup>
  801557:	83 c4 10             	add    $0x10,%esp
  80155a:	85 c0                	test   %eax,%eax
  80155c:	78 33                	js     801591 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80155e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801561:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801565:	74 2f                	je     801596 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801567:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80156a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801571:	00 00 00 
	stat->st_isdir = 0;
  801574:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80157b:	00 00 00 
	stat->st_dev = dev;
  80157e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801584:	83 ec 08             	sub    $0x8,%esp
  801587:	53                   	push   %ebx
  801588:	ff 75 f0             	pushl  -0x10(%ebp)
  80158b:	ff 50 14             	call   *0x14(%eax)
  80158e:	83 c4 10             	add    $0x10,%esp
}
  801591:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801594:	c9                   	leave  
  801595:	c3                   	ret    
		return -E_NOT_SUPP;
  801596:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80159b:	eb f4                	jmp    801591 <fstat+0x68>

0080159d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	56                   	push   %esi
  8015a1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015a2:	83 ec 08             	sub    $0x8,%esp
  8015a5:	6a 00                	push   $0x0
  8015a7:	ff 75 08             	pushl  0x8(%ebp)
  8015aa:	e8 22 02 00 00       	call   8017d1 <open>
  8015af:	89 c3                	mov    %eax,%ebx
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	78 1b                	js     8015d3 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015b8:	83 ec 08             	sub    $0x8,%esp
  8015bb:	ff 75 0c             	pushl  0xc(%ebp)
  8015be:	50                   	push   %eax
  8015bf:	e8 65 ff ff ff       	call   801529 <fstat>
  8015c4:	89 c6                	mov    %eax,%esi
	close(fd);
  8015c6:	89 1c 24             	mov    %ebx,(%esp)
  8015c9:	e8 27 fc ff ff       	call   8011f5 <close>
	return r;
  8015ce:	83 c4 10             	add    $0x10,%esp
  8015d1:	89 f3                	mov    %esi,%ebx
}
  8015d3:	89 d8                	mov    %ebx,%eax
  8015d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d8:	5b                   	pop    %ebx
  8015d9:	5e                   	pop    %esi
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    

008015dc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	56                   	push   %esi
  8015e0:	53                   	push   %ebx
  8015e1:	89 c6                	mov    %eax,%esi
  8015e3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015e5:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015ec:	74 27                	je     801615 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015ee:	6a 07                	push   $0x7
  8015f0:	68 00 50 80 00       	push   $0x805000
  8015f5:	56                   	push   %esi
  8015f6:	ff 35 00 40 80 00    	pushl  0x804000
  8015fc:	e8 69 0c 00 00       	call   80226a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801601:	83 c4 0c             	add    $0xc,%esp
  801604:	6a 00                	push   $0x0
  801606:	53                   	push   %ebx
  801607:	6a 00                	push   $0x0
  801609:	e8 f3 0b 00 00       	call   802201 <ipc_recv>
}
  80160e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801611:	5b                   	pop    %ebx
  801612:	5e                   	pop    %esi
  801613:	5d                   	pop    %ebp
  801614:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801615:	83 ec 0c             	sub    $0xc,%esp
  801618:	6a 01                	push   $0x1
  80161a:	e8 a3 0c 00 00       	call   8022c2 <ipc_find_env>
  80161f:	a3 00 40 80 00       	mov    %eax,0x804000
  801624:	83 c4 10             	add    $0x10,%esp
  801627:	eb c5                	jmp    8015ee <fsipc+0x12>

00801629 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	8b 40 0c             	mov    0xc(%eax),%eax
  801635:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80163a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801642:	ba 00 00 00 00       	mov    $0x0,%edx
  801647:	b8 02 00 00 00       	mov    $0x2,%eax
  80164c:	e8 8b ff ff ff       	call   8015dc <fsipc>
}
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <devfile_flush>:
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	8b 40 0c             	mov    0xc(%eax),%eax
  80165f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801664:	ba 00 00 00 00       	mov    $0x0,%edx
  801669:	b8 06 00 00 00       	mov    $0x6,%eax
  80166e:	e8 69 ff ff ff       	call   8015dc <fsipc>
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <devfile_stat>:
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	53                   	push   %ebx
  801679:	83 ec 04             	sub    $0x4,%esp
  80167c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8b 40 0c             	mov    0xc(%eax),%eax
  801685:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80168a:	ba 00 00 00 00       	mov    $0x0,%edx
  80168f:	b8 05 00 00 00       	mov    $0x5,%eax
  801694:	e8 43 ff ff ff       	call   8015dc <fsipc>
  801699:	85 c0                	test   %eax,%eax
  80169b:	78 2c                	js     8016c9 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80169d:	83 ec 08             	sub    $0x8,%esp
  8016a0:	68 00 50 80 00       	push   $0x805000
  8016a5:	53                   	push   %ebx
  8016a6:	e8 b8 f2 ff ff       	call   800963 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016ab:	a1 80 50 80 00       	mov    0x805080,%eax
  8016b0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016b6:	a1 84 50 80 00       	mov    0x805084,%eax
  8016bb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016c1:	83 c4 10             	add    $0x10,%esp
  8016c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <devfile_write>:
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	53                   	push   %ebx
  8016d2:	83 ec 08             	sub    $0x8,%esp
  8016d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	8b 40 0c             	mov    0xc(%eax),%eax
  8016de:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016e3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016e9:	53                   	push   %ebx
  8016ea:	ff 75 0c             	pushl  0xc(%ebp)
  8016ed:	68 08 50 80 00       	push   $0x805008
  8016f2:	e8 5c f4 ff ff       	call   800b53 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fc:	b8 04 00 00 00       	mov    $0x4,%eax
  801701:	e8 d6 fe ff ff       	call   8015dc <fsipc>
  801706:	83 c4 10             	add    $0x10,%esp
  801709:	85 c0                	test   %eax,%eax
  80170b:	78 0b                	js     801718 <devfile_write+0x4a>
	assert(r <= n);
  80170d:	39 d8                	cmp    %ebx,%eax
  80170f:	77 0c                	ja     80171d <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801711:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801716:	7f 1e                	jg     801736 <devfile_write+0x68>
}
  801718:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    
	assert(r <= n);
  80171d:	68 64 2a 80 00       	push   $0x802a64
  801722:	68 6b 2a 80 00       	push   $0x802a6b
  801727:	68 98 00 00 00       	push   $0x98
  80172c:	68 80 2a 80 00       	push   $0x802a80
  801731:	e8 6a 0a 00 00       	call   8021a0 <_panic>
	assert(r <= PGSIZE);
  801736:	68 8b 2a 80 00       	push   $0x802a8b
  80173b:	68 6b 2a 80 00       	push   $0x802a6b
  801740:	68 99 00 00 00       	push   $0x99
  801745:	68 80 2a 80 00       	push   $0x802a80
  80174a:	e8 51 0a 00 00       	call   8021a0 <_panic>

0080174f <devfile_read>:
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	56                   	push   %esi
  801753:	53                   	push   %ebx
  801754:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8b 40 0c             	mov    0xc(%eax),%eax
  80175d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801762:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801768:	ba 00 00 00 00       	mov    $0x0,%edx
  80176d:	b8 03 00 00 00       	mov    $0x3,%eax
  801772:	e8 65 fe ff ff       	call   8015dc <fsipc>
  801777:	89 c3                	mov    %eax,%ebx
  801779:	85 c0                	test   %eax,%eax
  80177b:	78 1f                	js     80179c <devfile_read+0x4d>
	assert(r <= n);
  80177d:	39 f0                	cmp    %esi,%eax
  80177f:	77 24                	ja     8017a5 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801781:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801786:	7f 33                	jg     8017bb <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801788:	83 ec 04             	sub    $0x4,%esp
  80178b:	50                   	push   %eax
  80178c:	68 00 50 80 00       	push   $0x805000
  801791:	ff 75 0c             	pushl  0xc(%ebp)
  801794:	e8 58 f3 ff ff       	call   800af1 <memmove>
	return r;
  801799:	83 c4 10             	add    $0x10,%esp
}
  80179c:	89 d8                	mov    %ebx,%eax
  80179e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a1:	5b                   	pop    %ebx
  8017a2:	5e                   	pop    %esi
  8017a3:	5d                   	pop    %ebp
  8017a4:	c3                   	ret    
	assert(r <= n);
  8017a5:	68 64 2a 80 00       	push   $0x802a64
  8017aa:	68 6b 2a 80 00       	push   $0x802a6b
  8017af:	6a 7c                	push   $0x7c
  8017b1:	68 80 2a 80 00       	push   $0x802a80
  8017b6:	e8 e5 09 00 00       	call   8021a0 <_panic>
	assert(r <= PGSIZE);
  8017bb:	68 8b 2a 80 00       	push   $0x802a8b
  8017c0:	68 6b 2a 80 00       	push   $0x802a6b
  8017c5:	6a 7d                	push   $0x7d
  8017c7:	68 80 2a 80 00       	push   $0x802a80
  8017cc:	e8 cf 09 00 00       	call   8021a0 <_panic>

008017d1 <open>:
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
  8017d4:	56                   	push   %esi
  8017d5:	53                   	push   %ebx
  8017d6:	83 ec 1c             	sub    $0x1c,%esp
  8017d9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017dc:	56                   	push   %esi
  8017dd:	e8 48 f1 ff ff       	call   80092a <strlen>
  8017e2:	83 c4 10             	add    $0x10,%esp
  8017e5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017ea:	7f 6c                	jg     801858 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017ec:	83 ec 0c             	sub    $0xc,%esp
  8017ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017f2:	50                   	push   %eax
  8017f3:	e8 79 f8 ff ff       	call   801071 <fd_alloc>
  8017f8:	89 c3                	mov    %eax,%ebx
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	85 c0                	test   %eax,%eax
  8017ff:	78 3c                	js     80183d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801801:	83 ec 08             	sub    $0x8,%esp
  801804:	56                   	push   %esi
  801805:	68 00 50 80 00       	push   $0x805000
  80180a:	e8 54 f1 ff ff       	call   800963 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80180f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801812:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801817:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181a:	b8 01 00 00 00       	mov    $0x1,%eax
  80181f:	e8 b8 fd ff ff       	call   8015dc <fsipc>
  801824:	89 c3                	mov    %eax,%ebx
  801826:	83 c4 10             	add    $0x10,%esp
  801829:	85 c0                	test   %eax,%eax
  80182b:	78 19                	js     801846 <open+0x75>
	return fd2num(fd);
  80182d:	83 ec 0c             	sub    $0xc,%esp
  801830:	ff 75 f4             	pushl  -0xc(%ebp)
  801833:	e8 12 f8 ff ff       	call   80104a <fd2num>
  801838:	89 c3                	mov    %eax,%ebx
  80183a:	83 c4 10             	add    $0x10,%esp
}
  80183d:	89 d8                	mov    %ebx,%eax
  80183f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801842:	5b                   	pop    %ebx
  801843:	5e                   	pop    %esi
  801844:	5d                   	pop    %ebp
  801845:	c3                   	ret    
		fd_close(fd, 0);
  801846:	83 ec 08             	sub    $0x8,%esp
  801849:	6a 00                	push   $0x0
  80184b:	ff 75 f4             	pushl  -0xc(%ebp)
  80184e:	e8 1b f9 ff ff       	call   80116e <fd_close>
		return r;
  801853:	83 c4 10             	add    $0x10,%esp
  801856:	eb e5                	jmp    80183d <open+0x6c>
		return -E_BAD_PATH;
  801858:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80185d:	eb de                	jmp    80183d <open+0x6c>

0080185f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801865:	ba 00 00 00 00       	mov    $0x0,%edx
  80186a:	b8 08 00 00 00       	mov    $0x8,%eax
  80186f:	e8 68 fd ff ff       	call   8015dc <fsipc>
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80187c:	68 97 2a 80 00       	push   $0x802a97
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	e8 da f0 ff ff       	call   800963 <strcpy>
	return 0;
}
  801889:	b8 00 00 00 00       	mov    $0x0,%eax
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <devsock_close>:
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	53                   	push   %ebx
  801894:	83 ec 10             	sub    $0x10,%esp
  801897:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80189a:	53                   	push   %ebx
  80189b:	e8 61 0a 00 00       	call   802301 <pageref>
  8018a0:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018a3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018a8:	83 f8 01             	cmp    $0x1,%eax
  8018ab:	74 07                	je     8018b4 <devsock_close+0x24>
}
  8018ad:	89 d0                	mov    %edx,%eax
  8018af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018b4:	83 ec 0c             	sub    $0xc,%esp
  8018b7:	ff 73 0c             	pushl  0xc(%ebx)
  8018ba:	e8 b9 02 00 00       	call   801b78 <nsipc_close>
  8018bf:	89 c2                	mov    %eax,%edx
  8018c1:	83 c4 10             	add    $0x10,%esp
  8018c4:	eb e7                	jmp    8018ad <devsock_close+0x1d>

008018c6 <devsock_write>:
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	ff 75 10             	pushl  0x10(%ebp)
  8018d1:	ff 75 0c             	pushl  0xc(%ebp)
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	ff 70 0c             	pushl  0xc(%eax)
  8018da:	e8 76 03 00 00       	call   801c55 <nsipc_send>
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <devsock_read>:
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018e7:	6a 00                	push   $0x0
  8018e9:	ff 75 10             	pushl  0x10(%ebp)
  8018ec:	ff 75 0c             	pushl  0xc(%ebp)
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	ff 70 0c             	pushl  0xc(%eax)
  8018f5:	e8 ef 02 00 00       	call   801be9 <nsipc_recv>
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <fd2sockid>:
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801902:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801905:	52                   	push   %edx
  801906:	50                   	push   %eax
  801907:	e8 b7 f7 ff ff       	call   8010c3 <fd_lookup>
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	85 c0                	test   %eax,%eax
  801911:	78 10                	js     801923 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801916:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80191c:	39 08                	cmp    %ecx,(%eax)
  80191e:	75 05                	jne    801925 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801920:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    
		return -E_NOT_SUPP;
  801925:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80192a:	eb f7                	jmp    801923 <fd2sockid+0x27>

0080192c <alloc_sockfd>:
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	56                   	push   %esi
  801930:	53                   	push   %ebx
  801931:	83 ec 1c             	sub    $0x1c,%esp
  801934:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801936:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801939:	50                   	push   %eax
  80193a:	e8 32 f7 ff ff       	call   801071 <fd_alloc>
  80193f:	89 c3                	mov    %eax,%ebx
  801941:	83 c4 10             	add    $0x10,%esp
  801944:	85 c0                	test   %eax,%eax
  801946:	78 43                	js     80198b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801948:	83 ec 04             	sub    $0x4,%esp
  80194b:	68 07 04 00 00       	push   $0x407
  801950:	ff 75 f4             	pushl  -0xc(%ebp)
  801953:	6a 00                	push   $0x0
  801955:	e8 fb f3 ff ff       	call   800d55 <sys_page_alloc>
  80195a:	89 c3                	mov    %eax,%ebx
  80195c:	83 c4 10             	add    $0x10,%esp
  80195f:	85 c0                	test   %eax,%eax
  801961:	78 28                	js     80198b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801966:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80196c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80196e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801971:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801978:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80197b:	83 ec 0c             	sub    $0xc,%esp
  80197e:	50                   	push   %eax
  80197f:	e8 c6 f6 ff ff       	call   80104a <fd2num>
  801984:	89 c3                	mov    %eax,%ebx
  801986:	83 c4 10             	add    $0x10,%esp
  801989:	eb 0c                	jmp    801997 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80198b:	83 ec 0c             	sub    $0xc,%esp
  80198e:	56                   	push   %esi
  80198f:	e8 e4 01 00 00       	call   801b78 <nsipc_close>
		return r;
  801994:	83 c4 10             	add    $0x10,%esp
}
  801997:	89 d8                	mov    %ebx,%eax
  801999:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199c:	5b                   	pop    %ebx
  80199d:	5e                   	pop    %esi
  80199e:	5d                   	pop    %ebp
  80199f:	c3                   	ret    

008019a0 <accept>:
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	e8 4e ff ff ff       	call   8018fc <fd2sockid>
  8019ae:	85 c0                	test   %eax,%eax
  8019b0:	78 1b                	js     8019cd <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019b2:	83 ec 04             	sub    $0x4,%esp
  8019b5:	ff 75 10             	pushl  0x10(%ebp)
  8019b8:	ff 75 0c             	pushl  0xc(%ebp)
  8019bb:	50                   	push   %eax
  8019bc:	e8 0e 01 00 00       	call   801acf <nsipc_accept>
  8019c1:	83 c4 10             	add    $0x10,%esp
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	78 05                	js     8019cd <accept+0x2d>
	return alloc_sockfd(r);
  8019c8:	e8 5f ff ff ff       	call   80192c <alloc_sockfd>
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <bind>:
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	e8 1f ff ff ff       	call   8018fc <fd2sockid>
  8019dd:	85 c0                	test   %eax,%eax
  8019df:	78 12                	js     8019f3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019e1:	83 ec 04             	sub    $0x4,%esp
  8019e4:	ff 75 10             	pushl  0x10(%ebp)
  8019e7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ea:	50                   	push   %eax
  8019eb:	e8 31 01 00 00       	call   801b21 <nsipc_bind>
  8019f0:	83 c4 10             	add    $0x10,%esp
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <shutdown>:
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	e8 f9 fe ff ff       	call   8018fc <fd2sockid>
  801a03:	85 c0                	test   %eax,%eax
  801a05:	78 0f                	js     801a16 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a07:	83 ec 08             	sub    $0x8,%esp
  801a0a:	ff 75 0c             	pushl  0xc(%ebp)
  801a0d:	50                   	push   %eax
  801a0e:	e8 43 01 00 00       	call   801b56 <nsipc_shutdown>
  801a13:	83 c4 10             	add    $0x10,%esp
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <connect>:
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	e8 d6 fe ff ff       	call   8018fc <fd2sockid>
  801a26:	85 c0                	test   %eax,%eax
  801a28:	78 12                	js     801a3c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a2a:	83 ec 04             	sub    $0x4,%esp
  801a2d:	ff 75 10             	pushl  0x10(%ebp)
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	50                   	push   %eax
  801a34:	e8 59 01 00 00       	call   801b92 <nsipc_connect>
  801a39:	83 c4 10             	add    $0x10,%esp
}
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <listen>:
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
  801a41:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	e8 b0 fe ff ff       	call   8018fc <fd2sockid>
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	78 0f                	js     801a5f <listen+0x21>
	return nsipc_listen(r, backlog);
  801a50:	83 ec 08             	sub    $0x8,%esp
  801a53:	ff 75 0c             	pushl  0xc(%ebp)
  801a56:	50                   	push   %eax
  801a57:	e8 6b 01 00 00       	call   801bc7 <nsipc_listen>
  801a5c:	83 c4 10             	add    $0x10,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a67:	ff 75 10             	pushl  0x10(%ebp)
  801a6a:	ff 75 0c             	pushl  0xc(%ebp)
  801a6d:	ff 75 08             	pushl  0x8(%ebp)
  801a70:	e8 3e 02 00 00       	call   801cb3 <nsipc_socket>
  801a75:	83 c4 10             	add    $0x10,%esp
  801a78:	85 c0                	test   %eax,%eax
  801a7a:	78 05                	js     801a81 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a7c:	e8 ab fe ff ff       	call   80192c <alloc_sockfd>
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	53                   	push   %ebx
  801a87:	83 ec 04             	sub    $0x4,%esp
  801a8a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a8c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a93:	74 26                	je     801abb <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a95:	6a 07                	push   $0x7
  801a97:	68 00 60 80 00       	push   $0x806000
  801a9c:	53                   	push   %ebx
  801a9d:	ff 35 04 40 80 00    	pushl  0x804004
  801aa3:	e8 c2 07 00 00       	call   80226a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801aa8:	83 c4 0c             	add    $0xc,%esp
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	e8 4b 07 00 00       	call   802201 <ipc_recv>
}
  801ab6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801abb:	83 ec 0c             	sub    $0xc,%esp
  801abe:	6a 02                	push   $0x2
  801ac0:	e8 fd 07 00 00       	call   8022c2 <ipc_find_env>
  801ac5:	a3 04 40 80 00       	mov    %eax,0x804004
  801aca:	83 c4 10             	add    $0x10,%esp
  801acd:	eb c6                	jmp    801a95 <nsipc+0x12>

00801acf <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	56                   	push   %esi
  801ad3:	53                   	push   %ebx
  801ad4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801adf:	8b 06                	mov    (%esi),%eax
  801ae1:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ae6:	b8 01 00 00 00       	mov    $0x1,%eax
  801aeb:	e8 93 ff ff ff       	call   801a83 <nsipc>
  801af0:	89 c3                	mov    %eax,%ebx
  801af2:	85 c0                	test   %eax,%eax
  801af4:	79 09                	jns    801aff <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801af6:	89 d8                	mov    %ebx,%eax
  801af8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afb:	5b                   	pop    %ebx
  801afc:	5e                   	pop    %esi
  801afd:	5d                   	pop    %ebp
  801afe:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801aff:	83 ec 04             	sub    $0x4,%esp
  801b02:	ff 35 10 60 80 00    	pushl  0x806010
  801b08:	68 00 60 80 00       	push   $0x806000
  801b0d:	ff 75 0c             	pushl  0xc(%ebp)
  801b10:	e8 dc ef ff ff       	call   800af1 <memmove>
		*addrlen = ret->ret_addrlen;
  801b15:	a1 10 60 80 00       	mov    0x806010,%eax
  801b1a:	89 06                	mov    %eax,(%esi)
  801b1c:	83 c4 10             	add    $0x10,%esp
	return r;
  801b1f:	eb d5                	jmp    801af6 <nsipc_accept+0x27>

00801b21 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	53                   	push   %ebx
  801b25:	83 ec 08             	sub    $0x8,%esp
  801b28:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b33:	53                   	push   %ebx
  801b34:	ff 75 0c             	pushl  0xc(%ebp)
  801b37:	68 04 60 80 00       	push   $0x806004
  801b3c:	e8 b0 ef ff ff       	call   800af1 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b41:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b47:	b8 02 00 00 00       	mov    $0x2,%eax
  801b4c:	e8 32 ff ff ff       	call   801a83 <nsipc>
}
  801b51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b67:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b6c:	b8 03 00 00 00       	mov    $0x3,%eax
  801b71:	e8 0d ff ff ff       	call   801a83 <nsipc>
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <nsipc_close>:

int
nsipc_close(int s)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
  801b7b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b86:	b8 04 00 00 00       	mov    $0x4,%eax
  801b8b:	e8 f3 fe ff ff       	call   801a83 <nsipc>
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	53                   	push   %ebx
  801b96:	83 ec 08             	sub    $0x8,%esp
  801b99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ba4:	53                   	push   %ebx
  801ba5:	ff 75 0c             	pushl  0xc(%ebp)
  801ba8:	68 04 60 80 00       	push   $0x806004
  801bad:	e8 3f ef ff ff       	call   800af1 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bb2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bb8:	b8 05 00 00 00       	mov    $0x5,%eax
  801bbd:	e8 c1 fe ff ff       	call   801a83 <nsipc>
}
  801bc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bdd:	b8 06 00 00 00       	mov    $0x6,%eax
  801be2:	e8 9c fe ff ff       	call   801a83 <nsipc>
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	56                   	push   %esi
  801bed:	53                   	push   %ebx
  801bee:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bf9:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bff:	8b 45 14             	mov    0x14(%ebp),%eax
  801c02:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c07:	b8 07 00 00 00       	mov    $0x7,%eax
  801c0c:	e8 72 fe ff ff       	call   801a83 <nsipc>
  801c11:	89 c3                	mov    %eax,%ebx
  801c13:	85 c0                	test   %eax,%eax
  801c15:	78 1f                	js     801c36 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c17:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c1c:	7f 21                	jg     801c3f <nsipc_recv+0x56>
  801c1e:	39 c6                	cmp    %eax,%esi
  801c20:	7c 1d                	jl     801c3f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c22:	83 ec 04             	sub    $0x4,%esp
  801c25:	50                   	push   %eax
  801c26:	68 00 60 80 00       	push   $0x806000
  801c2b:	ff 75 0c             	pushl  0xc(%ebp)
  801c2e:	e8 be ee ff ff       	call   800af1 <memmove>
  801c33:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c36:	89 d8                	mov    %ebx,%eax
  801c38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c3b:	5b                   	pop    %ebx
  801c3c:	5e                   	pop    %esi
  801c3d:	5d                   	pop    %ebp
  801c3e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c3f:	68 a3 2a 80 00       	push   $0x802aa3
  801c44:	68 6b 2a 80 00       	push   $0x802a6b
  801c49:	6a 62                	push   $0x62
  801c4b:	68 b8 2a 80 00       	push   $0x802ab8
  801c50:	e8 4b 05 00 00       	call   8021a0 <_panic>

00801c55 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	53                   	push   %ebx
  801c59:	83 ec 04             	sub    $0x4,%esp
  801c5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c67:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c6d:	7f 2e                	jg     801c9d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c6f:	83 ec 04             	sub    $0x4,%esp
  801c72:	53                   	push   %ebx
  801c73:	ff 75 0c             	pushl  0xc(%ebp)
  801c76:	68 0c 60 80 00       	push   $0x80600c
  801c7b:	e8 71 ee ff ff       	call   800af1 <memmove>
	nsipcbuf.send.req_size = size;
  801c80:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c86:	8b 45 14             	mov    0x14(%ebp),%eax
  801c89:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c8e:	b8 08 00 00 00       	mov    $0x8,%eax
  801c93:	e8 eb fd ff ff       	call   801a83 <nsipc>
}
  801c98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    
	assert(size < 1600);
  801c9d:	68 c4 2a 80 00       	push   $0x802ac4
  801ca2:	68 6b 2a 80 00       	push   $0x802a6b
  801ca7:	6a 6d                	push   $0x6d
  801ca9:	68 b8 2a 80 00       	push   $0x802ab8
  801cae:	e8 ed 04 00 00       	call   8021a0 <_panic>

00801cb3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc4:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cd1:	b8 09 00 00 00       	mov    $0x9,%eax
  801cd6:	e8 a8 fd ff ff       	call   801a83 <nsipc>
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	56                   	push   %esi
  801ce1:	53                   	push   %ebx
  801ce2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ce5:	83 ec 0c             	sub    $0xc,%esp
  801ce8:	ff 75 08             	pushl  0x8(%ebp)
  801ceb:	e8 6a f3 ff ff       	call   80105a <fd2data>
  801cf0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cf2:	83 c4 08             	add    $0x8,%esp
  801cf5:	68 d0 2a 80 00       	push   $0x802ad0
  801cfa:	53                   	push   %ebx
  801cfb:	e8 63 ec ff ff       	call   800963 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d00:	8b 46 04             	mov    0x4(%esi),%eax
  801d03:	2b 06                	sub    (%esi),%eax
  801d05:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d0b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d12:	00 00 00 
	stat->st_dev = &devpipe;
  801d15:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d1c:	30 80 00 
	return 0;
}
  801d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d27:	5b                   	pop    %ebx
  801d28:	5e                   	pop    %esi
  801d29:	5d                   	pop    %ebp
  801d2a:	c3                   	ret    

00801d2b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	53                   	push   %ebx
  801d2f:	83 ec 0c             	sub    $0xc,%esp
  801d32:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d35:	53                   	push   %ebx
  801d36:	6a 00                	push   $0x0
  801d38:	e8 9d f0 ff ff       	call   800dda <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d3d:	89 1c 24             	mov    %ebx,(%esp)
  801d40:	e8 15 f3 ff ff       	call   80105a <fd2data>
  801d45:	83 c4 08             	add    $0x8,%esp
  801d48:	50                   	push   %eax
  801d49:	6a 00                	push   $0x0
  801d4b:	e8 8a f0 ff ff       	call   800dda <sys_page_unmap>
}
  801d50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <_pipeisclosed>:
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	57                   	push   %edi
  801d59:	56                   	push   %esi
  801d5a:	53                   	push   %ebx
  801d5b:	83 ec 1c             	sub    $0x1c,%esp
  801d5e:	89 c7                	mov    %eax,%edi
  801d60:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d62:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801d67:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d6a:	83 ec 0c             	sub    $0xc,%esp
  801d6d:	57                   	push   %edi
  801d6e:	e8 8e 05 00 00       	call   802301 <pageref>
  801d73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d76:	89 34 24             	mov    %esi,(%esp)
  801d79:	e8 83 05 00 00       	call   802301 <pageref>
		nn = thisenv->env_runs;
  801d7e:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801d84:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d87:	83 c4 10             	add    $0x10,%esp
  801d8a:	39 cb                	cmp    %ecx,%ebx
  801d8c:	74 1b                	je     801da9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d8e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d91:	75 cf                	jne    801d62 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d93:	8b 42 58             	mov    0x58(%edx),%eax
  801d96:	6a 01                	push   $0x1
  801d98:	50                   	push   %eax
  801d99:	53                   	push   %ebx
  801d9a:	68 d7 2a 80 00       	push   $0x802ad7
  801d9f:	e8 60 e4 ff ff       	call   800204 <cprintf>
  801da4:	83 c4 10             	add    $0x10,%esp
  801da7:	eb b9                	jmp    801d62 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801da9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dac:	0f 94 c0             	sete   %al
  801daf:	0f b6 c0             	movzbl %al,%eax
}
  801db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db5:	5b                   	pop    %ebx
  801db6:	5e                   	pop    %esi
  801db7:	5f                   	pop    %edi
  801db8:	5d                   	pop    %ebp
  801db9:	c3                   	ret    

00801dba <devpipe_write>:
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	57                   	push   %edi
  801dbe:	56                   	push   %esi
  801dbf:	53                   	push   %ebx
  801dc0:	83 ec 28             	sub    $0x28,%esp
  801dc3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dc6:	56                   	push   %esi
  801dc7:	e8 8e f2 ff ff       	call   80105a <fd2data>
  801dcc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dce:	83 c4 10             	add    $0x10,%esp
  801dd1:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dd9:	74 4f                	je     801e2a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ddb:	8b 43 04             	mov    0x4(%ebx),%eax
  801dde:	8b 0b                	mov    (%ebx),%ecx
  801de0:	8d 51 20             	lea    0x20(%ecx),%edx
  801de3:	39 d0                	cmp    %edx,%eax
  801de5:	72 14                	jb     801dfb <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801de7:	89 da                	mov    %ebx,%edx
  801de9:	89 f0                	mov    %esi,%eax
  801deb:	e8 65 ff ff ff       	call   801d55 <_pipeisclosed>
  801df0:	85 c0                	test   %eax,%eax
  801df2:	75 3b                	jne    801e2f <devpipe_write+0x75>
			sys_yield();
  801df4:	e8 3d ef ff ff       	call   800d36 <sys_yield>
  801df9:	eb e0                	jmp    801ddb <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dfe:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e02:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e05:	89 c2                	mov    %eax,%edx
  801e07:	c1 fa 1f             	sar    $0x1f,%edx
  801e0a:	89 d1                	mov    %edx,%ecx
  801e0c:	c1 e9 1b             	shr    $0x1b,%ecx
  801e0f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e12:	83 e2 1f             	and    $0x1f,%edx
  801e15:	29 ca                	sub    %ecx,%edx
  801e17:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e1b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e1f:	83 c0 01             	add    $0x1,%eax
  801e22:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e25:	83 c7 01             	add    $0x1,%edi
  801e28:	eb ac                	jmp    801dd6 <devpipe_write+0x1c>
	return i;
  801e2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2d:	eb 05                	jmp    801e34 <devpipe_write+0x7a>
				return 0;
  801e2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e37:	5b                   	pop    %ebx
  801e38:	5e                   	pop    %esi
  801e39:	5f                   	pop    %edi
  801e3a:	5d                   	pop    %ebp
  801e3b:	c3                   	ret    

00801e3c <devpipe_read>:
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	57                   	push   %edi
  801e40:	56                   	push   %esi
  801e41:	53                   	push   %ebx
  801e42:	83 ec 18             	sub    $0x18,%esp
  801e45:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e48:	57                   	push   %edi
  801e49:	e8 0c f2 ff ff       	call   80105a <fd2data>
  801e4e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e50:	83 c4 10             	add    $0x10,%esp
  801e53:	be 00 00 00 00       	mov    $0x0,%esi
  801e58:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e5b:	75 14                	jne    801e71 <devpipe_read+0x35>
	return i;
  801e5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e60:	eb 02                	jmp    801e64 <devpipe_read+0x28>
				return i;
  801e62:	89 f0                	mov    %esi,%eax
}
  801e64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e67:	5b                   	pop    %ebx
  801e68:	5e                   	pop    %esi
  801e69:	5f                   	pop    %edi
  801e6a:	5d                   	pop    %ebp
  801e6b:	c3                   	ret    
			sys_yield();
  801e6c:	e8 c5 ee ff ff       	call   800d36 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e71:	8b 03                	mov    (%ebx),%eax
  801e73:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e76:	75 18                	jne    801e90 <devpipe_read+0x54>
			if (i > 0)
  801e78:	85 f6                	test   %esi,%esi
  801e7a:	75 e6                	jne    801e62 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e7c:	89 da                	mov    %ebx,%edx
  801e7e:	89 f8                	mov    %edi,%eax
  801e80:	e8 d0 fe ff ff       	call   801d55 <_pipeisclosed>
  801e85:	85 c0                	test   %eax,%eax
  801e87:	74 e3                	je     801e6c <devpipe_read+0x30>
				return 0;
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8e:	eb d4                	jmp    801e64 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e90:	99                   	cltd   
  801e91:	c1 ea 1b             	shr    $0x1b,%edx
  801e94:	01 d0                	add    %edx,%eax
  801e96:	83 e0 1f             	and    $0x1f,%eax
  801e99:	29 d0                	sub    %edx,%eax
  801e9b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ea0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ea3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ea6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ea9:	83 c6 01             	add    $0x1,%esi
  801eac:	eb aa                	jmp    801e58 <devpipe_read+0x1c>

00801eae <pipe>:
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	56                   	push   %esi
  801eb2:	53                   	push   %ebx
  801eb3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801eb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb9:	50                   	push   %eax
  801eba:	e8 b2 f1 ff ff       	call   801071 <fd_alloc>
  801ebf:	89 c3                	mov    %eax,%ebx
  801ec1:	83 c4 10             	add    $0x10,%esp
  801ec4:	85 c0                	test   %eax,%eax
  801ec6:	0f 88 23 01 00 00    	js     801fef <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ecc:	83 ec 04             	sub    $0x4,%esp
  801ecf:	68 07 04 00 00       	push   $0x407
  801ed4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed7:	6a 00                	push   $0x0
  801ed9:	e8 77 ee ff ff       	call   800d55 <sys_page_alloc>
  801ede:	89 c3                	mov    %eax,%ebx
  801ee0:	83 c4 10             	add    $0x10,%esp
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	0f 88 04 01 00 00    	js     801fef <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801eeb:	83 ec 0c             	sub    $0xc,%esp
  801eee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ef1:	50                   	push   %eax
  801ef2:	e8 7a f1 ff ff       	call   801071 <fd_alloc>
  801ef7:	89 c3                	mov    %eax,%ebx
  801ef9:	83 c4 10             	add    $0x10,%esp
  801efc:	85 c0                	test   %eax,%eax
  801efe:	0f 88 db 00 00 00    	js     801fdf <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f04:	83 ec 04             	sub    $0x4,%esp
  801f07:	68 07 04 00 00       	push   $0x407
  801f0c:	ff 75 f0             	pushl  -0x10(%ebp)
  801f0f:	6a 00                	push   $0x0
  801f11:	e8 3f ee ff ff       	call   800d55 <sys_page_alloc>
  801f16:	89 c3                	mov    %eax,%ebx
  801f18:	83 c4 10             	add    $0x10,%esp
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	0f 88 bc 00 00 00    	js     801fdf <pipe+0x131>
	va = fd2data(fd0);
  801f23:	83 ec 0c             	sub    $0xc,%esp
  801f26:	ff 75 f4             	pushl  -0xc(%ebp)
  801f29:	e8 2c f1 ff ff       	call   80105a <fd2data>
  801f2e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f30:	83 c4 0c             	add    $0xc,%esp
  801f33:	68 07 04 00 00       	push   $0x407
  801f38:	50                   	push   %eax
  801f39:	6a 00                	push   $0x0
  801f3b:	e8 15 ee ff ff       	call   800d55 <sys_page_alloc>
  801f40:	89 c3                	mov    %eax,%ebx
  801f42:	83 c4 10             	add    $0x10,%esp
  801f45:	85 c0                	test   %eax,%eax
  801f47:	0f 88 82 00 00 00    	js     801fcf <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f4d:	83 ec 0c             	sub    $0xc,%esp
  801f50:	ff 75 f0             	pushl  -0x10(%ebp)
  801f53:	e8 02 f1 ff ff       	call   80105a <fd2data>
  801f58:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f5f:	50                   	push   %eax
  801f60:	6a 00                	push   $0x0
  801f62:	56                   	push   %esi
  801f63:	6a 00                	push   $0x0
  801f65:	e8 2e ee ff ff       	call   800d98 <sys_page_map>
  801f6a:	89 c3                	mov    %eax,%ebx
  801f6c:	83 c4 20             	add    $0x20,%esp
  801f6f:	85 c0                	test   %eax,%eax
  801f71:	78 4e                	js     801fc1 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f73:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f80:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f87:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f8a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f96:	83 ec 0c             	sub    $0xc,%esp
  801f99:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9c:	e8 a9 f0 ff ff       	call   80104a <fd2num>
  801fa1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fa4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fa6:	83 c4 04             	add    $0x4,%esp
  801fa9:	ff 75 f0             	pushl  -0x10(%ebp)
  801fac:	e8 99 f0 ff ff       	call   80104a <fd2num>
  801fb1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fb4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fb7:	83 c4 10             	add    $0x10,%esp
  801fba:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fbf:	eb 2e                	jmp    801fef <pipe+0x141>
	sys_page_unmap(0, va);
  801fc1:	83 ec 08             	sub    $0x8,%esp
  801fc4:	56                   	push   %esi
  801fc5:	6a 00                	push   $0x0
  801fc7:	e8 0e ee ff ff       	call   800dda <sys_page_unmap>
  801fcc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fcf:	83 ec 08             	sub    $0x8,%esp
  801fd2:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd5:	6a 00                	push   $0x0
  801fd7:	e8 fe ed ff ff       	call   800dda <sys_page_unmap>
  801fdc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fdf:	83 ec 08             	sub    $0x8,%esp
  801fe2:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe5:	6a 00                	push   $0x0
  801fe7:	e8 ee ed ff ff       	call   800dda <sys_page_unmap>
  801fec:	83 c4 10             	add    $0x10,%esp
}
  801fef:	89 d8                	mov    %ebx,%eax
  801ff1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff4:	5b                   	pop    %ebx
  801ff5:	5e                   	pop    %esi
  801ff6:	5d                   	pop    %ebp
  801ff7:	c3                   	ret    

00801ff8 <pipeisclosed>:
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
  801ffb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ffe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802001:	50                   	push   %eax
  802002:	ff 75 08             	pushl  0x8(%ebp)
  802005:	e8 b9 f0 ff ff       	call   8010c3 <fd_lookup>
  80200a:	83 c4 10             	add    $0x10,%esp
  80200d:	85 c0                	test   %eax,%eax
  80200f:	78 18                	js     802029 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802011:	83 ec 0c             	sub    $0xc,%esp
  802014:	ff 75 f4             	pushl  -0xc(%ebp)
  802017:	e8 3e f0 ff ff       	call   80105a <fd2data>
	return _pipeisclosed(fd, p);
  80201c:	89 c2                	mov    %eax,%edx
  80201e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802021:	e8 2f fd ff ff       	call   801d55 <_pipeisclosed>
  802026:	83 c4 10             	add    $0x10,%esp
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80202b:	b8 00 00 00 00       	mov    $0x0,%eax
  802030:	c3                   	ret    

00802031 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802037:	68 ef 2a 80 00       	push   $0x802aef
  80203c:	ff 75 0c             	pushl  0xc(%ebp)
  80203f:	e8 1f e9 ff ff       	call   800963 <strcpy>
	return 0;
}
  802044:	b8 00 00 00 00       	mov    $0x0,%eax
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <devcons_write>:
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	57                   	push   %edi
  80204f:	56                   	push   %esi
  802050:	53                   	push   %ebx
  802051:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802057:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80205c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802062:	3b 75 10             	cmp    0x10(%ebp),%esi
  802065:	73 31                	jae    802098 <devcons_write+0x4d>
		m = n - tot;
  802067:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80206a:	29 f3                	sub    %esi,%ebx
  80206c:	83 fb 7f             	cmp    $0x7f,%ebx
  80206f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802074:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802077:	83 ec 04             	sub    $0x4,%esp
  80207a:	53                   	push   %ebx
  80207b:	89 f0                	mov    %esi,%eax
  80207d:	03 45 0c             	add    0xc(%ebp),%eax
  802080:	50                   	push   %eax
  802081:	57                   	push   %edi
  802082:	e8 6a ea ff ff       	call   800af1 <memmove>
		sys_cputs(buf, m);
  802087:	83 c4 08             	add    $0x8,%esp
  80208a:	53                   	push   %ebx
  80208b:	57                   	push   %edi
  80208c:	e8 08 ec ff ff       	call   800c99 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802091:	01 de                	add    %ebx,%esi
  802093:	83 c4 10             	add    $0x10,%esp
  802096:	eb ca                	jmp    802062 <devcons_write+0x17>
}
  802098:	89 f0                	mov    %esi,%eax
  80209a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80209d:	5b                   	pop    %ebx
  80209e:	5e                   	pop    %esi
  80209f:	5f                   	pop    %edi
  8020a0:	5d                   	pop    %ebp
  8020a1:	c3                   	ret    

008020a2 <devcons_read>:
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
  8020a5:	83 ec 08             	sub    $0x8,%esp
  8020a8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020b1:	74 21                	je     8020d4 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020b3:	e8 ff eb ff ff       	call   800cb7 <sys_cgetc>
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	75 07                	jne    8020c3 <devcons_read+0x21>
		sys_yield();
  8020bc:	e8 75 ec ff ff       	call   800d36 <sys_yield>
  8020c1:	eb f0                	jmp    8020b3 <devcons_read+0x11>
	if (c < 0)
  8020c3:	78 0f                	js     8020d4 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020c5:	83 f8 04             	cmp    $0x4,%eax
  8020c8:	74 0c                	je     8020d6 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020cd:	88 02                	mov    %al,(%edx)
	return 1;
  8020cf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    
		return 0;
  8020d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020db:	eb f7                	jmp    8020d4 <devcons_read+0x32>

008020dd <cputchar>:
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
  8020e0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020e9:	6a 01                	push   $0x1
  8020eb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020ee:	50                   	push   %eax
  8020ef:	e8 a5 eb ff ff       	call   800c99 <sys_cputs>
}
  8020f4:	83 c4 10             	add    $0x10,%esp
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <getchar>:
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
  8020fc:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020ff:	6a 01                	push   $0x1
  802101:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802104:	50                   	push   %eax
  802105:	6a 00                	push   $0x0
  802107:	e8 27 f2 ff ff       	call   801333 <read>
	if (r < 0)
  80210c:	83 c4 10             	add    $0x10,%esp
  80210f:	85 c0                	test   %eax,%eax
  802111:	78 06                	js     802119 <getchar+0x20>
	if (r < 1)
  802113:	74 06                	je     80211b <getchar+0x22>
	return c;
  802115:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    
		return -E_EOF;
  80211b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802120:	eb f7                	jmp    802119 <getchar+0x20>

00802122 <iscons>:
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802128:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80212b:	50                   	push   %eax
  80212c:	ff 75 08             	pushl  0x8(%ebp)
  80212f:	e8 8f ef ff ff       	call   8010c3 <fd_lookup>
  802134:	83 c4 10             	add    $0x10,%esp
  802137:	85 c0                	test   %eax,%eax
  802139:	78 11                	js     80214c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80213b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802144:	39 10                	cmp    %edx,(%eax)
  802146:	0f 94 c0             	sete   %al
  802149:	0f b6 c0             	movzbl %al,%eax
}
  80214c:	c9                   	leave  
  80214d:	c3                   	ret    

0080214e <opencons>:
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
  802151:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802154:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802157:	50                   	push   %eax
  802158:	e8 14 ef ff ff       	call   801071 <fd_alloc>
  80215d:	83 c4 10             	add    $0x10,%esp
  802160:	85 c0                	test   %eax,%eax
  802162:	78 3a                	js     80219e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802164:	83 ec 04             	sub    $0x4,%esp
  802167:	68 07 04 00 00       	push   $0x407
  80216c:	ff 75 f4             	pushl  -0xc(%ebp)
  80216f:	6a 00                	push   $0x0
  802171:	e8 df eb ff ff       	call   800d55 <sys_page_alloc>
  802176:	83 c4 10             	add    $0x10,%esp
  802179:	85 c0                	test   %eax,%eax
  80217b:	78 21                	js     80219e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80217d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802180:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802186:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802192:	83 ec 0c             	sub    $0xc,%esp
  802195:	50                   	push   %eax
  802196:	e8 af ee ff ff       	call   80104a <fd2num>
  80219b:	83 c4 10             	add    $0x10,%esp
}
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	56                   	push   %esi
  8021a4:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8021a5:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8021aa:	8b 40 48             	mov    0x48(%eax),%eax
  8021ad:	83 ec 04             	sub    $0x4,%esp
  8021b0:	68 20 2b 80 00       	push   $0x802b20
  8021b5:	50                   	push   %eax
  8021b6:	68 06 26 80 00       	push   $0x802606
  8021bb:	e8 44 e0 ff ff       	call   800204 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021c0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021c3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021c9:	e8 49 eb ff ff       	call   800d17 <sys_getenvid>
  8021ce:	83 c4 04             	add    $0x4,%esp
  8021d1:	ff 75 0c             	pushl  0xc(%ebp)
  8021d4:	ff 75 08             	pushl  0x8(%ebp)
  8021d7:	56                   	push   %esi
  8021d8:	50                   	push   %eax
  8021d9:	68 fc 2a 80 00       	push   $0x802afc
  8021de:	e8 21 e0 ff ff       	call   800204 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021e3:	83 c4 18             	add    $0x18,%esp
  8021e6:	53                   	push   %ebx
  8021e7:	ff 75 10             	pushl  0x10(%ebp)
  8021ea:	e8 c4 df ff ff       	call   8001b3 <vcprintf>
	cprintf("\n");
  8021ef:	c7 04 24 ca 25 80 00 	movl   $0x8025ca,(%esp)
  8021f6:	e8 09 e0 ff ff       	call   800204 <cprintf>
  8021fb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021fe:	cc                   	int3   
  8021ff:	eb fd                	jmp    8021fe <_panic+0x5e>

00802201 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
  802204:	56                   	push   %esi
  802205:	53                   	push   %ebx
  802206:	8b 75 08             	mov    0x8(%ebp),%esi
  802209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80220f:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802211:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802216:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802219:	83 ec 0c             	sub    $0xc,%esp
  80221c:	50                   	push   %eax
  80221d:	e8 e3 ec ff ff       	call   800f05 <sys_ipc_recv>
	if(ret < 0){
  802222:	83 c4 10             	add    $0x10,%esp
  802225:	85 c0                	test   %eax,%eax
  802227:	78 2b                	js     802254 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802229:	85 f6                	test   %esi,%esi
  80222b:	74 0a                	je     802237 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80222d:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802232:	8b 40 78             	mov    0x78(%eax),%eax
  802235:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802237:	85 db                	test   %ebx,%ebx
  802239:	74 0a                	je     802245 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80223b:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802240:	8b 40 7c             	mov    0x7c(%eax),%eax
  802243:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802245:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80224a:	8b 40 74             	mov    0x74(%eax),%eax
}
  80224d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802250:	5b                   	pop    %ebx
  802251:	5e                   	pop    %esi
  802252:	5d                   	pop    %ebp
  802253:	c3                   	ret    
		if(from_env_store)
  802254:	85 f6                	test   %esi,%esi
  802256:	74 06                	je     80225e <ipc_recv+0x5d>
			*from_env_store = 0;
  802258:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80225e:	85 db                	test   %ebx,%ebx
  802260:	74 eb                	je     80224d <ipc_recv+0x4c>
			*perm_store = 0;
  802262:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802268:	eb e3                	jmp    80224d <ipc_recv+0x4c>

0080226a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	57                   	push   %edi
  80226e:	56                   	push   %esi
  80226f:	53                   	push   %ebx
  802270:	83 ec 0c             	sub    $0xc,%esp
  802273:	8b 7d 08             	mov    0x8(%ebp),%edi
  802276:	8b 75 0c             	mov    0xc(%ebp),%esi
  802279:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80227c:	85 db                	test   %ebx,%ebx
  80227e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802283:	0f 44 d8             	cmove  %eax,%ebx
  802286:	eb 05                	jmp    80228d <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802288:	e8 a9 ea ff ff       	call   800d36 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80228d:	ff 75 14             	pushl  0x14(%ebp)
  802290:	53                   	push   %ebx
  802291:	56                   	push   %esi
  802292:	57                   	push   %edi
  802293:	e8 4a ec ff ff       	call   800ee2 <sys_ipc_try_send>
  802298:	83 c4 10             	add    $0x10,%esp
  80229b:	85 c0                	test   %eax,%eax
  80229d:	74 1b                	je     8022ba <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80229f:	79 e7                	jns    802288 <ipc_send+0x1e>
  8022a1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022a4:	74 e2                	je     802288 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022a6:	83 ec 04             	sub    $0x4,%esp
  8022a9:	68 27 2b 80 00       	push   $0x802b27
  8022ae:	6a 46                	push   $0x46
  8022b0:	68 3c 2b 80 00       	push   $0x802b3c
  8022b5:	e8 e6 fe ff ff       	call   8021a0 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022bd:	5b                   	pop    %ebx
  8022be:	5e                   	pop    %esi
  8022bf:	5f                   	pop    %edi
  8022c0:	5d                   	pop    %ebp
  8022c1:	c3                   	ret    

008022c2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
  8022c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022c8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022cd:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8022d3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022d9:	8b 52 50             	mov    0x50(%edx),%edx
  8022dc:	39 ca                	cmp    %ecx,%edx
  8022de:	74 11                	je     8022f1 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022e0:	83 c0 01             	add    $0x1,%eax
  8022e3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022e8:	75 e3                	jne    8022cd <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ef:	eb 0e                	jmp    8022ff <ipc_find_env+0x3d>
			return envs[i].env_id;
  8022f1:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8022f7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022fc:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022ff:	5d                   	pop    %ebp
  802300:	c3                   	ret    

00802301 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
  802304:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802307:	89 d0                	mov    %edx,%eax
  802309:	c1 e8 16             	shr    $0x16,%eax
  80230c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802313:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802318:	f6 c1 01             	test   $0x1,%cl
  80231b:	74 1d                	je     80233a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80231d:	c1 ea 0c             	shr    $0xc,%edx
  802320:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802327:	f6 c2 01             	test   $0x1,%dl
  80232a:	74 0e                	je     80233a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80232c:	c1 ea 0c             	shr    $0xc,%edx
  80232f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802336:	ef 
  802337:	0f b7 c0             	movzwl %ax,%eax
}
  80233a:	5d                   	pop    %ebp
  80233b:	c3                   	ret    
  80233c:	66 90                	xchg   %ax,%ax
  80233e:	66 90                	xchg   %ax,%ax

00802340 <__udivdi3>:
  802340:	55                   	push   %ebp
  802341:	57                   	push   %edi
  802342:	56                   	push   %esi
  802343:	53                   	push   %ebx
  802344:	83 ec 1c             	sub    $0x1c,%esp
  802347:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80234b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80234f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802353:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802357:	85 d2                	test   %edx,%edx
  802359:	75 4d                	jne    8023a8 <__udivdi3+0x68>
  80235b:	39 f3                	cmp    %esi,%ebx
  80235d:	76 19                	jbe    802378 <__udivdi3+0x38>
  80235f:	31 ff                	xor    %edi,%edi
  802361:	89 e8                	mov    %ebp,%eax
  802363:	89 f2                	mov    %esi,%edx
  802365:	f7 f3                	div    %ebx
  802367:	89 fa                	mov    %edi,%edx
  802369:	83 c4 1c             	add    $0x1c,%esp
  80236c:	5b                   	pop    %ebx
  80236d:	5e                   	pop    %esi
  80236e:	5f                   	pop    %edi
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    
  802371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802378:	89 d9                	mov    %ebx,%ecx
  80237a:	85 db                	test   %ebx,%ebx
  80237c:	75 0b                	jne    802389 <__udivdi3+0x49>
  80237e:	b8 01 00 00 00       	mov    $0x1,%eax
  802383:	31 d2                	xor    %edx,%edx
  802385:	f7 f3                	div    %ebx
  802387:	89 c1                	mov    %eax,%ecx
  802389:	31 d2                	xor    %edx,%edx
  80238b:	89 f0                	mov    %esi,%eax
  80238d:	f7 f1                	div    %ecx
  80238f:	89 c6                	mov    %eax,%esi
  802391:	89 e8                	mov    %ebp,%eax
  802393:	89 f7                	mov    %esi,%edi
  802395:	f7 f1                	div    %ecx
  802397:	89 fa                	mov    %edi,%edx
  802399:	83 c4 1c             	add    $0x1c,%esp
  80239c:	5b                   	pop    %ebx
  80239d:	5e                   	pop    %esi
  80239e:	5f                   	pop    %edi
  80239f:	5d                   	pop    %ebp
  8023a0:	c3                   	ret    
  8023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a8:	39 f2                	cmp    %esi,%edx
  8023aa:	77 1c                	ja     8023c8 <__udivdi3+0x88>
  8023ac:	0f bd fa             	bsr    %edx,%edi
  8023af:	83 f7 1f             	xor    $0x1f,%edi
  8023b2:	75 2c                	jne    8023e0 <__udivdi3+0xa0>
  8023b4:	39 f2                	cmp    %esi,%edx
  8023b6:	72 06                	jb     8023be <__udivdi3+0x7e>
  8023b8:	31 c0                	xor    %eax,%eax
  8023ba:	39 eb                	cmp    %ebp,%ebx
  8023bc:	77 a9                	ja     802367 <__udivdi3+0x27>
  8023be:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c3:	eb a2                	jmp    802367 <__udivdi3+0x27>
  8023c5:	8d 76 00             	lea    0x0(%esi),%esi
  8023c8:	31 ff                	xor    %edi,%edi
  8023ca:	31 c0                	xor    %eax,%eax
  8023cc:	89 fa                	mov    %edi,%edx
  8023ce:	83 c4 1c             	add    $0x1c,%esp
  8023d1:	5b                   	pop    %ebx
  8023d2:	5e                   	pop    %esi
  8023d3:	5f                   	pop    %edi
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    
  8023d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023dd:	8d 76 00             	lea    0x0(%esi),%esi
  8023e0:	89 f9                	mov    %edi,%ecx
  8023e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023e7:	29 f8                	sub    %edi,%eax
  8023e9:	d3 e2                	shl    %cl,%edx
  8023eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023ef:	89 c1                	mov    %eax,%ecx
  8023f1:	89 da                	mov    %ebx,%edx
  8023f3:	d3 ea                	shr    %cl,%edx
  8023f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023f9:	09 d1                	or     %edx,%ecx
  8023fb:	89 f2                	mov    %esi,%edx
  8023fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802401:	89 f9                	mov    %edi,%ecx
  802403:	d3 e3                	shl    %cl,%ebx
  802405:	89 c1                	mov    %eax,%ecx
  802407:	d3 ea                	shr    %cl,%edx
  802409:	89 f9                	mov    %edi,%ecx
  80240b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80240f:	89 eb                	mov    %ebp,%ebx
  802411:	d3 e6                	shl    %cl,%esi
  802413:	89 c1                	mov    %eax,%ecx
  802415:	d3 eb                	shr    %cl,%ebx
  802417:	09 de                	or     %ebx,%esi
  802419:	89 f0                	mov    %esi,%eax
  80241b:	f7 74 24 08          	divl   0x8(%esp)
  80241f:	89 d6                	mov    %edx,%esi
  802421:	89 c3                	mov    %eax,%ebx
  802423:	f7 64 24 0c          	mull   0xc(%esp)
  802427:	39 d6                	cmp    %edx,%esi
  802429:	72 15                	jb     802440 <__udivdi3+0x100>
  80242b:	89 f9                	mov    %edi,%ecx
  80242d:	d3 e5                	shl    %cl,%ebp
  80242f:	39 c5                	cmp    %eax,%ebp
  802431:	73 04                	jae    802437 <__udivdi3+0xf7>
  802433:	39 d6                	cmp    %edx,%esi
  802435:	74 09                	je     802440 <__udivdi3+0x100>
  802437:	89 d8                	mov    %ebx,%eax
  802439:	31 ff                	xor    %edi,%edi
  80243b:	e9 27 ff ff ff       	jmp    802367 <__udivdi3+0x27>
  802440:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802443:	31 ff                	xor    %edi,%edi
  802445:	e9 1d ff ff ff       	jmp    802367 <__udivdi3+0x27>
  80244a:	66 90                	xchg   %ax,%ax
  80244c:	66 90                	xchg   %ax,%ax
  80244e:	66 90                	xchg   %ax,%ax

00802450 <__umoddi3>:
  802450:	55                   	push   %ebp
  802451:	57                   	push   %edi
  802452:	56                   	push   %esi
  802453:	53                   	push   %ebx
  802454:	83 ec 1c             	sub    $0x1c,%esp
  802457:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80245b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80245f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802463:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802467:	89 da                	mov    %ebx,%edx
  802469:	85 c0                	test   %eax,%eax
  80246b:	75 43                	jne    8024b0 <__umoddi3+0x60>
  80246d:	39 df                	cmp    %ebx,%edi
  80246f:	76 17                	jbe    802488 <__umoddi3+0x38>
  802471:	89 f0                	mov    %esi,%eax
  802473:	f7 f7                	div    %edi
  802475:	89 d0                	mov    %edx,%eax
  802477:	31 d2                	xor    %edx,%edx
  802479:	83 c4 1c             	add    $0x1c,%esp
  80247c:	5b                   	pop    %ebx
  80247d:	5e                   	pop    %esi
  80247e:	5f                   	pop    %edi
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    
  802481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802488:	89 fd                	mov    %edi,%ebp
  80248a:	85 ff                	test   %edi,%edi
  80248c:	75 0b                	jne    802499 <__umoddi3+0x49>
  80248e:	b8 01 00 00 00       	mov    $0x1,%eax
  802493:	31 d2                	xor    %edx,%edx
  802495:	f7 f7                	div    %edi
  802497:	89 c5                	mov    %eax,%ebp
  802499:	89 d8                	mov    %ebx,%eax
  80249b:	31 d2                	xor    %edx,%edx
  80249d:	f7 f5                	div    %ebp
  80249f:	89 f0                	mov    %esi,%eax
  8024a1:	f7 f5                	div    %ebp
  8024a3:	89 d0                	mov    %edx,%eax
  8024a5:	eb d0                	jmp    802477 <__umoddi3+0x27>
  8024a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ae:	66 90                	xchg   %ax,%ax
  8024b0:	89 f1                	mov    %esi,%ecx
  8024b2:	39 d8                	cmp    %ebx,%eax
  8024b4:	76 0a                	jbe    8024c0 <__umoddi3+0x70>
  8024b6:	89 f0                	mov    %esi,%eax
  8024b8:	83 c4 1c             	add    $0x1c,%esp
  8024bb:	5b                   	pop    %ebx
  8024bc:	5e                   	pop    %esi
  8024bd:	5f                   	pop    %edi
  8024be:	5d                   	pop    %ebp
  8024bf:	c3                   	ret    
  8024c0:	0f bd e8             	bsr    %eax,%ebp
  8024c3:	83 f5 1f             	xor    $0x1f,%ebp
  8024c6:	75 20                	jne    8024e8 <__umoddi3+0x98>
  8024c8:	39 d8                	cmp    %ebx,%eax
  8024ca:	0f 82 b0 00 00 00    	jb     802580 <__umoddi3+0x130>
  8024d0:	39 f7                	cmp    %esi,%edi
  8024d2:	0f 86 a8 00 00 00    	jbe    802580 <__umoddi3+0x130>
  8024d8:	89 c8                	mov    %ecx,%eax
  8024da:	83 c4 1c             	add    $0x1c,%esp
  8024dd:	5b                   	pop    %ebx
  8024de:	5e                   	pop    %esi
  8024df:	5f                   	pop    %edi
  8024e0:	5d                   	pop    %ebp
  8024e1:	c3                   	ret    
  8024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024e8:	89 e9                	mov    %ebp,%ecx
  8024ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8024ef:	29 ea                	sub    %ebp,%edx
  8024f1:	d3 e0                	shl    %cl,%eax
  8024f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024f7:	89 d1                	mov    %edx,%ecx
  8024f9:	89 f8                	mov    %edi,%eax
  8024fb:	d3 e8                	shr    %cl,%eax
  8024fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802501:	89 54 24 04          	mov    %edx,0x4(%esp)
  802505:	8b 54 24 04          	mov    0x4(%esp),%edx
  802509:	09 c1                	or     %eax,%ecx
  80250b:	89 d8                	mov    %ebx,%eax
  80250d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802511:	89 e9                	mov    %ebp,%ecx
  802513:	d3 e7                	shl    %cl,%edi
  802515:	89 d1                	mov    %edx,%ecx
  802517:	d3 e8                	shr    %cl,%eax
  802519:	89 e9                	mov    %ebp,%ecx
  80251b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80251f:	d3 e3                	shl    %cl,%ebx
  802521:	89 c7                	mov    %eax,%edi
  802523:	89 d1                	mov    %edx,%ecx
  802525:	89 f0                	mov    %esi,%eax
  802527:	d3 e8                	shr    %cl,%eax
  802529:	89 e9                	mov    %ebp,%ecx
  80252b:	89 fa                	mov    %edi,%edx
  80252d:	d3 e6                	shl    %cl,%esi
  80252f:	09 d8                	or     %ebx,%eax
  802531:	f7 74 24 08          	divl   0x8(%esp)
  802535:	89 d1                	mov    %edx,%ecx
  802537:	89 f3                	mov    %esi,%ebx
  802539:	f7 64 24 0c          	mull   0xc(%esp)
  80253d:	89 c6                	mov    %eax,%esi
  80253f:	89 d7                	mov    %edx,%edi
  802541:	39 d1                	cmp    %edx,%ecx
  802543:	72 06                	jb     80254b <__umoddi3+0xfb>
  802545:	75 10                	jne    802557 <__umoddi3+0x107>
  802547:	39 c3                	cmp    %eax,%ebx
  802549:	73 0c                	jae    802557 <__umoddi3+0x107>
  80254b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80254f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802553:	89 d7                	mov    %edx,%edi
  802555:	89 c6                	mov    %eax,%esi
  802557:	89 ca                	mov    %ecx,%edx
  802559:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80255e:	29 f3                	sub    %esi,%ebx
  802560:	19 fa                	sbb    %edi,%edx
  802562:	89 d0                	mov    %edx,%eax
  802564:	d3 e0                	shl    %cl,%eax
  802566:	89 e9                	mov    %ebp,%ecx
  802568:	d3 eb                	shr    %cl,%ebx
  80256a:	d3 ea                	shr    %cl,%edx
  80256c:	09 d8                	or     %ebx,%eax
  80256e:	83 c4 1c             	add    $0x1c,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    
  802576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80257d:	8d 76 00             	lea    0x0(%esi),%esi
  802580:	89 da                	mov    %ebx,%edx
  802582:	29 fe                	sub    %edi,%esi
  802584:	19 c2                	sbb    %eax,%edx
  802586:	89 f1                	mov    %esi,%ecx
  802588:	89 c8                	mov    %ecx,%eax
  80258a:	e9 4b ff ff ff       	jmp    8024da <__umoddi3+0x8a>
