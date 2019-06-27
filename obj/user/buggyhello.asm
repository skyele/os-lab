
obj/user/buggyhello.debug:     file format elf32-i386


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
  80002c:	e8 16 00 00 00       	call   800047 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  800039:	6a 01                	push   $0x1
  80003b:	6a 01                	push   $0x1
  80003d:	e8 3e 0c 00 00       	call   800c80 <sys_cputs>
}
  800042:	83 c4 10             	add    $0x10,%esp
  800045:	c9                   	leave  
  800046:	c3                   	ret    

00800047 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800047:	55                   	push   %ebp
  800048:	89 e5                	mov    %esp,%ebp
  80004a:	57                   	push   %edi
  80004b:	56                   	push   %esi
  80004c:	53                   	push   %ebx
  80004d:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800050:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800057:	00 00 00 
	envid_t find = sys_getenvid();
  80005a:	e8 9f 0c 00 00       	call   800cfe <sys_getenvid>
  80005f:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800065:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80006a:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80006f:	bf 01 00 00 00       	mov    $0x1,%edi
  800074:	eb 0b                	jmp    800081 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800076:	83 c2 01             	add    $0x1,%edx
  800079:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80007f:	74 23                	je     8000a4 <libmain+0x5d>
		if(envs[i].env_id == find)
  800081:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800087:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80008d:	8b 49 48             	mov    0x48(%ecx),%ecx
  800090:	39 c1                	cmp    %eax,%ecx
  800092:	75 e2                	jne    800076 <libmain+0x2f>
  800094:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  80009a:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000a0:	89 fe                	mov    %edi,%esi
  8000a2:	eb d2                	jmp    800076 <libmain+0x2f>
  8000a4:	89 f0                	mov    %esi,%eax
  8000a6:	84 c0                	test   %al,%al
  8000a8:	74 06                	je     8000b0 <libmain+0x69>
  8000aa:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b4:	7e 0a                	jle    8000c0 <libmain+0x79>
		binaryname = argv[0];
  8000b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b9:	8b 00                	mov    (%eax),%eax
  8000bb:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000c0:	a1 08 40 80 00       	mov    0x804008,%eax
  8000c5:	8b 40 48             	mov    0x48(%eax),%eax
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	50                   	push   %eax
  8000cc:	68 80 25 80 00       	push   $0x802580
  8000d1:	e8 15 01 00 00       	call   8001eb <cprintf>
	cprintf("before umain\n");
  8000d6:	c7 04 24 9e 25 80 00 	movl   $0x80259e,(%esp)
  8000dd:	e8 09 01 00 00       	call   8001eb <cprintf>
	// call user main routine
	umain(argc, argv);
  8000e2:	83 c4 08             	add    $0x8,%esp
  8000e5:	ff 75 0c             	pushl  0xc(%ebp)
  8000e8:	ff 75 08             	pushl  0x8(%ebp)
  8000eb:	e8 43 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000f0:	c7 04 24 ac 25 80 00 	movl   $0x8025ac,(%esp)
  8000f7:	e8 ef 00 00 00       	call   8001eb <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8000fc:	a1 08 40 80 00       	mov    0x804008,%eax
  800101:	8b 40 48             	mov    0x48(%eax),%eax
  800104:	83 c4 08             	add    $0x8,%esp
  800107:	50                   	push   %eax
  800108:	68 b9 25 80 00       	push   $0x8025b9
  80010d:	e8 d9 00 00 00       	call   8001eb <cprintf>
	// exit gracefully
	exit();
  800112:	e8 0b 00 00 00       	call   800122 <exit>
}
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80011d:	5b                   	pop    %ebx
  80011e:	5e                   	pop    %esi
  80011f:	5f                   	pop    %edi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    

00800122 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800128:	a1 08 40 80 00       	mov    0x804008,%eax
  80012d:	8b 40 48             	mov    0x48(%eax),%eax
  800130:	68 e4 25 80 00       	push   $0x8025e4
  800135:	50                   	push   %eax
  800136:	68 d8 25 80 00       	push   $0x8025d8
  80013b:	e8 ab 00 00 00       	call   8001eb <cprintf>
	close_all();
  800140:	e8 c4 10 00 00       	call   801209 <close_all>
	sys_env_destroy(0);
  800145:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
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
  800298:	e8 93 20 00 00       	call   802330 <__udivdi3>
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
  8002c1:	e8 7a 21 00 00       	call   802440 <__umoddi3>
  8002c6:	83 c4 14             	add    $0x14,%esp
  8002c9:	0f be 80 e9 25 80 00 	movsbl 0x8025e9(%eax),%eax
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
  800438:	83 f8 11             	cmp    $0x11,%eax
  80043b:	7f 23                	jg     800460 <vprintfmt+0x148>
  80043d:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  800444:	85 d2                	test   %edx,%edx
  800446:	74 18                	je     800460 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800448:	52                   	push   %edx
  800449:	68 3d 2a 80 00       	push   $0x802a3d
  80044e:	53                   	push   %ebx
  80044f:	56                   	push   %esi
  800450:	e8 a6 fe ff ff       	call   8002fb <printfmt>
  800455:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800458:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045b:	e9 fe 02 00 00       	jmp    80075e <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800460:	50                   	push   %eax
  800461:	68 01 26 80 00       	push   $0x802601
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
  800488:	b8 fa 25 80 00       	mov    $0x8025fa,%eax
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
  800820:	bf 1d 27 80 00       	mov    $0x80271d,%edi
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
  80084c:	bf 55 27 80 00       	mov    $0x802755,%edi
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
  800ced:	68 68 29 80 00       	push   $0x802968
  800cf2:	6a 43                	push   $0x43
  800cf4:	68 85 29 80 00       	push   $0x802985
  800cf9:	e8 89 14 00 00       	call   802187 <_panic>

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
  800d6e:	68 68 29 80 00       	push   $0x802968
  800d73:	6a 43                	push   $0x43
  800d75:	68 85 29 80 00       	push   $0x802985
  800d7a:	e8 08 14 00 00       	call   802187 <_panic>

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
  800db0:	68 68 29 80 00       	push   $0x802968
  800db5:	6a 43                	push   $0x43
  800db7:	68 85 29 80 00       	push   $0x802985
  800dbc:	e8 c6 13 00 00       	call   802187 <_panic>

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
  800df2:	68 68 29 80 00       	push   $0x802968
  800df7:	6a 43                	push   $0x43
  800df9:	68 85 29 80 00       	push   $0x802985
  800dfe:	e8 84 13 00 00       	call   802187 <_panic>

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
  800e34:	68 68 29 80 00       	push   $0x802968
  800e39:	6a 43                	push   $0x43
  800e3b:	68 85 29 80 00       	push   $0x802985
  800e40:	e8 42 13 00 00       	call   802187 <_panic>

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
  800e76:	68 68 29 80 00       	push   $0x802968
  800e7b:	6a 43                	push   $0x43
  800e7d:	68 85 29 80 00       	push   $0x802985
  800e82:	e8 00 13 00 00       	call   802187 <_panic>

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
  800eb8:	68 68 29 80 00       	push   $0x802968
  800ebd:	6a 43                	push   $0x43
  800ebf:	68 85 29 80 00       	push   $0x802985
  800ec4:	e8 be 12 00 00       	call   802187 <_panic>

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
  800f1c:	68 68 29 80 00       	push   $0x802968
  800f21:	6a 43                	push   $0x43
  800f23:	68 85 29 80 00       	push   $0x802985
  800f28:	e8 5a 12 00 00       	call   802187 <_panic>

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
  801000:	68 68 29 80 00       	push   $0x802968
  801005:	6a 43                	push   $0x43
  801007:	68 85 29 80 00       	push   $0x802985
  80100c:	e8 76 11 00 00       	call   802187 <_panic>

00801011 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	57                   	push   %edi
  801015:	56                   	push   %esi
  801016:	53                   	push   %ebx
	asm volatile("int %1\n"
  801017:	b9 00 00 00 00       	mov    $0x0,%ecx
  80101c:	8b 55 08             	mov    0x8(%ebp),%edx
  80101f:	b8 14 00 00 00       	mov    $0x14,%eax
  801024:	89 cb                	mov    %ecx,%ebx
  801026:	89 cf                	mov    %ecx,%edi
  801028:	89 ce                	mov    %ecx,%esi
  80102a:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    

00801031 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	05 00 00 00 30       	add    $0x30000000,%eax
  80103c:	c1 e8 0c             	shr    $0xc,%eax
}
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    

00801041 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80104c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801051:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801056:	5d                   	pop    %ebp
  801057:	c3                   	ret    

00801058 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801060:	89 c2                	mov    %eax,%edx
  801062:	c1 ea 16             	shr    $0x16,%edx
  801065:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80106c:	f6 c2 01             	test   $0x1,%dl
  80106f:	74 2d                	je     80109e <fd_alloc+0x46>
  801071:	89 c2                	mov    %eax,%edx
  801073:	c1 ea 0c             	shr    $0xc,%edx
  801076:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80107d:	f6 c2 01             	test   $0x1,%dl
  801080:	74 1c                	je     80109e <fd_alloc+0x46>
  801082:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801087:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80108c:	75 d2                	jne    801060 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801097:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80109c:	eb 0a                	jmp    8010a8 <fd_alloc+0x50>
			*fd_store = fd;
  80109e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a8:	5d                   	pop    %ebp
  8010a9:	c3                   	ret    

008010aa <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010b0:	83 f8 1f             	cmp    $0x1f,%eax
  8010b3:	77 30                	ja     8010e5 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010b5:	c1 e0 0c             	shl    $0xc,%eax
  8010b8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010bd:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010c3:	f6 c2 01             	test   $0x1,%dl
  8010c6:	74 24                	je     8010ec <fd_lookup+0x42>
  8010c8:	89 c2                	mov    %eax,%edx
  8010ca:	c1 ea 0c             	shr    $0xc,%edx
  8010cd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010d4:	f6 c2 01             	test   $0x1,%dl
  8010d7:	74 1a                	je     8010f3 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010dc:	89 02                	mov    %eax,(%edx)
	return 0;
  8010de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e3:	5d                   	pop    %ebp
  8010e4:	c3                   	ret    
		return -E_INVAL;
  8010e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ea:	eb f7                	jmp    8010e3 <fd_lookup+0x39>
		return -E_INVAL;
  8010ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f1:	eb f0                	jmp    8010e3 <fd_lookup+0x39>
  8010f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f8:	eb e9                	jmp    8010e3 <fd_lookup+0x39>

008010fa <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	83 ec 08             	sub    $0x8,%esp
  801100:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801103:	ba 00 00 00 00       	mov    $0x0,%edx
  801108:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80110d:	39 08                	cmp    %ecx,(%eax)
  80110f:	74 38                	je     801149 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801111:	83 c2 01             	add    $0x1,%edx
  801114:	8b 04 95 10 2a 80 00 	mov    0x802a10(,%edx,4),%eax
  80111b:	85 c0                	test   %eax,%eax
  80111d:	75 ee                	jne    80110d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80111f:	a1 08 40 80 00       	mov    0x804008,%eax
  801124:	8b 40 48             	mov    0x48(%eax),%eax
  801127:	83 ec 04             	sub    $0x4,%esp
  80112a:	51                   	push   %ecx
  80112b:	50                   	push   %eax
  80112c:	68 94 29 80 00       	push   $0x802994
  801131:	e8 b5 f0 ff ff       	call   8001eb <cprintf>
	*dev = 0;
  801136:	8b 45 0c             	mov    0xc(%ebp),%eax
  801139:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80113f:	83 c4 10             	add    $0x10,%esp
  801142:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801147:	c9                   	leave  
  801148:	c3                   	ret    
			*dev = devtab[i];
  801149:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80114e:	b8 00 00 00 00       	mov    $0x0,%eax
  801153:	eb f2                	jmp    801147 <dev_lookup+0x4d>

00801155 <fd_close>:
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
  801158:	57                   	push   %edi
  801159:	56                   	push   %esi
  80115a:	53                   	push   %ebx
  80115b:	83 ec 24             	sub    $0x24,%esp
  80115e:	8b 75 08             	mov    0x8(%ebp),%esi
  801161:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801164:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801167:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801168:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80116e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801171:	50                   	push   %eax
  801172:	e8 33 ff ff ff       	call   8010aa <fd_lookup>
  801177:	89 c3                	mov    %eax,%ebx
  801179:	83 c4 10             	add    $0x10,%esp
  80117c:	85 c0                	test   %eax,%eax
  80117e:	78 05                	js     801185 <fd_close+0x30>
	    || fd != fd2)
  801180:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801183:	74 16                	je     80119b <fd_close+0x46>
		return (must_exist ? r : 0);
  801185:	89 f8                	mov    %edi,%eax
  801187:	84 c0                	test   %al,%al
  801189:	b8 00 00 00 00       	mov    $0x0,%eax
  80118e:	0f 44 d8             	cmove  %eax,%ebx
}
  801191:	89 d8                	mov    %ebx,%eax
  801193:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801196:	5b                   	pop    %ebx
  801197:	5e                   	pop    %esi
  801198:	5f                   	pop    %edi
  801199:	5d                   	pop    %ebp
  80119a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80119b:	83 ec 08             	sub    $0x8,%esp
  80119e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011a1:	50                   	push   %eax
  8011a2:	ff 36                	pushl  (%esi)
  8011a4:	e8 51 ff ff ff       	call   8010fa <dev_lookup>
  8011a9:	89 c3                	mov    %eax,%ebx
  8011ab:	83 c4 10             	add    $0x10,%esp
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	78 1a                	js     8011cc <fd_close+0x77>
		if (dev->dev_close)
  8011b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011b5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011b8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	74 0b                	je     8011cc <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011c1:	83 ec 0c             	sub    $0xc,%esp
  8011c4:	56                   	push   %esi
  8011c5:	ff d0                	call   *%eax
  8011c7:	89 c3                	mov    %eax,%ebx
  8011c9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011cc:	83 ec 08             	sub    $0x8,%esp
  8011cf:	56                   	push   %esi
  8011d0:	6a 00                	push   $0x0
  8011d2:	e8 ea fb ff ff       	call   800dc1 <sys_page_unmap>
	return r;
  8011d7:	83 c4 10             	add    $0x10,%esp
  8011da:	eb b5                	jmp    801191 <fd_close+0x3c>

008011dc <close>:

int
close(int fdnum)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e5:	50                   	push   %eax
  8011e6:	ff 75 08             	pushl  0x8(%ebp)
  8011e9:	e8 bc fe ff ff       	call   8010aa <fd_lookup>
  8011ee:	83 c4 10             	add    $0x10,%esp
  8011f1:	85 c0                	test   %eax,%eax
  8011f3:	79 02                	jns    8011f7 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    
		return fd_close(fd, 1);
  8011f7:	83 ec 08             	sub    $0x8,%esp
  8011fa:	6a 01                	push   $0x1
  8011fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8011ff:	e8 51 ff ff ff       	call   801155 <fd_close>
  801204:	83 c4 10             	add    $0x10,%esp
  801207:	eb ec                	jmp    8011f5 <close+0x19>

00801209 <close_all>:

void
close_all(void)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	53                   	push   %ebx
  80120d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801210:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801215:	83 ec 0c             	sub    $0xc,%esp
  801218:	53                   	push   %ebx
  801219:	e8 be ff ff ff       	call   8011dc <close>
	for (i = 0; i < MAXFD; i++)
  80121e:	83 c3 01             	add    $0x1,%ebx
  801221:	83 c4 10             	add    $0x10,%esp
  801224:	83 fb 20             	cmp    $0x20,%ebx
  801227:	75 ec                	jne    801215 <close_all+0xc>
}
  801229:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80122c:	c9                   	leave  
  80122d:	c3                   	ret    

0080122e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	57                   	push   %edi
  801232:	56                   	push   %esi
  801233:	53                   	push   %ebx
  801234:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801237:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80123a:	50                   	push   %eax
  80123b:	ff 75 08             	pushl  0x8(%ebp)
  80123e:	e8 67 fe ff ff       	call   8010aa <fd_lookup>
  801243:	89 c3                	mov    %eax,%ebx
  801245:	83 c4 10             	add    $0x10,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	0f 88 81 00 00 00    	js     8012d1 <dup+0xa3>
		return r;
	close(newfdnum);
  801250:	83 ec 0c             	sub    $0xc,%esp
  801253:	ff 75 0c             	pushl  0xc(%ebp)
  801256:	e8 81 ff ff ff       	call   8011dc <close>

	newfd = INDEX2FD(newfdnum);
  80125b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80125e:	c1 e6 0c             	shl    $0xc,%esi
  801261:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801267:	83 c4 04             	add    $0x4,%esp
  80126a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80126d:	e8 cf fd ff ff       	call   801041 <fd2data>
  801272:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801274:	89 34 24             	mov    %esi,(%esp)
  801277:	e8 c5 fd ff ff       	call   801041 <fd2data>
  80127c:	83 c4 10             	add    $0x10,%esp
  80127f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801281:	89 d8                	mov    %ebx,%eax
  801283:	c1 e8 16             	shr    $0x16,%eax
  801286:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80128d:	a8 01                	test   $0x1,%al
  80128f:	74 11                	je     8012a2 <dup+0x74>
  801291:	89 d8                	mov    %ebx,%eax
  801293:	c1 e8 0c             	shr    $0xc,%eax
  801296:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80129d:	f6 c2 01             	test   $0x1,%dl
  8012a0:	75 39                	jne    8012db <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012a5:	89 d0                	mov    %edx,%eax
  8012a7:	c1 e8 0c             	shr    $0xc,%eax
  8012aa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012b1:	83 ec 0c             	sub    $0xc,%esp
  8012b4:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b9:	50                   	push   %eax
  8012ba:	56                   	push   %esi
  8012bb:	6a 00                	push   $0x0
  8012bd:	52                   	push   %edx
  8012be:	6a 00                	push   $0x0
  8012c0:	e8 ba fa ff ff       	call   800d7f <sys_page_map>
  8012c5:	89 c3                	mov    %eax,%ebx
  8012c7:	83 c4 20             	add    $0x20,%esp
  8012ca:	85 c0                	test   %eax,%eax
  8012cc:	78 31                	js     8012ff <dup+0xd1>
		goto err;

	return newfdnum;
  8012ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012d1:	89 d8                	mov    %ebx,%eax
  8012d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d6:	5b                   	pop    %ebx
  8012d7:	5e                   	pop    %esi
  8012d8:	5f                   	pop    %edi
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012db:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ea:	50                   	push   %eax
  8012eb:	57                   	push   %edi
  8012ec:	6a 00                	push   $0x0
  8012ee:	53                   	push   %ebx
  8012ef:	6a 00                	push   $0x0
  8012f1:	e8 89 fa ff ff       	call   800d7f <sys_page_map>
  8012f6:	89 c3                	mov    %eax,%ebx
  8012f8:	83 c4 20             	add    $0x20,%esp
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	79 a3                	jns    8012a2 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012ff:	83 ec 08             	sub    $0x8,%esp
  801302:	56                   	push   %esi
  801303:	6a 00                	push   $0x0
  801305:	e8 b7 fa ff ff       	call   800dc1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80130a:	83 c4 08             	add    $0x8,%esp
  80130d:	57                   	push   %edi
  80130e:	6a 00                	push   $0x0
  801310:	e8 ac fa ff ff       	call   800dc1 <sys_page_unmap>
	return r;
  801315:	83 c4 10             	add    $0x10,%esp
  801318:	eb b7                	jmp    8012d1 <dup+0xa3>

0080131a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	53                   	push   %ebx
  80131e:	83 ec 1c             	sub    $0x1c,%esp
  801321:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801324:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801327:	50                   	push   %eax
  801328:	53                   	push   %ebx
  801329:	e8 7c fd ff ff       	call   8010aa <fd_lookup>
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	85 c0                	test   %eax,%eax
  801333:	78 3f                	js     801374 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801335:	83 ec 08             	sub    $0x8,%esp
  801338:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133b:	50                   	push   %eax
  80133c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133f:	ff 30                	pushl  (%eax)
  801341:	e8 b4 fd ff ff       	call   8010fa <dev_lookup>
  801346:	83 c4 10             	add    $0x10,%esp
  801349:	85 c0                	test   %eax,%eax
  80134b:	78 27                	js     801374 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80134d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801350:	8b 42 08             	mov    0x8(%edx),%eax
  801353:	83 e0 03             	and    $0x3,%eax
  801356:	83 f8 01             	cmp    $0x1,%eax
  801359:	74 1e                	je     801379 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80135b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135e:	8b 40 08             	mov    0x8(%eax),%eax
  801361:	85 c0                	test   %eax,%eax
  801363:	74 35                	je     80139a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801365:	83 ec 04             	sub    $0x4,%esp
  801368:	ff 75 10             	pushl  0x10(%ebp)
  80136b:	ff 75 0c             	pushl  0xc(%ebp)
  80136e:	52                   	push   %edx
  80136f:	ff d0                	call   *%eax
  801371:	83 c4 10             	add    $0x10,%esp
}
  801374:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801377:	c9                   	leave  
  801378:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801379:	a1 08 40 80 00       	mov    0x804008,%eax
  80137e:	8b 40 48             	mov    0x48(%eax),%eax
  801381:	83 ec 04             	sub    $0x4,%esp
  801384:	53                   	push   %ebx
  801385:	50                   	push   %eax
  801386:	68 d5 29 80 00       	push   $0x8029d5
  80138b:	e8 5b ee ff ff       	call   8001eb <cprintf>
		return -E_INVAL;
  801390:	83 c4 10             	add    $0x10,%esp
  801393:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801398:	eb da                	jmp    801374 <read+0x5a>
		return -E_NOT_SUPP;
  80139a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80139f:	eb d3                	jmp    801374 <read+0x5a>

008013a1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	57                   	push   %edi
  8013a5:	56                   	push   %esi
  8013a6:	53                   	push   %ebx
  8013a7:	83 ec 0c             	sub    $0xc,%esp
  8013aa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013ad:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b5:	39 f3                	cmp    %esi,%ebx
  8013b7:	73 23                	jae    8013dc <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013b9:	83 ec 04             	sub    $0x4,%esp
  8013bc:	89 f0                	mov    %esi,%eax
  8013be:	29 d8                	sub    %ebx,%eax
  8013c0:	50                   	push   %eax
  8013c1:	89 d8                	mov    %ebx,%eax
  8013c3:	03 45 0c             	add    0xc(%ebp),%eax
  8013c6:	50                   	push   %eax
  8013c7:	57                   	push   %edi
  8013c8:	e8 4d ff ff ff       	call   80131a <read>
		if (m < 0)
  8013cd:	83 c4 10             	add    $0x10,%esp
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	78 06                	js     8013da <readn+0x39>
			return m;
		if (m == 0)
  8013d4:	74 06                	je     8013dc <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013d6:	01 c3                	add    %eax,%ebx
  8013d8:	eb db                	jmp    8013b5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013da:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013dc:	89 d8                	mov    %ebx,%eax
  8013de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e1:	5b                   	pop    %ebx
  8013e2:	5e                   	pop    %esi
  8013e3:	5f                   	pop    %edi
  8013e4:	5d                   	pop    %ebp
  8013e5:	c3                   	ret    

008013e6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
  8013e9:	53                   	push   %ebx
  8013ea:	83 ec 1c             	sub    $0x1c,%esp
  8013ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f3:	50                   	push   %eax
  8013f4:	53                   	push   %ebx
  8013f5:	e8 b0 fc ff ff       	call   8010aa <fd_lookup>
  8013fa:	83 c4 10             	add    $0x10,%esp
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	78 3a                	js     80143b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801401:	83 ec 08             	sub    $0x8,%esp
  801404:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801407:	50                   	push   %eax
  801408:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140b:	ff 30                	pushl  (%eax)
  80140d:	e8 e8 fc ff ff       	call   8010fa <dev_lookup>
  801412:	83 c4 10             	add    $0x10,%esp
  801415:	85 c0                	test   %eax,%eax
  801417:	78 22                	js     80143b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801419:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801420:	74 1e                	je     801440 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801422:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801425:	8b 52 0c             	mov    0xc(%edx),%edx
  801428:	85 d2                	test   %edx,%edx
  80142a:	74 35                	je     801461 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80142c:	83 ec 04             	sub    $0x4,%esp
  80142f:	ff 75 10             	pushl  0x10(%ebp)
  801432:	ff 75 0c             	pushl  0xc(%ebp)
  801435:	50                   	push   %eax
  801436:	ff d2                	call   *%edx
  801438:	83 c4 10             	add    $0x10,%esp
}
  80143b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801440:	a1 08 40 80 00       	mov    0x804008,%eax
  801445:	8b 40 48             	mov    0x48(%eax),%eax
  801448:	83 ec 04             	sub    $0x4,%esp
  80144b:	53                   	push   %ebx
  80144c:	50                   	push   %eax
  80144d:	68 f1 29 80 00       	push   $0x8029f1
  801452:	e8 94 ed ff ff       	call   8001eb <cprintf>
		return -E_INVAL;
  801457:	83 c4 10             	add    $0x10,%esp
  80145a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80145f:	eb da                	jmp    80143b <write+0x55>
		return -E_NOT_SUPP;
  801461:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801466:	eb d3                	jmp    80143b <write+0x55>

00801468 <seek>:

int
seek(int fdnum, off_t offset)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80146e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801471:	50                   	push   %eax
  801472:	ff 75 08             	pushl  0x8(%ebp)
  801475:	e8 30 fc ff ff       	call   8010aa <fd_lookup>
  80147a:	83 c4 10             	add    $0x10,%esp
  80147d:	85 c0                	test   %eax,%eax
  80147f:	78 0e                	js     80148f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801481:	8b 55 0c             	mov    0xc(%ebp),%edx
  801484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801487:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80148a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148f:	c9                   	leave  
  801490:	c3                   	ret    

00801491 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	53                   	push   %ebx
  801495:	83 ec 1c             	sub    $0x1c,%esp
  801498:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80149e:	50                   	push   %eax
  80149f:	53                   	push   %ebx
  8014a0:	e8 05 fc ff ff       	call   8010aa <fd_lookup>
  8014a5:	83 c4 10             	add    $0x10,%esp
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	78 37                	js     8014e3 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ac:	83 ec 08             	sub    $0x8,%esp
  8014af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b2:	50                   	push   %eax
  8014b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b6:	ff 30                	pushl  (%eax)
  8014b8:	e8 3d fc ff ff       	call   8010fa <dev_lookup>
  8014bd:	83 c4 10             	add    $0x10,%esp
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	78 1f                	js     8014e3 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014cb:	74 1b                	je     8014e8 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d0:	8b 52 18             	mov    0x18(%edx),%edx
  8014d3:	85 d2                	test   %edx,%edx
  8014d5:	74 32                	je     801509 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	ff 75 0c             	pushl  0xc(%ebp)
  8014dd:	50                   	push   %eax
  8014de:	ff d2                	call   *%edx
  8014e0:	83 c4 10             	add    $0x10,%esp
}
  8014e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014e8:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014ed:	8b 40 48             	mov    0x48(%eax),%eax
  8014f0:	83 ec 04             	sub    $0x4,%esp
  8014f3:	53                   	push   %ebx
  8014f4:	50                   	push   %eax
  8014f5:	68 b4 29 80 00       	push   $0x8029b4
  8014fa:	e8 ec ec ff ff       	call   8001eb <cprintf>
		return -E_INVAL;
  8014ff:	83 c4 10             	add    $0x10,%esp
  801502:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801507:	eb da                	jmp    8014e3 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801509:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80150e:	eb d3                	jmp    8014e3 <ftruncate+0x52>

00801510 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	53                   	push   %ebx
  801514:	83 ec 1c             	sub    $0x1c,%esp
  801517:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80151a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151d:	50                   	push   %eax
  80151e:	ff 75 08             	pushl  0x8(%ebp)
  801521:	e8 84 fb ff ff       	call   8010aa <fd_lookup>
  801526:	83 c4 10             	add    $0x10,%esp
  801529:	85 c0                	test   %eax,%eax
  80152b:	78 4b                	js     801578 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152d:	83 ec 08             	sub    $0x8,%esp
  801530:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801533:	50                   	push   %eax
  801534:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801537:	ff 30                	pushl  (%eax)
  801539:	e8 bc fb ff ff       	call   8010fa <dev_lookup>
  80153e:	83 c4 10             	add    $0x10,%esp
  801541:	85 c0                	test   %eax,%eax
  801543:	78 33                	js     801578 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801548:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80154c:	74 2f                	je     80157d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80154e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801551:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801558:	00 00 00 
	stat->st_isdir = 0;
  80155b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801562:	00 00 00 
	stat->st_dev = dev;
  801565:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80156b:	83 ec 08             	sub    $0x8,%esp
  80156e:	53                   	push   %ebx
  80156f:	ff 75 f0             	pushl  -0x10(%ebp)
  801572:	ff 50 14             	call   *0x14(%eax)
  801575:	83 c4 10             	add    $0x10,%esp
}
  801578:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    
		return -E_NOT_SUPP;
  80157d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801582:	eb f4                	jmp    801578 <fstat+0x68>

00801584 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	56                   	push   %esi
  801588:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801589:	83 ec 08             	sub    $0x8,%esp
  80158c:	6a 00                	push   $0x0
  80158e:	ff 75 08             	pushl  0x8(%ebp)
  801591:	e8 22 02 00 00       	call   8017b8 <open>
  801596:	89 c3                	mov    %eax,%ebx
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	85 c0                	test   %eax,%eax
  80159d:	78 1b                	js     8015ba <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	ff 75 0c             	pushl  0xc(%ebp)
  8015a5:	50                   	push   %eax
  8015a6:	e8 65 ff ff ff       	call   801510 <fstat>
  8015ab:	89 c6                	mov    %eax,%esi
	close(fd);
  8015ad:	89 1c 24             	mov    %ebx,(%esp)
  8015b0:	e8 27 fc ff ff       	call   8011dc <close>
	return r;
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	89 f3                	mov    %esi,%ebx
}
  8015ba:	89 d8                	mov    %ebx,%eax
  8015bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015bf:	5b                   	pop    %ebx
  8015c0:	5e                   	pop    %esi
  8015c1:	5d                   	pop    %ebp
  8015c2:	c3                   	ret    

008015c3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	56                   	push   %esi
  8015c7:	53                   	push   %ebx
  8015c8:	89 c6                	mov    %eax,%esi
  8015ca:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015cc:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015d3:	74 27                	je     8015fc <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015d5:	6a 07                	push   $0x7
  8015d7:	68 00 50 80 00       	push   $0x805000
  8015dc:	56                   	push   %esi
  8015dd:	ff 35 00 40 80 00    	pushl  0x804000
  8015e3:	e8 69 0c 00 00       	call   802251 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015e8:	83 c4 0c             	add    $0xc,%esp
  8015eb:	6a 00                	push   $0x0
  8015ed:	53                   	push   %ebx
  8015ee:	6a 00                	push   $0x0
  8015f0:	e8 f3 0b 00 00       	call   8021e8 <ipc_recv>
}
  8015f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f8:	5b                   	pop    %ebx
  8015f9:	5e                   	pop    %esi
  8015fa:	5d                   	pop    %ebp
  8015fb:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015fc:	83 ec 0c             	sub    $0xc,%esp
  8015ff:	6a 01                	push   $0x1
  801601:	e8 a3 0c 00 00       	call   8022a9 <ipc_find_env>
  801606:	a3 00 40 80 00       	mov    %eax,0x804000
  80160b:	83 c4 10             	add    $0x10,%esp
  80160e:	eb c5                	jmp    8015d5 <fsipc+0x12>

00801610 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	8b 40 0c             	mov    0xc(%eax),%eax
  80161c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801621:	8b 45 0c             	mov    0xc(%ebp),%eax
  801624:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801629:	ba 00 00 00 00       	mov    $0x0,%edx
  80162e:	b8 02 00 00 00       	mov    $0x2,%eax
  801633:	e8 8b ff ff ff       	call   8015c3 <fsipc>
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <devfile_flush>:
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	8b 40 0c             	mov    0xc(%eax),%eax
  801646:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80164b:	ba 00 00 00 00       	mov    $0x0,%edx
  801650:	b8 06 00 00 00       	mov    $0x6,%eax
  801655:	e8 69 ff ff ff       	call   8015c3 <fsipc>
}
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <devfile_stat>:
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	53                   	push   %ebx
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	8b 40 0c             	mov    0xc(%eax),%eax
  80166c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801671:	ba 00 00 00 00       	mov    $0x0,%edx
  801676:	b8 05 00 00 00       	mov    $0x5,%eax
  80167b:	e8 43 ff ff ff       	call   8015c3 <fsipc>
  801680:	85 c0                	test   %eax,%eax
  801682:	78 2c                	js     8016b0 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801684:	83 ec 08             	sub    $0x8,%esp
  801687:	68 00 50 80 00       	push   $0x805000
  80168c:	53                   	push   %ebx
  80168d:	e8 b8 f2 ff ff       	call   80094a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801692:	a1 80 50 80 00       	mov    0x805080,%eax
  801697:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80169d:	a1 84 50 80 00       	mov    0x805084,%eax
  8016a2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <devfile_write>:
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	53                   	push   %ebx
  8016b9:	83 ec 08             	sub    $0x8,%esp
  8016bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016ca:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016d0:	53                   	push   %ebx
  8016d1:	ff 75 0c             	pushl  0xc(%ebp)
  8016d4:	68 08 50 80 00       	push   $0x805008
  8016d9:	e8 5c f4 ff ff       	call   800b3a <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016de:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e3:	b8 04 00 00 00       	mov    $0x4,%eax
  8016e8:	e8 d6 fe ff ff       	call   8015c3 <fsipc>
  8016ed:	83 c4 10             	add    $0x10,%esp
  8016f0:	85 c0                	test   %eax,%eax
  8016f2:	78 0b                	js     8016ff <devfile_write+0x4a>
	assert(r <= n);
  8016f4:	39 d8                	cmp    %ebx,%eax
  8016f6:	77 0c                	ja     801704 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016f8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016fd:	7f 1e                	jg     80171d <devfile_write+0x68>
}
  8016ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801702:	c9                   	leave  
  801703:	c3                   	ret    
	assert(r <= n);
  801704:	68 24 2a 80 00       	push   $0x802a24
  801709:	68 2b 2a 80 00       	push   $0x802a2b
  80170e:	68 98 00 00 00       	push   $0x98
  801713:	68 40 2a 80 00       	push   $0x802a40
  801718:	e8 6a 0a 00 00       	call   802187 <_panic>
	assert(r <= PGSIZE);
  80171d:	68 4b 2a 80 00       	push   $0x802a4b
  801722:	68 2b 2a 80 00       	push   $0x802a2b
  801727:	68 99 00 00 00       	push   $0x99
  80172c:	68 40 2a 80 00       	push   $0x802a40
  801731:	e8 51 0a 00 00       	call   802187 <_panic>

00801736 <devfile_read>:
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	56                   	push   %esi
  80173a:	53                   	push   %ebx
  80173b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	8b 40 0c             	mov    0xc(%eax),%eax
  801744:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801749:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80174f:	ba 00 00 00 00       	mov    $0x0,%edx
  801754:	b8 03 00 00 00       	mov    $0x3,%eax
  801759:	e8 65 fe ff ff       	call   8015c3 <fsipc>
  80175e:	89 c3                	mov    %eax,%ebx
  801760:	85 c0                	test   %eax,%eax
  801762:	78 1f                	js     801783 <devfile_read+0x4d>
	assert(r <= n);
  801764:	39 f0                	cmp    %esi,%eax
  801766:	77 24                	ja     80178c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801768:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80176d:	7f 33                	jg     8017a2 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80176f:	83 ec 04             	sub    $0x4,%esp
  801772:	50                   	push   %eax
  801773:	68 00 50 80 00       	push   $0x805000
  801778:	ff 75 0c             	pushl  0xc(%ebp)
  80177b:	e8 58 f3 ff ff       	call   800ad8 <memmove>
	return r;
  801780:	83 c4 10             	add    $0x10,%esp
}
  801783:	89 d8                	mov    %ebx,%eax
  801785:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801788:	5b                   	pop    %ebx
  801789:	5e                   	pop    %esi
  80178a:	5d                   	pop    %ebp
  80178b:	c3                   	ret    
	assert(r <= n);
  80178c:	68 24 2a 80 00       	push   $0x802a24
  801791:	68 2b 2a 80 00       	push   $0x802a2b
  801796:	6a 7c                	push   $0x7c
  801798:	68 40 2a 80 00       	push   $0x802a40
  80179d:	e8 e5 09 00 00       	call   802187 <_panic>
	assert(r <= PGSIZE);
  8017a2:	68 4b 2a 80 00       	push   $0x802a4b
  8017a7:	68 2b 2a 80 00       	push   $0x802a2b
  8017ac:	6a 7d                	push   $0x7d
  8017ae:	68 40 2a 80 00       	push   $0x802a40
  8017b3:	e8 cf 09 00 00       	call   802187 <_panic>

008017b8 <open>:
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	56                   	push   %esi
  8017bc:	53                   	push   %ebx
  8017bd:	83 ec 1c             	sub    $0x1c,%esp
  8017c0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017c3:	56                   	push   %esi
  8017c4:	e8 48 f1 ff ff       	call   800911 <strlen>
  8017c9:	83 c4 10             	add    $0x10,%esp
  8017cc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017d1:	7f 6c                	jg     80183f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017d3:	83 ec 0c             	sub    $0xc,%esp
  8017d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d9:	50                   	push   %eax
  8017da:	e8 79 f8 ff ff       	call   801058 <fd_alloc>
  8017df:	89 c3                	mov    %eax,%ebx
  8017e1:	83 c4 10             	add    $0x10,%esp
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	78 3c                	js     801824 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017e8:	83 ec 08             	sub    $0x8,%esp
  8017eb:	56                   	push   %esi
  8017ec:	68 00 50 80 00       	push   $0x805000
  8017f1:	e8 54 f1 ff ff       	call   80094a <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f9:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801801:	b8 01 00 00 00       	mov    $0x1,%eax
  801806:	e8 b8 fd ff ff       	call   8015c3 <fsipc>
  80180b:	89 c3                	mov    %eax,%ebx
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	85 c0                	test   %eax,%eax
  801812:	78 19                	js     80182d <open+0x75>
	return fd2num(fd);
  801814:	83 ec 0c             	sub    $0xc,%esp
  801817:	ff 75 f4             	pushl  -0xc(%ebp)
  80181a:	e8 12 f8 ff ff       	call   801031 <fd2num>
  80181f:	89 c3                	mov    %eax,%ebx
  801821:	83 c4 10             	add    $0x10,%esp
}
  801824:	89 d8                	mov    %ebx,%eax
  801826:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801829:	5b                   	pop    %ebx
  80182a:	5e                   	pop    %esi
  80182b:	5d                   	pop    %ebp
  80182c:	c3                   	ret    
		fd_close(fd, 0);
  80182d:	83 ec 08             	sub    $0x8,%esp
  801830:	6a 00                	push   $0x0
  801832:	ff 75 f4             	pushl  -0xc(%ebp)
  801835:	e8 1b f9 ff ff       	call   801155 <fd_close>
		return r;
  80183a:	83 c4 10             	add    $0x10,%esp
  80183d:	eb e5                	jmp    801824 <open+0x6c>
		return -E_BAD_PATH;
  80183f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801844:	eb de                	jmp    801824 <open+0x6c>

00801846 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80184c:	ba 00 00 00 00       	mov    $0x0,%edx
  801851:	b8 08 00 00 00       	mov    $0x8,%eax
  801856:	e8 68 fd ff ff       	call   8015c3 <fsipc>
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801863:	68 57 2a 80 00       	push   $0x802a57
  801868:	ff 75 0c             	pushl  0xc(%ebp)
  80186b:	e8 da f0 ff ff       	call   80094a <strcpy>
	return 0;
}
  801870:	b8 00 00 00 00       	mov    $0x0,%eax
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <devsock_close>:
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	53                   	push   %ebx
  80187b:	83 ec 10             	sub    $0x10,%esp
  80187e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801881:	53                   	push   %ebx
  801882:	e8 61 0a 00 00       	call   8022e8 <pageref>
  801887:	83 c4 10             	add    $0x10,%esp
		return 0;
  80188a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80188f:	83 f8 01             	cmp    $0x1,%eax
  801892:	74 07                	je     80189b <devsock_close+0x24>
}
  801894:	89 d0                	mov    %edx,%eax
  801896:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801899:	c9                   	leave  
  80189a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80189b:	83 ec 0c             	sub    $0xc,%esp
  80189e:	ff 73 0c             	pushl  0xc(%ebx)
  8018a1:	e8 b9 02 00 00       	call   801b5f <nsipc_close>
  8018a6:	89 c2                	mov    %eax,%edx
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	eb e7                	jmp    801894 <devsock_close+0x1d>

008018ad <devsock_write>:
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018b3:	6a 00                	push   $0x0
  8018b5:	ff 75 10             	pushl  0x10(%ebp)
  8018b8:	ff 75 0c             	pushl  0xc(%ebp)
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	ff 70 0c             	pushl  0xc(%eax)
  8018c1:	e8 76 03 00 00       	call   801c3c <nsipc_send>
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <devsock_read>:
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018ce:	6a 00                	push   $0x0
  8018d0:	ff 75 10             	pushl  0x10(%ebp)
  8018d3:	ff 75 0c             	pushl  0xc(%ebp)
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	ff 70 0c             	pushl  0xc(%eax)
  8018dc:	e8 ef 02 00 00       	call   801bd0 <nsipc_recv>
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <fd2sockid>:
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018e9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018ec:	52                   	push   %edx
  8018ed:	50                   	push   %eax
  8018ee:	e8 b7 f7 ff ff       	call   8010aa <fd_lookup>
  8018f3:	83 c4 10             	add    $0x10,%esp
  8018f6:	85 c0                	test   %eax,%eax
  8018f8:	78 10                	js     80190a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fd:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801903:	39 08                	cmp    %ecx,(%eax)
  801905:	75 05                	jne    80190c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801907:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    
		return -E_NOT_SUPP;
  80190c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801911:	eb f7                	jmp    80190a <fd2sockid+0x27>

00801913 <alloc_sockfd>:
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	56                   	push   %esi
  801917:	53                   	push   %ebx
  801918:	83 ec 1c             	sub    $0x1c,%esp
  80191b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80191d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801920:	50                   	push   %eax
  801921:	e8 32 f7 ff ff       	call   801058 <fd_alloc>
  801926:	89 c3                	mov    %eax,%ebx
  801928:	83 c4 10             	add    $0x10,%esp
  80192b:	85 c0                	test   %eax,%eax
  80192d:	78 43                	js     801972 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80192f:	83 ec 04             	sub    $0x4,%esp
  801932:	68 07 04 00 00       	push   $0x407
  801937:	ff 75 f4             	pushl  -0xc(%ebp)
  80193a:	6a 00                	push   $0x0
  80193c:	e8 fb f3 ff ff       	call   800d3c <sys_page_alloc>
  801941:	89 c3                	mov    %eax,%ebx
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	85 c0                	test   %eax,%eax
  801948:	78 28                	js     801972 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80194a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801953:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801958:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80195f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801962:	83 ec 0c             	sub    $0xc,%esp
  801965:	50                   	push   %eax
  801966:	e8 c6 f6 ff ff       	call   801031 <fd2num>
  80196b:	89 c3                	mov    %eax,%ebx
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	eb 0c                	jmp    80197e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801972:	83 ec 0c             	sub    $0xc,%esp
  801975:	56                   	push   %esi
  801976:	e8 e4 01 00 00       	call   801b5f <nsipc_close>
		return r;
  80197b:	83 c4 10             	add    $0x10,%esp
}
  80197e:	89 d8                	mov    %ebx,%eax
  801980:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801983:	5b                   	pop    %ebx
  801984:	5e                   	pop    %esi
  801985:	5d                   	pop    %ebp
  801986:	c3                   	ret    

00801987 <accept>:
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	e8 4e ff ff ff       	call   8018e3 <fd2sockid>
  801995:	85 c0                	test   %eax,%eax
  801997:	78 1b                	js     8019b4 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801999:	83 ec 04             	sub    $0x4,%esp
  80199c:	ff 75 10             	pushl  0x10(%ebp)
  80199f:	ff 75 0c             	pushl  0xc(%ebp)
  8019a2:	50                   	push   %eax
  8019a3:	e8 0e 01 00 00       	call   801ab6 <nsipc_accept>
  8019a8:	83 c4 10             	add    $0x10,%esp
  8019ab:	85 c0                	test   %eax,%eax
  8019ad:	78 05                	js     8019b4 <accept+0x2d>
	return alloc_sockfd(r);
  8019af:	e8 5f ff ff ff       	call   801913 <alloc_sockfd>
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <bind>:
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	e8 1f ff ff ff       	call   8018e3 <fd2sockid>
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	78 12                	js     8019da <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019c8:	83 ec 04             	sub    $0x4,%esp
  8019cb:	ff 75 10             	pushl  0x10(%ebp)
  8019ce:	ff 75 0c             	pushl  0xc(%ebp)
  8019d1:	50                   	push   %eax
  8019d2:	e8 31 01 00 00       	call   801b08 <nsipc_bind>
  8019d7:	83 c4 10             	add    $0x10,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <shutdown>:
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	e8 f9 fe ff ff       	call   8018e3 <fd2sockid>
  8019ea:	85 c0                	test   %eax,%eax
  8019ec:	78 0f                	js     8019fd <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019ee:	83 ec 08             	sub    $0x8,%esp
  8019f1:	ff 75 0c             	pushl  0xc(%ebp)
  8019f4:	50                   	push   %eax
  8019f5:	e8 43 01 00 00       	call   801b3d <nsipc_shutdown>
  8019fa:	83 c4 10             	add    $0x10,%esp
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <connect>:
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	e8 d6 fe ff ff       	call   8018e3 <fd2sockid>
  801a0d:	85 c0                	test   %eax,%eax
  801a0f:	78 12                	js     801a23 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a11:	83 ec 04             	sub    $0x4,%esp
  801a14:	ff 75 10             	pushl  0x10(%ebp)
  801a17:	ff 75 0c             	pushl  0xc(%ebp)
  801a1a:	50                   	push   %eax
  801a1b:	e8 59 01 00 00       	call   801b79 <nsipc_connect>
  801a20:	83 c4 10             	add    $0x10,%esp
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <listen>:
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	e8 b0 fe ff ff       	call   8018e3 <fd2sockid>
  801a33:	85 c0                	test   %eax,%eax
  801a35:	78 0f                	js     801a46 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a37:	83 ec 08             	sub    $0x8,%esp
  801a3a:	ff 75 0c             	pushl  0xc(%ebp)
  801a3d:	50                   	push   %eax
  801a3e:	e8 6b 01 00 00       	call   801bae <nsipc_listen>
  801a43:	83 c4 10             	add    $0x10,%esp
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a4e:	ff 75 10             	pushl  0x10(%ebp)
  801a51:	ff 75 0c             	pushl  0xc(%ebp)
  801a54:	ff 75 08             	pushl  0x8(%ebp)
  801a57:	e8 3e 02 00 00       	call   801c9a <nsipc_socket>
  801a5c:	83 c4 10             	add    $0x10,%esp
  801a5f:	85 c0                	test   %eax,%eax
  801a61:	78 05                	js     801a68 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a63:	e8 ab fe ff ff       	call   801913 <alloc_sockfd>
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	53                   	push   %ebx
  801a6e:	83 ec 04             	sub    $0x4,%esp
  801a71:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a73:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a7a:	74 26                	je     801aa2 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a7c:	6a 07                	push   $0x7
  801a7e:	68 00 60 80 00       	push   $0x806000
  801a83:	53                   	push   %ebx
  801a84:	ff 35 04 40 80 00    	pushl  0x804004
  801a8a:	e8 c2 07 00 00       	call   802251 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a8f:	83 c4 0c             	add    $0xc,%esp
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	e8 4b 07 00 00       	call   8021e8 <ipc_recv>
}
  801a9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801aa2:	83 ec 0c             	sub    $0xc,%esp
  801aa5:	6a 02                	push   $0x2
  801aa7:	e8 fd 07 00 00       	call   8022a9 <ipc_find_env>
  801aac:	a3 04 40 80 00       	mov    %eax,0x804004
  801ab1:	83 c4 10             	add    $0x10,%esp
  801ab4:	eb c6                	jmp    801a7c <nsipc+0x12>

00801ab6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	56                   	push   %esi
  801aba:	53                   	push   %ebx
  801abb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ac6:	8b 06                	mov    (%esi),%eax
  801ac8:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801acd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad2:	e8 93 ff ff ff       	call   801a6a <nsipc>
  801ad7:	89 c3                	mov    %eax,%ebx
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	79 09                	jns    801ae6 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801add:	89 d8                	mov    %ebx,%eax
  801adf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae2:	5b                   	pop    %ebx
  801ae3:	5e                   	pop    %esi
  801ae4:	5d                   	pop    %ebp
  801ae5:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ae6:	83 ec 04             	sub    $0x4,%esp
  801ae9:	ff 35 10 60 80 00    	pushl  0x806010
  801aef:	68 00 60 80 00       	push   $0x806000
  801af4:	ff 75 0c             	pushl  0xc(%ebp)
  801af7:	e8 dc ef ff ff       	call   800ad8 <memmove>
		*addrlen = ret->ret_addrlen;
  801afc:	a1 10 60 80 00       	mov    0x806010,%eax
  801b01:	89 06                	mov    %eax,(%esi)
  801b03:	83 c4 10             	add    $0x10,%esp
	return r;
  801b06:	eb d5                	jmp    801add <nsipc_accept+0x27>

00801b08 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	53                   	push   %ebx
  801b0c:	83 ec 08             	sub    $0x8,%esp
  801b0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b1a:	53                   	push   %ebx
  801b1b:	ff 75 0c             	pushl  0xc(%ebp)
  801b1e:	68 04 60 80 00       	push   $0x806004
  801b23:	e8 b0 ef ff ff       	call   800ad8 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b28:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b2e:	b8 02 00 00 00       	mov    $0x2,%eax
  801b33:	e8 32 ff ff ff       	call   801a6a <nsipc>
}
  801b38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b53:	b8 03 00 00 00       	mov    $0x3,%eax
  801b58:	e8 0d ff ff ff       	call   801a6a <nsipc>
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <nsipc_close>:

int
nsipc_close(int s)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b6d:	b8 04 00 00 00       	mov    $0x4,%eax
  801b72:	e8 f3 fe ff ff       	call   801a6a <nsipc>
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	53                   	push   %ebx
  801b7d:	83 ec 08             	sub    $0x8,%esp
  801b80:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b8b:	53                   	push   %ebx
  801b8c:	ff 75 0c             	pushl  0xc(%ebp)
  801b8f:	68 04 60 80 00       	push   $0x806004
  801b94:	e8 3f ef ff ff       	call   800ad8 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b99:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b9f:	b8 05 00 00 00       	mov    $0x5,%eax
  801ba4:	e8 c1 fe ff ff       	call   801a6a <nsipc>
}
  801ba9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bc4:	b8 06 00 00 00       	mov    $0x6,%eax
  801bc9:	e8 9c fe ff ff       	call   801a6a <nsipc>
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	56                   	push   %esi
  801bd4:	53                   	push   %ebx
  801bd5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801be0:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801be6:	8b 45 14             	mov    0x14(%ebp),%eax
  801be9:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bee:	b8 07 00 00 00       	mov    $0x7,%eax
  801bf3:	e8 72 fe ff ff       	call   801a6a <nsipc>
  801bf8:	89 c3                	mov    %eax,%ebx
  801bfa:	85 c0                	test   %eax,%eax
  801bfc:	78 1f                	js     801c1d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bfe:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c03:	7f 21                	jg     801c26 <nsipc_recv+0x56>
  801c05:	39 c6                	cmp    %eax,%esi
  801c07:	7c 1d                	jl     801c26 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c09:	83 ec 04             	sub    $0x4,%esp
  801c0c:	50                   	push   %eax
  801c0d:	68 00 60 80 00       	push   $0x806000
  801c12:	ff 75 0c             	pushl  0xc(%ebp)
  801c15:	e8 be ee ff ff       	call   800ad8 <memmove>
  801c1a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c1d:	89 d8                	mov    %ebx,%eax
  801c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c22:	5b                   	pop    %ebx
  801c23:	5e                   	pop    %esi
  801c24:	5d                   	pop    %ebp
  801c25:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c26:	68 63 2a 80 00       	push   $0x802a63
  801c2b:	68 2b 2a 80 00       	push   $0x802a2b
  801c30:	6a 62                	push   $0x62
  801c32:	68 78 2a 80 00       	push   $0x802a78
  801c37:	e8 4b 05 00 00       	call   802187 <_panic>

00801c3c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	53                   	push   %ebx
  801c40:	83 ec 04             	sub    $0x4,%esp
  801c43:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c4e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c54:	7f 2e                	jg     801c84 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c56:	83 ec 04             	sub    $0x4,%esp
  801c59:	53                   	push   %ebx
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	68 0c 60 80 00       	push   $0x80600c
  801c62:	e8 71 ee ff ff       	call   800ad8 <memmove>
	nsipcbuf.send.req_size = size;
  801c67:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c70:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c75:	b8 08 00 00 00       	mov    $0x8,%eax
  801c7a:	e8 eb fd ff ff       	call   801a6a <nsipc>
}
  801c7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    
	assert(size < 1600);
  801c84:	68 84 2a 80 00       	push   $0x802a84
  801c89:	68 2b 2a 80 00       	push   $0x802a2b
  801c8e:	6a 6d                	push   $0x6d
  801c90:	68 78 2a 80 00       	push   $0x802a78
  801c95:	e8 ed 04 00 00       	call   802187 <_panic>

00801c9a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cab:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cb0:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cb8:	b8 09 00 00 00       	mov    $0x9,%eax
  801cbd:	e8 a8 fd ff ff       	call   801a6a <nsipc>
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	56                   	push   %esi
  801cc8:	53                   	push   %ebx
  801cc9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ccc:	83 ec 0c             	sub    $0xc,%esp
  801ccf:	ff 75 08             	pushl  0x8(%ebp)
  801cd2:	e8 6a f3 ff ff       	call   801041 <fd2data>
  801cd7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cd9:	83 c4 08             	add    $0x8,%esp
  801cdc:	68 90 2a 80 00       	push   $0x802a90
  801ce1:	53                   	push   %ebx
  801ce2:	e8 63 ec ff ff       	call   80094a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ce7:	8b 46 04             	mov    0x4(%esi),%eax
  801cea:	2b 06                	sub    (%esi),%eax
  801cec:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cf2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cf9:	00 00 00 
	stat->st_dev = &devpipe;
  801cfc:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d03:	30 80 00 
	return 0;
}
  801d06:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d0e:	5b                   	pop    %ebx
  801d0f:	5e                   	pop    %esi
  801d10:	5d                   	pop    %ebp
  801d11:	c3                   	ret    

00801d12 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	53                   	push   %ebx
  801d16:	83 ec 0c             	sub    $0xc,%esp
  801d19:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d1c:	53                   	push   %ebx
  801d1d:	6a 00                	push   $0x0
  801d1f:	e8 9d f0 ff ff       	call   800dc1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d24:	89 1c 24             	mov    %ebx,(%esp)
  801d27:	e8 15 f3 ff ff       	call   801041 <fd2data>
  801d2c:	83 c4 08             	add    $0x8,%esp
  801d2f:	50                   	push   %eax
  801d30:	6a 00                	push   $0x0
  801d32:	e8 8a f0 ff ff       	call   800dc1 <sys_page_unmap>
}
  801d37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <_pipeisclosed>:
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	57                   	push   %edi
  801d40:	56                   	push   %esi
  801d41:	53                   	push   %ebx
  801d42:	83 ec 1c             	sub    $0x1c,%esp
  801d45:	89 c7                	mov    %eax,%edi
  801d47:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d49:	a1 08 40 80 00       	mov    0x804008,%eax
  801d4e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d51:	83 ec 0c             	sub    $0xc,%esp
  801d54:	57                   	push   %edi
  801d55:	e8 8e 05 00 00       	call   8022e8 <pageref>
  801d5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d5d:	89 34 24             	mov    %esi,(%esp)
  801d60:	e8 83 05 00 00       	call   8022e8 <pageref>
		nn = thisenv->env_runs;
  801d65:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d6b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d6e:	83 c4 10             	add    $0x10,%esp
  801d71:	39 cb                	cmp    %ecx,%ebx
  801d73:	74 1b                	je     801d90 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d75:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d78:	75 cf                	jne    801d49 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d7a:	8b 42 58             	mov    0x58(%edx),%eax
  801d7d:	6a 01                	push   $0x1
  801d7f:	50                   	push   %eax
  801d80:	53                   	push   %ebx
  801d81:	68 97 2a 80 00       	push   $0x802a97
  801d86:	e8 60 e4 ff ff       	call   8001eb <cprintf>
  801d8b:	83 c4 10             	add    $0x10,%esp
  801d8e:	eb b9                	jmp    801d49 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d90:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d93:	0f 94 c0             	sete   %al
  801d96:	0f b6 c0             	movzbl %al,%eax
}
  801d99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d9c:	5b                   	pop    %ebx
  801d9d:	5e                   	pop    %esi
  801d9e:	5f                   	pop    %edi
  801d9f:	5d                   	pop    %ebp
  801da0:	c3                   	ret    

00801da1 <devpipe_write>:
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	57                   	push   %edi
  801da5:	56                   	push   %esi
  801da6:	53                   	push   %ebx
  801da7:	83 ec 28             	sub    $0x28,%esp
  801daa:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dad:	56                   	push   %esi
  801dae:	e8 8e f2 ff ff       	call   801041 <fd2data>
  801db3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801db5:	83 c4 10             	add    $0x10,%esp
  801db8:	bf 00 00 00 00       	mov    $0x0,%edi
  801dbd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dc0:	74 4f                	je     801e11 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dc2:	8b 43 04             	mov    0x4(%ebx),%eax
  801dc5:	8b 0b                	mov    (%ebx),%ecx
  801dc7:	8d 51 20             	lea    0x20(%ecx),%edx
  801dca:	39 d0                	cmp    %edx,%eax
  801dcc:	72 14                	jb     801de2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dce:	89 da                	mov    %ebx,%edx
  801dd0:	89 f0                	mov    %esi,%eax
  801dd2:	e8 65 ff ff ff       	call   801d3c <_pipeisclosed>
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	75 3b                	jne    801e16 <devpipe_write+0x75>
			sys_yield();
  801ddb:	e8 3d ef ff ff       	call   800d1d <sys_yield>
  801de0:	eb e0                	jmp    801dc2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801de2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801de5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801de9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dec:	89 c2                	mov    %eax,%edx
  801dee:	c1 fa 1f             	sar    $0x1f,%edx
  801df1:	89 d1                	mov    %edx,%ecx
  801df3:	c1 e9 1b             	shr    $0x1b,%ecx
  801df6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801df9:	83 e2 1f             	and    $0x1f,%edx
  801dfc:	29 ca                	sub    %ecx,%edx
  801dfe:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e02:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e06:	83 c0 01             	add    $0x1,%eax
  801e09:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e0c:	83 c7 01             	add    $0x1,%edi
  801e0f:	eb ac                	jmp    801dbd <devpipe_write+0x1c>
	return i;
  801e11:	8b 45 10             	mov    0x10(%ebp),%eax
  801e14:	eb 05                	jmp    801e1b <devpipe_write+0x7a>
				return 0;
  801e16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1e:	5b                   	pop    %ebx
  801e1f:	5e                   	pop    %esi
  801e20:	5f                   	pop    %edi
  801e21:	5d                   	pop    %ebp
  801e22:	c3                   	ret    

00801e23 <devpipe_read>:
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	57                   	push   %edi
  801e27:	56                   	push   %esi
  801e28:	53                   	push   %ebx
  801e29:	83 ec 18             	sub    $0x18,%esp
  801e2c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e2f:	57                   	push   %edi
  801e30:	e8 0c f2 ff ff       	call   801041 <fd2data>
  801e35:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e37:	83 c4 10             	add    $0x10,%esp
  801e3a:	be 00 00 00 00       	mov    $0x0,%esi
  801e3f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e42:	75 14                	jne    801e58 <devpipe_read+0x35>
	return i;
  801e44:	8b 45 10             	mov    0x10(%ebp),%eax
  801e47:	eb 02                	jmp    801e4b <devpipe_read+0x28>
				return i;
  801e49:	89 f0                	mov    %esi,%eax
}
  801e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e4e:	5b                   	pop    %ebx
  801e4f:	5e                   	pop    %esi
  801e50:	5f                   	pop    %edi
  801e51:	5d                   	pop    %ebp
  801e52:	c3                   	ret    
			sys_yield();
  801e53:	e8 c5 ee ff ff       	call   800d1d <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e58:	8b 03                	mov    (%ebx),%eax
  801e5a:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e5d:	75 18                	jne    801e77 <devpipe_read+0x54>
			if (i > 0)
  801e5f:	85 f6                	test   %esi,%esi
  801e61:	75 e6                	jne    801e49 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e63:	89 da                	mov    %ebx,%edx
  801e65:	89 f8                	mov    %edi,%eax
  801e67:	e8 d0 fe ff ff       	call   801d3c <_pipeisclosed>
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	74 e3                	je     801e53 <devpipe_read+0x30>
				return 0;
  801e70:	b8 00 00 00 00       	mov    $0x0,%eax
  801e75:	eb d4                	jmp    801e4b <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e77:	99                   	cltd   
  801e78:	c1 ea 1b             	shr    $0x1b,%edx
  801e7b:	01 d0                	add    %edx,%eax
  801e7d:	83 e0 1f             	and    $0x1f,%eax
  801e80:	29 d0                	sub    %edx,%eax
  801e82:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e8a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e8d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e90:	83 c6 01             	add    $0x1,%esi
  801e93:	eb aa                	jmp    801e3f <devpipe_read+0x1c>

00801e95 <pipe>:
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	56                   	push   %esi
  801e99:	53                   	push   %ebx
  801e9a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e9d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea0:	50                   	push   %eax
  801ea1:	e8 b2 f1 ff ff       	call   801058 <fd_alloc>
  801ea6:	89 c3                	mov    %eax,%ebx
  801ea8:	83 c4 10             	add    $0x10,%esp
  801eab:	85 c0                	test   %eax,%eax
  801ead:	0f 88 23 01 00 00    	js     801fd6 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb3:	83 ec 04             	sub    $0x4,%esp
  801eb6:	68 07 04 00 00       	push   $0x407
  801ebb:	ff 75 f4             	pushl  -0xc(%ebp)
  801ebe:	6a 00                	push   $0x0
  801ec0:	e8 77 ee ff ff       	call   800d3c <sys_page_alloc>
  801ec5:	89 c3                	mov    %eax,%ebx
  801ec7:	83 c4 10             	add    $0x10,%esp
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	0f 88 04 01 00 00    	js     801fd6 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ed2:	83 ec 0c             	sub    $0xc,%esp
  801ed5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ed8:	50                   	push   %eax
  801ed9:	e8 7a f1 ff ff       	call   801058 <fd_alloc>
  801ede:	89 c3                	mov    %eax,%ebx
  801ee0:	83 c4 10             	add    $0x10,%esp
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	0f 88 db 00 00 00    	js     801fc6 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eeb:	83 ec 04             	sub    $0x4,%esp
  801eee:	68 07 04 00 00       	push   $0x407
  801ef3:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef6:	6a 00                	push   $0x0
  801ef8:	e8 3f ee ff ff       	call   800d3c <sys_page_alloc>
  801efd:	89 c3                	mov    %eax,%ebx
  801eff:	83 c4 10             	add    $0x10,%esp
  801f02:	85 c0                	test   %eax,%eax
  801f04:	0f 88 bc 00 00 00    	js     801fc6 <pipe+0x131>
	va = fd2data(fd0);
  801f0a:	83 ec 0c             	sub    $0xc,%esp
  801f0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f10:	e8 2c f1 ff ff       	call   801041 <fd2data>
  801f15:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f17:	83 c4 0c             	add    $0xc,%esp
  801f1a:	68 07 04 00 00       	push   $0x407
  801f1f:	50                   	push   %eax
  801f20:	6a 00                	push   $0x0
  801f22:	e8 15 ee ff ff       	call   800d3c <sys_page_alloc>
  801f27:	89 c3                	mov    %eax,%ebx
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	0f 88 82 00 00 00    	js     801fb6 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f34:	83 ec 0c             	sub    $0xc,%esp
  801f37:	ff 75 f0             	pushl  -0x10(%ebp)
  801f3a:	e8 02 f1 ff ff       	call   801041 <fd2data>
  801f3f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f46:	50                   	push   %eax
  801f47:	6a 00                	push   $0x0
  801f49:	56                   	push   %esi
  801f4a:	6a 00                	push   $0x0
  801f4c:	e8 2e ee ff ff       	call   800d7f <sys_page_map>
  801f51:	89 c3                	mov    %eax,%ebx
  801f53:	83 c4 20             	add    $0x20,%esp
  801f56:	85 c0                	test   %eax,%eax
  801f58:	78 4e                	js     801fa8 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f5a:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f62:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f67:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f6e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f71:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f76:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f7d:	83 ec 0c             	sub    $0xc,%esp
  801f80:	ff 75 f4             	pushl  -0xc(%ebp)
  801f83:	e8 a9 f0 ff ff       	call   801031 <fd2num>
  801f88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f8b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f8d:	83 c4 04             	add    $0x4,%esp
  801f90:	ff 75 f0             	pushl  -0x10(%ebp)
  801f93:	e8 99 f0 ff ff       	call   801031 <fd2num>
  801f98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f9b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f9e:	83 c4 10             	add    $0x10,%esp
  801fa1:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fa6:	eb 2e                	jmp    801fd6 <pipe+0x141>
	sys_page_unmap(0, va);
  801fa8:	83 ec 08             	sub    $0x8,%esp
  801fab:	56                   	push   %esi
  801fac:	6a 00                	push   $0x0
  801fae:	e8 0e ee ff ff       	call   800dc1 <sys_page_unmap>
  801fb3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fb6:	83 ec 08             	sub    $0x8,%esp
  801fb9:	ff 75 f0             	pushl  -0x10(%ebp)
  801fbc:	6a 00                	push   $0x0
  801fbe:	e8 fe ed ff ff       	call   800dc1 <sys_page_unmap>
  801fc3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fc6:	83 ec 08             	sub    $0x8,%esp
  801fc9:	ff 75 f4             	pushl  -0xc(%ebp)
  801fcc:	6a 00                	push   $0x0
  801fce:	e8 ee ed ff ff       	call   800dc1 <sys_page_unmap>
  801fd3:	83 c4 10             	add    $0x10,%esp
}
  801fd6:	89 d8                	mov    %ebx,%eax
  801fd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fdb:	5b                   	pop    %ebx
  801fdc:	5e                   	pop    %esi
  801fdd:	5d                   	pop    %ebp
  801fde:	c3                   	ret    

00801fdf <pipeisclosed>:
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fe5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe8:	50                   	push   %eax
  801fe9:	ff 75 08             	pushl  0x8(%ebp)
  801fec:	e8 b9 f0 ff ff       	call   8010aa <fd_lookup>
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	78 18                	js     802010 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ff8:	83 ec 0c             	sub    $0xc,%esp
  801ffb:	ff 75 f4             	pushl  -0xc(%ebp)
  801ffe:	e8 3e f0 ff ff       	call   801041 <fd2data>
	return _pipeisclosed(fd, p);
  802003:	89 c2                	mov    %eax,%edx
  802005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802008:	e8 2f fd ff ff       	call   801d3c <_pipeisclosed>
  80200d:	83 c4 10             	add    $0x10,%esp
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802012:	b8 00 00 00 00       	mov    $0x0,%eax
  802017:	c3                   	ret    

00802018 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80201e:	68 af 2a 80 00       	push   $0x802aaf
  802023:	ff 75 0c             	pushl  0xc(%ebp)
  802026:	e8 1f e9 ff ff       	call   80094a <strcpy>
	return 0;
}
  80202b:	b8 00 00 00 00       	mov    $0x0,%eax
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <devcons_write>:
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	57                   	push   %edi
  802036:	56                   	push   %esi
  802037:	53                   	push   %ebx
  802038:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80203e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802043:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802049:	3b 75 10             	cmp    0x10(%ebp),%esi
  80204c:	73 31                	jae    80207f <devcons_write+0x4d>
		m = n - tot;
  80204e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802051:	29 f3                	sub    %esi,%ebx
  802053:	83 fb 7f             	cmp    $0x7f,%ebx
  802056:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80205b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80205e:	83 ec 04             	sub    $0x4,%esp
  802061:	53                   	push   %ebx
  802062:	89 f0                	mov    %esi,%eax
  802064:	03 45 0c             	add    0xc(%ebp),%eax
  802067:	50                   	push   %eax
  802068:	57                   	push   %edi
  802069:	e8 6a ea ff ff       	call   800ad8 <memmove>
		sys_cputs(buf, m);
  80206e:	83 c4 08             	add    $0x8,%esp
  802071:	53                   	push   %ebx
  802072:	57                   	push   %edi
  802073:	e8 08 ec ff ff       	call   800c80 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802078:	01 de                	add    %ebx,%esi
  80207a:	83 c4 10             	add    $0x10,%esp
  80207d:	eb ca                	jmp    802049 <devcons_write+0x17>
}
  80207f:	89 f0                	mov    %esi,%eax
  802081:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802084:	5b                   	pop    %ebx
  802085:	5e                   	pop    %esi
  802086:	5f                   	pop    %edi
  802087:	5d                   	pop    %ebp
  802088:	c3                   	ret    

00802089 <devcons_read>:
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	83 ec 08             	sub    $0x8,%esp
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802094:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802098:	74 21                	je     8020bb <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80209a:	e8 ff eb ff ff       	call   800c9e <sys_cgetc>
  80209f:	85 c0                	test   %eax,%eax
  8020a1:	75 07                	jne    8020aa <devcons_read+0x21>
		sys_yield();
  8020a3:	e8 75 ec ff ff       	call   800d1d <sys_yield>
  8020a8:	eb f0                	jmp    80209a <devcons_read+0x11>
	if (c < 0)
  8020aa:	78 0f                	js     8020bb <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020ac:	83 f8 04             	cmp    $0x4,%eax
  8020af:	74 0c                	je     8020bd <devcons_read+0x34>
	*(char*)vbuf = c;
  8020b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b4:	88 02                	mov    %al,(%edx)
	return 1;
  8020b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    
		return 0;
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c2:	eb f7                	jmp    8020bb <devcons_read+0x32>

008020c4 <cputchar>:
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cd:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020d0:	6a 01                	push   $0x1
  8020d2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020d5:	50                   	push   %eax
  8020d6:	e8 a5 eb ff ff       	call   800c80 <sys_cputs>
}
  8020db:	83 c4 10             	add    $0x10,%esp
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <getchar>:
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020e6:	6a 01                	push   $0x1
  8020e8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020eb:	50                   	push   %eax
  8020ec:	6a 00                	push   $0x0
  8020ee:	e8 27 f2 ff ff       	call   80131a <read>
	if (r < 0)
  8020f3:	83 c4 10             	add    $0x10,%esp
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	78 06                	js     802100 <getchar+0x20>
	if (r < 1)
  8020fa:	74 06                	je     802102 <getchar+0x22>
	return c;
  8020fc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802100:	c9                   	leave  
  802101:	c3                   	ret    
		return -E_EOF;
  802102:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802107:	eb f7                	jmp    802100 <getchar+0x20>

00802109 <iscons>:
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
  80210c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80210f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802112:	50                   	push   %eax
  802113:	ff 75 08             	pushl  0x8(%ebp)
  802116:	e8 8f ef ff ff       	call   8010aa <fd_lookup>
  80211b:	83 c4 10             	add    $0x10,%esp
  80211e:	85 c0                	test   %eax,%eax
  802120:	78 11                	js     802133 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802125:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80212b:	39 10                	cmp    %edx,(%eax)
  80212d:	0f 94 c0             	sete   %al
  802130:	0f b6 c0             	movzbl %al,%eax
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <opencons>:
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80213b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80213e:	50                   	push   %eax
  80213f:	e8 14 ef ff ff       	call   801058 <fd_alloc>
  802144:	83 c4 10             	add    $0x10,%esp
  802147:	85 c0                	test   %eax,%eax
  802149:	78 3a                	js     802185 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80214b:	83 ec 04             	sub    $0x4,%esp
  80214e:	68 07 04 00 00       	push   $0x407
  802153:	ff 75 f4             	pushl  -0xc(%ebp)
  802156:	6a 00                	push   $0x0
  802158:	e8 df eb ff ff       	call   800d3c <sys_page_alloc>
  80215d:	83 c4 10             	add    $0x10,%esp
  802160:	85 c0                	test   %eax,%eax
  802162:	78 21                	js     802185 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802167:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80216d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802179:	83 ec 0c             	sub    $0xc,%esp
  80217c:	50                   	push   %eax
  80217d:	e8 af ee ff ff       	call   801031 <fd2num>
  802182:	83 c4 10             	add    $0x10,%esp
}
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	56                   	push   %esi
  80218b:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80218c:	a1 08 40 80 00       	mov    0x804008,%eax
  802191:	8b 40 48             	mov    0x48(%eax),%eax
  802194:	83 ec 04             	sub    $0x4,%esp
  802197:	68 e0 2a 80 00       	push   $0x802ae0
  80219c:	50                   	push   %eax
  80219d:	68 d8 25 80 00       	push   $0x8025d8
  8021a2:	e8 44 e0 ff ff       	call   8001eb <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021a7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021aa:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021b0:	e8 49 eb ff ff       	call   800cfe <sys_getenvid>
  8021b5:	83 c4 04             	add    $0x4,%esp
  8021b8:	ff 75 0c             	pushl  0xc(%ebp)
  8021bb:	ff 75 08             	pushl  0x8(%ebp)
  8021be:	56                   	push   %esi
  8021bf:	50                   	push   %eax
  8021c0:	68 bc 2a 80 00       	push   $0x802abc
  8021c5:	e8 21 e0 ff ff       	call   8001eb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021ca:	83 c4 18             	add    $0x18,%esp
  8021cd:	53                   	push   %ebx
  8021ce:	ff 75 10             	pushl  0x10(%ebp)
  8021d1:	e8 c4 df ff ff       	call   80019a <vcprintf>
	cprintf("\n");
  8021d6:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  8021dd:	e8 09 e0 ff ff       	call   8001eb <cprintf>
  8021e2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021e5:	cc                   	int3   
  8021e6:	eb fd                	jmp    8021e5 <_panic+0x5e>

008021e8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
  8021eb:	56                   	push   %esi
  8021ec:	53                   	push   %ebx
  8021ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8021f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021f6:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021f8:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021fd:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802200:	83 ec 0c             	sub    $0xc,%esp
  802203:	50                   	push   %eax
  802204:	e8 e3 ec ff ff       	call   800eec <sys_ipc_recv>
	if(ret < 0){
  802209:	83 c4 10             	add    $0x10,%esp
  80220c:	85 c0                	test   %eax,%eax
  80220e:	78 2b                	js     80223b <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802210:	85 f6                	test   %esi,%esi
  802212:	74 0a                	je     80221e <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802214:	a1 08 40 80 00       	mov    0x804008,%eax
  802219:	8b 40 78             	mov    0x78(%eax),%eax
  80221c:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80221e:	85 db                	test   %ebx,%ebx
  802220:	74 0a                	je     80222c <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802222:	a1 08 40 80 00       	mov    0x804008,%eax
  802227:	8b 40 7c             	mov    0x7c(%eax),%eax
  80222a:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80222c:	a1 08 40 80 00       	mov    0x804008,%eax
  802231:	8b 40 74             	mov    0x74(%eax),%eax
}
  802234:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802237:	5b                   	pop    %ebx
  802238:	5e                   	pop    %esi
  802239:	5d                   	pop    %ebp
  80223a:	c3                   	ret    
		if(from_env_store)
  80223b:	85 f6                	test   %esi,%esi
  80223d:	74 06                	je     802245 <ipc_recv+0x5d>
			*from_env_store = 0;
  80223f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802245:	85 db                	test   %ebx,%ebx
  802247:	74 eb                	je     802234 <ipc_recv+0x4c>
			*perm_store = 0;
  802249:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80224f:	eb e3                	jmp    802234 <ipc_recv+0x4c>

00802251 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
  802254:	57                   	push   %edi
  802255:	56                   	push   %esi
  802256:	53                   	push   %ebx
  802257:	83 ec 0c             	sub    $0xc,%esp
  80225a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80225d:	8b 75 0c             	mov    0xc(%ebp),%esi
  802260:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802263:	85 db                	test   %ebx,%ebx
  802265:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80226a:	0f 44 d8             	cmove  %eax,%ebx
  80226d:	eb 05                	jmp    802274 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80226f:	e8 a9 ea ff ff       	call   800d1d <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802274:	ff 75 14             	pushl  0x14(%ebp)
  802277:	53                   	push   %ebx
  802278:	56                   	push   %esi
  802279:	57                   	push   %edi
  80227a:	e8 4a ec ff ff       	call   800ec9 <sys_ipc_try_send>
  80227f:	83 c4 10             	add    $0x10,%esp
  802282:	85 c0                	test   %eax,%eax
  802284:	74 1b                	je     8022a1 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802286:	79 e7                	jns    80226f <ipc_send+0x1e>
  802288:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80228b:	74 e2                	je     80226f <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80228d:	83 ec 04             	sub    $0x4,%esp
  802290:	68 e7 2a 80 00       	push   $0x802ae7
  802295:	6a 46                	push   $0x46
  802297:	68 fc 2a 80 00       	push   $0x802afc
  80229c:	e8 e6 fe ff ff       	call   802187 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022a4:	5b                   	pop    %ebx
  8022a5:	5e                   	pop    %esi
  8022a6:	5f                   	pop    %edi
  8022a7:	5d                   	pop    %ebp
  8022a8:	c3                   	ret    

008022a9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022af:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022b4:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8022ba:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022c0:	8b 52 50             	mov    0x50(%edx),%edx
  8022c3:	39 ca                	cmp    %ecx,%edx
  8022c5:	74 11                	je     8022d8 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022c7:	83 c0 01             	add    $0x1,%eax
  8022ca:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022cf:	75 e3                	jne    8022b4 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d6:	eb 0e                	jmp    8022e6 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8022d8:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8022de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022e3:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022e6:	5d                   	pop    %ebp
  8022e7:	c3                   	ret    

008022e8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022ee:	89 d0                	mov    %edx,%eax
  8022f0:	c1 e8 16             	shr    $0x16,%eax
  8022f3:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022fa:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022ff:	f6 c1 01             	test   $0x1,%cl
  802302:	74 1d                	je     802321 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802304:	c1 ea 0c             	shr    $0xc,%edx
  802307:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80230e:	f6 c2 01             	test   $0x1,%dl
  802311:	74 0e                	je     802321 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802313:	c1 ea 0c             	shr    $0xc,%edx
  802316:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80231d:	ef 
  80231e:	0f b7 c0             	movzwl %ax,%eax
}
  802321:	5d                   	pop    %ebp
  802322:	c3                   	ret    
  802323:	66 90                	xchg   %ax,%ax
  802325:	66 90                	xchg   %ax,%ax
  802327:	66 90                	xchg   %ax,%ax
  802329:	66 90                	xchg   %ax,%ax
  80232b:	66 90                	xchg   %ax,%ax
  80232d:	66 90                	xchg   %ax,%ax
  80232f:	90                   	nop

00802330 <__udivdi3>:
  802330:	55                   	push   %ebp
  802331:	57                   	push   %edi
  802332:	56                   	push   %esi
  802333:	53                   	push   %ebx
  802334:	83 ec 1c             	sub    $0x1c,%esp
  802337:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80233b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80233f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802343:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802347:	85 d2                	test   %edx,%edx
  802349:	75 4d                	jne    802398 <__udivdi3+0x68>
  80234b:	39 f3                	cmp    %esi,%ebx
  80234d:	76 19                	jbe    802368 <__udivdi3+0x38>
  80234f:	31 ff                	xor    %edi,%edi
  802351:	89 e8                	mov    %ebp,%eax
  802353:	89 f2                	mov    %esi,%edx
  802355:	f7 f3                	div    %ebx
  802357:	89 fa                	mov    %edi,%edx
  802359:	83 c4 1c             	add    $0x1c,%esp
  80235c:	5b                   	pop    %ebx
  80235d:	5e                   	pop    %esi
  80235e:	5f                   	pop    %edi
  80235f:	5d                   	pop    %ebp
  802360:	c3                   	ret    
  802361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802368:	89 d9                	mov    %ebx,%ecx
  80236a:	85 db                	test   %ebx,%ebx
  80236c:	75 0b                	jne    802379 <__udivdi3+0x49>
  80236e:	b8 01 00 00 00       	mov    $0x1,%eax
  802373:	31 d2                	xor    %edx,%edx
  802375:	f7 f3                	div    %ebx
  802377:	89 c1                	mov    %eax,%ecx
  802379:	31 d2                	xor    %edx,%edx
  80237b:	89 f0                	mov    %esi,%eax
  80237d:	f7 f1                	div    %ecx
  80237f:	89 c6                	mov    %eax,%esi
  802381:	89 e8                	mov    %ebp,%eax
  802383:	89 f7                	mov    %esi,%edi
  802385:	f7 f1                	div    %ecx
  802387:	89 fa                	mov    %edi,%edx
  802389:	83 c4 1c             	add    $0x1c,%esp
  80238c:	5b                   	pop    %ebx
  80238d:	5e                   	pop    %esi
  80238e:	5f                   	pop    %edi
  80238f:	5d                   	pop    %ebp
  802390:	c3                   	ret    
  802391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802398:	39 f2                	cmp    %esi,%edx
  80239a:	77 1c                	ja     8023b8 <__udivdi3+0x88>
  80239c:	0f bd fa             	bsr    %edx,%edi
  80239f:	83 f7 1f             	xor    $0x1f,%edi
  8023a2:	75 2c                	jne    8023d0 <__udivdi3+0xa0>
  8023a4:	39 f2                	cmp    %esi,%edx
  8023a6:	72 06                	jb     8023ae <__udivdi3+0x7e>
  8023a8:	31 c0                	xor    %eax,%eax
  8023aa:	39 eb                	cmp    %ebp,%ebx
  8023ac:	77 a9                	ja     802357 <__udivdi3+0x27>
  8023ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b3:	eb a2                	jmp    802357 <__udivdi3+0x27>
  8023b5:	8d 76 00             	lea    0x0(%esi),%esi
  8023b8:	31 ff                	xor    %edi,%edi
  8023ba:	31 c0                	xor    %eax,%eax
  8023bc:	89 fa                	mov    %edi,%edx
  8023be:	83 c4 1c             	add    $0x1c,%esp
  8023c1:	5b                   	pop    %ebx
  8023c2:	5e                   	pop    %esi
  8023c3:	5f                   	pop    %edi
  8023c4:	5d                   	pop    %ebp
  8023c5:	c3                   	ret    
  8023c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023cd:	8d 76 00             	lea    0x0(%esi),%esi
  8023d0:	89 f9                	mov    %edi,%ecx
  8023d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023d7:	29 f8                	sub    %edi,%eax
  8023d9:	d3 e2                	shl    %cl,%edx
  8023db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023df:	89 c1                	mov    %eax,%ecx
  8023e1:	89 da                	mov    %ebx,%edx
  8023e3:	d3 ea                	shr    %cl,%edx
  8023e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023e9:	09 d1                	or     %edx,%ecx
  8023eb:	89 f2                	mov    %esi,%edx
  8023ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023f1:	89 f9                	mov    %edi,%ecx
  8023f3:	d3 e3                	shl    %cl,%ebx
  8023f5:	89 c1                	mov    %eax,%ecx
  8023f7:	d3 ea                	shr    %cl,%edx
  8023f9:	89 f9                	mov    %edi,%ecx
  8023fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023ff:	89 eb                	mov    %ebp,%ebx
  802401:	d3 e6                	shl    %cl,%esi
  802403:	89 c1                	mov    %eax,%ecx
  802405:	d3 eb                	shr    %cl,%ebx
  802407:	09 de                	or     %ebx,%esi
  802409:	89 f0                	mov    %esi,%eax
  80240b:	f7 74 24 08          	divl   0x8(%esp)
  80240f:	89 d6                	mov    %edx,%esi
  802411:	89 c3                	mov    %eax,%ebx
  802413:	f7 64 24 0c          	mull   0xc(%esp)
  802417:	39 d6                	cmp    %edx,%esi
  802419:	72 15                	jb     802430 <__udivdi3+0x100>
  80241b:	89 f9                	mov    %edi,%ecx
  80241d:	d3 e5                	shl    %cl,%ebp
  80241f:	39 c5                	cmp    %eax,%ebp
  802421:	73 04                	jae    802427 <__udivdi3+0xf7>
  802423:	39 d6                	cmp    %edx,%esi
  802425:	74 09                	je     802430 <__udivdi3+0x100>
  802427:	89 d8                	mov    %ebx,%eax
  802429:	31 ff                	xor    %edi,%edi
  80242b:	e9 27 ff ff ff       	jmp    802357 <__udivdi3+0x27>
  802430:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802433:	31 ff                	xor    %edi,%edi
  802435:	e9 1d ff ff ff       	jmp    802357 <__udivdi3+0x27>
  80243a:	66 90                	xchg   %ax,%ax
  80243c:	66 90                	xchg   %ax,%ax
  80243e:	66 90                	xchg   %ax,%ax

00802440 <__umoddi3>:
  802440:	55                   	push   %ebp
  802441:	57                   	push   %edi
  802442:	56                   	push   %esi
  802443:	53                   	push   %ebx
  802444:	83 ec 1c             	sub    $0x1c,%esp
  802447:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80244b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80244f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802453:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802457:	89 da                	mov    %ebx,%edx
  802459:	85 c0                	test   %eax,%eax
  80245b:	75 43                	jne    8024a0 <__umoddi3+0x60>
  80245d:	39 df                	cmp    %ebx,%edi
  80245f:	76 17                	jbe    802478 <__umoddi3+0x38>
  802461:	89 f0                	mov    %esi,%eax
  802463:	f7 f7                	div    %edi
  802465:	89 d0                	mov    %edx,%eax
  802467:	31 d2                	xor    %edx,%edx
  802469:	83 c4 1c             	add    $0x1c,%esp
  80246c:	5b                   	pop    %ebx
  80246d:	5e                   	pop    %esi
  80246e:	5f                   	pop    %edi
  80246f:	5d                   	pop    %ebp
  802470:	c3                   	ret    
  802471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802478:	89 fd                	mov    %edi,%ebp
  80247a:	85 ff                	test   %edi,%edi
  80247c:	75 0b                	jne    802489 <__umoddi3+0x49>
  80247e:	b8 01 00 00 00       	mov    $0x1,%eax
  802483:	31 d2                	xor    %edx,%edx
  802485:	f7 f7                	div    %edi
  802487:	89 c5                	mov    %eax,%ebp
  802489:	89 d8                	mov    %ebx,%eax
  80248b:	31 d2                	xor    %edx,%edx
  80248d:	f7 f5                	div    %ebp
  80248f:	89 f0                	mov    %esi,%eax
  802491:	f7 f5                	div    %ebp
  802493:	89 d0                	mov    %edx,%eax
  802495:	eb d0                	jmp    802467 <__umoddi3+0x27>
  802497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80249e:	66 90                	xchg   %ax,%ax
  8024a0:	89 f1                	mov    %esi,%ecx
  8024a2:	39 d8                	cmp    %ebx,%eax
  8024a4:	76 0a                	jbe    8024b0 <__umoddi3+0x70>
  8024a6:	89 f0                	mov    %esi,%eax
  8024a8:	83 c4 1c             	add    $0x1c,%esp
  8024ab:	5b                   	pop    %ebx
  8024ac:	5e                   	pop    %esi
  8024ad:	5f                   	pop    %edi
  8024ae:	5d                   	pop    %ebp
  8024af:	c3                   	ret    
  8024b0:	0f bd e8             	bsr    %eax,%ebp
  8024b3:	83 f5 1f             	xor    $0x1f,%ebp
  8024b6:	75 20                	jne    8024d8 <__umoddi3+0x98>
  8024b8:	39 d8                	cmp    %ebx,%eax
  8024ba:	0f 82 b0 00 00 00    	jb     802570 <__umoddi3+0x130>
  8024c0:	39 f7                	cmp    %esi,%edi
  8024c2:	0f 86 a8 00 00 00    	jbe    802570 <__umoddi3+0x130>
  8024c8:	89 c8                	mov    %ecx,%eax
  8024ca:	83 c4 1c             	add    $0x1c,%esp
  8024cd:	5b                   	pop    %ebx
  8024ce:	5e                   	pop    %esi
  8024cf:	5f                   	pop    %edi
  8024d0:	5d                   	pop    %ebp
  8024d1:	c3                   	ret    
  8024d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024d8:	89 e9                	mov    %ebp,%ecx
  8024da:	ba 20 00 00 00       	mov    $0x20,%edx
  8024df:	29 ea                	sub    %ebp,%edx
  8024e1:	d3 e0                	shl    %cl,%eax
  8024e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024e7:	89 d1                	mov    %edx,%ecx
  8024e9:	89 f8                	mov    %edi,%eax
  8024eb:	d3 e8                	shr    %cl,%eax
  8024ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024f9:	09 c1                	or     %eax,%ecx
  8024fb:	89 d8                	mov    %ebx,%eax
  8024fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802501:	89 e9                	mov    %ebp,%ecx
  802503:	d3 e7                	shl    %cl,%edi
  802505:	89 d1                	mov    %edx,%ecx
  802507:	d3 e8                	shr    %cl,%eax
  802509:	89 e9                	mov    %ebp,%ecx
  80250b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80250f:	d3 e3                	shl    %cl,%ebx
  802511:	89 c7                	mov    %eax,%edi
  802513:	89 d1                	mov    %edx,%ecx
  802515:	89 f0                	mov    %esi,%eax
  802517:	d3 e8                	shr    %cl,%eax
  802519:	89 e9                	mov    %ebp,%ecx
  80251b:	89 fa                	mov    %edi,%edx
  80251d:	d3 e6                	shl    %cl,%esi
  80251f:	09 d8                	or     %ebx,%eax
  802521:	f7 74 24 08          	divl   0x8(%esp)
  802525:	89 d1                	mov    %edx,%ecx
  802527:	89 f3                	mov    %esi,%ebx
  802529:	f7 64 24 0c          	mull   0xc(%esp)
  80252d:	89 c6                	mov    %eax,%esi
  80252f:	89 d7                	mov    %edx,%edi
  802531:	39 d1                	cmp    %edx,%ecx
  802533:	72 06                	jb     80253b <__umoddi3+0xfb>
  802535:	75 10                	jne    802547 <__umoddi3+0x107>
  802537:	39 c3                	cmp    %eax,%ebx
  802539:	73 0c                	jae    802547 <__umoddi3+0x107>
  80253b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80253f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802543:	89 d7                	mov    %edx,%edi
  802545:	89 c6                	mov    %eax,%esi
  802547:	89 ca                	mov    %ecx,%edx
  802549:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80254e:	29 f3                	sub    %esi,%ebx
  802550:	19 fa                	sbb    %edi,%edx
  802552:	89 d0                	mov    %edx,%eax
  802554:	d3 e0                	shl    %cl,%eax
  802556:	89 e9                	mov    %ebp,%ecx
  802558:	d3 eb                	shr    %cl,%ebx
  80255a:	d3 ea                	shr    %cl,%edx
  80255c:	09 d8                	or     %ebx,%eax
  80255e:	83 c4 1c             	add    $0x1c,%esp
  802561:	5b                   	pop    %ebx
  802562:	5e                   	pop    %esi
  802563:	5f                   	pop    %edi
  802564:	5d                   	pop    %ebp
  802565:	c3                   	ret    
  802566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80256d:	8d 76 00             	lea    0x0(%esi),%esi
  802570:	89 da                	mov    %ebx,%edx
  802572:	29 fe                	sub    %edi,%esi
  802574:	19 c2                	sbb    %eax,%edx
  802576:	89 f1                	mov    %esi,%ecx
  802578:	89 c8                	mov    %ecx,%eax
  80257a:	e9 4b ff ff ff       	jmp    8024ca <__umoddi3+0x8a>
