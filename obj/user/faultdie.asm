
obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 81 00 00 00       	call   8000b2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("in faultdie %s\n", __FUNCTION__);
  80003b:	83 ec 08             	sub    $0x8,%esp
  80003e:	68 38 26 80 00       	push   $0x802638
  800043:	68 00 26 80 00       	push   $0x802600
  800048:	e8 b6 01 00 00       	call   800203 <cprintf>
	void *addr = (void*)utf->utf_fault_va;
  80004d:	8b 33                	mov    (%ebx),%esi
	cprintf("1ha?\n");
  80004f:	c7 04 24 10 26 80 00 	movl   $0x802610,(%esp)
  800056:	e8 a8 01 00 00       	call   800203 <cprintf>
	uint32_t err = utf->utf_err;
  80005b:	8b 5b 04             	mov    0x4(%ebx),%ebx
	cprintf("2ha?\n");
  80005e:	c7 04 24 16 26 80 00 	movl   $0x802616,(%esp)
  800065:	e8 99 01 00 00       	call   800203 <cprintf>
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  80006a:	83 c4 0c             	add    $0xc,%esp
  80006d:	83 e3 07             	and    $0x7,%ebx
  800070:	53                   	push   %ebx
  800071:	56                   	push   %esi
  800072:	68 1c 26 80 00       	push   $0x80261c
  800077:	e8 87 01 00 00       	call   800203 <cprintf>
	sys_env_destroy(sys_getenvid());
  80007c:	e8 95 0c 00 00       	call   800d16 <sys_getenvid>
  800081:	89 04 24             	mov    %eax,(%esp)
  800084:	e8 4c 0c 00 00       	call   800cd5 <sys_env_destroy>
}
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008f:	5b                   	pop    %ebx
  800090:	5e                   	pop    %esi
  800091:	5d                   	pop    %ebp
  800092:	c3                   	ret    

00800093 <umain>:

void
umain(int argc, char **argv)
{
  800093:	55                   	push   %ebp
  800094:	89 e5                	mov    %esp,%ebp
  800096:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800099:	68 33 00 80 00       	push   $0x800033
  80009e:	e8 86 0f 00 00       	call   801029 <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  8000a3:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  8000aa:	00 00 00 
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	c9                   	leave  
  8000b1:	c3                   	ret    

008000b2 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000b2:	55                   	push   %ebp
  8000b3:	89 e5                	mov    %esp,%ebp
  8000b5:	57                   	push   %edi
  8000b6:	56                   	push   %esi
  8000b7:	53                   	push   %ebx
  8000b8:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000bb:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8000c2:	00 00 00 
	envid_t find = sys_getenvid();
  8000c5:	e8 4c 0c 00 00       	call   800d16 <sys_getenvid>
  8000ca:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000d0:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000d5:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000da:	bf 01 00 00 00       	mov    $0x1,%edi
  8000df:	eb 0b                	jmp    8000ec <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000e1:	83 c2 01             	add    $0x1,%edx
  8000e4:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000ea:	74 21                	je     80010d <libmain+0x5b>
		if(envs[i].env_id == find)
  8000ec:	89 d1                	mov    %edx,%ecx
  8000ee:	c1 e1 07             	shl    $0x7,%ecx
  8000f1:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000f7:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000fa:	39 c1                	cmp    %eax,%ecx
  8000fc:	75 e3                	jne    8000e1 <libmain+0x2f>
  8000fe:	89 d3                	mov    %edx,%ebx
  800100:	c1 e3 07             	shl    $0x7,%ebx
  800103:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800109:	89 fe                	mov    %edi,%esi
  80010b:	eb d4                	jmp    8000e1 <libmain+0x2f>
  80010d:	89 f0                	mov    %esi,%eax
  80010f:	84 c0                	test   %al,%al
  800111:	74 06                	je     800119 <libmain+0x67>
  800113:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800119:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80011d:	7e 0a                	jle    800129 <libmain+0x77>
		binaryname = argv[0];
  80011f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800122:	8b 00                	mov    (%eax),%eax
  800124:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("call umain!\n");
  800129:	83 ec 0c             	sub    $0xc,%esp
  80012c:	68 40 26 80 00       	push   $0x802640
  800131:	e8 cd 00 00 00       	call   800203 <cprintf>
	// call user main routine
	umain(argc, argv);
  800136:	83 c4 08             	add    $0x8,%esp
  800139:	ff 75 0c             	pushl  0xc(%ebp)
  80013c:	ff 75 08             	pushl  0x8(%ebp)
  80013f:	e8 4f ff ff ff       	call   800093 <umain>

	// exit gracefully
	exit();
  800144:	e8 0b 00 00 00       	call   800154 <exit>
}
  800149:	83 c4 10             	add    $0x10,%esp
  80014c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80014f:	5b                   	pop    %ebx
  800150:	5e                   	pop    %esi
  800151:	5f                   	pop    %edi
  800152:	5d                   	pop    %ebp
  800153:	c3                   	ret    

00800154 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80015a:	e8 37 11 00 00       	call   801296 <close_all>
	sys_env_destroy(0);
  80015f:	83 ec 0c             	sub    $0xc,%esp
  800162:	6a 00                	push   $0x0
  800164:	e8 6c 0b 00 00       	call   800cd5 <sys_env_destroy>
}
  800169:	83 c4 10             	add    $0x10,%esp
  80016c:	c9                   	leave  
  80016d:	c3                   	ret    

0080016e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80016e:	55                   	push   %ebp
  80016f:	89 e5                	mov    %esp,%ebp
  800171:	53                   	push   %ebx
  800172:	83 ec 04             	sub    $0x4,%esp
  800175:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800178:	8b 13                	mov    (%ebx),%edx
  80017a:	8d 42 01             	lea    0x1(%edx),%eax
  80017d:	89 03                	mov    %eax,(%ebx)
  80017f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800182:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800186:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018b:	74 09                	je     800196 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80018d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800191:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800194:	c9                   	leave  
  800195:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	68 ff 00 00 00       	push   $0xff
  80019e:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a1:	50                   	push   %eax
  8001a2:	e8 f1 0a 00 00       	call   800c98 <sys_cputs>
		b->idx = 0;
  8001a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001ad:	83 c4 10             	add    $0x10,%esp
  8001b0:	eb db                	jmp    80018d <putch+0x1f>

008001b2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001bb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c2:	00 00 00 
	b.cnt = 0;
  8001c5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001cc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001cf:	ff 75 0c             	pushl  0xc(%ebp)
  8001d2:	ff 75 08             	pushl  0x8(%ebp)
  8001d5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001db:	50                   	push   %eax
  8001dc:	68 6e 01 80 00       	push   $0x80016e
  8001e1:	e8 4a 01 00 00       	call   800330 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e6:	83 c4 08             	add    $0x8,%esp
  8001e9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001ef:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f5:	50                   	push   %eax
  8001f6:	e8 9d 0a 00 00       	call   800c98 <sys_cputs>

	return b.cnt;
}
  8001fb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800201:	c9                   	leave  
  800202:	c3                   	ret    

00800203 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800203:	55                   	push   %ebp
  800204:	89 e5                	mov    %esp,%ebp
  800206:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800209:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020c:	50                   	push   %eax
  80020d:	ff 75 08             	pushl  0x8(%ebp)
  800210:	e8 9d ff ff ff       	call   8001b2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800215:	c9                   	leave  
  800216:	c3                   	ret    

00800217 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	57                   	push   %edi
  80021b:	56                   	push   %esi
  80021c:	53                   	push   %ebx
  80021d:	83 ec 1c             	sub    $0x1c,%esp
  800220:	89 c6                	mov    %eax,%esi
  800222:	89 d7                	mov    %edx,%edi
  800224:	8b 45 08             	mov    0x8(%ebp),%eax
  800227:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80022d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800230:	8b 45 10             	mov    0x10(%ebp),%eax
  800233:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800236:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80023a:	74 2c                	je     800268 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80023c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80023f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800246:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800249:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80024c:	39 c2                	cmp    %eax,%edx
  80024e:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800251:	73 43                	jae    800296 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800253:	83 eb 01             	sub    $0x1,%ebx
  800256:	85 db                	test   %ebx,%ebx
  800258:	7e 6c                	jle    8002c6 <printnum+0xaf>
				putch(padc, putdat);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	57                   	push   %edi
  80025e:	ff 75 18             	pushl  0x18(%ebp)
  800261:	ff d6                	call   *%esi
  800263:	83 c4 10             	add    $0x10,%esp
  800266:	eb eb                	jmp    800253 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	6a 20                	push   $0x20
  80026d:	6a 00                	push   $0x0
  80026f:	50                   	push   %eax
  800270:	ff 75 e4             	pushl  -0x1c(%ebp)
  800273:	ff 75 e0             	pushl  -0x20(%ebp)
  800276:	89 fa                	mov    %edi,%edx
  800278:	89 f0                	mov    %esi,%eax
  80027a:	e8 98 ff ff ff       	call   800217 <printnum>
		while (--width > 0)
  80027f:	83 c4 20             	add    $0x20,%esp
  800282:	83 eb 01             	sub    $0x1,%ebx
  800285:	85 db                	test   %ebx,%ebx
  800287:	7e 65                	jle    8002ee <printnum+0xd7>
			putch(padc, putdat);
  800289:	83 ec 08             	sub    $0x8,%esp
  80028c:	57                   	push   %edi
  80028d:	6a 20                	push   $0x20
  80028f:	ff d6                	call   *%esi
  800291:	83 c4 10             	add    $0x10,%esp
  800294:	eb ec                	jmp    800282 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	ff 75 18             	pushl  0x18(%ebp)
  80029c:	83 eb 01             	sub    $0x1,%ebx
  80029f:	53                   	push   %ebx
  8002a0:	50                   	push   %eax
  8002a1:	83 ec 08             	sub    $0x8,%esp
  8002a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b0:	e8 fb 20 00 00       	call   8023b0 <__udivdi3>
  8002b5:	83 c4 18             	add    $0x18,%esp
  8002b8:	52                   	push   %edx
  8002b9:	50                   	push   %eax
  8002ba:	89 fa                	mov    %edi,%edx
  8002bc:	89 f0                	mov    %esi,%eax
  8002be:	e8 54 ff ff ff       	call   800217 <printnum>
  8002c3:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002c6:	83 ec 08             	sub    $0x8,%esp
  8002c9:	57                   	push   %edi
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d9:	e8 e2 21 00 00       	call   8024c0 <__umoddi3>
  8002de:	83 c4 14             	add    $0x14,%esp
  8002e1:	0f be 80 57 26 80 00 	movsbl 0x802657(%eax),%eax
  8002e8:	50                   	push   %eax
  8002e9:	ff d6                	call   *%esi
  8002eb:	83 c4 10             	add    $0x10,%esp
	}
}
  8002ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f1:	5b                   	pop    %ebx
  8002f2:	5e                   	pop    %esi
  8002f3:	5f                   	pop    %edi
  8002f4:	5d                   	pop    %ebp
  8002f5:	c3                   	ret    

008002f6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f6:	55                   	push   %ebp
  8002f7:	89 e5                	mov    %esp,%ebp
  8002f9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002fc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800300:	8b 10                	mov    (%eax),%edx
  800302:	3b 50 04             	cmp    0x4(%eax),%edx
  800305:	73 0a                	jae    800311 <sprintputch+0x1b>
		*b->buf++ = ch;
  800307:	8d 4a 01             	lea    0x1(%edx),%ecx
  80030a:	89 08                	mov    %ecx,(%eax)
  80030c:	8b 45 08             	mov    0x8(%ebp),%eax
  80030f:	88 02                	mov    %al,(%edx)
}
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    

00800313 <printfmt>:
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800319:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80031c:	50                   	push   %eax
  80031d:	ff 75 10             	pushl  0x10(%ebp)
  800320:	ff 75 0c             	pushl  0xc(%ebp)
  800323:	ff 75 08             	pushl  0x8(%ebp)
  800326:	e8 05 00 00 00       	call   800330 <vprintfmt>
}
  80032b:	83 c4 10             	add    $0x10,%esp
  80032e:	c9                   	leave  
  80032f:	c3                   	ret    

00800330 <vprintfmt>:
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	57                   	push   %edi
  800334:	56                   	push   %esi
  800335:	53                   	push   %ebx
  800336:	83 ec 3c             	sub    $0x3c,%esp
  800339:	8b 75 08             	mov    0x8(%ebp),%esi
  80033c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80033f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800342:	e9 32 04 00 00       	jmp    800779 <vprintfmt+0x449>
		padc = ' ';
  800347:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80034b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800352:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800359:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800360:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800367:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80036e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800373:	8d 47 01             	lea    0x1(%edi),%eax
  800376:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800379:	0f b6 17             	movzbl (%edi),%edx
  80037c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80037f:	3c 55                	cmp    $0x55,%al
  800381:	0f 87 12 05 00 00    	ja     800899 <vprintfmt+0x569>
  800387:	0f b6 c0             	movzbl %al,%eax
  80038a:	ff 24 85 40 28 80 00 	jmp    *0x802840(,%eax,4)
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800394:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800398:	eb d9                	jmp    800373 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80039a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80039d:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003a1:	eb d0                	jmp    800373 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003a3:	0f b6 d2             	movzbl %dl,%edx
  8003a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ae:	89 75 08             	mov    %esi,0x8(%ebp)
  8003b1:	eb 03                	jmp    8003b6 <vprintfmt+0x86>
  8003b3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003b9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003bd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003c0:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003c3:	83 fe 09             	cmp    $0x9,%esi
  8003c6:	76 eb                	jbe    8003b3 <vprintfmt+0x83>
  8003c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8003ce:	eb 14                	jmp    8003e4 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d3:	8b 00                	mov    (%eax),%eax
  8003d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003db:	8d 40 04             	lea    0x4(%eax),%eax
  8003de:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e8:	79 89                	jns    800373 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003f7:	e9 77 ff ff ff       	jmp    800373 <vprintfmt+0x43>
  8003fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ff:	85 c0                	test   %eax,%eax
  800401:	0f 48 c1             	cmovs  %ecx,%eax
  800404:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800407:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80040a:	e9 64 ff ff ff       	jmp    800373 <vprintfmt+0x43>
  80040f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800412:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800419:	e9 55 ff ff ff       	jmp    800373 <vprintfmt+0x43>
			lflag++;
  80041e:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800422:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800425:	e9 49 ff ff ff       	jmp    800373 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80042a:	8b 45 14             	mov    0x14(%ebp),%eax
  80042d:	8d 78 04             	lea    0x4(%eax),%edi
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	53                   	push   %ebx
  800434:	ff 30                	pushl  (%eax)
  800436:	ff d6                	call   *%esi
			break;
  800438:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80043b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80043e:	e9 33 03 00 00       	jmp    800776 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800443:	8b 45 14             	mov    0x14(%ebp),%eax
  800446:	8d 78 04             	lea    0x4(%eax),%edi
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	99                   	cltd   
  80044c:	31 d0                	xor    %edx,%eax
  80044e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800450:	83 f8 10             	cmp    $0x10,%eax
  800453:	7f 23                	jg     800478 <vprintfmt+0x148>
  800455:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  80045c:	85 d2                	test   %edx,%edx
  80045e:	74 18                	je     800478 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800460:	52                   	push   %edx
  800461:	68 31 2b 80 00       	push   $0x802b31
  800466:	53                   	push   %ebx
  800467:	56                   	push   %esi
  800468:	e8 a6 fe ff ff       	call   800313 <printfmt>
  80046d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800470:	89 7d 14             	mov    %edi,0x14(%ebp)
  800473:	e9 fe 02 00 00       	jmp    800776 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800478:	50                   	push   %eax
  800479:	68 6f 26 80 00       	push   $0x80266f
  80047e:	53                   	push   %ebx
  80047f:	56                   	push   %esi
  800480:	e8 8e fe ff ff       	call   800313 <printfmt>
  800485:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800488:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80048b:	e9 e6 02 00 00       	jmp    800776 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800490:	8b 45 14             	mov    0x14(%ebp),%eax
  800493:	83 c0 04             	add    $0x4,%eax
  800496:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800499:	8b 45 14             	mov    0x14(%ebp),%eax
  80049c:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80049e:	85 c9                	test   %ecx,%ecx
  8004a0:	b8 68 26 80 00       	mov    $0x802668,%eax
  8004a5:	0f 45 c1             	cmovne %ecx,%eax
  8004a8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004af:	7e 06                	jle    8004b7 <vprintfmt+0x187>
  8004b1:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004b5:	75 0d                	jne    8004c4 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004ba:	89 c7                	mov    %eax,%edi
  8004bc:	03 45 e0             	add    -0x20(%ebp),%eax
  8004bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c2:	eb 53                	jmp    800517 <vprintfmt+0x1e7>
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	ff 75 d8             	pushl  -0x28(%ebp)
  8004ca:	50                   	push   %eax
  8004cb:	e8 71 04 00 00       	call   800941 <strnlen>
  8004d0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d3:	29 c1                	sub    %eax,%ecx
  8004d5:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004d8:	83 c4 10             	add    $0x10,%esp
  8004db:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004dd:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e4:	eb 0f                	jmp    8004f5 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	53                   	push   %ebx
  8004ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ed:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ef:	83 ef 01             	sub    $0x1,%edi
  8004f2:	83 c4 10             	add    $0x10,%esp
  8004f5:	85 ff                	test   %edi,%edi
  8004f7:	7f ed                	jg     8004e6 <vprintfmt+0x1b6>
  8004f9:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004fc:	85 c9                	test   %ecx,%ecx
  8004fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800503:	0f 49 c1             	cmovns %ecx,%eax
  800506:	29 c1                	sub    %eax,%ecx
  800508:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80050b:	eb aa                	jmp    8004b7 <vprintfmt+0x187>
					putch(ch, putdat);
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	53                   	push   %ebx
  800511:	52                   	push   %edx
  800512:	ff d6                	call   *%esi
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80051a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80051c:	83 c7 01             	add    $0x1,%edi
  80051f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800523:	0f be d0             	movsbl %al,%edx
  800526:	85 d2                	test   %edx,%edx
  800528:	74 4b                	je     800575 <vprintfmt+0x245>
  80052a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80052e:	78 06                	js     800536 <vprintfmt+0x206>
  800530:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800534:	78 1e                	js     800554 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800536:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80053a:	74 d1                	je     80050d <vprintfmt+0x1dd>
  80053c:	0f be c0             	movsbl %al,%eax
  80053f:	83 e8 20             	sub    $0x20,%eax
  800542:	83 f8 5e             	cmp    $0x5e,%eax
  800545:	76 c6                	jbe    80050d <vprintfmt+0x1dd>
					putch('?', putdat);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	53                   	push   %ebx
  80054b:	6a 3f                	push   $0x3f
  80054d:	ff d6                	call   *%esi
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	eb c3                	jmp    800517 <vprintfmt+0x1e7>
  800554:	89 cf                	mov    %ecx,%edi
  800556:	eb 0e                	jmp    800566 <vprintfmt+0x236>
				putch(' ', putdat);
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	53                   	push   %ebx
  80055c:	6a 20                	push   $0x20
  80055e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800560:	83 ef 01             	sub    $0x1,%edi
  800563:	83 c4 10             	add    $0x10,%esp
  800566:	85 ff                	test   %edi,%edi
  800568:	7f ee                	jg     800558 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80056a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
  800570:	e9 01 02 00 00       	jmp    800776 <vprintfmt+0x446>
  800575:	89 cf                	mov    %ecx,%edi
  800577:	eb ed                	jmp    800566 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800579:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80057c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800583:	e9 eb fd ff ff       	jmp    800373 <vprintfmt+0x43>
	if (lflag >= 2)
  800588:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80058c:	7f 21                	jg     8005af <vprintfmt+0x27f>
	else if (lflag)
  80058e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800592:	74 68                	je     8005fc <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8b 00                	mov    (%eax),%eax
  800599:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80059c:	89 c1                	mov    %eax,%ecx
  80059e:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8d 40 04             	lea    0x4(%eax),%eax
  8005aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ad:	eb 17                	jmp    8005c6 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8b 50 04             	mov    0x4(%eax),%edx
  8005b5:	8b 00                	mov    (%eax),%eax
  8005b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ba:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	8d 40 08             	lea    0x8(%eax),%eax
  8005c3:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005d2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005d6:	78 3f                	js     800617 <vprintfmt+0x2e7>
			base = 10;
  8005d8:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005dd:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005e1:	0f 84 71 01 00 00    	je     800758 <vprintfmt+0x428>
				putch('+', putdat);
  8005e7:	83 ec 08             	sub    $0x8,%esp
  8005ea:	53                   	push   %ebx
  8005eb:	6a 2b                	push   $0x2b
  8005ed:	ff d6                	call   *%esi
  8005ef:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005f2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f7:	e9 5c 01 00 00       	jmp    800758 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800604:	89 c1                	mov    %eax,%ecx
  800606:	c1 f9 1f             	sar    $0x1f,%ecx
  800609:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8d 40 04             	lea    0x4(%eax),%eax
  800612:	89 45 14             	mov    %eax,0x14(%ebp)
  800615:	eb af                	jmp    8005c6 <vprintfmt+0x296>
				putch('-', putdat);
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	53                   	push   %ebx
  80061b:	6a 2d                	push   $0x2d
  80061d:	ff d6                	call   *%esi
				num = -(long long) num;
  80061f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800622:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800625:	f7 d8                	neg    %eax
  800627:	83 d2 00             	adc    $0x0,%edx
  80062a:	f7 da                	neg    %edx
  80062c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800632:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800635:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063a:	e9 19 01 00 00       	jmp    800758 <vprintfmt+0x428>
	if (lflag >= 2)
  80063f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800643:	7f 29                	jg     80066e <vprintfmt+0x33e>
	else if (lflag)
  800645:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800649:	74 44                	je     80068f <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	ba 00 00 00 00       	mov    $0x0,%edx
  800655:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800658:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8d 40 04             	lea    0x4(%eax),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800664:	b8 0a 00 00 00       	mov    $0xa,%eax
  800669:	e9 ea 00 00 00       	jmp    800758 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8b 50 04             	mov    0x4(%eax),%edx
  800674:	8b 00                	mov    (%eax),%eax
  800676:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800679:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8d 40 08             	lea    0x8(%eax),%eax
  800682:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800685:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068a:	e9 c9 00 00 00       	jmp    800758 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	ba 00 00 00 00       	mov    $0x0,%edx
  800699:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8d 40 04             	lea    0x4(%eax),%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ad:	e9 a6 00 00 00       	jmp    800758 <vprintfmt+0x428>
			putch('0', putdat);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	53                   	push   %ebx
  8006b6:	6a 30                	push   $0x30
  8006b8:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006ba:	83 c4 10             	add    $0x10,%esp
  8006bd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006c1:	7f 26                	jg     8006e9 <vprintfmt+0x3b9>
	else if (lflag)
  8006c3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006c7:	74 3e                	je     800707 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8d 40 04             	lea    0x4(%eax),%eax
  8006df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e2:	b8 08 00 00 00       	mov    $0x8,%eax
  8006e7:	eb 6f                	jmp    800758 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	8b 50 04             	mov    0x4(%eax),%edx
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	8d 40 08             	lea    0x8(%eax),%eax
  8006fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800700:	b8 08 00 00 00       	mov    $0x8,%eax
  800705:	eb 51                	jmp    800758 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	ba 00 00 00 00       	mov    $0x0,%edx
  800711:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800714:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8d 40 04             	lea    0x4(%eax),%eax
  80071d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800720:	b8 08 00 00 00       	mov    $0x8,%eax
  800725:	eb 31                	jmp    800758 <vprintfmt+0x428>
			putch('0', putdat);
  800727:	83 ec 08             	sub    $0x8,%esp
  80072a:	53                   	push   %ebx
  80072b:	6a 30                	push   $0x30
  80072d:	ff d6                	call   *%esi
			putch('x', putdat);
  80072f:	83 c4 08             	add    $0x8,%esp
  800732:	53                   	push   %ebx
  800733:	6a 78                	push   $0x78
  800735:	ff d6                	call   *%esi
			num = (unsigned long long)
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	ba 00 00 00 00       	mov    $0x0,%edx
  800741:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800744:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800747:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80074a:	8b 45 14             	mov    0x14(%ebp),%eax
  80074d:	8d 40 04             	lea    0x4(%eax),%eax
  800750:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800753:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800758:	83 ec 0c             	sub    $0xc,%esp
  80075b:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80075f:	52                   	push   %edx
  800760:	ff 75 e0             	pushl  -0x20(%ebp)
  800763:	50                   	push   %eax
  800764:	ff 75 dc             	pushl  -0x24(%ebp)
  800767:	ff 75 d8             	pushl  -0x28(%ebp)
  80076a:	89 da                	mov    %ebx,%edx
  80076c:	89 f0                	mov    %esi,%eax
  80076e:	e8 a4 fa ff ff       	call   800217 <printnum>
			break;
  800773:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800776:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800779:	83 c7 01             	add    $0x1,%edi
  80077c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800780:	83 f8 25             	cmp    $0x25,%eax
  800783:	0f 84 be fb ff ff    	je     800347 <vprintfmt+0x17>
			if (ch == '\0')
  800789:	85 c0                	test   %eax,%eax
  80078b:	0f 84 28 01 00 00    	je     8008b9 <vprintfmt+0x589>
			putch(ch, putdat);
  800791:	83 ec 08             	sub    $0x8,%esp
  800794:	53                   	push   %ebx
  800795:	50                   	push   %eax
  800796:	ff d6                	call   *%esi
  800798:	83 c4 10             	add    $0x10,%esp
  80079b:	eb dc                	jmp    800779 <vprintfmt+0x449>
	if (lflag >= 2)
  80079d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007a1:	7f 26                	jg     8007c9 <vprintfmt+0x499>
	else if (lflag)
  8007a3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007a7:	74 41                	je     8007ea <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	8d 40 04             	lea    0x4(%eax),%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c2:	b8 10 00 00 00       	mov    $0x10,%eax
  8007c7:	eb 8f                	jmp    800758 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8b 50 04             	mov    0x4(%eax),%edx
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8d 40 08             	lea    0x8(%eax),%eax
  8007dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e0:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e5:	e9 6e ff ff ff       	jmp    800758 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	8d 40 04             	lea    0x4(%eax),%eax
  800800:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800803:	b8 10 00 00 00       	mov    $0x10,%eax
  800808:	e9 4b ff ff ff       	jmp    800758 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	83 c0 04             	add    $0x4,%eax
  800813:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	85 c0                	test   %eax,%eax
  80081d:	74 14                	je     800833 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80081f:	8b 13                	mov    (%ebx),%edx
  800821:	83 fa 7f             	cmp    $0x7f,%edx
  800824:	7f 37                	jg     80085d <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800826:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800828:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80082b:	89 45 14             	mov    %eax,0x14(%ebp)
  80082e:	e9 43 ff ff ff       	jmp    800776 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800833:	b8 0a 00 00 00       	mov    $0xa,%eax
  800838:	bf 8d 27 80 00       	mov    $0x80278d,%edi
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
  800850:	75 eb                	jne    80083d <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800852:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800855:	89 45 14             	mov    %eax,0x14(%ebp)
  800858:	e9 19 ff ff ff       	jmp    800776 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80085d:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80085f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800864:	bf c5 27 80 00       	mov    $0x8027c5,%edi
							putch(ch, putdat);
  800869:	83 ec 08             	sub    $0x8,%esp
  80086c:	53                   	push   %ebx
  80086d:	50                   	push   %eax
  80086e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800870:	83 c7 01             	add    $0x1,%edi
  800873:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800877:	83 c4 10             	add    $0x10,%esp
  80087a:	85 c0                	test   %eax,%eax
  80087c:	75 eb                	jne    800869 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80087e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800881:	89 45 14             	mov    %eax,0x14(%ebp)
  800884:	e9 ed fe ff ff       	jmp    800776 <vprintfmt+0x446>
			putch(ch, putdat);
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	53                   	push   %ebx
  80088d:	6a 25                	push   $0x25
  80088f:	ff d6                	call   *%esi
			break;
  800891:	83 c4 10             	add    $0x10,%esp
  800894:	e9 dd fe ff ff       	jmp    800776 <vprintfmt+0x446>
			putch('%', putdat);
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	53                   	push   %ebx
  80089d:	6a 25                	push   $0x25
  80089f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008a1:	83 c4 10             	add    $0x10,%esp
  8008a4:	89 f8                	mov    %edi,%eax
  8008a6:	eb 03                	jmp    8008ab <vprintfmt+0x57b>
  8008a8:	83 e8 01             	sub    $0x1,%eax
  8008ab:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008af:	75 f7                	jne    8008a8 <vprintfmt+0x578>
  8008b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008b4:	e9 bd fe ff ff       	jmp    800776 <vprintfmt+0x446>
}
  8008b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008bc:	5b                   	pop    %ebx
  8008bd:	5e                   	pop    %esi
  8008be:	5f                   	pop    %edi
  8008bf:	5d                   	pop    %ebp
  8008c0:	c3                   	ret    

008008c1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	83 ec 18             	sub    $0x18,%esp
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008d0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008d4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008de:	85 c0                	test   %eax,%eax
  8008e0:	74 26                	je     800908 <vsnprintf+0x47>
  8008e2:	85 d2                	test   %edx,%edx
  8008e4:	7e 22                	jle    800908 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e6:	ff 75 14             	pushl  0x14(%ebp)
  8008e9:	ff 75 10             	pushl  0x10(%ebp)
  8008ec:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ef:	50                   	push   %eax
  8008f0:	68 f6 02 80 00       	push   $0x8002f6
  8008f5:	e8 36 fa ff ff       	call   800330 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008fd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800903:	83 c4 10             	add    $0x10,%esp
}
  800906:	c9                   	leave  
  800907:	c3                   	ret    
		return -E_INVAL;
  800908:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80090d:	eb f7                	jmp    800906 <vsnprintf+0x45>

0080090f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800915:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800918:	50                   	push   %eax
  800919:	ff 75 10             	pushl  0x10(%ebp)
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	ff 75 08             	pushl  0x8(%ebp)
  800922:	e8 9a ff ff ff       	call   8008c1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800927:	c9                   	leave  
  800928:	c3                   	ret    

00800929 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80092f:	b8 00 00 00 00       	mov    $0x0,%eax
  800934:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800938:	74 05                	je     80093f <strlen+0x16>
		n++;
  80093a:	83 c0 01             	add    $0x1,%eax
  80093d:	eb f5                	jmp    800934 <strlen+0xb>
	return n;
}
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    

00800941 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800947:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80094a:	ba 00 00 00 00       	mov    $0x0,%edx
  80094f:	39 c2                	cmp    %eax,%edx
  800951:	74 0d                	je     800960 <strnlen+0x1f>
  800953:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800957:	74 05                	je     80095e <strnlen+0x1d>
		n++;
  800959:	83 c2 01             	add    $0x1,%edx
  80095c:	eb f1                	jmp    80094f <strnlen+0xe>
  80095e:	89 d0                	mov    %edx,%eax
	return n;
}
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	53                   	push   %ebx
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80096c:	ba 00 00 00 00       	mov    $0x0,%edx
  800971:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800975:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800978:	83 c2 01             	add    $0x1,%edx
  80097b:	84 c9                	test   %cl,%cl
  80097d:	75 f2                	jne    800971 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80097f:	5b                   	pop    %ebx
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	53                   	push   %ebx
  800986:	83 ec 10             	sub    $0x10,%esp
  800989:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80098c:	53                   	push   %ebx
  80098d:	e8 97 ff ff ff       	call   800929 <strlen>
  800992:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	01 d8                	add    %ebx,%eax
  80099a:	50                   	push   %eax
  80099b:	e8 c2 ff ff ff       	call   800962 <strcpy>
	return dst;
}
  8009a0:	89 d8                	mov    %ebx,%eax
  8009a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009a5:	c9                   	leave  
  8009a6:	c3                   	ret    

008009a7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	56                   	push   %esi
  8009ab:	53                   	push   %ebx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b2:	89 c6                	mov    %eax,%esi
  8009b4:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b7:	89 c2                	mov    %eax,%edx
  8009b9:	39 f2                	cmp    %esi,%edx
  8009bb:	74 11                	je     8009ce <strncpy+0x27>
		*dst++ = *src;
  8009bd:	83 c2 01             	add    $0x1,%edx
  8009c0:	0f b6 19             	movzbl (%ecx),%ebx
  8009c3:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009c6:	80 fb 01             	cmp    $0x1,%bl
  8009c9:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009cc:	eb eb                	jmp    8009b9 <strncpy+0x12>
	}
	return ret;
}
  8009ce:	5b                   	pop    %ebx
  8009cf:	5e                   	pop    %esi
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    

008009d2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	56                   	push   %esi
  8009d6:	53                   	push   %ebx
  8009d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009dd:	8b 55 10             	mov    0x10(%ebp),%edx
  8009e0:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009e2:	85 d2                	test   %edx,%edx
  8009e4:	74 21                	je     800a07 <strlcpy+0x35>
  8009e6:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009ea:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009ec:	39 c2                	cmp    %eax,%edx
  8009ee:	74 14                	je     800a04 <strlcpy+0x32>
  8009f0:	0f b6 19             	movzbl (%ecx),%ebx
  8009f3:	84 db                	test   %bl,%bl
  8009f5:	74 0b                	je     800a02 <strlcpy+0x30>
			*dst++ = *src++;
  8009f7:	83 c1 01             	add    $0x1,%ecx
  8009fa:	83 c2 01             	add    $0x1,%edx
  8009fd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a00:	eb ea                	jmp    8009ec <strlcpy+0x1a>
  800a02:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a04:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a07:	29 f0                	sub    %esi,%eax
}
  800a09:	5b                   	pop    %ebx
  800a0a:	5e                   	pop    %esi
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    

00800a0d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a13:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a16:	0f b6 01             	movzbl (%ecx),%eax
  800a19:	84 c0                	test   %al,%al
  800a1b:	74 0c                	je     800a29 <strcmp+0x1c>
  800a1d:	3a 02                	cmp    (%edx),%al
  800a1f:	75 08                	jne    800a29 <strcmp+0x1c>
		p++, q++;
  800a21:	83 c1 01             	add    $0x1,%ecx
  800a24:	83 c2 01             	add    $0x1,%edx
  800a27:	eb ed                	jmp    800a16 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a29:	0f b6 c0             	movzbl %al,%eax
  800a2c:	0f b6 12             	movzbl (%edx),%edx
  800a2f:	29 d0                	sub    %edx,%eax
}
  800a31:	5d                   	pop    %ebp
  800a32:	c3                   	ret    

00800a33 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	53                   	push   %ebx
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3d:	89 c3                	mov    %eax,%ebx
  800a3f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a42:	eb 06                	jmp    800a4a <strncmp+0x17>
		n--, p++, q++;
  800a44:	83 c0 01             	add    $0x1,%eax
  800a47:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a4a:	39 d8                	cmp    %ebx,%eax
  800a4c:	74 16                	je     800a64 <strncmp+0x31>
  800a4e:	0f b6 08             	movzbl (%eax),%ecx
  800a51:	84 c9                	test   %cl,%cl
  800a53:	74 04                	je     800a59 <strncmp+0x26>
  800a55:	3a 0a                	cmp    (%edx),%cl
  800a57:	74 eb                	je     800a44 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a59:	0f b6 00             	movzbl (%eax),%eax
  800a5c:	0f b6 12             	movzbl (%edx),%edx
  800a5f:	29 d0                	sub    %edx,%eax
}
  800a61:	5b                   	pop    %ebx
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    
		return 0;
  800a64:	b8 00 00 00 00       	mov    $0x0,%eax
  800a69:	eb f6                	jmp    800a61 <strncmp+0x2e>

00800a6b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a75:	0f b6 10             	movzbl (%eax),%edx
  800a78:	84 d2                	test   %dl,%dl
  800a7a:	74 09                	je     800a85 <strchr+0x1a>
		if (*s == c)
  800a7c:	38 ca                	cmp    %cl,%dl
  800a7e:	74 0a                	je     800a8a <strchr+0x1f>
	for (; *s; s++)
  800a80:	83 c0 01             	add    $0x1,%eax
  800a83:	eb f0                	jmp    800a75 <strchr+0xa>
			return (char *) s;
	return 0;
  800a85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a8a:	5d                   	pop    %ebp
  800a8b:	c3                   	ret    

00800a8c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a96:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a99:	38 ca                	cmp    %cl,%dl
  800a9b:	74 09                	je     800aa6 <strfind+0x1a>
  800a9d:	84 d2                	test   %dl,%dl
  800a9f:	74 05                	je     800aa6 <strfind+0x1a>
	for (; *s; s++)
  800aa1:	83 c0 01             	add    $0x1,%eax
  800aa4:	eb f0                	jmp    800a96 <strfind+0xa>
			break;
	return (char *) s;
}
  800aa6:	5d                   	pop    %ebp
  800aa7:	c3                   	ret    

00800aa8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	57                   	push   %edi
  800aac:	56                   	push   %esi
  800aad:	53                   	push   %ebx
  800aae:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ab1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ab4:	85 c9                	test   %ecx,%ecx
  800ab6:	74 31                	je     800ae9 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ab8:	89 f8                	mov    %edi,%eax
  800aba:	09 c8                	or     %ecx,%eax
  800abc:	a8 03                	test   $0x3,%al
  800abe:	75 23                	jne    800ae3 <memset+0x3b>
		c &= 0xFF;
  800ac0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac4:	89 d3                	mov    %edx,%ebx
  800ac6:	c1 e3 08             	shl    $0x8,%ebx
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	c1 e0 18             	shl    $0x18,%eax
  800ace:	89 d6                	mov    %edx,%esi
  800ad0:	c1 e6 10             	shl    $0x10,%esi
  800ad3:	09 f0                	or     %esi,%eax
  800ad5:	09 c2                	or     %eax,%edx
  800ad7:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ad9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800adc:	89 d0                	mov    %edx,%eax
  800ade:	fc                   	cld    
  800adf:	f3 ab                	rep stos %eax,%es:(%edi)
  800ae1:	eb 06                	jmp    800ae9 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae6:	fc                   	cld    
  800ae7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ae9:	89 f8                	mov    %edi,%eax
  800aeb:	5b                   	pop    %ebx
  800aec:	5e                   	pop    %esi
  800aed:	5f                   	pop    %edi
  800aee:	5d                   	pop    %ebp
  800aef:	c3                   	ret    

00800af0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	57                   	push   %edi
  800af4:	56                   	push   %esi
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800afb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800afe:	39 c6                	cmp    %eax,%esi
  800b00:	73 32                	jae    800b34 <memmove+0x44>
  800b02:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b05:	39 c2                	cmp    %eax,%edx
  800b07:	76 2b                	jbe    800b34 <memmove+0x44>
		s += n;
		d += n;
  800b09:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0c:	89 fe                	mov    %edi,%esi
  800b0e:	09 ce                	or     %ecx,%esi
  800b10:	09 d6                	or     %edx,%esi
  800b12:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b18:	75 0e                	jne    800b28 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b1a:	83 ef 04             	sub    $0x4,%edi
  800b1d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b20:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b23:	fd                   	std    
  800b24:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b26:	eb 09                	jmp    800b31 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b28:	83 ef 01             	sub    $0x1,%edi
  800b2b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b2e:	fd                   	std    
  800b2f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b31:	fc                   	cld    
  800b32:	eb 1a                	jmp    800b4e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b34:	89 c2                	mov    %eax,%edx
  800b36:	09 ca                	or     %ecx,%edx
  800b38:	09 f2                	or     %esi,%edx
  800b3a:	f6 c2 03             	test   $0x3,%dl
  800b3d:	75 0a                	jne    800b49 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b3f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b42:	89 c7                	mov    %eax,%edi
  800b44:	fc                   	cld    
  800b45:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b47:	eb 05                	jmp    800b4e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b49:	89 c7                	mov    %eax,%edi
  800b4b:	fc                   	cld    
  800b4c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b4e:	5e                   	pop    %esi
  800b4f:	5f                   	pop    %edi
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    

00800b52 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b58:	ff 75 10             	pushl  0x10(%ebp)
  800b5b:	ff 75 0c             	pushl  0xc(%ebp)
  800b5e:	ff 75 08             	pushl  0x8(%ebp)
  800b61:	e8 8a ff ff ff       	call   800af0 <memmove>
}
  800b66:	c9                   	leave  
  800b67:	c3                   	ret    

00800b68 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	56                   	push   %esi
  800b6c:	53                   	push   %ebx
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b73:	89 c6                	mov    %eax,%esi
  800b75:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b78:	39 f0                	cmp    %esi,%eax
  800b7a:	74 1c                	je     800b98 <memcmp+0x30>
		if (*s1 != *s2)
  800b7c:	0f b6 08             	movzbl (%eax),%ecx
  800b7f:	0f b6 1a             	movzbl (%edx),%ebx
  800b82:	38 d9                	cmp    %bl,%cl
  800b84:	75 08                	jne    800b8e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b86:	83 c0 01             	add    $0x1,%eax
  800b89:	83 c2 01             	add    $0x1,%edx
  800b8c:	eb ea                	jmp    800b78 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b8e:	0f b6 c1             	movzbl %cl,%eax
  800b91:	0f b6 db             	movzbl %bl,%ebx
  800b94:	29 d8                	sub    %ebx,%eax
  800b96:	eb 05                	jmp    800b9d <memcmp+0x35>
	}

	return 0;
  800b98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b9d:	5b                   	pop    %ebx
  800b9e:	5e                   	pop    %esi
  800b9f:	5d                   	pop    %ebp
  800ba0:	c3                   	ret    

00800ba1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800baa:	89 c2                	mov    %eax,%edx
  800bac:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800baf:	39 d0                	cmp    %edx,%eax
  800bb1:	73 09                	jae    800bbc <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb3:	38 08                	cmp    %cl,(%eax)
  800bb5:	74 05                	je     800bbc <memfind+0x1b>
	for (; s < ends; s++)
  800bb7:	83 c0 01             	add    $0x1,%eax
  800bba:	eb f3                	jmp    800baf <memfind+0xe>
			break;
	return (void *) s;
}
  800bbc:	5d                   	pop    %ebp
  800bbd:	c3                   	ret    

00800bbe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	57                   	push   %edi
  800bc2:	56                   	push   %esi
  800bc3:	53                   	push   %ebx
  800bc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bca:	eb 03                	jmp    800bcf <strtol+0x11>
		s++;
  800bcc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bcf:	0f b6 01             	movzbl (%ecx),%eax
  800bd2:	3c 20                	cmp    $0x20,%al
  800bd4:	74 f6                	je     800bcc <strtol+0xe>
  800bd6:	3c 09                	cmp    $0x9,%al
  800bd8:	74 f2                	je     800bcc <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bda:	3c 2b                	cmp    $0x2b,%al
  800bdc:	74 2a                	je     800c08 <strtol+0x4a>
	int neg = 0;
  800bde:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800be3:	3c 2d                	cmp    $0x2d,%al
  800be5:	74 2b                	je     800c12 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bed:	75 0f                	jne    800bfe <strtol+0x40>
  800bef:	80 39 30             	cmpb   $0x30,(%ecx)
  800bf2:	74 28                	je     800c1c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf4:	85 db                	test   %ebx,%ebx
  800bf6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bfb:	0f 44 d8             	cmove  %eax,%ebx
  800bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  800c03:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c06:	eb 50                	jmp    800c58 <strtol+0x9a>
		s++;
  800c08:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c0b:	bf 00 00 00 00       	mov    $0x0,%edi
  800c10:	eb d5                	jmp    800be7 <strtol+0x29>
		s++, neg = 1;
  800c12:	83 c1 01             	add    $0x1,%ecx
  800c15:	bf 01 00 00 00       	mov    $0x1,%edi
  800c1a:	eb cb                	jmp    800be7 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c1c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c20:	74 0e                	je     800c30 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c22:	85 db                	test   %ebx,%ebx
  800c24:	75 d8                	jne    800bfe <strtol+0x40>
		s++, base = 8;
  800c26:	83 c1 01             	add    $0x1,%ecx
  800c29:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c2e:	eb ce                	jmp    800bfe <strtol+0x40>
		s += 2, base = 16;
  800c30:	83 c1 02             	add    $0x2,%ecx
  800c33:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c38:	eb c4                	jmp    800bfe <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c3a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c3d:	89 f3                	mov    %esi,%ebx
  800c3f:	80 fb 19             	cmp    $0x19,%bl
  800c42:	77 29                	ja     800c6d <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c44:	0f be d2             	movsbl %dl,%edx
  800c47:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c4a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c4d:	7d 30                	jge    800c7f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c4f:	83 c1 01             	add    $0x1,%ecx
  800c52:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c56:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c58:	0f b6 11             	movzbl (%ecx),%edx
  800c5b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c5e:	89 f3                	mov    %esi,%ebx
  800c60:	80 fb 09             	cmp    $0x9,%bl
  800c63:	77 d5                	ja     800c3a <strtol+0x7c>
			dig = *s - '0';
  800c65:	0f be d2             	movsbl %dl,%edx
  800c68:	83 ea 30             	sub    $0x30,%edx
  800c6b:	eb dd                	jmp    800c4a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c6d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c70:	89 f3                	mov    %esi,%ebx
  800c72:	80 fb 19             	cmp    $0x19,%bl
  800c75:	77 08                	ja     800c7f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c77:	0f be d2             	movsbl %dl,%edx
  800c7a:	83 ea 37             	sub    $0x37,%edx
  800c7d:	eb cb                	jmp    800c4a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c83:	74 05                	je     800c8a <strtol+0xcc>
		*endptr = (char *) s;
  800c85:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c88:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c8a:	89 c2                	mov    %eax,%edx
  800c8c:	f7 da                	neg    %edx
  800c8e:	85 ff                	test   %edi,%edi
  800c90:	0f 45 c2             	cmovne %edx,%eax
}
  800c93:	5b                   	pop    %ebx
  800c94:	5e                   	pop    %esi
  800c95:	5f                   	pop    %edi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	57                   	push   %edi
  800c9c:	56                   	push   %esi
  800c9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca9:	89 c3                	mov    %eax,%ebx
  800cab:	89 c7                	mov    %eax,%edi
  800cad:	89 c6                	mov    %eax,%esi
  800caf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb1:	5b                   	pop    %ebx
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    

00800cb6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	57                   	push   %edi
  800cba:	56                   	push   %esi
  800cbb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc1:	b8 01 00 00 00       	mov    $0x1,%eax
  800cc6:	89 d1                	mov    %edx,%ecx
  800cc8:	89 d3                	mov    %edx,%ebx
  800cca:	89 d7                	mov    %edx,%edi
  800ccc:	89 d6                	mov    %edx,%esi
  800cce:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cd0:	5b                   	pop    %ebx
  800cd1:	5e                   	pop    %esi
  800cd2:	5f                   	pop    %edi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	57                   	push   %edi
  800cd9:	56                   	push   %esi
  800cda:	53                   	push   %ebx
  800cdb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cde:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce6:	b8 03 00 00 00       	mov    $0x3,%eax
  800ceb:	89 cb                	mov    %ecx,%ebx
  800ced:	89 cf                	mov    %ecx,%edi
  800cef:	89 ce                	mov    %ecx,%esi
  800cf1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf3:	85 c0                	test   %eax,%eax
  800cf5:	7f 08                	jg     800cff <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5f                   	pop    %edi
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cff:	83 ec 0c             	sub    $0xc,%esp
  800d02:	50                   	push   %eax
  800d03:	6a 03                	push   $0x3
  800d05:	68 e4 29 80 00       	push   $0x8029e4
  800d0a:	6a 43                	push   $0x43
  800d0c:	68 01 2a 80 00       	push   $0x802a01
  800d11:	e8 fe 14 00 00       	call   802214 <_panic>

00800d16 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	57                   	push   %edi
  800d1a:	56                   	push   %esi
  800d1b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d21:	b8 02 00 00 00       	mov    $0x2,%eax
  800d26:	89 d1                	mov    %edx,%ecx
  800d28:	89 d3                	mov    %edx,%ebx
  800d2a:	89 d7                	mov    %edx,%edi
  800d2c:	89 d6                	mov    %edx,%esi
  800d2e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d30:	5b                   	pop    %ebx
  800d31:	5e                   	pop    %esi
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <sys_yield>:

void
sys_yield(void)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	57                   	push   %edi
  800d39:	56                   	push   %esi
  800d3a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d40:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d45:	89 d1                	mov    %edx,%ecx
  800d47:	89 d3                	mov    %edx,%ebx
  800d49:	89 d7                	mov    %edx,%edi
  800d4b:	89 d6                	mov    %edx,%esi
  800d4d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d4f:	5b                   	pop    %ebx
  800d50:	5e                   	pop    %esi
  800d51:	5f                   	pop    %edi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	57                   	push   %edi
  800d58:	56                   	push   %esi
  800d59:	53                   	push   %ebx
  800d5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5d:	be 00 00 00 00       	mov    $0x0,%esi
  800d62:	8b 55 08             	mov    0x8(%ebp),%edx
  800d65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d68:	b8 04 00 00 00       	mov    $0x4,%eax
  800d6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d70:	89 f7                	mov    %esi,%edi
  800d72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d74:	85 c0                	test   %eax,%eax
  800d76:	7f 08                	jg     800d80 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d80:	83 ec 0c             	sub    $0xc,%esp
  800d83:	50                   	push   %eax
  800d84:	6a 04                	push   $0x4
  800d86:	68 e4 29 80 00       	push   $0x8029e4
  800d8b:	6a 43                	push   $0x43
  800d8d:	68 01 2a 80 00       	push   $0x802a01
  800d92:	e8 7d 14 00 00       	call   802214 <_panic>

00800d97 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	57                   	push   %edi
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
  800d9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da0:	8b 55 08             	mov    0x8(%ebp),%edx
  800da3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da6:	b8 05 00 00 00       	mov    $0x5,%eax
  800dab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dae:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db1:	8b 75 18             	mov    0x18(%ebp),%esi
  800db4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db6:	85 c0                	test   %eax,%eax
  800db8:	7f 08                	jg     800dc2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbd:	5b                   	pop    %ebx
  800dbe:	5e                   	pop    %esi
  800dbf:	5f                   	pop    %edi
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc2:	83 ec 0c             	sub    $0xc,%esp
  800dc5:	50                   	push   %eax
  800dc6:	6a 05                	push   $0x5
  800dc8:	68 e4 29 80 00       	push   $0x8029e4
  800dcd:	6a 43                	push   $0x43
  800dcf:	68 01 2a 80 00       	push   $0x802a01
  800dd4:	e8 3b 14 00 00       	call   802214 <_panic>

00800dd9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
  800ddf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ded:	b8 06 00 00 00       	mov    $0x6,%eax
  800df2:	89 df                	mov    %ebx,%edi
  800df4:	89 de                	mov    %ebx,%esi
  800df6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	7f 08                	jg     800e04 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e04:	83 ec 0c             	sub    $0xc,%esp
  800e07:	50                   	push   %eax
  800e08:	6a 06                	push   $0x6
  800e0a:	68 e4 29 80 00       	push   $0x8029e4
  800e0f:	6a 43                	push   $0x43
  800e11:	68 01 2a 80 00       	push   $0x802a01
  800e16:	e8 f9 13 00 00       	call   802214 <_panic>

00800e1b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	57                   	push   %edi
  800e1f:	56                   	push   %esi
  800e20:	53                   	push   %ebx
  800e21:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e24:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e29:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2f:	b8 08 00 00 00       	mov    $0x8,%eax
  800e34:	89 df                	mov    %ebx,%edi
  800e36:	89 de                	mov    %ebx,%esi
  800e38:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	7f 08                	jg     800e46 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e46:	83 ec 0c             	sub    $0xc,%esp
  800e49:	50                   	push   %eax
  800e4a:	6a 08                	push   $0x8
  800e4c:	68 e4 29 80 00       	push   $0x8029e4
  800e51:	6a 43                	push   $0x43
  800e53:	68 01 2a 80 00       	push   $0x802a01
  800e58:	e8 b7 13 00 00       	call   802214 <_panic>

00800e5d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	57                   	push   %edi
  800e61:	56                   	push   %esi
  800e62:	53                   	push   %ebx
  800e63:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e71:	b8 09 00 00 00       	mov    $0x9,%eax
  800e76:	89 df                	mov    %ebx,%edi
  800e78:	89 de                	mov    %ebx,%esi
  800e7a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7c:	85 c0                	test   %eax,%eax
  800e7e:	7f 08                	jg     800e88 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e83:	5b                   	pop    %ebx
  800e84:	5e                   	pop    %esi
  800e85:	5f                   	pop    %edi
  800e86:	5d                   	pop    %ebp
  800e87:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e88:	83 ec 0c             	sub    $0xc,%esp
  800e8b:	50                   	push   %eax
  800e8c:	6a 09                	push   $0x9
  800e8e:	68 e4 29 80 00       	push   $0x8029e4
  800e93:	6a 43                	push   $0x43
  800e95:	68 01 2a 80 00       	push   $0x802a01
  800e9a:	e8 75 13 00 00       	call   802214 <_panic>

00800e9f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
  800ea5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ead:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb8:	89 df                	mov    %ebx,%edi
  800eba:	89 de                	mov    %ebx,%esi
  800ebc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	7f 08                	jg     800eca <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ec2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec5:	5b                   	pop    %ebx
  800ec6:	5e                   	pop    %esi
  800ec7:	5f                   	pop    %edi
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eca:	83 ec 0c             	sub    $0xc,%esp
  800ecd:	50                   	push   %eax
  800ece:	6a 0a                	push   $0xa
  800ed0:	68 e4 29 80 00       	push   $0x8029e4
  800ed5:	6a 43                	push   $0x43
  800ed7:	68 01 2a 80 00       	push   $0x802a01
  800edc:	e8 33 13 00 00       	call   802214 <_panic>

00800ee1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	57                   	push   %edi
  800ee5:	56                   	push   %esi
  800ee6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eed:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef2:	be 00 00 00 00       	mov    $0x0,%esi
  800ef7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800efa:	8b 7d 14             	mov    0x14(%ebp),%edi
  800efd:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    

00800f04 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	57                   	push   %edi
  800f08:	56                   	push   %esi
  800f09:	53                   	push   %ebx
  800f0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f12:	8b 55 08             	mov    0x8(%ebp),%edx
  800f15:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f1a:	89 cb                	mov    %ecx,%ebx
  800f1c:	89 cf                	mov    %ecx,%edi
  800f1e:	89 ce                	mov    %ecx,%esi
  800f20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f22:	85 c0                	test   %eax,%eax
  800f24:	7f 08                	jg     800f2e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f29:	5b                   	pop    %ebx
  800f2a:	5e                   	pop    %esi
  800f2b:	5f                   	pop    %edi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2e:	83 ec 0c             	sub    $0xc,%esp
  800f31:	50                   	push   %eax
  800f32:	6a 0d                	push   $0xd
  800f34:	68 e4 29 80 00       	push   $0x8029e4
  800f39:	6a 43                	push   $0x43
  800f3b:	68 01 2a 80 00       	push   $0x802a01
  800f40:	e8 cf 12 00 00       	call   802214 <_panic>

00800f45 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	57                   	push   %edi
  800f49:	56                   	push   %esi
  800f4a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f50:	8b 55 08             	mov    0x8(%ebp),%edx
  800f53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f56:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f5b:	89 df                	mov    %ebx,%edi
  800f5d:	89 de                	mov    %ebx,%esi
  800f5f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f61:	5b                   	pop    %ebx
  800f62:	5e                   	pop    %esi
  800f63:	5f                   	pop    %edi
  800f64:	5d                   	pop    %ebp
  800f65:	c3                   	ret    

00800f66 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	57                   	push   %edi
  800f6a:	56                   	push   %esi
  800f6b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f71:	8b 55 08             	mov    0x8(%ebp),%edx
  800f74:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f79:	89 cb                	mov    %ecx,%ebx
  800f7b:	89 cf                	mov    %ecx,%edi
  800f7d:	89 ce                	mov    %ecx,%esi
  800f7f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f81:	5b                   	pop    %ebx
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    

00800f86 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	57                   	push   %edi
  800f8a:	56                   	push   %esi
  800f8b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f91:	b8 10 00 00 00       	mov    $0x10,%eax
  800f96:	89 d1                	mov    %edx,%ecx
  800f98:	89 d3                	mov    %edx,%ebx
  800f9a:	89 d7                	mov    %edx,%edi
  800f9c:	89 d6                	mov    %edx,%esi
  800f9e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fa0:	5b                   	pop    %ebx
  800fa1:	5e                   	pop    %esi
  800fa2:	5f                   	pop    %edi
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    

00800fa5 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	57                   	push   %edi
  800fa9:	56                   	push   %esi
  800faa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb6:	b8 11 00 00 00       	mov    $0x11,%eax
  800fbb:	89 df                	mov    %ebx,%edi
  800fbd:	89 de                	mov    %ebx,%esi
  800fbf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fc1:	5b                   	pop    %ebx
  800fc2:	5e                   	pop    %esi
  800fc3:	5f                   	pop    %edi
  800fc4:	5d                   	pop    %ebp
  800fc5:	c3                   	ret    

00800fc6 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	57                   	push   %edi
  800fca:	56                   	push   %esi
  800fcb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd7:	b8 12 00 00 00       	mov    $0x12,%eax
  800fdc:	89 df                	mov    %ebx,%edi
  800fde:	89 de                	mov    %ebx,%esi
  800fe0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fe2:	5b                   	pop    %ebx
  800fe3:	5e                   	pop    %esi
  800fe4:	5f                   	pop    %edi
  800fe5:	5d                   	pop    %ebp
  800fe6:	c3                   	ret    

00800fe7 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	57                   	push   %edi
  800feb:	56                   	push   %esi
  800fec:	53                   	push   %ebx
  800fed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffb:	b8 13 00 00 00       	mov    $0x13,%eax
  801000:	89 df                	mov    %ebx,%edi
  801002:	89 de                	mov    %ebx,%esi
  801004:	cd 30                	int    $0x30
	if(check && ret > 0)
  801006:	85 c0                	test   %eax,%eax
  801008:	7f 08                	jg     801012 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80100a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100d:	5b                   	pop    %ebx
  80100e:	5e                   	pop    %esi
  80100f:	5f                   	pop    %edi
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801012:	83 ec 0c             	sub    $0xc,%esp
  801015:	50                   	push   %eax
  801016:	6a 13                	push   $0x13
  801018:	68 e4 29 80 00       	push   $0x8029e4
  80101d:	6a 43                	push   $0x43
  80101f:	68 01 2a 80 00       	push   $0x802a01
  801024:	e8 eb 11 00 00       	call   802214 <_panic>

00801029 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80102f:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  801036:	74 0a                	je     801042 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  801040:	c9                   	leave  
  801041:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  801042:	83 ec 04             	sub    $0x4,%esp
  801045:	6a 07                	push   $0x7
  801047:	68 00 f0 bf ee       	push   $0xeebff000
  80104c:	6a 00                	push   $0x0
  80104e:	e8 01 fd ff ff       	call   800d54 <sys_page_alloc>
		if(r < 0)
  801053:	83 c4 10             	add    $0x10,%esp
  801056:	85 c0                	test   %eax,%eax
  801058:	78 2a                	js     801084 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80105a:	83 ec 08             	sub    $0x8,%esp
  80105d:	68 98 10 80 00       	push   $0x801098
  801062:	6a 00                	push   $0x0
  801064:	e8 36 fe ff ff       	call   800e9f <sys_env_set_pgfault_upcall>
		if(r < 0)
  801069:	83 c4 10             	add    $0x10,%esp
  80106c:	85 c0                	test   %eax,%eax
  80106e:	79 c8                	jns    801038 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  801070:	83 ec 04             	sub    $0x4,%esp
  801073:	68 40 2a 80 00       	push   $0x802a40
  801078:	6a 25                	push   $0x25
  80107a:	68 79 2a 80 00       	push   $0x802a79
  80107f:	e8 90 11 00 00       	call   802214 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  801084:	83 ec 04             	sub    $0x4,%esp
  801087:	68 10 2a 80 00       	push   $0x802a10
  80108c:	6a 22                	push   $0x22
  80108e:	68 79 2a 80 00       	push   $0x802a79
  801093:	e8 7c 11 00 00       	call   802214 <_panic>

00801098 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801098:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801099:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  80109e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8010a0:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8010a3:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8010a7:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8010ab:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8010ae:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8010b0:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8010b4:	83 c4 08             	add    $0x8,%esp
	popal
  8010b7:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8010b8:	83 c4 04             	add    $0x4,%esp
	popfl
  8010bb:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8010bc:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8010bd:	c3                   	ret    

008010be <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	05 00 00 00 30       	add    $0x30000000,%eax
  8010c9:	c1 e8 0c             	shr    $0xc,%eax
}
  8010cc:	5d                   	pop    %ebp
  8010cd:	c3                   	ret    

008010ce <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010de:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010e3:	5d                   	pop    %ebp
  8010e4:	c3                   	ret    

008010e5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
  8010e8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010ed:	89 c2                	mov    %eax,%edx
  8010ef:	c1 ea 16             	shr    $0x16,%edx
  8010f2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010f9:	f6 c2 01             	test   $0x1,%dl
  8010fc:	74 2d                	je     80112b <fd_alloc+0x46>
  8010fe:	89 c2                	mov    %eax,%edx
  801100:	c1 ea 0c             	shr    $0xc,%edx
  801103:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80110a:	f6 c2 01             	test   $0x1,%dl
  80110d:	74 1c                	je     80112b <fd_alloc+0x46>
  80110f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801114:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801119:	75 d2                	jne    8010ed <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801124:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801129:	eb 0a                	jmp    801135 <fd_alloc+0x50>
			*fd_store = fd;
  80112b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80112e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801130:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80113d:	83 f8 1f             	cmp    $0x1f,%eax
  801140:	77 30                	ja     801172 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801142:	c1 e0 0c             	shl    $0xc,%eax
  801145:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80114a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801150:	f6 c2 01             	test   $0x1,%dl
  801153:	74 24                	je     801179 <fd_lookup+0x42>
  801155:	89 c2                	mov    %eax,%edx
  801157:	c1 ea 0c             	shr    $0xc,%edx
  80115a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801161:	f6 c2 01             	test   $0x1,%dl
  801164:	74 1a                	je     801180 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801166:	8b 55 0c             	mov    0xc(%ebp),%edx
  801169:	89 02                	mov    %eax,(%edx)
	return 0;
  80116b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801170:	5d                   	pop    %ebp
  801171:	c3                   	ret    
		return -E_INVAL;
  801172:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801177:	eb f7                	jmp    801170 <fd_lookup+0x39>
		return -E_INVAL;
  801179:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80117e:	eb f0                	jmp    801170 <fd_lookup+0x39>
  801180:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801185:	eb e9                	jmp    801170 <fd_lookup+0x39>

00801187 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	83 ec 08             	sub    $0x8,%esp
  80118d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801190:	ba 00 00 00 00       	mov    $0x0,%edx
  801195:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80119a:	39 08                	cmp    %ecx,(%eax)
  80119c:	74 38                	je     8011d6 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80119e:	83 c2 01             	add    $0x1,%edx
  8011a1:	8b 04 95 04 2b 80 00 	mov    0x802b04(,%edx,4),%eax
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	75 ee                	jne    80119a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011ac:	a1 08 40 80 00       	mov    0x804008,%eax
  8011b1:	8b 40 48             	mov    0x48(%eax),%eax
  8011b4:	83 ec 04             	sub    $0x4,%esp
  8011b7:	51                   	push   %ecx
  8011b8:	50                   	push   %eax
  8011b9:	68 88 2a 80 00       	push   $0x802a88
  8011be:	e8 40 f0 ff ff       	call   800203 <cprintf>
	*dev = 0;
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011cc:	83 c4 10             	add    $0x10,%esp
  8011cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    
			*dev = devtab[i];
  8011d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011db:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e0:	eb f2                	jmp    8011d4 <dev_lookup+0x4d>

008011e2 <fd_close>:
{
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
  8011e5:	57                   	push   %edi
  8011e6:	56                   	push   %esi
  8011e7:	53                   	push   %ebx
  8011e8:	83 ec 24             	sub    $0x24,%esp
  8011eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8011ee:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011f4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011f5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011fb:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011fe:	50                   	push   %eax
  8011ff:	e8 33 ff ff ff       	call   801137 <fd_lookup>
  801204:	89 c3                	mov    %eax,%ebx
  801206:	83 c4 10             	add    $0x10,%esp
  801209:	85 c0                	test   %eax,%eax
  80120b:	78 05                	js     801212 <fd_close+0x30>
	    || fd != fd2)
  80120d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801210:	74 16                	je     801228 <fd_close+0x46>
		return (must_exist ? r : 0);
  801212:	89 f8                	mov    %edi,%eax
  801214:	84 c0                	test   %al,%al
  801216:	b8 00 00 00 00       	mov    $0x0,%eax
  80121b:	0f 44 d8             	cmove  %eax,%ebx
}
  80121e:	89 d8                	mov    %ebx,%eax
  801220:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801223:	5b                   	pop    %ebx
  801224:	5e                   	pop    %esi
  801225:	5f                   	pop    %edi
  801226:	5d                   	pop    %ebp
  801227:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801228:	83 ec 08             	sub    $0x8,%esp
  80122b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80122e:	50                   	push   %eax
  80122f:	ff 36                	pushl  (%esi)
  801231:	e8 51 ff ff ff       	call   801187 <dev_lookup>
  801236:	89 c3                	mov    %eax,%ebx
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	85 c0                	test   %eax,%eax
  80123d:	78 1a                	js     801259 <fd_close+0x77>
		if (dev->dev_close)
  80123f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801242:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801245:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80124a:	85 c0                	test   %eax,%eax
  80124c:	74 0b                	je     801259 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	56                   	push   %esi
  801252:	ff d0                	call   *%eax
  801254:	89 c3                	mov    %eax,%ebx
  801256:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801259:	83 ec 08             	sub    $0x8,%esp
  80125c:	56                   	push   %esi
  80125d:	6a 00                	push   $0x0
  80125f:	e8 75 fb ff ff       	call   800dd9 <sys_page_unmap>
	return r;
  801264:	83 c4 10             	add    $0x10,%esp
  801267:	eb b5                	jmp    80121e <fd_close+0x3c>

00801269 <close>:

int
close(int fdnum)
{
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
  80126c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80126f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801272:	50                   	push   %eax
  801273:	ff 75 08             	pushl  0x8(%ebp)
  801276:	e8 bc fe ff ff       	call   801137 <fd_lookup>
  80127b:	83 c4 10             	add    $0x10,%esp
  80127e:	85 c0                	test   %eax,%eax
  801280:	79 02                	jns    801284 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801282:	c9                   	leave  
  801283:	c3                   	ret    
		return fd_close(fd, 1);
  801284:	83 ec 08             	sub    $0x8,%esp
  801287:	6a 01                	push   $0x1
  801289:	ff 75 f4             	pushl  -0xc(%ebp)
  80128c:	e8 51 ff ff ff       	call   8011e2 <fd_close>
  801291:	83 c4 10             	add    $0x10,%esp
  801294:	eb ec                	jmp    801282 <close+0x19>

00801296 <close_all>:

void
close_all(void)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	53                   	push   %ebx
  80129a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80129d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012a2:	83 ec 0c             	sub    $0xc,%esp
  8012a5:	53                   	push   %ebx
  8012a6:	e8 be ff ff ff       	call   801269 <close>
	for (i = 0; i < MAXFD; i++)
  8012ab:	83 c3 01             	add    $0x1,%ebx
  8012ae:	83 c4 10             	add    $0x10,%esp
  8012b1:	83 fb 20             	cmp    $0x20,%ebx
  8012b4:	75 ec                	jne    8012a2 <close_all+0xc>
}
  8012b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	57                   	push   %edi
  8012bf:	56                   	push   %esi
  8012c0:	53                   	push   %ebx
  8012c1:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012c7:	50                   	push   %eax
  8012c8:	ff 75 08             	pushl  0x8(%ebp)
  8012cb:	e8 67 fe ff ff       	call   801137 <fd_lookup>
  8012d0:	89 c3                	mov    %eax,%ebx
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	0f 88 81 00 00 00    	js     80135e <dup+0xa3>
		return r;
	close(newfdnum);
  8012dd:	83 ec 0c             	sub    $0xc,%esp
  8012e0:	ff 75 0c             	pushl  0xc(%ebp)
  8012e3:	e8 81 ff ff ff       	call   801269 <close>

	newfd = INDEX2FD(newfdnum);
  8012e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012eb:	c1 e6 0c             	shl    $0xc,%esi
  8012ee:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012f4:	83 c4 04             	add    $0x4,%esp
  8012f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012fa:	e8 cf fd ff ff       	call   8010ce <fd2data>
  8012ff:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801301:	89 34 24             	mov    %esi,(%esp)
  801304:	e8 c5 fd ff ff       	call   8010ce <fd2data>
  801309:	83 c4 10             	add    $0x10,%esp
  80130c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80130e:	89 d8                	mov    %ebx,%eax
  801310:	c1 e8 16             	shr    $0x16,%eax
  801313:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80131a:	a8 01                	test   $0x1,%al
  80131c:	74 11                	je     80132f <dup+0x74>
  80131e:	89 d8                	mov    %ebx,%eax
  801320:	c1 e8 0c             	shr    $0xc,%eax
  801323:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80132a:	f6 c2 01             	test   $0x1,%dl
  80132d:	75 39                	jne    801368 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80132f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801332:	89 d0                	mov    %edx,%eax
  801334:	c1 e8 0c             	shr    $0xc,%eax
  801337:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80133e:	83 ec 0c             	sub    $0xc,%esp
  801341:	25 07 0e 00 00       	and    $0xe07,%eax
  801346:	50                   	push   %eax
  801347:	56                   	push   %esi
  801348:	6a 00                	push   $0x0
  80134a:	52                   	push   %edx
  80134b:	6a 00                	push   $0x0
  80134d:	e8 45 fa ff ff       	call   800d97 <sys_page_map>
  801352:	89 c3                	mov    %eax,%ebx
  801354:	83 c4 20             	add    $0x20,%esp
  801357:	85 c0                	test   %eax,%eax
  801359:	78 31                	js     80138c <dup+0xd1>
		goto err;

	return newfdnum;
  80135b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80135e:	89 d8                	mov    %ebx,%eax
  801360:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801363:	5b                   	pop    %ebx
  801364:	5e                   	pop    %esi
  801365:	5f                   	pop    %edi
  801366:	5d                   	pop    %ebp
  801367:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801368:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80136f:	83 ec 0c             	sub    $0xc,%esp
  801372:	25 07 0e 00 00       	and    $0xe07,%eax
  801377:	50                   	push   %eax
  801378:	57                   	push   %edi
  801379:	6a 00                	push   $0x0
  80137b:	53                   	push   %ebx
  80137c:	6a 00                	push   $0x0
  80137e:	e8 14 fa ff ff       	call   800d97 <sys_page_map>
  801383:	89 c3                	mov    %eax,%ebx
  801385:	83 c4 20             	add    $0x20,%esp
  801388:	85 c0                	test   %eax,%eax
  80138a:	79 a3                	jns    80132f <dup+0x74>
	sys_page_unmap(0, newfd);
  80138c:	83 ec 08             	sub    $0x8,%esp
  80138f:	56                   	push   %esi
  801390:	6a 00                	push   $0x0
  801392:	e8 42 fa ff ff       	call   800dd9 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801397:	83 c4 08             	add    $0x8,%esp
  80139a:	57                   	push   %edi
  80139b:	6a 00                	push   $0x0
  80139d:	e8 37 fa ff ff       	call   800dd9 <sys_page_unmap>
	return r;
  8013a2:	83 c4 10             	add    $0x10,%esp
  8013a5:	eb b7                	jmp    80135e <dup+0xa3>

008013a7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	53                   	push   %ebx
  8013ab:	83 ec 1c             	sub    $0x1c,%esp
  8013ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013b4:	50                   	push   %eax
  8013b5:	53                   	push   %ebx
  8013b6:	e8 7c fd ff ff       	call   801137 <fd_lookup>
  8013bb:	83 c4 10             	add    $0x10,%esp
  8013be:	85 c0                	test   %eax,%eax
  8013c0:	78 3f                	js     801401 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c2:	83 ec 08             	sub    $0x8,%esp
  8013c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c8:	50                   	push   %eax
  8013c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013cc:	ff 30                	pushl  (%eax)
  8013ce:	e8 b4 fd ff ff       	call   801187 <dev_lookup>
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	78 27                	js     801401 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013dd:	8b 42 08             	mov    0x8(%edx),%eax
  8013e0:	83 e0 03             	and    $0x3,%eax
  8013e3:	83 f8 01             	cmp    $0x1,%eax
  8013e6:	74 1e                	je     801406 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013eb:	8b 40 08             	mov    0x8(%eax),%eax
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	74 35                	je     801427 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013f2:	83 ec 04             	sub    $0x4,%esp
  8013f5:	ff 75 10             	pushl  0x10(%ebp)
  8013f8:	ff 75 0c             	pushl  0xc(%ebp)
  8013fb:	52                   	push   %edx
  8013fc:	ff d0                	call   *%eax
  8013fe:	83 c4 10             	add    $0x10,%esp
}
  801401:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801404:	c9                   	leave  
  801405:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801406:	a1 08 40 80 00       	mov    0x804008,%eax
  80140b:	8b 40 48             	mov    0x48(%eax),%eax
  80140e:	83 ec 04             	sub    $0x4,%esp
  801411:	53                   	push   %ebx
  801412:	50                   	push   %eax
  801413:	68 c9 2a 80 00       	push   $0x802ac9
  801418:	e8 e6 ed ff ff       	call   800203 <cprintf>
		return -E_INVAL;
  80141d:	83 c4 10             	add    $0x10,%esp
  801420:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801425:	eb da                	jmp    801401 <read+0x5a>
		return -E_NOT_SUPP;
  801427:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80142c:	eb d3                	jmp    801401 <read+0x5a>

0080142e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	57                   	push   %edi
  801432:	56                   	push   %esi
  801433:	53                   	push   %ebx
  801434:	83 ec 0c             	sub    $0xc,%esp
  801437:	8b 7d 08             	mov    0x8(%ebp),%edi
  80143a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80143d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801442:	39 f3                	cmp    %esi,%ebx
  801444:	73 23                	jae    801469 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801446:	83 ec 04             	sub    $0x4,%esp
  801449:	89 f0                	mov    %esi,%eax
  80144b:	29 d8                	sub    %ebx,%eax
  80144d:	50                   	push   %eax
  80144e:	89 d8                	mov    %ebx,%eax
  801450:	03 45 0c             	add    0xc(%ebp),%eax
  801453:	50                   	push   %eax
  801454:	57                   	push   %edi
  801455:	e8 4d ff ff ff       	call   8013a7 <read>
		if (m < 0)
  80145a:	83 c4 10             	add    $0x10,%esp
  80145d:	85 c0                	test   %eax,%eax
  80145f:	78 06                	js     801467 <readn+0x39>
			return m;
		if (m == 0)
  801461:	74 06                	je     801469 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801463:	01 c3                	add    %eax,%ebx
  801465:	eb db                	jmp    801442 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801467:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801469:	89 d8                	mov    %ebx,%eax
  80146b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80146e:	5b                   	pop    %ebx
  80146f:	5e                   	pop    %esi
  801470:	5f                   	pop    %edi
  801471:	5d                   	pop    %ebp
  801472:	c3                   	ret    

00801473 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	53                   	push   %ebx
  801477:	83 ec 1c             	sub    $0x1c,%esp
  80147a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801480:	50                   	push   %eax
  801481:	53                   	push   %ebx
  801482:	e8 b0 fc ff ff       	call   801137 <fd_lookup>
  801487:	83 c4 10             	add    $0x10,%esp
  80148a:	85 c0                	test   %eax,%eax
  80148c:	78 3a                	js     8014c8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80148e:	83 ec 08             	sub    $0x8,%esp
  801491:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801494:	50                   	push   %eax
  801495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801498:	ff 30                	pushl  (%eax)
  80149a:	e8 e8 fc ff ff       	call   801187 <dev_lookup>
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	78 22                	js     8014c8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014ad:	74 1e                	je     8014cd <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b2:	8b 52 0c             	mov    0xc(%edx),%edx
  8014b5:	85 d2                	test   %edx,%edx
  8014b7:	74 35                	je     8014ee <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014b9:	83 ec 04             	sub    $0x4,%esp
  8014bc:	ff 75 10             	pushl  0x10(%ebp)
  8014bf:	ff 75 0c             	pushl  0xc(%ebp)
  8014c2:	50                   	push   %eax
  8014c3:	ff d2                	call   *%edx
  8014c5:	83 c4 10             	add    $0x10,%esp
}
  8014c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014cd:	a1 08 40 80 00       	mov    0x804008,%eax
  8014d2:	8b 40 48             	mov    0x48(%eax),%eax
  8014d5:	83 ec 04             	sub    $0x4,%esp
  8014d8:	53                   	push   %ebx
  8014d9:	50                   	push   %eax
  8014da:	68 e5 2a 80 00       	push   $0x802ae5
  8014df:	e8 1f ed ff ff       	call   800203 <cprintf>
		return -E_INVAL;
  8014e4:	83 c4 10             	add    $0x10,%esp
  8014e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ec:	eb da                	jmp    8014c8 <write+0x55>
		return -E_NOT_SUPP;
  8014ee:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014f3:	eb d3                	jmp    8014c8 <write+0x55>

008014f5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014fe:	50                   	push   %eax
  8014ff:	ff 75 08             	pushl  0x8(%ebp)
  801502:	e8 30 fc ff ff       	call   801137 <fd_lookup>
  801507:	83 c4 10             	add    $0x10,%esp
  80150a:	85 c0                	test   %eax,%eax
  80150c:	78 0e                	js     80151c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80150e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801514:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801517:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    

0080151e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	53                   	push   %ebx
  801522:	83 ec 1c             	sub    $0x1c,%esp
  801525:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801528:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80152b:	50                   	push   %eax
  80152c:	53                   	push   %ebx
  80152d:	e8 05 fc ff ff       	call   801137 <fd_lookup>
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	85 c0                	test   %eax,%eax
  801537:	78 37                	js     801570 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801539:	83 ec 08             	sub    $0x8,%esp
  80153c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153f:	50                   	push   %eax
  801540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801543:	ff 30                	pushl  (%eax)
  801545:	e8 3d fc ff ff       	call   801187 <dev_lookup>
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	85 c0                	test   %eax,%eax
  80154f:	78 1f                	js     801570 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801554:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801558:	74 1b                	je     801575 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80155a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155d:	8b 52 18             	mov    0x18(%edx),%edx
  801560:	85 d2                	test   %edx,%edx
  801562:	74 32                	je     801596 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801564:	83 ec 08             	sub    $0x8,%esp
  801567:	ff 75 0c             	pushl  0xc(%ebp)
  80156a:	50                   	push   %eax
  80156b:	ff d2                	call   *%edx
  80156d:	83 c4 10             	add    $0x10,%esp
}
  801570:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801573:	c9                   	leave  
  801574:	c3                   	ret    
			thisenv->env_id, fdnum);
  801575:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80157a:	8b 40 48             	mov    0x48(%eax),%eax
  80157d:	83 ec 04             	sub    $0x4,%esp
  801580:	53                   	push   %ebx
  801581:	50                   	push   %eax
  801582:	68 a8 2a 80 00       	push   $0x802aa8
  801587:	e8 77 ec ff ff       	call   800203 <cprintf>
		return -E_INVAL;
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801594:	eb da                	jmp    801570 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801596:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80159b:	eb d3                	jmp    801570 <ftruncate+0x52>

0080159d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	53                   	push   %ebx
  8015a1:	83 ec 1c             	sub    $0x1c,%esp
  8015a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015aa:	50                   	push   %eax
  8015ab:	ff 75 08             	pushl  0x8(%ebp)
  8015ae:	e8 84 fb ff ff       	call   801137 <fd_lookup>
  8015b3:	83 c4 10             	add    $0x10,%esp
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	78 4b                	js     801605 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ba:	83 ec 08             	sub    $0x8,%esp
  8015bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c0:	50                   	push   %eax
  8015c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c4:	ff 30                	pushl  (%eax)
  8015c6:	e8 bc fb ff ff       	call   801187 <dev_lookup>
  8015cb:	83 c4 10             	add    $0x10,%esp
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	78 33                	js     801605 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015d9:	74 2f                	je     80160a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015db:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015de:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015e5:	00 00 00 
	stat->st_isdir = 0;
  8015e8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015ef:	00 00 00 
	stat->st_dev = dev;
  8015f2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015f8:	83 ec 08             	sub    $0x8,%esp
  8015fb:	53                   	push   %ebx
  8015fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8015ff:	ff 50 14             	call   *0x14(%eax)
  801602:	83 c4 10             	add    $0x10,%esp
}
  801605:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801608:	c9                   	leave  
  801609:	c3                   	ret    
		return -E_NOT_SUPP;
  80160a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80160f:	eb f4                	jmp    801605 <fstat+0x68>

00801611 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	56                   	push   %esi
  801615:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	6a 00                	push   $0x0
  80161b:	ff 75 08             	pushl  0x8(%ebp)
  80161e:	e8 22 02 00 00       	call   801845 <open>
  801623:	89 c3                	mov    %eax,%ebx
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	85 c0                	test   %eax,%eax
  80162a:	78 1b                	js     801647 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80162c:	83 ec 08             	sub    $0x8,%esp
  80162f:	ff 75 0c             	pushl  0xc(%ebp)
  801632:	50                   	push   %eax
  801633:	e8 65 ff ff ff       	call   80159d <fstat>
  801638:	89 c6                	mov    %eax,%esi
	close(fd);
  80163a:	89 1c 24             	mov    %ebx,(%esp)
  80163d:	e8 27 fc ff ff       	call   801269 <close>
	return r;
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	89 f3                	mov    %esi,%ebx
}
  801647:	89 d8                	mov    %ebx,%eax
  801649:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164c:	5b                   	pop    %ebx
  80164d:	5e                   	pop    %esi
  80164e:	5d                   	pop    %ebp
  80164f:	c3                   	ret    

00801650 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	56                   	push   %esi
  801654:	53                   	push   %ebx
  801655:	89 c6                	mov    %eax,%esi
  801657:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801659:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801660:	74 27                	je     801689 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801662:	6a 07                	push   $0x7
  801664:	68 00 50 80 00       	push   $0x805000
  801669:	56                   	push   %esi
  80166a:	ff 35 00 40 80 00    	pushl  0x804000
  801670:	e8 69 0c 00 00       	call   8022de <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801675:	83 c4 0c             	add    $0xc,%esp
  801678:	6a 00                	push   $0x0
  80167a:	53                   	push   %ebx
  80167b:	6a 00                	push   $0x0
  80167d:	e8 f3 0b 00 00       	call   802275 <ipc_recv>
}
  801682:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801685:	5b                   	pop    %ebx
  801686:	5e                   	pop    %esi
  801687:	5d                   	pop    %ebp
  801688:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801689:	83 ec 0c             	sub    $0xc,%esp
  80168c:	6a 01                	push   $0x1
  80168e:	e8 a3 0c 00 00       	call   802336 <ipc_find_env>
  801693:	a3 00 40 80 00       	mov    %eax,0x804000
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	eb c5                	jmp    801662 <fsipc+0x12>

0080169d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b1:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bb:	b8 02 00 00 00       	mov    $0x2,%eax
  8016c0:	e8 8b ff ff ff       	call   801650 <fsipc>
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <devfile_flush>:
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016dd:	b8 06 00 00 00       	mov    $0x6,%eax
  8016e2:	e8 69 ff ff ff       	call   801650 <fsipc>
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <devfile_stat>:
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	53                   	push   %ebx
  8016ed:	83 ec 04             	sub    $0x4,%esp
  8016f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f9:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801703:	b8 05 00 00 00       	mov    $0x5,%eax
  801708:	e8 43 ff ff ff       	call   801650 <fsipc>
  80170d:	85 c0                	test   %eax,%eax
  80170f:	78 2c                	js     80173d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801711:	83 ec 08             	sub    $0x8,%esp
  801714:	68 00 50 80 00       	push   $0x805000
  801719:	53                   	push   %ebx
  80171a:	e8 43 f2 ff ff       	call   800962 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80171f:	a1 80 50 80 00       	mov    0x805080,%eax
  801724:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80172a:	a1 84 50 80 00       	mov    0x805084,%eax
  80172f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801735:	83 c4 10             	add    $0x10,%esp
  801738:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <devfile_write>:
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	53                   	push   %ebx
  801746:	83 ec 08             	sub    $0x8,%esp
  801749:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
  80174f:	8b 40 0c             	mov    0xc(%eax),%eax
  801752:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801757:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80175d:	53                   	push   %ebx
  80175e:	ff 75 0c             	pushl  0xc(%ebp)
  801761:	68 08 50 80 00       	push   $0x805008
  801766:	e8 e7 f3 ff ff       	call   800b52 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80176b:	ba 00 00 00 00       	mov    $0x0,%edx
  801770:	b8 04 00 00 00       	mov    $0x4,%eax
  801775:	e8 d6 fe ff ff       	call   801650 <fsipc>
  80177a:	83 c4 10             	add    $0x10,%esp
  80177d:	85 c0                	test   %eax,%eax
  80177f:	78 0b                	js     80178c <devfile_write+0x4a>
	assert(r <= n);
  801781:	39 d8                	cmp    %ebx,%eax
  801783:	77 0c                	ja     801791 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801785:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80178a:	7f 1e                	jg     8017aa <devfile_write+0x68>
}
  80178c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80178f:	c9                   	leave  
  801790:	c3                   	ret    
	assert(r <= n);
  801791:	68 18 2b 80 00       	push   $0x802b18
  801796:	68 1f 2b 80 00       	push   $0x802b1f
  80179b:	68 98 00 00 00       	push   $0x98
  8017a0:	68 34 2b 80 00       	push   $0x802b34
  8017a5:	e8 6a 0a 00 00       	call   802214 <_panic>
	assert(r <= PGSIZE);
  8017aa:	68 3f 2b 80 00       	push   $0x802b3f
  8017af:	68 1f 2b 80 00       	push   $0x802b1f
  8017b4:	68 99 00 00 00       	push   $0x99
  8017b9:	68 34 2b 80 00       	push   $0x802b34
  8017be:	e8 51 0a 00 00       	call   802214 <_panic>

008017c3 <devfile_read>:
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	56                   	push   %esi
  8017c7:	53                   	push   %ebx
  8017c8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017d6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e1:	b8 03 00 00 00       	mov    $0x3,%eax
  8017e6:	e8 65 fe ff ff       	call   801650 <fsipc>
  8017eb:	89 c3                	mov    %eax,%ebx
  8017ed:	85 c0                	test   %eax,%eax
  8017ef:	78 1f                	js     801810 <devfile_read+0x4d>
	assert(r <= n);
  8017f1:	39 f0                	cmp    %esi,%eax
  8017f3:	77 24                	ja     801819 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017fa:	7f 33                	jg     80182f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017fc:	83 ec 04             	sub    $0x4,%esp
  8017ff:	50                   	push   %eax
  801800:	68 00 50 80 00       	push   $0x805000
  801805:	ff 75 0c             	pushl  0xc(%ebp)
  801808:	e8 e3 f2 ff ff       	call   800af0 <memmove>
	return r;
  80180d:	83 c4 10             	add    $0x10,%esp
}
  801810:	89 d8                	mov    %ebx,%eax
  801812:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801815:	5b                   	pop    %ebx
  801816:	5e                   	pop    %esi
  801817:	5d                   	pop    %ebp
  801818:	c3                   	ret    
	assert(r <= n);
  801819:	68 18 2b 80 00       	push   $0x802b18
  80181e:	68 1f 2b 80 00       	push   $0x802b1f
  801823:	6a 7c                	push   $0x7c
  801825:	68 34 2b 80 00       	push   $0x802b34
  80182a:	e8 e5 09 00 00       	call   802214 <_panic>
	assert(r <= PGSIZE);
  80182f:	68 3f 2b 80 00       	push   $0x802b3f
  801834:	68 1f 2b 80 00       	push   $0x802b1f
  801839:	6a 7d                	push   $0x7d
  80183b:	68 34 2b 80 00       	push   $0x802b34
  801840:	e8 cf 09 00 00       	call   802214 <_panic>

00801845 <open>:
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	56                   	push   %esi
  801849:	53                   	push   %ebx
  80184a:	83 ec 1c             	sub    $0x1c,%esp
  80184d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801850:	56                   	push   %esi
  801851:	e8 d3 f0 ff ff       	call   800929 <strlen>
  801856:	83 c4 10             	add    $0x10,%esp
  801859:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80185e:	7f 6c                	jg     8018cc <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801860:	83 ec 0c             	sub    $0xc,%esp
  801863:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801866:	50                   	push   %eax
  801867:	e8 79 f8 ff ff       	call   8010e5 <fd_alloc>
  80186c:	89 c3                	mov    %eax,%ebx
  80186e:	83 c4 10             	add    $0x10,%esp
  801871:	85 c0                	test   %eax,%eax
  801873:	78 3c                	js     8018b1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801875:	83 ec 08             	sub    $0x8,%esp
  801878:	56                   	push   %esi
  801879:	68 00 50 80 00       	push   $0x805000
  80187e:	e8 df f0 ff ff       	call   800962 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801883:	8b 45 0c             	mov    0xc(%ebp),%eax
  801886:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80188b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80188e:	b8 01 00 00 00       	mov    $0x1,%eax
  801893:	e8 b8 fd ff ff       	call   801650 <fsipc>
  801898:	89 c3                	mov    %eax,%ebx
  80189a:	83 c4 10             	add    $0x10,%esp
  80189d:	85 c0                	test   %eax,%eax
  80189f:	78 19                	js     8018ba <open+0x75>
	return fd2num(fd);
  8018a1:	83 ec 0c             	sub    $0xc,%esp
  8018a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a7:	e8 12 f8 ff ff       	call   8010be <fd2num>
  8018ac:	89 c3                	mov    %eax,%ebx
  8018ae:	83 c4 10             	add    $0x10,%esp
}
  8018b1:	89 d8                	mov    %ebx,%eax
  8018b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b6:	5b                   	pop    %ebx
  8018b7:	5e                   	pop    %esi
  8018b8:	5d                   	pop    %ebp
  8018b9:	c3                   	ret    
		fd_close(fd, 0);
  8018ba:	83 ec 08             	sub    $0x8,%esp
  8018bd:	6a 00                	push   $0x0
  8018bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c2:	e8 1b f9 ff ff       	call   8011e2 <fd_close>
		return r;
  8018c7:	83 c4 10             	add    $0x10,%esp
  8018ca:	eb e5                	jmp    8018b1 <open+0x6c>
		return -E_BAD_PATH;
  8018cc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018d1:	eb de                	jmp    8018b1 <open+0x6c>

008018d3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018de:	b8 08 00 00 00       	mov    $0x8,%eax
  8018e3:	e8 68 fd ff ff       	call   801650 <fsipc>
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018f0:	68 4b 2b 80 00       	push   $0x802b4b
  8018f5:	ff 75 0c             	pushl  0xc(%ebp)
  8018f8:	e8 65 f0 ff ff       	call   800962 <strcpy>
	return 0;
}
  8018fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <devsock_close>:
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	53                   	push   %ebx
  801908:	83 ec 10             	sub    $0x10,%esp
  80190b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80190e:	53                   	push   %ebx
  80190f:	e8 5d 0a 00 00       	call   802371 <pageref>
  801914:	83 c4 10             	add    $0x10,%esp
		return 0;
  801917:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80191c:	83 f8 01             	cmp    $0x1,%eax
  80191f:	74 07                	je     801928 <devsock_close+0x24>
}
  801921:	89 d0                	mov    %edx,%eax
  801923:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801926:	c9                   	leave  
  801927:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801928:	83 ec 0c             	sub    $0xc,%esp
  80192b:	ff 73 0c             	pushl  0xc(%ebx)
  80192e:	e8 b9 02 00 00       	call   801bec <nsipc_close>
  801933:	89 c2                	mov    %eax,%edx
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	eb e7                	jmp    801921 <devsock_close+0x1d>

0080193a <devsock_write>:
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801940:	6a 00                	push   $0x0
  801942:	ff 75 10             	pushl  0x10(%ebp)
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	ff 70 0c             	pushl  0xc(%eax)
  80194e:	e8 76 03 00 00       	call   801cc9 <nsipc_send>
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <devsock_read>:
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80195b:	6a 00                	push   $0x0
  80195d:	ff 75 10             	pushl  0x10(%ebp)
  801960:	ff 75 0c             	pushl  0xc(%ebp)
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	ff 70 0c             	pushl  0xc(%eax)
  801969:	e8 ef 02 00 00       	call   801c5d <nsipc_recv>
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <fd2sockid>:
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801976:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801979:	52                   	push   %edx
  80197a:	50                   	push   %eax
  80197b:	e8 b7 f7 ff ff       	call   801137 <fd_lookup>
  801980:	83 c4 10             	add    $0x10,%esp
  801983:	85 c0                	test   %eax,%eax
  801985:	78 10                	js     801997 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198a:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801990:	39 08                	cmp    %ecx,(%eax)
  801992:	75 05                	jne    801999 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801994:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    
		return -E_NOT_SUPP;
  801999:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80199e:	eb f7                	jmp    801997 <fd2sockid+0x27>

008019a0 <alloc_sockfd>:
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	56                   	push   %esi
  8019a4:	53                   	push   %ebx
  8019a5:	83 ec 1c             	sub    $0x1c,%esp
  8019a8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8019aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ad:	50                   	push   %eax
  8019ae:	e8 32 f7 ff ff       	call   8010e5 <fd_alloc>
  8019b3:	89 c3                	mov    %eax,%ebx
  8019b5:	83 c4 10             	add    $0x10,%esp
  8019b8:	85 c0                	test   %eax,%eax
  8019ba:	78 43                	js     8019ff <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019bc:	83 ec 04             	sub    $0x4,%esp
  8019bf:	68 07 04 00 00       	push   $0x407
  8019c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8019c7:	6a 00                	push   $0x0
  8019c9:	e8 86 f3 ff ff       	call   800d54 <sys_page_alloc>
  8019ce:	89 c3                	mov    %eax,%ebx
  8019d0:	83 c4 10             	add    $0x10,%esp
  8019d3:	85 c0                	test   %eax,%eax
  8019d5:	78 28                	js     8019ff <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019da:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019e0:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019ec:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019ef:	83 ec 0c             	sub    $0xc,%esp
  8019f2:	50                   	push   %eax
  8019f3:	e8 c6 f6 ff ff       	call   8010be <fd2num>
  8019f8:	89 c3                	mov    %eax,%ebx
  8019fa:	83 c4 10             	add    $0x10,%esp
  8019fd:	eb 0c                	jmp    801a0b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019ff:	83 ec 0c             	sub    $0xc,%esp
  801a02:	56                   	push   %esi
  801a03:	e8 e4 01 00 00       	call   801bec <nsipc_close>
		return r;
  801a08:	83 c4 10             	add    $0x10,%esp
}
  801a0b:	89 d8                	mov    %ebx,%eax
  801a0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a10:	5b                   	pop    %ebx
  801a11:	5e                   	pop    %esi
  801a12:	5d                   	pop    %ebp
  801a13:	c3                   	ret    

00801a14 <accept>:
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	e8 4e ff ff ff       	call   801970 <fd2sockid>
  801a22:	85 c0                	test   %eax,%eax
  801a24:	78 1b                	js     801a41 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a26:	83 ec 04             	sub    $0x4,%esp
  801a29:	ff 75 10             	pushl  0x10(%ebp)
  801a2c:	ff 75 0c             	pushl  0xc(%ebp)
  801a2f:	50                   	push   %eax
  801a30:	e8 0e 01 00 00       	call   801b43 <nsipc_accept>
  801a35:	83 c4 10             	add    $0x10,%esp
  801a38:	85 c0                	test   %eax,%eax
  801a3a:	78 05                	js     801a41 <accept+0x2d>
	return alloc_sockfd(r);
  801a3c:	e8 5f ff ff ff       	call   8019a0 <alloc_sockfd>
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <bind>:
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	e8 1f ff ff ff       	call   801970 <fd2sockid>
  801a51:	85 c0                	test   %eax,%eax
  801a53:	78 12                	js     801a67 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a55:	83 ec 04             	sub    $0x4,%esp
  801a58:	ff 75 10             	pushl  0x10(%ebp)
  801a5b:	ff 75 0c             	pushl  0xc(%ebp)
  801a5e:	50                   	push   %eax
  801a5f:	e8 31 01 00 00       	call   801b95 <nsipc_bind>
  801a64:	83 c4 10             	add    $0x10,%esp
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <shutdown>:
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	e8 f9 fe ff ff       	call   801970 <fd2sockid>
  801a77:	85 c0                	test   %eax,%eax
  801a79:	78 0f                	js     801a8a <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a7b:	83 ec 08             	sub    $0x8,%esp
  801a7e:	ff 75 0c             	pushl  0xc(%ebp)
  801a81:	50                   	push   %eax
  801a82:	e8 43 01 00 00       	call   801bca <nsipc_shutdown>
  801a87:	83 c4 10             	add    $0x10,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <connect>:
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	e8 d6 fe ff ff       	call   801970 <fd2sockid>
  801a9a:	85 c0                	test   %eax,%eax
  801a9c:	78 12                	js     801ab0 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a9e:	83 ec 04             	sub    $0x4,%esp
  801aa1:	ff 75 10             	pushl  0x10(%ebp)
  801aa4:	ff 75 0c             	pushl  0xc(%ebp)
  801aa7:	50                   	push   %eax
  801aa8:	e8 59 01 00 00       	call   801c06 <nsipc_connect>
  801aad:	83 c4 10             	add    $0x10,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <listen>:
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	e8 b0 fe ff ff       	call   801970 <fd2sockid>
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	78 0f                	js     801ad3 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ac4:	83 ec 08             	sub    $0x8,%esp
  801ac7:	ff 75 0c             	pushl  0xc(%ebp)
  801aca:	50                   	push   %eax
  801acb:	e8 6b 01 00 00       	call   801c3b <nsipc_listen>
  801ad0:	83 c4 10             	add    $0x10,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801adb:	ff 75 10             	pushl  0x10(%ebp)
  801ade:	ff 75 0c             	pushl  0xc(%ebp)
  801ae1:	ff 75 08             	pushl  0x8(%ebp)
  801ae4:	e8 3e 02 00 00       	call   801d27 <nsipc_socket>
  801ae9:	83 c4 10             	add    $0x10,%esp
  801aec:	85 c0                	test   %eax,%eax
  801aee:	78 05                	js     801af5 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801af0:	e8 ab fe ff ff       	call   8019a0 <alloc_sockfd>
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	53                   	push   %ebx
  801afb:	83 ec 04             	sub    $0x4,%esp
  801afe:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b00:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b07:	74 26                	je     801b2f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b09:	6a 07                	push   $0x7
  801b0b:	68 00 60 80 00       	push   $0x806000
  801b10:	53                   	push   %ebx
  801b11:	ff 35 04 40 80 00    	pushl  0x804004
  801b17:	e8 c2 07 00 00       	call   8022de <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b1c:	83 c4 0c             	add    $0xc,%esp
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	e8 4b 07 00 00       	call   802275 <ipc_recv>
}
  801b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b2f:	83 ec 0c             	sub    $0xc,%esp
  801b32:	6a 02                	push   $0x2
  801b34:	e8 fd 07 00 00       	call   802336 <ipc_find_env>
  801b39:	a3 04 40 80 00       	mov    %eax,0x804004
  801b3e:	83 c4 10             	add    $0x10,%esp
  801b41:	eb c6                	jmp    801b09 <nsipc+0x12>

00801b43 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	56                   	push   %esi
  801b47:	53                   	push   %ebx
  801b48:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b53:	8b 06                	mov    (%esi),%eax
  801b55:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b5f:	e8 93 ff ff ff       	call   801af7 <nsipc>
  801b64:	89 c3                	mov    %eax,%ebx
  801b66:	85 c0                	test   %eax,%eax
  801b68:	79 09                	jns    801b73 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b6a:	89 d8                	mov    %ebx,%eax
  801b6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b6f:	5b                   	pop    %ebx
  801b70:	5e                   	pop    %esi
  801b71:	5d                   	pop    %ebp
  801b72:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b73:	83 ec 04             	sub    $0x4,%esp
  801b76:	ff 35 10 60 80 00    	pushl  0x806010
  801b7c:	68 00 60 80 00       	push   $0x806000
  801b81:	ff 75 0c             	pushl  0xc(%ebp)
  801b84:	e8 67 ef ff ff       	call   800af0 <memmove>
		*addrlen = ret->ret_addrlen;
  801b89:	a1 10 60 80 00       	mov    0x806010,%eax
  801b8e:	89 06                	mov    %eax,(%esi)
  801b90:	83 c4 10             	add    $0x10,%esp
	return r;
  801b93:	eb d5                	jmp    801b6a <nsipc_accept+0x27>

00801b95 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	53                   	push   %ebx
  801b99:	83 ec 08             	sub    $0x8,%esp
  801b9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ba7:	53                   	push   %ebx
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	68 04 60 80 00       	push   $0x806004
  801bb0:	e8 3b ef ff ff       	call   800af0 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801bb5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801bbb:	b8 02 00 00 00       	mov    $0x2,%eax
  801bc0:	e8 32 ff ff ff       	call   801af7 <nsipc>
}
  801bc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
  801bcd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bdb:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801be0:	b8 03 00 00 00       	mov    $0x3,%eax
  801be5:	e8 0d ff ff ff       	call   801af7 <nsipc>
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <nsipc_close>:

int
nsipc_close(int s)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bfa:	b8 04 00 00 00       	mov    $0x4,%eax
  801bff:	e8 f3 fe ff ff       	call   801af7 <nsipc>
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	53                   	push   %ebx
  801c0a:	83 ec 08             	sub    $0x8,%esp
  801c0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c18:	53                   	push   %ebx
  801c19:	ff 75 0c             	pushl  0xc(%ebp)
  801c1c:	68 04 60 80 00       	push   $0x806004
  801c21:	e8 ca ee ff ff       	call   800af0 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c26:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c2c:	b8 05 00 00 00       	mov    $0x5,%eax
  801c31:	e8 c1 fe ff ff       	call   801af7 <nsipc>
}
  801c36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c51:	b8 06 00 00 00       	mov    $0x6,%eax
  801c56:	e8 9c fe ff ff       	call   801af7 <nsipc>
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	56                   	push   %esi
  801c61:	53                   	push   %ebx
  801c62:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c65:	8b 45 08             	mov    0x8(%ebp),%eax
  801c68:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c6d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c73:	8b 45 14             	mov    0x14(%ebp),%eax
  801c76:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c7b:	b8 07 00 00 00       	mov    $0x7,%eax
  801c80:	e8 72 fe ff ff       	call   801af7 <nsipc>
  801c85:	89 c3                	mov    %eax,%ebx
  801c87:	85 c0                	test   %eax,%eax
  801c89:	78 1f                	js     801caa <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c8b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c90:	7f 21                	jg     801cb3 <nsipc_recv+0x56>
  801c92:	39 c6                	cmp    %eax,%esi
  801c94:	7c 1d                	jl     801cb3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c96:	83 ec 04             	sub    $0x4,%esp
  801c99:	50                   	push   %eax
  801c9a:	68 00 60 80 00       	push   $0x806000
  801c9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ca2:	e8 49 ee ff ff       	call   800af0 <memmove>
  801ca7:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801caa:	89 d8                	mov    %ebx,%eax
  801cac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801caf:	5b                   	pop    %ebx
  801cb0:	5e                   	pop    %esi
  801cb1:	5d                   	pop    %ebp
  801cb2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801cb3:	68 57 2b 80 00       	push   $0x802b57
  801cb8:	68 1f 2b 80 00       	push   $0x802b1f
  801cbd:	6a 62                	push   $0x62
  801cbf:	68 6c 2b 80 00       	push   $0x802b6c
  801cc4:	e8 4b 05 00 00       	call   802214 <_panic>

00801cc9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	53                   	push   %ebx
  801ccd:	83 ec 04             	sub    $0x4,%esp
  801cd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801cdb:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ce1:	7f 2e                	jg     801d11 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ce3:	83 ec 04             	sub    $0x4,%esp
  801ce6:	53                   	push   %ebx
  801ce7:	ff 75 0c             	pushl  0xc(%ebp)
  801cea:	68 0c 60 80 00       	push   $0x80600c
  801cef:	e8 fc ed ff ff       	call   800af0 <memmove>
	nsipcbuf.send.req_size = size;
  801cf4:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801cfa:	8b 45 14             	mov    0x14(%ebp),%eax
  801cfd:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d02:	b8 08 00 00 00       	mov    $0x8,%eax
  801d07:	e8 eb fd ff ff       	call   801af7 <nsipc>
}
  801d0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    
	assert(size < 1600);
  801d11:	68 78 2b 80 00       	push   $0x802b78
  801d16:	68 1f 2b 80 00       	push   $0x802b1f
  801d1b:	6a 6d                	push   $0x6d
  801d1d:	68 6c 2b 80 00       	push   $0x802b6c
  801d22:	e8 ed 04 00 00       	call   802214 <_panic>

00801d27 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d38:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d40:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d45:	b8 09 00 00 00       	mov    $0x9,%eax
  801d4a:	e8 a8 fd ff ff       	call   801af7 <nsipc>
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	56                   	push   %esi
  801d55:	53                   	push   %ebx
  801d56:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d59:	83 ec 0c             	sub    $0xc,%esp
  801d5c:	ff 75 08             	pushl  0x8(%ebp)
  801d5f:	e8 6a f3 ff ff       	call   8010ce <fd2data>
  801d64:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d66:	83 c4 08             	add    $0x8,%esp
  801d69:	68 84 2b 80 00       	push   $0x802b84
  801d6e:	53                   	push   %ebx
  801d6f:	e8 ee eb ff ff       	call   800962 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d74:	8b 46 04             	mov    0x4(%esi),%eax
  801d77:	2b 06                	sub    (%esi),%eax
  801d79:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d7f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d86:	00 00 00 
	stat->st_dev = &devpipe;
  801d89:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d90:	30 80 00 
	return 0;
}
  801d93:	b8 00 00 00 00       	mov    $0x0,%eax
  801d98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d9b:	5b                   	pop    %ebx
  801d9c:	5e                   	pop    %esi
  801d9d:	5d                   	pop    %ebp
  801d9e:	c3                   	ret    

00801d9f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	53                   	push   %ebx
  801da3:	83 ec 0c             	sub    $0xc,%esp
  801da6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801da9:	53                   	push   %ebx
  801daa:	6a 00                	push   $0x0
  801dac:	e8 28 f0 ff ff       	call   800dd9 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801db1:	89 1c 24             	mov    %ebx,(%esp)
  801db4:	e8 15 f3 ff ff       	call   8010ce <fd2data>
  801db9:	83 c4 08             	add    $0x8,%esp
  801dbc:	50                   	push   %eax
  801dbd:	6a 00                	push   $0x0
  801dbf:	e8 15 f0 ff ff       	call   800dd9 <sys_page_unmap>
}
  801dc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <_pipeisclosed>:
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	57                   	push   %edi
  801dcd:	56                   	push   %esi
  801dce:	53                   	push   %ebx
  801dcf:	83 ec 1c             	sub    $0x1c,%esp
  801dd2:	89 c7                	mov    %eax,%edi
  801dd4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801dd6:	a1 08 40 80 00       	mov    0x804008,%eax
  801ddb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dde:	83 ec 0c             	sub    $0xc,%esp
  801de1:	57                   	push   %edi
  801de2:	e8 8a 05 00 00       	call   802371 <pageref>
  801de7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dea:	89 34 24             	mov    %esi,(%esp)
  801ded:	e8 7f 05 00 00       	call   802371 <pageref>
		nn = thisenv->env_runs;
  801df2:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801df8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801dfb:	83 c4 10             	add    $0x10,%esp
  801dfe:	39 cb                	cmp    %ecx,%ebx
  801e00:	74 1b                	je     801e1d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e02:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e05:	75 cf                	jne    801dd6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e07:	8b 42 58             	mov    0x58(%edx),%eax
  801e0a:	6a 01                	push   $0x1
  801e0c:	50                   	push   %eax
  801e0d:	53                   	push   %ebx
  801e0e:	68 8b 2b 80 00       	push   $0x802b8b
  801e13:	e8 eb e3 ff ff       	call   800203 <cprintf>
  801e18:	83 c4 10             	add    $0x10,%esp
  801e1b:	eb b9                	jmp    801dd6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e1d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e20:	0f 94 c0             	sete   %al
  801e23:	0f b6 c0             	movzbl %al,%eax
}
  801e26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e29:	5b                   	pop    %ebx
  801e2a:	5e                   	pop    %esi
  801e2b:	5f                   	pop    %edi
  801e2c:	5d                   	pop    %ebp
  801e2d:	c3                   	ret    

00801e2e <devpipe_write>:
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	57                   	push   %edi
  801e32:	56                   	push   %esi
  801e33:	53                   	push   %ebx
  801e34:	83 ec 28             	sub    $0x28,%esp
  801e37:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e3a:	56                   	push   %esi
  801e3b:	e8 8e f2 ff ff       	call   8010ce <fd2data>
  801e40:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	bf 00 00 00 00       	mov    $0x0,%edi
  801e4a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e4d:	74 4f                	je     801e9e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e4f:	8b 43 04             	mov    0x4(%ebx),%eax
  801e52:	8b 0b                	mov    (%ebx),%ecx
  801e54:	8d 51 20             	lea    0x20(%ecx),%edx
  801e57:	39 d0                	cmp    %edx,%eax
  801e59:	72 14                	jb     801e6f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e5b:	89 da                	mov    %ebx,%edx
  801e5d:	89 f0                	mov    %esi,%eax
  801e5f:	e8 65 ff ff ff       	call   801dc9 <_pipeisclosed>
  801e64:	85 c0                	test   %eax,%eax
  801e66:	75 3b                	jne    801ea3 <devpipe_write+0x75>
			sys_yield();
  801e68:	e8 c8 ee ff ff       	call   800d35 <sys_yield>
  801e6d:	eb e0                	jmp    801e4f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e72:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e76:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e79:	89 c2                	mov    %eax,%edx
  801e7b:	c1 fa 1f             	sar    $0x1f,%edx
  801e7e:	89 d1                	mov    %edx,%ecx
  801e80:	c1 e9 1b             	shr    $0x1b,%ecx
  801e83:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e86:	83 e2 1f             	and    $0x1f,%edx
  801e89:	29 ca                	sub    %ecx,%edx
  801e8b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e8f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e93:	83 c0 01             	add    $0x1,%eax
  801e96:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e99:	83 c7 01             	add    $0x1,%edi
  801e9c:	eb ac                	jmp    801e4a <devpipe_write+0x1c>
	return i;
  801e9e:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea1:	eb 05                	jmp    801ea8 <devpipe_write+0x7a>
				return 0;
  801ea3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eab:	5b                   	pop    %ebx
  801eac:	5e                   	pop    %esi
  801ead:	5f                   	pop    %edi
  801eae:	5d                   	pop    %ebp
  801eaf:	c3                   	ret    

00801eb0 <devpipe_read>:
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	57                   	push   %edi
  801eb4:	56                   	push   %esi
  801eb5:	53                   	push   %ebx
  801eb6:	83 ec 18             	sub    $0x18,%esp
  801eb9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ebc:	57                   	push   %edi
  801ebd:	e8 0c f2 ff ff       	call   8010ce <fd2data>
  801ec2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ec4:	83 c4 10             	add    $0x10,%esp
  801ec7:	be 00 00 00 00       	mov    $0x0,%esi
  801ecc:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ecf:	75 14                	jne    801ee5 <devpipe_read+0x35>
	return i;
  801ed1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed4:	eb 02                	jmp    801ed8 <devpipe_read+0x28>
				return i;
  801ed6:	89 f0                	mov    %esi,%eax
}
  801ed8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801edb:	5b                   	pop    %ebx
  801edc:	5e                   	pop    %esi
  801edd:	5f                   	pop    %edi
  801ede:	5d                   	pop    %ebp
  801edf:	c3                   	ret    
			sys_yield();
  801ee0:	e8 50 ee ff ff       	call   800d35 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ee5:	8b 03                	mov    (%ebx),%eax
  801ee7:	3b 43 04             	cmp    0x4(%ebx),%eax
  801eea:	75 18                	jne    801f04 <devpipe_read+0x54>
			if (i > 0)
  801eec:	85 f6                	test   %esi,%esi
  801eee:	75 e6                	jne    801ed6 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801ef0:	89 da                	mov    %ebx,%edx
  801ef2:	89 f8                	mov    %edi,%eax
  801ef4:	e8 d0 fe ff ff       	call   801dc9 <_pipeisclosed>
  801ef9:	85 c0                	test   %eax,%eax
  801efb:	74 e3                	je     801ee0 <devpipe_read+0x30>
				return 0;
  801efd:	b8 00 00 00 00       	mov    $0x0,%eax
  801f02:	eb d4                	jmp    801ed8 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f04:	99                   	cltd   
  801f05:	c1 ea 1b             	shr    $0x1b,%edx
  801f08:	01 d0                	add    %edx,%eax
  801f0a:	83 e0 1f             	and    $0x1f,%eax
  801f0d:	29 d0                	sub    %edx,%eax
  801f0f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f17:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f1a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f1d:	83 c6 01             	add    $0x1,%esi
  801f20:	eb aa                	jmp    801ecc <devpipe_read+0x1c>

00801f22 <pipe>:
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	56                   	push   %esi
  801f26:	53                   	push   %ebx
  801f27:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f2d:	50                   	push   %eax
  801f2e:	e8 b2 f1 ff ff       	call   8010e5 <fd_alloc>
  801f33:	89 c3                	mov    %eax,%ebx
  801f35:	83 c4 10             	add    $0x10,%esp
  801f38:	85 c0                	test   %eax,%eax
  801f3a:	0f 88 23 01 00 00    	js     802063 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f40:	83 ec 04             	sub    $0x4,%esp
  801f43:	68 07 04 00 00       	push   $0x407
  801f48:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4b:	6a 00                	push   $0x0
  801f4d:	e8 02 ee ff ff       	call   800d54 <sys_page_alloc>
  801f52:	89 c3                	mov    %eax,%ebx
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	85 c0                	test   %eax,%eax
  801f59:	0f 88 04 01 00 00    	js     802063 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f65:	50                   	push   %eax
  801f66:	e8 7a f1 ff ff       	call   8010e5 <fd_alloc>
  801f6b:	89 c3                	mov    %eax,%ebx
  801f6d:	83 c4 10             	add    $0x10,%esp
  801f70:	85 c0                	test   %eax,%eax
  801f72:	0f 88 db 00 00 00    	js     802053 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f78:	83 ec 04             	sub    $0x4,%esp
  801f7b:	68 07 04 00 00       	push   $0x407
  801f80:	ff 75 f0             	pushl  -0x10(%ebp)
  801f83:	6a 00                	push   $0x0
  801f85:	e8 ca ed ff ff       	call   800d54 <sys_page_alloc>
  801f8a:	89 c3                	mov    %eax,%ebx
  801f8c:	83 c4 10             	add    $0x10,%esp
  801f8f:	85 c0                	test   %eax,%eax
  801f91:	0f 88 bc 00 00 00    	js     802053 <pipe+0x131>
	va = fd2data(fd0);
  801f97:	83 ec 0c             	sub    $0xc,%esp
  801f9a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9d:	e8 2c f1 ff ff       	call   8010ce <fd2data>
  801fa2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fa4:	83 c4 0c             	add    $0xc,%esp
  801fa7:	68 07 04 00 00       	push   $0x407
  801fac:	50                   	push   %eax
  801fad:	6a 00                	push   $0x0
  801faf:	e8 a0 ed ff ff       	call   800d54 <sys_page_alloc>
  801fb4:	89 c3                	mov    %eax,%ebx
  801fb6:	83 c4 10             	add    $0x10,%esp
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	0f 88 82 00 00 00    	js     802043 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fc1:	83 ec 0c             	sub    $0xc,%esp
  801fc4:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc7:	e8 02 f1 ff ff       	call   8010ce <fd2data>
  801fcc:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fd3:	50                   	push   %eax
  801fd4:	6a 00                	push   $0x0
  801fd6:	56                   	push   %esi
  801fd7:	6a 00                	push   $0x0
  801fd9:	e8 b9 ed ff ff       	call   800d97 <sys_page_map>
  801fde:	89 c3                	mov    %eax,%ebx
  801fe0:	83 c4 20             	add    $0x20,%esp
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	78 4e                	js     802035 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801fe7:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801fec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fef:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ff1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff4:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ffb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ffe:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802000:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802003:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80200a:	83 ec 0c             	sub    $0xc,%esp
  80200d:	ff 75 f4             	pushl  -0xc(%ebp)
  802010:	e8 a9 f0 ff ff       	call   8010be <fd2num>
  802015:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802018:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80201a:	83 c4 04             	add    $0x4,%esp
  80201d:	ff 75 f0             	pushl  -0x10(%ebp)
  802020:	e8 99 f0 ff ff       	call   8010be <fd2num>
  802025:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802028:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80202b:	83 c4 10             	add    $0x10,%esp
  80202e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802033:	eb 2e                	jmp    802063 <pipe+0x141>
	sys_page_unmap(0, va);
  802035:	83 ec 08             	sub    $0x8,%esp
  802038:	56                   	push   %esi
  802039:	6a 00                	push   $0x0
  80203b:	e8 99 ed ff ff       	call   800dd9 <sys_page_unmap>
  802040:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802043:	83 ec 08             	sub    $0x8,%esp
  802046:	ff 75 f0             	pushl  -0x10(%ebp)
  802049:	6a 00                	push   $0x0
  80204b:	e8 89 ed ff ff       	call   800dd9 <sys_page_unmap>
  802050:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802053:	83 ec 08             	sub    $0x8,%esp
  802056:	ff 75 f4             	pushl  -0xc(%ebp)
  802059:	6a 00                	push   $0x0
  80205b:	e8 79 ed ff ff       	call   800dd9 <sys_page_unmap>
  802060:	83 c4 10             	add    $0x10,%esp
}
  802063:	89 d8                	mov    %ebx,%eax
  802065:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802068:	5b                   	pop    %ebx
  802069:	5e                   	pop    %esi
  80206a:	5d                   	pop    %ebp
  80206b:	c3                   	ret    

0080206c <pipeisclosed>:
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802072:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802075:	50                   	push   %eax
  802076:	ff 75 08             	pushl  0x8(%ebp)
  802079:	e8 b9 f0 ff ff       	call   801137 <fd_lookup>
  80207e:	83 c4 10             	add    $0x10,%esp
  802081:	85 c0                	test   %eax,%eax
  802083:	78 18                	js     80209d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802085:	83 ec 0c             	sub    $0xc,%esp
  802088:	ff 75 f4             	pushl  -0xc(%ebp)
  80208b:	e8 3e f0 ff ff       	call   8010ce <fd2data>
	return _pipeisclosed(fd, p);
  802090:	89 c2                	mov    %eax,%edx
  802092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802095:	e8 2f fd ff ff       	call   801dc9 <_pipeisclosed>
  80209a:	83 c4 10             	add    $0x10,%esp
}
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80209f:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a4:	c3                   	ret    

008020a5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020ab:	68 a3 2b 80 00       	push   $0x802ba3
  8020b0:	ff 75 0c             	pushl  0xc(%ebp)
  8020b3:	e8 aa e8 ff ff       	call   800962 <strcpy>
	return 0;
}
  8020b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <devcons_write>:
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	57                   	push   %edi
  8020c3:	56                   	push   %esi
  8020c4:	53                   	push   %ebx
  8020c5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020cb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020d0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020d6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020d9:	73 31                	jae    80210c <devcons_write+0x4d>
		m = n - tot;
  8020db:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020de:	29 f3                	sub    %esi,%ebx
  8020e0:	83 fb 7f             	cmp    $0x7f,%ebx
  8020e3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020e8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020eb:	83 ec 04             	sub    $0x4,%esp
  8020ee:	53                   	push   %ebx
  8020ef:	89 f0                	mov    %esi,%eax
  8020f1:	03 45 0c             	add    0xc(%ebp),%eax
  8020f4:	50                   	push   %eax
  8020f5:	57                   	push   %edi
  8020f6:	e8 f5 e9 ff ff       	call   800af0 <memmove>
		sys_cputs(buf, m);
  8020fb:	83 c4 08             	add    $0x8,%esp
  8020fe:	53                   	push   %ebx
  8020ff:	57                   	push   %edi
  802100:	e8 93 eb ff ff       	call   800c98 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802105:	01 de                	add    %ebx,%esi
  802107:	83 c4 10             	add    $0x10,%esp
  80210a:	eb ca                	jmp    8020d6 <devcons_write+0x17>
}
  80210c:	89 f0                	mov    %esi,%eax
  80210e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802111:	5b                   	pop    %ebx
  802112:	5e                   	pop    %esi
  802113:	5f                   	pop    %edi
  802114:	5d                   	pop    %ebp
  802115:	c3                   	ret    

00802116 <devcons_read>:
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 08             	sub    $0x8,%esp
  80211c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802121:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802125:	74 21                	je     802148 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802127:	e8 8a eb ff ff       	call   800cb6 <sys_cgetc>
  80212c:	85 c0                	test   %eax,%eax
  80212e:	75 07                	jne    802137 <devcons_read+0x21>
		sys_yield();
  802130:	e8 00 ec ff ff       	call   800d35 <sys_yield>
  802135:	eb f0                	jmp    802127 <devcons_read+0x11>
	if (c < 0)
  802137:	78 0f                	js     802148 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802139:	83 f8 04             	cmp    $0x4,%eax
  80213c:	74 0c                	je     80214a <devcons_read+0x34>
	*(char*)vbuf = c;
  80213e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802141:	88 02                	mov    %al,(%edx)
	return 1;
  802143:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802148:	c9                   	leave  
  802149:	c3                   	ret    
		return 0;
  80214a:	b8 00 00 00 00       	mov    $0x0,%eax
  80214f:	eb f7                	jmp    802148 <devcons_read+0x32>

00802151 <cputchar>:
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80215d:	6a 01                	push   $0x1
  80215f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802162:	50                   	push   %eax
  802163:	e8 30 eb ff ff       	call   800c98 <sys_cputs>
}
  802168:	83 c4 10             	add    $0x10,%esp
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <getchar>:
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
  802170:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802173:	6a 01                	push   $0x1
  802175:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802178:	50                   	push   %eax
  802179:	6a 00                	push   $0x0
  80217b:	e8 27 f2 ff ff       	call   8013a7 <read>
	if (r < 0)
  802180:	83 c4 10             	add    $0x10,%esp
  802183:	85 c0                	test   %eax,%eax
  802185:	78 06                	js     80218d <getchar+0x20>
	if (r < 1)
  802187:	74 06                	je     80218f <getchar+0x22>
	return c;
  802189:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    
		return -E_EOF;
  80218f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802194:	eb f7                	jmp    80218d <getchar+0x20>

00802196 <iscons>:
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
  802199:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80219c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80219f:	50                   	push   %eax
  8021a0:	ff 75 08             	pushl  0x8(%ebp)
  8021a3:	e8 8f ef ff ff       	call   801137 <fd_lookup>
  8021a8:	83 c4 10             	add    $0x10,%esp
  8021ab:	85 c0                	test   %eax,%eax
  8021ad:	78 11                	js     8021c0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021b8:	39 10                	cmp    %edx,(%eax)
  8021ba:	0f 94 c0             	sete   %al
  8021bd:	0f b6 c0             	movzbl %al,%eax
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <opencons>:
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
  8021c5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021cb:	50                   	push   %eax
  8021cc:	e8 14 ef ff ff       	call   8010e5 <fd_alloc>
  8021d1:	83 c4 10             	add    $0x10,%esp
  8021d4:	85 c0                	test   %eax,%eax
  8021d6:	78 3a                	js     802212 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021d8:	83 ec 04             	sub    $0x4,%esp
  8021db:	68 07 04 00 00       	push   $0x407
  8021e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e3:	6a 00                	push   $0x0
  8021e5:	e8 6a eb ff ff       	call   800d54 <sys_page_alloc>
  8021ea:	83 c4 10             	add    $0x10,%esp
  8021ed:	85 c0                	test   %eax,%eax
  8021ef:	78 21                	js     802212 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f4:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021fa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ff:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802206:	83 ec 0c             	sub    $0xc,%esp
  802209:	50                   	push   %eax
  80220a:	e8 af ee ff ff       	call   8010be <fd2num>
  80220f:	83 c4 10             	add    $0x10,%esp
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	56                   	push   %esi
  802218:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802219:	a1 08 40 80 00       	mov    0x804008,%eax
  80221e:	8b 40 48             	mov    0x48(%eax),%eax
  802221:	83 ec 04             	sub    $0x4,%esp
  802224:	68 e0 2b 80 00       	push   $0x802be0
  802229:	50                   	push   %eax
  80222a:	68 af 2b 80 00       	push   $0x802baf
  80222f:	e8 cf df ff ff       	call   800203 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802234:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802237:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80223d:	e8 d4 ea ff ff       	call   800d16 <sys_getenvid>
  802242:	83 c4 04             	add    $0x4,%esp
  802245:	ff 75 0c             	pushl  0xc(%ebp)
  802248:	ff 75 08             	pushl  0x8(%ebp)
  80224b:	56                   	push   %esi
  80224c:	50                   	push   %eax
  80224d:	68 bc 2b 80 00       	push   $0x802bbc
  802252:	e8 ac df ff ff       	call   800203 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802257:	83 c4 18             	add    $0x18,%esp
  80225a:	53                   	push   %ebx
  80225b:	ff 75 10             	pushl  0x10(%ebp)
  80225e:	e8 4f df ff ff       	call   8001b2 <vcprintf>
	cprintf("\n");
  802263:	c7 04 24 4b 26 80 00 	movl   $0x80264b,(%esp)
  80226a:	e8 94 df ff ff       	call   800203 <cprintf>
  80226f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802272:	cc                   	int3   
  802273:	eb fd                	jmp    802272 <_panic+0x5e>

00802275 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	56                   	push   %esi
  802279:	53                   	push   %ebx
  80227a:	8b 75 08             	mov    0x8(%ebp),%esi
  80227d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802280:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802283:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802285:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80228a:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80228d:	83 ec 0c             	sub    $0xc,%esp
  802290:	50                   	push   %eax
  802291:	e8 6e ec ff ff       	call   800f04 <sys_ipc_recv>
	if(ret < 0){
  802296:	83 c4 10             	add    $0x10,%esp
  802299:	85 c0                	test   %eax,%eax
  80229b:	78 2b                	js     8022c8 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80229d:	85 f6                	test   %esi,%esi
  80229f:	74 0a                	je     8022ab <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8022a1:	a1 08 40 80 00       	mov    0x804008,%eax
  8022a6:	8b 40 74             	mov    0x74(%eax),%eax
  8022a9:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022ab:	85 db                	test   %ebx,%ebx
  8022ad:	74 0a                	je     8022b9 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8022af:	a1 08 40 80 00       	mov    0x804008,%eax
  8022b4:	8b 40 78             	mov    0x78(%eax),%eax
  8022b7:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8022b9:	a1 08 40 80 00       	mov    0x804008,%eax
  8022be:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022c4:	5b                   	pop    %ebx
  8022c5:	5e                   	pop    %esi
  8022c6:	5d                   	pop    %ebp
  8022c7:	c3                   	ret    
		if(from_env_store)
  8022c8:	85 f6                	test   %esi,%esi
  8022ca:	74 06                	je     8022d2 <ipc_recv+0x5d>
			*from_env_store = 0;
  8022cc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022d2:	85 db                	test   %ebx,%ebx
  8022d4:	74 eb                	je     8022c1 <ipc_recv+0x4c>
			*perm_store = 0;
  8022d6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022dc:	eb e3                	jmp    8022c1 <ipc_recv+0x4c>

008022de <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
  8022e1:	57                   	push   %edi
  8022e2:	56                   	push   %esi
  8022e3:	53                   	push   %ebx
  8022e4:	83 ec 0c             	sub    $0xc,%esp
  8022e7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022ea:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022f0:	85 db                	test   %ebx,%ebx
  8022f2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022f7:	0f 44 d8             	cmove  %eax,%ebx
  8022fa:	eb 05                	jmp    802301 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022fc:	e8 34 ea ff ff       	call   800d35 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802301:	ff 75 14             	pushl  0x14(%ebp)
  802304:	53                   	push   %ebx
  802305:	56                   	push   %esi
  802306:	57                   	push   %edi
  802307:	e8 d5 eb ff ff       	call   800ee1 <sys_ipc_try_send>
  80230c:	83 c4 10             	add    $0x10,%esp
  80230f:	85 c0                	test   %eax,%eax
  802311:	74 1b                	je     80232e <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802313:	79 e7                	jns    8022fc <ipc_send+0x1e>
  802315:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802318:	74 e2                	je     8022fc <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80231a:	83 ec 04             	sub    $0x4,%esp
  80231d:	68 e7 2b 80 00       	push   $0x802be7
  802322:	6a 48                	push   $0x48
  802324:	68 fc 2b 80 00       	push   $0x802bfc
  802329:	e8 e6 fe ff ff       	call   802214 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80232e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802331:	5b                   	pop    %ebx
  802332:	5e                   	pop    %esi
  802333:	5f                   	pop    %edi
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    

00802336 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80233c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802341:	89 c2                	mov    %eax,%edx
  802343:	c1 e2 07             	shl    $0x7,%edx
  802346:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80234c:	8b 52 50             	mov    0x50(%edx),%edx
  80234f:	39 ca                	cmp    %ecx,%edx
  802351:	74 11                	je     802364 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802353:	83 c0 01             	add    $0x1,%eax
  802356:	3d 00 04 00 00       	cmp    $0x400,%eax
  80235b:	75 e4                	jne    802341 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80235d:	b8 00 00 00 00       	mov    $0x0,%eax
  802362:	eb 0b                	jmp    80236f <ipc_find_env+0x39>
			return envs[i].env_id;
  802364:	c1 e0 07             	shl    $0x7,%eax
  802367:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80236c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    

00802371 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
  802374:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802377:	89 d0                	mov    %edx,%eax
  802379:	c1 e8 16             	shr    $0x16,%eax
  80237c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802383:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802388:	f6 c1 01             	test   $0x1,%cl
  80238b:	74 1d                	je     8023aa <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80238d:	c1 ea 0c             	shr    $0xc,%edx
  802390:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802397:	f6 c2 01             	test   $0x1,%dl
  80239a:	74 0e                	je     8023aa <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80239c:	c1 ea 0c             	shr    $0xc,%edx
  80239f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023a6:	ef 
  8023a7:	0f b7 c0             	movzwl %ax,%eax
}
  8023aa:	5d                   	pop    %ebp
  8023ab:	c3                   	ret    
  8023ac:	66 90                	xchg   %ax,%ax
  8023ae:	66 90                	xchg   %ax,%ax

008023b0 <__udivdi3>:
  8023b0:	55                   	push   %ebp
  8023b1:	57                   	push   %edi
  8023b2:	56                   	push   %esi
  8023b3:	53                   	push   %ebx
  8023b4:	83 ec 1c             	sub    $0x1c,%esp
  8023b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023c7:	85 d2                	test   %edx,%edx
  8023c9:	75 4d                	jne    802418 <__udivdi3+0x68>
  8023cb:	39 f3                	cmp    %esi,%ebx
  8023cd:	76 19                	jbe    8023e8 <__udivdi3+0x38>
  8023cf:	31 ff                	xor    %edi,%edi
  8023d1:	89 e8                	mov    %ebp,%eax
  8023d3:	89 f2                	mov    %esi,%edx
  8023d5:	f7 f3                	div    %ebx
  8023d7:	89 fa                	mov    %edi,%edx
  8023d9:	83 c4 1c             	add    $0x1c,%esp
  8023dc:	5b                   	pop    %ebx
  8023dd:	5e                   	pop    %esi
  8023de:	5f                   	pop    %edi
  8023df:	5d                   	pop    %ebp
  8023e0:	c3                   	ret    
  8023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023e8:	89 d9                	mov    %ebx,%ecx
  8023ea:	85 db                	test   %ebx,%ebx
  8023ec:	75 0b                	jne    8023f9 <__udivdi3+0x49>
  8023ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f3:	31 d2                	xor    %edx,%edx
  8023f5:	f7 f3                	div    %ebx
  8023f7:	89 c1                	mov    %eax,%ecx
  8023f9:	31 d2                	xor    %edx,%edx
  8023fb:	89 f0                	mov    %esi,%eax
  8023fd:	f7 f1                	div    %ecx
  8023ff:	89 c6                	mov    %eax,%esi
  802401:	89 e8                	mov    %ebp,%eax
  802403:	89 f7                	mov    %esi,%edi
  802405:	f7 f1                	div    %ecx
  802407:	89 fa                	mov    %edi,%edx
  802409:	83 c4 1c             	add    $0x1c,%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5f                   	pop    %edi
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    
  802411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802418:	39 f2                	cmp    %esi,%edx
  80241a:	77 1c                	ja     802438 <__udivdi3+0x88>
  80241c:	0f bd fa             	bsr    %edx,%edi
  80241f:	83 f7 1f             	xor    $0x1f,%edi
  802422:	75 2c                	jne    802450 <__udivdi3+0xa0>
  802424:	39 f2                	cmp    %esi,%edx
  802426:	72 06                	jb     80242e <__udivdi3+0x7e>
  802428:	31 c0                	xor    %eax,%eax
  80242a:	39 eb                	cmp    %ebp,%ebx
  80242c:	77 a9                	ja     8023d7 <__udivdi3+0x27>
  80242e:	b8 01 00 00 00       	mov    $0x1,%eax
  802433:	eb a2                	jmp    8023d7 <__udivdi3+0x27>
  802435:	8d 76 00             	lea    0x0(%esi),%esi
  802438:	31 ff                	xor    %edi,%edi
  80243a:	31 c0                	xor    %eax,%eax
  80243c:	89 fa                	mov    %edi,%edx
  80243e:	83 c4 1c             	add    $0x1c,%esp
  802441:	5b                   	pop    %ebx
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    
  802446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80244d:	8d 76 00             	lea    0x0(%esi),%esi
  802450:	89 f9                	mov    %edi,%ecx
  802452:	b8 20 00 00 00       	mov    $0x20,%eax
  802457:	29 f8                	sub    %edi,%eax
  802459:	d3 e2                	shl    %cl,%edx
  80245b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80245f:	89 c1                	mov    %eax,%ecx
  802461:	89 da                	mov    %ebx,%edx
  802463:	d3 ea                	shr    %cl,%edx
  802465:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802469:	09 d1                	or     %edx,%ecx
  80246b:	89 f2                	mov    %esi,%edx
  80246d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802471:	89 f9                	mov    %edi,%ecx
  802473:	d3 e3                	shl    %cl,%ebx
  802475:	89 c1                	mov    %eax,%ecx
  802477:	d3 ea                	shr    %cl,%edx
  802479:	89 f9                	mov    %edi,%ecx
  80247b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80247f:	89 eb                	mov    %ebp,%ebx
  802481:	d3 e6                	shl    %cl,%esi
  802483:	89 c1                	mov    %eax,%ecx
  802485:	d3 eb                	shr    %cl,%ebx
  802487:	09 de                	or     %ebx,%esi
  802489:	89 f0                	mov    %esi,%eax
  80248b:	f7 74 24 08          	divl   0x8(%esp)
  80248f:	89 d6                	mov    %edx,%esi
  802491:	89 c3                	mov    %eax,%ebx
  802493:	f7 64 24 0c          	mull   0xc(%esp)
  802497:	39 d6                	cmp    %edx,%esi
  802499:	72 15                	jb     8024b0 <__udivdi3+0x100>
  80249b:	89 f9                	mov    %edi,%ecx
  80249d:	d3 e5                	shl    %cl,%ebp
  80249f:	39 c5                	cmp    %eax,%ebp
  8024a1:	73 04                	jae    8024a7 <__udivdi3+0xf7>
  8024a3:	39 d6                	cmp    %edx,%esi
  8024a5:	74 09                	je     8024b0 <__udivdi3+0x100>
  8024a7:	89 d8                	mov    %ebx,%eax
  8024a9:	31 ff                	xor    %edi,%edi
  8024ab:	e9 27 ff ff ff       	jmp    8023d7 <__udivdi3+0x27>
  8024b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024b3:	31 ff                	xor    %edi,%edi
  8024b5:	e9 1d ff ff ff       	jmp    8023d7 <__udivdi3+0x27>
  8024ba:	66 90                	xchg   %ax,%ax
  8024bc:	66 90                	xchg   %ax,%ax
  8024be:	66 90                	xchg   %ax,%ax

008024c0 <__umoddi3>:
  8024c0:	55                   	push   %ebp
  8024c1:	57                   	push   %edi
  8024c2:	56                   	push   %esi
  8024c3:	53                   	push   %ebx
  8024c4:	83 ec 1c             	sub    $0x1c,%esp
  8024c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024d7:	89 da                	mov    %ebx,%edx
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	75 43                	jne    802520 <__umoddi3+0x60>
  8024dd:	39 df                	cmp    %ebx,%edi
  8024df:	76 17                	jbe    8024f8 <__umoddi3+0x38>
  8024e1:	89 f0                	mov    %esi,%eax
  8024e3:	f7 f7                	div    %edi
  8024e5:	89 d0                	mov    %edx,%eax
  8024e7:	31 d2                	xor    %edx,%edx
  8024e9:	83 c4 1c             	add    $0x1c,%esp
  8024ec:	5b                   	pop    %ebx
  8024ed:	5e                   	pop    %esi
  8024ee:	5f                   	pop    %edi
  8024ef:	5d                   	pop    %ebp
  8024f0:	c3                   	ret    
  8024f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024f8:	89 fd                	mov    %edi,%ebp
  8024fa:	85 ff                	test   %edi,%edi
  8024fc:	75 0b                	jne    802509 <__umoddi3+0x49>
  8024fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802503:	31 d2                	xor    %edx,%edx
  802505:	f7 f7                	div    %edi
  802507:	89 c5                	mov    %eax,%ebp
  802509:	89 d8                	mov    %ebx,%eax
  80250b:	31 d2                	xor    %edx,%edx
  80250d:	f7 f5                	div    %ebp
  80250f:	89 f0                	mov    %esi,%eax
  802511:	f7 f5                	div    %ebp
  802513:	89 d0                	mov    %edx,%eax
  802515:	eb d0                	jmp    8024e7 <__umoddi3+0x27>
  802517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80251e:	66 90                	xchg   %ax,%ax
  802520:	89 f1                	mov    %esi,%ecx
  802522:	39 d8                	cmp    %ebx,%eax
  802524:	76 0a                	jbe    802530 <__umoddi3+0x70>
  802526:	89 f0                	mov    %esi,%eax
  802528:	83 c4 1c             	add    $0x1c,%esp
  80252b:	5b                   	pop    %ebx
  80252c:	5e                   	pop    %esi
  80252d:	5f                   	pop    %edi
  80252e:	5d                   	pop    %ebp
  80252f:	c3                   	ret    
  802530:	0f bd e8             	bsr    %eax,%ebp
  802533:	83 f5 1f             	xor    $0x1f,%ebp
  802536:	75 20                	jne    802558 <__umoddi3+0x98>
  802538:	39 d8                	cmp    %ebx,%eax
  80253a:	0f 82 b0 00 00 00    	jb     8025f0 <__umoddi3+0x130>
  802540:	39 f7                	cmp    %esi,%edi
  802542:	0f 86 a8 00 00 00    	jbe    8025f0 <__umoddi3+0x130>
  802548:	89 c8                	mov    %ecx,%eax
  80254a:	83 c4 1c             	add    $0x1c,%esp
  80254d:	5b                   	pop    %ebx
  80254e:	5e                   	pop    %esi
  80254f:	5f                   	pop    %edi
  802550:	5d                   	pop    %ebp
  802551:	c3                   	ret    
  802552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802558:	89 e9                	mov    %ebp,%ecx
  80255a:	ba 20 00 00 00       	mov    $0x20,%edx
  80255f:	29 ea                	sub    %ebp,%edx
  802561:	d3 e0                	shl    %cl,%eax
  802563:	89 44 24 08          	mov    %eax,0x8(%esp)
  802567:	89 d1                	mov    %edx,%ecx
  802569:	89 f8                	mov    %edi,%eax
  80256b:	d3 e8                	shr    %cl,%eax
  80256d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802571:	89 54 24 04          	mov    %edx,0x4(%esp)
  802575:	8b 54 24 04          	mov    0x4(%esp),%edx
  802579:	09 c1                	or     %eax,%ecx
  80257b:	89 d8                	mov    %ebx,%eax
  80257d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802581:	89 e9                	mov    %ebp,%ecx
  802583:	d3 e7                	shl    %cl,%edi
  802585:	89 d1                	mov    %edx,%ecx
  802587:	d3 e8                	shr    %cl,%eax
  802589:	89 e9                	mov    %ebp,%ecx
  80258b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80258f:	d3 e3                	shl    %cl,%ebx
  802591:	89 c7                	mov    %eax,%edi
  802593:	89 d1                	mov    %edx,%ecx
  802595:	89 f0                	mov    %esi,%eax
  802597:	d3 e8                	shr    %cl,%eax
  802599:	89 e9                	mov    %ebp,%ecx
  80259b:	89 fa                	mov    %edi,%edx
  80259d:	d3 e6                	shl    %cl,%esi
  80259f:	09 d8                	or     %ebx,%eax
  8025a1:	f7 74 24 08          	divl   0x8(%esp)
  8025a5:	89 d1                	mov    %edx,%ecx
  8025a7:	89 f3                	mov    %esi,%ebx
  8025a9:	f7 64 24 0c          	mull   0xc(%esp)
  8025ad:	89 c6                	mov    %eax,%esi
  8025af:	89 d7                	mov    %edx,%edi
  8025b1:	39 d1                	cmp    %edx,%ecx
  8025b3:	72 06                	jb     8025bb <__umoddi3+0xfb>
  8025b5:	75 10                	jne    8025c7 <__umoddi3+0x107>
  8025b7:	39 c3                	cmp    %eax,%ebx
  8025b9:	73 0c                	jae    8025c7 <__umoddi3+0x107>
  8025bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025c3:	89 d7                	mov    %edx,%edi
  8025c5:	89 c6                	mov    %eax,%esi
  8025c7:	89 ca                	mov    %ecx,%edx
  8025c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025ce:	29 f3                	sub    %esi,%ebx
  8025d0:	19 fa                	sbb    %edi,%edx
  8025d2:	89 d0                	mov    %edx,%eax
  8025d4:	d3 e0                	shl    %cl,%eax
  8025d6:	89 e9                	mov    %ebp,%ecx
  8025d8:	d3 eb                	shr    %cl,%ebx
  8025da:	d3 ea                	shr    %cl,%edx
  8025dc:	09 d8                	or     %ebx,%eax
  8025de:	83 c4 1c             	add    $0x1c,%esp
  8025e1:	5b                   	pop    %ebx
  8025e2:	5e                   	pop    %esi
  8025e3:	5f                   	pop    %edi
  8025e4:	5d                   	pop    %ebp
  8025e5:	c3                   	ret    
  8025e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ed:	8d 76 00             	lea    0x0(%esi),%esi
  8025f0:	89 da                	mov    %ebx,%edx
  8025f2:	29 fe                	sub    %edi,%esi
  8025f4:	19 c2                	sbb    %eax,%edx
  8025f6:	89 f1                	mov    %esi,%ecx
  8025f8:	89 c8                	mov    %ecx,%eax
  8025fa:	e9 4b ff ff ff       	jmp    80254a <__umoddi3+0x8a>
