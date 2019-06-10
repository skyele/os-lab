
obj/user/breakpoint.debug:     file format elf32-i386


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
  80002c:	e8 04 00 00 00       	call   800035 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $3");
  800033:	cc                   	int3   
}
  800034:	c3                   	ret    

00800035 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800035:	55                   	push   %ebp
  800036:	89 e5                	mov    %esp,%ebp
  800038:	57                   	push   %edi
  800039:	56                   	push   %esi
  80003a:	53                   	push   %ebx
  80003b:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80003e:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800045:	00 00 00 
	envid_t find = sys_getenvid();
  800048:	e8 9d 0c 00 00       	call   800cea <sys_getenvid>
  80004d:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800053:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800058:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80005d:	bf 01 00 00 00       	mov    $0x1,%edi
  800062:	eb 0b                	jmp    80006f <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800064:	83 c2 01             	add    $0x1,%edx
  800067:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80006d:	74 21                	je     800090 <libmain+0x5b>
		if(envs[i].env_id == find)
  80006f:	89 d1                	mov    %edx,%ecx
  800071:	c1 e1 07             	shl    $0x7,%ecx
  800074:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80007a:	8b 49 48             	mov    0x48(%ecx),%ecx
  80007d:	39 c1                	cmp    %eax,%ecx
  80007f:	75 e3                	jne    800064 <libmain+0x2f>
  800081:	89 d3                	mov    %edx,%ebx
  800083:	c1 e3 07             	shl    $0x7,%ebx
  800086:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80008c:	89 fe                	mov    %edi,%esi
  80008e:	eb d4                	jmp    800064 <libmain+0x2f>
  800090:	89 f0                	mov    %esi,%eax
  800092:	84 c0                	test   %al,%al
  800094:	74 06                	je     80009c <libmain+0x67>
  800096:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a0:	7e 0a                	jle    8000ac <libmain+0x77>
		binaryname = argv[0];
  8000a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a5:	8b 00                	mov    (%eax),%eax
  8000a7:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000ac:	a1 08 40 80 00       	mov    0x804008,%eax
  8000b1:	8b 40 48             	mov    0x48(%eax),%eax
  8000b4:	83 ec 08             	sub    $0x8,%esp
  8000b7:	50                   	push   %eax
  8000b8:	68 60 25 80 00       	push   $0x802560
  8000bd:	e8 15 01 00 00       	call   8001d7 <cprintf>
	cprintf("before umain\n");
  8000c2:	c7 04 24 7e 25 80 00 	movl   $0x80257e,(%esp)
  8000c9:	e8 09 01 00 00       	call   8001d7 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000ce:	83 c4 08             	add    $0x8,%esp
  8000d1:	ff 75 0c             	pushl  0xc(%ebp)
  8000d4:	ff 75 08             	pushl  0x8(%ebp)
  8000d7:	e8 57 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000dc:	c7 04 24 8c 25 80 00 	movl   $0x80258c,(%esp)
  8000e3:	e8 ef 00 00 00       	call   8001d7 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8000e8:	a1 08 40 80 00       	mov    0x804008,%eax
  8000ed:	8b 40 48             	mov    0x48(%eax),%eax
  8000f0:	83 c4 08             	add    $0x8,%esp
  8000f3:	50                   	push   %eax
  8000f4:	68 99 25 80 00       	push   $0x802599
  8000f9:	e8 d9 00 00 00       	call   8001d7 <cprintf>
	// exit gracefully
	exit();
  8000fe:	e8 0b 00 00 00       	call   80010e <exit>
}
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800109:	5b                   	pop    %ebx
  80010a:	5e                   	pop    %esi
  80010b:	5f                   	pop    %edi
  80010c:	5d                   	pop    %ebp
  80010d:	c3                   	ret    

0080010e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010e:	55                   	push   %ebp
  80010f:	89 e5                	mov    %esp,%ebp
  800111:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800114:	a1 08 40 80 00       	mov    0x804008,%eax
  800119:	8b 40 48             	mov    0x48(%eax),%eax
  80011c:	68 c4 25 80 00       	push   $0x8025c4
  800121:	50                   	push   %eax
  800122:	68 b8 25 80 00       	push   $0x8025b8
  800127:	e8 ab 00 00 00       	call   8001d7 <cprintf>
	close_all();
  80012c:	e8 c4 10 00 00       	call   8011f5 <close_all>
	sys_env_destroy(0);
  800131:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800138:	e8 6c 0b 00 00       	call   800ca9 <sys_env_destroy>
}
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	c9                   	leave  
  800141:	c3                   	ret    

00800142 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	53                   	push   %ebx
  800146:	83 ec 04             	sub    $0x4,%esp
  800149:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80014c:	8b 13                	mov    (%ebx),%edx
  80014e:	8d 42 01             	lea    0x1(%edx),%eax
  800151:	89 03                	mov    %eax,(%ebx)
  800153:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800156:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80015a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80015f:	74 09                	je     80016a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800161:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800165:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800168:	c9                   	leave  
  800169:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80016a:	83 ec 08             	sub    $0x8,%esp
  80016d:	68 ff 00 00 00       	push   $0xff
  800172:	8d 43 08             	lea    0x8(%ebx),%eax
  800175:	50                   	push   %eax
  800176:	e8 f1 0a 00 00       	call   800c6c <sys_cputs>
		b->idx = 0;
  80017b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	eb db                	jmp    800161 <putch+0x1f>

00800186 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800186:	55                   	push   %ebp
  800187:	89 e5                	mov    %esp,%ebp
  800189:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80018f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800196:	00 00 00 
	b.cnt = 0;
  800199:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a3:	ff 75 0c             	pushl  0xc(%ebp)
  8001a6:	ff 75 08             	pushl  0x8(%ebp)
  8001a9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001af:	50                   	push   %eax
  8001b0:	68 42 01 80 00       	push   $0x800142
  8001b5:	e8 4a 01 00 00       	call   800304 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ba:	83 c4 08             	add    $0x8,%esp
  8001bd:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001c3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001c9:	50                   	push   %eax
  8001ca:	e8 9d 0a 00 00       	call   800c6c <sys_cputs>

	return b.cnt;
}
  8001cf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001d5:	c9                   	leave  
  8001d6:	c3                   	ret    

008001d7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001dd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001e0:	50                   	push   %eax
  8001e1:	ff 75 08             	pushl  0x8(%ebp)
  8001e4:	e8 9d ff ff ff       	call   800186 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001e9:	c9                   	leave  
  8001ea:	c3                   	ret    

008001eb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	57                   	push   %edi
  8001ef:	56                   	push   %esi
  8001f0:	53                   	push   %ebx
  8001f1:	83 ec 1c             	sub    $0x1c,%esp
  8001f4:	89 c6                	mov    %eax,%esi
  8001f6:	89 d7                	mov    %edx,%edi
  8001f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800201:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800204:	8b 45 10             	mov    0x10(%ebp),%eax
  800207:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80020a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80020e:	74 2c                	je     80023c <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800210:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800213:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80021a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80021d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800220:	39 c2                	cmp    %eax,%edx
  800222:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800225:	73 43                	jae    80026a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800227:	83 eb 01             	sub    $0x1,%ebx
  80022a:	85 db                	test   %ebx,%ebx
  80022c:	7e 6c                	jle    80029a <printnum+0xaf>
				putch(padc, putdat);
  80022e:	83 ec 08             	sub    $0x8,%esp
  800231:	57                   	push   %edi
  800232:	ff 75 18             	pushl  0x18(%ebp)
  800235:	ff d6                	call   *%esi
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	eb eb                	jmp    800227 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	6a 20                	push   $0x20
  800241:	6a 00                	push   $0x0
  800243:	50                   	push   %eax
  800244:	ff 75 e4             	pushl  -0x1c(%ebp)
  800247:	ff 75 e0             	pushl  -0x20(%ebp)
  80024a:	89 fa                	mov    %edi,%edx
  80024c:	89 f0                	mov    %esi,%eax
  80024e:	e8 98 ff ff ff       	call   8001eb <printnum>
		while (--width > 0)
  800253:	83 c4 20             	add    $0x20,%esp
  800256:	83 eb 01             	sub    $0x1,%ebx
  800259:	85 db                	test   %ebx,%ebx
  80025b:	7e 65                	jle    8002c2 <printnum+0xd7>
			putch(padc, putdat);
  80025d:	83 ec 08             	sub    $0x8,%esp
  800260:	57                   	push   %edi
  800261:	6a 20                	push   $0x20
  800263:	ff d6                	call   *%esi
  800265:	83 c4 10             	add    $0x10,%esp
  800268:	eb ec                	jmp    800256 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	ff 75 18             	pushl  0x18(%ebp)
  800270:	83 eb 01             	sub    $0x1,%ebx
  800273:	53                   	push   %ebx
  800274:	50                   	push   %eax
  800275:	83 ec 08             	sub    $0x8,%esp
  800278:	ff 75 dc             	pushl  -0x24(%ebp)
  80027b:	ff 75 d8             	pushl  -0x28(%ebp)
  80027e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800281:	ff 75 e0             	pushl  -0x20(%ebp)
  800284:	e8 87 20 00 00       	call   802310 <__udivdi3>
  800289:	83 c4 18             	add    $0x18,%esp
  80028c:	52                   	push   %edx
  80028d:	50                   	push   %eax
  80028e:	89 fa                	mov    %edi,%edx
  800290:	89 f0                	mov    %esi,%eax
  800292:	e8 54 ff ff ff       	call   8001eb <printnum>
  800297:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	57                   	push   %edi
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ad:	e8 6e 21 00 00       	call   802420 <__umoddi3>
  8002b2:	83 c4 14             	add    $0x14,%esp
  8002b5:	0f be 80 c9 25 80 00 	movsbl 0x8025c9(%eax),%eax
  8002bc:	50                   	push   %eax
  8002bd:	ff d6                	call   *%esi
  8002bf:	83 c4 10             	add    $0x10,%esp
	}
}
  8002c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c5:	5b                   	pop    %ebx
  8002c6:	5e                   	pop    %esi
  8002c7:	5f                   	pop    %edi
  8002c8:	5d                   	pop    %ebp
  8002c9:	c3                   	ret    

008002ca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ca:	55                   	push   %ebp
  8002cb:	89 e5                	mov    %esp,%ebp
  8002cd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d4:	8b 10                	mov    (%eax),%edx
  8002d6:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d9:	73 0a                	jae    8002e5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002db:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002de:	89 08                	mov    %ecx,(%eax)
  8002e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e3:	88 02                	mov    %al,(%edx)
}
  8002e5:	5d                   	pop    %ebp
  8002e6:	c3                   	ret    

008002e7 <printfmt>:
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ed:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002f0:	50                   	push   %eax
  8002f1:	ff 75 10             	pushl  0x10(%ebp)
  8002f4:	ff 75 0c             	pushl  0xc(%ebp)
  8002f7:	ff 75 08             	pushl  0x8(%ebp)
  8002fa:	e8 05 00 00 00       	call   800304 <vprintfmt>
}
  8002ff:	83 c4 10             	add    $0x10,%esp
  800302:	c9                   	leave  
  800303:	c3                   	ret    

00800304 <vprintfmt>:
{
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	57                   	push   %edi
  800308:	56                   	push   %esi
  800309:	53                   	push   %ebx
  80030a:	83 ec 3c             	sub    $0x3c,%esp
  80030d:	8b 75 08             	mov    0x8(%ebp),%esi
  800310:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800313:	8b 7d 10             	mov    0x10(%ebp),%edi
  800316:	e9 32 04 00 00       	jmp    80074d <vprintfmt+0x449>
		padc = ' ';
  80031b:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80031f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800326:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80032d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800334:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80033b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800342:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800347:	8d 47 01             	lea    0x1(%edi),%eax
  80034a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034d:	0f b6 17             	movzbl (%edi),%edx
  800350:	8d 42 dd             	lea    -0x23(%edx),%eax
  800353:	3c 55                	cmp    $0x55,%al
  800355:	0f 87 12 05 00 00    	ja     80086d <vprintfmt+0x569>
  80035b:	0f b6 c0             	movzbl %al,%eax
  80035e:	ff 24 85 a0 27 80 00 	jmp    *0x8027a0(,%eax,4)
  800365:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800368:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80036c:	eb d9                	jmp    800347 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80036e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800371:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800375:	eb d0                	jmp    800347 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800377:	0f b6 d2             	movzbl %dl,%edx
  80037a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037d:	b8 00 00 00 00       	mov    $0x0,%eax
  800382:	89 75 08             	mov    %esi,0x8(%ebp)
  800385:	eb 03                	jmp    80038a <vprintfmt+0x86>
  800387:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80038a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800391:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800394:	8d 72 d0             	lea    -0x30(%edx),%esi
  800397:	83 fe 09             	cmp    $0x9,%esi
  80039a:	76 eb                	jbe    800387 <vprintfmt+0x83>
  80039c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80039f:	8b 75 08             	mov    0x8(%ebp),%esi
  8003a2:	eb 14                	jmp    8003b8 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a7:	8b 00                	mov    (%eax),%eax
  8003a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8003af:	8d 40 04             	lea    0x4(%eax),%eax
  8003b2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003bc:	79 89                	jns    800347 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003cb:	e9 77 ff ff ff       	jmp    800347 <vprintfmt+0x43>
  8003d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d3:	85 c0                	test   %eax,%eax
  8003d5:	0f 48 c1             	cmovs  %ecx,%eax
  8003d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003de:	e9 64 ff ff ff       	jmp    800347 <vprintfmt+0x43>
  8003e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003ed:	e9 55 ff ff ff       	jmp    800347 <vprintfmt+0x43>
			lflag++;
  8003f2:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003f9:	e9 49 ff ff ff       	jmp    800347 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800401:	8d 78 04             	lea    0x4(%eax),%edi
  800404:	83 ec 08             	sub    $0x8,%esp
  800407:	53                   	push   %ebx
  800408:	ff 30                	pushl  (%eax)
  80040a:	ff d6                	call   *%esi
			break;
  80040c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80040f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800412:	e9 33 03 00 00       	jmp    80074a <vprintfmt+0x446>
			err = va_arg(ap, int);
  800417:	8b 45 14             	mov    0x14(%ebp),%eax
  80041a:	8d 78 04             	lea    0x4(%eax),%edi
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	99                   	cltd   
  800420:	31 d0                	xor    %edx,%eax
  800422:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800424:	83 f8 11             	cmp    $0x11,%eax
  800427:	7f 23                	jg     80044c <vprintfmt+0x148>
  800429:	8b 14 85 00 29 80 00 	mov    0x802900(,%eax,4),%edx
  800430:	85 d2                	test   %edx,%edx
  800432:	74 18                	je     80044c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800434:	52                   	push   %edx
  800435:	68 1d 2a 80 00       	push   $0x802a1d
  80043a:	53                   	push   %ebx
  80043b:	56                   	push   %esi
  80043c:	e8 a6 fe ff ff       	call   8002e7 <printfmt>
  800441:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800444:	89 7d 14             	mov    %edi,0x14(%ebp)
  800447:	e9 fe 02 00 00       	jmp    80074a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80044c:	50                   	push   %eax
  80044d:	68 e1 25 80 00       	push   $0x8025e1
  800452:	53                   	push   %ebx
  800453:	56                   	push   %esi
  800454:	e8 8e fe ff ff       	call   8002e7 <printfmt>
  800459:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80045f:	e9 e6 02 00 00       	jmp    80074a <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	83 c0 04             	add    $0x4,%eax
  80046a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80046d:	8b 45 14             	mov    0x14(%ebp),%eax
  800470:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800472:	85 c9                	test   %ecx,%ecx
  800474:	b8 da 25 80 00       	mov    $0x8025da,%eax
  800479:	0f 45 c1             	cmovne %ecx,%eax
  80047c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80047f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800483:	7e 06                	jle    80048b <vprintfmt+0x187>
  800485:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800489:	75 0d                	jne    800498 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80048e:	89 c7                	mov    %eax,%edi
  800490:	03 45 e0             	add    -0x20(%ebp),%eax
  800493:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800496:	eb 53                	jmp    8004eb <vprintfmt+0x1e7>
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	ff 75 d8             	pushl  -0x28(%ebp)
  80049e:	50                   	push   %eax
  80049f:	e8 71 04 00 00       	call   800915 <strnlen>
  8004a4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a7:	29 c1                	sub    %eax,%ecx
  8004a9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004ac:	83 c4 10             	add    $0x10,%esp
  8004af:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004b1:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b8:	eb 0f                	jmp    8004c9 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	53                   	push   %ebx
  8004be:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c3:	83 ef 01             	sub    $0x1,%edi
  8004c6:	83 c4 10             	add    $0x10,%esp
  8004c9:	85 ff                	test   %edi,%edi
  8004cb:	7f ed                	jg     8004ba <vprintfmt+0x1b6>
  8004cd:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004d0:	85 c9                	test   %ecx,%ecx
  8004d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d7:	0f 49 c1             	cmovns %ecx,%eax
  8004da:	29 c1                	sub    %eax,%ecx
  8004dc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004df:	eb aa                	jmp    80048b <vprintfmt+0x187>
					putch(ch, putdat);
  8004e1:	83 ec 08             	sub    $0x8,%esp
  8004e4:	53                   	push   %ebx
  8004e5:	52                   	push   %edx
  8004e6:	ff d6                	call   *%esi
  8004e8:	83 c4 10             	add    $0x10,%esp
  8004eb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ee:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f0:	83 c7 01             	add    $0x1,%edi
  8004f3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004f7:	0f be d0             	movsbl %al,%edx
  8004fa:	85 d2                	test   %edx,%edx
  8004fc:	74 4b                	je     800549 <vprintfmt+0x245>
  8004fe:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800502:	78 06                	js     80050a <vprintfmt+0x206>
  800504:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800508:	78 1e                	js     800528 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80050a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80050e:	74 d1                	je     8004e1 <vprintfmt+0x1dd>
  800510:	0f be c0             	movsbl %al,%eax
  800513:	83 e8 20             	sub    $0x20,%eax
  800516:	83 f8 5e             	cmp    $0x5e,%eax
  800519:	76 c6                	jbe    8004e1 <vprintfmt+0x1dd>
					putch('?', putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	53                   	push   %ebx
  80051f:	6a 3f                	push   $0x3f
  800521:	ff d6                	call   *%esi
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	eb c3                	jmp    8004eb <vprintfmt+0x1e7>
  800528:	89 cf                	mov    %ecx,%edi
  80052a:	eb 0e                	jmp    80053a <vprintfmt+0x236>
				putch(' ', putdat);
  80052c:	83 ec 08             	sub    $0x8,%esp
  80052f:	53                   	push   %ebx
  800530:	6a 20                	push   $0x20
  800532:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800534:	83 ef 01             	sub    $0x1,%edi
  800537:	83 c4 10             	add    $0x10,%esp
  80053a:	85 ff                	test   %edi,%edi
  80053c:	7f ee                	jg     80052c <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80053e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800541:	89 45 14             	mov    %eax,0x14(%ebp)
  800544:	e9 01 02 00 00       	jmp    80074a <vprintfmt+0x446>
  800549:	89 cf                	mov    %ecx,%edi
  80054b:	eb ed                	jmp    80053a <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80054d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800550:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800557:	e9 eb fd ff ff       	jmp    800347 <vprintfmt+0x43>
	if (lflag >= 2)
  80055c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800560:	7f 21                	jg     800583 <vprintfmt+0x27f>
	else if (lflag)
  800562:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800566:	74 68                	je     8005d0 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800570:	89 c1                	mov    %eax,%ecx
  800572:	c1 f9 1f             	sar    $0x1f,%ecx
  800575:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800578:	8b 45 14             	mov    0x14(%ebp),%eax
  80057b:	8d 40 04             	lea    0x4(%eax),%eax
  80057e:	89 45 14             	mov    %eax,0x14(%ebp)
  800581:	eb 17                	jmp    80059a <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	8b 50 04             	mov    0x4(%eax),%edx
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80058e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8d 40 08             	lea    0x8(%eax),%eax
  800597:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80059a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005a6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005aa:	78 3f                	js     8005eb <vprintfmt+0x2e7>
			base = 10;
  8005ac:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005b1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005b5:	0f 84 71 01 00 00    	je     80072c <vprintfmt+0x428>
				putch('+', putdat);
  8005bb:	83 ec 08             	sub    $0x8,%esp
  8005be:	53                   	push   %ebx
  8005bf:	6a 2b                	push   $0x2b
  8005c1:	ff d6                	call   *%esi
  8005c3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005cb:	e9 5c 01 00 00       	jmp    80072c <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	8b 00                	mov    (%eax),%eax
  8005d5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005d8:	89 c1                	mov    %eax,%ecx
  8005da:	c1 f9 1f             	sar    $0x1f,%ecx
  8005dd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8d 40 04             	lea    0x4(%eax),%eax
  8005e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e9:	eb af                	jmp    80059a <vprintfmt+0x296>
				putch('-', putdat);
  8005eb:	83 ec 08             	sub    $0x8,%esp
  8005ee:	53                   	push   %ebx
  8005ef:	6a 2d                	push   $0x2d
  8005f1:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005f9:	f7 d8                	neg    %eax
  8005fb:	83 d2 00             	adc    $0x0,%edx
  8005fe:	f7 da                	neg    %edx
  800600:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800603:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800606:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800609:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060e:	e9 19 01 00 00       	jmp    80072c <vprintfmt+0x428>
	if (lflag >= 2)
  800613:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800617:	7f 29                	jg     800642 <vprintfmt+0x33e>
	else if (lflag)
  800619:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80061d:	74 44                	je     800663 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8b 00                	mov    (%eax),%eax
  800624:	ba 00 00 00 00       	mov    $0x0,%edx
  800629:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8d 40 04             	lea    0x4(%eax),%eax
  800635:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800638:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063d:	e9 ea 00 00 00       	jmp    80072c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8b 50 04             	mov    0x4(%eax),%edx
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8d 40 08             	lea    0x8(%eax),%eax
  800656:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800659:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065e:	e9 c9 00 00 00       	jmp    80072c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8b 00                	mov    (%eax),%eax
  800668:	ba 00 00 00 00       	mov    $0x0,%edx
  80066d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800670:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	8d 40 04             	lea    0x4(%eax),%eax
  800679:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800681:	e9 a6 00 00 00       	jmp    80072c <vprintfmt+0x428>
			putch('0', putdat);
  800686:	83 ec 08             	sub    $0x8,%esp
  800689:	53                   	push   %ebx
  80068a:	6a 30                	push   $0x30
  80068c:	ff d6                	call   *%esi
	if (lflag >= 2)
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800695:	7f 26                	jg     8006bd <vprintfmt+0x3b9>
	else if (lflag)
  800697:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80069b:	74 3e                	je     8006db <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8d 40 04             	lea    0x4(%eax),%eax
  8006b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b6:	b8 08 00 00 00       	mov    $0x8,%eax
  8006bb:	eb 6f                	jmp    80072c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8b 50 04             	mov    0x4(%eax),%edx
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ce:	8d 40 08             	lea    0x8(%eax),%eax
  8006d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d4:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d9:	eb 51                	jmp    80072c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8d 40 04             	lea    0x4(%eax),%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f4:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f9:	eb 31                	jmp    80072c <vprintfmt+0x428>
			putch('0', putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	53                   	push   %ebx
  8006ff:	6a 30                	push   $0x30
  800701:	ff d6                	call   *%esi
			putch('x', putdat);
  800703:	83 c4 08             	add    $0x8,%esp
  800706:	53                   	push   %ebx
  800707:	6a 78                	push   $0x78
  800709:	ff d6                	call   *%esi
			num = (unsigned long long)
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	ba 00 00 00 00       	mov    $0x0,%edx
  800715:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800718:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80071b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8d 40 04             	lea    0x4(%eax),%eax
  800724:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800727:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800733:	52                   	push   %edx
  800734:	ff 75 e0             	pushl  -0x20(%ebp)
  800737:	50                   	push   %eax
  800738:	ff 75 dc             	pushl  -0x24(%ebp)
  80073b:	ff 75 d8             	pushl  -0x28(%ebp)
  80073e:	89 da                	mov    %ebx,%edx
  800740:	89 f0                	mov    %esi,%eax
  800742:	e8 a4 fa ff ff       	call   8001eb <printnum>
			break;
  800747:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80074a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074d:	83 c7 01             	add    $0x1,%edi
  800750:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800754:	83 f8 25             	cmp    $0x25,%eax
  800757:	0f 84 be fb ff ff    	je     80031b <vprintfmt+0x17>
			if (ch == '\0')
  80075d:	85 c0                	test   %eax,%eax
  80075f:	0f 84 28 01 00 00    	je     80088d <vprintfmt+0x589>
			putch(ch, putdat);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	53                   	push   %ebx
  800769:	50                   	push   %eax
  80076a:	ff d6                	call   *%esi
  80076c:	83 c4 10             	add    $0x10,%esp
  80076f:	eb dc                	jmp    80074d <vprintfmt+0x449>
	if (lflag >= 2)
  800771:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800775:	7f 26                	jg     80079d <vprintfmt+0x499>
	else if (lflag)
  800777:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80077b:	74 41                	je     8007be <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8b 00                	mov    (%eax),%eax
  800782:	ba 00 00 00 00       	mov    $0x0,%edx
  800787:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8d 40 04             	lea    0x4(%eax),%eax
  800793:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800796:	b8 10 00 00 00       	mov    $0x10,%eax
  80079b:	eb 8f                	jmp    80072c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 50 04             	mov    0x4(%eax),%edx
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	8d 40 08             	lea    0x8(%eax),%eax
  8007b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b4:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b9:	e9 6e ff ff ff       	jmp    80072c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
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
  8007dc:	e9 4b ff ff ff       	jmp    80072c <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	83 c0 04             	add    $0x4,%eax
  8007e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	85 c0                	test   %eax,%eax
  8007f1:	74 14                	je     800807 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007f3:	8b 13                	mov    (%ebx),%edx
  8007f5:	83 fa 7f             	cmp    $0x7f,%edx
  8007f8:	7f 37                	jg     800831 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007fa:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800802:	e9 43 ff ff ff       	jmp    80074a <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800807:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080c:	bf fd 26 80 00       	mov    $0x8026fd,%edi
							putch(ch, putdat);
  800811:	83 ec 08             	sub    $0x8,%esp
  800814:	53                   	push   %ebx
  800815:	50                   	push   %eax
  800816:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800818:	83 c7 01             	add    $0x1,%edi
  80081b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80081f:	83 c4 10             	add    $0x10,%esp
  800822:	85 c0                	test   %eax,%eax
  800824:	75 eb                	jne    800811 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800826:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800829:	89 45 14             	mov    %eax,0x14(%ebp)
  80082c:	e9 19 ff ff ff       	jmp    80074a <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800831:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800833:	b8 0a 00 00 00       	mov    $0xa,%eax
  800838:	bf 35 27 80 00       	mov    $0x802735,%edi
							putch(ch, putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	53                   	push   %ebx
  800841:	50                   	push   %eax
  800842:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800844:	83 c7 01             	add    $0x1,%edi
  800847:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80084b:	83 c4 10             	add    $0x10,%esp
  80084e:	85 c0                	test   %eax,%eax
  800850:	75 eb                	jne    80083d <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800852:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800855:	89 45 14             	mov    %eax,0x14(%ebp)
  800858:	e9 ed fe ff ff       	jmp    80074a <vprintfmt+0x446>
			putch(ch, putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	53                   	push   %ebx
  800861:	6a 25                	push   $0x25
  800863:	ff d6                	call   *%esi
			break;
  800865:	83 c4 10             	add    $0x10,%esp
  800868:	e9 dd fe ff ff       	jmp    80074a <vprintfmt+0x446>
			putch('%', putdat);
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	53                   	push   %ebx
  800871:	6a 25                	push   $0x25
  800873:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800875:	83 c4 10             	add    $0x10,%esp
  800878:	89 f8                	mov    %edi,%eax
  80087a:	eb 03                	jmp    80087f <vprintfmt+0x57b>
  80087c:	83 e8 01             	sub    $0x1,%eax
  80087f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800883:	75 f7                	jne    80087c <vprintfmt+0x578>
  800885:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800888:	e9 bd fe ff ff       	jmp    80074a <vprintfmt+0x446>
}
  80088d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800890:	5b                   	pop    %ebx
  800891:	5e                   	pop    %esi
  800892:	5f                   	pop    %edi
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    

00800895 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	83 ec 18             	sub    $0x18,%esp
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008a4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008a8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008b2:	85 c0                	test   %eax,%eax
  8008b4:	74 26                	je     8008dc <vsnprintf+0x47>
  8008b6:	85 d2                	test   %edx,%edx
  8008b8:	7e 22                	jle    8008dc <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ba:	ff 75 14             	pushl  0x14(%ebp)
  8008bd:	ff 75 10             	pushl  0x10(%ebp)
  8008c0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c3:	50                   	push   %eax
  8008c4:	68 ca 02 80 00       	push   $0x8002ca
  8008c9:	e8 36 fa ff ff       	call   800304 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d7:	83 c4 10             	add    $0x10,%esp
}
  8008da:	c9                   	leave  
  8008db:	c3                   	ret    
		return -E_INVAL;
  8008dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008e1:	eb f7                	jmp    8008da <vsnprintf+0x45>

008008e3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008ec:	50                   	push   %eax
  8008ed:	ff 75 10             	pushl  0x10(%ebp)
  8008f0:	ff 75 0c             	pushl  0xc(%ebp)
  8008f3:	ff 75 08             	pushl  0x8(%ebp)
  8008f6:	e8 9a ff ff ff       	call   800895 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008fb:	c9                   	leave  
  8008fc:	c3                   	ret    

008008fd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008fd:	55                   	push   %ebp
  8008fe:	89 e5                	mov    %esp,%ebp
  800900:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800903:	b8 00 00 00 00       	mov    $0x0,%eax
  800908:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80090c:	74 05                	je     800913 <strlen+0x16>
		n++;
  80090e:	83 c0 01             	add    $0x1,%eax
  800911:	eb f5                	jmp    800908 <strlen+0xb>
	return n;
}
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091e:	ba 00 00 00 00       	mov    $0x0,%edx
  800923:	39 c2                	cmp    %eax,%edx
  800925:	74 0d                	je     800934 <strnlen+0x1f>
  800927:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80092b:	74 05                	je     800932 <strnlen+0x1d>
		n++;
  80092d:	83 c2 01             	add    $0x1,%edx
  800930:	eb f1                	jmp    800923 <strnlen+0xe>
  800932:	89 d0                	mov    %edx,%eax
	return n;
}
  800934:	5d                   	pop    %ebp
  800935:	c3                   	ret    

00800936 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	53                   	push   %ebx
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800940:	ba 00 00 00 00       	mov    $0x0,%edx
  800945:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800949:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80094c:	83 c2 01             	add    $0x1,%edx
  80094f:	84 c9                	test   %cl,%cl
  800951:	75 f2                	jne    800945 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800953:	5b                   	pop    %ebx
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	53                   	push   %ebx
  80095a:	83 ec 10             	sub    $0x10,%esp
  80095d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800960:	53                   	push   %ebx
  800961:	e8 97 ff ff ff       	call   8008fd <strlen>
  800966:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800969:	ff 75 0c             	pushl  0xc(%ebp)
  80096c:	01 d8                	add    %ebx,%eax
  80096e:	50                   	push   %eax
  80096f:	e8 c2 ff ff ff       	call   800936 <strcpy>
	return dst;
}
  800974:	89 d8                	mov    %ebx,%eax
  800976:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800979:	c9                   	leave  
  80097a:	c3                   	ret    

0080097b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	56                   	push   %esi
  80097f:	53                   	push   %ebx
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800986:	89 c6                	mov    %eax,%esi
  800988:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80098b:	89 c2                	mov    %eax,%edx
  80098d:	39 f2                	cmp    %esi,%edx
  80098f:	74 11                	je     8009a2 <strncpy+0x27>
		*dst++ = *src;
  800991:	83 c2 01             	add    $0x1,%edx
  800994:	0f b6 19             	movzbl (%ecx),%ebx
  800997:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80099a:	80 fb 01             	cmp    $0x1,%bl
  80099d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009a0:	eb eb                	jmp    80098d <strncpy+0x12>
	}
	return ret;
}
  8009a2:	5b                   	pop    %ebx
  8009a3:	5e                   	pop    %esi
  8009a4:	5d                   	pop    %ebp
  8009a5:	c3                   	ret    

008009a6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	56                   	push   %esi
  8009aa:	53                   	push   %ebx
  8009ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b1:	8b 55 10             	mov    0x10(%ebp),%edx
  8009b4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009b6:	85 d2                	test   %edx,%edx
  8009b8:	74 21                	je     8009db <strlcpy+0x35>
  8009ba:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009be:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009c0:	39 c2                	cmp    %eax,%edx
  8009c2:	74 14                	je     8009d8 <strlcpy+0x32>
  8009c4:	0f b6 19             	movzbl (%ecx),%ebx
  8009c7:	84 db                	test   %bl,%bl
  8009c9:	74 0b                	je     8009d6 <strlcpy+0x30>
			*dst++ = *src++;
  8009cb:	83 c1 01             	add    $0x1,%ecx
  8009ce:	83 c2 01             	add    $0x1,%edx
  8009d1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009d4:	eb ea                	jmp    8009c0 <strlcpy+0x1a>
  8009d6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009d8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009db:	29 f0                	sub    %esi,%eax
}
  8009dd:	5b                   	pop    %ebx
  8009de:	5e                   	pop    %esi
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ea:	0f b6 01             	movzbl (%ecx),%eax
  8009ed:	84 c0                	test   %al,%al
  8009ef:	74 0c                	je     8009fd <strcmp+0x1c>
  8009f1:	3a 02                	cmp    (%edx),%al
  8009f3:	75 08                	jne    8009fd <strcmp+0x1c>
		p++, q++;
  8009f5:	83 c1 01             	add    $0x1,%ecx
  8009f8:	83 c2 01             	add    $0x1,%edx
  8009fb:	eb ed                	jmp    8009ea <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009fd:	0f b6 c0             	movzbl %al,%eax
  800a00:	0f b6 12             	movzbl (%edx),%edx
  800a03:	29 d0                	sub    %edx,%eax
}
  800a05:	5d                   	pop    %ebp
  800a06:	c3                   	ret    

00800a07 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	53                   	push   %ebx
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a11:	89 c3                	mov    %eax,%ebx
  800a13:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a16:	eb 06                	jmp    800a1e <strncmp+0x17>
		n--, p++, q++;
  800a18:	83 c0 01             	add    $0x1,%eax
  800a1b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a1e:	39 d8                	cmp    %ebx,%eax
  800a20:	74 16                	je     800a38 <strncmp+0x31>
  800a22:	0f b6 08             	movzbl (%eax),%ecx
  800a25:	84 c9                	test   %cl,%cl
  800a27:	74 04                	je     800a2d <strncmp+0x26>
  800a29:	3a 0a                	cmp    (%edx),%cl
  800a2b:	74 eb                	je     800a18 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2d:	0f b6 00             	movzbl (%eax),%eax
  800a30:	0f b6 12             	movzbl (%edx),%edx
  800a33:	29 d0                	sub    %edx,%eax
}
  800a35:	5b                   	pop    %ebx
  800a36:	5d                   	pop    %ebp
  800a37:	c3                   	ret    
		return 0;
  800a38:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3d:	eb f6                	jmp    800a35 <strncmp+0x2e>

00800a3f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a49:	0f b6 10             	movzbl (%eax),%edx
  800a4c:	84 d2                	test   %dl,%dl
  800a4e:	74 09                	je     800a59 <strchr+0x1a>
		if (*s == c)
  800a50:	38 ca                	cmp    %cl,%dl
  800a52:	74 0a                	je     800a5e <strchr+0x1f>
	for (; *s; s++)
  800a54:	83 c0 01             	add    $0x1,%eax
  800a57:	eb f0                	jmp    800a49 <strchr+0xa>
			return (char *) s;
	return 0;
  800a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a6a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a6d:	38 ca                	cmp    %cl,%dl
  800a6f:	74 09                	je     800a7a <strfind+0x1a>
  800a71:	84 d2                	test   %dl,%dl
  800a73:	74 05                	je     800a7a <strfind+0x1a>
	for (; *s; s++)
  800a75:	83 c0 01             	add    $0x1,%eax
  800a78:	eb f0                	jmp    800a6a <strfind+0xa>
			break;
	return (char *) s;
}
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	57                   	push   %edi
  800a80:	56                   	push   %esi
  800a81:	53                   	push   %ebx
  800a82:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a85:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a88:	85 c9                	test   %ecx,%ecx
  800a8a:	74 31                	je     800abd <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a8c:	89 f8                	mov    %edi,%eax
  800a8e:	09 c8                	or     %ecx,%eax
  800a90:	a8 03                	test   $0x3,%al
  800a92:	75 23                	jne    800ab7 <memset+0x3b>
		c &= 0xFF;
  800a94:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a98:	89 d3                	mov    %edx,%ebx
  800a9a:	c1 e3 08             	shl    $0x8,%ebx
  800a9d:	89 d0                	mov    %edx,%eax
  800a9f:	c1 e0 18             	shl    $0x18,%eax
  800aa2:	89 d6                	mov    %edx,%esi
  800aa4:	c1 e6 10             	shl    $0x10,%esi
  800aa7:	09 f0                	or     %esi,%eax
  800aa9:	09 c2                	or     %eax,%edx
  800aab:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aad:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab0:	89 d0                	mov    %edx,%eax
  800ab2:	fc                   	cld    
  800ab3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab5:	eb 06                	jmp    800abd <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aba:	fc                   	cld    
  800abb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800abd:	89 f8                	mov    %edi,%eax
  800abf:	5b                   	pop    %ebx
  800ac0:	5e                   	pop    %esi
  800ac1:	5f                   	pop    %edi
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	57                   	push   %edi
  800ac8:	56                   	push   %esi
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800acf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ad2:	39 c6                	cmp    %eax,%esi
  800ad4:	73 32                	jae    800b08 <memmove+0x44>
  800ad6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ad9:	39 c2                	cmp    %eax,%edx
  800adb:	76 2b                	jbe    800b08 <memmove+0x44>
		s += n;
		d += n;
  800add:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae0:	89 fe                	mov    %edi,%esi
  800ae2:	09 ce                	or     %ecx,%esi
  800ae4:	09 d6                	or     %edx,%esi
  800ae6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aec:	75 0e                	jne    800afc <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aee:	83 ef 04             	sub    $0x4,%edi
  800af1:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800af7:	fd                   	std    
  800af8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800afa:	eb 09                	jmp    800b05 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800afc:	83 ef 01             	sub    $0x1,%edi
  800aff:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b02:	fd                   	std    
  800b03:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b05:	fc                   	cld    
  800b06:	eb 1a                	jmp    800b22 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b08:	89 c2                	mov    %eax,%edx
  800b0a:	09 ca                	or     %ecx,%edx
  800b0c:	09 f2                	or     %esi,%edx
  800b0e:	f6 c2 03             	test   $0x3,%dl
  800b11:	75 0a                	jne    800b1d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b13:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b16:	89 c7                	mov    %eax,%edi
  800b18:	fc                   	cld    
  800b19:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1b:	eb 05                	jmp    800b22 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b1d:	89 c7                	mov    %eax,%edi
  800b1f:	fc                   	cld    
  800b20:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b22:	5e                   	pop    %esi
  800b23:	5f                   	pop    %edi
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b2c:	ff 75 10             	pushl  0x10(%ebp)
  800b2f:	ff 75 0c             	pushl  0xc(%ebp)
  800b32:	ff 75 08             	pushl  0x8(%ebp)
  800b35:	e8 8a ff ff ff       	call   800ac4 <memmove>
}
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	56                   	push   %esi
  800b40:	53                   	push   %ebx
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b47:	89 c6                	mov    %eax,%esi
  800b49:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b4c:	39 f0                	cmp    %esi,%eax
  800b4e:	74 1c                	je     800b6c <memcmp+0x30>
		if (*s1 != *s2)
  800b50:	0f b6 08             	movzbl (%eax),%ecx
  800b53:	0f b6 1a             	movzbl (%edx),%ebx
  800b56:	38 d9                	cmp    %bl,%cl
  800b58:	75 08                	jne    800b62 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b5a:	83 c0 01             	add    $0x1,%eax
  800b5d:	83 c2 01             	add    $0x1,%edx
  800b60:	eb ea                	jmp    800b4c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b62:	0f b6 c1             	movzbl %cl,%eax
  800b65:	0f b6 db             	movzbl %bl,%ebx
  800b68:	29 d8                	sub    %ebx,%eax
  800b6a:	eb 05                	jmp    800b71 <memcmp+0x35>
	}

	return 0;
  800b6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b71:	5b                   	pop    %ebx
  800b72:	5e                   	pop    %esi
  800b73:	5d                   	pop    %ebp
  800b74:	c3                   	ret    

00800b75 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b7e:	89 c2                	mov    %eax,%edx
  800b80:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b83:	39 d0                	cmp    %edx,%eax
  800b85:	73 09                	jae    800b90 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b87:	38 08                	cmp    %cl,(%eax)
  800b89:	74 05                	je     800b90 <memfind+0x1b>
	for (; s < ends; s++)
  800b8b:	83 c0 01             	add    $0x1,%eax
  800b8e:	eb f3                	jmp    800b83 <memfind+0xe>
			break;
	return (void *) s;
}
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	57                   	push   %edi
  800b96:	56                   	push   %esi
  800b97:	53                   	push   %ebx
  800b98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9e:	eb 03                	jmp    800ba3 <strtol+0x11>
		s++;
  800ba0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ba3:	0f b6 01             	movzbl (%ecx),%eax
  800ba6:	3c 20                	cmp    $0x20,%al
  800ba8:	74 f6                	je     800ba0 <strtol+0xe>
  800baa:	3c 09                	cmp    $0x9,%al
  800bac:	74 f2                	je     800ba0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bae:	3c 2b                	cmp    $0x2b,%al
  800bb0:	74 2a                	je     800bdc <strtol+0x4a>
	int neg = 0;
  800bb2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bb7:	3c 2d                	cmp    $0x2d,%al
  800bb9:	74 2b                	je     800be6 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bbb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bc1:	75 0f                	jne    800bd2 <strtol+0x40>
  800bc3:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc6:	74 28                	je     800bf0 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc8:	85 db                	test   %ebx,%ebx
  800bca:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bcf:	0f 44 d8             	cmove  %eax,%ebx
  800bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bda:	eb 50                	jmp    800c2c <strtol+0x9a>
		s++;
  800bdc:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bdf:	bf 00 00 00 00       	mov    $0x0,%edi
  800be4:	eb d5                	jmp    800bbb <strtol+0x29>
		s++, neg = 1;
  800be6:	83 c1 01             	add    $0x1,%ecx
  800be9:	bf 01 00 00 00       	mov    $0x1,%edi
  800bee:	eb cb                	jmp    800bbb <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bf4:	74 0e                	je     800c04 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bf6:	85 db                	test   %ebx,%ebx
  800bf8:	75 d8                	jne    800bd2 <strtol+0x40>
		s++, base = 8;
  800bfa:	83 c1 01             	add    $0x1,%ecx
  800bfd:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c02:	eb ce                	jmp    800bd2 <strtol+0x40>
		s += 2, base = 16;
  800c04:	83 c1 02             	add    $0x2,%ecx
  800c07:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c0c:	eb c4                	jmp    800bd2 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c0e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c11:	89 f3                	mov    %esi,%ebx
  800c13:	80 fb 19             	cmp    $0x19,%bl
  800c16:	77 29                	ja     800c41 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c18:	0f be d2             	movsbl %dl,%edx
  800c1b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c1e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c21:	7d 30                	jge    800c53 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c23:	83 c1 01             	add    $0x1,%ecx
  800c26:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c2a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c2c:	0f b6 11             	movzbl (%ecx),%edx
  800c2f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c32:	89 f3                	mov    %esi,%ebx
  800c34:	80 fb 09             	cmp    $0x9,%bl
  800c37:	77 d5                	ja     800c0e <strtol+0x7c>
			dig = *s - '0';
  800c39:	0f be d2             	movsbl %dl,%edx
  800c3c:	83 ea 30             	sub    $0x30,%edx
  800c3f:	eb dd                	jmp    800c1e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c41:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c44:	89 f3                	mov    %esi,%ebx
  800c46:	80 fb 19             	cmp    $0x19,%bl
  800c49:	77 08                	ja     800c53 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c4b:	0f be d2             	movsbl %dl,%edx
  800c4e:	83 ea 37             	sub    $0x37,%edx
  800c51:	eb cb                	jmp    800c1e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c57:	74 05                	je     800c5e <strtol+0xcc>
		*endptr = (char *) s;
  800c59:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c5e:	89 c2                	mov    %eax,%edx
  800c60:	f7 da                	neg    %edx
  800c62:	85 ff                	test   %edi,%edi
  800c64:	0f 45 c2             	cmovne %edx,%eax
}
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5f                   	pop    %edi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    

00800c6c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	57                   	push   %edi
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c72:	b8 00 00 00 00       	mov    $0x0,%eax
  800c77:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7d:	89 c3                	mov    %eax,%ebx
  800c7f:	89 c7                	mov    %eax,%edi
  800c81:	89 c6                	mov    %eax,%esi
  800c83:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <sys_cgetc>:

int
sys_cgetc(void)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c90:	ba 00 00 00 00       	mov    $0x0,%edx
  800c95:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9a:	89 d1                	mov    %edx,%ecx
  800c9c:	89 d3                	mov    %edx,%ebx
  800c9e:	89 d7                	mov    %edx,%edi
  800ca0:	89 d6                	mov    %edx,%esi
  800ca2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	57                   	push   %edi
  800cad:	56                   	push   %esi
  800cae:	53                   	push   %ebx
  800caf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cba:	b8 03 00 00 00       	mov    $0x3,%eax
  800cbf:	89 cb                	mov    %ecx,%ebx
  800cc1:	89 cf                	mov    %ecx,%edi
  800cc3:	89 ce                	mov    %ecx,%esi
  800cc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc7:	85 c0                	test   %eax,%eax
  800cc9:	7f 08                	jg     800cd3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ccb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd3:	83 ec 0c             	sub    $0xc,%esp
  800cd6:	50                   	push   %eax
  800cd7:	6a 03                	push   $0x3
  800cd9:	68 48 29 80 00       	push   $0x802948
  800cde:	6a 43                	push   $0x43
  800ce0:	68 65 29 80 00       	push   $0x802965
  800ce5:	e8 89 14 00 00       	call   802173 <_panic>

00800cea <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	57                   	push   %edi
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf5:	b8 02 00 00 00       	mov    $0x2,%eax
  800cfa:	89 d1                	mov    %edx,%ecx
  800cfc:	89 d3                	mov    %edx,%ebx
  800cfe:	89 d7                	mov    %edx,%edi
  800d00:	89 d6                	mov    %edx,%esi
  800d02:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d04:	5b                   	pop    %ebx
  800d05:	5e                   	pop    %esi
  800d06:	5f                   	pop    %edi
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    

00800d09 <sys_yield>:

void
sys_yield(void)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	57                   	push   %edi
  800d0d:	56                   	push   %esi
  800d0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d14:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d19:	89 d1                	mov    %edx,%ecx
  800d1b:	89 d3                	mov    %edx,%ebx
  800d1d:	89 d7                	mov    %edx,%edi
  800d1f:	89 d6                	mov    %edx,%esi
  800d21:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d23:	5b                   	pop    %ebx
  800d24:	5e                   	pop    %esi
  800d25:	5f                   	pop    %edi
  800d26:	5d                   	pop    %ebp
  800d27:	c3                   	ret    

00800d28 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	57                   	push   %edi
  800d2c:	56                   	push   %esi
  800d2d:	53                   	push   %ebx
  800d2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d31:	be 00 00 00 00       	mov    $0x0,%esi
  800d36:	8b 55 08             	mov    0x8(%ebp),%edx
  800d39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3c:	b8 04 00 00 00       	mov    $0x4,%eax
  800d41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d44:	89 f7                	mov    %esi,%edi
  800d46:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d48:	85 c0                	test   %eax,%eax
  800d4a:	7f 08                	jg     800d54 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4f:	5b                   	pop    %ebx
  800d50:	5e                   	pop    %esi
  800d51:	5f                   	pop    %edi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d54:	83 ec 0c             	sub    $0xc,%esp
  800d57:	50                   	push   %eax
  800d58:	6a 04                	push   $0x4
  800d5a:	68 48 29 80 00       	push   $0x802948
  800d5f:	6a 43                	push   $0x43
  800d61:	68 65 29 80 00       	push   $0x802965
  800d66:	e8 08 14 00 00       	call   802173 <_panic>

00800d6b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	57                   	push   %edi
  800d6f:	56                   	push   %esi
  800d70:	53                   	push   %ebx
  800d71:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d74:	8b 55 08             	mov    0x8(%ebp),%edx
  800d77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d82:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d85:	8b 75 18             	mov    0x18(%ebp),%esi
  800d88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8a:	85 c0                	test   %eax,%eax
  800d8c:	7f 08                	jg     800d96 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d91:	5b                   	pop    %ebx
  800d92:	5e                   	pop    %esi
  800d93:	5f                   	pop    %edi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d96:	83 ec 0c             	sub    $0xc,%esp
  800d99:	50                   	push   %eax
  800d9a:	6a 05                	push   $0x5
  800d9c:	68 48 29 80 00       	push   $0x802948
  800da1:	6a 43                	push   $0x43
  800da3:	68 65 29 80 00       	push   $0x802965
  800da8:	e8 c6 13 00 00       	call   802173 <_panic>

00800dad <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	57                   	push   %edi
  800db1:	56                   	push   %esi
  800db2:	53                   	push   %ebx
  800db3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc1:	b8 06 00 00 00       	mov    $0x6,%eax
  800dc6:	89 df                	mov    %ebx,%edi
  800dc8:	89 de                	mov    %ebx,%esi
  800dca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	7f 08                	jg     800dd8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd3:	5b                   	pop    %ebx
  800dd4:	5e                   	pop    %esi
  800dd5:	5f                   	pop    %edi
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd8:	83 ec 0c             	sub    $0xc,%esp
  800ddb:	50                   	push   %eax
  800ddc:	6a 06                	push   $0x6
  800dde:	68 48 29 80 00       	push   $0x802948
  800de3:	6a 43                	push   $0x43
  800de5:	68 65 29 80 00       	push   $0x802965
  800dea:	e8 84 13 00 00       	call   802173 <_panic>

00800def <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	57                   	push   %edi
  800df3:	56                   	push   %esi
  800df4:	53                   	push   %ebx
  800df5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800e00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e03:	b8 08 00 00 00       	mov    $0x8,%eax
  800e08:	89 df                	mov    %ebx,%edi
  800e0a:	89 de                	mov    %ebx,%esi
  800e0c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	7f 08                	jg     800e1a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1a:	83 ec 0c             	sub    $0xc,%esp
  800e1d:	50                   	push   %eax
  800e1e:	6a 08                	push   $0x8
  800e20:	68 48 29 80 00       	push   $0x802948
  800e25:	6a 43                	push   $0x43
  800e27:	68 65 29 80 00       	push   $0x802965
  800e2c:	e8 42 13 00 00       	call   802173 <_panic>

00800e31 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	57                   	push   %edi
  800e35:	56                   	push   %esi
  800e36:	53                   	push   %ebx
  800e37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e45:	b8 09 00 00 00       	mov    $0x9,%eax
  800e4a:	89 df                	mov    %ebx,%edi
  800e4c:	89 de                	mov    %ebx,%esi
  800e4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e50:	85 c0                	test   %eax,%eax
  800e52:	7f 08                	jg     800e5c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e57:	5b                   	pop    %ebx
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5c:	83 ec 0c             	sub    $0xc,%esp
  800e5f:	50                   	push   %eax
  800e60:	6a 09                	push   $0x9
  800e62:	68 48 29 80 00       	push   $0x802948
  800e67:	6a 43                	push   $0x43
  800e69:	68 65 29 80 00       	push   $0x802965
  800e6e:	e8 00 13 00 00       	call   802173 <_panic>

00800e73 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	57                   	push   %edi
  800e77:	56                   	push   %esi
  800e78:	53                   	push   %ebx
  800e79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e81:	8b 55 08             	mov    0x8(%ebp),%edx
  800e84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e87:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e8c:	89 df                	mov    %ebx,%edi
  800e8e:	89 de                	mov    %ebx,%esi
  800e90:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e92:	85 c0                	test   %eax,%eax
  800e94:	7f 08                	jg     800e9e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e99:	5b                   	pop    %ebx
  800e9a:	5e                   	pop    %esi
  800e9b:	5f                   	pop    %edi
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	50                   	push   %eax
  800ea2:	6a 0a                	push   $0xa
  800ea4:	68 48 29 80 00       	push   $0x802948
  800ea9:	6a 43                	push   $0x43
  800eab:	68 65 29 80 00       	push   $0x802965
  800eb0:	e8 be 12 00 00       	call   802173 <_panic>

00800eb5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	57                   	push   %edi
  800eb9:	56                   	push   %esi
  800eba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ec6:	be 00 00 00 00       	mov    $0x0,%esi
  800ecb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ece:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed3:	5b                   	pop    %ebx
  800ed4:	5e                   	pop    %esi
  800ed5:	5f                   	pop    %edi
  800ed6:	5d                   	pop    %ebp
  800ed7:	c3                   	ret    

00800ed8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	57                   	push   %edi
  800edc:	56                   	push   %esi
  800edd:	53                   	push   %ebx
  800ede:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eee:	89 cb                	mov    %ecx,%ebx
  800ef0:	89 cf                	mov    %ecx,%edi
  800ef2:	89 ce                	mov    %ecx,%esi
  800ef4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	7f 08                	jg     800f02 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efd:	5b                   	pop    %ebx
  800efe:	5e                   	pop    %esi
  800eff:	5f                   	pop    %edi
  800f00:	5d                   	pop    %ebp
  800f01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f02:	83 ec 0c             	sub    $0xc,%esp
  800f05:	50                   	push   %eax
  800f06:	6a 0d                	push   $0xd
  800f08:	68 48 29 80 00       	push   $0x802948
  800f0d:	6a 43                	push   $0x43
  800f0f:	68 65 29 80 00       	push   $0x802965
  800f14:	e8 5a 12 00 00       	call   802173 <_panic>

00800f19 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f24:	8b 55 08             	mov    0x8(%ebp),%edx
  800f27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f2f:	89 df                	mov    %ebx,%edi
  800f31:	89 de                	mov    %ebx,%esi
  800f33:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5f                   	pop    %edi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    

00800f3a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	57                   	push   %edi
  800f3e:	56                   	push   %esi
  800f3f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f40:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f45:	8b 55 08             	mov    0x8(%ebp),%edx
  800f48:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f4d:	89 cb                	mov    %ecx,%ebx
  800f4f:	89 cf                	mov    %ecx,%edi
  800f51:	89 ce                	mov    %ecx,%esi
  800f53:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f55:	5b                   	pop    %ebx
  800f56:	5e                   	pop    %esi
  800f57:	5f                   	pop    %edi
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    

00800f5a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	57                   	push   %edi
  800f5e:	56                   	push   %esi
  800f5f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f60:	ba 00 00 00 00       	mov    $0x0,%edx
  800f65:	b8 10 00 00 00       	mov    $0x10,%eax
  800f6a:	89 d1                	mov    %edx,%ecx
  800f6c:	89 d3                	mov    %edx,%ebx
  800f6e:	89 d7                	mov    %edx,%edi
  800f70:	89 d6                	mov    %edx,%esi
  800f72:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    

00800f79 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	57                   	push   %edi
  800f7d:	56                   	push   %esi
  800f7e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f84:	8b 55 08             	mov    0x8(%ebp),%edx
  800f87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8a:	b8 11 00 00 00       	mov    $0x11,%eax
  800f8f:	89 df                	mov    %ebx,%edi
  800f91:	89 de                	mov    %ebx,%esi
  800f93:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f95:	5b                   	pop    %ebx
  800f96:	5e                   	pop    %esi
  800f97:	5f                   	pop    %edi
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    

00800f9a <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	57                   	push   %edi
  800f9e:	56                   	push   %esi
  800f9f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fab:	b8 12 00 00 00       	mov    $0x12,%eax
  800fb0:	89 df                	mov    %ebx,%edi
  800fb2:	89 de                	mov    %ebx,%esi
  800fb4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fb6:	5b                   	pop    %ebx
  800fb7:	5e                   	pop    %esi
  800fb8:	5f                   	pop    %edi
  800fb9:	5d                   	pop    %ebp
  800fba:	c3                   	ret    

00800fbb <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	57                   	push   %edi
  800fbf:	56                   	push   %esi
  800fc0:	53                   	push   %ebx
  800fc1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcf:	b8 13 00 00 00       	mov    $0x13,%eax
  800fd4:	89 df                	mov    %ebx,%edi
  800fd6:	89 de                	mov    %ebx,%esi
  800fd8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	7f 08                	jg     800fe6 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe1:	5b                   	pop    %ebx
  800fe2:	5e                   	pop    %esi
  800fe3:	5f                   	pop    %edi
  800fe4:	5d                   	pop    %ebp
  800fe5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe6:	83 ec 0c             	sub    $0xc,%esp
  800fe9:	50                   	push   %eax
  800fea:	6a 13                	push   $0x13
  800fec:	68 48 29 80 00       	push   $0x802948
  800ff1:	6a 43                	push   $0x43
  800ff3:	68 65 29 80 00       	push   $0x802965
  800ff8:	e8 76 11 00 00       	call   802173 <_panic>

00800ffd <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	57                   	push   %edi
  801001:	56                   	push   %esi
  801002:	53                   	push   %ebx
	asm volatile("int %1\n"
  801003:	b9 00 00 00 00       	mov    $0x0,%ecx
  801008:	8b 55 08             	mov    0x8(%ebp),%edx
  80100b:	b8 14 00 00 00       	mov    $0x14,%eax
  801010:	89 cb                	mov    %ecx,%ebx
  801012:	89 cf                	mov    %ecx,%edi
  801014:	89 ce                	mov    %ecx,%esi
  801016:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801018:	5b                   	pop    %ebx
  801019:	5e                   	pop    %esi
  80101a:	5f                   	pop    %edi
  80101b:	5d                   	pop    %ebp
  80101c:	c3                   	ret    

0080101d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	05 00 00 00 30       	add    $0x30000000,%eax
  801028:	c1 e8 0c             	shr    $0xc,%eax
}
  80102b:	5d                   	pop    %ebp
  80102c:	c3                   	ret    

0080102d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801038:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80103d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801042:	5d                   	pop    %ebp
  801043:	c3                   	ret    

00801044 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80104c:	89 c2                	mov    %eax,%edx
  80104e:	c1 ea 16             	shr    $0x16,%edx
  801051:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801058:	f6 c2 01             	test   $0x1,%dl
  80105b:	74 2d                	je     80108a <fd_alloc+0x46>
  80105d:	89 c2                	mov    %eax,%edx
  80105f:	c1 ea 0c             	shr    $0xc,%edx
  801062:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801069:	f6 c2 01             	test   $0x1,%dl
  80106c:	74 1c                	je     80108a <fd_alloc+0x46>
  80106e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801073:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801078:	75 d2                	jne    80104c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801083:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801088:	eb 0a                	jmp    801094 <fd_alloc+0x50>
			*fd_store = fd;
  80108a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80108f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    

00801096 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80109c:	83 f8 1f             	cmp    $0x1f,%eax
  80109f:	77 30                	ja     8010d1 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010a1:	c1 e0 0c             	shl    $0xc,%eax
  8010a4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010a9:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010af:	f6 c2 01             	test   $0x1,%dl
  8010b2:	74 24                	je     8010d8 <fd_lookup+0x42>
  8010b4:	89 c2                	mov    %eax,%edx
  8010b6:	c1 ea 0c             	shr    $0xc,%edx
  8010b9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010c0:	f6 c2 01             	test   $0x1,%dl
  8010c3:	74 1a                	je     8010df <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c8:	89 02                	mov    %eax,(%edx)
	return 0;
  8010ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010cf:	5d                   	pop    %ebp
  8010d0:	c3                   	ret    
		return -E_INVAL;
  8010d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d6:	eb f7                	jmp    8010cf <fd_lookup+0x39>
		return -E_INVAL;
  8010d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010dd:	eb f0                	jmp    8010cf <fd_lookup+0x39>
  8010df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e4:	eb e9                	jmp    8010cf <fd_lookup+0x39>

008010e6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	83 ec 08             	sub    $0x8,%esp
  8010ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f4:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010f9:	39 08                	cmp    %ecx,(%eax)
  8010fb:	74 38                	je     801135 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010fd:	83 c2 01             	add    $0x1,%edx
  801100:	8b 04 95 f0 29 80 00 	mov    0x8029f0(,%edx,4),%eax
  801107:	85 c0                	test   %eax,%eax
  801109:	75 ee                	jne    8010f9 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80110b:	a1 08 40 80 00       	mov    0x804008,%eax
  801110:	8b 40 48             	mov    0x48(%eax),%eax
  801113:	83 ec 04             	sub    $0x4,%esp
  801116:	51                   	push   %ecx
  801117:	50                   	push   %eax
  801118:	68 74 29 80 00       	push   $0x802974
  80111d:	e8 b5 f0 ff ff       	call   8001d7 <cprintf>
	*dev = 0;
  801122:	8b 45 0c             	mov    0xc(%ebp),%eax
  801125:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80112b:	83 c4 10             	add    $0x10,%esp
  80112e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801133:	c9                   	leave  
  801134:	c3                   	ret    
			*dev = devtab[i];
  801135:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801138:	89 01                	mov    %eax,(%ecx)
			return 0;
  80113a:	b8 00 00 00 00       	mov    $0x0,%eax
  80113f:	eb f2                	jmp    801133 <dev_lookup+0x4d>

00801141 <fd_close>:
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	57                   	push   %edi
  801145:	56                   	push   %esi
  801146:	53                   	push   %ebx
  801147:	83 ec 24             	sub    $0x24,%esp
  80114a:	8b 75 08             	mov    0x8(%ebp),%esi
  80114d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801150:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801153:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801154:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80115a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80115d:	50                   	push   %eax
  80115e:	e8 33 ff ff ff       	call   801096 <fd_lookup>
  801163:	89 c3                	mov    %eax,%ebx
  801165:	83 c4 10             	add    $0x10,%esp
  801168:	85 c0                	test   %eax,%eax
  80116a:	78 05                	js     801171 <fd_close+0x30>
	    || fd != fd2)
  80116c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80116f:	74 16                	je     801187 <fd_close+0x46>
		return (must_exist ? r : 0);
  801171:	89 f8                	mov    %edi,%eax
  801173:	84 c0                	test   %al,%al
  801175:	b8 00 00 00 00       	mov    $0x0,%eax
  80117a:	0f 44 d8             	cmove  %eax,%ebx
}
  80117d:	89 d8                	mov    %ebx,%eax
  80117f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801182:	5b                   	pop    %ebx
  801183:	5e                   	pop    %esi
  801184:	5f                   	pop    %edi
  801185:	5d                   	pop    %ebp
  801186:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801187:	83 ec 08             	sub    $0x8,%esp
  80118a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80118d:	50                   	push   %eax
  80118e:	ff 36                	pushl  (%esi)
  801190:	e8 51 ff ff ff       	call   8010e6 <dev_lookup>
  801195:	89 c3                	mov    %eax,%ebx
  801197:	83 c4 10             	add    $0x10,%esp
  80119a:	85 c0                	test   %eax,%eax
  80119c:	78 1a                	js     8011b8 <fd_close+0x77>
		if (dev->dev_close)
  80119e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011a1:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011a4:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	74 0b                	je     8011b8 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011ad:	83 ec 0c             	sub    $0xc,%esp
  8011b0:	56                   	push   %esi
  8011b1:	ff d0                	call   *%eax
  8011b3:	89 c3                	mov    %eax,%ebx
  8011b5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011b8:	83 ec 08             	sub    $0x8,%esp
  8011bb:	56                   	push   %esi
  8011bc:	6a 00                	push   $0x0
  8011be:	e8 ea fb ff ff       	call   800dad <sys_page_unmap>
	return r;
  8011c3:	83 c4 10             	add    $0x10,%esp
  8011c6:	eb b5                	jmp    80117d <fd_close+0x3c>

008011c8 <close>:

int
close(int fdnum)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d1:	50                   	push   %eax
  8011d2:	ff 75 08             	pushl  0x8(%ebp)
  8011d5:	e8 bc fe ff ff       	call   801096 <fd_lookup>
  8011da:	83 c4 10             	add    $0x10,%esp
  8011dd:	85 c0                	test   %eax,%eax
  8011df:	79 02                	jns    8011e3 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    
		return fd_close(fd, 1);
  8011e3:	83 ec 08             	sub    $0x8,%esp
  8011e6:	6a 01                	push   $0x1
  8011e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8011eb:	e8 51 ff ff ff       	call   801141 <fd_close>
  8011f0:	83 c4 10             	add    $0x10,%esp
  8011f3:	eb ec                	jmp    8011e1 <close+0x19>

008011f5 <close_all>:

void
close_all(void)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	53                   	push   %ebx
  8011f9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011fc:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801201:	83 ec 0c             	sub    $0xc,%esp
  801204:	53                   	push   %ebx
  801205:	e8 be ff ff ff       	call   8011c8 <close>
	for (i = 0; i < MAXFD; i++)
  80120a:	83 c3 01             	add    $0x1,%ebx
  80120d:	83 c4 10             	add    $0x10,%esp
  801210:	83 fb 20             	cmp    $0x20,%ebx
  801213:	75 ec                	jne    801201 <close_all+0xc>
}
  801215:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	57                   	push   %edi
  80121e:	56                   	push   %esi
  80121f:	53                   	push   %ebx
  801220:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801223:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801226:	50                   	push   %eax
  801227:	ff 75 08             	pushl  0x8(%ebp)
  80122a:	e8 67 fe ff ff       	call   801096 <fd_lookup>
  80122f:	89 c3                	mov    %eax,%ebx
  801231:	83 c4 10             	add    $0x10,%esp
  801234:	85 c0                	test   %eax,%eax
  801236:	0f 88 81 00 00 00    	js     8012bd <dup+0xa3>
		return r;
	close(newfdnum);
  80123c:	83 ec 0c             	sub    $0xc,%esp
  80123f:	ff 75 0c             	pushl  0xc(%ebp)
  801242:	e8 81 ff ff ff       	call   8011c8 <close>

	newfd = INDEX2FD(newfdnum);
  801247:	8b 75 0c             	mov    0xc(%ebp),%esi
  80124a:	c1 e6 0c             	shl    $0xc,%esi
  80124d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801253:	83 c4 04             	add    $0x4,%esp
  801256:	ff 75 e4             	pushl  -0x1c(%ebp)
  801259:	e8 cf fd ff ff       	call   80102d <fd2data>
  80125e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801260:	89 34 24             	mov    %esi,(%esp)
  801263:	e8 c5 fd ff ff       	call   80102d <fd2data>
  801268:	83 c4 10             	add    $0x10,%esp
  80126b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80126d:	89 d8                	mov    %ebx,%eax
  80126f:	c1 e8 16             	shr    $0x16,%eax
  801272:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801279:	a8 01                	test   $0x1,%al
  80127b:	74 11                	je     80128e <dup+0x74>
  80127d:	89 d8                	mov    %ebx,%eax
  80127f:	c1 e8 0c             	shr    $0xc,%eax
  801282:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801289:	f6 c2 01             	test   $0x1,%dl
  80128c:	75 39                	jne    8012c7 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80128e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801291:	89 d0                	mov    %edx,%eax
  801293:	c1 e8 0c             	shr    $0xc,%eax
  801296:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80129d:	83 ec 0c             	sub    $0xc,%esp
  8012a0:	25 07 0e 00 00       	and    $0xe07,%eax
  8012a5:	50                   	push   %eax
  8012a6:	56                   	push   %esi
  8012a7:	6a 00                	push   $0x0
  8012a9:	52                   	push   %edx
  8012aa:	6a 00                	push   $0x0
  8012ac:	e8 ba fa ff ff       	call   800d6b <sys_page_map>
  8012b1:	89 c3                	mov    %eax,%ebx
  8012b3:	83 c4 20             	add    $0x20,%esp
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	78 31                	js     8012eb <dup+0xd1>
		goto err;

	return newfdnum;
  8012ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012bd:	89 d8                	mov    %ebx,%eax
  8012bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c2:	5b                   	pop    %ebx
  8012c3:	5e                   	pop    %esi
  8012c4:	5f                   	pop    %edi
  8012c5:	5d                   	pop    %ebp
  8012c6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012c7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012ce:	83 ec 0c             	sub    $0xc,%esp
  8012d1:	25 07 0e 00 00       	and    $0xe07,%eax
  8012d6:	50                   	push   %eax
  8012d7:	57                   	push   %edi
  8012d8:	6a 00                	push   $0x0
  8012da:	53                   	push   %ebx
  8012db:	6a 00                	push   $0x0
  8012dd:	e8 89 fa ff ff       	call   800d6b <sys_page_map>
  8012e2:	89 c3                	mov    %eax,%ebx
  8012e4:	83 c4 20             	add    $0x20,%esp
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	79 a3                	jns    80128e <dup+0x74>
	sys_page_unmap(0, newfd);
  8012eb:	83 ec 08             	sub    $0x8,%esp
  8012ee:	56                   	push   %esi
  8012ef:	6a 00                	push   $0x0
  8012f1:	e8 b7 fa ff ff       	call   800dad <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012f6:	83 c4 08             	add    $0x8,%esp
  8012f9:	57                   	push   %edi
  8012fa:	6a 00                	push   $0x0
  8012fc:	e8 ac fa ff ff       	call   800dad <sys_page_unmap>
	return r;
  801301:	83 c4 10             	add    $0x10,%esp
  801304:	eb b7                	jmp    8012bd <dup+0xa3>

00801306 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	53                   	push   %ebx
  80130a:	83 ec 1c             	sub    $0x1c,%esp
  80130d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801310:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801313:	50                   	push   %eax
  801314:	53                   	push   %ebx
  801315:	e8 7c fd ff ff       	call   801096 <fd_lookup>
  80131a:	83 c4 10             	add    $0x10,%esp
  80131d:	85 c0                	test   %eax,%eax
  80131f:	78 3f                	js     801360 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801321:	83 ec 08             	sub    $0x8,%esp
  801324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801327:	50                   	push   %eax
  801328:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80132b:	ff 30                	pushl  (%eax)
  80132d:	e8 b4 fd ff ff       	call   8010e6 <dev_lookup>
  801332:	83 c4 10             	add    $0x10,%esp
  801335:	85 c0                	test   %eax,%eax
  801337:	78 27                	js     801360 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801339:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80133c:	8b 42 08             	mov    0x8(%edx),%eax
  80133f:	83 e0 03             	and    $0x3,%eax
  801342:	83 f8 01             	cmp    $0x1,%eax
  801345:	74 1e                	je     801365 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134a:	8b 40 08             	mov    0x8(%eax),%eax
  80134d:	85 c0                	test   %eax,%eax
  80134f:	74 35                	je     801386 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801351:	83 ec 04             	sub    $0x4,%esp
  801354:	ff 75 10             	pushl  0x10(%ebp)
  801357:	ff 75 0c             	pushl  0xc(%ebp)
  80135a:	52                   	push   %edx
  80135b:	ff d0                	call   *%eax
  80135d:	83 c4 10             	add    $0x10,%esp
}
  801360:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801363:	c9                   	leave  
  801364:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801365:	a1 08 40 80 00       	mov    0x804008,%eax
  80136a:	8b 40 48             	mov    0x48(%eax),%eax
  80136d:	83 ec 04             	sub    $0x4,%esp
  801370:	53                   	push   %ebx
  801371:	50                   	push   %eax
  801372:	68 b5 29 80 00       	push   $0x8029b5
  801377:	e8 5b ee ff ff       	call   8001d7 <cprintf>
		return -E_INVAL;
  80137c:	83 c4 10             	add    $0x10,%esp
  80137f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801384:	eb da                	jmp    801360 <read+0x5a>
		return -E_NOT_SUPP;
  801386:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80138b:	eb d3                	jmp    801360 <read+0x5a>

0080138d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	57                   	push   %edi
  801391:	56                   	push   %esi
  801392:	53                   	push   %ebx
  801393:	83 ec 0c             	sub    $0xc,%esp
  801396:	8b 7d 08             	mov    0x8(%ebp),%edi
  801399:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80139c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a1:	39 f3                	cmp    %esi,%ebx
  8013a3:	73 23                	jae    8013c8 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013a5:	83 ec 04             	sub    $0x4,%esp
  8013a8:	89 f0                	mov    %esi,%eax
  8013aa:	29 d8                	sub    %ebx,%eax
  8013ac:	50                   	push   %eax
  8013ad:	89 d8                	mov    %ebx,%eax
  8013af:	03 45 0c             	add    0xc(%ebp),%eax
  8013b2:	50                   	push   %eax
  8013b3:	57                   	push   %edi
  8013b4:	e8 4d ff ff ff       	call   801306 <read>
		if (m < 0)
  8013b9:	83 c4 10             	add    $0x10,%esp
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	78 06                	js     8013c6 <readn+0x39>
			return m;
		if (m == 0)
  8013c0:	74 06                	je     8013c8 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013c2:	01 c3                	add    %eax,%ebx
  8013c4:	eb db                	jmp    8013a1 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013c6:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013c8:	89 d8                	mov    %ebx,%eax
  8013ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013cd:	5b                   	pop    %ebx
  8013ce:	5e                   	pop    %esi
  8013cf:	5f                   	pop    %edi
  8013d0:	5d                   	pop    %ebp
  8013d1:	c3                   	ret    

008013d2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	53                   	push   %ebx
  8013d6:	83 ec 1c             	sub    $0x1c,%esp
  8013d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013df:	50                   	push   %eax
  8013e0:	53                   	push   %ebx
  8013e1:	e8 b0 fc ff ff       	call   801096 <fd_lookup>
  8013e6:	83 c4 10             	add    $0x10,%esp
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	78 3a                	js     801427 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ed:	83 ec 08             	sub    $0x8,%esp
  8013f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f3:	50                   	push   %eax
  8013f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f7:	ff 30                	pushl  (%eax)
  8013f9:	e8 e8 fc ff ff       	call   8010e6 <dev_lookup>
  8013fe:	83 c4 10             	add    $0x10,%esp
  801401:	85 c0                	test   %eax,%eax
  801403:	78 22                	js     801427 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801408:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80140c:	74 1e                	je     80142c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80140e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801411:	8b 52 0c             	mov    0xc(%edx),%edx
  801414:	85 d2                	test   %edx,%edx
  801416:	74 35                	je     80144d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801418:	83 ec 04             	sub    $0x4,%esp
  80141b:	ff 75 10             	pushl  0x10(%ebp)
  80141e:	ff 75 0c             	pushl  0xc(%ebp)
  801421:	50                   	push   %eax
  801422:	ff d2                	call   *%edx
  801424:	83 c4 10             	add    $0x10,%esp
}
  801427:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80142c:	a1 08 40 80 00       	mov    0x804008,%eax
  801431:	8b 40 48             	mov    0x48(%eax),%eax
  801434:	83 ec 04             	sub    $0x4,%esp
  801437:	53                   	push   %ebx
  801438:	50                   	push   %eax
  801439:	68 d1 29 80 00       	push   $0x8029d1
  80143e:	e8 94 ed ff ff       	call   8001d7 <cprintf>
		return -E_INVAL;
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144b:	eb da                	jmp    801427 <write+0x55>
		return -E_NOT_SUPP;
  80144d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801452:	eb d3                	jmp    801427 <write+0x55>

00801454 <seek>:

int
seek(int fdnum, off_t offset)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80145a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145d:	50                   	push   %eax
  80145e:	ff 75 08             	pushl  0x8(%ebp)
  801461:	e8 30 fc ff ff       	call   801096 <fd_lookup>
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	85 c0                	test   %eax,%eax
  80146b:	78 0e                	js     80147b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80146d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801473:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	53                   	push   %ebx
  801481:	83 ec 1c             	sub    $0x1c,%esp
  801484:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801487:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80148a:	50                   	push   %eax
  80148b:	53                   	push   %ebx
  80148c:	e8 05 fc ff ff       	call   801096 <fd_lookup>
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	85 c0                	test   %eax,%eax
  801496:	78 37                	js     8014cf <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801498:	83 ec 08             	sub    $0x8,%esp
  80149b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80149e:	50                   	push   %eax
  80149f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a2:	ff 30                	pushl  (%eax)
  8014a4:	e8 3d fc ff ff       	call   8010e6 <dev_lookup>
  8014a9:	83 c4 10             	add    $0x10,%esp
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	78 1f                	js     8014cf <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014b7:	74 1b                	je     8014d4 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014bc:	8b 52 18             	mov    0x18(%edx),%edx
  8014bf:	85 d2                	test   %edx,%edx
  8014c1:	74 32                	je     8014f5 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014c3:	83 ec 08             	sub    $0x8,%esp
  8014c6:	ff 75 0c             	pushl  0xc(%ebp)
  8014c9:	50                   	push   %eax
  8014ca:	ff d2                	call   *%edx
  8014cc:	83 c4 10             	add    $0x10,%esp
}
  8014cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014d4:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014d9:	8b 40 48             	mov    0x48(%eax),%eax
  8014dc:	83 ec 04             	sub    $0x4,%esp
  8014df:	53                   	push   %ebx
  8014e0:	50                   	push   %eax
  8014e1:	68 94 29 80 00       	push   $0x802994
  8014e6:	e8 ec ec ff ff       	call   8001d7 <cprintf>
		return -E_INVAL;
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f3:	eb da                	jmp    8014cf <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014fa:	eb d3                	jmp    8014cf <ftruncate+0x52>

008014fc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	53                   	push   %ebx
  801500:	83 ec 1c             	sub    $0x1c,%esp
  801503:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801506:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801509:	50                   	push   %eax
  80150a:	ff 75 08             	pushl  0x8(%ebp)
  80150d:	e8 84 fb ff ff       	call   801096 <fd_lookup>
  801512:	83 c4 10             	add    $0x10,%esp
  801515:	85 c0                	test   %eax,%eax
  801517:	78 4b                	js     801564 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801519:	83 ec 08             	sub    $0x8,%esp
  80151c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80151f:	50                   	push   %eax
  801520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801523:	ff 30                	pushl  (%eax)
  801525:	e8 bc fb ff ff       	call   8010e6 <dev_lookup>
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	85 c0                	test   %eax,%eax
  80152f:	78 33                	js     801564 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801534:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801538:	74 2f                	je     801569 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80153a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80153d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801544:	00 00 00 
	stat->st_isdir = 0;
  801547:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80154e:	00 00 00 
	stat->st_dev = dev;
  801551:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801557:	83 ec 08             	sub    $0x8,%esp
  80155a:	53                   	push   %ebx
  80155b:	ff 75 f0             	pushl  -0x10(%ebp)
  80155e:	ff 50 14             	call   *0x14(%eax)
  801561:	83 c4 10             	add    $0x10,%esp
}
  801564:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801567:	c9                   	leave  
  801568:	c3                   	ret    
		return -E_NOT_SUPP;
  801569:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80156e:	eb f4                	jmp    801564 <fstat+0x68>

00801570 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	56                   	push   %esi
  801574:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801575:	83 ec 08             	sub    $0x8,%esp
  801578:	6a 00                	push   $0x0
  80157a:	ff 75 08             	pushl  0x8(%ebp)
  80157d:	e8 22 02 00 00       	call   8017a4 <open>
  801582:	89 c3                	mov    %eax,%ebx
  801584:	83 c4 10             	add    $0x10,%esp
  801587:	85 c0                	test   %eax,%eax
  801589:	78 1b                	js     8015a6 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80158b:	83 ec 08             	sub    $0x8,%esp
  80158e:	ff 75 0c             	pushl  0xc(%ebp)
  801591:	50                   	push   %eax
  801592:	e8 65 ff ff ff       	call   8014fc <fstat>
  801597:	89 c6                	mov    %eax,%esi
	close(fd);
  801599:	89 1c 24             	mov    %ebx,(%esp)
  80159c:	e8 27 fc ff ff       	call   8011c8 <close>
	return r;
  8015a1:	83 c4 10             	add    $0x10,%esp
  8015a4:	89 f3                	mov    %esi,%ebx
}
  8015a6:	89 d8                	mov    %ebx,%eax
  8015a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ab:	5b                   	pop    %ebx
  8015ac:	5e                   	pop    %esi
  8015ad:	5d                   	pop    %ebp
  8015ae:	c3                   	ret    

008015af <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
  8015b2:	56                   	push   %esi
  8015b3:	53                   	push   %ebx
  8015b4:	89 c6                	mov    %eax,%esi
  8015b6:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015b8:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015bf:	74 27                	je     8015e8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015c1:	6a 07                	push   $0x7
  8015c3:	68 00 50 80 00       	push   $0x805000
  8015c8:	56                   	push   %esi
  8015c9:	ff 35 00 40 80 00    	pushl  0x804000
  8015cf:	e8 69 0c 00 00       	call   80223d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015d4:	83 c4 0c             	add    $0xc,%esp
  8015d7:	6a 00                	push   $0x0
  8015d9:	53                   	push   %ebx
  8015da:	6a 00                	push   $0x0
  8015dc:	e8 f3 0b 00 00       	call   8021d4 <ipc_recv>
}
  8015e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e4:	5b                   	pop    %ebx
  8015e5:	5e                   	pop    %esi
  8015e6:	5d                   	pop    %ebp
  8015e7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	6a 01                	push   $0x1
  8015ed:	e8 a3 0c 00 00       	call   802295 <ipc_find_env>
  8015f2:	a3 00 40 80 00       	mov    %eax,0x804000
  8015f7:	83 c4 10             	add    $0x10,%esp
  8015fa:	eb c5                	jmp    8015c1 <fsipc+0x12>

008015fc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	8b 40 0c             	mov    0xc(%eax),%eax
  801608:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80160d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801610:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801615:	ba 00 00 00 00       	mov    $0x0,%edx
  80161a:	b8 02 00 00 00       	mov    $0x2,%eax
  80161f:	e8 8b ff ff ff       	call   8015af <fsipc>
}
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <devfile_flush>:
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8b 40 0c             	mov    0xc(%eax),%eax
  801632:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801637:	ba 00 00 00 00       	mov    $0x0,%edx
  80163c:	b8 06 00 00 00       	mov    $0x6,%eax
  801641:	e8 69 ff ff ff       	call   8015af <fsipc>
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <devfile_stat>:
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	53                   	push   %ebx
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	8b 40 0c             	mov    0xc(%eax),%eax
  801658:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80165d:	ba 00 00 00 00       	mov    $0x0,%edx
  801662:	b8 05 00 00 00       	mov    $0x5,%eax
  801667:	e8 43 ff ff ff       	call   8015af <fsipc>
  80166c:	85 c0                	test   %eax,%eax
  80166e:	78 2c                	js     80169c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801670:	83 ec 08             	sub    $0x8,%esp
  801673:	68 00 50 80 00       	push   $0x805000
  801678:	53                   	push   %ebx
  801679:	e8 b8 f2 ff ff       	call   800936 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80167e:	a1 80 50 80 00       	mov    0x805080,%eax
  801683:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801689:	a1 84 50 80 00       	mov    0x805084,%eax
  80168e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801694:	83 c4 10             	add    $0x10,%esp
  801697:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <devfile_write>:
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
  8016a4:	53                   	push   %ebx
  8016a5:	83 ec 08             	sub    $0x8,%esp
  8016a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016b6:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016bc:	53                   	push   %ebx
  8016bd:	ff 75 0c             	pushl  0xc(%ebp)
  8016c0:	68 08 50 80 00       	push   $0x805008
  8016c5:	e8 5c f4 ff ff       	call   800b26 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8016cf:	b8 04 00 00 00       	mov    $0x4,%eax
  8016d4:	e8 d6 fe ff ff       	call   8015af <fsipc>
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	78 0b                	js     8016eb <devfile_write+0x4a>
	assert(r <= n);
  8016e0:	39 d8                	cmp    %ebx,%eax
  8016e2:	77 0c                	ja     8016f0 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016e4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016e9:	7f 1e                	jg     801709 <devfile_write+0x68>
}
  8016eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    
	assert(r <= n);
  8016f0:	68 04 2a 80 00       	push   $0x802a04
  8016f5:	68 0b 2a 80 00       	push   $0x802a0b
  8016fa:	68 98 00 00 00       	push   $0x98
  8016ff:	68 20 2a 80 00       	push   $0x802a20
  801704:	e8 6a 0a 00 00       	call   802173 <_panic>
	assert(r <= PGSIZE);
  801709:	68 2b 2a 80 00       	push   $0x802a2b
  80170e:	68 0b 2a 80 00       	push   $0x802a0b
  801713:	68 99 00 00 00       	push   $0x99
  801718:	68 20 2a 80 00       	push   $0x802a20
  80171d:	e8 51 0a 00 00       	call   802173 <_panic>

00801722 <devfile_read>:
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	56                   	push   %esi
  801726:	53                   	push   %ebx
  801727:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	8b 40 0c             	mov    0xc(%eax),%eax
  801730:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801735:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80173b:	ba 00 00 00 00       	mov    $0x0,%edx
  801740:	b8 03 00 00 00       	mov    $0x3,%eax
  801745:	e8 65 fe ff ff       	call   8015af <fsipc>
  80174a:	89 c3                	mov    %eax,%ebx
  80174c:	85 c0                	test   %eax,%eax
  80174e:	78 1f                	js     80176f <devfile_read+0x4d>
	assert(r <= n);
  801750:	39 f0                	cmp    %esi,%eax
  801752:	77 24                	ja     801778 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801754:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801759:	7f 33                	jg     80178e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80175b:	83 ec 04             	sub    $0x4,%esp
  80175e:	50                   	push   %eax
  80175f:	68 00 50 80 00       	push   $0x805000
  801764:	ff 75 0c             	pushl  0xc(%ebp)
  801767:	e8 58 f3 ff ff       	call   800ac4 <memmove>
	return r;
  80176c:	83 c4 10             	add    $0x10,%esp
}
  80176f:	89 d8                	mov    %ebx,%eax
  801771:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801774:	5b                   	pop    %ebx
  801775:	5e                   	pop    %esi
  801776:	5d                   	pop    %ebp
  801777:	c3                   	ret    
	assert(r <= n);
  801778:	68 04 2a 80 00       	push   $0x802a04
  80177d:	68 0b 2a 80 00       	push   $0x802a0b
  801782:	6a 7c                	push   $0x7c
  801784:	68 20 2a 80 00       	push   $0x802a20
  801789:	e8 e5 09 00 00       	call   802173 <_panic>
	assert(r <= PGSIZE);
  80178e:	68 2b 2a 80 00       	push   $0x802a2b
  801793:	68 0b 2a 80 00       	push   $0x802a0b
  801798:	6a 7d                	push   $0x7d
  80179a:	68 20 2a 80 00       	push   $0x802a20
  80179f:	e8 cf 09 00 00       	call   802173 <_panic>

008017a4 <open>:
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	56                   	push   %esi
  8017a8:	53                   	push   %ebx
  8017a9:	83 ec 1c             	sub    $0x1c,%esp
  8017ac:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017af:	56                   	push   %esi
  8017b0:	e8 48 f1 ff ff       	call   8008fd <strlen>
  8017b5:	83 c4 10             	add    $0x10,%esp
  8017b8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017bd:	7f 6c                	jg     80182b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017bf:	83 ec 0c             	sub    $0xc,%esp
  8017c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c5:	50                   	push   %eax
  8017c6:	e8 79 f8 ff ff       	call   801044 <fd_alloc>
  8017cb:	89 c3                	mov    %eax,%ebx
  8017cd:	83 c4 10             	add    $0x10,%esp
  8017d0:	85 c0                	test   %eax,%eax
  8017d2:	78 3c                	js     801810 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017d4:	83 ec 08             	sub    $0x8,%esp
  8017d7:	56                   	push   %esi
  8017d8:	68 00 50 80 00       	push   $0x805000
  8017dd:	e8 54 f1 ff ff       	call   800936 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e5:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f2:	e8 b8 fd ff ff       	call   8015af <fsipc>
  8017f7:	89 c3                	mov    %eax,%ebx
  8017f9:	83 c4 10             	add    $0x10,%esp
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	78 19                	js     801819 <open+0x75>
	return fd2num(fd);
  801800:	83 ec 0c             	sub    $0xc,%esp
  801803:	ff 75 f4             	pushl  -0xc(%ebp)
  801806:	e8 12 f8 ff ff       	call   80101d <fd2num>
  80180b:	89 c3                	mov    %eax,%ebx
  80180d:	83 c4 10             	add    $0x10,%esp
}
  801810:	89 d8                	mov    %ebx,%eax
  801812:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801815:	5b                   	pop    %ebx
  801816:	5e                   	pop    %esi
  801817:	5d                   	pop    %ebp
  801818:	c3                   	ret    
		fd_close(fd, 0);
  801819:	83 ec 08             	sub    $0x8,%esp
  80181c:	6a 00                	push   $0x0
  80181e:	ff 75 f4             	pushl  -0xc(%ebp)
  801821:	e8 1b f9 ff ff       	call   801141 <fd_close>
		return r;
  801826:	83 c4 10             	add    $0x10,%esp
  801829:	eb e5                	jmp    801810 <open+0x6c>
		return -E_BAD_PATH;
  80182b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801830:	eb de                	jmp    801810 <open+0x6c>

00801832 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801838:	ba 00 00 00 00       	mov    $0x0,%edx
  80183d:	b8 08 00 00 00       	mov    $0x8,%eax
  801842:	e8 68 fd ff ff       	call   8015af <fsipc>
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80184f:	68 37 2a 80 00       	push   $0x802a37
  801854:	ff 75 0c             	pushl  0xc(%ebp)
  801857:	e8 da f0 ff ff       	call   800936 <strcpy>
	return 0;
}
  80185c:	b8 00 00 00 00       	mov    $0x0,%eax
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <devsock_close>:
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	53                   	push   %ebx
  801867:	83 ec 10             	sub    $0x10,%esp
  80186a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80186d:	53                   	push   %ebx
  80186e:	e8 5d 0a 00 00       	call   8022d0 <pageref>
  801873:	83 c4 10             	add    $0x10,%esp
		return 0;
  801876:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80187b:	83 f8 01             	cmp    $0x1,%eax
  80187e:	74 07                	je     801887 <devsock_close+0x24>
}
  801880:	89 d0                	mov    %edx,%eax
  801882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801885:	c9                   	leave  
  801886:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801887:	83 ec 0c             	sub    $0xc,%esp
  80188a:	ff 73 0c             	pushl  0xc(%ebx)
  80188d:	e8 b9 02 00 00       	call   801b4b <nsipc_close>
  801892:	89 c2                	mov    %eax,%edx
  801894:	83 c4 10             	add    $0x10,%esp
  801897:	eb e7                	jmp    801880 <devsock_close+0x1d>

00801899 <devsock_write>:
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80189f:	6a 00                	push   $0x0
  8018a1:	ff 75 10             	pushl  0x10(%ebp)
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	ff 70 0c             	pushl  0xc(%eax)
  8018ad:	e8 76 03 00 00       	call   801c28 <nsipc_send>
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <devsock_read>:
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018ba:	6a 00                	push   $0x0
  8018bc:	ff 75 10             	pushl  0x10(%ebp)
  8018bf:	ff 75 0c             	pushl  0xc(%ebp)
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	ff 70 0c             	pushl  0xc(%eax)
  8018c8:	e8 ef 02 00 00       	call   801bbc <nsipc_recv>
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <fd2sockid>:
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018d5:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018d8:	52                   	push   %edx
  8018d9:	50                   	push   %eax
  8018da:	e8 b7 f7 ff ff       	call   801096 <fd_lookup>
  8018df:	83 c4 10             	add    $0x10,%esp
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	78 10                	js     8018f6 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e9:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018ef:	39 08                	cmp    %ecx,(%eax)
  8018f1:	75 05                	jne    8018f8 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018f3:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    
		return -E_NOT_SUPP;
  8018f8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018fd:	eb f7                	jmp    8018f6 <fd2sockid+0x27>

008018ff <alloc_sockfd>:
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	56                   	push   %esi
  801903:	53                   	push   %ebx
  801904:	83 ec 1c             	sub    $0x1c,%esp
  801907:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801909:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190c:	50                   	push   %eax
  80190d:	e8 32 f7 ff ff       	call   801044 <fd_alloc>
  801912:	89 c3                	mov    %eax,%ebx
  801914:	83 c4 10             	add    $0x10,%esp
  801917:	85 c0                	test   %eax,%eax
  801919:	78 43                	js     80195e <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80191b:	83 ec 04             	sub    $0x4,%esp
  80191e:	68 07 04 00 00       	push   $0x407
  801923:	ff 75 f4             	pushl  -0xc(%ebp)
  801926:	6a 00                	push   $0x0
  801928:	e8 fb f3 ff ff       	call   800d28 <sys_page_alloc>
  80192d:	89 c3                	mov    %eax,%ebx
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	85 c0                	test   %eax,%eax
  801934:	78 28                	js     80195e <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801939:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80193f:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801944:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80194b:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80194e:	83 ec 0c             	sub    $0xc,%esp
  801951:	50                   	push   %eax
  801952:	e8 c6 f6 ff ff       	call   80101d <fd2num>
  801957:	89 c3                	mov    %eax,%ebx
  801959:	83 c4 10             	add    $0x10,%esp
  80195c:	eb 0c                	jmp    80196a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80195e:	83 ec 0c             	sub    $0xc,%esp
  801961:	56                   	push   %esi
  801962:	e8 e4 01 00 00       	call   801b4b <nsipc_close>
		return r;
  801967:	83 c4 10             	add    $0x10,%esp
}
  80196a:	89 d8                	mov    %ebx,%eax
  80196c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196f:	5b                   	pop    %ebx
  801970:	5e                   	pop    %esi
  801971:	5d                   	pop    %ebp
  801972:	c3                   	ret    

00801973 <accept>:
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	e8 4e ff ff ff       	call   8018cf <fd2sockid>
  801981:	85 c0                	test   %eax,%eax
  801983:	78 1b                	js     8019a0 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801985:	83 ec 04             	sub    $0x4,%esp
  801988:	ff 75 10             	pushl  0x10(%ebp)
  80198b:	ff 75 0c             	pushl  0xc(%ebp)
  80198e:	50                   	push   %eax
  80198f:	e8 0e 01 00 00       	call   801aa2 <nsipc_accept>
  801994:	83 c4 10             	add    $0x10,%esp
  801997:	85 c0                	test   %eax,%eax
  801999:	78 05                	js     8019a0 <accept+0x2d>
	return alloc_sockfd(r);
  80199b:	e8 5f ff ff ff       	call   8018ff <alloc_sockfd>
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <bind>:
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	e8 1f ff ff ff       	call   8018cf <fd2sockid>
  8019b0:	85 c0                	test   %eax,%eax
  8019b2:	78 12                	js     8019c6 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019b4:	83 ec 04             	sub    $0x4,%esp
  8019b7:	ff 75 10             	pushl  0x10(%ebp)
  8019ba:	ff 75 0c             	pushl  0xc(%ebp)
  8019bd:	50                   	push   %eax
  8019be:	e8 31 01 00 00       	call   801af4 <nsipc_bind>
  8019c3:	83 c4 10             	add    $0x10,%esp
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <shutdown>:
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	e8 f9 fe ff ff       	call   8018cf <fd2sockid>
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	78 0f                	js     8019e9 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019da:	83 ec 08             	sub    $0x8,%esp
  8019dd:	ff 75 0c             	pushl  0xc(%ebp)
  8019e0:	50                   	push   %eax
  8019e1:	e8 43 01 00 00       	call   801b29 <nsipc_shutdown>
  8019e6:	83 c4 10             	add    $0x10,%esp
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <connect>:
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	e8 d6 fe ff ff       	call   8018cf <fd2sockid>
  8019f9:	85 c0                	test   %eax,%eax
  8019fb:	78 12                	js     801a0f <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019fd:	83 ec 04             	sub    $0x4,%esp
  801a00:	ff 75 10             	pushl  0x10(%ebp)
  801a03:	ff 75 0c             	pushl  0xc(%ebp)
  801a06:	50                   	push   %eax
  801a07:	e8 59 01 00 00       	call   801b65 <nsipc_connect>
  801a0c:	83 c4 10             	add    $0x10,%esp
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <listen>:
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	e8 b0 fe ff ff       	call   8018cf <fd2sockid>
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	78 0f                	js     801a32 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a23:	83 ec 08             	sub    $0x8,%esp
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	50                   	push   %eax
  801a2a:	e8 6b 01 00 00       	call   801b9a <nsipc_listen>
  801a2f:	83 c4 10             	add    $0x10,%esp
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a3a:	ff 75 10             	pushl  0x10(%ebp)
  801a3d:	ff 75 0c             	pushl  0xc(%ebp)
  801a40:	ff 75 08             	pushl  0x8(%ebp)
  801a43:	e8 3e 02 00 00       	call   801c86 <nsipc_socket>
  801a48:	83 c4 10             	add    $0x10,%esp
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	78 05                	js     801a54 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a4f:	e8 ab fe ff ff       	call   8018ff <alloc_sockfd>
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	53                   	push   %ebx
  801a5a:	83 ec 04             	sub    $0x4,%esp
  801a5d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a5f:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a66:	74 26                	je     801a8e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a68:	6a 07                	push   $0x7
  801a6a:	68 00 60 80 00       	push   $0x806000
  801a6f:	53                   	push   %ebx
  801a70:	ff 35 04 40 80 00    	pushl  0x804004
  801a76:	e8 c2 07 00 00       	call   80223d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a7b:	83 c4 0c             	add    $0xc,%esp
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	e8 4b 07 00 00       	call   8021d4 <ipc_recv>
}
  801a89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a8e:	83 ec 0c             	sub    $0xc,%esp
  801a91:	6a 02                	push   $0x2
  801a93:	e8 fd 07 00 00       	call   802295 <ipc_find_env>
  801a98:	a3 04 40 80 00       	mov    %eax,0x804004
  801a9d:	83 c4 10             	add    $0x10,%esp
  801aa0:	eb c6                	jmp    801a68 <nsipc+0x12>

00801aa2 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	56                   	push   %esi
  801aa6:	53                   	push   %ebx
  801aa7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ab2:	8b 06                	mov    (%esi),%eax
  801ab4:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ab9:	b8 01 00 00 00       	mov    $0x1,%eax
  801abe:	e8 93 ff ff ff       	call   801a56 <nsipc>
  801ac3:	89 c3                	mov    %eax,%ebx
  801ac5:	85 c0                	test   %eax,%eax
  801ac7:	79 09                	jns    801ad2 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ac9:	89 d8                	mov    %ebx,%eax
  801acb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ace:	5b                   	pop    %ebx
  801acf:	5e                   	pop    %esi
  801ad0:	5d                   	pop    %ebp
  801ad1:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ad2:	83 ec 04             	sub    $0x4,%esp
  801ad5:	ff 35 10 60 80 00    	pushl  0x806010
  801adb:	68 00 60 80 00       	push   $0x806000
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	e8 dc ef ff ff       	call   800ac4 <memmove>
		*addrlen = ret->ret_addrlen;
  801ae8:	a1 10 60 80 00       	mov    0x806010,%eax
  801aed:	89 06                	mov    %eax,(%esi)
  801aef:	83 c4 10             	add    $0x10,%esp
	return r;
  801af2:	eb d5                	jmp    801ac9 <nsipc_accept+0x27>

00801af4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	53                   	push   %ebx
  801af8:	83 ec 08             	sub    $0x8,%esp
  801afb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b06:	53                   	push   %ebx
  801b07:	ff 75 0c             	pushl  0xc(%ebp)
  801b0a:	68 04 60 80 00       	push   $0x806004
  801b0f:	e8 b0 ef ff ff       	call   800ac4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b14:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b1a:	b8 02 00 00 00       	mov    $0x2,%eax
  801b1f:	e8 32 ff ff ff       	call   801a56 <nsipc>
}
  801b24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b3f:	b8 03 00 00 00       	mov    $0x3,%eax
  801b44:	e8 0d ff ff ff       	call   801a56 <nsipc>
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <nsipc_close>:

int
nsipc_close(int s)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
  801b4e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b59:	b8 04 00 00 00       	mov    $0x4,%eax
  801b5e:	e8 f3 fe ff ff       	call   801a56 <nsipc>
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	53                   	push   %ebx
  801b69:	83 ec 08             	sub    $0x8,%esp
  801b6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b77:	53                   	push   %ebx
  801b78:	ff 75 0c             	pushl  0xc(%ebp)
  801b7b:	68 04 60 80 00       	push   $0x806004
  801b80:	e8 3f ef ff ff       	call   800ac4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b85:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b8b:	b8 05 00 00 00       	mov    $0x5,%eax
  801b90:	e8 c1 fe ff ff       	call   801a56 <nsipc>
}
  801b95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bab:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bb0:	b8 06 00 00 00       	mov    $0x6,%eax
  801bb5:	e8 9c fe ff ff       	call   801a56 <nsipc>
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	56                   	push   %esi
  801bc0:	53                   	push   %ebx
  801bc1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bcc:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd5:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bda:	b8 07 00 00 00       	mov    $0x7,%eax
  801bdf:	e8 72 fe ff ff       	call   801a56 <nsipc>
  801be4:	89 c3                	mov    %eax,%ebx
  801be6:	85 c0                	test   %eax,%eax
  801be8:	78 1f                	js     801c09 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bea:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bef:	7f 21                	jg     801c12 <nsipc_recv+0x56>
  801bf1:	39 c6                	cmp    %eax,%esi
  801bf3:	7c 1d                	jl     801c12 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bf5:	83 ec 04             	sub    $0x4,%esp
  801bf8:	50                   	push   %eax
  801bf9:	68 00 60 80 00       	push   $0x806000
  801bfe:	ff 75 0c             	pushl  0xc(%ebp)
  801c01:	e8 be ee ff ff       	call   800ac4 <memmove>
  801c06:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c09:	89 d8                	mov    %ebx,%eax
  801c0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c0e:	5b                   	pop    %ebx
  801c0f:	5e                   	pop    %esi
  801c10:	5d                   	pop    %ebp
  801c11:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c12:	68 43 2a 80 00       	push   $0x802a43
  801c17:	68 0b 2a 80 00       	push   $0x802a0b
  801c1c:	6a 62                	push   $0x62
  801c1e:	68 58 2a 80 00       	push   $0x802a58
  801c23:	e8 4b 05 00 00       	call   802173 <_panic>

00801c28 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	53                   	push   %ebx
  801c2c:	83 ec 04             	sub    $0x4,%esp
  801c2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c3a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c40:	7f 2e                	jg     801c70 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c42:	83 ec 04             	sub    $0x4,%esp
  801c45:	53                   	push   %ebx
  801c46:	ff 75 0c             	pushl  0xc(%ebp)
  801c49:	68 0c 60 80 00       	push   $0x80600c
  801c4e:	e8 71 ee ff ff       	call   800ac4 <memmove>
	nsipcbuf.send.req_size = size;
  801c53:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c59:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c61:	b8 08 00 00 00       	mov    $0x8,%eax
  801c66:	e8 eb fd ff ff       	call   801a56 <nsipc>
}
  801c6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    
	assert(size < 1600);
  801c70:	68 64 2a 80 00       	push   $0x802a64
  801c75:	68 0b 2a 80 00       	push   $0x802a0b
  801c7a:	6a 6d                	push   $0x6d
  801c7c:	68 58 2a 80 00       	push   $0x802a58
  801c81:	e8 ed 04 00 00       	call   802173 <_panic>

00801c86 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c97:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c9f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ca4:	b8 09 00 00 00       	mov    $0x9,%eax
  801ca9:	e8 a8 fd ff ff       	call   801a56 <nsipc>
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	56                   	push   %esi
  801cb4:	53                   	push   %ebx
  801cb5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cb8:	83 ec 0c             	sub    $0xc,%esp
  801cbb:	ff 75 08             	pushl  0x8(%ebp)
  801cbe:	e8 6a f3 ff ff       	call   80102d <fd2data>
  801cc3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cc5:	83 c4 08             	add    $0x8,%esp
  801cc8:	68 70 2a 80 00       	push   $0x802a70
  801ccd:	53                   	push   %ebx
  801cce:	e8 63 ec ff ff       	call   800936 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cd3:	8b 46 04             	mov    0x4(%esi),%eax
  801cd6:	2b 06                	sub    (%esi),%eax
  801cd8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cde:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ce5:	00 00 00 
	stat->st_dev = &devpipe;
  801ce8:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cef:	30 80 00 
	return 0;
}
  801cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cfa:	5b                   	pop    %ebx
  801cfb:	5e                   	pop    %esi
  801cfc:	5d                   	pop    %ebp
  801cfd:	c3                   	ret    

00801cfe <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	53                   	push   %ebx
  801d02:	83 ec 0c             	sub    $0xc,%esp
  801d05:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d08:	53                   	push   %ebx
  801d09:	6a 00                	push   $0x0
  801d0b:	e8 9d f0 ff ff       	call   800dad <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d10:	89 1c 24             	mov    %ebx,(%esp)
  801d13:	e8 15 f3 ff ff       	call   80102d <fd2data>
  801d18:	83 c4 08             	add    $0x8,%esp
  801d1b:	50                   	push   %eax
  801d1c:	6a 00                	push   $0x0
  801d1e:	e8 8a f0 ff ff       	call   800dad <sys_page_unmap>
}
  801d23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <_pipeisclosed>:
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	57                   	push   %edi
  801d2c:	56                   	push   %esi
  801d2d:	53                   	push   %ebx
  801d2e:	83 ec 1c             	sub    $0x1c,%esp
  801d31:	89 c7                	mov    %eax,%edi
  801d33:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d35:	a1 08 40 80 00       	mov    0x804008,%eax
  801d3a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d3d:	83 ec 0c             	sub    $0xc,%esp
  801d40:	57                   	push   %edi
  801d41:	e8 8a 05 00 00       	call   8022d0 <pageref>
  801d46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d49:	89 34 24             	mov    %esi,(%esp)
  801d4c:	e8 7f 05 00 00       	call   8022d0 <pageref>
		nn = thisenv->env_runs;
  801d51:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d57:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d5a:	83 c4 10             	add    $0x10,%esp
  801d5d:	39 cb                	cmp    %ecx,%ebx
  801d5f:	74 1b                	je     801d7c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d61:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d64:	75 cf                	jne    801d35 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d66:	8b 42 58             	mov    0x58(%edx),%eax
  801d69:	6a 01                	push   $0x1
  801d6b:	50                   	push   %eax
  801d6c:	53                   	push   %ebx
  801d6d:	68 77 2a 80 00       	push   $0x802a77
  801d72:	e8 60 e4 ff ff       	call   8001d7 <cprintf>
  801d77:	83 c4 10             	add    $0x10,%esp
  801d7a:	eb b9                	jmp    801d35 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d7c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d7f:	0f 94 c0             	sete   %al
  801d82:	0f b6 c0             	movzbl %al,%eax
}
  801d85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d88:	5b                   	pop    %ebx
  801d89:	5e                   	pop    %esi
  801d8a:	5f                   	pop    %edi
  801d8b:	5d                   	pop    %ebp
  801d8c:	c3                   	ret    

00801d8d <devpipe_write>:
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	57                   	push   %edi
  801d91:	56                   	push   %esi
  801d92:	53                   	push   %ebx
  801d93:	83 ec 28             	sub    $0x28,%esp
  801d96:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d99:	56                   	push   %esi
  801d9a:	e8 8e f2 ff ff       	call   80102d <fd2data>
  801d9f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	bf 00 00 00 00       	mov    $0x0,%edi
  801da9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dac:	74 4f                	je     801dfd <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dae:	8b 43 04             	mov    0x4(%ebx),%eax
  801db1:	8b 0b                	mov    (%ebx),%ecx
  801db3:	8d 51 20             	lea    0x20(%ecx),%edx
  801db6:	39 d0                	cmp    %edx,%eax
  801db8:	72 14                	jb     801dce <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dba:	89 da                	mov    %ebx,%edx
  801dbc:	89 f0                	mov    %esi,%eax
  801dbe:	e8 65 ff ff ff       	call   801d28 <_pipeisclosed>
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	75 3b                	jne    801e02 <devpipe_write+0x75>
			sys_yield();
  801dc7:	e8 3d ef ff ff       	call   800d09 <sys_yield>
  801dcc:	eb e0                	jmp    801dae <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dd1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dd5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dd8:	89 c2                	mov    %eax,%edx
  801dda:	c1 fa 1f             	sar    $0x1f,%edx
  801ddd:	89 d1                	mov    %edx,%ecx
  801ddf:	c1 e9 1b             	shr    $0x1b,%ecx
  801de2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801de5:	83 e2 1f             	and    $0x1f,%edx
  801de8:	29 ca                	sub    %ecx,%edx
  801dea:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dee:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801df2:	83 c0 01             	add    $0x1,%eax
  801df5:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801df8:	83 c7 01             	add    $0x1,%edi
  801dfb:	eb ac                	jmp    801da9 <devpipe_write+0x1c>
	return i;
  801dfd:	8b 45 10             	mov    0x10(%ebp),%eax
  801e00:	eb 05                	jmp    801e07 <devpipe_write+0x7a>
				return 0;
  801e02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e0a:	5b                   	pop    %ebx
  801e0b:	5e                   	pop    %esi
  801e0c:	5f                   	pop    %edi
  801e0d:	5d                   	pop    %ebp
  801e0e:	c3                   	ret    

00801e0f <devpipe_read>:
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	57                   	push   %edi
  801e13:	56                   	push   %esi
  801e14:	53                   	push   %ebx
  801e15:	83 ec 18             	sub    $0x18,%esp
  801e18:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e1b:	57                   	push   %edi
  801e1c:	e8 0c f2 ff ff       	call   80102d <fd2data>
  801e21:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e23:	83 c4 10             	add    $0x10,%esp
  801e26:	be 00 00 00 00       	mov    $0x0,%esi
  801e2b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e2e:	75 14                	jne    801e44 <devpipe_read+0x35>
	return i;
  801e30:	8b 45 10             	mov    0x10(%ebp),%eax
  801e33:	eb 02                	jmp    801e37 <devpipe_read+0x28>
				return i;
  801e35:	89 f0                	mov    %esi,%eax
}
  801e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e3a:	5b                   	pop    %ebx
  801e3b:	5e                   	pop    %esi
  801e3c:	5f                   	pop    %edi
  801e3d:	5d                   	pop    %ebp
  801e3e:	c3                   	ret    
			sys_yield();
  801e3f:	e8 c5 ee ff ff       	call   800d09 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e44:	8b 03                	mov    (%ebx),%eax
  801e46:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e49:	75 18                	jne    801e63 <devpipe_read+0x54>
			if (i > 0)
  801e4b:	85 f6                	test   %esi,%esi
  801e4d:	75 e6                	jne    801e35 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e4f:	89 da                	mov    %ebx,%edx
  801e51:	89 f8                	mov    %edi,%eax
  801e53:	e8 d0 fe ff ff       	call   801d28 <_pipeisclosed>
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	74 e3                	je     801e3f <devpipe_read+0x30>
				return 0;
  801e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e61:	eb d4                	jmp    801e37 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e63:	99                   	cltd   
  801e64:	c1 ea 1b             	shr    $0x1b,%edx
  801e67:	01 d0                	add    %edx,%eax
  801e69:	83 e0 1f             	and    $0x1f,%eax
  801e6c:	29 d0                	sub    %edx,%eax
  801e6e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e76:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e79:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e7c:	83 c6 01             	add    $0x1,%esi
  801e7f:	eb aa                	jmp    801e2b <devpipe_read+0x1c>

00801e81 <pipe>:
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	56                   	push   %esi
  801e85:	53                   	push   %ebx
  801e86:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e8c:	50                   	push   %eax
  801e8d:	e8 b2 f1 ff ff       	call   801044 <fd_alloc>
  801e92:	89 c3                	mov    %eax,%ebx
  801e94:	83 c4 10             	add    $0x10,%esp
  801e97:	85 c0                	test   %eax,%eax
  801e99:	0f 88 23 01 00 00    	js     801fc2 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e9f:	83 ec 04             	sub    $0x4,%esp
  801ea2:	68 07 04 00 00       	push   $0x407
  801ea7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eaa:	6a 00                	push   $0x0
  801eac:	e8 77 ee ff ff       	call   800d28 <sys_page_alloc>
  801eb1:	89 c3                	mov    %eax,%ebx
  801eb3:	83 c4 10             	add    $0x10,%esp
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	0f 88 04 01 00 00    	js     801fc2 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ebe:	83 ec 0c             	sub    $0xc,%esp
  801ec1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ec4:	50                   	push   %eax
  801ec5:	e8 7a f1 ff ff       	call   801044 <fd_alloc>
  801eca:	89 c3                	mov    %eax,%ebx
  801ecc:	83 c4 10             	add    $0x10,%esp
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	0f 88 db 00 00 00    	js     801fb2 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed7:	83 ec 04             	sub    $0x4,%esp
  801eda:	68 07 04 00 00       	push   $0x407
  801edf:	ff 75 f0             	pushl  -0x10(%ebp)
  801ee2:	6a 00                	push   $0x0
  801ee4:	e8 3f ee ff ff       	call   800d28 <sys_page_alloc>
  801ee9:	89 c3                	mov    %eax,%ebx
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	85 c0                	test   %eax,%eax
  801ef0:	0f 88 bc 00 00 00    	js     801fb2 <pipe+0x131>
	va = fd2data(fd0);
  801ef6:	83 ec 0c             	sub    $0xc,%esp
  801ef9:	ff 75 f4             	pushl  -0xc(%ebp)
  801efc:	e8 2c f1 ff ff       	call   80102d <fd2data>
  801f01:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f03:	83 c4 0c             	add    $0xc,%esp
  801f06:	68 07 04 00 00       	push   $0x407
  801f0b:	50                   	push   %eax
  801f0c:	6a 00                	push   $0x0
  801f0e:	e8 15 ee ff ff       	call   800d28 <sys_page_alloc>
  801f13:	89 c3                	mov    %eax,%ebx
  801f15:	83 c4 10             	add    $0x10,%esp
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	0f 88 82 00 00 00    	js     801fa2 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f20:	83 ec 0c             	sub    $0xc,%esp
  801f23:	ff 75 f0             	pushl  -0x10(%ebp)
  801f26:	e8 02 f1 ff ff       	call   80102d <fd2data>
  801f2b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f32:	50                   	push   %eax
  801f33:	6a 00                	push   $0x0
  801f35:	56                   	push   %esi
  801f36:	6a 00                	push   $0x0
  801f38:	e8 2e ee ff ff       	call   800d6b <sys_page_map>
  801f3d:	89 c3                	mov    %eax,%ebx
  801f3f:	83 c4 20             	add    $0x20,%esp
  801f42:	85 c0                	test   %eax,%eax
  801f44:	78 4e                	js     801f94 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f46:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f53:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f5d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f62:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f69:	83 ec 0c             	sub    $0xc,%esp
  801f6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f6f:	e8 a9 f0 ff ff       	call   80101d <fd2num>
  801f74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f77:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f79:	83 c4 04             	add    $0x4,%esp
  801f7c:	ff 75 f0             	pushl  -0x10(%ebp)
  801f7f:	e8 99 f0 ff ff       	call   80101d <fd2num>
  801f84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f87:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f8a:	83 c4 10             	add    $0x10,%esp
  801f8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f92:	eb 2e                	jmp    801fc2 <pipe+0x141>
	sys_page_unmap(0, va);
  801f94:	83 ec 08             	sub    $0x8,%esp
  801f97:	56                   	push   %esi
  801f98:	6a 00                	push   $0x0
  801f9a:	e8 0e ee ff ff       	call   800dad <sys_page_unmap>
  801f9f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fa2:	83 ec 08             	sub    $0x8,%esp
  801fa5:	ff 75 f0             	pushl  -0x10(%ebp)
  801fa8:	6a 00                	push   $0x0
  801faa:	e8 fe ed ff ff       	call   800dad <sys_page_unmap>
  801faf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fb2:	83 ec 08             	sub    $0x8,%esp
  801fb5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb8:	6a 00                	push   $0x0
  801fba:	e8 ee ed ff ff       	call   800dad <sys_page_unmap>
  801fbf:	83 c4 10             	add    $0x10,%esp
}
  801fc2:	89 d8                	mov    %ebx,%eax
  801fc4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc7:	5b                   	pop    %ebx
  801fc8:	5e                   	pop    %esi
  801fc9:	5d                   	pop    %ebp
  801fca:	c3                   	ret    

00801fcb <pipeisclosed>:
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fd1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd4:	50                   	push   %eax
  801fd5:	ff 75 08             	pushl  0x8(%ebp)
  801fd8:	e8 b9 f0 ff ff       	call   801096 <fd_lookup>
  801fdd:	83 c4 10             	add    $0x10,%esp
  801fe0:	85 c0                	test   %eax,%eax
  801fe2:	78 18                	js     801ffc <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fe4:	83 ec 0c             	sub    $0xc,%esp
  801fe7:	ff 75 f4             	pushl  -0xc(%ebp)
  801fea:	e8 3e f0 ff ff       	call   80102d <fd2data>
	return _pipeisclosed(fd, p);
  801fef:	89 c2                	mov    %eax,%edx
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	e8 2f fd ff ff       	call   801d28 <_pipeisclosed>
  801ff9:	83 c4 10             	add    $0x10,%esp
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801ffe:	b8 00 00 00 00       	mov    $0x0,%eax
  802003:	c3                   	ret    

00802004 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80200a:	68 8f 2a 80 00       	push   $0x802a8f
  80200f:	ff 75 0c             	pushl  0xc(%ebp)
  802012:	e8 1f e9 ff ff       	call   800936 <strcpy>
	return 0;
}
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <devcons_write>:
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	57                   	push   %edi
  802022:	56                   	push   %esi
  802023:	53                   	push   %ebx
  802024:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80202a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80202f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802035:	3b 75 10             	cmp    0x10(%ebp),%esi
  802038:	73 31                	jae    80206b <devcons_write+0x4d>
		m = n - tot;
  80203a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80203d:	29 f3                	sub    %esi,%ebx
  80203f:	83 fb 7f             	cmp    $0x7f,%ebx
  802042:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802047:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80204a:	83 ec 04             	sub    $0x4,%esp
  80204d:	53                   	push   %ebx
  80204e:	89 f0                	mov    %esi,%eax
  802050:	03 45 0c             	add    0xc(%ebp),%eax
  802053:	50                   	push   %eax
  802054:	57                   	push   %edi
  802055:	e8 6a ea ff ff       	call   800ac4 <memmove>
		sys_cputs(buf, m);
  80205a:	83 c4 08             	add    $0x8,%esp
  80205d:	53                   	push   %ebx
  80205e:	57                   	push   %edi
  80205f:	e8 08 ec ff ff       	call   800c6c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802064:	01 de                	add    %ebx,%esi
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	eb ca                	jmp    802035 <devcons_write+0x17>
}
  80206b:	89 f0                	mov    %esi,%eax
  80206d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802070:	5b                   	pop    %ebx
  802071:	5e                   	pop    %esi
  802072:	5f                   	pop    %edi
  802073:	5d                   	pop    %ebp
  802074:	c3                   	ret    

00802075 <devcons_read>:
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 08             	sub    $0x8,%esp
  80207b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802080:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802084:	74 21                	je     8020a7 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802086:	e8 ff eb ff ff       	call   800c8a <sys_cgetc>
  80208b:	85 c0                	test   %eax,%eax
  80208d:	75 07                	jne    802096 <devcons_read+0x21>
		sys_yield();
  80208f:	e8 75 ec ff ff       	call   800d09 <sys_yield>
  802094:	eb f0                	jmp    802086 <devcons_read+0x11>
	if (c < 0)
  802096:	78 0f                	js     8020a7 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802098:	83 f8 04             	cmp    $0x4,%eax
  80209b:	74 0c                	je     8020a9 <devcons_read+0x34>
	*(char*)vbuf = c;
  80209d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a0:	88 02                	mov    %al,(%edx)
	return 1;
  8020a2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    
		return 0;
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	eb f7                	jmp    8020a7 <devcons_read+0x32>

008020b0 <cputchar>:
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020bc:	6a 01                	push   $0x1
  8020be:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020c1:	50                   	push   %eax
  8020c2:	e8 a5 eb ff ff       	call   800c6c <sys_cputs>
}
  8020c7:	83 c4 10             	add    $0x10,%esp
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <getchar>:
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020d2:	6a 01                	push   $0x1
  8020d4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020d7:	50                   	push   %eax
  8020d8:	6a 00                	push   $0x0
  8020da:	e8 27 f2 ff ff       	call   801306 <read>
	if (r < 0)
  8020df:	83 c4 10             	add    $0x10,%esp
  8020e2:	85 c0                	test   %eax,%eax
  8020e4:	78 06                	js     8020ec <getchar+0x20>
	if (r < 1)
  8020e6:	74 06                	je     8020ee <getchar+0x22>
	return c;
  8020e8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    
		return -E_EOF;
  8020ee:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020f3:	eb f7                	jmp    8020ec <getchar+0x20>

008020f5 <iscons>:
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020fe:	50                   	push   %eax
  8020ff:	ff 75 08             	pushl  0x8(%ebp)
  802102:	e8 8f ef ff ff       	call   801096 <fd_lookup>
  802107:	83 c4 10             	add    $0x10,%esp
  80210a:	85 c0                	test   %eax,%eax
  80210c:	78 11                	js     80211f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80210e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802111:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802117:	39 10                	cmp    %edx,(%eax)
  802119:	0f 94 c0             	sete   %al
  80211c:	0f b6 c0             	movzbl %al,%eax
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <opencons>:
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802127:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80212a:	50                   	push   %eax
  80212b:	e8 14 ef ff ff       	call   801044 <fd_alloc>
  802130:	83 c4 10             	add    $0x10,%esp
  802133:	85 c0                	test   %eax,%eax
  802135:	78 3a                	js     802171 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802137:	83 ec 04             	sub    $0x4,%esp
  80213a:	68 07 04 00 00       	push   $0x407
  80213f:	ff 75 f4             	pushl  -0xc(%ebp)
  802142:	6a 00                	push   $0x0
  802144:	e8 df eb ff ff       	call   800d28 <sys_page_alloc>
  802149:	83 c4 10             	add    $0x10,%esp
  80214c:	85 c0                	test   %eax,%eax
  80214e:	78 21                	js     802171 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802153:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802159:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80215b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802165:	83 ec 0c             	sub    $0xc,%esp
  802168:	50                   	push   %eax
  802169:	e8 af ee ff ff       	call   80101d <fd2num>
  80216e:	83 c4 10             	add    $0x10,%esp
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	56                   	push   %esi
  802177:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802178:	a1 08 40 80 00       	mov    0x804008,%eax
  80217d:	8b 40 48             	mov    0x48(%eax),%eax
  802180:	83 ec 04             	sub    $0x4,%esp
  802183:	68 c0 2a 80 00       	push   $0x802ac0
  802188:	50                   	push   %eax
  802189:	68 b8 25 80 00       	push   $0x8025b8
  80218e:	e8 44 e0 ff ff       	call   8001d7 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802193:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802196:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80219c:	e8 49 eb ff ff       	call   800cea <sys_getenvid>
  8021a1:	83 c4 04             	add    $0x4,%esp
  8021a4:	ff 75 0c             	pushl  0xc(%ebp)
  8021a7:	ff 75 08             	pushl  0x8(%ebp)
  8021aa:	56                   	push   %esi
  8021ab:	50                   	push   %eax
  8021ac:	68 9c 2a 80 00       	push   $0x802a9c
  8021b1:	e8 21 e0 ff ff       	call   8001d7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021b6:	83 c4 18             	add    $0x18,%esp
  8021b9:	53                   	push   %ebx
  8021ba:	ff 75 10             	pushl  0x10(%ebp)
  8021bd:	e8 c4 df ff ff       	call   800186 <vcprintf>
	cprintf("\n");
  8021c2:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  8021c9:	e8 09 e0 ff ff       	call   8001d7 <cprintf>
  8021ce:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021d1:	cc                   	int3   
  8021d2:	eb fd                	jmp    8021d1 <_panic+0x5e>

008021d4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
  8021d7:	56                   	push   %esi
  8021d8:	53                   	push   %ebx
  8021d9:	8b 75 08             	mov    0x8(%ebp),%esi
  8021dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021df:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021e2:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021e4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021e9:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021ec:	83 ec 0c             	sub    $0xc,%esp
  8021ef:	50                   	push   %eax
  8021f0:	e8 e3 ec ff ff       	call   800ed8 <sys_ipc_recv>
	if(ret < 0){
  8021f5:	83 c4 10             	add    $0x10,%esp
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	78 2b                	js     802227 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021fc:	85 f6                	test   %esi,%esi
  8021fe:	74 0a                	je     80220a <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802200:	a1 08 40 80 00       	mov    0x804008,%eax
  802205:	8b 40 74             	mov    0x74(%eax),%eax
  802208:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80220a:	85 db                	test   %ebx,%ebx
  80220c:	74 0a                	je     802218 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80220e:	a1 08 40 80 00       	mov    0x804008,%eax
  802213:	8b 40 78             	mov    0x78(%eax),%eax
  802216:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802218:	a1 08 40 80 00       	mov    0x804008,%eax
  80221d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802220:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802223:	5b                   	pop    %ebx
  802224:	5e                   	pop    %esi
  802225:	5d                   	pop    %ebp
  802226:	c3                   	ret    
		if(from_env_store)
  802227:	85 f6                	test   %esi,%esi
  802229:	74 06                	je     802231 <ipc_recv+0x5d>
			*from_env_store = 0;
  80222b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802231:	85 db                	test   %ebx,%ebx
  802233:	74 eb                	je     802220 <ipc_recv+0x4c>
			*perm_store = 0;
  802235:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80223b:	eb e3                	jmp    802220 <ipc_recv+0x4c>

0080223d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	57                   	push   %edi
  802241:	56                   	push   %esi
  802242:	53                   	push   %ebx
  802243:	83 ec 0c             	sub    $0xc,%esp
  802246:	8b 7d 08             	mov    0x8(%ebp),%edi
  802249:	8b 75 0c             	mov    0xc(%ebp),%esi
  80224c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80224f:	85 db                	test   %ebx,%ebx
  802251:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802256:	0f 44 d8             	cmove  %eax,%ebx
  802259:	eb 05                	jmp    802260 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80225b:	e8 a9 ea ff ff       	call   800d09 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802260:	ff 75 14             	pushl  0x14(%ebp)
  802263:	53                   	push   %ebx
  802264:	56                   	push   %esi
  802265:	57                   	push   %edi
  802266:	e8 4a ec ff ff       	call   800eb5 <sys_ipc_try_send>
  80226b:	83 c4 10             	add    $0x10,%esp
  80226e:	85 c0                	test   %eax,%eax
  802270:	74 1b                	je     80228d <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802272:	79 e7                	jns    80225b <ipc_send+0x1e>
  802274:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802277:	74 e2                	je     80225b <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802279:	83 ec 04             	sub    $0x4,%esp
  80227c:	68 c7 2a 80 00       	push   $0x802ac7
  802281:	6a 46                	push   $0x46
  802283:	68 dc 2a 80 00       	push   $0x802adc
  802288:	e8 e6 fe ff ff       	call   802173 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80228d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802290:	5b                   	pop    %ebx
  802291:	5e                   	pop    %esi
  802292:	5f                   	pop    %edi
  802293:	5d                   	pop    %ebp
  802294:	c3                   	ret    

00802295 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80229b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022a0:	89 c2                	mov    %eax,%edx
  8022a2:	c1 e2 07             	shl    $0x7,%edx
  8022a5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022ab:	8b 52 50             	mov    0x50(%edx),%edx
  8022ae:	39 ca                	cmp    %ecx,%edx
  8022b0:	74 11                	je     8022c3 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022b2:	83 c0 01             	add    $0x1,%eax
  8022b5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022ba:	75 e4                	jne    8022a0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c1:	eb 0b                	jmp    8022ce <ipc_find_env+0x39>
			return envs[i].env_id;
  8022c3:	c1 e0 07             	shl    $0x7,%eax
  8022c6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022cb:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022ce:	5d                   	pop    %ebp
  8022cf:	c3                   	ret    

008022d0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022d6:	89 d0                	mov    %edx,%eax
  8022d8:	c1 e8 16             	shr    $0x16,%eax
  8022db:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022e2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022e7:	f6 c1 01             	test   $0x1,%cl
  8022ea:	74 1d                	je     802309 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022ec:	c1 ea 0c             	shr    $0xc,%edx
  8022ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022f6:	f6 c2 01             	test   $0x1,%dl
  8022f9:	74 0e                	je     802309 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022fb:	c1 ea 0c             	shr    $0xc,%edx
  8022fe:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802305:	ef 
  802306:	0f b7 c0             	movzwl %ax,%eax
}
  802309:	5d                   	pop    %ebp
  80230a:	c3                   	ret    
  80230b:	66 90                	xchg   %ax,%ax
  80230d:	66 90                	xchg   %ax,%ax
  80230f:	90                   	nop

00802310 <__udivdi3>:
  802310:	55                   	push   %ebp
  802311:	57                   	push   %edi
  802312:	56                   	push   %esi
  802313:	53                   	push   %ebx
  802314:	83 ec 1c             	sub    $0x1c,%esp
  802317:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80231b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80231f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802323:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802327:	85 d2                	test   %edx,%edx
  802329:	75 4d                	jne    802378 <__udivdi3+0x68>
  80232b:	39 f3                	cmp    %esi,%ebx
  80232d:	76 19                	jbe    802348 <__udivdi3+0x38>
  80232f:	31 ff                	xor    %edi,%edi
  802331:	89 e8                	mov    %ebp,%eax
  802333:	89 f2                	mov    %esi,%edx
  802335:	f7 f3                	div    %ebx
  802337:	89 fa                	mov    %edi,%edx
  802339:	83 c4 1c             	add    $0x1c,%esp
  80233c:	5b                   	pop    %ebx
  80233d:	5e                   	pop    %esi
  80233e:	5f                   	pop    %edi
  80233f:	5d                   	pop    %ebp
  802340:	c3                   	ret    
  802341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802348:	89 d9                	mov    %ebx,%ecx
  80234a:	85 db                	test   %ebx,%ebx
  80234c:	75 0b                	jne    802359 <__udivdi3+0x49>
  80234e:	b8 01 00 00 00       	mov    $0x1,%eax
  802353:	31 d2                	xor    %edx,%edx
  802355:	f7 f3                	div    %ebx
  802357:	89 c1                	mov    %eax,%ecx
  802359:	31 d2                	xor    %edx,%edx
  80235b:	89 f0                	mov    %esi,%eax
  80235d:	f7 f1                	div    %ecx
  80235f:	89 c6                	mov    %eax,%esi
  802361:	89 e8                	mov    %ebp,%eax
  802363:	89 f7                	mov    %esi,%edi
  802365:	f7 f1                	div    %ecx
  802367:	89 fa                	mov    %edi,%edx
  802369:	83 c4 1c             	add    $0x1c,%esp
  80236c:	5b                   	pop    %ebx
  80236d:	5e                   	pop    %esi
  80236e:	5f                   	pop    %edi
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    
  802371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802378:	39 f2                	cmp    %esi,%edx
  80237a:	77 1c                	ja     802398 <__udivdi3+0x88>
  80237c:	0f bd fa             	bsr    %edx,%edi
  80237f:	83 f7 1f             	xor    $0x1f,%edi
  802382:	75 2c                	jne    8023b0 <__udivdi3+0xa0>
  802384:	39 f2                	cmp    %esi,%edx
  802386:	72 06                	jb     80238e <__udivdi3+0x7e>
  802388:	31 c0                	xor    %eax,%eax
  80238a:	39 eb                	cmp    %ebp,%ebx
  80238c:	77 a9                	ja     802337 <__udivdi3+0x27>
  80238e:	b8 01 00 00 00       	mov    $0x1,%eax
  802393:	eb a2                	jmp    802337 <__udivdi3+0x27>
  802395:	8d 76 00             	lea    0x0(%esi),%esi
  802398:	31 ff                	xor    %edi,%edi
  80239a:	31 c0                	xor    %eax,%eax
  80239c:	89 fa                	mov    %edi,%edx
  80239e:	83 c4 1c             	add    $0x1c,%esp
  8023a1:	5b                   	pop    %ebx
  8023a2:	5e                   	pop    %esi
  8023a3:	5f                   	pop    %edi
  8023a4:	5d                   	pop    %ebp
  8023a5:	c3                   	ret    
  8023a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ad:	8d 76 00             	lea    0x0(%esi),%esi
  8023b0:	89 f9                	mov    %edi,%ecx
  8023b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023b7:	29 f8                	sub    %edi,%eax
  8023b9:	d3 e2                	shl    %cl,%edx
  8023bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023bf:	89 c1                	mov    %eax,%ecx
  8023c1:	89 da                	mov    %ebx,%edx
  8023c3:	d3 ea                	shr    %cl,%edx
  8023c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023c9:	09 d1                	or     %edx,%ecx
  8023cb:	89 f2                	mov    %esi,%edx
  8023cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023d1:	89 f9                	mov    %edi,%ecx
  8023d3:	d3 e3                	shl    %cl,%ebx
  8023d5:	89 c1                	mov    %eax,%ecx
  8023d7:	d3 ea                	shr    %cl,%edx
  8023d9:	89 f9                	mov    %edi,%ecx
  8023db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023df:	89 eb                	mov    %ebp,%ebx
  8023e1:	d3 e6                	shl    %cl,%esi
  8023e3:	89 c1                	mov    %eax,%ecx
  8023e5:	d3 eb                	shr    %cl,%ebx
  8023e7:	09 de                	or     %ebx,%esi
  8023e9:	89 f0                	mov    %esi,%eax
  8023eb:	f7 74 24 08          	divl   0x8(%esp)
  8023ef:	89 d6                	mov    %edx,%esi
  8023f1:	89 c3                	mov    %eax,%ebx
  8023f3:	f7 64 24 0c          	mull   0xc(%esp)
  8023f7:	39 d6                	cmp    %edx,%esi
  8023f9:	72 15                	jb     802410 <__udivdi3+0x100>
  8023fb:	89 f9                	mov    %edi,%ecx
  8023fd:	d3 e5                	shl    %cl,%ebp
  8023ff:	39 c5                	cmp    %eax,%ebp
  802401:	73 04                	jae    802407 <__udivdi3+0xf7>
  802403:	39 d6                	cmp    %edx,%esi
  802405:	74 09                	je     802410 <__udivdi3+0x100>
  802407:	89 d8                	mov    %ebx,%eax
  802409:	31 ff                	xor    %edi,%edi
  80240b:	e9 27 ff ff ff       	jmp    802337 <__udivdi3+0x27>
  802410:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802413:	31 ff                	xor    %edi,%edi
  802415:	e9 1d ff ff ff       	jmp    802337 <__udivdi3+0x27>
  80241a:	66 90                	xchg   %ax,%ax
  80241c:	66 90                	xchg   %ax,%ax
  80241e:	66 90                	xchg   %ax,%ax

00802420 <__umoddi3>:
  802420:	55                   	push   %ebp
  802421:	57                   	push   %edi
  802422:	56                   	push   %esi
  802423:	53                   	push   %ebx
  802424:	83 ec 1c             	sub    $0x1c,%esp
  802427:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80242b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80242f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802433:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802437:	89 da                	mov    %ebx,%edx
  802439:	85 c0                	test   %eax,%eax
  80243b:	75 43                	jne    802480 <__umoddi3+0x60>
  80243d:	39 df                	cmp    %ebx,%edi
  80243f:	76 17                	jbe    802458 <__umoddi3+0x38>
  802441:	89 f0                	mov    %esi,%eax
  802443:	f7 f7                	div    %edi
  802445:	89 d0                	mov    %edx,%eax
  802447:	31 d2                	xor    %edx,%edx
  802449:	83 c4 1c             	add    $0x1c,%esp
  80244c:	5b                   	pop    %ebx
  80244d:	5e                   	pop    %esi
  80244e:	5f                   	pop    %edi
  80244f:	5d                   	pop    %ebp
  802450:	c3                   	ret    
  802451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802458:	89 fd                	mov    %edi,%ebp
  80245a:	85 ff                	test   %edi,%edi
  80245c:	75 0b                	jne    802469 <__umoddi3+0x49>
  80245e:	b8 01 00 00 00       	mov    $0x1,%eax
  802463:	31 d2                	xor    %edx,%edx
  802465:	f7 f7                	div    %edi
  802467:	89 c5                	mov    %eax,%ebp
  802469:	89 d8                	mov    %ebx,%eax
  80246b:	31 d2                	xor    %edx,%edx
  80246d:	f7 f5                	div    %ebp
  80246f:	89 f0                	mov    %esi,%eax
  802471:	f7 f5                	div    %ebp
  802473:	89 d0                	mov    %edx,%eax
  802475:	eb d0                	jmp    802447 <__umoddi3+0x27>
  802477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80247e:	66 90                	xchg   %ax,%ax
  802480:	89 f1                	mov    %esi,%ecx
  802482:	39 d8                	cmp    %ebx,%eax
  802484:	76 0a                	jbe    802490 <__umoddi3+0x70>
  802486:	89 f0                	mov    %esi,%eax
  802488:	83 c4 1c             	add    $0x1c,%esp
  80248b:	5b                   	pop    %ebx
  80248c:	5e                   	pop    %esi
  80248d:	5f                   	pop    %edi
  80248e:	5d                   	pop    %ebp
  80248f:	c3                   	ret    
  802490:	0f bd e8             	bsr    %eax,%ebp
  802493:	83 f5 1f             	xor    $0x1f,%ebp
  802496:	75 20                	jne    8024b8 <__umoddi3+0x98>
  802498:	39 d8                	cmp    %ebx,%eax
  80249a:	0f 82 b0 00 00 00    	jb     802550 <__umoddi3+0x130>
  8024a0:	39 f7                	cmp    %esi,%edi
  8024a2:	0f 86 a8 00 00 00    	jbe    802550 <__umoddi3+0x130>
  8024a8:	89 c8                	mov    %ecx,%eax
  8024aa:	83 c4 1c             	add    $0x1c,%esp
  8024ad:	5b                   	pop    %ebx
  8024ae:	5e                   	pop    %esi
  8024af:	5f                   	pop    %edi
  8024b0:	5d                   	pop    %ebp
  8024b1:	c3                   	ret    
  8024b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024b8:	89 e9                	mov    %ebp,%ecx
  8024ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8024bf:	29 ea                	sub    %ebp,%edx
  8024c1:	d3 e0                	shl    %cl,%eax
  8024c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024c7:	89 d1                	mov    %edx,%ecx
  8024c9:	89 f8                	mov    %edi,%eax
  8024cb:	d3 e8                	shr    %cl,%eax
  8024cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024d9:	09 c1                	or     %eax,%ecx
  8024db:	89 d8                	mov    %ebx,%eax
  8024dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024e1:	89 e9                	mov    %ebp,%ecx
  8024e3:	d3 e7                	shl    %cl,%edi
  8024e5:	89 d1                	mov    %edx,%ecx
  8024e7:	d3 e8                	shr    %cl,%eax
  8024e9:	89 e9                	mov    %ebp,%ecx
  8024eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024ef:	d3 e3                	shl    %cl,%ebx
  8024f1:	89 c7                	mov    %eax,%edi
  8024f3:	89 d1                	mov    %edx,%ecx
  8024f5:	89 f0                	mov    %esi,%eax
  8024f7:	d3 e8                	shr    %cl,%eax
  8024f9:	89 e9                	mov    %ebp,%ecx
  8024fb:	89 fa                	mov    %edi,%edx
  8024fd:	d3 e6                	shl    %cl,%esi
  8024ff:	09 d8                	or     %ebx,%eax
  802501:	f7 74 24 08          	divl   0x8(%esp)
  802505:	89 d1                	mov    %edx,%ecx
  802507:	89 f3                	mov    %esi,%ebx
  802509:	f7 64 24 0c          	mull   0xc(%esp)
  80250d:	89 c6                	mov    %eax,%esi
  80250f:	89 d7                	mov    %edx,%edi
  802511:	39 d1                	cmp    %edx,%ecx
  802513:	72 06                	jb     80251b <__umoddi3+0xfb>
  802515:	75 10                	jne    802527 <__umoddi3+0x107>
  802517:	39 c3                	cmp    %eax,%ebx
  802519:	73 0c                	jae    802527 <__umoddi3+0x107>
  80251b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80251f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802523:	89 d7                	mov    %edx,%edi
  802525:	89 c6                	mov    %eax,%esi
  802527:	89 ca                	mov    %ecx,%edx
  802529:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80252e:	29 f3                	sub    %esi,%ebx
  802530:	19 fa                	sbb    %edi,%edx
  802532:	89 d0                	mov    %edx,%eax
  802534:	d3 e0                	shl    %cl,%eax
  802536:	89 e9                	mov    %ebp,%ecx
  802538:	d3 eb                	shr    %cl,%ebx
  80253a:	d3 ea                	shr    %cl,%edx
  80253c:	09 d8                	or     %ebx,%eax
  80253e:	83 c4 1c             	add    $0x1c,%esp
  802541:	5b                   	pop    %ebx
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    
  802546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80254d:	8d 76 00             	lea    0x0(%esi),%esi
  802550:	89 da                	mov    %ebx,%edx
  802552:	29 fe                	sub    %edi,%esi
  802554:	19 c2                	sbb    %eax,%edx
  802556:	89 f1                	mov    %esi,%ecx
  802558:	89 c8                	mov    %ecx,%eax
  80255a:	e9 4b ff ff ff       	jmp    8024aa <__umoddi3+0x8a>
