
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
  8000b9:	68 60 25 80 00       	push   $0x802560
  8000be:	e8 15 01 00 00       	call   8001d8 <cprintf>
	cprintf("before umain\n");
  8000c3:	c7 04 24 7e 25 80 00 	movl   $0x80257e,(%esp)
  8000ca:	e8 09 01 00 00       	call   8001d8 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000cf:	83 c4 08             	add    $0x8,%esp
  8000d2:	ff 75 0c             	pushl  0xc(%ebp)
  8000d5:	ff 75 08             	pushl  0x8(%ebp)
  8000d8:	e8 56 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000dd:	c7 04 24 8c 25 80 00 	movl   $0x80258c,(%esp)
  8000e4:	e8 ef 00 00 00       	call   8001d8 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8000e9:	a1 08 40 80 00       	mov    0x804008,%eax
  8000ee:	8b 40 48             	mov    0x48(%eax),%eax
  8000f1:	83 c4 08             	add    $0x8,%esp
  8000f4:	50                   	push   %eax
  8000f5:	68 99 25 80 00       	push   $0x802599
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
  80011d:	68 c4 25 80 00       	push   $0x8025c4
  800122:	50                   	push   %eax
  800123:	68 b8 25 80 00       	push   $0x8025b8
  800128:	e8 ab 00 00 00       	call   8001d8 <cprintf>
	close_all();
  80012d:	e8 c4 10 00 00       	call   8011f6 <close_all>
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
  800285:	e8 86 20 00 00       	call   802310 <__udivdi3>
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
  8002ae:	e8 6d 21 00 00       	call   802420 <__umoddi3>
  8002b3:	83 c4 14             	add    $0x14,%esp
  8002b6:	0f be 80 c9 25 80 00 	movsbl 0x8025c9(%eax),%eax
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
  80035f:	ff 24 85 a0 27 80 00 	jmp    *0x8027a0(,%eax,4)
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
  80042a:	8b 14 85 00 29 80 00 	mov    0x802900(,%eax,4),%edx
  800431:	85 d2                	test   %edx,%edx
  800433:	74 18                	je     80044d <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800435:	52                   	push   %edx
  800436:	68 1d 2a 80 00       	push   $0x802a1d
  80043b:	53                   	push   %ebx
  80043c:	56                   	push   %esi
  80043d:	e8 a6 fe ff ff       	call   8002e8 <printfmt>
  800442:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800445:	89 7d 14             	mov    %edi,0x14(%ebp)
  800448:	e9 fe 02 00 00       	jmp    80074b <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80044d:	50                   	push   %eax
  80044e:	68 e1 25 80 00       	push   $0x8025e1
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
  800475:	b8 da 25 80 00       	mov    $0x8025da,%eax
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
  80080d:	bf fd 26 80 00       	mov    $0x8026fd,%edi
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
  800839:	bf 35 27 80 00       	mov    $0x802735,%edi
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
  800cda:	68 48 29 80 00       	push   $0x802948
  800cdf:	6a 43                	push   $0x43
  800ce1:	68 65 29 80 00       	push   $0x802965
  800ce6:	e8 89 14 00 00       	call   802174 <_panic>

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
  800d5b:	68 48 29 80 00       	push   $0x802948
  800d60:	6a 43                	push   $0x43
  800d62:	68 65 29 80 00       	push   $0x802965
  800d67:	e8 08 14 00 00       	call   802174 <_panic>

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
  800d9d:	68 48 29 80 00       	push   $0x802948
  800da2:	6a 43                	push   $0x43
  800da4:	68 65 29 80 00       	push   $0x802965
  800da9:	e8 c6 13 00 00       	call   802174 <_panic>

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
  800ddf:	68 48 29 80 00       	push   $0x802948
  800de4:	6a 43                	push   $0x43
  800de6:	68 65 29 80 00       	push   $0x802965
  800deb:	e8 84 13 00 00       	call   802174 <_panic>

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
  800e21:	68 48 29 80 00       	push   $0x802948
  800e26:	6a 43                	push   $0x43
  800e28:	68 65 29 80 00       	push   $0x802965
  800e2d:	e8 42 13 00 00       	call   802174 <_panic>

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
  800e63:	68 48 29 80 00       	push   $0x802948
  800e68:	6a 43                	push   $0x43
  800e6a:	68 65 29 80 00       	push   $0x802965
  800e6f:	e8 00 13 00 00       	call   802174 <_panic>

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
  800ea5:	68 48 29 80 00       	push   $0x802948
  800eaa:	6a 43                	push   $0x43
  800eac:	68 65 29 80 00       	push   $0x802965
  800eb1:	e8 be 12 00 00       	call   802174 <_panic>

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
  800f09:	68 48 29 80 00       	push   $0x802948
  800f0e:	6a 43                	push   $0x43
  800f10:	68 65 29 80 00       	push   $0x802965
  800f15:	e8 5a 12 00 00       	call   802174 <_panic>

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
  800fed:	68 48 29 80 00       	push   $0x802948
  800ff2:	6a 43                	push   $0x43
  800ff4:	68 65 29 80 00       	push   $0x802965
  800ff9:	e8 76 11 00 00       	call   802174 <_panic>

00800ffe <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	57                   	push   %edi
  801002:	56                   	push   %esi
  801003:	53                   	push   %ebx
	asm volatile("int %1\n"
  801004:	b9 00 00 00 00       	mov    $0x0,%ecx
  801009:	8b 55 08             	mov    0x8(%ebp),%edx
  80100c:	b8 14 00 00 00       	mov    $0x14,%eax
  801011:	89 cb                	mov    %ecx,%ebx
  801013:	89 cf                	mov    %ecx,%edi
  801015:	89 ce                	mov    %ecx,%esi
  801017:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801019:	5b                   	pop    %ebx
  80101a:	5e                   	pop    %esi
  80101b:	5f                   	pop    %edi
  80101c:	5d                   	pop    %ebp
  80101d:	c3                   	ret    

0080101e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	05 00 00 00 30       	add    $0x30000000,%eax
  801029:	c1 e8 0c             	shr    $0xc,%eax
}
  80102c:	5d                   	pop    %ebp
  80102d:	c3                   	ret    

0080102e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80102e:	55                   	push   %ebp
  80102f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801039:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80103e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801043:	5d                   	pop    %ebp
  801044:	c3                   	ret    

00801045 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80104d:	89 c2                	mov    %eax,%edx
  80104f:	c1 ea 16             	shr    $0x16,%edx
  801052:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801059:	f6 c2 01             	test   $0x1,%dl
  80105c:	74 2d                	je     80108b <fd_alloc+0x46>
  80105e:	89 c2                	mov    %eax,%edx
  801060:	c1 ea 0c             	shr    $0xc,%edx
  801063:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80106a:	f6 c2 01             	test   $0x1,%dl
  80106d:	74 1c                	je     80108b <fd_alloc+0x46>
  80106f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801074:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801079:	75 d2                	jne    80104d <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801084:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801089:	eb 0a                	jmp    801095 <fd_alloc+0x50>
			*fd_store = fd;
  80108b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801090:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801095:	5d                   	pop    %ebp
  801096:	c3                   	ret    

00801097 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80109d:	83 f8 1f             	cmp    $0x1f,%eax
  8010a0:	77 30                	ja     8010d2 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010a2:	c1 e0 0c             	shl    $0xc,%eax
  8010a5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010aa:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010b0:	f6 c2 01             	test   $0x1,%dl
  8010b3:	74 24                	je     8010d9 <fd_lookup+0x42>
  8010b5:	89 c2                	mov    %eax,%edx
  8010b7:	c1 ea 0c             	shr    $0xc,%edx
  8010ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010c1:	f6 c2 01             	test   $0x1,%dl
  8010c4:	74 1a                	je     8010e0 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c9:	89 02                	mov    %eax,(%edx)
	return 0;
  8010cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    
		return -E_INVAL;
  8010d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d7:	eb f7                	jmp    8010d0 <fd_lookup+0x39>
		return -E_INVAL;
  8010d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010de:	eb f0                	jmp    8010d0 <fd_lookup+0x39>
  8010e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e5:	eb e9                	jmp    8010d0 <fd_lookup+0x39>

008010e7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 08             	sub    $0x8,%esp
  8010ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f5:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010fa:	39 08                	cmp    %ecx,(%eax)
  8010fc:	74 38                	je     801136 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010fe:	83 c2 01             	add    $0x1,%edx
  801101:	8b 04 95 f0 29 80 00 	mov    0x8029f0(,%edx,4),%eax
  801108:	85 c0                	test   %eax,%eax
  80110a:	75 ee                	jne    8010fa <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80110c:	a1 08 40 80 00       	mov    0x804008,%eax
  801111:	8b 40 48             	mov    0x48(%eax),%eax
  801114:	83 ec 04             	sub    $0x4,%esp
  801117:	51                   	push   %ecx
  801118:	50                   	push   %eax
  801119:	68 74 29 80 00       	push   $0x802974
  80111e:	e8 b5 f0 ff ff       	call   8001d8 <cprintf>
	*dev = 0;
  801123:	8b 45 0c             	mov    0xc(%ebp),%eax
  801126:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80112c:	83 c4 10             	add    $0x10,%esp
  80112f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801134:	c9                   	leave  
  801135:	c3                   	ret    
			*dev = devtab[i];
  801136:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801139:	89 01                	mov    %eax,(%ecx)
			return 0;
  80113b:	b8 00 00 00 00       	mov    $0x0,%eax
  801140:	eb f2                	jmp    801134 <dev_lookup+0x4d>

00801142 <fd_close>:
{
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
  801145:	57                   	push   %edi
  801146:	56                   	push   %esi
  801147:	53                   	push   %ebx
  801148:	83 ec 24             	sub    $0x24,%esp
  80114b:	8b 75 08             	mov    0x8(%ebp),%esi
  80114e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801151:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801154:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801155:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80115b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80115e:	50                   	push   %eax
  80115f:	e8 33 ff ff ff       	call   801097 <fd_lookup>
  801164:	89 c3                	mov    %eax,%ebx
  801166:	83 c4 10             	add    $0x10,%esp
  801169:	85 c0                	test   %eax,%eax
  80116b:	78 05                	js     801172 <fd_close+0x30>
	    || fd != fd2)
  80116d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801170:	74 16                	je     801188 <fd_close+0x46>
		return (must_exist ? r : 0);
  801172:	89 f8                	mov    %edi,%eax
  801174:	84 c0                	test   %al,%al
  801176:	b8 00 00 00 00       	mov    $0x0,%eax
  80117b:	0f 44 d8             	cmove  %eax,%ebx
}
  80117e:	89 d8                	mov    %ebx,%eax
  801180:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801183:	5b                   	pop    %ebx
  801184:	5e                   	pop    %esi
  801185:	5f                   	pop    %edi
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801188:	83 ec 08             	sub    $0x8,%esp
  80118b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80118e:	50                   	push   %eax
  80118f:	ff 36                	pushl  (%esi)
  801191:	e8 51 ff ff ff       	call   8010e7 <dev_lookup>
  801196:	89 c3                	mov    %eax,%ebx
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	85 c0                	test   %eax,%eax
  80119d:	78 1a                	js     8011b9 <fd_close+0x77>
		if (dev->dev_close)
  80119f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011a2:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011a5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011aa:	85 c0                	test   %eax,%eax
  8011ac:	74 0b                	je     8011b9 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011ae:	83 ec 0c             	sub    $0xc,%esp
  8011b1:	56                   	push   %esi
  8011b2:	ff d0                	call   *%eax
  8011b4:	89 c3                	mov    %eax,%ebx
  8011b6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011b9:	83 ec 08             	sub    $0x8,%esp
  8011bc:	56                   	push   %esi
  8011bd:	6a 00                	push   $0x0
  8011bf:	e8 ea fb ff ff       	call   800dae <sys_page_unmap>
	return r;
  8011c4:	83 c4 10             	add    $0x10,%esp
  8011c7:	eb b5                	jmp    80117e <fd_close+0x3c>

008011c9 <close>:

int
close(int fdnum)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d2:	50                   	push   %eax
  8011d3:	ff 75 08             	pushl  0x8(%ebp)
  8011d6:	e8 bc fe ff ff       	call   801097 <fd_lookup>
  8011db:	83 c4 10             	add    $0x10,%esp
  8011de:	85 c0                	test   %eax,%eax
  8011e0:	79 02                	jns    8011e4 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    
		return fd_close(fd, 1);
  8011e4:	83 ec 08             	sub    $0x8,%esp
  8011e7:	6a 01                	push   $0x1
  8011e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011ec:	e8 51 ff ff ff       	call   801142 <fd_close>
  8011f1:	83 c4 10             	add    $0x10,%esp
  8011f4:	eb ec                	jmp    8011e2 <close+0x19>

008011f6 <close_all>:

void
close_all(void)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	53                   	push   %ebx
  8011fa:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011fd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801202:	83 ec 0c             	sub    $0xc,%esp
  801205:	53                   	push   %ebx
  801206:	e8 be ff ff ff       	call   8011c9 <close>
	for (i = 0; i < MAXFD; i++)
  80120b:	83 c3 01             	add    $0x1,%ebx
  80120e:	83 c4 10             	add    $0x10,%esp
  801211:	83 fb 20             	cmp    $0x20,%ebx
  801214:	75 ec                	jne    801202 <close_all+0xc>
}
  801216:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	57                   	push   %edi
  80121f:	56                   	push   %esi
  801220:	53                   	push   %ebx
  801221:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801224:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801227:	50                   	push   %eax
  801228:	ff 75 08             	pushl  0x8(%ebp)
  80122b:	e8 67 fe ff ff       	call   801097 <fd_lookup>
  801230:	89 c3                	mov    %eax,%ebx
  801232:	83 c4 10             	add    $0x10,%esp
  801235:	85 c0                	test   %eax,%eax
  801237:	0f 88 81 00 00 00    	js     8012be <dup+0xa3>
		return r;
	close(newfdnum);
  80123d:	83 ec 0c             	sub    $0xc,%esp
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	e8 81 ff ff ff       	call   8011c9 <close>

	newfd = INDEX2FD(newfdnum);
  801248:	8b 75 0c             	mov    0xc(%ebp),%esi
  80124b:	c1 e6 0c             	shl    $0xc,%esi
  80124e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801254:	83 c4 04             	add    $0x4,%esp
  801257:	ff 75 e4             	pushl  -0x1c(%ebp)
  80125a:	e8 cf fd ff ff       	call   80102e <fd2data>
  80125f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801261:	89 34 24             	mov    %esi,(%esp)
  801264:	e8 c5 fd ff ff       	call   80102e <fd2data>
  801269:	83 c4 10             	add    $0x10,%esp
  80126c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80126e:	89 d8                	mov    %ebx,%eax
  801270:	c1 e8 16             	shr    $0x16,%eax
  801273:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80127a:	a8 01                	test   $0x1,%al
  80127c:	74 11                	je     80128f <dup+0x74>
  80127e:	89 d8                	mov    %ebx,%eax
  801280:	c1 e8 0c             	shr    $0xc,%eax
  801283:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80128a:	f6 c2 01             	test   $0x1,%dl
  80128d:	75 39                	jne    8012c8 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80128f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801292:	89 d0                	mov    %edx,%eax
  801294:	c1 e8 0c             	shr    $0xc,%eax
  801297:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80129e:	83 ec 0c             	sub    $0xc,%esp
  8012a1:	25 07 0e 00 00       	and    $0xe07,%eax
  8012a6:	50                   	push   %eax
  8012a7:	56                   	push   %esi
  8012a8:	6a 00                	push   $0x0
  8012aa:	52                   	push   %edx
  8012ab:	6a 00                	push   $0x0
  8012ad:	e8 ba fa ff ff       	call   800d6c <sys_page_map>
  8012b2:	89 c3                	mov    %eax,%ebx
  8012b4:	83 c4 20             	add    $0x20,%esp
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	78 31                	js     8012ec <dup+0xd1>
		goto err;

	return newfdnum;
  8012bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012be:	89 d8                	mov    %ebx,%eax
  8012c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c3:	5b                   	pop    %ebx
  8012c4:	5e                   	pop    %esi
  8012c5:	5f                   	pop    %edi
  8012c6:	5d                   	pop    %ebp
  8012c7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012c8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012cf:	83 ec 0c             	sub    $0xc,%esp
  8012d2:	25 07 0e 00 00       	and    $0xe07,%eax
  8012d7:	50                   	push   %eax
  8012d8:	57                   	push   %edi
  8012d9:	6a 00                	push   $0x0
  8012db:	53                   	push   %ebx
  8012dc:	6a 00                	push   $0x0
  8012de:	e8 89 fa ff ff       	call   800d6c <sys_page_map>
  8012e3:	89 c3                	mov    %eax,%ebx
  8012e5:	83 c4 20             	add    $0x20,%esp
  8012e8:	85 c0                	test   %eax,%eax
  8012ea:	79 a3                	jns    80128f <dup+0x74>
	sys_page_unmap(0, newfd);
  8012ec:	83 ec 08             	sub    $0x8,%esp
  8012ef:	56                   	push   %esi
  8012f0:	6a 00                	push   $0x0
  8012f2:	e8 b7 fa ff ff       	call   800dae <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012f7:	83 c4 08             	add    $0x8,%esp
  8012fa:	57                   	push   %edi
  8012fb:	6a 00                	push   $0x0
  8012fd:	e8 ac fa ff ff       	call   800dae <sys_page_unmap>
	return r;
  801302:	83 c4 10             	add    $0x10,%esp
  801305:	eb b7                	jmp    8012be <dup+0xa3>

00801307 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	53                   	push   %ebx
  80130b:	83 ec 1c             	sub    $0x1c,%esp
  80130e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801311:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801314:	50                   	push   %eax
  801315:	53                   	push   %ebx
  801316:	e8 7c fd ff ff       	call   801097 <fd_lookup>
  80131b:	83 c4 10             	add    $0x10,%esp
  80131e:	85 c0                	test   %eax,%eax
  801320:	78 3f                	js     801361 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801322:	83 ec 08             	sub    $0x8,%esp
  801325:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801328:	50                   	push   %eax
  801329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80132c:	ff 30                	pushl  (%eax)
  80132e:	e8 b4 fd ff ff       	call   8010e7 <dev_lookup>
  801333:	83 c4 10             	add    $0x10,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	78 27                	js     801361 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80133a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80133d:	8b 42 08             	mov    0x8(%edx),%eax
  801340:	83 e0 03             	and    $0x3,%eax
  801343:	83 f8 01             	cmp    $0x1,%eax
  801346:	74 1e                	je     801366 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134b:	8b 40 08             	mov    0x8(%eax),%eax
  80134e:	85 c0                	test   %eax,%eax
  801350:	74 35                	je     801387 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801352:	83 ec 04             	sub    $0x4,%esp
  801355:	ff 75 10             	pushl  0x10(%ebp)
  801358:	ff 75 0c             	pushl  0xc(%ebp)
  80135b:	52                   	push   %edx
  80135c:	ff d0                	call   *%eax
  80135e:	83 c4 10             	add    $0x10,%esp
}
  801361:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801364:	c9                   	leave  
  801365:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801366:	a1 08 40 80 00       	mov    0x804008,%eax
  80136b:	8b 40 48             	mov    0x48(%eax),%eax
  80136e:	83 ec 04             	sub    $0x4,%esp
  801371:	53                   	push   %ebx
  801372:	50                   	push   %eax
  801373:	68 b5 29 80 00       	push   $0x8029b5
  801378:	e8 5b ee ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801385:	eb da                	jmp    801361 <read+0x5a>
		return -E_NOT_SUPP;
  801387:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80138c:	eb d3                	jmp    801361 <read+0x5a>

0080138e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	57                   	push   %edi
  801392:	56                   	push   %esi
  801393:	53                   	push   %ebx
  801394:	83 ec 0c             	sub    $0xc,%esp
  801397:	8b 7d 08             	mov    0x8(%ebp),%edi
  80139a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80139d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a2:	39 f3                	cmp    %esi,%ebx
  8013a4:	73 23                	jae    8013c9 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013a6:	83 ec 04             	sub    $0x4,%esp
  8013a9:	89 f0                	mov    %esi,%eax
  8013ab:	29 d8                	sub    %ebx,%eax
  8013ad:	50                   	push   %eax
  8013ae:	89 d8                	mov    %ebx,%eax
  8013b0:	03 45 0c             	add    0xc(%ebp),%eax
  8013b3:	50                   	push   %eax
  8013b4:	57                   	push   %edi
  8013b5:	e8 4d ff ff ff       	call   801307 <read>
		if (m < 0)
  8013ba:	83 c4 10             	add    $0x10,%esp
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	78 06                	js     8013c7 <readn+0x39>
			return m;
		if (m == 0)
  8013c1:	74 06                	je     8013c9 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013c3:	01 c3                	add    %eax,%ebx
  8013c5:	eb db                	jmp    8013a2 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013c7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013c9:	89 d8                	mov    %ebx,%eax
  8013cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ce:	5b                   	pop    %ebx
  8013cf:	5e                   	pop    %esi
  8013d0:	5f                   	pop    %edi
  8013d1:	5d                   	pop    %ebp
  8013d2:	c3                   	ret    

008013d3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	53                   	push   %ebx
  8013d7:	83 ec 1c             	sub    $0x1c,%esp
  8013da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013e0:	50                   	push   %eax
  8013e1:	53                   	push   %ebx
  8013e2:	e8 b0 fc ff ff       	call   801097 <fd_lookup>
  8013e7:	83 c4 10             	add    $0x10,%esp
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	78 3a                	js     801428 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ee:	83 ec 08             	sub    $0x8,%esp
  8013f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f4:	50                   	push   %eax
  8013f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f8:	ff 30                	pushl  (%eax)
  8013fa:	e8 e8 fc ff ff       	call   8010e7 <dev_lookup>
  8013ff:	83 c4 10             	add    $0x10,%esp
  801402:	85 c0                	test   %eax,%eax
  801404:	78 22                	js     801428 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801409:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80140d:	74 1e                	je     80142d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80140f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801412:	8b 52 0c             	mov    0xc(%edx),%edx
  801415:	85 d2                	test   %edx,%edx
  801417:	74 35                	je     80144e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801419:	83 ec 04             	sub    $0x4,%esp
  80141c:	ff 75 10             	pushl  0x10(%ebp)
  80141f:	ff 75 0c             	pushl  0xc(%ebp)
  801422:	50                   	push   %eax
  801423:	ff d2                	call   *%edx
  801425:	83 c4 10             	add    $0x10,%esp
}
  801428:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80142d:	a1 08 40 80 00       	mov    0x804008,%eax
  801432:	8b 40 48             	mov    0x48(%eax),%eax
  801435:	83 ec 04             	sub    $0x4,%esp
  801438:	53                   	push   %ebx
  801439:	50                   	push   %eax
  80143a:	68 d1 29 80 00       	push   $0x8029d1
  80143f:	e8 94 ed ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  801444:	83 c4 10             	add    $0x10,%esp
  801447:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144c:	eb da                	jmp    801428 <write+0x55>
		return -E_NOT_SUPP;
  80144e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801453:	eb d3                	jmp    801428 <write+0x55>

00801455 <seek>:

int
seek(int fdnum, off_t offset)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80145b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145e:	50                   	push   %eax
  80145f:	ff 75 08             	pushl  0x8(%ebp)
  801462:	e8 30 fc ff ff       	call   801097 <fd_lookup>
  801467:	83 c4 10             	add    $0x10,%esp
  80146a:	85 c0                	test   %eax,%eax
  80146c:	78 0e                	js     80147c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80146e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801474:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	53                   	push   %ebx
  801482:	83 ec 1c             	sub    $0x1c,%esp
  801485:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801488:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80148b:	50                   	push   %eax
  80148c:	53                   	push   %ebx
  80148d:	e8 05 fc ff ff       	call   801097 <fd_lookup>
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	85 c0                	test   %eax,%eax
  801497:	78 37                	js     8014d0 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801499:	83 ec 08             	sub    $0x8,%esp
  80149c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80149f:	50                   	push   %eax
  8014a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a3:	ff 30                	pushl  (%eax)
  8014a5:	e8 3d fc ff ff       	call   8010e7 <dev_lookup>
  8014aa:	83 c4 10             	add    $0x10,%esp
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	78 1f                	js     8014d0 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014b8:	74 1b                	je     8014d5 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014bd:	8b 52 18             	mov    0x18(%edx),%edx
  8014c0:	85 d2                	test   %edx,%edx
  8014c2:	74 32                	je     8014f6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014c4:	83 ec 08             	sub    $0x8,%esp
  8014c7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ca:	50                   	push   %eax
  8014cb:	ff d2                	call   *%edx
  8014cd:	83 c4 10             	add    $0x10,%esp
}
  8014d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014d5:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014da:	8b 40 48             	mov    0x48(%eax),%eax
  8014dd:	83 ec 04             	sub    $0x4,%esp
  8014e0:	53                   	push   %ebx
  8014e1:	50                   	push   %eax
  8014e2:	68 94 29 80 00       	push   $0x802994
  8014e7:	e8 ec ec ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  8014ec:	83 c4 10             	add    $0x10,%esp
  8014ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f4:	eb da                	jmp    8014d0 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014f6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014fb:	eb d3                	jmp    8014d0 <ftruncate+0x52>

008014fd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
  801500:	53                   	push   %ebx
  801501:	83 ec 1c             	sub    $0x1c,%esp
  801504:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801507:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80150a:	50                   	push   %eax
  80150b:	ff 75 08             	pushl  0x8(%ebp)
  80150e:	e8 84 fb ff ff       	call   801097 <fd_lookup>
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	85 c0                	test   %eax,%eax
  801518:	78 4b                	js     801565 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80151a:	83 ec 08             	sub    $0x8,%esp
  80151d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801520:	50                   	push   %eax
  801521:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801524:	ff 30                	pushl  (%eax)
  801526:	e8 bc fb ff ff       	call   8010e7 <dev_lookup>
  80152b:	83 c4 10             	add    $0x10,%esp
  80152e:	85 c0                	test   %eax,%eax
  801530:	78 33                	js     801565 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801535:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801539:	74 2f                	je     80156a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80153b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80153e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801545:	00 00 00 
	stat->st_isdir = 0;
  801548:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80154f:	00 00 00 
	stat->st_dev = dev;
  801552:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801558:	83 ec 08             	sub    $0x8,%esp
  80155b:	53                   	push   %ebx
  80155c:	ff 75 f0             	pushl  -0x10(%ebp)
  80155f:	ff 50 14             	call   *0x14(%eax)
  801562:	83 c4 10             	add    $0x10,%esp
}
  801565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801568:	c9                   	leave  
  801569:	c3                   	ret    
		return -E_NOT_SUPP;
  80156a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80156f:	eb f4                	jmp    801565 <fstat+0x68>

00801571 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	56                   	push   %esi
  801575:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801576:	83 ec 08             	sub    $0x8,%esp
  801579:	6a 00                	push   $0x0
  80157b:	ff 75 08             	pushl  0x8(%ebp)
  80157e:	e8 22 02 00 00       	call   8017a5 <open>
  801583:	89 c3                	mov    %eax,%ebx
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	85 c0                	test   %eax,%eax
  80158a:	78 1b                	js     8015a7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80158c:	83 ec 08             	sub    $0x8,%esp
  80158f:	ff 75 0c             	pushl  0xc(%ebp)
  801592:	50                   	push   %eax
  801593:	e8 65 ff ff ff       	call   8014fd <fstat>
  801598:	89 c6                	mov    %eax,%esi
	close(fd);
  80159a:	89 1c 24             	mov    %ebx,(%esp)
  80159d:	e8 27 fc ff ff       	call   8011c9 <close>
	return r;
  8015a2:	83 c4 10             	add    $0x10,%esp
  8015a5:	89 f3                	mov    %esi,%ebx
}
  8015a7:	89 d8                	mov    %ebx,%eax
  8015a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ac:	5b                   	pop    %ebx
  8015ad:	5e                   	pop    %esi
  8015ae:	5d                   	pop    %ebp
  8015af:	c3                   	ret    

008015b0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	56                   	push   %esi
  8015b4:	53                   	push   %ebx
  8015b5:	89 c6                	mov    %eax,%esi
  8015b7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015b9:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015c0:	74 27                	je     8015e9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015c2:	6a 07                	push   $0x7
  8015c4:	68 00 50 80 00       	push   $0x805000
  8015c9:	56                   	push   %esi
  8015ca:	ff 35 00 40 80 00    	pushl  0x804000
  8015d0:	e8 69 0c 00 00       	call   80223e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015d5:	83 c4 0c             	add    $0xc,%esp
  8015d8:	6a 00                	push   $0x0
  8015da:	53                   	push   %ebx
  8015db:	6a 00                	push   $0x0
  8015dd:	e8 f3 0b 00 00       	call   8021d5 <ipc_recv>
}
  8015e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e5:	5b                   	pop    %ebx
  8015e6:	5e                   	pop    %esi
  8015e7:	5d                   	pop    %ebp
  8015e8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015e9:	83 ec 0c             	sub    $0xc,%esp
  8015ec:	6a 01                	push   $0x1
  8015ee:	e8 a3 0c 00 00       	call   802296 <ipc_find_env>
  8015f3:	a3 00 40 80 00       	mov    %eax,0x804000
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	eb c5                	jmp    8015c2 <fsipc+0x12>

008015fd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	8b 40 0c             	mov    0xc(%eax),%eax
  801609:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80160e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801611:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801616:	ba 00 00 00 00       	mov    $0x0,%edx
  80161b:	b8 02 00 00 00       	mov    $0x2,%eax
  801620:	e8 8b ff ff ff       	call   8015b0 <fsipc>
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <devfile_flush>:
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	8b 40 0c             	mov    0xc(%eax),%eax
  801633:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801638:	ba 00 00 00 00       	mov    $0x0,%edx
  80163d:	b8 06 00 00 00       	mov    $0x6,%eax
  801642:	e8 69 ff ff ff       	call   8015b0 <fsipc>
}
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <devfile_stat>:
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	53                   	push   %ebx
  80164d:	83 ec 04             	sub    $0x4,%esp
  801650:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	8b 40 0c             	mov    0xc(%eax),%eax
  801659:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80165e:	ba 00 00 00 00       	mov    $0x0,%edx
  801663:	b8 05 00 00 00       	mov    $0x5,%eax
  801668:	e8 43 ff ff ff       	call   8015b0 <fsipc>
  80166d:	85 c0                	test   %eax,%eax
  80166f:	78 2c                	js     80169d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801671:	83 ec 08             	sub    $0x8,%esp
  801674:	68 00 50 80 00       	push   $0x805000
  801679:	53                   	push   %ebx
  80167a:	e8 b8 f2 ff ff       	call   800937 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80167f:	a1 80 50 80 00       	mov    0x805080,%eax
  801684:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80168a:	a1 84 50 80 00       	mov    0x805084,%eax
  80168f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801695:	83 c4 10             	add    $0x10,%esp
  801698:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <devfile_write>:
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	53                   	push   %ebx
  8016a6:	83 ec 08             	sub    $0x8,%esp
  8016a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016b7:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016bd:	53                   	push   %ebx
  8016be:	ff 75 0c             	pushl  0xc(%ebp)
  8016c1:	68 08 50 80 00       	push   $0x805008
  8016c6:	e8 5c f4 ff ff       	call   800b27 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d0:	b8 04 00 00 00       	mov    $0x4,%eax
  8016d5:	e8 d6 fe ff ff       	call   8015b0 <fsipc>
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	78 0b                	js     8016ec <devfile_write+0x4a>
	assert(r <= n);
  8016e1:	39 d8                	cmp    %ebx,%eax
  8016e3:	77 0c                	ja     8016f1 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016e5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016ea:	7f 1e                	jg     80170a <devfile_write+0x68>
}
  8016ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    
	assert(r <= n);
  8016f1:	68 04 2a 80 00       	push   $0x802a04
  8016f6:	68 0b 2a 80 00       	push   $0x802a0b
  8016fb:	68 98 00 00 00       	push   $0x98
  801700:	68 20 2a 80 00       	push   $0x802a20
  801705:	e8 6a 0a 00 00       	call   802174 <_panic>
	assert(r <= PGSIZE);
  80170a:	68 2b 2a 80 00       	push   $0x802a2b
  80170f:	68 0b 2a 80 00       	push   $0x802a0b
  801714:	68 99 00 00 00       	push   $0x99
  801719:	68 20 2a 80 00       	push   $0x802a20
  80171e:	e8 51 0a 00 00       	call   802174 <_panic>

00801723 <devfile_read>:
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	56                   	push   %esi
  801727:	53                   	push   %ebx
  801728:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	8b 40 0c             	mov    0xc(%eax),%eax
  801731:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801736:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80173c:	ba 00 00 00 00       	mov    $0x0,%edx
  801741:	b8 03 00 00 00       	mov    $0x3,%eax
  801746:	e8 65 fe ff ff       	call   8015b0 <fsipc>
  80174b:	89 c3                	mov    %eax,%ebx
  80174d:	85 c0                	test   %eax,%eax
  80174f:	78 1f                	js     801770 <devfile_read+0x4d>
	assert(r <= n);
  801751:	39 f0                	cmp    %esi,%eax
  801753:	77 24                	ja     801779 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801755:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80175a:	7f 33                	jg     80178f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80175c:	83 ec 04             	sub    $0x4,%esp
  80175f:	50                   	push   %eax
  801760:	68 00 50 80 00       	push   $0x805000
  801765:	ff 75 0c             	pushl  0xc(%ebp)
  801768:	e8 58 f3 ff ff       	call   800ac5 <memmove>
	return r;
  80176d:	83 c4 10             	add    $0x10,%esp
}
  801770:	89 d8                	mov    %ebx,%eax
  801772:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801775:	5b                   	pop    %ebx
  801776:	5e                   	pop    %esi
  801777:	5d                   	pop    %ebp
  801778:	c3                   	ret    
	assert(r <= n);
  801779:	68 04 2a 80 00       	push   $0x802a04
  80177e:	68 0b 2a 80 00       	push   $0x802a0b
  801783:	6a 7c                	push   $0x7c
  801785:	68 20 2a 80 00       	push   $0x802a20
  80178a:	e8 e5 09 00 00       	call   802174 <_panic>
	assert(r <= PGSIZE);
  80178f:	68 2b 2a 80 00       	push   $0x802a2b
  801794:	68 0b 2a 80 00       	push   $0x802a0b
  801799:	6a 7d                	push   $0x7d
  80179b:	68 20 2a 80 00       	push   $0x802a20
  8017a0:	e8 cf 09 00 00       	call   802174 <_panic>

008017a5 <open>:
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	56                   	push   %esi
  8017a9:	53                   	push   %ebx
  8017aa:	83 ec 1c             	sub    $0x1c,%esp
  8017ad:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017b0:	56                   	push   %esi
  8017b1:	e8 48 f1 ff ff       	call   8008fe <strlen>
  8017b6:	83 c4 10             	add    $0x10,%esp
  8017b9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017be:	7f 6c                	jg     80182c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017c0:	83 ec 0c             	sub    $0xc,%esp
  8017c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c6:	50                   	push   %eax
  8017c7:	e8 79 f8 ff ff       	call   801045 <fd_alloc>
  8017cc:	89 c3                	mov    %eax,%ebx
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	78 3c                	js     801811 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017d5:	83 ec 08             	sub    $0x8,%esp
  8017d8:	56                   	push   %esi
  8017d9:	68 00 50 80 00       	push   $0x805000
  8017de:	e8 54 f1 ff ff       	call   800937 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e6:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f3:	e8 b8 fd ff ff       	call   8015b0 <fsipc>
  8017f8:	89 c3                	mov    %eax,%ebx
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	85 c0                	test   %eax,%eax
  8017ff:	78 19                	js     80181a <open+0x75>
	return fd2num(fd);
  801801:	83 ec 0c             	sub    $0xc,%esp
  801804:	ff 75 f4             	pushl  -0xc(%ebp)
  801807:	e8 12 f8 ff ff       	call   80101e <fd2num>
  80180c:	89 c3                	mov    %eax,%ebx
  80180e:	83 c4 10             	add    $0x10,%esp
}
  801811:	89 d8                	mov    %ebx,%eax
  801813:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801816:	5b                   	pop    %ebx
  801817:	5e                   	pop    %esi
  801818:	5d                   	pop    %ebp
  801819:	c3                   	ret    
		fd_close(fd, 0);
  80181a:	83 ec 08             	sub    $0x8,%esp
  80181d:	6a 00                	push   $0x0
  80181f:	ff 75 f4             	pushl  -0xc(%ebp)
  801822:	e8 1b f9 ff ff       	call   801142 <fd_close>
		return r;
  801827:	83 c4 10             	add    $0x10,%esp
  80182a:	eb e5                	jmp    801811 <open+0x6c>
		return -E_BAD_PATH;
  80182c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801831:	eb de                	jmp    801811 <open+0x6c>

00801833 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801839:	ba 00 00 00 00       	mov    $0x0,%edx
  80183e:	b8 08 00 00 00       	mov    $0x8,%eax
  801843:	e8 68 fd ff ff       	call   8015b0 <fsipc>
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801850:	68 37 2a 80 00       	push   $0x802a37
  801855:	ff 75 0c             	pushl  0xc(%ebp)
  801858:	e8 da f0 ff ff       	call   800937 <strcpy>
	return 0;
}
  80185d:	b8 00 00 00 00       	mov    $0x0,%eax
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <devsock_close>:
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	53                   	push   %ebx
  801868:	83 ec 10             	sub    $0x10,%esp
  80186b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80186e:	53                   	push   %ebx
  80186f:	e8 5d 0a 00 00       	call   8022d1 <pageref>
  801874:	83 c4 10             	add    $0x10,%esp
		return 0;
  801877:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80187c:	83 f8 01             	cmp    $0x1,%eax
  80187f:	74 07                	je     801888 <devsock_close+0x24>
}
  801881:	89 d0                	mov    %edx,%eax
  801883:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801886:	c9                   	leave  
  801887:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801888:	83 ec 0c             	sub    $0xc,%esp
  80188b:	ff 73 0c             	pushl  0xc(%ebx)
  80188e:	e8 b9 02 00 00       	call   801b4c <nsipc_close>
  801893:	89 c2                	mov    %eax,%edx
  801895:	83 c4 10             	add    $0x10,%esp
  801898:	eb e7                	jmp    801881 <devsock_close+0x1d>

0080189a <devsock_write>:
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018a0:	6a 00                	push   $0x0
  8018a2:	ff 75 10             	pushl  0x10(%ebp)
  8018a5:	ff 75 0c             	pushl  0xc(%ebp)
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	ff 70 0c             	pushl  0xc(%eax)
  8018ae:	e8 76 03 00 00       	call   801c29 <nsipc_send>
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <devsock_read>:
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018bb:	6a 00                	push   $0x0
  8018bd:	ff 75 10             	pushl  0x10(%ebp)
  8018c0:	ff 75 0c             	pushl  0xc(%ebp)
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	ff 70 0c             	pushl  0xc(%eax)
  8018c9:	e8 ef 02 00 00       	call   801bbd <nsipc_recv>
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <fd2sockid>:
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018d6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018d9:	52                   	push   %edx
  8018da:	50                   	push   %eax
  8018db:	e8 b7 f7 ff ff       	call   801097 <fd_lookup>
  8018e0:	83 c4 10             	add    $0x10,%esp
  8018e3:	85 c0                	test   %eax,%eax
  8018e5:	78 10                	js     8018f7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ea:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018f0:	39 08                	cmp    %ecx,(%eax)
  8018f2:	75 05                	jne    8018f9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018f4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    
		return -E_NOT_SUPP;
  8018f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018fe:	eb f7                	jmp    8018f7 <fd2sockid+0x27>

00801900 <alloc_sockfd>:
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	56                   	push   %esi
  801904:	53                   	push   %ebx
  801905:	83 ec 1c             	sub    $0x1c,%esp
  801908:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80190a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190d:	50                   	push   %eax
  80190e:	e8 32 f7 ff ff       	call   801045 <fd_alloc>
  801913:	89 c3                	mov    %eax,%ebx
  801915:	83 c4 10             	add    $0x10,%esp
  801918:	85 c0                	test   %eax,%eax
  80191a:	78 43                	js     80195f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80191c:	83 ec 04             	sub    $0x4,%esp
  80191f:	68 07 04 00 00       	push   $0x407
  801924:	ff 75 f4             	pushl  -0xc(%ebp)
  801927:	6a 00                	push   $0x0
  801929:	e8 fb f3 ff ff       	call   800d29 <sys_page_alloc>
  80192e:	89 c3                	mov    %eax,%ebx
  801930:	83 c4 10             	add    $0x10,%esp
  801933:	85 c0                	test   %eax,%eax
  801935:	78 28                	js     80195f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193a:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801940:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801945:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80194c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80194f:	83 ec 0c             	sub    $0xc,%esp
  801952:	50                   	push   %eax
  801953:	e8 c6 f6 ff ff       	call   80101e <fd2num>
  801958:	89 c3                	mov    %eax,%ebx
  80195a:	83 c4 10             	add    $0x10,%esp
  80195d:	eb 0c                	jmp    80196b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80195f:	83 ec 0c             	sub    $0xc,%esp
  801962:	56                   	push   %esi
  801963:	e8 e4 01 00 00       	call   801b4c <nsipc_close>
		return r;
  801968:	83 c4 10             	add    $0x10,%esp
}
  80196b:	89 d8                	mov    %ebx,%eax
  80196d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801970:	5b                   	pop    %ebx
  801971:	5e                   	pop    %esi
  801972:	5d                   	pop    %ebp
  801973:	c3                   	ret    

00801974 <accept>:
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	e8 4e ff ff ff       	call   8018d0 <fd2sockid>
  801982:	85 c0                	test   %eax,%eax
  801984:	78 1b                	js     8019a1 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801986:	83 ec 04             	sub    $0x4,%esp
  801989:	ff 75 10             	pushl  0x10(%ebp)
  80198c:	ff 75 0c             	pushl  0xc(%ebp)
  80198f:	50                   	push   %eax
  801990:	e8 0e 01 00 00       	call   801aa3 <nsipc_accept>
  801995:	83 c4 10             	add    $0x10,%esp
  801998:	85 c0                	test   %eax,%eax
  80199a:	78 05                	js     8019a1 <accept+0x2d>
	return alloc_sockfd(r);
  80199c:	e8 5f ff ff ff       	call   801900 <alloc_sockfd>
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <bind>:
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	e8 1f ff ff ff       	call   8018d0 <fd2sockid>
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	78 12                	js     8019c7 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019b5:	83 ec 04             	sub    $0x4,%esp
  8019b8:	ff 75 10             	pushl  0x10(%ebp)
  8019bb:	ff 75 0c             	pushl  0xc(%ebp)
  8019be:	50                   	push   %eax
  8019bf:	e8 31 01 00 00       	call   801af5 <nsipc_bind>
  8019c4:	83 c4 10             	add    $0x10,%esp
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <shutdown>:
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	e8 f9 fe ff ff       	call   8018d0 <fd2sockid>
  8019d7:	85 c0                	test   %eax,%eax
  8019d9:	78 0f                	js     8019ea <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019db:	83 ec 08             	sub    $0x8,%esp
  8019de:	ff 75 0c             	pushl  0xc(%ebp)
  8019e1:	50                   	push   %eax
  8019e2:	e8 43 01 00 00       	call   801b2a <nsipc_shutdown>
  8019e7:	83 c4 10             	add    $0x10,%esp
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <connect>:
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	e8 d6 fe ff ff       	call   8018d0 <fd2sockid>
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	78 12                	js     801a10 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019fe:	83 ec 04             	sub    $0x4,%esp
  801a01:	ff 75 10             	pushl  0x10(%ebp)
  801a04:	ff 75 0c             	pushl  0xc(%ebp)
  801a07:	50                   	push   %eax
  801a08:	e8 59 01 00 00       	call   801b66 <nsipc_connect>
  801a0d:	83 c4 10             	add    $0x10,%esp
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <listen>:
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	e8 b0 fe ff ff       	call   8018d0 <fd2sockid>
  801a20:	85 c0                	test   %eax,%eax
  801a22:	78 0f                	js     801a33 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a24:	83 ec 08             	sub    $0x8,%esp
  801a27:	ff 75 0c             	pushl  0xc(%ebp)
  801a2a:	50                   	push   %eax
  801a2b:	e8 6b 01 00 00       	call   801b9b <nsipc_listen>
  801a30:	83 c4 10             	add    $0x10,%esp
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a3b:	ff 75 10             	pushl  0x10(%ebp)
  801a3e:	ff 75 0c             	pushl  0xc(%ebp)
  801a41:	ff 75 08             	pushl  0x8(%ebp)
  801a44:	e8 3e 02 00 00       	call   801c87 <nsipc_socket>
  801a49:	83 c4 10             	add    $0x10,%esp
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	78 05                	js     801a55 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a50:	e8 ab fe ff ff       	call   801900 <alloc_sockfd>
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	53                   	push   %ebx
  801a5b:	83 ec 04             	sub    $0x4,%esp
  801a5e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a60:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a67:	74 26                	je     801a8f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a69:	6a 07                	push   $0x7
  801a6b:	68 00 60 80 00       	push   $0x806000
  801a70:	53                   	push   %ebx
  801a71:	ff 35 04 40 80 00    	pushl  0x804004
  801a77:	e8 c2 07 00 00       	call   80223e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a7c:	83 c4 0c             	add    $0xc,%esp
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	e8 4b 07 00 00       	call   8021d5 <ipc_recv>
}
  801a8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a8f:	83 ec 0c             	sub    $0xc,%esp
  801a92:	6a 02                	push   $0x2
  801a94:	e8 fd 07 00 00       	call   802296 <ipc_find_env>
  801a99:	a3 04 40 80 00       	mov    %eax,0x804004
  801a9e:	83 c4 10             	add    $0x10,%esp
  801aa1:	eb c6                	jmp    801a69 <nsipc+0x12>

00801aa3 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	56                   	push   %esi
  801aa7:	53                   	push   %ebx
  801aa8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ab3:	8b 06                	mov    (%esi),%eax
  801ab5:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801aba:	b8 01 00 00 00       	mov    $0x1,%eax
  801abf:	e8 93 ff ff ff       	call   801a57 <nsipc>
  801ac4:	89 c3                	mov    %eax,%ebx
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	79 09                	jns    801ad3 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801aca:	89 d8                	mov    %ebx,%eax
  801acc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801acf:	5b                   	pop    %ebx
  801ad0:	5e                   	pop    %esi
  801ad1:	5d                   	pop    %ebp
  801ad2:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ad3:	83 ec 04             	sub    $0x4,%esp
  801ad6:	ff 35 10 60 80 00    	pushl  0x806010
  801adc:	68 00 60 80 00       	push   $0x806000
  801ae1:	ff 75 0c             	pushl  0xc(%ebp)
  801ae4:	e8 dc ef ff ff       	call   800ac5 <memmove>
		*addrlen = ret->ret_addrlen;
  801ae9:	a1 10 60 80 00       	mov    0x806010,%eax
  801aee:	89 06                	mov    %eax,(%esi)
  801af0:	83 c4 10             	add    $0x10,%esp
	return r;
  801af3:	eb d5                	jmp    801aca <nsipc_accept+0x27>

00801af5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	53                   	push   %ebx
  801af9:	83 ec 08             	sub    $0x8,%esp
  801afc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b07:	53                   	push   %ebx
  801b08:	ff 75 0c             	pushl  0xc(%ebp)
  801b0b:	68 04 60 80 00       	push   $0x806004
  801b10:	e8 b0 ef ff ff       	call   800ac5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b15:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b1b:	b8 02 00 00 00       	mov    $0x2,%eax
  801b20:	e8 32 ff ff ff       	call   801a57 <nsipc>
}
  801b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b40:	b8 03 00 00 00       	mov    $0x3,%eax
  801b45:	e8 0d ff ff ff       	call   801a57 <nsipc>
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <nsipc_close>:

int
nsipc_close(int s)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b52:	8b 45 08             	mov    0x8(%ebp),%eax
  801b55:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b5a:	b8 04 00 00 00       	mov    $0x4,%eax
  801b5f:	e8 f3 fe ff ff       	call   801a57 <nsipc>
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	53                   	push   %ebx
  801b6a:	83 ec 08             	sub    $0x8,%esp
  801b6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b78:	53                   	push   %ebx
  801b79:	ff 75 0c             	pushl  0xc(%ebp)
  801b7c:	68 04 60 80 00       	push   $0x806004
  801b81:	e8 3f ef ff ff       	call   800ac5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b86:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b8c:	b8 05 00 00 00       	mov    $0x5,%eax
  801b91:	e8 c1 fe ff ff       	call   801a57 <nsipc>
}
  801b96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bac:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bb1:	b8 06 00 00 00       	mov    $0x6,%eax
  801bb6:	e8 9c fe ff ff       	call   801a57 <nsipc>
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	56                   	push   %esi
  801bc1:	53                   	push   %ebx
  801bc2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bcd:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bd3:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd6:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bdb:	b8 07 00 00 00       	mov    $0x7,%eax
  801be0:	e8 72 fe ff ff       	call   801a57 <nsipc>
  801be5:	89 c3                	mov    %eax,%ebx
  801be7:	85 c0                	test   %eax,%eax
  801be9:	78 1f                	js     801c0a <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801beb:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bf0:	7f 21                	jg     801c13 <nsipc_recv+0x56>
  801bf2:	39 c6                	cmp    %eax,%esi
  801bf4:	7c 1d                	jl     801c13 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bf6:	83 ec 04             	sub    $0x4,%esp
  801bf9:	50                   	push   %eax
  801bfa:	68 00 60 80 00       	push   $0x806000
  801bff:	ff 75 0c             	pushl  0xc(%ebp)
  801c02:	e8 be ee ff ff       	call   800ac5 <memmove>
  801c07:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c0a:	89 d8                	mov    %ebx,%eax
  801c0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c0f:	5b                   	pop    %ebx
  801c10:	5e                   	pop    %esi
  801c11:	5d                   	pop    %ebp
  801c12:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c13:	68 43 2a 80 00       	push   $0x802a43
  801c18:	68 0b 2a 80 00       	push   $0x802a0b
  801c1d:	6a 62                	push   $0x62
  801c1f:	68 58 2a 80 00       	push   $0x802a58
  801c24:	e8 4b 05 00 00       	call   802174 <_panic>

00801c29 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	53                   	push   %ebx
  801c2d:	83 ec 04             	sub    $0x4,%esp
  801c30:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c3b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c41:	7f 2e                	jg     801c71 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c43:	83 ec 04             	sub    $0x4,%esp
  801c46:	53                   	push   %ebx
  801c47:	ff 75 0c             	pushl  0xc(%ebp)
  801c4a:	68 0c 60 80 00       	push   $0x80600c
  801c4f:	e8 71 ee ff ff       	call   800ac5 <memmove>
	nsipcbuf.send.req_size = size;
  801c54:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c5a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c62:	b8 08 00 00 00       	mov    $0x8,%eax
  801c67:	e8 eb fd ff ff       	call   801a57 <nsipc>
}
  801c6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    
	assert(size < 1600);
  801c71:	68 64 2a 80 00       	push   $0x802a64
  801c76:	68 0b 2a 80 00       	push   $0x802a0b
  801c7b:	6a 6d                	push   $0x6d
  801c7d:	68 58 2a 80 00       	push   $0x802a58
  801c82:	e8 ed 04 00 00       	call   802174 <_panic>

00801c87 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c98:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca0:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ca5:	b8 09 00 00 00       	mov    $0x9,%eax
  801caa:	e8 a8 fd ff ff       	call   801a57 <nsipc>
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	56                   	push   %esi
  801cb5:	53                   	push   %ebx
  801cb6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cb9:	83 ec 0c             	sub    $0xc,%esp
  801cbc:	ff 75 08             	pushl  0x8(%ebp)
  801cbf:	e8 6a f3 ff ff       	call   80102e <fd2data>
  801cc4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cc6:	83 c4 08             	add    $0x8,%esp
  801cc9:	68 70 2a 80 00       	push   $0x802a70
  801cce:	53                   	push   %ebx
  801ccf:	e8 63 ec ff ff       	call   800937 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cd4:	8b 46 04             	mov    0x4(%esi),%eax
  801cd7:	2b 06                	sub    (%esi),%eax
  801cd9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cdf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ce6:	00 00 00 
	stat->st_dev = &devpipe;
  801ce9:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cf0:	30 80 00 
	return 0;
}
  801cf3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5e                   	pop    %esi
  801cfd:	5d                   	pop    %ebp
  801cfe:	c3                   	ret    

00801cff <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	53                   	push   %ebx
  801d03:	83 ec 0c             	sub    $0xc,%esp
  801d06:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d09:	53                   	push   %ebx
  801d0a:	6a 00                	push   $0x0
  801d0c:	e8 9d f0 ff ff       	call   800dae <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d11:	89 1c 24             	mov    %ebx,(%esp)
  801d14:	e8 15 f3 ff ff       	call   80102e <fd2data>
  801d19:	83 c4 08             	add    $0x8,%esp
  801d1c:	50                   	push   %eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	e8 8a f0 ff ff       	call   800dae <sys_page_unmap>
}
  801d24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <_pipeisclosed>:
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	57                   	push   %edi
  801d2d:	56                   	push   %esi
  801d2e:	53                   	push   %ebx
  801d2f:	83 ec 1c             	sub    $0x1c,%esp
  801d32:	89 c7                	mov    %eax,%edi
  801d34:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d36:	a1 08 40 80 00       	mov    0x804008,%eax
  801d3b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d3e:	83 ec 0c             	sub    $0xc,%esp
  801d41:	57                   	push   %edi
  801d42:	e8 8a 05 00 00       	call   8022d1 <pageref>
  801d47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d4a:	89 34 24             	mov    %esi,(%esp)
  801d4d:	e8 7f 05 00 00       	call   8022d1 <pageref>
		nn = thisenv->env_runs;
  801d52:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d58:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d5b:	83 c4 10             	add    $0x10,%esp
  801d5e:	39 cb                	cmp    %ecx,%ebx
  801d60:	74 1b                	je     801d7d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d62:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d65:	75 cf                	jne    801d36 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d67:	8b 42 58             	mov    0x58(%edx),%eax
  801d6a:	6a 01                	push   $0x1
  801d6c:	50                   	push   %eax
  801d6d:	53                   	push   %ebx
  801d6e:	68 77 2a 80 00       	push   $0x802a77
  801d73:	e8 60 e4 ff ff       	call   8001d8 <cprintf>
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	eb b9                	jmp    801d36 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d7d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d80:	0f 94 c0             	sete   %al
  801d83:	0f b6 c0             	movzbl %al,%eax
}
  801d86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d89:	5b                   	pop    %ebx
  801d8a:	5e                   	pop    %esi
  801d8b:	5f                   	pop    %edi
  801d8c:	5d                   	pop    %ebp
  801d8d:	c3                   	ret    

00801d8e <devpipe_write>:
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	57                   	push   %edi
  801d92:	56                   	push   %esi
  801d93:	53                   	push   %ebx
  801d94:	83 ec 28             	sub    $0x28,%esp
  801d97:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d9a:	56                   	push   %esi
  801d9b:	e8 8e f2 ff ff       	call   80102e <fd2data>
  801da0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801da2:	83 c4 10             	add    $0x10,%esp
  801da5:	bf 00 00 00 00       	mov    $0x0,%edi
  801daa:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dad:	74 4f                	je     801dfe <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801daf:	8b 43 04             	mov    0x4(%ebx),%eax
  801db2:	8b 0b                	mov    (%ebx),%ecx
  801db4:	8d 51 20             	lea    0x20(%ecx),%edx
  801db7:	39 d0                	cmp    %edx,%eax
  801db9:	72 14                	jb     801dcf <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dbb:	89 da                	mov    %ebx,%edx
  801dbd:	89 f0                	mov    %esi,%eax
  801dbf:	e8 65 ff ff ff       	call   801d29 <_pipeisclosed>
  801dc4:	85 c0                	test   %eax,%eax
  801dc6:	75 3b                	jne    801e03 <devpipe_write+0x75>
			sys_yield();
  801dc8:	e8 3d ef ff ff       	call   800d0a <sys_yield>
  801dcd:	eb e0                	jmp    801daf <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dd2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dd6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dd9:	89 c2                	mov    %eax,%edx
  801ddb:	c1 fa 1f             	sar    $0x1f,%edx
  801dde:	89 d1                	mov    %edx,%ecx
  801de0:	c1 e9 1b             	shr    $0x1b,%ecx
  801de3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801de6:	83 e2 1f             	and    $0x1f,%edx
  801de9:	29 ca                	sub    %ecx,%edx
  801deb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801def:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801df3:	83 c0 01             	add    $0x1,%eax
  801df6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801df9:	83 c7 01             	add    $0x1,%edi
  801dfc:	eb ac                	jmp    801daa <devpipe_write+0x1c>
	return i;
  801dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  801e01:	eb 05                	jmp    801e08 <devpipe_write+0x7a>
				return 0;
  801e03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e0b:	5b                   	pop    %ebx
  801e0c:	5e                   	pop    %esi
  801e0d:	5f                   	pop    %edi
  801e0e:	5d                   	pop    %ebp
  801e0f:	c3                   	ret    

00801e10 <devpipe_read>:
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	57                   	push   %edi
  801e14:	56                   	push   %esi
  801e15:	53                   	push   %ebx
  801e16:	83 ec 18             	sub    $0x18,%esp
  801e19:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e1c:	57                   	push   %edi
  801e1d:	e8 0c f2 ff ff       	call   80102e <fd2data>
  801e22:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e24:	83 c4 10             	add    $0x10,%esp
  801e27:	be 00 00 00 00       	mov    $0x0,%esi
  801e2c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e2f:	75 14                	jne    801e45 <devpipe_read+0x35>
	return i;
  801e31:	8b 45 10             	mov    0x10(%ebp),%eax
  801e34:	eb 02                	jmp    801e38 <devpipe_read+0x28>
				return i;
  801e36:	89 f0                	mov    %esi,%eax
}
  801e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e3b:	5b                   	pop    %ebx
  801e3c:	5e                   	pop    %esi
  801e3d:	5f                   	pop    %edi
  801e3e:	5d                   	pop    %ebp
  801e3f:	c3                   	ret    
			sys_yield();
  801e40:	e8 c5 ee ff ff       	call   800d0a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e45:	8b 03                	mov    (%ebx),%eax
  801e47:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e4a:	75 18                	jne    801e64 <devpipe_read+0x54>
			if (i > 0)
  801e4c:	85 f6                	test   %esi,%esi
  801e4e:	75 e6                	jne    801e36 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e50:	89 da                	mov    %ebx,%edx
  801e52:	89 f8                	mov    %edi,%eax
  801e54:	e8 d0 fe ff ff       	call   801d29 <_pipeisclosed>
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	74 e3                	je     801e40 <devpipe_read+0x30>
				return 0;
  801e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e62:	eb d4                	jmp    801e38 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e64:	99                   	cltd   
  801e65:	c1 ea 1b             	shr    $0x1b,%edx
  801e68:	01 d0                	add    %edx,%eax
  801e6a:	83 e0 1f             	and    $0x1f,%eax
  801e6d:	29 d0                	sub    %edx,%eax
  801e6f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e77:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e7a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e7d:	83 c6 01             	add    $0x1,%esi
  801e80:	eb aa                	jmp    801e2c <devpipe_read+0x1c>

00801e82 <pipe>:
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	56                   	push   %esi
  801e86:	53                   	push   %ebx
  801e87:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e8d:	50                   	push   %eax
  801e8e:	e8 b2 f1 ff ff       	call   801045 <fd_alloc>
  801e93:	89 c3                	mov    %eax,%ebx
  801e95:	83 c4 10             	add    $0x10,%esp
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	0f 88 23 01 00 00    	js     801fc3 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea0:	83 ec 04             	sub    $0x4,%esp
  801ea3:	68 07 04 00 00       	push   $0x407
  801ea8:	ff 75 f4             	pushl  -0xc(%ebp)
  801eab:	6a 00                	push   $0x0
  801ead:	e8 77 ee ff ff       	call   800d29 <sys_page_alloc>
  801eb2:	89 c3                	mov    %eax,%ebx
  801eb4:	83 c4 10             	add    $0x10,%esp
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	0f 88 04 01 00 00    	js     801fc3 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ebf:	83 ec 0c             	sub    $0xc,%esp
  801ec2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ec5:	50                   	push   %eax
  801ec6:	e8 7a f1 ff ff       	call   801045 <fd_alloc>
  801ecb:	89 c3                	mov    %eax,%ebx
  801ecd:	83 c4 10             	add    $0x10,%esp
  801ed0:	85 c0                	test   %eax,%eax
  801ed2:	0f 88 db 00 00 00    	js     801fb3 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed8:	83 ec 04             	sub    $0x4,%esp
  801edb:	68 07 04 00 00       	push   $0x407
  801ee0:	ff 75 f0             	pushl  -0x10(%ebp)
  801ee3:	6a 00                	push   $0x0
  801ee5:	e8 3f ee ff ff       	call   800d29 <sys_page_alloc>
  801eea:	89 c3                	mov    %eax,%ebx
  801eec:	83 c4 10             	add    $0x10,%esp
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	0f 88 bc 00 00 00    	js     801fb3 <pipe+0x131>
	va = fd2data(fd0);
  801ef7:	83 ec 0c             	sub    $0xc,%esp
  801efa:	ff 75 f4             	pushl  -0xc(%ebp)
  801efd:	e8 2c f1 ff ff       	call   80102e <fd2data>
  801f02:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f04:	83 c4 0c             	add    $0xc,%esp
  801f07:	68 07 04 00 00       	push   $0x407
  801f0c:	50                   	push   %eax
  801f0d:	6a 00                	push   $0x0
  801f0f:	e8 15 ee ff ff       	call   800d29 <sys_page_alloc>
  801f14:	89 c3                	mov    %eax,%ebx
  801f16:	83 c4 10             	add    $0x10,%esp
  801f19:	85 c0                	test   %eax,%eax
  801f1b:	0f 88 82 00 00 00    	js     801fa3 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f21:	83 ec 0c             	sub    $0xc,%esp
  801f24:	ff 75 f0             	pushl  -0x10(%ebp)
  801f27:	e8 02 f1 ff ff       	call   80102e <fd2data>
  801f2c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f33:	50                   	push   %eax
  801f34:	6a 00                	push   $0x0
  801f36:	56                   	push   %esi
  801f37:	6a 00                	push   $0x0
  801f39:	e8 2e ee ff ff       	call   800d6c <sys_page_map>
  801f3e:	89 c3                	mov    %eax,%ebx
  801f40:	83 c4 20             	add    $0x20,%esp
  801f43:	85 c0                	test   %eax,%eax
  801f45:	78 4e                	js     801f95 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f47:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f54:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f5e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f63:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f6a:	83 ec 0c             	sub    $0xc,%esp
  801f6d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f70:	e8 a9 f0 ff ff       	call   80101e <fd2num>
  801f75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f78:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f7a:	83 c4 04             	add    $0x4,%esp
  801f7d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f80:	e8 99 f0 ff ff       	call   80101e <fd2num>
  801f85:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f88:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f8b:	83 c4 10             	add    $0x10,%esp
  801f8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f93:	eb 2e                	jmp    801fc3 <pipe+0x141>
	sys_page_unmap(0, va);
  801f95:	83 ec 08             	sub    $0x8,%esp
  801f98:	56                   	push   %esi
  801f99:	6a 00                	push   $0x0
  801f9b:	e8 0e ee ff ff       	call   800dae <sys_page_unmap>
  801fa0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fa3:	83 ec 08             	sub    $0x8,%esp
  801fa6:	ff 75 f0             	pushl  -0x10(%ebp)
  801fa9:	6a 00                	push   $0x0
  801fab:	e8 fe ed ff ff       	call   800dae <sys_page_unmap>
  801fb0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fb3:	83 ec 08             	sub    $0x8,%esp
  801fb6:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb9:	6a 00                	push   $0x0
  801fbb:	e8 ee ed ff ff       	call   800dae <sys_page_unmap>
  801fc0:	83 c4 10             	add    $0x10,%esp
}
  801fc3:	89 d8                	mov    %ebx,%eax
  801fc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc8:	5b                   	pop    %ebx
  801fc9:	5e                   	pop    %esi
  801fca:	5d                   	pop    %ebp
  801fcb:	c3                   	ret    

00801fcc <pipeisclosed>:
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd5:	50                   	push   %eax
  801fd6:	ff 75 08             	pushl  0x8(%ebp)
  801fd9:	e8 b9 f0 ff ff       	call   801097 <fd_lookup>
  801fde:	83 c4 10             	add    $0x10,%esp
  801fe1:	85 c0                	test   %eax,%eax
  801fe3:	78 18                	js     801ffd <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fe5:	83 ec 0c             	sub    $0xc,%esp
  801fe8:	ff 75 f4             	pushl  -0xc(%ebp)
  801feb:	e8 3e f0 ff ff       	call   80102e <fd2data>
	return _pipeisclosed(fd, p);
  801ff0:	89 c2                	mov    %eax,%edx
  801ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff5:	e8 2f fd ff ff       	call   801d29 <_pipeisclosed>
  801ffa:	83 c4 10             	add    $0x10,%esp
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fff:	b8 00 00 00 00       	mov    $0x0,%eax
  802004:	c3                   	ret    

00802005 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80200b:	68 8f 2a 80 00       	push   $0x802a8f
  802010:	ff 75 0c             	pushl  0xc(%ebp)
  802013:	e8 1f e9 ff ff       	call   800937 <strcpy>
	return 0;
}
  802018:	b8 00 00 00 00       	mov    $0x0,%eax
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <devcons_write>:
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	57                   	push   %edi
  802023:	56                   	push   %esi
  802024:	53                   	push   %ebx
  802025:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80202b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802030:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802036:	3b 75 10             	cmp    0x10(%ebp),%esi
  802039:	73 31                	jae    80206c <devcons_write+0x4d>
		m = n - tot;
  80203b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80203e:	29 f3                	sub    %esi,%ebx
  802040:	83 fb 7f             	cmp    $0x7f,%ebx
  802043:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802048:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80204b:	83 ec 04             	sub    $0x4,%esp
  80204e:	53                   	push   %ebx
  80204f:	89 f0                	mov    %esi,%eax
  802051:	03 45 0c             	add    0xc(%ebp),%eax
  802054:	50                   	push   %eax
  802055:	57                   	push   %edi
  802056:	e8 6a ea ff ff       	call   800ac5 <memmove>
		sys_cputs(buf, m);
  80205b:	83 c4 08             	add    $0x8,%esp
  80205e:	53                   	push   %ebx
  80205f:	57                   	push   %edi
  802060:	e8 08 ec ff ff       	call   800c6d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802065:	01 de                	add    %ebx,%esi
  802067:	83 c4 10             	add    $0x10,%esp
  80206a:	eb ca                	jmp    802036 <devcons_write+0x17>
}
  80206c:	89 f0                	mov    %esi,%eax
  80206e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802071:	5b                   	pop    %ebx
  802072:	5e                   	pop    %esi
  802073:	5f                   	pop    %edi
  802074:	5d                   	pop    %ebp
  802075:	c3                   	ret    

00802076 <devcons_read>:
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
  802079:	83 ec 08             	sub    $0x8,%esp
  80207c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802081:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802085:	74 21                	je     8020a8 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802087:	e8 ff eb ff ff       	call   800c8b <sys_cgetc>
  80208c:	85 c0                	test   %eax,%eax
  80208e:	75 07                	jne    802097 <devcons_read+0x21>
		sys_yield();
  802090:	e8 75 ec ff ff       	call   800d0a <sys_yield>
  802095:	eb f0                	jmp    802087 <devcons_read+0x11>
	if (c < 0)
  802097:	78 0f                	js     8020a8 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802099:	83 f8 04             	cmp    $0x4,%eax
  80209c:	74 0c                	je     8020aa <devcons_read+0x34>
	*(char*)vbuf = c;
  80209e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a1:	88 02                	mov    %al,(%edx)
	return 1;
  8020a3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    
		return 0;
  8020aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8020af:	eb f7                	jmp    8020a8 <devcons_read+0x32>

008020b1 <cputchar>:
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ba:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020bd:	6a 01                	push   $0x1
  8020bf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020c2:	50                   	push   %eax
  8020c3:	e8 a5 eb ff ff       	call   800c6d <sys_cputs>
}
  8020c8:	83 c4 10             	add    $0x10,%esp
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <getchar>:
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020d3:	6a 01                	push   $0x1
  8020d5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020d8:	50                   	push   %eax
  8020d9:	6a 00                	push   $0x0
  8020db:	e8 27 f2 ff ff       	call   801307 <read>
	if (r < 0)
  8020e0:	83 c4 10             	add    $0x10,%esp
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	78 06                	js     8020ed <getchar+0x20>
	if (r < 1)
  8020e7:	74 06                	je     8020ef <getchar+0x22>
	return c;
  8020e9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    
		return -E_EOF;
  8020ef:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020f4:	eb f7                	jmp    8020ed <getchar+0x20>

008020f6 <iscons>:
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ff:	50                   	push   %eax
  802100:	ff 75 08             	pushl  0x8(%ebp)
  802103:	e8 8f ef ff ff       	call   801097 <fd_lookup>
  802108:	83 c4 10             	add    $0x10,%esp
  80210b:	85 c0                	test   %eax,%eax
  80210d:	78 11                	js     802120 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80210f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802112:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802118:	39 10                	cmp    %edx,(%eax)
  80211a:	0f 94 c0             	sete   %al
  80211d:	0f b6 c0             	movzbl %al,%eax
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <opencons>:
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802128:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80212b:	50                   	push   %eax
  80212c:	e8 14 ef ff ff       	call   801045 <fd_alloc>
  802131:	83 c4 10             	add    $0x10,%esp
  802134:	85 c0                	test   %eax,%eax
  802136:	78 3a                	js     802172 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802138:	83 ec 04             	sub    $0x4,%esp
  80213b:	68 07 04 00 00       	push   $0x407
  802140:	ff 75 f4             	pushl  -0xc(%ebp)
  802143:	6a 00                	push   $0x0
  802145:	e8 df eb ff ff       	call   800d29 <sys_page_alloc>
  80214a:	83 c4 10             	add    $0x10,%esp
  80214d:	85 c0                	test   %eax,%eax
  80214f:	78 21                	js     802172 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802151:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802154:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80215a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80215c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802166:	83 ec 0c             	sub    $0xc,%esp
  802169:	50                   	push   %eax
  80216a:	e8 af ee ff ff       	call   80101e <fd2num>
  80216f:	83 c4 10             	add    $0x10,%esp
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	56                   	push   %esi
  802178:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802179:	a1 08 40 80 00       	mov    0x804008,%eax
  80217e:	8b 40 48             	mov    0x48(%eax),%eax
  802181:	83 ec 04             	sub    $0x4,%esp
  802184:	68 c0 2a 80 00       	push   $0x802ac0
  802189:	50                   	push   %eax
  80218a:	68 b8 25 80 00       	push   $0x8025b8
  80218f:	e8 44 e0 ff ff       	call   8001d8 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802194:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802197:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80219d:	e8 49 eb ff ff       	call   800ceb <sys_getenvid>
  8021a2:	83 c4 04             	add    $0x4,%esp
  8021a5:	ff 75 0c             	pushl  0xc(%ebp)
  8021a8:	ff 75 08             	pushl  0x8(%ebp)
  8021ab:	56                   	push   %esi
  8021ac:	50                   	push   %eax
  8021ad:	68 9c 2a 80 00       	push   $0x802a9c
  8021b2:	e8 21 e0 ff ff       	call   8001d8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021b7:	83 c4 18             	add    $0x18,%esp
  8021ba:	53                   	push   %ebx
  8021bb:	ff 75 10             	pushl  0x10(%ebp)
  8021be:	e8 c4 df ff ff       	call   800187 <vcprintf>
	cprintf("\n");
  8021c3:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  8021ca:	e8 09 e0 ff ff       	call   8001d8 <cprintf>
  8021cf:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021d2:	cc                   	int3   
  8021d3:	eb fd                	jmp    8021d2 <_panic+0x5e>

008021d5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	56                   	push   %esi
  8021d9:	53                   	push   %ebx
  8021da:	8b 75 08             	mov    0x8(%ebp),%esi
  8021dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021e3:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021e5:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021ea:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021ed:	83 ec 0c             	sub    $0xc,%esp
  8021f0:	50                   	push   %eax
  8021f1:	e8 e3 ec ff ff       	call   800ed9 <sys_ipc_recv>
	if(ret < 0){
  8021f6:	83 c4 10             	add    $0x10,%esp
  8021f9:	85 c0                	test   %eax,%eax
  8021fb:	78 2b                	js     802228 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021fd:	85 f6                	test   %esi,%esi
  8021ff:	74 0a                	je     80220b <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802201:	a1 08 40 80 00       	mov    0x804008,%eax
  802206:	8b 40 74             	mov    0x74(%eax),%eax
  802209:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80220b:	85 db                	test   %ebx,%ebx
  80220d:	74 0a                	je     802219 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80220f:	a1 08 40 80 00       	mov    0x804008,%eax
  802214:	8b 40 78             	mov    0x78(%eax),%eax
  802217:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802219:	a1 08 40 80 00       	mov    0x804008,%eax
  80221e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802221:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802224:	5b                   	pop    %ebx
  802225:	5e                   	pop    %esi
  802226:	5d                   	pop    %ebp
  802227:	c3                   	ret    
		if(from_env_store)
  802228:	85 f6                	test   %esi,%esi
  80222a:	74 06                	je     802232 <ipc_recv+0x5d>
			*from_env_store = 0;
  80222c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802232:	85 db                	test   %ebx,%ebx
  802234:	74 eb                	je     802221 <ipc_recv+0x4c>
			*perm_store = 0;
  802236:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80223c:	eb e3                	jmp    802221 <ipc_recv+0x4c>

0080223e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	57                   	push   %edi
  802242:	56                   	push   %esi
  802243:	53                   	push   %ebx
  802244:	83 ec 0c             	sub    $0xc,%esp
  802247:	8b 7d 08             	mov    0x8(%ebp),%edi
  80224a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80224d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802250:	85 db                	test   %ebx,%ebx
  802252:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802257:	0f 44 d8             	cmove  %eax,%ebx
  80225a:	eb 05                	jmp    802261 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80225c:	e8 a9 ea ff ff       	call   800d0a <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802261:	ff 75 14             	pushl  0x14(%ebp)
  802264:	53                   	push   %ebx
  802265:	56                   	push   %esi
  802266:	57                   	push   %edi
  802267:	e8 4a ec ff ff       	call   800eb6 <sys_ipc_try_send>
  80226c:	83 c4 10             	add    $0x10,%esp
  80226f:	85 c0                	test   %eax,%eax
  802271:	74 1b                	je     80228e <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802273:	79 e7                	jns    80225c <ipc_send+0x1e>
  802275:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802278:	74 e2                	je     80225c <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80227a:	83 ec 04             	sub    $0x4,%esp
  80227d:	68 c7 2a 80 00       	push   $0x802ac7
  802282:	6a 46                	push   $0x46
  802284:	68 dc 2a 80 00       	push   $0x802adc
  802289:	e8 e6 fe ff ff       	call   802174 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80228e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802291:	5b                   	pop    %ebx
  802292:	5e                   	pop    %esi
  802293:	5f                   	pop    %edi
  802294:	5d                   	pop    %ebp
  802295:	c3                   	ret    

00802296 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
  802299:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80229c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022a1:	89 c2                	mov    %eax,%edx
  8022a3:	c1 e2 07             	shl    $0x7,%edx
  8022a6:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022ac:	8b 52 50             	mov    0x50(%edx),%edx
  8022af:	39 ca                	cmp    %ecx,%edx
  8022b1:	74 11                	je     8022c4 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022b3:	83 c0 01             	add    $0x1,%eax
  8022b6:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022bb:	75 e4                	jne    8022a1 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c2:	eb 0b                	jmp    8022cf <ipc_find_env+0x39>
			return envs[i].env_id;
  8022c4:	c1 e0 07             	shl    $0x7,%eax
  8022c7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022cc:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022cf:	5d                   	pop    %ebp
  8022d0:	c3                   	ret    

008022d1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
  8022d4:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022d7:	89 d0                	mov    %edx,%eax
  8022d9:	c1 e8 16             	shr    $0x16,%eax
  8022dc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022e3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022e8:	f6 c1 01             	test   $0x1,%cl
  8022eb:	74 1d                	je     80230a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022ed:	c1 ea 0c             	shr    $0xc,%edx
  8022f0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022f7:	f6 c2 01             	test   $0x1,%dl
  8022fa:	74 0e                	je     80230a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022fc:	c1 ea 0c             	shr    $0xc,%edx
  8022ff:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802306:	ef 
  802307:	0f b7 c0             	movzwl %ax,%eax
}
  80230a:	5d                   	pop    %ebp
  80230b:	c3                   	ret    
  80230c:	66 90                	xchg   %ax,%ax
  80230e:	66 90                	xchg   %ax,%ax

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
