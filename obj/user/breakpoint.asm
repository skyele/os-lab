
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
  8000b8:	68 40 25 80 00       	push   $0x802540
  8000bd:	e8 15 01 00 00       	call   8001d7 <cprintf>
	cprintf("before umain\n");
  8000c2:	c7 04 24 5e 25 80 00 	movl   $0x80255e,(%esp)
  8000c9:	e8 09 01 00 00       	call   8001d7 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000ce:	83 c4 08             	add    $0x8,%esp
  8000d1:	ff 75 0c             	pushl  0xc(%ebp)
  8000d4:	ff 75 08             	pushl  0x8(%ebp)
  8000d7:	e8 57 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000dc:	c7 04 24 6c 25 80 00 	movl   $0x80256c,(%esp)
  8000e3:	e8 ef 00 00 00       	call   8001d7 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8000e8:	a1 08 40 80 00       	mov    0x804008,%eax
  8000ed:	8b 40 48             	mov    0x48(%eax),%eax
  8000f0:	83 c4 08             	add    $0x8,%esp
  8000f3:	50                   	push   %eax
  8000f4:	68 79 25 80 00       	push   $0x802579
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
  80011c:	68 a4 25 80 00       	push   $0x8025a4
  800121:	50                   	push   %eax
  800122:	68 98 25 80 00       	push   $0x802598
  800127:	e8 ab 00 00 00       	call   8001d7 <cprintf>
	close_all();
  80012c:	e8 a4 10 00 00       	call   8011d5 <close_all>
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
  800284:	e8 67 20 00 00       	call   8022f0 <__udivdi3>
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
  8002ad:	e8 4e 21 00 00       	call   802400 <__umoddi3>
  8002b2:	83 c4 14             	add    $0x14,%esp
  8002b5:	0f be 80 a9 25 80 00 	movsbl 0x8025a9(%eax),%eax
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
  80035e:	ff 24 85 80 27 80 00 	jmp    *0x802780(,%eax,4)
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
  800429:	8b 14 85 e0 28 80 00 	mov    0x8028e0(,%eax,4),%edx
  800430:	85 d2                	test   %edx,%edx
  800432:	74 18                	je     80044c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800434:	52                   	push   %edx
  800435:	68 fd 29 80 00       	push   $0x8029fd
  80043a:	53                   	push   %ebx
  80043b:	56                   	push   %esi
  80043c:	e8 a6 fe ff ff       	call   8002e7 <printfmt>
  800441:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800444:	89 7d 14             	mov    %edi,0x14(%ebp)
  800447:	e9 fe 02 00 00       	jmp    80074a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80044c:	50                   	push   %eax
  80044d:	68 c1 25 80 00       	push   $0x8025c1
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
  800474:	b8 ba 25 80 00       	mov    $0x8025ba,%eax
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
  80080c:	bf dd 26 80 00       	mov    $0x8026dd,%edi
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
  800838:	bf 15 27 80 00       	mov    $0x802715,%edi
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
  800cd9:	68 28 29 80 00       	push   $0x802928
  800cde:	6a 43                	push   $0x43
  800ce0:	68 45 29 80 00       	push   $0x802945
  800ce5:	e8 69 14 00 00       	call   802153 <_panic>

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
  800d5a:	68 28 29 80 00       	push   $0x802928
  800d5f:	6a 43                	push   $0x43
  800d61:	68 45 29 80 00       	push   $0x802945
  800d66:	e8 e8 13 00 00       	call   802153 <_panic>

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
  800d9c:	68 28 29 80 00       	push   $0x802928
  800da1:	6a 43                	push   $0x43
  800da3:	68 45 29 80 00       	push   $0x802945
  800da8:	e8 a6 13 00 00       	call   802153 <_panic>

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
  800dde:	68 28 29 80 00       	push   $0x802928
  800de3:	6a 43                	push   $0x43
  800de5:	68 45 29 80 00       	push   $0x802945
  800dea:	e8 64 13 00 00       	call   802153 <_panic>

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
  800e20:	68 28 29 80 00       	push   $0x802928
  800e25:	6a 43                	push   $0x43
  800e27:	68 45 29 80 00       	push   $0x802945
  800e2c:	e8 22 13 00 00       	call   802153 <_panic>

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
  800e62:	68 28 29 80 00       	push   $0x802928
  800e67:	6a 43                	push   $0x43
  800e69:	68 45 29 80 00       	push   $0x802945
  800e6e:	e8 e0 12 00 00       	call   802153 <_panic>

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
  800ea4:	68 28 29 80 00       	push   $0x802928
  800ea9:	6a 43                	push   $0x43
  800eab:	68 45 29 80 00       	push   $0x802945
  800eb0:	e8 9e 12 00 00       	call   802153 <_panic>

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
  800f08:	68 28 29 80 00       	push   $0x802928
  800f0d:	6a 43                	push   $0x43
  800f0f:	68 45 29 80 00       	push   $0x802945
  800f14:	e8 3a 12 00 00       	call   802153 <_panic>

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
  800fec:	68 28 29 80 00       	push   $0x802928
  800ff1:	6a 43                	push   $0x43
  800ff3:	68 45 29 80 00       	push   $0x802945
  800ff8:	e8 56 11 00 00       	call   802153 <_panic>

00800ffd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	05 00 00 00 30       	add    $0x30000000,%eax
  801008:	c1 e8 0c             	shr    $0xc,%eax
}
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    

0080100d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801018:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80101d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801022:	5d                   	pop    %ebp
  801023:	c3                   	ret    

00801024 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80102c:	89 c2                	mov    %eax,%edx
  80102e:	c1 ea 16             	shr    $0x16,%edx
  801031:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801038:	f6 c2 01             	test   $0x1,%dl
  80103b:	74 2d                	je     80106a <fd_alloc+0x46>
  80103d:	89 c2                	mov    %eax,%edx
  80103f:	c1 ea 0c             	shr    $0xc,%edx
  801042:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801049:	f6 c2 01             	test   $0x1,%dl
  80104c:	74 1c                	je     80106a <fd_alloc+0x46>
  80104e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801053:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801058:	75 d2                	jne    80102c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801063:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801068:	eb 0a                	jmp    801074 <fd_alloc+0x50>
			*fd_store = fd;
  80106a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80106d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80106f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80107c:	83 f8 1f             	cmp    $0x1f,%eax
  80107f:	77 30                	ja     8010b1 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801081:	c1 e0 0c             	shl    $0xc,%eax
  801084:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801089:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80108f:	f6 c2 01             	test   $0x1,%dl
  801092:	74 24                	je     8010b8 <fd_lookup+0x42>
  801094:	89 c2                	mov    %eax,%edx
  801096:	c1 ea 0c             	shr    $0xc,%edx
  801099:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010a0:	f6 c2 01             	test   $0x1,%dl
  8010a3:	74 1a                	je     8010bf <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a8:	89 02                	mov    %eax,(%edx)
	return 0;
  8010aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    
		return -E_INVAL;
  8010b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010b6:	eb f7                	jmp    8010af <fd_lookup+0x39>
		return -E_INVAL;
  8010b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010bd:	eb f0                	jmp    8010af <fd_lookup+0x39>
  8010bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c4:	eb e9                	jmp    8010af <fd_lookup+0x39>

008010c6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	83 ec 08             	sub    $0x8,%esp
  8010cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d4:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010d9:	39 08                	cmp    %ecx,(%eax)
  8010db:	74 38                	je     801115 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010dd:	83 c2 01             	add    $0x1,%edx
  8010e0:	8b 04 95 d0 29 80 00 	mov    0x8029d0(,%edx,4),%eax
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	75 ee                	jne    8010d9 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010eb:	a1 08 40 80 00       	mov    0x804008,%eax
  8010f0:	8b 40 48             	mov    0x48(%eax),%eax
  8010f3:	83 ec 04             	sub    $0x4,%esp
  8010f6:	51                   	push   %ecx
  8010f7:	50                   	push   %eax
  8010f8:	68 54 29 80 00       	push   $0x802954
  8010fd:	e8 d5 f0 ff ff       	call   8001d7 <cprintf>
	*dev = 0;
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80110b:	83 c4 10             	add    $0x10,%esp
  80110e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801113:	c9                   	leave  
  801114:	c3                   	ret    
			*dev = devtab[i];
  801115:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801118:	89 01                	mov    %eax,(%ecx)
			return 0;
  80111a:	b8 00 00 00 00       	mov    $0x0,%eax
  80111f:	eb f2                	jmp    801113 <dev_lookup+0x4d>

00801121 <fd_close>:
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	57                   	push   %edi
  801125:	56                   	push   %esi
  801126:	53                   	push   %ebx
  801127:	83 ec 24             	sub    $0x24,%esp
  80112a:	8b 75 08             	mov    0x8(%ebp),%esi
  80112d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801130:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801133:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801134:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80113a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80113d:	50                   	push   %eax
  80113e:	e8 33 ff ff ff       	call   801076 <fd_lookup>
  801143:	89 c3                	mov    %eax,%ebx
  801145:	83 c4 10             	add    $0x10,%esp
  801148:	85 c0                	test   %eax,%eax
  80114a:	78 05                	js     801151 <fd_close+0x30>
	    || fd != fd2)
  80114c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80114f:	74 16                	je     801167 <fd_close+0x46>
		return (must_exist ? r : 0);
  801151:	89 f8                	mov    %edi,%eax
  801153:	84 c0                	test   %al,%al
  801155:	b8 00 00 00 00       	mov    $0x0,%eax
  80115a:	0f 44 d8             	cmove  %eax,%ebx
}
  80115d:	89 d8                	mov    %ebx,%eax
  80115f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801162:	5b                   	pop    %ebx
  801163:	5e                   	pop    %esi
  801164:	5f                   	pop    %edi
  801165:	5d                   	pop    %ebp
  801166:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801167:	83 ec 08             	sub    $0x8,%esp
  80116a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80116d:	50                   	push   %eax
  80116e:	ff 36                	pushl  (%esi)
  801170:	e8 51 ff ff ff       	call   8010c6 <dev_lookup>
  801175:	89 c3                	mov    %eax,%ebx
  801177:	83 c4 10             	add    $0x10,%esp
  80117a:	85 c0                	test   %eax,%eax
  80117c:	78 1a                	js     801198 <fd_close+0x77>
		if (dev->dev_close)
  80117e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801181:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801184:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801189:	85 c0                	test   %eax,%eax
  80118b:	74 0b                	je     801198 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80118d:	83 ec 0c             	sub    $0xc,%esp
  801190:	56                   	push   %esi
  801191:	ff d0                	call   *%eax
  801193:	89 c3                	mov    %eax,%ebx
  801195:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801198:	83 ec 08             	sub    $0x8,%esp
  80119b:	56                   	push   %esi
  80119c:	6a 00                	push   $0x0
  80119e:	e8 0a fc ff ff       	call   800dad <sys_page_unmap>
	return r;
  8011a3:	83 c4 10             	add    $0x10,%esp
  8011a6:	eb b5                	jmp    80115d <fd_close+0x3c>

008011a8 <close>:

int
close(int fdnum)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b1:	50                   	push   %eax
  8011b2:	ff 75 08             	pushl  0x8(%ebp)
  8011b5:	e8 bc fe ff ff       	call   801076 <fd_lookup>
  8011ba:	83 c4 10             	add    $0x10,%esp
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	79 02                	jns    8011c3 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011c1:	c9                   	leave  
  8011c2:	c3                   	ret    
		return fd_close(fd, 1);
  8011c3:	83 ec 08             	sub    $0x8,%esp
  8011c6:	6a 01                	push   $0x1
  8011c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8011cb:	e8 51 ff ff ff       	call   801121 <fd_close>
  8011d0:	83 c4 10             	add    $0x10,%esp
  8011d3:	eb ec                	jmp    8011c1 <close+0x19>

008011d5 <close_all>:

void
close_all(void)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
  8011d8:	53                   	push   %ebx
  8011d9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011dc:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011e1:	83 ec 0c             	sub    $0xc,%esp
  8011e4:	53                   	push   %ebx
  8011e5:	e8 be ff ff ff       	call   8011a8 <close>
	for (i = 0; i < MAXFD; i++)
  8011ea:	83 c3 01             	add    $0x1,%ebx
  8011ed:	83 c4 10             	add    $0x10,%esp
  8011f0:	83 fb 20             	cmp    $0x20,%ebx
  8011f3:	75 ec                	jne    8011e1 <close_all+0xc>
}
  8011f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	57                   	push   %edi
  8011fe:	56                   	push   %esi
  8011ff:	53                   	push   %ebx
  801200:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801203:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801206:	50                   	push   %eax
  801207:	ff 75 08             	pushl  0x8(%ebp)
  80120a:	e8 67 fe ff ff       	call   801076 <fd_lookup>
  80120f:	89 c3                	mov    %eax,%ebx
  801211:	83 c4 10             	add    $0x10,%esp
  801214:	85 c0                	test   %eax,%eax
  801216:	0f 88 81 00 00 00    	js     80129d <dup+0xa3>
		return r;
	close(newfdnum);
  80121c:	83 ec 0c             	sub    $0xc,%esp
  80121f:	ff 75 0c             	pushl  0xc(%ebp)
  801222:	e8 81 ff ff ff       	call   8011a8 <close>

	newfd = INDEX2FD(newfdnum);
  801227:	8b 75 0c             	mov    0xc(%ebp),%esi
  80122a:	c1 e6 0c             	shl    $0xc,%esi
  80122d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801233:	83 c4 04             	add    $0x4,%esp
  801236:	ff 75 e4             	pushl  -0x1c(%ebp)
  801239:	e8 cf fd ff ff       	call   80100d <fd2data>
  80123e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801240:	89 34 24             	mov    %esi,(%esp)
  801243:	e8 c5 fd ff ff       	call   80100d <fd2data>
  801248:	83 c4 10             	add    $0x10,%esp
  80124b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80124d:	89 d8                	mov    %ebx,%eax
  80124f:	c1 e8 16             	shr    $0x16,%eax
  801252:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801259:	a8 01                	test   $0x1,%al
  80125b:	74 11                	je     80126e <dup+0x74>
  80125d:	89 d8                	mov    %ebx,%eax
  80125f:	c1 e8 0c             	shr    $0xc,%eax
  801262:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801269:	f6 c2 01             	test   $0x1,%dl
  80126c:	75 39                	jne    8012a7 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80126e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801271:	89 d0                	mov    %edx,%eax
  801273:	c1 e8 0c             	shr    $0xc,%eax
  801276:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80127d:	83 ec 0c             	sub    $0xc,%esp
  801280:	25 07 0e 00 00       	and    $0xe07,%eax
  801285:	50                   	push   %eax
  801286:	56                   	push   %esi
  801287:	6a 00                	push   $0x0
  801289:	52                   	push   %edx
  80128a:	6a 00                	push   $0x0
  80128c:	e8 da fa ff ff       	call   800d6b <sys_page_map>
  801291:	89 c3                	mov    %eax,%ebx
  801293:	83 c4 20             	add    $0x20,%esp
  801296:	85 c0                	test   %eax,%eax
  801298:	78 31                	js     8012cb <dup+0xd1>
		goto err;

	return newfdnum;
  80129a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80129d:	89 d8                	mov    %ebx,%eax
  80129f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a2:	5b                   	pop    %ebx
  8012a3:	5e                   	pop    %esi
  8012a4:	5f                   	pop    %edi
  8012a5:	5d                   	pop    %ebp
  8012a6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012a7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012ae:	83 ec 0c             	sub    $0xc,%esp
  8012b1:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b6:	50                   	push   %eax
  8012b7:	57                   	push   %edi
  8012b8:	6a 00                	push   $0x0
  8012ba:	53                   	push   %ebx
  8012bb:	6a 00                	push   $0x0
  8012bd:	e8 a9 fa ff ff       	call   800d6b <sys_page_map>
  8012c2:	89 c3                	mov    %eax,%ebx
  8012c4:	83 c4 20             	add    $0x20,%esp
  8012c7:	85 c0                	test   %eax,%eax
  8012c9:	79 a3                	jns    80126e <dup+0x74>
	sys_page_unmap(0, newfd);
  8012cb:	83 ec 08             	sub    $0x8,%esp
  8012ce:	56                   	push   %esi
  8012cf:	6a 00                	push   $0x0
  8012d1:	e8 d7 fa ff ff       	call   800dad <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012d6:	83 c4 08             	add    $0x8,%esp
  8012d9:	57                   	push   %edi
  8012da:	6a 00                	push   $0x0
  8012dc:	e8 cc fa ff ff       	call   800dad <sys_page_unmap>
	return r;
  8012e1:	83 c4 10             	add    $0x10,%esp
  8012e4:	eb b7                	jmp    80129d <dup+0xa3>

008012e6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	53                   	push   %ebx
  8012ea:	83 ec 1c             	sub    $0x1c,%esp
  8012ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f3:	50                   	push   %eax
  8012f4:	53                   	push   %ebx
  8012f5:	e8 7c fd ff ff       	call   801076 <fd_lookup>
  8012fa:	83 c4 10             	add    $0x10,%esp
  8012fd:	85 c0                	test   %eax,%eax
  8012ff:	78 3f                	js     801340 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801301:	83 ec 08             	sub    $0x8,%esp
  801304:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801307:	50                   	push   %eax
  801308:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130b:	ff 30                	pushl  (%eax)
  80130d:	e8 b4 fd ff ff       	call   8010c6 <dev_lookup>
  801312:	83 c4 10             	add    $0x10,%esp
  801315:	85 c0                	test   %eax,%eax
  801317:	78 27                	js     801340 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801319:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80131c:	8b 42 08             	mov    0x8(%edx),%eax
  80131f:	83 e0 03             	and    $0x3,%eax
  801322:	83 f8 01             	cmp    $0x1,%eax
  801325:	74 1e                	je     801345 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132a:	8b 40 08             	mov    0x8(%eax),%eax
  80132d:	85 c0                	test   %eax,%eax
  80132f:	74 35                	je     801366 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801331:	83 ec 04             	sub    $0x4,%esp
  801334:	ff 75 10             	pushl  0x10(%ebp)
  801337:	ff 75 0c             	pushl  0xc(%ebp)
  80133a:	52                   	push   %edx
  80133b:	ff d0                	call   *%eax
  80133d:	83 c4 10             	add    $0x10,%esp
}
  801340:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801343:	c9                   	leave  
  801344:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801345:	a1 08 40 80 00       	mov    0x804008,%eax
  80134a:	8b 40 48             	mov    0x48(%eax),%eax
  80134d:	83 ec 04             	sub    $0x4,%esp
  801350:	53                   	push   %ebx
  801351:	50                   	push   %eax
  801352:	68 95 29 80 00       	push   $0x802995
  801357:	e8 7b ee ff ff       	call   8001d7 <cprintf>
		return -E_INVAL;
  80135c:	83 c4 10             	add    $0x10,%esp
  80135f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801364:	eb da                	jmp    801340 <read+0x5a>
		return -E_NOT_SUPP;
  801366:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80136b:	eb d3                	jmp    801340 <read+0x5a>

0080136d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	57                   	push   %edi
  801371:	56                   	push   %esi
  801372:	53                   	push   %ebx
  801373:	83 ec 0c             	sub    $0xc,%esp
  801376:	8b 7d 08             	mov    0x8(%ebp),%edi
  801379:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80137c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801381:	39 f3                	cmp    %esi,%ebx
  801383:	73 23                	jae    8013a8 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801385:	83 ec 04             	sub    $0x4,%esp
  801388:	89 f0                	mov    %esi,%eax
  80138a:	29 d8                	sub    %ebx,%eax
  80138c:	50                   	push   %eax
  80138d:	89 d8                	mov    %ebx,%eax
  80138f:	03 45 0c             	add    0xc(%ebp),%eax
  801392:	50                   	push   %eax
  801393:	57                   	push   %edi
  801394:	e8 4d ff ff ff       	call   8012e6 <read>
		if (m < 0)
  801399:	83 c4 10             	add    $0x10,%esp
  80139c:	85 c0                	test   %eax,%eax
  80139e:	78 06                	js     8013a6 <readn+0x39>
			return m;
		if (m == 0)
  8013a0:	74 06                	je     8013a8 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013a2:	01 c3                	add    %eax,%ebx
  8013a4:	eb db                	jmp    801381 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013a6:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013a8:	89 d8                	mov    %ebx,%eax
  8013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ad:	5b                   	pop    %ebx
  8013ae:	5e                   	pop    %esi
  8013af:	5f                   	pop    %edi
  8013b0:	5d                   	pop    %ebp
  8013b1:	c3                   	ret    

008013b2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
  8013b5:	53                   	push   %ebx
  8013b6:	83 ec 1c             	sub    $0x1c,%esp
  8013b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013bf:	50                   	push   %eax
  8013c0:	53                   	push   %ebx
  8013c1:	e8 b0 fc ff ff       	call   801076 <fd_lookup>
  8013c6:	83 c4 10             	add    $0x10,%esp
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	78 3a                	js     801407 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013cd:	83 ec 08             	sub    $0x8,%esp
  8013d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d3:	50                   	push   %eax
  8013d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d7:	ff 30                	pushl  (%eax)
  8013d9:	e8 e8 fc ff ff       	call   8010c6 <dev_lookup>
  8013de:	83 c4 10             	add    $0x10,%esp
  8013e1:	85 c0                	test   %eax,%eax
  8013e3:	78 22                	js     801407 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013ec:	74 1e                	je     80140c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f1:	8b 52 0c             	mov    0xc(%edx),%edx
  8013f4:	85 d2                	test   %edx,%edx
  8013f6:	74 35                	je     80142d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013f8:	83 ec 04             	sub    $0x4,%esp
  8013fb:	ff 75 10             	pushl  0x10(%ebp)
  8013fe:	ff 75 0c             	pushl  0xc(%ebp)
  801401:	50                   	push   %eax
  801402:	ff d2                	call   *%edx
  801404:	83 c4 10             	add    $0x10,%esp
}
  801407:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80140c:	a1 08 40 80 00       	mov    0x804008,%eax
  801411:	8b 40 48             	mov    0x48(%eax),%eax
  801414:	83 ec 04             	sub    $0x4,%esp
  801417:	53                   	push   %ebx
  801418:	50                   	push   %eax
  801419:	68 b1 29 80 00       	push   $0x8029b1
  80141e:	e8 b4 ed ff ff       	call   8001d7 <cprintf>
		return -E_INVAL;
  801423:	83 c4 10             	add    $0x10,%esp
  801426:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80142b:	eb da                	jmp    801407 <write+0x55>
		return -E_NOT_SUPP;
  80142d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801432:	eb d3                	jmp    801407 <write+0x55>

00801434 <seek>:

int
seek(int fdnum, off_t offset)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80143a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143d:	50                   	push   %eax
  80143e:	ff 75 08             	pushl  0x8(%ebp)
  801441:	e8 30 fc ff ff       	call   801076 <fd_lookup>
  801446:	83 c4 10             	add    $0x10,%esp
  801449:	85 c0                	test   %eax,%eax
  80144b:	78 0e                	js     80145b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80144d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801453:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801456:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	53                   	push   %ebx
  801461:	83 ec 1c             	sub    $0x1c,%esp
  801464:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801467:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80146a:	50                   	push   %eax
  80146b:	53                   	push   %ebx
  80146c:	e8 05 fc ff ff       	call   801076 <fd_lookup>
  801471:	83 c4 10             	add    $0x10,%esp
  801474:	85 c0                	test   %eax,%eax
  801476:	78 37                	js     8014af <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801478:	83 ec 08             	sub    $0x8,%esp
  80147b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147e:	50                   	push   %eax
  80147f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801482:	ff 30                	pushl  (%eax)
  801484:	e8 3d fc ff ff       	call   8010c6 <dev_lookup>
  801489:	83 c4 10             	add    $0x10,%esp
  80148c:	85 c0                	test   %eax,%eax
  80148e:	78 1f                	js     8014af <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801490:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801493:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801497:	74 1b                	je     8014b4 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801499:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149c:	8b 52 18             	mov    0x18(%edx),%edx
  80149f:	85 d2                	test   %edx,%edx
  8014a1:	74 32                	je     8014d5 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014a3:	83 ec 08             	sub    $0x8,%esp
  8014a6:	ff 75 0c             	pushl  0xc(%ebp)
  8014a9:	50                   	push   %eax
  8014aa:	ff d2                	call   *%edx
  8014ac:	83 c4 10             	add    $0x10,%esp
}
  8014af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014b4:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014b9:	8b 40 48             	mov    0x48(%eax),%eax
  8014bc:	83 ec 04             	sub    $0x4,%esp
  8014bf:	53                   	push   %ebx
  8014c0:	50                   	push   %eax
  8014c1:	68 74 29 80 00       	push   $0x802974
  8014c6:	e8 0c ed ff ff       	call   8001d7 <cprintf>
		return -E_INVAL;
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d3:	eb da                	jmp    8014af <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014da:	eb d3                	jmp    8014af <ftruncate+0x52>

008014dc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	53                   	push   %ebx
  8014e0:	83 ec 1c             	sub    $0x1c,%esp
  8014e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e9:	50                   	push   %eax
  8014ea:	ff 75 08             	pushl  0x8(%ebp)
  8014ed:	e8 84 fb ff ff       	call   801076 <fd_lookup>
  8014f2:	83 c4 10             	add    $0x10,%esp
  8014f5:	85 c0                	test   %eax,%eax
  8014f7:	78 4b                	js     801544 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ff:	50                   	push   %eax
  801500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801503:	ff 30                	pushl  (%eax)
  801505:	e8 bc fb ff ff       	call   8010c6 <dev_lookup>
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	85 c0                	test   %eax,%eax
  80150f:	78 33                	js     801544 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801514:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801518:	74 2f                	je     801549 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80151a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80151d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801524:	00 00 00 
	stat->st_isdir = 0;
  801527:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80152e:	00 00 00 
	stat->st_dev = dev;
  801531:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801537:	83 ec 08             	sub    $0x8,%esp
  80153a:	53                   	push   %ebx
  80153b:	ff 75 f0             	pushl  -0x10(%ebp)
  80153e:	ff 50 14             	call   *0x14(%eax)
  801541:	83 c4 10             	add    $0x10,%esp
}
  801544:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801547:	c9                   	leave  
  801548:	c3                   	ret    
		return -E_NOT_SUPP;
  801549:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80154e:	eb f4                	jmp    801544 <fstat+0x68>

00801550 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	56                   	push   %esi
  801554:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801555:	83 ec 08             	sub    $0x8,%esp
  801558:	6a 00                	push   $0x0
  80155a:	ff 75 08             	pushl  0x8(%ebp)
  80155d:	e8 22 02 00 00       	call   801784 <open>
  801562:	89 c3                	mov    %eax,%ebx
  801564:	83 c4 10             	add    $0x10,%esp
  801567:	85 c0                	test   %eax,%eax
  801569:	78 1b                	js     801586 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80156b:	83 ec 08             	sub    $0x8,%esp
  80156e:	ff 75 0c             	pushl  0xc(%ebp)
  801571:	50                   	push   %eax
  801572:	e8 65 ff ff ff       	call   8014dc <fstat>
  801577:	89 c6                	mov    %eax,%esi
	close(fd);
  801579:	89 1c 24             	mov    %ebx,(%esp)
  80157c:	e8 27 fc ff ff       	call   8011a8 <close>
	return r;
  801581:	83 c4 10             	add    $0x10,%esp
  801584:	89 f3                	mov    %esi,%ebx
}
  801586:	89 d8                	mov    %ebx,%eax
  801588:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80158b:	5b                   	pop    %ebx
  80158c:	5e                   	pop    %esi
  80158d:	5d                   	pop    %ebp
  80158e:	c3                   	ret    

0080158f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	56                   	push   %esi
  801593:	53                   	push   %ebx
  801594:	89 c6                	mov    %eax,%esi
  801596:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801598:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80159f:	74 27                	je     8015c8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015a1:	6a 07                	push   $0x7
  8015a3:	68 00 50 80 00       	push   $0x805000
  8015a8:	56                   	push   %esi
  8015a9:	ff 35 00 40 80 00    	pushl  0x804000
  8015af:	e8 69 0c 00 00       	call   80221d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015b4:	83 c4 0c             	add    $0xc,%esp
  8015b7:	6a 00                	push   $0x0
  8015b9:	53                   	push   %ebx
  8015ba:	6a 00                	push   $0x0
  8015bc:	e8 f3 0b 00 00       	call   8021b4 <ipc_recv>
}
  8015c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c4:	5b                   	pop    %ebx
  8015c5:	5e                   	pop    %esi
  8015c6:	5d                   	pop    %ebp
  8015c7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015c8:	83 ec 0c             	sub    $0xc,%esp
  8015cb:	6a 01                	push   $0x1
  8015cd:	e8 a3 0c 00 00       	call   802275 <ipc_find_env>
  8015d2:	a3 00 40 80 00       	mov    %eax,0x804000
  8015d7:	83 c4 10             	add    $0x10,%esp
  8015da:	eb c5                	jmp    8015a1 <fsipc+0x12>

008015dc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f0:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fa:	b8 02 00 00 00       	mov    $0x2,%eax
  8015ff:	e8 8b ff ff ff       	call   80158f <fsipc>
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <devfile_flush>:
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8b 40 0c             	mov    0xc(%eax),%eax
  801612:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801617:	ba 00 00 00 00       	mov    $0x0,%edx
  80161c:	b8 06 00 00 00       	mov    $0x6,%eax
  801621:	e8 69 ff ff ff       	call   80158f <fsipc>
}
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <devfile_stat>:
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	53                   	push   %ebx
  80162c:	83 ec 04             	sub    $0x4,%esp
  80162f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	8b 40 0c             	mov    0xc(%eax),%eax
  801638:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80163d:	ba 00 00 00 00       	mov    $0x0,%edx
  801642:	b8 05 00 00 00       	mov    $0x5,%eax
  801647:	e8 43 ff ff ff       	call   80158f <fsipc>
  80164c:	85 c0                	test   %eax,%eax
  80164e:	78 2c                	js     80167c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	68 00 50 80 00       	push   $0x805000
  801658:	53                   	push   %ebx
  801659:	e8 d8 f2 ff ff       	call   800936 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80165e:	a1 80 50 80 00       	mov    0x805080,%eax
  801663:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801669:	a1 84 50 80 00       	mov    0x805084,%eax
  80166e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <devfile_write>:
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	53                   	push   %ebx
  801685:	83 ec 08             	sub    $0x8,%esp
  801688:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	8b 40 0c             	mov    0xc(%eax),%eax
  801691:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801696:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80169c:	53                   	push   %ebx
  80169d:	ff 75 0c             	pushl  0xc(%ebp)
  8016a0:	68 08 50 80 00       	push   $0x805008
  8016a5:	e8 7c f4 ff ff       	call   800b26 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8016af:	b8 04 00 00 00       	mov    $0x4,%eax
  8016b4:	e8 d6 fe ff ff       	call   80158f <fsipc>
  8016b9:	83 c4 10             	add    $0x10,%esp
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	78 0b                	js     8016cb <devfile_write+0x4a>
	assert(r <= n);
  8016c0:	39 d8                	cmp    %ebx,%eax
  8016c2:	77 0c                	ja     8016d0 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016c4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016c9:	7f 1e                	jg     8016e9 <devfile_write+0x68>
}
  8016cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    
	assert(r <= n);
  8016d0:	68 e4 29 80 00       	push   $0x8029e4
  8016d5:	68 eb 29 80 00       	push   $0x8029eb
  8016da:	68 98 00 00 00       	push   $0x98
  8016df:	68 00 2a 80 00       	push   $0x802a00
  8016e4:	e8 6a 0a 00 00       	call   802153 <_panic>
	assert(r <= PGSIZE);
  8016e9:	68 0b 2a 80 00       	push   $0x802a0b
  8016ee:	68 eb 29 80 00       	push   $0x8029eb
  8016f3:	68 99 00 00 00       	push   $0x99
  8016f8:	68 00 2a 80 00       	push   $0x802a00
  8016fd:	e8 51 0a 00 00       	call   802153 <_panic>

00801702 <devfile_read>:
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	56                   	push   %esi
  801706:	53                   	push   %ebx
  801707:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	8b 40 0c             	mov    0xc(%eax),%eax
  801710:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801715:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80171b:	ba 00 00 00 00       	mov    $0x0,%edx
  801720:	b8 03 00 00 00       	mov    $0x3,%eax
  801725:	e8 65 fe ff ff       	call   80158f <fsipc>
  80172a:	89 c3                	mov    %eax,%ebx
  80172c:	85 c0                	test   %eax,%eax
  80172e:	78 1f                	js     80174f <devfile_read+0x4d>
	assert(r <= n);
  801730:	39 f0                	cmp    %esi,%eax
  801732:	77 24                	ja     801758 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801734:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801739:	7f 33                	jg     80176e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80173b:	83 ec 04             	sub    $0x4,%esp
  80173e:	50                   	push   %eax
  80173f:	68 00 50 80 00       	push   $0x805000
  801744:	ff 75 0c             	pushl  0xc(%ebp)
  801747:	e8 78 f3 ff ff       	call   800ac4 <memmove>
	return r;
  80174c:	83 c4 10             	add    $0x10,%esp
}
  80174f:	89 d8                	mov    %ebx,%eax
  801751:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801754:	5b                   	pop    %ebx
  801755:	5e                   	pop    %esi
  801756:	5d                   	pop    %ebp
  801757:	c3                   	ret    
	assert(r <= n);
  801758:	68 e4 29 80 00       	push   $0x8029e4
  80175d:	68 eb 29 80 00       	push   $0x8029eb
  801762:	6a 7c                	push   $0x7c
  801764:	68 00 2a 80 00       	push   $0x802a00
  801769:	e8 e5 09 00 00       	call   802153 <_panic>
	assert(r <= PGSIZE);
  80176e:	68 0b 2a 80 00       	push   $0x802a0b
  801773:	68 eb 29 80 00       	push   $0x8029eb
  801778:	6a 7d                	push   $0x7d
  80177a:	68 00 2a 80 00       	push   $0x802a00
  80177f:	e8 cf 09 00 00       	call   802153 <_panic>

00801784 <open>:
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	56                   	push   %esi
  801788:	53                   	push   %ebx
  801789:	83 ec 1c             	sub    $0x1c,%esp
  80178c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80178f:	56                   	push   %esi
  801790:	e8 68 f1 ff ff       	call   8008fd <strlen>
  801795:	83 c4 10             	add    $0x10,%esp
  801798:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80179d:	7f 6c                	jg     80180b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80179f:	83 ec 0c             	sub    $0xc,%esp
  8017a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a5:	50                   	push   %eax
  8017a6:	e8 79 f8 ff ff       	call   801024 <fd_alloc>
  8017ab:	89 c3                	mov    %eax,%ebx
  8017ad:	83 c4 10             	add    $0x10,%esp
  8017b0:	85 c0                	test   %eax,%eax
  8017b2:	78 3c                	js     8017f0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017b4:	83 ec 08             	sub    $0x8,%esp
  8017b7:	56                   	push   %esi
  8017b8:	68 00 50 80 00       	push   $0x805000
  8017bd:	e8 74 f1 ff ff       	call   800936 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c5:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d2:	e8 b8 fd ff ff       	call   80158f <fsipc>
  8017d7:	89 c3                	mov    %eax,%ebx
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	78 19                	js     8017f9 <open+0x75>
	return fd2num(fd);
  8017e0:	83 ec 0c             	sub    $0xc,%esp
  8017e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e6:	e8 12 f8 ff ff       	call   800ffd <fd2num>
  8017eb:	89 c3                	mov    %eax,%ebx
  8017ed:	83 c4 10             	add    $0x10,%esp
}
  8017f0:	89 d8                	mov    %ebx,%eax
  8017f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f5:	5b                   	pop    %ebx
  8017f6:	5e                   	pop    %esi
  8017f7:	5d                   	pop    %ebp
  8017f8:	c3                   	ret    
		fd_close(fd, 0);
  8017f9:	83 ec 08             	sub    $0x8,%esp
  8017fc:	6a 00                	push   $0x0
  8017fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801801:	e8 1b f9 ff ff       	call   801121 <fd_close>
		return r;
  801806:	83 c4 10             	add    $0x10,%esp
  801809:	eb e5                	jmp    8017f0 <open+0x6c>
		return -E_BAD_PATH;
  80180b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801810:	eb de                	jmp    8017f0 <open+0x6c>

00801812 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801818:	ba 00 00 00 00       	mov    $0x0,%edx
  80181d:	b8 08 00 00 00       	mov    $0x8,%eax
  801822:	e8 68 fd ff ff       	call   80158f <fsipc>
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80182f:	68 17 2a 80 00       	push   $0x802a17
  801834:	ff 75 0c             	pushl  0xc(%ebp)
  801837:	e8 fa f0 ff ff       	call   800936 <strcpy>
	return 0;
}
  80183c:	b8 00 00 00 00       	mov    $0x0,%eax
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <devsock_close>:
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	53                   	push   %ebx
  801847:	83 ec 10             	sub    $0x10,%esp
  80184a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80184d:	53                   	push   %ebx
  80184e:	e8 5d 0a 00 00       	call   8022b0 <pageref>
  801853:	83 c4 10             	add    $0x10,%esp
		return 0;
  801856:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80185b:	83 f8 01             	cmp    $0x1,%eax
  80185e:	74 07                	je     801867 <devsock_close+0x24>
}
  801860:	89 d0                	mov    %edx,%eax
  801862:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801865:	c9                   	leave  
  801866:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801867:	83 ec 0c             	sub    $0xc,%esp
  80186a:	ff 73 0c             	pushl  0xc(%ebx)
  80186d:	e8 b9 02 00 00       	call   801b2b <nsipc_close>
  801872:	89 c2                	mov    %eax,%edx
  801874:	83 c4 10             	add    $0x10,%esp
  801877:	eb e7                	jmp    801860 <devsock_close+0x1d>

00801879 <devsock_write>:
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80187f:	6a 00                	push   $0x0
  801881:	ff 75 10             	pushl  0x10(%ebp)
  801884:	ff 75 0c             	pushl  0xc(%ebp)
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	ff 70 0c             	pushl  0xc(%eax)
  80188d:	e8 76 03 00 00       	call   801c08 <nsipc_send>
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <devsock_read>:
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80189a:	6a 00                	push   $0x0
  80189c:	ff 75 10             	pushl  0x10(%ebp)
  80189f:	ff 75 0c             	pushl  0xc(%ebp)
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	ff 70 0c             	pushl  0xc(%eax)
  8018a8:	e8 ef 02 00 00       	call   801b9c <nsipc_recv>
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <fd2sockid>:
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018b5:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018b8:	52                   	push   %edx
  8018b9:	50                   	push   %eax
  8018ba:	e8 b7 f7 ff ff       	call   801076 <fd_lookup>
  8018bf:	83 c4 10             	add    $0x10,%esp
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	78 10                	js     8018d6 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c9:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018cf:	39 08                	cmp    %ecx,(%eax)
  8018d1:	75 05                	jne    8018d8 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018d3:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    
		return -E_NOT_SUPP;
  8018d8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018dd:	eb f7                	jmp    8018d6 <fd2sockid+0x27>

008018df <alloc_sockfd>:
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	56                   	push   %esi
  8018e3:	53                   	push   %ebx
  8018e4:	83 ec 1c             	sub    $0x1c,%esp
  8018e7:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ec:	50                   	push   %eax
  8018ed:	e8 32 f7 ff ff       	call   801024 <fd_alloc>
  8018f2:	89 c3                	mov    %eax,%ebx
  8018f4:	83 c4 10             	add    $0x10,%esp
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	78 43                	js     80193e <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018fb:	83 ec 04             	sub    $0x4,%esp
  8018fe:	68 07 04 00 00       	push   $0x407
  801903:	ff 75 f4             	pushl  -0xc(%ebp)
  801906:	6a 00                	push   $0x0
  801908:	e8 1b f4 ff ff       	call   800d28 <sys_page_alloc>
  80190d:	89 c3                	mov    %eax,%ebx
  80190f:	83 c4 10             	add    $0x10,%esp
  801912:	85 c0                	test   %eax,%eax
  801914:	78 28                	js     80193e <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801919:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80191f:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801924:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80192b:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80192e:	83 ec 0c             	sub    $0xc,%esp
  801931:	50                   	push   %eax
  801932:	e8 c6 f6 ff ff       	call   800ffd <fd2num>
  801937:	89 c3                	mov    %eax,%ebx
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	eb 0c                	jmp    80194a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80193e:	83 ec 0c             	sub    $0xc,%esp
  801941:	56                   	push   %esi
  801942:	e8 e4 01 00 00       	call   801b2b <nsipc_close>
		return r;
  801947:	83 c4 10             	add    $0x10,%esp
}
  80194a:	89 d8                	mov    %ebx,%eax
  80194c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80194f:	5b                   	pop    %ebx
  801950:	5e                   	pop    %esi
  801951:	5d                   	pop    %ebp
  801952:	c3                   	ret    

00801953 <accept>:
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	e8 4e ff ff ff       	call   8018af <fd2sockid>
  801961:	85 c0                	test   %eax,%eax
  801963:	78 1b                	js     801980 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801965:	83 ec 04             	sub    $0x4,%esp
  801968:	ff 75 10             	pushl  0x10(%ebp)
  80196b:	ff 75 0c             	pushl  0xc(%ebp)
  80196e:	50                   	push   %eax
  80196f:	e8 0e 01 00 00       	call   801a82 <nsipc_accept>
  801974:	83 c4 10             	add    $0x10,%esp
  801977:	85 c0                	test   %eax,%eax
  801979:	78 05                	js     801980 <accept+0x2d>
	return alloc_sockfd(r);
  80197b:	e8 5f ff ff ff       	call   8018df <alloc_sockfd>
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <bind>:
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	e8 1f ff ff ff       	call   8018af <fd2sockid>
  801990:	85 c0                	test   %eax,%eax
  801992:	78 12                	js     8019a6 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801994:	83 ec 04             	sub    $0x4,%esp
  801997:	ff 75 10             	pushl  0x10(%ebp)
  80199a:	ff 75 0c             	pushl  0xc(%ebp)
  80199d:	50                   	push   %eax
  80199e:	e8 31 01 00 00       	call   801ad4 <nsipc_bind>
  8019a3:	83 c4 10             	add    $0x10,%esp
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <shutdown>:
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
  8019ab:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	e8 f9 fe ff ff       	call   8018af <fd2sockid>
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	78 0f                	js     8019c9 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019ba:	83 ec 08             	sub    $0x8,%esp
  8019bd:	ff 75 0c             	pushl  0xc(%ebp)
  8019c0:	50                   	push   %eax
  8019c1:	e8 43 01 00 00       	call   801b09 <nsipc_shutdown>
  8019c6:	83 c4 10             	add    $0x10,%esp
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <connect>:
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	e8 d6 fe ff ff       	call   8018af <fd2sockid>
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	78 12                	js     8019ef <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019dd:	83 ec 04             	sub    $0x4,%esp
  8019e0:	ff 75 10             	pushl  0x10(%ebp)
  8019e3:	ff 75 0c             	pushl  0xc(%ebp)
  8019e6:	50                   	push   %eax
  8019e7:	e8 59 01 00 00       	call   801b45 <nsipc_connect>
  8019ec:	83 c4 10             	add    $0x10,%esp
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <listen>:
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	e8 b0 fe ff ff       	call   8018af <fd2sockid>
  8019ff:	85 c0                	test   %eax,%eax
  801a01:	78 0f                	js     801a12 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a03:	83 ec 08             	sub    $0x8,%esp
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	50                   	push   %eax
  801a0a:	e8 6b 01 00 00       	call   801b7a <nsipc_listen>
  801a0f:	83 c4 10             	add    $0x10,%esp
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a1a:	ff 75 10             	pushl  0x10(%ebp)
  801a1d:	ff 75 0c             	pushl  0xc(%ebp)
  801a20:	ff 75 08             	pushl  0x8(%ebp)
  801a23:	e8 3e 02 00 00       	call   801c66 <nsipc_socket>
  801a28:	83 c4 10             	add    $0x10,%esp
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	78 05                	js     801a34 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a2f:	e8 ab fe ff ff       	call   8018df <alloc_sockfd>
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	53                   	push   %ebx
  801a3a:	83 ec 04             	sub    $0x4,%esp
  801a3d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a3f:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a46:	74 26                	je     801a6e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a48:	6a 07                	push   $0x7
  801a4a:	68 00 60 80 00       	push   $0x806000
  801a4f:	53                   	push   %ebx
  801a50:	ff 35 04 40 80 00    	pushl  0x804004
  801a56:	e8 c2 07 00 00       	call   80221d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a5b:	83 c4 0c             	add    $0xc,%esp
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	e8 4b 07 00 00       	call   8021b4 <ipc_recv>
}
  801a69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a6e:	83 ec 0c             	sub    $0xc,%esp
  801a71:	6a 02                	push   $0x2
  801a73:	e8 fd 07 00 00       	call   802275 <ipc_find_env>
  801a78:	a3 04 40 80 00       	mov    %eax,0x804004
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	eb c6                	jmp    801a48 <nsipc+0x12>

00801a82 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	56                   	push   %esi
  801a86:	53                   	push   %ebx
  801a87:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a92:	8b 06                	mov    (%esi),%eax
  801a94:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a99:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9e:	e8 93 ff ff ff       	call   801a36 <nsipc>
  801aa3:	89 c3                	mov    %eax,%ebx
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	79 09                	jns    801ab2 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801aa9:	89 d8                	mov    %ebx,%eax
  801aab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aae:	5b                   	pop    %ebx
  801aaf:	5e                   	pop    %esi
  801ab0:	5d                   	pop    %ebp
  801ab1:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ab2:	83 ec 04             	sub    $0x4,%esp
  801ab5:	ff 35 10 60 80 00    	pushl  0x806010
  801abb:	68 00 60 80 00       	push   $0x806000
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	e8 fc ef ff ff       	call   800ac4 <memmove>
		*addrlen = ret->ret_addrlen;
  801ac8:	a1 10 60 80 00       	mov    0x806010,%eax
  801acd:	89 06                	mov    %eax,(%esi)
  801acf:	83 c4 10             	add    $0x10,%esp
	return r;
  801ad2:	eb d5                	jmp    801aa9 <nsipc_accept+0x27>

00801ad4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	53                   	push   %ebx
  801ad8:	83 ec 08             	sub    $0x8,%esp
  801adb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ae6:	53                   	push   %ebx
  801ae7:	ff 75 0c             	pushl  0xc(%ebp)
  801aea:	68 04 60 80 00       	push   $0x806004
  801aef:	e8 d0 ef ff ff       	call   800ac4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801af4:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801afa:	b8 02 00 00 00       	mov    $0x2,%eax
  801aff:	e8 32 ff ff ff       	call   801a36 <nsipc>
}
  801b04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b1f:	b8 03 00 00 00       	mov    $0x3,%eax
  801b24:	e8 0d ff ff ff       	call   801a36 <nsipc>
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <nsipc_close>:

int
nsipc_close(int s)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b39:	b8 04 00 00 00       	mov    $0x4,%eax
  801b3e:	e8 f3 fe ff ff       	call   801a36 <nsipc>
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	53                   	push   %ebx
  801b49:	83 ec 08             	sub    $0x8,%esp
  801b4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b57:	53                   	push   %ebx
  801b58:	ff 75 0c             	pushl  0xc(%ebp)
  801b5b:	68 04 60 80 00       	push   $0x806004
  801b60:	e8 5f ef ff ff       	call   800ac4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b65:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b6b:	b8 05 00 00 00       	mov    $0x5,%eax
  801b70:	e8 c1 fe ff ff       	call   801a36 <nsipc>
}
  801b75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b90:	b8 06 00 00 00       	mov    $0x6,%eax
  801b95:	e8 9c fe ff ff       	call   801a36 <nsipc>
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	56                   	push   %esi
  801ba0:	53                   	push   %ebx
  801ba1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bac:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bb2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb5:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bba:	b8 07 00 00 00       	mov    $0x7,%eax
  801bbf:	e8 72 fe ff ff       	call   801a36 <nsipc>
  801bc4:	89 c3                	mov    %eax,%ebx
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	78 1f                	js     801be9 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bca:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bcf:	7f 21                	jg     801bf2 <nsipc_recv+0x56>
  801bd1:	39 c6                	cmp    %eax,%esi
  801bd3:	7c 1d                	jl     801bf2 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bd5:	83 ec 04             	sub    $0x4,%esp
  801bd8:	50                   	push   %eax
  801bd9:	68 00 60 80 00       	push   $0x806000
  801bde:	ff 75 0c             	pushl  0xc(%ebp)
  801be1:	e8 de ee ff ff       	call   800ac4 <memmove>
  801be6:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801be9:	89 d8                	mov    %ebx,%eax
  801beb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bee:	5b                   	pop    %ebx
  801bef:	5e                   	pop    %esi
  801bf0:	5d                   	pop    %ebp
  801bf1:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bf2:	68 23 2a 80 00       	push   $0x802a23
  801bf7:	68 eb 29 80 00       	push   $0x8029eb
  801bfc:	6a 62                	push   $0x62
  801bfe:	68 38 2a 80 00       	push   $0x802a38
  801c03:	e8 4b 05 00 00       	call   802153 <_panic>

00801c08 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	53                   	push   %ebx
  801c0c:	83 ec 04             	sub    $0x4,%esp
  801c0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c1a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c20:	7f 2e                	jg     801c50 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c22:	83 ec 04             	sub    $0x4,%esp
  801c25:	53                   	push   %ebx
  801c26:	ff 75 0c             	pushl  0xc(%ebp)
  801c29:	68 0c 60 80 00       	push   $0x80600c
  801c2e:	e8 91 ee ff ff       	call   800ac4 <memmove>
	nsipcbuf.send.req_size = size;
  801c33:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c39:	8b 45 14             	mov    0x14(%ebp),%eax
  801c3c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c41:	b8 08 00 00 00       	mov    $0x8,%eax
  801c46:	e8 eb fd ff ff       	call   801a36 <nsipc>
}
  801c4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    
	assert(size < 1600);
  801c50:	68 44 2a 80 00       	push   $0x802a44
  801c55:	68 eb 29 80 00       	push   $0x8029eb
  801c5a:	6a 6d                	push   $0x6d
  801c5c:	68 38 2a 80 00       	push   $0x802a38
  801c61:	e8 ed 04 00 00       	call   802153 <_panic>

00801c66 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c77:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c7f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c84:	b8 09 00 00 00       	mov    $0x9,%eax
  801c89:	e8 a8 fd ff ff       	call   801a36 <nsipc>
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	56                   	push   %esi
  801c94:	53                   	push   %ebx
  801c95:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c98:	83 ec 0c             	sub    $0xc,%esp
  801c9b:	ff 75 08             	pushl  0x8(%ebp)
  801c9e:	e8 6a f3 ff ff       	call   80100d <fd2data>
  801ca3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ca5:	83 c4 08             	add    $0x8,%esp
  801ca8:	68 50 2a 80 00       	push   $0x802a50
  801cad:	53                   	push   %ebx
  801cae:	e8 83 ec ff ff       	call   800936 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cb3:	8b 46 04             	mov    0x4(%esi),%eax
  801cb6:	2b 06                	sub    (%esi),%eax
  801cb8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cbe:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cc5:	00 00 00 
	stat->st_dev = &devpipe;
  801cc8:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ccf:	30 80 00 
	return 0;
}
  801cd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cda:	5b                   	pop    %ebx
  801cdb:	5e                   	pop    %esi
  801cdc:	5d                   	pop    %ebp
  801cdd:	c3                   	ret    

00801cde <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	53                   	push   %ebx
  801ce2:	83 ec 0c             	sub    $0xc,%esp
  801ce5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ce8:	53                   	push   %ebx
  801ce9:	6a 00                	push   $0x0
  801ceb:	e8 bd f0 ff ff       	call   800dad <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cf0:	89 1c 24             	mov    %ebx,(%esp)
  801cf3:	e8 15 f3 ff ff       	call   80100d <fd2data>
  801cf8:	83 c4 08             	add    $0x8,%esp
  801cfb:	50                   	push   %eax
  801cfc:	6a 00                	push   $0x0
  801cfe:	e8 aa f0 ff ff       	call   800dad <sys_page_unmap>
}
  801d03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <_pipeisclosed>:
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	57                   	push   %edi
  801d0c:	56                   	push   %esi
  801d0d:	53                   	push   %ebx
  801d0e:	83 ec 1c             	sub    $0x1c,%esp
  801d11:	89 c7                	mov    %eax,%edi
  801d13:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d15:	a1 08 40 80 00       	mov    0x804008,%eax
  801d1a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d1d:	83 ec 0c             	sub    $0xc,%esp
  801d20:	57                   	push   %edi
  801d21:	e8 8a 05 00 00       	call   8022b0 <pageref>
  801d26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d29:	89 34 24             	mov    %esi,(%esp)
  801d2c:	e8 7f 05 00 00       	call   8022b0 <pageref>
		nn = thisenv->env_runs;
  801d31:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d37:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d3a:	83 c4 10             	add    $0x10,%esp
  801d3d:	39 cb                	cmp    %ecx,%ebx
  801d3f:	74 1b                	je     801d5c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d41:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d44:	75 cf                	jne    801d15 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d46:	8b 42 58             	mov    0x58(%edx),%eax
  801d49:	6a 01                	push   $0x1
  801d4b:	50                   	push   %eax
  801d4c:	53                   	push   %ebx
  801d4d:	68 57 2a 80 00       	push   $0x802a57
  801d52:	e8 80 e4 ff ff       	call   8001d7 <cprintf>
  801d57:	83 c4 10             	add    $0x10,%esp
  801d5a:	eb b9                	jmp    801d15 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d5c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d5f:	0f 94 c0             	sete   %al
  801d62:	0f b6 c0             	movzbl %al,%eax
}
  801d65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d68:	5b                   	pop    %ebx
  801d69:	5e                   	pop    %esi
  801d6a:	5f                   	pop    %edi
  801d6b:	5d                   	pop    %ebp
  801d6c:	c3                   	ret    

00801d6d <devpipe_write>:
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	57                   	push   %edi
  801d71:	56                   	push   %esi
  801d72:	53                   	push   %ebx
  801d73:	83 ec 28             	sub    $0x28,%esp
  801d76:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d79:	56                   	push   %esi
  801d7a:	e8 8e f2 ff ff       	call   80100d <fd2data>
  801d7f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d81:	83 c4 10             	add    $0x10,%esp
  801d84:	bf 00 00 00 00       	mov    $0x0,%edi
  801d89:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d8c:	74 4f                	je     801ddd <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d8e:	8b 43 04             	mov    0x4(%ebx),%eax
  801d91:	8b 0b                	mov    (%ebx),%ecx
  801d93:	8d 51 20             	lea    0x20(%ecx),%edx
  801d96:	39 d0                	cmp    %edx,%eax
  801d98:	72 14                	jb     801dae <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d9a:	89 da                	mov    %ebx,%edx
  801d9c:	89 f0                	mov    %esi,%eax
  801d9e:	e8 65 ff ff ff       	call   801d08 <_pipeisclosed>
  801da3:	85 c0                	test   %eax,%eax
  801da5:	75 3b                	jne    801de2 <devpipe_write+0x75>
			sys_yield();
  801da7:	e8 5d ef ff ff       	call   800d09 <sys_yield>
  801dac:	eb e0                	jmp    801d8e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801db5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801db8:	89 c2                	mov    %eax,%edx
  801dba:	c1 fa 1f             	sar    $0x1f,%edx
  801dbd:	89 d1                	mov    %edx,%ecx
  801dbf:	c1 e9 1b             	shr    $0x1b,%ecx
  801dc2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dc5:	83 e2 1f             	and    $0x1f,%edx
  801dc8:	29 ca                	sub    %ecx,%edx
  801dca:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dce:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dd2:	83 c0 01             	add    $0x1,%eax
  801dd5:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dd8:	83 c7 01             	add    $0x1,%edi
  801ddb:	eb ac                	jmp    801d89 <devpipe_write+0x1c>
	return i;
  801ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  801de0:	eb 05                	jmp    801de7 <devpipe_write+0x7a>
				return 0;
  801de2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dea:	5b                   	pop    %ebx
  801deb:	5e                   	pop    %esi
  801dec:	5f                   	pop    %edi
  801ded:	5d                   	pop    %ebp
  801dee:	c3                   	ret    

00801def <devpipe_read>:
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	57                   	push   %edi
  801df3:	56                   	push   %esi
  801df4:	53                   	push   %ebx
  801df5:	83 ec 18             	sub    $0x18,%esp
  801df8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dfb:	57                   	push   %edi
  801dfc:	e8 0c f2 ff ff       	call   80100d <fd2data>
  801e01:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e03:	83 c4 10             	add    $0x10,%esp
  801e06:	be 00 00 00 00       	mov    $0x0,%esi
  801e0b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e0e:	75 14                	jne    801e24 <devpipe_read+0x35>
	return i;
  801e10:	8b 45 10             	mov    0x10(%ebp),%eax
  801e13:	eb 02                	jmp    801e17 <devpipe_read+0x28>
				return i;
  801e15:	89 f0                	mov    %esi,%eax
}
  801e17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1a:	5b                   	pop    %ebx
  801e1b:	5e                   	pop    %esi
  801e1c:	5f                   	pop    %edi
  801e1d:	5d                   	pop    %ebp
  801e1e:	c3                   	ret    
			sys_yield();
  801e1f:	e8 e5 ee ff ff       	call   800d09 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e24:	8b 03                	mov    (%ebx),%eax
  801e26:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e29:	75 18                	jne    801e43 <devpipe_read+0x54>
			if (i > 0)
  801e2b:	85 f6                	test   %esi,%esi
  801e2d:	75 e6                	jne    801e15 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e2f:	89 da                	mov    %ebx,%edx
  801e31:	89 f8                	mov    %edi,%eax
  801e33:	e8 d0 fe ff ff       	call   801d08 <_pipeisclosed>
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	74 e3                	je     801e1f <devpipe_read+0x30>
				return 0;
  801e3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e41:	eb d4                	jmp    801e17 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e43:	99                   	cltd   
  801e44:	c1 ea 1b             	shr    $0x1b,%edx
  801e47:	01 d0                	add    %edx,%eax
  801e49:	83 e0 1f             	and    $0x1f,%eax
  801e4c:	29 d0                	sub    %edx,%eax
  801e4e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e56:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e59:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e5c:	83 c6 01             	add    $0x1,%esi
  801e5f:	eb aa                	jmp    801e0b <devpipe_read+0x1c>

00801e61 <pipe>:
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	56                   	push   %esi
  801e65:	53                   	push   %ebx
  801e66:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e6c:	50                   	push   %eax
  801e6d:	e8 b2 f1 ff ff       	call   801024 <fd_alloc>
  801e72:	89 c3                	mov    %eax,%ebx
  801e74:	83 c4 10             	add    $0x10,%esp
  801e77:	85 c0                	test   %eax,%eax
  801e79:	0f 88 23 01 00 00    	js     801fa2 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e7f:	83 ec 04             	sub    $0x4,%esp
  801e82:	68 07 04 00 00       	push   $0x407
  801e87:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8a:	6a 00                	push   $0x0
  801e8c:	e8 97 ee ff ff       	call   800d28 <sys_page_alloc>
  801e91:	89 c3                	mov    %eax,%ebx
  801e93:	83 c4 10             	add    $0x10,%esp
  801e96:	85 c0                	test   %eax,%eax
  801e98:	0f 88 04 01 00 00    	js     801fa2 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e9e:	83 ec 0c             	sub    $0xc,%esp
  801ea1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ea4:	50                   	push   %eax
  801ea5:	e8 7a f1 ff ff       	call   801024 <fd_alloc>
  801eaa:	89 c3                	mov    %eax,%ebx
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	0f 88 db 00 00 00    	js     801f92 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb7:	83 ec 04             	sub    $0x4,%esp
  801eba:	68 07 04 00 00       	push   $0x407
  801ebf:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec2:	6a 00                	push   $0x0
  801ec4:	e8 5f ee ff ff       	call   800d28 <sys_page_alloc>
  801ec9:	89 c3                	mov    %eax,%ebx
  801ecb:	83 c4 10             	add    $0x10,%esp
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	0f 88 bc 00 00 00    	js     801f92 <pipe+0x131>
	va = fd2data(fd0);
  801ed6:	83 ec 0c             	sub    $0xc,%esp
  801ed9:	ff 75 f4             	pushl  -0xc(%ebp)
  801edc:	e8 2c f1 ff ff       	call   80100d <fd2data>
  801ee1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee3:	83 c4 0c             	add    $0xc,%esp
  801ee6:	68 07 04 00 00       	push   $0x407
  801eeb:	50                   	push   %eax
  801eec:	6a 00                	push   $0x0
  801eee:	e8 35 ee ff ff       	call   800d28 <sys_page_alloc>
  801ef3:	89 c3                	mov    %eax,%ebx
  801ef5:	83 c4 10             	add    $0x10,%esp
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	0f 88 82 00 00 00    	js     801f82 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f00:	83 ec 0c             	sub    $0xc,%esp
  801f03:	ff 75 f0             	pushl  -0x10(%ebp)
  801f06:	e8 02 f1 ff ff       	call   80100d <fd2data>
  801f0b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f12:	50                   	push   %eax
  801f13:	6a 00                	push   $0x0
  801f15:	56                   	push   %esi
  801f16:	6a 00                	push   $0x0
  801f18:	e8 4e ee ff ff       	call   800d6b <sys_page_map>
  801f1d:	89 c3                	mov    %eax,%ebx
  801f1f:	83 c4 20             	add    $0x20,%esp
  801f22:	85 c0                	test   %eax,%eax
  801f24:	78 4e                	js     801f74 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f26:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f33:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f3d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f42:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f49:	83 ec 0c             	sub    $0xc,%esp
  801f4c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4f:	e8 a9 f0 ff ff       	call   800ffd <fd2num>
  801f54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f57:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f59:	83 c4 04             	add    $0x4,%esp
  801f5c:	ff 75 f0             	pushl  -0x10(%ebp)
  801f5f:	e8 99 f0 ff ff       	call   800ffd <fd2num>
  801f64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f67:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f6a:	83 c4 10             	add    $0x10,%esp
  801f6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f72:	eb 2e                	jmp    801fa2 <pipe+0x141>
	sys_page_unmap(0, va);
  801f74:	83 ec 08             	sub    $0x8,%esp
  801f77:	56                   	push   %esi
  801f78:	6a 00                	push   $0x0
  801f7a:	e8 2e ee ff ff       	call   800dad <sys_page_unmap>
  801f7f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f82:	83 ec 08             	sub    $0x8,%esp
  801f85:	ff 75 f0             	pushl  -0x10(%ebp)
  801f88:	6a 00                	push   $0x0
  801f8a:	e8 1e ee ff ff       	call   800dad <sys_page_unmap>
  801f8f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f92:	83 ec 08             	sub    $0x8,%esp
  801f95:	ff 75 f4             	pushl  -0xc(%ebp)
  801f98:	6a 00                	push   $0x0
  801f9a:	e8 0e ee ff ff       	call   800dad <sys_page_unmap>
  801f9f:	83 c4 10             	add    $0x10,%esp
}
  801fa2:	89 d8                	mov    %ebx,%eax
  801fa4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fa7:	5b                   	pop    %ebx
  801fa8:	5e                   	pop    %esi
  801fa9:	5d                   	pop    %ebp
  801faa:	c3                   	ret    

00801fab <pipeisclosed>:
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb4:	50                   	push   %eax
  801fb5:	ff 75 08             	pushl  0x8(%ebp)
  801fb8:	e8 b9 f0 ff ff       	call   801076 <fd_lookup>
  801fbd:	83 c4 10             	add    $0x10,%esp
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	78 18                	js     801fdc <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fc4:	83 ec 0c             	sub    $0xc,%esp
  801fc7:	ff 75 f4             	pushl  -0xc(%ebp)
  801fca:	e8 3e f0 ff ff       	call   80100d <fd2data>
	return _pipeisclosed(fd, p);
  801fcf:	89 c2                	mov    %eax,%edx
  801fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd4:	e8 2f fd ff ff       	call   801d08 <_pipeisclosed>
  801fd9:	83 c4 10             	add    $0x10,%esp
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fde:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe3:	c3                   	ret    

00801fe4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fea:	68 6f 2a 80 00       	push   $0x802a6f
  801fef:	ff 75 0c             	pushl  0xc(%ebp)
  801ff2:	e8 3f e9 ff ff       	call   800936 <strcpy>
	return 0;
}
  801ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <devcons_write>:
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	57                   	push   %edi
  802002:	56                   	push   %esi
  802003:	53                   	push   %ebx
  802004:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80200a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80200f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802015:	3b 75 10             	cmp    0x10(%ebp),%esi
  802018:	73 31                	jae    80204b <devcons_write+0x4d>
		m = n - tot;
  80201a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80201d:	29 f3                	sub    %esi,%ebx
  80201f:	83 fb 7f             	cmp    $0x7f,%ebx
  802022:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802027:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80202a:	83 ec 04             	sub    $0x4,%esp
  80202d:	53                   	push   %ebx
  80202e:	89 f0                	mov    %esi,%eax
  802030:	03 45 0c             	add    0xc(%ebp),%eax
  802033:	50                   	push   %eax
  802034:	57                   	push   %edi
  802035:	e8 8a ea ff ff       	call   800ac4 <memmove>
		sys_cputs(buf, m);
  80203a:	83 c4 08             	add    $0x8,%esp
  80203d:	53                   	push   %ebx
  80203e:	57                   	push   %edi
  80203f:	e8 28 ec ff ff       	call   800c6c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802044:	01 de                	add    %ebx,%esi
  802046:	83 c4 10             	add    $0x10,%esp
  802049:	eb ca                	jmp    802015 <devcons_write+0x17>
}
  80204b:	89 f0                	mov    %esi,%eax
  80204d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802050:	5b                   	pop    %ebx
  802051:	5e                   	pop    %esi
  802052:	5f                   	pop    %edi
  802053:	5d                   	pop    %ebp
  802054:	c3                   	ret    

00802055 <devcons_read>:
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	83 ec 08             	sub    $0x8,%esp
  80205b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802060:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802064:	74 21                	je     802087 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802066:	e8 1f ec ff ff       	call   800c8a <sys_cgetc>
  80206b:	85 c0                	test   %eax,%eax
  80206d:	75 07                	jne    802076 <devcons_read+0x21>
		sys_yield();
  80206f:	e8 95 ec ff ff       	call   800d09 <sys_yield>
  802074:	eb f0                	jmp    802066 <devcons_read+0x11>
	if (c < 0)
  802076:	78 0f                	js     802087 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802078:	83 f8 04             	cmp    $0x4,%eax
  80207b:	74 0c                	je     802089 <devcons_read+0x34>
	*(char*)vbuf = c;
  80207d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802080:	88 02                	mov    %al,(%edx)
	return 1;
  802082:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    
		return 0;
  802089:	b8 00 00 00 00       	mov    $0x0,%eax
  80208e:	eb f7                	jmp    802087 <devcons_read+0x32>

00802090 <cputchar>:
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80209c:	6a 01                	push   $0x1
  80209e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020a1:	50                   	push   %eax
  8020a2:	e8 c5 eb ff ff       	call   800c6c <sys_cputs>
}
  8020a7:	83 c4 10             	add    $0x10,%esp
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <getchar>:
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
  8020af:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020b2:	6a 01                	push   $0x1
  8020b4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020b7:	50                   	push   %eax
  8020b8:	6a 00                	push   $0x0
  8020ba:	e8 27 f2 ff ff       	call   8012e6 <read>
	if (r < 0)
  8020bf:	83 c4 10             	add    $0x10,%esp
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	78 06                	js     8020cc <getchar+0x20>
	if (r < 1)
  8020c6:	74 06                	je     8020ce <getchar+0x22>
	return c;
  8020c8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    
		return -E_EOF;
  8020ce:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020d3:	eb f7                	jmp    8020cc <getchar+0x20>

008020d5 <iscons>:
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020de:	50                   	push   %eax
  8020df:	ff 75 08             	pushl  0x8(%ebp)
  8020e2:	e8 8f ef ff ff       	call   801076 <fd_lookup>
  8020e7:	83 c4 10             	add    $0x10,%esp
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	78 11                	js     8020ff <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f1:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020f7:	39 10                	cmp    %edx,(%eax)
  8020f9:	0f 94 c0             	sete   %al
  8020fc:	0f b6 c0             	movzbl %al,%eax
}
  8020ff:	c9                   	leave  
  802100:	c3                   	ret    

00802101 <opencons>:
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
  802104:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802107:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80210a:	50                   	push   %eax
  80210b:	e8 14 ef ff ff       	call   801024 <fd_alloc>
  802110:	83 c4 10             	add    $0x10,%esp
  802113:	85 c0                	test   %eax,%eax
  802115:	78 3a                	js     802151 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802117:	83 ec 04             	sub    $0x4,%esp
  80211a:	68 07 04 00 00       	push   $0x407
  80211f:	ff 75 f4             	pushl  -0xc(%ebp)
  802122:	6a 00                	push   $0x0
  802124:	e8 ff eb ff ff       	call   800d28 <sys_page_alloc>
  802129:	83 c4 10             	add    $0x10,%esp
  80212c:	85 c0                	test   %eax,%eax
  80212e:	78 21                	js     802151 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802133:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802139:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80213b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802145:	83 ec 0c             	sub    $0xc,%esp
  802148:	50                   	push   %eax
  802149:	e8 af ee ff ff       	call   800ffd <fd2num>
  80214e:	83 c4 10             	add    $0x10,%esp
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	56                   	push   %esi
  802157:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802158:	a1 08 40 80 00       	mov    0x804008,%eax
  80215d:	8b 40 48             	mov    0x48(%eax),%eax
  802160:	83 ec 04             	sub    $0x4,%esp
  802163:	68 a0 2a 80 00       	push   $0x802aa0
  802168:	50                   	push   %eax
  802169:	68 98 25 80 00       	push   $0x802598
  80216e:	e8 64 e0 ff ff       	call   8001d7 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802173:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802176:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80217c:	e8 69 eb ff ff       	call   800cea <sys_getenvid>
  802181:	83 c4 04             	add    $0x4,%esp
  802184:	ff 75 0c             	pushl  0xc(%ebp)
  802187:	ff 75 08             	pushl  0x8(%ebp)
  80218a:	56                   	push   %esi
  80218b:	50                   	push   %eax
  80218c:	68 7c 2a 80 00       	push   $0x802a7c
  802191:	e8 41 e0 ff ff       	call   8001d7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802196:	83 c4 18             	add    $0x18,%esp
  802199:	53                   	push   %ebx
  80219a:	ff 75 10             	pushl  0x10(%ebp)
  80219d:	e8 e4 df ff ff       	call   800186 <vcprintf>
	cprintf("\n");
  8021a2:	c7 04 24 5c 25 80 00 	movl   $0x80255c,(%esp)
  8021a9:	e8 29 e0 ff ff       	call   8001d7 <cprintf>
  8021ae:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021b1:	cc                   	int3   
  8021b2:	eb fd                	jmp    8021b1 <_panic+0x5e>

008021b4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	56                   	push   %esi
  8021b8:	53                   	push   %ebx
  8021b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8021bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021c2:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021c4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021c9:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021cc:	83 ec 0c             	sub    $0xc,%esp
  8021cf:	50                   	push   %eax
  8021d0:	e8 03 ed ff ff       	call   800ed8 <sys_ipc_recv>
	if(ret < 0){
  8021d5:	83 c4 10             	add    $0x10,%esp
  8021d8:	85 c0                	test   %eax,%eax
  8021da:	78 2b                	js     802207 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021dc:	85 f6                	test   %esi,%esi
  8021de:	74 0a                	je     8021ea <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8021e0:	a1 08 40 80 00       	mov    0x804008,%eax
  8021e5:	8b 40 74             	mov    0x74(%eax),%eax
  8021e8:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021ea:	85 db                	test   %ebx,%ebx
  8021ec:	74 0a                	je     8021f8 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8021ee:	a1 08 40 80 00       	mov    0x804008,%eax
  8021f3:	8b 40 78             	mov    0x78(%eax),%eax
  8021f6:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8021f8:	a1 08 40 80 00       	mov    0x804008,%eax
  8021fd:	8b 40 70             	mov    0x70(%eax),%eax
}
  802200:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802203:	5b                   	pop    %ebx
  802204:	5e                   	pop    %esi
  802205:	5d                   	pop    %ebp
  802206:	c3                   	ret    
		if(from_env_store)
  802207:	85 f6                	test   %esi,%esi
  802209:	74 06                	je     802211 <ipc_recv+0x5d>
			*from_env_store = 0;
  80220b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802211:	85 db                	test   %ebx,%ebx
  802213:	74 eb                	je     802200 <ipc_recv+0x4c>
			*perm_store = 0;
  802215:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80221b:	eb e3                	jmp    802200 <ipc_recv+0x4c>

0080221d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
  802220:	57                   	push   %edi
  802221:	56                   	push   %esi
  802222:	53                   	push   %ebx
  802223:	83 ec 0c             	sub    $0xc,%esp
  802226:	8b 7d 08             	mov    0x8(%ebp),%edi
  802229:	8b 75 0c             	mov    0xc(%ebp),%esi
  80222c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80222f:	85 db                	test   %ebx,%ebx
  802231:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802236:	0f 44 d8             	cmove  %eax,%ebx
  802239:	eb 05                	jmp    802240 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80223b:	e8 c9 ea ff ff       	call   800d09 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802240:	ff 75 14             	pushl  0x14(%ebp)
  802243:	53                   	push   %ebx
  802244:	56                   	push   %esi
  802245:	57                   	push   %edi
  802246:	e8 6a ec ff ff       	call   800eb5 <sys_ipc_try_send>
  80224b:	83 c4 10             	add    $0x10,%esp
  80224e:	85 c0                	test   %eax,%eax
  802250:	74 1b                	je     80226d <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802252:	79 e7                	jns    80223b <ipc_send+0x1e>
  802254:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802257:	74 e2                	je     80223b <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802259:	83 ec 04             	sub    $0x4,%esp
  80225c:	68 a7 2a 80 00       	push   $0x802aa7
  802261:	6a 46                	push   $0x46
  802263:	68 bc 2a 80 00       	push   $0x802abc
  802268:	e8 e6 fe ff ff       	call   802153 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80226d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802270:	5b                   	pop    %ebx
  802271:	5e                   	pop    %esi
  802272:	5f                   	pop    %edi
  802273:	5d                   	pop    %ebp
  802274:	c3                   	ret    

00802275 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80227b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802280:	89 c2                	mov    %eax,%edx
  802282:	c1 e2 07             	shl    $0x7,%edx
  802285:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80228b:	8b 52 50             	mov    0x50(%edx),%edx
  80228e:	39 ca                	cmp    %ecx,%edx
  802290:	74 11                	je     8022a3 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802292:	83 c0 01             	add    $0x1,%eax
  802295:	3d 00 04 00 00       	cmp    $0x400,%eax
  80229a:	75 e4                	jne    802280 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80229c:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a1:	eb 0b                	jmp    8022ae <ipc_find_env+0x39>
			return envs[i].env_id;
  8022a3:	c1 e0 07             	shl    $0x7,%eax
  8022a6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022ab:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022ae:	5d                   	pop    %ebp
  8022af:	c3                   	ret    

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
