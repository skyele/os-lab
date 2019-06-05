
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 69 00 00 00       	call   80009a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 08 40 80 00       	mov    0x804008,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	50                   	push   %eax
  800043:	68 60 25 80 00       	push   $0x802560
  800048:	e8 9e 01 00 00       	call   8001eb <cprintf>
  80004d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800050:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800055:	e8 c3 0c 00 00       	call   800d1d <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  80005f:	8b 40 48             	mov    0x48(%eax),%eax
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	53                   	push   %ebx
  800066:	50                   	push   %eax
  800067:	68 80 25 80 00       	push   $0x802580
  80006c:	e8 7a 01 00 00       	call   8001eb <cprintf>
	for (i = 0; i < 5; i++) {
  800071:	83 c3 01             	add    $0x1,%ebx
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	83 fb 05             	cmp    $0x5,%ebx
  80007a:	75 d9                	jne    800055 <umain+0x22>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  80007c:	a1 08 40 80 00       	mov    0x804008,%eax
  800081:	8b 40 48             	mov    0x48(%eax),%eax
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	50                   	push   %eax
  800088:	68 ac 25 80 00       	push   $0x8025ac
  80008d:	e8 59 01 00 00       	call   8001eb <cprintf>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	57                   	push   %edi
  80009e:	56                   	push   %esi
  80009f:	53                   	push   %ebx
  8000a0:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000a3:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8000aa:	00 00 00 
	envid_t find = sys_getenvid();
  8000ad:	e8 4c 0c 00 00       	call   800cfe <sys_getenvid>
  8000b2:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000b8:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000bd:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000c2:	bf 01 00 00 00       	mov    $0x1,%edi
  8000c7:	eb 0b                	jmp    8000d4 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000c9:	83 c2 01             	add    $0x1,%edx
  8000cc:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000d2:	74 21                	je     8000f5 <libmain+0x5b>
		if(envs[i].env_id == find)
  8000d4:	89 d1                	mov    %edx,%ecx
  8000d6:	c1 e1 07             	shl    $0x7,%ecx
  8000d9:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000df:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000e2:	39 c1                	cmp    %eax,%ecx
  8000e4:	75 e3                	jne    8000c9 <libmain+0x2f>
  8000e6:	89 d3                	mov    %edx,%ebx
  8000e8:	c1 e3 07             	shl    $0x7,%ebx
  8000eb:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000f1:	89 fe                	mov    %edi,%esi
  8000f3:	eb d4                	jmp    8000c9 <libmain+0x2f>
  8000f5:	89 f0                	mov    %esi,%eax
  8000f7:	84 c0                	test   %al,%al
  8000f9:	74 06                	je     800101 <libmain+0x67>
  8000fb:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800101:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800105:	7e 0a                	jle    800111 <libmain+0x77>
		binaryname = argv[0];
  800107:	8b 45 0c             	mov    0xc(%ebp),%eax
  80010a:	8b 00                	mov    (%eax),%eax
  80010c:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("in libmain.c call umain!\n");
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	68 cb 25 80 00       	push   $0x8025cb
  800119:	e8 cd 00 00 00       	call   8001eb <cprintf>
	// call user main routine
	umain(argc, argv);
  80011e:	83 c4 08             	add    $0x8,%esp
  800121:	ff 75 0c             	pushl  0xc(%ebp)
  800124:	ff 75 08             	pushl  0x8(%ebp)
  800127:	e8 07 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80012c:	e8 0b 00 00 00       	call   80013c <exit>
}
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800137:	5b                   	pop    %ebx
  800138:	5e                   	pop    %esi
  800139:	5f                   	pop    %edi
  80013a:	5d                   	pop    %ebp
  80013b:	c3                   	ret    

0080013c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800142:	e8 a2 10 00 00       	call   8011e9 <close_all>
	sys_env_destroy(0);
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 00                	push   $0x0
  80014c:	e8 6c 0b 00 00       	call   800cbd <sys_env_destroy>
}
  800151:	83 c4 10             	add    $0x10,%esp
  800154:	c9                   	leave  
  800155:	c3                   	ret    

00800156 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800156:	55                   	push   %ebp
  800157:	89 e5                	mov    %esp,%ebp
  800159:	53                   	push   %ebx
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800160:	8b 13                	mov    (%ebx),%edx
  800162:	8d 42 01             	lea    0x1(%edx),%eax
  800165:	89 03                	mov    %eax,(%ebx)
  800167:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80016e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800173:	74 09                	je     80017e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800175:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800179:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80017c:	c9                   	leave  
  80017d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	68 ff 00 00 00       	push   $0xff
  800186:	8d 43 08             	lea    0x8(%ebx),%eax
  800189:	50                   	push   %eax
  80018a:	e8 f1 0a 00 00       	call   800c80 <sys_cputs>
		b->idx = 0;
  80018f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	eb db                	jmp    800175 <putch+0x1f>

0080019a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001aa:	00 00 00 
	b.cnt = 0;
  8001ad:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001b7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c3:	50                   	push   %eax
  8001c4:	68 56 01 80 00       	push   $0x800156
  8001c9:	e8 4a 01 00 00       	call   800318 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ce:	83 c4 08             	add    $0x8,%esp
  8001d1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001d7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001dd:	50                   	push   %eax
  8001de:	e8 9d 0a 00 00       	call   800c80 <sys_cputs>

	return b.cnt;
}
  8001e3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001e9:	c9                   	leave  
  8001ea:	c3                   	ret    

008001eb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f4:	50                   	push   %eax
  8001f5:	ff 75 08             	pushl  0x8(%ebp)
  8001f8:	e8 9d ff ff ff       	call   80019a <vcprintf>
	va_end(ap);

	return cnt;
}
  8001fd:	c9                   	leave  
  8001fe:	c3                   	ret    

008001ff <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	57                   	push   %edi
  800203:	56                   	push   %esi
  800204:	53                   	push   %ebx
  800205:	83 ec 1c             	sub    $0x1c,%esp
  800208:	89 c6                	mov    %eax,%esi
  80020a:	89 d7                	mov    %edx,%edi
  80020c:	8b 45 08             	mov    0x8(%ebp),%eax
  80020f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800212:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800215:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800218:	8b 45 10             	mov    0x10(%ebp),%eax
  80021b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80021e:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800222:	74 2c                	je     800250 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800224:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800227:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80022e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800231:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800234:	39 c2                	cmp    %eax,%edx
  800236:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800239:	73 43                	jae    80027e <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80023b:	83 eb 01             	sub    $0x1,%ebx
  80023e:	85 db                	test   %ebx,%ebx
  800240:	7e 6c                	jle    8002ae <printnum+0xaf>
				putch(padc, putdat);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	57                   	push   %edi
  800246:	ff 75 18             	pushl  0x18(%ebp)
  800249:	ff d6                	call   *%esi
  80024b:	83 c4 10             	add    $0x10,%esp
  80024e:	eb eb                	jmp    80023b <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	6a 20                	push   $0x20
  800255:	6a 00                	push   $0x0
  800257:	50                   	push   %eax
  800258:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025b:	ff 75 e0             	pushl  -0x20(%ebp)
  80025e:	89 fa                	mov    %edi,%edx
  800260:	89 f0                	mov    %esi,%eax
  800262:	e8 98 ff ff ff       	call   8001ff <printnum>
		while (--width > 0)
  800267:	83 c4 20             	add    $0x20,%esp
  80026a:	83 eb 01             	sub    $0x1,%ebx
  80026d:	85 db                	test   %ebx,%ebx
  80026f:	7e 65                	jle    8002d6 <printnum+0xd7>
			putch(padc, putdat);
  800271:	83 ec 08             	sub    $0x8,%esp
  800274:	57                   	push   %edi
  800275:	6a 20                	push   $0x20
  800277:	ff d6                	call   *%esi
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	eb ec                	jmp    80026a <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 18             	pushl  0x18(%ebp)
  800284:	83 eb 01             	sub    $0x1,%ebx
  800287:	53                   	push   %ebx
  800288:	50                   	push   %eax
  800289:	83 ec 08             	sub    $0x8,%esp
  80028c:	ff 75 dc             	pushl  -0x24(%ebp)
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	ff 75 e4             	pushl  -0x1c(%ebp)
  800295:	ff 75 e0             	pushl  -0x20(%ebp)
  800298:	e8 63 20 00 00       	call   802300 <__udivdi3>
  80029d:	83 c4 18             	add    $0x18,%esp
  8002a0:	52                   	push   %edx
  8002a1:	50                   	push   %eax
  8002a2:	89 fa                	mov    %edi,%edx
  8002a4:	89 f0                	mov    %esi,%eax
  8002a6:	e8 54 ff ff ff       	call   8001ff <printnum>
  8002ab:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002ae:	83 ec 08             	sub    $0x8,%esp
  8002b1:	57                   	push   %edi
  8002b2:	83 ec 04             	sub    $0x4,%esp
  8002b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b8:	ff 75 d8             	pushl  -0x28(%ebp)
  8002bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002be:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c1:	e8 4a 21 00 00       	call   802410 <__umoddi3>
  8002c6:	83 c4 14             	add    $0x14,%esp
  8002c9:	0f be 80 ef 25 80 00 	movsbl 0x8025ef(%eax),%eax
  8002d0:	50                   	push   %eax
  8002d1:	ff d6                	call   *%esi
  8002d3:	83 c4 10             	add    $0x10,%esp
	}
}
  8002d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d9:	5b                   	pop    %ebx
  8002da:	5e                   	pop    %esi
  8002db:	5f                   	pop    %edi
  8002dc:	5d                   	pop    %ebp
  8002dd:	c3                   	ret    

008002de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e8:	8b 10                	mov    (%eax),%edx
  8002ea:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ed:	73 0a                	jae    8002f9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ef:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f2:	89 08                	mov    %ecx,(%eax)
  8002f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f7:	88 02                	mov    %al,(%edx)
}
  8002f9:	5d                   	pop    %ebp
  8002fa:	c3                   	ret    

008002fb <printfmt>:
{
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800301:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800304:	50                   	push   %eax
  800305:	ff 75 10             	pushl  0x10(%ebp)
  800308:	ff 75 0c             	pushl  0xc(%ebp)
  80030b:	ff 75 08             	pushl  0x8(%ebp)
  80030e:	e8 05 00 00 00       	call   800318 <vprintfmt>
}
  800313:	83 c4 10             	add    $0x10,%esp
  800316:	c9                   	leave  
  800317:	c3                   	ret    

00800318 <vprintfmt>:
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	57                   	push   %edi
  80031c:	56                   	push   %esi
  80031d:	53                   	push   %ebx
  80031e:	83 ec 3c             	sub    $0x3c,%esp
  800321:	8b 75 08             	mov    0x8(%ebp),%esi
  800324:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800327:	8b 7d 10             	mov    0x10(%ebp),%edi
  80032a:	e9 32 04 00 00       	jmp    800761 <vprintfmt+0x449>
		padc = ' ';
  80032f:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800333:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80033a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800341:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800348:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80034f:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800356:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035b:	8d 47 01             	lea    0x1(%edi),%eax
  80035e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800361:	0f b6 17             	movzbl (%edi),%edx
  800364:	8d 42 dd             	lea    -0x23(%edx),%eax
  800367:	3c 55                	cmp    $0x55,%al
  800369:	0f 87 12 05 00 00    	ja     800881 <vprintfmt+0x569>
  80036f:	0f b6 c0             	movzbl %al,%eax
  800372:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
  800379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80037c:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800380:	eb d9                	jmp    80035b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800382:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800385:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800389:	eb d0                	jmp    80035b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80038b:	0f b6 d2             	movzbl %dl,%edx
  80038e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800391:	b8 00 00 00 00       	mov    $0x0,%eax
  800396:	89 75 08             	mov    %esi,0x8(%ebp)
  800399:	eb 03                	jmp    80039e <vprintfmt+0x86>
  80039b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80039e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a8:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003ab:	83 fe 09             	cmp    $0x9,%esi
  8003ae:	76 eb                	jbe    80039b <vprintfmt+0x83>
  8003b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8003b6:	eb 14                	jmp    8003cc <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bb:	8b 00                	mov    (%eax),%eax
  8003bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c3:	8d 40 04             	lea    0x4(%eax),%eax
  8003c6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d0:	79 89                	jns    80035b <vprintfmt+0x43>
				width = precision, precision = -1;
  8003d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003df:	e9 77 ff ff ff       	jmp    80035b <vprintfmt+0x43>
  8003e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e7:	85 c0                	test   %eax,%eax
  8003e9:	0f 48 c1             	cmovs  %ecx,%eax
  8003ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f2:	e9 64 ff ff ff       	jmp    80035b <vprintfmt+0x43>
  8003f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003fa:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800401:	e9 55 ff ff ff       	jmp    80035b <vprintfmt+0x43>
			lflag++;
  800406:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80040a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80040d:	e9 49 ff ff ff       	jmp    80035b <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800412:	8b 45 14             	mov    0x14(%ebp),%eax
  800415:	8d 78 04             	lea    0x4(%eax),%edi
  800418:	83 ec 08             	sub    $0x8,%esp
  80041b:	53                   	push   %ebx
  80041c:	ff 30                	pushl  (%eax)
  80041e:	ff d6                	call   *%esi
			break;
  800420:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800423:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800426:	e9 33 03 00 00       	jmp    80075e <vprintfmt+0x446>
			err = va_arg(ap, int);
  80042b:	8b 45 14             	mov    0x14(%ebp),%eax
  80042e:	8d 78 04             	lea    0x4(%eax),%edi
  800431:	8b 00                	mov    (%eax),%eax
  800433:	99                   	cltd   
  800434:	31 d0                	xor    %edx,%eax
  800436:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800438:	83 f8 10             	cmp    $0x10,%eax
  80043b:	7f 23                	jg     800460 <vprintfmt+0x148>
  80043d:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  800444:	85 d2                	test   %edx,%edx
  800446:	74 18                	je     800460 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800448:	52                   	push   %edx
  800449:	68 39 2a 80 00       	push   $0x802a39
  80044e:	53                   	push   %ebx
  80044f:	56                   	push   %esi
  800450:	e8 a6 fe ff ff       	call   8002fb <printfmt>
  800455:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800458:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045b:	e9 fe 02 00 00       	jmp    80075e <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800460:	50                   	push   %eax
  800461:	68 07 26 80 00       	push   $0x802607
  800466:	53                   	push   %ebx
  800467:	56                   	push   %esi
  800468:	e8 8e fe ff ff       	call   8002fb <printfmt>
  80046d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800470:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800473:	e9 e6 02 00 00       	jmp    80075e <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800478:	8b 45 14             	mov    0x14(%ebp),%eax
  80047b:	83 c0 04             	add    $0x4,%eax
  80047e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800481:	8b 45 14             	mov    0x14(%ebp),%eax
  800484:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800486:	85 c9                	test   %ecx,%ecx
  800488:	b8 00 26 80 00       	mov    $0x802600,%eax
  80048d:	0f 45 c1             	cmovne %ecx,%eax
  800490:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800493:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800497:	7e 06                	jle    80049f <vprintfmt+0x187>
  800499:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80049d:	75 0d                	jne    8004ac <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80049f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a2:	89 c7                	mov    %eax,%edi
  8004a4:	03 45 e0             	add    -0x20(%ebp),%eax
  8004a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004aa:	eb 53                	jmp    8004ff <vprintfmt+0x1e7>
  8004ac:	83 ec 08             	sub    $0x8,%esp
  8004af:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b2:	50                   	push   %eax
  8004b3:	e8 71 04 00 00       	call   800929 <strnlen>
  8004b8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004bb:	29 c1                	sub    %eax,%ecx
  8004bd:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004c0:	83 c4 10             	add    $0x10,%esp
  8004c3:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004c5:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cc:	eb 0f                	jmp    8004dd <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	53                   	push   %ebx
  8004d2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d7:	83 ef 01             	sub    $0x1,%edi
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	85 ff                	test   %edi,%edi
  8004df:	7f ed                	jg     8004ce <vprintfmt+0x1b6>
  8004e1:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004e4:	85 c9                	test   %ecx,%ecx
  8004e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004eb:	0f 49 c1             	cmovns %ecx,%eax
  8004ee:	29 c1                	sub    %eax,%ecx
  8004f0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004f3:	eb aa                	jmp    80049f <vprintfmt+0x187>
					putch(ch, putdat);
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	53                   	push   %ebx
  8004f9:	52                   	push   %edx
  8004fa:	ff d6                	call   *%esi
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800502:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800504:	83 c7 01             	add    $0x1,%edi
  800507:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80050b:	0f be d0             	movsbl %al,%edx
  80050e:	85 d2                	test   %edx,%edx
  800510:	74 4b                	je     80055d <vprintfmt+0x245>
  800512:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800516:	78 06                	js     80051e <vprintfmt+0x206>
  800518:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80051c:	78 1e                	js     80053c <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80051e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800522:	74 d1                	je     8004f5 <vprintfmt+0x1dd>
  800524:	0f be c0             	movsbl %al,%eax
  800527:	83 e8 20             	sub    $0x20,%eax
  80052a:	83 f8 5e             	cmp    $0x5e,%eax
  80052d:	76 c6                	jbe    8004f5 <vprintfmt+0x1dd>
					putch('?', putdat);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	53                   	push   %ebx
  800533:	6a 3f                	push   $0x3f
  800535:	ff d6                	call   *%esi
  800537:	83 c4 10             	add    $0x10,%esp
  80053a:	eb c3                	jmp    8004ff <vprintfmt+0x1e7>
  80053c:	89 cf                	mov    %ecx,%edi
  80053e:	eb 0e                	jmp    80054e <vprintfmt+0x236>
				putch(' ', putdat);
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	53                   	push   %ebx
  800544:	6a 20                	push   $0x20
  800546:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800548:	83 ef 01             	sub    $0x1,%edi
  80054b:	83 c4 10             	add    $0x10,%esp
  80054e:	85 ff                	test   %edi,%edi
  800550:	7f ee                	jg     800540 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800552:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800555:	89 45 14             	mov    %eax,0x14(%ebp)
  800558:	e9 01 02 00 00       	jmp    80075e <vprintfmt+0x446>
  80055d:	89 cf                	mov    %ecx,%edi
  80055f:	eb ed                	jmp    80054e <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800561:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800564:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80056b:	e9 eb fd ff ff       	jmp    80035b <vprintfmt+0x43>
	if (lflag >= 2)
  800570:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800574:	7f 21                	jg     800597 <vprintfmt+0x27f>
	else if (lflag)
  800576:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80057a:	74 68                	je     8005e4 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800584:	89 c1                	mov    %eax,%ecx
  800586:	c1 f9 1f             	sar    $0x1f,%ecx
  800589:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8d 40 04             	lea    0x4(%eax),%eax
  800592:	89 45 14             	mov    %eax,0x14(%ebp)
  800595:	eb 17                	jmp    8005ae <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	8b 50 04             	mov    0x4(%eax),%edx
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8d 40 08             	lea    0x8(%eax),%eax
  8005ab:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005ae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005ba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005be:	78 3f                	js     8005ff <vprintfmt+0x2e7>
			base = 10;
  8005c0:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005c5:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005c9:	0f 84 71 01 00 00    	je     800740 <vprintfmt+0x428>
				putch('+', putdat);
  8005cf:	83 ec 08             	sub    $0x8,%esp
  8005d2:	53                   	push   %ebx
  8005d3:	6a 2b                	push   $0x2b
  8005d5:	ff d6                	call   *%esi
  8005d7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005da:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005df:	e9 5c 01 00 00       	jmp    800740 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8b 00                	mov    (%eax),%eax
  8005e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ec:	89 c1                	mov    %eax,%ecx
  8005ee:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8d 40 04             	lea    0x4(%eax),%eax
  8005fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fd:	eb af                	jmp    8005ae <vprintfmt+0x296>
				putch('-', putdat);
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	53                   	push   %ebx
  800603:	6a 2d                	push   $0x2d
  800605:	ff d6                	call   *%esi
				num = -(long long) num;
  800607:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80060a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80060d:	f7 d8                	neg    %eax
  80060f:	83 d2 00             	adc    $0x0,%edx
  800612:	f7 da                	neg    %edx
  800614:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800617:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80061d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800622:	e9 19 01 00 00       	jmp    800740 <vprintfmt+0x428>
	if (lflag >= 2)
  800627:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80062b:	7f 29                	jg     800656 <vprintfmt+0x33e>
	else if (lflag)
  80062d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800631:	74 44                	je     800677 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8b 00                	mov    (%eax),%eax
  800638:	ba 00 00 00 00       	mov    $0x0,%edx
  80063d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800640:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8d 40 04             	lea    0x4(%eax),%eax
  800649:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800651:	e9 ea 00 00 00       	jmp    800740 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8b 50 04             	mov    0x4(%eax),%edx
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800661:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8d 40 08             	lea    0x8(%eax),%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800672:	e9 c9 00 00 00       	jmp    800740 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	ba 00 00 00 00       	mov    $0x0,%edx
  800681:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800684:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8d 40 04             	lea    0x4(%eax),%eax
  80068d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800690:	b8 0a 00 00 00       	mov    $0xa,%eax
  800695:	e9 a6 00 00 00       	jmp    800740 <vprintfmt+0x428>
			putch('0', putdat);
  80069a:	83 ec 08             	sub    $0x8,%esp
  80069d:	53                   	push   %ebx
  80069e:	6a 30                	push   $0x30
  8006a0:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006a2:	83 c4 10             	add    $0x10,%esp
  8006a5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006a9:	7f 26                	jg     8006d1 <vprintfmt+0x3b9>
	else if (lflag)
  8006ab:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006af:	74 3e                	je     8006ef <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8d 40 04             	lea    0x4(%eax),%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8006cf:	eb 6f                	jmp    800740 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 50 04             	mov    0x4(%eax),%edx
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8d 40 08             	lea    0x8(%eax),%eax
  8006e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e8:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ed:	eb 51                	jmp    800740 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8d 40 04             	lea    0x4(%eax),%eax
  800705:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800708:	b8 08 00 00 00       	mov    $0x8,%eax
  80070d:	eb 31                	jmp    800740 <vprintfmt+0x428>
			putch('0', putdat);
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	53                   	push   %ebx
  800713:	6a 30                	push   $0x30
  800715:	ff d6                	call   *%esi
			putch('x', putdat);
  800717:	83 c4 08             	add    $0x8,%esp
  80071a:	53                   	push   %ebx
  80071b:	6a 78                	push   $0x78
  80071d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	ba 00 00 00 00       	mov    $0x0,%edx
  800729:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80072f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8d 40 04             	lea    0x4(%eax),%eax
  800738:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800747:	52                   	push   %edx
  800748:	ff 75 e0             	pushl  -0x20(%ebp)
  80074b:	50                   	push   %eax
  80074c:	ff 75 dc             	pushl  -0x24(%ebp)
  80074f:	ff 75 d8             	pushl  -0x28(%ebp)
  800752:	89 da                	mov    %ebx,%edx
  800754:	89 f0                	mov    %esi,%eax
  800756:	e8 a4 fa ff ff       	call   8001ff <printnum>
			break;
  80075b:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80075e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800761:	83 c7 01             	add    $0x1,%edi
  800764:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800768:	83 f8 25             	cmp    $0x25,%eax
  80076b:	0f 84 be fb ff ff    	je     80032f <vprintfmt+0x17>
			if (ch == '\0')
  800771:	85 c0                	test   %eax,%eax
  800773:	0f 84 28 01 00 00    	je     8008a1 <vprintfmt+0x589>
			putch(ch, putdat);
  800779:	83 ec 08             	sub    $0x8,%esp
  80077c:	53                   	push   %ebx
  80077d:	50                   	push   %eax
  80077e:	ff d6                	call   *%esi
  800780:	83 c4 10             	add    $0x10,%esp
  800783:	eb dc                	jmp    800761 <vprintfmt+0x449>
	if (lflag >= 2)
  800785:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800789:	7f 26                	jg     8007b1 <vprintfmt+0x499>
	else if (lflag)
  80078b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80078f:	74 41                	je     8007d2 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	8b 00                	mov    (%eax),%eax
  800796:	ba 00 00 00 00       	mov    $0x0,%edx
  80079b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a4:	8d 40 04             	lea    0x4(%eax),%eax
  8007a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007aa:	b8 10 00 00 00       	mov    $0x10,%eax
  8007af:	eb 8f                	jmp    800740 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	8b 50 04             	mov    0x4(%eax),%edx
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 40 08             	lea    0x8(%eax),%eax
  8007c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c8:	b8 10 00 00 00       	mov    $0x10,%eax
  8007cd:	e9 6e ff ff ff       	jmp    800740 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	8d 40 04             	lea    0x4(%eax),%eax
  8007e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007eb:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f0:	e9 4b ff ff ff       	jmp    800740 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	83 c0 04             	add    $0x4,%eax
  8007fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	8b 00                	mov    (%eax),%eax
  800803:	85 c0                	test   %eax,%eax
  800805:	74 14                	je     80081b <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800807:	8b 13                	mov    (%ebx),%edx
  800809:	83 fa 7f             	cmp    $0x7f,%edx
  80080c:	7f 37                	jg     800845 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80080e:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800810:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
  800816:	e9 43 ff ff ff       	jmp    80075e <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80081b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800820:	bf 25 27 80 00       	mov    $0x802725,%edi
							putch(ch, putdat);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	53                   	push   %ebx
  800829:	50                   	push   %eax
  80082a:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80082c:	83 c7 01             	add    $0x1,%edi
  80082f:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800833:	83 c4 10             	add    $0x10,%esp
  800836:	85 c0                	test   %eax,%eax
  800838:	75 eb                	jne    800825 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80083a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80083d:	89 45 14             	mov    %eax,0x14(%ebp)
  800840:	e9 19 ff ff ff       	jmp    80075e <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800845:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800847:	b8 0a 00 00 00       	mov    $0xa,%eax
  80084c:	bf 5d 27 80 00       	mov    $0x80275d,%edi
							putch(ch, putdat);
  800851:	83 ec 08             	sub    $0x8,%esp
  800854:	53                   	push   %ebx
  800855:	50                   	push   %eax
  800856:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800858:	83 c7 01             	add    $0x1,%edi
  80085b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	85 c0                	test   %eax,%eax
  800864:	75 eb                	jne    800851 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800866:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800869:	89 45 14             	mov    %eax,0x14(%ebp)
  80086c:	e9 ed fe ff ff       	jmp    80075e <vprintfmt+0x446>
			putch(ch, putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	53                   	push   %ebx
  800875:	6a 25                	push   $0x25
  800877:	ff d6                	call   *%esi
			break;
  800879:	83 c4 10             	add    $0x10,%esp
  80087c:	e9 dd fe ff ff       	jmp    80075e <vprintfmt+0x446>
			putch('%', putdat);
  800881:	83 ec 08             	sub    $0x8,%esp
  800884:	53                   	push   %ebx
  800885:	6a 25                	push   $0x25
  800887:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800889:	83 c4 10             	add    $0x10,%esp
  80088c:	89 f8                	mov    %edi,%eax
  80088e:	eb 03                	jmp    800893 <vprintfmt+0x57b>
  800890:	83 e8 01             	sub    $0x1,%eax
  800893:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800897:	75 f7                	jne    800890 <vprintfmt+0x578>
  800899:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089c:	e9 bd fe ff ff       	jmp    80075e <vprintfmt+0x446>
}
  8008a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008a4:	5b                   	pop    %ebx
  8008a5:	5e                   	pop    %esi
  8008a6:	5f                   	pop    %edi
  8008a7:	5d                   	pop    %ebp
  8008a8:	c3                   	ret    

008008a9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	83 ec 18             	sub    $0x18,%esp
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008b8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008bc:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008c6:	85 c0                	test   %eax,%eax
  8008c8:	74 26                	je     8008f0 <vsnprintf+0x47>
  8008ca:	85 d2                	test   %edx,%edx
  8008cc:	7e 22                	jle    8008f0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ce:	ff 75 14             	pushl  0x14(%ebp)
  8008d1:	ff 75 10             	pushl  0x10(%ebp)
  8008d4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d7:	50                   	push   %eax
  8008d8:	68 de 02 80 00       	push   $0x8002de
  8008dd:	e8 36 fa ff ff       	call   800318 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008eb:	83 c4 10             	add    $0x10,%esp
}
  8008ee:	c9                   	leave  
  8008ef:	c3                   	ret    
		return -E_INVAL;
  8008f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f5:	eb f7                	jmp    8008ee <vsnprintf+0x45>

008008f7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008fd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800900:	50                   	push   %eax
  800901:	ff 75 10             	pushl  0x10(%ebp)
  800904:	ff 75 0c             	pushl  0xc(%ebp)
  800907:	ff 75 08             	pushl  0x8(%ebp)
  80090a:	e8 9a ff ff ff       	call   8008a9 <vsnprintf>
	va_end(ap);

	return rc;
}
  80090f:	c9                   	leave  
  800910:	c3                   	ret    

00800911 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800917:	b8 00 00 00 00       	mov    $0x0,%eax
  80091c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800920:	74 05                	je     800927 <strlen+0x16>
		n++;
  800922:	83 c0 01             	add    $0x1,%eax
  800925:	eb f5                	jmp    80091c <strlen+0xb>
	return n;
}
  800927:	5d                   	pop    %ebp
  800928:	c3                   	ret    

00800929 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092f:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800932:	ba 00 00 00 00       	mov    $0x0,%edx
  800937:	39 c2                	cmp    %eax,%edx
  800939:	74 0d                	je     800948 <strnlen+0x1f>
  80093b:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80093f:	74 05                	je     800946 <strnlen+0x1d>
		n++;
  800941:	83 c2 01             	add    $0x1,%edx
  800944:	eb f1                	jmp    800937 <strnlen+0xe>
  800946:	89 d0                	mov    %edx,%eax
	return n;
}
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800954:	ba 00 00 00 00       	mov    $0x0,%edx
  800959:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80095d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800960:	83 c2 01             	add    $0x1,%edx
  800963:	84 c9                	test   %cl,%cl
  800965:	75 f2                	jne    800959 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800967:	5b                   	pop    %ebx
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	53                   	push   %ebx
  80096e:	83 ec 10             	sub    $0x10,%esp
  800971:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800974:	53                   	push   %ebx
  800975:	e8 97 ff ff ff       	call   800911 <strlen>
  80097a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80097d:	ff 75 0c             	pushl  0xc(%ebp)
  800980:	01 d8                	add    %ebx,%eax
  800982:	50                   	push   %eax
  800983:	e8 c2 ff ff ff       	call   80094a <strcpy>
	return dst;
}
  800988:	89 d8                	mov    %ebx,%eax
  80098a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80098d:	c9                   	leave  
  80098e:	c3                   	ret    

0080098f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	56                   	push   %esi
  800993:	53                   	push   %ebx
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80099a:	89 c6                	mov    %eax,%esi
  80099c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80099f:	89 c2                	mov    %eax,%edx
  8009a1:	39 f2                	cmp    %esi,%edx
  8009a3:	74 11                	je     8009b6 <strncpy+0x27>
		*dst++ = *src;
  8009a5:	83 c2 01             	add    $0x1,%edx
  8009a8:	0f b6 19             	movzbl (%ecx),%ebx
  8009ab:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009ae:	80 fb 01             	cmp    $0x1,%bl
  8009b1:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009b4:	eb eb                	jmp    8009a1 <strncpy+0x12>
	}
	return ret;
}
  8009b6:	5b                   	pop    %ebx
  8009b7:	5e                   	pop    %esi
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    

008009ba <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	56                   	push   %esi
  8009be:	53                   	push   %ebx
  8009bf:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c5:	8b 55 10             	mov    0x10(%ebp),%edx
  8009c8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009ca:	85 d2                	test   %edx,%edx
  8009cc:	74 21                	je     8009ef <strlcpy+0x35>
  8009ce:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d2:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009d4:	39 c2                	cmp    %eax,%edx
  8009d6:	74 14                	je     8009ec <strlcpy+0x32>
  8009d8:	0f b6 19             	movzbl (%ecx),%ebx
  8009db:	84 db                	test   %bl,%bl
  8009dd:	74 0b                	je     8009ea <strlcpy+0x30>
			*dst++ = *src++;
  8009df:	83 c1 01             	add    $0x1,%ecx
  8009e2:	83 c2 01             	add    $0x1,%edx
  8009e5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009e8:	eb ea                	jmp    8009d4 <strlcpy+0x1a>
  8009ea:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ec:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ef:	29 f0                	sub    %esi,%eax
}
  8009f1:	5b                   	pop    %ebx
  8009f2:	5e                   	pop    %esi
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009fe:	0f b6 01             	movzbl (%ecx),%eax
  800a01:	84 c0                	test   %al,%al
  800a03:	74 0c                	je     800a11 <strcmp+0x1c>
  800a05:	3a 02                	cmp    (%edx),%al
  800a07:	75 08                	jne    800a11 <strcmp+0x1c>
		p++, q++;
  800a09:	83 c1 01             	add    $0x1,%ecx
  800a0c:	83 c2 01             	add    $0x1,%edx
  800a0f:	eb ed                	jmp    8009fe <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a11:	0f b6 c0             	movzbl %al,%eax
  800a14:	0f b6 12             	movzbl (%edx),%edx
  800a17:	29 d0                	sub    %edx,%eax
}
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	53                   	push   %ebx
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a25:	89 c3                	mov    %eax,%ebx
  800a27:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a2a:	eb 06                	jmp    800a32 <strncmp+0x17>
		n--, p++, q++;
  800a2c:	83 c0 01             	add    $0x1,%eax
  800a2f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a32:	39 d8                	cmp    %ebx,%eax
  800a34:	74 16                	je     800a4c <strncmp+0x31>
  800a36:	0f b6 08             	movzbl (%eax),%ecx
  800a39:	84 c9                	test   %cl,%cl
  800a3b:	74 04                	je     800a41 <strncmp+0x26>
  800a3d:	3a 0a                	cmp    (%edx),%cl
  800a3f:	74 eb                	je     800a2c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a41:	0f b6 00             	movzbl (%eax),%eax
  800a44:	0f b6 12             	movzbl (%edx),%edx
  800a47:	29 d0                	sub    %edx,%eax
}
  800a49:	5b                   	pop    %ebx
  800a4a:	5d                   	pop    %ebp
  800a4b:	c3                   	ret    
		return 0;
  800a4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a51:	eb f6                	jmp    800a49 <strncmp+0x2e>

00800a53 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5d:	0f b6 10             	movzbl (%eax),%edx
  800a60:	84 d2                	test   %dl,%dl
  800a62:	74 09                	je     800a6d <strchr+0x1a>
		if (*s == c)
  800a64:	38 ca                	cmp    %cl,%dl
  800a66:	74 0a                	je     800a72 <strchr+0x1f>
	for (; *s; s++)
  800a68:	83 c0 01             	add    $0x1,%eax
  800a6b:	eb f0                	jmp    800a5d <strchr+0xa>
			return (char *) s;
	return 0;
  800a6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a72:	5d                   	pop    %ebp
  800a73:	c3                   	ret    

00800a74 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a81:	38 ca                	cmp    %cl,%dl
  800a83:	74 09                	je     800a8e <strfind+0x1a>
  800a85:	84 d2                	test   %dl,%dl
  800a87:	74 05                	je     800a8e <strfind+0x1a>
	for (; *s; s++)
  800a89:	83 c0 01             	add    $0x1,%eax
  800a8c:	eb f0                	jmp    800a7e <strfind+0xa>
			break;
	return (char *) s;
}
  800a8e:	5d                   	pop    %ebp
  800a8f:	c3                   	ret    

00800a90 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	57                   	push   %edi
  800a94:	56                   	push   %esi
  800a95:	53                   	push   %ebx
  800a96:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a99:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a9c:	85 c9                	test   %ecx,%ecx
  800a9e:	74 31                	je     800ad1 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa0:	89 f8                	mov    %edi,%eax
  800aa2:	09 c8                	or     %ecx,%eax
  800aa4:	a8 03                	test   $0x3,%al
  800aa6:	75 23                	jne    800acb <memset+0x3b>
		c &= 0xFF;
  800aa8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aac:	89 d3                	mov    %edx,%ebx
  800aae:	c1 e3 08             	shl    $0x8,%ebx
  800ab1:	89 d0                	mov    %edx,%eax
  800ab3:	c1 e0 18             	shl    $0x18,%eax
  800ab6:	89 d6                	mov    %edx,%esi
  800ab8:	c1 e6 10             	shl    $0x10,%esi
  800abb:	09 f0                	or     %esi,%eax
  800abd:	09 c2                	or     %eax,%edx
  800abf:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ac4:	89 d0                	mov    %edx,%eax
  800ac6:	fc                   	cld    
  800ac7:	f3 ab                	rep stos %eax,%es:(%edi)
  800ac9:	eb 06                	jmp    800ad1 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ace:	fc                   	cld    
  800acf:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ad1:	89 f8                	mov    %edi,%eax
  800ad3:	5b                   	pop    %ebx
  800ad4:	5e                   	pop    %esi
  800ad5:	5f                   	pop    %edi
  800ad6:	5d                   	pop    %ebp
  800ad7:	c3                   	ret    

00800ad8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	57                   	push   %edi
  800adc:	56                   	push   %esi
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ae6:	39 c6                	cmp    %eax,%esi
  800ae8:	73 32                	jae    800b1c <memmove+0x44>
  800aea:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aed:	39 c2                	cmp    %eax,%edx
  800aef:	76 2b                	jbe    800b1c <memmove+0x44>
		s += n;
		d += n;
  800af1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af4:	89 fe                	mov    %edi,%esi
  800af6:	09 ce                	or     %ecx,%esi
  800af8:	09 d6                	or     %edx,%esi
  800afa:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b00:	75 0e                	jne    800b10 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b02:	83 ef 04             	sub    $0x4,%edi
  800b05:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b08:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b0b:	fd                   	std    
  800b0c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b0e:	eb 09                	jmp    800b19 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b10:	83 ef 01             	sub    $0x1,%edi
  800b13:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b16:	fd                   	std    
  800b17:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b19:	fc                   	cld    
  800b1a:	eb 1a                	jmp    800b36 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1c:	89 c2                	mov    %eax,%edx
  800b1e:	09 ca                	or     %ecx,%edx
  800b20:	09 f2                	or     %esi,%edx
  800b22:	f6 c2 03             	test   $0x3,%dl
  800b25:	75 0a                	jne    800b31 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b27:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b2a:	89 c7                	mov    %eax,%edi
  800b2c:	fc                   	cld    
  800b2d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b2f:	eb 05                	jmp    800b36 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b31:	89 c7                	mov    %eax,%edi
  800b33:	fc                   	cld    
  800b34:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b36:	5e                   	pop    %esi
  800b37:	5f                   	pop    %edi
  800b38:	5d                   	pop    %ebp
  800b39:	c3                   	ret    

00800b3a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b40:	ff 75 10             	pushl  0x10(%ebp)
  800b43:	ff 75 0c             	pushl  0xc(%ebp)
  800b46:	ff 75 08             	pushl  0x8(%ebp)
  800b49:	e8 8a ff ff ff       	call   800ad8 <memmove>
}
  800b4e:	c9                   	leave  
  800b4f:	c3                   	ret    

00800b50 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5b:	89 c6                	mov    %eax,%esi
  800b5d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b60:	39 f0                	cmp    %esi,%eax
  800b62:	74 1c                	je     800b80 <memcmp+0x30>
		if (*s1 != *s2)
  800b64:	0f b6 08             	movzbl (%eax),%ecx
  800b67:	0f b6 1a             	movzbl (%edx),%ebx
  800b6a:	38 d9                	cmp    %bl,%cl
  800b6c:	75 08                	jne    800b76 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b6e:	83 c0 01             	add    $0x1,%eax
  800b71:	83 c2 01             	add    $0x1,%edx
  800b74:	eb ea                	jmp    800b60 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b76:	0f b6 c1             	movzbl %cl,%eax
  800b79:	0f b6 db             	movzbl %bl,%ebx
  800b7c:	29 d8                	sub    %ebx,%eax
  800b7e:	eb 05                	jmp    800b85 <memcmp+0x35>
	}

	return 0;
  800b80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b85:	5b                   	pop    %ebx
  800b86:	5e                   	pop    %esi
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    

00800b89 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b92:	89 c2                	mov    %eax,%edx
  800b94:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b97:	39 d0                	cmp    %edx,%eax
  800b99:	73 09                	jae    800ba4 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b9b:	38 08                	cmp    %cl,(%eax)
  800b9d:	74 05                	je     800ba4 <memfind+0x1b>
	for (; s < ends; s++)
  800b9f:	83 c0 01             	add    $0x1,%eax
  800ba2:	eb f3                	jmp    800b97 <memfind+0xe>
			break;
	return (void *) s;
}
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	57                   	push   %edi
  800baa:	56                   	push   %esi
  800bab:	53                   	push   %ebx
  800bac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800baf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bb2:	eb 03                	jmp    800bb7 <strtol+0x11>
		s++;
  800bb4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bb7:	0f b6 01             	movzbl (%ecx),%eax
  800bba:	3c 20                	cmp    $0x20,%al
  800bbc:	74 f6                	je     800bb4 <strtol+0xe>
  800bbe:	3c 09                	cmp    $0x9,%al
  800bc0:	74 f2                	je     800bb4 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bc2:	3c 2b                	cmp    $0x2b,%al
  800bc4:	74 2a                	je     800bf0 <strtol+0x4a>
	int neg = 0;
  800bc6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bcb:	3c 2d                	cmp    $0x2d,%al
  800bcd:	74 2b                	je     800bfa <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bcf:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bd5:	75 0f                	jne    800be6 <strtol+0x40>
  800bd7:	80 39 30             	cmpb   $0x30,(%ecx)
  800bda:	74 28                	je     800c04 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bdc:	85 db                	test   %ebx,%ebx
  800bde:	b8 0a 00 00 00       	mov    $0xa,%eax
  800be3:	0f 44 d8             	cmove  %eax,%ebx
  800be6:	b8 00 00 00 00       	mov    $0x0,%eax
  800beb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bee:	eb 50                	jmp    800c40 <strtol+0x9a>
		s++;
  800bf0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bf3:	bf 00 00 00 00       	mov    $0x0,%edi
  800bf8:	eb d5                	jmp    800bcf <strtol+0x29>
		s++, neg = 1;
  800bfa:	83 c1 01             	add    $0x1,%ecx
  800bfd:	bf 01 00 00 00       	mov    $0x1,%edi
  800c02:	eb cb                	jmp    800bcf <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c04:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c08:	74 0e                	je     800c18 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c0a:	85 db                	test   %ebx,%ebx
  800c0c:	75 d8                	jne    800be6 <strtol+0x40>
		s++, base = 8;
  800c0e:	83 c1 01             	add    $0x1,%ecx
  800c11:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c16:	eb ce                	jmp    800be6 <strtol+0x40>
		s += 2, base = 16;
  800c18:	83 c1 02             	add    $0x2,%ecx
  800c1b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c20:	eb c4                	jmp    800be6 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c22:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c25:	89 f3                	mov    %esi,%ebx
  800c27:	80 fb 19             	cmp    $0x19,%bl
  800c2a:	77 29                	ja     800c55 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c2c:	0f be d2             	movsbl %dl,%edx
  800c2f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c32:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c35:	7d 30                	jge    800c67 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c37:	83 c1 01             	add    $0x1,%ecx
  800c3a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c3e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c40:	0f b6 11             	movzbl (%ecx),%edx
  800c43:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c46:	89 f3                	mov    %esi,%ebx
  800c48:	80 fb 09             	cmp    $0x9,%bl
  800c4b:	77 d5                	ja     800c22 <strtol+0x7c>
			dig = *s - '0';
  800c4d:	0f be d2             	movsbl %dl,%edx
  800c50:	83 ea 30             	sub    $0x30,%edx
  800c53:	eb dd                	jmp    800c32 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c55:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c58:	89 f3                	mov    %esi,%ebx
  800c5a:	80 fb 19             	cmp    $0x19,%bl
  800c5d:	77 08                	ja     800c67 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c5f:	0f be d2             	movsbl %dl,%edx
  800c62:	83 ea 37             	sub    $0x37,%edx
  800c65:	eb cb                	jmp    800c32 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6b:	74 05                	je     800c72 <strtol+0xcc>
		*endptr = (char *) s;
  800c6d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c70:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c72:	89 c2                	mov    %eax,%edx
  800c74:	f7 da                	neg    %edx
  800c76:	85 ff                	test   %edi,%edi
  800c78:	0f 45 c2             	cmovne %edx,%eax
}
  800c7b:	5b                   	pop    %ebx
  800c7c:	5e                   	pop    %esi
  800c7d:	5f                   	pop    %edi
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    

00800c80 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	57                   	push   %edi
  800c84:	56                   	push   %esi
  800c85:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c86:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c91:	89 c3                	mov    %eax,%ebx
  800c93:	89 c7                	mov    %eax,%edi
  800c95:	89 c6                	mov    %eax,%esi
  800c97:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c99:	5b                   	pop    %ebx
  800c9a:	5e                   	pop    %esi
  800c9b:	5f                   	pop    %edi
  800c9c:	5d                   	pop    %ebp
  800c9d:	c3                   	ret    

00800c9e <sys_cgetc>:

int
sys_cgetc(void)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	57                   	push   %edi
  800ca2:	56                   	push   %esi
  800ca3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca9:	b8 01 00 00 00       	mov    $0x1,%eax
  800cae:	89 d1                	mov    %edx,%ecx
  800cb0:	89 d3                	mov    %edx,%ebx
  800cb2:	89 d7                	mov    %edx,%edi
  800cb4:	89 d6                	mov    %edx,%esi
  800cb6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cb8:	5b                   	pop    %ebx
  800cb9:	5e                   	pop    %esi
  800cba:	5f                   	pop    %edi
  800cbb:	5d                   	pop    %ebp
  800cbc:	c3                   	ret    

00800cbd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	57                   	push   %edi
  800cc1:	56                   	push   %esi
  800cc2:	53                   	push   %ebx
  800cc3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ccb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cce:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd3:	89 cb                	mov    %ecx,%ebx
  800cd5:	89 cf                	mov    %ecx,%edi
  800cd7:	89 ce                	mov    %ecx,%esi
  800cd9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cdb:	85 c0                	test   %eax,%eax
  800cdd:	7f 08                	jg     800ce7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce2:	5b                   	pop    %ebx
  800ce3:	5e                   	pop    %esi
  800ce4:	5f                   	pop    %edi
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce7:	83 ec 0c             	sub    $0xc,%esp
  800cea:	50                   	push   %eax
  800ceb:	6a 03                	push   $0x3
  800ced:	68 64 29 80 00       	push   $0x802964
  800cf2:	6a 43                	push   $0x43
  800cf4:	68 81 29 80 00       	push   $0x802981
  800cf9:	e8 69 14 00 00       	call   802167 <_panic>

00800cfe <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	57                   	push   %edi
  800d02:	56                   	push   %esi
  800d03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d04:	ba 00 00 00 00       	mov    $0x0,%edx
  800d09:	b8 02 00 00 00       	mov    $0x2,%eax
  800d0e:	89 d1                	mov    %edx,%ecx
  800d10:	89 d3                	mov    %edx,%ebx
  800d12:	89 d7                	mov    %edx,%edi
  800d14:	89 d6                	mov    %edx,%esi
  800d16:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d18:	5b                   	pop    %ebx
  800d19:	5e                   	pop    %esi
  800d1a:	5f                   	pop    %edi
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    

00800d1d <sys_yield>:

void
sys_yield(void)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	57                   	push   %edi
  800d21:	56                   	push   %esi
  800d22:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d23:	ba 00 00 00 00       	mov    $0x0,%edx
  800d28:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d2d:	89 d1                	mov    %edx,%ecx
  800d2f:	89 d3                	mov    %edx,%ebx
  800d31:	89 d7                	mov    %edx,%edi
  800d33:	89 d6                	mov    %edx,%esi
  800d35:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d37:	5b                   	pop    %ebx
  800d38:	5e                   	pop    %esi
  800d39:	5f                   	pop    %edi
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	57                   	push   %edi
  800d40:	56                   	push   %esi
  800d41:	53                   	push   %ebx
  800d42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d45:	be 00 00 00 00       	mov    $0x0,%esi
  800d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d50:	b8 04 00 00 00       	mov    $0x4,%eax
  800d55:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d58:	89 f7                	mov    %esi,%edi
  800d5a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5c:	85 c0                	test   %eax,%eax
  800d5e:	7f 08                	jg     800d68 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d63:	5b                   	pop    %ebx
  800d64:	5e                   	pop    %esi
  800d65:	5f                   	pop    %edi
  800d66:	5d                   	pop    %ebp
  800d67:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d68:	83 ec 0c             	sub    $0xc,%esp
  800d6b:	50                   	push   %eax
  800d6c:	6a 04                	push   $0x4
  800d6e:	68 64 29 80 00       	push   $0x802964
  800d73:	6a 43                	push   $0x43
  800d75:	68 81 29 80 00       	push   $0x802981
  800d7a:	e8 e8 13 00 00       	call   802167 <_panic>

00800d7f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	57                   	push   %edi
  800d83:	56                   	push   %esi
  800d84:	53                   	push   %ebx
  800d85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d88:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8e:	b8 05 00 00 00       	mov    $0x5,%eax
  800d93:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d96:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d99:	8b 75 18             	mov    0x18(%ebp),%esi
  800d9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9e:	85 c0                	test   %eax,%eax
  800da0:	7f 08                	jg     800daa <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800daa:	83 ec 0c             	sub    $0xc,%esp
  800dad:	50                   	push   %eax
  800dae:	6a 05                	push   $0x5
  800db0:	68 64 29 80 00       	push   $0x802964
  800db5:	6a 43                	push   $0x43
  800db7:	68 81 29 80 00       	push   $0x802981
  800dbc:	e8 a6 13 00 00       	call   802167 <_panic>

00800dc1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	57                   	push   %edi
  800dc5:	56                   	push   %esi
  800dc6:	53                   	push   %ebx
  800dc7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dca:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd5:	b8 06 00 00 00       	mov    $0x6,%eax
  800dda:	89 df                	mov    %ebx,%edi
  800ddc:	89 de                	mov    %ebx,%esi
  800dde:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de0:	85 c0                	test   %eax,%eax
  800de2:	7f 08                	jg     800dec <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800de4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de7:	5b                   	pop    %ebx
  800de8:	5e                   	pop    %esi
  800de9:	5f                   	pop    %edi
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dec:	83 ec 0c             	sub    $0xc,%esp
  800def:	50                   	push   %eax
  800df0:	6a 06                	push   $0x6
  800df2:	68 64 29 80 00       	push   $0x802964
  800df7:	6a 43                	push   $0x43
  800df9:	68 81 29 80 00       	push   $0x802981
  800dfe:	e8 64 13 00 00       	call   802167 <_panic>

00800e03 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	57                   	push   %edi
  800e07:	56                   	push   %esi
  800e08:	53                   	push   %ebx
  800e09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e11:	8b 55 08             	mov    0x8(%ebp),%edx
  800e14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e17:	b8 08 00 00 00       	mov    $0x8,%eax
  800e1c:	89 df                	mov    %ebx,%edi
  800e1e:	89 de                	mov    %ebx,%esi
  800e20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e22:	85 c0                	test   %eax,%eax
  800e24:	7f 08                	jg     800e2e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e29:	5b                   	pop    %ebx
  800e2a:	5e                   	pop    %esi
  800e2b:	5f                   	pop    %edi
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	50                   	push   %eax
  800e32:	6a 08                	push   $0x8
  800e34:	68 64 29 80 00       	push   $0x802964
  800e39:	6a 43                	push   $0x43
  800e3b:	68 81 29 80 00       	push   $0x802981
  800e40:	e8 22 13 00 00       	call   802167 <_panic>

00800e45 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	57                   	push   %edi
  800e49:	56                   	push   %esi
  800e4a:	53                   	push   %ebx
  800e4b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e53:	8b 55 08             	mov    0x8(%ebp),%edx
  800e56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e59:	b8 09 00 00 00       	mov    $0x9,%eax
  800e5e:	89 df                	mov    %ebx,%edi
  800e60:	89 de                	mov    %ebx,%esi
  800e62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e64:	85 c0                	test   %eax,%eax
  800e66:	7f 08                	jg     800e70 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6b:	5b                   	pop    %ebx
  800e6c:	5e                   	pop    %esi
  800e6d:	5f                   	pop    %edi
  800e6e:	5d                   	pop    %ebp
  800e6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e70:	83 ec 0c             	sub    $0xc,%esp
  800e73:	50                   	push   %eax
  800e74:	6a 09                	push   $0x9
  800e76:	68 64 29 80 00       	push   $0x802964
  800e7b:	6a 43                	push   $0x43
  800e7d:	68 81 29 80 00       	push   $0x802981
  800e82:	e8 e0 12 00 00       	call   802167 <_panic>

00800e87 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	57                   	push   %edi
  800e8b:	56                   	push   %esi
  800e8c:	53                   	push   %ebx
  800e8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e95:	8b 55 08             	mov    0x8(%ebp),%edx
  800e98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea0:	89 df                	mov    %ebx,%edi
  800ea2:	89 de                	mov    %ebx,%esi
  800ea4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	7f 08                	jg     800eb2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ead:	5b                   	pop    %ebx
  800eae:	5e                   	pop    %esi
  800eaf:	5f                   	pop    %edi
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb2:	83 ec 0c             	sub    $0xc,%esp
  800eb5:	50                   	push   %eax
  800eb6:	6a 0a                	push   $0xa
  800eb8:	68 64 29 80 00       	push   $0x802964
  800ebd:	6a 43                	push   $0x43
  800ebf:	68 81 29 80 00       	push   $0x802981
  800ec4:	e8 9e 12 00 00       	call   802167 <_panic>

00800ec9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eda:	be 00 00 00 00       	mov    $0x0,%esi
  800edf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ee7:	5b                   	pop    %ebx
  800ee8:	5e                   	pop    %esi
  800ee9:	5f                   	pop    %edi
  800eea:	5d                   	pop    %ebp
  800eeb:	c3                   	ret    

00800eec <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	57                   	push   %edi
  800ef0:	56                   	push   %esi
  800ef1:	53                   	push   %ebx
  800ef2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800efa:	8b 55 08             	mov    0x8(%ebp),%edx
  800efd:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f02:	89 cb                	mov    %ecx,%ebx
  800f04:	89 cf                	mov    %ecx,%edi
  800f06:	89 ce                	mov    %ecx,%esi
  800f08:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0a:	85 c0                	test   %eax,%eax
  800f0c:	7f 08                	jg     800f16 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f11:	5b                   	pop    %ebx
  800f12:	5e                   	pop    %esi
  800f13:	5f                   	pop    %edi
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f16:	83 ec 0c             	sub    $0xc,%esp
  800f19:	50                   	push   %eax
  800f1a:	6a 0d                	push   $0xd
  800f1c:	68 64 29 80 00       	push   $0x802964
  800f21:	6a 43                	push   $0x43
  800f23:	68 81 29 80 00       	push   $0x802981
  800f28:	e8 3a 12 00 00       	call   802167 <_panic>

00800f2d <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	57                   	push   %edi
  800f31:	56                   	push   %esi
  800f32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f38:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3e:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f43:	89 df                	mov    %ebx,%edi
  800f45:	89 de                	mov    %ebx,%esi
  800f47:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f49:	5b                   	pop    %ebx
  800f4a:	5e                   	pop    %esi
  800f4b:	5f                   	pop    %edi
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    

00800f4e <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	57                   	push   %edi
  800f52:	56                   	push   %esi
  800f53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f54:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f59:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5c:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f61:	89 cb                	mov    %ecx,%ebx
  800f63:	89 cf                	mov    %ecx,%edi
  800f65:	89 ce                	mov    %ecx,%esi
  800f67:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f69:	5b                   	pop    %ebx
  800f6a:	5e                   	pop    %esi
  800f6b:	5f                   	pop    %edi
  800f6c:	5d                   	pop    %ebp
  800f6d:	c3                   	ret    

00800f6e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	57                   	push   %edi
  800f72:	56                   	push   %esi
  800f73:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f74:	ba 00 00 00 00       	mov    $0x0,%edx
  800f79:	b8 10 00 00 00       	mov    $0x10,%eax
  800f7e:	89 d1                	mov    %edx,%ecx
  800f80:	89 d3                	mov    %edx,%ebx
  800f82:	89 d7                	mov    %edx,%edi
  800f84:	89 d6                	mov    %edx,%esi
  800f86:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f88:	5b                   	pop    %ebx
  800f89:	5e                   	pop    %esi
  800f8a:	5f                   	pop    %edi
  800f8b:	5d                   	pop    %ebp
  800f8c:	c3                   	ret    

00800f8d <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	57                   	push   %edi
  800f91:	56                   	push   %esi
  800f92:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f98:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9e:	b8 11 00 00 00       	mov    $0x11,%eax
  800fa3:	89 df                	mov    %ebx,%edi
  800fa5:	89 de                	mov    %ebx,%esi
  800fa7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fa9:	5b                   	pop    %ebx
  800faa:	5e                   	pop    %esi
  800fab:	5f                   	pop    %edi
  800fac:	5d                   	pop    %ebp
  800fad:	c3                   	ret    

00800fae <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	57                   	push   %edi
  800fb2:	56                   	push   %esi
  800fb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbf:	b8 12 00 00 00       	mov    $0x12,%eax
  800fc4:	89 df                	mov    %ebx,%edi
  800fc6:	89 de                	mov    %ebx,%esi
  800fc8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fca:	5b                   	pop    %ebx
  800fcb:	5e                   	pop    %esi
  800fcc:	5f                   	pop    %edi
  800fcd:	5d                   	pop    %ebp
  800fce:	c3                   	ret    

00800fcf <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	57                   	push   %edi
  800fd3:	56                   	push   %esi
  800fd4:	53                   	push   %ebx
  800fd5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe3:	b8 13 00 00 00       	mov    $0x13,%eax
  800fe8:	89 df                	mov    %ebx,%edi
  800fea:	89 de                	mov    %ebx,%esi
  800fec:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fee:	85 c0                	test   %eax,%eax
  800ff0:	7f 08                	jg     800ffa <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ff2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5f                   	pop    %edi
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffa:	83 ec 0c             	sub    $0xc,%esp
  800ffd:	50                   	push   %eax
  800ffe:	6a 13                	push   $0x13
  801000:	68 64 29 80 00       	push   $0x802964
  801005:	6a 43                	push   $0x43
  801007:	68 81 29 80 00       	push   $0x802981
  80100c:	e8 56 11 00 00       	call   802167 <_panic>

00801011 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	05 00 00 00 30       	add    $0x30000000,%eax
  80101c:	c1 e8 0c             	shr    $0xc,%eax
}
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    

00801021 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80102c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801031:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    

00801038 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801040:	89 c2                	mov    %eax,%edx
  801042:	c1 ea 16             	shr    $0x16,%edx
  801045:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80104c:	f6 c2 01             	test   $0x1,%dl
  80104f:	74 2d                	je     80107e <fd_alloc+0x46>
  801051:	89 c2                	mov    %eax,%edx
  801053:	c1 ea 0c             	shr    $0xc,%edx
  801056:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80105d:	f6 c2 01             	test   $0x1,%dl
  801060:	74 1c                	je     80107e <fd_alloc+0x46>
  801062:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801067:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80106c:	75 d2                	jne    801040 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801077:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80107c:	eb 0a                	jmp    801088 <fd_alloc+0x50>
			*fd_store = fd;
  80107e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801081:	89 01                	mov    %eax,(%ecx)
			return 0;
  801083:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801088:	5d                   	pop    %ebp
  801089:	c3                   	ret    

0080108a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801090:	83 f8 1f             	cmp    $0x1f,%eax
  801093:	77 30                	ja     8010c5 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801095:	c1 e0 0c             	shl    $0xc,%eax
  801098:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80109d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010a3:	f6 c2 01             	test   $0x1,%dl
  8010a6:	74 24                	je     8010cc <fd_lookup+0x42>
  8010a8:	89 c2                	mov    %eax,%edx
  8010aa:	c1 ea 0c             	shr    $0xc,%edx
  8010ad:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010b4:	f6 c2 01             	test   $0x1,%dl
  8010b7:	74 1a                	je     8010d3 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bc:	89 02                	mov    %eax,(%edx)
	return 0;
  8010be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c3:	5d                   	pop    %ebp
  8010c4:	c3                   	ret    
		return -E_INVAL;
  8010c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ca:	eb f7                	jmp    8010c3 <fd_lookup+0x39>
		return -E_INVAL;
  8010cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d1:	eb f0                	jmp    8010c3 <fd_lookup+0x39>
  8010d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d8:	eb e9                	jmp    8010c3 <fd_lookup+0x39>

008010da <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 08             	sub    $0x8,%esp
  8010e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e8:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010ed:	39 08                	cmp    %ecx,(%eax)
  8010ef:	74 38                	je     801129 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010f1:	83 c2 01             	add    $0x1,%edx
  8010f4:	8b 04 95 0c 2a 80 00 	mov    0x802a0c(,%edx,4),%eax
  8010fb:	85 c0                	test   %eax,%eax
  8010fd:	75 ee                	jne    8010ed <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010ff:	a1 08 40 80 00       	mov    0x804008,%eax
  801104:	8b 40 48             	mov    0x48(%eax),%eax
  801107:	83 ec 04             	sub    $0x4,%esp
  80110a:	51                   	push   %ecx
  80110b:	50                   	push   %eax
  80110c:	68 90 29 80 00       	push   $0x802990
  801111:	e8 d5 f0 ff ff       	call   8001eb <cprintf>
	*dev = 0;
  801116:	8b 45 0c             	mov    0xc(%ebp),%eax
  801119:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80111f:	83 c4 10             	add    $0x10,%esp
  801122:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801127:	c9                   	leave  
  801128:	c3                   	ret    
			*dev = devtab[i];
  801129:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80112e:	b8 00 00 00 00       	mov    $0x0,%eax
  801133:	eb f2                	jmp    801127 <dev_lookup+0x4d>

00801135 <fd_close>:
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	57                   	push   %edi
  801139:	56                   	push   %esi
  80113a:	53                   	push   %ebx
  80113b:	83 ec 24             	sub    $0x24,%esp
  80113e:	8b 75 08             	mov    0x8(%ebp),%esi
  801141:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801144:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801147:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801148:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80114e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801151:	50                   	push   %eax
  801152:	e8 33 ff ff ff       	call   80108a <fd_lookup>
  801157:	89 c3                	mov    %eax,%ebx
  801159:	83 c4 10             	add    $0x10,%esp
  80115c:	85 c0                	test   %eax,%eax
  80115e:	78 05                	js     801165 <fd_close+0x30>
	    || fd != fd2)
  801160:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801163:	74 16                	je     80117b <fd_close+0x46>
		return (must_exist ? r : 0);
  801165:	89 f8                	mov    %edi,%eax
  801167:	84 c0                	test   %al,%al
  801169:	b8 00 00 00 00       	mov    $0x0,%eax
  80116e:	0f 44 d8             	cmove  %eax,%ebx
}
  801171:	89 d8                	mov    %ebx,%eax
  801173:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801176:	5b                   	pop    %ebx
  801177:	5e                   	pop    %esi
  801178:	5f                   	pop    %edi
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801181:	50                   	push   %eax
  801182:	ff 36                	pushl  (%esi)
  801184:	e8 51 ff ff ff       	call   8010da <dev_lookup>
  801189:	89 c3                	mov    %eax,%ebx
  80118b:	83 c4 10             	add    $0x10,%esp
  80118e:	85 c0                	test   %eax,%eax
  801190:	78 1a                	js     8011ac <fd_close+0x77>
		if (dev->dev_close)
  801192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801195:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801198:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80119d:	85 c0                	test   %eax,%eax
  80119f:	74 0b                	je     8011ac <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011a1:	83 ec 0c             	sub    $0xc,%esp
  8011a4:	56                   	push   %esi
  8011a5:	ff d0                	call   *%eax
  8011a7:	89 c3                	mov    %eax,%ebx
  8011a9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	56                   	push   %esi
  8011b0:	6a 00                	push   $0x0
  8011b2:	e8 0a fc ff ff       	call   800dc1 <sys_page_unmap>
	return r;
  8011b7:	83 c4 10             	add    $0x10,%esp
  8011ba:	eb b5                	jmp    801171 <fd_close+0x3c>

008011bc <close>:

int
close(int fdnum)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c5:	50                   	push   %eax
  8011c6:	ff 75 08             	pushl  0x8(%ebp)
  8011c9:	e8 bc fe ff ff       	call   80108a <fd_lookup>
  8011ce:	83 c4 10             	add    $0x10,%esp
  8011d1:	85 c0                	test   %eax,%eax
  8011d3:	79 02                	jns    8011d7 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    
		return fd_close(fd, 1);
  8011d7:	83 ec 08             	sub    $0x8,%esp
  8011da:	6a 01                	push   $0x1
  8011dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8011df:	e8 51 ff ff ff       	call   801135 <fd_close>
  8011e4:	83 c4 10             	add    $0x10,%esp
  8011e7:	eb ec                	jmp    8011d5 <close+0x19>

008011e9 <close_all>:

void
close_all(void)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	53                   	push   %ebx
  8011ed:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011f0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011f5:	83 ec 0c             	sub    $0xc,%esp
  8011f8:	53                   	push   %ebx
  8011f9:	e8 be ff ff ff       	call   8011bc <close>
	for (i = 0; i < MAXFD; i++)
  8011fe:	83 c3 01             	add    $0x1,%ebx
  801201:	83 c4 10             	add    $0x10,%esp
  801204:	83 fb 20             	cmp    $0x20,%ebx
  801207:	75 ec                	jne    8011f5 <close_all+0xc>
}
  801209:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	57                   	push   %edi
  801212:	56                   	push   %esi
  801213:	53                   	push   %ebx
  801214:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801217:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80121a:	50                   	push   %eax
  80121b:	ff 75 08             	pushl  0x8(%ebp)
  80121e:	e8 67 fe ff ff       	call   80108a <fd_lookup>
  801223:	89 c3                	mov    %eax,%ebx
  801225:	83 c4 10             	add    $0x10,%esp
  801228:	85 c0                	test   %eax,%eax
  80122a:	0f 88 81 00 00 00    	js     8012b1 <dup+0xa3>
		return r;
	close(newfdnum);
  801230:	83 ec 0c             	sub    $0xc,%esp
  801233:	ff 75 0c             	pushl  0xc(%ebp)
  801236:	e8 81 ff ff ff       	call   8011bc <close>

	newfd = INDEX2FD(newfdnum);
  80123b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80123e:	c1 e6 0c             	shl    $0xc,%esi
  801241:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801247:	83 c4 04             	add    $0x4,%esp
  80124a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80124d:	e8 cf fd ff ff       	call   801021 <fd2data>
  801252:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801254:	89 34 24             	mov    %esi,(%esp)
  801257:	e8 c5 fd ff ff       	call   801021 <fd2data>
  80125c:	83 c4 10             	add    $0x10,%esp
  80125f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801261:	89 d8                	mov    %ebx,%eax
  801263:	c1 e8 16             	shr    $0x16,%eax
  801266:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80126d:	a8 01                	test   $0x1,%al
  80126f:	74 11                	je     801282 <dup+0x74>
  801271:	89 d8                	mov    %ebx,%eax
  801273:	c1 e8 0c             	shr    $0xc,%eax
  801276:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80127d:	f6 c2 01             	test   $0x1,%dl
  801280:	75 39                	jne    8012bb <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801282:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801285:	89 d0                	mov    %edx,%eax
  801287:	c1 e8 0c             	shr    $0xc,%eax
  80128a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801291:	83 ec 0c             	sub    $0xc,%esp
  801294:	25 07 0e 00 00       	and    $0xe07,%eax
  801299:	50                   	push   %eax
  80129a:	56                   	push   %esi
  80129b:	6a 00                	push   $0x0
  80129d:	52                   	push   %edx
  80129e:	6a 00                	push   $0x0
  8012a0:	e8 da fa ff ff       	call   800d7f <sys_page_map>
  8012a5:	89 c3                	mov    %eax,%ebx
  8012a7:	83 c4 20             	add    $0x20,%esp
  8012aa:	85 c0                	test   %eax,%eax
  8012ac:	78 31                	js     8012df <dup+0xd1>
		goto err;

	return newfdnum;
  8012ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012b1:	89 d8                	mov    %ebx,%eax
  8012b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b6:	5b                   	pop    %ebx
  8012b7:	5e                   	pop    %esi
  8012b8:	5f                   	pop    %edi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012bb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012c2:	83 ec 0c             	sub    $0xc,%esp
  8012c5:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ca:	50                   	push   %eax
  8012cb:	57                   	push   %edi
  8012cc:	6a 00                	push   $0x0
  8012ce:	53                   	push   %ebx
  8012cf:	6a 00                	push   $0x0
  8012d1:	e8 a9 fa ff ff       	call   800d7f <sys_page_map>
  8012d6:	89 c3                	mov    %eax,%ebx
  8012d8:	83 c4 20             	add    $0x20,%esp
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	79 a3                	jns    801282 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012df:	83 ec 08             	sub    $0x8,%esp
  8012e2:	56                   	push   %esi
  8012e3:	6a 00                	push   $0x0
  8012e5:	e8 d7 fa ff ff       	call   800dc1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012ea:	83 c4 08             	add    $0x8,%esp
  8012ed:	57                   	push   %edi
  8012ee:	6a 00                	push   $0x0
  8012f0:	e8 cc fa ff ff       	call   800dc1 <sys_page_unmap>
	return r;
  8012f5:	83 c4 10             	add    $0x10,%esp
  8012f8:	eb b7                	jmp    8012b1 <dup+0xa3>

008012fa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	53                   	push   %ebx
  8012fe:	83 ec 1c             	sub    $0x1c,%esp
  801301:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801304:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801307:	50                   	push   %eax
  801308:	53                   	push   %ebx
  801309:	e8 7c fd ff ff       	call   80108a <fd_lookup>
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	85 c0                	test   %eax,%eax
  801313:	78 3f                	js     801354 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801315:	83 ec 08             	sub    $0x8,%esp
  801318:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80131b:	50                   	push   %eax
  80131c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131f:	ff 30                	pushl  (%eax)
  801321:	e8 b4 fd ff ff       	call   8010da <dev_lookup>
  801326:	83 c4 10             	add    $0x10,%esp
  801329:	85 c0                	test   %eax,%eax
  80132b:	78 27                	js     801354 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80132d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801330:	8b 42 08             	mov    0x8(%edx),%eax
  801333:	83 e0 03             	and    $0x3,%eax
  801336:	83 f8 01             	cmp    $0x1,%eax
  801339:	74 1e                	je     801359 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80133b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133e:	8b 40 08             	mov    0x8(%eax),%eax
  801341:	85 c0                	test   %eax,%eax
  801343:	74 35                	je     80137a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801345:	83 ec 04             	sub    $0x4,%esp
  801348:	ff 75 10             	pushl  0x10(%ebp)
  80134b:	ff 75 0c             	pushl  0xc(%ebp)
  80134e:	52                   	push   %edx
  80134f:	ff d0                	call   *%eax
  801351:	83 c4 10             	add    $0x10,%esp
}
  801354:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801357:	c9                   	leave  
  801358:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801359:	a1 08 40 80 00       	mov    0x804008,%eax
  80135e:	8b 40 48             	mov    0x48(%eax),%eax
  801361:	83 ec 04             	sub    $0x4,%esp
  801364:	53                   	push   %ebx
  801365:	50                   	push   %eax
  801366:	68 d1 29 80 00       	push   $0x8029d1
  80136b:	e8 7b ee ff ff       	call   8001eb <cprintf>
		return -E_INVAL;
  801370:	83 c4 10             	add    $0x10,%esp
  801373:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801378:	eb da                	jmp    801354 <read+0x5a>
		return -E_NOT_SUPP;
  80137a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80137f:	eb d3                	jmp    801354 <read+0x5a>

00801381 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	57                   	push   %edi
  801385:	56                   	push   %esi
  801386:	53                   	push   %ebx
  801387:	83 ec 0c             	sub    $0xc,%esp
  80138a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80138d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801390:	bb 00 00 00 00       	mov    $0x0,%ebx
  801395:	39 f3                	cmp    %esi,%ebx
  801397:	73 23                	jae    8013bc <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801399:	83 ec 04             	sub    $0x4,%esp
  80139c:	89 f0                	mov    %esi,%eax
  80139e:	29 d8                	sub    %ebx,%eax
  8013a0:	50                   	push   %eax
  8013a1:	89 d8                	mov    %ebx,%eax
  8013a3:	03 45 0c             	add    0xc(%ebp),%eax
  8013a6:	50                   	push   %eax
  8013a7:	57                   	push   %edi
  8013a8:	e8 4d ff ff ff       	call   8012fa <read>
		if (m < 0)
  8013ad:	83 c4 10             	add    $0x10,%esp
  8013b0:	85 c0                	test   %eax,%eax
  8013b2:	78 06                	js     8013ba <readn+0x39>
			return m;
		if (m == 0)
  8013b4:	74 06                	je     8013bc <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013b6:	01 c3                	add    %eax,%ebx
  8013b8:	eb db                	jmp    801395 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013ba:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013bc:	89 d8                	mov    %ebx,%eax
  8013be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c1:	5b                   	pop    %ebx
  8013c2:	5e                   	pop    %esi
  8013c3:	5f                   	pop    %edi
  8013c4:	5d                   	pop    %ebp
  8013c5:	c3                   	ret    

008013c6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	53                   	push   %ebx
  8013ca:	83 ec 1c             	sub    $0x1c,%esp
  8013cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d3:	50                   	push   %eax
  8013d4:	53                   	push   %ebx
  8013d5:	e8 b0 fc ff ff       	call   80108a <fd_lookup>
  8013da:	83 c4 10             	add    $0x10,%esp
  8013dd:	85 c0                	test   %eax,%eax
  8013df:	78 3a                	js     80141b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e1:	83 ec 08             	sub    $0x8,%esp
  8013e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e7:	50                   	push   %eax
  8013e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013eb:	ff 30                	pushl  (%eax)
  8013ed:	e8 e8 fc ff ff       	call   8010da <dev_lookup>
  8013f2:	83 c4 10             	add    $0x10,%esp
  8013f5:	85 c0                	test   %eax,%eax
  8013f7:	78 22                	js     80141b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801400:	74 1e                	je     801420 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801402:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801405:	8b 52 0c             	mov    0xc(%edx),%edx
  801408:	85 d2                	test   %edx,%edx
  80140a:	74 35                	je     801441 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80140c:	83 ec 04             	sub    $0x4,%esp
  80140f:	ff 75 10             	pushl  0x10(%ebp)
  801412:	ff 75 0c             	pushl  0xc(%ebp)
  801415:	50                   	push   %eax
  801416:	ff d2                	call   *%edx
  801418:	83 c4 10             	add    $0x10,%esp
}
  80141b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801420:	a1 08 40 80 00       	mov    0x804008,%eax
  801425:	8b 40 48             	mov    0x48(%eax),%eax
  801428:	83 ec 04             	sub    $0x4,%esp
  80142b:	53                   	push   %ebx
  80142c:	50                   	push   %eax
  80142d:	68 ed 29 80 00       	push   $0x8029ed
  801432:	e8 b4 ed ff ff       	call   8001eb <cprintf>
		return -E_INVAL;
  801437:	83 c4 10             	add    $0x10,%esp
  80143a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80143f:	eb da                	jmp    80141b <write+0x55>
		return -E_NOT_SUPP;
  801441:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801446:	eb d3                	jmp    80141b <write+0x55>

00801448 <seek>:

int
seek(int fdnum, off_t offset)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80144e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801451:	50                   	push   %eax
  801452:	ff 75 08             	pushl  0x8(%ebp)
  801455:	e8 30 fc ff ff       	call   80108a <fd_lookup>
  80145a:	83 c4 10             	add    $0x10,%esp
  80145d:	85 c0                	test   %eax,%eax
  80145f:	78 0e                	js     80146f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801461:	8b 55 0c             	mov    0xc(%ebp),%edx
  801464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801467:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80146a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	53                   	push   %ebx
  801475:	83 ec 1c             	sub    $0x1c,%esp
  801478:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80147e:	50                   	push   %eax
  80147f:	53                   	push   %ebx
  801480:	e8 05 fc ff ff       	call   80108a <fd_lookup>
  801485:	83 c4 10             	add    $0x10,%esp
  801488:	85 c0                	test   %eax,%eax
  80148a:	78 37                	js     8014c3 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80148c:	83 ec 08             	sub    $0x8,%esp
  80148f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801492:	50                   	push   %eax
  801493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801496:	ff 30                	pushl  (%eax)
  801498:	e8 3d fc ff ff       	call   8010da <dev_lookup>
  80149d:	83 c4 10             	add    $0x10,%esp
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	78 1f                	js     8014c3 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014ab:	74 1b                	je     8014c8 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b0:	8b 52 18             	mov    0x18(%edx),%edx
  8014b3:	85 d2                	test   %edx,%edx
  8014b5:	74 32                	je     8014e9 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014b7:	83 ec 08             	sub    $0x8,%esp
  8014ba:	ff 75 0c             	pushl  0xc(%ebp)
  8014bd:	50                   	push   %eax
  8014be:	ff d2                	call   *%edx
  8014c0:	83 c4 10             	add    $0x10,%esp
}
  8014c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014c8:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014cd:	8b 40 48             	mov    0x48(%eax),%eax
  8014d0:	83 ec 04             	sub    $0x4,%esp
  8014d3:	53                   	push   %ebx
  8014d4:	50                   	push   %eax
  8014d5:	68 b0 29 80 00       	push   $0x8029b0
  8014da:	e8 0c ed ff ff       	call   8001eb <cprintf>
		return -E_INVAL;
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e7:	eb da                	jmp    8014c3 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014ee:	eb d3                	jmp    8014c3 <ftruncate+0x52>

008014f0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	53                   	push   %ebx
  8014f4:	83 ec 1c             	sub    $0x1c,%esp
  8014f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014fd:	50                   	push   %eax
  8014fe:	ff 75 08             	pushl  0x8(%ebp)
  801501:	e8 84 fb ff ff       	call   80108a <fd_lookup>
  801506:	83 c4 10             	add    $0x10,%esp
  801509:	85 c0                	test   %eax,%eax
  80150b:	78 4b                	js     801558 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150d:	83 ec 08             	sub    $0x8,%esp
  801510:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801513:	50                   	push   %eax
  801514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801517:	ff 30                	pushl  (%eax)
  801519:	e8 bc fb ff ff       	call   8010da <dev_lookup>
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	85 c0                	test   %eax,%eax
  801523:	78 33                	js     801558 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801528:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80152c:	74 2f                	je     80155d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80152e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801531:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801538:	00 00 00 
	stat->st_isdir = 0;
  80153b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801542:	00 00 00 
	stat->st_dev = dev;
  801545:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80154b:	83 ec 08             	sub    $0x8,%esp
  80154e:	53                   	push   %ebx
  80154f:	ff 75 f0             	pushl  -0x10(%ebp)
  801552:	ff 50 14             	call   *0x14(%eax)
  801555:	83 c4 10             	add    $0x10,%esp
}
  801558:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155b:	c9                   	leave  
  80155c:	c3                   	ret    
		return -E_NOT_SUPP;
  80155d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801562:	eb f4                	jmp    801558 <fstat+0x68>

00801564 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	56                   	push   %esi
  801568:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801569:	83 ec 08             	sub    $0x8,%esp
  80156c:	6a 00                	push   $0x0
  80156e:	ff 75 08             	pushl  0x8(%ebp)
  801571:	e8 22 02 00 00       	call   801798 <open>
  801576:	89 c3                	mov    %eax,%ebx
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	85 c0                	test   %eax,%eax
  80157d:	78 1b                	js     80159a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80157f:	83 ec 08             	sub    $0x8,%esp
  801582:	ff 75 0c             	pushl  0xc(%ebp)
  801585:	50                   	push   %eax
  801586:	e8 65 ff ff ff       	call   8014f0 <fstat>
  80158b:	89 c6                	mov    %eax,%esi
	close(fd);
  80158d:	89 1c 24             	mov    %ebx,(%esp)
  801590:	e8 27 fc ff ff       	call   8011bc <close>
	return r;
  801595:	83 c4 10             	add    $0x10,%esp
  801598:	89 f3                	mov    %esi,%ebx
}
  80159a:	89 d8                	mov    %ebx,%eax
  80159c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80159f:	5b                   	pop    %ebx
  8015a0:	5e                   	pop    %esi
  8015a1:	5d                   	pop    %ebp
  8015a2:	c3                   	ret    

008015a3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	56                   	push   %esi
  8015a7:	53                   	push   %ebx
  8015a8:	89 c6                	mov    %eax,%esi
  8015aa:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015ac:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015b3:	74 27                	je     8015dc <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015b5:	6a 07                	push   $0x7
  8015b7:	68 00 50 80 00       	push   $0x805000
  8015bc:	56                   	push   %esi
  8015bd:	ff 35 00 40 80 00    	pushl  0x804000
  8015c3:	e8 69 0c 00 00       	call   802231 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015c8:	83 c4 0c             	add    $0xc,%esp
  8015cb:	6a 00                	push   $0x0
  8015cd:	53                   	push   %ebx
  8015ce:	6a 00                	push   $0x0
  8015d0:	e8 f3 0b 00 00       	call   8021c8 <ipc_recv>
}
  8015d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d8:	5b                   	pop    %ebx
  8015d9:	5e                   	pop    %esi
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015dc:	83 ec 0c             	sub    $0xc,%esp
  8015df:	6a 01                	push   $0x1
  8015e1:	e8 a3 0c 00 00       	call   802289 <ipc_find_env>
  8015e6:	a3 00 40 80 00       	mov    %eax,0x804000
  8015eb:	83 c4 10             	add    $0x10,%esp
  8015ee:	eb c5                	jmp    8015b5 <fsipc+0x12>

008015f0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015fc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801601:	8b 45 0c             	mov    0xc(%ebp),%eax
  801604:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801609:	ba 00 00 00 00       	mov    $0x0,%edx
  80160e:	b8 02 00 00 00       	mov    $0x2,%eax
  801613:	e8 8b ff ff ff       	call   8015a3 <fsipc>
}
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <devfile_flush>:
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	8b 40 0c             	mov    0xc(%eax),%eax
  801626:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80162b:	ba 00 00 00 00       	mov    $0x0,%edx
  801630:	b8 06 00 00 00       	mov    $0x6,%eax
  801635:	e8 69 ff ff ff       	call   8015a3 <fsipc>
}
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <devfile_stat>:
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	53                   	push   %ebx
  801640:	83 ec 04             	sub    $0x4,%esp
  801643:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8b 40 0c             	mov    0xc(%eax),%eax
  80164c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801651:	ba 00 00 00 00       	mov    $0x0,%edx
  801656:	b8 05 00 00 00       	mov    $0x5,%eax
  80165b:	e8 43 ff ff ff       	call   8015a3 <fsipc>
  801660:	85 c0                	test   %eax,%eax
  801662:	78 2c                	js     801690 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801664:	83 ec 08             	sub    $0x8,%esp
  801667:	68 00 50 80 00       	push   $0x805000
  80166c:	53                   	push   %ebx
  80166d:	e8 d8 f2 ff ff       	call   80094a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801672:	a1 80 50 80 00       	mov    0x805080,%eax
  801677:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80167d:	a1 84 50 80 00       	mov    0x805084,%eax
  801682:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801688:	83 c4 10             	add    $0x10,%esp
  80168b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801690:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <devfile_write>:
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	53                   	push   %ebx
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016aa:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016b0:	53                   	push   %ebx
  8016b1:	ff 75 0c             	pushl  0xc(%ebp)
  8016b4:	68 08 50 80 00       	push   $0x805008
  8016b9:	e8 7c f4 ff ff       	call   800b3a <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016be:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c3:	b8 04 00 00 00       	mov    $0x4,%eax
  8016c8:	e8 d6 fe ff ff       	call   8015a3 <fsipc>
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	85 c0                	test   %eax,%eax
  8016d2:	78 0b                	js     8016df <devfile_write+0x4a>
	assert(r <= n);
  8016d4:	39 d8                	cmp    %ebx,%eax
  8016d6:	77 0c                	ja     8016e4 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016d8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016dd:	7f 1e                	jg     8016fd <devfile_write+0x68>
}
  8016df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    
	assert(r <= n);
  8016e4:	68 20 2a 80 00       	push   $0x802a20
  8016e9:	68 27 2a 80 00       	push   $0x802a27
  8016ee:	68 98 00 00 00       	push   $0x98
  8016f3:	68 3c 2a 80 00       	push   $0x802a3c
  8016f8:	e8 6a 0a 00 00       	call   802167 <_panic>
	assert(r <= PGSIZE);
  8016fd:	68 47 2a 80 00       	push   $0x802a47
  801702:	68 27 2a 80 00       	push   $0x802a27
  801707:	68 99 00 00 00       	push   $0x99
  80170c:	68 3c 2a 80 00       	push   $0x802a3c
  801711:	e8 51 0a 00 00       	call   802167 <_panic>

00801716 <devfile_read>:
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	56                   	push   %esi
  80171a:	53                   	push   %ebx
  80171b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8b 40 0c             	mov    0xc(%eax),%eax
  801724:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801729:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80172f:	ba 00 00 00 00       	mov    $0x0,%edx
  801734:	b8 03 00 00 00       	mov    $0x3,%eax
  801739:	e8 65 fe ff ff       	call   8015a3 <fsipc>
  80173e:	89 c3                	mov    %eax,%ebx
  801740:	85 c0                	test   %eax,%eax
  801742:	78 1f                	js     801763 <devfile_read+0x4d>
	assert(r <= n);
  801744:	39 f0                	cmp    %esi,%eax
  801746:	77 24                	ja     80176c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801748:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80174d:	7f 33                	jg     801782 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80174f:	83 ec 04             	sub    $0x4,%esp
  801752:	50                   	push   %eax
  801753:	68 00 50 80 00       	push   $0x805000
  801758:	ff 75 0c             	pushl  0xc(%ebp)
  80175b:	e8 78 f3 ff ff       	call   800ad8 <memmove>
	return r;
  801760:	83 c4 10             	add    $0x10,%esp
}
  801763:	89 d8                	mov    %ebx,%eax
  801765:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801768:	5b                   	pop    %ebx
  801769:	5e                   	pop    %esi
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    
	assert(r <= n);
  80176c:	68 20 2a 80 00       	push   $0x802a20
  801771:	68 27 2a 80 00       	push   $0x802a27
  801776:	6a 7c                	push   $0x7c
  801778:	68 3c 2a 80 00       	push   $0x802a3c
  80177d:	e8 e5 09 00 00       	call   802167 <_panic>
	assert(r <= PGSIZE);
  801782:	68 47 2a 80 00       	push   $0x802a47
  801787:	68 27 2a 80 00       	push   $0x802a27
  80178c:	6a 7d                	push   $0x7d
  80178e:	68 3c 2a 80 00       	push   $0x802a3c
  801793:	e8 cf 09 00 00       	call   802167 <_panic>

00801798 <open>:
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	56                   	push   %esi
  80179c:	53                   	push   %ebx
  80179d:	83 ec 1c             	sub    $0x1c,%esp
  8017a0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017a3:	56                   	push   %esi
  8017a4:	e8 68 f1 ff ff       	call   800911 <strlen>
  8017a9:	83 c4 10             	add    $0x10,%esp
  8017ac:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017b1:	7f 6c                	jg     80181f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017b3:	83 ec 0c             	sub    $0xc,%esp
  8017b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b9:	50                   	push   %eax
  8017ba:	e8 79 f8 ff ff       	call   801038 <fd_alloc>
  8017bf:	89 c3                	mov    %eax,%ebx
  8017c1:	83 c4 10             	add    $0x10,%esp
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	78 3c                	js     801804 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017c8:	83 ec 08             	sub    $0x8,%esp
  8017cb:	56                   	push   %esi
  8017cc:	68 00 50 80 00       	push   $0x805000
  8017d1:	e8 74 f1 ff ff       	call   80094a <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d9:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e6:	e8 b8 fd ff ff       	call   8015a3 <fsipc>
  8017eb:	89 c3                	mov    %eax,%ebx
  8017ed:	83 c4 10             	add    $0x10,%esp
  8017f0:	85 c0                	test   %eax,%eax
  8017f2:	78 19                	js     80180d <open+0x75>
	return fd2num(fd);
  8017f4:	83 ec 0c             	sub    $0xc,%esp
  8017f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017fa:	e8 12 f8 ff ff       	call   801011 <fd2num>
  8017ff:	89 c3                	mov    %eax,%ebx
  801801:	83 c4 10             	add    $0x10,%esp
}
  801804:	89 d8                	mov    %ebx,%eax
  801806:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801809:	5b                   	pop    %ebx
  80180a:	5e                   	pop    %esi
  80180b:	5d                   	pop    %ebp
  80180c:	c3                   	ret    
		fd_close(fd, 0);
  80180d:	83 ec 08             	sub    $0x8,%esp
  801810:	6a 00                	push   $0x0
  801812:	ff 75 f4             	pushl  -0xc(%ebp)
  801815:	e8 1b f9 ff ff       	call   801135 <fd_close>
		return r;
  80181a:	83 c4 10             	add    $0x10,%esp
  80181d:	eb e5                	jmp    801804 <open+0x6c>
		return -E_BAD_PATH;
  80181f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801824:	eb de                	jmp    801804 <open+0x6c>

00801826 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80182c:	ba 00 00 00 00       	mov    $0x0,%edx
  801831:	b8 08 00 00 00       	mov    $0x8,%eax
  801836:	e8 68 fd ff ff       	call   8015a3 <fsipc>
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801843:	68 53 2a 80 00       	push   $0x802a53
  801848:	ff 75 0c             	pushl  0xc(%ebp)
  80184b:	e8 fa f0 ff ff       	call   80094a <strcpy>
	return 0;
}
  801850:	b8 00 00 00 00       	mov    $0x0,%eax
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <devsock_close>:
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	53                   	push   %ebx
  80185b:	83 ec 10             	sub    $0x10,%esp
  80185e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801861:	53                   	push   %ebx
  801862:	e8 5d 0a 00 00       	call   8022c4 <pageref>
  801867:	83 c4 10             	add    $0x10,%esp
		return 0;
  80186a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80186f:	83 f8 01             	cmp    $0x1,%eax
  801872:	74 07                	je     80187b <devsock_close+0x24>
}
  801874:	89 d0                	mov    %edx,%eax
  801876:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801879:	c9                   	leave  
  80187a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80187b:	83 ec 0c             	sub    $0xc,%esp
  80187e:	ff 73 0c             	pushl  0xc(%ebx)
  801881:	e8 b9 02 00 00       	call   801b3f <nsipc_close>
  801886:	89 c2                	mov    %eax,%edx
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	eb e7                	jmp    801874 <devsock_close+0x1d>

0080188d <devsock_write>:
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801893:	6a 00                	push   $0x0
  801895:	ff 75 10             	pushl  0x10(%ebp)
  801898:	ff 75 0c             	pushl  0xc(%ebp)
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	ff 70 0c             	pushl  0xc(%eax)
  8018a1:	e8 76 03 00 00       	call   801c1c <nsipc_send>
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <devsock_read>:
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
  8018ab:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018ae:	6a 00                	push   $0x0
  8018b0:	ff 75 10             	pushl  0x10(%ebp)
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	ff 70 0c             	pushl  0xc(%eax)
  8018bc:	e8 ef 02 00 00       	call   801bb0 <nsipc_recv>
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <fd2sockid>:
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018c9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018cc:	52                   	push   %edx
  8018cd:	50                   	push   %eax
  8018ce:	e8 b7 f7 ff ff       	call   80108a <fd_lookup>
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	78 10                	js     8018ea <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018dd:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018e3:	39 08                	cmp    %ecx,(%eax)
  8018e5:	75 05                	jne    8018ec <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018e7:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    
		return -E_NOT_SUPP;
  8018ec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018f1:	eb f7                	jmp    8018ea <fd2sockid+0x27>

008018f3 <alloc_sockfd>:
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	56                   	push   %esi
  8018f7:	53                   	push   %ebx
  8018f8:	83 ec 1c             	sub    $0x1c,%esp
  8018fb:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801900:	50                   	push   %eax
  801901:	e8 32 f7 ff ff       	call   801038 <fd_alloc>
  801906:	89 c3                	mov    %eax,%ebx
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	85 c0                	test   %eax,%eax
  80190d:	78 43                	js     801952 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80190f:	83 ec 04             	sub    $0x4,%esp
  801912:	68 07 04 00 00       	push   $0x407
  801917:	ff 75 f4             	pushl  -0xc(%ebp)
  80191a:	6a 00                	push   $0x0
  80191c:	e8 1b f4 ff ff       	call   800d3c <sys_page_alloc>
  801921:	89 c3                	mov    %eax,%ebx
  801923:	83 c4 10             	add    $0x10,%esp
  801926:	85 c0                	test   %eax,%eax
  801928:	78 28                	js     801952 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80192a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801933:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801938:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80193f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801942:	83 ec 0c             	sub    $0xc,%esp
  801945:	50                   	push   %eax
  801946:	e8 c6 f6 ff ff       	call   801011 <fd2num>
  80194b:	89 c3                	mov    %eax,%ebx
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	eb 0c                	jmp    80195e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801952:	83 ec 0c             	sub    $0xc,%esp
  801955:	56                   	push   %esi
  801956:	e8 e4 01 00 00       	call   801b3f <nsipc_close>
		return r;
  80195b:	83 c4 10             	add    $0x10,%esp
}
  80195e:	89 d8                	mov    %ebx,%eax
  801960:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801963:	5b                   	pop    %ebx
  801964:	5e                   	pop    %esi
  801965:	5d                   	pop    %ebp
  801966:	c3                   	ret    

00801967 <accept>:
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	e8 4e ff ff ff       	call   8018c3 <fd2sockid>
  801975:	85 c0                	test   %eax,%eax
  801977:	78 1b                	js     801994 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801979:	83 ec 04             	sub    $0x4,%esp
  80197c:	ff 75 10             	pushl  0x10(%ebp)
  80197f:	ff 75 0c             	pushl  0xc(%ebp)
  801982:	50                   	push   %eax
  801983:	e8 0e 01 00 00       	call   801a96 <nsipc_accept>
  801988:	83 c4 10             	add    $0x10,%esp
  80198b:	85 c0                	test   %eax,%eax
  80198d:	78 05                	js     801994 <accept+0x2d>
	return alloc_sockfd(r);
  80198f:	e8 5f ff ff ff       	call   8018f3 <alloc_sockfd>
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <bind>:
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	e8 1f ff ff ff       	call   8018c3 <fd2sockid>
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	78 12                	js     8019ba <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019a8:	83 ec 04             	sub    $0x4,%esp
  8019ab:	ff 75 10             	pushl  0x10(%ebp)
  8019ae:	ff 75 0c             	pushl  0xc(%ebp)
  8019b1:	50                   	push   %eax
  8019b2:	e8 31 01 00 00       	call   801ae8 <nsipc_bind>
  8019b7:	83 c4 10             	add    $0x10,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <shutdown>:
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
  8019bf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	e8 f9 fe ff ff       	call   8018c3 <fd2sockid>
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	78 0f                	js     8019dd <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019ce:	83 ec 08             	sub    $0x8,%esp
  8019d1:	ff 75 0c             	pushl  0xc(%ebp)
  8019d4:	50                   	push   %eax
  8019d5:	e8 43 01 00 00       	call   801b1d <nsipc_shutdown>
  8019da:	83 c4 10             	add    $0x10,%esp
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <connect>:
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	e8 d6 fe ff ff       	call   8018c3 <fd2sockid>
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	78 12                	js     801a03 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019f1:	83 ec 04             	sub    $0x4,%esp
  8019f4:	ff 75 10             	pushl  0x10(%ebp)
  8019f7:	ff 75 0c             	pushl  0xc(%ebp)
  8019fa:	50                   	push   %eax
  8019fb:	e8 59 01 00 00       	call   801b59 <nsipc_connect>
  801a00:	83 c4 10             	add    $0x10,%esp
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <listen>:
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	e8 b0 fe ff ff       	call   8018c3 <fd2sockid>
  801a13:	85 c0                	test   %eax,%eax
  801a15:	78 0f                	js     801a26 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a17:	83 ec 08             	sub    $0x8,%esp
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	50                   	push   %eax
  801a1e:	e8 6b 01 00 00       	call   801b8e <nsipc_listen>
  801a23:	83 c4 10             	add    $0x10,%esp
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a2e:	ff 75 10             	pushl  0x10(%ebp)
  801a31:	ff 75 0c             	pushl  0xc(%ebp)
  801a34:	ff 75 08             	pushl  0x8(%ebp)
  801a37:	e8 3e 02 00 00       	call   801c7a <nsipc_socket>
  801a3c:	83 c4 10             	add    $0x10,%esp
  801a3f:	85 c0                	test   %eax,%eax
  801a41:	78 05                	js     801a48 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a43:	e8 ab fe ff ff       	call   8018f3 <alloc_sockfd>
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	53                   	push   %ebx
  801a4e:	83 ec 04             	sub    $0x4,%esp
  801a51:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a53:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a5a:	74 26                	je     801a82 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a5c:	6a 07                	push   $0x7
  801a5e:	68 00 60 80 00       	push   $0x806000
  801a63:	53                   	push   %ebx
  801a64:	ff 35 04 40 80 00    	pushl  0x804004
  801a6a:	e8 c2 07 00 00       	call   802231 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a6f:	83 c4 0c             	add    $0xc,%esp
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	e8 4b 07 00 00       	call   8021c8 <ipc_recv>
}
  801a7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a82:	83 ec 0c             	sub    $0xc,%esp
  801a85:	6a 02                	push   $0x2
  801a87:	e8 fd 07 00 00       	call   802289 <ipc_find_env>
  801a8c:	a3 04 40 80 00       	mov    %eax,0x804004
  801a91:	83 c4 10             	add    $0x10,%esp
  801a94:	eb c6                	jmp    801a5c <nsipc+0x12>

00801a96 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	56                   	push   %esi
  801a9a:	53                   	push   %ebx
  801a9b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801aa6:	8b 06                	mov    (%esi),%eax
  801aa8:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801aad:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab2:	e8 93 ff ff ff       	call   801a4a <nsipc>
  801ab7:	89 c3                	mov    %eax,%ebx
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	79 09                	jns    801ac6 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801abd:	89 d8                	mov    %ebx,%eax
  801abf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac2:	5b                   	pop    %ebx
  801ac3:	5e                   	pop    %esi
  801ac4:	5d                   	pop    %ebp
  801ac5:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ac6:	83 ec 04             	sub    $0x4,%esp
  801ac9:	ff 35 10 60 80 00    	pushl  0x806010
  801acf:	68 00 60 80 00       	push   $0x806000
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	e8 fc ef ff ff       	call   800ad8 <memmove>
		*addrlen = ret->ret_addrlen;
  801adc:	a1 10 60 80 00       	mov    0x806010,%eax
  801ae1:	89 06                	mov    %eax,(%esi)
  801ae3:	83 c4 10             	add    $0x10,%esp
	return r;
  801ae6:	eb d5                	jmp    801abd <nsipc_accept+0x27>

00801ae8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	53                   	push   %ebx
  801aec:	83 ec 08             	sub    $0x8,%esp
  801aef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801afa:	53                   	push   %ebx
  801afb:	ff 75 0c             	pushl  0xc(%ebp)
  801afe:	68 04 60 80 00       	push   $0x806004
  801b03:	e8 d0 ef ff ff       	call   800ad8 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b08:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b0e:	b8 02 00 00 00       	mov    $0x2,%eax
  801b13:	e8 32 ff ff ff       	call   801a4a <nsipc>
}
  801b18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
  801b20:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b33:	b8 03 00 00 00       	mov    $0x3,%eax
  801b38:	e8 0d ff ff ff       	call   801a4a <nsipc>
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <nsipc_close>:

int
nsipc_close(int s)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b4d:	b8 04 00 00 00       	mov    $0x4,%eax
  801b52:	e8 f3 fe ff ff       	call   801a4a <nsipc>
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	53                   	push   %ebx
  801b5d:	83 ec 08             	sub    $0x8,%esp
  801b60:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b6b:	53                   	push   %ebx
  801b6c:	ff 75 0c             	pushl  0xc(%ebp)
  801b6f:	68 04 60 80 00       	push   $0x806004
  801b74:	e8 5f ef ff ff       	call   800ad8 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b79:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b7f:	b8 05 00 00 00       	mov    $0x5,%eax
  801b84:	e8 c1 fe ff ff       	call   801a4a <nsipc>
}
  801b89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801ba4:	b8 06 00 00 00       	mov    $0x6,%eax
  801ba9:	e8 9c fe ff ff       	call   801a4a <nsipc>
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	56                   	push   %esi
  801bb4:	53                   	push   %ebx
  801bb5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bc0:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bc6:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc9:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bce:	b8 07 00 00 00       	mov    $0x7,%eax
  801bd3:	e8 72 fe ff ff       	call   801a4a <nsipc>
  801bd8:	89 c3                	mov    %eax,%ebx
  801bda:	85 c0                	test   %eax,%eax
  801bdc:	78 1f                	js     801bfd <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bde:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801be3:	7f 21                	jg     801c06 <nsipc_recv+0x56>
  801be5:	39 c6                	cmp    %eax,%esi
  801be7:	7c 1d                	jl     801c06 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801be9:	83 ec 04             	sub    $0x4,%esp
  801bec:	50                   	push   %eax
  801bed:	68 00 60 80 00       	push   $0x806000
  801bf2:	ff 75 0c             	pushl  0xc(%ebp)
  801bf5:	e8 de ee ff ff       	call   800ad8 <memmove>
  801bfa:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801bfd:	89 d8                	mov    %ebx,%eax
  801bff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c02:	5b                   	pop    %ebx
  801c03:	5e                   	pop    %esi
  801c04:	5d                   	pop    %ebp
  801c05:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c06:	68 5f 2a 80 00       	push   $0x802a5f
  801c0b:	68 27 2a 80 00       	push   $0x802a27
  801c10:	6a 62                	push   $0x62
  801c12:	68 74 2a 80 00       	push   $0x802a74
  801c17:	e8 4b 05 00 00       	call   802167 <_panic>

00801c1c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
  801c1f:	53                   	push   %ebx
  801c20:	83 ec 04             	sub    $0x4,%esp
  801c23:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c2e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c34:	7f 2e                	jg     801c64 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c36:	83 ec 04             	sub    $0x4,%esp
  801c39:	53                   	push   %ebx
  801c3a:	ff 75 0c             	pushl  0xc(%ebp)
  801c3d:	68 0c 60 80 00       	push   $0x80600c
  801c42:	e8 91 ee ff ff       	call   800ad8 <memmove>
	nsipcbuf.send.req_size = size;
  801c47:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c50:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c55:	b8 08 00 00 00       	mov    $0x8,%eax
  801c5a:	e8 eb fd ff ff       	call   801a4a <nsipc>
}
  801c5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    
	assert(size < 1600);
  801c64:	68 80 2a 80 00       	push   $0x802a80
  801c69:	68 27 2a 80 00       	push   $0x802a27
  801c6e:	6a 6d                	push   $0x6d
  801c70:	68 74 2a 80 00       	push   $0x802a74
  801c75:	e8 ed 04 00 00       	call   802167 <_panic>

00801c7a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8b:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c90:	8b 45 10             	mov    0x10(%ebp),%eax
  801c93:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c98:	b8 09 00 00 00       	mov    $0x9,%eax
  801c9d:	e8 a8 fd ff ff       	call   801a4a <nsipc>
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	56                   	push   %esi
  801ca8:	53                   	push   %ebx
  801ca9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cac:	83 ec 0c             	sub    $0xc,%esp
  801caf:	ff 75 08             	pushl  0x8(%ebp)
  801cb2:	e8 6a f3 ff ff       	call   801021 <fd2data>
  801cb7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cb9:	83 c4 08             	add    $0x8,%esp
  801cbc:	68 8c 2a 80 00       	push   $0x802a8c
  801cc1:	53                   	push   %ebx
  801cc2:	e8 83 ec ff ff       	call   80094a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cc7:	8b 46 04             	mov    0x4(%esi),%eax
  801cca:	2b 06                	sub    (%esi),%eax
  801ccc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cd2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cd9:	00 00 00 
	stat->st_dev = &devpipe;
  801cdc:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ce3:	30 80 00 
	return 0;
}
  801ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ceb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cee:	5b                   	pop    %ebx
  801cef:	5e                   	pop    %esi
  801cf0:	5d                   	pop    %ebp
  801cf1:	c3                   	ret    

00801cf2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	53                   	push   %ebx
  801cf6:	83 ec 0c             	sub    $0xc,%esp
  801cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cfc:	53                   	push   %ebx
  801cfd:	6a 00                	push   $0x0
  801cff:	e8 bd f0 ff ff       	call   800dc1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d04:	89 1c 24             	mov    %ebx,(%esp)
  801d07:	e8 15 f3 ff ff       	call   801021 <fd2data>
  801d0c:	83 c4 08             	add    $0x8,%esp
  801d0f:	50                   	push   %eax
  801d10:	6a 00                	push   $0x0
  801d12:	e8 aa f0 ff ff       	call   800dc1 <sys_page_unmap>
}
  801d17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <_pipeisclosed>:
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
  801d1f:	57                   	push   %edi
  801d20:	56                   	push   %esi
  801d21:	53                   	push   %ebx
  801d22:	83 ec 1c             	sub    $0x1c,%esp
  801d25:	89 c7                	mov    %eax,%edi
  801d27:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d29:	a1 08 40 80 00       	mov    0x804008,%eax
  801d2e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d31:	83 ec 0c             	sub    $0xc,%esp
  801d34:	57                   	push   %edi
  801d35:	e8 8a 05 00 00       	call   8022c4 <pageref>
  801d3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d3d:	89 34 24             	mov    %esi,(%esp)
  801d40:	e8 7f 05 00 00       	call   8022c4 <pageref>
		nn = thisenv->env_runs;
  801d45:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d4b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d4e:	83 c4 10             	add    $0x10,%esp
  801d51:	39 cb                	cmp    %ecx,%ebx
  801d53:	74 1b                	je     801d70 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d55:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d58:	75 cf                	jne    801d29 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d5a:	8b 42 58             	mov    0x58(%edx),%eax
  801d5d:	6a 01                	push   $0x1
  801d5f:	50                   	push   %eax
  801d60:	53                   	push   %ebx
  801d61:	68 93 2a 80 00       	push   $0x802a93
  801d66:	e8 80 e4 ff ff       	call   8001eb <cprintf>
  801d6b:	83 c4 10             	add    $0x10,%esp
  801d6e:	eb b9                	jmp    801d29 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d70:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d73:	0f 94 c0             	sete   %al
  801d76:	0f b6 c0             	movzbl %al,%eax
}
  801d79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d7c:	5b                   	pop    %ebx
  801d7d:	5e                   	pop    %esi
  801d7e:	5f                   	pop    %edi
  801d7f:	5d                   	pop    %ebp
  801d80:	c3                   	ret    

00801d81 <devpipe_write>:
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	57                   	push   %edi
  801d85:	56                   	push   %esi
  801d86:	53                   	push   %ebx
  801d87:	83 ec 28             	sub    $0x28,%esp
  801d8a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d8d:	56                   	push   %esi
  801d8e:	e8 8e f2 ff ff       	call   801021 <fd2data>
  801d93:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d95:	83 c4 10             	add    $0x10,%esp
  801d98:	bf 00 00 00 00       	mov    $0x0,%edi
  801d9d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801da0:	74 4f                	je     801df1 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801da2:	8b 43 04             	mov    0x4(%ebx),%eax
  801da5:	8b 0b                	mov    (%ebx),%ecx
  801da7:	8d 51 20             	lea    0x20(%ecx),%edx
  801daa:	39 d0                	cmp    %edx,%eax
  801dac:	72 14                	jb     801dc2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dae:	89 da                	mov    %ebx,%edx
  801db0:	89 f0                	mov    %esi,%eax
  801db2:	e8 65 ff ff ff       	call   801d1c <_pipeisclosed>
  801db7:	85 c0                	test   %eax,%eax
  801db9:	75 3b                	jne    801df6 <devpipe_write+0x75>
			sys_yield();
  801dbb:	e8 5d ef ff ff       	call   800d1d <sys_yield>
  801dc0:	eb e0                	jmp    801da2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dc5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dc9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dcc:	89 c2                	mov    %eax,%edx
  801dce:	c1 fa 1f             	sar    $0x1f,%edx
  801dd1:	89 d1                	mov    %edx,%ecx
  801dd3:	c1 e9 1b             	shr    $0x1b,%ecx
  801dd6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dd9:	83 e2 1f             	and    $0x1f,%edx
  801ddc:	29 ca                	sub    %ecx,%edx
  801dde:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801de2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801de6:	83 c0 01             	add    $0x1,%eax
  801de9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dec:	83 c7 01             	add    $0x1,%edi
  801def:	eb ac                	jmp    801d9d <devpipe_write+0x1c>
	return i;
  801df1:	8b 45 10             	mov    0x10(%ebp),%eax
  801df4:	eb 05                	jmp    801dfb <devpipe_write+0x7a>
				return 0;
  801df6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dfe:	5b                   	pop    %ebx
  801dff:	5e                   	pop    %esi
  801e00:	5f                   	pop    %edi
  801e01:	5d                   	pop    %ebp
  801e02:	c3                   	ret    

00801e03 <devpipe_read>:
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	57                   	push   %edi
  801e07:	56                   	push   %esi
  801e08:	53                   	push   %ebx
  801e09:	83 ec 18             	sub    $0x18,%esp
  801e0c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e0f:	57                   	push   %edi
  801e10:	e8 0c f2 ff ff       	call   801021 <fd2data>
  801e15:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e17:	83 c4 10             	add    $0x10,%esp
  801e1a:	be 00 00 00 00       	mov    $0x0,%esi
  801e1f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e22:	75 14                	jne    801e38 <devpipe_read+0x35>
	return i;
  801e24:	8b 45 10             	mov    0x10(%ebp),%eax
  801e27:	eb 02                	jmp    801e2b <devpipe_read+0x28>
				return i;
  801e29:	89 f0                	mov    %esi,%eax
}
  801e2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e2e:	5b                   	pop    %ebx
  801e2f:	5e                   	pop    %esi
  801e30:	5f                   	pop    %edi
  801e31:	5d                   	pop    %ebp
  801e32:	c3                   	ret    
			sys_yield();
  801e33:	e8 e5 ee ff ff       	call   800d1d <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e38:	8b 03                	mov    (%ebx),%eax
  801e3a:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e3d:	75 18                	jne    801e57 <devpipe_read+0x54>
			if (i > 0)
  801e3f:	85 f6                	test   %esi,%esi
  801e41:	75 e6                	jne    801e29 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e43:	89 da                	mov    %ebx,%edx
  801e45:	89 f8                	mov    %edi,%eax
  801e47:	e8 d0 fe ff ff       	call   801d1c <_pipeisclosed>
  801e4c:	85 c0                	test   %eax,%eax
  801e4e:	74 e3                	je     801e33 <devpipe_read+0x30>
				return 0;
  801e50:	b8 00 00 00 00       	mov    $0x0,%eax
  801e55:	eb d4                	jmp    801e2b <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e57:	99                   	cltd   
  801e58:	c1 ea 1b             	shr    $0x1b,%edx
  801e5b:	01 d0                	add    %edx,%eax
  801e5d:	83 e0 1f             	and    $0x1f,%eax
  801e60:	29 d0                	sub    %edx,%eax
  801e62:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e6a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e6d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e70:	83 c6 01             	add    $0x1,%esi
  801e73:	eb aa                	jmp    801e1f <devpipe_read+0x1c>

00801e75 <pipe>:
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	56                   	push   %esi
  801e79:	53                   	push   %ebx
  801e7a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e7d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e80:	50                   	push   %eax
  801e81:	e8 b2 f1 ff ff       	call   801038 <fd_alloc>
  801e86:	89 c3                	mov    %eax,%ebx
  801e88:	83 c4 10             	add    $0x10,%esp
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	0f 88 23 01 00 00    	js     801fb6 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e93:	83 ec 04             	sub    $0x4,%esp
  801e96:	68 07 04 00 00       	push   $0x407
  801e9b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e9e:	6a 00                	push   $0x0
  801ea0:	e8 97 ee ff ff       	call   800d3c <sys_page_alloc>
  801ea5:	89 c3                	mov    %eax,%ebx
  801ea7:	83 c4 10             	add    $0x10,%esp
  801eaa:	85 c0                	test   %eax,%eax
  801eac:	0f 88 04 01 00 00    	js     801fb6 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801eb2:	83 ec 0c             	sub    $0xc,%esp
  801eb5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801eb8:	50                   	push   %eax
  801eb9:	e8 7a f1 ff ff       	call   801038 <fd_alloc>
  801ebe:	89 c3                	mov    %eax,%ebx
  801ec0:	83 c4 10             	add    $0x10,%esp
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	0f 88 db 00 00 00    	js     801fa6 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ecb:	83 ec 04             	sub    $0x4,%esp
  801ece:	68 07 04 00 00       	push   $0x407
  801ed3:	ff 75 f0             	pushl  -0x10(%ebp)
  801ed6:	6a 00                	push   $0x0
  801ed8:	e8 5f ee ff ff       	call   800d3c <sys_page_alloc>
  801edd:	89 c3                	mov    %eax,%ebx
  801edf:	83 c4 10             	add    $0x10,%esp
  801ee2:	85 c0                	test   %eax,%eax
  801ee4:	0f 88 bc 00 00 00    	js     801fa6 <pipe+0x131>
	va = fd2data(fd0);
  801eea:	83 ec 0c             	sub    $0xc,%esp
  801eed:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef0:	e8 2c f1 ff ff       	call   801021 <fd2data>
  801ef5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ef7:	83 c4 0c             	add    $0xc,%esp
  801efa:	68 07 04 00 00       	push   $0x407
  801eff:	50                   	push   %eax
  801f00:	6a 00                	push   $0x0
  801f02:	e8 35 ee ff ff       	call   800d3c <sys_page_alloc>
  801f07:	89 c3                	mov    %eax,%ebx
  801f09:	83 c4 10             	add    $0x10,%esp
  801f0c:	85 c0                	test   %eax,%eax
  801f0e:	0f 88 82 00 00 00    	js     801f96 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	ff 75 f0             	pushl  -0x10(%ebp)
  801f1a:	e8 02 f1 ff ff       	call   801021 <fd2data>
  801f1f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f26:	50                   	push   %eax
  801f27:	6a 00                	push   $0x0
  801f29:	56                   	push   %esi
  801f2a:	6a 00                	push   $0x0
  801f2c:	e8 4e ee ff ff       	call   800d7f <sys_page_map>
  801f31:	89 c3                	mov    %eax,%ebx
  801f33:	83 c4 20             	add    $0x20,%esp
  801f36:	85 c0                	test   %eax,%eax
  801f38:	78 4e                	js     801f88 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f3a:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f42:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f47:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f51:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f56:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f5d:	83 ec 0c             	sub    $0xc,%esp
  801f60:	ff 75 f4             	pushl  -0xc(%ebp)
  801f63:	e8 a9 f0 ff ff       	call   801011 <fd2num>
  801f68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f6b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f6d:	83 c4 04             	add    $0x4,%esp
  801f70:	ff 75 f0             	pushl  -0x10(%ebp)
  801f73:	e8 99 f0 ff ff       	call   801011 <fd2num>
  801f78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f7b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f7e:	83 c4 10             	add    $0x10,%esp
  801f81:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f86:	eb 2e                	jmp    801fb6 <pipe+0x141>
	sys_page_unmap(0, va);
  801f88:	83 ec 08             	sub    $0x8,%esp
  801f8b:	56                   	push   %esi
  801f8c:	6a 00                	push   $0x0
  801f8e:	e8 2e ee ff ff       	call   800dc1 <sys_page_unmap>
  801f93:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f96:	83 ec 08             	sub    $0x8,%esp
  801f99:	ff 75 f0             	pushl  -0x10(%ebp)
  801f9c:	6a 00                	push   $0x0
  801f9e:	e8 1e ee ff ff       	call   800dc1 <sys_page_unmap>
  801fa3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fa6:	83 ec 08             	sub    $0x8,%esp
  801fa9:	ff 75 f4             	pushl  -0xc(%ebp)
  801fac:	6a 00                	push   $0x0
  801fae:	e8 0e ee ff ff       	call   800dc1 <sys_page_unmap>
  801fb3:	83 c4 10             	add    $0x10,%esp
}
  801fb6:	89 d8                	mov    %ebx,%eax
  801fb8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fbb:	5b                   	pop    %ebx
  801fbc:	5e                   	pop    %esi
  801fbd:	5d                   	pop    %ebp
  801fbe:	c3                   	ret    

00801fbf <pipeisclosed>:
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc8:	50                   	push   %eax
  801fc9:	ff 75 08             	pushl  0x8(%ebp)
  801fcc:	e8 b9 f0 ff ff       	call   80108a <fd_lookup>
  801fd1:	83 c4 10             	add    $0x10,%esp
  801fd4:	85 c0                	test   %eax,%eax
  801fd6:	78 18                	js     801ff0 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fd8:	83 ec 0c             	sub    $0xc,%esp
  801fdb:	ff 75 f4             	pushl  -0xc(%ebp)
  801fde:	e8 3e f0 ff ff       	call   801021 <fd2data>
	return _pipeisclosed(fd, p);
  801fe3:	89 c2                	mov    %eax,%edx
  801fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe8:	e8 2f fd ff ff       	call   801d1c <_pipeisclosed>
  801fed:	83 c4 10             	add    $0x10,%esp
}
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff7:	c3                   	ret    

00801ff8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
  801ffb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ffe:	68 ab 2a 80 00       	push   $0x802aab
  802003:	ff 75 0c             	pushl  0xc(%ebp)
  802006:	e8 3f e9 ff ff       	call   80094a <strcpy>
	return 0;
}
  80200b:	b8 00 00 00 00       	mov    $0x0,%eax
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <devcons_write>:
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	57                   	push   %edi
  802016:	56                   	push   %esi
  802017:	53                   	push   %ebx
  802018:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80201e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802023:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802029:	3b 75 10             	cmp    0x10(%ebp),%esi
  80202c:	73 31                	jae    80205f <devcons_write+0x4d>
		m = n - tot;
  80202e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802031:	29 f3                	sub    %esi,%ebx
  802033:	83 fb 7f             	cmp    $0x7f,%ebx
  802036:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80203b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80203e:	83 ec 04             	sub    $0x4,%esp
  802041:	53                   	push   %ebx
  802042:	89 f0                	mov    %esi,%eax
  802044:	03 45 0c             	add    0xc(%ebp),%eax
  802047:	50                   	push   %eax
  802048:	57                   	push   %edi
  802049:	e8 8a ea ff ff       	call   800ad8 <memmove>
		sys_cputs(buf, m);
  80204e:	83 c4 08             	add    $0x8,%esp
  802051:	53                   	push   %ebx
  802052:	57                   	push   %edi
  802053:	e8 28 ec ff ff       	call   800c80 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802058:	01 de                	add    %ebx,%esi
  80205a:	83 c4 10             	add    $0x10,%esp
  80205d:	eb ca                	jmp    802029 <devcons_write+0x17>
}
  80205f:	89 f0                	mov    %esi,%eax
  802061:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802064:	5b                   	pop    %ebx
  802065:	5e                   	pop    %esi
  802066:	5f                   	pop    %edi
  802067:	5d                   	pop    %ebp
  802068:	c3                   	ret    

00802069 <devcons_read>:
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	83 ec 08             	sub    $0x8,%esp
  80206f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802074:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802078:	74 21                	je     80209b <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80207a:	e8 1f ec ff ff       	call   800c9e <sys_cgetc>
  80207f:	85 c0                	test   %eax,%eax
  802081:	75 07                	jne    80208a <devcons_read+0x21>
		sys_yield();
  802083:	e8 95 ec ff ff       	call   800d1d <sys_yield>
  802088:	eb f0                	jmp    80207a <devcons_read+0x11>
	if (c < 0)
  80208a:	78 0f                	js     80209b <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80208c:	83 f8 04             	cmp    $0x4,%eax
  80208f:	74 0c                	je     80209d <devcons_read+0x34>
	*(char*)vbuf = c;
  802091:	8b 55 0c             	mov    0xc(%ebp),%edx
  802094:	88 02                	mov    %al,(%edx)
	return 1;
  802096:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    
		return 0;
  80209d:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a2:	eb f7                	jmp    80209b <devcons_read+0x32>

008020a4 <cputchar>:
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020b0:	6a 01                	push   $0x1
  8020b2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020b5:	50                   	push   %eax
  8020b6:	e8 c5 eb ff ff       	call   800c80 <sys_cputs>
}
  8020bb:	83 c4 10             	add    $0x10,%esp
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <getchar>:
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020c6:	6a 01                	push   $0x1
  8020c8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020cb:	50                   	push   %eax
  8020cc:	6a 00                	push   $0x0
  8020ce:	e8 27 f2 ff ff       	call   8012fa <read>
	if (r < 0)
  8020d3:	83 c4 10             	add    $0x10,%esp
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	78 06                	js     8020e0 <getchar+0x20>
	if (r < 1)
  8020da:	74 06                	je     8020e2 <getchar+0x22>
	return c;
  8020dc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    
		return -E_EOF;
  8020e2:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020e7:	eb f7                	jmp    8020e0 <getchar+0x20>

008020e9 <iscons>:
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f2:	50                   	push   %eax
  8020f3:	ff 75 08             	pushl  0x8(%ebp)
  8020f6:	e8 8f ef ff ff       	call   80108a <fd_lookup>
  8020fb:	83 c4 10             	add    $0x10,%esp
  8020fe:	85 c0                	test   %eax,%eax
  802100:	78 11                	js     802113 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802105:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80210b:	39 10                	cmp    %edx,(%eax)
  80210d:	0f 94 c0             	sete   %al
  802110:	0f b6 c0             	movzbl %al,%eax
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <opencons>:
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80211b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80211e:	50                   	push   %eax
  80211f:	e8 14 ef ff ff       	call   801038 <fd_alloc>
  802124:	83 c4 10             	add    $0x10,%esp
  802127:	85 c0                	test   %eax,%eax
  802129:	78 3a                	js     802165 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80212b:	83 ec 04             	sub    $0x4,%esp
  80212e:	68 07 04 00 00       	push   $0x407
  802133:	ff 75 f4             	pushl  -0xc(%ebp)
  802136:	6a 00                	push   $0x0
  802138:	e8 ff eb ff ff       	call   800d3c <sys_page_alloc>
  80213d:	83 c4 10             	add    $0x10,%esp
  802140:	85 c0                	test   %eax,%eax
  802142:	78 21                	js     802165 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802147:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80214d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802159:	83 ec 0c             	sub    $0xc,%esp
  80215c:	50                   	push   %eax
  80215d:	e8 af ee ff ff       	call   801011 <fd2num>
  802162:	83 c4 10             	add    $0x10,%esp
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	56                   	push   %esi
  80216b:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80216c:	a1 08 40 80 00       	mov    0x804008,%eax
  802171:	8b 40 48             	mov    0x48(%eax),%eax
  802174:	83 ec 04             	sub    $0x4,%esp
  802177:	68 e8 2a 80 00       	push   $0x802ae8
  80217c:	50                   	push   %eax
  80217d:	68 b7 2a 80 00       	push   $0x802ab7
  802182:	e8 64 e0 ff ff       	call   8001eb <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802187:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80218a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802190:	e8 69 eb ff ff       	call   800cfe <sys_getenvid>
  802195:	83 c4 04             	add    $0x4,%esp
  802198:	ff 75 0c             	pushl  0xc(%ebp)
  80219b:	ff 75 08             	pushl  0x8(%ebp)
  80219e:	56                   	push   %esi
  80219f:	50                   	push   %eax
  8021a0:	68 c4 2a 80 00       	push   $0x802ac4
  8021a5:	e8 41 e0 ff ff       	call   8001eb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021aa:	83 c4 18             	add    $0x18,%esp
  8021ad:	53                   	push   %ebx
  8021ae:	ff 75 10             	pushl  0x10(%ebp)
  8021b1:	e8 e4 df ff ff       	call   80019a <vcprintf>
	cprintf("\n");
  8021b6:	c7 04 24 e3 25 80 00 	movl   $0x8025e3,(%esp)
  8021bd:	e8 29 e0 ff ff       	call   8001eb <cprintf>
  8021c2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021c5:	cc                   	int3   
  8021c6:	eb fd                	jmp    8021c5 <_panic+0x5e>

008021c8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	56                   	push   %esi
  8021cc:	53                   	push   %ebx
  8021cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8021d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021d6:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021d8:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021dd:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021e0:	83 ec 0c             	sub    $0xc,%esp
  8021e3:	50                   	push   %eax
  8021e4:	e8 03 ed ff ff       	call   800eec <sys_ipc_recv>
	if(ret < 0){
  8021e9:	83 c4 10             	add    $0x10,%esp
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	78 2b                	js     80221b <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021f0:	85 f6                	test   %esi,%esi
  8021f2:	74 0a                	je     8021fe <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8021f4:	a1 08 40 80 00       	mov    0x804008,%eax
  8021f9:	8b 40 74             	mov    0x74(%eax),%eax
  8021fc:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021fe:	85 db                	test   %ebx,%ebx
  802200:	74 0a                	je     80220c <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802202:	a1 08 40 80 00       	mov    0x804008,%eax
  802207:	8b 40 78             	mov    0x78(%eax),%eax
  80220a:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80220c:	a1 08 40 80 00       	mov    0x804008,%eax
  802211:	8b 40 70             	mov    0x70(%eax),%eax
}
  802214:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802217:	5b                   	pop    %ebx
  802218:	5e                   	pop    %esi
  802219:	5d                   	pop    %ebp
  80221a:	c3                   	ret    
		if(from_env_store)
  80221b:	85 f6                	test   %esi,%esi
  80221d:	74 06                	je     802225 <ipc_recv+0x5d>
			*from_env_store = 0;
  80221f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802225:	85 db                	test   %ebx,%ebx
  802227:	74 eb                	je     802214 <ipc_recv+0x4c>
			*perm_store = 0;
  802229:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80222f:	eb e3                	jmp    802214 <ipc_recv+0x4c>

00802231 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
  802234:	57                   	push   %edi
  802235:	56                   	push   %esi
  802236:	53                   	push   %ebx
  802237:	83 ec 0c             	sub    $0xc,%esp
  80223a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80223d:	8b 75 0c             	mov    0xc(%ebp),%esi
  802240:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802243:	85 db                	test   %ebx,%ebx
  802245:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80224a:	0f 44 d8             	cmove  %eax,%ebx
  80224d:	eb 05                	jmp    802254 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80224f:	e8 c9 ea ff ff       	call   800d1d <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802254:	ff 75 14             	pushl  0x14(%ebp)
  802257:	53                   	push   %ebx
  802258:	56                   	push   %esi
  802259:	57                   	push   %edi
  80225a:	e8 6a ec ff ff       	call   800ec9 <sys_ipc_try_send>
  80225f:	83 c4 10             	add    $0x10,%esp
  802262:	85 c0                	test   %eax,%eax
  802264:	74 1b                	je     802281 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802266:	79 e7                	jns    80224f <ipc_send+0x1e>
  802268:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80226b:	74 e2                	je     80224f <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80226d:	83 ec 04             	sub    $0x4,%esp
  802270:	68 ef 2a 80 00       	push   $0x802aef
  802275:	6a 48                	push   $0x48
  802277:	68 04 2b 80 00       	push   $0x802b04
  80227c:	e8 e6 fe ff ff       	call   802167 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802281:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802284:	5b                   	pop    %ebx
  802285:	5e                   	pop    %esi
  802286:	5f                   	pop    %edi
  802287:	5d                   	pop    %ebp
  802288:	c3                   	ret    

00802289 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80228f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802294:	89 c2                	mov    %eax,%edx
  802296:	c1 e2 07             	shl    $0x7,%edx
  802299:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80229f:	8b 52 50             	mov    0x50(%edx),%edx
  8022a2:	39 ca                	cmp    %ecx,%edx
  8022a4:	74 11                	je     8022b7 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022a6:	83 c0 01             	add    $0x1,%eax
  8022a9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022ae:	75 e4                	jne    802294 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b5:	eb 0b                	jmp    8022c2 <ipc_find_env+0x39>
			return envs[i].env_id;
  8022b7:	c1 e0 07             	shl    $0x7,%eax
  8022ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022bf:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022c2:	5d                   	pop    %ebp
  8022c3:	c3                   	ret    

008022c4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
  8022c7:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022ca:	89 d0                	mov    %edx,%eax
  8022cc:	c1 e8 16             	shr    $0x16,%eax
  8022cf:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022d6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022db:	f6 c1 01             	test   $0x1,%cl
  8022de:	74 1d                	je     8022fd <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022e0:	c1 ea 0c             	shr    $0xc,%edx
  8022e3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022ea:	f6 c2 01             	test   $0x1,%dl
  8022ed:	74 0e                	je     8022fd <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022ef:	c1 ea 0c             	shr    $0xc,%edx
  8022f2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022f9:	ef 
  8022fa:	0f b7 c0             	movzwl %ax,%eax
}
  8022fd:	5d                   	pop    %ebp
  8022fe:	c3                   	ret    
  8022ff:	90                   	nop

00802300 <__udivdi3>:
  802300:	55                   	push   %ebp
  802301:	57                   	push   %edi
  802302:	56                   	push   %esi
  802303:	53                   	push   %ebx
  802304:	83 ec 1c             	sub    $0x1c,%esp
  802307:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80230b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80230f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802313:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802317:	85 d2                	test   %edx,%edx
  802319:	75 4d                	jne    802368 <__udivdi3+0x68>
  80231b:	39 f3                	cmp    %esi,%ebx
  80231d:	76 19                	jbe    802338 <__udivdi3+0x38>
  80231f:	31 ff                	xor    %edi,%edi
  802321:	89 e8                	mov    %ebp,%eax
  802323:	89 f2                	mov    %esi,%edx
  802325:	f7 f3                	div    %ebx
  802327:	89 fa                	mov    %edi,%edx
  802329:	83 c4 1c             	add    $0x1c,%esp
  80232c:	5b                   	pop    %ebx
  80232d:	5e                   	pop    %esi
  80232e:	5f                   	pop    %edi
  80232f:	5d                   	pop    %ebp
  802330:	c3                   	ret    
  802331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802338:	89 d9                	mov    %ebx,%ecx
  80233a:	85 db                	test   %ebx,%ebx
  80233c:	75 0b                	jne    802349 <__udivdi3+0x49>
  80233e:	b8 01 00 00 00       	mov    $0x1,%eax
  802343:	31 d2                	xor    %edx,%edx
  802345:	f7 f3                	div    %ebx
  802347:	89 c1                	mov    %eax,%ecx
  802349:	31 d2                	xor    %edx,%edx
  80234b:	89 f0                	mov    %esi,%eax
  80234d:	f7 f1                	div    %ecx
  80234f:	89 c6                	mov    %eax,%esi
  802351:	89 e8                	mov    %ebp,%eax
  802353:	89 f7                	mov    %esi,%edi
  802355:	f7 f1                	div    %ecx
  802357:	89 fa                	mov    %edi,%edx
  802359:	83 c4 1c             	add    $0x1c,%esp
  80235c:	5b                   	pop    %ebx
  80235d:	5e                   	pop    %esi
  80235e:	5f                   	pop    %edi
  80235f:	5d                   	pop    %ebp
  802360:	c3                   	ret    
  802361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802368:	39 f2                	cmp    %esi,%edx
  80236a:	77 1c                	ja     802388 <__udivdi3+0x88>
  80236c:	0f bd fa             	bsr    %edx,%edi
  80236f:	83 f7 1f             	xor    $0x1f,%edi
  802372:	75 2c                	jne    8023a0 <__udivdi3+0xa0>
  802374:	39 f2                	cmp    %esi,%edx
  802376:	72 06                	jb     80237e <__udivdi3+0x7e>
  802378:	31 c0                	xor    %eax,%eax
  80237a:	39 eb                	cmp    %ebp,%ebx
  80237c:	77 a9                	ja     802327 <__udivdi3+0x27>
  80237e:	b8 01 00 00 00       	mov    $0x1,%eax
  802383:	eb a2                	jmp    802327 <__udivdi3+0x27>
  802385:	8d 76 00             	lea    0x0(%esi),%esi
  802388:	31 ff                	xor    %edi,%edi
  80238a:	31 c0                	xor    %eax,%eax
  80238c:	89 fa                	mov    %edi,%edx
  80238e:	83 c4 1c             	add    $0x1c,%esp
  802391:	5b                   	pop    %ebx
  802392:	5e                   	pop    %esi
  802393:	5f                   	pop    %edi
  802394:	5d                   	pop    %ebp
  802395:	c3                   	ret    
  802396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80239d:	8d 76 00             	lea    0x0(%esi),%esi
  8023a0:	89 f9                	mov    %edi,%ecx
  8023a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023a7:	29 f8                	sub    %edi,%eax
  8023a9:	d3 e2                	shl    %cl,%edx
  8023ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023af:	89 c1                	mov    %eax,%ecx
  8023b1:	89 da                	mov    %ebx,%edx
  8023b3:	d3 ea                	shr    %cl,%edx
  8023b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023b9:	09 d1                	or     %edx,%ecx
  8023bb:	89 f2                	mov    %esi,%edx
  8023bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023c1:	89 f9                	mov    %edi,%ecx
  8023c3:	d3 e3                	shl    %cl,%ebx
  8023c5:	89 c1                	mov    %eax,%ecx
  8023c7:	d3 ea                	shr    %cl,%edx
  8023c9:	89 f9                	mov    %edi,%ecx
  8023cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023cf:	89 eb                	mov    %ebp,%ebx
  8023d1:	d3 e6                	shl    %cl,%esi
  8023d3:	89 c1                	mov    %eax,%ecx
  8023d5:	d3 eb                	shr    %cl,%ebx
  8023d7:	09 de                	or     %ebx,%esi
  8023d9:	89 f0                	mov    %esi,%eax
  8023db:	f7 74 24 08          	divl   0x8(%esp)
  8023df:	89 d6                	mov    %edx,%esi
  8023e1:	89 c3                	mov    %eax,%ebx
  8023e3:	f7 64 24 0c          	mull   0xc(%esp)
  8023e7:	39 d6                	cmp    %edx,%esi
  8023e9:	72 15                	jb     802400 <__udivdi3+0x100>
  8023eb:	89 f9                	mov    %edi,%ecx
  8023ed:	d3 e5                	shl    %cl,%ebp
  8023ef:	39 c5                	cmp    %eax,%ebp
  8023f1:	73 04                	jae    8023f7 <__udivdi3+0xf7>
  8023f3:	39 d6                	cmp    %edx,%esi
  8023f5:	74 09                	je     802400 <__udivdi3+0x100>
  8023f7:	89 d8                	mov    %ebx,%eax
  8023f9:	31 ff                	xor    %edi,%edi
  8023fb:	e9 27 ff ff ff       	jmp    802327 <__udivdi3+0x27>
  802400:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802403:	31 ff                	xor    %edi,%edi
  802405:	e9 1d ff ff ff       	jmp    802327 <__udivdi3+0x27>
  80240a:	66 90                	xchg   %ax,%ax
  80240c:	66 90                	xchg   %ax,%ax
  80240e:	66 90                	xchg   %ax,%ax

00802410 <__umoddi3>:
  802410:	55                   	push   %ebp
  802411:	57                   	push   %edi
  802412:	56                   	push   %esi
  802413:	53                   	push   %ebx
  802414:	83 ec 1c             	sub    $0x1c,%esp
  802417:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80241b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80241f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802423:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802427:	89 da                	mov    %ebx,%edx
  802429:	85 c0                	test   %eax,%eax
  80242b:	75 43                	jne    802470 <__umoddi3+0x60>
  80242d:	39 df                	cmp    %ebx,%edi
  80242f:	76 17                	jbe    802448 <__umoddi3+0x38>
  802431:	89 f0                	mov    %esi,%eax
  802433:	f7 f7                	div    %edi
  802435:	89 d0                	mov    %edx,%eax
  802437:	31 d2                	xor    %edx,%edx
  802439:	83 c4 1c             	add    $0x1c,%esp
  80243c:	5b                   	pop    %ebx
  80243d:	5e                   	pop    %esi
  80243e:	5f                   	pop    %edi
  80243f:	5d                   	pop    %ebp
  802440:	c3                   	ret    
  802441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802448:	89 fd                	mov    %edi,%ebp
  80244a:	85 ff                	test   %edi,%edi
  80244c:	75 0b                	jne    802459 <__umoddi3+0x49>
  80244e:	b8 01 00 00 00       	mov    $0x1,%eax
  802453:	31 d2                	xor    %edx,%edx
  802455:	f7 f7                	div    %edi
  802457:	89 c5                	mov    %eax,%ebp
  802459:	89 d8                	mov    %ebx,%eax
  80245b:	31 d2                	xor    %edx,%edx
  80245d:	f7 f5                	div    %ebp
  80245f:	89 f0                	mov    %esi,%eax
  802461:	f7 f5                	div    %ebp
  802463:	89 d0                	mov    %edx,%eax
  802465:	eb d0                	jmp    802437 <__umoddi3+0x27>
  802467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80246e:	66 90                	xchg   %ax,%ax
  802470:	89 f1                	mov    %esi,%ecx
  802472:	39 d8                	cmp    %ebx,%eax
  802474:	76 0a                	jbe    802480 <__umoddi3+0x70>
  802476:	89 f0                	mov    %esi,%eax
  802478:	83 c4 1c             	add    $0x1c,%esp
  80247b:	5b                   	pop    %ebx
  80247c:	5e                   	pop    %esi
  80247d:	5f                   	pop    %edi
  80247e:	5d                   	pop    %ebp
  80247f:	c3                   	ret    
  802480:	0f bd e8             	bsr    %eax,%ebp
  802483:	83 f5 1f             	xor    $0x1f,%ebp
  802486:	75 20                	jne    8024a8 <__umoddi3+0x98>
  802488:	39 d8                	cmp    %ebx,%eax
  80248a:	0f 82 b0 00 00 00    	jb     802540 <__umoddi3+0x130>
  802490:	39 f7                	cmp    %esi,%edi
  802492:	0f 86 a8 00 00 00    	jbe    802540 <__umoddi3+0x130>
  802498:	89 c8                	mov    %ecx,%eax
  80249a:	83 c4 1c             	add    $0x1c,%esp
  80249d:	5b                   	pop    %ebx
  80249e:	5e                   	pop    %esi
  80249f:	5f                   	pop    %edi
  8024a0:	5d                   	pop    %ebp
  8024a1:	c3                   	ret    
  8024a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024a8:	89 e9                	mov    %ebp,%ecx
  8024aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8024af:	29 ea                	sub    %ebp,%edx
  8024b1:	d3 e0                	shl    %cl,%eax
  8024b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024b7:	89 d1                	mov    %edx,%ecx
  8024b9:	89 f8                	mov    %edi,%eax
  8024bb:	d3 e8                	shr    %cl,%eax
  8024bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024c9:	09 c1                	or     %eax,%ecx
  8024cb:	89 d8                	mov    %ebx,%eax
  8024cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024d1:	89 e9                	mov    %ebp,%ecx
  8024d3:	d3 e7                	shl    %cl,%edi
  8024d5:	89 d1                	mov    %edx,%ecx
  8024d7:	d3 e8                	shr    %cl,%eax
  8024d9:	89 e9                	mov    %ebp,%ecx
  8024db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024df:	d3 e3                	shl    %cl,%ebx
  8024e1:	89 c7                	mov    %eax,%edi
  8024e3:	89 d1                	mov    %edx,%ecx
  8024e5:	89 f0                	mov    %esi,%eax
  8024e7:	d3 e8                	shr    %cl,%eax
  8024e9:	89 e9                	mov    %ebp,%ecx
  8024eb:	89 fa                	mov    %edi,%edx
  8024ed:	d3 e6                	shl    %cl,%esi
  8024ef:	09 d8                	or     %ebx,%eax
  8024f1:	f7 74 24 08          	divl   0x8(%esp)
  8024f5:	89 d1                	mov    %edx,%ecx
  8024f7:	89 f3                	mov    %esi,%ebx
  8024f9:	f7 64 24 0c          	mull   0xc(%esp)
  8024fd:	89 c6                	mov    %eax,%esi
  8024ff:	89 d7                	mov    %edx,%edi
  802501:	39 d1                	cmp    %edx,%ecx
  802503:	72 06                	jb     80250b <__umoddi3+0xfb>
  802505:	75 10                	jne    802517 <__umoddi3+0x107>
  802507:	39 c3                	cmp    %eax,%ebx
  802509:	73 0c                	jae    802517 <__umoddi3+0x107>
  80250b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80250f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802513:	89 d7                	mov    %edx,%edi
  802515:	89 c6                	mov    %eax,%esi
  802517:	89 ca                	mov    %ecx,%edx
  802519:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80251e:	29 f3                	sub    %esi,%ebx
  802520:	19 fa                	sbb    %edi,%edx
  802522:	89 d0                	mov    %edx,%eax
  802524:	d3 e0                	shl    %cl,%eax
  802526:	89 e9                	mov    %ebp,%ecx
  802528:	d3 eb                	shr    %cl,%ebx
  80252a:	d3 ea                	shr    %cl,%edx
  80252c:	09 d8                	or     %ebx,%eax
  80252e:	83 c4 1c             	add    $0x1c,%esp
  802531:	5b                   	pop    %ebx
  802532:	5e                   	pop    %esi
  802533:	5f                   	pop    %edi
  802534:	5d                   	pop    %ebp
  802535:	c3                   	ret    
  802536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80253d:	8d 76 00             	lea    0x0(%esi),%esi
  802540:	89 da                	mov    %ebx,%edx
  802542:	29 fe                	sub    %edi,%esi
  802544:	19 c2                	sbb    %eax,%edx
  802546:	89 f1                	mov    %esi,%ecx
  802548:	89 c8                	mov    %ecx,%eax
  80254a:	e9 4b ff ff ff       	jmp    80249a <__umoddi3+0x8a>
