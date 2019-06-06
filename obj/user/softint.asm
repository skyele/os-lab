
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
  800049:	e8 9d 0c 00 00       	call   800ceb <sys_getenvid>
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
  80006e:	74 21                	je     800091 <libmain+0x5b>
		if(envs[i].env_id == find)
  800070:	89 d1                	mov    %edx,%ecx
  800072:	c1 e1 07             	shl    $0x7,%ecx
  800075:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80007b:	8b 49 48             	mov    0x48(%ecx),%ecx
  80007e:	39 c1                	cmp    %eax,%ecx
  800080:	75 e3                	jne    800065 <libmain+0x2f>
  800082:	89 d3                	mov    %edx,%ebx
  800084:	c1 e3 07             	shl    $0x7,%ebx
  800087:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80008d:	89 fe                	mov    %edi,%esi
  80008f:	eb d4                	jmp    800065 <libmain+0x2f>
  800091:	89 f0                	mov    %esi,%eax
  800093:	84 c0                	test   %al,%al
  800095:	74 06                	je     80009d <libmain+0x67>
  800097:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a1:	7e 0a                	jle    8000ad <libmain+0x77>
		binaryname = argv[0];
  8000a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a6:	8b 00                	mov    (%eax),%eax
  8000a8:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000ad:	a1 08 40 80 00       	mov    0x804008,%eax
  8000b2:	8b 40 48             	mov    0x48(%eax),%eax
  8000b5:	83 ec 08             	sub    $0x8,%esp
  8000b8:	50                   	push   %eax
  8000b9:	68 40 25 80 00       	push   $0x802540
  8000be:	e8 15 01 00 00       	call   8001d8 <cprintf>
	cprintf("before umain\n");
  8000c3:	c7 04 24 5e 25 80 00 	movl   $0x80255e,(%esp)
  8000ca:	e8 09 01 00 00       	call   8001d8 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000cf:	83 c4 08             	add    $0x8,%esp
  8000d2:	ff 75 0c             	pushl  0xc(%ebp)
  8000d5:	ff 75 08             	pushl  0x8(%ebp)
  8000d8:	e8 56 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000dd:	c7 04 24 6c 25 80 00 	movl   $0x80256c,(%esp)
  8000e4:	e8 ef 00 00 00       	call   8001d8 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8000e9:	a1 08 40 80 00       	mov    0x804008,%eax
  8000ee:	8b 40 48             	mov    0x48(%eax),%eax
  8000f1:	83 c4 08             	add    $0x8,%esp
  8000f4:	50                   	push   %eax
  8000f5:	68 79 25 80 00       	push   $0x802579
  8000fa:	e8 d9 00 00 00       	call   8001d8 <cprintf>
	// exit gracefully
	exit();
  8000ff:	e8 0b 00 00 00       	call   80010f <exit>
}
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010a:	5b                   	pop    %ebx
  80010b:	5e                   	pop    %esi
  80010c:	5f                   	pop    %edi
  80010d:	5d                   	pop    %ebp
  80010e:	c3                   	ret    

0080010f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010f:	55                   	push   %ebp
  800110:	89 e5                	mov    %esp,%ebp
  800112:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800115:	a1 08 40 80 00       	mov    0x804008,%eax
  80011a:	8b 40 48             	mov    0x48(%eax),%eax
  80011d:	68 a4 25 80 00       	push   $0x8025a4
  800122:	50                   	push   %eax
  800123:	68 98 25 80 00       	push   $0x802598
  800128:	e8 ab 00 00 00       	call   8001d8 <cprintf>
	close_all();
  80012d:	e8 a4 10 00 00       	call   8011d6 <close_all>
	sys_env_destroy(0);
  800132:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800139:	e8 6c 0b 00 00       	call   800caa <sys_env_destroy>
}
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	53                   	push   %ebx
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80014d:	8b 13                	mov    (%ebx),%edx
  80014f:	8d 42 01             	lea    0x1(%edx),%eax
  800152:	89 03                	mov    %eax,(%ebx)
  800154:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800157:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80015b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800160:	74 09                	je     80016b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800162:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800166:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800169:	c9                   	leave  
  80016a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80016b:	83 ec 08             	sub    $0x8,%esp
  80016e:	68 ff 00 00 00       	push   $0xff
  800173:	8d 43 08             	lea    0x8(%ebx),%eax
  800176:	50                   	push   %eax
  800177:	e8 f1 0a 00 00       	call   800c6d <sys_cputs>
		b->idx = 0;
  80017c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	eb db                	jmp    800162 <putch+0x1f>

00800187 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800190:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800197:	00 00 00 
	b.cnt = 0;
  80019a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a4:	ff 75 0c             	pushl  0xc(%ebp)
  8001a7:	ff 75 08             	pushl  0x8(%ebp)
  8001aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b0:	50                   	push   %eax
  8001b1:	68 43 01 80 00       	push   $0x800143
  8001b6:	e8 4a 01 00 00       	call   800305 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001bb:	83 c4 08             	add    $0x8,%esp
  8001be:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001c4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ca:	50                   	push   %eax
  8001cb:	e8 9d 0a 00 00       	call   800c6d <sys_cputs>

	return b.cnt;
}
  8001d0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001d6:	c9                   	leave  
  8001d7:	c3                   	ret    

008001d8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001de:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001e1:	50                   	push   %eax
  8001e2:	ff 75 08             	pushl  0x8(%ebp)
  8001e5:	e8 9d ff ff ff       	call   800187 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ea:	c9                   	leave  
  8001eb:	c3                   	ret    

008001ec <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	57                   	push   %edi
  8001f0:	56                   	push   %esi
  8001f1:	53                   	push   %ebx
  8001f2:	83 ec 1c             	sub    $0x1c,%esp
  8001f5:	89 c6                	mov    %eax,%esi
  8001f7:	89 d7                	mov    %edx,%edi
  8001f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800202:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800205:	8b 45 10             	mov    0x10(%ebp),%eax
  800208:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80020b:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80020f:	74 2c                	je     80023d <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800211:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800214:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80021b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80021e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800221:	39 c2                	cmp    %eax,%edx
  800223:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800226:	73 43                	jae    80026b <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800228:	83 eb 01             	sub    $0x1,%ebx
  80022b:	85 db                	test   %ebx,%ebx
  80022d:	7e 6c                	jle    80029b <printnum+0xaf>
				putch(padc, putdat);
  80022f:	83 ec 08             	sub    $0x8,%esp
  800232:	57                   	push   %edi
  800233:	ff 75 18             	pushl  0x18(%ebp)
  800236:	ff d6                	call   *%esi
  800238:	83 c4 10             	add    $0x10,%esp
  80023b:	eb eb                	jmp    800228 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	6a 20                	push   $0x20
  800242:	6a 00                	push   $0x0
  800244:	50                   	push   %eax
  800245:	ff 75 e4             	pushl  -0x1c(%ebp)
  800248:	ff 75 e0             	pushl  -0x20(%ebp)
  80024b:	89 fa                	mov    %edi,%edx
  80024d:	89 f0                	mov    %esi,%eax
  80024f:	e8 98 ff ff ff       	call   8001ec <printnum>
		while (--width > 0)
  800254:	83 c4 20             	add    $0x20,%esp
  800257:	83 eb 01             	sub    $0x1,%ebx
  80025a:	85 db                	test   %ebx,%ebx
  80025c:	7e 65                	jle    8002c3 <printnum+0xd7>
			putch(padc, putdat);
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	57                   	push   %edi
  800262:	6a 20                	push   $0x20
  800264:	ff d6                	call   *%esi
  800266:	83 c4 10             	add    $0x10,%esp
  800269:	eb ec                	jmp    800257 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	ff 75 18             	pushl  0x18(%ebp)
  800271:	83 eb 01             	sub    $0x1,%ebx
  800274:	53                   	push   %ebx
  800275:	50                   	push   %eax
  800276:	83 ec 08             	sub    $0x8,%esp
  800279:	ff 75 dc             	pushl  -0x24(%ebp)
  80027c:	ff 75 d8             	pushl  -0x28(%ebp)
  80027f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800282:	ff 75 e0             	pushl  -0x20(%ebp)
  800285:	e8 66 20 00 00       	call   8022f0 <__udivdi3>
  80028a:	83 c4 18             	add    $0x18,%esp
  80028d:	52                   	push   %edx
  80028e:	50                   	push   %eax
  80028f:	89 fa                	mov    %edi,%edx
  800291:	89 f0                	mov    %esi,%eax
  800293:	e8 54 ff ff ff       	call   8001ec <printnum>
  800298:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80029b:	83 ec 08             	sub    $0x8,%esp
  80029e:	57                   	push   %edi
  80029f:	83 ec 04             	sub    $0x4,%esp
  8002a2:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a5:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ae:	e8 4d 21 00 00       	call   802400 <__umoddi3>
  8002b3:	83 c4 14             	add    $0x14,%esp
  8002b6:	0f be 80 a9 25 80 00 	movsbl 0x8025a9(%eax),%eax
  8002bd:	50                   	push   %eax
  8002be:	ff d6                	call   *%esi
  8002c0:	83 c4 10             	add    $0x10,%esp
	}
}
  8002c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c6:	5b                   	pop    %ebx
  8002c7:	5e                   	pop    %esi
  8002c8:	5f                   	pop    %edi
  8002c9:	5d                   	pop    %ebp
  8002ca:	c3                   	ret    

008002cb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002cb:	55                   	push   %ebp
  8002cc:	89 e5                	mov    %esp,%ebp
  8002ce:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d5:	8b 10                	mov    (%eax),%edx
  8002d7:	3b 50 04             	cmp    0x4(%eax),%edx
  8002da:	73 0a                	jae    8002e6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002dc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002df:	89 08                	mov    %ecx,(%eax)
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	88 02                	mov    %al,(%edx)
}
  8002e6:	5d                   	pop    %ebp
  8002e7:	c3                   	ret    

008002e8 <printfmt>:
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ee:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002f1:	50                   	push   %eax
  8002f2:	ff 75 10             	pushl  0x10(%ebp)
  8002f5:	ff 75 0c             	pushl  0xc(%ebp)
  8002f8:	ff 75 08             	pushl  0x8(%ebp)
  8002fb:	e8 05 00 00 00       	call   800305 <vprintfmt>
}
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	c9                   	leave  
  800304:	c3                   	ret    

00800305 <vprintfmt>:
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	57                   	push   %edi
  800309:	56                   	push   %esi
  80030a:	53                   	push   %ebx
  80030b:	83 ec 3c             	sub    $0x3c,%esp
  80030e:	8b 75 08             	mov    0x8(%ebp),%esi
  800311:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800314:	8b 7d 10             	mov    0x10(%ebp),%edi
  800317:	e9 32 04 00 00       	jmp    80074e <vprintfmt+0x449>
		padc = ' ';
  80031c:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800320:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800327:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80032e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800335:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80033c:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800343:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800348:	8d 47 01             	lea    0x1(%edi),%eax
  80034b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034e:	0f b6 17             	movzbl (%edi),%edx
  800351:	8d 42 dd             	lea    -0x23(%edx),%eax
  800354:	3c 55                	cmp    $0x55,%al
  800356:	0f 87 12 05 00 00    	ja     80086e <vprintfmt+0x569>
  80035c:	0f b6 c0             	movzbl %al,%eax
  80035f:	ff 24 85 80 27 80 00 	jmp    *0x802780(,%eax,4)
  800366:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800369:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80036d:	eb d9                	jmp    800348 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80036f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800372:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800376:	eb d0                	jmp    800348 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800378:	0f b6 d2             	movzbl %dl,%edx
  80037b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037e:	b8 00 00 00 00       	mov    $0x0,%eax
  800383:	89 75 08             	mov    %esi,0x8(%ebp)
  800386:	eb 03                	jmp    80038b <vprintfmt+0x86>
  800388:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80038b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800392:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800395:	8d 72 d0             	lea    -0x30(%edx),%esi
  800398:	83 fe 09             	cmp    $0x9,%esi
  80039b:	76 eb                	jbe    800388 <vprintfmt+0x83>
  80039d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8003a3:	eb 14                	jmp    8003b9 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a8:	8b 00                	mov    (%eax),%eax
  8003aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b0:	8d 40 04             	lea    0x4(%eax),%eax
  8003b3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003bd:	79 89                	jns    800348 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003cc:	e9 77 ff ff ff       	jmp    800348 <vprintfmt+0x43>
  8003d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d4:	85 c0                	test   %eax,%eax
  8003d6:	0f 48 c1             	cmovs  %ecx,%eax
  8003d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003df:	e9 64 ff ff ff       	jmp    800348 <vprintfmt+0x43>
  8003e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003ee:	e9 55 ff ff ff       	jmp    800348 <vprintfmt+0x43>
			lflag++;
  8003f3:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003fa:	e9 49 ff ff ff       	jmp    800348 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800402:	8d 78 04             	lea    0x4(%eax),%edi
  800405:	83 ec 08             	sub    $0x8,%esp
  800408:	53                   	push   %ebx
  800409:	ff 30                	pushl  (%eax)
  80040b:	ff d6                	call   *%esi
			break;
  80040d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800410:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800413:	e9 33 03 00 00       	jmp    80074b <vprintfmt+0x446>
			err = va_arg(ap, int);
  800418:	8b 45 14             	mov    0x14(%ebp),%eax
  80041b:	8d 78 04             	lea    0x4(%eax),%edi
  80041e:	8b 00                	mov    (%eax),%eax
  800420:	99                   	cltd   
  800421:	31 d0                	xor    %edx,%eax
  800423:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800425:	83 f8 11             	cmp    $0x11,%eax
  800428:	7f 23                	jg     80044d <vprintfmt+0x148>
  80042a:	8b 14 85 e0 28 80 00 	mov    0x8028e0(,%eax,4),%edx
  800431:	85 d2                	test   %edx,%edx
  800433:	74 18                	je     80044d <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800435:	52                   	push   %edx
  800436:	68 fd 29 80 00       	push   $0x8029fd
  80043b:	53                   	push   %ebx
  80043c:	56                   	push   %esi
  80043d:	e8 a6 fe ff ff       	call   8002e8 <printfmt>
  800442:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800445:	89 7d 14             	mov    %edi,0x14(%ebp)
  800448:	e9 fe 02 00 00       	jmp    80074b <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80044d:	50                   	push   %eax
  80044e:	68 c1 25 80 00       	push   $0x8025c1
  800453:	53                   	push   %ebx
  800454:	56                   	push   %esi
  800455:	e8 8e fe ff ff       	call   8002e8 <printfmt>
  80045a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800460:	e9 e6 02 00 00       	jmp    80074b <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800465:	8b 45 14             	mov    0x14(%ebp),%eax
  800468:	83 c0 04             	add    $0x4,%eax
  80046b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80046e:	8b 45 14             	mov    0x14(%ebp),%eax
  800471:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800473:	85 c9                	test   %ecx,%ecx
  800475:	b8 ba 25 80 00       	mov    $0x8025ba,%eax
  80047a:	0f 45 c1             	cmovne %ecx,%eax
  80047d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800480:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800484:	7e 06                	jle    80048c <vprintfmt+0x187>
  800486:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80048a:	75 0d                	jne    800499 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80048f:	89 c7                	mov    %eax,%edi
  800491:	03 45 e0             	add    -0x20(%ebp),%eax
  800494:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800497:	eb 53                	jmp    8004ec <vprintfmt+0x1e7>
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	ff 75 d8             	pushl  -0x28(%ebp)
  80049f:	50                   	push   %eax
  8004a0:	e8 71 04 00 00       	call   800916 <strnlen>
  8004a5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a8:	29 c1                	sub    %eax,%ecx
  8004aa:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004ad:	83 c4 10             	add    $0x10,%esp
  8004b0:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004b2:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b9:	eb 0f                	jmp    8004ca <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004bb:	83 ec 08             	sub    $0x8,%esp
  8004be:	53                   	push   %ebx
  8004bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c4:	83 ef 01             	sub    $0x1,%edi
  8004c7:	83 c4 10             	add    $0x10,%esp
  8004ca:	85 ff                	test   %edi,%edi
  8004cc:	7f ed                	jg     8004bb <vprintfmt+0x1b6>
  8004ce:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004d1:	85 c9                	test   %ecx,%ecx
  8004d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d8:	0f 49 c1             	cmovns %ecx,%eax
  8004db:	29 c1                	sub    %eax,%ecx
  8004dd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004e0:	eb aa                	jmp    80048c <vprintfmt+0x187>
					putch(ch, putdat);
  8004e2:	83 ec 08             	sub    $0x8,%esp
  8004e5:	53                   	push   %ebx
  8004e6:	52                   	push   %edx
  8004e7:	ff d6                	call   *%esi
  8004e9:	83 c4 10             	add    $0x10,%esp
  8004ec:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ef:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f1:	83 c7 01             	add    $0x1,%edi
  8004f4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004f8:	0f be d0             	movsbl %al,%edx
  8004fb:	85 d2                	test   %edx,%edx
  8004fd:	74 4b                	je     80054a <vprintfmt+0x245>
  8004ff:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800503:	78 06                	js     80050b <vprintfmt+0x206>
  800505:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800509:	78 1e                	js     800529 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80050b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80050f:	74 d1                	je     8004e2 <vprintfmt+0x1dd>
  800511:	0f be c0             	movsbl %al,%eax
  800514:	83 e8 20             	sub    $0x20,%eax
  800517:	83 f8 5e             	cmp    $0x5e,%eax
  80051a:	76 c6                	jbe    8004e2 <vprintfmt+0x1dd>
					putch('?', putdat);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	53                   	push   %ebx
  800520:	6a 3f                	push   $0x3f
  800522:	ff d6                	call   *%esi
  800524:	83 c4 10             	add    $0x10,%esp
  800527:	eb c3                	jmp    8004ec <vprintfmt+0x1e7>
  800529:	89 cf                	mov    %ecx,%edi
  80052b:	eb 0e                	jmp    80053b <vprintfmt+0x236>
				putch(' ', putdat);
  80052d:	83 ec 08             	sub    $0x8,%esp
  800530:	53                   	push   %ebx
  800531:	6a 20                	push   $0x20
  800533:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800535:	83 ef 01             	sub    $0x1,%edi
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	85 ff                	test   %edi,%edi
  80053d:	7f ee                	jg     80052d <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80053f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800542:	89 45 14             	mov    %eax,0x14(%ebp)
  800545:	e9 01 02 00 00       	jmp    80074b <vprintfmt+0x446>
  80054a:	89 cf                	mov    %ecx,%edi
  80054c:	eb ed                	jmp    80053b <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80054e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800551:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800558:	e9 eb fd ff ff       	jmp    800348 <vprintfmt+0x43>
	if (lflag >= 2)
  80055d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800561:	7f 21                	jg     800584 <vprintfmt+0x27f>
	else if (lflag)
  800563:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800567:	74 68                	je     8005d1 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800571:	89 c1                	mov    %eax,%ecx
  800573:	c1 f9 1f             	sar    $0x1f,%ecx
  800576:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8d 40 04             	lea    0x4(%eax),%eax
  80057f:	89 45 14             	mov    %eax,0x14(%ebp)
  800582:	eb 17                	jmp    80059b <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8b 50 04             	mov    0x4(%eax),%edx
  80058a:	8b 00                	mov    (%eax),%eax
  80058c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80058f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8d 40 08             	lea    0x8(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80059b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005a7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005ab:	78 3f                	js     8005ec <vprintfmt+0x2e7>
			base = 10;
  8005ad:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005b2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005b6:	0f 84 71 01 00 00    	je     80072d <vprintfmt+0x428>
				putch('+', putdat);
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	53                   	push   %ebx
  8005c0:	6a 2b                	push   $0x2b
  8005c2:	ff d6                	call   *%esi
  8005c4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005cc:	e9 5c 01 00 00       	jmp    80072d <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005d9:	89 c1                	mov    %eax,%ecx
  8005db:	c1 f9 1f             	sar    $0x1f,%ecx
  8005de:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8d 40 04             	lea    0x4(%eax),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ea:	eb af                	jmp    80059b <vprintfmt+0x296>
				putch('-', putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	53                   	push   %ebx
  8005f0:	6a 2d                	push   $0x2d
  8005f2:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005fa:	f7 d8                	neg    %eax
  8005fc:	83 d2 00             	adc    $0x0,%edx
  8005ff:	f7 da                	neg    %edx
  800601:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800604:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800607:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80060a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060f:	e9 19 01 00 00       	jmp    80072d <vprintfmt+0x428>
	if (lflag >= 2)
  800614:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800618:	7f 29                	jg     800643 <vprintfmt+0x33e>
	else if (lflag)
  80061a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80061e:	74 44                	je     800664 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800620:	8b 45 14             	mov    0x14(%ebp),%eax
  800623:	8b 00                	mov    (%eax),%eax
  800625:	ba 00 00 00 00       	mov    $0x0,%edx
  80062a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	8d 40 04             	lea    0x4(%eax),%eax
  800636:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800639:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063e:	e9 ea 00 00 00       	jmp    80072d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8b 50 04             	mov    0x4(%eax),%edx
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8d 40 08             	lea    0x8(%eax),%eax
  800657:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065f:	e9 c9 00 00 00       	jmp    80072d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8b 00                	mov    (%eax),%eax
  800669:	ba 00 00 00 00       	mov    $0x0,%edx
  80066e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800671:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8d 40 04             	lea    0x4(%eax),%eax
  80067a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800682:	e9 a6 00 00 00       	jmp    80072d <vprintfmt+0x428>
			putch('0', putdat);
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	53                   	push   %ebx
  80068b:	6a 30                	push   $0x30
  80068d:	ff d6                	call   *%esi
	if (lflag >= 2)
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800696:	7f 26                	jg     8006be <vprintfmt+0x3b9>
	else if (lflag)
  800698:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80069c:	74 3e                	je     8006dc <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8d 40 04             	lea    0x4(%eax),%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b7:	b8 08 00 00 00       	mov    $0x8,%eax
  8006bc:	eb 6f                	jmp    80072d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8b 50 04             	mov    0x4(%eax),%edx
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8d 40 08             	lea    0x8(%eax),%eax
  8006d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d5:	b8 08 00 00 00       	mov    $0x8,%eax
  8006da:	eb 51                	jmp    80072d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8d 40 04             	lea    0x4(%eax),%eax
  8006f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f5:	b8 08 00 00 00       	mov    $0x8,%eax
  8006fa:	eb 31                	jmp    80072d <vprintfmt+0x428>
			putch('0', putdat);
  8006fc:	83 ec 08             	sub    $0x8,%esp
  8006ff:	53                   	push   %ebx
  800700:	6a 30                	push   $0x30
  800702:	ff d6                	call   *%esi
			putch('x', putdat);
  800704:	83 c4 08             	add    $0x8,%esp
  800707:	53                   	push   %ebx
  800708:	6a 78                	push   $0x78
  80070a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	ba 00 00 00 00       	mov    $0x0,%edx
  800716:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800719:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80071c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	8d 40 04             	lea    0x4(%eax),%eax
  800725:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800728:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80072d:	83 ec 0c             	sub    $0xc,%esp
  800730:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800734:	52                   	push   %edx
  800735:	ff 75 e0             	pushl  -0x20(%ebp)
  800738:	50                   	push   %eax
  800739:	ff 75 dc             	pushl  -0x24(%ebp)
  80073c:	ff 75 d8             	pushl  -0x28(%ebp)
  80073f:	89 da                	mov    %ebx,%edx
  800741:	89 f0                	mov    %esi,%eax
  800743:	e8 a4 fa ff ff       	call   8001ec <printnum>
			break;
  800748:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80074b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074e:	83 c7 01             	add    $0x1,%edi
  800751:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800755:	83 f8 25             	cmp    $0x25,%eax
  800758:	0f 84 be fb ff ff    	je     80031c <vprintfmt+0x17>
			if (ch == '\0')
  80075e:	85 c0                	test   %eax,%eax
  800760:	0f 84 28 01 00 00    	je     80088e <vprintfmt+0x589>
			putch(ch, putdat);
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	53                   	push   %ebx
  80076a:	50                   	push   %eax
  80076b:	ff d6                	call   *%esi
  80076d:	83 c4 10             	add    $0x10,%esp
  800770:	eb dc                	jmp    80074e <vprintfmt+0x449>
	if (lflag >= 2)
  800772:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800776:	7f 26                	jg     80079e <vprintfmt+0x499>
	else if (lflag)
  800778:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80077c:	74 41                	je     8007bf <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	ba 00 00 00 00       	mov    $0x0,%edx
  800788:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078e:	8b 45 14             	mov    0x14(%ebp),%eax
  800791:	8d 40 04             	lea    0x4(%eax),%eax
  800794:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800797:	b8 10 00 00 00       	mov    $0x10,%eax
  80079c:	eb 8f                	jmp    80072d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8b 50 04             	mov    0x4(%eax),%edx
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8007af:	8d 40 08             	lea    0x8(%eax),%eax
  8007b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b5:	b8 10 00 00 00       	mov    $0x10,%eax
  8007ba:	e9 6e ff ff ff       	jmp    80072d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8d 40 04             	lea    0x4(%eax),%eax
  8007d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d8:	b8 10 00 00 00       	mov    $0x10,%eax
  8007dd:	e9 4b ff ff ff       	jmp    80072d <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	83 c0 04             	add    $0x4,%eax
  8007e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	85 c0                	test   %eax,%eax
  8007f2:	74 14                	je     800808 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007f4:	8b 13                	mov    (%ebx),%edx
  8007f6:	83 fa 7f             	cmp    $0x7f,%edx
  8007f9:	7f 37                	jg     800832 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007fb:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800800:	89 45 14             	mov    %eax,0x14(%ebp)
  800803:	e9 43 ff ff ff       	jmp    80074b <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800808:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080d:	bf dd 26 80 00       	mov    $0x8026dd,%edi
							putch(ch, putdat);
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	53                   	push   %ebx
  800816:	50                   	push   %eax
  800817:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800819:	83 c7 01             	add    $0x1,%edi
  80081c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800820:	83 c4 10             	add    $0x10,%esp
  800823:	85 c0                	test   %eax,%eax
  800825:	75 eb                	jne    800812 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800827:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80082a:	89 45 14             	mov    %eax,0x14(%ebp)
  80082d:	e9 19 ff ff ff       	jmp    80074b <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800832:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800834:	b8 0a 00 00 00       	mov    $0xa,%eax
  800839:	bf 15 27 80 00       	mov    $0x802715,%edi
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
  800851:	75 eb                	jne    80083e <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800853:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
  800859:	e9 ed fe ff ff       	jmp    80074b <vprintfmt+0x446>
			putch(ch, putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	53                   	push   %ebx
  800862:	6a 25                	push   $0x25
  800864:	ff d6                	call   *%esi
			break;
  800866:	83 c4 10             	add    $0x10,%esp
  800869:	e9 dd fe ff ff       	jmp    80074b <vprintfmt+0x446>
			putch('%', putdat);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	53                   	push   %ebx
  800872:	6a 25                	push   $0x25
  800874:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800876:	83 c4 10             	add    $0x10,%esp
  800879:	89 f8                	mov    %edi,%eax
  80087b:	eb 03                	jmp    800880 <vprintfmt+0x57b>
  80087d:	83 e8 01             	sub    $0x1,%eax
  800880:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800884:	75 f7                	jne    80087d <vprintfmt+0x578>
  800886:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800889:	e9 bd fe ff ff       	jmp    80074b <vprintfmt+0x446>
}
  80088e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800891:	5b                   	pop    %ebx
  800892:	5e                   	pop    %esi
  800893:	5f                   	pop    %edi
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	83 ec 18             	sub    $0x18,%esp
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008a5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008a9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008b3:	85 c0                	test   %eax,%eax
  8008b5:	74 26                	je     8008dd <vsnprintf+0x47>
  8008b7:	85 d2                	test   %edx,%edx
  8008b9:	7e 22                	jle    8008dd <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008bb:	ff 75 14             	pushl  0x14(%ebp)
  8008be:	ff 75 10             	pushl  0x10(%ebp)
  8008c1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c4:	50                   	push   %eax
  8008c5:	68 cb 02 80 00       	push   $0x8002cb
  8008ca:	e8 36 fa ff ff       	call   800305 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d8:	83 c4 10             	add    $0x10,%esp
}
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    
		return -E_INVAL;
  8008dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008e2:	eb f7                	jmp    8008db <vsnprintf+0x45>

008008e4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ea:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008ed:	50                   	push   %eax
  8008ee:	ff 75 10             	pushl  0x10(%ebp)
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	ff 75 08             	pushl  0x8(%ebp)
  8008f7:	e8 9a ff ff ff       	call   800896 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
  800909:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80090d:	74 05                	je     800914 <strlen+0x16>
		n++;
  80090f:	83 c0 01             	add    $0x1,%eax
  800912:	eb f5                	jmp    800909 <strlen+0xb>
	return n;
}
  800914:	5d                   	pop    %ebp
  800915:	c3                   	ret    

00800916 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091f:	ba 00 00 00 00       	mov    $0x0,%edx
  800924:	39 c2                	cmp    %eax,%edx
  800926:	74 0d                	je     800935 <strnlen+0x1f>
  800928:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80092c:	74 05                	je     800933 <strnlen+0x1d>
		n++;
  80092e:	83 c2 01             	add    $0x1,%edx
  800931:	eb f1                	jmp    800924 <strnlen+0xe>
  800933:	89 d0                	mov    %edx,%eax
	return n;
}
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	53                   	push   %ebx
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800941:	ba 00 00 00 00       	mov    $0x0,%edx
  800946:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80094a:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80094d:	83 c2 01             	add    $0x1,%edx
  800950:	84 c9                	test   %cl,%cl
  800952:	75 f2                	jne    800946 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800954:	5b                   	pop    %ebx
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	53                   	push   %ebx
  80095b:	83 ec 10             	sub    $0x10,%esp
  80095e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800961:	53                   	push   %ebx
  800962:	e8 97 ff ff ff       	call   8008fe <strlen>
  800967:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	01 d8                	add    %ebx,%eax
  80096f:	50                   	push   %eax
  800970:	e8 c2 ff ff ff       	call   800937 <strcpy>
	return dst;
}
  800975:	89 d8                	mov    %ebx,%eax
  800977:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097a:	c9                   	leave  
  80097b:	c3                   	ret    

0080097c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	56                   	push   %esi
  800980:	53                   	push   %ebx
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800987:	89 c6                	mov    %eax,%esi
  800989:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80098c:	89 c2                	mov    %eax,%edx
  80098e:	39 f2                	cmp    %esi,%edx
  800990:	74 11                	je     8009a3 <strncpy+0x27>
		*dst++ = *src;
  800992:	83 c2 01             	add    $0x1,%edx
  800995:	0f b6 19             	movzbl (%ecx),%ebx
  800998:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80099b:	80 fb 01             	cmp    $0x1,%bl
  80099e:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009a1:	eb eb                	jmp    80098e <strncpy+0x12>
	}
	return ret;
}
  8009a3:	5b                   	pop    %ebx
  8009a4:	5e                   	pop    %esi
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	56                   	push   %esi
  8009ab:	53                   	push   %ebx
  8009ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8009af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b2:	8b 55 10             	mov    0x10(%ebp),%edx
  8009b5:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009b7:	85 d2                	test   %edx,%edx
  8009b9:	74 21                	je     8009dc <strlcpy+0x35>
  8009bb:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009bf:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009c1:	39 c2                	cmp    %eax,%edx
  8009c3:	74 14                	je     8009d9 <strlcpy+0x32>
  8009c5:	0f b6 19             	movzbl (%ecx),%ebx
  8009c8:	84 db                	test   %bl,%bl
  8009ca:	74 0b                	je     8009d7 <strlcpy+0x30>
			*dst++ = *src++;
  8009cc:	83 c1 01             	add    $0x1,%ecx
  8009cf:	83 c2 01             	add    $0x1,%edx
  8009d2:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009d5:	eb ea                	jmp    8009c1 <strlcpy+0x1a>
  8009d7:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009d9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009dc:	29 f0                	sub    %esi,%eax
}
  8009de:	5b                   	pop    %ebx
  8009df:	5e                   	pop    %esi
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    

008009e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009eb:	0f b6 01             	movzbl (%ecx),%eax
  8009ee:	84 c0                	test   %al,%al
  8009f0:	74 0c                	je     8009fe <strcmp+0x1c>
  8009f2:	3a 02                	cmp    (%edx),%al
  8009f4:	75 08                	jne    8009fe <strcmp+0x1c>
		p++, q++;
  8009f6:	83 c1 01             	add    $0x1,%ecx
  8009f9:	83 c2 01             	add    $0x1,%edx
  8009fc:	eb ed                	jmp    8009eb <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009fe:	0f b6 c0             	movzbl %al,%eax
  800a01:	0f b6 12             	movzbl (%edx),%edx
  800a04:	29 d0                	sub    %edx,%eax
}
  800a06:	5d                   	pop    %ebp
  800a07:	c3                   	ret    

00800a08 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	53                   	push   %ebx
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a12:	89 c3                	mov    %eax,%ebx
  800a14:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a17:	eb 06                	jmp    800a1f <strncmp+0x17>
		n--, p++, q++;
  800a19:	83 c0 01             	add    $0x1,%eax
  800a1c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a1f:	39 d8                	cmp    %ebx,%eax
  800a21:	74 16                	je     800a39 <strncmp+0x31>
  800a23:	0f b6 08             	movzbl (%eax),%ecx
  800a26:	84 c9                	test   %cl,%cl
  800a28:	74 04                	je     800a2e <strncmp+0x26>
  800a2a:	3a 0a                	cmp    (%edx),%cl
  800a2c:	74 eb                	je     800a19 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2e:	0f b6 00             	movzbl (%eax),%eax
  800a31:	0f b6 12             	movzbl (%edx),%edx
  800a34:	29 d0                	sub    %edx,%eax
}
  800a36:	5b                   	pop    %ebx
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    
		return 0;
  800a39:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3e:	eb f6                	jmp    800a36 <strncmp+0x2e>

00800a40 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a4a:	0f b6 10             	movzbl (%eax),%edx
  800a4d:	84 d2                	test   %dl,%dl
  800a4f:	74 09                	je     800a5a <strchr+0x1a>
		if (*s == c)
  800a51:	38 ca                	cmp    %cl,%dl
  800a53:	74 0a                	je     800a5f <strchr+0x1f>
	for (; *s; s++)
  800a55:	83 c0 01             	add    $0x1,%eax
  800a58:	eb f0                	jmp    800a4a <strchr+0xa>
			return (char *) s;
	return 0;
  800a5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a5f:	5d                   	pop    %ebp
  800a60:	c3                   	ret    

00800a61 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a6b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a6e:	38 ca                	cmp    %cl,%dl
  800a70:	74 09                	je     800a7b <strfind+0x1a>
  800a72:	84 d2                	test   %dl,%dl
  800a74:	74 05                	je     800a7b <strfind+0x1a>
	for (; *s; s++)
  800a76:	83 c0 01             	add    $0x1,%eax
  800a79:	eb f0                	jmp    800a6b <strfind+0xa>
			break;
	return (char *) s;
}
  800a7b:	5d                   	pop    %ebp
  800a7c:	c3                   	ret    

00800a7d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	57                   	push   %edi
  800a81:	56                   	push   %esi
  800a82:	53                   	push   %ebx
  800a83:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a86:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a89:	85 c9                	test   %ecx,%ecx
  800a8b:	74 31                	je     800abe <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a8d:	89 f8                	mov    %edi,%eax
  800a8f:	09 c8                	or     %ecx,%eax
  800a91:	a8 03                	test   $0x3,%al
  800a93:	75 23                	jne    800ab8 <memset+0x3b>
		c &= 0xFF;
  800a95:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a99:	89 d3                	mov    %edx,%ebx
  800a9b:	c1 e3 08             	shl    $0x8,%ebx
  800a9e:	89 d0                	mov    %edx,%eax
  800aa0:	c1 e0 18             	shl    $0x18,%eax
  800aa3:	89 d6                	mov    %edx,%esi
  800aa5:	c1 e6 10             	shl    $0x10,%esi
  800aa8:	09 f0                	or     %esi,%eax
  800aaa:	09 c2                	or     %eax,%edx
  800aac:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aae:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab1:	89 d0                	mov    %edx,%eax
  800ab3:	fc                   	cld    
  800ab4:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab6:	eb 06                	jmp    800abe <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abb:	fc                   	cld    
  800abc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800abe:	89 f8                	mov    %edi,%eax
  800ac0:	5b                   	pop    %ebx
  800ac1:	5e                   	pop    %esi
  800ac2:	5f                   	pop    %edi
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    

00800ac5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	57                   	push   %edi
  800ac9:	56                   	push   %esi
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ad3:	39 c6                	cmp    %eax,%esi
  800ad5:	73 32                	jae    800b09 <memmove+0x44>
  800ad7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ada:	39 c2                	cmp    %eax,%edx
  800adc:	76 2b                	jbe    800b09 <memmove+0x44>
		s += n;
		d += n;
  800ade:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae1:	89 fe                	mov    %edi,%esi
  800ae3:	09 ce                	or     %ecx,%esi
  800ae5:	09 d6                	or     %edx,%esi
  800ae7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aed:	75 0e                	jne    800afd <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aef:	83 ef 04             	sub    $0x4,%edi
  800af2:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800af8:	fd                   	std    
  800af9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800afb:	eb 09                	jmp    800b06 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800afd:	83 ef 01             	sub    $0x1,%edi
  800b00:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b03:	fd                   	std    
  800b04:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b06:	fc                   	cld    
  800b07:	eb 1a                	jmp    800b23 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b09:	89 c2                	mov    %eax,%edx
  800b0b:	09 ca                	or     %ecx,%edx
  800b0d:	09 f2                	or     %esi,%edx
  800b0f:	f6 c2 03             	test   $0x3,%dl
  800b12:	75 0a                	jne    800b1e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b14:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b17:	89 c7                	mov    %eax,%edi
  800b19:	fc                   	cld    
  800b1a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1c:	eb 05                	jmp    800b23 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b1e:	89 c7                	mov    %eax,%edi
  800b20:	fc                   	cld    
  800b21:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b23:	5e                   	pop    %esi
  800b24:	5f                   	pop    %edi
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b2d:	ff 75 10             	pushl  0x10(%ebp)
  800b30:	ff 75 0c             	pushl  0xc(%ebp)
  800b33:	ff 75 08             	pushl  0x8(%ebp)
  800b36:	e8 8a ff ff ff       	call   800ac5 <memmove>
}
  800b3b:	c9                   	leave  
  800b3c:	c3                   	ret    

00800b3d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	56                   	push   %esi
  800b41:	53                   	push   %ebx
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b48:	89 c6                	mov    %eax,%esi
  800b4a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b4d:	39 f0                	cmp    %esi,%eax
  800b4f:	74 1c                	je     800b6d <memcmp+0x30>
		if (*s1 != *s2)
  800b51:	0f b6 08             	movzbl (%eax),%ecx
  800b54:	0f b6 1a             	movzbl (%edx),%ebx
  800b57:	38 d9                	cmp    %bl,%cl
  800b59:	75 08                	jne    800b63 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b5b:	83 c0 01             	add    $0x1,%eax
  800b5e:	83 c2 01             	add    $0x1,%edx
  800b61:	eb ea                	jmp    800b4d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b63:	0f b6 c1             	movzbl %cl,%eax
  800b66:	0f b6 db             	movzbl %bl,%ebx
  800b69:	29 d8                	sub    %ebx,%eax
  800b6b:	eb 05                	jmp    800b72 <memcmp+0x35>
	}

	return 0;
  800b6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b72:	5b                   	pop    %ebx
  800b73:	5e                   	pop    %esi
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b7f:	89 c2                	mov    %eax,%edx
  800b81:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b84:	39 d0                	cmp    %edx,%eax
  800b86:	73 09                	jae    800b91 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b88:	38 08                	cmp    %cl,(%eax)
  800b8a:	74 05                	je     800b91 <memfind+0x1b>
	for (; s < ends; s++)
  800b8c:	83 c0 01             	add    $0x1,%eax
  800b8f:	eb f3                	jmp    800b84 <memfind+0xe>
			break;
	return (void *) s;
}
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    

00800b93 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	57                   	push   %edi
  800b97:	56                   	push   %esi
  800b98:	53                   	push   %ebx
  800b99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9f:	eb 03                	jmp    800ba4 <strtol+0x11>
		s++;
  800ba1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ba4:	0f b6 01             	movzbl (%ecx),%eax
  800ba7:	3c 20                	cmp    $0x20,%al
  800ba9:	74 f6                	je     800ba1 <strtol+0xe>
  800bab:	3c 09                	cmp    $0x9,%al
  800bad:	74 f2                	je     800ba1 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800baf:	3c 2b                	cmp    $0x2b,%al
  800bb1:	74 2a                	je     800bdd <strtol+0x4a>
	int neg = 0;
  800bb3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bb8:	3c 2d                	cmp    $0x2d,%al
  800bba:	74 2b                	je     800be7 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bbc:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bc2:	75 0f                	jne    800bd3 <strtol+0x40>
  800bc4:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc7:	74 28                	je     800bf1 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc9:	85 db                	test   %ebx,%ebx
  800bcb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bd0:	0f 44 d8             	cmove  %eax,%ebx
  800bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bdb:	eb 50                	jmp    800c2d <strtol+0x9a>
		s++;
  800bdd:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800be0:	bf 00 00 00 00       	mov    $0x0,%edi
  800be5:	eb d5                	jmp    800bbc <strtol+0x29>
		s++, neg = 1;
  800be7:	83 c1 01             	add    $0x1,%ecx
  800bea:	bf 01 00 00 00       	mov    $0x1,%edi
  800bef:	eb cb                	jmp    800bbc <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bf5:	74 0e                	je     800c05 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bf7:	85 db                	test   %ebx,%ebx
  800bf9:	75 d8                	jne    800bd3 <strtol+0x40>
		s++, base = 8;
  800bfb:	83 c1 01             	add    $0x1,%ecx
  800bfe:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c03:	eb ce                	jmp    800bd3 <strtol+0x40>
		s += 2, base = 16;
  800c05:	83 c1 02             	add    $0x2,%ecx
  800c08:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c0d:	eb c4                	jmp    800bd3 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c0f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c12:	89 f3                	mov    %esi,%ebx
  800c14:	80 fb 19             	cmp    $0x19,%bl
  800c17:	77 29                	ja     800c42 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c19:	0f be d2             	movsbl %dl,%edx
  800c1c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c1f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c22:	7d 30                	jge    800c54 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c24:	83 c1 01             	add    $0x1,%ecx
  800c27:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c2b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c2d:	0f b6 11             	movzbl (%ecx),%edx
  800c30:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c33:	89 f3                	mov    %esi,%ebx
  800c35:	80 fb 09             	cmp    $0x9,%bl
  800c38:	77 d5                	ja     800c0f <strtol+0x7c>
			dig = *s - '0';
  800c3a:	0f be d2             	movsbl %dl,%edx
  800c3d:	83 ea 30             	sub    $0x30,%edx
  800c40:	eb dd                	jmp    800c1f <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c42:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c45:	89 f3                	mov    %esi,%ebx
  800c47:	80 fb 19             	cmp    $0x19,%bl
  800c4a:	77 08                	ja     800c54 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c4c:	0f be d2             	movsbl %dl,%edx
  800c4f:	83 ea 37             	sub    $0x37,%edx
  800c52:	eb cb                	jmp    800c1f <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c54:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c58:	74 05                	je     800c5f <strtol+0xcc>
		*endptr = (char *) s;
  800c5a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c5f:	89 c2                	mov    %eax,%edx
  800c61:	f7 da                	neg    %edx
  800c63:	85 ff                	test   %edi,%edi
  800c65:	0f 45 c2             	cmovne %edx,%eax
}
  800c68:	5b                   	pop    %ebx
  800c69:	5e                   	pop    %esi
  800c6a:	5f                   	pop    %edi
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	57                   	push   %edi
  800c71:	56                   	push   %esi
  800c72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c73:	b8 00 00 00 00       	mov    $0x0,%eax
  800c78:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7e:	89 c3                	mov    %eax,%ebx
  800c80:	89 c7                	mov    %eax,%edi
  800c82:	89 c6                	mov    %eax,%esi
  800c84:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c86:	5b                   	pop    %ebx
  800c87:	5e                   	pop    %esi
  800c88:	5f                   	pop    %edi
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    

00800c8b <sys_cgetc>:

int
sys_cgetc(void)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	57                   	push   %edi
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c91:	ba 00 00 00 00       	mov    $0x0,%edx
  800c96:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9b:	89 d1                	mov    %edx,%ecx
  800c9d:	89 d3                	mov    %edx,%ebx
  800c9f:	89 d7                	mov    %edx,%edi
  800ca1:	89 d6                	mov    %edx,%esi
  800ca3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca5:	5b                   	pop    %ebx
  800ca6:	5e                   	pop    %esi
  800ca7:	5f                   	pop    %edi
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    

00800caa <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	57                   	push   %edi
  800cae:	56                   	push   %esi
  800caf:	53                   	push   %ebx
  800cb0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc0:	89 cb                	mov    %ecx,%ebx
  800cc2:	89 cf                	mov    %ecx,%edi
  800cc4:	89 ce                	mov    %ecx,%esi
  800cc6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc8:	85 c0                	test   %eax,%eax
  800cca:	7f 08                	jg     800cd4 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ccc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5f                   	pop    %edi
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd4:	83 ec 0c             	sub    $0xc,%esp
  800cd7:	50                   	push   %eax
  800cd8:	6a 03                	push   $0x3
  800cda:	68 28 29 80 00       	push   $0x802928
  800cdf:	6a 43                	push   $0x43
  800ce1:	68 45 29 80 00       	push   $0x802945
  800ce6:	e8 69 14 00 00       	call   802154 <_panic>

00800ceb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	57                   	push   %edi
  800cef:	56                   	push   %esi
  800cf0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf6:	b8 02 00 00 00       	mov    $0x2,%eax
  800cfb:	89 d1                	mov    %edx,%ecx
  800cfd:	89 d3                	mov    %edx,%ebx
  800cff:	89 d7                	mov    %edx,%edi
  800d01:	89 d6                	mov    %edx,%esi
  800d03:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d05:	5b                   	pop    %ebx
  800d06:	5e                   	pop    %esi
  800d07:	5f                   	pop    %edi
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <sys_yield>:

void
sys_yield(void)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	57                   	push   %edi
  800d0e:	56                   	push   %esi
  800d0f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d10:	ba 00 00 00 00       	mov    $0x0,%edx
  800d15:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d1a:	89 d1                	mov    %edx,%ecx
  800d1c:	89 d3                	mov    %edx,%ebx
  800d1e:	89 d7                	mov    %edx,%edi
  800d20:	89 d6                	mov    %edx,%esi
  800d22:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	57                   	push   %edi
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
  800d2f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d32:	be 00 00 00 00       	mov    $0x0,%esi
  800d37:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3d:	b8 04 00 00 00       	mov    $0x4,%eax
  800d42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d45:	89 f7                	mov    %esi,%edi
  800d47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d49:	85 c0                	test   %eax,%eax
  800d4b:	7f 08                	jg     800d55 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d55:	83 ec 0c             	sub    $0xc,%esp
  800d58:	50                   	push   %eax
  800d59:	6a 04                	push   $0x4
  800d5b:	68 28 29 80 00       	push   $0x802928
  800d60:	6a 43                	push   $0x43
  800d62:	68 45 29 80 00       	push   $0x802945
  800d67:	e8 e8 13 00 00       	call   802154 <_panic>

00800d6c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	57                   	push   %edi
  800d70:	56                   	push   %esi
  800d71:	53                   	push   %ebx
  800d72:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d75:	8b 55 08             	mov    0x8(%ebp),%edx
  800d78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7b:	b8 05 00 00 00       	mov    $0x5,%eax
  800d80:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d83:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d86:	8b 75 18             	mov    0x18(%ebp),%esi
  800d89:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8b:	85 c0                	test   %eax,%eax
  800d8d:	7f 08                	jg     800d97 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d92:	5b                   	pop    %ebx
  800d93:	5e                   	pop    %esi
  800d94:	5f                   	pop    %edi
  800d95:	5d                   	pop    %ebp
  800d96:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d97:	83 ec 0c             	sub    $0xc,%esp
  800d9a:	50                   	push   %eax
  800d9b:	6a 05                	push   $0x5
  800d9d:	68 28 29 80 00       	push   $0x802928
  800da2:	6a 43                	push   $0x43
  800da4:	68 45 29 80 00       	push   $0x802945
  800da9:	e8 a6 13 00 00       	call   802154 <_panic>

00800dae <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	57                   	push   %edi
  800db2:	56                   	push   %esi
  800db3:	53                   	push   %ebx
  800db4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc2:	b8 06 00 00 00       	mov    $0x6,%eax
  800dc7:	89 df                	mov    %ebx,%edi
  800dc9:	89 de                	mov    %ebx,%esi
  800dcb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcd:	85 c0                	test   %eax,%eax
  800dcf:	7f 08                	jg     800dd9 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd4:	5b                   	pop    %ebx
  800dd5:	5e                   	pop    %esi
  800dd6:	5f                   	pop    %edi
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd9:	83 ec 0c             	sub    $0xc,%esp
  800ddc:	50                   	push   %eax
  800ddd:	6a 06                	push   $0x6
  800ddf:	68 28 29 80 00       	push   $0x802928
  800de4:	6a 43                	push   $0x43
  800de6:	68 45 29 80 00       	push   $0x802945
  800deb:	e8 64 13 00 00       	call   802154 <_panic>

00800df0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	57                   	push   %edi
  800df4:	56                   	push   %esi
  800df5:	53                   	push   %ebx
  800df6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800e01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e04:	b8 08 00 00 00       	mov    $0x8,%eax
  800e09:	89 df                	mov    %ebx,%edi
  800e0b:	89 de                	mov    %ebx,%esi
  800e0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0f:	85 c0                	test   %eax,%eax
  800e11:	7f 08                	jg     800e1b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e16:	5b                   	pop    %ebx
  800e17:	5e                   	pop    %esi
  800e18:	5f                   	pop    %edi
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1b:	83 ec 0c             	sub    $0xc,%esp
  800e1e:	50                   	push   %eax
  800e1f:	6a 08                	push   $0x8
  800e21:	68 28 29 80 00       	push   $0x802928
  800e26:	6a 43                	push   $0x43
  800e28:	68 45 29 80 00       	push   $0x802945
  800e2d:	e8 22 13 00 00       	call   802154 <_panic>

00800e32 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	57                   	push   %edi
  800e36:	56                   	push   %esi
  800e37:	53                   	push   %ebx
  800e38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e40:	8b 55 08             	mov    0x8(%ebp),%edx
  800e43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e46:	b8 09 00 00 00       	mov    $0x9,%eax
  800e4b:	89 df                	mov    %ebx,%edi
  800e4d:	89 de                	mov    %ebx,%esi
  800e4f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e51:	85 c0                	test   %eax,%eax
  800e53:	7f 08                	jg     800e5d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e58:	5b                   	pop    %ebx
  800e59:	5e                   	pop    %esi
  800e5a:	5f                   	pop    %edi
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5d:	83 ec 0c             	sub    $0xc,%esp
  800e60:	50                   	push   %eax
  800e61:	6a 09                	push   $0x9
  800e63:	68 28 29 80 00       	push   $0x802928
  800e68:	6a 43                	push   $0x43
  800e6a:	68 45 29 80 00       	push   $0x802945
  800e6f:	e8 e0 12 00 00       	call   802154 <_panic>

00800e74 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	57                   	push   %edi
  800e78:	56                   	push   %esi
  800e79:	53                   	push   %ebx
  800e7a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e82:	8b 55 08             	mov    0x8(%ebp),%edx
  800e85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e88:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e8d:	89 df                	mov    %ebx,%edi
  800e8f:	89 de                	mov    %ebx,%esi
  800e91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	7f 08                	jg     800e9f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9f:	83 ec 0c             	sub    $0xc,%esp
  800ea2:	50                   	push   %eax
  800ea3:	6a 0a                	push   $0xa
  800ea5:	68 28 29 80 00       	push   $0x802928
  800eaa:	6a 43                	push   $0x43
  800eac:	68 45 29 80 00       	push   $0x802945
  800eb1:	e8 9e 12 00 00       	call   802154 <_panic>

00800eb6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	57                   	push   %edi
  800eba:	56                   	push   %esi
  800ebb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec2:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ec7:	be 00 00 00 00       	mov    $0x0,%esi
  800ecc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ecf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed2:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed4:	5b                   	pop    %ebx
  800ed5:	5e                   	pop    %esi
  800ed6:	5f                   	pop    %edi
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    

00800ed9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	57                   	push   %edi
  800edd:	56                   	push   %esi
  800ede:	53                   	push   %ebx
  800edf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eea:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eef:	89 cb                	mov    %ecx,%ebx
  800ef1:	89 cf                	mov    %ecx,%edi
  800ef3:	89 ce                	mov    %ecx,%esi
  800ef5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef7:	85 c0                	test   %eax,%eax
  800ef9:	7f 08                	jg     800f03 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f03:	83 ec 0c             	sub    $0xc,%esp
  800f06:	50                   	push   %eax
  800f07:	6a 0d                	push   $0xd
  800f09:	68 28 29 80 00       	push   $0x802928
  800f0e:	6a 43                	push   $0x43
  800f10:	68 45 29 80 00       	push   $0x802945
  800f15:	e8 3a 12 00 00       	call   802154 <_panic>

00800f1a <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	57                   	push   %edi
  800f1e:	56                   	push   %esi
  800f1f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f20:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f25:	8b 55 08             	mov    0x8(%ebp),%edx
  800f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2b:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f30:	89 df                	mov    %ebx,%edi
  800f32:	89 de                	mov    %ebx,%esi
  800f34:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f36:	5b                   	pop    %ebx
  800f37:	5e                   	pop    %esi
  800f38:	5f                   	pop    %edi
  800f39:	5d                   	pop    %ebp
  800f3a:	c3                   	ret    

00800f3b <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	57                   	push   %edi
  800f3f:	56                   	push   %esi
  800f40:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f41:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f46:	8b 55 08             	mov    0x8(%ebp),%edx
  800f49:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f4e:	89 cb                	mov    %ecx,%ebx
  800f50:	89 cf                	mov    %ecx,%edi
  800f52:	89 ce                	mov    %ecx,%esi
  800f54:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5f                   	pop    %edi
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	57                   	push   %edi
  800f5f:	56                   	push   %esi
  800f60:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f61:	ba 00 00 00 00       	mov    $0x0,%edx
  800f66:	b8 10 00 00 00       	mov    $0x10,%eax
  800f6b:	89 d1                	mov    %edx,%ecx
  800f6d:	89 d3                	mov    %edx,%ebx
  800f6f:	89 d7                	mov    %edx,%edi
  800f71:	89 d6                	mov    %edx,%esi
  800f73:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f75:	5b                   	pop    %ebx
  800f76:	5e                   	pop    %esi
  800f77:	5f                   	pop    %edi
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    

00800f7a <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	57                   	push   %edi
  800f7e:	56                   	push   %esi
  800f7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f80:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f85:	8b 55 08             	mov    0x8(%ebp),%edx
  800f88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8b:	b8 11 00 00 00       	mov    $0x11,%eax
  800f90:	89 df                	mov    %ebx,%edi
  800f92:	89 de                	mov    %ebx,%esi
  800f94:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f96:	5b                   	pop    %ebx
  800f97:	5e                   	pop    %esi
  800f98:	5f                   	pop    %edi
  800f99:	5d                   	pop    %ebp
  800f9a:	c3                   	ret    

00800f9b <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	57                   	push   %edi
  800f9f:	56                   	push   %esi
  800fa0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fac:	b8 12 00 00 00       	mov    $0x12,%eax
  800fb1:	89 df                	mov    %ebx,%edi
  800fb3:	89 de                	mov    %ebx,%esi
  800fb5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fb7:	5b                   	pop    %ebx
  800fb8:	5e                   	pop    %esi
  800fb9:	5f                   	pop    %edi
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    

00800fbc <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	57                   	push   %edi
  800fc0:	56                   	push   %esi
  800fc1:	53                   	push   %ebx
  800fc2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd0:	b8 13 00 00 00       	mov    $0x13,%eax
  800fd5:	89 df                	mov    %ebx,%edi
  800fd7:	89 de                	mov    %ebx,%esi
  800fd9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fdb:	85 c0                	test   %eax,%eax
  800fdd:	7f 08                	jg     800fe7 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe2:	5b                   	pop    %ebx
  800fe3:	5e                   	pop    %esi
  800fe4:	5f                   	pop    %edi
  800fe5:	5d                   	pop    %ebp
  800fe6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe7:	83 ec 0c             	sub    $0xc,%esp
  800fea:	50                   	push   %eax
  800feb:	6a 13                	push   $0x13
  800fed:	68 28 29 80 00       	push   $0x802928
  800ff2:	6a 43                	push   $0x43
  800ff4:	68 45 29 80 00       	push   $0x802945
  800ff9:	e8 56 11 00 00       	call   802154 <_panic>

00800ffe <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	05 00 00 00 30       	add    $0x30000000,%eax
  801009:	c1 e8 0c             	shr    $0xc,%eax
}
  80100c:	5d                   	pop    %ebp
  80100d:	c3                   	ret    

0080100e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801019:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80101e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    

00801025 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80102d:	89 c2                	mov    %eax,%edx
  80102f:	c1 ea 16             	shr    $0x16,%edx
  801032:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801039:	f6 c2 01             	test   $0x1,%dl
  80103c:	74 2d                	je     80106b <fd_alloc+0x46>
  80103e:	89 c2                	mov    %eax,%edx
  801040:	c1 ea 0c             	shr    $0xc,%edx
  801043:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80104a:	f6 c2 01             	test   $0x1,%dl
  80104d:	74 1c                	je     80106b <fd_alloc+0x46>
  80104f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801054:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801059:	75 d2                	jne    80102d <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801064:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801069:	eb 0a                	jmp    801075 <fd_alloc+0x50>
			*fd_store = fd;
  80106b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80106e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801070:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80107d:	83 f8 1f             	cmp    $0x1f,%eax
  801080:	77 30                	ja     8010b2 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801082:	c1 e0 0c             	shl    $0xc,%eax
  801085:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80108a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801090:	f6 c2 01             	test   $0x1,%dl
  801093:	74 24                	je     8010b9 <fd_lookup+0x42>
  801095:	89 c2                	mov    %eax,%edx
  801097:	c1 ea 0c             	shr    $0xc,%edx
  80109a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010a1:	f6 c2 01             	test   $0x1,%dl
  8010a4:	74 1a                	je     8010c0 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a9:	89 02                	mov    %eax,(%edx)
	return 0;
  8010ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    
		return -E_INVAL;
  8010b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010b7:	eb f7                	jmp    8010b0 <fd_lookup+0x39>
		return -E_INVAL;
  8010b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010be:	eb f0                	jmp    8010b0 <fd_lookup+0x39>
  8010c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c5:	eb e9                	jmp    8010b0 <fd_lookup+0x39>

008010c7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 08             	sub    $0x8,%esp
  8010cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d5:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010da:	39 08                	cmp    %ecx,(%eax)
  8010dc:	74 38                	je     801116 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010de:	83 c2 01             	add    $0x1,%edx
  8010e1:	8b 04 95 d0 29 80 00 	mov    0x8029d0(,%edx,4),%eax
  8010e8:	85 c0                	test   %eax,%eax
  8010ea:	75 ee                	jne    8010da <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010ec:	a1 08 40 80 00       	mov    0x804008,%eax
  8010f1:	8b 40 48             	mov    0x48(%eax),%eax
  8010f4:	83 ec 04             	sub    $0x4,%esp
  8010f7:	51                   	push   %ecx
  8010f8:	50                   	push   %eax
  8010f9:	68 54 29 80 00       	push   $0x802954
  8010fe:	e8 d5 f0 ff ff       	call   8001d8 <cprintf>
	*dev = 0;
  801103:	8b 45 0c             	mov    0xc(%ebp),%eax
  801106:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80110c:	83 c4 10             	add    $0x10,%esp
  80110f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801114:	c9                   	leave  
  801115:	c3                   	ret    
			*dev = devtab[i];
  801116:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801119:	89 01                	mov    %eax,(%ecx)
			return 0;
  80111b:	b8 00 00 00 00       	mov    $0x0,%eax
  801120:	eb f2                	jmp    801114 <dev_lookup+0x4d>

00801122 <fd_close>:
{
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
  801125:	57                   	push   %edi
  801126:	56                   	push   %esi
  801127:	53                   	push   %ebx
  801128:	83 ec 24             	sub    $0x24,%esp
  80112b:	8b 75 08             	mov    0x8(%ebp),%esi
  80112e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801131:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801134:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801135:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80113b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80113e:	50                   	push   %eax
  80113f:	e8 33 ff ff ff       	call   801077 <fd_lookup>
  801144:	89 c3                	mov    %eax,%ebx
  801146:	83 c4 10             	add    $0x10,%esp
  801149:	85 c0                	test   %eax,%eax
  80114b:	78 05                	js     801152 <fd_close+0x30>
	    || fd != fd2)
  80114d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801150:	74 16                	je     801168 <fd_close+0x46>
		return (must_exist ? r : 0);
  801152:	89 f8                	mov    %edi,%eax
  801154:	84 c0                	test   %al,%al
  801156:	b8 00 00 00 00       	mov    $0x0,%eax
  80115b:	0f 44 d8             	cmove  %eax,%ebx
}
  80115e:	89 d8                	mov    %ebx,%eax
  801160:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801163:	5b                   	pop    %ebx
  801164:	5e                   	pop    %esi
  801165:	5f                   	pop    %edi
  801166:	5d                   	pop    %ebp
  801167:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80116e:	50                   	push   %eax
  80116f:	ff 36                	pushl  (%esi)
  801171:	e8 51 ff ff ff       	call   8010c7 <dev_lookup>
  801176:	89 c3                	mov    %eax,%ebx
  801178:	83 c4 10             	add    $0x10,%esp
  80117b:	85 c0                	test   %eax,%eax
  80117d:	78 1a                	js     801199 <fd_close+0x77>
		if (dev->dev_close)
  80117f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801182:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801185:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80118a:	85 c0                	test   %eax,%eax
  80118c:	74 0b                	je     801199 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80118e:	83 ec 0c             	sub    $0xc,%esp
  801191:	56                   	push   %esi
  801192:	ff d0                	call   *%eax
  801194:	89 c3                	mov    %eax,%ebx
  801196:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801199:	83 ec 08             	sub    $0x8,%esp
  80119c:	56                   	push   %esi
  80119d:	6a 00                	push   $0x0
  80119f:	e8 0a fc ff ff       	call   800dae <sys_page_unmap>
	return r;
  8011a4:	83 c4 10             	add    $0x10,%esp
  8011a7:	eb b5                	jmp    80115e <fd_close+0x3c>

008011a9 <close>:

int
close(int fdnum)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b2:	50                   	push   %eax
  8011b3:	ff 75 08             	pushl  0x8(%ebp)
  8011b6:	e8 bc fe ff ff       	call   801077 <fd_lookup>
  8011bb:	83 c4 10             	add    $0x10,%esp
  8011be:	85 c0                	test   %eax,%eax
  8011c0:	79 02                	jns    8011c4 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011c2:	c9                   	leave  
  8011c3:	c3                   	ret    
		return fd_close(fd, 1);
  8011c4:	83 ec 08             	sub    $0x8,%esp
  8011c7:	6a 01                	push   $0x1
  8011c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011cc:	e8 51 ff ff ff       	call   801122 <fd_close>
  8011d1:	83 c4 10             	add    $0x10,%esp
  8011d4:	eb ec                	jmp    8011c2 <close+0x19>

008011d6 <close_all>:

void
close_all(void)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	53                   	push   %ebx
  8011da:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011dd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011e2:	83 ec 0c             	sub    $0xc,%esp
  8011e5:	53                   	push   %ebx
  8011e6:	e8 be ff ff ff       	call   8011a9 <close>
	for (i = 0; i < MAXFD; i++)
  8011eb:	83 c3 01             	add    $0x1,%ebx
  8011ee:	83 c4 10             	add    $0x10,%esp
  8011f1:	83 fb 20             	cmp    $0x20,%ebx
  8011f4:	75 ec                	jne    8011e2 <close_all+0xc>
}
  8011f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f9:	c9                   	leave  
  8011fa:	c3                   	ret    

008011fb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	57                   	push   %edi
  8011ff:	56                   	push   %esi
  801200:	53                   	push   %ebx
  801201:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801204:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801207:	50                   	push   %eax
  801208:	ff 75 08             	pushl  0x8(%ebp)
  80120b:	e8 67 fe ff ff       	call   801077 <fd_lookup>
  801210:	89 c3                	mov    %eax,%ebx
  801212:	83 c4 10             	add    $0x10,%esp
  801215:	85 c0                	test   %eax,%eax
  801217:	0f 88 81 00 00 00    	js     80129e <dup+0xa3>
		return r;
	close(newfdnum);
  80121d:	83 ec 0c             	sub    $0xc,%esp
  801220:	ff 75 0c             	pushl  0xc(%ebp)
  801223:	e8 81 ff ff ff       	call   8011a9 <close>

	newfd = INDEX2FD(newfdnum);
  801228:	8b 75 0c             	mov    0xc(%ebp),%esi
  80122b:	c1 e6 0c             	shl    $0xc,%esi
  80122e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801234:	83 c4 04             	add    $0x4,%esp
  801237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80123a:	e8 cf fd ff ff       	call   80100e <fd2data>
  80123f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801241:	89 34 24             	mov    %esi,(%esp)
  801244:	e8 c5 fd ff ff       	call   80100e <fd2data>
  801249:	83 c4 10             	add    $0x10,%esp
  80124c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80124e:	89 d8                	mov    %ebx,%eax
  801250:	c1 e8 16             	shr    $0x16,%eax
  801253:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80125a:	a8 01                	test   $0x1,%al
  80125c:	74 11                	je     80126f <dup+0x74>
  80125e:	89 d8                	mov    %ebx,%eax
  801260:	c1 e8 0c             	shr    $0xc,%eax
  801263:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80126a:	f6 c2 01             	test   $0x1,%dl
  80126d:	75 39                	jne    8012a8 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80126f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801272:	89 d0                	mov    %edx,%eax
  801274:	c1 e8 0c             	shr    $0xc,%eax
  801277:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80127e:	83 ec 0c             	sub    $0xc,%esp
  801281:	25 07 0e 00 00       	and    $0xe07,%eax
  801286:	50                   	push   %eax
  801287:	56                   	push   %esi
  801288:	6a 00                	push   $0x0
  80128a:	52                   	push   %edx
  80128b:	6a 00                	push   $0x0
  80128d:	e8 da fa ff ff       	call   800d6c <sys_page_map>
  801292:	89 c3                	mov    %eax,%ebx
  801294:	83 c4 20             	add    $0x20,%esp
  801297:	85 c0                	test   %eax,%eax
  801299:	78 31                	js     8012cc <dup+0xd1>
		goto err;

	return newfdnum;
  80129b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80129e:	89 d8                	mov    %ebx,%eax
  8012a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a3:	5b                   	pop    %ebx
  8012a4:	5e                   	pop    %esi
  8012a5:	5f                   	pop    %edi
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012a8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012af:	83 ec 0c             	sub    $0xc,%esp
  8012b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b7:	50                   	push   %eax
  8012b8:	57                   	push   %edi
  8012b9:	6a 00                	push   $0x0
  8012bb:	53                   	push   %ebx
  8012bc:	6a 00                	push   $0x0
  8012be:	e8 a9 fa ff ff       	call   800d6c <sys_page_map>
  8012c3:	89 c3                	mov    %eax,%ebx
  8012c5:	83 c4 20             	add    $0x20,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	79 a3                	jns    80126f <dup+0x74>
	sys_page_unmap(0, newfd);
  8012cc:	83 ec 08             	sub    $0x8,%esp
  8012cf:	56                   	push   %esi
  8012d0:	6a 00                	push   $0x0
  8012d2:	e8 d7 fa ff ff       	call   800dae <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012d7:	83 c4 08             	add    $0x8,%esp
  8012da:	57                   	push   %edi
  8012db:	6a 00                	push   $0x0
  8012dd:	e8 cc fa ff ff       	call   800dae <sys_page_unmap>
	return r;
  8012e2:	83 c4 10             	add    $0x10,%esp
  8012e5:	eb b7                	jmp    80129e <dup+0xa3>

008012e7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	53                   	push   %ebx
  8012eb:	83 ec 1c             	sub    $0x1c,%esp
  8012ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f4:	50                   	push   %eax
  8012f5:	53                   	push   %ebx
  8012f6:	e8 7c fd ff ff       	call   801077 <fd_lookup>
  8012fb:	83 c4 10             	add    $0x10,%esp
  8012fe:	85 c0                	test   %eax,%eax
  801300:	78 3f                	js     801341 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801302:	83 ec 08             	sub    $0x8,%esp
  801305:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801308:	50                   	push   %eax
  801309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130c:	ff 30                	pushl  (%eax)
  80130e:	e8 b4 fd ff ff       	call   8010c7 <dev_lookup>
  801313:	83 c4 10             	add    $0x10,%esp
  801316:	85 c0                	test   %eax,%eax
  801318:	78 27                	js     801341 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80131a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80131d:	8b 42 08             	mov    0x8(%edx),%eax
  801320:	83 e0 03             	and    $0x3,%eax
  801323:	83 f8 01             	cmp    $0x1,%eax
  801326:	74 1e                	je     801346 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132b:	8b 40 08             	mov    0x8(%eax),%eax
  80132e:	85 c0                	test   %eax,%eax
  801330:	74 35                	je     801367 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801332:	83 ec 04             	sub    $0x4,%esp
  801335:	ff 75 10             	pushl  0x10(%ebp)
  801338:	ff 75 0c             	pushl  0xc(%ebp)
  80133b:	52                   	push   %edx
  80133c:	ff d0                	call   *%eax
  80133e:	83 c4 10             	add    $0x10,%esp
}
  801341:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801344:	c9                   	leave  
  801345:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801346:	a1 08 40 80 00       	mov    0x804008,%eax
  80134b:	8b 40 48             	mov    0x48(%eax),%eax
  80134e:	83 ec 04             	sub    $0x4,%esp
  801351:	53                   	push   %ebx
  801352:	50                   	push   %eax
  801353:	68 95 29 80 00       	push   $0x802995
  801358:	e8 7b ee ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801365:	eb da                	jmp    801341 <read+0x5a>
		return -E_NOT_SUPP;
  801367:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80136c:	eb d3                	jmp    801341 <read+0x5a>

0080136e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
  801371:	57                   	push   %edi
  801372:	56                   	push   %esi
  801373:	53                   	push   %ebx
  801374:	83 ec 0c             	sub    $0xc,%esp
  801377:	8b 7d 08             	mov    0x8(%ebp),%edi
  80137a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80137d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801382:	39 f3                	cmp    %esi,%ebx
  801384:	73 23                	jae    8013a9 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801386:	83 ec 04             	sub    $0x4,%esp
  801389:	89 f0                	mov    %esi,%eax
  80138b:	29 d8                	sub    %ebx,%eax
  80138d:	50                   	push   %eax
  80138e:	89 d8                	mov    %ebx,%eax
  801390:	03 45 0c             	add    0xc(%ebp),%eax
  801393:	50                   	push   %eax
  801394:	57                   	push   %edi
  801395:	e8 4d ff ff ff       	call   8012e7 <read>
		if (m < 0)
  80139a:	83 c4 10             	add    $0x10,%esp
  80139d:	85 c0                	test   %eax,%eax
  80139f:	78 06                	js     8013a7 <readn+0x39>
			return m;
		if (m == 0)
  8013a1:	74 06                	je     8013a9 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013a3:	01 c3                	add    %eax,%ebx
  8013a5:	eb db                	jmp    801382 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013a7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013a9:	89 d8                	mov    %ebx,%eax
  8013ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ae:	5b                   	pop    %ebx
  8013af:	5e                   	pop    %esi
  8013b0:	5f                   	pop    %edi
  8013b1:	5d                   	pop    %ebp
  8013b2:	c3                   	ret    

008013b3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	53                   	push   %ebx
  8013b7:	83 ec 1c             	sub    $0x1c,%esp
  8013ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c0:	50                   	push   %eax
  8013c1:	53                   	push   %ebx
  8013c2:	e8 b0 fc ff ff       	call   801077 <fd_lookup>
  8013c7:	83 c4 10             	add    $0x10,%esp
  8013ca:	85 c0                	test   %eax,%eax
  8013cc:	78 3a                	js     801408 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ce:	83 ec 08             	sub    $0x8,%esp
  8013d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d4:	50                   	push   %eax
  8013d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d8:	ff 30                	pushl  (%eax)
  8013da:	e8 e8 fc ff ff       	call   8010c7 <dev_lookup>
  8013df:	83 c4 10             	add    $0x10,%esp
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	78 22                	js     801408 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013ed:	74 1e                	je     80140d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f2:	8b 52 0c             	mov    0xc(%edx),%edx
  8013f5:	85 d2                	test   %edx,%edx
  8013f7:	74 35                	je     80142e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013f9:	83 ec 04             	sub    $0x4,%esp
  8013fc:	ff 75 10             	pushl  0x10(%ebp)
  8013ff:	ff 75 0c             	pushl  0xc(%ebp)
  801402:	50                   	push   %eax
  801403:	ff d2                	call   *%edx
  801405:	83 c4 10             	add    $0x10,%esp
}
  801408:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80140d:	a1 08 40 80 00       	mov    0x804008,%eax
  801412:	8b 40 48             	mov    0x48(%eax),%eax
  801415:	83 ec 04             	sub    $0x4,%esp
  801418:	53                   	push   %ebx
  801419:	50                   	push   %eax
  80141a:	68 b1 29 80 00       	push   $0x8029b1
  80141f:	e8 b4 ed ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  801424:	83 c4 10             	add    $0x10,%esp
  801427:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80142c:	eb da                	jmp    801408 <write+0x55>
		return -E_NOT_SUPP;
  80142e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801433:	eb d3                	jmp    801408 <write+0x55>

00801435 <seek>:

int
seek(int fdnum, off_t offset)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80143b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143e:	50                   	push   %eax
  80143f:	ff 75 08             	pushl  0x8(%ebp)
  801442:	e8 30 fc ff ff       	call   801077 <fd_lookup>
  801447:	83 c4 10             	add    $0x10,%esp
  80144a:	85 c0                	test   %eax,%eax
  80144c:	78 0e                	js     80145c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80144e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801454:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801457:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	53                   	push   %ebx
  801462:	83 ec 1c             	sub    $0x1c,%esp
  801465:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801468:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80146b:	50                   	push   %eax
  80146c:	53                   	push   %ebx
  80146d:	e8 05 fc ff ff       	call   801077 <fd_lookup>
  801472:	83 c4 10             	add    $0x10,%esp
  801475:	85 c0                	test   %eax,%eax
  801477:	78 37                	js     8014b0 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801479:	83 ec 08             	sub    $0x8,%esp
  80147c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147f:	50                   	push   %eax
  801480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801483:	ff 30                	pushl  (%eax)
  801485:	e8 3d fc ff ff       	call   8010c7 <dev_lookup>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	85 c0                	test   %eax,%eax
  80148f:	78 1f                	js     8014b0 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801491:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801494:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801498:	74 1b                	je     8014b5 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80149a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149d:	8b 52 18             	mov    0x18(%edx),%edx
  8014a0:	85 d2                	test   %edx,%edx
  8014a2:	74 32                	je     8014d6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014a4:	83 ec 08             	sub    $0x8,%esp
  8014a7:	ff 75 0c             	pushl  0xc(%ebp)
  8014aa:	50                   	push   %eax
  8014ab:	ff d2                	call   *%edx
  8014ad:	83 c4 10             	add    $0x10,%esp
}
  8014b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014b5:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014ba:	8b 40 48             	mov    0x48(%eax),%eax
  8014bd:	83 ec 04             	sub    $0x4,%esp
  8014c0:	53                   	push   %ebx
  8014c1:	50                   	push   %eax
  8014c2:	68 74 29 80 00       	push   $0x802974
  8014c7:	e8 0c ed ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  8014cc:	83 c4 10             	add    $0x10,%esp
  8014cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d4:	eb da                	jmp    8014b0 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014db:	eb d3                	jmp    8014b0 <ftruncate+0x52>

008014dd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	53                   	push   %ebx
  8014e1:	83 ec 1c             	sub    $0x1c,%esp
  8014e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ea:	50                   	push   %eax
  8014eb:	ff 75 08             	pushl  0x8(%ebp)
  8014ee:	e8 84 fb ff ff       	call   801077 <fd_lookup>
  8014f3:	83 c4 10             	add    $0x10,%esp
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	78 4b                	js     801545 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801500:	50                   	push   %eax
  801501:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801504:	ff 30                	pushl  (%eax)
  801506:	e8 bc fb ff ff       	call   8010c7 <dev_lookup>
  80150b:	83 c4 10             	add    $0x10,%esp
  80150e:	85 c0                	test   %eax,%eax
  801510:	78 33                	js     801545 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801515:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801519:	74 2f                	je     80154a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80151b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80151e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801525:	00 00 00 
	stat->st_isdir = 0;
  801528:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80152f:	00 00 00 
	stat->st_dev = dev;
  801532:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801538:	83 ec 08             	sub    $0x8,%esp
  80153b:	53                   	push   %ebx
  80153c:	ff 75 f0             	pushl  -0x10(%ebp)
  80153f:	ff 50 14             	call   *0x14(%eax)
  801542:	83 c4 10             	add    $0x10,%esp
}
  801545:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801548:	c9                   	leave  
  801549:	c3                   	ret    
		return -E_NOT_SUPP;
  80154a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80154f:	eb f4                	jmp    801545 <fstat+0x68>

00801551 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	56                   	push   %esi
  801555:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801556:	83 ec 08             	sub    $0x8,%esp
  801559:	6a 00                	push   $0x0
  80155b:	ff 75 08             	pushl  0x8(%ebp)
  80155e:	e8 22 02 00 00       	call   801785 <open>
  801563:	89 c3                	mov    %eax,%ebx
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	85 c0                	test   %eax,%eax
  80156a:	78 1b                	js     801587 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80156c:	83 ec 08             	sub    $0x8,%esp
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	50                   	push   %eax
  801573:	e8 65 ff ff ff       	call   8014dd <fstat>
  801578:	89 c6                	mov    %eax,%esi
	close(fd);
  80157a:	89 1c 24             	mov    %ebx,(%esp)
  80157d:	e8 27 fc ff ff       	call   8011a9 <close>
	return r;
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	89 f3                	mov    %esi,%ebx
}
  801587:	89 d8                	mov    %ebx,%eax
  801589:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80158c:	5b                   	pop    %ebx
  80158d:	5e                   	pop    %esi
  80158e:	5d                   	pop    %ebp
  80158f:	c3                   	ret    

00801590 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	56                   	push   %esi
  801594:	53                   	push   %ebx
  801595:	89 c6                	mov    %eax,%esi
  801597:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801599:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015a0:	74 27                	je     8015c9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015a2:	6a 07                	push   $0x7
  8015a4:	68 00 50 80 00       	push   $0x805000
  8015a9:	56                   	push   %esi
  8015aa:	ff 35 00 40 80 00    	pushl  0x804000
  8015b0:	e8 69 0c 00 00       	call   80221e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015b5:	83 c4 0c             	add    $0xc,%esp
  8015b8:	6a 00                	push   $0x0
  8015ba:	53                   	push   %ebx
  8015bb:	6a 00                	push   $0x0
  8015bd:	e8 f3 0b 00 00       	call   8021b5 <ipc_recv>
}
  8015c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c5:	5b                   	pop    %ebx
  8015c6:	5e                   	pop    %esi
  8015c7:	5d                   	pop    %ebp
  8015c8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015c9:	83 ec 0c             	sub    $0xc,%esp
  8015cc:	6a 01                	push   $0x1
  8015ce:	e8 a3 0c 00 00       	call   802276 <ipc_find_env>
  8015d3:	a3 00 40 80 00       	mov    %eax,0x804000
  8015d8:	83 c4 10             	add    $0x10,%esp
  8015db:	eb c5                	jmp    8015a2 <fsipc+0x12>

008015dd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f1:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fb:	b8 02 00 00 00       	mov    $0x2,%eax
  801600:	e8 8b ff ff ff       	call   801590 <fsipc>
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <devfile_flush>:
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	8b 40 0c             	mov    0xc(%eax),%eax
  801613:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801618:	ba 00 00 00 00       	mov    $0x0,%edx
  80161d:	b8 06 00 00 00       	mov    $0x6,%eax
  801622:	e8 69 ff ff ff       	call   801590 <fsipc>
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <devfile_stat>:
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	53                   	push   %ebx
  80162d:	83 ec 04             	sub    $0x4,%esp
  801630:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	8b 40 0c             	mov    0xc(%eax),%eax
  801639:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80163e:	ba 00 00 00 00       	mov    $0x0,%edx
  801643:	b8 05 00 00 00       	mov    $0x5,%eax
  801648:	e8 43 ff ff ff       	call   801590 <fsipc>
  80164d:	85 c0                	test   %eax,%eax
  80164f:	78 2c                	js     80167d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801651:	83 ec 08             	sub    $0x8,%esp
  801654:	68 00 50 80 00       	push   $0x805000
  801659:	53                   	push   %ebx
  80165a:	e8 d8 f2 ff ff       	call   800937 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80165f:	a1 80 50 80 00       	mov    0x805080,%eax
  801664:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80166a:	a1 84 50 80 00       	mov    0x805084,%eax
  80166f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801675:	83 c4 10             	add    $0x10,%esp
  801678:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <devfile_write>:
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	53                   	push   %ebx
  801686:	83 ec 08             	sub    $0x8,%esp
  801689:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	8b 40 0c             	mov    0xc(%eax),%eax
  801692:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801697:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80169d:	53                   	push   %ebx
  80169e:	ff 75 0c             	pushl  0xc(%ebp)
  8016a1:	68 08 50 80 00       	push   $0x805008
  8016a6:	e8 7c f4 ff ff       	call   800b27 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b0:	b8 04 00 00 00       	mov    $0x4,%eax
  8016b5:	e8 d6 fe ff ff       	call   801590 <fsipc>
  8016ba:	83 c4 10             	add    $0x10,%esp
  8016bd:	85 c0                	test   %eax,%eax
  8016bf:	78 0b                	js     8016cc <devfile_write+0x4a>
	assert(r <= n);
  8016c1:	39 d8                	cmp    %ebx,%eax
  8016c3:	77 0c                	ja     8016d1 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016ca:	7f 1e                	jg     8016ea <devfile_write+0x68>
}
  8016cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    
	assert(r <= n);
  8016d1:	68 e4 29 80 00       	push   $0x8029e4
  8016d6:	68 eb 29 80 00       	push   $0x8029eb
  8016db:	68 98 00 00 00       	push   $0x98
  8016e0:	68 00 2a 80 00       	push   $0x802a00
  8016e5:	e8 6a 0a 00 00       	call   802154 <_panic>
	assert(r <= PGSIZE);
  8016ea:	68 0b 2a 80 00       	push   $0x802a0b
  8016ef:	68 eb 29 80 00       	push   $0x8029eb
  8016f4:	68 99 00 00 00       	push   $0x99
  8016f9:	68 00 2a 80 00       	push   $0x802a00
  8016fe:	e8 51 0a 00 00       	call   802154 <_panic>

00801703 <devfile_read>:
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	56                   	push   %esi
  801707:	53                   	push   %ebx
  801708:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	8b 40 0c             	mov    0xc(%eax),%eax
  801711:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801716:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80171c:	ba 00 00 00 00       	mov    $0x0,%edx
  801721:	b8 03 00 00 00       	mov    $0x3,%eax
  801726:	e8 65 fe ff ff       	call   801590 <fsipc>
  80172b:	89 c3                	mov    %eax,%ebx
  80172d:	85 c0                	test   %eax,%eax
  80172f:	78 1f                	js     801750 <devfile_read+0x4d>
	assert(r <= n);
  801731:	39 f0                	cmp    %esi,%eax
  801733:	77 24                	ja     801759 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801735:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80173a:	7f 33                	jg     80176f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80173c:	83 ec 04             	sub    $0x4,%esp
  80173f:	50                   	push   %eax
  801740:	68 00 50 80 00       	push   $0x805000
  801745:	ff 75 0c             	pushl  0xc(%ebp)
  801748:	e8 78 f3 ff ff       	call   800ac5 <memmove>
	return r;
  80174d:	83 c4 10             	add    $0x10,%esp
}
  801750:	89 d8                	mov    %ebx,%eax
  801752:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801755:	5b                   	pop    %ebx
  801756:	5e                   	pop    %esi
  801757:	5d                   	pop    %ebp
  801758:	c3                   	ret    
	assert(r <= n);
  801759:	68 e4 29 80 00       	push   $0x8029e4
  80175e:	68 eb 29 80 00       	push   $0x8029eb
  801763:	6a 7c                	push   $0x7c
  801765:	68 00 2a 80 00       	push   $0x802a00
  80176a:	e8 e5 09 00 00       	call   802154 <_panic>
	assert(r <= PGSIZE);
  80176f:	68 0b 2a 80 00       	push   $0x802a0b
  801774:	68 eb 29 80 00       	push   $0x8029eb
  801779:	6a 7d                	push   $0x7d
  80177b:	68 00 2a 80 00       	push   $0x802a00
  801780:	e8 cf 09 00 00       	call   802154 <_panic>

00801785 <open>:
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	56                   	push   %esi
  801789:	53                   	push   %ebx
  80178a:	83 ec 1c             	sub    $0x1c,%esp
  80178d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801790:	56                   	push   %esi
  801791:	e8 68 f1 ff ff       	call   8008fe <strlen>
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80179e:	7f 6c                	jg     80180c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017a0:	83 ec 0c             	sub    $0xc,%esp
  8017a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a6:	50                   	push   %eax
  8017a7:	e8 79 f8 ff ff       	call   801025 <fd_alloc>
  8017ac:	89 c3                	mov    %eax,%ebx
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	78 3c                	js     8017f1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017b5:	83 ec 08             	sub    $0x8,%esp
  8017b8:	56                   	push   %esi
  8017b9:	68 00 50 80 00       	push   $0x805000
  8017be:	e8 74 f1 ff ff       	call   800937 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c6:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d3:	e8 b8 fd ff ff       	call   801590 <fsipc>
  8017d8:	89 c3                	mov    %eax,%ebx
  8017da:	83 c4 10             	add    $0x10,%esp
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	78 19                	js     8017fa <open+0x75>
	return fd2num(fd);
  8017e1:	83 ec 0c             	sub    $0xc,%esp
  8017e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e7:	e8 12 f8 ff ff       	call   800ffe <fd2num>
  8017ec:	89 c3                	mov    %eax,%ebx
  8017ee:	83 c4 10             	add    $0x10,%esp
}
  8017f1:	89 d8                	mov    %ebx,%eax
  8017f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f6:	5b                   	pop    %ebx
  8017f7:	5e                   	pop    %esi
  8017f8:	5d                   	pop    %ebp
  8017f9:	c3                   	ret    
		fd_close(fd, 0);
  8017fa:	83 ec 08             	sub    $0x8,%esp
  8017fd:	6a 00                	push   $0x0
  8017ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801802:	e8 1b f9 ff ff       	call   801122 <fd_close>
		return r;
  801807:	83 c4 10             	add    $0x10,%esp
  80180a:	eb e5                	jmp    8017f1 <open+0x6c>
		return -E_BAD_PATH;
  80180c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801811:	eb de                	jmp    8017f1 <open+0x6c>

00801813 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801819:	ba 00 00 00 00       	mov    $0x0,%edx
  80181e:	b8 08 00 00 00       	mov    $0x8,%eax
  801823:	e8 68 fd ff ff       	call   801590 <fsipc>
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801830:	68 17 2a 80 00       	push   $0x802a17
  801835:	ff 75 0c             	pushl  0xc(%ebp)
  801838:	e8 fa f0 ff ff       	call   800937 <strcpy>
	return 0;
}
  80183d:	b8 00 00 00 00       	mov    $0x0,%eax
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <devsock_close>:
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	53                   	push   %ebx
  801848:	83 ec 10             	sub    $0x10,%esp
  80184b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80184e:	53                   	push   %ebx
  80184f:	e8 5d 0a 00 00       	call   8022b1 <pageref>
  801854:	83 c4 10             	add    $0x10,%esp
		return 0;
  801857:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80185c:	83 f8 01             	cmp    $0x1,%eax
  80185f:	74 07                	je     801868 <devsock_close+0x24>
}
  801861:	89 d0                	mov    %edx,%eax
  801863:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801866:	c9                   	leave  
  801867:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801868:	83 ec 0c             	sub    $0xc,%esp
  80186b:	ff 73 0c             	pushl  0xc(%ebx)
  80186e:	e8 b9 02 00 00       	call   801b2c <nsipc_close>
  801873:	89 c2                	mov    %eax,%edx
  801875:	83 c4 10             	add    $0x10,%esp
  801878:	eb e7                	jmp    801861 <devsock_close+0x1d>

0080187a <devsock_write>:
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801880:	6a 00                	push   $0x0
  801882:	ff 75 10             	pushl  0x10(%ebp)
  801885:	ff 75 0c             	pushl  0xc(%ebp)
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	ff 70 0c             	pushl  0xc(%eax)
  80188e:	e8 76 03 00 00       	call   801c09 <nsipc_send>
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <devsock_read>:
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80189b:	6a 00                	push   $0x0
  80189d:	ff 75 10             	pushl  0x10(%ebp)
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a6:	ff 70 0c             	pushl  0xc(%eax)
  8018a9:	e8 ef 02 00 00       	call   801b9d <nsipc_recv>
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <fd2sockid>:
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018b6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018b9:	52                   	push   %edx
  8018ba:	50                   	push   %eax
  8018bb:	e8 b7 f7 ff ff       	call   801077 <fd_lookup>
  8018c0:	83 c4 10             	add    $0x10,%esp
  8018c3:	85 c0                	test   %eax,%eax
  8018c5:	78 10                	js     8018d7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ca:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018d0:	39 08                	cmp    %ecx,(%eax)
  8018d2:	75 05                	jne    8018d9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018d4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    
		return -E_NOT_SUPP;
  8018d9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018de:	eb f7                	jmp    8018d7 <fd2sockid+0x27>

008018e0 <alloc_sockfd>:
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	56                   	push   %esi
  8018e4:	53                   	push   %ebx
  8018e5:	83 ec 1c             	sub    $0x1c,%esp
  8018e8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ed:	50                   	push   %eax
  8018ee:	e8 32 f7 ff ff       	call   801025 <fd_alloc>
  8018f3:	89 c3                	mov    %eax,%ebx
  8018f5:	83 c4 10             	add    $0x10,%esp
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	78 43                	js     80193f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018fc:	83 ec 04             	sub    $0x4,%esp
  8018ff:	68 07 04 00 00       	push   $0x407
  801904:	ff 75 f4             	pushl  -0xc(%ebp)
  801907:	6a 00                	push   $0x0
  801909:	e8 1b f4 ff ff       	call   800d29 <sys_page_alloc>
  80190e:	89 c3                	mov    %eax,%ebx
  801910:	83 c4 10             	add    $0x10,%esp
  801913:	85 c0                	test   %eax,%eax
  801915:	78 28                	js     80193f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191a:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801920:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801925:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80192c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80192f:	83 ec 0c             	sub    $0xc,%esp
  801932:	50                   	push   %eax
  801933:	e8 c6 f6 ff ff       	call   800ffe <fd2num>
  801938:	89 c3                	mov    %eax,%ebx
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	eb 0c                	jmp    80194b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80193f:	83 ec 0c             	sub    $0xc,%esp
  801942:	56                   	push   %esi
  801943:	e8 e4 01 00 00       	call   801b2c <nsipc_close>
		return r;
  801948:	83 c4 10             	add    $0x10,%esp
}
  80194b:	89 d8                	mov    %ebx,%eax
  80194d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801950:	5b                   	pop    %ebx
  801951:	5e                   	pop    %esi
  801952:	5d                   	pop    %ebp
  801953:	c3                   	ret    

00801954 <accept>:
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	e8 4e ff ff ff       	call   8018b0 <fd2sockid>
  801962:	85 c0                	test   %eax,%eax
  801964:	78 1b                	js     801981 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801966:	83 ec 04             	sub    $0x4,%esp
  801969:	ff 75 10             	pushl  0x10(%ebp)
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	50                   	push   %eax
  801970:	e8 0e 01 00 00       	call   801a83 <nsipc_accept>
  801975:	83 c4 10             	add    $0x10,%esp
  801978:	85 c0                	test   %eax,%eax
  80197a:	78 05                	js     801981 <accept+0x2d>
	return alloc_sockfd(r);
  80197c:	e8 5f ff ff ff       	call   8018e0 <alloc_sockfd>
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <bind>:
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	e8 1f ff ff ff       	call   8018b0 <fd2sockid>
  801991:	85 c0                	test   %eax,%eax
  801993:	78 12                	js     8019a7 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801995:	83 ec 04             	sub    $0x4,%esp
  801998:	ff 75 10             	pushl  0x10(%ebp)
  80199b:	ff 75 0c             	pushl  0xc(%ebp)
  80199e:	50                   	push   %eax
  80199f:	e8 31 01 00 00       	call   801ad5 <nsipc_bind>
  8019a4:	83 c4 10             	add    $0x10,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <shutdown>:
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	e8 f9 fe ff ff       	call   8018b0 <fd2sockid>
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	78 0f                	js     8019ca <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019bb:	83 ec 08             	sub    $0x8,%esp
  8019be:	ff 75 0c             	pushl  0xc(%ebp)
  8019c1:	50                   	push   %eax
  8019c2:	e8 43 01 00 00       	call   801b0a <nsipc_shutdown>
  8019c7:	83 c4 10             	add    $0x10,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <connect>:
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	e8 d6 fe ff ff       	call   8018b0 <fd2sockid>
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	78 12                	js     8019f0 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019de:	83 ec 04             	sub    $0x4,%esp
  8019e1:	ff 75 10             	pushl  0x10(%ebp)
  8019e4:	ff 75 0c             	pushl  0xc(%ebp)
  8019e7:	50                   	push   %eax
  8019e8:	e8 59 01 00 00       	call   801b46 <nsipc_connect>
  8019ed:	83 c4 10             	add    $0x10,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <listen>:
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	e8 b0 fe ff ff       	call   8018b0 <fd2sockid>
  801a00:	85 c0                	test   %eax,%eax
  801a02:	78 0f                	js     801a13 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a04:	83 ec 08             	sub    $0x8,%esp
  801a07:	ff 75 0c             	pushl  0xc(%ebp)
  801a0a:	50                   	push   %eax
  801a0b:	e8 6b 01 00 00       	call   801b7b <nsipc_listen>
  801a10:	83 c4 10             	add    $0x10,%esp
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
  801a18:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a1b:	ff 75 10             	pushl  0x10(%ebp)
  801a1e:	ff 75 0c             	pushl  0xc(%ebp)
  801a21:	ff 75 08             	pushl  0x8(%ebp)
  801a24:	e8 3e 02 00 00       	call   801c67 <nsipc_socket>
  801a29:	83 c4 10             	add    $0x10,%esp
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	78 05                	js     801a35 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a30:	e8 ab fe ff ff       	call   8018e0 <alloc_sockfd>
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	53                   	push   %ebx
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a40:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a47:	74 26                	je     801a6f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a49:	6a 07                	push   $0x7
  801a4b:	68 00 60 80 00       	push   $0x806000
  801a50:	53                   	push   %ebx
  801a51:	ff 35 04 40 80 00    	pushl  0x804004
  801a57:	e8 c2 07 00 00       	call   80221e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a5c:	83 c4 0c             	add    $0xc,%esp
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	e8 4b 07 00 00       	call   8021b5 <ipc_recv>
}
  801a6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a6f:	83 ec 0c             	sub    $0xc,%esp
  801a72:	6a 02                	push   $0x2
  801a74:	e8 fd 07 00 00       	call   802276 <ipc_find_env>
  801a79:	a3 04 40 80 00       	mov    %eax,0x804004
  801a7e:	83 c4 10             	add    $0x10,%esp
  801a81:	eb c6                	jmp    801a49 <nsipc+0x12>

00801a83 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	56                   	push   %esi
  801a87:	53                   	push   %ebx
  801a88:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a93:	8b 06                	mov    (%esi),%eax
  801a95:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9f:	e8 93 ff ff ff       	call   801a37 <nsipc>
  801aa4:	89 c3                	mov    %eax,%ebx
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	79 09                	jns    801ab3 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801aaa:	89 d8                	mov    %ebx,%eax
  801aac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aaf:	5b                   	pop    %ebx
  801ab0:	5e                   	pop    %esi
  801ab1:	5d                   	pop    %ebp
  801ab2:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ab3:	83 ec 04             	sub    $0x4,%esp
  801ab6:	ff 35 10 60 80 00    	pushl  0x806010
  801abc:	68 00 60 80 00       	push   $0x806000
  801ac1:	ff 75 0c             	pushl  0xc(%ebp)
  801ac4:	e8 fc ef ff ff       	call   800ac5 <memmove>
		*addrlen = ret->ret_addrlen;
  801ac9:	a1 10 60 80 00       	mov    0x806010,%eax
  801ace:	89 06                	mov    %eax,(%esi)
  801ad0:	83 c4 10             	add    $0x10,%esp
	return r;
  801ad3:	eb d5                	jmp    801aaa <nsipc_accept+0x27>

00801ad5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	53                   	push   %ebx
  801ad9:	83 ec 08             	sub    $0x8,%esp
  801adc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ae7:	53                   	push   %ebx
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	68 04 60 80 00       	push   $0x806004
  801af0:	e8 d0 ef ff ff       	call   800ac5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801af5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801afb:	b8 02 00 00 00       	mov    $0x2,%eax
  801b00:	e8 32 ff ff ff       	call   801a37 <nsipc>
}
  801b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b20:	b8 03 00 00 00       	mov    $0x3,%eax
  801b25:	e8 0d ff ff ff       	call   801a37 <nsipc>
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <nsipc_close>:

int
nsipc_close(int s)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b3a:	b8 04 00 00 00       	mov    $0x4,%eax
  801b3f:	e8 f3 fe ff ff       	call   801a37 <nsipc>
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	53                   	push   %ebx
  801b4a:	83 ec 08             	sub    $0x8,%esp
  801b4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b58:	53                   	push   %ebx
  801b59:	ff 75 0c             	pushl  0xc(%ebp)
  801b5c:	68 04 60 80 00       	push   $0x806004
  801b61:	e8 5f ef ff ff       	call   800ac5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b66:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b6c:	b8 05 00 00 00       	mov    $0x5,%eax
  801b71:	e8 c1 fe ff ff       	call   801a37 <nsipc>
}
  801b76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b91:	b8 06 00 00 00       	mov    $0x6,%eax
  801b96:	e8 9c fe ff ff       	call   801a37 <nsipc>
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	56                   	push   %esi
  801ba1:	53                   	push   %ebx
  801ba2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bad:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bb3:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb6:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bbb:	b8 07 00 00 00       	mov    $0x7,%eax
  801bc0:	e8 72 fe ff ff       	call   801a37 <nsipc>
  801bc5:	89 c3                	mov    %eax,%ebx
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	78 1f                	js     801bea <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bcb:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bd0:	7f 21                	jg     801bf3 <nsipc_recv+0x56>
  801bd2:	39 c6                	cmp    %eax,%esi
  801bd4:	7c 1d                	jl     801bf3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bd6:	83 ec 04             	sub    $0x4,%esp
  801bd9:	50                   	push   %eax
  801bda:	68 00 60 80 00       	push   $0x806000
  801bdf:	ff 75 0c             	pushl  0xc(%ebp)
  801be2:	e8 de ee ff ff       	call   800ac5 <memmove>
  801be7:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801bea:	89 d8                	mov    %ebx,%eax
  801bec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bef:	5b                   	pop    %ebx
  801bf0:	5e                   	pop    %esi
  801bf1:	5d                   	pop    %ebp
  801bf2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bf3:	68 23 2a 80 00       	push   $0x802a23
  801bf8:	68 eb 29 80 00       	push   $0x8029eb
  801bfd:	6a 62                	push   $0x62
  801bff:	68 38 2a 80 00       	push   $0x802a38
  801c04:	e8 4b 05 00 00       	call   802154 <_panic>

00801c09 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	53                   	push   %ebx
  801c0d:	83 ec 04             	sub    $0x4,%esp
  801c10:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c1b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c21:	7f 2e                	jg     801c51 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c23:	83 ec 04             	sub    $0x4,%esp
  801c26:	53                   	push   %ebx
  801c27:	ff 75 0c             	pushl  0xc(%ebp)
  801c2a:	68 0c 60 80 00       	push   $0x80600c
  801c2f:	e8 91 ee ff ff       	call   800ac5 <memmove>
	nsipcbuf.send.req_size = size;
  801c34:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c3a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c3d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c42:	b8 08 00 00 00       	mov    $0x8,%eax
  801c47:	e8 eb fd ff ff       	call   801a37 <nsipc>
}
  801c4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    
	assert(size < 1600);
  801c51:	68 44 2a 80 00       	push   $0x802a44
  801c56:	68 eb 29 80 00       	push   $0x8029eb
  801c5b:	6a 6d                	push   $0x6d
  801c5d:	68 38 2a 80 00       	push   $0x802a38
  801c62:	e8 ed 04 00 00       	call   802154 <_panic>

00801c67 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c78:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c80:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c85:	b8 09 00 00 00       	mov    $0x9,%eax
  801c8a:	e8 a8 fd ff ff       	call   801a37 <nsipc>
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	56                   	push   %esi
  801c95:	53                   	push   %ebx
  801c96:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c99:	83 ec 0c             	sub    $0xc,%esp
  801c9c:	ff 75 08             	pushl  0x8(%ebp)
  801c9f:	e8 6a f3 ff ff       	call   80100e <fd2data>
  801ca4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ca6:	83 c4 08             	add    $0x8,%esp
  801ca9:	68 50 2a 80 00       	push   $0x802a50
  801cae:	53                   	push   %ebx
  801caf:	e8 83 ec ff ff       	call   800937 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cb4:	8b 46 04             	mov    0x4(%esi),%eax
  801cb7:	2b 06                	sub    (%esi),%eax
  801cb9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cbf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cc6:	00 00 00 
	stat->st_dev = &devpipe;
  801cc9:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cd0:	30 80 00 
	return 0;
}
  801cd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cdb:	5b                   	pop    %ebx
  801cdc:	5e                   	pop    %esi
  801cdd:	5d                   	pop    %ebp
  801cde:	c3                   	ret    

00801cdf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	53                   	push   %ebx
  801ce3:	83 ec 0c             	sub    $0xc,%esp
  801ce6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ce9:	53                   	push   %ebx
  801cea:	6a 00                	push   $0x0
  801cec:	e8 bd f0 ff ff       	call   800dae <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cf1:	89 1c 24             	mov    %ebx,(%esp)
  801cf4:	e8 15 f3 ff ff       	call   80100e <fd2data>
  801cf9:	83 c4 08             	add    $0x8,%esp
  801cfc:	50                   	push   %eax
  801cfd:	6a 00                	push   $0x0
  801cff:	e8 aa f0 ff ff       	call   800dae <sys_page_unmap>
}
  801d04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <_pipeisclosed>:
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	57                   	push   %edi
  801d0d:	56                   	push   %esi
  801d0e:	53                   	push   %ebx
  801d0f:	83 ec 1c             	sub    $0x1c,%esp
  801d12:	89 c7                	mov    %eax,%edi
  801d14:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d16:	a1 08 40 80 00       	mov    0x804008,%eax
  801d1b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d1e:	83 ec 0c             	sub    $0xc,%esp
  801d21:	57                   	push   %edi
  801d22:	e8 8a 05 00 00       	call   8022b1 <pageref>
  801d27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d2a:	89 34 24             	mov    %esi,(%esp)
  801d2d:	e8 7f 05 00 00       	call   8022b1 <pageref>
		nn = thisenv->env_runs;
  801d32:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d38:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d3b:	83 c4 10             	add    $0x10,%esp
  801d3e:	39 cb                	cmp    %ecx,%ebx
  801d40:	74 1b                	je     801d5d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d42:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d45:	75 cf                	jne    801d16 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d47:	8b 42 58             	mov    0x58(%edx),%eax
  801d4a:	6a 01                	push   $0x1
  801d4c:	50                   	push   %eax
  801d4d:	53                   	push   %ebx
  801d4e:	68 57 2a 80 00       	push   $0x802a57
  801d53:	e8 80 e4 ff ff       	call   8001d8 <cprintf>
  801d58:	83 c4 10             	add    $0x10,%esp
  801d5b:	eb b9                	jmp    801d16 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d5d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d60:	0f 94 c0             	sete   %al
  801d63:	0f b6 c0             	movzbl %al,%eax
}
  801d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d69:	5b                   	pop    %ebx
  801d6a:	5e                   	pop    %esi
  801d6b:	5f                   	pop    %edi
  801d6c:	5d                   	pop    %ebp
  801d6d:	c3                   	ret    

00801d6e <devpipe_write>:
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	57                   	push   %edi
  801d72:	56                   	push   %esi
  801d73:	53                   	push   %ebx
  801d74:	83 ec 28             	sub    $0x28,%esp
  801d77:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d7a:	56                   	push   %esi
  801d7b:	e8 8e f2 ff ff       	call   80100e <fd2data>
  801d80:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d82:	83 c4 10             	add    $0x10,%esp
  801d85:	bf 00 00 00 00       	mov    $0x0,%edi
  801d8a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d8d:	74 4f                	je     801dde <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d8f:	8b 43 04             	mov    0x4(%ebx),%eax
  801d92:	8b 0b                	mov    (%ebx),%ecx
  801d94:	8d 51 20             	lea    0x20(%ecx),%edx
  801d97:	39 d0                	cmp    %edx,%eax
  801d99:	72 14                	jb     801daf <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d9b:	89 da                	mov    %ebx,%edx
  801d9d:	89 f0                	mov    %esi,%eax
  801d9f:	e8 65 ff ff ff       	call   801d09 <_pipeisclosed>
  801da4:	85 c0                	test   %eax,%eax
  801da6:	75 3b                	jne    801de3 <devpipe_write+0x75>
			sys_yield();
  801da8:	e8 5d ef ff ff       	call   800d0a <sys_yield>
  801dad:	eb e0                	jmp    801d8f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801daf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801db6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801db9:	89 c2                	mov    %eax,%edx
  801dbb:	c1 fa 1f             	sar    $0x1f,%edx
  801dbe:	89 d1                	mov    %edx,%ecx
  801dc0:	c1 e9 1b             	shr    $0x1b,%ecx
  801dc3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dc6:	83 e2 1f             	and    $0x1f,%edx
  801dc9:	29 ca                	sub    %ecx,%edx
  801dcb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dcf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dd3:	83 c0 01             	add    $0x1,%eax
  801dd6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dd9:	83 c7 01             	add    $0x1,%edi
  801ddc:	eb ac                	jmp    801d8a <devpipe_write+0x1c>
	return i;
  801dde:	8b 45 10             	mov    0x10(%ebp),%eax
  801de1:	eb 05                	jmp    801de8 <devpipe_write+0x7a>
				return 0;
  801de3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801deb:	5b                   	pop    %ebx
  801dec:	5e                   	pop    %esi
  801ded:	5f                   	pop    %edi
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    

00801df0 <devpipe_read>:
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	57                   	push   %edi
  801df4:	56                   	push   %esi
  801df5:	53                   	push   %ebx
  801df6:	83 ec 18             	sub    $0x18,%esp
  801df9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dfc:	57                   	push   %edi
  801dfd:	e8 0c f2 ff ff       	call   80100e <fd2data>
  801e02:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e04:	83 c4 10             	add    $0x10,%esp
  801e07:	be 00 00 00 00       	mov    $0x0,%esi
  801e0c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e0f:	75 14                	jne    801e25 <devpipe_read+0x35>
	return i;
  801e11:	8b 45 10             	mov    0x10(%ebp),%eax
  801e14:	eb 02                	jmp    801e18 <devpipe_read+0x28>
				return i;
  801e16:	89 f0                	mov    %esi,%eax
}
  801e18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1b:	5b                   	pop    %ebx
  801e1c:	5e                   	pop    %esi
  801e1d:	5f                   	pop    %edi
  801e1e:	5d                   	pop    %ebp
  801e1f:	c3                   	ret    
			sys_yield();
  801e20:	e8 e5 ee ff ff       	call   800d0a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e25:	8b 03                	mov    (%ebx),%eax
  801e27:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e2a:	75 18                	jne    801e44 <devpipe_read+0x54>
			if (i > 0)
  801e2c:	85 f6                	test   %esi,%esi
  801e2e:	75 e6                	jne    801e16 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e30:	89 da                	mov    %ebx,%edx
  801e32:	89 f8                	mov    %edi,%eax
  801e34:	e8 d0 fe ff ff       	call   801d09 <_pipeisclosed>
  801e39:	85 c0                	test   %eax,%eax
  801e3b:	74 e3                	je     801e20 <devpipe_read+0x30>
				return 0;
  801e3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e42:	eb d4                	jmp    801e18 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e44:	99                   	cltd   
  801e45:	c1 ea 1b             	shr    $0x1b,%edx
  801e48:	01 d0                	add    %edx,%eax
  801e4a:	83 e0 1f             	and    $0x1f,%eax
  801e4d:	29 d0                	sub    %edx,%eax
  801e4f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e57:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e5a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e5d:	83 c6 01             	add    $0x1,%esi
  801e60:	eb aa                	jmp    801e0c <devpipe_read+0x1c>

00801e62 <pipe>:
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	56                   	push   %esi
  801e66:	53                   	push   %ebx
  801e67:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e6d:	50                   	push   %eax
  801e6e:	e8 b2 f1 ff ff       	call   801025 <fd_alloc>
  801e73:	89 c3                	mov    %eax,%ebx
  801e75:	83 c4 10             	add    $0x10,%esp
  801e78:	85 c0                	test   %eax,%eax
  801e7a:	0f 88 23 01 00 00    	js     801fa3 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e80:	83 ec 04             	sub    $0x4,%esp
  801e83:	68 07 04 00 00       	push   $0x407
  801e88:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8b:	6a 00                	push   $0x0
  801e8d:	e8 97 ee ff ff       	call   800d29 <sys_page_alloc>
  801e92:	89 c3                	mov    %eax,%ebx
  801e94:	83 c4 10             	add    $0x10,%esp
  801e97:	85 c0                	test   %eax,%eax
  801e99:	0f 88 04 01 00 00    	js     801fa3 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e9f:	83 ec 0c             	sub    $0xc,%esp
  801ea2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ea5:	50                   	push   %eax
  801ea6:	e8 7a f1 ff ff       	call   801025 <fd_alloc>
  801eab:	89 c3                	mov    %eax,%ebx
  801ead:	83 c4 10             	add    $0x10,%esp
  801eb0:	85 c0                	test   %eax,%eax
  801eb2:	0f 88 db 00 00 00    	js     801f93 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb8:	83 ec 04             	sub    $0x4,%esp
  801ebb:	68 07 04 00 00       	push   $0x407
  801ec0:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec3:	6a 00                	push   $0x0
  801ec5:	e8 5f ee ff ff       	call   800d29 <sys_page_alloc>
  801eca:	89 c3                	mov    %eax,%ebx
  801ecc:	83 c4 10             	add    $0x10,%esp
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	0f 88 bc 00 00 00    	js     801f93 <pipe+0x131>
	va = fd2data(fd0);
  801ed7:	83 ec 0c             	sub    $0xc,%esp
  801eda:	ff 75 f4             	pushl  -0xc(%ebp)
  801edd:	e8 2c f1 ff ff       	call   80100e <fd2data>
  801ee2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee4:	83 c4 0c             	add    $0xc,%esp
  801ee7:	68 07 04 00 00       	push   $0x407
  801eec:	50                   	push   %eax
  801eed:	6a 00                	push   $0x0
  801eef:	e8 35 ee ff ff       	call   800d29 <sys_page_alloc>
  801ef4:	89 c3                	mov    %eax,%ebx
  801ef6:	83 c4 10             	add    $0x10,%esp
  801ef9:	85 c0                	test   %eax,%eax
  801efb:	0f 88 82 00 00 00    	js     801f83 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f01:	83 ec 0c             	sub    $0xc,%esp
  801f04:	ff 75 f0             	pushl  -0x10(%ebp)
  801f07:	e8 02 f1 ff ff       	call   80100e <fd2data>
  801f0c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f13:	50                   	push   %eax
  801f14:	6a 00                	push   $0x0
  801f16:	56                   	push   %esi
  801f17:	6a 00                	push   $0x0
  801f19:	e8 4e ee ff ff       	call   800d6c <sys_page_map>
  801f1e:	89 c3                	mov    %eax,%ebx
  801f20:	83 c4 20             	add    $0x20,%esp
  801f23:	85 c0                	test   %eax,%eax
  801f25:	78 4e                	js     801f75 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f27:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f34:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f3e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f43:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f4a:	83 ec 0c             	sub    $0xc,%esp
  801f4d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f50:	e8 a9 f0 ff ff       	call   800ffe <fd2num>
  801f55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f58:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f5a:	83 c4 04             	add    $0x4,%esp
  801f5d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f60:	e8 99 f0 ff ff       	call   800ffe <fd2num>
  801f65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f68:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f6b:	83 c4 10             	add    $0x10,%esp
  801f6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f73:	eb 2e                	jmp    801fa3 <pipe+0x141>
	sys_page_unmap(0, va);
  801f75:	83 ec 08             	sub    $0x8,%esp
  801f78:	56                   	push   %esi
  801f79:	6a 00                	push   $0x0
  801f7b:	e8 2e ee ff ff       	call   800dae <sys_page_unmap>
  801f80:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f83:	83 ec 08             	sub    $0x8,%esp
  801f86:	ff 75 f0             	pushl  -0x10(%ebp)
  801f89:	6a 00                	push   $0x0
  801f8b:	e8 1e ee ff ff       	call   800dae <sys_page_unmap>
  801f90:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f93:	83 ec 08             	sub    $0x8,%esp
  801f96:	ff 75 f4             	pushl  -0xc(%ebp)
  801f99:	6a 00                	push   $0x0
  801f9b:	e8 0e ee ff ff       	call   800dae <sys_page_unmap>
  801fa0:	83 c4 10             	add    $0x10,%esp
}
  801fa3:	89 d8                	mov    %ebx,%eax
  801fa5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fa8:	5b                   	pop    %ebx
  801fa9:	5e                   	pop    %esi
  801faa:	5d                   	pop    %ebp
  801fab:	c3                   	ret    

00801fac <pipeisclosed>:
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fb2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb5:	50                   	push   %eax
  801fb6:	ff 75 08             	pushl  0x8(%ebp)
  801fb9:	e8 b9 f0 ff ff       	call   801077 <fd_lookup>
  801fbe:	83 c4 10             	add    $0x10,%esp
  801fc1:	85 c0                	test   %eax,%eax
  801fc3:	78 18                	js     801fdd <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fc5:	83 ec 0c             	sub    $0xc,%esp
  801fc8:	ff 75 f4             	pushl  -0xc(%ebp)
  801fcb:	e8 3e f0 ff ff       	call   80100e <fd2data>
	return _pipeisclosed(fd, p);
  801fd0:	89 c2                	mov    %eax,%edx
  801fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd5:	e8 2f fd ff ff       	call   801d09 <_pipeisclosed>
  801fda:	83 c4 10             	add    $0x10,%esp
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe4:	c3                   	ret    

00801fe5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801feb:	68 6f 2a 80 00       	push   $0x802a6f
  801ff0:	ff 75 0c             	pushl  0xc(%ebp)
  801ff3:	e8 3f e9 ff ff       	call   800937 <strcpy>
	return 0;
}
  801ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <devcons_write>:
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	57                   	push   %edi
  802003:	56                   	push   %esi
  802004:	53                   	push   %ebx
  802005:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80200b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802010:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802016:	3b 75 10             	cmp    0x10(%ebp),%esi
  802019:	73 31                	jae    80204c <devcons_write+0x4d>
		m = n - tot;
  80201b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80201e:	29 f3                	sub    %esi,%ebx
  802020:	83 fb 7f             	cmp    $0x7f,%ebx
  802023:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802028:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80202b:	83 ec 04             	sub    $0x4,%esp
  80202e:	53                   	push   %ebx
  80202f:	89 f0                	mov    %esi,%eax
  802031:	03 45 0c             	add    0xc(%ebp),%eax
  802034:	50                   	push   %eax
  802035:	57                   	push   %edi
  802036:	e8 8a ea ff ff       	call   800ac5 <memmove>
		sys_cputs(buf, m);
  80203b:	83 c4 08             	add    $0x8,%esp
  80203e:	53                   	push   %ebx
  80203f:	57                   	push   %edi
  802040:	e8 28 ec ff ff       	call   800c6d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802045:	01 de                	add    %ebx,%esi
  802047:	83 c4 10             	add    $0x10,%esp
  80204a:	eb ca                	jmp    802016 <devcons_write+0x17>
}
  80204c:	89 f0                	mov    %esi,%eax
  80204e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802051:	5b                   	pop    %ebx
  802052:	5e                   	pop    %esi
  802053:	5f                   	pop    %edi
  802054:	5d                   	pop    %ebp
  802055:	c3                   	ret    

00802056 <devcons_read>:
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 08             	sub    $0x8,%esp
  80205c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802061:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802065:	74 21                	je     802088 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802067:	e8 1f ec ff ff       	call   800c8b <sys_cgetc>
  80206c:	85 c0                	test   %eax,%eax
  80206e:	75 07                	jne    802077 <devcons_read+0x21>
		sys_yield();
  802070:	e8 95 ec ff ff       	call   800d0a <sys_yield>
  802075:	eb f0                	jmp    802067 <devcons_read+0x11>
	if (c < 0)
  802077:	78 0f                	js     802088 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802079:	83 f8 04             	cmp    $0x4,%eax
  80207c:	74 0c                	je     80208a <devcons_read+0x34>
	*(char*)vbuf = c;
  80207e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802081:	88 02                	mov    %al,(%edx)
	return 1;
  802083:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802088:	c9                   	leave  
  802089:	c3                   	ret    
		return 0;
  80208a:	b8 00 00 00 00       	mov    $0x0,%eax
  80208f:	eb f7                	jmp    802088 <devcons_read+0x32>

00802091 <cputchar>:
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
  802094:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80209d:	6a 01                	push   $0x1
  80209f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020a2:	50                   	push   %eax
  8020a3:	e8 c5 eb ff ff       	call   800c6d <sys_cputs>
}
  8020a8:	83 c4 10             	add    $0x10,%esp
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <getchar>:
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020b3:	6a 01                	push   $0x1
  8020b5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020b8:	50                   	push   %eax
  8020b9:	6a 00                	push   $0x0
  8020bb:	e8 27 f2 ff ff       	call   8012e7 <read>
	if (r < 0)
  8020c0:	83 c4 10             	add    $0x10,%esp
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	78 06                	js     8020cd <getchar+0x20>
	if (r < 1)
  8020c7:	74 06                	je     8020cf <getchar+0x22>
	return c;
  8020c9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    
		return -E_EOF;
  8020cf:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020d4:	eb f7                	jmp    8020cd <getchar+0x20>

008020d6 <iscons>:
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020df:	50                   	push   %eax
  8020e0:	ff 75 08             	pushl  0x8(%ebp)
  8020e3:	e8 8f ef ff ff       	call   801077 <fd_lookup>
  8020e8:	83 c4 10             	add    $0x10,%esp
  8020eb:	85 c0                	test   %eax,%eax
  8020ed:	78 11                	js     802100 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020f8:	39 10                	cmp    %edx,(%eax)
  8020fa:	0f 94 c0             	sete   %al
  8020fd:	0f b6 c0             	movzbl %al,%eax
}
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <opencons>:
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
  802105:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802108:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80210b:	50                   	push   %eax
  80210c:	e8 14 ef ff ff       	call   801025 <fd_alloc>
  802111:	83 c4 10             	add    $0x10,%esp
  802114:	85 c0                	test   %eax,%eax
  802116:	78 3a                	js     802152 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802118:	83 ec 04             	sub    $0x4,%esp
  80211b:	68 07 04 00 00       	push   $0x407
  802120:	ff 75 f4             	pushl  -0xc(%ebp)
  802123:	6a 00                	push   $0x0
  802125:	e8 ff eb ff ff       	call   800d29 <sys_page_alloc>
  80212a:	83 c4 10             	add    $0x10,%esp
  80212d:	85 c0                	test   %eax,%eax
  80212f:	78 21                	js     802152 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802134:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80213a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80213c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802146:	83 ec 0c             	sub    $0xc,%esp
  802149:	50                   	push   %eax
  80214a:	e8 af ee ff ff       	call   800ffe <fd2num>
  80214f:	83 c4 10             	add    $0x10,%esp
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	56                   	push   %esi
  802158:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802159:	a1 08 40 80 00       	mov    0x804008,%eax
  80215e:	8b 40 48             	mov    0x48(%eax),%eax
  802161:	83 ec 04             	sub    $0x4,%esp
  802164:	68 a0 2a 80 00       	push   $0x802aa0
  802169:	50                   	push   %eax
  80216a:	68 98 25 80 00       	push   $0x802598
  80216f:	e8 64 e0 ff ff       	call   8001d8 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802174:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802177:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80217d:	e8 69 eb ff ff       	call   800ceb <sys_getenvid>
  802182:	83 c4 04             	add    $0x4,%esp
  802185:	ff 75 0c             	pushl  0xc(%ebp)
  802188:	ff 75 08             	pushl  0x8(%ebp)
  80218b:	56                   	push   %esi
  80218c:	50                   	push   %eax
  80218d:	68 7c 2a 80 00       	push   $0x802a7c
  802192:	e8 41 e0 ff ff       	call   8001d8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802197:	83 c4 18             	add    $0x18,%esp
  80219a:	53                   	push   %ebx
  80219b:	ff 75 10             	pushl  0x10(%ebp)
  80219e:	e8 e4 df ff ff       	call   800187 <vcprintf>
	cprintf("\n");
  8021a3:	c7 04 24 5c 25 80 00 	movl   $0x80255c,(%esp)
  8021aa:	e8 29 e0 ff ff       	call   8001d8 <cprintf>
  8021af:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021b2:	cc                   	int3   
  8021b3:	eb fd                	jmp    8021b2 <_panic+0x5e>

008021b5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
  8021b8:	56                   	push   %esi
  8021b9:	53                   	push   %ebx
  8021ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8021bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021c3:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021c5:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021ca:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021cd:	83 ec 0c             	sub    $0xc,%esp
  8021d0:	50                   	push   %eax
  8021d1:	e8 03 ed ff ff       	call   800ed9 <sys_ipc_recv>
	if(ret < 0){
  8021d6:	83 c4 10             	add    $0x10,%esp
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	78 2b                	js     802208 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021dd:	85 f6                	test   %esi,%esi
  8021df:	74 0a                	je     8021eb <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8021e1:	a1 08 40 80 00       	mov    0x804008,%eax
  8021e6:	8b 40 74             	mov    0x74(%eax),%eax
  8021e9:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021eb:	85 db                	test   %ebx,%ebx
  8021ed:	74 0a                	je     8021f9 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8021ef:	a1 08 40 80 00       	mov    0x804008,%eax
  8021f4:	8b 40 78             	mov    0x78(%eax),%eax
  8021f7:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8021f9:	a1 08 40 80 00       	mov    0x804008,%eax
  8021fe:	8b 40 70             	mov    0x70(%eax),%eax
}
  802201:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802204:	5b                   	pop    %ebx
  802205:	5e                   	pop    %esi
  802206:	5d                   	pop    %ebp
  802207:	c3                   	ret    
		if(from_env_store)
  802208:	85 f6                	test   %esi,%esi
  80220a:	74 06                	je     802212 <ipc_recv+0x5d>
			*from_env_store = 0;
  80220c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802212:	85 db                	test   %ebx,%ebx
  802214:	74 eb                	je     802201 <ipc_recv+0x4c>
			*perm_store = 0;
  802216:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80221c:	eb e3                	jmp    802201 <ipc_recv+0x4c>

0080221e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	57                   	push   %edi
  802222:	56                   	push   %esi
  802223:	53                   	push   %ebx
  802224:	83 ec 0c             	sub    $0xc,%esp
  802227:	8b 7d 08             	mov    0x8(%ebp),%edi
  80222a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80222d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802230:	85 db                	test   %ebx,%ebx
  802232:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802237:	0f 44 d8             	cmove  %eax,%ebx
  80223a:	eb 05                	jmp    802241 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80223c:	e8 c9 ea ff ff       	call   800d0a <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802241:	ff 75 14             	pushl  0x14(%ebp)
  802244:	53                   	push   %ebx
  802245:	56                   	push   %esi
  802246:	57                   	push   %edi
  802247:	e8 6a ec ff ff       	call   800eb6 <sys_ipc_try_send>
  80224c:	83 c4 10             	add    $0x10,%esp
  80224f:	85 c0                	test   %eax,%eax
  802251:	74 1b                	je     80226e <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802253:	79 e7                	jns    80223c <ipc_send+0x1e>
  802255:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802258:	74 e2                	je     80223c <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80225a:	83 ec 04             	sub    $0x4,%esp
  80225d:	68 a7 2a 80 00       	push   $0x802aa7
  802262:	6a 46                	push   $0x46
  802264:	68 bc 2a 80 00       	push   $0x802abc
  802269:	e8 e6 fe ff ff       	call   802154 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80226e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802271:	5b                   	pop    %ebx
  802272:	5e                   	pop    %esi
  802273:	5f                   	pop    %edi
  802274:	5d                   	pop    %ebp
  802275:	c3                   	ret    

00802276 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
  802279:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80227c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802281:	89 c2                	mov    %eax,%edx
  802283:	c1 e2 07             	shl    $0x7,%edx
  802286:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80228c:	8b 52 50             	mov    0x50(%edx),%edx
  80228f:	39 ca                	cmp    %ecx,%edx
  802291:	74 11                	je     8022a4 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802293:	83 c0 01             	add    $0x1,%eax
  802296:	3d 00 04 00 00       	cmp    $0x400,%eax
  80229b:	75 e4                	jne    802281 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80229d:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a2:	eb 0b                	jmp    8022af <ipc_find_env+0x39>
			return envs[i].env_id;
  8022a4:	c1 e0 07             	shl    $0x7,%eax
  8022a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022ac:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022af:	5d                   	pop    %ebp
  8022b0:	c3                   	ret    

008022b1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022b7:	89 d0                	mov    %edx,%eax
  8022b9:	c1 e8 16             	shr    $0x16,%eax
  8022bc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022c3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022c8:	f6 c1 01             	test   $0x1,%cl
  8022cb:	74 1d                	je     8022ea <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022cd:	c1 ea 0c             	shr    $0xc,%edx
  8022d0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022d7:	f6 c2 01             	test   $0x1,%dl
  8022da:	74 0e                	je     8022ea <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022dc:	c1 ea 0c             	shr    $0xc,%edx
  8022df:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022e6:	ef 
  8022e7:	0f b7 c0             	movzwl %ax,%eax
}
  8022ea:	5d                   	pop    %ebp
  8022eb:	c3                   	ret    
  8022ec:	66 90                	xchg   %ax,%ax
  8022ee:	66 90                	xchg   %ax,%ax

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
