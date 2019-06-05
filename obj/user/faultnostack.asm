
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	68 cb 0f 80 00       	push   $0x800fcb
  80003e:	6a 00                	push   $0x0
  800040:	e8 fc 0d 00 00       	call   800e41 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800045:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80004c:	00 00 00 
}
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	57                   	push   %edi
  800058:	56                   	push   %esi
  800059:	53                   	push   %ebx
  80005a:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80005d:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800064:	00 00 00 
	envid_t find = sys_getenvid();
  800067:	e8 4c 0c 00 00       	call   800cb8 <sys_getenvid>
  80006c:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800072:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800077:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80007c:	bf 01 00 00 00       	mov    $0x1,%edi
  800081:	eb 0b                	jmp    80008e <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800083:	83 c2 01             	add    $0x1,%edx
  800086:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80008c:	74 21                	je     8000af <libmain+0x5b>
		if(envs[i].env_id == find)
  80008e:	89 d1                	mov    %edx,%ecx
  800090:	c1 e1 07             	shl    $0x7,%ecx
  800093:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800099:	8b 49 48             	mov    0x48(%ecx),%ecx
  80009c:	39 c1                	cmp    %eax,%ecx
  80009e:	75 e3                	jne    800083 <libmain+0x2f>
  8000a0:	89 d3                	mov    %edx,%ebx
  8000a2:	c1 e3 07             	shl    $0x7,%ebx
  8000a5:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000ab:	89 fe                	mov    %edi,%esi
  8000ad:	eb d4                	jmp    800083 <libmain+0x2f>
  8000af:	89 f0                	mov    %esi,%eax
  8000b1:	84 c0                	test   %al,%al
  8000b3:	74 06                	je     8000bb <libmain+0x67>
  8000b5:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000bf:	7e 0a                	jle    8000cb <libmain+0x77>
		binaryname = argv[0];
  8000c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c4:	8b 00                	mov    (%eax),%eax
  8000c6:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("in libmain.c call umain!\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 a0 25 80 00       	push   $0x8025a0
  8000d3:	e8 cd 00 00 00       	call   8001a5 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000d8:	83 c4 08             	add    $0x8,%esp
  8000db:	ff 75 0c             	pushl  0xc(%ebp)
  8000de:	ff 75 08             	pushl  0x8(%ebp)
  8000e1:	e8 4d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000e6:	e8 0b 00 00 00       	call   8000f6 <exit>
}
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f1:	5b                   	pop    %ebx
  8000f2:	5e                   	pop    %esi
  8000f3:	5f                   	pop    %edi
  8000f4:	5d                   	pop    %ebp
  8000f5:	c3                   	ret    

008000f6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000fc:	e8 c8 10 00 00       	call   8011c9 <close_all>
	sys_env_destroy(0);
  800101:	83 ec 0c             	sub    $0xc,%esp
  800104:	6a 00                	push   $0x0
  800106:	e8 6c 0b 00 00       	call   800c77 <sys_env_destroy>
}
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	c9                   	leave  
  80010f:	c3                   	ret    

00800110 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	53                   	push   %ebx
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80011a:	8b 13                	mov    (%ebx),%edx
  80011c:	8d 42 01             	lea    0x1(%edx),%eax
  80011f:	89 03                	mov    %eax,(%ebx)
  800121:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800124:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800128:	3d ff 00 00 00       	cmp    $0xff,%eax
  80012d:	74 09                	je     800138 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80012f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800133:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800136:	c9                   	leave  
  800137:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	68 ff 00 00 00       	push   $0xff
  800140:	8d 43 08             	lea    0x8(%ebx),%eax
  800143:	50                   	push   %eax
  800144:	e8 f1 0a 00 00       	call   800c3a <sys_cputs>
		b->idx = 0;
  800149:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80014f:	83 c4 10             	add    $0x10,%esp
  800152:	eb db                	jmp    80012f <putch+0x1f>

00800154 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80015d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800164:	00 00 00 
	b.cnt = 0;
  800167:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80016e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800171:	ff 75 0c             	pushl  0xc(%ebp)
  800174:	ff 75 08             	pushl  0x8(%ebp)
  800177:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80017d:	50                   	push   %eax
  80017e:	68 10 01 80 00       	push   $0x800110
  800183:	e8 4a 01 00 00       	call   8002d2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800188:	83 c4 08             	add    $0x8,%esp
  80018b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800191:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800197:	50                   	push   %eax
  800198:	e8 9d 0a 00 00       	call   800c3a <sys_cputs>

	return b.cnt;
}
  80019d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    

008001a5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001ab:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001ae:	50                   	push   %eax
  8001af:	ff 75 08             	pushl  0x8(%ebp)
  8001b2:	e8 9d ff ff ff       	call   800154 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001b7:	c9                   	leave  
  8001b8:	c3                   	ret    

008001b9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001b9:	55                   	push   %ebp
  8001ba:	89 e5                	mov    %esp,%ebp
  8001bc:	57                   	push   %edi
  8001bd:	56                   	push   %esi
  8001be:	53                   	push   %ebx
  8001bf:	83 ec 1c             	sub    $0x1c,%esp
  8001c2:	89 c6                	mov    %eax,%esi
  8001c4:	89 d7                	mov    %edx,%edi
  8001c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8001d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001d8:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001dc:	74 2c                	je     80020a <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001eb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001ee:	39 c2                	cmp    %eax,%edx
  8001f0:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001f3:	73 43                	jae    800238 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001f5:	83 eb 01             	sub    $0x1,%ebx
  8001f8:	85 db                	test   %ebx,%ebx
  8001fa:	7e 6c                	jle    800268 <printnum+0xaf>
				putch(padc, putdat);
  8001fc:	83 ec 08             	sub    $0x8,%esp
  8001ff:	57                   	push   %edi
  800200:	ff 75 18             	pushl  0x18(%ebp)
  800203:	ff d6                	call   *%esi
  800205:	83 c4 10             	add    $0x10,%esp
  800208:	eb eb                	jmp    8001f5 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	6a 20                	push   $0x20
  80020f:	6a 00                	push   $0x0
  800211:	50                   	push   %eax
  800212:	ff 75 e4             	pushl  -0x1c(%ebp)
  800215:	ff 75 e0             	pushl  -0x20(%ebp)
  800218:	89 fa                	mov    %edi,%edx
  80021a:	89 f0                	mov    %esi,%eax
  80021c:	e8 98 ff ff ff       	call   8001b9 <printnum>
		while (--width > 0)
  800221:	83 c4 20             	add    $0x20,%esp
  800224:	83 eb 01             	sub    $0x1,%ebx
  800227:	85 db                	test   %ebx,%ebx
  800229:	7e 65                	jle    800290 <printnum+0xd7>
			putch(padc, putdat);
  80022b:	83 ec 08             	sub    $0x8,%esp
  80022e:	57                   	push   %edi
  80022f:	6a 20                	push   $0x20
  800231:	ff d6                	call   *%esi
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	eb ec                	jmp    800224 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	ff 75 18             	pushl  0x18(%ebp)
  80023e:	83 eb 01             	sub    $0x1,%ebx
  800241:	53                   	push   %ebx
  800242:	50                   	push   %eax
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	ff 75 dc             	pushl  -0x24(%ebp)
  800249:	ff 75 d8             	pushl  -0x28(%ebp)
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	ff 75 e0             	pushl  -0x20(%ebp)
  800252:	e8 f9 20 00 00       	call   802350 <__udivdi3>
  800257:	83 c4 18             	add    $0x18,%esp
  80025a:	52                   	push   %edx
  80025b:	50                   	push   %eax
  80025c:	89 fa                	mov    %edi,%edx
  80025e:	89 f0                	mov    %esi,%eax
  800260:	e8 54 ff ff ff       	call   8001b9 <printnum>
  800265:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800268:	83 ec 08             	sub    $0x8,%esp
  80026b:	57                   	push   %edi
  80026c:	83 ec 04             	sub    $0x4,%esp
  80026f:	ff 75 dc             	pushl  -0x24(%ebp)
  800272:	ff 75 d8             	pushl  -0x28(%ebp)
  800275:	ff 75 e4             	pushl  -0x1c(%ebp)
  800278:	ff 75 e0             	pushl  -0x20(%ebp)
  80027b:	e8 e0 21 00 00       	call   802460 <__umoddi3>
  800280:	83 c4 14             	add    $0x14,%esp
  800283:	0f be 80 c4 25 80 00 	movsbl 0x8025c4(%eax),%eax
  80028a:	50                   	push   %eax
  80028b:	ff d6                	call   *%esi
  80028d:	83 c4 10             	add    $0x10,%esp
	}
}
  800290:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800293:	5b                   	pop    %ebx
  800294:	5e                   	pop    %esi
  800295:	5f                   	pop    %edi
  800296:	5d                   	pop    %ebp
  800297:	c3                   	ret    

00800298 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80029e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002a2:	8b 10                	mov    (%eax),%edx
  8002a4:	3b 50 04             	cmp    0x4(%eax),%edx
  8002a7:	73 0a                	jae    8002b3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ac:	89 08                	mov    %ecx,(%eax)
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	88 02                	mov    %al,(%edx)
}
  8002b3:	5d                   	pop    %ebp
  8002b4:	c3                   	ret    

008002b5 <printfmt>:
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002bb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002be:	50                   	push   %eax
  8002bf:	ff 75 10             	pushl  0x10(%ebp)
  8002c2:	ff 75 0c             	pushl  0xc(%ebp)
  8002c5:	ff 75 08             	pushl  0x8(%ebp)
  8002c8:	e8 05 00 00 00       	call   8002d2 <vprintfmt>
}
  8002cd:	83 c4 10             	add    $0x10,%esp
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <vprintfmt>:
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	57                   	push   %edi
  8002d6:	56                   	push   %esi
  8002d7:	53                   	push   %ebx
  8002d8:	83 ec 3c             	sub    $0x3c,%esp
  8002db:	8b 75 08             	mov    0x8(%ebp),%esi
  8002de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002e4:	e9 32 04 00 00       	jmp    80071b <vprintfmt+0x449>
		padc = ' ';
  8002e9:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002ed:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002f4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002fb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800302:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800309:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800310:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800315:	8d 47 01             	lea    0x1(%edi),%eax
  800318:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80031b:	0f b6 17             	movzbl (%edi),%edx
  80031e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800321:	3c 55                	cmp    $0x55,%al
  800323:	0f 87 12 05 00 00    	ja     80083b <vprintfmt+0x569>
  800329:	0f b6 c0             	movzbl %al,%eax
  80032c:	ff 24 85 a0 27 80 00 	jmp    *0x8027a0(,%eax,4)
  800333:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800336:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80033a:	eb d9                	jmp    800315 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80033c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80033f:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800343:	eb d0                	jmp    800315 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800345:	0f b6 d2             	movzbl %dl,%edx
  800348:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80034b:	b8 00 00 00 00       	mov    $0x0,%eax
  800350:	89 75 08             	mov    %esi,0x8(%ebp)
  800353:	eb 03                	jmp    800358 <vprintfmt+0x86>
  800355:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800358:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80035b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80035f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800362:	8d 72 d0             	lea    -0x30(%edx),%esi
  800365:	83 fe 09             	cmp    $0x9,%esi
  800368:	76 eb                	jbe    800355 <vprintfmt+0x83>
  80036a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036d:	8b 75 08             	mov    0x8(%ebp),%esi
  800370:	eb 14                	jmp    800386 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800372:	8b 45 14             	mov    0x14(%ebp),%eax
  800375:	8b 00                	mov    (%eax),%eax
  800377:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80037a:	8b 45 14             	mov    0x14(%ebp),%eax
  80037d:	8d 40 04             	lea    0x4(%eax),%eax
  800380:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800383:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800386:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80038a:	79 89                	jns    800315 <vprintfmt+0x43>
				width = precision, precision = -1;
  80038c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80038f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800392:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800399:	e9 77 ff ff ff       	jmp    800315 <vprintfmt+0x43>
  80039e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a1:	85 c0                	test   %eax,%eax
  8003a3:	0f 48 c1             	cmovs  %ecx,%eax
  8003a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ac:	e9 64 ff ff ff       	jmp    800315 <vprintfmt+0x43>
  8003b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003b4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003bb:	e9 55 ff ff ff       	jmp    800315 <vprintfmt+0x43>
			lflag++;
  8003c0:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003c7:	e9 49 ff ff ff       	jmp    800315 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cf:	8d 78 04             	lea    0x4(%eax),%edi
  8003d2:	83 ec 08             	sub    $0x8,%esp
  8003d5:	53                   	push   %ebx
  8003d6:	ff 30                	pushl  (%eax)
  8003d8:	ff d6                	call   *%esi
			break;
  8003da:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003dd:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003e0:	e9 33 03 00 00       	jmp    800718 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e8:	8d 78 04             	lea    0x4(%eax),%edi
  8003eb:	8b 00                	mov    (%eax),%eax
  8003ed:	99                   	cltd   
  8003ee:	31 d0                	xor    %edx,%eax
  8003f0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003f2:	83 f8 10             	cmp    $0x10,%eax
  8003f5:	7f 23                	jg     80041a <vprintfmt+0x148>
  8003f7:	8b 14 85 00 29 80 00 	mov    0x802900(,%eax,4),%edx
  8003fe:	85 d2                	test   %edx,%edx
  800400:	74 18                	je     80041a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800402:	52                   	push   %edx
  800403:	68 19 2a 80 00       	push   $0x802a19
  800408:	53                   	push   %ebx
  800409:	56                   	push   %esi
  80040a:	e8 a6 fe ff ff       	call   8002b5 <printfmt>
  80040f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800412:	89 7d 14             	mov    %edi,0x14(%ebp)
  800415:	e9 fe 02 00 00       	jmp    800718 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80041a:	50                   	push   %eax
  80041b:	68 dc 25 80 00       	push   $0x8025dc
  800420:	53                   	push   %ebx
  800421:	56                   	push   %esi
  800422:	e8 8e fe ff ff       	call   8002b5 <printfmt>
  800427:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80042a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80042d:	e9 e6 02 00 00       	jmp    800718 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800432:	8b 45 14             	mov    0x14(%ebp),%eax
  800435:	83 c0 04             	add    $0x4,%eax
  800438:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80043b:	8b 45 14             	mov    0x14(%ebp),%eax
  80043e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800440:	85 c9                	test   %ecx,%ecx
  800442:	b8 d5 25 80 00       	mov    $0x8025d5,%eax
  800447:	0f 45 c1             	cmovne %ecx,%eax
  80044a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80044d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800451:	7e 06                	jle    800459 <vprintfmt+0x187>
  800453:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800457:	75 0d                	jne    800466 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800459:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80045c:	89 c7                	mov    %eax,%edi
  80045e:	03 45 e0             	add    -0x20(%ebp),%eax
  800461:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800464:	eb 53                	jmp    8004b9 <vprintfmt+0x1e7>
  800466:	83 ec 08             	sub    $0x8,%esp
  800469:	ff 75 d8             	pushl  -0x28(%ebp)
  80046c:	50                   	push   %eax
  80046d:	e8 71 04 00 00       	call   8008e3 <strnlen>
  800472:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800475:	29 c1                	sub    %eax,%ecx
  800477:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80047a:	83 c4 10             	add    $0x10,%esp
  80047d:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80047f:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800483:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800486:	eb 0f                	jmp    800497 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800488:	83 ec 08             	sub    $0x8,%esp
  80048b:	53                   	push   %ebx
  80048c:	ff 75 e0             	pushl  -0x20(%ebp)
  80048f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800491:	83 ef 01             	sub    $0x1,%edi
  800494:	83 c4 10             	add    $0x10,%esp
  800497:	85 ff                	test   %edi,%edi
  800499:	7f ed                	jg     800488 <vprintfmt+0x1b6>
  80049b:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80049e:	85 c9                	test   %ecx,%ecx
  8004a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a5:	0f 49 c1             	cmovns %ecx,%eax
  8004a8:	29 c1                	sub    %eax,%ecx
  8004aa:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004ad:	eb aa                	jmp    800459 <vprintfmt+0x187>
					putch(ch, putdat);
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	53                   	push   %ebx
  8004b3:	52                   	push   %edx
  8004b4:	ff d6                	call   *%esi
  8004b6:	83 c4 10             	add    $0x10,%esp
  8004b9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004bc:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004be:	83 c7 01             	add    $0x1,%edi
  8004c1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004c5:	0f be d0             	movsbl %al,%edx
  8004c8:	85 d2                	test   %edx,%edx
  8004ca:	74 4b                	je     800517 <vprintfmt+0x245>
  8004cc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004d0:	78 06                	js     8004d8 <vprintfmt+0x206>
  8004d2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004d6:	78 1e                	js     8004f6 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004d8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004dc:	74 d1                	je     8004af <vprintfmt+0x1dd>
  8004de:	0f be c0             	movsbl %al,%eax
  8004e1:	83 e8 20             	sub    $0x20,%eax
  8004e4:	83 f8 5e             	cmp    $0x5e,%eax
  8004e7:	76 c6                	jbe    8004af <vprintfmt+0x1dd>
					putch('?', putdat);
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	53                   	push   %ebx
  8004ed:	6a 3f                	push   $0x3f
  8004ef:	ff d6                	call   *%esi
  8004f1:	83 c4 10             	add    $0x10,%esp
  8004f4:	eb c3                	jmp    8004b9 <vprintfmt+0x1e7>
  8004f6:	89 cf                	mov    %ecx,%edi
  8004f8:	eb 0e                	jmp    800508 <vprintfmt+0x236>
				putch(' ', putdat);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	53                   	push   %ebx
  8004fe:	6a 20                	push   $0x20
  800500:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800502:	83 ef 01             	sub    $0x1,%edi
  800505:	83 c4 10             	add    $0x10,%esp
  800508:	85 ff                	test   %edi,%edi
  80050a:	7f ee                	jg     8004fa <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80050c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80050f:	89 45 14             	mov    %eax,0x14(%ebp)
  800512:	e9 01 02 00 00       	jmp    800718 <vprintfmt+0x446>
  800517:	89 cf                	mov    %ecx,%edi
  800519:	eb ed                	jmp    800508 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80051b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80051e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800525:	e9 eb fd ff ff       	jmp    800315 <vprintfmt+0x43>
	if (lflag >= 2)
  80052a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80052e:	7f 21                	jg     800551 <vprintfmt+0x27f>
	else if (lflag)
  800530:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800534:	74 68                	je     80059e <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800536:	8b 45 14             	mov    0x14(%ebp),%eax
  800539:	8b 00                	mov    (%eax),%eax
  80053b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80053e:	89 c1                	mov    %eax,%ecx
  800540:	c1 f9 1f             	sar    $0x1f,%ecx
  800543:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800546:	8b 45 14             	mov    0x14(%ebp),%eax
  800549:	8d 40 04             	lea    0x4(%eax),%eax
  80054c:	89 45 14             	mov    %eax,0x14(%ebp)
  80054f:	eb 17                	jmp    800568 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800551:	8b 45 14             	mov    0x14(%ebp),%eax
  800554:	8b 50 04             	mov    0x4(%eax),%edx
  800557:	8b 00                	mov    (%eax),%eax
  800559:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80055c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8d 40 08             	lea    0x8(%eax),%eax
  800565:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800568:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80056e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800571:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800574:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800578:	78 3f                	js     8005b9 <vprintfmt+0x2e7>
			base = 10;
  80057a:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80057f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800583:	0f 84 71 01 00 00    	je     8006fa <vprintfmt+0x428>
				putch('+', putdat);
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	53                   	push   %ebx
  80058d:	6a 2b                	push   $0x2b
  80058f:	ff d6                	call   *%esi
  800591:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800594:	b8 0a 00 00 00       	mov    $0xa,%eax
  800599:	e9 5c 01 00 00       	jmp    8006fa <vprintfmt+0x428>
		return va_arg(*ap, int);
  80059e:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a6:	89 c1                	mov    %eax,%ecx
  8005a8:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ab:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8d 40 04             	lea    0x4(%eax),%eax
  8005b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b7:	eb af                	jmp    800568 <vprintfmt+0x296>
				putch('-', putdat);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	53                   	push   %ebx
  8005bd:	6a 2d                	push   $0x2d
  8005bf:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005c4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005c7:	f7 d8                	neg    %eax
  8005c9:	83 d2 00             	adc    $0x0,%edx
  8005cc:	f7 da                	neg    %edx
  8005ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005d7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005dc:	e9 19 01 00 00       	jmp    8006fa <vprintfmt+0x428>
	if (lflag >= 2)
  8005e1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005e5:	7f 29                	jg     800610 <vprintfmt+0x33e>
	else if (lflag)
  8005e7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005eb:	74 44                	je     800631 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8d 40 04             	lea    0x4(%eax),%eax
  800603:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800606:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060b:	e9 ea 00 00 00       	jmp    8006fa <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8b 50 04             	mov    0x4(%eax),%edx
  800616:	8b 00                	mov    (%eax),%eax
  800618:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8d 40 08             	lea    0x8(%eax),%eax
  800624:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800627:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062c:	e9 c9 00 00 00       	jmp    8006fa <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8b 00                	mov    (%eax),%eax
  800636:	ba 00 00 00 00       	mov    $0x0,%edx
  80063b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8d 40 04             	lea    0x4(%eax),%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80064f:	e9 a6 00 00 00       	jmp    8006fa <vprintfmt+0x428>
			putch('0', putdat);
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	53                   	push   %ebx
  800658:	6a 30                	push   $0x30
  80065a:	ff d6                	call   *%esi
	if (lflag >= 2)
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800663:	7f 26                	jg     80068b <vprintfmt+0x3b9>
	else if (lflag)
  800665:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800669:	74 3e                	je     8006a9 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8b 00                	mov    (%eax),%eax
  800670:	ba 00 00 00 00       	mov    $0x0,%edx
  800675:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800678:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8d 40 04             	lea    0x4(%eax),%eax
  800681:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800684:	b8 08 00 00 00       	mov    $0x8,%eax
  800689:	eb 6f                	jmp    8006fa <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8b 50 04             	mov    0x4(%eax),%edx
  800691:	8b 00                	mov    (%eax),%eax
  800693:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800696:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8d 40 08             	lea    0x8(%eax),%eax
  80069f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a2:	b8 08 00 00 00       	mov    $0x8,%eax
  8006a7:	eb 51                	jmp    8006fa <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8d 40 04             	lea    0x4(%eax),%eax
  8006bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006c2:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c7:	eb 31                	jmp    8006fa <vprintfmt+0x428>
			putch('0', putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	53                   	push   %ebx
  8006cd:	6a 30                	push   $0x30
  8006cf:	ff d6                	call   *%esi
			putch('x', putdat);
  8006d1:	83 c4 08             	add    $0x8,%esp
  8006d4:	53                   	push   %ebx
  8006d5:	6a 78                	push   $0x78
  8006d7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006e9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8d 40 04             	lea    0x4(%eax),%eax
  8006f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f5:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006fa:	83 ec 0c             	sub    $0xc,%esp
  8006fd:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800701:	52                   	push   %edx
  800702:	ff 75 e0             	pushl  -0x20(%ebp)
  800705:	50                   	push   %eax
  800706:	ff 75 dc             	pushl  -0x24(%ebp)
  800709:	ff 75 d8             	pushl  -0x28(%ebp)
  80070c:	89 da                	mov    %ebx,%edx
  80070e:	89 f0                	mov    %esi,%eax
  800710:	e8 a4 fa ff ff       	call   8001b9 <printnum>
			break;
  800715:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800718:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80071b:	83 c7 01             	add    $0x1,%edi
  80071e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800722:	83 f8 25             	cmp    $0x25,%eax
  800725:	0f 84 be fb ff ff    	je     8002e9 <vprintfmt+0x17>
			if (ch == '\0')
  80072b:	85 c0                	test   %eax,%eax
  80072d:	0f 84 28 01 00 00    	je     80085b <vprintfmt+0x589>
			putch(ch, putdat);
  800733:	83 ec 08             	sub    $0x8,%esp
  800736:	53                   	push   %ebx
  800737:	50                   	push   %eax
  800738:	ff d6                	call   *%esi
  80073a:	83 c4 10             	add    $0x10,%esp
  80073d:	eb dc                	jmp    80071b <vprintfmt+0x449>
	if (lflag >= 2)
  80073f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800743:	7f 26                	jg     80076b <vprintfmt+0x499>
	else if (lflag)
  800745:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800749:	74 41                	je     80078c <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	ba 00 00 00 00       	mov    $0x0,%edx
  800755:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800758:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8d 40 04             	lea    0x4(%eax),%eax
  800761:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800764:	b8 10 00 00 00       	mov    $0x10,%eax
  800769:	eb 8f                	jmp    8006fa <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8b 50 04             	mov    0x4(%eax),%edx
  800771:	8b 00                	mov    (%eax),%eax
  800773:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800776:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8d 40 08             	lea    0x8(%eax),%eax
  80077f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800782:	b8 10 00 00 00       	mov    $0x10,%eax
  800787:	e9 6e ff ff ff       	jmp    8006fa <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	ba 00 00 00 00       	mov    $0x0,%edx
  800796:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800799:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8d 40 04             	lea    0x4(%eax),%eax
  8007a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a5:	b8 10 00 00 00       	mov    $0x10,%eax
  8007aa:	e9 4b ff ff ff       	jmp    8006fa <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	83 c0 04             	add    $0x4,%eax
  8007b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	8b 00                	mov    (%eax),%eax
  8007bd:	85 c0                	test   %eax,%eax
  8007bf:	74 14                	je     8007d5 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007c1:	8b 13                	mov    (%ebx),%edx
  8007c3:	83 fa 7f             	cmp    $0x7f,%edx
  8007c6:	7f 37                	jg     8007ff <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007c8:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d0:	e9 43 ff ff ff       	jmp    800718 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007da:	bf f9 26 80 00       	mov    $0x8026f9,%edi
							putch(ch, putdat);
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	53                   	push   %ebx
  8007e3:	50                   	push   %eax
  8007e4:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007e6:	83 c7 01             	add    $0x1,%edi
  8007e9:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007ed:	83 c4 10             	add    $0x10,%esp
  8007f0:	85 c0                	test   %eax,%eax
  8007f2:	75 eb                	jne    8007df <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fa:	e9 19 ff ff ff       	jmp    800718 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007ff:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800801:	b8 0a 00 00 00       	mov    $0xa,%eax
  800806:	bf 31 27 80 00       	mov    $0x802731,%edi
							putch(ch, putdat);
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	53                   	push   %ebx
  80080f:	50                   	push   %eax
  800810:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800812:	83 c7 01             	add    $0x1,%edi
  800815:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800819:	83 c4 10             	add    $0x10,%esp
  80081c:	85 c0                	test   %eax,%eax
  80081e:	75 eb                	jne    80080b <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800820:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
  800826:	e9 ed fe ff ff       	jmp    800718 <vprintfmt+0x446>
			putch(ch, putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	53                   	push   %ebx
  80082f:	6a 25                	push   $0x25
  800831:	ff d6                	call   *%esi
			break;
  800833:	83 c4 10             	add    $0x10,%esp
  800836:	e9 dd fe ff ff       	jmp    800718 <vprintfmt+0x446>
			putch('%', putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	53                   	push   %ebx
  80083f:	6a 25                	push   $0x25
  800841:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800843:	83 c4 10             	add    $0x10,%esp
  800846:	89 f8                	mov    %edi,%eax
  800848:	eb 03                	jmp    80084d <vprintfmt+0x57b>
  80084a:	83 e8 01             	sub    $0x1,%eax
  80084d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800851:	75 f7                	jne    80084a <vprintfmt+0x578>
  800853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800856:	e9 bd fe ff ff       	jmp    800718 <vprintfmt+0x446>
}
  80085b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80085e:	5b                   	pop    %ebx
  80085f:	5e                   	pop    %esi
  800860:	5f                   	pop    %edi
  800861:	5d                   	pop    %ebp
  800862:	c3                   	ret    

00800863 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	83 ec 18             	sub    $0x18,%esp
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80086f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800872:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800876:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800879:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800880:	85 c0                	test   %eax,%eax
  800882:	74 26                	je     8008aa <vsnprintf+0x47>
  800884:	85 d2                	test   %edx,%edx
  800886:	7e 22                	jle    8008aa <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800888:	ff 75 14             	pushl  0x14(%ebp)
  80088b:	ff 75 10             	pushl  0x10(%ebp)
  80088e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800891:	50                   	push   %eax
  800892:	68 98 02 80 00       	push   $0x800298
  800897:	e8 36 fa ff ff       	call   8002d2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80089c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80089f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a5:	83 c4 10             	add    $0x10,%esp
}
  8008a8:	c9                   	leave  
  8008a9:	c3                   	ret    
		return -E_INVAL;
  8008aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008af:	eb f7                	jmp    8008a8 <vsnprintf+0x45>

008008b1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008b7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008ba:	50                   	push   %eax
  8008bb:	ff 75 10             	pushl  0x10(%ebp)
  8008be:	ff 75 0c             	pushl  0xc(%ebp)
  8008c1:	ff 75 08             	pushl  0x8(%ebp)
  8008c4:	e8 9a ff ff ff       	call   800863 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008c9:	c9                   	leave  
  8008ca:	c3                   	ret    

008008cb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008da:	74 05                	je     8008e1 <strlen+0x16>
		n++;
  8008dc:	83 c0 01             	add    $0x1,%eax
  8008df:	eb f5                	jmp    8008d6 <strlen+0xb>
	return n;
}
  8008e1:	5d                   	pop    %ebp
  8008e2:	c3                   	ret    

008008e3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f1:	39 c2                	cmp    %eax,%edx
  8008f3:	74 0d                	je     800902 <strnlen+0x1f>
  8008f5:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008f9:	74 05                	je     800900 <strnlen+0x1d>
		n++;
  8008fb:	83 c2 01             	add    $0x1,%edx
  8008fe:	eb f1                	jmp    8008f1 <strnlen+0xe>
  800900:	89 d0                	mov    %edx,%eax
	return n;
}
  800902:	5d                   	pop    %ebp
  800903:	c3                   	ret    

00800904 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	53                   	push   %ebx
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80090e:	ba 00 00 00 00       	mov    $0x0,%edx
  800913:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800917:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80091a:	83 c2 01             	add    $0x1,%edx
  80091d:	84 c9                	test   %cl,%cl
  80091f:	75 f2                	jne    800913 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800921:	5b                   	pop    %ebx
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	53                   	push   %ebx
  800928:	83 ec 10             	sub    $0x10,%esp
  80092b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80092e:	53                   	push   %ebx
  80092f:	e8 97 ff ff ff       	call   8008cb <strlen>
  800934:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800937:	ff 75 0c             	pushl  0xc(%ebp)
  80093a:	01 d8                	add    %ebx,%eax
  80093c:	50                   	push   %eax
  80093d:	e8 c2 ff ff ff       	call   800904 <strcpy>
	return dst;
}
  800942:	89 d8                	mov    %ebx,%eax
  800944:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800947:	c9                   	leave  
  800948:	c3                   	ret    

00800949 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	56                   	push   %esi
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800954:	89 c6                	mov    %eax,%esi
  800956:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800959:	89 c2                	mov    %eax,%edx
  80095b:	39 f2                	cmp    %esi,%edx
  80095d:	74 11                	je     800970 <strncpy+0x27>
		*dst++ = *src;
  80095f:	83 c2 01             	add    $0x1,%edx
  800962:	0f b6 19             	movzbl (%ecx),%ebx
  800965:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800968:	80 fb 01             	cmp    $0x1,%bl
  80096b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80096e:	eb eb                	jmp    80095b <strncpy+0x12>
	}
	return ret;
}
  800970:	5b                   	pop    %ebx
  800971:	5e                   	pop    %esi
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	56                   	push   %esi
  800978:	53                   	push   %ebx
  800979:	8b 75 08             	mov    0x8(%ebp),%esi
  80097c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80097f:	8b 55 10             	mov    0x10(%ebp),%edx
  800982:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800984:	85 d2                	test   %edx,%edx
  800986:	74 21                	je     8009a9 <strlcpy+0x35>
  800988:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80098c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80098e:	39 c2                	cmp    %eax,%edx
  800990:	74 14                	je     8009a6 <strlcpy+0x32>
  800992:	0f b6 19             	movzbl (%ecx),%ebx
  800995:	84 db                	test   %bl,%bl
  800997:	74 0b                	je     8009a4 <strlcpy+0x30>
			*dst++ = *src++;
  800999:	83 c1 01             	add    $0x1,%ecx
  80099c:	83 c2 01             	add    $0x1,%edx
  80099f:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009a2:	eb ea                	jmp    80098e <strlcpy+0x1a>
  8009a4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009a6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009a9:	29 f0                	sub    %esi,%eax
}
  8009ab:	5b                   	pop    %ebx
  8009ac:	5e                   	pop    %esi
  8009ad:	5d                   	pop    %ebp
  8009ae:	c3                   	ret    

008009af <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009b8:	0f b6 01             	movzbl (%ecx),%eax
  8009bb:	84 c0                	test   %al,%al
  8009bd:	74 0c                	je     8009cb <strcmp+0x1c>
  8009bf:	3a 02                	cmp    (%edx),%al
  8009c1:	75 08                	jne    8009cb <strcmp+0x1c>
		p++, q++;
  8009c3:	83 c1 01             	add    $0x1,%ecx
  8009c6:	83 c2 01             	add    $0x1,%edx
  8009c9:	eb ed                	jmp    8009b8 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009cb:	0f b6 c0             	movzbl %al,%eax
  8009ce:	0f b6 12             	movzbl (%edx),%edx
  8009d1:	29 d0                	sub    %edx,%eax
}
  8009d3:	5d                   	pop    %ebp
  8009d4:	c3                   	ret    

008009d5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	53                   	push   %ebx
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009df:	89 c3                	mov    %eax,%ebx
  8009e1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009e4:	eb 06                	jmp    8009ec <strncmp+0x17>
		n--, p++, q++;
  8009e6:	83 c0 01             	add    $0x1,%eax
  8009e9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009ec:	39 d8                	cmp    %ebx,%eax
  8009ee:	74 16                	je     800a06 <strncmp+0x31>
  8009f0:	0f b6 08             	movzbl (%eax),%ecx
  8009f3:	84 c9                	test   %cl,%cl
  8009f5:	74 04                	je     8009fb <strncmp+0x26>
  8009f7:	3a 0a                	cmp    (%edx),%cl
  8009f9:	74 eb                	je     8009e6 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009fb:	0f b6 00             	movzbl (%eax),%eax
  8009fe:	0f b6 12             	movzbl (%edx),%edx
  800a01:	29 d0                	sub    %edx,%eax
}
  800a03:	5b                   	pop    %ebx
  800a04:	5d                   	pop    %ebp
  800a05:	c3                   	ret    
		return 0;
  800a06:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0b:	eb f6                	jmp    800a03 <strncmp+0x2e>

00800a0d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a17:	0f b6 10             	movzbl (%eax),%edx
  800a1a:	84 d2                	test   %dl,%dl
  800a1c:	74 09                	je     800a27 <strchr+0x1a>
		if (*s == c)
  800a1e:	38 ca                	cmp    %cl,%dl
  800a20:	74 0a                	je     800a2c <strchr+0x1f>
	for (; *s; s++)
  800a22:	83 c0 01             	add    $0x1,%eax
  800a25:	eb f0                	jmp    800a17 <strchr+0xa>
			return (char *) s;
	return 0;
  800a27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a2c:	5d                   	pop    %ebp
  800a2d:	c3                   	ret    

00800a2e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a38:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a3b:	38 ca                	cmp    %cl,%dl
  800a3d:	74 09                	je     800a48 <strfind+0x1a>
  800a3f:	84 d2                	test   %dl,%dl
  800a41:	74 05                	je     800a48 <strfind+0x1a>
	for (; *s; s++)
  800a43:	83 c0 01             	add    $0x1,%eax
  800a46:	eb f0                	jmp    800a38 <strfind+0xa>
			break;
	return (char *) s;
}
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    

00800a4a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	57                   	push   %edi
  800a4e:	56                   	push   %esi
  800a4f:	53                   	push   %ebx
  800a50:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a53:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a56:	85 c9                	test   %ecx,%ecx
  800a58:	74 31                	je     800a8b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a5a:	89 f8                	mov    %edi,%eax
  800a5c:	09 c8                	or     %ecx,%eax
  800a5e:	a8 03                	test   $0x3,%al
  800a60:	75 23                	jne    800a85 <memset+0x3b>
		c &= 0xFF;
  800a62:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a66:	89 d3                	mov    %edx,%ebx
  800a68:	c1 e3 08             	shl    $0x8,%ebx
  800a6b:	89 d0                	mov    %edx,%eax
  800a6d:	c1 e0 18             	shl    $0x18,%eax
  800a70:	89 d6                	mov    %edx,%esi
  800a72:	c1 e6 10             	shl    $0x10,%esi
  800a75:	09 f0                	or     %esi,%eax
  800a77:	09 c2                	or     %eax,%edx
  800a79:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a7b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a7e:	89 d0                	mov    %edx,%eax
  800a80:	fc                   	cld    
  800a81:	f3 ab                	rep stos %eax,%es:(%edi)
  800a83:	eb 06                	jmp    800a8b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a88:	fc                   	cld    
  800a89:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a8b:	89 f8                	mov    %edi,%eax
  800a8d:	5b                   	pop    %ebx
  800a8e:	5e                   	pop    %esi
  800a8f:	5f                   	pop    %edi
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	57                   	push   %edi
  800a96:	56                   	push   %esi
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aa0:	39 c6                	cmp    %eax,%esi
  800aa2:	73 32                	jae    800ad6 <memmove+0x44>
  800aa4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aa7:	39 c2                	cmp    %eax,%edx
  800aa9:	76 2b                	jbe    800ad6 <memmove+0x44>
		s += n;
		d += n;
  800aab:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aae:	89 fe                	mov    %edi,%esi
  800ab0:	09 ce                	or     %ecx,%esi
  800ab2:	09 d6                	or     %edx,%esi
  800ab4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aba:	75 0e                	jne    800aca <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800abc:	83 ef 04             	sub    $0x4,%edi
  800abf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ac2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ac5:	fd                   	std    
  800ac6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac8:	eb 09                	jmp    800ad3 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aca:	83 ef 01             	sub    $0x1,%edi
  800acd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ad0:	fd                   	std    
  800ad1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ad3:	fc                   	cld    
  800ad4:	eb 1a                	jmp    800af0 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad6:	89 c2                	mov    %eax,%edx
  800ad8:	09 ca                	or     %ecx,%edx
  800ada:	09 f2                	or     %esi,%edx
  800adc:	f6 c2 03             	test   $0x3,%dl
  800adf:	75 0a                	jne    800aeb <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ae1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ae4:	89 c7                	mov    %eax,%edi
  800ae6:	fc                   	cld    
  800ae7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae9:	eb 05                	jmp    800af0 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800aeb:	89 c7                	mov    %eax,%edi
  800aed:	fc                   	cld    
  800aee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800af0:	5e                   	pop    %esi
  800af1:	5f                   	pop    %edi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800afa:	ff 75 10             	pushl  0x10(%ebp)
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	ff 75 08             	pushl  0x8(%ebp)
  800b03:	e8 8a ff ff ff       	call   800a92 <memmove>
}
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    

00800b0a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	56                   	push   %esi
  800b0e:	53                   	push   %ebx
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b15:	89 c6                	mov    %eax,%esi
  800b17:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b1a:	39 f0                	cmp    %esi,%eax
  800b1c:	74 1c                	je     800b3a <memcmp+0x30>
		if (*s1 != *s2)
  800b1e:	0f b6 08             	movzbl (%eax),%ecx
  800b21:	0f b6 1a             	movzbl (%edx),%ebx
  800b24:	38 d9                	cmp    %bl,%cl
  800b26:	75 08                	jne    800b30 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b28:	83 c0 01             	add    $0x1,%eax
  800b2b:	83 c2 01             	add    $0x1,%edx
  800b2e:	eb ea                	jmp    800b1a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b30:	0f b6 c1             	movzbl %cl,%eax
  800b33:	0f b6 db             	movzbl %bl,%ebx
  800b36:	29 d8                	sub    %ebx,%eax
  800b38:	eb 05                	jmp    800b3f <memcmp+0x35>
	}

	return 0;
  800b3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b3f:	5b                   	pop    %ebx
  800b40:	5e                   	pop    %esi
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b4c:	89 c2                	mov    %eax,%edx
  800b4e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b51:	39 d0                	cmp    %edx,%eax
  800b53:	73 09                	jae    800b5e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b55:	38 08                	cmp    %cl,(%eax)
  800b57:	74 05                	je     800b5e <memfind+0x1b>
	for (; s < ends; s++)
  800b59:	83 c0 01             	add    $0x1,%eax
  800b5c:	eb f3                	jmp    800b51 <memfind+0xe>
			break;
	return (void *) s;
}
  800b5e:	5d                   	pop    %ebp
  800b5f:	c3                   	ret    

00800b60 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	57                   	push   %edi
  800b64:	56                   	push   %esi
  800b65:	53                   	push   %ebx
  800b66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b69:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b6c:	eb 03                	jmp    800b71 <strtol+0x11>
		s++;
  800b6e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b71:	0f b6 01             	movzbl (%ecx),%eax
  800b74:	3c 20                	cmp    $0x20,%al
  800b76:	74 f6                	je     800b6e <strtol+0xe>
  800b78:	3c 09                	cmp    $0x9,%al
  800b7a:	74 f2                	je     800b6e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b7c:	3c 2b                	cmp    $0x2b,%al
  800b7e:	74 2a                	je     800baa <strtol+0x4a>
	int neg = 0;
  800b80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b85:	3c 2d                	cmp    $0x2d,%al
  800b87:	74 2b                	je     800bb4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b89:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b8f:	75 0f                	jne    800ba0 <strtol+0x40>
  800b91:	80 39 30             	cmpb   $0x30,(%ecx)
  800b94:	74 28                	je     800bbe <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b96:	85 db                	test   %ebx,%ebx
  800b98:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b9d:	0f 44 d8             	cmove  %eax,%ebx
  800ba0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ba8:	eb 50                	jmp    800bfa <strtol+0x9a>
		s++;
  800baa:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bad:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb2:	eb d5                	jmp    800b89 <strtol+0x29>
		s++, neg = 1;
  800bb4:	83 c1 01             	add    $0x1,%ecx
  800bb7:	bf 01 00 00 00       	mov    $0x1,%edi
  800bbc:	eb cb                	jmp    800b89 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bbe:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bc2:	74 0e                	je     800bd2 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bc4:	85 db                	test   %ebx,%ebx
  800bc6:	75 d8                	jne    800ba0 <strtol+0x40>
		s++, base = 8;
  800bc8:	83 c1 01             	add    $0x1,%ecx
  800bcb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bd0:	eb ce                	jmp    800ba0 <strtol+0x40>
		s += 2, base = 16;
  800bd2:	83 c1 02             	add    $0x2,%ecx
  800bd5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bda:	eb c4                	jmp    800ba0 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bdc:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bdf:	89 f3                	mov    %esi,%ebx
  800be1:	80 fb 19             	cmp    $0x19,%bl
  800be4:	77 29                	ja     800c0f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800be6:	0f be d2             	movsbl %dl,%edx
  800be9:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bec:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bef:	7d 30                	jge    800c21 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bf1:	83 c1 01             	add    $0x1,%ecx
  800bf4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bf8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bfa:	0f b6 11             	movzbl (%ecx),%edx
  800bfd:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c00:	89 f3                	mov    %esi,%ebx
  800c02:	80 fb 09             	cmp    $0x9,%bl
  800c05:	77 d5                	ja     800bdc <strtol+0x7c>
			dig = *s - '0';
  800c07:	0f be d2             	movsbl %dl,%edx
  800c0a:	83 ea 30             	sub    $0x30,%edx
  800c0d:	eb dd                	jmp    800bec <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c0f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c12:	89 f3                	mov    %esi,%ebx
  800c14:	80 fb 19             	cmp    $0x19,%bl
  800c17:	77 08                	ja     800c21 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c19:	0f be d2             	movsbl %dl,%edx
  800c1c:	83 ea 37             	sub    $0x37,%edx
  800c1f:	eb cb                	jmp    800bec <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c25:	74 05                	je     800c2c <strtol+0xcc>
		*endptr = (char *) s;
  800c27:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c2a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c2c:	89 c2                	mov    %eax,%edx
  800c2e:	f7 da                	neg    %edx
  800c30:	85 ff                	test   %edi,%edi
  800c32:	0f 45 c2             	cmovne %edx,%eax
}
  800c35:	5b                   	pop    %ebx
  800c36:	5e                   	pop    %esi
  800c37:	5f                   	pop    %edi
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    

00800c3a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	57                   	push   %edi
  800c3e:	56                   	push   %esi
  800c3f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c40:	b8 00 00 00 00       	mov    $0x0,%eax
  800c45:	8b 55 08             	mov    0x8(%ebp),%edx
  800c48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4b:	89 c3                	mov    %eax,%ebx
  800c4d:	89 c7                	mov    %eax,%edi
  800c4f:	89 c6                	mov    %eax,%esi
  800c51:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	57                   	push   %edi
  800c5c:	56                   	push   %esi
  800c5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c63:	b8 01 00 00 00       	mov    $0x1,%eax
  800c68:	89 d1                	mov    %edx,%ecx
  800c6a:	89 d3                	mov    %edx,%ebx
  800c6c:	89 d7                	mov    %edx,%edi
  800c6e:	89 d6                	mov    %edx,%esi
  800c70:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c72:	5b                   	pop    %ebx
  800c73:	5e                   	pop    %esi
  800c74:	5f                   	pop    %edi
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    

00800c77 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	57                   	push   %edi
  800c7b:	56                   	push   %esi
  800c7c:	53                   	push   %ebx
  800c7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c80:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c85:	8b 55 08             	mov    0x8(%ebp),%edx
  800c88:	b8 03 00 00 00       	mov    $0x3,%eax
  800c8d:	89 cb                	mov    %ecx,%ebx
  800c8f:	89 cf                	mov    %ecx,%edi
  800c91:	89 ce                	mov    %ecx,%esi
  800c93:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c95:	85 c0                	test   %eax,%eax
  800c97:	7f 08                	jg     800ca1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c9c:	5b                   	pop    %ebx
  800c9d:	5e                   	pop    %esi
  800c9e:	5f                   	pop    %edi
  800c9f:	5d                   	pop    %ebp
  800ca0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca1:	83 ec 0c             	sub    $0xc,%esp
  800ca4:	50                   	push   %eax
  800ca5:	6a 03                	push   $0x3
  800ca7:	68 44 29 80 00       	push   $0x802944
  800cac:	6a 43                	push   $0x43
  800cae:	68 61 29 80 00       	push   $0x802961
  800cb3:	e8 8f 14 00 00       	call   802147 <_panic>

00800cb8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	57                   	push   %edi
  800cbc:	56                   	push   %esi
  800cbd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc3:	b8 02 00 00 00       	mov    $0x2,%eax
  800cc8:	89 d1                	mov    %edx,%ecx
  800cca:	89 d3                	mov    %edx,%ebx
  800ccc:	89 d7                	mov    %edx,%edi
  800cce:	89 d6                	mov    %edx,%esi
  800cd0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cd2:	5b                   	pop    %ebx
  800cd3:	5e                   	pop    %esi
  800cd4:	5f                   	pop    %edi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <sys_yield>:

void
sys_yield(void)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cdd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ce7:	89 d1                	mov    %edx,%ecx
  800ce9:	89 d3                	mov    %edx,%ebx
  800ceb:	89 d7                	mov    %edx,%edi
  800ced:	89 d6                	mov    %edx,%esi
  800cef:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cf1:	5b                   	pop    %ebx
  800cf2:	5e                   	pop    %esi
  800cf3:	5f                   	pop    %edi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	53                   	push   %ebx
  800cfc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cff:	be 00 00 00 00       	mov    $0x0,%esi
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0a:	b8 04 00 00 00       	mov    $0x4,%eax
  800d0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d12:	89 f7                	mov    %esi,%edi
  800d14:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d16:	85 c0                	test   %eax,%eax
  800d18:	7f 08                	jg     800d22 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1d:	5b                   	pop    %ebx
  800d1e:	5e                   	pop    %esi
  800d1f:	5f                   	pop    %edi
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d22:	83 ec 0c             	sub    $0xc,%esp
  800d25:	50                   	push   %eax
  800d26:	6a 04                	push   $0x4
  800d28:	68 44 29 80 00       	push   $0x802944
  800d2d:	6a 43                	push   $0x43
  800d2f:	68 61 29 80 00       	push   $0x802961
  800d34:	e8 0e 14 00 00       	call   802147 <_panic>

00800d39 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	57                   	push   %edi
  800d3d:	56                   	push   %esi
  800d3e:	53                   	push   %ebx
  800d3f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d42:	8b 55 08             	mov    0x8(%ebp),%edx
  800d45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d48:	b8 05 00 00 00       	mov    $0x5,%eax
  800d4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d50:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d53:	8b 75 18             	mov    0x18(%ebp),%esi
  800d56:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d58:	85 c0                	test   %eax,%eax
  800d5a:	7f 08                	jg     800d64 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5f:	5b                   	pop    %ebx
  800d60:	5e                   	pop    %esi
  800d61:	5f                   	pop    %edi
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d64:	83 ec 0c             	sub    $0xc,%esp
  800d67:	50                   	push   %eax
  800d68:	6a 05                	push   $0x5
  800d6a:	68 44 29 80 00       	push   $0x802944
  800d6f:	6a 43                	push   $0x43
  800d71:	68 61 29 80 00       	push   $0x802961
  800d76:	e8 cc 13 00 00       	call   802147 <_panic>

00800d7b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	57                   	push   %edi
  800d7f:	56                   	push   %esi
  800d80:	53                   	push   %ebx
  800d81:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d84:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d89:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8f:	b8 06 00 00 00       	mov    $0x6,%eax
  800d94:	89 df                	mov    %ebx,%edi
  800d96:	89 de                	mov    %ebx,%esi
  800d98:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9a:	85 c0                	test   %eax,%eax
  800d9c:	7f 08                	jg     800da6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da1:	5b                   	pop    %ebx
  800da2:	5e                   	pop    %esi
  800da3:	5f                   	pop    %edi
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da6:	83 ec 0c             	sub    $0xc,%esp
  800da9:	50                   	push   %eax
  800daa:	6a 06                	push   $0x6
  800dac:	68 44 29 80 00       	push   $0x802944
  800db1:	6a 43                	push   $0x43
  800db3:	68 61 29 80 00       	push   $0x802961
  800db8:	e8 8a 13 00 00       	call   802147 <_panic>

00800dbd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	57                   	push   %edi
  800dc1:	56                   	push   %esi
  800dc2:	53                   	push   %ebx
  800dc3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd1:	b8 08 00 00 00       	mov    $0x8,%eax
  800dd6:	89 df                	mov    %ebx,%edi
  800dd8:	89 de                	mov    %ebx,%esi
  800dda:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ddc:	85 c0                	test   %eax,%eax
  800dde:	7f 08                	jg     800de8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de3:	5b                   	pop    %ebx
  800de4:	5e                   	pop    %esi
  800de5:	5f                   	pop    %edi
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de8:	83 ec 0c             	sub    $0xc,%esp
  800deb:	50                   	push   %eax
  800dec:	6a 08                	push   $0x8
  800dee:	68 44 29 80 00       	push   $0x802944
  800df3:	6a 43                	push   $0x43
  800df5:	68 61 29 80 00       	push   $0x802961
  800dfa:	e8 48 13 00 00       	call   802147 <_panic>

00800dff <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	57                   	push   %edi
  800e03:	56                   	push   %esi
  800e04:	53                   	push   %ebx
  800e05:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e08:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e13:	b8 09 00 00 00       	mov    $0x9,%eax
  800e18:	89 df                	mov    %ebx,%edi
  800e1a:	89 de                	mov    %ebx,%esi
  800e1c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1e:	85 c0                	test   %eax,%eax
  800e20:	7f 08                	jg     800e2a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e25:	5b                   	pop    %ebx
  800e26:	5e                   	pop    %esi
  800e27:	5f                   	pop    %edi
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2a:	83 ec 0c             	sub    $0xc,%esp
  800e2d:	50                   	push   %eax
  800e2e:	6a 09                	push   $0x9
  800e30:	68 44 29 80 00       	push   $0x802944
  800e35:	6a 43                	push   $0x43
  800e37:	68 61 29 80 00       	push   $0x802961
  800e3c:	e8 06 13 00 00       	call   802147 <_panic>

00800e41 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	57                   	push   %edi
  800e45:	56                   	push   %esi
  800e46:	53                   	push   %ebx
  800e47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e55:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e5a:	89 df                	mov    %ebx,%edi
  800e5c:	89 de                	mov    %ebx,%esi
  800e5e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e60:	85 c0                	test   %eax,%eax
  800e62:	7f 08                	jg     800e6c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e67:	5b                   	pop    %ebx
  800e68:	5e                   	pop    %esi
  800e69:	5f                   	pop    %edi
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6c:	83 ec 0c             	sub    $0xc,%esp
  800e6f:	50                   	push   %eax
  800e70:	6a 0a                	push   $0xa
  800e72:	68 44 29 80 00       	push   $0x802944
  800e77:	6a 43                	push   $0x43
  800e79:	68 61 29 80 00       	push   $0x802961
  800e7e:	e8 c4 12 00 00       	call   802147 <_panic>

00800e83 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	57                   	push   %edi
  800e87:	56                   	push   %esi
  800e88:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e89:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e94:	be 00 00 00 00       	mov    $0x0,%esi
  800e99:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e9c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e9f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ea1:	5b                   	pop    %ebx
  800ea2:	5e                   	pop    %esi
  800ea3:	5f                   	pop    %edi
  800ea4:	5d                   	pop    %ebp
  800ea5:	c3                   	ret    

00800ea6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	57                   	push   %edi
  800eaa:	56                   	push   %esi
  800eab:	53                   	push   %ebx
  800eac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eaf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ebc:	89 cb                	mov    %ecx,%ebx
  800ebe:	89 cf                	mov    %ecx,%edi
  800ec0:	89 ce                	mov    %ecx,%esi
  800ec2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	7f 08                	jg     800ed0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ec8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ecb:	5b                   	pop    %ebx
  800ecc:	5e                   	pop    %esi
  800ecd:	5f                   	pop    %edi
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed0:	83 ec 0c             	sub    $0xc,%esp
  800ed3:	50                   	push   %eax
  800ed4:	6a 0d                	push   $0xd
  800ed6:	68 44 29 80 00       	push   $0x802944
  800edb:	6a 43                	push   $0x43
  800edd:	68 61 29 80 00       	push   $0x802961
  800ee2:	e8 60 12 00 00       	call   802147 <_panic>

00800ee7 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	57                   	push   %edi
  800eeb:	56                   	push   %esi
  800eec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eed:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef8:	b8 0e 00 00 00       	mov    $0xe,%eax
  800efd:	89 df                	mov    %ebx,%edi
  800eff:	89 de                	mov    %ebx,%esi
  800f01:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f03:	5b                   	pop    %ebx
  800f04:	5e                   	pop    %esi
  800f05:	5f                   	pop    %edi
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    

00800f08 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	57                   	push   %edi
  800f0c:	56                   	push   %esi
  800f0d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f13:	8b 55 08             	mov    0x8(%ebp),%edx
  800f16:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f1b:	89 cb                	mov    %ecx,%ebx
  800f1d:	89 cf                	mov    %ecx,%edi
  800f1f:	89 ce                	mov    %ecx,%esi
  800f21:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f23:	5b                   	pop    %ebx
  800f24:	5e                   	pop    %esi
  800f25:	5f                   	pop    %edi
  800f26:	5d                   	pop    %ebp
  800f27:	c3                   	ret    

00800f28 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	57                   	push   %edi
  800f2c:	56                   	push   %esi
  800f2d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f33:	b8 10 00 00 00       	mov    $0x10,%eax
  800f38:	89 d1                	mov    %edx,%ecx
  800f3a:	89 d3                	mov    %edx,%ebx
  800f3c:	89 d7                	mov    %edx,%edi
  800f3e:	89 d6                	mov    %edx,%esi
  800f40:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f42:	5b                   	pop    %ebx
  800f43:	5e                   	pop    %esi
  800f44:	5f                   	pop    %edi
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    

00800f47 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	57                   	push   %edi
  800f4b:	56                   	push   %esi
  800f4c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f52:	8b 55 08             	mov    0x8(%ebp),%edx
  800f55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f58:	b8 11 00 00 00       	mov    $0x11,%eax
  800f5d:	89 df                	mov    %ebx,%edi
  800f5f:	89 de                	mov    %ebx,%esi
  800f61:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f63:	5b                   	pop    %ebx
  800f64:	5e                   	pop    %esi
  800f65:	5f                   	pop    %edi
  800f66:	5d                   	pop    %ebp
  800f67:	c3                   	ret    

00800f68 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	57                   	push   %edi
  800f6c:	56                   	push   %esi
  800f6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f73:	8b 55 08             	mov    0x8(%ebp),%edx
  800f76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f79:	b8 12 00 00 00       	mov    $0x12,%eax
  800f7e:	89 df                	mov    %ebx,%edi
  800f80:	89 de                	mov    %ebx,%esi
  800f82:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5f                   	pop    %edi
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    

00800f89 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	57                   	push   %edi
  800f8d:	56                   	push   %esi
  800f8e:	53                   	push   %ebx
  800f8f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f92:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f97:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9d:	b8 13 00 00 00       	mov    $0x13,%eax
  800fa2:	89 df                	mov    %ebx,%edi
  800fa4:	89 de                	mov    %ebx,%esi
  800fa6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa8:	85 c0                	test   %eax,%eax
  800faa:	7f 08                	jg     800fb4 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800faf:	5b                   	pop    %ebx
  800fb0:	5e                   	pop    %esi
  800fb1:	5f                   	pop    %edi
  800fb2:	5d                   	pop    %ebp
  800fb3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb4:	83 ec 0c             	sub    $0xc,%esp
  800fb7:	50                   	push   %eax
  800fb8:	6a 13                	push   $0x13
  800fba:	68 44 29 80 00       	push   $0x802944
  800fbf:	6a 43                	push   $0x43
  800fc1:	68 61 29 80 00       	push   $0x802961
  800fc6:	e8 7c 11 00 00       	call   802147 <_panic>

00800fcb <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800fcb:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800fcc:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  800fd1:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800fd3:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  800fd6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  800fda:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  800fde:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800fe1:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  800fe3:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  800fe7:	83 c4 08             	add    $0x8,%esp
	popal
  800fea:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  800feb:	83 c4 04             	add    $0x4,%esp
	popfl
  800fee:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800fef:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800ff0:	c3                   	ret    

00800ff1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	05 00 00 00 30       	add    $0x30000000,%eax
  800ffc:	c1 e8 0c             	shr    $0xc,%eax
}
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    

00801001 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80100c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801011:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    

00801018 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801020:	89 c2                	mov    %eax,%edx
  801022:	c1 ea 16             	shr    $0x16,%edx
  801025:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80102c:	f6 c2 01             	test   $0x1,%dl
  80102f:	74 2d                	je     80105e <fd_alloc+0x46>
  801031:	89 c2                	mov    %eax,%edx
  801033:	c1 ea 0c             	shr    $0xc,%edx
  801036:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80103d:	f6 c2 01             	test   $0x1,%dl
  801040:	74 1c                	je     80105e <fd_alloc+0x46>
  801042:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801047:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80104c:	75 d2                	jne    801020 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801057:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80105c:	eb 0a                	jmp    801068 <fd_alloc+0x50>
			*fd_store = fd;
  80105e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801061:	89 01                	mov    %eax,(%ecx)
			return 0;
  801063:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    

0080106a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801070:	83 f8 1f             	cmp    $0x1f,%eax
  801073:	77 30                	ja     8010a5 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801075:	c1 e0 0c             	shl    $0xc,%eax
  801078:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80107d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801083:	f6 c2 01             	test   $0x1,%dl
  801086:	74 24                	je     8010ac <fd_lookup+0x42>
  801088:	89 c2                	mov    %eax,%edx
  80108a:	c1 ea 0c             	shr    $0xc,%edx
  80108d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801094:	f6 c2 01             	test   $0x1,%dl
  801097:	74 1a                	je     8010b3 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801099:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109c:	89 02                	mov    %eax,(%edx)
	return 0;
  80109e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    
		return -E_INVAL;
  8010a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010aa:	eb f7                	jmp    8010a3 <fd_lookup+0x39>
		return -E_INVAL;
  8010ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010b1:	eb f0                	jmp    8010a3 <fd_lookup+0x39>
  8010b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010b8:	eb e9                	jmp    8010a3 <fd_lookup+0x39>

008010ba <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c8:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010cd:	39 08                	cmp    %ecx,(%eax)
  8010cf:	74 38                	je     801109 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010d1:	83 c2 01             	add    $0x1,%edx
  8010d4:	8b 04 95 ec 29 80 00 	mov    0x8029ec(,%edx,4),%eax
  8010db:	85 c0                	test   %eax,%eax
  8010dd:	75 ee                	jne    8010cd <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010df:	a1 08 40 80 00       	mov    0x804008,%eax
  8010e4:	8b 40 48             	mov    0x48(%eax),%eax
  8010e7:	83 ec 04             	sub    $0x4,%esp
  8010ea:	51                   	push   %ecx
  8010eb:	50                   	push   %eax
  8010ec:	68 70 29 80 00       	push   $0x802970
  8010f1:	e8 af f0 ff ff       	call   8001a5 <cprintf>
	*dev = 0;
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010ff:	83 c4 10             	add    $0x10,%esp
  801102:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801107:	c9                   	leave  
  801108:	c3                   	ret    
			*dev = devtab[i];
  801109:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80110c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80110e:	b8 00 00 00 00       	mov    $0x0,%eax
  801113:	eb f2                	jmp    801107 <dev_lookup+0x4d>

00801115 <fd_close>:
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	57                   	push   %edi
  801119:	56                   	push   %esi
  80111a:	53                   	push   %ebx
  80111b:	83 ec 24             	sub    $0x24,%esp
  80111e:	8b 75 08             	mov    0x8(%ebp),%esi
  801121:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801124:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801127:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801128:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80112e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801131:	50                   	push   %eax
  801132:	e8 33 ff ff ff       	call   80106a <fd_lookup>
  801137:	89 c3                	mov    %eax,%ebx
  801139:	83 c4 10             	add    $0x10,%esp
  80113c:	85 c0                	test   %eax,%eax
  80113e:	78 05                	js     801145 <fd_close+0x30>
	    || fd != fd2)
  801140:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801143:	74 16                	je     80115b <fd_close+0x46>
		return (must_exist ? r : 0);
  801145:	89 f8                	mov    %edi,%eax
  801147:	84 c0                	test   %al,%al
  801149:	b8 00 00 00 00       	mov    $0x0,%eax
  80114e:	0f 44 d8             	cmove  %eax,%ebx
}
  801151:	89 d8                	mov    %ebx,%eax
  801153:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801156:	5b                   	pop    %ebx
  801157:	5e                   	pop    %esi
  801158:	5f                   	pop    %edi
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80115b:	83 ec 08             	sub    $0x8,%esp
  80115e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801161:	50                   	push   %eax
  801162:	ff 36                	pushl  (%esi)
  801164:	e8 51 ff ff ff       	call   8010ba <dev_lookup>
  801169:	89 c3                	mov    %eax,%ebx
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	85 c0                	test   %eax,%eax
  801170:	78 1a                	js     80118c <fd_close+0x77>
		if (dev->dev_close)
  801172:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801175:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801178:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80117d:	85 c0                	test   %eax,%eax
  80117f:	74 0b                	je     80118c <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801181:	83 ec 0c             	sub    $0xc,%esp
  801184:	56                   	push   %esi
  801185:	ff d0                	call   *%eax
  801187:	89 c3                	mov    %eax,%ebx
  801189:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80118c:	83 ec 08             	sub    $0x8,%esp
  80118f:	56                   	push   %esi
  801190:	6a 00                	push   $0x0
  801192:	e8 e4 fb ff ff       	call   800d7b <sys_page_unmap>
	return r;
  801197:	83 c4 10             	add    $0x10,%esp
  80119a:	eb b5                	jmp    801151 <fd_close+0x3c>

0080119c <close>:

int
close(int fdnum)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a5:	50                   	push   %eax
  8011a6:	ff 75 08             	pushl  0x8(%ebp)
  8011a9:	e8 bc fe ff ff       	call   80106a <fd_lookup>
  8011ae:	83 c4 10             	add    $0x10,%esp
  8011b1:	85 c0                	test   %eax,%eax
  8011b3:	79 02                	jns    8011b7 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    
		return fd_close(fd, 1);
  8011b7:	83 ec 08             	sub    $0x8,%esp
  8011ba:	6a 01                	push   $0x1
  8011bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bf:	e8 51 ff ff ff       	call   801115 <fd_close>
  8011c4:	83 c4 10             	add    $0x10,%esp
  8011c7:	eb ec                	jmp    8011b5 <close+0x19>

008011c9 <close_all>:

void
close_all(void)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	53                   	push   %ebx
  8011cd:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011d0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011d5:	83 ec 0c             	sub    $0xc,%esp
  8011d8:	53                   	push   %ebx
  8011d9:	e8 be ff ff ff       	call   80119c <close>
	for (i = 0; i < MAXFD; i++)
  8011de:	83 c3 01             	add    $0x1,%ebx
  8011e1:	83 c4 10             	add    $0x10,%esp
  8011e4:	83 fb 20             	cmp    $0x20,%ebx
  8011e7:	75 ec                	jne    8011d5 <close_all+0xc>
}
  8011e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	57                   	push   %edi
  8011f2:	56                   	push   %esi
  8011f3:	53                   	push   %ebx
  8011f4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011f7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011fa:	50                   	push   %eax
  8011fb:	ff 75 08             	pushl  0x8(%ebp)
  8011fe:	e8 67 fe ff ff       	call   80106a <fd_lookup>
  801203:	89 c3                	mov    %eax,%ebx
  801205:	83 c4 10             	add    $0x10,%esp
  801208:	85 c0                	test   %eax,%eax
  80120a:	0f 88 81 00 00 00    	js     801291 <dup+0xa3>
		return r;
	close(newfdnum);
  801210:	83 ec 0c             	sub    $0xc,%esp
  801213:	ff 75 0c             	pushl  0xc(%ebp)
  801216:	e8 81 ff ff ff       	call   80119c <close>

	newfd = INDEX2FD(newfdnum);
  80121b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80121e:	c1 e6 0c             	shl    $0xc,%esi
  801221:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801227:	83 c4 04             	add    $0x4,%esp
  80122a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80122d:	e8 cf fd ff ff       	call   801001 <fd2data>
  801232:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801234:	89 34 24             	mov    %esi,(%esp)
  801237:	e8 c5 fd ff ff       	call   801001 <fd2data>
  80123c:	83 c4 10             	add    $0x10,%esp
  80123f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801241:	89 d8                	mov    %ebx,%eax
  801243:	c1 e8 16             	shr    $0x16,%eax
  801246:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80124d:	a8 01                	test   $0x1,%al
  80124f:	74 11                	je     801262 <dup+0x74>
  801251:	89 d8                	mov    %ebx,%eax
  801253:	c1 e8 0c             	shr    $0xc,%eax
  801256:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80125d:	f6 c2 01             	test   $0x1,%dl
  801260:	75 39                	jne    80129b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801262:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801265:	89 d0                	mov    %edx,%eax
  801267:	c1 e8 0c             	shr    $0xc,%eax
  80126a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801271:	83 ec 0c             	sub    $0xc,%esp
  801274:	25 07 0e 00 00       	and    $0xe07,%eax
  801279:	50                   	push   %eax
  80127a:	56                   	push   %esi
  80127b:	6a 00                	push   $0x0
  80127d:	52                   	push   %edx
  80127e:	6a 00                	push   $0x0
  801280:	e8 b4 fa ff ff       	call   800d39 <sys_page_map>
  801285:	89 c3                	mov    %eax,%ebx
  801287:	83 c4 20             	add    $0x20,%esp
  80128a:	85 c0                	test   %eax,%eax
  80128c:	78 31                	js     8012bf <dup+0xd1>
		goto err;

	return newfdnum;
  80128e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801291:	89 d8                	mov    %ebx,%eax
  801293:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801296:	5b                   	pop    %ebx
  801297:	5e                   	pop    %esi
  801298:	5f                   	pop    %edi
  801299:	5d                   	pop    %ebp
  80129a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80129b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012a2:	83 ec 0c             	sub    $0xc,%esp
  8012a5:	25 07 0e 00 00       	and    $0xe07,%eax
  8012aa:	50                   	push   %eax
  8012ab:	57                   	push   %edi
  8012ac:	6a 00                	push   $0x0
  8012ae:	53                   	push   %ebx
  8012af:	6a 00                	push   $0x0
  8012b1:	e8 83 fa ff ff       	call   800d39 <sys_page_map>
  8012b6:	89 c3                	mov    %eax,%ebx
  8012b8:	83 c4 20             	add    $0x20,%esp
  8012bb:	85 c0                	test   %eax,%eax
  8012bd:	79 a3                	jns    801262 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012bf:	83 ec 08             	sub    $0x8,%esp
  8012c2:	56                   	push   %esi
  8012c3:	6a 00                	push   $0x0
  8012c5:	e8 b1 fa ff ff       	call   800d7b <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012ca:	83 c4 08             	add    $0x8,%esp
  8012cd:	57                   	push   %edi
  8012ce:	6a 00                	push   $0x0
  8012d0:	e8 a6 fa ff ff       	call   800d7b <sys_page_unmap>
	return r;
  8012d5:	83 c4 10             	add    $0x10,%esp
  8012d8:	eb b7                	jmp    801291 <dup+0xa3>

008012da <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	53                   	push   %ebx
  8012de:	83 ec 1c             	sub    $0x1c,%esp
  8012e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012e7:	50                   	push   %eax
  8012e8:	53                   	push   %ebx
  8012e9:	e8 7c fd ff ff       	call   80106a <fd_lookup>
  8012ee:	83 c4 10             	add    $0x10,%esp
  8012f1:	85 c0                	test   %eax,%eax
  8012f3:	78 3f                	js     801334 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012f5:	83 ec 08             	sub    $0x8,%esp
  8012f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012fb:	50                   	push   %eax
  8012fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ff:	ff 30                	pushl  (%eax)
  801301:	e8 b4 fd ff ff       	call   8010ba <dev_lookup>
  801306:	83 c4 10             	add    $0x10,%esp
  801309:	85 c0                	test   %eax,%eax
  80130b:	78 27                	js     801334 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80130d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801310:	8b 42 08             	mov    0x8(%edx),%eax
  801313:	83 e0 03             	and    $0x3,%eax
  801316:	83 f8 01             	cmp    $0x1,%eax
  801319:	74 1e                	je     801339 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80131b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131e:	8b 40 08             	mov    0x8(%eax),%eax
  801321:	85 c0                	test   %eax,%eax
  801323:	74 35                	je     80135a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801325:	83 ec 04             	sub    $0x4,%esp
  801328:	ff 75 10             	pushl  0x10(%ebp)
  80132b:	ff 75 0c             	pushl  0xc(%ebp)
  80132e:	52                   	push   %edx
  80132f:	ff d0                	call   *%eax
  801331:	83 c4 10             	add    $0x10,%esp
}
  801334:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801337:	c9                   	leave  
  801338:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801339:	a1 08 40 80 00       	mov    0x804008,%eax
  80133e:	8b 40 48             	mov    0x48(%eax),%eax
  801341:	83 ec 04             	sub    $0x4,%esp
  801344:	53                   	push   %ebx
  801345:	50                   	push   %eax
  801346:	68 b1 29 80 00       	push   $0x8029b1
  80134b:	e8 55 ee ff ff       	call   8001a5 <cprintf>
		return -E_INVAL;
  801350:	83 c4 10             	add    $0x10,%esp
  801353:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801358:	eb da                	jmp    801334 <read+0x5a>
		return -E_NOT_SUPP;
  80135a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80135f:	eb d3                	jmp    801334 <read+0x5a>

00801361 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	57                   	push   %edi
  801365:	56                   	push   %esi
  801366:	53                   	push   %ebx
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80136d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801370:	bb 00 00 00 00       	mov    $0x0,%ebx
  801375:	39 f3                	cmp    %esi,%ebx
  801377:	73 23                	jae    80139c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801379:	83 ec 04             	sub    $0x4,%esp
  80137c:	89 f0                	mov    %esi,%eax
  80137e:	29 d8                	sub    %ebx,%eax
  801380:	50                   	push   %eax
  801381:	89 d8                	mov    %ebx,%eax
  801383:	03 45 0c             	add    0xc(%ebp),%eax
  801386:	50                   	push   %eax
  801387:	57                   	push   %edi
  801388:	e8 4d ff ff ff       	call   8012da <read>
		if (m < 0)
  80138d:	83 c4 10             	add    $0x10,%esp
  801390:	85 c0                	test   %eax,%eax
  801392:	78 06                	js     80139a <readn+0x39>
			return m;
		if (m == 0)
  801394:	74 06                	je     80139c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801396:	01 c3                	add    %eax,%ebx
  801398:	eb db                	jmp    801375 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80139a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80139c:	89 d8                	mov    %ebx,%eax
  80139e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a1:	5b                   	pop    %ebx
  8013a2:	5e                   	pop    %esi
  8013a3:	5f                   	pop    %edi
  8013a4:	5d                   	pop    %ebp
  8013a5:	c3                   	ret    

008013a6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	53                   	push   %ebx
  8013aa:	83 ec 1c             	sub    $0x1c,%esp
  8013ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013b3:	50                   	push   %eax
  8013b4:	53                   	push   %ebx
  8013b5:	e8 b0 fc ff ff       	call   80106a <fd_lookup>
  8013ba:	83 c4 10             	add    $0x10,%esp
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	78 3a                	js     8013fb <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c1:	83 ec 08             	sub    $0x8,%esp
  8013c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c7:	50                   	push   %eax
  8013c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013cb:	ff 30                	pushl  (%eax)
  8013cd:	e8 e8 fc ff ff       	call   8010ba <dev_lookup>
  8013d2:	83 c4 10             	add    $0x10,%esp
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	78 22                	js     8013fb <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013dc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013e0:	74 1e                	je     801400 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e5:	8b 52 0c             	mov    0xc(%edx),%edx
  8013e8:	85 d2                	test   %edx,%edx
  8013ea:	74 35                	je     801421 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013ec:	83 ec 04             	sub    $0x4,%esp
  8013ef:	ff 75 10             	pushl  0x10(%ebp)
  8013f2:	ff 75 0c             	pushl  0xc(%ebp)
  8013f5:	50                   	push   %eax
  8013f6:	ff d2                	call   *%edx
  8013f8:	83 c4 10             	add    $0x10,%esp
}
  8013fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013fe:	c9                   	leave  
  8013ff:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801400:	a1 08 40 80 00       	mov    0x804008,%eax
  801405:	8b 40 48             	mov    0x48(%eax),%eax
  801408:	83 ec 04             	sub    $0x4,%esp
  80140b:	53                   	push   %ebx
  80140c:	50                   	push   %eax
  80140d:	68 cd 29 80 00       	push   $0x8029cd
  801412:	e8 8e ed ff ff       	call   8001a5 <cprintf>
		return -E_INVAL;
  801417:	83 c4 10             	add    $0x10,%esp
  80141a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80141f:	eb da                	jmp    8013fb <write+0x55>
		return -E_NOT_SUPP;
  801421:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801426:	eb d3                	jmp    8013fb <write+0x55>

00801428 <seek>:

int
seek(int fdnum, off_t offset)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80142e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801431:	50                   	push   %eax
  801432:	ff 75 08             	pushl  0x8(%ebp)
  801435:	e8 30 fc ff ff       	call   80106a <fd_lookup>
  80143a:	83 c4 10             	add    $0x10,%esp
  80143d:	85 c0                	test   %eax,%eax
  80143f:	78 0e                	js     80144f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801441:	8b 55 0c             	mov    0xc(%ebp),%edx
  801444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801447:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80144a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144f:	c9                   	leave  
  801450:	c3                   	ret    

00801451 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	53                   	push   %ebx
  801455:	83 ec 1c             	sub    $0x1c,%esp
  801458:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80145b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80145e:	50                   	push   %eax
  80145f:	53                   	push   %ebx
  801460:	e8 05 fc ff ff       	call   80106a <fd_lookup>
  801465:	83 c4 10             	add    $0x10,%esp
  801468:	85 c0                	test   %eax,%eax
  80146a:	78 37                	js     8014a3 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80146c:	83 ec 08             	sub    $0x8,%esp
  80146f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801472:	50                   	push   %eax
  801473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801476:	ff 30                	pushl  (%eax)
  801478:	e8 3d fc ff ff       	call   8010ba <dev_lookup>
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	85 c0                	test   %eax,%eax
  801482:	78 1f                	js     8014a3 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801487:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80148b:	74 1b                	je     8014a8 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80148d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801490:	8b 52 18             	mov    0x18(%edx),%edx
  801493:	85 d2                	test   %edx,%edx
  801495:	74 32                	je     8014c9 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801497:	83 ec 08             	sub    $0x8,%esp
  80149a:	ff 75 0c             	pushl  0xc(%ebp)
  80149d:	50                   	push   %eax
  80149e:	ff d2                	call   *%edx
  8014a0:	83 c4 10             	add    $0x10,%esp
}
  8014a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014a8:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014ad:	8b 40 48             	mov    0x48(%eax),%eax
  8014b0:	83 ec 04             	sub    $0x4,%esp
  8014b3:	53                   	push   %ebx
  8014b4:	50                   	push   %eax
  8014b5:	68 90 29 80 00       	push   $0x802990
  8014ba:	e8 e6 ec ff ff       	call   8001a5 <cprintf>
		return -E_INVAL;
  8014bf:	83 c4 10             	add    $0x10,%esp
  8014c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c7:	eb da                	jmp    8014a3 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014ce:	eb d3                	jmp    8014a3 <ftruncate+0x52>

008014d0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	53                   	push   %ebx
  8014d4:	83 ec 1c             	sub    $0x1c,%esp
  8014d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014dd:	50                   	push   %eax
  8014de:	ff 75 08             	pushl  0x8(%ebp)
  8014e1:	e8 84 fb ff ff       	call   80106a <fd_lookup>
  8014e6:	83 c4 10             	add    $0x10,%esp
  8014e9:	85 c0                	test   %eax,%eax
  8014eb:	78 4b                	js     801538 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ed:	83 ec 08             	sub    $0x8,%esp
  8014f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f3:	50                   	push   %eax
  8014f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f7:	ff 30                	pushl  (%eax)
  8014f9:	e8 bc fb ff ff       	call   8010ba <dev_lookup>
  8014fe:	83 c4 10             	add    $0x10,%esp
  801501:	85 c0                	test   %eax,%eax
  801503:	78 33                	js     801538 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801508:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80150c:	74 2f                	je     80153d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80150e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801511:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801518:	00 00 00 
	stat->st_isdir = 0;
  80151b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801522:	00 00 00 
	stat->st_dev = dev;
  801525:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80152b:	83 ec 08             	sub    $0x8,%esp
  80152e:	53                   	push   %ebx
  80152f:	ff 75 f0             	pushl  -0x10(%ebp)
  801532:	ff 50 14             	call   *0x14(%eax)
  801535:	83 c4 10             	add    $0x10,%esp
}
  801538:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    
		return -E_NOT_SUPP;
  80153d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801542:	eb f4                	jmp    801538 <fstat+0x68>

00801544 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	56                   	push   %esi
  801548:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801549:	83 ec 08             	sub    $0x8,%esp
  80154c:	6a 00                	push   $0x0
  80154e:	ff 75 08             	pushl  0x8(%ebp)
  801551:	e8 22 02 00 00       	call   801778 <open>
  801556:	89 c3                	mov    %eax,%ebx
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	85 c0                	test   %eax,%eax
  80155d:	78 1b                	js     80157a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80155f:	83 ec 08             	sub    $0x8,%esp
  801562:	ff 75 0c             	pushl  0xc(%ebp)
  801565:	50                   	push   %eax
  801566:	e8 65 ff ff ff       	call   8014d0 <fstat>
  80156b:	89 c6                	mov    %eax,%esi
	close(fd);
  80156d:	89 1c 24             	mov    %ebx,(%esp)
  801570:	e8 27 fc ff ff       	call   80119c <close>
	return r;
  801575:	83 c4 10             	add    $0x10,%esp
  801578:	89 f3                	mov    %esi,%ebx
}
  80157a:	89 d8                	mov    %ebx,%eax
  80157c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157f:	5b                   	pop    %ebx
  801580:	5e                   	pop    %esi
  801581:	5d                   	pop    %ebp
  801582:	c3                   	ret    

00801583 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	56                   	push   %esi
  801587:	53                   	push   %ebx
  801588:	89 c6                	mov    %eax,%esi
  80158a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80158c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801593:	74 27                	je     8015bc <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801595:	6a 07                	push   $0x7
  801597:	68 00 50 80 00       	push   $0x805000
  80159c:	56                   	push   %esi
  80159d:	ff 35 00 40 80 00    	pushl  0x804000
  8015a3:	e8 d8 0c 00 00       	call   802280 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015a8:	83 c4 0c             	add    $0xc,%esp
  8015ab:	6a 00                	push   $0x0
  8015ad:	53                   	push   %ebx
  8015ae:	6a 00                	push   $0x0
  8015b0:	e8 62 0c 00 00       	call   802217 <ipc_recv>
}
  8015b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b8:	5b                   	pop    %ebx
  8015b9:	5e                   	pop    %esi
  8015ba:	5d                   	pop    %ebp
  8015bb:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015bc:	83 ec 0c             	sub    $0xc,%esp
  8015bf:	6a 01                	push   $0x1
  8015c1:	e8 12 0d 00 00       	call   8022d8 <ipc_find_env>
  8015c6:	a3 00 40 80 00       	mov    %eax,0x804000
  8015cb:	83 c4 10             	add    $0x10,%esp
  8015ce:	eb c5                	jmp    801595 <fsipc+0x12>

008015d0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015dc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e4:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ee:	b8 02 00 00 00       	mov    $0x2,%eax
  8015f3:	e8 8b ff ff ff       	call   801583 <fsipc>
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <devfile_flush>:
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	8b 40 0c             	mov    0xc(%eax),%eax
  801606:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80160b:	ba 00 00 00 00       	mov    $0x0,%edx
  801610:	b8 06 00 00 00       	mov    $0x6,%eax
  801615:	e8 69 ff ff ff       	call   801583 <fsipc>
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <devfile_stat>:
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	53                   	push   %ebx
  801620:	83 ec 04             	sub    $0x4,%esp
  801623:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	8b 40 0c             	mov    0xc(%eax),%eax
  80162c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801631:	ba 00 00 00 00       	mov    $0x0,%edx
  801636:	b8 05 00 00 00       	mov    $0x5,%eax
  80163b:	e8 43 ff ff ff       	call   801583 <fsipc>
  801640:	85 c0                	test   %eax,%eax
  801642:	78 2c                	js     801670 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801644:	83 ec 08             	sub    $0x8,%esp
  801647:	68 00 50 80 00       	push   $0x805000
  80164c:	53                   	push   %ebx
  80164d:	e8 b2 f2 ff ff       	call   800904 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801652:	a1 80 50 80 00       	mov    0x805080,%eax
  801657:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80165d:	a1 84 50 80 00       	mov    0x805084,%eax
  801662:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801668:	83 c4 10             	add    $0x10,%esp
  80166b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801670:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <devfile_write>:
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	53                   	push   %ebx
  801679:	83 ec 08             	sub    $0x8,%esp
  80167c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8b 40 0c             	mov    0xc(%eax),%eax
  801685:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80168a:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801690:	53                   	push   %ebx
  801691:	ff 75 0c             	pushl  0xc(%ebp)
  801694:	68 08 50 80 00       	push   $0x805008
  801699:	e8 56 f4 ff ff       	call   800af4 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80169e:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a3:	b8 04 00 00 00       	mov    $0x4,%eax
  8016a8:	e8 d6 fe ff ff       	call   801583 <fsipc>
  8016ad:	83 c4 10             	add    $0x10,%esp
  8016b0:	85 c0                	test   %eax,%eax
  8016b2:	78 0b                	js     8016bf <devfile_write+0x4a>
	assert(r <= n);
  8016b4:	39 d8                	cmp    %ebx,%eax
  8016b6:	77 0c                	ja     8016c4 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016b8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016bd:	7f 1e                	jg     8016dd <devfile_write+0x68>
}
  8016bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    
	assert(r <= n);
  8016c4:	68 00 2a 80 00       	push   $0x802a00
  8016c9:	68 07 2a 80 00       	push   $0x802a07
  8016ce:	68 98 00 00 00       	push   $0x98
  8016d3:	68 1c 2a 80 00       	push   $0x802a1c
  8016d8:	e8 6a 0a 00 00       	call   802147 <_panic>
	assert(r <= PGSIZE);
  8016dd:	68 27 2a 80 00       	push   $0x802a27
  8016e2:	68 07 2a 80 00       	push   $0x802a07
  8016e7:	68 99 00 00 00       	push   $0x99
  8016ec:	68 1c 2a 80 00       	push   $0x802a1c
  8016f1:	e8 51 0a 00 00       	call   802147 <_panic>

008016f6 <devfile_read>:
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	56                   	push   %esi
  8016fa:	53                   	push   %ebx
  8016fb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	8b 40 0c             	mov    0xc(%eax),%eax
  801704:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801709:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80170f:	ba 00 00 00 00       	mov    $0x0,%edx
  801714:	b8 03 00 00 00       	mov    $0x3,%eax
  801719:	e8 65 fe ff ff       	call   801583 <fsipc>
  80171e:	89 c3                	mov    %eax,%ebx
  801720:	85 c0                	test   %eax,%eax
  801722:	78 1f                	js     801743 <devfile_read+0x4d>
	assert(r <= n);
  801724:	39 f0                	cmp    %esi,%eax
  801726:	77 24                	ja     80174c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801728:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80172d:	7f 33                	jg     801762 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80172f:	83 ec 04             	sub    $0x4,%esp
  801732:	50                   	push   %eax
  801733:	68 00 50 80 00       	push   $0x805000
  801738:	ff 75 0c             	pushl  0xc(%ebp)
  80173b:	e8 52 f3 ff ff       	call   800a92 <memmove>
	return r;
  801740:	83 c4 10             	add    $0x10,%esp
}
  801743:	89 d8                	mov    %ebx,%eax
  801745:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801748:	5b                   	pop    %ebx
  801749:	5e                   	pop    %esi
  80174a:	5d                   	pop    %ebp
  80174b:	c3                   	ret    
	assert(r <= n);
  80174c:	68 00 2a 80 00       	push   $0x802a00
  801751:	68 07 2a 80 00       	push   $0x802a07
  801756:	6a 7c                	push   $0x7c
  801758:	68 1c 2a 80 00       	push   $0x802a1c
  80175d:	e8 e5 09 00 00       	call   802147 <_panic>
	assert(r <= PGSIZE);
  801762:	68 27 2a 80 00       	push   $0x802a27
  801767:	68 07 2a 80 00       	push   $0x802a07
  80176c:	6a 7d                	push   $0x7d
  80176e:	68 1c 2a 80 00       	push   $0x802a1c
  801773:	e8 cf 09 00 00       	call   802147 <_panic>

00801778 <open>:
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	56                   	push   %esi
  80177c:	53                   	push   %ebx
  80177d:	83 ec 1c             	sub    $0x1c,%esp
  801780:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801783:	56                   	push   %esi
  801784:	e8 42 f1 ff ff       	call   8008cb <strlen>
  801789:	83 c4 10             	add    $0x10,%esp
  80178c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801791:	7f 6c                	jg     8017ff <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801793:	83 ec 0c             	sub    $0xc,%esp
  801796:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801799:	50                   	push   %eax
  80179a:	e8 79 f8 ff ff       	call   801018 <fd_alloc>
  80179f:	89 c3                	mov    %eax,%ebx
  8017a1:	83 c4 10             	add    $0x10,%esp
  8017a4:	85 c0                	test   %eax,%eax
  8017a6:	78 3c                	js     8017e4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017a8:	83 ec 08             	sub    $0x8,%esp
  8017ab:	56                   	push   %esi
  8017ac:	68 00 50 80 00       	push   $0x805000
  8017b1:	e8 4e f1 ff ff       	call   800904 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b9:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c6:	e8 b8 fd ff ff       	call   801583 <fsipc>
  8017cb:	89 c3                	mov    %eax,%ebx
  8017cd:	83 c4 10             	add    $0x10,%esp
  8017d0:	85 c0                	test   %eax,%eax
  8017d2:	78 19                	js     8017ed <open+0x75>
	return fd2num(fd);
  8017d4:	83 ec 0c             	sub    $0xc,%esp
  8017d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017da:	e8 12 f8 ff ff       	call   800ff1 <fd2num>
  8017df:	89 c3                	mov    %eax,%ebx
  8017e1:	83 c4 10             	add    $0x10,%esp
}
  8017e4:	89 d8                	mov    %ebx,%eax
  8017e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e9:	5b                   	pop    %ebx
  8017ea:	5e                   	pop    %esi
  8017eb:	5d                   	pop    %ebp
  8017ec:	c3                   	ret    
		fd_close(fd, 0);
  8017ed:	83 ec 08             	sub    $0x8,%esp
  8017f0:	6a 00                	push   $0x0
  8017f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8017f5:	e8 1b f9 ff ff       	call   801115 <fd_close>
		return r;
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	eb e5                	jmp    8017e4 <open+0x6c>
		return -E_BAD_PATH;
  8017ff:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801804:	eb de                	jmp    8017e4 <open+0x6c>

00801806 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80180c:	ba 00 00 00 00       	mov    $0x0,%edx
  801811:	b8 08 00 00 00       	mov    $0x8,%eax
  801816:	e8 68 fd ff ff       	call   801583 <fsipc>
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801823:	68 33 2a 80 00       	push   $0x802a33
  801828:	ff 75 0c             	pushl  0xc(%ebp)
  80182b:	e8 d4 f0 ff ff       	call   800904 <strcpy>
	return 0;
}
  801830:	b8 00 00 00 00       	mov    $0x0,%eax
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <devsock_close>:
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	53                   	push   %ebx
  80183b:	83 ec 10             	sub    $0x10,%esp
  80183e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801841:	53                   	push   %ebx
  801842:	e8 cc 0a 00 00       	call   802313 <pageref>
  801847:	83 c4 10             	add    $0x10,%esp
		return 0;
  80184a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80184f:	83 f8 01             	cmp    $0x1,%eax
  801852:	74 07                	je     80185b <devsock_close+0x24>
}
  801854:	89 d0                	mov    %edx,%eax
  801856:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801859:	c9                   	leave  
  80185a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	ff 73 0c             	pushl  0xc(%ebx)
  801861:	e8 b9 02 00 00       	call   801b1f <nsipc_close>
  801866:	89 c2                	mov    %eax,%edx
  801868:	83 c4 10             	add    $0x10,%esp
  80186b:	eb e7                	jmp    801854 <devsock_close+0x1d>

0080186d <devsock_write>:
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801873:	6a 00                	push   $0x0
  801875:	ff 75 10             	pushl  0x10(%ebp)
  801878:	ff 75 0c             	pushl  0xc(%ebp)
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	ff 70 0c             	pushl  0xc(%eax)
  801881:	e8 76 03 00 00       	call   801bfc <nsipc_send>
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <devsock_read>:
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80188e:	6a 00                	push   $0x0
  801890:	ff 75 10             	pushl  0x10(%ebp)
  801893:	ff 75 0c             	pushl  0xc(%ebp)
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	ff 70 0c             	pushl  0xc(%eax)
  80189c:	e8 ef 02 00 00       	call   801b90 <nsipc_recv>
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <fd2sockid>:
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018a9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018ac:	52                   	push   %edx
  8018ad:	50                   	push   %eax
  8018ae:	e8 b7 f7 ff ff       	call   80106a <fd_lookup>
  8018b3:	83 c4 10             	add    $0x10,%esp
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	78 10                	js     8018ca <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018bd:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018c3:	39 08                	cmp    %ecx,(%eax)
  8018c5:	75 05                	jne    8018cc <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018c7:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    
		return -E_NOT_SUPP;
  8018cc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018d1:	eb f7                	jmp    8018ca <fd2sockid+0x27>

008018d3 <alloc_sockfd>:
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	56                   	push   %esi
  8018d7:	53                   	push   %ebx
  8018d8:	83 ec 1c             	sub    $0x1c,%esp
  8018db:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e0:	50                   	push   %eax
  8018e1:	e8 32 f7 ff ff       	call   801018 <fd_alloc>
  8018e6:	89 c3                	mov    %eax,%ebx
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	85 c0                	test   %eax,%eax
  8018ed:	78 43                	js     801932 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018ef:	83 ec 04             	sub    $0x4,%esp
  8018f2:	68 07 04 00 00       	push   $0x407
  8018f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018fa:	6a 00                	push   $0x0
  8018fc:	e8 f5 f3 ff ff       	call   800cf6 <sys_page_alloc>
  801901:	89 c3                	mov    %eax,%ebx
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	85 c0                	test   %eax,%eax
  801908:	78 28                	js     801932 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80190a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801913:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801918:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80191f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801922:	83 ec 0c             	sub    $0xc,%esp
  801925:	50                   	push   %eax
  801926:	e8 c6 f6 ff ff       	call   800ff1 <fd2num>
  80192b:	89 c3                	mov    %eax,%ebx
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	eb 0c                	jmp    80193e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801932:	83 ec 0c             	sub    $0xc,%esp
  801935:	56                   	push   %esi
  801936:	e8 e4 01 00 00       	call   801b1f <nsipc_close>
		return r;
  80193b:	83 c4 10             	add    $0x10,%esp
}
  80193e:	89 d8                	mov    %ebx,%eax
  801940:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801943:	5b                   	pop    %ebx
  801944:	5e                   	pop    %esi
  801945:	5d                   	pop    %ebp
  801946:	c3                   	ret    

00801947 <accept>:
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	e8 4e ff ff ff       	call   8018a3 <fd2sockid>
  801955:	85 c0                	test   %eax,%eax
  801957:	78 1b                	js     801974 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801959:	83 ec 04             	sub    $0x4,%esp
  80195c:	ff 75 10             	pushl  0x10(%ebp)
  80195f:	ff 75 0c             	pushl  0xc(%ebp)
  801962:	50                   	push   %eax
  801963:	e8 0e 01 00 00       	call   801a76 <nsipc_accept>
  801968:	83 c4 10             	add    $0x10,%esp
  80196b:	85 c0                	test   %eax,%eax
  80196d:	78 05                	js     801974 <accept+0x2d>
	return alloc_sockfd(r);
  80196f:	e8 5f ff ff ff       	call   8018d3 <alloc_sockfd>
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <bind>:
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	e8 1f ff ff ff       	call   8018a3 <fd2sockid>
  801984:	85 c0                	test   %eax,%eax
  801986:	78 12                	js     80199a <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801988:	83 ec 04             	sub    $0x4,%esp
  80198b:	ff 75 10             	pushl  0x10(%ebp)
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	50                   	push   %eax
  801992:	e8 31 01 00 00       	call   801ac8 <nsipc_bind>
  801997:	83 c4 10             	add    $0x10,%esp
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <shutdown>:
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	e8 f9 fe ff ff       	call   8018a3 <fd2sockid>
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	78 0f                	js     8019bd <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019ae:	83 ec 08             	sub    $0x8,%esp
  8019b1:	ff 75 0c             	pushl  0xc(%ebp)
  8019b4:	50                   	push   %eax
  8019b5:	e8 43 01 00 00       	call   801afd <nsipc_shutdown>
  8019ba:	83 c4 10             	add    $0x10,%esp
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <connect>:
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	e8 d6 fe ff ff       	call   8018a3 <fd2sockid>
  8019cd:	85 c0                	test   %eax,%eax
  8019cf:	78 12                	js     8019e3 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019d1:	83 ec 04             	sub    $0x4,%esp
  8019d4:	ff 75 10             	pushl  0x10(%ebp)
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	50                   	push   %eax
  8019db:	e8 59 01 00 00       	call   801b39 <nsipc_connect>
  8019e0:	83 c4 10             	add    $0x10,%esp
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <listen>:
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	e8 b0 fe ff ff       	call   8018a3 <fd2sockid>
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	78 0f                	js     801a06 <listen+0x21>
	return nsipc_listen(r, backlog);
  8019f7:	83 ec 08             	sub    $0x8,%esp
  8019fa:	ff 75 0c             	pushl  0xc(%ebp)
  8019fd:	50                   	push   %eax
  8019fe:	e8 6b 01 00 00       	call   801b6e <nsipc_listen>
  801a03:	83 c4 10             	add    $0x10,%esp
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a0e:	ff 75 10             	pushl  0x10(%ebp)
  801a11:	ff 75 0c             	pushl  0xc(%ebp)
  801a14:	ff 75 08             	pushl  0x8(%ebp)
  801a17:	e8 3e 02 00 00       	call   801c5a <nsipc_socket>
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	78 05                	js     801a28 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a23:	e8 ab fe ff ff       	call   8018d3 <alloc_sockfd>
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	53                   	push   %ebx
  801a2e:	83 ec 04             	sub    $0x4,%esp
  801a31:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a33:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a3a:	74 26                	je     801a62 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a3c:	6a 07                	push   $0x7
  801a3e:	68 00 60 80 00       	push   $0x806000
  801a43:	53                   	push   %ebx
  801a44:	ff 35 04 40 80 00    	pushl  0x804004
  801a4a:	e8 31 08 00 00       	call   802280 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a4f:	83 c4 0c             	add    $0xc,%esp
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	e8 ba 07 00 00       	call   802217 <ipc_recv>
}
  801a5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a62:	83 ec 0c             	sub    $0xc,%esp
  801a65:	6a 02                	push   $0x2
  801a67:	e8 6c 08 00 00       	call   8022d8 <ipc_find_env>
  801a6c:	a3 04 40 80 00       	mov    %eax,0x804004
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	eb c6                	jmp    801a3c <nsipc+0x12>

00801a76 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	56                   	push   %esi
  801a7a:	53                   	push   %ebx
  801a7b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a86:	8b 06                	mov    (%esi),%eax
  801a88:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a92:	e8 93 ff ff ff       	call   801a2a <nsipc>
  801a97:	89 c3                	mov    %eax,%ebx
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	79 09                	jns    801aa6 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a9d:	89 d8                	mov    %ebx,%eax
  801a9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa2:	5b                   	pop    %ebx
  801aa3:	5e                   	pop    %esi
  801aa4:	5d                   	pop    %ebp
  801aa5:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801aa6:	83 ec 04             	sub    $0x4,%esp
  801aa9:	ff 35 10 60 80 00    	pushl  0x806010
  801aaf:	68 00 60 80 00       	push   $0x806000
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	e8 d6 ef ff ff       	call   800a92 <memmove>
		*addrlen = ret->ret_addrlen;
  801abc:	a1 10 60 80 00       	mov    0x806010,%eax
  801ac1:	89 06                	mov    %eax,(%esi)
  801ac3:	83 c4 10             	add    $0x10,%esp
	return r;
  801ac6:	eb d5                	jmp    801a9d <nsipc_accept+0x27>

00801ac8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	53                   	push   %ebx
  801acc:	83 ec 08             	sub    $0x8,%esp
  801acf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ada:	53                   	push   %ebx
  801adb:	ff 75 0c             	pushl  0xc(%ebp)
  801ade:	68 04 60 80 00       	push   $0x806004
  801ae3:	e8 aa ef ff ff       	call   800a92 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ae8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801aee:	b8 02 00 00 00       	mov    $0x2,%eax
  801af3:	e8 32 ff ff ff       	call   801a2a <nsipc>
}
  801af8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b13:	b8 03 00 00 00       	mov    $0x3,%eax
  801b18:	e8 0d ff ff ff       	call   801a2a <nsipc>
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <nsipc_close>:

int
nsipc_close(int s)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b2d:	b8 04 00 00 00       	mov    $0x4,%eax
  801b32:	e8 f3 fe ff ff       	call   801a2a <nsipc>
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	53                   	push   %ebx
  801b3d:	83 ec 08             	sub    $0x8,%esp
  801b40:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b4b:	53                   	push   %ebx
  801b4c:	ff 75 0c             	pushl  0xc(%ebp)
  801b4f:	68 04 60 80 00       	push   $0x806004
  801b54:	e8 39 ef ff ff       	call   800a92 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b59:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b5f:	b8 05 00 00 00       	mov    $0x5,%eax
  801b64:	e8 c1 fe ff ff       	call   801a2a <nsipc>
}
  801b69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b84:	b8 06 00 00 00       	mov    $0x6,%eax
  801b89:	e8 9c fe ff ff       	call   801a2a <nsipc>
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	56                   	push   %esi
  801b94:	53                   	push   %ebx
  801b95:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801ba0:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801ba6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba9:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bae:	b8 07 00 00 00       	mov    $0x7,%eax
  801bb3:	e8 72 fe ff ff       	call   801a2a <nsipc>
  801bb8:	89 c3                	mov    %eax,%ebx
  801bba:	85 c0                	test   %eax,%eax
  801bbc:	78 1f                	js     801bdd <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bbe:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bc3:	7f 21                	jg     801be6 <nsipc_recv+0x56>
  801bc5:	39 c6                	cmp    %eax,%esi
  801bc7:	7c 1d                	jl     801be6 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bc9:	83 ec 04             	sub    $0x4,%esp
  801bcc:	50                   	push   %eax
  801bcd:	68 00 60 80 00       	push   $0x806000
  801bd2:	ff 75 0c             	pushl  0xc(%ebp)
  801bd5:	e8 b8 ee ff ff       	call   800a92 <memmove>
  801bda:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801bdd:	89 d8                	mov    %ebx,%eax
  801bdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be2:	5b                   	pop    %ebx
  801be3:	5e                   	pop    %esi
  801be4:	5d                   	pop    %ebp
  801be5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801be6:	68 3f 2a 80 00       	push   $0x802a3f
  801beb:	68 07 2a 80 00       	push   $0x802a07
  801bf0:	6a 62                	push   $0x62
  801bf2:	68 54 2a 80 00       	push   $0x802a54
  801bf7:	e8 4b 05 00 00       	call   802147 <_panic>

00801bfc <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	53                   	push   %ebx
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c0e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c14:	7f 2e                	jg     801c44 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c16:	83 ec 04             	sub    $0x4,%esp
  801c19:	53                   	push   %ebx
  801c1a:	ff 75 0c             	pushl  0xc(%ebp)
  801c1d:	68 0c 60 80 00       	push   $0x80600c
  801c22:	e8 6b ee ff ff       	call   800a92 <memmove>
	nsipcbuf.send.req_size = size;
  801c27:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c30:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c35:	b8 08 00 00 00       	mov    $0x8,%eax
  801c3a:	e8 eb fd ff ff       	call   801a2a <nsipc>
}
  801c3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    
	assert(size < 1600);
  801c44:	68 60 2a 80 00       	push   $0x802a60
  801c49:	68 07 2a 80 00       	push   $0x802a07
  801c4e:	6a 6d                	push   $0x6d
  801c50:	68 54 2a 80 00       	push   $0x802a54
  801c55:	e8 ed 04 00 00       	call   802147 <_panic>

00801c5a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6b:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c70:	8b 45 10             	mov    0x10(%ebp),%eax
  801c73:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c78:	b8 09 00 00 00       	mov    $0x9,%eax
  801c7d:	e8 a8 fd ff ff       	call   801a2a <nsipc>
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	56                   	push   %esi
  801c88:	53                   	push   %ebx
  801c89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c8c:	83 ec 0c             	sub    $0xc,%esp
  801c8f:	ff 75 08             	pushl  0x8(%ebp)
  801c92:	e8 6a f3 ff ff       	call   801001 <fd2data>
  801c97:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c99:	83 c4 08             	add    $0x8,%esp
  801c9c:	68 6c 2a 80 00       	push   $0x802a6c
  801ca1:	53                   	push   %ebx
  801ca2:	e8 5d ec ff ff       	call   800904 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ca7:	8b 46 04             	mov    0x4(%esi),%eax
  801caa:	2b 06                	sub    (%esi),%eax
  801cac:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cb2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cb9:	00 00 00 
	stat->st_dev = &devpipe;
  801cbc:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cc3:	30 80 00 
	return 0;
}
  801cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cce:	5b                   	pop    %ebx
  801ccf:	5e                   	pop    %esi
  801cd0:	5d                   	pop    %ebp
  801cd1:	c3                   	ret    

00801cd2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	53                   	push   %ebx
  801cd6:	83 ec 0c             	sub    $0xc,%esp
  801cd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cdc:	53                   	push   %ebx
  801cdd:	6a 00                	push   $0x0
  801cdf:	e8 97 f0 ff ff       	call   800d7b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ce4:	89 1c 24             	mov    %ebx,(%esp)
  801ce7:	e8 15 f3 ff ff       	call   801001 <fd2data>
  801cec:	83 c4 08             	add    $0x8,%esp
  801cef:	50                   	push   %eax
  801cf0:	6a 00                	push   $0x0
  801cf2:	e8 84 f0 ff ff       	call   800d7b <sys_page_unmap>
}
  801cf7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <_pipeisclosed>:
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	57                   	push   %edi
  801d00:	56                   	push   %esi
  801d01:	53                   	push   %ebx
  801d02:	83 ec 1c             	sub    $0x1c,%esp
  801d05:	89 c7                	mov    %eax,%edi
  801d07:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d09:	a1 08 40 80 00       	mov    0x804008,%eax
  801d0e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d11:	83 ec 0c             	sub    $0xc,%esp
  801d14:	57                   	push   %edi
  801d15:	e8 f9 05 00 00       	call   802313 <pageref>
  801d1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d1d:	89 34 24             	mov    %esi,(%esp)
  801d20:	e8 ee 05 00 00       	call   802313 <pageref>
		nn = thisenv->env_runs;
  801d25:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d2b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	39 cb                	cmp    %ecx,%ebx
  801d33:	74 1b                	je     801d50 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d35:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d38:	75 cf                	jne    801d09 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d3a:	8b 42 58             	mov    0x58(%edx),%eax
  801d3d:	6a 01                	push   $0x1
  801d3f:	50                   	push   %eax
  801d40:	53                   	push   %ebx
  801d41:	68 73 2a 80 00       	push   $0x802a73
  801d46:	e8 5a e4 ff ff       	call   8001a5 <cprintf>
  801d4b:	83 c4 10             	add    $0x10,%esp
  801d4e:	eb b9                	jmp    801d09 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d50:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d53:	0f 94 c0             	sete   %al
  801d56:	0f b6 c0             	movzbl %al,%eax
}
  801d59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d5c:	5b                   	pop    %ebx
  801d5d:	5e                   	pop    %esi
  801d5e:	5f                   	pop    %edi
  801d5f:	5d                   	pop    %ebp
  801d60:	c3                   	ret    

00801d61 <devpipe_write>:
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	57                   	push   %edi
  801d65:	56                   	push   %esi
  801d66:	53                   	push   %ebx
  801d67:	83 ec 28             	sub    $0x28,%esp
  801d6a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d6d:	56                   	push   %esi
  801d6e:	e8 8e f2 ff ff       	call   801001 <fd2data>
  801d73:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d75:	83 c4 10             	add    $0x10,%esp
  801d78:	bf 00 00 00 00       	mov    $0x0,%edi
  801d7d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d80:	74 4f                	je     801dd1 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d82:	8b 43 04             	mov    0x4(%ebx),%eax
  801d85:	8b 0b                	mov    (%ebx),%ecx
  801d87:	8d 51 20             	lea    0x20(%ecx),%edx
  801d8a:	39 d0                	cmp    %edx,%eax
  801d8c:	72 14                	jb     801da2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d8e:	89 da                	mov    %ebx,%edx
  801d90:	89 f0                	mov    %esi,%eax
  801d92:	e8 65 ff ff ff       	call   801cfc <_pipeisclosed>
  801d97:	85 c0                	test   %eax,%eax
  801d99:	75 3b                	jne    801dd6 <devpipe_write+0x75>
			sys_yield();
  801d9b:	e8 37 ef ff ff       	call   800cd7 <sys_yield>
  801da0:	eb e0                	jmp    801d82 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801da2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801da5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801da9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dac:	89 c2                	mov    %eax,%edx
  801dae:	c1 fa 1f             	sar    $0x1f,%edx
  801db1:	89 d1                	mov    %edx,%ecx
  801db3:	c1 e9 1b             	shr    $0x1b,%ecx
  801db6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801db9:	83 e2 1f             	and    $0x1f,%edx
  801dbc:	29 ca                	sub    %ecx,%edx
  801dbe:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dc2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dc6:	83 c0 01             	add    $0x1,%eax
  801dc9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dcc:	83 c7 01             	add    $0x1,%edi
  801dcf:	eb ac                	jmp    801d7d <devpipe_write+0x1c>
	return i;
  801dd1:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd4:	eb 05                	jmp    801ddb <devpipe_write+0x7a>
				return 0;
  801dd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dde:	5b                   	pop    %ebx
  801ddf:	5e                   	pop    %esi
  801de0:	5f                   	pop    %edi
  801de1:	5d                   	pop    %ebp
  801de2:	c3                   	ret    

00801de3 <devpipe_read>:
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	57                   	push   %edi
  801de7:	56                   	push   %esi
  801de8:	53                   	push   %ebx
  801de9:	83 ec 18             	sub    $0x18,%esp
  801dec:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801def:	57                   	push   %edi
  801df0:	e8 0c f2 ff ff       	call   801001 <fd2data>
  801df5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801df7:	83 c4 10             	add    $0x10,%esp
  801dfa:	be 00 00 00 00       	mov    $0x0,%esi
  801dff:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e02:	75 14                	jne    801e18 <devpipe_read+0x35>
	return i;
  801e04:	8b 45 10             	mov    0x10(%ebp),%eax
  801e07:	eb 02                	jmp    801e0b <devpipe_read+0x28>
				return i;
  801e09:	89 f0                	mov    %esi,%eax
}
  801e0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e0e:	5b                   	pop    %ebx
  801e0f:	5e                   	pop    %esi
  801e10:	5f                   	pop    %edi
  801e11:	5d                   	pop    %ebp
  801e12:	c3                   	ret    
			sys_yield();
  801e13:	e8 bf ee ff ff       	call   800cd7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e18:	8b 03                	mov    (%ebx),%eax
  801e1a:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e1d:	75 18                	jne    801e37 <devpipe_read+0x54>
			if (i > 0)
  801e1f:	85 f6                	test   %esi,%esi
  801e21:	75 e6                	jne    801e09 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e23:	89 da                	mov    %ebx,%edx
  801e25:	89 f8                	mov    %edi,%eax
  801e27:	e8 d0 fe ff ff       	call   801cfc <_pipeisclosed>
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	74 e3                	je     801e13 <devpipe_read+0x30>
				return 0;
  801e30:	b8 00 00 00 00       	mov    $0x0,%eax
  801e35:	eb d4                	jmp    801e0b <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e37:	99                   	cltd   
  801e38:	c1 ea 1b             	shr    $0x1b,%edx
  801e3b:	01 d0                	add    %edx,%eax
  801e3d:	83 e0 1f             	and    $0x1f,%eax
  801e40:	29 d0                	sub    %edx,%eax
  801e42:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e4a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e4d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e50:	83 c6 01             	add    $0x1,%esi
  801e53:	eb aa                	jmp    801dff <devpipe_read+0x1c>

00801e55 <pipe>:
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	56                   	push   %esi
  801e59:	53                   	push   %ebx
  801e5a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e5d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e60:	50                   	push   %eax
  801e61:	e8 b2 f1 ff ff       	call   801018 <fd_alloc>
  801e66:	89 c3                	mov    %eax,%ebx
  801e68:	83 c4 10             	add    $0x10,%esp
  801e6b:	85 c0                	test   %eax,%eax
  801e6d:	0f 88 23 01 00 00    	js     801f96 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e73:	83 ec 04             	sub    $0x4,%esp
  801e76:	68 07 04 00 00       	push   $0x407
  801e7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7e:	6a 00                	push   $0x0
  801e80:	e8 71 ee ff ff       	call   800cf6 <sys_page_alloc>
  801e85:	89 c3                	mov    %eax,%ebx
  801e87:	83 c4 10             	add    $0x10,%esp
  801e8a:	85 c0                	test   %eax,%eax
  801e8c:	0f 88 04 01 00 00    	js     801f96 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e92:	83 ec 0c             	sub    $0xc,%esp
  801e95:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e98:	50                   	push   %eax
  801e99:	e8 7a f1 ff ff       	call   801018 <fd_alloc>
  801e9e:	89 c3                	mov    %eax,%ebx
  801ea0:	83 c4 10             	add    $0x10,%esp
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	0f 88 db 00 00 00    	js     801f86 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eab:	83 ec 04             	sub    $0x4,%esp
  801eae:	68 07 04 00 00       	push   $0x407
  801eb3:	ff 75 f0             	pushl  -0x10(%ebp)
  801eb6:	6a 00                	push   $0x0
  801eb8:	e8 39 ee ff ff       	call   800cf6 <sys_page_alloc>
  801ebd:	89 c3                	mov    %eax,%ebx
  801ebf:	83 c4 10             	add    $0x10,%esp
  801ec2:	85 c0                	test   %eax,%eax
  801ec4:	0f 88 bc 00 00 00    	js     801f86 <pipe+0x131>
	va = fd2data(fd0);
  801eca:	83 ec 0c             	sub    $0xc,%esp
  801ecd:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed0:	e8 2c f1 ff ff       	call   801001 <fd2data>
  801ed5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed7:	83 c4 0c             	add    $0xc,%esp
  801eda:	68 07 04 00 00       	push   $0x407
  801edf:	50                   	push   %eax
  801ee0:	6a 00                	push   $0x0
  801ee2:	e8 0f ee ff ff       	call   800cf6 <sys_page_alloc>
  801ee7:	89 c3                	mov    %eax,%ebx
  801ee9:	83 c4 10             	add    $0x10,%esp
  801eec:	85 c0                	test   %eax,%eax
  801eee:	0f 88 82 00 00 00    	js     801f76 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ef4:	83 ec 0c             	sub    $0xc,%esp
  801ef7:	ff 75 f0             	pushl  -0x10(%ebp)
  801efa:	e8 02 f1 ff ff       	call   801001 <fd2data>
  801eff:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f06:	50                   	push   %eax
  801f07:	6a 00                	push   $0x0
  801f09:	56                   	push   %esi
  801f0a:	6a 00                	push   $0x0
  801f0c:	e8 28 ee ff ff       	call   800d39 <sys_page_map>
  801f11:	89 c3                	mov    %eax,%ebx
  801f13:	83 c4 20             	add    $0x20,%esp
  801f16:	85 c0                	test   %eax,%eax
  801f18:	78 4e                	js     801f68 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f1a:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f22:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f27:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f31:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f36:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f3d:	83 ec 0c             	sub    $0xc,%esp
  801f40:	ff 75 f4             	pushl  -0xc(%ebp)
  801f43:	e8 a9 f0 ff ff       	call   800ff1 <fd2num>
  801f48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f4b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f4d:	83 c4 04             	add    $0x4,%esp
  801f50:	ff 75 f0             	pushl  -0x10(%ebp)
  801f53:	e8 99 f0 ff ff       	call   800ff1 <fd2num>
  801f58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f5b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f5e:	83 c4 10             	add    $0x10,%esp
  801f61:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f66:	eb 2e                	jmp    801f96 <pipe+0x141>
	sys_page_unmap(0, va);
  801f68:	83 ec 08             	sub    $0x8,%esp
  801f6b:	56                   	push   %esi
  801f6c:	6a 00                	push   $0x0
  801f6e:	e8 08 ee ff ff       	call   800d7b <sys_page_unmap>
  801f73:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f76:	83 ec 08             	sub    $0x8,%esp
  801f79:	ff 75 f0             	pushl  -0x10(%ebp)
  801f7c:	6a 00                	push   $0x0
  801f7e:	e8 f8 ed ff ff       	call   800d7b <sys_page_unmap>
  801f83:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f86:	83 ec 08             	sub    $0x8,%esp
  801f89:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8c:	6a 00                	push   $0x0
  801f8e:	e8 e8 ed ff ff       	call   800d7b <sys_page_unmap>
  801f93:	83 c4 10             	add    $0x10,%esp
}
  801f96:	89 d8                	mov    %ebx,%eax
  801f98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f9b:	5b                   	pop    %ebx
  801f9c:	5e                   	pop    %esi
  801f9d:	5d                   	pop    %ebp
  801f9e:	c3                   	ret    

00801f9f <pipeisclosed>:
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fa5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa8:	50                   	push   %eax
  801fa9:	ff 75 08             	pushl  0x8(%ebp)
  801fac:	e8 b9 f0 ff ff       	call   80106a <fd_lookup>
  801fb1:	83 c4 10             	add    $0x10,%esp
  801fb4:	85 c0                	test   %eax,%eax
  801fb6:	78 18                	js     801fd0 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fb8:	83 ec 0c             	sub    $0xc,%esp
  801fbb:	ff 75 f4             	pushl  -0xc(%ebp)
  801fbe:	e8 3e f0 ff ff       	call   801001 <fd2data>
	return _pipeisclosed(fd, p);
  801fc3:	89 c2                	mov    %eax,%edx
  801fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc8:	e8 2f fd ff ff       	call   801cfc <_pipeisclosed>
  801fcd:	83 c4 10             	add    $0x10,%esp
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd7:	c3                   	ret    

00801fd8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fde:	68 8b 2a 80 00       	push   $0x802a8b
  801fe3:	ff 75 0c             	pushl  0xc(%ebp)
  801fe6:	e8 19 e9 ff ff       	call   800904 <strcpy>
	return 0;
}
  801feb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <devcons_write>:
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	57                   	push   %edi
  801ff6:	56                   	push   %esi
  801ff7:	53                   	push   %ebx
  801ff8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ffe:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802003:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802009:	3b 75 10             	cmp    0x10(%ebp),%esi
  80200c:	73 31                	jae    80203f <devcons_write+0x4d>
		m = n - tot;
  80200e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802011:	29 f3                	sub    %esi,%ebx
  802013:	83 fb 7f             	cmp    $0x7f,%ebx
  802016:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80201b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80201e:	83 ec 04             	sub    $0x4,%esp
  802021:	53                   	push   %ebx
  802022:	89 f0                	mov    %esi,%eax
  802024:	03 45 0c             	add    0xc(%ebp),%eax
  802027:	50                   	push   %eax
  802028:	57                   	push   %edi
  802029:	e8 64 ea ff ff       	call   800a92 <memmove>
		sys_cputs(buf, m);
  80202e:	83 c4 08             	add    $0x8,%esp
  802031:	53                   	push   %ebx
  802032:	57                   	push   %edi
  802033:	e8 02 ec ff ff       	call   800c3a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802038:	01 de                	add    %ebx,%esi
  80203a:	83 c4 10             	add    $0x10,%esp
  80203d:	eb ca                	jmp    802009 <devcons_write+0x17>
}
  80203f:	89 f0                	mov    %esi,%eax
  802041:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802044:	5b                   	pop    %ebx
  802045:	5e                   	pop    %esi
  802046:	5f                   	pop    %edi
  802047:	5d                   	pop    %ebp
  802048:	c3                   	ret    

00802049 <devcons_read>:
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 08             	sub    $0x8,%esp
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802054:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802058:	74 21                	je     80207b <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80205a:	e8 f9 eb ff ff       	call   800c58 <sys_cgetc>
  80205f:	85 c0                	test   %eax,%eax
  802061:	75 07                	jne    80206a <devcons_read+0x21>
		sys_yield();
  802063:	e8 6f ec ff ff       	call   800cd7 <sys_yield>
  802068:	eb f0                	jmp    80205a <devcons_read+0x11>
	if (c < 0)
  80206a:	78 0f                	js     80207b <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80206c:	83 f8 04             	cmp    $0x4,%eax
  80206f:	74 0c                	je     80207d <devcons_read+0x34>
	*(char*)vbuf = c;
  802071:	8b 55 0c             	mov    0xc(%ebp),%edx
  802074:	88 02                	mov    %al,(%edx)
	return 1;
  802076:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    
		return 0;
  80207d:	b8 00 00 00 00       	mov    $0x0,%eax
  802082:	eb f7                	jmp    80207b <devcons_read+0x32>

00802084 <cputchar>:
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802090:	6a 01                	push   $0x1
  802092:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802095:	50                   	push   %eax
  802096:	e8 9f eb ff ff       	call   800c3a <sys_cputs>
}
  80209b:	83 c4 10             	add    $0x10,%esp
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <getchar>:
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020a6:	6a 01                	push   $0x1
  8020a8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020ab:	50                   	push   %eax
  8020ac:	6a 00                	push   $0x0
  8020ae:	e8 27 f2 ff ff       	call   8012da <read>
	if (r < 0)
  8020b3:	83 c4 10             	add    $0x10,%esp
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	78 06                	js     8020c0 <getchar+0x20>
	if (r < 1)
  8020ba:	74 06                	je     8020c2 <getchar+0x22>
	return c;
  8020bc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    
		return -E_EOF;
  8020c2:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020c7:	eb f7                	jmp    8020c0 <getchar+0x20>

008020c9 <iscons>:
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d2:	50                   	push   %eax
  8020d3:	ff 75 08             	pushl  0x8(%ebp)
  8020d6:	e8 8f ef ff ff       	call   80106a <fd_lookup>
  8020db:	83 c4 10             	add    $0x10,%esp
  8020de:	85 c0                	test   %eax,%eax
  8020e0:	78 11                	js     8020f3 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020eb:	39 10                	cmp    %edx,(%eax)
  8020ed:	0f 94 c0             	sete   %al
  8020f0:	0f b6 c0             	movzbl %al,%eax
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <opencons>:
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020fe:	50                   	push   %eax
  8020ff:	e8 14 ef ff ff       	call   801018 <fd_alloc>
  802104:	83 c4 10             	add    $0x10,%esp
  802107:	85 c0                	test   %eax,%eax
  802109:	78 3a                	js     802145 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80210b:	83 ec 04             	sub    $0x4,%esp
  80210e:	68 07 04 00 00       	push   $0x407
  802113:	ff 75 f4             	pushl  -0xc(%ebp)
  802116:	6a 00                	push   $0x0
  802118:	e8 d9 eb ff ff       	call   800cf6 <sys_page_alloc>
  80211d:	83 c4 10             	add    $0x10,%esp
  802120:	85 c0                	test   %eax,%eax
  802122:	78 21                	js     802145 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80212d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802139:	83 ec 0c             	sub    $0xc,%esp
  80213c:	50                   	push   %eax
  80213d:	e8 af ee ff ff       	call   800ff1 <fd2num>
  802142:	83 c4 10             	add    $0x10,%esp
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	56                   	push   %esi
  80214b:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80214c:	a1 08 40 80 00       	mov    0x804008,%eax
  802151:	8b 40 48             	mov    0x48(%eax),%eax
  802154:	83 ec 04             	sub    $0x4,%esp
  802157:	68 c8 2a 80 00       	push   $0x802ac8
  80215c:	50                   	push   %eax
  80215d:	68 97 2a 80 00       	push   $0x802a97
  802162:	e8 3e e0 ff ff       	call   8001a5 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802167:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80216a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802170:	e8 43 eb ff ff       	call   800cb8 <sys_getenvid>
  802175:	83 c4 04             	add    $0x4,%esp
  802178:	ff 75 0c             	pushl  0xc(%ebp)
  80217b:	ff 75 08             	pushl  0x8(%ebp)
  80217e:	56                   	push   %esi
  80217f:	50                   	push   %eax
  802180:	68 a4 2a 80 00       	push   $0x802aa4
  802185:	e8 1b e0 ff ff       	call   8001a5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80218a:	83 c4 18             	add    $0x18,%esp
  80218d:	53                   	push   %ebx
  80218e:	ff 75 10             	pushl  0x10(%ebp)
  802191:	e8 be df ff ff       	call   800154 <vcprintf>
	cprintf("\n");
  802196:	c7 04 24 b8 25 80 00 	movl   $0x8025b8,(%esp)
  80219d:	e8 03 e0 ff ff       	call   8001a5 <cprintf>
  8021a2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021a5:	cc                   	int3   
  8021a6:	eb fd                	jmp    8021a5 <_panic+0x5e>

008021a8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8021ae:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8021b5:	74 0a                	je     8021c1 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8021c1:	83 ec 04             	sub    $0x4,%esp
  8021c4:	6a 07                	push   $0x7
  8021c6:	68 00 f0 bf ee       	push   $0xeebff000
  8021cb:	6a 00                	push   $0x0
  8021cd:	e8 24 eb ff ff       	call   800cf6 <sys_page_alloc>
		if(r < 0)
  8021d2:	83 c4 10             	add    $0x10,%esp
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	78 2a                	js     802203 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8021d9:	83 ec 08             	sub    $0x8,%esp
  8021dc:	68 cb 0f 80 00       	push   $0x800fcb
  8021e1:	6a 00                	push   $0x0
  8021e3:	e8 59 ec ff ff       	call   800e41 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8021e8:	83 c4 10             	add    $0x10,%esp
  8021eb:	85 c0                	test   %eax,%eax
  8021ed:	79 c8                	jns    8021b7 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8021ef:	83 ec 04             	sub    $0x4,%esp
  8021f2:	68 00 2b 80 00       	push   $0x802b00
  8021f7:	6a 25                	push   $0x25
  8021f9:	68 3c 2b 80 00       	push   $0x802b3c
  8021fe:	e8 44 ff ff ff       	call   802147 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802203:	83 ec 04             	sub    $0x4,%esp
  802206:	68 d0 2a 80 00       	push   $0x802ad0
  80220b:	6a 22                	push   $0x22
  80220d:	68 3c 2b 80 00       	push   $0x802b3c
  802212:	e8 30 ff ff ff       	call   802147 <_panic>

00802217 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	56                   	push   %esi
  80221b:	53                   	push   %ebx
  80221c:	8b 75 08             	mov    0x8(%ebp),%esi
  80221f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802222:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802225:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802227:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80222c:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80222f:	83 ec 0c             	sub    $0xc,%esp
  802232:	50                   	push   %eax
  802233:	e8 6e ec ff ff       	call   800ea6 <sys_ipc_recv>
	if(ret < 0){
  802238:	83 c4 10             	add    $0x10,%esp
  80223b:	85 c0                	test   %eax,%eax
  80223d:	78 2b                	js     80226a <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80223f:	85 f6                	test   %esi,%esi
  802241:	74 0a                	je     80224d <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802243:	a1 08 40 80 00       	mov    0x804008,%eax
  802248:	8b 40 74             	mov    0x74(%eax),%eax
  80224b:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80224d:	85 db                	test   %ebx,%ebx
  80224f:	74 0a                	je     80225b <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802251:	a1 08 40 80 00       	mov    0x804008,%eax
  802256:	8b 40 78             	mov    0x78(%eax),%eax
  802259:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80225b:	a1 08 40 80 00       	mov    0x804008,%eax
  802260:	8b 40 70             	mov    0x70(%eax),%eax
}
  802263:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802266:	5b                   	pop    %ebx
  802267:	5e                   	pop    %esi
  802268:	5d                   	pop    %ebp
  802269:	c3                   	ret    
		if(from_env_store)
  80226a:	85 f6                	test   %esi,%esi
  80226c:	74 06                	je     802274 <ipc_recv+0x5d>
			*from_env_store = 0;
  80226e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802274:	85 db                	test   %ebx,%ebx
  802276:	74 eb                	je     802263 <ipc_recv+0x4c>
			*perm_store = 0;
  802278:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80227e:	eb e3                	jmp    802263 <ipc_recv+0x4c>

00802280 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	57                   	push   %edi
  802284:	56                   	push   %esi
  802285:	53                   	push   %ebx
  802286:	83 ec 0c             	sub    $0xc,%esp
  802289:	8b 7d 08             	mov    0x8(%ebp),%edi
  80228c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80228f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802292:	85 db                	test   %ebx,%ebx
  802294:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802299:	0f 44 d8             	cmove  %eax,%ebx
  80229c:	eb 05                	jmp    8022a3 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80229e:	e8 34 ea ff ff       	call   800cd7 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8022a3:	ff 75 14             	pushl  0x14(%ebp)
  8022a6:	53                   	push   %ebx
  8022a7:	56                   	push   %esi
  8022a8:	57                   	push   %edi
  8022a9:	e8 d5 eb ff ff       	call   800e83 <sys_ipc_try_send>
  8022ae:	83 c4 10             	add    $0x10,%esp
  8022b1:	85 c0                	test   %eax,%eax
  8022b3:	74 1b                	je     8022d0 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022b5:	79 e7                	jns    80229e <ipc_send+0x1e>
  8022b7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022ba:	74 e2                	je     80229e <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022bc:	83 ec 04             	sub    $0x4,%esp
  8022bf:	68 4a 2b 80 00       	push   $0x802b4a
  8022c4:	6a 48                	push   $0x48
  8022c6:	68 5f 2b 80 00       	push   $0x802b5f
  8022cb:	e8 77 fe ff ff       	call   802147 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022d3:	5b                   	pop    %ebx
  8022d4:	5e                   	pop    %esi
  8022d5:	5f                   	pop    %edi
  8022d6:	5d                   	pop    %ebp
  8022d7:	c3                   	ret    

008022d8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
  8022db:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022de:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022e3:	89 c2                	mov    %eax,%edx
  8022e5:	c1 e2 07             	shl    $0x7,%edx
  8022e8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022ee:	8b 52 50             	mov    0x50(%edx),%edx
  8022f1:	39 ca                	cmp    %ecx,%edx
  8022f3:	74 11                	je     802306 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022f5:	83 c0 01             	add    $0x1,%eax
  8022f8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022fd:	75 e4                	jne    8022e3 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802304:	eb 0b                	jmp    802311 <ipc_find_env+0x39>
			return envs[i].env_id;
  802306:	c1 e0 07             	shl    $0x7,%eax
  802309:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80230e:	8b 40 48             	mov    0x48(%eax),%eax
}
  802311:	5d                   	pop    %ebp
  802312:	c3                   	ret    

00802313 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
  802316:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802319:	89 d0                	mov    %edx,%eax
  80231b:	c1 e8 16             	shr    $0x16,%eax
  80231e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802325:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80232a:	f6 c1 01             	test   $0x1,%cl
  80232d:	74 1d                	je     80234c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80232f:	c1 ea 0c             	shr    $0xc,%edx
  802332:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802339:	f6 c2 01             	test   $0x1,%dl
  80233c:	74 0e                	je     80234c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80233e:	c1 ea 0c             	shr    $0xc,%edx
  802341:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802348:	ef 
  802349:	0f b7 c0             	movzwl %ax,%eax
}
  80234c:	5d                   	pop    %ebp
  80234d:	c3                   	ret    
  80234e:	66 90                	xchg   %ax,%ax

00802350 <__udivdi3>:
  802350:	55                   	push   %ebp
  802351:	57                   	push   %edi
  802352:	56                   	push   %esi
  802353:	53                   	push   %ebx
  802354:	83 ec 1c             	sub    $0x1c,%esp
  802357:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80235b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80235f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802363:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802367:	85 d2                	test   %edx,%edx
  802369:	75 4d                	jne    8023b8 <__udivdi3+0x68>
  80236b:	39 f3                	cmp    %esi,%ebx
  80236d:	76 19                	jbe    802388 <__udivdi3+0x38>
  80236f:	31 ff                	xor    %edi,%edi
  802371:	89 e8                	mov    %ebp,%eax
  802373:	89 f2                	mov    %esi,%edx
  802375:	f7 f3                	div    %ebx
  802377:	89 fa                	mov    %edi,%edx
  802379:	83 c4 1c             	add    $0x1c,%esp
  80237c:	5b                   	pop    %ebx
  80237d:	5e                   	pop    %esi
  80237e:	5f                   	pop    %edi
  80237f:	5d                   	pop    %ebp
  802380:	c3                   	ret    
  802381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802388:	89 d9                	mov    %ebx,%ecx
  80238a:	85 db                	test   %ebx,%ebx
  80238c:	75 0b                	jne    802399 <__udivdi3+0x49>
  80238e:	b8 01 00 00 00       	mov    $0x1,%eax
  802393:	31 d2                	xor    %edx,%edx
  802395:	f7 f3                	div    %ebx
  802397:	89 c1                	mov    %eax,%ecx
  802399:	31 d2                	xor    %edx,%edx
  80239b:	89 f0                	mov    %esi,%eax
  80239d:	f7 f1                	div    %ecx
  80239f:	89 c6                	mov    %eax,%esi
  8023a1:	89 e8                	mov    %ebp,%eax
  8023a3:	89 f7                	mov    %esi,%edi
  8023a5:	f7 f1                	div    %ecx
  8023a7:	89 fa                	mov    %edi,%edx
  8023a9:	83 c4 1c             	add    $0x1c,%esp
  8023ac:	5b                   	pop    %ebx
  8023ad:	5e                   	pop    %esi
  8023ae:	5f                   	pop    %edi
  8023af:	5d                   	pop    %ebp
  8023b0:	c3                   	ret    
  8023b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	39 f2                	cmp    %esi,%edx
  8023ba:	77 1c                	ja     8023d8 <__udivdi3+0x88>
  8023bc:	0f bd fa             	bsr    %edx,%edi
  8023bf:	83 f7 1f             	xor    $0x1f,%edi
  8023c2:	75 2c                	jne    8023f0 <__udivdi3+0xa0>
  8023c4:	39 f2                	cmp    %esi,%edx
  8023c6:	72 06                	jb     8023ce <__udivdi3+0x7e>
  8023c8:	31 c0                	xor    %eax,%eax
  8023ca:	39 eb                	cmp    %ebp,%ebx
  8023cc:	77 a9                	ja     802377 <__udivdi3+0x27>
  8023ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d3:	eb a2                	jmp    802377 <__udivdi3+0x27>
  8023d5:	8d 76 00             	lea    0x0(%esi),%esi
  8023d8:	31 ff                	xor    %edi,%edi
  8023da:	31 c0                	xor    %eax,%eax
  8023dc:	89 fa                	mov    %edi,%edx
  8023de:	83 c4 1c             	add    $0x1c,%esp
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	5f                   	pop    %edi
  8023e4:	5d                   	pop    %ebp
  8023e5:	c3                   	ret    
  8023e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ed:	8d 76 00             	lea    0x0(%esi),%esi
  8023f0:	89 f9                	mov    %edi,%ecx
  8023f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023f7:	29 f8                	sub    %edi,%eax
  8023f9:	d3 e2                	shl    %cl,%edx
  8023fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023ff:	89 c1                	mov    %eax,%ecx
  802401:	89 da                	mov    %ebx,%edx
  802403:	d3 ea                	shr    %cl,%edx
  802405:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802409:	09 d1                	or     %edx,%ecx
  80240b:	89 f2                	mov    %esi,%edx
  80240d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802411:	89 f9                	mov    %edi,%ecx
  802413:	d3 e3                	shl    %cl,%ebx
  802415:	89 c1                	mov    %eax,%ecx
  802417:	d3 ea                	shr    %cl,%edx
  802419:	89 f9                	mov    %edi,%ecx
  80241b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80241f:	89 eb                	mov    %ebp,%ebx
  802421:	d3 e6                	shl    %cl,%esi
  802423:	89 c1                	mov    %eax,%ecx
  802425:	d3 eb                	shr    %cl,%ebx
  802427:	09 de                	or     %ebx,%esi
  802429:	89 f0                	mov    %esi,%eax
  80242b:	f7 74 24 08          	divl   0x8(%esp)
  80242f:	89 d6                	mov    %edx,%esi
  802431:	89 c3                	mov    %eax,%ebx
  802433:	f7 64 24 0c          	mull   0xc(%esp)
  802437:	39 d6                	cmp    %edx,%esi
  802439:	72 15                	jb     802450 <__udivdi3+0x100>
  80243b:	89 f9                	mov    %edi,%ecx
  80243d:	d3 e5                	shl    %cl,%ebp
  80243f:	39 c5                	cmp    %eax,%ebp
  802441:	73 04                	jae    802447 <__udivdi3+0xf7>
  802443:	39 d6                	cmp    %edx,%esi
  802445:	74 09                	je     802450 <__udivdi3+0x100>
  802447:	89 d8                	mov    %ebx,%eax
  802449:	31 ff                	xor    %edi,%edi
  80244b:	e9 27 ff ff ff       	jmp    802377 <__udivdi3+0x27>
  802450:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802453:	31 ff                	xor    %edi,%edi
  802455:	e9 1d ff ff ff       	jmp    802377 <__udivdi3+0x27>
  80245a:	66 90                	xchg   %ax,%ax
  80245c:	66 90                	xchg   %ax,%ax
  80245e:	66 90                	xchg   %ax,%ax

00802460 <__umoddi3>:
  802460:	55                   	push   %ebp
  802461:	57                   	push   %edi
  802462:	56                   	push   %esi
  802463:	53                   	push   %ebx
  802464:	83 ec 1c             	sub    $0x1c,%esp
  802467:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80246b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80246f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802473:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802477:	89 da                	mov    %ebx,%edx
  802479:	85 c0                	test   %eax,%eax
  80247b:	75 43                	jne    8024c0 <__umoddi3+0x60>
  80247d:	39 df                	cmp    %ebx,%edi
  80247f:	76 17                	jbe    802498 <__umoddi3+0x38>
  802481:	89 f0                	mov    %esi,%eax
  802483:	f7 f7                	div    %edi
  802485:	89 d0                	mov    %edx,%eax
  802487:	31 d2                	xor    %edx,%edx
  802489:	83 c4 1c             	add    $0x1c,%esp
  80248c:	5b                   	pop    %ebx
  80248d:	5e                   	pop    %esi
  80248e:	5f                   	pop    %edi
  80248f:	5d                   	pop    %ebp
  802490:	c3                   	ret    
  802491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802498:	89 fd                	mov    %edi,%ebp
  80249a:	85 ff                	test   %edi,%edi
  80249c:	75 0b                	jne    8024a9 <__umoddi3+0x49>
  80249e:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a3:	31 d2                	xor    %edx,%edx
  8024a5:	f7 f7                	div    %edi
  8024a7:	89 c5                	mov    %eax,%ebp
  8024a9:	89 d8                	mov    %ebx,%eax
  8024ab:	31 d2                	xor    %edx,%edx
  8024ad:	f7 f5                	div    %ebp
  8024af:	89 f0                	mov    %esi,%eax
  8024b1:	f7 f5                	div    %ebp
  8024b3:	89 d0                	mov    %edx,%eax
  8024b5:	eb d0                	jmp    802487 <__umoddi3+0x27>
  8024b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024be:	66 90                	xchg   %ax,%ax
  8024c0:	89 f1                	mov    %esi,%ecx
  8024c2:	39 d8                	cmp    %ebx,%eax
  8024c4:	76 0a                	jbe    8024d0 <__umoddi3+0x70>
  8024c6:	89 f0                	mov    %esi,%eax
  8024c8:	83 c4 1c             	add    $0x1c,%esp
  8024cb:	5b                   	pop    %ebx
  8024cc:	5e                   	pop    %esi
  8024cd:	5f                   	pop    %edi
  8024ce:	5d                   	pop    %ebp
  8024cf:	c3                   	ret    
  8024d0:	0f bd e8             	bsr    %eax,%ebp
  8024d3:	83 f5 1f             	xor    $0x1f,%ebp
  8024d6:	75 20                	jne    8024f8 <__umoddi3+0x98>
  8024d8:	39 d8                	cmp    %ebx,%eax
  8024da:	0f 82 b0 00 00 00    	jb     802590 <__umoddi3+0x130>
  8024e0:	39 f7                	cmp    %esi,%edi
  8024e2:	0f 86 a8 00 00 00    	jbe    802590 <__umoddi3+0x130>
  8024e8:	89 c8                	mov    %ecx,%eax
  8024ea:	83 c4 1c             	add    $0x1c,%esp
  8024ed:	5b                   	pop    %ebx
  8024ee:	5e                   	pop    %esi
  8024ef:	5f                   	pop    %edi
  8024f0:	5d                   	pop    %ebp
  8024f1:	c3                   	ret    
  8024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024f8:	89 e9                	mov    %ebp,%ecx
  8024fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8024ff:	29 ea                	sub    %ebp,%edx
  802501:	d3 e0                	shl    %cl,%eax
  802503:	89 44 24 08          	mov    %eax,0x8(%esp)
  802507:	89 d1                	mov    %edx,%ecx
  802509:	89 f8                	mov    %edi,%eax
  80250b:	d3 e8                	shr    %cl,%eax
  80250d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802511:	89 54 24 04          	mov    %edx,0x4(%esp)
  802515:	8b 54 24 04          	mov    0x4(%esp),%edx
  802519:	09 c1                	or     %eax,%ecx
  80251b:	89 d8                	mov    %ebx,%eax
  80251d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802521:	89 e9                	mov    %ebp,%ecx
  802523:	d3 e7                	shl    %cl,%edi
  802525:	89 d1                	mov    %edx,%ecx
  802527:	d3 e8                	shr    %cl,%eax
  802529:	89 e9                	mov    %ebp,%ecx
  80252b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80252f:	d3 e3                	shl    %cl,%ebx
  802531:	89 c7                	mov    %eax,%edi
  802533:	89 d1                	mov    %edx,%ecx
  802535:	89 f0                	mov    %esi,%eax
  802537:	d3 e8                	shr    %cl,%eax
  802539:	89 e9                	mov    %ebp,%ecx
  80253b:	89 fa                	mov    %edi,%edx
  80253d:	d3 e6                	shl    %cl,%esi
  80253f:	09 d8                	or     %ebx,%eax
  802541:	f7 74 24 08          	divl   0x8(%esp)
  802545:	89 d1                	mov    %edx,%ecx
  802547:	89 f3                	mov    %esi,%ebx
  802549:	f7 64 24 0c          	mull   0xc(%esp)
  80254d:	89 c6                	mov    %eax,%esi
  80254f:	89 d7                	mov    %edx,%edi
  802551:	39 d1                	cmp    %edx,%ecx
  802553:	72 06                	jb     80255b <__umoddi3+0xfb>
  802555:	75 10                	jne    802567 <__umoddi3+0x107>
  802557:	39 c3                	cmp    %eax,%ebx
  802559:	73 0c                	jae    802567 <__umoddi3+0x107>
  80255b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80255f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802563:	89 d7                	mov    %edx,%edi
  802565:	89 c6                	mov    %eax,%esi
  802567:	89 ca                	mov    %ecx,%edx
  802569:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80256e:	29 f3                	sub    %esi,%ebx
  802570:	19 fa                	sbb    %edi,%edx
  802572:	89 d0                	mov    %edx,%eax
  802574:	d3 e0                	shl    %cl,%eax
  802576:	89 e9                	mov    %ebp,%ecx
  802578:	d3 eb                	shr    %cl,%ebx
  80257a:	d3 ea                	shr    %cl,%edx
  80257c:	09 d8                	or     %ebx,%eax
  80257e:	83 c4 1c             	add    $0x1c,%esp
  802581:	5b                   	pop    %ebx
  802582:	5e                   	pop    %esi
  802583:	5f                   	pop    %edi
  802584:	5d                   	pop    %ebp
  802585:	c3                   	ret    
  802586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80258d:	8d 76 00             	lea    0x0(%esi),%esi
  802590:	89 da                	mov    %ebx,%edx
  802592:	29 fe                	sub    %edi,%esi
  802594:	19 c2                	sbb    %eax,%edx
  802596:	89 f1                	mov    %esi,%ecx
  802598:	89 c8                	mov    %ecx,%eax
  80259a:	e9 4b ff ff ff       	jmp    8024ea <__umoddi3+0x8a>
