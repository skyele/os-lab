
obj/user/badsegment.debug:     file format elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void
umain(int argc, char **argv)
{
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800033:	66 b8 28 00          	mov    $0x28,%ax
  800037:	8e d8                	mov    %eax,%ds
}
  800039:	c3                   	ret    

0080003a <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	57                   	push   %edi
  80003e:	56                   	push   %esi
  80003f:	53                   	push   %ebx
  800040:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800043:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80004a:	00 00 00 
	envid_t find = sys_getenvid();
  80004d:	e8 9f 0c 00 00       	call   800cf1 <sys_getenvid>
  800052:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800058:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80005d:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800062:	bf 01 00 00 00       	mov    $0x1,%edi
  800067:	eb 0b                	jmp    800074 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800069:	83 c2 01             	add    $0x1,%edx
  80006c:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800072:	74 23                	je     800097 <libmain+0x5d>
		if(envs[i].env_id == find)
  800074:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  80007a:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800080:	8b 49 48             	mov    0x48(%ecx),%ecx
  800083:	39 c1                	cmp    %eax,%ecx
  800085:	75 e2                	jne    800069 <libmain+0x2f>
  800087:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  80008d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800093:	89 fe                	mov    %edi,%esi
  800095:	eb d2                	jmp    800069 <libmain+0x2f>
  800097:	89 f0                	mov    %esi,%eax
  800099:	84 c0                	test   %al,%al
  80009b:	74 06                	je     8000a3 <libmain+0x69>
  80009d:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a7:	7e 0a                	jle    8000b3 <libmain+0x79>
		binaryname = argv[0];
  8000a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ac:	8b 00                	mov    (%eax),%eax
  8000ae:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000b3:	a1 08 40 80 00       	mov    0x804008,%eax
  8000b8:	8b 40 48             	mov    0x48(%eax),%eax
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	50                   	push   %eax
  8000bf:	68 80 25 80 00       	push   $0x802580
  8000c4:	e8 15 01 00 00       	call   8001de <cprintf>
	cprintf("before umain\n");
  8000c9:	c7 04 24 9e 25 80 00 	movl   $0x80259e,(%esp)
  8000d0:	e8 09 01 00 00       	call   8001de <cprintf>
	// call user main routine
	umain(argc, argv);
  8000d5:	83 c4 08             	add    $0x8,%esp
  8000d8:	ff 75 0c             	pushl  0xc(%ebp)
  8000db:	ff 75 08             	pushl  0x8(%ebp)
  8000de:	e8 50 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000e3:	c7 04 24 ac 25 80 00 	movl   $0x8025ac,(%esp)
  8000ea:	e8 ef 00 00 00       	call   8001de <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8000ef:	a1 08 40 80 00       	mov    0x804008,%eax
  8000f4:	8b 40 48             	mov    0x48(%eax),%eax
  8000f7:	83 c4 08             	add    $0x8,%esp
  8000fa:	50                   	push   %eax
  8000fb:	68 b9 25 80 00       	push   $0x8025b9
  800100:	e8 d9 00 00 00       	call   8001de <cprintf>
	// exit gracefully
	exit();
  800105:	e8 0b 00 00 00       	call   800115 <exit>
}
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800110:	5b                   	pop    %ebx
  800111:	5e                   	pop    %esi
  800112:	5f                   	pop    %edi
  800113:	5d                   	pop    %ebp
  800114:	c3                   	ret    

00800115 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800115:	55                   	push   %ebp
  800116:	89 e5                	mov    %esp,%ebp
  800118:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80011b:	a1 08 40 80 00       	mov    0x804008,%eax
  800120:	8b 40 48             	mov    0x48(%eax),%eax
  800123:	68 e4 25 80 00       	push   $0x8025e4
  800128:	50                   	push   %eax
  800129:	68 d8 25 80 00       	push   $0x8025d8
  80012e:	e8 ab 00 00 00       	call   8001de <cprintf>
	close_all();
  800133:	e8 c4 10 00 00       	call   8011fc <close_all>
	sys_env_destroy(0);
  800138:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80013f:	e8 6c 0b 00 00       	call   800cb0 <sys_env_destroy>
}
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	c9                   	leave  
  800148:	c3                   	ret    

00800149 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	53                   	push   %ebx
  80014d:	83 ec 04             	sub    $0x4,%esp
  800150:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800153:	8b 13                	mov    (%ebx),%edx
  800155:	8d 42 01             	lea    0x1(%edx),%eax
  800158:	89 03                	mov    %eax,(%ebx)
  80015a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80015d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800161:	3d ff 00 00 00       	cmp    $0xff,%eax
  800166:	74 09                	je     800171 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800168:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80016c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80016f:	c9                   	leave  
  800170:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800171:	83 ec 08             	sub    $0x8,%esp
  800174:	68 ff 00 00 00       	push   $0xff
  800179:	8d 43 08             	lea    0x8(%ebx),%eax
  80017c:	50                   	push   %eax
  80017d:	e8 f1 0a 00 00       	call   800c73 <sys_cputs>
		b->idx = 0;
  800182:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800188:	83 c4 10             	add    $0x10,%esp
  80018b:	eb db                	jmp    800168 <putch+0x1f>

0080018d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80018d:	55                   	push   %ebp
  80018e:	89 e5                	mov    %esp,%ebp
  800190:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800196:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80019d:	00 00 00 
	b.cnt = 0;
  8001a0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001aa:	ff 75 0c             	pushl  0xc(%ebp)
  8001ad:	ff 75 08             	pushl  0x8(%ebp)
  8001b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b6:	50                   	push   %eax
  8001b7:	68 49 01 80 00       	push   $0x800149
  8001bc:	e8 4a 01 00 00       	call   80030b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001c1:	83 c4 08             	add    $0x8,%esp
  8001c4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001ca:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001d0:	50                   	push   %eax
  8001d1:	e8 9d 0a 00 00       	call   800c73 <sys_cputs>

	return b.cnt;
}
  8001d6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001e4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001e7:	50                   	push   %eax
  8001e8:	ff 75 08             	pushl  0x8(%ebp)
  8001eb:	e8 9d ff ff ff       	call   80018d <vcprintf>
	va_end(ap);

	return cnt;
}
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	57                   	push   %edi
  8001f6:	56                   	push   %esi
  8001f7:	53                   	push   %ebx
  8001f8:	83 ec 1c             	sub    $0x1c,%esp
  8001fb:	89 c6                	mov    %eax,%esi
  8001fd:	89 d7                	mov    %edx,%edi
  8001ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800202:	8b 55 0c             	mov    0xc(%ebp),%edx
  800205:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800208:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80020b:	8b 45 10             	mov    0x10(%ebp),%eax
  80020e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800211:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800215:	74 2c                	je     800243 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800217:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80021a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800221:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800224:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800227:	39 c2                	cmp    %eax,%edx
  800229:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80022c:	73 43                	jae    800271 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80022e:	83 eb 01             	sub    $0x1,%ebx
  800231:	85 db                	test   %ebx,%ebx
  800233:	7e 6c                	jle    8002a1 <printnum+0xaf>
				putch(padc, putdat);
  800235:	83 ec 08             	sub    $0x8,%esp
  800238:	57                   	push   %edi
  800239:	ff 75 18             	pushl  0x18(%ebp)
  80023c:	ff d6                	call   *%esi
  80023e:	83 c4 10             	add    $0x10,%esp
  800241:	eb eb                	jmp    80022e <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800243:	83 ec 0c             	sub    $0xc,%esp
  800246:	6a 20                	push   $0x20
  800248:	6a 00                	push   $0x0
  80024a:	50                   	push   %eax
  80024b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024e:	ff 75 e0             	pushl  -0x20(%ebp)
  800251:	89 fa                	mov    %edi,%edx
  800253:	89 f0                	mov    %esi,%eax
  800255:	e8 98 ff ff ff       	call   8001f2 <printnum>
		while (--width > 0)
  80025a:	83 c4 20             	add    $0x20,%esp
  80025d:	83 eb 01             	sub    $0x1,%ebx
  800260:	85 db                	test   %ebx,%ebx
  800262:	7e 65                	jle    8002c9 <printnum+0xd7>
			putch(padc, putdat);
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	57                   	push   %edi
  800268:	6a 20                	push   $0x20
  80026a:	ff d6                	call   *%esi
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	eb ec                	jmp    80025d <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800271:	83 ec 0c             	sub    $0xc,%esp
  800274:	ff 75 18             	pushl  0x18(%ebp)
  800277:	83 eb 01             	sub    $0x1,%ebx
  80027a:	53                   	push   %ebx
  80027b:	50                   	push   %eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	ff 75 dc             	pushl  -0x24(%ebp)
  800282:	ff 75 d8             	pushl  -0x28(%ebp)
  800285:	ff 75 e4             	pushl  -0x1c(%ebp)
  800288:	ff 75 e0             	pushl  -0x20(%ebp)
  80028b:	e8 90 20 00 00       	call   802320 <__udivdi3>
  800290:	83 c4 18             	add    $0x18,%esp
  800293:	52                   	push   %edx
  800294:	50                   	push   %eax
  800295:	89 fa                	mov    %edi,%edx
  800297:	89 f0                	mov    %esi,%eax
  800299:	e8 54 ff ff ff       	call   8001f2 <printnum>
  80029e:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002a1:	83 ec 08             	sub    $0x8,%esp
  8002a4:	57                   	push   %edi
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b1:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b4:	e8 77 21 00 00       	call   802430 <__umoddi3>
  8002b9:	83 c4 14             	add    $0x14,%esp
  8002bc:	0f be 80 e9 25 80 00 	movsbl 0x8025e9(%eax),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff d6                	call   *%esi
  8002c6:	83 c4 10             	add    $0x10,%esp
	}
}
  8002c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cc:	5b                   	pop    %ebx
  8002cd:	5e                   	pop    %esi
  8002ce:	5f                   	pop    %edi
  8002cf:	5d                   	pop    %ebp
  8002d0:	c3                   	ret    

008002d1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002db:	8b 10                	mov    (%eax),%edx
  8002dd:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e0:	73 0a                	jae    8002ec <sprintputch+0x1b>
		*b->buf++ = ch;
  8002e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e5:	89 08                	mov    %ecx,(%eax)
  8002e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ea:	88 02                	mov    %al,(%edx)
}
  8002ec:	5d                   	pop    %ebp
  8002ed:	c3                   	ret    

008002ee <printfmt>:
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002f4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002f7:	50                   	push   %eax
  8002f8:	ff 75 10             	pushl  0x10(%ebp)
  8002fb:	ff 75 0c             	pushl  0xc(%ebp)
  8002fe:	ff 75 08             	pushl  0x8(%ebp)
  800301:	e8 05 00 00 00       	call   80030b <vprintfmt>
}
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	c9                   	leave  
  80030a:	c3                   	ret    

0080030b <vprintfmt>:
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	57                   	push   %edi
  80030f:	56                   	push   %esi
  800310:	53                   	push   %ebx
  800311:	83 ec 3c             	sub    $0x3c,%esp
  800314:	8b 75 08             	mov    0x8(%ebp),%esi
  800317:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80031a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80031d:	e9 32 04 00 00       	jmp    800754 <vprintfmt+0x449>
		padc = ' ';
  800322:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800326:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80032d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800334:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80033b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800342:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800349:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80034e:	8d 47 01             	lea    0x1(%edi),%eax
  800351:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800354:	0f b6 17             	movzbl (%edi),%edx
  800357:	8d 42 dd             	lea    -0x23(%edx),%eax
  80035a:	3c 55                	cmp    $0x55,%al
  80035c:	0f 87 12 05 00 00    	ja     800874 <vprintfmt+0x569>
  800362:	0f b6 c0             	movzbl %al,%eax
  800365:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
  80036c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80036f:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800373:	eb d9                	jmp    80034e <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800375:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800378:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80037c:	eb d0                	jmp    80034e <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80037e:	0f b6 d2             	movzbl %dl,%edx
  800381:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800384:	b8 00 00 00 00       	mov    $0x0,%eax
  800389:	89 75 08             	mov    %esi,0x8(%ebp)
  80038c:	eb 03                	jmp    800391 <vprintfmt+0x86>
  80038e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800391:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800394:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800398:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80039b:	8d 72 d0             	lea    -0x30(%edx),%esi
  80039e:	83 fe 09             	cmp    $0x9,%esi
  8003a1:	76 eb                	jbe    80038e <vprintfmt+0x83>
  8003a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8003a9:	eb 14                	jmp    8003bf <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ae:	8b 00                	mov    (%eax),%eax
  8003b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b6:	8d 40 04             	lea    0x4(%eax),%eax
  8003b9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003bf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c3:	79 89                	jns    80034e <vprintfmt+0x43>
				width = precision, precision = -1;
  8003c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003cb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003d2:	e9 77 ff ff ff       	jmp    80034e <vprintfmt+0x43>
  8003d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003da:	85 c0                	test   %eax,%eax
  8003dc:	0f 48 c1             	cmovs  %ecx,%eax
  8003df:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e5:	e9 64 ff ff ff       	jmp    80034e <vprintfmt+0x43>
  8003ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ed:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003f4:	e9 55 ff ff ff       	jmp    80034e <vprintfmt+0x43>
			lflag++;
  8003f9:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800400:	e9 49 ff ff ff       	jmp    80034e <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800405:	8b 45 14             	mov    0x14(%ebp),%eax
  800408:	8d 78 04             	lea    0x4(%eax),%edi
  80040b:	83 ec 08             	sub    $0x8,%esp
  80040e:	53                   	push   %ebx
  80040f:	ff 30                	pushl  (%eax)
  800411:	ff d6                	call   *%esi
			break;
  800413:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800416:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800419:	e9 33 03 00 00       	jmp    800751 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80041e:	8b 45 14             	mov    0x14(%ebp),%eax
  800421:	8d 78 04             	lea    0x4(%eax),%edi
  800424:	8b 00                	mov    (%eax),%eax
  800426:	99                   	cltd   
  800427:	31 d0                	xor    %edx,%eax
  800429:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80042b:	83 f8 11             	cmp    $0x11,%eax
  80042e:	7f 23                	jg     800453 <vprintfmt+0x148>
  800430:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  800437:	85 d2                	test   %edx,%edx
  800439:	74 18                	je     800453 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80043b:	52                   	push   %edx
  80043c:	68 3d 2a 80 00       	push   $0x802a3d
  800441:	53                   	push   %ebx
  800442:	56                   	push   %esi
  800443:	e8 a6 fe ff ff       	call   8002ee <printfmt>
  800448:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80044b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044e:	e9 fe 02 00 00       	jmp    800751 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800453:	50                   	push   %eax
  800454:	68 01 26 80 00       	push   $0x802601
  800459:	53                   	push   %ebx
  80045a:	56                   	push   %esi
  80045b:	e8 8e fe ff ff       	call   8002ee <printfmt>
  800460:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800463:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800466:	e9 e6 02 00 00       	jmp    800751 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80046b:	8b 45 14             	mov    0x14(%ebp),%eax
  80046e:	83 c0 04             	add    $0x4,%eax
  800471:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800479:	85 c9                	test   %ecx,%ecx
  80047b:	b8 fa 25 80 00       	mov    $0x8025fa,%eax
  800480:	0f 45 c1             	cmovne %ecx,%eax
  800483:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800486:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80048a:	7e 06                	jle    800492 <vprintfmt+0x187>
  80048c:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800490:	75 0d                	jne    80049f <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800492:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800495:	89 c7                	mov    %eax,%edi
  800497:	03 45 e0             	add    -0x20(%ebp),%eax
  80049a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049d:	eb 53                	jmp    8004f2 <vprintfmt+0x1e7>
  80049f:	83 ec 08             	sub    $0x8,%esp
  8004a2:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a5:	50                   	push   %eax
  8004a6:	e8 71 04 00 00       	call   80091c <strnlen>
  8004ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ae:	29 c1                	sub    %eax,%ecx
  8004b0:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004b3:	83 c4 10             	add    $0x10,%esp
  8004b6:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004b8:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bf:	eb 0f                	jmp    8004d0 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	53                   	push   %ebx
  8004c5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ca:	83 ef 01             	sub    $0x1,%edi
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	85 ff                	test   %edi,%edi
  8004d2:	7f ed                	jg     8004c1 <vprintfmt+0x1b6>
  8004d4:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004d7:	85 c9                	test   %ecx,%ecx
  8004d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004de:	0f 49 c1             	cmovns %ecx,%eax
  8004e1:	29 c1                	sub    %eax,%ecx
  8004e3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004e6:	eb aa                	jmp    800492 <vprintfmt+0x187>
					putch(ch, putdat);
  8004e8:	83 ec 08             	sub    $0x8,%esp
  8004eb:	53                   	push   %ebx
  8004ec:	52                   	push   %edx
  8004ed:	ff d6                	call   *%esi
  8004ef:	83 c4 10             	add    $0x10,%esp
  8004f2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f7:	83 c7 01             	add    $0x1,%edi
  8004fa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004fe:	0f be d0             	movsbl %al,%edx
  800501:	85 d2                	test   %edx,%edx
  800503:	74 4b                	je     800550 <vprintfmt+0x245>
  800505:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800509:	78 06                	js     800511 <vprintfmt+0x206>
  80050b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80050f:	78 1e                	js     80052f <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800511:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800515:	74 d1                	je     8004e8 <vprintfmt+0x1dd>
  800517:	0f be c0             	movsbl %al,%eax
  80051a:	83 e8 20             	sub    $0x20,%eax
  80051d:	83 f8 5e             	cmp    $0x5e,%eax
  800520:	76 c6                	jbe    8004e8 <vprintfmt+0x1dd>
					putch('?', putdat);
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	53                   	push   %ebx
  800526:	6a 3f                	push   $0x3f
  800528:	ff d6                	call   *%esi
  80052a:	83 c4 10             	add    $0x10,%esp
  80052d:	eb c3                	jmp    8004f2 <vprintfmt+0x1e7>
  80052f:	89 cf                	mov    %ecx,%edi
  800531:	eb 0e                	jmp    800541 <vprintfmt+0x236>
				putch(' ', putdat);
  800533:	83 ec 08             	sub    $0x8,%esp
  800536:	53                   	push   %ebx
  800537:	6a 20                	push   $0x20
  800539:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80053b:	83 ef 01             	sub    $0x1,%edi
  80053e:	83 c4 10             	add    $0x10,%esp
  800541:	85 ff                	test   %edi,%edi
  800543:	7f ee                	jg     800533 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800545:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800548:	89 45 14             	mov    %eax,0x14(%ebp)
  80054b:	e9 01 02 00 00       	jmp    800751 <vprintfmt+0x446>
  800550:	89 cf                	mov    %ecx,%edi
  800552:	eb ed                	jmp    800541 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800554:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800557:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80055e:	e9 eb fd ff ff       	jmp    80034e <vprintfmt+0x43>
	if (lflag >= 2)
  800563:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800567:	7f 21                	jg     80058a <vprintfmt+0x27f>
	else if (lflag)
  800569:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80056d:	74 68                	je     8005d7 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8b 00                	mov    (%eax),%eax
  800574:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800577:	89 c1                	mov    %eax,%ecx
  800579:	c1 f9 1f             	sar    $0x1f,%ecx
  80057c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80057f:	8b 45 14             	mov    0x14(%ebp),%eax
  800582:	8d 40 04             	lea    0x4(%eax),%eax
  800585:	89 45 14             	mov    %eax,0x14(%ebp)
  800588:	eb 17                	jmp    8005a1 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8b 50 04             	mov    0x4(%eax),%edx
  800590:	8b 00                	mov    (%eax),%eax
  800592:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800595:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8d 40 08             	lea    0x8(%eax),%eax
  80059e:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005ad:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005b1:	78 3f                	js     8005f2 <vprintfmt+0x2e7>
			base = 10;
  8005b3:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005b8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005bc:	0f 84 71 01 00 00    	je     800733 <vprintfmt+0x428>
				putch('+', putdat);
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	53                   	push   %ebx
  8005c6:	6a 2b                	push   $0x2b
  8005c8:	ff d6                	call   *%esi
  8005ca:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d2:	e9 5c 01 00 00       	jmp    800733 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005df:	89 c1                	mov    %eax,%ecx
  8005e1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005e4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8d 40 04             	lea    0x4(%eax),%eax
  8005ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f0:	eb af                	jmp    8005a1 <vprintfmt+0x296>
				putch('-', putdat);
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	53                   	push   %ebx
  8005f6:	6a 2d                	push   $0x2d
  8005f8:	ff d6                	call   *%esi
				num = -(long long) num;
  8005fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800600:	f7 d8                	neg    %eax
  800602:	83 d2 00             	adc    $0x0,%edx
  800605:	f7 da                	neg    %edx
  800607:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800610:	b8 0a 00 00 00       	mov    $0xa,%eax
  800615:	e9 19 01 00 00       	jmp    800733 <vprintfmt+0x428>
	if (lflag >= 2)
  80061a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80061e:	7f 29                	jg     800649 <vprintfmt+0x33e>
	else if (lflag)
  800620:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800624:	74 44                	je     80066a <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	ba 00 00 00 00       	mov    $0x0,%edx
  800630:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800633:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8d 40 04             	lea    0x4(%eax),%eax
  80063c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800644:	e9 ea 00 00 00       	jmp    800733 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8b 50 04             	mov    0x4(%eax),%edx
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800654:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8d 40 08             	lea    0x8(%eax),%eax
  80065d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800660:	b8 0a 00 00 00       	mov    $0xa,%eax
  800665:	e9 c9 00 00 00       	jmp    800733 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	ba 00 00 00 00       	mov    $0x0,%edx
  800674:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800677:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8d 40 04             	lea    0x4(%eax),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800683:	b8 0a 00 00 00       	mov    $0xa,%eax
  800688:	e9 a6 00 00 00       	jmp    800733 <vprintfmt+0x428>
			putch('0', putdat);
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	53                   	push   %ebx
  800691:	6a 30                	push   $0x30
  800693:	ff d6                	call   *%esi
	if (lflag >= 2)
  800695:	83 c4 10             	add    $0x10,%esp
  800698:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80069c:	7f 26                	jg     8006c4 <vprintfmt+0x3b9>
	else if (lflag)
  80069e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006a2:	74 3e                	je     8006e2 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006bd:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c2:	eb 6f                	jmp    800733 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8d 40 08             	lea    0x8(%eax),%eax
  8006d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006db:	b8 08 00 00 00       	mov    $0x8,%eax
  8006e0:	eb 51                	jmp    800733 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8d 40 04             	lea    0x4(%eax),%eax
  8006f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006fb:	b8 08 00 00 00       	mov    $0x8,%eax
  800700:	eb 31                	jmp    800733 <vprintfmt+0x428>
			putch('0', putdat);
  800702:	83 ec 08             	sub    $0x8,%esp
  800705:	53                   	push   %ebx
  800706:	6a 30                	push   $0x30
  800708:	ff d6                	call   *%esi
			putch('x', putdat);
  80070a:	83 c4 08             	add    $0x8,%esp
  80070d:	53                   	push   %ebx
  80070e:	6a 78                	push   $0x78
  800710:	ff d6                	call   *%esi
			num = (unsigned long long)
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8b 00                	mov    (%eax),%eax
  800717:	ba 00 00 00 00       	mov    $0x0,%edx
  80071c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800722:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	8d 40 04             	lea    0x4(%eax),%eax
  80072b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800733:	83 ec 0c             	sub    $0xc,%esp
  800736:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80073a:	52                   	push   %edx
  80073b:	ff 75 e0             	pushl  -0x20(%ebp)
  80073e:	50                   	push   %eax
  80073f:	ff 75 dc             	pushl  -0x24(%ebp)
  800742:	ff 75 d8             	pushl  -0x28(%ebp)
  800745:	89 da                	mov    %ebx,%edx
  800747:	89 f0                	mov    %esi,%eax
  800749:	e8 a4 fa ff ff       	call   8001f2 <printnum>
			break;
  80074e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800751:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800754:	83 c7 01             	add    $0x1,%edi
  800757:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80075b:	83 f8 25             	cmp    $0x25,%eax
  80075e:	0f 84 be fb ff ff    	je     800322 <vprintfmt+0x17>
			if (ch == '\0')
  800764:	85 c0                	test   %eax,%eax
  800766:	0f 84 28 01 00 00    	je     800894 <vprintfmt+0x589>
			putch(ch, putdat);
  80076c:	83 ec 08             	sub    $0x8,%esp
  80076f:	53                   	push   %ebx
  800770:	50                   	push   %eax
  800771:	ff d6                	call   *%esi
  800773:	83 c4 10             	add    $0x10,%esp
  800776:	eb dc                	jmp    800754 <vprintfmt+0x449>
	if (lflag >= 2)
  800778:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80077c:	7f 26                	jg     8007a4 <vprintfmt+0x499>
	else if (lflag)
  80077e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800782:	74 41                	je     8007c5 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8b 00                	mov    (%eax),%eax
  800789:	ba 00 00 00 00       	mov    $0x0,%edx
  80078e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800791:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8d 40 04             	lea    0x4(%eax),%eax
  80079a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079d:	b8 10 00 00 00       	mov    $0x10,%eax
  8007a2:	eb 8f                	jmp    800733 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8b 50 04             	mov    0x4(%eax),%edx
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8d 40 08             	lea    0x8(%eax),%eax
  8007b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007bb:	b8 10 00 00 00       	mov    $0x10,%eax
  8007c0:	e9 6e ff ff ff       	jmp    800733 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8d 40 04             	lea    0x4(%eax),%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007de:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e3:	e9 4b ff ff ff       	jmp    800733 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	83 c0 04             	add    $0x4,%eax
  8007ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	85 c0                	test   %eax,%eax
  8007f8:	74 14                	je     80080e <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007fa:	8b 13                	mov    (%ebx),%edx
  8007fc:	83 fa 7f             	cmp    $0x7f,%edx
  8007ff:	7f 37                	jg     800838 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800801:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800803:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
  800809:	e9 43 ff ff ff       	jmp    800751 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80080e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800813:	bf 1d 27 80 00       	mov    $0x80271d,%edi
							putch(ch, putdat);
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	53                   	push   %ebx
  80081c:	50                   	push   %eax
  80081d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80081f:	83 c7 01             	add    $0x1,%edi
  800822:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800826:	83 c4 10             	add    $0x10,%esp
  800829:	85 c0                	test   %eax,%eax
  80082b:	75 eb                	jne    800818 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80082d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800830:	89 45 14             	mov    %eax,0x14(%ebp)
  800833:	e9 19 ff ff ff       	jmp    800751 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800838:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80083a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083f:	bf 55 27 80 00       	mov    $0x802755,%edi
							putch(ch, putdat);
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	53                   	push   %ebx
  800848:	50                   	push   %eax
  800849:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80084b:	83 c7 01             	add    $0x1,%edi
  80084e:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800852:	83 c4 10             	add    $0x10,%esp
  800855:	85 c0                	test   %eax,%eax
  800857:	75 eb                	jne    800844 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800859:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80085c:	89 45 14             	mov    %eax,0x14(%ebp)
  80085f:	e9 ed fe ff ff       	jmp    800751 <vprintfmt+0x446>
			putch(ch, putdat);
  800864:	83 ec 08             	sub    $0x8,%esp
  800867:	53                   	push   %ebx
  800868:	6a 25                	push   $0x25
  80086a:	ff d6                	call   *%esi
			break;
  80086c:	83 c4 10             	add    $0x10,%esp
  80086f:	e9 dd fe ff ff       	jmp    800751 <vprintfmt+0x446>
			putch('%', putdat);
  800874:	83 ec 08             	sub    $0x8,%esp
  800877:	53                   	push   %ebx
  800878:	6a 25                	push   $0x25
  80087a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	89 f8                	mov    %edi,%eax
  800881:	eb 03                	jmp    800886 <vprintfmt+0x57b>
  800883:	83 e8 01             	sub    $0x1,%eax
  800886:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80088a:	75 f7                	jne    800883 <vprintfmt+0x578>
  80088c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80088f:	e9 bd fe ff ff       	jmp    800751 <vprintfmt+0x446>
}
  800894:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800897:	5b                   	pop    %ebx
  800898:	5e                   	pop    %esi
  800899:	5f                   	pop    %edi
  80089a:	5d                   	pop    %ebp
  80089b:	c3                   	ret    

0080089c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	83 ec 18             	sub    $0x18,%esp
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ab:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008af:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008b9:	85 c0                	test   %eax,%eax
  8008bb:	74 26                	je     8008e3 <vsnprintf+0x47>
  8008bd:	85 d2                	test   %edx,%edx
  8008bf:	7e 22                	jle    8008e3 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008c1:	ff 75 14             	pushl  0x14(%ebp)
  8008c4:	ff 75 10             	pushl  0x10(%ebp)
  8008c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ca:	50                   	push   %eax
  8008cb:	68 d1 02 80 00       	push   $0x8002d1
  8008d0:	e8 36 fa ff ff       	call   80030b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008de:	83 c4 10             	add    $0x10,%esp
}
  8008e1:	c9                   	leave  
  8008e2:	c3                   	ret    
		return -E_INVAL;
  8008e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008e8:	eb f7                	jmp    8008e1 <vsnprintf+0x45>

008008ea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008f0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008f3:	50                   	push   %eax
  8008f4:	ff 75 10             	pushl  0x10(%ebp)
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	ff 75 08             	pushl  0x8(%ebp)
  8008fd:	e8 9a ff ff ff       	call   80089c <vsnprintf>
	va_end(ap);

	return rc;
}
  800902:	c9                   	leave  
  800903:	c3                   	ret    

00800904 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80090a:	b8 00 00 00 00       	mov    $0x0,%eax
  80090f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800913:	74 05                	je     80091a <strlen+0x16>
		n++;
  800915:	83 c0 01             	add    $0x1,%eax
  800918:	eb f5                	jmp    80090f <strlen+0xb>
	return n;
}
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    

0080091c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800922:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800925:	ba 00 00 00 00       	mov    $0x0,%edx
  80092a:	39 c2                	cmp    %eax,%edx
  80092c:	74 0d                	je     80093b <strnlen+0x1f>
  80092e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800932:	74 05                	je     800939 <strnlen+0x1d>
		n++;
  800934:	83 c2 01             	add    $0x1,%edx
  800937:	eb f1                	jmp    80092a <strnlen+0xe>
  800939:	89 d0                	mov    %edx,%eax
	return n;
}
  80093b:	5d                   	pop    %ebp
  80093c:	c3                   	ret    

0080093d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80093d:	55                   	push   %ebp
  80093e:	89 e5                	mov    %esp,%ebp
  800940:	53                   	push   %ebx
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800947:	ba 00 00 00 00       	mov    $0x0,%edx
  80094c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800950:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800953:	83 c2 01             	add    $0x1,%edx
  800956:	84 c9                	test   %cl,%cl
  800958:	75 f2                	jne    80094c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80095a:	5b                   	pop    %ebx
  80095b:	5d                   	pop    %ebp
  80095c:	c3                   	ret    

0080095d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80095d:	55                   	push   %ebp
  80095e:	89 e5                	mov    %esp,%ebp
  800960:	53                   	push   %ebx
  800961:	83 ec 10             	sub    $0x10,%esp
  800964:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800967:	53                   	push   %ebx
  800968:	e8 97 ff ff ff       	call   800904 <strlen>
  80096d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800970:	ff 75 0c             	pushl  0xc(%ebp)
  800973:	01 d8                	add    %ebx,%eax
  800975:	50                   	push   %eax
  800976:	e8 c2 ff ff ff       	call   80093d <strcpy>
	return dst;
}
  80097b:	89 d8                	mov    %ebx,%eax
  80097d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800980:	c9                   	leave  
  800981:	c3                   	ret    

00800982 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	56                   	push   %esi
  800986:	53                   	push   %ebx
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80098d:	89 c6                	mov    %eax,%esi
  80098f:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800992:	89 c2                	mov    %eax,%edx
  800994:	39 f2                	cmp    %esi,%edx
  800996:	74 11                	je     8009a9 <strncpy+0x27>
		*dst++ = *src;
  800998:	83 c2 01             	add    $0x1,%edx
  80099b:	0f b6 19             	movzbl (%ecx),%ebx
  80099e:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a1:	80 fb 01             	cmp    $0x1,%bl
  8009a4:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009a7:	eb eb                	jmp    800994 <strncpy+0x12>
	}
	return ret;
}
  8009a9:	5b                   	pop    %ebx
  8009aa:	5e                   	pop    %esi
  8009ab:	5d                   	pop    %ebp
  8009ac:	c3                   	ret    

008009ad <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	56                   	push   %esi
  8009b1:	53                   	push   %ebx
  8009b2:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b8:	8b 55 10             	mov    0x10(%ebp),%edx
  8009bb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009bd:	85 d2                	test   %edx,%edx
  8009bf:	74 21                	je     8009e2 <strlcpy+0x35>
  8009c1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009c5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009c7:	39 c2                	cmp    %eax,%edx
  8009c9:	74 14                	je     8009df <strlcpy+0x32>
  8009cb:	0f b6 19             	movzbl (%ecx),%ebx
  8009ce:	84 db                	test   %bl,%bl
  8009d0:	74 0b                	je     8009dd <strlcpy+0x30>
			*dst++ = *src++;
  8009d2:	83 c1 01             	add    $0x1,%ecx
  8009d5:	83 c2 01             	add    $0x1,%edx
  8009d8:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009db:	eb ea                	jmp    8009c7 <strlcpy+0x1a>
  8009dd:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009df:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e2:	29 f0                	sub    %esi,%eax
}
  8009e4:	5b                   	pop    %ebx
  8009e5:	5e                   	pop    %esi
  8009e6:	5d                   	pop    %ebp
  8009e7:	c3                   	ret    

008009e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ee:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f1:	0f b6 01             	movzbl (%ecx),%eax
  8009f4:	84 c0                	test   %al,%al
  8009f6:	74 0c                	je     800a04 <strcmp+0x1c>
  8009f8:	3a 02                	cmp    (%edx),%al
  8009fa:	75 08                	jne    800a04 <strcmp+0x1c>
		p++, q++;
  8009fc:	83 c1 01             	add    $0x1,%ecx
  8009ff:	83 c2 01             	add    $0x1,%edx
  800a02:	eb ed                	jmp    8009f1 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a04:	0f b6 c0             	movzbl %al,%eax
  800a07:	0f b6 12             	movzbl (%edx),%edx
  800a0a:	29 d0                	sub    %edx,%eax
}
  800a0c:	5d                   	pop    %ebp
  800a0d:	c3                   	ret    

00800a0e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	53                   	push   %ebx
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a18:	89 c3                	mov    %eax,%ebx
  800a1a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a1d:	eb 06                	jmp    800a25 <strncmp+0x17>
		n--, p++, q++;
  800a1f:	83 c0 01             	add    $0x1,%eax
  800a22:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a25:	39 d8                	cmp    %ebx,%eax
  800a27:	74 16                	je     800a3f <strncmp+0x31>
  800a29:	0f b6 08             	movzbl (%eax),%ecx
  800a2c:	84 c9                	test   %cl,%cl
  800a2e:	74 04                	je     800a34 <strncmp+0x26>
  800a30:	3a 0a                	cmp    (%edx),%cl
  800a32:	74 eb                	je     800a1f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a34:	0f b6 00             	movzbl (%eax),%eax
  800a37:	0f b6 12             	movzbl (%edx),%edx
  800a3a:	29 d0                	sub    %edx,%eax
}
  800a3c:	5b                   	pop    %ebx
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    
		return 0;
  800a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a44:	eb f6                	jmp    800a3c <strncmp+0x2e>

00800a46 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a50:	0f b6 10             	movzbl (%eax),%edx
  800a53:	84 d2                	test   %dl,%dl
  800a55:	74 09                	je     800a60 <strchr+0x1a>
		if (*s == c)
  800a57:	38 ca                	cmp    %cl,%dl
  800a59:	74 0a                	je     800a65 <strchr+0x1f>
	for (; *s; s++)
  800a5b:	83 c0 01             	add    $0x1,%eax
  800a5e:	eb f0                	jmp    800a50 <strchr+0xa>
			return (char *) s;
	return 0;
  800a60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a71:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a74:	38 ca                	cmp    %cl,%dl
  800a76:	74 09                	je     800a81 <strfind+0x1a>
  800a78:	84 d2                	test   %dl,%dl
  800a7a:	74 05                	je     800a81 <strfind+0x1a>
	for (; *s; s++)
  800a7c:	83 c0 01             	add    $0x1,%eax
  800a7f:	eb f0                	jmp    800a71 <strfind+0xa>
			break;
	return (char *) s;
}
  800a81:	5d                   	pop    %ebp
  800a82:	c3                   	ret    

00800a83 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	57                   	push   %edi
  800a87:	56                   	push   %esi
  800a88:	53                   	push   %ebx
  800a89:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a8f:	85 c9                	test   %ecx,%ecx
  800a91:	74 31                	je     800ac4 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a93:	89 f8                	mov    %edi,%eax
  800a95:	09 c8                	or     %ecx,%eax
  800a97:	a8 03                	test   $0x3,%al
  800a99:	75 23                	jne    800abe <memset+0x3b>
		c &= 0xFF;
  800a9b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a9f:	89 d3                	mov    %edx,%ebx
  800aa1:	c1 e3 08             	shl    $0x8,%ebx
  800aa4:	89 d0                	mov    %edx,%eax
  800aa6:	c1 e0 18             	shl    $0x18,%eax
  800aa9:	89 d6                	mov    %edx,%esi
  800aab:	c1 e6 10             	shl    $0x10,%esi
  800aae:	09 f0                	or     %esi,%eax
  800ab0:	09 c2                	or     %eax,%edx
  800ab2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ab4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab7:	89 d0                	mov    %edx,%eax
  800ab9:	fc                   	cld    
  800aba:	f3 ab                	rep stos %eax,%es:(%edi)
  800abc:	eb 06                	jmp    800ac4 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800abe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac1:	fc                   	cld    
  800ac2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ac4:	89 f8                	mov    %edi,%eax
  800ac6:	5b                   	pop    %ebx
  800ac7:	5e                   	pop    %esi
  800ac8:	5f                   	pop    %edi
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	57                   	push   %edi
  800acf:	56                   	push   %esi
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ad9:	39 c6                	cmp    %eax,%esi
  800adb:	73 32                	jae    800b0f <memmove+0x44>
  800add:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ae0:	39 c2                	cmp    %eax,%edx
  800ae2:	76 2b                	jbe    800b0f <memmove+0x44>
		s += n;
		d += n;
  800ae4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae7:	89 fe                	mov    %edi,%esi
  800ae9:	09 ce                	or     %ecx,%esi
  800aeb:	09 d6                	or     %edx,%esi
  800aed:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800af3:	75 0e                	jne    800b03 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af5:	83 ef 04             	sub    $0x4,%edi
  800af8:	8d 72 fc             	lea    -0x4(%edx),%esi
  800afb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800afe:	fd                   	std    
  800aff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b01:	eb 09                	jmp    800b0c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b03:	83 ef 01             	sub    $0x1,%edi
  800b06:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b09:	fd                   	std    
  800b0a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b0c:	fc                   	cld    
  800b0d:	eb 1a                	jmp    800b29 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0f:	89 c2                	mov    %eax,%edx
  800b11:	09 ca                	or     %ecx,%edx
  800b13:	09 f2                	or     %esi,%edx
  800b15:	f6 c2 03             	test   $0x3,%dl
  800b18:	75 0a                	jne    800b24 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b1a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b1d:	89 c7                	mov    %eax,%edi
  800b1f:	fc                   	cld    
  800b20:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b22:	eb 05                	jmp    800b29 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b24:	89 c7                	mov    %eax,%edi
  800b26:	fc                   	cld    
  800b27:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b29:	5e                   	pop    %esi
  800b2a:	5f                   	pop    %edi
  800b2b:	5d                   	pop    %ebp
  800b2c:	c3                   	ret    

00800b2d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b33:	ff 75 10             	pushl  0x10(%ebp)
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	ff 75 08             	pushl  0x8(%ebp)
  800b3c:	e8 8a ff ff ff       	call   800acb <memmove>
}
  800b41:	c9                   	leave  
  800b42:	c3                   	ret    

00800b43 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	56                   	push   %esi
  800b47:	53                   	push   %ebx
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4e:	89 c6                	mov    %eax,%esi
  800b50:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b53:	39 f0                	cmp    %esi,%eax
  800b55:	74 1c                	je     800b73 <memcmp+0x30>
		if (*s1 != *s2)
  800b57:	0f b6 08             	movzbl (%eax),%ecx
  800b5a:	0f b6 1a             	movzbl (%edx),%ebx
  800b5d:	38 d9                	cmp    %bl,%cl
  800b5f:	75 08                	jne    800b69 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b61:	83 c0 01             	add    $0x1,%eax
  800b64:	83 c2 01             	add    $0x1,%edx
  800b67:	eb ea                	jmp    800b53 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b69:	0f b6 c1             	movzbl %cl,%eax
  800b6c:	0f b6 db             	movzbl %bl,%ebx
  800b6f:	29 d8                	sub    %ebx,%eax
  800b71:	eb 05                	jmp    800b78 <memcmp+0x35>
	}

	return 0;
  800b73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b78:	5b                   	pop    %ebx
  800b79:	5e                   	pop    %esi
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    

00800b7c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b85:	89 c2                	mov    %eax,%edx
  800b87:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b8a:	39 d0                	cmp    %edx,%eax
  800b8c:	73 09                	jae    800b97 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b8e:	38 08                	cmp    %cl,(%eax)
  800b90:	74 05                	je     800b97 <memfind+0x1b>
	for (; s < ends; s++)
  800b92:	83 c0 01             	add    $0x1,%eax
  800b95:	eb f3                	jmp    800b8a <memfind+0xe>
			break;
	return (void *) s;
}
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	57                   	push   %edi
  800b9d:	56                   	push   %esi
  800b9e:	53                   	push   %ebx
  800b9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ba5:	eb 03                	jmp    800baa <strtol+0x11>
		s++;
  800ba7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800baa:	0f b6 01             	movzbl (%ecx),%eax
  800bad:	3c 20                	cmp    $0x20,%al
  800baf:	74 f6                	je     800ba7 <strtol+0xe>
  800bb1:	3c 09                	cmp    $0x9,%al
  800bb3:	74 f2                	je     800ba7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bb5:	3c 2b                	cmp    $0x2b,%al
  800bb7:	74 2a                	je     800be3 <strtol+0x4a>
	int neg = 0;
  800bb9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bbe:	3c 2d                	cmp    $0x2d,%al
  800bc0:	74 2b                	je     800bed <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bc8:	75 0f                	jne    800bd9 <strtol+0x40>
  800bca:	80 39 30             	cmpb   $0x30,(%ecx)
  800bcd:	74 28                	je     800bf7 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bcf:	85 db                	test   %ebx,%ebx
  800bd1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bd6:	0f 44 d8             	cmove  %eax,%ebx
  800bd9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bde:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800be1:	eb 50                	jmp    800c33 <strtol+0x9a>
		s++;
  800be3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800be6:	bf 00 00 00 00       	mov    $0x0,%edi
  800beb:	eb d5                	jmp    800bc2 <strtol+0x29>
		s++, neg = 1;
  800bed:	83 c1 01             	add    $0x1,%ecx
  800bf0:	bf 01 00 00 00       	mov    $0x1,%edi
  800bf5:	eb cb                	jmp    800bc2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bfb:	74 0e                	je     800c0b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bfd:	85 db                	test   %ebx,%ebx
  800bff:	75 d8                	jne    800bd9 <strtol+0x40>
		s++, base = 8;
  800c01:	83 c1 01             	add    $0x1,%ecx
  800c04:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c09:	eb ce                	jmp    800bd9 <strtol+0x40>
		s += 2, base = 16;
  800c0b:	83 c1 02             	add    $0x2,%ecx
  800c0e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c13:	eb c4                	jmp    800bd9 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c15:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c18:	89 f3                	mov    %esi,%ebx
  800c1a:	80 fb 19             	cmp    $0x19,%bl
  800c1d:	77 29                	ja     800c48 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c1f:	0f be d2             	movsbl %dl,%edx
  800c22:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c25:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c28:	7d 30                	jge    800c5a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c2a:	83 c1 01             	add    $0x1,%ecx
  800c2d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c31:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c33:	0f b6 11             	movzbl (%ecx),%edx
  800c36:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c39:	89 f3                	mov    %esi,%ebx
  800c3b:	80 fb 09             	cmp    $0x9,%bl
  800c3e:	77 d5                	ja     800c15 <strtol+0x7c>
			dig = *s - '0';
  800c40:	0f be d2             	movsbl %dl,%edx
  800c43:	83 ea 30             	sub    $0x30,%edx
  800c46:	eb dd                	jmp    800c25 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c48:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c4b:	89 f3                	mov    %esi,%ebx
  800c4d:	80 fb 19             	cmp    $0x19,%bl
  800c50:	77 08                	ja     800c5a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c52:	0f be d2             	movsbl %dl,%edx
  800c55:	83 ea 37             	sub    $0x37,%edx
  800c58:	eb cb                	jmp    800c25 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5e:	74 05                	je     800c65 <strtol+0xcc>
		*endptr = (char *) s;
  800c60:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c63:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c65:	89 c2                	mov    %eax,%edx
  800c67:	f7 da                	neg    %edx
  800c69:	85 ff                	test   %edi,%edi
  800c6b:	0f 45 c2             	cmovne %edx,%eax
}
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	57                   	push   %edi
  800c77:	56                   	push   %esi
  800c78:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c79:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c84:	89 c3                	mov    %eax,%ebx
  800c86:	89 c7                	mov    %eax,%edi
  800c88:	89 c6                	mov    %eax,%esi
  800c8a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c8c:	5b                   	pop    %ebx
  800c8d:	5e                   	pop    %esi
  800c8e:	5f                   	pop    %edi
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    

00800c91 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	57                   	push   %edi
  800c95:	56                   	push   %esi
  800c96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c97:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9c:	b8 01 00 00 00       	mov    $0x1,%eax
  800ca1:	89 d1                	mov    %edx,%ecx
  800ca3:	89 d3                	mov    %edx,%ebx
  800ca5:	89 d7                	mov    %edx,%edi
  800ca7:	89 d6                	mov    %edx,%esi
  800ca9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cab:	5b                   	pop    %ebx
  800cac:	5e                   	pop    %esi
  800cad:	5f                   	pop    %edi
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc6:	89 cb                	mov    %ecx,%ebx
  800cc8:	89 cf                	mov    %ecx,%edi
  800cca:	89 ce                	mov    %ecx,%esi
  800ccc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cce:	85 c0                	test   %eax,%eax
  800cd0:	7f 08                	jg     800cda <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd5:	5b                   	pop    %ebx
  800cd6:	5e                   	pop    %esi
  800cd7:	5f                   	pop    %edi
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cda:	83 ec 0c             	sub    $0xc,%esp
  800cdd:	50                   	push   %eax
  800cde:	6a 03                	push   $0x3
  800ce0:	68 68 29 80 00       	push   $0x802968
  800ce5:	6a 43                	push   $0x43
  800ce7:	68 85 29 80 00       	push   $0x802985
  800cec:	e8 89 14 00 00       	call   80217a <_panic>

00800cf1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	57                   	push   %edi
  800cf5:	56                   	push   %esi
  800cf6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfc:	b8 02 00 00 00       	mov    $0x2,%eax
  800d01:	89 d1                	mov    %edx,%ecx
  800d03:	89 d3                	mov    %edx,%ebx
  800d05:	89 d7                	mov    %edx,%edi
  800d07:	89 d6                	mov    %edx,%esi
  800d09:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d0b:	5b                   	pop    %ebx
  800d0c:	5e                   	pop    %esi
  800d0d:	5f                   	pop    %edi
  800d0e:	5d                   	pop    %ebp
  800d0f:	c3                   	ret    

00800d10 <sys_yield>:

void
sys_yield(void)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	57                   	push   %edi
  800d14:	56                   	push   %esi
  800d15:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d16:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d20:	89 d1                	mov    %edx,%ecx
  800d22:	89 d3                	mov    %edx,%ebx
  800d24:	89 d7                	mov    %edx,%edi
  800d26:	89 d6                	mov    %edx,%esi
  800d28:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	57                   	push   %edi
  800d33:	56                   	push   %esi
  800d34:	53                   	push   %ebx
  800d35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d38:	be 00 00 00 00       	mov    $0x0,%esi
  800d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d43:	b8 04 00 00 00       	mov    $0x4,%eax
  800d48:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d4b:	89 f7                	mov    %esi,%edi
  800d4d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	7f 08                	jg     800d5b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d56:	5b                   	pop    %ebx
  800d57:	5e                   	pop    %esi
  800d58:	5f                   	pop    %edi
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5b:	83 ec 0c             	sub    $0xc,%esp
  800d5e:	50                   	push   %eax
  800d5f:	6a 04                	push   $0x4
  800d61:	68 68 29 80 00       	push   $0x802968
  800d66:	6a 43                	push   $0x43
  800d68:	68 85 29 80 00       	push   $0x802985
  800d6d:	e8 08 14 00 00       	call   80217a <_panic>

00800d72 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	57                   	push   %edi
  800d76:	56                   	push   %esi
  800d77:	53                   	push   %ebx
  800d78:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d81:	b8 05 00 00 00       	mov    $0x5,%eax
  800d86:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d89:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d8c:	8b 75 18             	mov    0x18(%ebp),%esi
  800d8f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d91:	85 c0                	test   %eax,%eax
  800d93:	7f 08                	jg     800d9d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d98:	5b                   	pop    %ebx
  800d99:	5e                   	pop    %esi
  800d9a:	5f                   	pop    %edi
  800d9b:	5d                   	pop    %ebp
  800d9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9d:	83 ec 0c             	sub    $0xc,%esp
  800da0:	50                   	push   %eax
  800da1:	6a 05                	push   $0x5
  800da3:	68 68 29 80 00       	push   $0x802968
  800da8:	6a 43                	push   $0x43
  800daa:	68 85 29 80 00       	push   $0x802985
  800daf:	e8 c6 13 00 00       	call   80217a <_panic>

00800db4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	57                   	push   %edi
  800db8:	56                   	push   %esi
  800db9:	53                   	push   %ebx
  800dba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc8:	b8 06 00 00 00       	mov    $0x6,%eax
  800dcd:	89 df                	mov    %ebx,%edi
  800dcf:	89 de                	mov    %ebx,%esi
  800dd1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	7f 08                	jg     800ddf <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dda:	5b                   	pop    %ebx
  800ddb:	5e                   	pop    %esi
  800ddc:	5f                   	pop    %edi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	50                   	push   %eax
  800de3:	6a 06                	push   $0x6
  800de5:	68 68 29 80 00       	push   $0x802968
  800dea:	6a 43                	push   $0x43
  800dec:	68 85 29 80 00       	push   $0x802985
  800df1:	e8 84 13 00 00       	call   80217a <_panic>

00800df6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	57                   	push   %edi
  800dfa:	56                   	push   %esi
  800dfb:	53                   	push   %ebx
  800dfc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e04:	8b 55 08             	mov    0x8(%ebp),%edx
  800e07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0a:	b8 08 00 00 00       	mov    $0x8,%eax
  800e0f:	89 df                	mov    %ebx,%edi
  800e11:	89 de                	mov    %ebx,%esi
  800e13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e15:	85 c0                	test   %eax,%eax
  800e17:	7f 08                	jg     800e21 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1c:	5b                   	pop    %ebx
  800e1d:	5e                   	pop    %esi
  800e1e:	5f                   	pop    %edi
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e21:	83 ec 0c             	sub    $0xc,%esp
  800e24:	50                   	push   %eax
  800e25:	6a 08                	push   $0x8
  800e27:	68 68 29 80 00       	push   $0x802968
  800e2c:	6a 43                	push   $0x43
  800e2e:	68 85 29 80 00       	push   $0x802985
  800e33:	e8 42 13 00 00       	call   80217a <_panic>

00800e38 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	57                   	push   %edi
  800e3c:	56                   	push   %esi
  800e3d:	53                   	push   %ebx
  800e3e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e41:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e46:	8b 55 08             	mov    0x8(%ebp),%edx
  800e49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4c:	b8 09 00 00 00       	mov    $0x9,%eax
  800e51:	89 df                	mov    %ebx,%edi
  800e53:	89 de                	mov    %ebx,%esi
  800e55:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e57:	85 c0                	test   %eax,%eax
  800e59:	7f 08                	jg     800e63 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e63:	83 ec 0c             	sub    $0xc,%esp
  800e66:	50                   	push   %eax
  800e67:	6a 09                	push   $0x9
  800e69:	68 68 29 80 00       	push   $0x802968
  800e6e:	6a 43                	push   $0x43
  800e70:	68 85 29 80 00       	push   $0x802985
  800e75:	e8 00 13 00 00       	call   80217a <_panic>

00800e7a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	57                   	push   %edi
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
  800e80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e88:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e93:	89 df                	mov    %ebx,%edi
  800e95:	89 de                	mov    %ebx,%esi
  800e97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	7f 08                	jg     800ea5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea0:	5b                   	pop    %ebx
  800ea1:	5e                   	pop    %esi
  800ea2:	5f                   	pop    %edi
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea5:	83 ec 0c             	sub    $0xc,%esp
  800ea8:	50                   	push   %eax
  800ea9:	6a 0a                	push   $0xa
  800eab:	68 68 29 80 00       	push   $0x802968
  800eb0:	6a 43                	push   $0x43
  800eb2:	68 85 29 80 00       	push   $0x802985
  800eb7:	e8 be 12 00 00       	call   80217a <_panic>

00800ebc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	57                   	push   %edi
  800ec0:	56                   	push   %esi
  800ec1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec8:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ecd:	be 00 00 00 00       	mov    $0x0,%esi
  800ed2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed8:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eda:	5b                   	pop    %ebx
  800edb:	5e                   	pop    %esi
  800edc:	5f                   	pop    %edi
  800edd:	5d                   	pop    %ebp
  800ede:	c3                   	ret    

00800edf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	57                   	push   %edi
  800ee3:	56                   	push   %esi
  800ee4:	53                   	push   %ebx
  800ee5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef0:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ef5:	89 cb                	mov    %ecx,%ebx
  800ef7:	89 cf                	mov    %ecx,%edi
  800ef9:	89 ce                	mov    %ecx,%esi
  800efb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efd:	85 c0                	test   %eax,%eax
  800eff:	7f 08                	jg     800f09 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f04:	5b                   	pop    %ebx
  800f05:	5e                   	pop    %esi
  800f06:	5f                   	pop    %edi
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f09:	83 ec 0c             	sub    $0xc,%esp
  800f0c:	50                   	push   %eax
  800f0d:	6a 0d                	push   $0xd
  800f0f:	68 68 29 80 00       	push   $0x802968
  800f14:	6a 43                	push   $0x43
  800f16:	68 85 29 80 00       	push   $0x802985
  800f1b:	e8 5a 12 00 00       	call   80217a <_panic>

00800f20 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	57                   	push   %edi
  800f24:	56                   	push   %esi
  800f25:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f26:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f31:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f36:	89 df                	mov    %ebx,%edi
  800f38:	89 de                	mov    %ebx,%esi
  800f3a:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    

00800f41 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	57                   	push   %edi
  800f45:	56                   	push   %esi
  800f46:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f47:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4f:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f54:	89 cb                	mov    %ecx,%ebx
  800f56:	89 cf                	mov    %ecx,%edi
  800f58:	89 ce                	mov    %ecx,%esi
  800f5a:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f5c:	5b                   	pop    %ebx
  800f5d:	5e                   	pop    %esi
  800f5e:	5f                   	pop    %edi
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	57                   	push   %edi
  800f65:	56                   	push   %esi
  800f66:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f67:	ba 00 00 00 00       	mov    $0x0,%edx
  800f6c:	b8 10 00 00 00       	mov    $0x10,%eax
  800f71:	89 d1                	mov    %edx,%ecx
  800f73:	89 d3                	mov    %edx,%ebx
  800f75:	89 d7                	mov    %edx,%edi
  800f77:	89 d6                	mov    %edx,%esi
  800f79:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f7b:	5b                   	pop    %ebx
  800f7c:	5e                   	pop    %esi
  800f7d:	5f                   	pop    %edi
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    

00800f80 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	57                   	push   %edi
  800f84:	56                   	push   %esi
  800f85:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f91:	b8 11 00 00 00       	mov    $0x11,%eax
  800f96:	89 df                	mov    %ebx,%edi
  800f98:	89 de                	mov    %ebx,%esi
  800f9a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f9c:	5b                   	pop    %ebx
  800f9d:	5e                   	pop    %esi
  800f9e:	5f                   	pop    %edi
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    

00800fa1 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	57                   	push   %edi
  800fa5:	56                   	push   %esi
  800fa6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fac:	8b 55 08             	mov    0x8(%ebp),%edx
  800faf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb2:	b8 12 00 00 00       	mov    $0x12,%eax
  800fb7:	89 df                	mov    %ebx,%edi
  800fb9:	89 de                	mov    %ebx,%esi
  800fbb:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fbd:	5b                   	pop    %ebx
  800fbe:	5e                   	pop    %esi
  800fbf:	5f                   	pop    %edi
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    

00800fc2 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	57                   	push   %edi
  800fc6:	56                   	push   %esi
  800fc7:	53                   	push   %ebx
  800fc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fcb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd6:	b8 13 00 00 00       	mov    $0x13,%eax
  800fdb:	89 df                	mov    %ebx,%edi
  800fdd:	89 de                	mov    %ebx,%esi
  800fdf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	7f 08                	jg     800fed <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fe5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe8:	5b                   	pop    %ebx
  800fe9:	5e                   	pop    %esi
  800fea:	5f                   	pop    %edi
  800feb:	5d                   	pop    %ebp
  800fec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fed:	83 ec 0c             	sub    $0xc,%esp
  800ff0:	50                   	push   %eax
  800ff1:	6a 13                	push   $0x13
  800ff3:	68 68 29 80 00       	push   $0x802968
  800ff8:	6a 43                	push   $0x43
  800ffa:	68 85 29 80 00       	push   $0x802985
  800fff:	e8 76 11 00 00       	call   80217a <_panic>

00801004 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	57                   	push   %edi
  801008:	56                   	push   %esi
  801009:	53                   	push   %ebx
	asm volatile("int %1\n"
  80100a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80100f:	8b 55 08             	mov    0x8(%ebp),%edx
  801012:	b8 14 00 00 00       	mov    $0x14,%eax
  801017:	89 cb                	mov    %ecx,%ebx
  801019:	89 cf                	mov    %ecx,%edi
  80101b:	89 ce                	mov    %ecx,%esi
  80101d:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80101f:	5b                   	pop    %ebx
  801020:	5e                   	pop    %esi
  801021:	5f                   	pop    %edi
  801022:	5d                   	pop    %ebp
  801023:	c3                   	ret    

00801024 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	05 00 00 00 30       	add    $0x30000000,%eax
  80102f:	c1 e8 0c             	shr    $0xc,%eax
}
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80103f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801044:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801049:	5d                   	pop    %ebp
  80104a:	c3                   	ret    

0080104b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801053:	89 c2                	mov    %eax,%edx
  801055:	c1 ea 16             	shr    $0x16,%edx
  801058:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80105f:	f6 c2 01             	test   $0x1,%dl
  801062:	74 2d                	je     801091 <fd_alloc+0x46>
  801064:	89 c2                	mov    %eax,%edx
  801066:	c1 ea 0c             	shr    $0xc,%edx
  801069:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801070:	f6 c2 01             	test   $0x1,%dl
  801073:	74 1c                	je     801091 <fd_alloc+0x46>
  801075:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80107a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80107f:	75 d2                	jne    801053 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80108a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80108f:	eb 0a                	jmp    80109b <fd_alloc+0x50>
			*fd_store = fd;
  801091:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801094:	89 01                	mov    %eax,(%ecx)
			return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010a3:	83 f8 1f             	cmp    $0x1f,%eax
  8010a6:	77 30                	ja     8010d8 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010a8:	c1 e0 0c             	shl    $0xc,%eax
  8010ab:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010b0:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010b6:	f6 c2 01             	test   $0x1,%dl
  8010b9:	74 24                	je     8010df <fd_lookup+0x42>
  8010bb:	89 c2                	mov    %eax,%edx
  8010bd:	c1 ea 0c             	shr    $0xc,%edx
  8010c0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010c7:	f6 c2 01             	test   $0x1,%dl
  8010ca:	74 1a                	je     8010e6 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cf:	89 02                	mov    %eax,(%edx)
	return 0;
  8010d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d6:	5d                   	pop    %ebp
  8010d7:	c3                   	ret    
		return -E_INVAL;
  8010d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010dd:	eb f7                	jmp    8010d6 <fd_lookup+0x39>
		return -E_INVAL;
  8010df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e4:	eb f0                	jmp    8010d6 <fd_lookup+0x39>
  8010e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010eb:	eb e9                	jmp    8010d6 <fd_lookup+0x39>

008010ed <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
  8010f0:	83 ec 08             	sub    $0x8,%esp
  8010f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8010fb:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801100:	39 08                	cmp    %ecx,(%eax)
  801102:	74 38                	je     80113c <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801104:	83 c2 01             	add    $0x1,%edx
  801107:	8b 04 95 10 2a 80 00 	mov    0x802a10(,%edx,4),%eax
  80110e:	85 c0                	test   %eax,%eax
  801110:	75 ee                	jne    801100 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801112:	a1 08 40 80 00       	mov    0x804008,%eax
  801117:	8b 40 48             	mov    0x48(%eax),%eax
  80111a:	83 ec 04             	sub    $0x4,%esp
  80111d:	51                   	push   %ecx
  80111e:	50                   	push   %eax
  80111f:	68 94 29 80 00       	push   $0x802994
  801124:	e8 b5 f0 ff ff       	call   8001de <cprintf>
	*dev = 0;
  801129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801132:	83 c4 10             	add    $0x10,%esp
  801135:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80113a:	c9                   	leave  
  80113b:	c3                   	ret    
			*dev = devtab[i];
  80113c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801141:	b8 00 00 00 00       	mov    $0x0,%eax
  801146:	eb f2                	jmp    80113a <dev_lookup+0x4d>

00801148 <fd_close>:
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	57                   	push   %edi
  80114c:	56                   	push   %esi
  80114d:	53                   	push   %ebx
  80114e:	83 ec 24             	sub    $0x24,%esp
  801151:	8b 75 08             	mov    0x8(%ebp),%esi
  801154:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801157:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80115a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80115b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801161:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801164:	50                   	push   %eax
  801165:	e8 33 ff ff ff       	call   80109d <fd_lookup>
  80116a:	89 c3                	mov    %eax,%ebx
  80116c:	83 c4 10             	add    $0x10,%esp
  80116f:	85 c0                	test   %eax,%eax
  801171:	78 05                	js     801178 <fd_close+0x30>
	    || fd != fd2)
  801173:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801176:	74 16                	je     80118e <fd_close+0x46>
		return (must_exist ? r : 0);
  801178:	89 f8                	mov    %edi,%eax
  80117a:	84 c0                	test   %al,%al
  80117c:	b8 00 00 00 00       	mov    $0x0,%eax
  801181:	0f 44 d8             	cmove  %eax,%ebx
}
  801184:	89 d8                	mov    %ebx,%eax
  801186:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801189:	5b                   	pop    %ebx
  80118a:	5e                   	pop    %esi
  80118b:	5f                   	pop    %edi
  80118c:	5d                   	pop    %ebp
  80118d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80118e:	83 ec 08             	sub    $0x8,%esp
  801191:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801194:	50                   	push   %eax
  801195:	ff 36                	pushl  (%esi)
  801197:	e8 51 ff ff ff       	call   8010ed <dev_lookup>
  80119c:	89 c3                	mov    %eax,%ebx
  80119e:	83 c4 10             	add    $0x10,%esp
  8011a1:	85 c0                	test   %eax,%eax
  8011a3:	78 1a                	js     8011bf <fd_close+0x77>
		if (dev->dev_close)
  8011a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011a8:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011ab:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	74 0b                	je     8011bf <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011b4:	83 ec 0c             	sub    $0xc,%esp
  8011b7:	56                   	push   %esi
  8011b8:	ff d0                	call   *%eax
  8011ba:	89 c3                	mov    %eax,%ebx
  8011bc:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011bf:	83 ec 08             	sub    $0x8,%esp
  8011c2:	56                   	push   %esi
  8011c3:	6a 00                	push   $0x0
  8011c5:	e8 ea fb ff ff       	call   800db4 <sys_page_unmap>
	return r;
  8011ca:	83 c4 10             	add    $0x10,%esp
  8011cd:	eb b5                	jmp    801184 <fd_close+0x3c>

008011cf <close>:

int
close(int fdnum)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d8:	50                   	push   %eax
  8011d9:	ff 75 08             	pushl  0x8(%ebp)
  8011dc:	e8 bc fe ff ff       	call   80109d <fd_lookup>
  8011e1:	83 c4 10             	add    $0x10,%esp
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	79 02                	jns    8011ea <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011e8:	c9                   	leave  
  8011e9:	c3                   	ret    
		return fd_close(fd, 1);
  8011ea:	83 ec 08             	sub    $0x8,%esp
  8011ed:	6a 01                	push   $0x1
  8011ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f2:	e8 51 ff ff ff       	call   801148 <fd_close>
  8011f7:	83 c4 10             	add    $0x10,%esp
  8011fa:	eb ec                	jmp    8011e8 <close+0x19>

008011fc <close_all>:

void
close_all(void)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	53                   	push   %ebx
  801200:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801203:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801208:	83 ec 0c             	sub    $0xc,%esp
  80120b:	53                   	push   %ebx
  80120c:	e8 be ff ff ff       	call   8011cf <close>
	for (i = 0; i < MAXFD; i++)
  801211:	83 c3 01             	add    $0x1,%ebx
  801214:	83 c4 10             	add    $0x10,%esp
  801217:	83 fb 20             	cmp    $0x20,%ebx
  80121a:	75 ec                	jne    801208 <close_all+0xc>
}
  80121c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80121f:	c9                   	leave  
  801220:	c3                   	ret    

00801221 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	57                   	push   %edi
  801225:	56                   	push   %esi
  801226:	53                   	push   %ebx
  801227:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80122a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80122d:	50                   	push   %eax
  80122e:	ff 75 08             	pushl  0x8(%ebp)
  801231:	e8 67 fe ff ff       	call   80109d <fd_lookup>
  801236:	89 c3                	mov    %eax,%ebx
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	85 c0                	test   %eax,%eax
  80123d:	0f 88 81 00 00 00    	js     8012c4 <dup+0xa3>
		return r;
	close(newfdnum);
  801243:	83 ec 0c             	sub    $0xc,%esp
  801246:	ff 75 0c             	pushl  0xc(%ebp)
  801249:	e8 81 ff ff ff       	call   8011cf <close>

	newfd = INDEX2FD(newfdnum);
  80124e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801251:	c1 e6 0c             	shl    $0xc,%esi
  801254:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80125a:	83 c4 04             	add    $0x4,%esp
  80125d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801260:	e8 cf fd ff ff       	call   801034 <fd2data>
  801265:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801267:	89 34 24             	mov    %esi,(%esp)
  80126a:	e8 c5 fd ff ff       	call   801034 <fd2data>
  80126f:	83 c4 10             	add    $0x10,%esp
  801272:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801274:	89 d8                	mov    %ebx,%eax
  801276:	c1 e8 16             	shr    $0x16,%eax
  801279:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801280:	a8 01                	test   $0x1,%al
  801282:	74 11                	je     801295 <dup+0x74>
  801284:	89 d8                	mov    %ebx,%eax
  801286:	c1 e8 0c             	shr    $0xc,%eax
  801289:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801290:	f6 c2 01             	test   $0x1,%dl
  801293:	75 39                	jne    8012ce <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801295:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801298:	89 d0                	mov    %edx,%eax
  80129a:	c1 e8 0c             	shr    $0xc,%eax
  80129d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012a4:	83 ec 0c             	sub    $0xc,%esp
  8012a7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ac:	50                   	push   %eax
  8012ad:	56                   	push   %esi
  8012ae:	6a 00                	push   $0x0
  8012b0:	52                   	push   %edx
  8012b1:	6a 00                	push   $0x0
  8012b3:	e8 ba fa ff ff       	call   800d72 <sys_page_map>
  8012b8:	89 c3                	mov    %eax,%ebx
  8012ba:	83 c4 20             	add    $0x20,%esp
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	78 31                	js     8012f2 <dup+0xd1>
		goto err;

	return newfdnum;
  8012c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012c4:	89 d8                	mov    %ebx,%eax
  8012c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c9:	5b                   	pop    %ebx
  8012ca:	5e                   	pop    %esi
  8012cb:	5f                   	pop    %edi
  8012cc:	5d                   	pop    %ebp
  8012cd:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012ce:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	25 07 0e 00 00       	and    $0xe07,%eax
  8012dd:	50                   	push   %eax
  8012de:	57                   	push   %edi
  8012df:	6a 00                	push   $0x0
  8012e1:	53                   	push   %ebx
  8012e2:	6a 00                	push   $0x0
  8012e4:	e8 89 fa ff ff       	call   800d72 <sys_page_map>
  8012e9:	89 c3                	mov    %eax,%ebx
  8012eb:	83 c4 20             	add    $0x20,%esp
  8012ee:	85 c0                	test   %eax,%eax
  8012f0:	79 a3                	jns    801295 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012f2:	83 ec 08             	sub    $0x8,%esp
  8012f5:	56                   	push   %esi
  8012f6:	6a 00                	push   $0x0
  8012f8:	e8 b7 fa ff ff       	call   800db4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012fd:	83 c4 08             	add    $0x8,%esp
  801300:	57                   	push   %edi
  801301:	6a 00                	push   $0x0
  801303:	e8 ac fa ff ff       	call   800db4 <sys_page_unmap>
	return r;
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	eb b7                	jmp    8012c4 <dup+0xa3>

0080130d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	53                   	push   %ebx
  801311:	83 ec 1c             	sub    $0x1c,%esp
  801314:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801317:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80131a:	50                   	push   %eax
  80131b:	53                   	push   %ebx
  80131c:	e8 7c fd ff ff       	call   80109d <fd_lookup>
  801321:	83 c4 10             	add    $0x10,%esp
  801324:	85 c0                	test   %eax,%eax
  801326:	78 3f                	js     801367 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801328:	83 ec 08             	sub    $0x8,%esp
  80132b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80132e:	50                   	push   %eax
  80132f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801332:	ff 30                	pushl  (%eax)
  801334:	e8 b4 fd ff ff       	call   8010ed <dev_lookup>
  801339:	83 c4 10             	add    $0x10,%esp
  80133c:	85 c0                	test   %eax,%eax
  80133e:	78 27                	js     801367 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801340:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801343:	8b 42 08             	mov    0x8(%edx),%eax
  801346:	83 e0 03             	and    $0x3,%eax
  801349:	83 f8 01             	cmp    $0x1,%eax
  80134c:	74 1e                	je     80136c <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80134e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801351:	8b 40 08             	mov    0x8(%eax),%eax
  801354:	85 c0                	test   %eax,%eax
  801356:	74 35                	je     80138d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801358:	83 ec 04             	sub    $0x4,%esp
  80135b:	ff 75 10             	pushl  0x10(%ebp)
  80135e:	ff 75 0c             	pushl  0xc(%ebp)
  801361:	52                   	push   %edx
  801362:	ff d0                	call   *%eax
  801364:	83 c4 10             	add    $0x10,%esp
}
  801367:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80136c:	a1 08 40 80 00       	mov    0x804008,%eax
  801371:	8b 40 48             	mov    0x48(%eax),%eax
  801374:	83 ec 04             	sub    $0x4,%esp
  801377:	53                   	push   %ebx
  801378:	50                   	push   %eax
  801379:	68 d5 29 80 00       	push   $0x8029d5
  80137e:	e8 5b ee ff ff       	call   8001de <cprintf>
		return -E_INVAL;
  801383:	83 c4 10             	add    $0x10,%esp
  801386:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80138b:	eb da                	jmp    801367 <read+0x5a>
		return -E_NOT_SUPP;
  80138d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801392:	eb d3                	jmp    801367 <read+0x5a>

00801394 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	57                   	push   %edi
  801398:	56                   	push   %esi
  801399:	53                   	push   %ebx
  80139a:	83 ec 0c             	sub    $0xc,%esp
  80139d:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013a0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a8:	39 f3                	cmp    %esi,%ebx
  8013aa:	73 23                	jae    8013cf <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013ac:	83 ec 04             	sub    $0x4,%esp
  8013af:	89 f0                	mov    %esi,%eax
  8013b1:	29 d8                	sub    %ebx,%eax
  8013b3:	50                   	push   %eax
  8013b4:	89 d8                	mov    %ebx,%eax
  8013b6:	03 45 0c             	add    0xc(%ebp),%eax
  8013b9:	50                   	push   %eax
  8013ba:	57                   	push   %edi
  8013bb:	e8 4d ff ff ff       	call   80130d <read>
		if (m < 0)
  8013c0:	83 c4 10             	add    $0x10,%esp
  8013c3:	85 c0                	test   %eax,%eax
  8013c5:	78 06                	js     8013cd <readn+0x39>
			return m;
		if (m == 0)
  8013c7:	74 06                	je     8013cf <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013c9:	01 c3                	add    %eax,%ebx
  8013cb:	eb db                	jmp    8013a8 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013cd:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013cf:	89 d8                	mov    %ebx,%eax
  8013d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d4:	5b                   	pop    %ebx
  8013d5:	5e                   	pop    %esi
  8013d6:	5f                   	pop    %edi
  8013d7:	5d                   	pop    %ebp
  8013d8:	c3                   	ret    

008013d9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	53                   	push   %ebx
  8013dd:	83 ec 1c             	sub    $0x1c,%esp
  8013e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013e6:	50                   	push   %eax
  8013e7:	53                   	push   %ebx
  8013e8:	e8 b0 fc ff ff       	call   80109d <fd_lookup>
  8013ed:	83 c4 10             	add    $0x10,%esp
  8013f0:	85 c0                	test   %eax,%eax
  8013f2:	78 3a                	js     80142e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013f4:	83 ec 08             	sub    $0x8,%esp
  8013f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fa:	50                   	push   %eax
  8013fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fe:	ff 30                	pushl  (%eax)
  801400:	e8 e8 fc ff ff       	call   8010ed <dev_lookup>
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	85 c0                	test   %eax,%eax
  80140a:	78 22                	js     80142e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80140c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801413:	74 1e                	je     801433 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801415:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801418:	8b 52 0c             	mov    0xc(%edx),%edx
  80141b:	85 d2                	test   %edx,%edx
  80141d:	74 35                	je     801454 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80141f:	83 ec 04             	sub    $0x4,%esp
  801422:	ff 75 10             	pushl  0x10(%ebp)
  801425:	ff 75 0c             	pushl  0xc(%ebp)
  801428:	50                   	push   %eax
  801429:	ff d2                	call   *%edx
  80142b:	83 c4 10             	add    $0x10,%esp
}
  80142e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801431:	c9                   	leave  
  801432:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801433:	a1 08 40 80 00       	mov    0x804008,%eax
  801438:	8b 40 48             	mov    0x48(%eax),%eax
  80143b:	83 ec 04             	sub    $0x4,%esp
  80143e:	53                   	push   %ebx
  80143f:	50                   	push   %eax
  801440:	68 f1 29 80 00       	push   $0x8029f1
  801445:	e8 94 ed ff ff       	call   8001de <cprintf>
		return -E_INVAL;
  80144a:	83 c4 10             	add    $0x10,%esp
  80144d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801452:	eb da                	jmp    80142e <write+0x55>
		return -E_NOT_SUPP;
  801454:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801459:	eb d3                	jmp    80142e <write+0x55>

0080145b <seek>:

int
seek(int fdnum, off_t offset)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801461:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801464:	50                   	push   %eax
  801465:	ff 75 08             	pushl  0x8(%ebp)
  801468:	e8 30 fc ff ff       	call   80109d <fd_lookup>
  80146d:	83 c4 10             	add    $0x10,%esp
  801470:	85 c0                	test   %eax,%eax
  801472:	78 0e                	js     801482 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801474:	8b 55 0c             	mov    0xc(%ebp),%edx
  801477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80147d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	53                   	push   %ebx
  801488:	83 ec 1c             	sub    $0x1c,%esp
  80148b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80148e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801491:	50                   	push   %eax
  801492:	53                   	push   %ebx
  801493:	e8 05 fc ff ff       	call   80109d <fd_lookup>
  801498:	83 c4 10             	add    $0x10,%esp
  80149b:	85 c0                	test   %eax,%eax
  80149d:	78 37                	js     8014d6 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80149f:	83 ec 08             	sub    $0x8,%esp
  8014a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a5:	50                   	push   %eax
  8014a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a9:	ff 30                	pushl  (%eax)
  8014ab:	e8 3d fc ff ff       	call   8010ed <dev_lookup>
  8014b0:	83 c4 10             	add    $0x10,%esp
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	78 1f                	js     8014d6 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014be:	74 1b                	je     8014db <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c3:	8b 52 18             	mov    0x18(%edx),%edx
  8014c6:	85 d2                	test   %edx,%edx
  8014c8:	74 32                	je     8014fc <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014ca:	83 ec 08             	sub    $0x8,%esp
  8014cd:	ff 75 0c             	pushl  0xc(%ebp)
  8014d0:	50                   	push   %eax
  8014d1:	ff d2                	call   *%edx
  8014d3:	83 c4 10             	add    $0x10,%esp
}
  8014d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014db:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014e0:	8b 40 48             	mov    0x48(%eax),%eax
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	53                   	push   %ebx
  8014e7:	50                   	push   %eax
  8014e8:	68 b4 29 80 00       	push   $0x8029b4
  8014ed:	e8 ec ec ff ff       	call   8001de <cprintf>
		return -E_INVAL;
  8014f2:	83 c4 10             	add    $0x10,%esp
  8014f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fa:	eb da                	jmp    8014d6 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014fc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801501:	eb d3                	jmp    8014d6 <ftruncate+0x52>

00801503 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	53                   	push   %ebx
  801507:	83 ec 1c             	sub    $0x1c,%esp
  80150a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80150d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801510:	50                   	push   %eax
  801511:	ff 75 08             	pushl  0x8(%ebp)
  801514:	e8 84 fb ff ff       	call   80109d <fd_lookup>
  801519:	83 c4 10             	add    $0x10,%esp
  80151c:	85 c0                	test   %eax,%eax
  80151e:	78 4b                	js     80156b <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801520:	83 ec 08             	sub    $0x8,%esp
  801523:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801526:	50                   	push   %eax
  801527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152a:	ff 30                	pushl  (%eax)
  80152c:	e8 bc fb ff ff       	call   8010ed <dev_lookup>
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	78 33                	js     80156b <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80153f:	74 2f                	je     801570 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801541:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801544:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80154b:	00 00 00 
	stat->st_isdir = 0;
  80154e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801555:	00 00 00 
	stat->st_dev = dev;
  801558:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80155e:	83 ec 08             	sub    $0x8,%esp
  801561:	53                   	push   %ebx
  801562:	ff 75 f0             	pushl  -0x10(%ebp)
  801565:	ff 50 14             	call   *0x14(%eax)
  801568:	83 c4 10             	add    $0x10,%esp
}
  80156b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80156e:	c9                   	leave  
  80156f:	c3                   	ret    
		return -E_NOT_SUPP;
  801570:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801575:	eb f4                	jmp    80156b <fstat+0x68>

00801577 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	56                   	push   %esi
  80157b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80157c:	83 ec 08             	sub    $0x8,%esp
  80157f:	6a 00                	push   $0x0
  801581:	ff 75 08             	pushl  0x8(%ebp)
  801584:	e8 22 02 00 00       	call   8017ab <open>
  801589:	89 c3                	mov    %eax,%ebx
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	85 c0                	test   %eax,%eax
  801590:	78 1b                	js     8015ad <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801592:	83 ec 08             	sub    $0x8,%esp
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	50                   	push   %eax
  801599:	e8 65 ff ff ff       	call   801503 <fstat>
  80159e:	89 c6                	mov    %eax,%esi
	close(fd);
  8015a0:	89 1c 24             	mov    %ebx,(%esp)
  8015a3:	e8 27 fc ff ff       	call   8011cf <close>
	return r;
  8015a8:	83 c4 10             	add    $0x10,%esp
  8015ab:	89 f3                	mov    %esi,%ebx
}
  8015ad:	89 d8                	mov    %ebx,%eax
  8015af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b2:	5b                   	pop    %ebx
  8015b3:	5e                   	pop    %esi
  8015b4:	5d                   	pop    %ebp
  8015b5:	c3                   	ret    

008015b6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	56                   	push   %esi
  8015ba:	53                   	push   %ebx
  8015bb:	89 c6                	mov    %eax,%esi
  8015bd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015bf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015c6:	74 27                	je     8015ef <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015c8:	6a 07                	push   $0x7
  8015ca:	68 00 50 80 00       	push   $0x805000
  8015cf:	56                   	push   %esi
  8015d0:	ff 35 00 40 80 00    	pushl  0x804000
  8015d6:	e8 69 0c 00 00       	call   802244 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015db:	83 c4 0c             	add    $0xc,%esp
  8015de:	6a 00                	push   $0x0
  8015e0:	53                   	push   %ebx
  8015e1:	6a 00                	push   $0x0
  8015e3:	e8 f3 0b 00 00       	call   8021db <ipc_recv>
}
  8015e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015eb:	5b                   	pop    %ebx
  8015ec:	5e                   	pop    %esi
  8015ed:	5d                   	pop    %ebp
  8015ee:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015ef:	83 ec 0c             	sub    $0xc,%esp
  8015f2:	6a 01                	push   $0x1
  8015f4:	e8 a3 0c 00 00       	call   80229c <ipc_find_env>
  8015f9:	a3 00 40 80 00       	mov    %eax,0x804000
  8015fe:	83 c4 10             	add    $0x10,%esp
  801601:	eb c5                	jmp    8015c8 <fsipc+0x12>

00801603 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	8b 40 0c             	mov    0xc(%eax),%eax
  80160f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801614:	8b 45 0c             	mov    0xc(%ebp),%eax
  801617:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80161c:	ba 00 00 00 00       	mov    $0x0,%edx
  801621:	b8 02 00 00 00       	mov    $0x2,%eax
  801626:	e8 8b ff ff ff       	call   8015b6 <fsipc>
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <devfile_flush>:
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	8b 40 0c             	mov    0xc(%eax),%eax
  801639:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80163e:	ba 00 00 00 00       	mov    $0x0,%edx
  801643:	b8 06 00 00 00       	mov    $0x6,%eax
  801648:	e8 69 ff ff ff       	call   8015b6 <fsipc>
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <devfile_stat>:
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	53                   	push   %ebx
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	8b 40 0c             	mov    0xc(%eax),%eax
  80165f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801664:	ba 00 00 00 00       	mov    $0x0,%edx
  801669:	b8 05 00 00 00       	mov    $0x5,%eax
  80166e:	e8 43 ff ff ff       	call   8015b6 <fsipc>
  801673:	85 c0                	test   %eax,%eax
  801675:	78 2c                	js     8016a3 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801677:	83 ec 08             	sub    $0x8,%esp
  80167a:	68 00 50 80 00       	push   $0x805000
  80167f:	53                   	push   %ebx
  801680:	e8 b8 f2 ff ff       	call   80093d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801685:	a1 80 50 80 00       	mov    0x805080,%eax
  80168a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801690:	a1 84 50 80 00       	mov    0x805084,%eax
  801695:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <devfile_write>:
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	53                   	push   %ebx
  8016ac:	83 ec 08             	sub    $0x8,%esp
  8016af:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016bd:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016c3:	53                   	push   %ebx
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	68 08 50 80 00       	push   $0x805008
  8016cc:	e8 5c f4 ff ff       	call   800b2d <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d6:	b8 04 00 00 00       	mov    $0x4,%eax
  8016db:	e8 d6 fe ff ff       	call   8015b6 <fsipc>
  8016e0:	83 c4 10             	add    $0x10,%esp
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	78 0b                	js     8016f2 <devfile_write+0x4a>
	assert(r <= n);
  8016e7:	39 d8                	cmp    %ebx,%eax
  8016e9:	77 0c                	ja     8016f7 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016eb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016f0:	7f 1e                	jg     801710 <devfile_write+0x68>
}
  8016f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    
	assert(r <= n);
  8016f7:	68 24 2a 80 00       	push   $0x802a24
  8016fc:	68 2b 2a 80 00       	push   $0x802a2b
  801701:	68 98 00 00 00       	push   $0x98
  801706:	68 40 2a 80 00       	push   $0x802a40
  80170b:	e8 6a 0a 00 00       	call   80217a <_panic>
	assert(r <= PGSIZE);
  801710:	68 4b 2a 80 00       	push   $0x802a4b
  801715:	68 2b 2a 80 00       	push   $0x802a2b
  80171a:	68 99 00 00 00       	push   $0x99
  80171f:	68 40 2a 80 00       	push   $0x802a40
  801724:	e8 51 0a 00 00       	call   80217a <_panic>

00801729 <devfile_read>:
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	56                   	push   %esi
  80172d:	53                   	push   %ebx
  80172e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	8b 40 0c             	mov    0xc(%eax),%eax
  801737:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80173c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801742:	ba 00 00 00 00       	mov    $0x0,%edx
  801747:	b8 03 00 00 00       	mov    $0x3,%eax
  80174c:	e8 65 fe ff ff       	call   8015b6 <fsipc>
  801751:	89 c3                	mov    %eax,%ebx
  801753:	85 c0                	test   %eax,%eax
  801755:	78 1f                	js     801776 <devfile_read+0x4d>
	assert(r <= n);
  801757:	39 f0                	cmp    %esi,%eax
  801759:	77 24                	ja     80177f <devfile_read+0x56>
	assert(r <= PGSIZE);
  80175b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801760:	7f 33                	jg     801795 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801762:	83 ec 04             	sub    $0x4,%esp
  801765:	50                   	push   %eax
  801766:	68 00 50 80 00       	push   $0x805000
  80176b:	ff 75 0c             	pushl  0xc(%ebp)
  80176e:	e8 58 f3 ff ff       	call   800acb <memmove>
	return r;
  801773:	83 c4 10             	add    $0x10,%esp
}
  801776:	89 d8                	mov    %ebx,%eax
  801778:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177b:	5b                   	pop    %ebx
  80177c:	5e                   	pop    %esi
  80177d:	5d                   	pop    %ebp
  80177e:	c3                   	ret    
	assert(r <= n);
  80177f:	68 24 2a 80 00       	push   $0x802a24
  801784:	68 2b 2a 80 00       	push   $0x802a2b
  801789:	6a 7c                	push   $0x7c
  80178b:	68 40 2a 80 00       	push   $0x802a40
  801790:	e8 e5 09 00 00       	call   80217a <_panic>
	assert(r <= PGSIZE);
  801795:	68 4b 2a 80 00       	push   $0x802a4b
  80179a:	68 2b 2a 80 00       	push   $0x802a2b
  80179f:	6a 7d                	push   $0x7d
  8017a1:	68 40 2a 80 00       	push   $0x802a40
  8017a6:	e8 cf 09 00 00       	call   80217a <_panic>

008017ab <open>:
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	56                   	push   %esi
  8017af:	53                   	push   %ebx
  8017b0:	83 ec 1c             	sub    $0x1c,%esp
  8017b3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017b6:	56                   	push   %esi
  8017b7:	e8 48 f1 ff ff       	call   800904 <strlen>
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017c4:	7f 6c                	jg     801832 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017c6:	83 ec 0c             	sub    $0xc,%esp
  8017c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017cc:	50                   	push   %eax
  8017cd:	e8 79 f8 ff ff       	call   80104b <fd_alloc>
  8017d2:	89 c3                	mov    %eax,%ebx
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	78 3c                	js     801817 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017db:	83 ec 08             	sub    $0x8,%esp
  8017de:	56                   	push   %esi
  8017df:	68 00 50 80 00       	push   $0x805000
  8017e4:	e8 54 f1 ff ff       	call   80093d <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f9:	e8 b8 fd ff ff       	call   8015b6 <fsipc>
  8017fe:	89 c3                	mov    %eax,%ebx
  801800:	83 c4 10             	add    $0x10,%esp
  801803:	85 c0                	test   %eax,%eax
  801805:	78 19                	js     801820 <open+0x75>
	return fd2num(fd);
  801807:	83 ec 0c             	sub    $0xc,%esp
  80180a:	ff 75 f4             	pushl  -0xc(%ebp)
  80180d:	e8 12 f8 ff ff       	call   801024 <fd2num>
  801812:	89 c3                	mov    %eax,%ebx
  801814:	83 c4 10             	add    $0x10,%esp
}
  801817:	89 d8                	mov    %ebx,%eax
  801819:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80181c:	5b                   	pop    %ebx
  80181d:	5e                   	pop    %esi
  80181e:	5d                   	pop    %ebp
  80181f:	c3                   	ret    
		fd_close(fd, 0);
  801820:	83 ec 08             	sub    $0x8,%esp
  801823:	6a 00                	push   $0x0
  801825:	ff 75 f4             	pushl  -0xc(%ebp)
  801828:	e8 1b f9 ff ff       	call   801148 <fd_close>
		return r;
  80182d:	83 c4 10             	add    $0x10,%esp
  801830:	eb e5                	jmp    801817 <open+0x6c>
		return -E_BAD_PATH;
  801832:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801837:	eb de                	jmp    801817 <open+0x6c>

00801839 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80183f:	ba 00 00 00 00       	mov    $0x0,%edx
  801844:	b8 08 00 00 00       	mov    $0x8,%eax
  801849:	e8 68 fd ff ff       	call   8015b6 <fsipc>
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801856:	68 57 2a 80 00       	push   $0x802a57
  80185b:	ff 75 0c             	pushl  0xc(%ebp)
  80185e:	e8 da f0 ff ff       	call   80093d <strcpy>
	return 0;
}
  801863:	b8 00 00 00 00       	mov    $0x0,%eax
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <devsock_close>:
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	53                   	push   %ebx
  80186e:	83 ec 10             	sub    $0x10,%esp
  801871:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801874:	53                   	push   %ebx
  801875:	e8 61 0a 00 00       	call   8022db <pageref>
  80187a:	83 c4 10             	add    $0x10,%esp
		return 0;
  80187d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801882:	83 f8 01             	cmp    $0x1,%eax
  801885:	74 07                	je     80188e <devsock_close+0x24>
}
  801887:	89 d0                	mov    %edx,%eax
  801889:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80188e:	83 ec 0c             	sub    $0xc,%esp
  801891:	ff 73 0c             	pushl  0xc(%ebx)
  801894:	e8 b9 02 00 00       	call   801b52 <nsipc_close>
  801899:	89 c2                	mov    %eax,%edx
  80189b:	83 c4 10             	add    $0x10,%esp
  80189e:	eb e7                	jmp    801887 <devsock_close+0x1d>

008018a0 <devsock_write>:
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	ff 75 10             	pushl  0x10(%ebp)
  8018ab:	ff 75 0c             	pushl  0xc(%ebp)
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	ff 70 0c             	pushl  0xc(%eax)
  8018b4:	e8 76 03 00 00       	call   801c2f <nsipc_send>
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <devsock_read>:
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018c1:	6a 00                	push   $0x0
  8018c3:	ff 75 10             	pushl  0x10(%ebp)
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	ff 70 0c             	pushl  0xc(%eax)
  8018cf:	e8 ef 02 00 00       	call   801bc3 <nsipc_recv>
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <fd2sockid>:
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018dc:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018df:	52                   	push   %edx
  8018e0:	50                   	push   %eax
  8018e1:	e8 b7 f7 ff ff       	call   80109d <fd_lookup>
  8018e6:	83 c4 10             	add    $0x10,%esp
  8018e9:	85 c0                	test   %eax,%eax
  8018eb:	78 10                	js     8018fd <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f0:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018f6:	39 08                	cmp    %ecx,(%eax)
  8018f8:	75 05                	jne    8018ff <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018fa:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    
		return -E_NOT_SUPP;
  8018ff:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801904:	eb f7                	jmp    8018fd <fd2sockid+0x27>

00801906 <alloc_sockfd>:
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	56                   	push   %esi
  80190a:	53                   	push   %ebx
  80190b:	83 ec 1c             	sub    $0x1c,%esp
  80190e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801910:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801913:	50                   	push   %eax
  801914:	e8 32 f7 ff ff       	call   80104b <fd_alloc>
  801919:	89 c3                	mov    %eax,%ebx
  80191b:	83 c4 10             	add    $0x10,%esp
  80191e:	85 c0                	test   %eax,%eax
  801920:	78 43                	js     801965 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801922:	83 ec 04             	sub    $0x4,%esp
  801925:	68 07 04 00 00       	push   $0x407
  80192a:	ff 75 f4             	pushl  -0xc(%ebp)
  80192d:	6a 00                	push   $0x0
  80192f:	e8 fb f3 ff ff       	call   800d2f <sys_page_alloc>
  801934:	89 c3                	mov    %eax,%ebx
  801936:	83 c4 10             	add    $0x10,%esp
  801939:	85 c0                	test   %eax,%eax
  80193b:	78 28                	js     801965 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80193d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801940:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801946:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801952:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801955:	83 ec 0c             	sub    $0xc,%esp
  801958:	50                   	push   %eax
  801959:	e8 c6 f6 ff ff       	call   801024 <fd2num>
  80195e:	89 c3                	mov    %eax,%ebx
  801960:	83 c4 10             	add    $0x10,%esp
  801963:	eb 0c                	jmp    801971 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801965:	83 ec 0c             	sub    $0xc,%esp
  801968:	56                   	push   %esi
  801969:	e8 e4 01 00 00       	call   801b52 <nsipc_close>
		return r;
  80196e:	83 c4 10             	add    $0x10,%esp
}
  801971:	89 d8                	mov    %ebx,%eax
  801973:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801976:	5b                   	pop    %ebx
  801977:	5e                   	pop    %esi
  801978:	5d                   	pop    %ebp
  801979:	c3                   	ret    

0080197a <accept>:
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	e8 4e ff ff ff       	call   8018d6 <fd2sockid>
  801988:	85 c0                	test   %eax,%eax
  80198a:	78 1b                	js     8019a7 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80198c:	83 ec 04             	sub    $0x4,%esp
  80198f:	ff 75 10             	pushl  0x10(%ebp)
  801992:	ff 75 0c             	pushl  0xc(%ebp)
  801995:	50                   	push   %eax
  801996:	e8 0e 01 00 00       	call   801aa9 <nsipc_accept>
  80199b:	83 c4 10             	add    $0x10,%esp
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	78 05                	js     8019a7 <accept+0x2d>
	return alloc_sockfd(r);
  8019a2:	e8 5f ff ff ff       	call   801906 <alloc_sockfd>
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <bind>:
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	e8 1f ff ff ff       	call   8018d6 <fd2sockid>
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	78 12                	js     8019cd <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019bb:	83 ec 04             	sub    $0x4,%esp
  8019be:	ff 75 10             	pushl  0x10(%ebp)
  8019c1:	ff 75 0c             	pushl  0xc(%ebp)
  8019c4:	50                   	push   %eax
  8019c5:	e8 31 01 00 00       	call   801afb <nsipc_bind>
  8019ca:	83 c4 10             	add    $0x10,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <shutdown>:
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	e8 f9 fe ff ff       	call   8018d6 <fd2sockid>
  8019dd:	85 c0                	test   %eax,%eax
  8019df:	78 0f                	js     8019f0 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019e1:	83 ec 08             	sub    $0x8,%esp
  8019e4:	ff 75 0c             	pushl  0xc(%ebp)
  8019e7:	50                   	push   %eax
  8019e8:	e8 43 01 00 00       	call   801b30 <nsipc_shutdown>
  8019ed:	83 c4 10             	add    $0x10,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <connect>:
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	e8 d6 fe ff ff       	call   8018d6 <fd2sockid>
  801a00:	85 c0                	test   %eax,%eax
  801a02:	78 12                	js     801a16 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a04:	83 ec 04             	sub    $0x4,%esp
  801a07:	ff 75 10             	pushl  0x10(%ebp)
  801a0a:	ff 75 0c             	pushl  0xc(%ebp)
  801a0d:	50                   	push   %eax
  801a0e:	e8 59 01 00 00       	call   801b6c <nsipc_connect>
  801a13:	83 c4 10             	add    $0x10,%esp
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <listen>:
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	e8 b0 fe ff ff       	call   8018d6 <fd2sockid>
  801a26:	85 c0                	test   %eax,%eax
  801a28:	78 0f                	js     801a39 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a2a:	83 ec 08             	sub    $0x8,%esp
  801a2d:	ff 75 0c             	pushl  0xc(%ebp)
  801a30:	50                   	push   %eax
  801a31:	e8 6b 01 00 00       	call   801ba1 <nsipc_listen>
  801a36:	83 c4 10             	add    $0x10,%esp
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <socket>:

int
socket(int domain, int type, int protocol)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a41:	ff 75 10             	pushl  0x10(%ebp)
  801a44:	ff 75 0c             	pushl  0xc(%ebp)
  801a47:	ff 75 08             	pushl  0x8(%ebp)
  801a4a:	e8 3e 02 00 00       	call   801c8d <nsipc_socket>
  801a4f:	83 c4 10             	add    $0x10,%esp
  801a52:	85 c0                	test   %eax,%eax
  801a54:	78 05                	js     801a5b <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a56:	e8 ab fe ff ff       	call   801906 <alloc_sockfd>
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	53                   	push   %ebx
  801a61:	83 ec 04             	sub    $0x4,%esp
  801a64:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a66:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a6d:	74 26                	je     801a95 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a6f:	6a 07                	push   $0x7
  801a71:	68 00 60 80 00       	push   $0x806000
  801a76:	53                   	push   %ebx
  801a77:	ff 35 04 40 80 00    	pushl  0x804004
  801a7d:	e8 c2 07 00 00       	call   802244 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a82:	83 c4 0c             	add    $0xc,%esp
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	e8 4b 07 00 00       	call   8021db <ipc_recv>
}
  801a90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a95:	83 ec 0c             	sub    $0xc,%esp
  801a98:	6a 02                	push   $0x2
  801a9a:	e8 fd 07 00 00       	call   80229c <ipc_find_env>
  801a9f:	a3 04 40 80 00       	mov    %eax,0x804004
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	eb c6                	jmp    801a6f <nsipc+0x12>

00801aa9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	56                   	push   %esi
  801aad:	53                   	push   %ebx
  801aae:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ab9:	8b 06                	mov    (%esi),%eax
  801abb:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ac0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac5:	e8 93 ff ff ff       	call   801a5d <nsipc>
  801aca:	89 c3                	mov    %eax,%ebx
  801acc:	85 c0                	test   %eax,%eax
  801ace:	79 09                	jns    801ad9 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ad0:	89 d8                	mov    %ebx,%eax
  801ad2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad5:	5b                   	pop    %ebx
  801ad6:	5e                   	pop    %esi
  801ad7:	5d                   	pop    %ebp
  801ad8:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ad9:	83 ec 04             	sub    $0x4,%esp
  801adc:	ff 35 10 60 80 00    	pushl  0x806010
  801ae2:	68 00 60 80 00       	push   $0x806000
  801ae7:	ff 75 0c             	pushl  0xc(%ebp)
  801aea:	e8 dc ef ff ff       	call   800acb <memmove>
		*addrlen = ret->ret_addrlen;
  801aef:	a1 10 60 80 00       	mov    0x806010,%eax
  801af4:	89 06                	mov    %eax,(%esi)
  801af6:	83 c4 10             	add    $0x10,%esp
	return r;
  801af9:	eb d5                	jmp    801ad0 <nsipc_accept+0x27>

00801afb <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	53                   	push   %ebx
  801aff:	83 ec 08             	sub    $0x8,%esp
  801b02:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b05:	8b 45 08             	mov    0x8(%ebp),%eax
  801b08:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b0d:	53                   	push   %ebx
  801b0e:	ff 75 0c             	pushl  0xc(%ebp)
  801b11:	68 04 60 80 00       	push   $0x806004
  801b16:	e8 b0 ef ff ff       	call   800acb <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b1b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b21:	b8 02 00 00 00       	mov    $0x2,%eax
  801b26:	e8 32 ff ff ff       	call   801a5d <nsipc>
}
  801b2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b41:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b46:	b8 03 00 00 00       	mov    $0x3,%eax
  801b4b:	e8 0d ff ff ff       	call   801a5d <nsipc>
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <nsipc_close>:

int
nsipc_close(int s)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b60:	b8 04 00 00 00       	mov    $0x4,%eax
  801b65:	e8 f3 fe ff ff       	call   801a5d <nsipc>
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	53                   	push   %ebx
  801b70:	83 ec 08             	sub    $0x8,%esp
  801b73:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b7e:	53                   	push   %ebx
  801b7f:	ff 75 0c             	pushl  0xc(%ebp)
  801b82:	68 04 60 80 00       	push   $0x806004
  801b87:	e8 3f ef ff ff       	call   800acb <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b8c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b92:	b8 05 00 00 00       	mov    $0x5,%eax
  801b97:	e8 c1 fe ff ff       	call   801a5d <nsipc>
}
  801b9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bb7:	b8 06 00 00 00       	mov    $0x6,%eax
  801bbc:	e8 9c fe ff ff       	call   801a5d <nsipc>
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	56                   	push   %esi
  801bc7:	53                   	push   %ebx
  801bc8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bd3:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bd9:	8b 45 14             	mov    0x14(%ebp),%eax
  801bdc:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801be1:	b8 07 00 00 00       	mov    $0x7,%eax
  801be6:	e8 72 fe ff ff       	call   801a5d <nsipc>
  801beb:	89 c3                	mov    %eax,%ebx
  801bed:	85 c0                	test   %eax,%eax
  801bef:	78 1f                	js     801c10 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bf1:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bf6:	7f 21                	jg     801c19 <nsipc_recv+0x56>
  801bf8:	39 c6                	cmp    %eax,%esi
  801bfa:	7c 1d                	jl     801c19 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bfc:	83 ec 04             	sub    $0x4,%esp
  801bff:	50                   	push   %eax
  801c00:	68 00 60 80 00       	push   $0x806000
  801c05:	ff 75 0c             	pushl  0xc(%ebp)
  801c08:	e8 be ee ff ff       	call   800acb <memmove>
  801c0d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c10:	89 d8                	mov    %ebx,%eax
  801c12:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c15:	5b                   	pop    %ebx
  801c16:	5e                   	pop    %esi
  801c17:	5d                   	pop    %ebp
  801c18:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c19:	68 63 2a 80 00       	push   $0x802a63
  801c1e:	68 2b 2a 80 00       	push   $0x802a2b
  801c23:	6a 62                	push   $0x62
  801c25:	68 78 2a 80 00       	push   $0x802a78
  801c2a:	e8 4b 05 00 00       	call   80217a <_panic>

00801c2f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	53                   	push   %ebx
  801c33:	83 ec 04             	sub    $0x4,%esp
  801c36:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c41:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c47:	7f 2e                	jg     801c77 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c49:	83 ec 04             	sub    $0x4,%esp
  801c4c:	53                   	push   %ebx
  801c4d:	ff 75 0c             	pushl  0xc(%ebp)
  801c50:	68 0c 60 80 00       	push   $0x80600c
  801c55:	e8 71 ee ff ff       	call   800acb <memmove>
	nsipcbuf.send.req_size = size;
  801c5a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c60:	8b 45 14             	mov    0x14(%ebp),%eax
  801c63:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c68:	b8 08 00 00 00       	mov    $0x8,%eax
  801c6d:	e8 eb fd ff ff       	call   801a5d <nsipc>
}
  801c72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    
	assert(size < 1600);
  801c77:	68 84 2a 80 00       	push   $0x802a84
  801c7c:	68 2b 2a 80 00       	push   $0x802a2b
  801c81:	6a 6d                	push   $0x6d
  801c83:	68 78 2a 80 00       	push   $0x802a78
  801c88:	e8 ed 04 00 00       	call   80217a <_panic>

00801c8d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c9e:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ca3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca6:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cab:	b8 09 00 00 00       	mov    $0x9,%eax
  801cb0:	e8 a8 fd ff ff       	call   801a5d <nsipc>
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	56                   	push   %esi
  801cbb:	53                   	push   %ebx
  801cbc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cbf:	83 ec 0c             	sub    $0xc,%esp
  801cc2:	ff 75 08             	pushl  0x8(%ebp)
  801cc5:	e8 6a f3 ff ff       	call   801034 <fd2data>
  801cca:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ccc:	83 c4 08             	add    $0x8,%esp
  801ccf:	68 90 2a 80 00       	push   $0x802a90
  801cd4:	53                   	push   %ebx
  801cd5:	e8 63 ec ff ff       	call   80093d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cda:	8b 46 04             	mov    0x4(%esi),%eax
  801cdd:	2b 06                	sub    (%esi),%eax
  801cdf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ce5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cec:	00 00 00 
	stat->st_dev = &devpipe;
  801cef:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cf6:	30 80 00 
	return 0;
}
  801cf9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d01:	5b                   	pop    %ebx
  801d02:	5e                   	pop    %esi
  801d03:	5d                   	pop    %ebp
  801d04:	c3                   	ret    

00801d05 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	53                   	push   %ebx
  801d09:	83 ec 0c             	sub    $0xc,%esp
  801d0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d0f:	53                   	push   %ebx
  801d10:	6a 00                	push   $0x0
  801d12:	e8 9d f0 ff ff       	call   800db4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d17:	89 1c 24             	mov    %ebx,(%esp)
  801d1a:	e8 15 f3 ff ff       	call   801034 <fd2data>
  801d1f:	83 c4 08             	add    $0x8,%esp
  801d22:	50                   	push   %eax
  801d23:	6a 00                	push   $0x0
  801d25:	e8 8a f0 ff ff       	call   800db4 <sys_page_unmap>
}
  801d2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <_pipeisclosed>:
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	57                   	push   %edi
  801d33:	56                   	push   %esi
  801d34:	53                   	push   %ebx
  801d35:	83 ec 1c             	sub    $0x1c,%esp
  801d38:	89 c7                	mov    %eax,%edi
  801d3a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d3c:	a1 08 40 80 00       	mov    0x804008,%eax
  801d41:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d44:	83 ec 0c             	sub    $0xc,%esp
  801d47:	57                   	push   %edi
  801d48:	e8 8e 05 00 00       	call   8022db <pageref>
  801d4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d50:	89 34 24             	mov    %esi,(%esp)
  801d53:	e8 83 05 00 00       	call   8022db <pageref>
		nn = thisenv->env_runs;
  801d58:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d5e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d61:	83 c4 10             	add    $0x10,%esp
  801d64:	39 cb                	cmp    %ecx,%ebx
  801d66:	74 1b                	je     801d83 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d68:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d6b:	75 cf                	jne    801d3c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d6d:	8b 42 58             	mov    0x58(%edx),%eax
  801d70:	6a 01                	push   $0x1
  801d72:	50                   	push   %eax
  801d73:	53                   	push   %ebx
  801d74:	68 97 2a 80 00       	push   $0x802a97
  801d79:	e8 60 e4 ff ff       	call   8001de <cprintf>
  801d7e:	83 c4 10             	add    $0x10,%esp
  801d81:	eb b9                	jmp    801d3c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d83:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d86:	0f 94 c0             	sete   %al
  801d89:	0f b6 c0             	movzbl %al,%eax
}
  801d8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d8f:	5b                   	pop    %ebx
  801d90:	5e                   	pop    %esi
  801d91:	5f                   	pop    %edi
  801d92:	5d                   	pop    %ebp
  801d93:	c3                   	ret    

00801d94 <devpipe_write>:
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	57                   	push   %edi
  801d98:	56                   	push   %esi
  801d99:	53                   	push   %ebx
  801d9a:	83 ec 28             	sub    $0x28,%esp
  801d9d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801da0:	56                   	push   %esi
  801da1:	e8 8e f2 ff ff       	call   801034 <fd2data>
  801da6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801da8:	83 c4 10             	add    $0x10,%esp
  801dab:	bf 00 00 00 00       	mov    $0x0,%edi
  801db0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801db3:	74 4f                	je     801e04 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801db5:	8b 43 04             	mov    0x4(%ebx),%eax
  801db8:	8b 0b                	mov    (%ebx),%ecx
  801dba:	8d 51 20             	lea    0x20(%ecx),%edx
  801dbd:	39 d0                	cmp    %edx,%eax
  801dbf:	72 14                	jb     801dd5 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dc1:	89 da                	mov    %ebx,%edx
  801dc3:	89 f0                	mov    %esi,%eax
  801dc5:	e8 65 ff ff ff       	call   801d2f <_pipeisclosed>
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	75 3b                	jne    801e09 <devpipe_write+0x75>
			sys_yield();
  801dce:	e8 3d ef ff ff       	call   800d10 <sys_yield>
  801dd3:	eb e0                	jmp    801db5 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dd8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ddc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ddf:	89 c2                	mov    %eax,%edx
  801de1:	c1 fa 1f             	sar    $0x1f,%edx
  801de4:	89 d1                	mov    %edx,%ecx
  801de6:	c1 e9 1b             	shr    $0x1b,%ecx
  801de9:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dec:	83 e2 1f             	and    $0x1f,%edx
  801def:	29 ca                	sub    %ecx,%edx
  801df1:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801df5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801df9:	83 c0 01             	add    $0x1,%eax
  801dfc:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dff:	83 c7 01             	add    $0x1,%edi
  801e02:	eb ac                	jmp    801db0 <devpipe_write+0x1c>
	return i;
  801e04:	8b 45 10             	mov    0x10(%ebp),%eax
  801e07:	eb 05                	jmp    801e0e <devpipe_write+0x7a>
				return 0;
  801e09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e11:	5b                   	pop    %ebx
  801e12:	5e                   	pop    %esi
  801e13:	5f                   	pop    %edi
  801e14:	5d                   	pop    %ebp
  801e15:	c3                   	ret    

00801e16 <devpipe_read>:
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	57                   	push   %edi
  801e1a:	56                   	push   %esi
  801e1b:	53                   	push   %ebx
  801e1c:	83 ec 18             	sub    $0x18,%esp
  801e1f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e22:	57                   	push   %edi
  801e23:	e8 0c f2 ff ff       	call   801034 <fd2data>
  801e28:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e2a:	83 c4 10             	add    $0x10,%esp
  801e2d:	be 00 00 00 00       	mov    $0x0,%esi
  801e32:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e35:	75 14                	jne    801e4b <devpipe_read+0x35>
	return i;
  801e37:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3a:	eb 02                	jmp    801e3e <devpipe_read+0x28>
				return i;
  801e3c:	89 f0                	mov    %esi,%eax
}
  801e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e41:	5b                   	pop    %ebx
  801e42:	5e                   	pop    %esi
  801e43:	5f                   	pop    %edi
  801e44:	5d                   	pop    %ebp
  801e45:	c3                   	ret    
			sys_yield();
  801e46:	e8 c5 ee ff ff       	call   800d10 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e4b:	8b 03                	mov    (%ebx),%eax
  801e4d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e50:	75 18                	jne    801e6a <devpipe_read+0x54>
			if (i > 0)
  801e52:	85 f6                	test   %esi,%esi
  801e54:	75 e6                	jne    801e3c <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e56:	89 da                	mov    %ebx,%edx
  801e58:	89 f8                	mov    %edi,%eax
  801e5a:	e8 d0 fe ff ff       	call   801d2f <_pipeisclosed>
  801e5f:	85 c0                	test   %eax,%eax
  801e61:	74 e3                	je     801e46 <devpipe_read+0x30>
				return 0;
  801e63:	b8 00 00 00 00       	mov    $0x0,%eax
  801e68:	eb d4                	jmp    801e3e <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e6a:	99                   	cltd   
  801e6b:	c1 ea 1b             	shr    $0x1b,%edx
  801e6e:	01 d0                	add    %edx,%eax
  801e70:	83 e0 1f             	and    $0x1f,%eax
  801e73:	29 d0                	sub    %edx,%eax
  801e75:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e7d:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e80:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e83:	83 c6 01             	add    $0x1,%esi
  801e86:	eb aa                	jmp    801e32 <devpipe_read+0x1c>

00801e88 <pipe>:
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	56                   	push   %esi
  801e8c:	53                   	push   %ebx
  801e8d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e90:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e93:	50                   	push   %eax
  801e94:	e8 b2 f1 ff ff       	call   80104b <fd_alloc>
  801e99:	89 c3                	mov    %eax,%ebx
  801e9b:	83 c4 10             	add    $0x10,%esp
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	0f 88 23 01 00 00    	js     801fc9 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea6:	83 ec 04             	sub    $0x4,%esp
  801ea9:	68 07 04 00 00       	push   $0x407
  801eae:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb1:	6a 00                	push   $0x0
  801eb3:	e8 77 ee ff ff       	call   800d2f <sys_page_alloc>
  801eb8:	89 c3                	mov    %eax,%ebx
  801eba:	83 c4 10             	add    $0x10,%esp
  801ebd:	85 c0                	test   %eax,%eax
  801ebf:	0f 88 04 01 00 00    	js     801fc9 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ec5:	83 ec 0c             	sub    $0xc,%esp
  801ec8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ecb:	50                   	push   %eax
  801ecc:	e8 7a f1 ff ff       	call   80104b <fd_alloc>
  801ed1:	89 c3                	mov    %eax,%ebx
  801ed3:	83 c4 10             	add    $0x10,%esp
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	0f 88 db 00 00 00    	js     801fb9 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ede:	83 ec 04             	sub    $0x4,%esp
  801ee1:	68 07 04 00 00       	push   $0x407
  801ee6:	ff 75 f0             	pushl  -0x10(%ebp)
  801ee9:	6a 00                	push   $0x0
  801eeb:	e8 3f ee ff ff       	call   800d2f <sys_page_alloc>
  801ef0:	89 c3                	mov    %eax,%ebx
  801ef2:	83 c4 10             	add    $0x10,%esp
  801ef5:	85 c0                	test   %eax,%eax
  801ef7:	0f 88 bc 00 00 00    	js     801fb9 <pipe+0x131>
	va = fd2data(fd0);
  801efd:	83 ec 0c             	sub    $0xc,%esp
  801f00:	ff 75 f4             	pushl  -0xc(%ebp)
  801f03:	e8 2c f1 ff ff       	call   801034 <fd2data>
  801f08:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f0a:	83 c4 0c             	add    $0xc,%esp
  801f0d:	68 07 04 00 00       	push   $0x407
  801f12:	50                   	push   %eax
  801f13:	6a 00                	push   $0x0
  801f15:	e8 15 ee ff ff       	call   800d2f <sys_page_alloc>
  801f1a:	89 c3                	mov    %eax,%ebx
  801f1c:	83 c4 10             	add    $0x10,%esp
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	0f 88 82 00 00 00    	js     801fa9 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f27:	83 ec 0c             	sub    $0xc,%esp
  801f2a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f2d:	e8 02 f1 ff ff       	call   801034 <fd2data>
  801f32:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f39:	50                   	push   %eax
  801f3a:	6a 00                	push   $0x0
  801f3c:	56                   	push   %esi
  801f3d:	6a 00                	push   $0x0
  801f3f:	e8 2e ee ff ff       	call   800d72 <sys_page_map>
  801f44:	89 c3                	mov    %eax,%ebx
  801f46:	83 c4 20             	add    $0x20,%esp
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	78 4e                	js     801f9b <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f4d:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f55:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f64:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f69:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f70:	83 ec 0c             	sub    $0xc,%esp
  801f73:	ff 75 f4             	pushl  -0xc(%ebp)
  801f76:	e8 a9 f0 ff ff       	call   801024 <fd2num>
  801f7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f7e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f80:	83 c4 04             	add    $0x4,%esp
  801f83:	ff 75 f0             	pushl  -0x10(%ebp)
  801f86:	e8 99 f0 ff ff       	call   801024 <fd2num>
  801f8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f8e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f91:	83 c4 10             	add    $0x10,%esp
  801f94:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f99:	eb 2e                	jmp    801fc9 <pipe+0x141>
	sys_page_unmap(0, va);
  801f9b:	83 ec 08             	sub    $0x8,%esp
  801f9e:	56                   	push   %esi
  801f9f:	6a 00                	push   $0x0
  801fa1:	e8 0e ee ff ff       	call   800db4 <sys_page_unmap>
  801fa6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fa9:	83 ec 08             	sub    $0x8,%esp
  801fac:	ff 75 f0             	pushl  -0x10(%ebp)
  801faf:	6a 00                	push   $0x0
  801fb1:	e8 fe ed ff ff       	call   800db4 <sys_page_unmap>
  801fb6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fb9:	83 ec 08             	sub    $0x8,%esp
  801fbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801fbf:	6a 00                	push   $0x0
  801fc1:	e8 ee ed ff ff       	call   800db4 <sys_page_unmap>
  801fc6:	83 c4 10             	add    $0x10,%esp
}
  801fc9:	89 d8                	mov    %ebx,%eax
  801fcb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fce:	5b                   	pop    %ebx
  801fcf:	5e                   	pop    %esi
  801fd0:	5d                   	pop    %ebp
  801fd1:	c3                   	ret    

00801fd2 <pipeisclosed>:
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fdb:	50                   	push   %eax
  801fdc:	ff 75 08             	pushl  0x8(%ebp)
  801fdf:	e8 b9 f0 ff ff       	call   80109d <fd_lookup>
  801fe4:	83 c4 10             	add    $0x10,%esp
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	78 18                	js     802003 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801feb:	83 ec 0c             	sub    $0xc,%esp
  801fee:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff1:	e8 3e f0 ff ff       	call   801034 <fd2data>
	return _pipeisclosed(fd, p);
  801ff6:	89 c2                	mov    %eax,%edx
  801ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffb:	e8 2f fd ff ff       	call   801d2f <_pipeisclosed>
  802000:	83 c4 10             	add    $0x10,%esp
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802005:	b8 00 00 00 00       	mov    $0x0,%eax
  80200a:	c3                   	ret    

0080200b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
  80200e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802011:	68 af 2a 80 00       	push   $0x802aaf
  802016:	ff 75 0c             	pushl  0xc(%ebp)
  802019:	e8 1f e9 ff ff       	call   80093d <strcpy>
	return 0;
}
  80201e:	b8 00 00 00 00       	mov    $0x0,%eax
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <devcons_write>:
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	57                   	push   %edi
  802029:	56                   	push   %esi
  80202a:	53                   	push   %ebx
  80202b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802031:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802036:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80203c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80203f:	73 31                	jae    802072 <devcons_write+0x4d>
		m = n - tot;
  802041:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802044:	29 f3                	sub    %esi,%ebx
  802046:	83 fb 7f             	cmp    $0x7f,%ebx
  802049:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80204e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802051:	83 ec 04             	sub    $0x4,%esp
  802054:	53                   	push   %ebx
  802055:	89 f0                	mov    %esi,%eax
  802057:	03 45 0c             	add    0xc(%ebp),%eax
  80205a:	50                   	push   %eax
  80205b:	57                   	push   %edi
  80205c:	e8 6a ea ff ff       	call   800acb <memmove>
		sys_cputs(buf, m);
  802061:	83 c4 08             	add    $0x8,%esp
  802064:	53                   	push   %ebx
  802065:	57                   	push   %edi
  802066:	e8 08 ec ff ff       	call   800c73 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80206b:	01 de                	add    %ebx,%esi
  80206d:	83 c4 10             	add    $0x10,%esp
  802070:	eb ca                	jmp    80203c <devcons_write+0x17>
}
  802072:	89 f0                	mov    %esi,%eax
  802074:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802077:	5b                   	pop    %ebx
  802078:	5e                   	pop    %esi
  802079:	5f                   	pop    %edi
  80207a:	5d                   	pop    %ebp
  80207b:	c3                   	ret    

0080207c <devcons_read>:
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 08             	sub    $0x8,%esp
  802082:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802087:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80208b:	74 21                	je     8020ae <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80208d:	e8 ff eb ff ff       	call   800c91 <sys_cgetc>
  802092:	85 c0                	test   %eax,%eax
  802094:	75 07                	jne    80209d <devcons_read+0x21>
		sys_yield();
  802096:	e8 75 ec ff ff       	call   800d10 <sys_yield>
  80209b:	eb f0                	jmp    80208d <devcons_read+0x11>
	if (c < 0)
  80209d:	78 0f                	js     8020ae <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80209f:	83 f8 04             	cmp    $0x4,%eax
  8020a2:	74 0c                	je     8020b0 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a7:	88 02                	mov    %al,(%edx)
	return 1;
  8020a9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    
		return 0;
  8020b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b5:	eb f7                	jmp    8020ae <devcons_read+0x32>

008020b7 <cputchar>:
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020c3:	6a 01                	push   $0x1
  8020c5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020c8:	50                   	push   %eax
  8020c9:	e8 a5 eb ff ff       	call   800c73 <sys_cputs>
}
  8020ce:	83 c4 10             	add    $0x10,%esp
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <getchar>:
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
  8020d6:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020d9:	6a 01                	push   $0x1
  8020db:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020de:	50                   	push   %eax
  8020df:	6a 00                	push   $0x0
  8020e1:	e8 27 f2 ff ff       	call   80130d <read>
	if (r < 0)
  8020e6:	83 c4 10             	add    $0x10,%esp
  8020e9:	85 c0                	test   %eax,%eax
  8020eb:	78 06                	js     8020f3 <getchar+0x20>
	if (r < 1)
  8020ed:	74 06                	je     8020f5 <getchar+0x22>
	return c;
  8020ef:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    
		return -E_EOF;
  8020f5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020fa:	eb f7                	jmp    8020f3 <getchar+0x20>

008020fc <iscons>:
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
  8020ff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802102:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802105:	50                   	push   %eax
  802106:	ff 75 08             	pushl  0x8(%ebp)
  802109:	e8 8f ef ff ff       	call   80109d <fd_lookup>
  80210e:	83 c4 10             	add    $0x10,%esp
  802111:	85 c0                	test   %eax,%eax
  802113:	78 11                	js     802126 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802118:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80211e:	39 10                	cmp    %edx,(%eax)
  802120:	0f 94 c0             	sete   %al
  802123:	0f b6 c0             	movzbl %al,%eax
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <opencons>:
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80212e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802131:	50                   	push   %eax
  802132:	e8 14 ef ff ff       	call   80104b <fd_alloc>
  802137:	83 c4 10             	add    $0x10,%esp
  80213a:	85 c0                	test   %eax,%eax
  80213c:	78 3a                	js     802178 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80213e:	83 ec 04             	sub    $0x4,%esp
  802141:	68 07 04 00 00       	push   $0x407
  802146:	ff 75 f4             	pushl  -0xc(%ebp)
  802149:	6a 00                	push   $0x0
  80214b:	e8 df eb ff ff       	call   800d2f <sys_page_alloc>
  802150:	83 c4 10             	add    $0x10,%esp
  802153:	85 c0                	test   %eax,%eax
  802155:	78 21                	js     802178 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802160:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802165:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80216c:	83 ec 0c             	sub    $0xc,%esp
  80216f:	50                   	push   %eax
  802170:	e8 af ee ff ff       	call   801024 <fd2num>
  802175:	83 c4 10             	add    $0x10,%esp
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	56                   	push   %esi
  80217e:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80217f:	a1 08 40 80 00       	mov    0x804008,%eax
  802184:	8b 40 48             	mov    0x48(%eax),%eax
  802187:	83 ec 04             	sub    $0x4,%esp
  80218a:	68 e0 2a 80 00       	push   $0x802ae0
  80218f:	50                   	push   %eax
  802190:	68 d8 25 80 00       	push   $0x8025d8
  802195:	e8 44 e0 ff ff       	call   8001de <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80219a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80219d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021a3:	e8 49 eb ff ff       	call   800cf1 <sys_getenvid>
  8021a8:	83 c4 04             	add    $0x4,%esp
  8021ab:	ff 75 0c             	pushl  0xc(%ebp)
  8021ae:	ff 75 08             	pushl  0x8(%ebp)
  8021b1:	56                   	push   %esi
  8021b2:	50                   	push   %eax
  8021b3:	68 bc 2a 80 00       	push   $0x802abc
  8021b8:	e8 21 e0 ff ff       	call   8001de <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021bd:	83 c4 18             	add    $0x18,%esp
  8021c0:	53                   	push   %ebx
  8021c1:	ff 75 10             	pushl  0x10(%ebp)
  8021c4:	e8 c4 df ff ff       	call   80018d <vcprintf>
	cprintf("\n");
  8021c9:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  8021d0:	e8 09 e0 ff ff       	call   8001de <cprintf>
  8021d5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021d8:	cc                   	int3   
  8021d9:	eb fd                	jmp    8021d8 <_panic+0x5e>

008021db <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	56                   	push   %esi
  8021df:	53                   	push   %ebx
  8021e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8021e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021e9:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021eb:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021f0:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021f3:	83 ec 0c             	sub    $0xc,%esp
  8021f6:	50                   	push   %eax
  8021f7:	e8 e3 ec ff ff       	call   800edf <sys_ipc_recv>
	if(ret < 0){
  8021fc:	83 c4 10             	add    $0x10,%esp
  8021ff:	85 c0                	test   %eax,%eax
  802201:	78 2b                	js     80222e <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802203:	85 f6                	test   %esi,%esi
  802205:	74 0a                	je     802211 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802207:	a1 08 40 80 00       	mov    0x804008,%eax
  80220c:	8b 40 78             	mov    0x78(%eax),%eax
  80220f:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802211:	85 db                	test   %ebx,%ebx
  802213:	74 0a                	je     80221f <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802215:	a1 08 40 80 00       	mov    0x804008,%eax
  80221a:	8b 40 7c             	mov    0x7c(%eax),%eax
  80221d:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80221f:	a1 08 40 80 00       	mov    0x804008,%eax
  802224:	8b 40 74             	mov    0x74(%eax),%eax
}
  802227:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80222a:	5b                   	pop    %ebx
  80222b:	5e                   	pop    %esi
  80222c:	5d                   	pop    %ebp
  80222d:	c3                   	ret    
		if(from_env_store)
  80222e:	85 f6                	test   %esi,%esi
  802230:	74 06                	je     802238 <ipc_recv+0x5d>
			*from_env_store = 0;
  802232:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802238:	85 db                	test   %ebx,%ebx
  80223a:	74 eb                	je     802227 <ipc_recv+0x4c>
			*perm_store = 0;
  80223c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802242:	eb e3                	jmp    802227 <ipc_recv+0x4c>

00802244 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
  802247:	57                   	push   %edi
  802248:	56                   	push   %esi
  802249:	53                   	push   %ebx
  80224a:	83 ec 0c             	sub    $0xc,%esp
  80224d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802250:	8b 75 0c             	mov    0xc(%ebp),%esi
  802253:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802256:	85 db                	test   %ebx,%ebx
  802258:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80225d:	0f 44 d8             	cmove  %eax,%ebx
  802260:	eb 05                	jmp    802267 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802262:	e8 a9 ea ff ff       	call   800d10 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802267:	ff 75 14             	pushl  0x14(%ebp)
  80226a:	53                   	push   %ebx
  80226b:	56                   	push   %esi
  80226c:	57                   	push   %edi
  80226d:	e8 4a ec ff ff       	call   800ebc <sys_ipc_try_send>
  802272:	83 c4 10             	add    $0x10,%esp
  802275:	85 c0                	test   %eax,%eax
  802277:	74 1b                	je     802294 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802279:	79 e7                	jns    802262 <ipc_send+0x1e>
  80227b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80227e:	74 e2                	je     802262 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802280:	83 ec 04             	sub    $0x4,%esp
  802283:	68 e7 2a 80 00       	push   $0x802ae7
  802288:	6a 46                	push   $0x46
  80228a:	68 fc 2a 80 00       	push   $0x802afc
  80228f:	e8 e6 fe ff ff       	call   80217a <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802294:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802297:	5b                   	pop    %ebx
  802298:	5e                   	pop    %esi
  802299:	5f                   	pop    %edi
  80229a:	5d                   	pop    %ebp
  80229b:	c3                   	ret    

0080229c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
  80229f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022a2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022a7:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8022ad:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022b3:	8b 52 50             	mov    0x50(%edx),%edx
  8022b6:	39 ca                	cmp    %ecx,%edx
  8022b8:	74 11                	je     8022cb <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022ba:	83 c0 01             	add    $0x1,%eax
  8022bd:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022c2:	75 e3                	jne    8022a7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c9:	eb 0e                	jmp    8022d9 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8022cb:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
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
