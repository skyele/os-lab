
obj/user/softint.debug:     file format elf32-i386


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
  80002c:	e8 05 00 00 00       	call   800036 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $14");	// page fault
  800033:	cd 0e                	int    $0xe
}
  800035:	c3                   	ret    

00800036 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800036:	55                   	push   %ebp
  800037:	89 e5                	mov    %esp,%ebp
  800039:	57                   	push   %edi
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80003f:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800046:	00 00 00 
	envid_t find = sys_getenvid();
  800049:	e8 9f 0c 00 00       	call   800ced <sys_getenvid>
  80004e:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800054:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800059:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80005e:	bf 01 00 00 00       	mov    $0x1,%edi
  800063:	eb 0b                	jmp    800070 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800065:	83 c2 01             	add    $0x1,%edx
  800068:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80006e:	74 23                	je     800093 <libmain+0x5d>
		if(envs[i].env_id == find)
  800070:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800076:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80007c:	8b 49 48             	mov    0x48(%ecx),%ecx
  80007f:	39 c1                	cmp    %eax,%ecx
  800081:	75 e2                	jne    800065 <libmain+0x2f>
  800083:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800089:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80008f:	89 fe                	mov    %edi,%esi
  800091:	eb d2                	jmp    800065 <libmain+0x2f>
  800093:	89 f0                	mov    %esi,%eax
  800095:	84 c0                	test   %al,%al
  800097:	74 06                	je     80009f <libmain+0x69>
  800099:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a3:	7e 0a                	jle    8000af <libmain+0x79>
		binaryname = argv[0];
  8000a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000af:	a1 08 40 80 00       	mov    0x804008,%eax
  8000b4:	8b 40 48             	mov    0x48(%eax),%eax
  8000b7:	83 ec 08             	sub    $0x8,%esp
  8000ba:	50                   	push   %eax
  8000bb:	68 80 25 80 00       	push   $0x802580
  8000c0:	e8 15 01 00 00       	call   8001da <cprintf>
	cprintf("before umain\n");
  8000c5:	c7 04 24 9e 25 80 00 	movl   $0x80259e,(%esp)
  8000cc:	e8 09 01 00 00       	call   8001da <cprintf>
	// call user main routine
	umain(argc, argv);
  8000d1:	83 c4 08             	add    $0x8,%esp
  8000d4:	ff 75 0c             	pushl  0xc(%ebp)
  8000d7:	ff 75 08             	pushl  0x8(%ebp)
  8000da:	e8 54 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000df:	c7 04 24 ac 25 80 00 	movl   $0x8025ac,(%esp)
  8000e6:	e8 ef 00 00 00       	call   8001da <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8000eb:	a1 08 40 80 00       	mov    0x804008,%eax
  8000f0:	8b 40 48             	mov    0x48(%eax),%eax
  8000f3:	83 c4 08             	add    $0x8,%esp
  8000f6:	50                   	push   %eax
  8000f7:	68 b9 25 80 00       	push   $0x8025b9
  8000fc:	e8 d9 00 00 00       	call   8001da <cprintf>
	// exit gracefully
	exit();
  800101:	e8 0b 00 00 00       	call   800111 <exit>
}
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5f                   	pop    %edi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    

00800111 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800117:	a1 08 40 80 00       	mov    0x804008,%eax
  80011c:	8b 40 48             	mov    0x48(%eax),%eax
  80011f:	68 e4 25 80 00       	push   $0x8025e4
  800124:	50                   	push   %eax
  800125:	68 d8 25 80 00       	push   $0x8025d8
  80012a:	e8 ab 00 00 00       	call   8001da <cprintf>
	close_all();
  80012f:	e8 c4 10 00 00       	call   8011f8 <close_all>
	sys_env_destroy(0);
  800134:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80013b:	e8 6c 0b 00 00       	call   800cac <sys_env_destroy>
}
  800140:	83 c4 10             	add    $0x10,%esp
  800143:	c9                   	leave  
  800144:	c3                   	ret    

00800145 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800145:	55                   	push   %ebp
  800146:	89 e5                	mov    %esp,%ebp
  800148:	53                   	push   %ebx
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80014f:	8b 13                	mov    (%ebx),%edx
  800151:	8d 42 01             	lea    0x1(%edx),%eax
  800154:	89 03                	mov    %eax,(%ebx)
  800156:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800159:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80015d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800162:	74 09                	je     80016d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800164:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800168:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80016b:	c9                   	leave  
  80016c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80016d:	83 ec 08             	sub    $0x8,%esp
  800170:	68 ff 00 00 00       	push   $0xff
  800175:	8d 43 08             	lea    0x8(%ebx),%eax
  800178:	50                   	push   %eax
  800179:	e8 f1 0a 00 00       	call   800c6f <sys_cputs>
		b->idx = 0;
  80017e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800184:	83 c4 10             	add    $0x10,%esp
  800187:	eb db                	jmp    800164 <putch+0x1f>

00800189 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800189:	55                   	push   %ebp
  80018a:	89 e5                	mov    %esp,%ebp
  80018c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800192:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800199:	00 00 00 
	b.cnt = 0;
  80019c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a6:	ff 75 0c             	pushl  0xc(%ebp)
  8001a9:	ff 75 08             	pushl  0x8(%ebp)
  8001ac:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b2:	50                   	push   %eax
  8001b3:	68 45 01 80 00       	push   $0x800145
  8001b8:	e8 4a 01 00 00       	call   800307 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001bd:	83 c4 08             	add    $0x8,%esp
  8001c0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001c6:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001cc:	50                   	push   %eax
  8001cd:	e8 9d 0a 00 00       	call   800c6f <sys_cputs>

	return b.cnt;
}
  8001d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001d8:	c9                   	leave  
  8001d9:	c3                   	ret    

008001da <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001e0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001e3:	50                   	push   %eax
  8001e4:	ff 75 08             	pushl  0x8(%ebp)
  8001e7:	e8 9d ff ff ff       	call   800189 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ec:	c9                   	leave  
  8001ed:	c3                   	ret    

008001ee <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	57                   	push   %edi
  8001f2:	56                   	push   %esi
  8001f3:	53                   	push   %ebx
  8001f4:	83 ec 1c             	sub    $0x1c,%esp
  8001f7:	89 c6                	mov    %eax,%esi
  8001f9:	89 d7                	mov    %edx,%edi
  8001fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800201:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800204:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800207:	8b 45 10             	mov    0x10(%ebp),%eax
  80020a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80020d:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800211:	74 2c                	je     80023f <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800213:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800216:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80021d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800220:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800223:	39 c2                	cmp    %eax,%edx
  800225:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800228:	73 43                	jae    80026d <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80022a:	83 eb 01             	sub    $0x1,%ebx
  80022d:	85 db                	test   %ebx,%ebx
  80022f:	7e 6c                	jle    80029d <printnum+0xaf>
				putch(padc, putdat);
  800231:	83 ec 08             	sub    $0x8,%esp
  800234:	57                   	push   %edi
  800235:	ff 75 18             	pushl  0x18(%ebp)
  800238:	ff d6                	call   *%esi
  80023a:	83 c4 10             	add    $0x10,%esp
  80023d:	eb eb                	jmp    80022a <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	6a 20                	push   $0x20
  800244:	6a 00                	push   $0x0
  800246:	50                   	push   %eax
  800247:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024a:	ff 75 e0             	pushl  -0x20(%ebp)
  80024d:	89 fa                	mov    %edi,%edx
  80024f:	89 f0                	mov    %esi,%eax
  800251:	e8 98 ff ff ff       	call   8001ee <printnum>
		while (--width > 0)
  800256:	83 c4 20             	add    $0x20,%esp
  800259:	83 eb 01             	sub    $0x1,%ebx
  80025c:	85 db                	test   %ebx,%ebx
  80025e:	7e 65                	jle    8002c5 <printnum+0xd7>
			putch(padc, putdat);
  800260:	83 ec 08             	sub    $0x8,%esp
  800263:	57                   	push   %edi
  800264:	6a 20                	push   $0x20
  800266:	ff d6                	call   *%esi
  800268:	83 c4 10             	add    $0x10,%esp
  80026b:	eb ec                	jmp    800259 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80026d:	83 ec 0c             	sub    $0xc,%esp
  800270:	ff 75 18             	pushl  0x18(%ebp)
  800273:	83 eb 01             	sub    $0x1,%ebx
  800276:	53                   	push   %ebx
  800277:	50                   	push   %eax
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	ff 75 dc             	pushl  -0x24(%ebp)
  80027e:	ff 75 d8             	pushl  -0x28(%ebp)
  800281:	ff 75 e4             	pushl  -0x1c(%ebp)
  800284:	ff 75 e0             	pushl  -0x20(%ebp)
  800287:	e8 94 20 00 00       	call   802320 <__udivdi3>
  80028c:	83 c4 18             	add    $0x18,%esp
  80028f:	52                   	push   %edx
  800290:	50                   	push   %eax
  800291:	89 fa                	mov    %edi,%edx
  800293:	89 f0                	mov    %esi,%eax
  800295:	e8 54 ff ff ff       	call   8001ee <printnum>
  80029a:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	57                   	push   %edi
  8002a1:	83 ec 04             	sub    $0x4,%esp
  8002a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b0:	e8 7b 21 00 00       	call   802430 <__umoddi3>
  8002b5:	83 c4 14             	add    $0x14,%esp
  8002b8:	0f be 80 e9 25 80 00 	movsbl 0x8025e9(%eax),%eax
  8002bf:	50                   	push   %eax
  8002c0:	ff d6                	call   *%esi
  8002c2:	83 c4 10             	add    $0x10,%esp
	}
}
  8002c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c8:	5b                   	pop    %ebx
  8002c9:	5e                   	pop    %esi
  8002ca:	5f                   	pop    %edi
  8002cb:	5d                   	pop    %ebp
  8002cc:	c3                   	ret    

008002cd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d7:	8b 10                	mov    (%eax),%edx
  8002d9:	3b 50 04             	cmp    0x4(%eax),%edx
  8002dc:	73 0a                	jae    8002e8 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002de:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e1:	89 08                	mov    %ecx,(%eax)
  8002e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e6:	88 02                	mov    %al,(%edx)
}
  8002e8:	5d                   	pop    %ebp
  8002e9:	c3                   	ret    

008002ea <printfmt>:
{
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002f0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002f3:	50                   	push   %eax
  8002f4:	ff 75 10             	pushl  0x10(%ebp)
  8002f7:	ff 75 0c             	pushl  0xc(%ebp)
  8002fa:	ff 75 08             	pushl  0x8(%ebp)
  8002fd:	e8 05 00 00 00       	call   800307 <vprintfmt>
}
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <vprintfmt>:
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	57                   	push   %edi
  80030b:	56                   	push   %esi
  80030c:	53                   	push   %ebx
  80030d:	83 ec 3c             	sub    $0x3c,%esp
  800310:	8b 75 08             	mov    0x8(%ebp),%esi
  800313:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800316:	8b 7d 10             	mov    0x10(%ebp),%edi
  800319:	e9 32 04 00 00       	jmp    800750 <vprintfmt+0x449>
		padc = ' ';
  80031e:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800322:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800329:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800330:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800337:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80033e:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800345:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80034a:	8d 47 01             	lea    0x1(%edi),%eax
  80034d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800350:	0f b6 17             	movzbl (%edi),%edx
  800353:	8d 42 dd             	lea    -0x23(%edx),%eax
  800356:	3c 55                	cmp    $0x55,%al
  800358:	0f 87 12 05 00 00    	ja     800870 <vprintfmt+0x569>
  80035e:	0f b6 c0             	movzbl %al,%eax
  800361:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
  800368:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80036b:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80036f:	eb d9                	jmp    80034a <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800371:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800374:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800378:	eb d0                	jmp    80034a <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80037a:	0f b6 d2             	movzbl %dl,%edx
  80037d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800380:	b8 00 00 00 00       	mov    $0x0,%eax
  800385:	89 75 08             	mov    %esi,0x8(%ebp)
  800388:	eb 03                	jmp    80038d <vprintfmt+0x86>
  80038a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80038d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800390:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800394:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800397:	8d 72 d0             	lea    -0x30(%edx),%esi
  80039a:	83 fe 09             	cmp    $0x9,%esi
  80039d:	76 eb                	jbe    80038a <vprintfmt+0x83>
  80039f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8003a5:	eb 14                	jmp    8003bb <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003aa:	8b 00                	mov    (%eax),%eax
  8003ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003af:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b2:	8d 40 04             	lea    0x4(%eax),%eax
  8003b5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003bf:	79 89                	jns    80034a <vprintfmt+0x43>
				width = precision, precision = -1;
  8003c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003ce:	e9 77 ff ff ff       	jmp    80034a <vprintfmt+0x43>
  8003d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d6:	85 c0                	test   %eax,%eax
  8003d8:	0f 48 c1             	cmovs  %ecx,%eax
  8003db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e1:	e9 64 ff ff ff       	jmp    80034a <vprintfmt+0x43>
  8003e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003f0:	e9 55 ff ff ff       	jmp    80034a <vprintfmt+0x43>
			lflag++;
  8003f5:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003fc:	e9 49 ff ff ff       	jmp    80034a <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800401:	8b 45 14             	mov    0x14(%ebp),%eax
  800404:	8d 78 04             	lea    0x4(%eax),%edi
  800407:	83 ec 08             	sub    $0x8,%esp
  80040a:	53                   	push   %ebx
  80040b:	ff 30                	pushl  (%eax)
  80040d:	ff d6                	call   *%esi
			break;
  80040f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800412:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800415:	e9 33 03 00 00       	jmp    80074d <vprintfmt+0x446>
			err = va_arg(ap, int);
  80041a:	8b 45 14             	mov    0x14(%ebp),%eax
  80041d:	8d 78 04             	lea    0x4(%eax),%edi
  800420:	8b 00                	mov    (%eax),%eax
  800422:	99                   	cltd   
  800423:	31 d0                	xor    %edx,%eax
  800425:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800427:	83 f8 11             	cmp    $0x11,%eax
  80042a:	7f 23                	jg     80044f <vprintfmt+0x148>
  80042c:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  800433:	85 d2                	test   %edx,%edx
  800435:	74 18                	je     80044f <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800437:	52                   	push   %edx
  800438:	68 3d 2a 80 00       	push   $0x802a3d
  80043d:	53                   	push   %ebx
  80043e:	56                   	push   %esi
  80043f:	e8 a6 fe ff ff       	call   8002ea <printfmt>
  800444:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800447:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044a:	e9 fe 02 00 00       	jmp    80074d <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80044f:	50                   	push   %eax
  800450:	68 01 26 80 00       	push   $0x802601
  800455:	53                   	push   %ebx
  800456:	56                   	push   %esi
  800457:	e8 8e fe ff ff       	call   8002ea <printfmt>
  80045c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800462:	e9 e6 02 00 00       	jmp    80074d <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800467:	8b 45 14             	mov    0x14(%ebp),%eax
  80046a:	83 c0 04             	add    $0x4,%eax
  80046d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800470:	8b 45 14             	mov    0x14(%ebp),%eax
  800473:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800475:	85 c9                	test   %ecx,%ecx
  800477:	b8 fa 25 80 00       	mov    $0x8025fa,%eax
  80047c:	0f 45 c1             	cmovne %ecx,%eax
  80047f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800482:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800486:	7e 06                	jle    80048e <vprintfmt+0x187>
  800488:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80048c:	75 0d                	jne    80049b <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800491:	89 c7                	mov    %eax,%edi
  800493:	03 45 e0             	add    -0x20(%ebp),%eax
  800496:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800499:	eb 53                	jmp    8004ee <vprintfmt+0x1e7>
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a1:	50                   	push   %eax
  8004a2:	e8 71 04 00 00       	call   800918 <strnlen>
  8004a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004aa:	29 c1                	sub    %eax,%ecx
  8004ac:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004af:	83 c4 10             	add    $0x10,%esp
  8004b2:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004b4:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bb:	eb 0f                	jmp    8004cc <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004bd:	83 ec 08             	sub    $0x8,%esp
  8004c0:	53                   	push   %ebx
  8004c1:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c6:	83 ef 01             	sub    $0x1,%edi
  8004c9:	83 c4 10             	add    $0x10,%esp
  8004cc:	85 ff                	test   %edi,%edi
  8004ce:	7f ed                	jg     8004bd <vprintfmt+0x1b6>
  8004d0:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004d3:	85 c9                	test   %ecx,%ecx
  8004d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004da:	0f 49 c1             	cmovns %ecx,%eax
  8004dd:	29 c1                	sub    %eax,%ecx
  8004df:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004e2:	eb aa                	jmp    80048e <vprintfmt+0x187>
					putch(ch, putdat);
  8004e4:	83 ec 08             	sub    $0x8,%esp
  8004e7:	53                   	push   %ebx
  8004e8:	52                   	push   %edx
  8004e9:	ff d6                	call   *%esi
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f1:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f3:	83 c7 01             	add    $0x1,%edi
  8004f6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004fa:	0f be d0             	movsbl %al,%edx
  8004fd:	85 d2                	test   %edx,%edx
  8004ff:	74 4b                	je     80054c <vprintfmt+0x245>
  800501:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800505:	78 06                	js     80050d <vprintfmt+0x206>
  800507:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80050b:	78 1e                	js     80052b <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80050d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800511:	74 d1                	je     8004e4 <vprintfmt+0x1dd>
  800513:	0f be c0             	movsbl %al,%eax
  800516:	83 e8 20             	sub    $0x20,%eax
  800519:	83 f8 5e             	cmp    $0x5e,%eax
  80051c:	76 c6                	jbe    8004e4 <vprintfmt+0x1dd>
					putch('?', putdat);
  80051e:	83 ec 08             	sub    $0x8,%esp
  800521:	53                   	push   %ebx
  800522:	6a 3f                	push   $0x3f
  800524:	ff d6                	call   *%esi
  800526:	83 c4 10             	add    $0x10,%esp
  800529:	eb c3                	jmp    8004ee <vprintfmt+0x1e7>
  80052b:	89 cf                	mov    %ecx,%edi
  80052d:	eb 0e                	jmp    80053d <vprintfmt+0x236>
				putch(' ', putdat);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	53                   	push   %ebx
  800533:	6a 20                	push   $0x20
  800535:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800537:	83 ef 01             	sub    $0x1,%edi
  80053a:	83 c4 10             	add    $0x10,%esp
  80053d:	85 ff                	test   %edi,%edi
  80053f:	7f ee                	jg     80052f <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800541:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800544:	89 45 14             	mov    %eax,0x14(%ebp)
  800547:	e9 01 02 00 00       	jmp    80074d <vprintfmt+0x446>
  80054c:	89 cf                	mov    %ecx,%edi
  80054e:	eb ed                	jmp    80053d <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800550:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800553:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80055a:	e9 eb fd ff ff       	jmp    80034a <vprintfmt+0x43>
	if (lflag >= 2)
  80055f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800563:	7f 21                	jg     800586 <vprintfmt+0x27f>
	else if (lflag)
  800565:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800569:	74 68                	je     8005d3 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80056b:	8b 45 14             	mov    0x14(%ebp),%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800573:	89 c1                	mov    %eax,%ecx
  800575:	c1 f9 1f             	sar    $0x1f,%ecx
  800578:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	8d 40 04             	lea    0x4(%eax),%eax
  800581:	89 45 14             	mov    %eax,0x14(%ebp)
  800584:	eb 17                	jmp    80059d <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	8b 50 04             	mov    0x4(%eax),%edx
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800591:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8d 40 08             	lea    0x8(%eax),%eax
  80059a:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80059d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005a9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005ad:	78 3f                	js     8005ee <vprintfmt+0x2e7>
			base = 10;
  8005af:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005b4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005b8:	0f 84 71 01 00 00    	je     80072f <vprintfmt+0x428>
				putch('+', putdat);
  8005be:	83 ec 08             	sub    $0x8,%esp
  8005c1:	53                   	push   %ebx
  8005c2:	6a 2b                	push   $0x2b
  8005c4:	ff d6                	call   *%esi
  8005c6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ce:	e9 5c 01 00 00       	jmp    80072f <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005db:	89 c1                	mov    %eax,%ecx
  8005dd:	c1 f9 1f             	sar    $0x1f,%ecx
  8005e0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	8d 40 04             	lea    0x4(%eax),%eax
  8005e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ec:	eb af                	jmp    80059d <vprintfmt+0x296>
				putch('-', putdat);
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	53                   	push   %ebx
  8005f2:	6a 2d                	push   $0x2d
  8005f4:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005fc:	f7 d8                	neg    %eax
  8005fe:	83 d2 00             	adc    $0x0,%edx
  800601:	f7 da                	neg    %edx
  800603:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800606:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800609:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80060c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800611:	e9 19 01 00 00       	jmp    80072f <vprintfmt+0x428>
	if (lflag >= 2)
  800616:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80061a:	7f 29                	jg     800645 <vprintfmt+0x33e>
	else if (lflag)
  80061c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800620:	74 44                	je     800666 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8b 00                	mov    (%eax),%eax
  800627:	ba 00 00 00 00       	mov    $0x0,%edx
  80062c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8d 40 04             	lea    0x4(%eax),%eax
  800638:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800640:	e9 ea 00 00 00       	jmp    80072f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8b 50 04             	mov    0x4(%eax),%edx
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800650:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	8d 40 08             	lea    0x8(%eax),%eax
  800659:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800661:	e9 c9 00 00 00       	jmp    80072f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8b 00                	mov    (%eax),%eax
  80066b:	ba 00 00 00 00       	mov    $0x0,%edx
  800670:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800673:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	8d 40 04             	lea    0x4(%eax),%eax
  80067c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800684:	e9 a6 00 00 00       	jmp    80072f <vprintfmt+0x428>
			putch('0', putdat);
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	53                   	push   %ebx
  80068d:	6a 30                	push   $0x30
  80068f:	ff d6                	call   *%esi
	if (lflag >= 2)
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800698:	7f 26                	jg     8006c0 <vprintfmt+0x3b9>
	else if (lflag)
  80069a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80069e:	74 3e                	je     8006de <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ad:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	8d 40 04             	lea    0x4(%eax),%eax
  8006b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b9:	b8 08 00 00 00       	mov    $0x8,%eax
  8006be:	eb 6f                	jmp    80072f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	8b 50 04             	mov    0x4(%eax),%edx
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8d 40 08             	lea    0x8(%eax),%eax
  8006d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d7:	b8 08 00 00 00       	mov    $0x8,%eax
  8006dc:	eb 51                	jmp    80072f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
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
  8006fc:	eb 31                	jmp    80072f <vprintfmt+0x428>
			putch('0', putdat);
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	53                   	push   %ebx
  800702:	6a 30                	push   $0x30
  800704:	ff d6                	call   *%esi
			putch('x', putdat);
  800706:	83 c4 08             	add    $0x8,%esp
  800709:	53                   	push   %ebx
  80070a:	6a 78                	push   $0x78
  80070c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8b 00                	mov    (%eax),%eax
  800713:	ba 00 00 00 00       	mov    $0x0,%edx
  800718:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80071e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8d 40 04             	lea    0x4(%eax),%eax
  800727:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800736:	52                   	push   %edx
  800737:	ff 75 e0             	pushl  -0x20(%ebp)
  80073a:	50                   	push   %eax
  80073b:	ff 75 dc             	pushl  -0x24(%ebp)
  80073e:	ff 75 d8             	pushl  -0x28(%ebp)
  800741:	89 da                	mov    %ebx,%edx
  800743:	89 f0                	mov    %esi,%eax
  800745:	e8 a4 fa ff ff       	call   8001ee <printnum>
			break;
  80074a:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80074d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800750:	83 c7 01             	add    $0x1,%edi
  800753:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800757:	83 f8 25             	cmp    $0x25,%eax
  80075a:	0f 84 be fb ff ff    	je     80031e <vprintfmt+0x17>
			if (ch == '\0')
  800760:	85 c0                	test   %eax,%eax
  800762:	0f 84 28 01 00 00    	je     800890 <vprintfmt+0x589>
			putch(ch, putdat);
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	53                   	push   %ebx
  80076c:	50                   	push   %eax
  80076d:	ff d6                	call   *%esi
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	eb dc                	jmp    800750 <vprintfmt+0x449>
	if (lflag >= 2)
  800774:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800778:	7f 26                	jg     8007a0 <vprintfmt+0x499>
	else if (lflag)
  80077a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80077e:	74 41                	je     8007c1 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	ba 00 00 00 00       	mov    $0x0,%edx
  80078a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	8d 40 04             	lea    0x4(%eax),%eax
  800796:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800799:	b8 10 00 00 00       	mov    $0x10,%eax
  80079e:	eb 8f                	jmp    80072f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	8b 50 04             	mov    0x4(%eax),%edx
  8007a6:	8b 00                	mov    (%eax),%eax
  8007a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	8d 40 08             	lea    0x8(%eax),%eax
  8007b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b7:	b8 10 00 00 00       	mov    $0x10,%eax
  8007bc:	e9 6e ff ff ff       	jmp    80072f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	8b 00                	mov    (%eax),%eax
  8007c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	8d 40 04             	lea    0x4(%eax),%eax
  8007d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007da:	b8 10 00 00 00       	mov    $0x10,%eax
  8007df:	e9 4b ff ff ff       	jmp    80072f <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	83 c0 04             	add    $0x4,%eax
  8007ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	85 c0                	test   %eax,%eax
  8007f4:	74 14                	je     80080a <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007f6:	8b 13                	mov    (%ebx),%edx
  8007f8:	83 fa 7f             	cmp    $0x7f,%edx
  8007fb:	7f 37                	jg     800834 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007fd:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800802:	89 45 14             	mov    %eax,0x14(%ebp)
  800805:	e9 43 ff ff ff       	jmp    80074d <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80080a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080f:	bf 1d 27 80 00       	mov    $0x80271d,%edi
							putch(ch, putdat);
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	53                   	push   %ebx
  800818:	50                   	push   %eax
  800819:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80081b:	83 c7 01             	add    $0x1,%edi
  80081e:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800822:	83 c4 10             	add    $0x10,%esp
  800825:	85 c0                	test   %eax,%eax
  800827:	75 eb                	jne    800814 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800829:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80082c:	89 45 14             	mov    %eax,0x14(%ebp)
  80082f:	e9 19 ff ff ff       	jmp    80074d <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800834:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800836:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083b:	bf 55 27 80 00       	mov    $0x802755,%edi
							putch(ch, putdat);
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	53                   	push   %ebx
  800844:	50                   	push   %eax
  800845:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800847:	83 c7 01             	add    $0x1,%edi
  80084a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80084e:	83 c4 10             	add    $0x10,%esp
  800851:	85 c0                	test   %eax,%eax
  800853:	75 eb                	jne    800840 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800855:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
  80085b:	e9 ed fe ff ff       	jmp    80074d <vprintfmt+0x446>
			putch(ch, putdat);
  800860:	83 ec 08             	sub    $0x8,%esp
  800863:	53                   	push   %ebx
  800864:	6a 25                	push   $0x25
  800866:	ff d6                	call   *%esi
			break;
  800868:	83 c4 10             	add    $0x10,%esp
  80086b:	e9 dd fe ff ff       	jmp    80074d <vprintfmt+0x446>
			putch('%', putdat);
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	53                   	push   %ebx
  800874:	6a 25                	push   $0x25
  800876:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800878:	83 c4 10             	add    $0x10,%esp
  80087b:	89 f8                	mov    %edi,%eax
  80087d:	eb 03                	jmp    800882 <vprintfmt+0x57b>
  80087f:	83 e8 01             	sub    $0x1,%eax
  800882:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800886:	75 f7                	jne    80087f <vprintfmt+0x578>
  800888:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80088b:	e9 bd fe ff ff       	jmp    80074d <vprintfmt+0x446>
}
  800890:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800893:	5b                   	pop    %ebx
  800894:	5e                   	pop    %esi
  800895:	5f                   	pop    %edi
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	83 ec 18             	sub    $0x18,%esp
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008a7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008ab:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008b5:	85 c0                	test   %eax,%eax
  8008b7:	74 26                	je     8008df <vsnprintf+0x47>
  8008b9:	85 d2                	test   %edx,%edx
  8008bb:	7e 22                	jle    8008df <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008bd:	ff 75 14             	pushl  0x14(%ebp)
  8008c0:	ff 75 10             	pushl  0x10(%ebp)
  8008c3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c6:	50                   	push   %eax
  8008c7:	68 cd 02 80 00       	push   $0x8002cd
  8008cc:	e8 36 fa ff ff       	call   800307 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008da:	83 c4 10             	add    $0x10,%esp
}
  8008dd:	c9                   	leave  
  8008de:	c3                   	ret    
		return -E_INVAL;
  8008df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008e4:	eb f7                	jmp    8008dd <vsnprintf+0x45>

008008e6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ec:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008ef:	50                   	push   %eax
  8008f0:	ff 75 10             	pushl  0x10(%ebp)
  8008f3:	ff 75 0c             	pushl  0xc(%ebp)
  8008f6:	ff 75 08             	pushl  0x8(%ebp)
  8008f9:	e8 9a ff ff ff       	call   800898 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008fe:	c9                   	leave  
  8008ff:	c3                   	ret    

00800900 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800906:	b8 00 00 00 00       	mov    $0x0,%eax
  80090b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80090f:	74 05                	je     800916 <strlen+0x16>
		n++;
  800911:	83 c0 01             	add    $0x1,%eax
  800914:	eb f5                	jmp    80090b <strlen+0xb>
	return n;
}
  800916:	5d                   	pop    %ebp
  800917:	c3                   	ret    

00800918 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091e:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800921:	ba 00 00 00 00       	mov    $0x0,%edx
  800926:	39 c2                	cmp    %eax,%edx
  800928:	74 0d                	je     800937 <strnlen+0x1f>
  80092a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80092e:	74 05                	je     800935 <strnlen+0x1d>
		n++;
  800930:	83 c2 01             	add    $0x1,%edx
  800933:	eb f1                	jmp    800926 <strnlen+0xe>
  800935:	89 d0                	mov    %edx,%eax
	return n;
}
  800937:	5d                   	pop    %ebp
  800938:	c3                   	ret    

00800939 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	53                   	push   %ebx
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800943:	ba 00 00 00 00       	mov    $0x0,%edx
  800948:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80094c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80094f:	83 c2 01             	add    $0x1,%edx
  800952:	84 c9                	test   %cl,%cl
  800954:	75 f2                	jne    800948 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800956:	5b                   	pop    %ebx
  800957:	5d                   	pop    %ebp
  800958:	c3                   	ret    

00800959 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	53                   	push   %ebx
  80095d:	83 ec 10             	sub    $0x10,%esp
  800960:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800963:	53                   	push   %ebx
  800964:	e8 97 ff ff ff       	call   800900 <strlen>
  800969:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	01 d8                	add    %ebx,%eax
  800971:	50                   	push   %eax
  800972:	e8 c2 ff ff ff       	call   800939 <strcpy>
	return dst;
}
  800977:	89 d8                	mov    %ebx,%eax
  800979:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097c:	c9                   	leave  
  80097d:	c3                   	ret    

0080097e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	56                   	push   %esi
  800982:	53                   	push   %ebx
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800989:	89 c6                	mov    %eax,%esi
  80098b:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80098e:	89 c2                	mov    %eax,%edx
  800990:	39 f2                	cmp    %esi,%edx
  800992:	74 11                	je     8009a5 <strncpy+0x27>
		*dst++ = *src;
  800994:	83 c2 01             	add    $0x1,%edx
  800997:	0f b6 19             	movzbl (%ecx),%ebx
  80099a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80099d:	80 fb 01             	cmp    $0x1,%bl
  8009a0:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009a3:	eb eb                	jmp    800990 <strncpy+0x12>
	}
	return ret;
}
  8009a5:	5b                   	pop    %ebx
  8009a6:	5e                   	pop    %esi
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    

008009a9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	56                   	push   %esi
  8009ad:	53                   	push   %ebx
  8009ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b4:	8b 55 10             	mov    0x10(%ebp),%edx
  8009b7:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009b9:	85 d2                	test   %edx,%edx
  8009bb:	74 21                	je     8009de <strlcpy+0x35>
  8009bd:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009c1:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009c3:	39 c2                	cmp    %eax,%edx
  8009c5:	74 14                	je     8009db <strlcpy+0x32>
  8009c7:	0f b6 19             	movzbl (%ecx),%ebx
  8009ca:	84 db                	test   %bl,%bl
  8009cc:	74 0b                	je     8009d9 <strlcpy+0x30>
			*dst++ = *src++;
  8009ce:	83 c1 01             	add    $0x1,%ecx
  8009d1:	83 c2 01             	add    $0x1,%edx
  8009d4:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009d7:	eb ea                	jmp    8009c3 <strlcpy+0x1a>
  8009d9:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009db:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009de:	29 f0                	sub    %esi,%eax
}
  8009e0:	5b                   	pop    %ebx
  8009e1:	5e                   	pop    %esi
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    

008009e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ea:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ed:	0f b6 01             	movzbl (%ecx),%eax
  8009f0:	84 c0                	test   %al,%al
  8009f2:	74 0c                	je     800a00 <strcmp+0x1c>
  8009f4:	3a 02                	cmp    (%edx),%al
  8009f6:	75 08                	jne    800a00 <strcmp+0x1c>
		p++, q++;
  8009f8:	83 c1 01             	add    $0x1,%ecx
  8009fb:	83 c2 01             	add    $0x1,%edx
  8009fe:	eb ed                	jmp    8009ed <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a00:	0f b6 c0             	movzbl %al,%eax
  800a03:	0f b6 12             	movzbl (%edx),%edx
  800a06:	29 d0                	sub    %edx,%eax
}
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	53                   	push   %ebx
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a14:	89 c3                	mov    %eax,%ebx
  800a16:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a19:	eb 06                	jmp    800a21 <strncmp+0x17>
		n--, p++, q++;
  800a1b:	83 c0 01             	add    $0x1,%eax
  800a1e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a21:	39 d8                	cmp    %ebx,%eax
  800a23:	74 16                	je     800a3b <strncmp+0x31>
  800a25:	0f b6 08             	movzbl (%eax),%ecx
  800a28:	84 c9                	test   %cl,%cl
  800a2a:	74 04                	je     800a30 <strncmp+0x26>
  800a2c:	3a 0a                	cmp    (%edx),%cl
  800a2e:	74 eb                	je     800a1b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a30:	0f b6 00             	movzbl (%eax),%eax
  800a33:	0f b6 12             	movzbl (%edx),%edx
  800a36:	29 d0                	sub    %edx,%eax
}
  800a38:	5b                   	pop    %ebx
  800a39:	5d                   	pop    %ebp
  800a3a:	c3                   	ret    
		return 0;
  800a3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a40:	eb f6                	jmp    800a38 <strncmp+0x2e>

00800a42 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	8b 45 08             	mov    0x8(%ebp),%eax
  800a48:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a4c:	0f b6 10             	movzbl (%eax),%edx
  800a4f:	84 d2                	test   %dl,%dl
  800a51:	74 09                	je     800a5c <strchr+0x1a>
		if (*s == c)
  800a53:	38 ca                	cmp    %cl,%dl
  800a55:	74 0a                	je     800a61 <strchr+0x1f>
	for (; *s; s++)
  800a57:	83 c0 01             	add    $0x1,%eax
  800a5a:	eb f0                	jmp    800a4c <strchr+0xa>
			return (char *) s;
	return 0;
  800a5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a61:	5d                   	pop    %ebp
  800a62:	c3                   	ret    

00800a63 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a6d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a70:	38 ca                	cmp    %cl,%dl
  800a72:	74 09                	je     800a7d <strfind+0x1a>
  800a74:	84 d2                	test   %dl,%dl
  800a76:	74 05                	je     800a7d <strfind+0x1a>
	for (; *s; s++)
  800a78:	83 c0 01             	add    $0x1,%eax
  800a7b:	eb f0                	jmp    800a6d <strfind+0xa>
			break;
	return (char *) s;
}
  800a7d:	5d                   	pop    %ebp
  800a7e:	c3                   	ret    

00800a7f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	57                   	push   %edi
  800a83:	56                   	push   %esi
  800a84:	53                   	push   %ebx
  800a85:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a88:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a8b:	85 c9                	test   %ecx,%ecx
  800a8d:	74 31                	je     800ac0 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a8f:	89 f8                	mov    %edi,%eax
  800a91:	09 c8                	or     %ecx,%eax
  800a93:	a8 03                	test   $0x3,%al
  800a95:	75 23                	jne    800aba <memset+0x3b>
		c &= 0xFF;
  800a97:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a9b:	89 d3                	mov    %edx,%ebx
  800a9d:	c1 e3 08             	shl    $0x8,%ebx
  800aa0:	89 d0                	mov    %edx,%eax
  800aa2:	c1 e0 18             	shl    $0x18,%eax
  800aa5:	89 d6                	mov    %edx,%esi
  800aa7:	c1 e6 10             	shl    $0x10,%esi
  800aaa:	09 f0                	or     %esi,%eax
  800aac:	09 c2                	or     %eax,%edx
  800aae:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ab0:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab3:	89 d0                	mov    %edx,%eax
  800ab5:	fc                   	cld    
  800ab6:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab8:	eb 06                	jmp    800ac0 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abd:	fc                   	cld    
  800abe:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ac0:	89 f8                	mov    %edi,%eax
  800ac2:	5b                   	pop    %ebx
  800ac3:	5e                   	pop    %esi
  800ac4:	5f                   	pop    %edi
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	57                   	push   %edi
  800acb:	56                   	push   %esi
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ad5:	39 c6                	cmp    %eax,%esi
  800ad7:	73 32                	jae    800b0b <memmove+0x44>
  800ad9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800adc:	39 c2                	cmp    %eax,%edx
  800ade:	76 2b                	jbe    800b0b <memmove+0x44>
		s += n;
		d += n;
  800ae0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae3:	89 fe                	mov    %edi,%esi
  800ae5:	09 ce                	or     %ecx,%esi
  800ae7:	09 d6                	or     %edx,%esi
  800ae9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aef:	75 0e                	jne    800aff <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af1:	83 ef 04             	sub    $0x4,%edi
  800af4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800afa:	fd                   	std    
  800afb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800afd:	eb 09                	jmp    800b08 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aff:	83 ef 01             	sub    $0x1,%edi
  800b02:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b05:	fd                   	std    
  800b06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b08:	fc                   	cld    
  800b09:	eb 1a                	jmp    800b25 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0b:	89 c2                	mov    %eax,%edx
  800b0d:	09 ca                	or     %ecx,%edx
  800b0f:	09 f2                	or     %esi,%edx
  800b11:	f6 c2 03             	test   $0x3,%dl
  800b14:	75 0a                	jne    800b20 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b16:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b19:	89 c7                	mov    %eax,%edi
  800b1b:	fc                   	cld    
  800b1c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1e:	eb 05                	jmp    800b25 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b20:	89 c7                	mov    %eax,%edi
  800b22:	fc                   	cld    
  800b23:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b25:	5e                   	pop    %esi
  800b26:	5f                   	pop    %edi
  800b27:	5d                   	pop    %ebp
  800b28:	c3                   	ret    

00800b29 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b2f:	ff 75 10             	pushl  0x10(%ebp)
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	ff 75 08             	pushl  0x8(%ebp)
  800b38:	e8 8a ff ff ff       	call   800ac7 <memmove>
}
  800b3d:	c9                   	leave  
  800b3e:	c3                   	ret    

00800b3f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	56                   	push   %esi
  800b43:	53                   	push   %ebx
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4a:	89 c6                	mov    %eax,%esi
  800b4c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b4f:	39 f0                	cmp    %esi,%eax
  800b51:	74 1c                	je     800b6f <memcmp+0x30>
		if (*s1 != *s2)
  800b53:	0f b6 08             	movzbl (%eax),%ecx
  800b56:	0f b6 1a             	movzbl (%edx),%ebx
  800b59:	38 d9                	cmp    %bl,%cl
  800b5b:	75 08                	jne    800b65 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b5d:	83 c0 01             	add    $0x1,%eax
  800b60:	83 c2 01             	add    $0x1,%edx
  800b63:	eb ea                	jmp    800b4f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b65:	0f b6 c1             	movzbl %cl,%eax
  800b68:	0f b6 db             	movzbl %bl,%ebx
  800b6b:	29 d8                	sub    %ebx,%eax
  800b6d:	eb 05                	jmp    800b74 <memcmp+0x35>
	}

	return 0;
  800b6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b74:	5b                   	pop    %ebx
  800b75:	5e                   	pop    %esi
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b81:	89 c2                	mov    %eax,%edx
  800b83:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b86:	39 d0                	cmp    %edx,%eax
  800b88:	73 09                	jae    800b93 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b8a:	38 08                	cmp    %cl,(%eax)
  800b8c:	74 05                	je     800b93 <memfind+0x1b>
	for (; s < ends; s++)
  800b8e:	83 c0 01             	add    $0x1,%eax
  800b91:	eb f3                	jmp    800b86 <memfind+0xe>
			break;
	return (void *) s;
}
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    

00800b95 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	57                   	push   %edi
  800b99:	56                   	push   %esi
  800b9a:	53                   	push   %ebx
  800b9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ba1:	eb 03                	jmp    800ba6 <strtol+0x11>
		s++;
  800ba3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ba6:	0f b6 01             	movzbl (%ecx),%eax
  800ba9:	3c 20                	cmp    $0x20,%al
  800bab:	74 f6                	je     800ba3 <strtol+0xe>
  800bad:	3c 09                	cmp    $0x9,%al
  800baf:	74 f2                	je     800ba3 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bb1:	3c 2b                	cmp    $0x2b,%al
  800bb3:	74 2a                	je     800bdf <strtol+0x4a>
	int neg = 0;
  800bb5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bba:	3c 2d                	cmp    $0x2d,%al
  800bbc:	74 2b                	je     800be9 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bbe:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bc4:	75 0f                	jne    800bd5 <strtol+0x40>
  800bc6:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc9:	74 28                	je     800bf3 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bcb:	85 db                	test   %ebx,%ebx
  800bcd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bd2:	0f 44 d8             	cmove  %eax,%ebx
  800bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bda:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bdd:	eb 50                	jmp    800c2f <strtol+0x9a>
		s++;
  800bdf:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800be2:	bf 00 00 00 00       	mov    $0x0,%edi
  800be7:	eb d5                	jmp    800bbe <strtol+0x29>
		s++, neg = 1;
  800be9:	83 c1 01             	add    $0x1,%ecx
  800bec:	bf 01 00 00 00       	mov    $0x1,%edi
  800bf1:	eb cb                	jmp    800bbe <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bf7:	74 0e                	je     800c07 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bf9:	85 db                	test   %ebx,%ebx
  800bfb:	75 d8                	jne    800bd5 <strtol+0x40>
		s++, base = 8;
  800bfd:	83 c1 01             	add    $0x1,%ecx
  800c00:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c05:	eb ce                	jmp    800bd5 <strtol+0x40>
		s += 2, base = 16;
  800c07:	83 c1 02             	add    $0x2,%ecx
  800c0a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c0f:	eb c4                	jmp    800bd5 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c11:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c14:	89 f3                	mov    %esi,%ebx
  800c16:	80 fb 19             	cmp    $0x19,%bl
  800c19:	77 29                	ja     800c44 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c1b:	0f be d2             	movsbl %dl,%edx
  800c1e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c21:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c24:	7d 30                	jge    800c56 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c26:	83 c1 01             	add    $0x1,%ecx
  800c29:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c2d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c2f:	0f b6 11             	movzbl (%ecx),%edx
  800c32:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c35:	89 f3                	mov    %esi,%ebx
  800c37:	80 fb 09             	cmp    $0x9,%bl
  800c3a:	77 d5                	ja     800c11 <strtol+0x7c>
			dig = *s - '0';
  800c3c:	0f be d2             	movsbl %dl,%edx
  800c3f:	83 ea 30             	sub    $0x30,%edx
  800c42:	eb dd                	jmp    800c21 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c44:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c47:	89 f3                	mov    %esi,%ebx
  800c49:	80 fb 19             	cmp    $0x19,%bl
  800c4c:	77 08                	ja     800c56 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c4e:	0f be d2             	movsbl %dl,%edx
  800c51:	83 ea 37             	sub    $0x37,%edx
  800c54:	eb cb                	jmp    800c21 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c56:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5a:	74 05                	je     800c61 <strtol+0xcc>
		*endptr = (char *) s;
  800c5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c61:	89 c2                	mov    %eax,%edx
  800c63:	f7 da                	neg    %edx
  800c65:	85 ff                	test   %edi,%edi
  800c67:	0f 45 c2             	cmovne %edx,%eax
}
  800c6a:	5b                   	pop    %ebx
  800c6b:	5e                   	pop    %esi
  800c6c:	5f                   	pop    %edi
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    

00800c6f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	57                   	push   %edi
  800c73:	56                   	push   %esi
  800c74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c75:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c80:	89 c3                	mov    %eax,%ebx
  800c82:	89 c7                	mov    %eax,%edi
  800c84:	89 c6                	mov    %eax,%esi
  800c86:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c88:	5b                   	pop    %ebx
  800c89:	5e                   	pop    %esi
  800c8a:	5f                   	pop    %edi
  800c8b:	5d                   	pop    %ebp
  800c8c:	c3                   	ret    

00800c8d <sys_cgetc>:

int
sys_cgetc(void)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	57                   	push   %edi
  800c91:	56                   	push   %esi
  800c92:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c93:	ba 00 00 00 00       	mov    $0x0,%edx
  800c98:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9d:	89 d1                	mov    %edx,%ecx
  800c9f:	89 d3                	mov    %edx,%ebx
  800ca1:	89 d7                	mov    %edx,%edi
  800ca3:	89 d6                	mov    %edx,%esi
  800ca5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca7:	5b                   	pop    %ebx
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	57                   	push   %edi
  800cb0:	56                   	push   %esi
  800cb1:	53                   	push   %ebx
  800cb2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cba:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbd:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc2:	89 cb                	mov    %ecx,%ebx
  800cc4:	89 cf                	mov    %ecx,%edi
  800cc6:	89 ce                	mov    %ecx,%esi
  800cc8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	7f 08                	jg     800cd6 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5f                   	pop    %edi
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd6:	83 ec 0c             	sub    $0xc,%esp
  800cd9:	50                   	push   %eax
  800cda:	6a 03                	push   $0x3
  800cdc:	68 68 29 80 00       	push   $0x802968
  800ce1:	6a 43                	push   $0x43
  800ce3:	68 85 29 80 00       	push   $0x802985
  800ce8:	e8 89 14 00 00       	call   802176 <_panic>

00800ced <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	57                   	push   %edi
  800cf1:	56                   	push   %esi
  800cf2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf3:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf8:	b8 02 00 00 00       	mov    $0x2,%eax
  800cfd:	89 d1                	mov    %edx,%ecx
  800cff:	89 d3                	mov    %edx,%ebx
  800d01:	89 d7                	mov    %edx,%edi
  800d03:	89 d6                	mov    %edx,%esi
  800d05:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d07:	5b                   	pop    %ebx
  800d08:	5e                   	pop    %esi
  800d09:	5f                   	pop    %edi
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    

00800d0c <sys_yield>:

void
sys_yield(void)
{
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	57                   	push   %edi
  800d10:	56                   	push   %esi
  800d11:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d12:	ba 00 00 00 00       	mov    $0x0,%edx
  800d17:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d1c:	89 d1                	mov    %edx,%ecx
  800d1e:	89 d3                	mov    %edx,%ebx
  800d20:	89 d7                	mov    %edx,%edi
  800d22:	89 d6                	mov    %edx,%esi
  800d24:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d26:	5b                   	pop    %ebx
  800d27:	5e                   	pop    %esi
  800d28:	5f                   	pop    %edi
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	57                   	push   %edi
  800d2f:	56                   	push   %esi
  800d30:	53                   	push   %ebx
  800d31:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d34:	be 00 00 00 00       	mov    $0x0,%esi
  800d39:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3f:	b8 04 00 00 00       	mov    $0x4,%eax
  800d44:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d47:	89 f7                	mov    %esi,%edi
  800d49:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4b:	85 c0                	test   %eax,%eax
  800d4d:	7f 08                	jg     800d57 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5f                   	pop    %edi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d57:	83 ec 0c             	sub    $0xc,%esp
  800d5a:	50                   	push   %eax
  800d5b:	6a 04                	push   $0x4
  800d5d:	68 68 29 80 00       	push   $0x802968
  800d62:	6a 43                	push   $0x43
  800d64:	68 85 29 80 00       	push   $0x802985
  800d69:	e8 08 14 00 00       	call   802176 <_panic>

00800d6e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
  800d74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d77:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7d:	b8 05 00 00 00       	mov    $0x5,%eax
  800d82:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d85:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d88:	8b 75 18             	mov    0x18(%ebp),%esi
  800d8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	7f 08                	jg     800d99 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d94:	5b                   	pop    %ebx
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d99:	83 ec 0c             	sub    $0xc,%esp
  800d9c:	50                   	push   %eax
  800d9d:	6a 05                	push   $0x5
  800d9f:	68 68 29 80 00       	push   $0x802968
  800da4:	6a 43                	push   $0x43
  800da6:	68 85 29 80 00       	push   $0x802985
  800dab:	e8 c6 13 00 00       	call   802176 <_panic>

00800db0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	57                   	push   %edi
  800db4:	56                   	push   %esi
  800db5:	53                   	push   %ebx
  800db6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc4:	b8 06 00 00 00       	mov    $0x6,%eax
  800dc9:	89 df                	mov    %ebx,%edi
  800dcb:	89 de                	mov    %ebx,%esi
  800dcd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcf:	85 c0                	test   %eax,%eax
  800dd1:	7f 08                	jg     800ddb <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd6:	5b                   	pop    %ebx
  800dd7:	5e                   	pop    %esi
  800dd8:	5f                   	pop    %edi
  800dd9:	5d                   	pop    %ebp
  800dda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddb:	83 ec 0c             	sub    $0xc,%esp
  800dde:	50                   	push   %eax
  800ddf:	6a 06                	push   $0x6
  800de1:	68 68 29 80 00       	push   $0x802968
  800de6:	6a 43                	push   $0x43
  800de8:	68 85 29 80 00       	push   $0x802985
  800ded:	e8 84 13 00 00       	call   802176 <_panic>

00800df2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	57                   	push   %edi
  800df6:	56                   	push   %esi
  800df7:	53                   	push   %ebx
  800df8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e00:	8b 55 08             	mov    0x8(%ebp),%edx
  800e03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e06:	b8 08 00 00 00       	mov    $0x8,%eax
  800e0b:	89 df                	mov    %ebx,%edi
  800e0d:	89 de                	mov    %ebx,%esi
  800e0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e11:	85 c0                	test   %eax,%eax
  800e13:	7f 08                	jg     800e1d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e18:	5b                   	pop    %ebx
  800e19:	5e                   	pop    %esi
  800e1a:	5f                   	pop    %edi
  800e1b:	5d                   	pop    %ebp
  800e1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1d:	83 ec 0c             	sub    $0xc,%esp
  800e20:	50                   	push   %eax
  800e21:	6a 08                	push   $0x8
  800e23:	68 68 29 80 00       	push   $0x802968
  800e28:	6a 43                	push   $0x43
  800e2a:	68 85 29 80 00       	push   $0x802985
  800e2f:	e8 42 13 00 00       	call   802176 <_panic>

00800e34 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	57                   	push   %edi
  800e38:	56                   	push   %esi
  800e39:	53                   	push   %ebx
  800e3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e42:	8b 55 08             	mov    0x8(%ebp),%edx
  800e45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e48:	b8 09 00 00 00       	mov    $0x9,%eax
  800e4d:	89 df                	mov    %ebx,%edi
  800e4f:	89 de                	mov    %ebx,%esi
  800e51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e53:	85 c0                	test   %eax,%eax
  800e55:	7f 08                	jg     800e5f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5a:	5b                   	pop    %ebx
  800e5b:	5e                   	pop    %esi
  800e5c:	5f                   	pop    %edi
  800e5d:	5d                   	pop    %ebp
  800e5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5f:	83 ec 0c             	sub    $0xc,%esp
  800e62:	50                   	push   %eax
  800e63:	6a 09                	push   $0x9
  800e65:	68 68 29 80 00       	push   $0x802968
  800e6a:	6a 43                	push   $0x43
  800e6c:	68 85 29 80 00       	push   $0x802985
  800e71:	e8 00 13 00 00       	call   802176 <_panic>

00800e76 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	57                   	push   %edi
  800e7a:	56                   	push   %esi
  800e7b:	53                   	push   %ebx
  800e7c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e84:	8b 55 08             	mov    0x8(%ebp),%edx
  800e87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e8f:	89 df                	mov    %ebx,%edi
  800e91:	89 de                	mov    %ebx,%esi
  800e93:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e95:	85 c0                	test   %eax,%eax
  800e97:	7f 08                	jg     800ea1 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea1:	83 ec 0c             	sub    $0xc,%esp
  800ea4:	50                   	push   %eax
  800ea5:	6a 0a                	push   $0xa
  800ea7:	68 68 29 80 00       	push   $0x802968
  800eac:	6a 43                	push   $0x43
  800eae:	68 85 29 80 00       	push   $0x802985
  800eb3:	e8 be 12 00 00       	call   802176 <_panic>

00800eb8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	57                   	push   %edi
  800ebc:	56                   	push   %esi
  800ebd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ec9:	be 00 00 00 00       	mov    $0x0,%esi
  800ece:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed6:	5b                   	pop    %ebx
  800ed7:	5e                   	pop    %esi
  800ed8:	5f                   	pop    %edi
  800ed9:	5d                   	pop    %ebp
  800eda:	c3                   	ret    

00800edb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	57                   	push   %edi
  800edf:	56                   	push   %esi
  800ee0:	53                   	push   %ebx
  800ee1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eec:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ef1:	89 cb                	mov    %ecx,%ebx
  800ef3:	89 cf                	mov    %ecx,%edi
  800ef5:	89 ce                	mov    %ecx,%esi
  800ef7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	7f 08                	jg     800f05 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5f                   	pop    %edi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f05:	83 ec 0c             	sub    $0xc,%esp
  800f08:	50                   	push   %eax
  800f09:	6a 0d                	push   $0xd
  800f0b:	68 68 29 80 00       	push   $0x802968
  800f10:	6a 43                	push   $0x43
  800f12:	68 85 29 80 00       	push   $0x802985
  800f17:	e8 5a 12 00 00       	call   802176 <_panic>

00800f1c <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	57                   	push   %edi
  800f20:	56                   	push   %esi
  800f21:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f22:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f27:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f32:	89 df                	mov    %ebx,%edi
  800f34:	89 de                	mov    %ebx,%esi
  800f36:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f38:	5b                   	pop    %ebx
  800f39:	5e                   	pop    %esi
  800f3a:	5f                   	pop    %edi
  800f3b:	5d                   	pop    %ebp
  800f3c:	c3                   	ret    

00800f3d <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	57                   	push   %edi
  800f41:	56                   	push   %esi
  800f42:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f43:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f48:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4b:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f50:	89 cb                	mov    %ecx,%ebx
  800f52:	89 cf                	mov    %ecx,%edi
  800f54:	89 ce                	mov    %ecx,%esi
  800f56:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f58:	5b                   	pop    %ebx
  800f59:	5e                   	pop    %esi
  800f5a:	5f                   	pop    %edi
  800f5b:	5d                   	pop    %ebp
  800f5c:	c3                   	ret    

00800f5d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	57                   	push   %edi
  800f61:	56                   	push   %esi
  800f62:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f63:	ba 00 00 00 00       	mov    $0x0,%edx
  800f68:	b8 10 00 00 00       	mov    $0x10,%eax
  800f6d:	89 d1                	mov    %edx,%ecx
  800f6f:	89 d3                	mov    %edx,%ebx
  800f71:	89 d7                	mov    %edx,%edi
  800f73:	89 d6                	mov    %edx,%esi
  800f75:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	57                   	push   %edi
  800f80:	56                   	push   %esi
  800f81:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f82:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f87:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8d:	b8 11 00 00 00       	mov    $0x11,%eax
  800f92:	89 df                	mov    %ebx,%edi
  800f94:	89 de                	mov    %ebx,%esi
  800f96:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f98:	5b                   	pop    %ebx
  800f99:	5e                   	pop    %esi
  800f9a:	5f                   	pop    %edi
  800f9b:	5d                   	pop    %ebp
  800f9c:	c3                   	ret    

00800f9d <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	57                   	push   %edi
  800fa1:	56                   	push   %esi
  800fa2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fae:	b8 12 00 00 00       	mov    $0x12,%eax
  800fb3:	89 df                	mov    %ebx,%edi
  800fb5:	89 de                	mov    %ebx,%esi
  800fb7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fb9:	5b                   	pop    %ebx
  800fba:	5e                   	pop    %esi
  800fbb:	5f                   	pop    %edi
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    

00800fbe <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	57                   	push   %edi
  800fc2:	56                   	push   %esi
  800fc3:	53                   	push   %ebx
  800fc4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd2:	b8 13 00 00 00       	mov    $0x13,%eax
  800fd7:	89 df                	mov    %ebx,%edi
  800fd9:	89 de                	mov    %ebx,%esi
  800fdb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fdd:	85 c0                	test   %eax,%eax
  800fdf:	7f 08                	jg     800fe9 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fe1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe4:	5b                   	pop    %ebx
  800fe5:	5e                   	pop    %esi
  800fe6:	5f                   	pop    %edi
  800fe7:	5d                   	pop    %ebp
  800fe8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe9:	83 ec 0c             	sub    $0xc,%esp
  800fec:	50                   	push   %eax
  800fed:	6a 13                	push   $0x13
  800fef:	68 68 29 80 00       	push   $0x802968
  800ff4:	6a 43                	push   $0x43
  800ff6:	68 85 29 80 00       	push   $0x802985
  800ffb:	e8 76 11 00 00       	call   802176 <_panic>

00801000 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	57                   	push   %edi
  801004:	56                   	push   %esi
  801005:	53                   	push   %ebx
	asm volatile("int %1\n"
  801006:	b9 00 00 00 00       	mov    $0x0,%ecx
  80100b:	8b 55 08             	mov    0x8(%ebp),%edx
  80100e:	b8 14 00 00 00       	mov    $0x14,%eax
  801013:	89 cb                	mov    %ecx,%ebx
  801015:	89 cf                	mov    %ecx,%edi
  801017:	89 ce                	mov    %ecx,%esi
  801019:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80101b:	5b                   	pop    %ebx
  80101c:	5e                   	pop    %esi
  80101d:	5f                   	pop    %edi
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    

00801020 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	05 00 00 00 30       	add    $0x30000000,%eax
  80102b:	c1 e8 0c             	shr    $0xc,%eax
}
  80102e:	5d                   	pop    %ebp
  80102f:	c3                   	ret    

00801030 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80103b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801040:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801045:	5d                   	pop    %ebp
  801046:	c3                   	ret    

00801047 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80104f:	89 c2                	mov    %eax,%edx
  801051:	c1 ea 16             	shr    $0x16,%edx
  801054:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80105b:	f6 c2 01             	test   $0x1,%dl
  80105e:	74 2d                	je     80108d <fd_alloc+0x46>
  801060:	89 c2                	mov    %eax,%edx
  801062:	c1 ea 0c             	shr    $0xc,%edx
  801065:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80106c:	f6 c2 01             	test   $0x1,%dl
  80106f:	74 1c                	je     80108d <fd_alloc+0x46>
  801071:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801076:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80107b:	75 d2                	jne    80104f <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801086:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80108b:	eb 0a                	jmp    801097 <fd_alloc+0x50>
			*fd_store = fd;
  80108d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801090:	89 01                	mov    %eax,(%ecx)
			return 0;
  801092:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801097:	5d                   	pop    %ebp
  801098:	c3                   	ret    

00801099 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80109f:	83 f8 1f             	cmp    $0x1f,%eax
  8010a2:	77 30                	ja     8010d4 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010a4:	c1 e0 0c             	shl    $0xc,%eax
  8010a7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010ac:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010b2:	f6 c2 01             	test   $0x1,%dl
  8010b5:	74 24                	je     8010db <fd_lookup+0x42>
  8010b7:	89 c2                	mov    %eax,%edx
  8010b9:	c1 ea 0c             	shr    $0xc,%edx
  8010bc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010c3:	f6 c2 01             	test   $0x1,%dl
  8010c6:	74 1a                	je     8010e2 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cb:	89 02                	mov    %eax,(%edx)
	return 0;
  8010cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d2:	5d                   	pop    %ebp
  8010d3:	c3                   	ret    
		return -E_INVAL;
  8010d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d9:	eb f7                	jmp    8010d2 <fd_lookup+0x39>
		return -E_INVAL;
  8010db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e0:	eb f0                	jmp    8010d2 <fd_lookup+0x39>
  8010e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e7:	eb e9                	jmp    8010d2 <fd_lookup+0x39>

008010e9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	83 ec 08             	sub    $0x8,%esp
  8010ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f7:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010fc:	39 08                	cmp    %ecx,(%eax)
  8010fe:	74 38                	je     801138 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801100:	83 c2 01             	add    $0x1,%edx
  801103:	8b 04 95 10 2a 80 00 	mov    0x802a10(,%edx,4),%eax
  80110a:	85 c0                	test   %eax,%eax
  80110c:	75 ee                	jne    8010fc <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80110e:	a1 08 40 80 00       	mov    0x804008,%eax
  801113:	8b 40 48             	mov    0x48(%eax),%eax
  801116:	83 ec 04             	sub    $0x4,%esp
  801119:	51                   	push   %ecx
  80111a:	50                   	push   %eax
  80111b:	68 94 29 80 00       	push   $0x802994
  801120:	e8 b5 f0 ff ff       	call   8001da <cprintf>
	*dev = 0;
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80112e:	83 c4 10             	add    $0x10,%esp
  801131:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801136:	c9                   	leave  
  801137:	c3                   	ret    
			*dev = devtab[i];
  801138:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80113d:	b8 00 00 00 00       	mov    $0x0,%eax
  801142:	eb f2                	jmp    801136 <dev_lookup+0x4d>

00801144 <fd_close>:
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
  801147:	57                   	push   %edi
  801148:	56                   	push   %esi
  801149:	53                   	push   %ebx
  80114a:	83 ec 24             	sub    $0x24,%esp
  80114d:	8b 75 08             	mov    0x8(%ebp),%esi
  801150:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801153:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801156:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801157:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80115d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801160:	50                   	push   %eax
  801161:	e8 33 ff ff ff       	call   801099 <fd_lookup>
  801166:	89 c3                	mov    %eax,%ebx
  801168:	83 c4 10             	add    $0x10,%esp
  80116b:	85 c0                	test   %eax,%eax
  80116d:	78 05                	js     801174 <fd_close+0x30>
	    || fd != fd2)
  80116f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801172:	74 16                	je     80118a <fd_close+0x46>
		return (must_exist ? r : 0);
  801174:	89 f8                	mov    %edi,%eax
  801176:	84 c0                	test   %al,%al
  801178:	b8 00 00 00 00       	mov    $0x0,%eax
  80117d:	0f 44 d8             	cmove  %eax,%ebx
}
  801180:	89 d8                	mov    %ebx,%eax
  801182:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801185:	5b                   	pop    %ebx
  801186:	5e                   	pop    %esi
  801187:	5f                   	pop    %edi
  801188:	5d                   	pop    %ebp
  801189:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80118a:	83 ec 08             	sub    $0x8,%esp
  80118d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801190:	50                   	push   %eax
  801191:	ff 36                	pushl  (%esi)
  801193:	e8 51 ff ff ff       	call   8010e9 <dev_lookup>
  801198:	89 c3                	mov    %eax,%ebx
  80119a:	83 c4 10             	add    $0x10,%esp
  80119d:	85 c0                	test   %eax,%eax
  80119f:	78 1a                	js     8011bb <fd_close+0x77>
		if (dev->dev_close)
  8011a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011a4:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011a7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	74 0b                	je     8011bb <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011b0:	83 ec 0c             	sub    $0xc,%esp
  8011b3:	56                   	push   %esi
  8011b4:	ff d0                	call   *%eax
  8011b6:	89 c3                	mov    %eax,%ebx
  8011b8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	56                   	push   %esi
  8011bf:	6a 00                	push   $0x0
  8011c1:	e8 ea fb ff ff       	call   800db0 <sys_page_unmap>
	return r;
  8011c6:	83 c4 10             	add    $0x10,%esp
  8011c9:	eb b5                	jmp    801180 <fd_close+0x3c>

008011cb <close>:

int
close(int fdnum)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d4:	50                   	push   %eax
  8011d5:	ff 75 08             	pushl  0x8(%ebp)
  8011d8:	e8 bc fe ff ff       	call   801099 <fd_lookup>
  8011dd:	83 c4 10             	add    $0x10,%esp
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	79 02                	jns    8011e6 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    
		return fd_close(fd, 1);
  8011e6:	83 ec 08             	sub    $0x8,%esp
  8011e9:	6a 01                	push   $0x1
  8011eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8011ee:	e8 51 ff ff ff       	call   801144 <fd_close>
  8011f3:	83 c4 10             	add    $0x10,%esp
  8011f6:	eb ec                	jmp    8011e4 <close+0x19>

008011f8 <close_all>:

void
close_all(void)
{
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
  8011fb:	53                   	push   %ebx
  8011fc:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011ff:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801204:	83 ec 0c             	sub    $0xc,%esp
  801207:	53                   	push   %ebx
  801208:	e8 be ff ff ff       	call   8011cb <close>
	for (i = 0; i < MAXFD; i++)
  80120d:	83 c3 01             	add    $0x1,%ebx
  801210:	83 c4 10             	add    $0x10,%esp
  801213:	83 fb 20             	cmp    $0x20,%ebx
  801216:	75 ec                	jne    801204 <close_all+0xc>
}
  801218:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    

0080121d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	57                   	push   %edi
  801221:	56                   	push   %esi
  801222:	53                   	push   %ebx
  801223:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801226:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801229:	50                   	push   %eax
  80122a:	ff 75 08             	pushl  0x8(%ebp)
  80122d:	e8 67 fe ff ff       	call   801099 <fd_lookup>
  801232:	89 c3                	mov    %eax,%ebx
  801234:	83 c4 10             	add    $0x10,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	0f 88 81 00 00 00    	js     8012c0 <dup+0xa3>
		return r;
	close(newfdnum);
  80123f:	83 ec 0c             	sub    $0xc,%esp
  801242:	ff 75 0c             	pushl  0xc(%ebp)
  801245:	e8 81 ff ff ff       	call   8011cb <close>

	newfd = INDEX2FD(newfdnum);
  80124a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80124d:	c1 e6 0c             	shl    $0xc,%esi
  801250:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801256:	83 c4 04             	add    $0x4,%esp
  801259:	ff 75 e4             	pushl  -0x1c(%ebp)
  80125c:	e8 cf fd ff ff       	call   801030 <fd2data>
  801261:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801263:	89 34 24             	mov    %esi,(%esp)
  801266:	e8 c5 fd ff ff       	call   801030 <fd2data>
  80126b:	83 c4 10             	add    $0x10,%esp
  80126e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801270:	89 d8                	mov    %ebx,%eax
  801272:	c1 e8 16             	shr    $0x16,%eax
  801275:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80127c:	a8 01                	test   $0x1,%al
  80127e:	74 11                	je     801291 <dup+0x74>
  801280:	89 d8                	mov    %ebx,%eax
  801282:	c1 e8 0c             	shr    $0xc,%eax
  801285:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80128c:	f6 c2 01             	test   $0x1,%dl
  80128f:	75 39                	jne    8012ca <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801291:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801294:	89 d0                	mov    %edx,%eax
  801296:	c1 e8 0c             	shr    $0xc,%eax
  801299:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012a0:	83 ec 0c             	sub    $0xc,%esp
  8012a3:	25 07 0e 00 00       	and    $0xe07,%eax
  8012a8:	50                   	push   %eax
  8012a9:	56                   	push   %esi
  8012aa:	6a 00                	push   $0x0
  8012ac:	52                   	push   %edx
  8012ad:	6a 00                	push   $0x0
  8012af:	e8 ba fa ff ff       	call   800d6e <sys_page_map>
  8012b4:	89 c3                	mov    %eax,%ebx
  8012b6:	83 c4 20             	add    $0x20,%esp
  8012b9:	85 c0                	test   %eax,%eax
  8012bb:	78 31                	js     8012ee <dup+0xd1>
		goto err;

	return newfdnum;
  8012bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012c0:	89 d8                	mov    %ebx,%eax
  8012c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c5:	5b                   	pop    %ebx
  8012c6:	5e                   	pop    %esi
  8012c7:	5f                   	pop    %edi
  8012c8:	5d                   	pop    %ebp
  8012c9:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012ca:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012d1:	83 ec 0c             	sub    $0xc,%esp
  8012d4:	25 07 0e 00 00       	and    $0xe07,%eax
  8012d9:	50                   	push   %eax
  8012da:	57                   	push   %edi
  8012db:	6a 00                	push   $0x0
  8012dd:	53                   	push   %ebx
  8012de:	6a 00                	push   $0x0
  8012e0:	e8 89 fa ff ff       	call   800d6e <sys_page_map>
  8012e5:	89 c3                	mov    %eax,%ebx
  8012e7:	83 c4 20             	add    $0x20,%esp
  8012ea:	85 c0                	test   %eax,%eax
  8012ec:	79 a3                	jns    801291 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012ee:	83 ec 08             	sub    $0x8,%esp
  8012f1:	56                   	push   %esi
  8012f2:	6a 00                	push   $0x0
  8012f4:	e8 b7 fa ff ff       	call   800db0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012f9:	83 c4 08             	add    $0x8,%esp
  8012fc:	57                   	push   %edi
  8012fd:	6a 00                	push   $0x0
  8012ff:	e8 ac fa ff ff       	call   800db0 <sys_page_unmap>
	return r;
  801304:	83 c4 10             	add    $0x10,%esp
  801307:	eb b7                	jmp    8012c0 <dup+0xa3>

00801309 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
  80130c:	53                   	push   %ebx
  80130d:	83 ec 1c             	sub    $0x1c,%esp
  801310:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801313:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801316:	50                   	push   %eax
  801317:	53                   	push   %ebx
  801318:	e8 7c fd ff ff       	call   801099 <fd_lookup>
  80131d:	83 c4 10             	add    $0x10,%esp
  801320:	85 c0                	test   %eax,%eax
  801322:	78 3f                	js     801363 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801324:	83 ec 08             	sub    $0x8,%esp
  801327:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80132a:	50                   	push   %eax
  80132b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80132e:	ff 30                	pushl  (%eax)
  801330:	e8 b4 fd ff ff       	call   8010e9 <dev_lookup>
  801335:	83 c4 10             	add    $0x10,%esp
  801338:	85 c0                	test   %eax,%eax
  80133a:	78 27                	js     801363 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80133c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80133f:	8b 42 08             	mov    0x8(%edx),%eax
  801342:	83 e0 03             	and    $0x3,%eax
  801345:	83 f8 01             	cmp    $0x1,%eax
  801348:	74 1e                	je     801368 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80134a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134d:	8b 40 08             	mov    0x8(%eax),%eax
  801350:	85 c0                	test   %eax,%eax
  801352:	74 35                	je     801389 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801354:	83 ec 04             	sub    $0x4,%esp
  801357:	ff 75 10             	pushl  0x10(%ebp)
  80135a:	ff 75 0c             	pushl  0xc(%ebp)
  80135d:	52                   	push   %edx
  80135e:	ff d0                	call   *%eax
  801360:	83 c4 10             	add    $0x10,%esp
}
  801363:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801366:	c9                   	leave  
  801367:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801368:	a1 08 40 80 00       	mov    0x804008,%eax
  80136d:	8b 40 48             	mov    0x48(%eax),%eax
  801370:	83 ec 04             	sub    $0x4,%esp
  801373:	53                   	push   %ebx
  801374:	50                   	push   %eax
  801375:	68 d5 29 80 00       	push   $0x8029d5
  80137a:	e8 5b ee ff ff       	call   8001da <cprintf>
		return -E_INVAL;
  80137f:	83 c4 10             	add    $0x10,%esp
  801382:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801387:	eb da                	jmp    801363 <read+0x5a>
		return -E_NOT_SUPP;
  801389:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80138e:	eb d3                	jmp    801363 <read+0x5a>

00801390 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
  801393:	57                   	push   %edi
  801394:	56                   	push   %esi
  801395:	53                   	push   %ebx
  801396:	83 ec 0c             	sub    $0xc,%esp
  801399:	8b 7d 08             	mov    0x8(%ebp),%edi
  80139c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80139f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a4:	39 f3                	cmp    %esi,%ebx
  8013a6:	73 23                	jae    8013cb <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013a8:	83 ec 04             	sub    $0x4,%esp
  8013ab:	89 f0                	mov    %esi,%eax
  8013ad:	29 d8                	sub    %ebx,%eax
  8013af:	50                   	push   %eax
  8013b0:	89 d8                	mov    %ebx,%eax
  8013b2:	03 45 0c             	add    0xc(%ebp),%eax
  8013b5:	50                   	push   %eax
  8013b6:	57                   	push   %edi
  8013b7:	e8 4d ff ff ff       	call   801309 <read>
		if (m < 0)
  8013bc:	83 c4 10             	add    $0x10,%esp
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	78 06                	js     8013c9 <readn+0x39>
			return m;
		if (m == 0)
  8013c3:	74 06                	je     8013cb <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013c5:	01 c3                	add    %eax,%ebx
  8013c7:	eb db                	jmp    8013a4 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013c9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013cb:	89 d8                	mov    %ebx,%eax
  8013cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d0:	5b                   	pop    %ebx
  8013d1:	5e                   	pop    %esi
  8013d2:	5f                   	pop    %edi
  8013d3:	5d                   	pop    %ebp
  8013d4:	c3                   	ret    

008013d5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	53                   	push   %ebx
  8013d9:	83 ec 1c             	sub    $0x1c,%esp
  8013dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013e2:	50                   	push   %eax
  8013e3:	53                   	push   %ebx
  8013e4:	e8 b0 fc ff ff       	call   801099 <fd_lookup>
  8013e9:	83 c4 10             	add    $0x10,%esp
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	78 3a                	js     80142a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013f0:	83 ec 08             	sub    $0x8,%esp
  8013f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f6:	50                   	push   %eax
  8013f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fa:	ff 30                	pushl  (%eax)
  8013fc:	e8 e8 fc ff ff       	call   8010e9 <dev_lookup>
  801401:	83 c4 10             	add    $0x10,%esp
  801404:	85 c0                	test   %eax,%eax
  801406:	78 22                	js     80142a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801408:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80140f:	74 1e                	je     80142f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801411:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801414:	8b 52 0c             	mov    0xc(%edx),%edx
  801417:	85 d2                	test   %edx,%edx
  801419:	74 35                	je     801450 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80141b:	83 ec 04             	sub    $0x4,%esp
  80141e:	ff 75 10             	pushl  0x10(%ebp)
  801421:	ff 75 0c             	pushl  0xc(%ebp)
  801424:	50                   	push   %eax
  801425:	ff d2                	call   *%edx
  801427:	83 c4 10             	add    $0x10,%esp
}
  80142a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80142f:	a1 08 40 80 00       	mov    0x804008,%eax
  801434:	8b 40 48             	mov    0x48(%eax),%eax
  801437:	83 ec 04             	sub    $0x4,%esp
  80143a:	53                   	push   %ebx
  80143b:	50                   	push   %eax
  80143c:	68 f1 29 80 00       	push   $0x8029f1
  801441:	e8 94 ed ff ff       	call   8001da <cprintf>
		return -E_INVAL;
  801446:	83 c4 10             	add    $0x10,%esp
  801449:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144e:	eb da                	jmp    80142a <write+0x55>
		return -E_NOT_SUPP;
  801450:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801455:	eb d3                	jmp    80142a <write+0x55>

00801457 <seek>:

int
seek(int fdnum, off_t offset)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80145d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801460:	50                   	push   %eax
  801461:	ff 75 08             	pushl  0x8(%ebp)
  801464:	e8 30 fc ff ff       	call   801099 <fd_lookup>
  801469:	83 c4 10             	add    $0x10,%esp
  80146c:	85 c0                	test   %eax,%eax
  80146e:	78 0e                	js     80147e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801470:	8b 55 0c             	mov    0xc(%ebp),%edx
  801473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801476:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801479:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	53                   	push   %ebx
  801484:	83 ec 1c             	sub    $0x1c,%esp
  801487:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80148a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80148d:	50                   	push   %eax
  80148e:	53                   	push   %ebx
  80148f:	e8 05 fc ff ff       	call   801099 <fd_lookup>
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	85 c0                	test   %eax,%eax
  801499:	78 37                	js     8014d2 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80149b:	83 ec 08             	sub    $0x8,%esp
  80149e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a1:	50                   	push   %eax
  8014a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a5:	ff 30                	pushl  (%eax)
  8014a7:	e8 3d fc ff ff       	call   8010e9 <dev_lookup>
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	78 1f                	js     8014d2 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014ba:	74 1b                	je     8014d7 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014bf:	8b 52 18             	mov    0x18(%edx),%edx
  8014c2:	85 d2                	test   %edx,%edx
  8014c4:	74 32                	je     8014f8 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014c6:	83 ec 08             	sub    $0x8,%esp
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	50                   	push   %eax
  8014cd:	ff d2                	call   *%edx
  8014cf:	83 c4 10             	add    $0x10,%esp
}
  8014d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014d7:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014dc:	8b 40 48             	mov    0x48(%eax),%eax
  8014df:	83 ec 04             	sub    $0x4,%esp
  8014e2:	53                   	push   %ebx
  8014e3:	50                   	push   %eax
  8014e4:	68 b4 29 80 00       	push   $0x8029b4
  8014e9:	e8 ec ec ff ff       	call   8001da <cprintf>
		return -E_INVAL;
  8014ee:	83 c4 10             	add    $0x10,%esp
  8014f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f6:	eb da                	jmp    8014d2 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014f8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014fd:	eb d3                	jmp    8014d2 <ftruncate+0x52>

008014ff <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	53                   	push   %ebx
  801503:	83 ec 1c             	sub    $0x1c,%esp
  801506:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801509:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80150c:	50                   	push   %eax
  80150d:	ff 75 08             	pushl  0x8(%ebp)
  801510:	e8 84 fb ff ff       	call   801099 <fd_lookup>
  801515:	83 c4 10             	add    $0x10,%esp
  801518:	85 c0                	test   %eax,%eax
  80151a:	78 4b                	js     801567 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80151c:	83 ec 08             	sub    $0x8,%esp
  80151f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801522:	50                   	push   %eax
  801523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801526:	ff 30                	pushl  (%eax)
  801528:	e8 bc fb ff ff       	call   8010e9 <dev_lookup>
  80152d:	83 c4 10             	add    $0x10,%esp
  801530:	85 c0                	test   %eax,%eax
  801532:	78 33                	js     801567 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801537:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80153b:	74 2f                	je     80156c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80153d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801540:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801547:	00 00 00 
	stat->st_isdir = 0;
  80154a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801551:	00 00 00 
	stat->st_dev = dev;
  801554:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80155a:	83 ec 08             	sub    $0x8,%esp
  80155d:	53                   	push   %ebx
  80155e:	ff 75 f0             	pushl  -0x10(%ebp)
  801561:	ff 50 14             	call   *0x14(%eax)
  801564:	83 c4 10             	add    $0x10,%esp
}
  801567:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    
		return -E_NOT_SUPP;
  80156c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801571:	eb f4                	jmp    801567 <fstat+0x68>

00801573 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	56                   	push   %esi
  801577:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801578:	83 ec 08             	sub    $0x8,%esp
  80157b:	6a 00                	push   $0x0
  80157d:	ff 75 08             	pushl  0x8(%ebp)
  801580:	e8 22 02 00 00       	call   8017a7 <open>
  801585:	89 c3                	mov    %eax,%ebx
  801587:	83 c4 10             	add    $0x10,%esp
  80158a:	85 c0                	test   %eax,%eax
  80158c:	78 1b                	js     8015a9 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80158e:	83 ec 08             	sub    $0x8,%esp
  801591:	ff 75 0c             	pushl  0xc(%ebp)
  801594:	50                   	push   %eax
  801595:	e8 65 ff ff ff       	call   8014ff <fstat>
  80159a:	89 c6                	mov    %eax,%esi
	close(fd);
  80159c:	89 1c 24             	mov    %ebx,(%esp)
  80159f:	e8 27 fc ff ff       	call   8011cb <close>
	return r;
  8015a4:	83 c4 10             	add    $0x10,%esp
  8015a7:	89 f3                	mov    %esi,%ebx
}
  8015a9:	89 d8                	mov    %ebx,%eax
  8015ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ae:	5b                   	pop    %ebx
  8015af:	5e                   	pop    %esi
  8015b0:	5d                   	pop    %ebp
  8015b1:	c3                   	ret    

008015b2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	56                   	push   %esi
  8015b6:	53                   	push   %ebx
  8015b7:	89 c6                	mov    %eax,%esi
  8015b9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015bb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015c2:	74 27                	je     8015eb <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015c4:	6a 07                	push   $0x7
  8015c6:	68 00 50 80 00       	push   $0x805000
  8015cb:	56                   	push   %esi
  8015cc:	ff 35 00 40 80 00    	pushl  0x804000
  8015d2:	e8 69 0c 00 00       	call   802240 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015d7:	83 c4 0c             	add    $0xc,%esp
  8015da:	6a 00                	push   $0x0
  8015dc:	53                   	push   %ebx
  8015dd:	6a 00                	push   $0x0
  8015df:	e8 f3 0b 00 00       	call   8021d7 <ipc_recv>
}
  8015e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e7:	5b                   	pop    %ebx
  8015e8:	5e                   	pop    %esi
  8015e9:	5d                   	pop    %ebp
  8015ea:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015eb:	83 ec 0c             	sub    $0xc,%esp
  8015ee:	6a 01                	push   $0x1
  8015f0:	e8 a3 0c 00 00       	call   802298 <ipc_find_env>
  8015f5:	a3 00 40 80 00       	mov    %eax,0x804000
  8015fa:	83 c4 10             	add    $0x10,%esp
  8015fd:	eb c5                	jmp    8015c4 <fsipc+0x12>

008015ff <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	8b 40 0c             	mov    0xc(%eax),%eax
  80160b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801610:	8b 45 0c             	mov    0xc(%ebp),%eax
  801613:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801618:	ba 00 00 00 00       	mov    $0x0,%edx
  80161d:	b8 02 00 00 00       	mov    $0x2,%eax
  801622:	e8 8b ff ff ff       	call   8015b2 <fsipc>
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <devfile_flush>:
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	8b 40 0c             	mov    0xc(%eax),%eax
  801635:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80163a:	ba 00 00 00 00       	mov    $0x0,%edx
  80163f:	b8 06 00 00 00       	mov    $0x6,%eax
  801644:	e8 69 ff ff ff       	call   8015b2 <fsipc>
}
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <devfile_stat>:
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	53                   	push   %ebx
  80164f:	83 ec 04             	sub    $0x4,%esp
  801652:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8b 40 0c             	mov    0xc(%eax),%eax
  80165b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801660:	ba 00 00 00 00       	mov    $0x0,%edx
  801665:	b8 05 00 00 00       	mov    $0x5,%eax
  80166a:	e8 43 ff ff ff       	call   8015b2 <fsipc>
  80166f:	85 c0                	test   %eax,%eax
  801671:	78 2c                	js     80169f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801673:	83 ec 08             	sub    $0x8,%esp
  801676:	68 00 50 80 00       	push   $0x805000
  80167b:	53                   	push   %ebx
  80167c:	e8 b8 f2 ff ff       	call   800939 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801681:	a1 80 50 80 00       	mov    0x805080,%eax
  801686:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80168c:	a1 84 50 80 00       	mov    0x805084,%eax
  801691:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <devfile_write>:
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	53                   	push   %ebx
  8016a8:	83 ec 08             	sub    $0x8,%esp
  8016ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016b9:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016bf:	53                   	push   %ebx
  8016c0:	ff 75 0c             	pushl  0xc(%ebp)
  8016c3:	68 08 50 80 00       	push   $0x805008
  8016c8:	e8 5c f4 ff ff       	call   800b29 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d2:	b8 04 00 00 00       	mov    $0x4,%eax
  8016d7:	e8 d6 fe ff ff       	call   8015b2 <fsipc>
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	78 0b                	js     8016ee <devfile_write+0x4a>
	assert(r <= n);
  8016e3:	39 d8                	cmp    %ebx,%eax
  8016e5:	77 0c                	ja     8016f3 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016e7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016ec:	7f 1e                	jg     80170c <devfile_write+0x68>
}
  8016ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    
	assert(r <= n);
  8016f3:	68 24 2a 80 00       	push   $0x802a24
  8016f8:	68 2b 2a 80 00       	push   $0x802a2b
  8016fd:	68 98 00 00 00       	push   $0x98
  801702:	68 40 2a 80 00       	push   $0x802a40
  801707:	e8 6a 0a 00 00       	call   802176 <_panic>
	assert(r <= PGSIZE);
  80170c:	68 4b 2a 80 00       	push   $0x802a4b
  801711:	68 2b 2a 80 00       	push   $0x802a2b
  801716:	68 99 00 00 00       	push   $0x99
  80171b:	68 40 2a 80 00       	push   $0x802a40
  801720:	e8 51 0a 00 00       	call   802176 <_panic>

00801725 <devfile_read>:
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	56                   	push   %esi
  801729:	53                   	push   %ebx
  80172a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	8b 40 0c             	mov    0xc(%eax),%eax
  801733:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801738:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80173e:	ba 00 00 00 00       	mov    $0x0,%edx
  801743:	b8 03 00 00 00       	mov    $0x3,%eax
  801748:	e8 65 fe ff ff       	call   8015b2 <fsipc>
  80174d:	89 c3                	mov    %eax,%ebx
  80174f:	85 c0                	test   %eax,%eax
  801751:	78 1f                	js     801772 <devfile_read+0x4d>
	assert(r <= n);
  801753:	39 f0                	cmp    %esi,%eax
  801755:	77 24                	ja     80177b <devfile_read+0x56>
	assert(r <= PGSIZE);
  801757:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80175c:	7f 33                	jg     801791 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80175e:	83 ec 04             	sub    $0x4,%esp
  801761:	50                   	push   %eax
  801762:	68 00 50 80 00       	push   $0x805000
  801767:	ff 75 0c             	pushl  0xc(%ebp)
  80176a:	e8 58 f3 ff ff       	call   800ac7 <memmove>
	return r;
  80176f:	83 c4 10             	add    $0x10,%esp
}
  801772:	89 d8                	mov    %ebx,%eax
  801774:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801777:	5b                   	pop    %ebx
  801778:	5e                   	pop    %esi
  801779:	5d                   	pop    %ebp
  80177a:	c3                   	ret    
	assert(r <= n);
  80177b:	68 24 2a 80 00       	push   $0x802a24
  801780:	68 2b 2a 80 00       	push   $0x802a2b
  801785:	6a 7c                	push   $0x7c
  801787:	68 40 2a 80 00       	push   $0x802a40
  80178c:	e8 e5 09 00 00       	call   802176 <_panic>
	assert(r <= PGSIZE);
  801791:	68 4b 2a 80 00       	push   $0x802a4b
  801796:	68 2b 2a 80 00       	push   $0x802a2b
  80179b:	6a 7d                	push   $0x7d
  80179d:	68 40 2a 80 00       	push   $0x802a40
  8017a2:	e8 cf 09 00 00       	call   802176 <_panic>

008017a7 <open>:
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	56                   	push   %esi
  8017ab:	53                   	push   %ebx
  8017ac:	83 ec 1c             	sub    $0x1c,%esp
  8017af:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017b2:	56                   	push   %esi
  8017b3:	e8 48 f1 ff ff       	call   800900 <strlen>
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017c0:	7f 6c                	jg     80182e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017c2:	83 ec 0c             	sub    $0xc,%esp
  8017c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c8:	50                   	push   %eax
  8017c9:	e8 79 f8 ff ff       	call   801047 <fd_alloc>
  8017ce:	89 c3                	mov    %eax,%ebx
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	78 3c                	js     801813 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017d7:	83 ec 08             	sub    $0x8,%esp
  8017da:	56                   	push   %esi
  8017db:	68 00 50 80 00       	push   $0x805000
  8017e0:	e8 54 f1 ff ff       	call   800939 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e8:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f5:	e8 b8 fd ff ff       	call   8015b2 <fsipc>
  8017fa:	89 c3                	mov    %eax,%ebx
  8017fc:	83 c4 10             	add    $0x10,%esp
  8017ff:	85 c0                	test   %eax,%eax
  801801:	78 19                	js     80181c <open+0x75>
	return fd2num(fd);
  801803:	83 ec 0c             	sub    $0xc,%esp
  801806:	ff 75 f4             	pushl  -0xc(%ebp)
  801809:	e8 12 f8 ff ff       	call   801020 <fd2num>
  80180e:	89 c3                	mov    %eax,%ebx
  801810:	83 c4 10             	add    $0x10,%esp
}
  801813:	89 d8                	mov    %ebx,%eax
  801815:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801818:	5b                   	pop    %ebx
  801819:	5e                   	pop    %esi
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    
		fd_close(fd, 0);
  80181c:	83 ec 08             	sub    $0x8,%esp
  80181f:	6a 00                	push   $0x0
  801821:	ff 75 f4             	pushl  -0xc(%ebp)
  801824:	e8 1b f9 ff ff       	call   801144 <fd_close>
		return r;
  801829:	83 c4 10             	add    $0x10,%esp
  80182c:	eb e5                	jmp    801813 <open+0x6c>
		return -E_BAD_PATH;
  80182e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801833:	eb de                	jmp    801813 <open+0x6c>

00801835 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80183b:	ba 00 00 00 00       	mov    $0x0,%edx
  801840:	b8 08 00 00 00       	mov    $0x8,%eax
  801845:	e8 68 fd ff ff       	call   8015b2 <fsipc>
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801852:	68 57 2a 80 00       	push   $0x802a57
  801857:	ff 75 0c             	pushl  0xc(%ebp)
  80185a:	e8 da f0 ff ff       	call   800939 <strcpy>
	return 0;
}
  80185f:	b8 00 00 00 00       	mov    $0x0,%eax
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <devsock_close>:
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	53                   	push   %ebx
  80186a:	83 ec 10             	sub    $0x10,%esp
  80186d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801870:	53                   	push   %ebx
  801871:	e8 61 0a 00 00       	call   8022d7 <pageref>
  801876:	83 c4 10             	add    $0x10,%esp
		return 0;
  801879:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80187e:	83 f8 01             	cmp    $0x1,%eax
  801881:	74 07                	je     80188a <devsock_close+0x24>
}
  801883:	89 d0                	mov    %edx,%eax
  801885:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801888:	c9                   	leave  
  801889:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80188a:	83 ec 0c             	sub    $0xc,%esp
  80188d:	ff 73 0c             	pushl  0xc(%ebx)
  801890:	e8 b9 02 00 00       	call   801b4e <nsipc_close>
  801895:	89 c2                	mov    %eax,%edx
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	eb e7                	jmp    801883 <devsock_close+0x1d>

0080189c <devsock_write>:
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018a2:	6a 00                	push   $0x0
  8018a4:	ff 75 10             	pushl  0x10(%ebp)
  8018a7:	ff 75 0c             	pushl  0xc(%ebp)
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	ff 70 0c             	pushl  0xc(%eax)
  8018b0:	e8 76 03 00 00       	call   801c2b <nsipc_send>
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <devsock_read>:
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018bd:	6a 00                	push   $0x0
  8018bf:	ff 75 10             	pushl  0x10(%ebp)
  8018c2:	ff 75 0c             	pushl  0xc(%ebp)
  8018c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c8:	ff 70 0c             	pushl  0xc(%eax)
  8018cb:	e8 ef 02 00 00       	call   801bbf <nsipc_recv>
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <fd2sockid>:
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018d8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018db:	52                   	push   %edx
  8018dc:	50                   	push   %eax
  8018dd:	e8 b7 f7 ff ff       	call   801099 <fd_lookup>
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	85 c0                	test   %eax,%eax
  8018e7:	78 10                	js     8018f9 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ec:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018f2:	39 08                	cmp    %ecx,(%eax)
  8018f4:	75 05                	jne    8018fb <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018f6:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    
		return -E_NOT_SUPP;
  8018fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801900:	eb f7                	jmp    8018f9 <fd2sockid+0x27>

00801902 <alloc_sockfd>:
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	56                   	push   %esi
  801906:	53                   	push   %ebx
  801907:	83 ec 1c             	sub    $0x1c,%esp
  80190a:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80190c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190f:	50                   	push   %eax
  801910:	e8 32 f7 ff ff       	call   801047 <fd_alloc>
  801915:	89 c3                	mov    %eax,%ebx
  801917:	83 c4 10             	add    $0x10,%esp
  80191a:	85 c0                	test   %eax,%eax
  80191c:	78 43                	js     801961 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80191e:	83 ec 04             	sub    $0x4,%esp
  801921:	68 07 04 00 00       	push   $0x407
  801926:	ff 75 f4             	pushl  -0xc(%ebp)
  801929:	6a 00                	push   $0x0
  80192b:	e8 fb f3 ff ff       	call   800d2b <sys_page_alloc>
  801930:	89 c3                	mov    %eax,%ebx
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	85 c0                	test   %eax,%eax
  801937:	78 28                	js     801961 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801942:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801947:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80194e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801951:	83 ec 0c             	sub    $0xc,%esp
  801954:	50                   	push   %eax
  801955:	e8 c6 f6 ff ff       	call   801020 <fd2num>
  80195a:	89 c3                	mov    %eax,%ebx
  80195c:	83 c4 10             	add    $0x10,%esp
  80195f:	eb 0c                	jmp    80196d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801961:	83 ec 0c             	sub    $0xc,%esp
  801964:	56                   	push   %esi
  801965:	e8 e4 01 00 00       	call   801b4e <nsipc_close>
		return r;
  80196a:	83 c4 10             	add    $0x10,%esp
}
  80196d:	89 d8                	mov    %ebx,%eax
  80196f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801972:	5b                   	pop    %ebx
  801973:	5e                   	pop    %esi
  801974:	5d                   	pop    %ebp
  801975:	c3                   	ret    

00801976 <accept>:
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	e8 4e ff ff ff       	call   8018d2 <fd2sockid>
  801984:	85 c0                	test   %eax,%eax
  801986:	78 1b                	js     8019a3 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801988:	83 ec 04             	sub    $0x4,%esp
  80198b:	ff 75 10             	pushl  0x10(%ebp)
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	50                   	push   %eax
  801992:	e8 0e 01 00 00       	call   801aa5 <nsipc_accept>
  801997:	83 c4 10             	add    $0x10,%esp
  80199a:	85 c0                	test   %eax,%eax
  80199c:	78 05                	js     8019a3 <accept+0x2d>
	return alloc_sockfd(r);
  80199e:	e8 5f ff ff ff       	call   801902 <alloc_sockfd>
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <bind>:
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	e8 1f ff ff ff       	call   8018d2 <fd2sockid>
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	78 12                	js     8019c9 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	ff 75 10             	pushl  0x10(%ebp)
  8019bd:	ff 75 0c             	pushl  0xc(%ebp)
  8019c0:	50                   	push   %eax
  8019c1:	e8 31 01 00 00       	call   801af7 <nsipc_bind>
  8019c6:	83 c4 10             	add    $0x10,%esp
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <shutdown>:
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	e8 f9 fe ff ff       	call   8018d2 <fd2sockid>
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	78 0f                	js     8019ec <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019dd:	83 ec 08             	sub    $0x8,%esp
  8019e0:	ff 75 0c             	pushl  0xc(%ebp)
  8019e3:	50                   	push   %eax
  8019e4:	e8 43 01 00 00       	call   801b2c <nsipc_shutdown>
  8019e9:	83 c4 10             	add    $0x10,%esp
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <connect>:
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	e8 d6 fe ff ff       	call   8018d2 <fd2sockid>
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 12                	js     801a12 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a00:	83 ec 04             	sub    $0x4,%esp
  801a03:	ff 75 10             	pushl  0x10(%ebp)
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	50                   	push   %eax
  801a0a:	e8 59 01 00 00       	call   801b68 <nsipc_connect>
  801a0f:	83 c4 10             	add    $0x10,%esp
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <listen>:
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	e8 b0 fe ff ff       	call   8018d2 <fd2sockid>
  801a22:	85 c0                	test   %eax,%eax
  801a24:	78 0f                	js     801a35 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a26:	83 ec 08             	sub    $0x8,%esp
  801a29:	ff 75 0c             	pushl  0xc(%ebp)
  801a2c:	50                   	push   %eax
  801a2d:	e8 6b 01 00 00       	call   801b9d <nsipc_listen>
  801a32:	83 c4 10             	add    $0x10,%esp
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a3d:	ff 75 10             	pushl  0x10(%ebp)
  801a40:	ff 75 0c             	pushl  0xc(%ebp)
  801a43:	ff 75 08             	pushl  0x8(%ebp)
  801a46:	e8 3e 02 00 00       	call   801c89 <nsipc_socket>
  801a4b:	83 c4 10             	add    $0x10,%esp
  801a4e:	85 c0                	test   %eax,%eax
  801a50:	78 05                	js     801a57 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a52:	e8 ab fe ff ff       	call   801902 <alloc_sockfd>
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	53                   	push   %ebx
  801a5d:	83 ec 04             	sub    $0x4,%esp
  801a60:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a62:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a69:	74 26                	je     801a91 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a6b:	6a 07                	push   $0x7
  801a6d:	68 00 60 80 00       	push   $0x806000
  801a72:	53                   	push   %ebx
  801a73:	ff 35 04 40 80 00    	pushl  0x804004
  801a79:	e8 c2 07 00 00       	call   802240 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a7e:	83 c4 0c             	add    $0xc,%esp
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	e8 4b 07 00 00       	call   8021d7 <ipc_recv>
}
  801a8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a91:	83 ec 0c             	sub    $0xc,%esp
  801a94:	6a 02                	push   $0x2
  801a96:	e8 fd 07 00 00       	call   802298 <ipc_find_env>
  801a9b:	a3 04 40 80 00       	mov    %eax,0x804004
  801aa0:	83 c4 10             	add    $0x10,%esp
  801aa3:	eb c6                	jmp    801a6b <nsipc+0x12>

00801aa5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	56                   	push   %esi
  801aa9:	53                   	push   %ebx
  801aaa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ab5:	8b 06                	mov    (%esi),%eax
  801ab7:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801abc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac1:	e8 93 ff ff ff       	call   801a59 <nsipc>
  801ac6:	89 c3                	mov    %eax,%ebx
  801ac8:	85 c0                	test   %eax,%eax
  801aca:	79 09                	jns    801ad5 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801acc:	89 d8                	mov    %ebx,%eax
  801ace:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad1:	5b                   	pop    %ebx
  801ad2:	5e                   	pop    %esi
  801ad3:	5d                   	pop    %ebp
  801ad4:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ad5:	83 ec 04             	sub    $0x4,%esp
  801ad8:	ff 35 10 60 80 00    	pushl  0x806010
  801ade:	68 00 60 80 00       	push   $0x806000
  801ae3:	ff 75 0c             	pushl  0xc(%ebp)
  801ae6:	e8 dc ef ff ff       	call   800ac7 <memmove>
		*addrlen = ret->ret_addrlen;
  801aeb:	a1 10 60 80 00       	mov    0x806010,%eax
  801af0:	89 06                	mov    %eax,(%esi)
  801af2:	83 c4 10             	add    $0x10,%esp
	return r;
  801af5:	eb d5                	jmp    801acc <nsipc_accept+0x27>

00801af7 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	53                   	push   %ebx
  801afb:	83 ec 08             	sub    $0x8,%esp
  801afe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b09:	53                   	push   %ebx
  801b0a:	ff 75 0c             	pushl  0xc(%ebp)
  801b0d:	68 04 60 80 00       	push   $0x806004
  801b12:	e8 b0 ef ff ff       	call   800ac7 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b17:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b1d:	b8 02 00 00 00       	mov    $0x2,%eax
  801b22:	e8 32 ff ff ff       	call   801a59 <nsipc>
}
  801b27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b42:	b8 03 00 00 00       	mov    $0x3,%eax
  801b47:	e8 0d ff ff ff       	call   801a59 <nsipc>
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <nsipc_close>:

int
nsipc_close(int s)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b5c:	b8 04 00 00 00       	mov    $0x4,%eax
  801b61:	e8 f3 fe ff ff       	call   801a59 <nsipc>
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	53                   	push   %ebx
  801b6c:	83 ec 08             	sub    $0x8,%esp
  801b6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b7a:	53                   	push   %ebx
  801b7b:	ff 75 0c             	pushl  0xc(%ebp)
  801b7e:	68 04 60 80 00       	push   $0x806004
  801b83:	e8 3f ef ff ff       	call   800ac7 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b88:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b8e:	b8 05 00 00 00       	mov    $0x5,%eax
  801b93:	e8 c1 fe ff ff       	call   801a59 <nsipc>
}
  801b98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bae:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bb3:	b8 06 00 00 00       	mov    $0x6,%eax
  801bb8:	e8 9c fe ff ff       	call   801a59 <nsipc>
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	56                   	push   %esi
  801bc3:	53                   	push   %ebx
  801bc4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bcf:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bd5:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd8:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bdd:	b8 07 00 00 00       	mov    $0x7,%eax
  801be2:	e8 72 fe ff ff       	call   801a59 <nsipc>
  801be7:	89 c3                	mov    %eax,%ebx
  801be9:	85 c0                	test   %eax,%eax
  801beb:	78 1f                	js     801c0c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bed:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bf2:	7f 21                	jg     801c15 <nsipc_recv+0x56>
  801bf4:	39 c6                	cmp    %eax,%esi
  801bf6:	7c 1d                	jl     801c15 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bf8:	83 ec 04             	sub    $0x4,%esp
  801bfb:	50                   	push   %eax
  801bfc:	68 00 60 80 00       	push   $0x806000
  801c01:	ff 75 0c             	pushl  0xc(%ebp)
  801c04:	e8 be ee ff ff       	call   800ac7 <memmove>
  801c09:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c0c:	89 d8                	mov    %ebx,%eax
  801c0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c11:	5b                   	pop    %ebx
  801c12:	5e                   	pop    %esi
  801c13:	5d                   	pop    %ebp
  801c14:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c15:	68 63 2a 80 00       	push   $0x802a63
  801c1a:	68 2b 2a 80 00       	push   $0x802a2b
  801c1f:	6a 62                	push   $0x62
  801c21:	68 78 2a 80 00       	push   $0x802a78
  801c26:	e8 4b 05 00 00       	call   802176 <_panic>

00801c2b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	53                   	push   %ebx
  801c2f:	83 ec 04             	sub    $0x4,%esp
  801c32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c3d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c43:	7f 2e                	jg     801c73 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c45:	83 ec 04             	sub    $0x4,%esp
  801c48:	53                   	push   %ebx
  801c49:	ff 75 0c             	pushl  0xc(%ebp)
  801c4c:	68 0c 60 80 00       	push   $0x80600c
  801c51:	e8 71 ee ff ff       	call   800ac7 <memmove>
	nsipcbuf.send.req_size = size;
  801c56:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c5c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c64:	b8 08 00 00 00       	mov    $0x8,%eax
  801c69:	e8 eb fd ff ff       	call   801a59 <nsipc>
}
  801c6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    
	assert(size < 1600);
  801c73:	68 84 2a 80 00       	push   $0x802a84
  801c78:	68 2b 2a 80 00       	push   $0x802a2b
  801c7d:	6a 6d                	push   $0x6d
  801c7f:	68 78 2a 80 00       	push   $0x802a78
  801c84:	e8 ed 04 00 00       	call   802176 <_panic>

00801c89 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c9a:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca2:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ca7:	b8 09 00 00 00       	mov    $0x9,%eax
  801cac:	e8 a8 fd ff ff       	call   801a59 <nsipc>
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	56                   	push   %esi
  801cb7:	53                   	push   %ebx
  801cb8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cbb:	83 ec 0c             	sub    $0xc,%esp
  801cbe:	ff 75 08             	pushl  0x8(%ebp)
  801cc1:	e8 6a f3 ff ff       	call   801030 <fd2data>
  801cc6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cc8:	83 c4 08             	add    $0x8,%esp
  801ccb:	68 90 2a 80 00       	push   $0x802a90
  801cd0:	53                   	push   %ebx
  801cd1:	e8 63 ec ff ff       	call   800939 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cd6:	8b 46 04             	mov    0x4(%esi),%eax
  801cd9:	2b 06                	sub    (%esi),%eax
  801cdb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ce1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ce8:	00 00 00 
	stat->st_dev = &devpipe;
  801ceb:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cf2:	30 80 00 
	return 0;
}
  801cf5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cfd:	5b                   	pop    %ebx
  801cfe:	5e                   	pop    %esi
  801cff:	5d                   	pop    %ebp
  801d00:	c3                   	ret    

00801d01 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	53                   	push   %ebx
  801d05:	83 ec 0c             	sub    $0xc,%esp
  801d08:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d0b:	53                   	push   %ebx
  801d0c:	6a 00                	push   $0x0
  801d0e:	e8 9d f0 ff ff       	call   800db0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d13:	89 1c 24             	mov    %ebx,(%esp)
  801d16:	e8 15 f3 ff ff       	call   801030 <fd2data>
  801d1b:	83 c4 08             	add    $0x8,%esp
  801d1e:	50                   	push   %eax
  801d1f:	6a 00                	push   $0x0
  801d21:	e8 8a f0 ff ff       	call   800db0 <sys_page_unmap>
}
  801d26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <_pipeisclosed>:
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	57                   	push   %edi
  801d2f:	56                   	push   %esi
  801d30:	53                   	push   %ebx
  801d31:	83 ec 1c             	sub    $0x1c,%esp
  801d34:	89 c7                	mov    %eax,%edi
  801d36:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d38:	a1 08 40 80 00       	mov    0x804008,%eax
  801d3d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d40:	83 ec 0c             	sub    $0xc,%esp
  801d43:	57                   	push   %edi
  801d44:	e8 8e 05 00 00       	call   8022d7 <pageref>
  801d49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d4c:	89 34 24             	mov    %esi,(%esp)
  801d4f:	e8 83 05 00 00       	call   8022d7 <pageref>
		nn = thisenv->env_runs;
  801d54:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d5a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d5d:	83 c4 10             	add    $0x10,%esp
  801d60:	39 cb                	cmp    %ecx,%ebx
  801d62:	74 1b                	je     801d7f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d64:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d67:	75 cf                	jne    801d38 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d69:	8b 42 58             	mov    0x58(%edx),%eax
  801d6c:	6a 01                	push   $0x1
  801d6e:	50                   	push   %eax
  801d6f:	53                   	push   %ebx
  801d70:	68 97 2a 80 00       	push   $0x802a97
  801d75:	e8 60 e4 ff ff       	call   8001da <cprintf>
  801d7a:	83 c4 10             	add    $0x10,%esp
  801d7d:	eb b9                	jmp    801d38 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d7f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d82:	0f 94 c0             	sete   %al
  801d85:	0f b6 c0             	movzbl %al,%eax
}
  801d88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d8b:	5b                   	pop    %ebx
  801d8c:	5e                   	pop    %esi
  801d8d:	5f                   	pop    %edi
  801d8e:	5d                   	pop    %ebp
  801d8f:	c3                   	ret    

00801d90 <devpipe_write>:
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	57                   	push   %edi
  801d94:	56                   	push   %esi
  801d95:	53                   	push   %ebx
  801d96:	83 ec 28             	sub    $0x28,%esp
  801d99:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d9c:	56                   	push   %esi
  801d9d:	e8 8e f2 ff ff       	call   801030 <fd2data>
  801da2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801da4:	83 c4 10             	add    $0x10,%esp
  801da7:	bf 00 00 00 00       	mov    $0x0,%edi
  801dac:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801daf:	74 4f                	je     801e00 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801db1:	8b 43 04             	mov    0x4(%ebx),%eax
  801db4:	8b 0b                	mov    (%ebx),%ecx
  801db6:	8d 51 20             	lea    0x20(%ecx),%edx
  801db9:	39 d0                	cmp    %edx,%eax
  801dbb:	72 14                	jb     801dd1 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dbd:	89 da                	mov    %ebx,%edx
  801dbf:	89 f0                	mov    %esi,%eax
  801dc1:	e8 65 ff ff ff       	call   801d2b <_pipeisclosed>
  801dc6:	85 c0                	test   %eax,%eax
  801dc8:	75 3b                	jne    801e05 <devpipe_write+0x75>
			sys_yield();
  801dca:	e8 3d ef ff ff       	call   800d0c <sys_yield>
  801dcf:	eb e0                	jmp    801db1 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dd4:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dd8:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ddb:	89 c2                	mov    %eax,%edx
  801ddd:	c1 fa 1f             	sar    $0x1f,%edx
  801de0:	89 d1                	mov    %edx,%ecx
  801de2:	c1 e9 1b             	shr    $0x1b,%ecx
  801de5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801de8:	83 e2 1f             	and    $0x1f,%edx
  801deb:	29 ca                	sub    %ecx,%edx
  801ded:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801df1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801df5:	83 c0 01             	add    $0x1,%eax
  801df8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dfb:	83 c7 01             	add    $0x1,%edi
  801dfe:	eb ac                	jmp    801dac <devpipe_write+0x1c>
	return i;
  801e00:	8b 45 10             	mov    0x10(%ebp),%eax
  801e03:	eb 05                	jmp    801e0a <devpipe_write+0x7a>
				return 0;
  801e05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e0d:	5b                   	pop    %ebx
  801e0e:	5e                   	pop    %esi
  801e0f:	5f                   	pop    %edi
  801e10:	5d                   	pop    %ebp
  801e11:	c3                   	ret    

00801e12 <devpipe_read>:
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	57                   	push   %edi
  801e16:	56                   	push   %esi
  801e17:	53                   	push   %ebx
  801e18:	83 ec 18             	sub    $0x18,%esp
  801e1b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e1e:	57                   	push   %edi
  801e1f:	e8 0c f2 ff ff       	call   801030 <fd2data>
  801e24:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e26:	83 c4 10             	add    $0x10,%esp
  801e29:	be 00 00 00 00       	mov    $0x0,%esi
  801e2e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e31:	75 14                	jne    801e47 <devpipe_read+0x35>
	return i;
  801e33:	8b 45 10             	mov    0x10(%ebp),%eax
  801e36:	eb 02                	jmp    801e3a <devpipe_read+0x28>
				return i;
  801e38:	89 f0                	mov    %esi,%eax
}
  801e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e3d:	5b                   	pop    %ebx
  801e3e:	5e                   	pop    %esi
  801e3f:	5f                   	pop    %edi
  801e40:	5d                   	pop    %ebp
  801e41:	c3                   	ret    
			sys_yield();
  801e42:	e8 c5 ee ff ff       	call   800d0c <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e47:	8b 03                	mov    (%ebx),%eax
  801e49:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e4c:	75 18                	jne    801e66 <devpipe_read+0x54>
			if (i > 0)
  801e4e:	85 f6                	test   %esi,%esi
  801e50:	75 e6                	jne    801e38 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e52:	89 da                	mov    %ebx,%edx
  801e54:	89 f8                	mov    %edi,%eax
  801e56:	e8 d0 fe ff ff       	call   801d2b <_pipeisclosed>
  801e5b:	85 c0                	test   %eax,%eax
  801e5d:	74 e3                	je     801e42 <devpipe_read+0x30>
				return 0;
  801e5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e64:	eb d4                	jmp    801e3a <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e66:	99                   	cltd   
  801e67:	c1 ea 1b             	shr    $0x1b,%edx
  801e6a:	01 d0                	add    %edx,%eax
  801e6c:	83 e0 1f             	and    $0x1f,%eax
  801e6f:	29 d0                	sub    %edx,%eax
  801e71:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e79:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e7c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e7f:	83 c6 01             	add    $0x1,%esi
  801e82:	eb aa                	jmp    801e2e <devpipe_read+0x1c>

00801e84 <pipe>:
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	56                   	push   %esi
  801e88:	53                   	push   %ebx
  801e89:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e8f:	50                   	push   %eax
  801e90:	e8 b2 f1 ff ff       	call   801047 <fd_alloc>
  801e95:	89 c3                	mov    %eax,%ebx
  801e97:	83 c4 10             	add    $0x10,%esp
  801e9a:	85 c0                	test   %eax,%eax
  801e9c:	0f 88 23 01 00 00    	js     801fc5 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea2:	83 ec 04             	sub    $0x4,%esp
  801ea5:	68 07 04 00 00       	push   $0x407
  801eaa:	ff 75 f4             	pushl  -0xc(%ebp)
  801ead:	6a 00                	push   $0x0
  801eaf:	e8 77 ee ff ff       	call   800d2b <sys_page_alloc>
  801eb4:	89 c3                	mov    %eax,%ebx
  801eb6:	83 c4 10             	add    $0x10,%esp
  801eb9:	85 c0                	test   %eax,%eax
  801ebb:	0f 88 04 01 00 00    	js     801fc5 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ec1:	83 ec 0c             	sub    $0xc,%esp
  801ec4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ec7:	50                   	push   %eax
  801ec8:	e8 7a f1 ff ff       	call   801047 <fd_alloc>
  801ecd:	89 c3                	mov    %eax,%ebx
  801ecf:	83 c4 10             	add    $0x10,%esp
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	0f 88 db 00 00 00    	js     801fb5 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eda:	83 ec 04             	sub    $0x4,%esp
  801edd:	68 07 04 00 00       	push   $0x407
  801ee2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ee5:	6a 00                	push   $0x0
  801ee7:	e8 3f ee ff ff       	call   800d2b <sys_page_alloc>
  801eec:	89 c3                	mov    %eax,%ebx
  801eee:	83 c4 10             	add    $0x10,%esp
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	0f 88 bc 00 00 00    	js     801fb5 <pipe+0x131>
	va = fd2data(fd0);
  801ef9:	83 ec 0c             	sub    $0xc,%esp
  801efc:	ff 75 f4             	pushl  -0xc(%ebp)
  801eff:	e8 2c f1 ff ff       	call   801030 <fd2data>
  801f04:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f06:	83 c4 0c             	add    $0xc,%esp
  801f09:	68 07 04 00 00       	push   $0x407
  801f0e:	50                   	push   %eax
  801f0f:	6a 00                	push   $0x0
  801f11:	e8 15 ee ff ff       	call   800d2b <sys_page_alloc>
  801f16:	89 c3                	mov    %eax,%ebx
  801f18:	83 c4 10             	add    $0x10,%esp
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	0f 88 82 00 00 00    	js     801fa5 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f23:	83 ec 0c             	sub    $0xc,%esp
  801f26:	ff 75 f0             	pushl  -0x10(%ebp)
  801f29:	e8 02 f1 ff ff       	call   801030 <fd2data>
  801f2e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f35:	50                   	push   %eax
  801f36:	6a 00                	push   $0x0
  801f38:	56                   	push   %esi
  801f39:	6a 00                	push   $0x0
  801f3b:	e8 2e ee ff ff       	call   800d6e <sys_page_map>
  801f40:	89 c3                	mov    %eax,%ebx
  801f42:	83 c4 20             	add    $0x20,%esp
  801f45:	85 c0                	test   %eax,%eax
  801f47:	78 4e                	js     801f97 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f49:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f51:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f56:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f60:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f65:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f6c:	83 ec 0c             	sub    $0xc,%esp
  801f6f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f72:	e8 a9 f0 ff ff       	call   801020 <fd2num>
  801f77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f7a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f7c:	83 c4 04             	add    $0x4,%esp
  801f7f:	ff 75 f0             	pushl  -0x10(%ebp)
  801f82:	e8 99 f0 ff ff       	call   801020 <fd2num>
  801f87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f8a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f8d:	83 c4 10             	add    $0x10,%esp
  801f90:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f95:	eb 2e                	jmp    801fc5 <pipe+0x141>
	sys_page_unmap(0, va);
  801f97:	83 ec 08             	sub    $0x8,%esp
  801f9a:	56                   	push   %esi
  801f9b:	6a 00                	push   $0x0
  801f9d:	e8 0e ee ff ff       	call   800db0 <sys_page_unmap>
  801fa2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fa5:	83 ec 08             	sub    $0x8,%esp
  801fa8:	ff 75 f0             	pushl  -0x10(%ebp)
  801fab:	6a 00                	push   $0x0
  801fad:	e8 fe ed ff ff       	call   800db0 <sys_page_unmap>
  801fb2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fb5:	83 ec 08             	sub    $0x8,%esp
  801fb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801fbb:	6a 00                	push   $0x0
  801fbd:	e8 ee ed ff ff       	call   800db0 <sys_page_unmap>
  801fc2:	83 c4 10             	add    $0x10,%esp
}
  801fc5:	89 d8                	mov    %ebx,%eax
  801fc7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fca:	5b                   	pop    %ebx
  801fcb:	5e                   	pop    %esi
  801fcc:	5d                   	pop    %ebp
  801fcd:	c3                   	ret    

00801fce <pipeisclosed>:
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd7:	50                   	push   %eax
  801fd8:	ff 75 08             	pushl  0x8(%ebp)
  801fdb:	e8 b9 f0 ff ff       	call   801099 <fd_lookup>
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	78 18                	js     801fff <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fe7:	83 ec 0c             	sub    $0xc,%esp
  801fea:	ff 75 f4             	pushl  -0xc(%ebp)
  801fed:	e8 3e f0 ff ff       	call   801030 <fd2data>
	return _pipeisclosed(fd, p);
  801ff2:	89 c2                	mov    %eax,%edx
  801ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff7:	e8 2f fd ff ff       	call   801d2b <_pipeisclosed>
  801ffc:	83 c4 10             	add    $0x10,%esp
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802001:	b8 00 00 00 00       	mov    $0x0,%eax
  802006:	c3                   	ret    

00802007 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80200d:	68 af 2a 80 00       	push   $0x802aaf
  802012:	ff 75 0c             	pushl  0xc(%ebp)
  802015:	e8 1f e9 ff ff       	call   800939 <strcpy>
	return 0;
}
  80201a:	b8 00 00 00 00       	mov    $0x0,%eax
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <devcons_write>:
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	57                   	push   %edi
  802025:	56                   	push   %esi
  802026:	53                   	push   %ebx
  802027:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80202d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802032:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802038:	3b 75 10             	cmp    0x10(%ebp),%esi
  80203b:	73 31                	jae    80206e <devcons_write+0x4d>
		m = n - tot;
  80203d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802040:	29 f3                	sub    %esi,%ebx
  802042:	83 fb 7f             	cmp    $0x7f,%ebx
  802045:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80204a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80204d:	83 ec 04             	sub    $0x4,%esp
  802050:	53                   	push   %ebx
  802051:	89 f0                	mov    %esi,%eax
  802053:	03 45 0c             	add    0xc(%ebp),%eax
  802056:	50                   	push   %eax
  802057:	57                   	push   %edi
  802058:	e8 6a ea ff ff       	call   800ac7 <memmove>
		sys_cputs(buf, m);
  80205d:	83 c4 08             	add    $0x8,%esp
  802060:	53                   	push   %ebx
  802061:	57                   	push   %edi
  802062:	e8 08 ec ff ff       	call   800c6f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802067:	01 de                	add    %ebx,%esi
  802069:	83 c4 10             	add    $0x10,%esp
  80206c:	eb ca                	jmp    802038 <devcons_write+0x17>
}
  80206e:	89 f0                	mov    %esi,%eax
  802070:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802073:	5b                   	pop    %ebx
  802074:	5e                   	pop    %esi
  802075:	5f                   	pop    %edi
  802076:	5d                   	pop    %ebp
  802077:	c3                   	ret    

00802078 <devcons_read>:
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 08             	sub    $0x8,%esp
  80207e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802083:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802087:	74 21                	je     8020aa <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802089:	e8 ff eb ff ff       	call   800c8d <sys_cgetc>
  80208e:	85 c0                	test   %eax,%eax
  802090:	75 07                	jne    802099 <devcons_read+0x21>
		sys_yield();
  802092:	e8 75 ec ff ff       	call   800d0c <sys_yield>
  802097:	eb f0                	jmp    802089 <devcons_read+0x11>
	if (c < 0)
  802099:	78 0f                	js     8020aa <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80209b:	83 f8 04             	cmp    $0x4,%eax
  80209e:	74 0c                	je     8020ac <devcons_read+0x34>
	*(char*)vbuf = c;
  8020a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a3:	88 02                	mov    %al,(%edx)
	return 1;
  8020a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    
		return 0;
  8020ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b1:	eb f7                	jmp    8020aa <devcons_read+0x32>

008020b3 <cputchar>:
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020bf:	6a 01                	push   $0x1
  8020c1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020c4:	50                   	push   %eax
  8020c5:	e8 a5 eb ff ff       	call   800c6f <sys_cputs>
}
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <getchar>:
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020d5:	6a 01                	push   $0x1
  8020d7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020da:	50                   	push   %eax
  8020db:	6a 00                	push   $0x0
  8020dd:	e8 27 f2 ff ff       	call   801309 <read>
	if (r < 0)
  8020e2:	83 c4 10             	add    $0x10,%esp
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	78 06                	js     8020ef <getchar+0x20>
	if (r < 1)
  8020e9:	74 06                	je     8020f1 <getchar+0x22>
	return c;
  8020eb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    
		return -E_EOF;
  8020f1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020f6:	eb f7                	jmp    8020ef <getchar+0x20>

008020f8 <iscons>:
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802101:	50                   	push   %eax
  802102:	ff 75 08             	pushl  0x8(%ebp)
  802105:	e8 8f ef ff ff       	call   801099 <fd_lookup>
  80210a:	83 c4 10             	add    $0x10,%esp
  80210d:	85 c0                	test   %eax,%eax
  80210f:	78 11                	js     802122 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802114:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80211a:	39 10                	cmp    %edx,(%eax)
  80211c:	0f 94 c0             	sete   %al
  80211f:	0f b6 c0             	movzbl %al,%eax
}
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <opencons>:
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80212a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80212d:	50                   	push   %eax
  80212e:	e8 14 ef ff ff       	call   801047 <fd_alloc>
  802133:	83 c4 10             	add    $0x10,%esp
  802136:	85 c0                	test   %eax,%eax
  802138:	78 3a                	js     802174 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80213a:	83 ec 04             	sub    $0x4,%esp
  80213d:	68 07 04 00 00       	push   $0x407
  802142:	ff 75 f4             	pushl  -0xc(%ebp)
  802145:	6a 00                	push   $0x0
  802147:	e8 df eb ff ff       	call   800d2b <sys_page_alloc>
  80214c:	83 c4 10             	add    $0x10,%esp
  80214f:	85 c0                	test   %eax,%eax
  802151:	78 21                	js     802174 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802156:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80215c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80215e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802161:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802168:	83 ec 0c             	sub    $0xc,%esp
  80216b:	50                   	push   %eax
  80216c:	e8 af ee ff ff       	call   801020 <fd2num>
  802171:	83 c4 10             	add    $0x10,%esp
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	56                   	push   %esi
  80217a:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80217b:	a1 08 40 80 00       	mov    0x804008,%eax
  802180:	8b 40 48             	mov    0x48(%eax),%eax
  802183:	83 ec 04             	sub    $0x4,%esp
  802186:	68 e0 2a 80 00       	push   $0x802ae0
  80218b:	50                   	push   %eax
  80218c:	68 d8 25 80 00       	push   $0x8025d8
  802191:	e8 44 e0 ff ff       	call   8001da <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802196:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802199:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80219f:	e8 49 eb ff ff       	call   800ced <sys_getenvid>
  8021a4:	83 c4 04             	add    $0x4,%esp
  8021a7:	ff 75 0c             	pushl  0xc(%ebp)
  8021aa:	ff 75 08             	pushl  0x8(%ebp)
  8021ad:	56                   	push   %esi
  8021ae:	50                   	push   %eax
  8021af:	68 bc 2a 80 00       	push   $0x802abc
  8021b4:	e8 21 e0 ff ff       	call   8001da <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021b9:	83 c4 18             	add    $0x18,%esp
  8021bc:	53                   	push   %ebx
  8021bd:	ff 75 10             	pushl  0x10(%ebp)
  8021c0:	e8 c4 df ff ff       	call   800189 <vcprintf>
	cprintf("\n");
  8021c5:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  8021cc:	e8 09 e0 ff ff       	call   8001da <cprintf>
  8021d1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021d4:	cc                   	int3   
  8021d5:	eb fd                	jmp    8021d4 <_panic+0x5e>

008021d7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
  8021da:	56                   	push   %esi
  8021db:	53                   	push   %ebx
  8021dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8021df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021e5:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021e7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021ec:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021ef:	83 ec 0c             	sub    $0xc,%esp
  8021f2:	50                   	push   %eax
  8021f3:	e8 e3 ec ff ff       	call   800edb <sys_ipc_recv>
	if(ret < 0){
  8021f8:	83 c4 10             	add    $0x10,%esp
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	78 2b                	js     80222a <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021ff:	85 f6                	test   %esi,%esi
  802201:	74 0a                	je     80220d <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802203:	a1 08 40 80 00       	mov    0x804008,%eax
  802208:	8b 40 78             	mov    0x78(%eax),%eax
  80220b:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80220d:	85 db                	test   %ebx,%ebx
  80220f:	74 0a                	je     80221b <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802211:	a1 08 40 80 00       	mov    0x804008,%eax
  802216:	8b 40 7c             	mov    0x7c(%eax),%eax
  802219:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80221b:	a1 08 40 80 00       	mov    0x804008,%eax
  802220:	8b 40 74             	mov    0x74(%eax),%eax
}
  802223:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802226:	5b                   	pop    %ebx
  802227:	5e                   	pop    %esi
  802228:	5d                   	pop    %ebp
  802229:	c3                   	ret    
		if(from_env_store)
  80222a:	85 f6                	test   %esi,%esi
  80222c:	74 06                	je     802234 <ipc_recv+0x5d>
			*from_env_store = 0;
  80222e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802234:	85 db                	test   %ebx,%ebx
  802236:	74 eb                	je     802223 <ipc_recv+0x4c>
			*perm_store = 0;
  802238:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80223e:	eb e3                	jmp    802223 <ipc_recv+0x4c>

00802240 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
  802243:	57                   	push   %edi
  802244:	56                   	push   %esi
  802245:	53                   	push   %ebx
  802246:	83 ec 0c             	sub    $0xc,%esp
  802249:	8b 7d 08             	mov    0x8(%ebp),%edi
  80224c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80224f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802252:	85 db                	test   %ebx,%ebx
  802254:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802259:	0f 44 d8             	cmove  %eax,%ebx
  80225c:	eb 05                	jmp    802263 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80225e:	e8 a9 ea ff ff       	call   800d0c <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802263:	ff 75 14             	pushl  0x14(%ebp)
  802266:	53                   	push   %ebx
  802267:	56                   	push   %esi
  802268:	57                   	push   %edi
  802269:	e8 4a ec ff ff       	call   800eb8 <sys_ipc_try_send>
  80226e:	83 c4 10             	add    $0x10,%esp
  802271:	85 c0                	test   %eax,%eax
  802273:	74 1b                	je     802290 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802275:	79 e7                	jns    80225e <ipc_send+0x1e>
  802277:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80227a:	74 e2                	je     80225e <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80227c:	83 ec 04             	sub    $0x4,%esp
  80227f:	68 e7 2a 80 00       	push   $0x802ae7
  802284:	6a 46                	push   $0x46
  802286:	68 fc 2a 80 00       	push   $0x802afc
  80228b:	e8 e6 fe ff ff       	call   802176 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802290:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802293:	5b                   	pop    %ebx
  802294:	5e                   	pop    %esi
  802295:	5f                   	pop    %edi
  802296:	5d                   	pop    %ebp
  802297:	c3                   	ret    

00802298 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022a3:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8022a9:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022af:	8b 52 50             	mov    0x50(%edx),%edx
  8022b2:	39 ca                	cmp    %ecx,%edx
  8022b4:	74 11                	je     8022c7 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022b6:	83 c0 01             	add    $0x1,%eax
  8022b9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022be:	75 e3                	jne    8022a3 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c5:	eb 0e                	jmp    8022d5 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8022c7:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8022cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022d2:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022d5:	5d                   	pop    %ebp
  8022d6:	c3                   	ret    

008022d7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
  8022da:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022dd:	89 d0                	mov    %edx,%eax
  8022df:	c1 e8 16             	shr    $0x16,%eax
  8022e2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022e9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022ee:	f6 c1 01             	test   $0x1,%cl
  8022f1:	74 1d                	je     802310 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022f3:	c1 ea 0c             	shr    $0xc,%edx
  8022f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022fd:	f6 c2 01             	test   $0x1,%dl
  802300:	74 0e                	je     802310 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802302:	c1 ea 0c             	shr    $0xc,%edx
  802305:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80230c:	ef 
  80230d:	0f b7 c0             	movzwl %ax,%eax
}
  802310:	5d                   	pop    %ebp
  802311:	c3                   	ret    
  802312:	66 90                	xchg   %ax,%ax
  802314:	66 90                	xchg   %ax,%ax
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
