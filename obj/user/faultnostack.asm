
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
  800039:	68 3e 10 80 00       	push   $0x80103e
  80003e:	6a 00                	push   $0x0
  800040:	e8 4f 0e 00 00       	call   800e94 <sys_env_set_pgfault_upcall>
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
  800067:	e8 9f 0c 00 00       	call   800d0b <sys_getenvid>
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
  80008c:	74 23                	je     8000b1 <libmain+0x5d>
		if(envs[i].env_id == find)
  80008e:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800094:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80009a:	8b 49 48             	mov    0x48(%ecx),%ecx
  80009d:	39 c1                	cmp    %eax,%ecx
  80009f:	75 e2                	jne    800083 <libmain+0x2f>
  8000a1:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8000a7:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000ad:	89 fe                	mov    %edi,%esi
  8000af:	eb d2                	jmp    800083 <libmain+0x2f>
  8000b1:	89 f0                	mov    %esi,%eax
  8000b3:	84 c0                	test   %al,%al
  8000b5:	74 06                	je     8000bd <libmain+0x69>
  8000b7:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000c1:	7e 0a                	jle    8000cd <libmain+0x79>
		binaryname = argv[0];
  8000c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c6:	8b 00                	mov    (%eax),%eax
  8000c8:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000cd:	a1 08 40 80 00       	mov    0x804008,%eax
  8000d2:	8b 40 48             	mov    0x48(%eax),%eax
  8000d5:	83 ec 08             	sub    $0x8,%esp
  8000d8:	50                   	push   %eax
  8000d9:	68 20 26 80 00       	push   $0x802620
  8000de:	e8 15 01 00 00       	call   8001f8 <cprintf>
	cprintf("before umain\n");
  8000e3:	c7 04 24 3e 26 80 00 	movl   $0x80263e,(%esp)
  8000ea:	e8 09 01 00 00       	call   8001f8 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000ef:	83 c4 08             	add    $0x8,%esp
  8000f2:	ff 75 0c             	pushl  0xc(%ebp)
  8000f5:	ff 75 08             	pushl  0x8(%ebp)
  8000f8:	e8 36 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000fd:	c7 04 24 4c 26 80 00 	movl   $0x80264c,(%esp)
  800104:	e8 ef 00 00 00       	call   8001f8 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800109:	a1 08 40 80 00       	mov    0x804008,%eax
  80010e:	8b 40 48             	mov    0x48(%eax),%eax
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	50                   	push   %eax
  800115:	68 59 26 80 00       	push   $0x802659
  80011a:	e8 d9 00 00 00       	call   8001f8 <cprintf>
	// exit gracefully
	exit();
  80011f:	e8 0b 00 00 00       	call   80012f <exit>
}
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80012a:	5b                   	pop    %ebx
  80012b:	5e                   	pop    %esi
  80012c:	5f                   	pop    %edi
  80012d:	5d                   	pop    %ebp
  80012e:	c3                   	ret    

0080012f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800135:	a1 08 40 80 00       	mov    0x804008,%eax
  80013a:	8b 40 48             	mov    0x48(%eax),%eax
  80013d:	68 84 26 80 00       	push   $0x802684
  800142:	50                   	push   %eax
  800143:	68 78 26 80 00       	push   $0x802678
  800148:	e8 ab 00 00 00       	call   8001f8 <cprintf>
	close_all();
  80014d:	e8 ea 10 00 00       	call   80123c <close_all>
	sys_env_destroy(0);
  800152:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800159:	e8 6c 0b 00 00       	call   800cca <sys_env_destroy>
}
  80015e:	83 c4 10             	add    $0x10,%esp
  800161:	c9                   	leave  
  800162:	c3                   	ret    

00800163 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	53                   	push   %ebx
  800167:	83 ec 04             	sub    $0x4,%esp
  80016a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80016d:	8b 13                	mov    (%ebx),%edx
  80016f:	8d 42 01             	lea    0x1(%edx),%eax
  800172:	89 03                	mov    %eax,(%ebx)
  800174:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800177:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80017b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800180:	74 09                	je     80018b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800182:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800186:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800189:	c9                   	leave  
  80018a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	68 ff 00 00 00       	push   $0xff
  800193:	8d 43 08             	lea    0x8(%ebx),%eax
  800196:	50                   	push   %eax
  800197:	e8 f1 0a 00 00       	call   800c8d <sys_cputs>
		b->idx = 0;
  80019c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001a2:	83 c4 10             	add    $0x10,%esp
  8001a5:	eb db                	jmp    800182 <putch+0x1f>

008001a7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b7:	00 00 00 
	b.cnt = 0;
  8001ba:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c4:	ff 75 0c             	pushl  0xc(%ebp)
  8001c7:	ff 75 08             	pushl  0x8(%ebp)
  8001ca:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d0:	50                   	push   %eax
  8001d1:	68 63 01 80 00       	push   $0x800163
  8001d6:	e8 4a 01 00 00       	call   800325 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001db:	83 c4 08             	add    $0x8,%esp
  8001de:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ea:	50                   	push   %eax
  8001eb:	e8 9d 0a 00 00       	call   800c8d <sys_cputs>

	return b.cnt;
}
  8001f0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f6:	c9                   	leave  
  8001f7:	c3                   	ret    

008001f8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f8:	55                   	push   %ebp
  8001f9:	89 e5                	mov    %esp,%ebp
  8001fb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fe:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800201:	50                   	push   %eax
  800202:	ff 75 08             	pushl  0x8(%ebp)
  800205:	e8 9d ff ff ff       	call   8001a7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	57                   	push   %edi
  800210:	56                   	push   %esi
  800211:	53                   	push   %ebx
  800212:	83 ec 1c             	sub    $0x1c,%esp
  800215:	89 c6                	mov    %eax,%esi
  800217:	89 d7                	mov    %edx,%edi
  800219:	8b 45 08             	mov    0x8(%ebp),%eax
  80021c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800222:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800225:	8b 45 10             	mov    0x10(%ebp),%eax
  800228:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80022b:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80022f:	74 2c                	je     80025d <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800231:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800234:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80023b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80023e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800241:	39 c2                	cmp    %eax,%edx
  800243:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800246:	73 43                	jae    80028b <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800248:	83 eb 01             	sub    $0x1,%ebx
  80024b:	85 db                	test   %ebx,%ebx
  80024d:	7e 6c                	jle    8002bb <printnum+0xaf>
				putch(padc, putdat);
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	57                   	push   %edi
  800253:	ff 75 18             	pushl  0x18(%ebp)
  800256:	ff d6                	call   *%esi
  800258:	83 c4 10             	add    $0x10,%esp
  80025b:	eb eb                	jmp    800248 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80025d:	83 ec 0c             	sub    $0xc,%esp
  800260:	6a 20                	push   $0x20
  800262:	6a 00                	push   $0x0
  800264:	50                   	push   %eax
  800265:	ff 75 e4             	pushl  -0x1c(%ebp)
  800268:	ff 75 e0             	pushl  -0x20(%ebp)
  80026b:	89 fa                	mov    %edi,%edx
  80026d:	89 f0                	mov    %esi,%eax
  80026f:	e8 98 ff ff ff       	call   80020c <printnum>
		while (--width > 0)
  800274:	83 c4 20             	add    $0x20,%esp
  800277:	83 eb 01             	sub    $0x1,%ebx
  80027a:	85 db                	test   %ebx,%ebx
  80027c:	7e 65                	jle    8002e3 <printnum+0xd7>
			putch(padc, putdat);
  80027e:	83 ec 08             	sub    $0x8,%esp
  800281:	57                   	push   %edi
  800282:	6a 20                	push   $0x20
  800284:	ff d6                	call   *%esi
  800286:	83 c4 10             	add    $0x10,%esp
  800289:	eb ec                	jmp    800277 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	ff 75 18             	pushl  0x18(%ebp)
  800291:	83 eb 01             	sub    $0x1,%ebx
  800294:	53                   	push   %ebx
  800295:	50                   	push   %eax
  800296:	83 ec 08             	sub    $0x8,%esp
  800299:	ff 75 dc             	pushl  -0x24(%ebp)
  80029c:	ff 75 d8             	pushl  -0x28(%ebp)
  80029f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a5:	e8 26 21 00 00       	call   8023d0 <__udivdi3>
  8002aa:	83 c4 18             	add    $0x18,%esp
  8002ad:	52                   	push   %edx
  8002ae:	50                   	push   %eax
  8002af:	89 fa                	mov    %edi,%edx
  8002b1:	89 f0                	mov    %esi,%eax
  8002b3:	e8 54 ff ff ff       	call   80020c <printnum>
  8002b8:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002bb:	83 ec 08             	sub    $0x8,%esp
  8002be:	57                   	push   %edi
  8002bf:	83 ec 04             	sub    $0x4,%esp
  8002c2:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002cb:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ce:	e8 0d 22 00 00       	call   8024e0 <__umoddi3>
  8002d3:	83 c4 14             	add    $0x14,%esp
  8002d6:	0f be 80 89 26 80 00 	movsbl 0x802689(%eax),%eax
  8002dd:	50                   	push   %eax
  8002de:	ff d6                	call   *%esi
  8002e0:	83 c4 10             	add    $0x10,%esp
	}
}
  8002e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e6:	5b                   	pop    %ebx
  8002e7:	5e                   	pop    %esi
  8002e8:	5f                   	pop    %edi
  8002e9:	5d                   	pop    %ebp
  8002ea:	c3                   	ret    

008002eb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002eb:	55                   	push   %ebp
  8002ec:	89 e5                	mov    %esp,%ebp
  8002ee:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f5:	8b 10                	mov    (%eax),%edx
  8002f7:	3b 50 04             	cmp    0x4(%eax),%edx
  8002fa:	73 0a                	jae    800306 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002fc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ff:	89 08                	mov    %ecx,(%eax)
  800301:	8b 45 08             	mov    0x8(%ebp),%eax
  800304:	88 02                	mov    %al,(%edx)
}
  800306:	5d                   	pop    %ebp
  800307:	c3                   	ret    

00800308 <printfmt>:
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80030e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800311:	50                   	push   %eax
  800312:	ff 75 10             	pushl  0x10(%ebp)
  800315:	ff 75 0c             	pushl  0xc(%ebp)
  800318:	ff 75 08             	pushl  0x8(%ebp)
  80031b:	e8 05 00 00 00       	call   800325 <vprintfmt>
}
  800320:	83 c4 10             	add    $0x10,%esp
  800323:	c9                   	leave  
  800324:	c3                   	ret    

00800325 <vprintfmt>:
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	57                   	push   %edi
  800329:	56                   	push   %esi
  80032a:	53                   	push   %ebx
  80032b:	83 ec 3c             	sub    $0x3c,%esp
  80032e:	8b 75 08             	mov    0x8(%ebp),%esi
  800331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800334:	8b 7d 10             	mov    0x10(%ebp),%edi
  800337:	e9 32 04 00 00       	jmp    80076e <vprintfmt+0x449>
		padc = ' ';
  80033c:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800340:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800347:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80034e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800355:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80035c:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800363:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800368:	8d 47 01             	lea    0x1(%edi),%eax
  80036b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036e:	0f b6 17             	movzbl (%edi),%edx
  800371:	8d 42 dd             	lea    -0x23(%edx),%eax
  800374:	3c 55                	cmp    $0x55,%al
  800376:	0f 87 12 05 00 00    	ja     80088e <vprintfmt+0x569>
  80037c:	0f b6 c0             	movzbl %al,%eax
  80037f:	ff 24 85 60 28 80 00 	jmp    *0x802860(,%eax,4)
  800386:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800389:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80038d:	eb d9                	jmp    800368 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800392:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800396:	eb d0                	jmp    800368 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800398:	0f b6 d2             	movzbl %dl,%edx
  80039b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80039e:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a3:	89 75 08             	mov    %esi,0x8(%ebp)
  8003a6:	eb 03                	jmp    8003ab <vprintfmt+0x86>
  8003a8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003ab:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ae:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003b2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003b5:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003b8:	83 fe 09             	cmp    $0x9,%esi
  8003bb:	76 eb                	jbe    8003a8 <vprintfmt+0x83>
  8003bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c3:	eb 14                	jmp    8003d9 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d0:	8d 40 04             	lea    0x4(%eax),%eax
  8003d3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003dd:	79 89                	jns    800368 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003ec:	e9 77 ff ff ff       	jmp    800368 <vprintfmt+0x43>
  8003f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f4:	85 c0                	test   %eax,%eax
  8003f6:	0f 48 c1             	cmovs  %ecx,%eax
  8003f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ff:	e9 64 ff ff ff       	jmp    800368 <vprintfmt+0x43>
  800404:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800407:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80040e:	e9 55 ff ff ff       	jmp    800368 <vprintfmt+0x43>
			lflag++;
  800413:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800417:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80041a:	e9 49 ff ff ff       	jmp    800368 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80041f:	8b 45 14             	mov    0x14(%ebp),%eax
  800422:	8d 78 04             	lea    0x4(%eax),%edi
  800425:	83 ec 08             	sub    $0x8,%esp
  800428:	53                   	push   %ebx
  800429:	ff 30                	pushl  (%eax)
  80042b:	ff d6                	call   *%esi
			break;
  80042d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800430:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800433:	e9 33 03 00 00       	jmp    80076b <vprintfmt+0x446>
			err = va_arg(ap, int);
  800438:	8b 45 14             	mov    0x14(%ebp),%eax
  80043b:	8d 78 04             	lea    0x4(%eax),%edi
  80043e:	8b 00                	mov    (%eax),%eax
  800440:	99                   	cltd   
  800441:	31 d0                	xor    %edx,%eax
  800443:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800445:	83 f8 11             	cmp    $0x11,%eax
  800448:	7f 23                	jg     80046d <vprintfmt+0x148>
  80044a:	8b 14 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edx
  800451:	85 d2                	test   %edx,%edx
  800453:	74 18                	je     80046d <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800455:	52                   	push   %edx
  800456:	68 dd 2a 80 00       	push   $0x802add
  80045b:	53                   	push   %ebx
  80045c:	56                   	push   %esi
  80045d:	e8 a6 fe ff ff       	call   800308 <printfmt>
  800462:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800465:	89 7d 14             	mov    %edi,0x14(%ebp)
  800468:	e9 fe 02 00 00       	jmp    80076b <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80046d:	50                   	push   %eax
  80046e:	68 a1 26 80 00       	push   $0x8026a1
  800473:	53                   	push   %ebx
  800474:	56                   	push   %esi
  800475:	e8 8e fe ff ff       	call   800308 <printfmt>
  80047a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800480:	e9 e6 02 00 00       	jmp    80076b <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800485:	8b 45 14             	mov    0x14(%ebp),%eax
  800488:	83 c0 04             	add    $0x4,%eax
  80048b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80048e:	8b 45 14             	mov    0x14(%ebp),%eax
  800491:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800493:	85 c9                	test   %ecx,%ecx
  800495:	b8 9a 26 80 00       	mov    $0x80269a,%eax
  80049a:	0f 45 c1             	cmovne %ecx,%eax
  80049d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a4:	7e 06                	jle    8004ac <vprintfmt+0x187>
  8004a6:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004aa:	75 0d                	jne    8004b9 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004af:	89 c7                	mov    %eax,%edi
  8004b1:	03 45 e0             	add    -0x20(%ebp),%eax
  8004b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b7:	eb 53                	jmp    80050c <vprintfmt+0x1e7>
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8004bf:	50                   	push   %eax
  8004c0:	e8 71 04 00 00       	call   800936 <strnlen>
  8004c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c8:	29 c1                	sub    %eax,%ecx
  8004ca:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004d2:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d9:	eb 0f                	jmp    8004ea <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	53                   	push   %ebx
  8004df:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e4:	83 ef 01             	sub    $0x1,%edi
  8004e7:	83 c4 10             	add    $0x10,%esp
  8004ea:	85 ff                	test   %edi,%edi
  8004ec:	7f ed                	jg     8004db <vprintfmt+0x1b6>
  8004ee:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004f1:	85 c9                	test   %ecx,%ecx
  8004f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f8:	0f 49 c1             	cmovns %ecx,%eax
  8004fb:	29 c1                	sub    %eax,%ecx
  8004fd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800500:	eb aa                	jmp    8004ac <vprintfmt+0x187>
					putch(ch, putdat);
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	53                   	push   %ebx
  800506:	52                   	push   %edx
  800507:	ff d6                	call   *%esi
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80050f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800511:	83 c7 01             	add    $0x1,%edi
  800514:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800518:	0f be d0             	movsbl %al,%edx
  80051b:	85 d2                	test   %edx,%edx
  80051d:	74 4b                	je     80056a <vprintfmt+0x245>
  80051f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800523:	78 06                	js     80052b <vprintfmt+0x206>
  800525:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800529:	78 1e                	js     800549 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80052b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80052f:	74 d1                	je     800502 <vprintfmt+0x1dd>
  800531:	0f be c0             	movsbl %al,%eax
  800534:	83 e8 20             	sub    $0x20,%eax
  800537:	83 f8 5e             	cmp    $0x5e,%eax
  80053a:	76 c6                	jbe    800502 <vprintfmt+0x1dd>
					putch('?', putdat);
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	53                   	push   %ebx
  800540:	6a 3f                	push   $0x3f
  800542:	ff d6                	call   *%esi
  800544:	83 c4 10             	add    $0x10,%esp
  800547:	eb c3                	jmp    80050c <vprintfmt+0x1e7>
  800549:	89 cf                	mov    %ecx,%edi
  80054b:	eb 0e                	jmp    80055b <vprintfmt+0x236>
				putch(' ', putdat);
  80054d:	83 ec 08             	sub    $0x8,%esp
  800550:	53                   	push   %ebx
  800551:	6a 20                	push   $0x20
  800553:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800555:	83 ef 01             	sub    $0x1,%edi
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	85 ff                	test   %edi,%edi
  80055d:	7f ee                	jg     80054d <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80055f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800562:	89 45 14             	mov    %eax,0x14(%ebp)
  800565:	e9 01 02 00 00       	jmp    80076b <vprintfmt+0x446>
  80056a:	89 cf                	mov    %ecx,%edi
  80056c:	eb ed                	jmp    80055b <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80056e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800571:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800578:	e9 eb fd ff ff       	jmp    800368 <vprintfmt+0x43>
	if (lflag >= 2)
  80057d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800581:	7f 21                	jg     8005a4 <vprintfmt+0x27f>
	else if (lflag)
  800583:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800587:	74 68                	je     8005f1 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800591:	89 c1                	mov    %eax,%ecx
  800593:	c1 f9 1f             	sar    $0x1f,%ecx
  800596:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800599:	8b 45 14             	mov    0x14(%ebp),%eax
  80059c:	8d 40 04             	lea    0x4(%eax),%eax
  80059f:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a2:	eb 17                	jmp    8005bb <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8b 50 04             	mov    0x4(%eax),%edx
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005af:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8d 40 08             	lea    0x8(%eax),%eax
  8005b8:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005c7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005cb:	78 3f                	js     80060c <vprintfmt+0x2e7>
			base = 10;
  8005cd:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005d2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005d6:	0f 84 71 01 00 00    	je     80074d <vprintfmt+0x428>
				putch('+', putdat);
  8005dc:	83 ec 08             	sub    $0x8,%esp
  8005df:	53                   	push   %ebx
  8005e0:	6a 2b                	push   $0x2b
  8005e2:	ff d6                	call   *%esi
  8005e4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ec:	e9 5c 01 00 00       	jmp    80074d <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	8b 00                	mov    (%eax),%eax
  8005f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f9:	89 c1                	mov    %eax,%ecx
  8005fb:	c1 f9 1f             	sar    $0x1f,%ecx
  8005fe:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8d 40 04             	lea    0x4(%eax),%eax
  800607:	89 45 14             	mov    %eax,0x14(%ebp)
  80060a:	eb af                	jmp    8005bb <vprintfmt+0x296>
				putch('-', putdat);
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	53                   	push   %ebx
  800610:	6a 2d                	push   $0x2d
  800612:	ff d6                	call   *%esi
				num = -(long long) num;
  800614:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800617:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80061a:	f7 d8                	neg    %eax
  80061c:	83 d2 00             	adc    $0x0,%edx
  80061f:	f7 da                	neg    %edx
  800621:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800624:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800627:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062f:	e9 19 01 00 00       	jmp    80074d <vprintfmt+0x428>
	if (lflag >= 2)
  800634:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800638:	7f 29                	jg     800663 <vprintfmt+0x33e>
	else if (lflag)
  80063a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80063e:	74 44                	je     800684 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	ba 00 00 00 00       	mov    $0x0,%edx
  80064a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8d 40 04             	lea    0x4(%eax),%eax
  800656:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800659:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065e:	e9 ea 00 00 00       	jmp    80074d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8b 50 04             	mov    0x4(%eax),%edx
  800669:	8b 00                	mov    (%eax),%eax
  80066b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8d 40 08             	lea    0x8(%eax),%eax
  800677:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067f:	e9 c9 00 00 00       	jmp    80074d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800691:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8d 40 04             	lea    0x4(%eax),%eax
  80069a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069d:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a2:	e9 a6 00 00 00       	jmp    80074d <vprintfmt+0x428>
			putch('0', putdat);
  8006a7:	83 ec 08             	sub    $0x8,%esp
  8006aa:	53                   	push   %ebx
  8006ab:	6a 30                	push   $0x30
  8006ad:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006af:	83 c4 10             	add    $0x10,%esp
  8006b2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006b6:	7f 26                	jg     8006de <vprintfmt+0x3b9>
	else if (lflag)
  8006b8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006bc:	74 3e                	je     8006fc <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8d 40 04             	lea    0x4(%eax),%eax
  8006d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d7:	b8 08 00 00 00       	mov    $0x8,%eax
  8006dc:	eb 6f                	jmp    80074d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8b 50 04             	mov    0x4(%eax),%edx
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8d 40 08             	lea    0x8(%eax),%eax
  8006f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f5:	b8 08 00 00 00       	mov    $0x8,%eax
  8006fa:	eb 51                	jmp    80074d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	ba 00 00 00 00       	mov    $0x0,%edx
  800706:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800709:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	8d 40 04             	lea    0x4(%eax),%eax
  800712:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800715:	b8 08 00 00 00       	mov    $0x8,%eax
  80071a:	eb 31                	jmp    80074d <vprintfmt+0x428>
			putch('0', putdat);
  80071c:	83 ec 08             	sub    $0x8,%esp
  80071f:	53                   	push   %ebx
  800720:	6a 30                	push   $0x30
  800722:	ff d6                	call   *%esi
			putch('x', putdat);
  800724:	83 c4 08             	add    $0x8,%esp
  800727:	53                   	push   %ebx
  800728:	6a 78                	push   $0x78
  80072a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	ba 00 00 00 00       	mov    $0x0,%edx
  800736:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800739:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80073c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8d 40 04             	lea    0x4(%eax),%eax
  800745:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800748:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80074d:	83 ec 0c             	sub    $0xc,%esp
  800750:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800754:	52                   	push   %edx
  800755:	ff 75 e0             	pushl  -0x20(%ebp)
  800758:	50                   	push   %eax
  800759:	ff 75 dc             	pushl  -0x24(%ebp)
  80075c:	ff 75 d8             	pushl  -0x28(%ebp)
  80075f:	89 da                	mov    %ebx,%edx
  800761:	89 f0                	mov    %esi,%eax
  800763:	e8 a4 fa ff ff       	call   80020c <printnum>
			break;
  800768:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80076b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076e:	83 c7 01             	add    $0x1,%edi
  800771:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800775:	83 f8 25             	cmp    $0x25,%eax
  800778:	0f 84 be fb ff ff    	je     80033c <vprintfmt+0x17>
			if (ch == '\0')
  80077e:	85 c0                	test   %eax,%eax
  800780:	0f 84 28 01 00 00    	je     8008ae <vprintfmt+0x589>
			putch(ch, putdat);
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	53                   	push   %ebx
  80078a:	50                   	push   %eax
  80078b:	ff d6                	call   *%esi
  80078d:	83 c4 10             	add    $0x10,%esp
  800790:	eb dc                	jmp    80076e <vprintfmt+0x449>
	if (lflag >= 2)
  800792:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800796:	7f 26                	jg     8007be <vprintfmt+0x499>
	else if (lflag)
  800798:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80079c:	74 41                	je     8007df <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	8d 40 04             	lea    0x4(%eax),%eax
  8007b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b7:	b8 10 00 00 00       	mov    $0x10,%eax
  8007bc:	eb 8f                	jmp    80074d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007be:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c1:	8b 50 04             	mov    0x4(%eax),%edx
  8007c4:	8b 00                	mov    (%eax),%eax
  8007c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	8d 40 08             	lea    0x8(%eax),%eax
  8007d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d5:	b8 10 00 00 00       	mov    $0x10,%eax
  8007da:	e9 6e ff ff ff       	jmp    80074d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8d 40 04             	lea    0x4(%eax),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f8:	b8 10 00 00 00       	mov    $0x10,%eax
  8007fd:	e9 4b ff ff ff       	jmp    80074d <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	83 c0 04             	add    $0x4,%eax
  800808:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	8b 00                	mov    (%eax),%eax
  800810:	85 c0                	test   %eax,%eax
  800812:	74 14                	je     800828 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800814:	8b 13                	mov    (%ebx),%edx
  800816:	83 fa 7f             	cmp    $0x7f,%edx
  800819:	7f 37                	jg     800852 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80081b:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80081d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800820:	89 45 14             	mov    %eax,0x14(%ebp)
  800823:	e9 43 ff ff ff       	jmp    80076b <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800828:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082d:	bf bd 27 80 00       	mov    $0x8027bd,%edi
							putch(ch, putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	53                   	push   %ebx
  800836:	50                   	push   %eax
  800837:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800839:	83 c7 01             	add    $0x1,%edi
  80083c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800840:	83 c4 10             	add    $0x10,%esp
  800843:	85 c0                	test   %eax,%eax
  800845:	75 eb                	jne    800832 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800847:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80084a:	89 45 14             	mov    %eax,0x14(%ebp)
  80084d:	e9 19 ff ff ff       	jmp    80076b <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800852:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800854:	b8 0a 00 00 00       	mov    $0xa,%eax
  800859:	bf f5 27 80 00       	mov    $0x8027f5,%edi
							putch(ch, putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	53                   	push   %ebx
  800862:	50                   	push   %eax
  800863:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800865:	83 c7 01             	add    $0x1,%edi
  800868:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80086c:	83 c4 10             	add    $0x10,%esp
  80086f:	85 c0                	test   %eax,%eax
  800871:	75 eb                	jne    80085e <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800873:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800876:	89 45 14             	mov    %eax,0x14(%ebp)
  800879:	e9 ed fe ff ff       	jmp    80076b <vprintfmt+0x446>
			putch(ch, putdat);
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	53                   	push   %ebx
  800882:	6a 25                	push   $0x25
  800884:	ff d6                	call   *%esi
			break;
  800886:	83 c4 10             	add    $0x10,%esp
  800889:	e9 dd fe ff ff       	jmp    80076b <vprintfmt+0x446>
			putch('%', putdat);
  80088e:	83 ec 08             	sub    $0x8,%esp
  800891:	53                   	push   %ebx
  800892:	6a 25                	push   $0x25
  800894:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800896:	83 c4 10             	add    $0x10,%esp
  800899:	89 f8                	mov    %edi,%eax
  80089b:	eb 03                	jmp    8008a0 <vprintfmt+0x57b>
  80089d:	83 e8 01             	sub    $0x1,%eax
  8008a0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008a4:	75 f7                	jne    80089d <vprintfmt+0x578>
  8008a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a9:	e9 bd fe ff ff       	jmp    80076b <vprintfmt+0x446>
}
  8008ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008b1:	5b                   	pop    %ebx
  8008b2:	5e                   	pop    %esi
  8008b3:	5f                   	pop    %edi
  8008b4:	5d                   	pop    %ebp
  8008b5:	c3                   	ret    

008008b6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	83 ec 18             	sub    $0x18,%esp
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008c9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008d3:	85 c0                	test   %eax,%eax
  8008d5:	74 26                	je     8008fd <vsnprintf+0x47>
  8008d7:	85 d2                	test   %edx,%edx
  8008d9:	7e 22                	jle    8008fd <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008db:	ff 75 14             	pushl  0x14(%ebp)
  8008de:	ff 75 10             	pushl  0x10(%ebp)
  8008e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008e4:	50                   	push   %eax
  8008e5:	68 eb 02 80 00       	push   $0x8002eb
  8008ea:	e8 36 fa ff ff       	call   800325 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008f2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f8:	83 c4 10             	add    $0x10,%esp
}
  8008fb:	c9                   	leave  
  8008fc:	c3                   	ret    
		return -E_INVAL;
  8008fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800902:	eb f7                	jmp    8008fb <vsnprintf+0x45>

00800904 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80090a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80090d:	50                   	push   %eax
  80090e:	ff 75 10             	pushl  0x10(%ebp)
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	ff 75 08             	pushl  0x8(%ebp)
  800917:	e8 9a ff ff ff       	call   8008b6 <vsnprintf>
	va_end(ap);

	return rc;
}
  80091c:	c9                   	leave  
  80091d:	c3                   	ret    

0080091e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800924:	b8 00 00 00 00       	mov    $0x0,%eax
  800929:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80092d:	74 05                	je     800934 <strlen+0x16>
		n++;
  80092f:	83 c0 01             	add    $0x1,%eax
  800932:	eb f5                	jmp    800929 <strlen+0xb>
	return n;
}
  800934:	5d                   	pop    %ebp
  800935:	c3                   	ret    

00800936 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80093c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093f:	ba 00 00 00 00       	mov    $0x0,%edx
  800944:	39 c2                	cmp    %eax,%edx
  800946:	74 0d                	je     800955 <strnlen+0x1f>
  800948:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80094c:	74 05                	je     800953 <strnlen+0x1d>
		n++;
  80094e:	83 c2 01             	add    $0x1,%edx
  800951:	eb f1                	jmp    800944 <strnlen+0xe>
  800953:	89 d0                	mov    %edx,%eax
	return n;
}
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	53                   	push   %ebx
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800961:	ba 00 00 00 00       	mov    $0x0,%edx
  800966:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80096a:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80096d:	83 c2 01             	add    $0x1,%edx
  800970:	84 c9                	test   %cl,%cl
  800972:	75 f2                	jne    800966 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800974:	5b                   	pop    %ebx
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	53                   	push   %ebx
  80097b:	83 ec 10             	sub    $0x10,%esp
  80097e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800981:	53                   	push   %ebx
  800982:	e8 97 ff ff ff       	call   80091e <strlen>
  800987:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80098a:	ff 75 0c             	pushl  0xc(%ebp)
  80098d:	01 d8                	add    %ebx,%eax
  80098f:	50                   	push   %eax
  800990:	e8 c2 ff ff ff       	call   800957 <strcpy>
	return dst;
}
  800995:	89 d8                	mov    %ebx,%eax
  800997:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	56                   	push   %esi
  8009a0:	53                   	push   %ebx
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a7:	89 c6                	mov    %eax,%esi
  8009a9:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ac:	89 c2                	mov    %eax,%edx
  8009ae:	39 f2                	cmp    %esi,%edx
  8009b0:	74 11                	je     8009c3 <strncpy+0x27>
		*dst++ = *src;
  8009b2:	83 c2 01             	add    $0x1,%edx
  8009b5:	0f b6 19             	movzbl (%ecx),%ebx
  8009b8:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009bb:	80 fb 01             	cmp    $0x1,%bl
  8009be:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009c1:	eb eb                	jmp    8009ae <strncpy+0x12>
	}
	return ret;
}
  8009c3:	5b                   	pop    %ebx
  8009c4:	5e                   	pop    %esi
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	56                   	push   %esi
  8009cb:	53                   	push   %ebx
  8009cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8009cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d2:	8b 55 10             	mov    0x10(%ebp),%edx
  8009d5:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009d7:	85 d2                	test   %edx,%edx
  8009d9:	74 21                	je     8009fc <strlcpy+0x35>
  8009db:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009df:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009e1:	39 c2                	cmp    %eax,%edx
  8009e3:	74 14                	je     8009f9 <strlcpy+0x32>
  8009e5:	0f b6 19             	movzbl (%ecx),%ebx
  8009e8:	84 db                	test   %bl,%bl
  8009ea:	74 0b                	je     8009f7 <strlcpy+0x30>
			*dst++ = *src++;
  8009ec:	83 c1 01             	add    $0x1,%ecx
  8009ef:	83 c2 01             	add    $0x1,%edx
  8009f2:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009f5:	eb ea                	jmp    8009e1 <strlcpy+0x1a>
  8009f7:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009f9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009fc:	29 f0                	sub    %esi,%eax
}
  8009fe:	5b                   	pop    %ebx
  8009ff:	5e                   	pop    %esi
  800a00:	5d                   	pop    %ebp
  800a01:	c3                   	ret    

00800a02 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a08:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a0b:	0f b6 01             	movzbl (%ecx),%eax
  800a0e:	84 c0                	test   %al,%al
  800a10:	74 0c                	je     800a1e <strcmp+0x1c>
  800a12:	3a 02                	cmp    (%edx),%al
  800a14:	75 08                	jne    800a1e <strcmp+0x1c>
		p++, q++;
  800a16:	83 c1 01             	add    $0x1,%ecx
  800a19:	83 c2 01             	add    $0x1,%edx
  800a1c:	eb ed                	jmp    800a0b <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1e:	0f b6 c0             	movzbl %al,%eax
  800a21:	0f b6 12             	movzbl (%edx),%edx
  800a24:	29 d0                	sub    %edx,%eax
}
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	53                   	push   %ebx
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a32:	89 c3                	mov    %eax,%ebx
  800a34:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a37:	eb 06                	jmp    800a3f <strncmp+0x17>
		n--, p++, q++;
  800a39:	83 c0 01             	add    $0x1,%eax
  800a3c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a3f:	39 d8                	cmp    %ebx,%eax
  800a41:	74 16                	je     800a59 <strncmp+0x31>
  800a43:	0f b6 08             	movzbl (%eax),%ecx
  800a46:	84 c9                	test   %cl,%cl
  800a48:	74 04                	je     800a4e <strncmp+0x26>
  800a4a:	3a 0a                	cmp    (%edx),%cl
  800a4c:	74 eb                	je     800a39 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4e:	0f b6 00             	movzbl (%eax),%eax
  800a51:	0f b6 12             	movzbl (%edx),%edx
  800a54:	29 d0                	sub    %edx,%eax
}
  800a56:	5b                   	pop    %ebx
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    
		return 0;
  800a59:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5e:	eb f6                	jmp    800a56 <strncmp+0x2e>

00800a60 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a6a:	0f b6 10             	movzbl (%eax),%edx
  800a6d:	84 d2                	test   %dl,%dl
  800a6f:	74 09                	je     800a7a <strchr+0x1a>
		if (*s == c)
  800a71:	38 ca                	cmp    %cl,%dl
  800a73:	74 0a                	je     800a7f <strchr+0x1f>
	for (; *s; s++)
  800a75:	83 c0 01             	add    $0x1,%eax
  800a78:	eb f0                	jmp    800a6a <strchr+0xa>
			return (char *) s;
	return 0;
  800a7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7f:	5d                   	pop    %ebp
  800a80:	c3                   	ret    

00800a81 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a8b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a8e:	38 ca                	cmp    %cl,%dl
  800a90:	74 09                	je     800a9b <strfind+0x1a>
  800a92:	84 d2                	test   %dl,%dl
  800a94:	74 05                	je     800a9b <strfind+0x1a>
	for (; *s; s++)
  800a96:	83 c0 01             	add    $0x1,%eax
  800a99:	eb f0                	jmp    800a8b <strfind+0xa>
			break;
	return (char *) s;
}
  800a9b:	5d                   	pop    %ebp
  800a9c:	c3                   	ret    

00800a9d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	57                   	push   %edi
  800aa1:	56                   	push   %esi
  800aa2:	53                   	push   %ebx
  800aa3:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aa6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa9:	85 c9                	test   %ecx,%ecx
  800aab:	74 31                	je     800ade <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aad:	89 f8                	mov    %edi,%eax
  800aaf:	09 c8                	or     %ecx,%eax
  800ab1:	a8 03                	test   $0x3,%al
  800ab3:	75 23                	jne    800ad8 <memset+0x3b>
		c &= 0xFF;
  800ab5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab9:	89 d3                	mov    %edx,%ebx
  800abb:	c1 e3 08             	shl    $0x8,%ebx
  800abe:	89 d0                	mov    %edx,%eax
  800ac0:	c1 e0 18             	shl    $0x18,%eax
  800ac3:	89 d6                	mov    %edx,%esi
  800ac5:	c1 e6 10             	shl    $0x10,%esi
  800ac8:	09 f0                	or     %esi,%eax
  800aca:	09 c2                	or     %eax,%edx
  800acc:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ace:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ad1:	89 d0                	mov    %edx,%eax
  800ad3:	fc                   	cld    
  800ad4:	f3 ab                	rep stos %eax,%es:(%edi)
  800ad6:	eb 06                	jmp    800ade <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adb:	fc                   	cld    
  800adc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ade:	89 f8                	mov    %edi,%eax
  800ae0:	5b                   	pop    %ebx
  800ae1:	5e                   	pop    %esi
  800ae2:	5f                   	pop    %edi
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	57                   	push   %edi
  800ae9:	56                   	push   %esi
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af3:	39 c6                	cmp    %eax,%esi
  800af5:	73 32                	jae    800b29 <memmove+0x44>
  800af7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800afa:	39 c2                	cmp    %eax,%edx
  800afc:	76 2b                	jbe    800b29 <memmove+0x44>
		s += n;
		d += n;
  800afe:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b01:	89 fe                	mov    %edi,%esi
  800b03:	09 ce                	or     %ecx,%esi
  800b05:	09 d6                	or     %edx,%esi
  800b07:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b0d:	75 0e                	jne    800b1d <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b0f:	83 ef 04             	sub    $0x4,%edi
  800b12:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b15:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b18:	fd                   	std    
  800b19:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1b:	eb 09                	jmp    800b26 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b1d:	83 ef 01             	sub    $0x1,%edi
  800b20:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b23:	fd                   	std    
  800b24:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b26:	fc                   	cld    
  800b27:	eb 1a                	jmp    800b43 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b29:	89 c2                	mov    %eax,%edx
  800b2b:	09 ca                	or     %ecx,%edx
  800b2d:	09 f2                	or     %esi,%edx
  800b2f:	f6 c2 03             	test   $0x3,%dl
  800b32:	75 0a                	jne    800b3e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b34:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b37:	89 c7                	mov    %eax,%edi
  800b39:	fc                   	cld    
  800b3a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3c:	eb 05                	jmp    800b43 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b3e:	89 c7                	mov    %eax,%edi
  800b40:	fc                   	cld    
  800b41:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b43:	5e                   	pop    %esi
  800b44:	5f                   	pop    %edi
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    

00800b47 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b4d:	ff 75 10             	pushl  0x10(%ebp)
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	ff 75 08             	pushl  0x8(%ebp)
  800b56:	e8 8a ff ff ff       	call   800ae5 <memmove>
}
  800b5b:	c9                   	leave  
  800b5c:	c3                   	ret    

00800b5d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b68:	89 c6                	mov    %eax,%esi
  800b6a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b6d:	39 f0                	cmp    %esi,%eax
  800b6f:	74 1c                	je     800b8d <memcmp+0x30>
		if (*s1 != *s2)
  800b71:	0f b6 08             	movzbl (%eax),%ecx
  800b74:	0f b6 1a             	movzbl (%edx),%ebx
  800b77:	38 d9                	cmp    %bl,%cl
  800b79:	75 08                	jne    800b83 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b7b:	83 c0 01             	add    $0x1,%eax
  800b7e:	83 c2 01             	add    $0x1,%edx
  800b81:	eb ea                	jmp    800b6d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b83:	0f b6 c1             	movzbl %cl,%eax
  800b86:	0f b6 db             	movzbl %bl,%ebx
  800b89:	29 d8                	sub    %ebx,%eax
  800b8b:	eb 05                	jmp    800b92 <memcmp+0x35>
	}

	return 0;
  800b8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b92:	5b                   	pop    %ebx
  800b93:	5e                   	pop    %esi
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    

00800b96 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b9f:	89 c2                	mov    %eax,%edx
  800ba1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ba4:	39 d0                	cmp    %edx,%eax
  800ba6:	73 09                	jae    800bb1 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ba8:	38 08                	cmp    %cl,(%eax)
  800baa:	74 05                	je     800bb1 <memfind+0x1b>
	for (; s < ends; s++)
  800bac:	83 c0 01             	add    $0x1,%eax
  800baf:	eb f3                	jmp    800ba4 <memfind+0xe>
			break;
	return (void *) s;
}
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	57                   	push   %edi
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
  800bb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bbf:	eb 03                	jmp    800bc4 <strtol+0x11>
		s++;
  800bc1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bc4:	0f b6 01             	movzbl (%ecx),%eax
  800bc7:	3c 20                	cmp    $0x20,%al
  800bc9:	74 f6                	je     800bc1 <strtol+0xe>
  800bcb:	3c 09                	cmp    $0x9,%al
  800bcd:	74 f2                	je     800bc1 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bcf:	3c 2b                	cmp    $0x2b,%al
  800bd1:	74 2a                	je     800bfd <strtol+0x4a>
	int neg = 0;
  800bd3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bd8:	3c 2d                	cmp    $0x2d,%al
  800bda:	74 2b                	je     800c07 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bdc:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800be2:	75 0f                	jne    800bf3 <strtol+0x40>
  800be4:	80 39 30             	cmpb   $0x30,(%ecx)
  800be7:	74 28                	je     800c11 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800be9:	85 db                	test   %ebx,%ebx
  800beb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bf0:	0f 44 d8             	cmove  %eax,%ebx
  800bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bfb:	eb 50                	jmp    800c4d <strtol+0x9a>
		s++;
  800bfd:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c00:	bf 00 00 00 00       	mov    $0x0,%edi
  800c05:	eb d5                	jmp    800bdc <strtol+0x29>
		s++, neg = 1;
  800c07:	83 c1 01             	add    $0x1,%ecx
  800c0a:	bf 01 00 00 00       	mov    $0x1,%edi
  800c0f:	eb cb                	jmp    800bdc <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c11:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c15:	74 0e                	je     800c25 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c17:	85 db                	test   %ebx,%ebx
  800c19:	75 d8                	jne    800bf3 <strtol+0x40>
		s++, base = 8;
  800c1b:	83 c1 01             	add    $0x1,%ecx
  800c1e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c23:	eb ce                	jmp    800bf3 <strtol+0x40>
		s += 2, base = 16;
  800c25:	83 c1 02             	add    $0x2,%ecx
  800c28:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c2d:	eb c4                	jmp    800bf3 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c2f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c32:	89 f3                	mov    %esi,%ebx
  800c34:	80 fb 19             	cmp    $0x19,%bl
  800c37:	77 29                	ja     800c62 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c39:	0f be d2             	movsbl %dl,%edx
  800c3c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c3f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c42:	7d 30                	jge    800c74 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c44:	83 c1 01             	add    $0x1,%ecx
  800c47:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c4b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c4d:	0f b6 11             	movzbl (%ecx),%edx
  800c50:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c53:	89 f3                	mov    %esi,%ebx
  800c55:	80 fb 09             	cmp    $0x9,%bl
  800c58:	77 d5                	ja     800c2f <strtol+0x7c>
			dig = *s - '0';
  800c5a:	0f be d2             	movsbl %dl,%edx
  800c5d:	83 ea 30             	sub    $0x30,%edx
  800c60:	eb dd                	jmp    800c3f <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c62:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c65:	89 f3                	mov    %esi,%ebx
  800c67:	80 fb 19             	cmp    $0x19,%bl
  800c6a:	77 08                	ja     800c74 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c6c:	0f be d2             	movsbl %dl,%edx
  800c6f:	83 ea 37             	sub    $0x37,%edx
  800c72:	eb cb                	jmp    800c3f <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c78:	74 05                	je     800c7f <strtol+0xcc>
		*endptr = (char *) s;
  800c7a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c7d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c7f:	89 c2                	mov    %eax,%edx
  800c81:	f7 da                	neg    %edx
  800c83:	85 ff                	test   %edi,%edi
  800c85:	0f 45 c2             	cmovne %edx,%eax
}
  800c88:	5b                   	pop    %ebx
  800c89:	5e                   	pop    %esi
  800c8a:	5f                   	pop    %edi
  800c8b:	5d                   	pop    %ebp
  800c8c:	c3                   	ret    

00800c8d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	57                   	push   %edi
  800c91:	56                   	push   %esi
  800c92:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c93:	b8 00 00 00 00       	mov    $0x0,%eax
  800c98:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9e:	89 c3                	mov    %eax,%ebx
  800ca0:	89 c7                	mov    %eax,%edi
  800ca2:	89 c6                	mov    %eax,%esi
  800ca4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    

00800cab <sys_cgetc>:

int
sys_cgetc(void)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb6:	b8 01 00 00 00       	mov    $0x1,%eax
  800cbb:	89 d1                	mov    %edx,%ecx
  800cbd:	89 d3                	mov    %edx,%ebx
  800cbf:	89 d7                	mov    %edx,%edi
  800cc1:	89 d6                	mov    %edx,%esi
  800cc3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cc5:	5b                   	pop    %ebx
  800cc6:	5e                   	pop    %esi
  800cc7:	5f                   	pop    %edi
  800cc8:	5d                   	pop    %ebp
  800cc9:	c3                   	ret    

00800cca <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	57                   	push   %edi
  800cce:	56                   	push   %esi
  800ccf:	53                   	push   %ebx
  800cd0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdb:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce0:	89 cb                	mov    %ecx,%ebx
  800ce2:	89 cf                	mov    %ecx,%edi
  800ce4:	89 ce                	mov    %ecx,%esi
  800ce6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce8:	85 c0                	test   %eax,%eax
  800cea:	7f 08                	jg     800cf4 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cef:	5b                   	pop    %ebx
  800cf0:	5e                   	pop    %esi
  800cf1:	5f                   	pop    %edi
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf4:	83 ec 0c             	sub    $0xc,%esp
  800cf7:	50                   	push   %eax
  800cf8:	6a 03                	push   $0x3
  800cfa:	68 08 2a 80 00       	push   $0x802a08
  800cff:	6a 43                	push   $0x43
  800d01:	68 25 2a 80 00       	push   $0x802a25
  800d06:	e8 af 14 00 00       	call   8021ba <_panic>

00800d0b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d11:	ba 00 00 00 00       	mov    $0x0,%edx
  800d16:	b8 02 00 00 00       	mov    $0x2,%eax
  800d1b:	89 d1                	mov    %edx,%ecx
  800d1d:	89 d3                	mov    %edx,%ebx
  800d1f:	89 d7                	mov    %edx,%edi
  800d21:	89 d6                	mov    %edx,%esi
  800d23:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <sys_yield>:

void
sys_yield(void)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d30:	ba 00 00 00 00       	mov    $0x0,%edx
  800d35:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d3a:	89 d1                	mov    %edx,%ecx
  800d3c:	89 d3                	mov    %edx,%ebx
  800d3e:	89 d7                	mov    %edx,%edi
  800d40:	89 d6                	mov    %edx,%esi
  800d42:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	57                   	push   %edi
  800d4d:	56                   	push   %esi
  800d4e:	53                   	push   %ebx
  800d4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d52:	be 00 00 00 00       	mov    $0x0,%esi
  800d57:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5d:	b8 04 00 00 00       	mov    $0x4,%eax
  800d62:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d65:	89 f7                	mov    %esi,%edi
  800d67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	7f 08                	jg     800d75 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d75:	83 ec 0c             	sub    $0xc,%esp
  800d78:	50                   	push   %eax
  800d79:	6a 04                	push   $0x4
  800d7b:	68 08 2a 80 00       	push   $0x802a08
  800d80:	6a 43                	push   $0x43
  800d82:	68 25 2a 80 00       	push   $0x802a25
  800d87:	e8 2e 14 00 00       	call   8021ba <_panic>

00800d8c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	57                   	push   %edi
  800d90:	56                   	push   %esi
  800d91:	53                   	push   %ebx
  800d92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d95:	8b 55 08             	mov    0x8(%ebp),%edx
  800d98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9b:	b8 05 00 00 00       	mov    $0x5,%eax
  800da0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da6:	8b 75 18             	mov    0x18(%ebp),%esi
  800da9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dab:	85 c0                	test   %eax,%eax
  800dad:	7f 08                	jg     800db7 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db2:	5b                   	pop    %ebx
  800db3:	5e                   	pop    %esi
  800db4:	5f                   	pop    %edi
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db7:	83 ec 0c             	sub    $0xc,%esp
  800dba:	50                   	push   %eax
  800dbb:	6a 05                	push   $0x5
  800dbd:	68 08 2a 80 00       	push   $0x802a08
  800dc2:	6a 43                	push   $0x43
  800dc4:	68 25 2a 80 00       	push   $0x802a25
  800dc9:	e8 ec 13 00 00       	call   8021ba <_panic>

00800dce <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	57                   	push   %edi
  800dd2:	56                   	push   %esi
  800dd3:	53                   	push   %ebx
  800dd4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de2:	b8 06 00 00 00       	mov    $0x6,%eax
  800de7:	89 df                	mov    %ebx,%edi
  800de9:	89 de                	mov    %ebx,%esi
  800deb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ded:	85 c0                	test   %eax,%eax
  800def:	7f 08                	jg     800df9 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800df1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5f                   	pop    %edi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df9:	83 ec 0c             	sub    $0xc,%esp
  800dfc:	50                   	push   %eax
  800dfd:	6a 06                	push   $0x6
  800dff:	68 08 2a 80 00       	push   $0x802a08
  800e04:	6a 43                	push   $0x43
  800e06:	68 25 2a 80 00       	push   $0x802a25
  800e0b:	e8 aa 13 00 00       	call   8021ba <_panic>

00800e10 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	57                   	push   %edi
  800e14:	56                   	push   %esi
  800e15:	53                   	push   %ebx
  800e16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e19:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e24:	b8 08 00 00 00       	mov    $0x8,%eax
  800e29:	89 df                	mov    %ebx,%edi
  800e2b:	89 de                	mov    %ebx,%esi
  800e2d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	7f 08                	jg     800e3b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e36:	5b                   	pop    %ebx
  800e37:	5e                   	pop    %esi
  800e38:	5f                   	pop    %edi
  800e39:	5d                   	pop    %ebp
  800e3a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3b:	83 ec 0c             	sub    $0xc,%esp
  800e3e:	50                   	push   %eax
  800e3f:	6a 08                	push   $0x8
  800e41:	68 08 2a 80 00       	push   $0x802a08
  800e46:	6a 43                	push   $0x43
  800e48:	68 25 2a 80 00       	push   $0x802a25
  800e4d:	e8 68 13 00 00       	call   8021ba <_panic>

00800e52 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
  800e58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e60:	8b 55 08             	mov    0x8(%ebp),%edx
  800e63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e66:	b8 09 00 00 00       	mov    $0x9,%eax
  800e6b:	89 df                	mov    %ebx,%edi
  800e6d:	89 de                	mov    %ebx,%esi
  800e6f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e71:	85 c0                	test   %eax,%eax
  800e73:	7f 08                	jg     800e7d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e78:	5b                   	pop    %ebx
  800e79:	5e                   	pop    %esi
  800e7a:	5f                   	pop    %edi
  800e7b:	5d                   	pop    %ebp
  800e7c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7d:	83 ec 0c             	sub    $0xc,%esp
  800e80:	50                   	push   %eax
  800e81:	6a 09                	push   $0x9
  800e83:	68 08 2a 80 00       	push   $0x802a08
  800e88:	6a 43                	push   $0x43
  800e8a:	68 25 2a 80 00       	push   $0x802a25
  800e8f:	e8 26 13 00 00       	call   8021ba <_panic>

00800e94 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e94:	55                   	push   %ebp
  800e95:	89 e5                	mov    %esp,%ebp
  800e97:	57                   	push   %edi
  800e98:	56                   	push   %esi
  800e99:	53                   	push   %ebx
  800e9a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ead:	89 df                	mov    %ebx,%edi
  800eaf:	89 de                	mov    %ebx,%esi
  800eb1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	7f 08                	jg     800ebf <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eba:	5b                   	pop    %ebx
  800ebb:	5e                   	pop    %esi
  800ebc:	5f                   	pop    %edi
  800ebd:	5d                   	pop    %ebp
  800ebe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebf:	83 ec 0c             	sub    $0xc,%esp
  800ec2:	50                   	push   %eax
  800ec3:	6a 0a                	push   $0xa
  800ec5:	68 08 2a 80 00       	push   $0x802a08
  800eca:	6a 43                	push   $0x43
  800ecc:	68 25 2a 80 00       	push   $0x802a25
  800ed1:	e8 e4 12 00 00       	call   8021ba <_panic>

00800ed6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	57                   	push   %edi
  800eda:	56                   	push   %esi
  800edb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800edc:	8b 55 08             	mov    0x8(%ebp),%edx
  800edf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee2:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ee7:	be 00 00 00 00       	mov    $0x0,%esi
  800eec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eef:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ef2:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ef4:	5b                   	pop    %ebx
  800ef5:	5e                   	pop    %esi
  800ef6:	5f                   	pop    %edi
  800ef7:	5d                   	pop    %ebp
  800ef8:	c3                   	ret    

00800ef9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	57                   	push   %edi
  800efd:	56                   	push   %esi
  800efe:	53                   	push   %ebx
  800eff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f02:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f07:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f0f:	89 cb                	mov    %ecx,%ebx
  800f11:	89 cf                	mov    %ecx,%edi
  800f13:	89 ce                	mov    %ecx,%esi
  800f15:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	7f 08                	jg     800f23 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1e:	5b                   	pop    %ebx
  800f1f:	5e                   	pop    %esi
  800f20:	5f                   	pop    %edi
  800f21:	5d                   	pop    %ebp
  800f22:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f23:	83 ec 0c             	sub    $0xc,%esp
  800f26:	50                   	push   %eax
  800f27:	6a 0d                	push   $0xd
  800f29:	68 08 2a 80 00       	push   $0x802a08
  800f2e:	6a 43                	push   $0x43
  800f30:	68 25 2a 80 00       	push   $0x802a25
  800f35:	e8 80 12 00 00       	call   8021ba <_panic>

00800f3a <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	57                   	push   %edi
  800f3e:	56                   	push   %esi
  800f3f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f45:	8b 55 08             	mov    0x8(%ebp),%edx
  800f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4b:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f50:	89 df                	mov    %ebx,%edi
  800f52:	89 de                	mov    %ebx,%esi
  800f54:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5f                   	pop    %edi
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	57                   	push   %edi
  800f5f:	56                   	push   %esi
  800f60:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f61:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f66:	8b 55 08             	mov    0x8(%ebp),%edx
  800f69:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f6e:	89 cb                	mov    %ecx,%ebx
  800f70:	89 cf                	mov    %ecx,%edi
  800f72:	89 ce                	mov    %ecx,%esi
  800f74:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f76:	5b                   	pop    %ebx
  800f77:	5e                   	pop    %esi
  800f78:	5f                   	pop    %edi
  800f79:	5d                   	pop    %ebp
  800f7a:	c3                   	ret    

00800f7b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	57                   	push   %edi
  800f7f:	56                   	push   %esi
  800f80:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f81:	ba 00 00 00 00       	mov    $0x0,%edx
  800f86:	b8 10 00 00 00       	mov    $0x10,%eax
  800f8b:	89 d1                	mov    %edx,%ecx
  800f8d:	89 d3                	mov    %edx,%ebx
  800f8f:	89 d7                	mov    %edx,%edi
  800f91:	89 d6                	mov    %edx,%esi
  800f93:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f95:	5b                   	pop    %ebx
  800f96:	5e                   	pop    %esi
  800f97:	5f                   	pop    %edi
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    

00800f9a <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
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
  800fab:	b8 11 00 00 00       	mov    $0x11,%eax
  800fb0:	89 df                	mov    %ebx,%edi
  800fb2:	89 de                	mov    %ebx,%esi
  800fb4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fb6:	5b                   	pop    %ebx
  800fb7:	5e                   	pop    %esi
  800fb8:	5f                   	pop    %edi
  800fb9:	5d                   	pop    %ebp
  800fba:	c3                   	ret    

00800fbb <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	57                   	push   %edi
  800fbf:	56                   	push   %esi
  800fc0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcc:	b8 12 00 00 00       	mov    $0x12,%eax
  800fd1:	89 df                	mov    %ebx,%edi
  800fd3:	89 de                	mov    %ebx,%esi
  800fd5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fd7:	5b                   	pop    %ebx
  800fd8:	5e                   	pop    %esi
  800fd9:	5f                   	pop    %edi
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    

00800fdc <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	57                   	push   %edi
  800fe0:	56                   	push   %esi
  800fe1:	53                   	push   %ebx
  800fe2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fea:	8b 55 08             	mov    0x8(%ebp),%edx
  800fed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff0:	b8 13 00 00 00       	mov    $0x13,%eax
  800ff5:	89 df                	mov    %ebx,%edi
  800ff7:	89 de                	mov    %ebx,%esi
  800ff9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	7f 08                	jg     801007 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5f                   	pop    %edi
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801007:	83 ec 0c             	sub    $0xc,%esp
  80100a:	50                   	push   %eax
  80100b:	6a 13                	push   $0x13
  80100d:	68 08 2a 80 00       	push   $0x802a08
  801012:	6a 43                	push   $0x43
  801014:	68 25 2a 80 00       	push   $0x802a25
  801019:	e8 9c 11 00 00       	call   8021ba <_panic>

0080101e <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	57                   	push   %edi
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
	asm volatile("int %1\n"
  801024:	b9 00 00 00 00       	mov    $0x0,%ecx
  801029:	8b 55 08             	mov    0x8(%ebp),%edx
  80102c:	b8 14 00 00 00       	mov    $0x14,%eax
  801031:	89 cb                	mov    %ecx,%ebx
  801033:	89 cf                	mov    %ecx,%edi
  801035:	89 ce                	mov    %ecx,%esi
  801037:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801039:	5b                   	pop    %ebx
  80103a:	5e                   	pop    %esi
  80103b:	5f                   	pop    %edi
  80103c:	5d                   	pop    %ebp
  80103d:	c3                   	ret    

0080103e <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80103e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80103f:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  801044:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801046:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  801049:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80104d:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  801051:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801054:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801056:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80105a:	83 c4 08             	add    $0x8,%esp
	popal
  80105d:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80105e:	83 c4 04             	add    $0x4,%esp
	popfl
  801061:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801062:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801063:	c3                   	ret    

00801064 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
  80106a:	05 00 00 00 30       	add    $0x30000000,%eax
  80106f:	c1 e8 0c             	shr    $0xc,%eax
}
  801072:	5d                   	pop    %ebp
  801073:	c3                   	ret    

00801074 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80107f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801084:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801089:	5d                   	pop    %ebp
  80108a:	c3                   	ret    

0080108b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801093:	89 c2                	mov    %eax,%edx
  801095:	c1 ea 16             	shr    $0x16,%edx
  801098:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80109f:	f6 c2 01             	test   $0x1,%dl
  8010a2:	74 2d                	je     8010d1 <fd_alloc+0x46>
  8010a4:	89 c2                	mov    %eax,%edx
  8010a6:	c1 ea 0c             	shr    $0xc,%edx
  8010a9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010b0:	f6 c2 01             	test   $0x1,%dl
  8010b3:	74 1c                	je     8010d1 <fd_alloc+0x46>
  8010b5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010ba:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010bf:	75 d2                	jne    801093 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010ca:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010cf:	eb 0a                	jmp    8010db <fd_alloc+0x50>
			*fd_store = fd;
  8010d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010db:	5d                   	pop    %ebp
  8010dc:	c3                   	ret    

008010dd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010e3:	83 f8 1f             	cmp    $0x1f,%eax
  8010e6:	77 30                	ja     801118 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010e8:	c1 e0 0c             	shl    $0xc,%eax
  8010eb:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010f0:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010f6:	f6 c2 01             	test   $0x1,%dl
  8010f9:	74 24                	je     80111f <fd_lookup+0x42>
  8010fb:	89 c2                	mov    %eax,%edx
  8010fd:	c1 ea 0c             	shr    $0xc,%edx
  801100:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801107:	f6 c2 01             	test   $0x1,%dl
  80110a:	74 1a                	je     801126 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80110c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110f:	89 02                	mov    %eax,(%edx)
	return 0;
  801111:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    
		return -E_INVAL;
  801118:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80111d:	eb f7                	jmp    801116 <fd_lookup+0x39>
		return -E_INVAL;
  80111f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801124:	eb f0                	jmp    801116 <fd_lookup+0x39>
  801126:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80112b:	eb e9                	jmp    801116 <fd_lookup+0x39>

0080112d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801136:	ba 00 00 00 00       	mov    $0x0,%edx
  80113b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801140:	39 08                	cmp    %ecx,(%eax)
  801142:	74 38                	je     80117c <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801144:	83 c2 01             	add    $0x1,%edx
  801147:	8b 04 95 b0 2a 80 00 	mov    0x802ab0(,%edx,4),%eax
  80114e:	85 c0                	test   %eax,%eax
  801150:	75 ee                	jne    801140 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801152:	a1 08 40 80 00       	mov    0x804008,%eax
  801157:	8b 40 48             	mov    0x48(%eax),%eax
  80115a:	83 ec 04             	sub    $0x4,%esp
  80115d:	51                   	push   %ecx
  80115e:	50                   	push   %eax
  80115f:	68 34 2a 80 00       	push   $0x802a34
  801164:	e8 8f f0 ff ff       	call   8001f8 <cprintf>
	*dev = 0;
  801169:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801172:	83 c4 10             	add    $0x10,%esp
  801175:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80117a:	c9                   	leave  
  80117b:	c3                   	ret    
			*dev = devtab[i];
  80117c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801181:	b8 00 00 00 00       	mov    $0x0,%eax
  801186:	eb f2                	jmp    80117a <dev_lookup+0x4d>

00801188 <fd_close>:
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	57                   	push   %edi
  80118c:	56                   	push   %esi
  80118d:	53                   	push   %ebx
  80118e:	83 ec 24             	sub    $0x24,%esp
  801191:	8b 75 08             	mov    0x8(%ebp),%esi
  801194:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801197:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80119a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80119b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011a1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011a4:	50                   	push   %eax
  8011a5:	e8 33 ff ff ff       	call   8010dd <fd_lookup>
  8011aa:	89 c3                	mov    %eax,%ebx
  8011ac:	83 c4 10             	add    $0x10,%esp
  8011af:	85 c0                	test   %eax,%eax
  8011b1:	78 05                	js     8011b8 <fd_close+0x30>
	    || fd != fd2)
  8011b3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011b6:	74 16                	je     8011ce <fd_close+0x46>
		return (must_exist ? r : 0);
  8011b8:	89 f8                	mov    %edi,%eax
  8011ba:	84 c0                	test   %al,%al
  8011bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c1:	0f 44 d8             	cmove  %eax,%ebx
}
  8011c4:	89 d8                	mov    %ebx,%eax
  8011c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c9:	5b                   	pop    %ebx
  8011ca:	5e                   	pop    %esi
  8011cb:	5f                   	pop    %edi
  8011cc:	5d                   	pop    %ebp
  8011cd:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011ce:	83 ec 08             	sub    $0x8,%esp
  8011d1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011d4:	50                   	push   %eax
  8011d5:	ff 36                	pushl  (%esi)
  8011d7:	e8 51 ff ff ff       	call   80112d <dev_lookup>
  8011dc:	89 c3                	mov    %eax,%ebx
  8011de:	83 c4 10             	add    $0x10,%esp
  8011e1:	85 c0                	test   %eax,%eax
  8011e3:	78 1a                	js     8011ff <fd_close+0x77>
		if (dev->dev_close)
  8011e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011e8:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011eb:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011f0:	85 c0                	test   %eax,%eax
  8011f2:	74 0b                	je     8011ff <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011f4:	83 ec 0c             	sub    $0xc,%esp
  8011f7:	56                   	push   %esi
  8011f8:	ff d0                	call   *%eax
  8011fa:	89 c3                	mov    %eax,%ebx
  8011fc:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011ff:	83 ec 08             	sub    $0x8,%esp
  801202:	56                   	push   %esi
  801203:	6a 00                	push   $0x0
  801205:	e8 c4 fb ff ff       	call   800dce <sys_page_unmap>
	return r;
  80120a:	83 c4 10             	add    $0x10,%esp
  80120d:	eb b5                	jmp    8011c4 <fd_close+0x3c>

0080120f <close>:

int
close(int fdnum)
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801215:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801218:	50                   	push   %eax
  801219:	ff 75 08             	pushl  0x8(%ebp)
  80121c:	e8 bc fe ff ff       	call   8010dd <fd_lookup>
  801221:	83 c4 10             	add    $0x10,%esp
  801224:	85 c0                	test   %eax,%eax
  801226:	79 02                	jns    80122a <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801228:	c9                   	leave  
  801229:	c3                   	ret    
		return fd_close(fd, 1);
  80122a:	83 ec 08             	sub    $0x8,%esp
  80122d:	6a 01                	push   $0x1
  80122f:	ff 75 f4             	pushl  -0xc(%ebp)
  801232:	e8 51 ff ff ff       	call   801188 <fd_close>
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	eb ec                	jmp    801228 <close+0x19>

0080123c <close_all>:

void
close_all(void)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	53                   	push   %ebx
  801240:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801243:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801248:	83 ec 0c             	sub    $0xc,%esp
  80124b:	53                   	push   %ebx
  80124c:	e8 be ff ff ff       	call   80120f <close>
	for (i = 0; i < MAXFD; i++)
  801251:	83 c3 01             	add    $0x1,%ebx
  801254:	83 c4 10             	add    $0x10,%esp
  801257:	83 fb 20             	cmp    $0x20,%ebx
  80125a:	75 ec                	jne    801248 <close_all+0xc>
}
  80125c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80125f:	c9                   	leave  
  801260:	c3                   	ret    

00801261 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
  801264:	57                   	push   %edi
  801265:	56                   	push   %esi
  801266:	53                   	push   %ebx
  801267:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80126a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80126d:	50                   	push   %eax
  80126e:	ff 75 08             	pushl  0x8(%ebp)
  801271:	e8 67 fe ff ff       	call   8010dd <fd_lookup>
  801276:	89 c3                	mov    %eax,%ebx
  801278:	83 c4 10             	add    $0x10,%esp
  80127b:	85 c0                	test   %eax,%eax
  80127d:	0f 88 81 00 00 00    	js     801304 <dup+0xa3>
		return r;
	close(newfdnum);
  801283:	83 ec 0c             	sub    $0xc,%esp
  801286:	ff 75 0c             	pushl  0xc(%ebp)
  801289:	e8 81 ff ff ff       	call   80120f <close>

	newfd = INDEX2FD(newfdnum);
  80128e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801291:	c1 e6 0c             	shl    $0xc,%esi
  801294:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80129a:	83 c4 04             	add    $0x4,%esp
  80129d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012a0:	e8 cf fd ff ff       	call   801074 <fd2data>
  8012a5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012a7:	89 34 24             	mov    %esi,(%esp)
  8012aa:	e8 c5 fd ff ff       	call   801074 <fd2data>
  8012af:	83 c4 10             	add    $0x10,%esp
  8012b2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012b4:	89 d8                	mov    %ebx,%eax
  8012b6:	c1 e8 16             	shr    $0x16,%eax
  8012b9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012c0:	a8 01                	test   $0x1,%al
  8012c2:	74 11                	je     8012d5 <dup+0x74>
  8012c4:	89 d8                	mov    %ebx,%eax
  8012c6:	c1 e8 0c             	shr    $0xc,%eax
  8012c9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012d0:	f6 c2 01             	test   $0x1,%dl
  8012d3:	75 39                	jne    80130e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012d8:	89 d0                	mov    %edx,%eax
  8012da:	c1 e8 0c             	shr    $0xc,%eax
  8012dd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012e4:	83 ec 0c             	sub    $0xc,%esp
  8012e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ec:	50                   	push   %eax
  8012ed:	56                   	push   %esi
  8012ee:	6a 00                	push   $0x0
  8012f0:	52                   	push   %edx
  8012f1:	6a 00                	push   $0x0
  8012f3:	e8 94 fa ff ff       	call   800d8c <sys_page_map>
  8012f8:	89 c3                	mov    %eax,%ebx
  8012fa:	83 c4 20             	add    $0x20,%esp
  8012fd:	85 c0                	test   %eax,%eax
  8012ff:	78 31                	js     801332 <dup+0xd1>
		goto err;

	return newfdnum;
  801301:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801304:	89 d8                	mov    %ebx,%eax
  801306:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801309:	5b                   	pop    %ebx
  80130a:	5e                   	pop    %esi
  80130b:	5f                   	pop    %edi
  80130c:	5d                   	pop    %ebp
  80130d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80130e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801315:	83 ec 0c             	sub    $0xc,%esp
  801318:	25 07 0e 00 00       	and    $0xe07,%eax
  80131d:	50                   	push   %eax
  80131e:	57                   	push   %edi
  80131f:	6a 00                	push   $0x0
  801321:	53                   	push   %ebx
  801322:	6a 00                	push   $0x0
  801324:	e8 63 fa ff ff       	call   800d8c <sys_page_map>
  801329:	89 c3                	mov    %eax,%ebx
  80132b:	83 c4 20             	add    $0x20,%esp
  80132e:	85 c0                	test   %eax,%eax
  801330:	79 a3                	jns    8012d5 <dup+0x74>
	sys_page_unmap(0, newfd);
  801332:	83 ec 08             	sub    $0x8,%esp
  801335:	56                   	push   %esi
  801336:	6a 00                	push   $0x0
  801338:	e8 91 fa ff ff       	call   800dce <sys_page_unmap>
	sys_page_unmap(0, nva);
  80133d:	83 c4 08             	add    $0x8,%esp
  801340:	57                   	push   %edi
  801341:	6a 00                	push   $0x0
  801343:	e8 86 fa ff ff       	call   800dce <sys_page_unmap>
	return r;
  801348:	83 c4 10             	add    $0x10,%esp
  80134b:	eb b7                	jmp    801304 <dup+0xa3>

0080134d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
  801350:	53                   	push   %ebx
  801351:	83 ec 1c             	sub    $0x1c,%esp
  801354:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801357:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80135a:	50                   	push   %eax
  80135b:	53                   	push   %ebx
  80135c:	e8 7c fd ff ff       	call   8010dd <fd_lookup>
  801361:	83 c4 10             	add    $0x10,%esp
  801364:	85 c0                	test   %eax,%eax
  801366:	78 3f                	js     8013a7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801368:	83 ec 08             	sub    $0x8,%esp
  80136b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136e:	50                   	push   %eax
  80136f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801372:	ff 30                	pushl  (%eax)
  801374:	e8 b4 fd ff ff       	call   80112d <dev_lookup>
  801379:	83 c4 10             	add    $0x10,%esp
  80137c:	85 c0                	test   %eax,%eax
  80137e:	78 27                	js     8013a7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801380:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801383:	8b 42 08             	mov    0x8(%edx),%eax
  801386:	83 e0 03             	and    $0x3,%eax
  801389:	83 f8 01             	cmp    $0x1,%eax
  80138c:	74 1e                	je     8013ac <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80138e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801391:	8b 40 08             	mov    0x8(%eax),%eax
  801394:	85 c0                	test   %eax,%eax
  801396:	74 35                	je     8013cd <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801398:	83 ec 04             	sub    $0x4,%esp
  80139b:	ff 75 10             	pushl  0x10(%ebp)
  80139e:	ff 75 0c             	pushl  0xc(%ebp)
  8013a1:	52                   	push   %edx
  8013a2:	ff d0                	call   *%eax
  8013a4:	83 c4 10             	add    $0x10,%esp
}
  8013a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013ac:	a1 08 40 80 00       	mov    0x804008,%eax
  8013b1:	8b 40 48             	mov    0x48(%eax),%eax
  8013b4:	83 ec 04             	sub    $0x4,%esp
  8013b7:	53                   	push   %ebx
  8013b8:	50                   	push   %eax
  8013b9:	68 75 2a 80 00       	push   $0x802a75
  8013be:	e8 35 ee ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013cb:	eb da                	jmp    8013a7 <read+0x5a>
		return -E_NOT_SUPP;
  8013cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013d2:	eb d3                	jmp    8013a7 <read+0x5a>

008013d4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	57                   	push   %edi
  8013d8:	56                   	push   %esi
  8013d9:	53                   	push   %ebx
  8013da:	83 ec 0c             	sub    $0xc,%esp
  8013dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013e0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e8:	39 f3                	cmp    %esi,%ebx
  8013ea:	73 23                	jae    80140f <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013ec:	83 ec 04             	sub    $0x4,%esp
  8013ef:	89 f0                	mov    %esi,%eax
  8013f1:	29 d8                	sub    %ebx,%eax
  8013f3:	50                   	push   %eax
  8013f4:	89 d8                	mov    %ebx,%eax
  8013f6:	03 45 0c             	add    0xc(%ebp),%eax
  8013f9:	50                   	push   %eax
  8013fa:	57                   	push   %edi
  8013fb:	e8 4d ff ff ff       	call   80134d <read>
		if (m < 0)
  801400:	83 c4 10             	add    $0x10,%esp
  801403:	85 c0                	test   %eax,%eax
  801405:	78 06                	js     80140d <readn+0x39>
			return m;
		if (m == 0)
  801407:	74 06                	je     80140f <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801409:	01 c3                	add    %eax,%ebx
  80140b:	eb db                	jmp    8013e8 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80140d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80140f:	89 d8                	mov    %ebx,%eax
  801411:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801414:	5b                   	pop    %ebx
  801415:	5e                   	pop    %esi
  801416:	5f                   	pop    %edi
  801417:	5d                   	pop    %ebp
  801418:	c3                   	ret    

00801419 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
  80141c:	53                   	push   %ebx
  80141d:	83 ec 1c             	sub    $0x1c,%esp
  801420:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801423:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801426:	50                   	push   %eax
  801427:	53                   	push   %ebx
  801428:	e8 b0 fc ff ff       	call   8010dd <fd_lookup>
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	85 c0                	test   %eax,%eax
  801432:	78 3a                	js     80146e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801434:	83 ec 08             	sub    $0x8,%esp
  801437:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143a:	50                   	push   %eax
  80143b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143e:	ff 30                	pushl  (%eax)
  801440:	e8 e8 fc ff ff       	call   80112d <dev_lookup>
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	85 c0                	test   %eax,%eax
  80144a:	78 22                	js     80146e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80144c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801453:	74 1e                	je     801473 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801455:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801458:	8b 52 0c             	mov    0xc(%edx),%edx
  80145b:	85 d2                	test   %edx,%edx
  80145d:	74 35                	je     801494 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80145f:	83 ec 04             	sub    $0x4,%esp
  801462:	ff 75 10             	pushl  0x10(%ebp)
  801465:	ff 75 0c             	pushl  0xc(%ebp)
  801468:	50                   	push   %eax
  801469:	ff d2                	call   *%edx
  80146b:	83 c4 10             	add    $0x10,%esp
}
  80146e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801471:	c9                   	leave  
  801472:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801473:	a1 08 40 80 00       	mov    0x804008,%eax
  801478:	8b 40 48             	mov    0x48(%eax),%eax
  80147b:	83 ec 04             	sub    $0x4,%esp
  80147e:	53                   	push   %ebx
  80147f:	50                   	push   %eax
  801480:	68 91 2a 80 00       	push   $0x802a91
  801485:	e8 6e ed ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801492:	eb da                	jmp    80146e <write+0x55>
		return -E_NOT_SUPP;
  801494:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801499:	eb d3                	jmp    80146e <write+0x55>

0080149b <seek>:

int
seek(int fdnum, off_t offset)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a4:	50                   	push   %eax
  8014a5:	ff 75 08             	pushl  0x8(%ebp)
  8014a8:	e8 30 fc ff ff       	call   8010dd <fd_lookup>
  8014ad:	83 c4 10             	add    $0x10,%esp
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	78 0e                	js     8014c2 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ba:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	53                   	push   %ebx
  8014c8:	83 ec 1c             	sub    $0x1c,%esp
  8014cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d1:	50                   	push   %eax
  8014d2:	53                   	push   %ebx
  8014d3:	e8 05 fc ff ff       	call   8010dd <fd_lookup>
  8014d8:	83 c4 10             	add    $0x10,%esp
  8014db:	85 c0                	test   %eax,%eax
  8014dd:	78 37                	js     801516 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014df:	83 ec 08             	sub    $0x8,%esp
  8014e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e5:	50                   	push   %eax
  8014e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e9:	ff 30                	pushl  (%eax)
  8014eb:	e8 3d fc ff ff       	call   80112d <dev_lookup>
  8014f0:	83 c4 10             	add    $0x10,%esp
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	78 1f                	js     801516 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014fa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014fe:	74 1b                	je     80151b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801500:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801503:	8b 52 18             	mov    0x18(%edx),%edx
  801506:	85 d2                	test   %edx,%edx
  801508:	74 32                	je     80153c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80150a:	83 ec 08             	sub    $0x8,%esp
  80150d:	ff 75 0c             	pushl  0xc(%ebp)
  801510:	50                   	push   %eax
  801511:	ff d2                	call   *%edx
  801513:	83 c4 10             	add    $0x10,%esp
}
  801516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801519:	c9                   	leave  
  80151a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80151b:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801520:	8b 40 48             	mov    0x48(%eax),%eax
  801523:	83 ec 04             	sub    $0x4,%esp
  801526:	53                   	push   %ebx
  801527:	50                   	push   %eax
  801528:	68 54 2a 80 00       	push   $0x802a54
  80152d:	e8 c6 ec ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80153a:	eb da                	jmp    801516 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80153c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801541:	eb d3                	jmp    801516 <ftruncate+0x52>

00801543 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	53                   	push   %ebx
  801547:	83 ec 1c             	sub    $0x1c,%esp
  80154a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80154d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801550:	50                   	push   %eax
  801551:	ff 75 08             	pushl  0x8(%ebp)
  801554:	e8 84 fb ff ff       	call   8010dd <fd_lookup>
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	85 c0                	test   %eax,%eax
  80155e:	78 4b                	js     8015ab <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801566:	50                   	push   %eax
  801567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156a:	ff 30                	pushl  (%eax)
  80156c:	e8 bc fb ff ff       	call   80112d <dev_lookup>
  801571:	83 c4 10             	add    $0x10,%esp
  801574:	85 c0                	test   %eax,%eax
  801576:	78 33                	js     8015ab <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80157f:	74 2f                	je     8015b0 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801581:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801584:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80158b:	00 00 00 
	stat->st_isdir = 0;
  80158e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801595:	00 00 00 
	stat->st_dev = dev;
  801598:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80159e:	83 ec 08             	sub    $0x8,%esp
  8015a1:	53                   	push   %ebx
  8015a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8015a5:	ff 50 14             	call   *0x14(%eax)
  8015a8:	83 c4 10             	add    $0x10,%esp
}
  8015ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    
		return -E_NOT_SUPP;
  8015b0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b5:	eb f4                	jmp    8015ab <fstat+0x68>

008015b7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	56                   	push   %esi
  8015bb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015bc:	83 ec 08             	sub    $0x8,%esp
  8015bf:	6a 00                	push   $0x0
  8015c1:	ff 75 08             	pushl  0x8(%ebp)
  8015c4:	e8 22 02 00 00       	call   8017eb <open>
  8015c9:	89 c3                	mov    %eax,%ebx
  8015cb:	83 c4 10             	add    $0x10,%esp
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	78 1b                	js     8015ed <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015d2:	83 ec 08             	sub    $0x8,%esp
  8015d5:	ff 75 0c             	pushl  0xc(%ebp)
  8015d8:	50                   	push   %eax
  8015d9:	e8 65 ff ff ff       	call   801543 <fstat>
  8015de:	89 c6                	mov    %eax,%esi
	close(fd);
  8015e0:	89 1c 24             	mov    %ebx,(%esp)
  8015e3:	e8 27 fc ff ff       	call   80120f <close>
	return r;
  8015e8:	83 c4 10             	add    $0x10,%esp
  8015eb:	89 f3                	mov    %esi,%ebx
}
  8015ed:	89 d8                	mov    %ebx,%eax
  8015ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f2:	5b                   	pop    %ebx
  8015f3:	5e                   	pop    %esi
  8015f4:	5d                   	pop    %ebp
  8015f5:	c3                   	ret    

008015f6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	56                   	push   %esi
  8015fa:	53                   	push   %ebx
  8015fb:	89 c6                	mov    %eax,%esi
  8015fd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015ff:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801606:	74 27                	je     80162f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801608:	6a 07                	push   $0x7
  80160a:	68 00 50 80 00       	push   $0x805000
  80160f:	56                   	push   %esi
  801610:	ff 35 00 40 80 00    	pushl  0x804000
  801616:	e8 d8 0c 00 00       	call   8022f3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80161b:	83 c4 0c             	add    $0xc,%esp
  80161e:	6a 00                	push   $0x0
  801620:	53                   	push   %ebx
  801621:	6a 00                	push   $0x0
  801623:	e8 62 0c 00 00       	call   80228a <ipc_recv>
}
  801628:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80162b:	5b                   	pop    %ebx
  80162c:	5e                   	pop    %esi
  80162d:	5d                   	pop    %ebp
  80162e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80162f:	83 ec 0c             	sub    $0xc,%esp
  801632:	6a 01                	push   $0x1
  801634:	e8 12 0d 00 00       	call   80234b <ipc_find_env>
  801639:	a3 00 40 80 00       	mov    %eax,0x804000
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	eb c5                	jmp    801608 <fsipc+0x12>

00801643 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	8b 40 0c             	mov    0xc(%eax),%eax
  80164f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801654:	8b 45 0c             	mov    0xc(%ebp),%eax
  801657:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80165c:	ba 00 00 00 00       	mov    $0x0,%edx
  801661:	b8 02 00 00 00       	mov    $0x2,%eax
  801666:	e8 8b ff ff ff       	call   8015f6 <fsipc>
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <devfile_flush>:
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8b 40 0c             	mov    0xc(%eax),%eax
  801679:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80167e:	ba 00 00 00 00       	mov    $0x0,%edx
  801683:	b8 06 00 00 00       	mov    $0x6,%eax
  801688:	e8 69 ff ff ff       	call   8015f6 <fsipc>
}
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <devfile_stat>:
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
  801692:	53                   	push   %ebx
  801693:	83 ec 04             	sub    $0x4,%esp
  801696:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	8b 40 0c             	mov    0xc(%eax),%eax
  80169f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a9:	b8 05 00 00 00       	mov    $0x5,%eax
  8016ae:	e8 43 ff ff ff       	call   8015f6 <fsipc>
  8016b3:	85 c0                	test   %eax,%eax
  8016b5:	78 2c                	js     8016e3 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016b7:	83 ec 08             	sub    $0x8,%esp
  8016ba:	68 00 50 80 00       	push   $0x805000
  8016bf:	53                   	push   %ebx
  8016c0:	e8 92 f2 ff ff       	call   800957 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016c5:	a1 80 50 80 00       	mov    0x805080,%eax
  8016ca:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016d0:	a1 84 50 80 00       	mov    0x805084,%eax
  8016d5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016db:	83 c4 10             	add    $0x10,%esp
  8016de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <devfile_write>:
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	53                   	push   %ebx
  8016ec:	83 ec 08             	sub    $0x8,%esp
  8016ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016fd:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801703:	53                   	push   %ebx
  801704:	ff 75 0c             	pushl  0xc(%ebp)
  801707:	68 08 50 80 00       	push   $0x805008
  80170c:	e8 36 f4 ff ff       	call   800b47 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801711:	ba 00 00 00 00       	mov    $0x0,%edx
  801716:	b8 04 00 00 00       	mov    $0x4,%eax
  80171b:	e8 d6 fe ff ff       	call   8015f6 <fsipc>
  801720:	83 c4 10             	add    $0x10,%esp
  801723:	85 c0                	test   %eax,%eax
  801725:	78 0b                	js     801732 <devfile_write+0x4a>
	assert(r <= n);
  801727:	39 d8                	cmp    %ebx,%eax
  801729:	77 0c                	ja     801737 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80172b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801730:	7f 1e                	jg     801750 <devfile_write+0x68>
}
  801732:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801735:	c9                   	leave  
  801736:	c3                   	ret    
	assert(r <= n);
  801737:	68 c4 2a 80 00       	push   $0x802ac4
  80173c:	68 cb 2a 80 00       	push   $0x802acb
  801741:	68 98 00 00 00       	push   $0x98
  801746:	68 e0 2a 80 00       	push   $0x802ae0
  80174b:	e8 6a 0a 00 00       	call   8021ba <_panic>
	assert(r <= PGSIZE);
  801750:	68 eb 2a 80 00       	push   $0x802aeb
  801755:	68 cb 2a 80 00       	push   $0x802acb
  80175a:	68 99 00 00 00       	push   $0x99
  80175f:	68 e0 2a 80 00       	push   $0x802ae0
  801764:	e8 51 0a 00 00       	call   8021ba <_panic>

00801769 <devfile_read>:
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	56                   	push   %esi
  80176d:	53                   	push   %ebx
  80176e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	8b 40 0c             	mov    0xc(%eax),%eax
  801777:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80177c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801782:	ba 00 00 00 00       	mov    $0x0,%edx
  801787:	b8 03 00 00 00       	mov    $0x3,%eax
  80178c:	e8 65 fe ff ff       	call   8015f6 <fsipc>
  801791:	89 c3                	mov    %eax,%ebx
  801793:	85 c0                	test   %eax,%eax
  801795:	78 1f                	js     8017b6 <devfile_read+0x4d>
	assert(r <= n);
  801797:	39 f0                	cmp    %esi,%eax
  801799:	77 24                	ja     8017bf <devfile_read+0x56>
	assert(r <= PGSIZE);
  80179b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017a0:	7f 33                	jg     8017d5 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017a2:	83 ec 04             	sub    $0x4,%esp
  8017a5:	50                   	push   %eax
  8017a6:	68 00 50 80 00       	push   $0x805000
  8017ab:	ff 75 0c             	pushl  0xc(%ebp)
  8017ae:	e8 32 f3 ff ff       	call   800ae5 <memmove>
	return r;
  8017b3:	83 c4 10             	add    $0x10,%esp
}
  8017b6:	89 d8                	mov    %ebx,%eax
  8017b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017bb:	5b                   	pop    %ebx
  8017bc:	5e                   	pop    %esi
  8017bd:	5d                   	pop    %ebp
  8017be:	c3                   	ret    
	assert(r <= n);
  8017bf:	68 c4 2a 80 00       	push   $0x802ac4
  8017c4:	68 cb 2a 80 00       	push   $0x802acb
  8017c9:	6a 7c                	push   $0x7c
  8017cb:	68 e0 2a 80 00       	push   $0x802ae0
  8017d0:	e8 e5 09 00 00       	call   8021ba <_panic>
	assert(r <= PGSIZE);
  8017d5:	68 eb 2a 80 00       	push   $0x802aeb
  8017da:	68 cb 2a 80 00       	push   $0x802acb
  8017df:	6a 7d                	push   $0x7d
  8017e1:	68 e0 2a 80 00       	push   $0x802ae0
  8017e6:	e8 cf 09 00 00       	call   8021ba <_panic>

008017eb <open>:
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	56                   	push   %esi
  8017ef:	53                   	push   %ebx
  8017f0:	83 ec 1c             	sub    $0x1c,%esp
  8017f3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017f6:	56                   	push   %esi
  8017f7:	e8 22 f1 ff ff       	call   80091e <strlen>
  8017fc:	83 c4 10             	add    $0x10,%esp
  8017ff:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801804:	7f 6c                	jg     801872 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801806:	83 ec 0c             	sub    $0xc,%esp
  801809:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180c:	50                   	push   %eax
  80180d:	e8 79 f8 ff ff       	call   80108b <fd_alloc>
  801812:	89 c3                	mov    %eax,%ebx
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	85 c0                	test   %eax,%eax
  801819:	78 3c                	js     801857 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80181b:	83 ec 08             	sub    $0x8,%esp
  80181e:	56                   	push   %esi
  80181f:	68 00 50 80 00       	push   $0x805000
  801824:	e8 2e f1 ff ff       	call   800957 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801829:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801831:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801834:	b8 01 00 00 00       	mov    $0x1,%eax
  801839:	e8 b8 fd ff ff       	call   8015f6 <fsipc>
  80183e:	89 c3                	mov    %eax,%ebx
  801840:	83 c4 10             	add    $0x10,%esp
  801843:	85 c0                	test   %eax,%eax
  801845:	78 19                	js     801860 <open+0x75>
	return fd2num(fd);
  801847:	83 ec 0c             	sub    $0xc,%esp
  80184a:	ff 75 f4             	pushl  -0xc(%ebp)
  80184d:	e8 12 f8 ff ff       	call   801064 <fd2num>
  801852:	89 c3                	mov    %eax,%ebx
  801854:	83 c4 10             	add    $0x10,%esp
}
  801857:	89 d8                	mov    %ebx,%eax
  801859:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80185c:	5b                   	pop    %ebx
  80185d:	5e                   	pop    %esi
  80185e:	5d                   	pop    %ebp
  80185f:	c3                   	ret    
		fd_close(fd, 0);
  801860:	83 ec 08             	sub    $0x8,%esp
  801863:	6a 00                	push   $0x0
  801865:	ff 75 f4             	pushl  -0xc(%ebp)
  801868:	e8 1b f9 ff ff       	call   801188 <fd_close>
		return r;
  80186d:	83 c4 10             	add    $0x10,%esp
  801870:	eb e5                	jmp    801857 <open+0x6c>
		return -E_BAD_PATH;
  801872:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801877:	eb de                	jmp    801857 <open+0x6c>

00801879 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80187f:	ba 00 00 00 00       	mov    $0x0,%edx
  801884:	b8 08 00 00 00       	mov    $0x8,%eax
  801889:	e8 68 fd ff ff       	call   8015f6 <fsipc>
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801896:	68 f7 2a 80 00       	push   $0x802af7
  80189b:	ff 75 0c             	pushl  0xc(%ebp)
  80189e:	e8 b4 f0 ff ff       	call   800957 <strcpy>
	return 0;
}
  8018a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <devsock_close>:
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	53                   	push   %ebx
  8018ae:	83 ec 10             	sub    $0x10,%esp
  8018b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018b4:	53                   	push   %ebx
  8018b5:	e8 d0 0a 00 00       	call   80238a <pageref>
  8018ba:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018bd:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018c2:	83 f8 01             	cmp    $0x1,%eax
  8018c5:	74 07                	je     8018ce <devsock_close+0x24>
}
  8018c7:	89 d0                	mov    %edx,%eax
  8018c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018ce:	83 ec 0c             	sub    $0xc,%esp
  8018d1:	ff 73 0c             	pushl  0xc(%ebx)
  8018d4:	e8 b9 02 00 00       	call   801b92 <nsipc_close>
  8018d9:	89 c2                	mov    %eax,%edx
  8018db:	83 c4 10             	add    $0x10,%esp
  8018de:	eb e7                	jmp    8018c7 <devsock_close+0x1d>

008018e0 <devsock_write>:
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018e6:	6a 00                	push   $0x0
  8018e8:	ff 75 10             	pushl  0x10(%ebp)
  8018eb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	ff 70 0c             	pushl  0xc(%eax)
  8018f4:	e8 76 03 00 00       	call   801c6f <nsipc_send>
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <devsock_read>:
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801901:	6a 00                	push   $0x0
  801903:	ff 75 10             	pushl  0x10(%ebp)
  801906:	ff 75 0c             	pushl  0xc(%ebp)
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	ff 70 0c             	pushl  0xc(%eax)
  80190f:	e8 ef 02 00 00       	call   801c03 <nsipc_recv>
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <fd2sockid>:
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80191c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80191f:	52                   	push   %edx
  801920:	50                   	push   %eax
  801921:	e8 b7 f7 ff ff       	call   8010dd <fd_lookup>
  801926:	83 c4 10             	add    $0x10,%esp
  801929:	85 c0                	test   %eax,%eax
  80192b:	78 10                	js     80193d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80192d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801930:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801936:	39 08                	cmp    %ecx,(%eax)
  801938:	75 05                	jne    80193f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80193a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    
		return -E_NOT_SUPP;
  80193f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801944:	eb f7                	jmp    80193d <fd2sockid+0x27>

00801946 <alloc_sockfd>:
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	56                   	push   %esi
  80194a:	53                   	push   %ebx
  80194b:	83 ec 1c             	sub    $0x1c,%esp
  80194e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801950:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801953:	50                   	push   %eax
  801954:	e8 32 f7 ff ff       	call   80108b <fd_alloc>
  801959:	89 c3                	mov    %eax,%ebx
  80195b:	83 c4 10             	add    $0x10,%esp
  80195e:	85 c0                	test   %eax,%eax
  801960:	78 43                	js     8019a5 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	68 07 04 00 00       	push   $0x407
  80196a:	ff 75 f4             	pushl  -0xc(%ebp)
  80196d:	6a 00                	push   $0x0
  80196f:	e8 d5 f3 ff ff       	call   800d49 <sys_page_alloc>
  801974:	89 c3                	mov    %eax,%ebx
  801976:	83 c4 10             	add    $0x10,%esp
  801979:	85 c0                	test   %eax,%eax
  80197b:	78 28                	js     8019a5 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80197d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801980:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801986:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801992:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801995:	83 ec 0c             	sub    $0xc,%esp
  801998:	50                   	push   %eax
  801999:	e8 c6 f6 ff ff       	call   801064 <fd2num>
  80199e:	89 c3                	mov    %eax,%ebx
  8019a0:	83 c4 10             	add    $0x10,%esp
  8019a3:	eb 0c                	jmp    8019b1 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019a5:	83 ec 0c             	sub    $0xc,%esp
  8019a8:	56                   	push   %esi
  8019a9:	e8 e4 01 00 00       	call   801b92 <nsipc_close>
		return r;
  8019ae:	83 c4 10             	add    $0x10,%esp
}
  8019b1:	89 d8                	mov    %ebx,%eax
  8019b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b6:	5b                   	pop    %ebx
  8019b7:	5e                   	pop    %esi
  8019b8:	5d                   	pop    %ebp
  8019b9:	c3                   	ret    

008019ba <accept>:
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	e8 4e ff ff ff       	call   801916 <fd2sockid>
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	78 1b                	js     8019e7 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	ff 75 10             	pushl  0x10(%ebp)
  8019d2:	ff 75 0c             	pushl  0xc(%ebp)
  8019d5:	50                   	push   %eax
  8019d6:	e8 0e 01 00 00       	call   801ae9 <nsipc_accept>
  8019db:	83 c4 10             	add    $0x10,%esp
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	78 05                	js     8019e7 <accept+0x2d>
	return alloc_sockfd(r);
  8019e2:	e8 5f ff ff ff       	call   801946 <alloc_sockfd>
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <bind>:
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	e8 1f ff ff ff       	call   801916 <fd2sockid>
  8019f7:	85 c0                	test   %eax,%eax
  8019f9:	78 12                	js     801a0d <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019fb:	83 ec 04             	sub    $0x4,%esp
  8019fe:	ff 75 10             	pushl  0x10(%ebp)
  801a01:	ff 75 0c             	pushl  0xc(%ebp)
  801a04:	50                   	push   %eax
  801a05:	e8 31 01 00 00       	call   801b3b <nsipc_bind>
  801a0a:	83 c4 10             	add    $0x10,%esp
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <shutdown>:
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	e8 f9 fe ff ff       	call   801916 <fd2sockid>
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	78 0f                	js     801a30 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a21:	83 ec 08             	sub    $0x8,%esp
  801a24:	ff 75 0c             	pushl  0xc(%ebp)
  801a27:	50                   	push   %eax
  801a28:	e8 43 01 00 00       	call   801b70 <nsipc_shutdown>
  801a2d:	83 c4 10             	add    $0x10,%esp
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <connect>:
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	e8 d6 fe ff ff       	call   801916 <fd2sockid>
  801a40:	85 c0                	test   %eax,%eax
  801a42:	78 12                	js     801a56 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a44:	83 ec 04             	sub    $0x4,%esp
  801a47:	ff 75 10             	pushl  0x10(%ebp)
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	50                   	push   %eax
  801a4e:	e8 59 01 00 00       	call   801bac <nsipc_connect>
  801a53:	83 c4 10             	add    $0x10,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <listen>:
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	e8 b0 fe ff ff       	call   801916 <fd2sockid>
  801a66:	85 c0                	test   %eax,%eax
  801a68:	78 0f                	js     801a79 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a6a:	83 ec 08             	sub    $0x8,%esp
  801a6d:	ff 75 0c             	pushl  0xc(%ebp)
  801a70:	50                   	push   %eax
  801a71:	e8 6b 01 00 00       	call   801be1 <nsipc_listen>
  801a76:	83 c4 10             	add    $0x10,%esp
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <socket>:

int
socket(int domain, int type, int protocol)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
  801a7e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a81:	ff 75 10             	pushl  0x10(%ebp)
  801a84:	ff 75 0c             	pushl  0xc(%ebp)
  801a87:	ff 75 08             	pushl  0x8(%ebp)
  801a8a:	e8 3e 02 00 00       	call   801ccd <nsipc_socket>
  801a8f:	83 c4 10             	add    $0x10,%esp
  801a92:	85 c0                	test   %eax,%eax
  801a94:	78 05                	js     801a9b <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a96:	e8 ab fe ff ff       	call   801946 <alloc_sockfd>
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	53                   	push   %ebx
  801aa1:	83 ec 04             	sub    $0x4,%esp
  801aa4:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801aa6:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801aad:	74 26                	je     801ad5 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801aaf:	6a 07                	push   $0x7
  801ab1:	68 00 60 80 00       	push   $0x806000
  801ab6:	53                   	push   %ebx
  801ab7:	ff 35 04 40 80 00    	pushl  0x804004
  801abd:	e8 31 08 00 00       	call   8022f3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ac2:	83 c4 0c             	add    $0xc,%esp
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	e8 ba 07 00 00       	call   80228a <ipc_recv>
}
  801ad0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ad5:	83 ec 0c             	sub    $0xc,%esp
  801ad8:	6a 02                	push   $0x2
  801ada:	e8 6c 08 00 00       	call   80234b <ipc_find_env>
  801adf:	a3 04 40 80 00       	mov    %eax,0x804004
  801ae4:	83 c4 10             	add    $0x10,%esp
  801ae7:	eb c6                	jmp    801aaf <nsipc+0x12>

00801ae9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	56                   	push   %esi
  801aed:	53                   	push   %ebx
  801aee:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801af9:	8b 06                	mov    (%esi),%eax
  801afb:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b00:	b8 01 00 00 00       	mov    $0x1,%eax
  801b05:	e8 93 ff ff ff       	call   801a9d <nsipc>
  801b0a:	89 c3                	mov    %eax,%ebx
  801b0c:	85 c0                	test   %eax,%eax
  801b0e:	79 09                	jns    801b19 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b10:	89 d8                	mov    %ebx,%eax
  801b12:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b15:	5b                   	pop    %ebx
  801b16:	5e                   	pop    %esi
  801b17:	5d                   	pop    %ebp
  801b18:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b19:	83 ec 04             	sub    $0x4,%esp
  801b1c:	ff 35 10 60 80 00    	pushl  0x806010
  801b22:	68 00 60 80 00       	push   $0x806000
  801b27:	ff 75 0c             	pushl  0xc(%ebp)
  801b2a:	e8 b6 ef ff ff       	call   800ae5 <memmove>
		*addrlen = ret->ret_addrlen;
  801b2f:	a1 10 60 80 00       	mov    0x806010,%eax
  801b34:	89 06                	mov    %eax,(%esi)
  801b36:	83 c4 10             	add    $0x10,%esp
	return r;
  801b39:	eb d5                	jmp    801b10 <nsipc_accept+0x27>

00801b3b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	53                   	push   %ebx
  801b3f:	83 ec 08             	sub    $0x8,%esp
  801b42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b4d:	53                   	push   %ebx
  801b4e:	ff 75 0c             	pushl  0xc(%ebp)
  801b51:	68 04 60 80 00       	push   $0x806004
  801b56:	e8 8a ef ff ff       	call   800ae5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b5b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b61:	b8 02 00 00 00       	mov    $0x2,%eax
  801b66:	e8 32 ff ff ff       	call   801a9d <nsipc>
}
  801b6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b81:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b86:	b8 03 00 00 00       	mov    $0x3,%eax
  801b8b:	e8 0d ff ff ff       	call   801a9d <nsipc>
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <nsipc_close>:

int
nsipc_close(int s)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ba0:	b8 04 00 00 00       	mov    $0x4,%eax
  801ba5:	e8 f3 fe ff ff       	call   801a9d <nsipc>
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	53                   	push   %ebx
  801bb0:	83 ec 08             	sub    $0x8,%esp
  801bb3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bbe:	53                   	push   %ebx
  801bbf:	ff 75 0c             	pushl  0xc(%ebp)
  801bc2:	68 04 60 80 00       	push   $0x806004
  801bc7:	e8 19 ef ff ff       	call   800ae5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bcc:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bd2:	b8 05 00 00 00       	mov    $0x5,%eax
  801bd7:	e8 c1 fe ff ff       	call   801a9d <nsipc>
}
  801bdc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bf7:	b8 06 00 00 00       	mov    $0x6,%eax
  801bfc:	e8 9c fe ff ff       	call   801a9d <nsipc>
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	56                   	push   %esi
  801c07:	53                   	push   %ebx
  801c08:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c13:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c19:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1c:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c21:	b8 07 00 00 00       	mov    $0x7,%eax
  801c26:	e8 72 fe ff ff       	call   801a9d <nsipc>
  801c2b:	89 c3                	mov    %eax,%ebx
  801c2d:	85 c0                	test   %eax,%eax
  801c2f:	78 1f                	js     801c50 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c31:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c36:	7f 21                	jg     801c59 <nsipc_recv+0x56>
  801c38:	39 c6                	cmp    %eax,%esi
  801c3a:	7c 1d                	jl     801c59 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c3c:	83 ec 04             	sub    $0x4,%esp
  801c3f:	50                   	push   %eax
  801c40:	68 00 60 80 00       	push   $0x806000
  801c45:	ff 75 0c             	pushl  0xc(%ebp)
  801c48:	e8 98 ee ff ff       	call   800ae5 <memmove>
  801c4d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c50:	89 d8                	mov    %ebx,%eax
  801c52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c55:	5b                   	pop    %ebx
  801c56:	5e                   	pop    %esi
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c59:	68 03 2b 80 00       	push   $0x802b03
  801c5e:	68 cb 2a 80 00       	push   $0x802acb
  801c63:	6a 62                	push   $0x62
  801c65:	68 18 2b 80 00       	push   $0x802b18
  801c6a:	e8 4b 05 00 00       	call   8021ba <_panic>

00801c6f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	53                   	push   %ebx
  801c73:	83 ec 04             	sub    $0x4,%esp
  801c76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c81:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c87:	7f 2e                	jg     801cb7 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c89:	83 ec 04             	sub    $0x4,%esp
  801c8c:	53                   	push   %ebx
  801c8d:	ff 75 0c             	pushl  0xc(%ebp)
  801c90:	68 0c 60 80 00       	push   $0x80600c
  801c95:	e8 4b ee ff ff       	call   800ae5 <memmove>
	nsipcbuf.send.req_size = size;
  801c9a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ca8:	b8 08 00 00 00       	mov    $0x8,%eax
  801cad:	e8 eb fd ff ff       	call   801a9d <nsipc>
}
  801cb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    
	assert(size < 1600);
  801cb7:	68 24 2b 80 00       	push   $0x802b24
  801cbc:	68 cb 2a 80 00       	push   $0x802acb
  801cc1:	6a 6d                	push   $0x6d
  801cc3:	68 18 2b 80 00       	push   $0x802b18
  801cc8:	e8 ed 04 00 00       	call   8021ba <_panic>

00801ccd <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cde:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ce3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce6:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ceb:	b8 09 00 00 00       	mov    $0x9,%eax
  801cf0:	e8 a8 fd ff ff       	call   801a9d <nsipc>
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	56                   	push   %esi
  801cfb:	53                   	push   %ebx
  801cfc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cff:	83 ec 0c             	sub    $0xc,%esp
  801d02:	ff 75 08             	pushl  0x8(%ebp)
  801d05:	e8 6a f3 ff ff       	call   801074 <fd2data>
  801d0a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d0c:	83 c4 08             	add    $0x8,%esp
  801d0f:	68 30 2b 80 00       	push   $0x802b30
  801d14:	53                   	push   %ebx
  801d15:	e8 3d ec ff ff       	call   800957 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d1a:	8b 46 04             	mov    0x4(%esi),%eax
  801d1d:	2b 06                	sub    (%esi),%eax
  801d1f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d25:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d2c:	00 00 00 
	stat->st_dev = &devpipe;
  801d2f:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d36:	30 80 00 
	return 0;
}
  801d39:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d41:	5b                   	pop    %ebx
  801d42:	5e                   	pop    %esi
  801d43:	5d                   	pop    %ebp
  801d44:	c3                   	ret    

00801d45 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	53                   	push   %ebx
  801d49:	83 ec 0c             	sub    $0xc,%esp
  801d4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d4f:	53                   	push   %ebx
  801d50:	6a 00                	push   $0x0
  801d52:	e8 77 f0 ff ff       	call   800dce <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d57:	89 1c 24             	mov    %ebx,(%esp)
  801d5a:	e8 15 f3 ff ff       	call   801074 <fd2data>
  801d5f:	83 c4 08             	add    $0x8,%esp
  801d62:	50                   	push   %eax
  801d63:	6a 00                	push   $0x0
  801d65:	e8 64 f0 ff ff       	call   800dce <sys_page_unmap>
}
  801d6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <_pipeisclosed>:
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
  801d72:	57                   	push   %edi
  801d73:	56                   	push   %esi
  801d74:	53                   	push   %ebx
  801d75:	83 ec 1c             	sub    $0x1c,%esp
  801d78:	89 c7                	mov    %eax,%edi
  801d7a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d7c:	a1 08 40 80 00       	mov    0x804008,%eax
  801d81:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d84:	83 ec 0c             	sub    $0xc,%esp
  801d87:	57                   	push   %edi
  801d88:	e8 fd 05 00 00       	call   80238a <pageref>
  801d8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d90:	89 34 24             	mov    %esi,(%esp)
  801d93:	e8 f2 05 00 00       	call   80238a <pageref>
		nn = thisenv->env_runs;
  801d98:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d9e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	39 cb                	cmp    %ecx,%ebx
  801da6:	74 1b                	je     801dc3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801da8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dab:	75 cf                	jne    801d7c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801dad:	8b 42 58             	mov    0x58(%edx),%eax
  801db0:	6a 01                	push   $0x1
  801db2:	50                   	push   %eax
  801db3:	53                   	push   %ebx
  801db4:	68 37 2b 80 00       	push   $0x802b37
  801db9:	e8 3a e4 ff ff       	call   8001f8 <cprintf>
  801dbe:	83 c4 10             	add    $0x10,%esp
  801dc1:	eb b9                	jmp    801d7c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801dc3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dc6:	0f 94 c0             	sete   %al
  801dc9:	0f b6 c0             	movzbl %al,%eax
}
  801dcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dcf:	5b                   	pop    %ebx
  801dd0:	5e                   	pop    %esi
  801dd1:	5f                   	pop    %edi
  801dd2:	5d                   	pop    %ebp
  801dd3:	c3                   	ret    

00801dd4 <devpipe_write>:
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
  801dd7:	57                   	push   %edi
  801dd8:	56                   	push   %esi
  801dd9:	53                   	push   %ebx
  801dda:	83 ec 28             	sub    $0x28,%esp
  801ddd:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801de0:	56                   	push   %esi
  801de1:	e8 8e f2 ff ff       	call   801074 <fd2data>
  801de6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801de8:	83 c4 10             	add    $0x10,%esp
  801deb:	bf 00 00 00 00       	mov    $0x0,%edi
  801df0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801df3:	74 4f                	je     801e44 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801df5:	8b 43 04             	mov    0x4(%ebx),%eax
  801df8:	8b 0b                	mov    (%ebx),%ecx
  801dfa:	8d 51 20             	lea    0x20(%ecx),%edx
  801dfd:	39 d0                	cmp    %edx,%eax
  801dff:	72 14                	jb     801e15 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e01:	89 da                	mov    %ebx,%edx
  801e03:	89 f0                	mov    %esi,%eax
  801e05:	e8 65 ff ff ff       	call   801d6f <_pipeisclosed>
  801e0a:	85 c0                	test   %eax,%eax
  801e0c:	75 3b                	jne    801e49 <devpipe_write+0x75>
			sys_yield();
  801e0e:	e8 17 ef ff ff       	call   800d2a <sys_yield>
  801e13:	eb e0                	jmp    801df5 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e18:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e1c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e1f:	89 c2                	mov    %eax,%edx
  801e21:	c1 fa 1f             	sar    $0x1f,%edx
  801e24:	89 d1                	mov    %edx,%ecx
  801e26:	c1 e9 1b             	shr    $0x1b,%ecx
  801e29:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e2c:	83 e2 1f             	and    $0x1f,%edx
  801e2f:	29 ca                	sub    %ecx,%edx
  801e31:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e35:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e39:	83 c0 01             	add    $0x1,%eax
  801e3c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e3f:	83 c7 01             	add    $0x1,%edi
  801e42:	eb ac                	jmp    801df0 <devpipe_write+0x1c>
	return i;
  801e44:	8b 45 10             	mov    0x10(%ebp),%eax
  801e47:	eb 05                	jmp    801e4e <devpipe_write+0x7a>
				return 0;
  801e49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e51:	5b                   	pop    %ebx
  801e52:	5e                   	pop    %esi
  801e53:	5f                   	pop    %edi
  801e54:	5d                   	pop    %ebp
  801e55:	c3                   	ret    

00801e56 <devpipe_read>:
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	57                   	push   %edi
  801e5a:	56                   	push   %esi
  801e5b:	53                   	push   %ebx
  801e5c:	83 ec 18             	sub    $0x18,%esp
  801e5f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e62:	57                   	push   %edi
  801e63:	e8 0c f2 ff ff       	call   801074 <fd2data>
  801e68:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e6a:	83 c4 10             	add    $0x10,%esp
  801e6d:	be 00 00 00 00       	mov    $0x0,%esi
  801e72:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e75:	75 14                	jne    801e8b <devpipe_read+0x35>
	return i;
  801e77:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7a:	eb 02                	jmp    801e7e <devpipe_read+0x28>
				return i;
  801e7c:	89 f0                	mov    %esi,%eax
}
  801e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e81:	5b                   	pop    %ebx
  801e82:	5e                   	pop    %esi
  801e83:	5f                   	pop    %edi
  801e84:	5d                   	pop    %ebp
  801e85:	c3                   	ret    
			sys_yield();
  801e86:	e8 9f ee ff ff       	call   800d2a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e8b:	8b 03                	mov    (%ebx),%eax
  801e8d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e90:	75 18                	jne    801eaa <devpipe_read+0x54>
			if (i > 0)
  801e92:	85 f6                	test   %esi,%esi
  801e94:	75 e6                	jne    801e7c <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e96:	89 da                	mov    %ebx,%edx
  801e98:	89 f8                	mov    %edi,%eax
  801e9a:	e8 d0 fe ff ff       	call   801d6f <_pipeisclosed>
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	74 e3                	je     801e86 <devpipe_read+0x30>
				return 0;
  801ea3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea8:	eb d4                	jmp    801e7e <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801eaa:	99                   	cltd   
  801eab:	c1 ea 1b             	shr    $0x1b,%edx
  801eae:	01 d0                	add    %edx,%eax
  801eb0:	83 e0 1f             	and    $0x1f,%eax
  801eb3:	29 d0                	sub    %edx,%eax
  801eb5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801eba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ebd:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ec0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ec3:	83 c6 01             	add    $0x1,%esi
  801ec6:	eb aa                	jmp    801e72 <devpipe_read+0x1c>

00801ec8 <pipe>:
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	56                   	push   %esi
  801ecc:	53                   	push   %ebx
  801ecd:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ed0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed3:	50                   	push   %eax
  801ed4:	e8 b2 f1 ff ff       	call   80108b <fd_alloc>
  801ed9:	89 c3                	mov    %eax,%ebx
  801edb:	83 c4 10             	add    $0x10,%esp
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	0f 88 23 01 00 00    	js     802009 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee6:	83 ec 04             	sub    $0x4,%esp
  801ee9:	68 07 04 00 00       	push   $0x407
  801eee:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef1:	6a 00                	push   $0x0
  801ef3:	e8 51 ee ff ff       	call   800d49 <sys_page_alloc>
  801ef8:	89 c3                	mov    %eax,%ebx
  801efa:	83 c4 10             	add    $0x10,%esp
  801efd:	85 c0                	test   %eax,%eax
  801eff:	0f 88 04 01 00 00    	js     802009 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f05:	83 ec 0c             	sub    $0xc,%esp
  801f08:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f0b:	50                   	push   %eax
  801f0c:	e8 7a f1 ff ff       	call   80108b <fd_alloc>
  801f11:	89 c3                	mov    %eax,%ebx
  801f13:	83 c4 10             	add    $0x10,%esp
  801f16:	85 c0                	test   %eax,%eax
  801f18:	0f 88 db 00 00 00    	js     801ff9 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f1e:	83 ec 04             	sub    $0x4,%esp
  801f21:	68 07 04 00 00       	push   $0x407
  801f26:	ff 75 f0             	pushl  -0x10(%ebp)
  801f29:	6a 00                	push   $0x0
  801f2b:	e8 19 ee ff ff       	call   800d49 <sys_page_alloc>
  801f30:	89 c3                	mov    %eax,%ebx
  801f32:	83 c4 10             	add    $0x10,%esp
  801f35:	85 c0                	test   %eax,%eax
  801f37:	0f 88 bc 00 00 00    	js     801ff9 <pipe+0x131>
	va = fd2data(fd0);
  801f3d:	83 ec 0c             	sub    $0xc,%esp
  801f40:	ff 75 f4             	pushl  -0xc(%ebp)
  801f43:	e8 2c f1 ff ff       	call   801074 <fd2data>
  801f48:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f4a:	83 c4 0c             	add    $0xc,%esp
  801f4d:	68 07 04 00 00       	push   $0x407
  801f52:	50                   	push   %eax
  801f53:	6a 00                	push   $0x0
  801f55:	e8 ef ed ff ff       	call   800d49 <sys_page_alloc>
  801f5a:	89 c3                	mov    %eax,%ebx
  801f5c:	83 c4 10             	add    $0x10,%esp
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	0f 88 82 00 00 00    	js     801fe9 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f67:	83 ec 0c             	sub    $0xc,%esp
  801f6a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f6d:	e8 02 f1 ff ff       	call   801074 <fd2data>
  801f72:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f79:	50                   	push   %eax
  801f7a:	6a 00                	push   $0x0
  801f7c:	56                   	push   %esi
  801f7d:	6a 00                	push   $0x0
  801f7f:	e8 08 ee ff ff       	call   800d8c <sys_page_map>
  801f84:	89 c3                	mov    %eax,%ebx
  801f86:	83 c4 20             	add    $0x20,%esp
  801f89:	85 c0                	test   %eax,%eax
  801f8b:	78 4e                	js     801fdb <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f8d:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f95:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801fa1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fa4:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fb0:	83 ec 0c             	sub    $0xc,%esp
  801fb3:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb6:	e8 a9 f0 ff ff       	call   801064 <fd2num>
  801fbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fbe:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fc0:	83 c4 04             	add    $0x4,%esp
  801fc3:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc6:	e8 99 f0 ff ff       	call   801064 <fd2num>
  801fcb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fce:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fd1:	83 c4 10             	add    $0x10,%esp
  801fd4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fd9:	eb 2e                	jmp    802009 <pipe+0x141>
	sys_page_unmap(0, va);
  801fdb:	83 ec 08             	sub    $0x8,%esp
  801fde:	56                   	push   %esi
  801fdf:	6a 00                	push   $0x0
  801fe1:	e8 e8 ed ff ff       	call   800dce <sys_page_unmap>
  801fe6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fe9:	83 ec 08             	sub    $0x8,%esp
  801fec:	ff 75 f0             	pushl  -0x10(%ebp)
  801fef:	6a 00                	push   $0x0
  801ff1:	e8 d8 ed ff ff       	call   800dce <sys_page_unmap>
  801ff6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ff9:	83 ec 08             	sub    $0x8,%esp
  801ffc:	ff 75 f4             	pushl  -0xc(%ebp)
  801fff:	6a 00                	push   $0x0
  802001:	e8 c8 ed ff ff       	call   800dce <sys_page_unmap>
  802006:	83 c4 10             	add    $0x10,%esp
}
  802009:	89 d8                	mov    %ebx,%eax
  80200b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80200e:	5b                   	pop    %ebx
  80200f:	5e                   	pop    %esi
  802010:	5d                   	pop    %ebp
  802011:	c3                   	ret    

00802012 <pipeisclosed>:
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802018:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80201b:	50                   	push   %eax
  80201c:	ff 75 08             	pushl  0x8(%ebp)
  80201f:	e8 b9 f0 ff ff       	call   8010dd <fd_lookup>
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	85 c0                	test   %eax,%eax
  802029:	78 18                	js     802043 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80202b:	83 ec 0c             	sub    $0xc,%esp
  80202e:	ff 75 f4             	pushl  -0xc(%ebp)
  802031:	e8 3e f0 ff ff       	call   801074 <fd2data>
	return _pipeisclosed(fd, p);
  802036:	89 c2                	mov    %eax,%edx
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	e8 2f fd ff ff       	call   801d6f <_pipeisclosed>
  802040:	83 c4 10             	add    $0x10,%esp
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802045:	b8 00 00 00 00       	mov    $0x0,%eax
  80204a:	c3                   	ret    

0080204b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802051:	68 4f 2b 80 00       	push   $0x802b4f
  802056:	ff 75 0c             	pushl  0xc(%ebp)
  802059:	e8 f9 e8 ff ff       	call   800957 <strcpy>
	return 0;
}
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <devcons_write>:
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	57                   	push   %edi
  802069:	56                   	push   %esi
  80206a:	53                   	push   %ebx
  80206b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802071:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802076:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80207c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80207f:	73 31                	jae    8020b2 <devcons_write+0x4d>
		m = n - tot;
  802081:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802084:	29 f3                	sub    %esi,%ebx
  802086:	83 fb 7f             	cmp    $0x7f,%ebx
  802089:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80208e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802091:	83 ec 04             	sub    $0x4,%esp
  802094:	53                   	push   %ebx
  802095:	89 f0                	mov    %esi,%eax
  802097:	03 45 0c             	add    0xc(%ebp),%eax
  80209a:	50                   	push   %eax
  80209b:	57                   	push   %edi
  80209c:	e8 44 ea ff ff       	call   800ae5 <memmove>
		sys_cputs(buf, m);
  8020a1:	83 c4 08             	add    $0x8,%esp
  8020a4:	53                   	push   %ebx
  8020a5:	57                   	push   %edi
  8020a6:	e8 e2 eb ff ff       	call   800c8d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020ab:	01 de                	add    %ebx,%esi
  8020ad:	83 c4 10             	add    $0x10,%esp
  8020b0:	eb ca                	jmp    80207c <devcons_write+0x17>
}
  8020b2:	89 f0                	mov    %esi,%eax
  8020b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020b7:	5b                   	pop    %ebx
  8020b8:	5e                   	pop    %esi
  8020b9:	5f                   	pop    %edi
  8020ba:	5d                   	pop    %ebp
  8020bb:	c3                   	ret    

008020bc <devcons_read>:
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	83 ec 08             	sub    $0x8,%esp
  8020c2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020cb:	74 21                	je     8020ee <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020cd:	e8 d9 eb ff ff       	call   800cab <sys_cgetc>
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	75 07                	jne    8020dd <devcons_read+0x21>
		sys_yield();
  8020d6:	e8 4f ec ff ff       	call   800d2a <sys_yield>
  8020db:	eb f0                	jmp    8020cd <devcons_read+0x11>
	if (c < 0)
  8020dd:	78 0f                	js     8020ee <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020df:	83 f8 04             	cmp    $0x4,%eax
  8020e2:	74 0c                	je     8020f0 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e7:	88 02                	mov    %al,(%edx)
	return 1;
  8020e9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    
		return 0;
  8020f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f5:	eb f7                	jmp    8020ee <devcons_read+0x32>

008020f7 <cputchar>:
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802103:	6a 01                	push   $0x1
  802105:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802108:	50                   	push   %eax
  802109:	e8 7f eb ff ff       	call   800c8d <sys_cputs>
}
  80210e:	83 c4 10             	add    $0x10,%esp
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <getchar>:
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802119:	6a 01                	push   $0x1
  80211b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80211e:	50                   	push   %eax
  80211f:	6a 00                	push   $0x0
  802121:	e8 27 f2 ff ff       	call   80134d <read>
	if (r < 0)
  802126:	83 c4 10             	add    $0x10,%esp
  802129:	85 c0                	test   %eax,%eax
  80212b:	78 06                	js     802133 <getchar+0x20>
	if (r < 1)
  80212d:	74 06                	je     802135 <getchar+0x22>
	return c;
  80212f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    
		return -E_EOF;
  802135:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80213a:	eb f7                	jmp    802133 <getchar+0x20>

0080213c <iscons>:
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802142:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802145:	50                   	push   %eax
  802146:	ff 75 08             	pushl  0x8(%ebp)
  802149:	e8 8f ef ff ff       	call   8010dd <fd_lookup>
  80214e:	83 c4 10             	add    $0x10,%esp
  802151:	85 c0                	test   %eax,%eax
  802153:	78 11                	js     802166 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802158:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80215e:	39 10                	cmp    %edx,(%eax)
  802160:	0f 94 c0             	sete   %al
  802163:	0f b6 c0             	movzbl %al,%eax
}
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <opencons>:
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80216e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802171:	50                   	push   %eax
  802172:	e8 14 ef ff ff       	call   80108b <fd_alloc>
  802177:	83 c4 10             	add    $0x10,%esp
  80217a:	85 c0                	test   %eax,%eax
  80217c:	78 3a                	js     8021b8 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80217e:	83 ec 04             	sub    $0x4,%esp
  802181:	68 07 04 00 00       	push   $0x407
  802186:	ff 75 f4             	pushl  -0xc(%ebp)
  802189:	6a 00                	push   $0x0
  80218b:	e8 b9 eb ff ff       	call   800d49 <sys_page_alloc>
  802190:	83 c4 10             	add    $0x10,%esp
  802193:	85 c0                	test   %eax,%eax
  802195:	78 21                	js     8021b8 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219a:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021a0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021ac:	83 ec 0c             	sub    $0xc,%esp
  8021af:	50                   	push   %eax
  8021b0:	e8 af ee ff ff       	call   801064 <fd2num>
  8021b5:	83 c4 10             	add    $0x10,%esp
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	56                   	push   %esi
  8021be:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8021bf:	a1 08 40 80 00       	mov    0x804008,%eax
  8021c4:	8b 40 48             	mov    0x48(%eax),%eax
  8021c7:	83 ec 04             	sub    $0x4,%esp
  8021ca:	68 80 2b 80 00       	push   $0x802b80
  8021cf:	50                   	push   %eax
  8021d0:	68 78 26 80 00       	push   $0x802678
  8021d5:	e8 1e e0 ff ff       	call   8001f8 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021da:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021dd:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021e3:	e8 23 eb ff ff       	call   800d0b <sys_getenvid>
  8021e8:	83 c4 04             	add    $0x4,%esp
  8021eb:	ff 75 0c             	pushl  0xc(%ebp)
  8021ee:	ff 75 08             	pushl  0x8(%ebp)
  8021f1:	56                   	push   %esi
  8021f2:	50                   	push   %eax
  8021f3:	68 5c 2b 80 00       	push   $0x802b5c
  8021f8:	e8 fb df ff ff       	call   8001f8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021fd:	83 c4 18             	add    $0x18,%esp
  802200:	53                   	push   %ebx
  802201:	ff 75 10             	pushl  0x10(%ebp)
  802204:	e8 9e df ff ff       	call   8001a7 <vcprintf>
	cprintf("\n");
  802209:	c7 04 24 3c 26 80 00 	movl   $0x80263c,(%esp)
  802210:	e8 e3 df ff ff       	call   8001f8 <cprintf>
  802215:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802218:	cc                   	int3   
  802219:	eb fd                	jmp    802218 <_panic+0x5e>

0080221b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802221:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802228:	74 0a                	je     802234 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802234:	83 ec 04             	sub    $0x4,%esp
  802237:	6a 07                	push   $0x7
  802239:	68 00 f0 bf ee       	push   $0xeebff000
  80223e:	6a 00                	push   $0x0
  802240:	e8 04 eb ff ff       	call   800d49 <sys_page_alloc>
		if(r < 0)
  802245:	83 c4 10             	add    $0x10,%esp
  802248:	85 c0                	test   %eax,%eax
  80224a:	78 2a                	js     802276 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80224c:	83 ec 08             	sub    $0x8,%esp
  80224f:	68 3e 10 80 00       	push   $0x80103e
  802254:	6a 00                	push   $0x0
  802256:	e8 39 ec ff ff       	call   800e94 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80225b:	83 c4 10             	add    $0x10,%esp
  80225e:	85 c0                	test   %eax,%eax
  802260:	79 c8                	jns    80222a <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802262:	83 ec 04             	sub    $0x4,%esp
  802265:	68 b8 2b 80 00       	push   $0x802bb8
  80226a:	6a 25                	push   $0x25
  80226c:	68 f4 2b 80 00       	push   $0x802bf4
  802271:	e8 44 ff ff ff       	call   8021ba <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802276:	83 ec 04             	sub    $0x4,%esp
  802279:	68 88 2b 80 00       	push   $0x802b88
  80227e:	6a 22                	push   $0x22
  802280:	68 f4 2b 80 00       	push   $0x802bf4
  802285:	e8 30 ff ff ff       	call   8021ba <_panic>

0080228a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80228a:	55                   	push   %ebp
  80228b:	89 e5                	mov    %esp,%ebp
  80228d:	56                   	push   %esi
  80228e:	53                   	push   %ebx
  80228f:	8b 75 08             	mov    0x8(%ebp),%esi
  802292:	8b 45 0c             	mov    0xc(%ebp),%eax
  802295:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802298:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80229a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80229f:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8022a2:	83 ec 0c             	sub    $0xc,%esp
  8022a5:	50                   	push   %eax
  8022a6:	e8 4e ec ff ff       	call   800ef9 <sys_ipc_recv>
	if(ret < 0){
  8022ab:	83 c4 10             	add    $0x10,%esp
  8022ae:	85 c0                	test   %eax,%eax
  8022b0:	78 2b                	js     8022dd <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022b2:	85 f6                	test   %esi,%esi
  8022b4:	74 0a                	je     8022c0 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8022b6:	a1 08 40 80 00       	mov    0x804008,%eax
  8022bb:	8b 40 78             	mov    0x78(%eax),%eax
  8022be:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022c0:	85 db                	test   %ebx,%ebx
  8022c2:	74 0a                	je     8022ce <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8022c4:	a1 08 40 80 00       	mov    0x804008,%eax
  8022c9:	8b 40 7c             	mov    0x7c(%eax),%eax
  8022cc:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8022ce:	a1 08 40 80 00       	mov    0x804008,%eax
  8022d3:	8b 40 74             	mov    0x74(%eax),%eax
}
  8022d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022d9:	5b                   	pop    %ebx
  8022da:	5e                   	pop    %esi
  8022db:	5d                   	pop    %ebp
  8022dc:	c3                   	ret    
		if(from_env_store)
  8022dd:	85 f6                	test   %esi,%esi
  8022df:	74 06                	je     8022e7 <ipc_recv+0x5d>
			*from_env_store = 0;
  8022e1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022e7:	85 db                	test   %ebx,%ebx
  8022e9:	74 eb                	je     8022d6 <ipc_recv+0x4c>
			*perm_store = 0;
  8022eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022f1:	eb e3                	jmp    8022d6 <ipc_recv+0x4c>

008022f3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	57                   	push   %edi
  8022f7:	56                   	push   %esi
  8022f8:	53                   	push   %ebx
  8022f9:	83 ec 0c             	sub    $0xc,%esp
  8022fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  802302:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802305:	85 db                	test   %ebx,%ebx
  802307:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80230c:	0f 44 d8             	cmove  %eax,%ebx
  80230f:	eb 05                	jmp    802316 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802311:	e8 14 ea ff ff       	call   800d2a <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802316:	ff 75 14             	pushl  0x14(%ebp)
  802319:	53                   	push   %ebx
  80231a:	56                   	push   %esi
  80231b:	57                   	push   %edi
  80231c:	e8 b5 eb ff ff       	call   800ed6 <sys_ipc_try_send>
  802321:	83 c4 10             	add    $0x10,%esp
  802324:	85 c0                	test   %eax,%eax
  802326:	74 1b                	je     802343 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802328:	79 e7                	jns    802311 <ipc_send+0x1e>
  80232a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80232d:	74 e2                	je     802311 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80232f:	83 ec 04             	sub    $0x4,%esp
  802332:	68 02 2c 80 00       	push   $0x802c02
  802337:	6a 46                	push   $0x46
  802339:	68 17 2c 80 00       	push   $0x802c17
  80233e:	e8 77 fe ff ff       	call   8021ba <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802343:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802346:	5b                   	pop    %ebx
  802347:	5e                   	pop    %esi
  802348:	5f                   	pop    %edi
  802349:	5d                   	pop    %ebp
  80234a:	c3                   	ret    

0080234b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802351:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802356:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80235c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802362:	8b 52 50             	mov    0x50(%edx),%edx
  802365:	39 ca                	cmp    %ecx,%edx
  802367:	74 11                	je     80237a <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802369:	83 c0 01             	add    $0x1,%eax
  80236c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802371:	75 e3                	jne    802356 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802373:	b8 00 00 00 00       	mov    $0x0,%eax
  802378:	eb 0e                	jmp    802388 <ipc_find_env+0x3d>
			return envs[i].env_id;
  80237a:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802380:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802385:	8b 40 48             	mov    0x48(%eax),%eax
}
  802388:	5d                   	pop    %ebp
  802389:	c3                   	ret    

0080238a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802390:	89 d0                	mov    %edx,%eax
  802392:	c1 e8 16             	shr    $0x16,%eax
  802395:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80239c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023a1:	f6 c1 01             	test   $0x1,%cl
  8023a4:	74 1d                	je     8023c3 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023a6:	c1 ea 0c             	shr    $0xc,%edx
  8023a9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023b0:	f6 c2 01             	test   $0x1,%dl
  8023b3:	74 0e                	je     8023c3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023b5:	c1 ea 0c             	shr    $0xc,%edx
  8023b8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023bf:	ef 
  8023c0:	0f b7 c0             	movzwl %ax,%eax
}
  8023c3:	5d                   	pop    %ebp
  8023c4:	c3                   	ret    
  8023c5:	66 90                	xchg   %ax,%ax
  8023c7:	66 90                	xchg   %ax,%ax
  8023c9:	66 90                	xchg   %ax,%ax
  8023cb:	66 90                	xchg   %ax,%ax
  8023cd:	66 90                	xchg   %ax,%ax
  8023cf:	90                   	nop

008023d0 <__udivdi3>:
  8023d0:	55                   	push   %ebp
  8023d1:	57                   	push   %edi
  8023d2:	56                   	push   %esi
  8023d3:	53                   	push   %ebx
  8023d4:	83 ec 1c             	sub    $0x1c,%esp
  8023d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023e7:	85 d2                	test   %edx,%edx
  8023e9:	75 4d                	jne    802438 <__udivdi3+0x68>
  8023eb:	39 f3                	cmp    %esi,%ebx
  8023ed:	76 19                	jbe    802408 <__udivdi3+0x38>
  8023ef:	31 ff                	xor    %edi,%edi
  8023f1:	89 e8                	mov    %ebp,%eax
  8023f3:	89 f2                	mov    %esi,%edx
  8023f5:	f7 f3                	div    %ebx
  8023f7:	89 fa                	mov    %edi,%edx
  8023f9:	83 c4 1c             	add    $0x1c,%esp
  8023fc:	5b                   	pop    %ebx
  8023fd:	5e                   	pop    %esi
  8023fe:	5f                   	pop    %edi
  8023ff:	5d                   	pop    %ebp
  802400:	c3                   	ret    
  802401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802408:	89 d9                	mov    %ebx,%ecx
  80240a:	85 db                	test   %ebx,%ebx
  80240c:	75 0b                	jne    802419 <__udivdi3+0x49>
  80240e:	b8 01 00 00 00       	mov    $0x1,%eax
  802413:	31 d2                	xor    %edx,%edx
  802415:	f7 f3                	div    %ebx
  802417:	89 c1                	mov    %eax,%ecx
  802419:	31 d2                	xor    %edx,%edx
  80241b:	89 f0                	mov    %esi,%eax
  80241d:	f7 f1                	div    %ecx
  80241f:	89 c6                	mov    %eax,%esi
  802421:	89 e8                	mov    %ebp,%eax
  802423:	89 f7                	mov    %esi,%edi
  802425:	f7 f1                	div    %ecx
  802427:	89 fa                	mov    %edi,%edx
  802429:	83 c4 1c             	add    $0x1c,%esp
  80242c:	5b                   	pop    %ebx
  80242d:	5e                   	pop    %esi
  80242e:	5f                   	pop    %edi
  80242f:	5d                   	pop    %ebp
  802430:	c3                   	ret    
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	39 f2                	cmp    %esi,%edx
  80243a:	77 1c                	ja     802458 <__udivdi3+0x88>
  80243c:	0f bd fa             	bsr    %edx,%edi
  80243f:	83 f7 1f             	xor    $0x1f,%edi
  802442:	75 2c                	jne    802470 <__udivdi3+0xa0>
  802444:	39 f2                	cmp    %esi,%edx
  802446:	72 06                	jb     80244e <__udivdi3+0x7e>
  802448:	31 c0                	xor    %eax,%eax
  80244a:	39 eb                	cmp    %ebp,%ebx
  80244c:	77 a9                	ja     8023f7 <__udivdi3+0x27>
  80244e:	b8 01 00 00 00       	mov    $0x1,%eax
  802453:	eb a2                	jmp    8023f7 <__udivdi3+0x27>
  802455:	8d 76 00             	lea    0x0(%esi),%esi
  802458:	31 ff                	xor    %edi,%edi
  80245a:	31 c0                	xor    %eax,%eax
  80245c:	89 fa                	mov    %edi,%edx
  80245e:	83 c4 1c             	add    $0x1c,%esp
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5f                   	pop    %edi
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    
  802466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80246d:	8d 76 00             	lea    0x0(%esi),%esi
  802470:	89 f9                	mov    %edi,%ecx
  802472:	b8 20 00 00 00       	mov    $0x20,%eax
  802477:	29 f8                	sub    %edi,%eax
  802479:	d3 e2                	shl    %cl,%edx
  80247b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80247f:	89 c1                	mov    %eax,%ecx
  802481:	89 da                	mov    %ebx,%edx
  802483:	d3 ea                	shr    %cl,%edx
  802485:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802489:	09 d1                	or     %edx,%ecx
  80248b:	89 f2                	mov    %esi,%edx
  80248d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802491:	89 f9                	mov    %edi,%ecx
  802493:	d3 e3                	shl    %cl,%ebx
  802495:	89 c1                	mov    %eax,%ecx
  802497:	d3 ea                	shr    %cl,%edx
  802499:	89 f9                	mov    %edi,%ecx
  80249b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80249f:	89 eb                	mov    %ebp,%ebx
  8024a1:	d3 e6                	shl    %cl,%esi
  8024a3:	89 c1                	mov    %eax,%ecx
  8024a5:	d3 eb                	shr    %cl,%ebx
  8024a7:	09 de                	or     %ebx,%esi
  8024a9:	89 f0                	mov    %esi,%eax
  8024ab:	f7 74 24 08          	divl   0x8(%esp)
  8024af:	89 d6                	mov    %edx,%esi
  8024b1:	89 c3                	mov    %eax,%ebx
  8024b3:	f7 64 24 0c          	mull   0xc(%esp)
  8024b7:	39 d6                	cmp    %edx,%esi
  8024b9:	72 15                	jb     8024d0 <__udivdi3+0x100>
  8024bb:	89 f9                	mov    %edi,%ecx
  8024bd:	d3 e5                	shl    %cl,%ebp
  8024bf:	39 c5                	cmp    %eax,%ebp
  8024c1:	73 04                	jae    8024c7 <__udivdi3+0xf7>
  8024c3:	39 d6                	cmp    %edx,%esi
  8024c5:	74 09                	je     8024d0 <__udivdi3+0x100>
  8024c7:	89 d8                	mov    %ebx,%eax
  8024c9:	31 ff                	xor    %edi,%edi
  8024cb:	e9 27 ff ff ff       	jmp    8023f7 <__udivdi3+0x27>
  8024d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024d3:	31 ff                	xor    %edi,%edi
  8024d5:	e9 1d ff ff ff       	jmp    8023f7 <__udivdi3+0x27>
  8024da:	66 90                	xchg   %ax,%ax
  8024dc:	66 90                	xchg   %ax,%ax
  8024de:	66 90                	xchg   %ax,%ax

008024e0 <__umoddi3>:
  8024e0:	55                   	push   %ebp
  8024e1:	57                   	push   %edi
  8024e2:	56                   	push   %esi
  8024e3:	53                   	push   %ebx
  8024e4:	83 ec 1c             	sub    $0x1c,%esp
  8024e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024f7:	89 da                	mov    %ebx,%edx
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	75 43                	jne    802540 <__umoddi3+0x60>
  8024fd:	39 df                	cmp    %ebx,%edi
  8024ff:	76 17                	jbe    802518 <__umoddi3+0x38>
  802501:	89 f0                	mov    %esi,%eax
  802503:	f7 f7                	div    %edi
  802505:	89 d0                	mov    %edx,%eax
  802507:	31 d2                	xor    %edx,%edx
  802509:	83 c4 1c             	add    $0x1c,%esp
  80250c:	5b                   	pop    %ebx
  80250d:	5e                   	pop    %esi
  80250e:	5f                   	pop    %edi
  80250f:	5d                   	pop    %ebp
  802510:	c3                   	ret    
  802511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802518:	89 fd                	mov    %edi,%ebp
  80251a:	85 ff                	test   %edi,%edi
  80251c:	75 0b                	jne    802529 <__umoddi3+0x49>
  80251e:	b8 01 00 00 00       	mov    $0x1,%eax
  802523:	31 d2                	xor    %edx,%edx
  802525:	f7 f7                	div    %edi
  802527:	89 c5                	mov    %eax,%ebp
  802529:	89 d8                	mov    %ebx,%eax
  80252b:	31 d2                	xor    %edx,%edx
  80252d:	f7 f5                	div    %ebp
  80252f:	89 f0                	mov    %esi,%eax
  802531:	f7 f5                	div    %ebp
  802533:	89 d0                	mov    %edx,%eax
  802535:	eb d0                	jmp    802507 <__umoddi3+0x27>
  802537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80253e:	66 90                	xchg   %ax,%ax
  802540:	89 f1                	mov    %esi,%ecx
  802542:	39 d8                	cmp    %ebx,%eax
  802544:	76 0a                	jbe    802550 <__umoddi3+0x70>
  802546:	89 f0                	mov    %esi,%eax
  802548:	83 c4 1c             	add    $0x1c,%esp
  80254b:	5b                   	pop    %ebx
  80254c:	5e                   	pop    %esi
  80254d:	5f                   	pop    %edi
  80254e:	5d                   	pop    %ebp
  80254f:	c3                   	ret    
  802550:	0f bd e8             	bsr    %eax,%ebp
  802553:	83 f5 1f             	xor    $0x1f,%ebp
  802556:	75 20                	jne    802578 <__umoddi3+0x98>
  802558:	39 d8                	cmp    %ebx,%eax
  80255a:	0f 82 b0 00 00 00    	jb     802610 <__umoddi3+0x130>
  802560:	39 f7                	cmp    %esi,%edi
  802562:	0f 86 a8 00 00 00    	jbe    802610 <__umoddi3+0x130>
  802568:	89 c8                	mov    %ecx,%eax
  80256a:	83 c4 1c             	add    $0x1c,%esp
  80256d:	5b                   	pop    %ebx
  80256e:	5e                   	pop    %esi
  80256f:	5f                   	pop    %edi
  802570:	5d                   	pop    %ebp
  802571:	c3                   	ret    
  802572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802578:	89 e9                	mov    %ebp,%ecx
  80257a:	ba 20 00 00 00       	mov    $0x20,%edx
  80257f:	29 ea                	sub    %ebp,%edx
  802581:	d3 e0                	shl    %cl,%eax
  802583:	89 44 24 08          	mov    %eax,0x8(%esp)
  802587:	89 d1                	mov    %edx,%ecx
  802589:	89 f8                	mov    %edi,%eax
  80258b:	d3 e8                	shr    %cl,%eax
  80258d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802591:	89 54 24 04          	mov    %edx,0x4(%esp)
  802595:	8b 54 24 04          	mov    0x4(%esp),%edx
  802599:	09 c1                	or     %eax,%ecx
  80259b:	89 d8                	mov    %ebx,%eax
  80259d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025a1:	89 e9                	mov    %ebp,%ecx
  8025a3:	d3 e7                	shl    %cl,%edi
  8025a5:	89 d1                	mov    %edx,%ecx
  8025a7:	d3 e8                	shr    %cl,%eax
  8025a9:	89 e9                	mov    %ebp,%ecx
  8025ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025af:	d3 e3                	shl    %cl,%ebx
  8025b1:	89 c7                	mov    %eax,%edi
  8025b3:	89 d1                	mov    %edx,%ecx
  8025b5:	89 f0                	mov    %esi,%eax
  8025b7:	d3 e8                	shr    %cl,%eax
  8025b9:	89 e9                	mov    %ebp,%ecx
  8025bb:	89 fa                	mov    %edi,%edx
  8025bd:	d3 e6                	shl    %cl,%esi
  8025bf:	09 d8                	or     %ebx,%eax
  8025c1:	f7 74 24 08          	divl   0x8(%esp)
  8025c5:	89 d1                	mov    %edx,%ecx
  8025c7:	89 f3                	mov    %esi,%ebx
  8025c9:	f7 64 24 0c          	mull   0xc(%esp)
  8025cd:	89 c6                	mov    %eax,%esi
  8025cf:	89 d7                	mov    %edx,%edi
  8025d1:	39 d1                	cmp    %edx,%ecx
  8025d3:	72 06                	jb     8025db <__umoddi3+0xfb>
  8025d5:	75 10                	jne    8025e7 <__umoddi3+0x107>
  8025d7:	39 c3                	cmp    %eax,%ebx
  8025d9:	73 0c                	jae    8025e7 <__umoddi3+0x107>
  8025db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025e3:	89 d7                	mov    %edx,%edi
  8025e5:	89 c6                	mov    %eax,%esi
  8025e7:	89 ca                	mov    %ecx,%edx
  8025e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025ee:	29 f3                	sub    %esi,%ebx
  8025f0:	19 fa                	sbb    %edi,%edx
  8025f2:	89 d0                	mov    %edx,%eax
  8025f4:	d3 e0                	shl    %cl,%eax
  8025f6:	89 e9                	mov    %ebp,%ecx
  8025f8:	d3 eb                	shr    %cl,%ebx
  8025fa:	d3 ea                	shr    %cl,%edx
  8025fc:	09 d8                	or     %ebx,%eax
  8025fe:	83 c4 1c             	add    $0x1c,%esp
  802601:	5b                   	pop    %ebx
  802602:	5e                   	pop    %esi
  802603:	5f                   	pop    %edi
  802604:	5d                   	pop    %ebp
  802605:	c3                   	ret    
  802606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80260d:	8d 76 00             	lea    0x0(%esi),%esi
  802610:	89 da                	mov    %ebx,%edx
  802612:	29 fe                	sub    %edi,%esi
  802614:	19 c2                	sbb    %eax,%edx
  802616:	89 f1                	mov    %esi,%ecx
  802618:	89 c8                	mov    %ecx,%eax
  80261a:	e9 4b ff ff ff       	jmp    80256a <__umoddi3+0x8a>
