
obj/user/pingpongs.debug:     file format elf32-i386


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
  80002c:	e8 6a 00 00 00       	call   80009b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003a:	e8 c0 13 00 00       	call   8013ff <sfork>
  80003f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800042:	85 c0                	test   %eax,%eax
  800044:	75 44                	jne    80008a <umain+0x57>
		// cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800046:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	6a 00                	push   $0x0
  800050:	53                   	push   %ebx
  800051:	e8 14 15 00 00       	call   80156a <ipc_recv>
		// cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, getthisenv(), getthisenv()->env_id);
		if (val == 10)
  800056:	a1 08 50 80 00       	mov    0x805008,%eax
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	83 f8 0a             	cmp    $0xa,%eax
  800061:	74 22                	je     800085 <umain+0x52>
			return;
		++val;
  800063:	83 c0 01             	add    $0x1,%eax
  800066:	a3 08 50 80 00       	mov    %eax,0x805008
		ipc_send(who, 0, 0, 0);
  80006b:	6a 00                	push   $0x0
  80006d:	6a 00                	push   $0x0
  80006f:	6a 00                	push   $0x0
  800071:	ff 75 f4             	pushl  -0xc(%ebp)
  800074:	e8 5a 15 00 00       	call   8015d3 <ipc_send>
		if (val == 10)
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	83 3d 08 50 80 00 0a 	cmpl   $0xa,0x805008
  800083:	75 c4                	jne    800049 <umain+0x16>
			return;
	}

}
  800085:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800088:	c9                   	leave  
  800089:	c3                   	ret    
		ipc_send(who, 0, 0, 0);
  80008a:	6a 00                	push   $0x0
  80008c:	6a 00                	push   $0x0
  80008e:	6a 00                	push   $0x0
  800090:	50                   	push   %eax
  800091:	e8 3d 15 00 00       	call   8015d3 <ipc_send>
  800096:	83 c4 10             	add    $0x10,%esp
  800099:	eb ab                	jmp    800046 <umain+0x13>

0080009b <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80009b:	55                   	push   %ebp
  80009c:	89 e5                	mov    %esp,%ebp
  80009e:	57                   	push   %edi
  80009f:	56                   	push   %esi
  8000a0:	53                   	push   %ebx
  8000a1:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000a4:	c7 05 0c 50 80 00 00 	movl   $0x0,0x80500c
  8000ab:	00 00 00 
	envid_t find = sys_getenvid();
  8000ae:	e8 9d 0c 00 00       	call   800d50 <sys_getenvid>
  8000b3:	8b 1d 0c 50 80 00    	mov    0x80500c,%ebx
  8000b9:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000be:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000c3:	bf 01 00 00 00       	mov    $0x1,%edi
  8000c8:	eb 0b                	jmp    8000d5 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000ca:	83 c2 01             	add    $0x1,%edx
  8000cd:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000d3:	74 21                	je     8000f6 <libmain+0x5b>
		if(envs[i].env_id == find)
  8000d5:	89 d1                	mov    %edx,%ecx
  8000d7:	c1 e1 07             	shl    $0x7,%ecx
  8000da:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000e0:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000e3:	39 c1                	cmp    %eax,%ecx
  8000e5:	75 e3                	jne    8000ca <libmain+0x2f>
  8000e7:	89 d3                	mov    %edx,%ebx
  8000e9:	c1 e3 07             	shl    $0x7,%ebx
  8000ec:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000f2:	89 fe                	mov    %edi,%esi
  8000f4:	eb d4                	jmp    8000ca <libmain+0x2f>
  8000f6:	89 f0                	mov    %esi,%eax
  8000f8:	84 c0                	test   %al,%al
  8000fa:	74 06                	je     800102 <libmain+0x67>
  8000fc:	89 1d 0c 50 80 00    	mov    %ebx,0x80500c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800102:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800106:	7e 0a                	jle    800112 <libmain+0x77>
		binaryname = argv[0];
  800108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80010b:	8b 00                	mov    (%eax),%eax
  80010d:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800112:	a1 0c 50 80 00       	mov    0x80500c,%eax
  800117:	8b 40 48             	mov    0x48(%eax),%eax
  80011a:	83 ec 08             	sub    $0x8,%esp
  80011d:	50                   	push   %eax
  80011e:	68 40 2b 80 00       	push   $0x802b40
  800123:	e8 15 01 00 00       	call   80023d <cprintf>
	cprintf("before umain\n");
  800128:	c7 04 24 5e 2b 80 00 	movl   $0x802b5e,(%esp)
  80012f:	e8 09 01 00 00       	call   80023d <cprintf>
	// call user main routine
	umain(argc, argv);
  800134:	83 c4 08             	add    $0x8,%esp
  800137:	ff 75 0c             	pushl  0xc(%ebp)
  80013a:	ff 75 08             	pushl  0x8(%ebp)
  80013d:	e8 f1 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800142:	c7 04 24 6c 2b 80 00 	movl   $0x802b6c,(%esp)
  800149:	e8 ef 00 00 00       	call   80023d <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80014e:	a1 0c 50 80 00       	mov    0x80500c,%eax
  800153:	8b 40 48             	mov    0x48(%eax),%eax
  800156:	83 c4 08             	add    $0x8,%esp
  800159:	50                   	push   %eax
  80015a:	68 79 2b 80 00       	push   $0x802b79
  80015f:	e8 d9 00 00 00       	call   80023d <cprintf>
	// exit gracefully
	exit();
  800164:	e8 0b 00 00 00       	call   800174 <exit>
}
  800169:	83 c4 10             	add    $0x10,%esp
  80016c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80016f:	5b                   	pop    %ebx
  800170:	5e                   	pop    %esi
  800171:	5f                   	pop    %edi
  800172:	5d                   	pop    %ebp
  800173:	c3                   	ret    

00800174 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80017a:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80017f:	8b 40 48             	mov    0x48(%eax),%eax
  800182:	68 a4 2b 80 00       	push   $0x802ba4
  800187:	50                   	push   %eax
  800188:	68 98 2b 80 00       	push   $0x802b98
  80018d:	e8 ab 00 00 00       	call   80023d <cprintf>
	close_all();
  800192:	e8 a7 16 00 00       	call   80183e <close_all>
	sys_env_destroy(0);
  800197:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80019e:	e8 6c 0b 00 00       	call   800d0f <sys_env_destroy>
}
  8001a3:	83 c4 10             	add    $0x10,%esp
  8001a6:	c9                   	leave  
  8001a7:	c3                   	ret    

008001a8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	53                   	push   %ebx
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b2:	8b 13                	mov    (%ebx),%edx
  8001b4:	8d 42 01             	lea    0x1(%edx),%eax
  8001b7:	89 03                	mov    %eax,(%ebx)
  8001b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001bc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c5:	74 09                	je     8001d0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001c7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ce:	c9                   	leave  
  8001cf:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	68 ff 00 00 00       	push   $0xff
  8001d8:	8d 43 08             	lea    0x8(%ebx),%eax
  8001db:	50                   	push   %eax
  8001dc:	e8 f1 0a 00 00       	call   800cd2 <sys_cputs>
		b->idx = 0;
  8001e1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	eb db                	jmp    8001c7 <putch+0x1f>

008001ec <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001fc:	00 00 00 
	b.cnt = 0;
  8001ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800206:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800209:	ff 75 0c             	pushl  0xc(%ebp)
  80020c:	ff 75 08             	pushl  0x8(%ebp)
  80020f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800215:	50                   	push   %eax
  800216:	68 a8 01 80 00       	push   $0x8001a8
  80021b:	e8 4a 01 00 00       	call   80036a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800220:	83 c4 08             	add    $0x8,%esp
  800223:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800229:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80022f:	50                   	push   %eax
  800230:	e8 9d 0a 00 00       	call   800cd2 <sys_cputs>

	return b.cnt;
}
  800235:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80023b:	c9                   	leave  
  80023c:	c3                   	ret    

0080023d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800243:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800246:	50                   	push   %eax
  800247:	ff 75 08             	pushl  0x8(%ebp)
  80024a:	e8 9d ff ff ff       	call   8001ec <vcprintf>
	va_end(ap);

	return cnt;
}
  80024f:	c9                   	leave  
  800250:	c3                   	ret    

00800251 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	57                   	push   %edi
  800255:	56                   	push   %esi
  800256:	53                   	push   %ebx
  800257:	83 ec 1c             	sub    $0x1c,%esp
  80025a:	89 c6                	mov    %eax,%esi
  80025c:	89 d7                	mov    %edx,%edi
  80025e:	8b 45 08             	mov    0x8(%ebp),%eax
  800261:	8b 55 0c             	mov    0xc(%ebp),%edx
  800264:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800267:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80026a:	8b 45 10             	mov    0x10(%ebp),%eax
  80026d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800270:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800274:	74 2c                	je     8002a2 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800276:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800279:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800280:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800283:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800286:	39 c2                	cmp    %eax,%edx
  800288:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80028b:	73 43                	jae    8002d0 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80028d:	83 eb 01             	sub    $0x1,%ebx
  800290:	85 db                	test   %ebx,%ebx
  800292:	7e 6c                	jle    800300 <printnum+0xaf>
				putch(padc, putdat);
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	57                   	push   %edi
  800298:	ff 75 18             	pushl  0x18(%ebp)
  80029b:	ff d6                	call   *%esi
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	eb eb                	jmp    80028d <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002a2:	83 ec 0c             	sub    $0xc,%esp
  8002a5:	6a 20                	push   $0x20
  8002a7:	6a 00                	push   $0x0
  8002a9:	50                   	push   %eax
  8002aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b0:	89 fa                	mov    %edi,%edx
  8002b2:	89 f0                	mov    %esi,%eax
  8002b4:	e8 98 ff ff ff       	call   800251 <printnum>
		while (--width > 0)
  8002b9:	83 c4 20             	add    $0x20,%esp
  8002bc:	83 eb 01             	sub    $0x1,%ebx
  8002bf:	85 db                	test   %ebx,%ebx
  8002c1:	7e 65                	jle    800328 <printnum+0xd7>
			putch(padc, putdat);
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	57                   	push   %edi
  8002c7:	6a 20                	push   $0x20
  8002c9:	ff d6                	call   *%esi
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	eb ec                	jmp    8002bc <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	ff 75 18             	pushl  0x18(%ebp)
  8002d6:	83 eb 01             	sub    $0x1,%ebx
  8002d9:	53                   	push   %ebx
  8002da:	50                   	push   %eax
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	ff 75 dc             	pushl  -0x24(%ebp)
  8002e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ea:	e8 01 26 00 00       	call   8028f0 <__udivdi3>
  8002ef:	83 c4 18             	add    $0x18,%esp
  8002f2:	52                   	push   %edx
  8002f3:	50                   	push   %eax
  8002f4:	89 fa                	mov    %edi,%edx
  8002f6:	89 f0                	mov    %esi,%eax
  8002f8:	e8 54 ff ff ff       	call   800251 <printnum>
  8002fd:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	57                   	push   %edi
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 dc             	pushl  -0x24(%ebp)
  80030a:	ff 75 d8             	pushl  -0x28(%ebp)
  80030d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800310:	ff 75 e0             	pushl  -0x20(%ebp)
  800313:	e8 e8 26 00 00       	call   802a00 <__umoddi3>
  800318:	83 c4 14             	add    $0x14,%esp
  80031b:	0f be 80 a9 2b 80 00 	movsbl 0x802ba9(%eax),%eax
  800322:	50                   	push   %eax
  800323:	ff d6                	call   *%esi
  800325:	83 c4 10             	add    $0x10,%esp
	}
}
  800328:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032b:	5b                   	pop    %ebx
  80032c:	5e                   	pop    %esi
  80032d:	5f                   	pop    %edi
  80032e:	5d                   	pop    %ebp
  80032f:	c3                   	ret    

00800330 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800336:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80033a:	8b 10                	mov    (%eax),%edx
  80033c:	3b 50 04             	cmp    0x4(%eax),%edx
  80033f:	73 0a                	jae    80034b <sprintputch+0x1b>
		*b->buf++ = ch;
  800341:	8d 4a 01             	lea    0x1(%edx),%ecx
  800344:	89 08                	mov    %ecx,(%eax)
  800346:	8b 45 08             	mov    0x8(%ebp),%eax
  800349:	88 02                	mov    %al,(%edx)
}
  80034b:	5d                   	pop    %ebp
  80034c:	c3                   	ret    

0080034d <printfmt>:
{
  80034d:	55                   	push   %ebp
  80034e:	89 e5                	mov    %esp,%ebp
  800350:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800353:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800356:	50                   	push   %eax
  800357:	ff 75 10             	pushl  0x10(%ebp)
  80035a:	ff 75 0c             	pushl  0xc(%ebp)
  80035d:	ff 75 08             	pushl  0x8(%ebp)
  800360:	e8 05 00 00 00       	call   80036a <vprintfmt>
}
  800365:	83 c4 10             	add    $0x10,%esp
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <vprintfmt>:
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	57                   	push   %edi
  80036e:	56                   	push   %esi
  80036f:	53                   	push   %ebx
  800370:	83 ec 3c             	sub    $0x3c,%esp
  800373:	8b 75 08             	mov    0x8(%ebp),%esi
  800376:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800379:	8b 7d 10             	mov    0x10(%ebp),%edi
  80037c:	e9 32 04 00 00       	jmp    8007b3 <vprintfmt+0x449>
		padc = ' ';
  800381:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800385:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80038c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800393:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80039a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003a1:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003a8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ad:	8d 47 01             	lea    0x1(%edi),%eax
  8003b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003b3:	0f b6 17             	movzbl (%edi),%edx
  8003b6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003b9:	3c 55                	cmp    $0x55,%al
  8003bb:	0f 87 12 05 00 00    	ja     8008d3 <vprintfmt+0x569>
  8003c1:	0f b6 c0             	movzbl %al,%eax
  8003c4:	ff 24 85 80 2d 80 00 	jmp    *0x802d80(,%eax,4)
  8003cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003ce:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003d2:	eb d9                	jmp    8003ad <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003d7:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003db:	eb d0                	jmp    8003ad <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003dd:	0f b6 d2             	movzbl %dl,%edx
  8003e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e8:	89 75 08             	mov    %esi,0x8(%ebp)
  8003eb:	eb 03                	jmp    8003f0 <vprintfmt+0x86>
  8003ed:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003f0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003f3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003f7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003fa:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003fd:	83 fe 09             	cmp    $0x9,%esi
  800400:	76 eb                	jbe    8003ed <vprintfmt+0x83>
  800402:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800405:	8b 75 08             	mov    0x8(%ebp),%esi
  800408:	eb 14                	jmp    80041e <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80040a:	8b 45 14             	mov    0x14(%ebp),%eax
  80040d:	8b 00                	mov    (%eax),%eax
  80040f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800412:	8b 45 14             	mov    0x14(%ebp),%eax
  800415:	8d 40 04             	lea    0x4(%eax),%eax
  800418:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80041b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80041e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800422:	79 89                	jns    8003ad <vprintfmt+0x43>
				width = precision, precision = -1;
  800424:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800427:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80042a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800431:	e9 77 ff ff ff       	jmp    8003ad <vprintfmt+0x43>
  800436:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800439:	85 c0                	test   %eax,%eax
  80043b:	0f 48 c1             	cmovs  %ecx,%eax
  80043e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800441:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800444:	e9 64 ff ff ff       	jmp    8003ad <vprintfmt+0x43>
  800449:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80044c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800453:	e9 55 ff ff ff       	jmp    8003ad <vprintfmt+0x43>
			lflag++;
  800458:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80045c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80045f:	e9 49 ff ff ff       	jmp    8003ad <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	8d 78 04             	lea    0x4(%eax),%edi
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	53                   	push   %ebx
  80046e:	ff 30                	pushl  (%eax)
  800470:	ff d6                	call   *%esi
			break;
  800472:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800475:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800478:	e9 33 03 00 00       	jmp    8007b0 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80047d:	8b 45 14             	mov    0x14(%ebp),%eax
  800480:	8d 78 04             	lea    0x4(%eax),%edi
  800483:	8b 00                	mov    (%eax),%eax
  800485:	99                   	cltd   
  800486:	31 d0                	xor    %edx,%eax
  800488:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80048a:	83 f8 11             	cmp    $0x11,%eax
  80048d:	7f 23                	jg     8004b2 <vprintfmt+0x148>
  80048f:	8b 14 85 e0 2e 80 00 	mov    0x802ee0(,%eax,4),%edx
  800496:	85 d2                	test   %edx,%edx
  800498:	74 18                	je     8004b2 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80049a:	52                   	push   %edx
  80049b:	68 0d 31 80 00       	push   $0x80310d
  8004a0:	53                   	push   %ebx
  8004a1:	56                   	push   %esi
  8004a2:	e8 a6 fe ff ff       	call   80034d <printfmt>
  8004a7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004aa:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004ad:	e9 fe 02 00 00       	jmp    8007b0 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004b2:	50                   	push   %eax
  8004b3:	68 c1 2b 80 00       	push   $0x802bc1
  8004b8:	53                   	push   %ebx
  8004b9:	56                   	push   %esi
  8004ba:	e8 8e fe ff ff       	call   80034d <printfmt>
  8004bf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004c5:	e9 e6 02 00 00       	jmp    8007b0 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cd:	83 c0 04             	add    $0x4,%eax
  8004d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d6:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004d8:	85 c9                	test   %ecx,%ecx
  8004da:	b8 ba 2b 80 00       	mov    $0x802bba,%eax
  8004df:	0f 45 c1             	cmovne %ecx,%eax
  8004e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e9:	7e 06                	jle    8004f1 <vprintfmt+0x187>
  8004eb:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004ef:	75 0d                	jne    8004fe <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004f4:	89 c7                	mov    %eax,%edi
  8004f6:	03 45 e0             	add    -0x20(%ebp),%eax
  8004f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004fc:	eb 53                	jmp    800551 <vprintfmt+0x1e7>
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	ff 75 d8             	pushl  -0x28(%ebp)
  800504:	50                   	push   %eax
  800505:	e8 71 04 00 00       	call   80097b <strnlen>
  80050a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80050d:	29 c1                	sub    %eax,%ecx
  80050f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800512:	83 c4 10             	add    $0x10,%esp
  800515:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800517:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80051b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80051e:	eb 0f                	jmp    80052f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	53                   	push   %ebx
  800524:	ff 75 e0             	pushl  -0x20(%ebp)
  800527:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800529:	83 ef 01             	sub    $0x1,%edi
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	85 ff                	test   %edi,%edi
  800531:	7f ed                	jg     800520 <vprintfmt+0x1b6>
  800533:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800536:	85 c9                	test   %ecx,%ecx
  800538:	b8 00 00 00 00       	mov    $0x0,%eax
  80053d:	0f 49 c1             	cmovns %ecx,%eax
  800540:	29 c1                	sub    %eax,%ecx
  800542:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800545:	eb aa                	jmp    8004f1 <vprintfmt+0x187>
					putch(ch, putdat);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	53                   	push   %ebx
  80054b:	52                   	push   %edx
  80054c:	ff d6                	call   *%esi
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800554:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800556:	83 c7 01             	add    $0x1,%edi
  800559:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80055d:	0f be d0             	movsbl %al,%edx
  800560:	85 d2                	test   %edx,%edx
  800562:	74 4b                	je     8005af <vprintfmt+0x245>
  800564:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800568:	78 06                	js     800570 <vprintfmt+0x206>
  80056a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80056e:	78 1e                	js     80058e <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800570:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800574:	74 d1                	je     800547 <vprintfmt+0x1dd>
  800576:	0f be c0             	movsbl %al,%eax
  800579:	83 e8 20             	sub    $0x20,%eax
  80057c:	83 f8 5e             	cmp    $0x5e,%eax
  80057f:	76 c6                	jbe    800547 <vprintfmt+0x1dd>
					putch('?', putdat);
  800581:	83 ec 08             	sub    $0x8,%esp
  800584:	53                   	push   %ebx
  800585:	6a 3f                	push   $0x3f
  800587:	ff d6                	call   *%esi
  800589:	83 c4 10             	add    $0x10,%esp
  80058c:	eb c3                	jmp    800551 <vprintfmt+0x1e7>
  80058e:	89 cf                	mov    %ecx,%edi
  800590:	eb 0e                	jmp    8005a0 <vprintfmt+0x236>
				putch(' ', putdat);
  800592:	83 ec 08             	sub    $0x8,%esp
  800595:	53                   	push   %ebx
  800596:	6a 20                	push   $0x20
  800598:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80059a:	83 ef 01             	sub    $0x1,%edi
  80059d:	83 c4 10             	add    $0x10,%esp
  8005a0:	85 ff                	test   %edi,%edi
  8005a2:	7f ee                	jg     800592 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005aa:	e9 01 02 00 00       	jmp    8007b0 <vprintfmt+0x446>
  8005af:	89 cf                	mov    %ecx,%edi
  8005b1:	eb ed                	jmp    8005a0 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005b6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005bd:	e9 eb fd ff ff       	jmp    8003ad <vprintfmt+0x43>
	if (lflag >= 2)
  8005c2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005c6:	7f 21                	jg     8005e9 <vprintfmt+0x27f>
	else if (lflag)
  8005c8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005cc:	74 68                	je     800636 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005d6:	89 c1                	mov    %eax,%ecx
  8005d8:	c1 f9 1f             	sar    $0x1f,%ecx
  8005db:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8d 40 04             	lea    0x4(%eax),%eax
  8005e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e7:	eb 17                	jmp    800600 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8b 50 04             	mov    0x4(%eax),%edx
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 40 08             	lea    0x8(%eax),%eax
  8005fd:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800600:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800603:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800606:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800609:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80060c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800610:	78 3f                	js     800651 <vprintfmt+0x2e7>
			base = 10;
  800612:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800617:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80061b:	0f 84 71 01 00 00    	je     800792 <vprintfmt+0x428>
				putch('+', putdat);
  800621:	83 ec 08             	sub    $0x8,%esp
  800624:	53                   	push   %ebx
  800625:	6a 2b                	push   $0x2b
  800627:	ff d6                	call   *%esi
  800629:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800631:	e9 5c 01 00 00       	jmp    800792 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80063e:	89 c1                	mov    %eax,%ecx
  800640:	c1 f9 1f             	sar    $0x1f,%ecx
  800643:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 40 04             	lea    0x4(%eax),%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
  80064f:	eb af                	jmp    800600 <vprintfmt+0x296>
				putch('-', putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	53                   	push   %ebx
  800655:	6a 2d                	push   $0x2d
  800657:	ff d6                	call   *%esi
				num = -(long long) num;
  800659:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80065c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80065f:	f7 d8                	neg    %eax
  800661:	83 d2 00             	adc    $0x0,%edx
  800664:	f7 da                	neg    %edx
  800666:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800669:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80066f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800674:	e9 19 01 00 00       	jmp    800792 <vprintfmt+0x428>
	if (lflag >= 2)
  800679:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80067d:	7f 29                	jg     8006a8 <vprintfmt+0x33e>
	else if (lflag)
  80067f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800683:	74 44                	je     8006c9 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	ba 00 00 00 00       	mov    $0x0,%edx
  80068f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800692:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 40 04             	lea    0x4(%eax),%eax
  80069b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069e:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a3:	e9 ea 00 00 00       	jmp    800792 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8b 50 04             	mov    0x4(%eax),%edx
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	8d 40 08             	lea    0x8(%eax),%eax
  8006bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006bf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c4:	e9 c9 00 00 00       	jmp    800792 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8d 40 04             	lea    0x4(%eax),%eax
  8006df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e7:	e9 a6 00 00 00       	jmp    800792 <vprintfmt+0x428>
			putch('0', putdat);
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	53                   	push   %ebx
  8006f0:	6a 30                	push   $0x30
  8006f2:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006f4:	83 c4 10             	add    $0x10,%esp
  8006f7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006fb:	7f 26                	jg     800723 <vprintfmt+0x3b9>
	else if (lflag)
  8006fd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800701:	74 3e                	je     800741 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	ba 00 00 00 00       	mov    $0x0,%edx
  80070d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800710:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8d 40 04             	lea    0x4(%eax),%eax
  800719:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80071c:	b8 08 00 00 00       	mov    $0x8,%eax
  800721:	eb 6f                	jmp    800792 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8b 50 04             	mov    0x4(%eax),%edx
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	8d 40 08             	lea    0x8(%eax),%eax
  800737:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80073a:	b8 08 00 00 00       	mov    $0x8,%eax
  80073f:	eb 51                	jmp    800792 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	ba 00 00 00 00       	mov    $0x0,%edx
  80074b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8d 40 04             	lea    0x4(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075a:	b8 08 00 00 00       	mov    $0x8,%eax
  80075f:	eb 31                	jmp    800792 <vprintfmt+0x428>
			putch('0', putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	53                   	push   %ebx
  800765:	6a 30                	push   $0x30
  800767:	ff d6                	call   *%esi
			putch('x', putdat);
  800769:	83 c4 08             	add    $0x8,%esp
  80076c:	53                   	push   %ebx
  80076d:	6a 78                	push   $0x78
  80076f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8b 00                	mov    (%eax),%eax
  800776:	ba 00 00 00 00       	mov    $0x0,%edx
  80077b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800781:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8d 40 04             	lea    0x4(%eax),%eax
  80078a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800792:	83 ec 0c             	sub    $0xc,%esp
  800795:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800799:	52                   	push   %edx
  80079a:	ff 75 e0             	pushl  -0x20(%ebp)
  80079d:	50                   	push   %eax
  80079e:	ff 75 dc             	pushl  -0x24(%ebp)
  8007a1:	ff 75 d8             	pushl  -0x28(%ebp)
  8007a4:	89 da                	mov    %ebx,%edx
  8007a6:	89 f0                	mov    %esi,%eax
  8007a8:	e8 a4 fa ff ff       	call   800251 <printnum>
			break;
  8007ad:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b3:	83 c7 01             	add    $0x1,%edi
  8007b6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007ba:	83 f8 25             	cmp    $0x25,%eax
  8007bd:	0f 84 be fb ff ff    	je     800381 <vprintfmt+0x17>
			if (ch == '\0')
  8007c3:	85 c0                	test   %eax,%eax
  8007c5:	0f 84 28 01 00 00    	je     8008f3 <vprintfmt+0x589>
			putch(ch, putdat);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	53                   	push   %ebx
  8007cf:	50                   	push   %eax
  8007d0:	ff d6                	call   *%esi
  8007d2:	83 c4 10             	add    $0x10,%esp
  8007d5:	eb dc                	jmp    8007b3 <vprintfmt+0x449>
	if (lflag >= 2)
  8007d7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007db:	7f 26                	jg     800803 <vprintfmt+0x499>
	else if (lflag)
  8007dd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007e1:	74 41                	je     800824 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8b 00                	mov    (%eax),%eax
  8007e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8d 40 04             	lea    0x4(%eax),%eax
  8007f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007fc:	b8 10 00 00 00       	mov    $0x10,%eax
  800801:	eb 8f                	jmp    800792 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	8b 50 04             	mov    0x4(%eax),%edx
  800809:	8b 00                	mov    (%eax),%eax
  80080b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	8d 40 08             	lea    0x8(%eax),%eax
  800817:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081a:	b8 10 00 00 00       	mov    $0x10,%eax
  80081f:	e9 6e ff ff ff       	jmp    800792 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8b 00                	mov    (%eax),%eax
  800829:	ba 00 00 00 00       	mov    $0x0,%edx
  80082e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800831:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	8d 40 04             	lea    0x4(%eax),%eax
  80083a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083d:	b8 10 00 00 00       	mov    $0x10,%eax
  800842:	e9 4b ff ff ff       	jmp    800792 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	83 c0 04             	add    $0x4,%eax
  80084d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	85 c0                	test   %eax,%eax
  800857:	74 14                	je     80086d <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800859:	8b 13                	mov    (%ebx),%edx
  80085b:	83 fa 7f             	cmp    $0x7f,%edx
  80085e:	7f 37                	jg     800897 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800860:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800862:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800865:	89 45 14             	mov    %eax,0x14(%ebp)
  800868:	e9 43 ff ff ff       	jmp    8007b0 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80086d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800872:	bf dd 2c 80 00       	mov    $0x802cdd,%edi
							putch(ch, putdat);
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	53                   	push   %ebx
  80087b:	50                   	push   %eax
  80087c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80087e:	83 c7 01             	add    $0x1,%edi
  800881:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	85 c0                	test   %eax,%eax
  80088a:	75 eb                	jne    800877 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80088c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80088f:	89 45 14             	mov    %eax,0x14(%ebp)
  800892:	e9 19 ff ff ff       	jmp    8007b0 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800897:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800899:	b8 0a 00 00 00       	mov    $0xa,%eax
  80089e:	bf 15 2d 80 00       	mov    $0x802d15,%edi
							putch(ch, putdat);
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	53                   	push   %ebx
  8008a7:	50                   	push   %eax
  8008a8:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008aa:	83 c7 01             	add    $0x1,%edi
  8008ad:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
  8008b4:	85 c0                	test   %eax,%eax
  8008b6:	75 eb                	jne    8008a3 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8008be:	e9 ed fe ff ff       	jmp    8007b0 <vprintfmt+0x446>
			putch(ch, putdat);
  8008c3:	83 ec 08             	sub    $0x8,%esp
  8008c6:	53                   	push   %ebx
  8008c7:	6a 25                	push   $0x25
  8008c9:	ff d6                	call   *%esi
			break;
  8008cb:	83 c4 10             	add    $0x10,%esp
  8008ce:	e9 dd fe ff ff       	jmp    8007b0 <vprintfmt+0x446>
			putch('%', putdat);
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	53                   	push   %ebx
  8008d7:	6a 25                	push   $0x25
  8008d9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008db:	83 c4 10             	add    $0x10,%esp
  8008de:	89 f8                	mov    %edi,%eax
  8008e0:	eb 03                	jmp    8008e5 <vprintfmt+0x57b>
  8008e2:	83 e8 01             	sub    $0x1,%eax
  8008e5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008e9:	75 f7                	jne    8008e2 <vprintfmt+0x578>
  8008eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ee:	e9 bd fe ff ff       	jmp    8007b0 <vprintfmt+0x446>
}
  8008f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008f6:	5b                   	pop    %ebx
  8008f7:	5e                   	pop    %esi
  8008f8:	5f                   	pop    %edi
  8008f9:	5d                   	pop    %ebp
  8008fa:	c3                   	ret    

008008fb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	83 ec 18             	sub    $0x18,%esp
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800907:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80090a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80090e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800911:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800918:	85 c0                	test   %eax,%eax
  80091a:	74 26                	je     800942 <vsnprintf+0x47>
  80091c:	85 d2                	test   %edx,%edx
  80091e:	7e 22                	jle    800942 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800920:	ff 75 14             	pushl  0x14(%ebp)
  800923:	ff 75 10             	pushl  0x10(%ebp)
  800926:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800929:	50                   	push   %eax
  80092a:	68 30 03 80 00       	push   $0x800330
  80092f:	e8 36 fa ff ff       	call   80036a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800934:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800937:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80093a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80093d:	83 c4 10             	add    $0x10,%esp
}
  800940:	c9                   	leave  
  800941:	c3                   	ret    
		return -E_INVAL;
  800942:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800947:	eb f7                	jmp    800940 <vsnprintf+0x45>

00800949 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80094f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800952:	50                   	push   %eax
  800953:	ff 75 10             	pushl  0x10(%ebp)
  800956:	ff 75 0c             	pushl  0xc(%ebp)
  800959:	ff 75 08             	pushl  0x8(%ebp)
  80095c:	e8 9a ff ff ff       	call   8008fb <vsnprintf>
	va_end(ap);

	return rc;
}
  800961:	c9                   	leave  
  800962:	c3                   	ret    

00800963 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800969:	b8 00 00 00 00       	mov    $0x0,%eax
  80096e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800972:	74 05                	je     800979 <strlen+0x16>
		n++;
  800974:	83 c0 01             	add    $0x1,%eax
  800977:	eb f5                	jmp    80096e <strlen+0xb>
	return n;
}
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800984:	ba 00 00 00 00       	mov    $0x0,%edx
  800989:	39 c2                	cmp    %eax,%edx
  80098b:	74 0d                	je     80099a <strnlen+0x1f>
  80098d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800991:	74 05                	je     800998 <strnlen+0x1d>
		n++;
  800993:	83 c2 01             	add    $0x1,%edx
  800996:	eb f1                	jmp    800989 <strnlen+0xe>
  800998:	89 d0                	mov    %edx,%eax
	return n;
}
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	53                   	push   %ebx
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ab:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009af:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009b2:	83 c2 01             	add    $0x1,%edx
  8009b5:	84 c9                	test   %cl,%cl
  8009b7:	75 f2                	jne    8009ab <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009b9:	5b                   	pop    %ebx
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	53                   	push   %ebx
  8009c0:	83 ec 10             	sub    $0x10,%esp
  8009c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009c6:	53                   	push   %ebx
  8009c7:	e8 97 ff ff ff       	call   800963 <strlen>
  8009cc:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009cf:	ff 75 0c             	pushl  0xc(%ebp)
  8009d2:	01 d8                	add    %ebx,%eax
  8009d4:	50                   	push   %eax
  8009d5:	e8 c2 ff ff ff       	call   80099c <strcpy>
	return dst;
}
  8009da:	89 d8                	mov    %ebx,%eax
  8009dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009df:	c9                   	leave  
  8009e0:	c3                   	ret    

008009e1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	56                   	push   %esi
  8009e5:	53                   	push   %ebx
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ec:	89 c6                	mov    %eax,%esi
  8009ee:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f1:	89 c2                	mov    %eax,%edx
  8009f3:	39 f2                	cmp    %esi,%edx
  8009f5:	74 11                	je     800a08 <strncpy+0x27>
		*dst++ = *src;
  8009f7:	83 c2 01             	add    $0x1,%edx
  8009fa:	0f b6 19             	movzbl (%ecx),%ebx
  8009fd:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a00:	80 fb 01             	cmp    $0x1,%bl
  800a03:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a06:	eb eb                	jmp    8009f3 <strncpy+0x12>
	}
	return ret;
}
  800a08:	5b                   	pop    %ebx
  800a09:	5e                   	pop    %esi
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	56                   	push   %esi
  800a10:	53                   	push   %ebx
  800a11:	8b 75 08             	mov    0x8(%ebp),%esi
  800a14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a17:	8b 55 10             	mov    0x10(%ebp),%edx
  800a1a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a1c:	85 d2                	test   %edx,%edx
  800a1e:	74 21                	je     800a41 <strlcpy+0x35>
  800a20:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a24:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a26:	39 c2                	cmp    %eax,%edx
  800a28:	74 14                	je     800a3e <strlcpy+0x32>
  800a2a:	0f b6 19             	movzbl (%ecx),%ebx
  800a2d:	84 db                	test   %bl,%bl
  800a2f:	74 0b                	je     800a3c <strlcpy+0x30>
			*dst++ = *src++;
  800a31:	83 c1 01             	add    $0x1,%ecx
  800a34:	83 c2 01             	add    $0x1,%edx
  800a37:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a3a:	eb ea                	jmp    800a26 <strlcpy+0x1a>
  800a3c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a3e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a41:	29 f0                	sub    %esi,%eax
}
  800a43:	5b                   	pop    %ebx
  800a44:	5e                   	pop    %esi
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a50:	0f b6 01             	movzbl (%ecx),%eax
  800a53:	84 c0                	test   %al,%al
  800a55:	74 0c                	je     800a63 <strcmp+0x1c>
  800a57:	3a 02                	cmp    (%edx),%al
  800a59:	75 08                	jne    800a63 <strcmp+0x1c>
		p++, q++;
  800a5b:	83 c1 01             	add    $0x1,%ecx
  800a5e:	83 c2 01             	add    $0x1,%edx
  800a61:	eb ed                	jmp    800a50 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a63:	0f b6 c0             	movzbl %al,%eax
  800a66:	0f b6 12             	movzbl (%edx),%edx
  800a69:	29 d0                	sub    %edx,%eax
}
  800a6b:	5d                   	pop    %ebp
  800a6c:	c3                   	ret    

00800a6d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a6d:	55                   	push   %ebp
  800a6e:	89 e5                	mov    %esp,%ebp
  800a70:	53                   	push   %ebx
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a77:	89 c3                	mov    %eax,%ebx
  800a79:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a7c:	eb 06                	jmp    800a84 <strncmp+0x17>
		n--, p++, q++;
  800a7e:	83 c0 01             	add    $0x1,%eax
  800a81:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a84:	39 d8                	cmp    %ebx,%eax
  800a86:	74 16                	je     800a9e <strncmp+0x31>
  800a88:	0f b6 08             	movzbl (%eax),%ecx
  800a8b:	84 c9                	test   %cl,%cl
  800a8d:	74 04                	je     800a93 <strncmp+0x26>
  800a8f:	3a 0a                	cmp    (%edx),%cl
  800a91:	74 eb                	je     800a7e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a93:	0f b6 00             	movzbl (%eax),%eax
  800a96:	0f b6 12             	movzbl (%edx),%edx
  800a99:	29 d0                	sub    %edx,%eax
}
  800a9b:	5b                   	pop    %ebx
  800a9c:	5d                   	pop    %ebp
  800a9d:	c3                   	ret    
		return 0;
  800a9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa3:	eb f6                	jmp    800a9b <strncmp+0x2e>

00800aa5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aaf:	0f b6 10             	movzbl (%eax),%edx
  800ab2:	84 d2                	test   %dl,%dl
  800ab4:	74 09                	je     800abf <strchr+0x1a>
		if (*s == c)
  800ab6:	38 ca                	cmp    %cl,%dl
  800ab8:	74 0a                	je     800ac4 <strchr+0x1f>
	for (; *s; s++)
  800aba:	83 c0 01             	add    $0x1,%eax
  800abd:	eb f0                	jmp    800aaf <strchr+0xa>
			return (char *) s;
	return 0;
  800abf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ad3:	38 ca                	cmp    %cl,%dl
  800ad5:	74 09                	je     800ae0 <strfind+0x1a>
  800ad7:	84 d2                	test   %dl,%dl
  800ad9:	74 05                	je     800ae0 <strfind+0x1a>
	for (; *s; s++)
  800adb:	83 c0 01             	add    $0x1,%eax
  800ade:	eb f0                	jmp    800ad0 <strfind+0xa>
			break;
	return (char *) s;
}
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	57                   	push   %edi
  800ae6:	56                   	push   %esi
  800ae7:	53                   	push   %ebx
  800ae8:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aeb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aee:	85 c9                	test   %ecx,%ecx
  800af0:	74 31                	je     800b23 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800af2:	89 f8                	mov    %edi,%eax
  800af4:	09 c8                	or     %ecx,%eax
  800af6:	a8 03                	test   $0x3,%al
  800af8:	75 23                	jne    800b1d <memset+0x3b>
		c &= 0xFF;
  800afa:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800afe:	89 d3                	mov    %edx,%ebx
  800b00:	c1 e3 08             	shl    $0x8,%ebx
  800b03:	89 d0                	mov    %edx,%eax
  800b05:	c1 e0 18             	shl    $0x18,%eax
  800b08:	89 d6                	mov    %edx,%esi
  800b0a:	c1 e6 10             	shl    $0x10,%esi
  800b0d:	09 f0                	or     %esi,%eax
  800b0f:	09 c2                	or     %eax,%edx
  800b11:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b13:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b16:	89 d0                	mov    %edx,%eax
  800b18:	fc                   	cld    
  800b19:	f3 ab                	rep stos %eax,%es:(%edi)
  800b1b:	eb 06                	jmp    800b23 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b20:	fc                   	cld    
  800b21:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b23:	89 f8                	mov    %edi,%eax
  800b25:	5b                   	pop    %ebx
  800b26:	5e                   	pop    %esi
  800b27:	5f                   	pop    %edi
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	57                   	push   %edi
  800b2e:	56                   	push   %esi
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b35:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b38:	39 c6                	cmp    %eax,%esi
  800b3a:	73 32                	jae    800b6e <memmove+0x44>
  800b3c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b3f:	39 c2                	cmp    %eax,%edx
  800b41:	76 2b                	jbe    800b6e <memmove+0x44>
		s += n;
		d += n;
  800b43:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b46:	89 fe                	mov    %edi,%esi
  800b48:	09 ce                	or     %ecx,%esi
  800b4a:	09 d6                	or     %edx,%esi
  800b4c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b52:	75 0e                	jne    800b62 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b54:	83 ef 04             	sub    $0x4,%edi
  800b57:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b5a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b5d:	fd                   	std    
  800b5e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b60:	eb 09                	jmp    800b6b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b62:	83 ef 01             	sub    $0x1,%edi
  800b65:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b68:	fd                   	std    
  800b69:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b6b:	fc                   	cld    
  800b6c:	eb 1a                	jmp    800b88 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6e:	89 c2                	mov    %eax,%edx
  800b70:	09 ca                	or     %ecx,%edx
  800b72:	09 f2                	or     %esi,%edx
  800b74:	f6 c2 03             	test   $0x3,%dl
  800b77:	75 0a                	jne    800b83 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b79:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b7c:	89 c7                	mov    %eax,%edi
  800b7e:	fc                   	cld    
  800b7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b81:	eb 05                	jmp    800b88 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b83:	89 c7                	mov    %eax,%edi
  800b85:	fc                   	cld    
  800b86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b88:	5e                   	pop    %esi
  800b89:	5f                   	pop    %edi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b92:	ff 75 10             	pushl  0x10(%ebp)
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	ff 75 08             	pushl  0x8(%ebp)
  800b9b:	e8 8a ff ff ff       	call   800b2a <memmove>
}
  800ba0:	c9                   	leave  
  800ba1:	c3                   	ret    

00800ba2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	56                   	push   %esi
  800ba6:	53                   	push   %ebx
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bad:	89 c6                	mov    %eax,%esi
  800baf:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bb2:	39 f0                	cmp    %esi,%eax
  800bb4:	74 1c                	je     800bd2 <memcmp+0x30>
		if (*s1 != *s2)
  800bb6:	0f b6 08             	movzbl (%eax),%ecx
  800bb9:	0f b6 1a             	movzbl (%edx),%ebx
  800bbc:	38 d9                	cmp    %bl,%cl
  800bbe:	75 08                	jne    800bc8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bc0:	83 c0 01             	add    $0x1,%eax
  800bc3:	83 c2 01             	add    $0x1,%edx
  800bc6:	eb ea                	jmp    800bb2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bc8:	0f b6 c1             	movzbl %cl,%eax
  800bcb:	0f b6 db             	movzbl %bl,%ebx
  800bce:	29 d8                	sub    %ebx,%eax
  800bd0:	eb 05                	jmp    800bd7 <memcmp+0x35>
	}

	return 0;
  800bd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd7:	5b                   	pop    %ebx
  800bd8:	5e                   	pop    %esi
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    

00800bdb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800be4:	89 c2                	mov    %eax,%edx
  800be6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800be9:	39 d0                	cmp    %edx,%eax
  800beb:	73 09                	jae    800bf6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bed:	38 08                	cmp    %cl,(%eax)
  800bef:	74 05                	je     800bf6 <memfind+0x1b>
	for (; s < ends; s++)
  800bf1:	83 c0 01             	add    $0x1,%eax
  800bf4:	eb f3                	jmp    800be9 <memfind+0xe>
			break;
	return (void *) s;
}
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    

00800bf8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	57                   	push   %edi
  800bfc:	56                   	push   %esi
  800bfd:	53                   	push   %ebx
  800bfe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c04:	eb 03                	jmp    800c09 <strtol+0x11>
		s++;
  800c06:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c09:	0f b6 01             	movzbl (%ecx),%eax
  800c0c:	3c 20                	cmp    $0x20,%al
  800c0e:	74 f6                	je     800c06 <strtol+0xe>
  800c10:	3c 09                	cmp    $0x9,%al
  800c12:	74 f2                	je     800c06 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c14:	3c 2b                	cmp    $0x2b,%al
  800c16:	74 2a                	je     800c42 <strtol+0x4a>
	int neg = 0;
  800c18:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c1d:	3c 2d                	cmp    $0x2d,%al
  800c1f:	74 2b                	je     800c4c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c21:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c27:	75 0f                	jne    800c38 <strtol+0x40>
  800c29:	80 39 30             	cmpb   $0x30,(%ecx)
  800c2c:	74 28                	je     800c56 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c2e:	85 db                	test   %ebx,%ebx
  800c30:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c35:	0f 44 d8             	cmove  %eax,%ebx
  800c38:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c40:	eb 50                	jmp    800c92 <strtol+0x9a>
		s++;
  800c42:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c45:	bf 00 00 00 00       	mov    $0x0,%edi
  800c4a:	eb d5                	jmp    800c21 <strtol+0x29>
		s++, neg = 1;
  800c4c:	83 c1 01             	add    $0x1,%ecx
  800c4f:	bf 01 00 00 00       	mov    $0x1,%edi
  800c54:	eb cb                	jmp    800c21 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c56:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c5a:	74 0e                	je     800c6a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c5c:	85 db                	test   %ebx,%ebx
  800c5e:	75 d8                	jne    800c38 <strtol+0x40>
		s++, base = 8;
  800c60:	83 c1 01             	add    $0x1,%ecx
  800c63:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c68:	eb ce                	jmp    800c38 <strtol+0x40>
		s += 2, base = 16;
  800c6a:	83 c1 02             	add    $0x2,%ecx
  800c6d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c72:	eb c4                	jmp    800c38 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c74:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c77:	89 f3                	mov    %esi,%ebx
  800c79:	80 fb 19             	cmp    $0x19,%bl
  800c7c:	77 29                	ja     800ca7 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c7e:	0f be d2             	movsbl %dl,%edx
  800c81:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c84:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c87:	7d 30                	jge    800cb9 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c89:	83 c1 01             	add    $0x1,%ecx
  800c8c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c90:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c92:	0f b6 11             	movzbl (%ecx),%edx
  800c95:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c98:	89 f3                	mov    %esi,%ebx
  800c9a:	80 fb 09             	cmp    $0x9,%bl
  800c9d:	77 d5                	ja     800c74 <strtol+0x7c>
			dig = *s - '0';
  800c9f:	0f be d2             	movsbl %dl,%edx
  800ca2:	83 ea 30             	sub    $0x30,%edx
  800ca5:	eb dd                	jmp    800c84 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ca7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800caa:	89 f3                	mov    %esi,%ebx
  800cac:	80 fb 19             	cmp    $0x19,%bl
  800caf:	77 08                	ja     800cb9 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cb1:	0f be d2             	movsbl %dl,%edx
  800cb4:	83 ea 37             	sub    $0x37,%edx
  800cb7:	eb cb                	jmp    800c84 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cb9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cbd:	74 05                	je     800cc4 <strtol+0xcc>
		*endptr = (char *) s;
  800cbf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cc2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cc4:	89 c2                	mov    %eax,%edx
  800cc6:	f7 da                	neg    %edx
  800cc8:	85 ff                	test   %edi,%edi
  800cca:	0f 45 c2             	cmovne %edx,%eax
}
  800ccd:	5b                   	pop    %ebx
  800cce:	5e                   	pop    %esi
  800ccf:	5f                   	pop    %edi
  800cd0:	5d                   	pop    %ebp
  800cd1:	c3                   	ret    

00800cd2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	57                   	push   %edi
  800cd6:	56                   	push   %esi
  800cd7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce3:	89 c3                	mov    %eax,%ebx
  800ce5:	89 c7                	mov    %eax,%edi
  800ce7:	89 c6                	mov    %eax,%esi
  800ce9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ceb:	5b                   	pop    %ebx
  800cec:	5e                   	pop    %esi
  800ced:	5f                   	pop    %edi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	57                   	push   %edi
  800cf4:	56                   	push   %esi
  800cf5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf6:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfb:	b8 01 00 00 00       	mov    $0x1,%eax
  800d00:	89 d1                	mov    %edx,%ecx
  800d02:	89 d3                	mov    %edx,%ebx
  800d04:	89 d7                	mov    %edx,%edi
  800d06:	89 d6                	mov    %edx,%esi
  800d08:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    

00800d0f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	57                   	push   %edi
  800d13:	56                   	push   %esi
  800d14:	53                   	push   %ebx
  800d15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d18:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d20:	b8 03 00 00 00       	mov    $0x3,%eax
  800d25:	89 cb                	mov    %ecx,%ebx
  800d27:	89 cf                	mov    %ecx,%edi
  800d29:	89 ce                	mov    %ecx,%esi
  800d2b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2d:	85 c0                	test   %eax,%eax
  800d2f:	7f 08                	jg     800d39 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d34:	5b                   	pop    %ebx
  800d35:	5e                   	pop    %esi
  800d36:	5f                   	pop    %edi
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d39:	83 ec 0c             	sub    $0xc,%esp
  800d3c:	50                   	push   %eax
  800d3d:	6a 03                	push   $0x3
  800d3f:	68 28 2f 80 00       	push   $0x802f28
  800d44:	6a 43                	push   $0x43
  800d46:	68 45 2f 80 00       	push   $0x802f45
  800d4b:	e8 6c 1a 00 00       	call   8027bc <_panic>

00800d50 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d56:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5b:	b8 02 00 00 00       	mov    $0x2,%eax
  800d60:	89 d1                	mov    %edx,%ecx
  800d62:	89 d3                	mov    %edx,%ebx
  800d64:	89 d7                	mov    %edx,%edi
  800d66:	89 d6                	mov    %edx,%esi
  800d68:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <sys_yield>:

void
sys_yield(void)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	57                   	push   %edi
  800d73:	56                   	push   %esi
  800d74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d75:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d7f:	89 d1                	mov    %edx,%ecx
  800d81:	89 d3                	mov    %edx,%ebx
  800d83:	89 d7                	mov    %edx,%edi
  800d85:	89 d6                	mov    %edx,%esi
  800d87:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d89:	5b                   	pop    %ebx
  800d8a:	5e                   	pop    %esi
  800d8b:	5f                   	pop    %edi
  800d8c:	5d                   	pop    %ebp
  800d8d:	c3                   	ret    

00800d8e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	57                   	push   %edi
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d97:	be 00 00 00 00       	mov    $0x0,%esi
  800d9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da2:	b8 04 00 00 00       	mov    $0x4,%eax
  800da7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800daa:	89 f7                	mov    %esi,%edi
  800dac:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dae:	85 c0                	test   %eax,%eax
  800db0:	7f 08                	jg     800dba <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db5:	5b                   	pop    %ebx
  800db6:	5e                   	pop    %esi
  800db7:	5f                   	pop    %edi
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dba:	83 ec 0c             	sub    $0xc,%esp
  800dbd:	50                   	push   %eax
  800dbe:	6a 04                	push   $0x4
  800dc0:	68 28 2f 80 00       	push   $0x802f28
  800dc5:	6a 43                	push   $0x43
  800dc7:	68 45 2f 80 00       	push   $0x802f45
  800dcc:	e8 eb 19 00 00       	call   8027bc <_panic>

00800dd1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	57                   	push   %edi
  800dd5:	56                   	push   %esi
  800dd6:	53                   	push   %ebx
  800dd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dda:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de0:	b8 05 00 00 00       	mov    $0x5,%eax
  800de5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800deb:	8b 75 18             	mov    0x18(%ebp),%esi
  800dee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df0:	85 c0                	test   %eax,%eax
  800df2:	7f 08                	jg     800dfc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df7:	5b                   	pop    %ebx
  800df8:	5e                   	pop    %esi
  800df9:	5f                   	pop    %edi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	50                   	push   %eax
  800e00:	6a 05                	push   $0x5
  800e02:	68 28 2f 80 00       	push   $0x802f28
  800e07:	6a 43                	push   $0x43
  800e09:	68 45 2f 80 00       	push   $0x802f45
  800e0e:	e8 a9 19 00 00       	call   8027bc <_panic>

00800e13 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	57                   	push   %edi
  800e17:	56                   	push   %esi
  800e18:	53                   	push   %ebx
  800e19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e21:	8b 55 08             	mov    0x8(%ebp),%edx
  800e24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e27:	b8 06 00 00 00       	mov    $0x6,%eax
  800e2c:	89 df                	mov    %ebx,%edi
  800e2e:	89 de                	mov    %ebx,%esi
  800e30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e32:	85 c0                	test   %eax,%eax
  800e34:	7f 08                	jg     800e3e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e39:	5b                   	pop    %ebx
  800e3a:	5e                   	pop    %esi
  800e3b:	5f                   	pop    %edi
  800e3c:	5d                   	pop    %ebp
  800e3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3e:	83 ec 0c             	sub    $0xc,%esp
  800e41:	50                   	push   %eax
  800e42:	6a 06                	push   $0x6
  800e44:	68 28 2f 80 00       	push   $0x802f28
  800e49:	6a 43                	push   $0x43
  800e4b:	68 45 2f 80 00       	push   $0x802f45
  800e50:	e8 67 19 00 00       	call   8027bc <_panic>

00800e55 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	57                   	push   %edi
  800e59:	56                   	push   %esi
  800e5a:	53                   	push   %ebx
  800e5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e63:	8b 55 08             	mov    0x8(%ebp),%edx
  800e66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e69:	b8 08 00 00 00       	mov    $0x8,%eax
  800e6e:	89 df                	mov    %ebx,%edi
  800e70:	89 de                	mov    %ebx,%esi
  800e72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e74:	85 c0                	test   %eax,%eax
  800e76:	7f 08                	jg     800e80 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7b:	5b                   	pop    %ebx
  800e7c:	5e                   	pop    %esi
  800e7d:	5f                   	pop    %edi
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e80:	83 ec 0c             	sub    $0xc,%esp
  800e83:	50                   	push   %eax
  800e84:	6a 08                	push   $0x8
  800e86:	68 28 2f 80 00       	push   $0x802f28
  800e8b:	6a 43                	push   $0x43
  800e8d:	68 45 2f 80 00       	push   $0x802f45
  800e92:	e8 25 19 00 00       	call   8027bc <_panic>

00800e97 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	57                   	push   %edi
  800e9b:	56                   	push   %esi
  800e9c:	53                   	push   %ebx
  800e9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eab:	b8 09 00 00 00       	mov    $0x9,%eax
  800eb0:	89 df                	mov    %ebx,%edi
  800eb2:	89 de                	mov    %ebx,%esi
  800eb4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb6:	85 c0                	test   %eax,%eax
  800eb8:	7f 08                	jg     800ec2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebd:	5b                   	pop    %ebx
  800ebe:	5e                   	pop    %esi
  800ebf:	5f                   	pop    %edi
  800ec0:	5d                   	pop    %ebp
  800ec1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec2:	83 ec 0c             	sub    $0xc,%esp
  800ec5:	50                   	push   %eax
  800ec6:	6a 09                	push   $0x9
  800ec8:	68 28 2f 80 00       	push   $0x802f28
  800ecd:	6a 43                	push   $0x43
  800ecf:	68 45 2f 80 00       	push   $0x802f45
  800ed4:	e8 e3 18 00 00       	call   8027bc <_panic>

00800ed9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	57                   	push   %edi
  800edd:	56                   	push   %esi
  800ede:	53                   	push   %ebx
  800edf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eed:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ef2:	89 df                	mov    %ebx,%edi
  800ef4:	89 de                	mov    %ebx,%esi
  800ef6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef8:	85 c0                	test   %eax,%eax
  800efa:	7f 08                	jg     800f04 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f04:	83 ec 0c             	sub    $0xc,%esp
  800f07:	50                   	push   %eax
  800f08:	6a 0a                	push   $0xa
  800f0a:	68 28 2f 80 00       	push   $0x802f28
  800f0f:	6a 43                	push   $0x43
  800f11:	68 45 2f 80 00       	push   $0x802f45
  800f16:	e8 a1 18 00 00       	call   8027bc <_panic>

00800f1b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	57                   	push   %edi
  800f1f:	56                   	push   %esi
  800f20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f27:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f2c:	be 00 00 00 00       	mov    $0x0,%esi
  800f31:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f34:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f37:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f39:	5b                   	pop    %ebx
  800f3a:	5e                   	pop    %esi
  800f3b:	5f                   	pop    %edi
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    

00800f3e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	57                   	push   %edi
  800f42:	56                   	push   %esi
  800f43:	53                   	push   %ebx
  800f44:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f47:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f54:	89 cb                	mov    %ecx,%ebx
  800f56:	89 cf                	mov    %ecx,%edi
  800f58:	89 ce                	mov    %ecx,%esi
  800f5a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	7f 08                	jg     800f68 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f63:	5b                   	pop    %ebx
  800f64:	5e                   	pop    %esi
  800f65:	5f                   	pop    %edi
  800f66:	5d                   	pop    %ebp
  800f67:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f68:	83 ec 0c             	sub    $0xc,%esp
  800f6b:	50                   	push   %eax
  800f6c:	6a 0d                	push   $0xd
  800f6e:	68 28 2f 80 00       	push   $0x802f28
  800f73:	6a 43                	push   $0x43
  800f75:	68 45 2f 80 00       	push   $0x802f45
  800f7a:	e8 3d 18 00 00       	call   8027bc <_panic>

00800f7f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	57                   	push   %edi
  800f83:	56                   	push   %esi
  800f84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f90:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f95:	89 df                	mov    %ebx,%edi
  800f97:	89 de                	mov    %ebx,%esi
  800f99:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f9b:	5b                   	pop    %ebx
  800f9c:	5e                   	pop    %esi
  800f9d:	5f                   	pop    %edi
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    

00800fa0 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	57                   	push   %edi
  800fa4:	56                   	push   %esi
  800fa5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fab:	8b 55 08             	mov    0x8(%ebp),%edx
  800fae:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fb3:	89 cb                	mov    %ecx,%ebx
  800fb5:	89 cf                	mov    %ecx,%edi
  800fb7:	89 ce                	mov    %ecx,%esi
  800fb9:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fbb:	5b                   	pop    %ebx
  800fbc:	5e                   	pop    %esi
  800fbd:	5f                   	pop    %edi
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	57                   	push   %edi
  800fc4:	56                   	push   %esi
  800fc5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800fcb:	b8 10 00 00 00       	mov    $0x10,%eax
  800fd0:	89 d1                	mov    %edx,%ecx
  800fd2:	89 d3                	mov    %edx,%ebx
  800fd4:	89 d7                	mov    %edx,%edi
  800fd6:	89 d6                	mov    %edx,%esi
  800fd8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fda:	5b                   	pop    %ebx
  800fdb:	5e                   	pop    %esi
  800fdc:	5f                   	pop    %edi
  800fdd:	5d                   	pop    %ebp
  800fde:	c3                   	ret    

00800fdf <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	57                   	push   %edi
  800fe3:	56                   	push   %esi
  800fe4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fea:	8b 55 08             	mov    0x8(%ebp),%edx
  800fed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff0:	b8 11 00 00 00       	mov    $0x11,%eax
  800ff5:	89 df                	mov    %ebx,%edi
  800ff7:	89 de                	mov    %ebx,%esi
  800ff9:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800ffb:	5b                   	pop    %ebx
  800ffc:	5e                   	pop    %esi
  800ffd:	5f                   	pop    %edi
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    

00801000 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	57                   	push   %edi
  801004:	56                   	push   %esi
  801005:	53                   	push   %ebx
	asm volatile("int %1\n"
  801006:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100b:	8b 55 08             	mov    0x8(%ebp),%edx
  80100e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801011:	b8 12 00 00 00       	mov    $0x12,%eax
  801016:	89 df                	mov    %ebx,%edi
  801018:	89 de                	mov    %ebx,%esi
  80101a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80101c:	5b                   	pop    %ebx
  80101d:	5e                   	pop    %esi
  80101e:	5f                   	pop    %edi
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    

00801021 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	57                   	push   %edi
  801025:	56                   	push   %esi
  801026:	53                   	push   %ebx
  801027:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80102a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102f:	8b 55 08             	mov    0x8(%ebp),%edx
  801032:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801035:	b8 13 00 00 00       	mov    $0x13,%eax
  80103a:	89 df                	mov    %ebx,%edi
  80103c:	89 de                	mov    %ebx,%esi
  80103e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801040:	85 c0                	test   %eax,%eax
  801042:	7f 08                	jg     80104c <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801044:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801047:	5b                   	pop    %ebx
  801048:	5e                   	pop    %esi
  801049:	5f                   	pop    %edi
  80104a:	5d                   	pop    %ebp
  80104b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80104c:	83 ec 0c             	sub    $0xc,%esp
  80104f:	50                   	push   %eax
  801050:	6a 13                	push   $0x13
  801052:	68 28 2f 80 00       	push   $0x802f28
  801057:	6a 43                	push   $0x43
  801059:	68 45 2f 80 00       	push   $0x802f45
  80105e:	e8 59 17 00 00       	call   8027bc <_panic>

00801063 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	57                   	push   %edi
  801067:	56                   	push   %esi
  801068:	53                   	push   %ebx
	asm volatile("int %1\n"
  801069:	b9 00 00 00 00       	mov    $0x0,%ecx
  80106e:	8b 55 08             	mov    0x8(%ebp),%edx
  801071:	b8 14 00 00 00       	mov    $0x14,%eax
  801076:	89 cb                	mov    %ecx,%ebx
  801078:	89 cf                	mov    %ecx,%edi
  80107a:	89 ce                	mov    %ecx,%esi
  80107c:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80107e:	5b                   	pop    %ebx
  80107f:	5e                   	pop    %esi
  801080:	5f                   	pop    %edi
  801081:	5d                   	pop    %ebp
  801082:	c3                   	ret    

00801083 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	53                   	push   %ebx
  801087:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  80108a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801091:	f6 c5 04             	test   $0x4,%ch
  801094:	75 45                	jne    8010db <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801096:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80109d:	83 e1 07             	and    $0x7,%ecx
  8010a0:	83 f9 07             	cmp    $0x7,%ecx
  8010a3:	74 6f                	je     801114 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8010a5:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010ac:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8010b2:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8010b8:	0f 84 b6 00 00 00    	je     801174 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8010be:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010c5:	83 e1 05             	and    $0x5,%ecx
  8010c8:	83 f9 05             	cmp    $0x5,%ecx
  8010cb:	0f 84 d7 00 00 00    	je     8011a8 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8010d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8010db:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010e2:	c1 e2 0c             	shl    $0xc,%edx
  8010e5:	83 ec 0c             	sub    $0xc,%esp
  8010e8:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8010ee:	51                   	push   %ecx
  8010ef:	52                   	push   %edx
  8010f0:	50                   	push   %eax
  8010f1:	52                   	push   %edx
  8010f2:	6a 00                	push   $0x0
  8010f4:	e8 d8 fc ff ff       	call   800dd1 <sys_page_map>
		if(r < 0)
  8010f9:	83 c4 20             	add    $0x20,%esp
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	79 d1                	jns    8010d1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801100:	83 ec 04             	sub    $0x4,%esp
  801103:	68 53 2f 80 00       	push   $0x802f53
  801108:	6a 54                	push   $0x54
  80110a:	68 69 2f 80 00       	push   $0x802f69
  80110f:	e8 a8 16 00 00       	call   8027bc <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801114:	89 d3                	mov    %edx,%ebx
  801116:	c1 e3 0c             	shl    $0xc,%ebx
  801119:	83 ec 0c             	sub    $0xc,%esp
  80111c:	68 05 08 00 00       	push   $0x805
  801121:	53                   	push   %ebx
  801122:	50                   	push   %eax
  801123:	53                   	push   %ebx
  801124:	6a 00                	push   $0x0
  801126:	e8 a6 fc ff ff       	call   800dd1 <sys_page_map>
		if(r < 0)
  80112b:	83 c4 20             	add    $0x20,%esp
  80112e:	85 c0                	test   %eax,%eax
  801130:	78 2e                	js     801160 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801132:	83 ec 0c             	sub    $0xc,%esp
  801135:	68 05 08 00 00       	push   $0x805
  80113a:	53                   	push   %ebx
  80113b:	6a 00                	push   $0x0
  80113d:	53                   	push   %ebx
  80113e:	6a 00                	push   $0x0
  801140:	e8 8c fc ff ff       	call   800dd1 <sys_page_map>
		if(r < 0)
  801145:	83 c4 20             	add    $0x20,%esp
  801148:	85 c0                	test   %eax,%eax
  80114a:	79 85                	jns    8010d1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80114c:	83 ec 04             	sub    $0x4,%esp
  80114f:	68 53 2f 80 00       	push   $0x802f53
  801154:	6a 5f                	push   $0x5f
  801156:	68 69 2f 80 00       	push   $0x802f69
  80115b:	e8 5c 16 00 00       	call   8027bc <_panic>
			panic("sys_page_map() panic\n");
  801160:	83 ec 04             	sub    $0x4,%esp
  801163:	68 53 2f 80 00       	push   $0x802f53
  801168:	6a 5b                	push   $0x5b
  80116a:	68 69 2f 80 00       	push   $0x802f69
  80116f:	e8 48 16 00 00       	call   8027bc <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801174:	c1 e2 0c             	shl    $0xc,%edx
  801177:	83 ec 0c             	sub    $0xc,%esp
  80117a:	68 05 08 00 00       	push   $0x805
  80117f:	52                   	push   %edx
  801180:	50                   	push   %eax
  801181:	52                   	push   %edx
  801182:	6a 00                	push   $0x0
  801184:	e8 48 fc ff ff       	call   800dd1 <sys_page_map>
		if(r < 0)
  801189:	83 c4 20             	add    $0x20,%esp
  80118c:	85 c0                	test   %eax,%eax
  80118e:	0f 89 3d ff ff ff    	jns    8010d1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801194:	83 ec 04             	sub    $0x4,%esp
  801197:	68 53 2f 80 00       	push   $0x802f53
  80119c:	6a 66                	push   $0x66
  80119e:	68 69 2f 80 00       	push   $0x802f69
  8011a3:	e8 14 16 00 00       	call   8027bc <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011a8:	c1 e2 0c             	shl    $0xc,%edx
  8011ab:	83 ec 0c             	sub    $0xc,%esp
  8011ae:	6a 05                	push   $0x5
  8011b0:	52                   	push   %edx
  8011b1:	50                   	push   %eax
  8011b2:	52                   	push   %edx
  8011b3:	6a 00                	push   $0x0
  8011b5:	e8 17 fc ff ff       	call   800dd1 <sys_page_map>
		if(r < 0)
  8011ba:	83 c4 20             	add    $0x20,%esp
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	0f 89 0c ff ff ff    	jns    8010d1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011c5:	83 ec 04             	sub    $0x4,%esp
  8011c8:	68 53 2f 80 00       	push   $0x802f53
  8011cd:	6a 6d                	push   $0x6d
  8011cf:	68 69 2f 80 00       	push   $0x802f69
  8011d4:	e8 e3 15 00 00       	call   8027bc <_panic>

008011d9 <pgfault>:
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	53                   	push   %ebx
  8011dd:	83 ec 04             	sub    $0x4,%esp
  8011e0:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8011e3:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011e5:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8011e9:	0f 84 99 00 00 00    	je     801288 <pgfault+0xaf>
  8011ef:	89 c2                	mov    %eax,%edx
  8011f1:	c1 ea 16             	shr    $0x16,%edx
  8011f4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011fb:	f6 c2 01             	test   $0x1,%dl
  8011fe:	0f 84 84 00 00 00    	je     801288 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801204:	89 c2                	mov    %eax,%edx
  801206:	c1 ea 0c             	shr    $0xc,%edx
  801209:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801210:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801216:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  80121c:	75 6a                	jne    801288 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  80121e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801223:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801225:	83 ec 04             	sub    $0x4,%esp
  801228:	6a 07                	push   $0x7
  80122a:	68 00 f0 7f 00       	push   $0x7ff000
  80122f:	6a 00                	push   $0x0
  801231:	e8 58 fb ff ff       	call   800d8e <sys_page_alloc>
	if(ret < 0)
  801236:	83 c4 10             	add    $0x10,%esp
  801239:	85 c0                	test   %eax,%eax
  80123b:	78 5f                	js     80129c <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80123d:	83 ec 04             	sub    $0x4,%esp
  801240:	68 00 10 00 00       	push   $0x1000
  801245:	53                   	push   %ebx
  801246:	68 00 f0 7f 00       	push   $0x7ff000
  80124b:	e8 3c f9 ff ff       	call   800b8c <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801250:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801257:	53                   	push   %ebx
  801258:	6a 00                	push   $0x0
  80125a:	68 00 f0 7f 00       	push   $0x7ff000
  80125f:	6a 00                	push   $0x0
  801261:	e8 6b fb ff ff       	call   800dd1 <sys_page_map>
	if(ret < 0)
  801266:	83 c4 20             	add    $0x20,%esp
  801269:	85 c0                	test   %eax,%eax
  80126b:	78 43                	js     8012b0 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  80126d:	83 ec 08             	sub    $0x8,%esp
  801270:	68 00 f0 7f 00       	push   $0x7ff000
  801275:	6a 00                	push   $0x0
  801277:	e8 97 fb ff ff       	call   800e13 <sys_page_unmap>
	if(ret < 0)
  80127c:	83 c4 10             	add    $0x10,%esp
  80127f:	85 c0                	test   %eax,%eax
  801281:	78 41                	js     8012c4 <pgfault+0xeb>
}
  801283:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801286:	c9                   	leave  
  801287:	c3                   	ret    
		panic("panic at pgfault()\n");
  801288:	83 ec 04             	sub    $0x4,%esp
  80128b:	68 74 2f 80 00       	push   $0x802f74
  801290:	6a 26                	push   $0x26
  801292:	68 69 2f 80 00       	push   $0x802f69
  801297:	e8 20 15 00 00       	call   8027bc <_panic>
		panic("panic in sys_page_alloc()\n");
  80129c:	83 ec 04             	sub    $0x4,%esp
  80129f:	68 88 2f 80 00       	push   $0x802f88
  8012a4:	6a 31                	push   $0x31
  8012a6:	68 69 2f 80 00       	push   $0x802f69
  8012ab:	e8 0c 15 00 00       	call   8027bc <_panic>
		panic("panic in sys_page_map()\n");
  8012b0:	83 ec 04             	sub    $0x4,%esp
  8012b3:	68 a3 2f 80 00       	push   $0x802fa3
  8012b8:	6a 36                	push   $0x36
  8012ba:	68 69 2f 80 00       	push   $0x802f69
  8012bf:	e8 f8 14 00 00       	call   8027bc <_panic>
		panic("panic in sys_page_unmap()\n");
  8012c4:	83 ec 04             	sub    $0x4,%esp
  8012c7:	68 bc 2f 80 00       	push   $0x802fbc
  8012cc:	6a 39                	push   $0x39
  8012ce:	68 69 2f 80 00       	push   $0x802f69
  8012d3:	e8 e4 14 00 00       	call   8027bc <_panic>

008012d8 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	57                   	push   %edi
  8012dc:	56                   	push   %esi
  8012dd:	53                   	push   %ebx
  8012de:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8012e1:	68 d9 11 80 00       	push   $0x8011d9
  8012e6:	e8 32 15 00 00       	call   80281d <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8012eb:	b8 07 00 00 00       	mov    $0x7,%eax
  8012f0:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	78 27                	js     801320 <fork+0x48>
  8012f9:	89 c6                	mov    %eax,%esi
  8012fb:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012fd:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801302:	75 48                	jne    80134c <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801304:	e8 47 fa ff ff       	call   800d50 <sys_getenvid>
  801309:	25 ff 03 00 00       	and    $0x3ff,%eax
  80130e:	c1 e0 07             	shl    $0x7,%eax
  801311:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801316:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  80131b:	e9 90 00 00 00       	jmp    8013b0 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801320:	83 ec 04             	sub    $0x4,%esp
  801323:	68 d8 2f 80 00       	push   $0x802fd8
  801328:	68 8c 00 00 00       	push   $0x8c
  80132d:	68 69 2f 80 00       	push   $0x802f69
  801332:	e8 85 14 00 00       	call   8027bc <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801337:	89 f8                	mov    %edi,%eax
  801339:	e8 45 fd ff ff       	call   801083 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80133e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801344:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80134a:	74 26                	je     801372 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  80134c:	89 d8                	mov    %ebx,%eax
  80134e:	c1 e8 16             	shr    $0x16,%eax
  801351:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801358:	a8 01                	test   $0x1,%al
  80135a:	74 e2                	je     80133e <fork+0x66>
  80135c:	89 da                	mov    %ebx,%edx
  80135e:	c1 ea 0c             	shr    $0xc,%edx
  801361:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801368:	83 e0 05             	and    $0x5,%eax
  80136b:	83 f8 05             	cmp    $0x5,%eax
  80136e:	75 ce                	jne    80133e <fork+0x66>
  801370:	eb c5                	jmp    801337 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801372:	83 ec 04             	sub    $0x4,%esp
  801375:	6a 07                	push   $0x7
  801377:	68 00 f0 bf ee       	push   $0xeebff000
  80137c:	56                   	push   %esi
  80137d:	e8 0c fa ff ff       	call   800d8e <sys_page_alloc>
	if(ret < 0)
  801382:	83 c4 10             	add    $0x10,%esp
  801385:	85 c0                	test   %eax,%eax
  801387:	78 31                	js     8013ba <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801389:	83 ec 08             	sub    $0x8,%esp
  80138c:	68 8c 28 80 00       	push   $0x80288c
  801391:	56                   	push   %esi
  801392:	e8 42 fb ff ff       	call   800ed9 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	85 c0                	test   %eax,%eax
  80139c:	78 33                	js     8013d1 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80139e:	83 ec 08             	sub    $0x8,%esp
  8013a1:	6a 02                	push   $0x2
  8013a3:	56                   	push   %esi
  8013a4:	e8 ac fa ff ff       	call   800e55 <sys_env_set_status>
	if(ret < 0)
  8013a9:	83 c4 10             	add    $0x10,%esp
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	78 38                	js     8013e8 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013b0:	89 f0                	mov    %esi,%eax
  8013b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b5:	5b                   	pop    %ebx
  8013b6:	5e                   	pop    %esi
  8013b7:	5f                   	pop    %edi
  8013b8:	5d                   	pop    %ebp
  8013b9:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013ba:	83 ec 04             	sub    $0x4,%esp
  8013bd:	68 88 2f 80 00       	push   $0x802f88
  8013c2:	68 98 00 00 00       	push   $0x98
  8013c7:	68 69 2f 80 00       	push   $0x802f69
  8013cc:	e8 eb 13 00 00       	call   8027bc <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8013d1:	83 ec 04             	sub    $0x4,%esp
  8013d4:	68 fc 2f 80 00       	push   $0x802ffc
  8013d9:	68 9b 00 00 00       	push   $0x9b
  8013de:	68 69 2f 80 00       	push   $0x802f69
  8013e3:	e8 d4 13 00 00       	call   8027bc <_panic>
		panic("panic in sys_env_set_status()\n");
  8013e8:	83 ec 04             	sub    $0x4,%esp
  8013eb:	68 24 30 80 00       	push   $0x803024
  8013f0:	68 9e 00 00 00       	push   $0x9e
  8013f5:	68 69 2f 80 00       	push   $0x802f69
  8013fa:	e8 bd 13 00 00       	call   8027bc <_panic>

008013ff <sfork>:

// Challenge!
int
sfork(void)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	57                   	push   %edi
  801403:	56                   	push   %esi
  801404:	53                   	push   %ebx
  801405:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801408:	68 d9 11 80 00       	push   $0x8011d9
  80140d:	e8 0b 14 00 00       	call   80281d <set_pgfault_handler>
  801412:	b8 07 00 00 00       	mov    $0x7,%eax
  801417:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801419:	83 c4 10             	add    $0x10,%esp
  80141c:	85 c0                	test   %eax,%eax
  80141e:	78 27                	js     801447 <sfork+0x48>
  801420:	89 c7                	mov    %eax,%edi
  801422:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801424:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801429:	75 55                	jne    801480 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  80142b:	e8 20 f9 ff ff       	call   800d50 <sys_getenvid>
  801430:	25 ff 03 00 00       	and    $0x3ff,%eax
  801435:	c1 e0 07             	shl    $0x7,%eax
  801438:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80143d:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  801442:	e9 d4 00 00 00       	jmp    80151b <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801447:	83 ec 04             	sub    $0x4,%esp
  80144a:	68 d8 2f 80 00       	push   $0x802fd8
  80144f:	68 af 00 00 00       	push   $0xaf
  801454:	68 69 2f 80 00       	push   $0x802f69
  801459:	e8 5e 13 00 00       	call   8027bc <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80145e:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801463:	89 f0                	mov    %esi,%eax
  801465:	e8 19 fc ff ff       	call   801083 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80146a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801470:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801476:	77 65                	ja     8014dd <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801478:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80147e:	74 de                	je     80145e <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801480:	89 d8                	mov    %ebx,%eax
  801482:	c1 e8 16             	shr    $0x16,%eax
  801485:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80148c:	a8 01                	test   $0x1,%al
  80148e:	74 da                	je     80146a <sfork+0x6b>
  801490:	89 da                	mov    %ebx,%edx
  801492:	c1 ea 0c             	shr    $0xc,%edx
  801495:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80149c:	83 e0 05             	and    $0x5,%eax
  80149f:	83 f8 05             	cmp    $0x5,%eax
  8014a2:	75 c6                	jne    80146a <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014a4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014ab:	c1 e2 0c             	shl    $0xc,%edx
  8014ae:	83 ec 0c             	sub    $0xc,%esp
  8014b1:	83 e0 07             	and    $0x7,%eax
  8014b4:	50                   	push   %eax
  8014b5:	52                   	push   %edx
  8014b6:	56                   	push   %esi
  8014b7:	52                   	push   %edx
  8014b8:	6a 00                	push   $0x0
  8014ba:	e8 12 f9 ff ff       	call   800dd1 <sys_page_map>
  8014bf:	83 c4 20             	add    $0x20,%esp
  8014c2:	85 c0                	test   %eax,%eax
  8014c4:	74 a4                	je     80146a <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	68 53 2f 80 00       	push   $0x802f53
  8014ce:	68 ba 00 00 00       	push   $0xba
  8014d3:	68 69 2f 80 00       	push   $0x802f69
  8014d8:	e8 df 12 00 00       	call   8027bc <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014dd:	83 ec 04             	sub    $0x4,%esp
  8014e0:	6a 07                	push   $0x7
  8014e2:	68 00 f0 bf ee       	push   $0xeebff000
  8014e7:	57                   	push   %edi
  8014e8:	e8 a1 f8 ff ff       	call   800d8e <sys_page_alloc>
	if(ret < 0)
  8014ed:	83 c4 10             	add    $0x10,%esp
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	78 31                	js     801525 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014f4:	83 ec 08             	sub    $0x8,%esp
  8014f7:	68 8c 28 80 00       	push   $0x80288c
  8014fc:	57                   	push   %edi
  8014fd:	e8 d7 f9 ff ff       	call   800ed9 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801502:	83 c4 10             	add    $0x10,%esp
  801505:	85 c0                	test   %eax,%eax
  801507:	78 33                	js     80153c <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801509:	83 ec 08             	sub    $0x8,%esp
  80150c:	6a 02                	push   $0x2
  80150e:	57                   	push   %edi
  80150f:	e8 41 f9 ff ff       	call   800e55 <sys_env_set_status>
	if(ret < 0)
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	85 c0                	test   %eax,%eax
  801519:	78 38                	js     801553 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80151b:	89 f8                	mov    %edi,%eax
  80151d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801520:	5b                   	pop    %ebx
  801521:	5e                   	pop    %esi
  801522:	5f                   	pop    %edi
  801523:	5d                   	pop    %ebp
  801524:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801525:	83 ec 04             	sub    $0x4,%esp
  801528:	68 88 2f 80 00       	push   $0x802f88
  80152d:	68 c0 00 00 00       	push   $0xc0
  801532:	68 69 2f 80 00       	push   $0x802f69
  801537:	e8 80 12 00 00       	call   8027bc <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80153c:	83 ec 04             	sub    $0x4,%esp
  80153f:	68 fc 2f 80 00       	push   $0x802ffc
  801544:	68 c3 00 00 00       	push   $0xc3
  801549:	68 69 2f 80 00       	push   $0x802f69
  80154e:	e8 69 12 00 00       	call   8027bc <_panic>
		panic("panic in sys_env_set_status()\n");
  801553:	83 ec 04             	sub    $0x4,%esp
  801556:	68 24 30 80 00       	push   $0x803024
  80155b:	68 c6 00 00 00       	push   $0xc6
  801560:	68 69 2f 80 00       	push   $0x802f69
  801565:	e8 52 12 00 00       	call   8027bc <_panic>

0080156a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	56                   	push   %esi
  80156e:	53                   	push   %ebx
  80156f:	8b 75 08             	mov    0x8(%ebp),%esi
  801572:	8b 45 0c             	mov    0xc(%ebp),%eax
  801575:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801578:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80157a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80157f:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801582:	83 ec 0c             	sub    $0xc,%esp
  801585:	50                   	push   %eax
  801586:	e8 b3 f9 ff ff       	call   800f3e <sys_ipc_recv>
	if(ret < 0){
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	85 c0                	test   %eax,%eax
  801590:	78 2b                	js     8015bd <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801592:	85 f6                	test   %esi,%esi
  801594:	74 0a                	je     8015a0 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801596:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80159b:	8b 40 74             	mov    0x74(%eax),%eax
  80159e:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8015a0:	85 db                	test   %ebx,%ebx
  8015a2:	74 0a                	je     8015ae <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8015a4:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8015a9:	8b 40 78             	mov    0x78(%eax),%eax
  8015ac:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8015ae:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8015b3:	8b 40 70             	mov    0x70(%eax),%eax
}
  8015b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b9:	5b                   	pop    %ebx
  8015ba:	5e                   	pop    %esi
  8015bb:	5d                   	pop    %ebp
  8015bc:	c3                   	ret    
		if(from_env_store)
  8015bd:	85 f6                	test   %esi,%esi
  8015bf:	74 06                	je     8015c7 <ipc_recv+0x5d>
			*from_env_store = 0;
  8015c1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8015c7:	85 db                	test   %ebx,%ebx
  8015c9:	74 eb                	je     8015b6 <ipc_recv+0x4c>
			*perm_store = 0;
  8015cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8015d1:	eb e3                	jmp    8015b6 <ipc_recv+0x4c>

008015d3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	57                   	push   %edi
  8015d7:	56                   	push   %esi
  8015d8:	53                   	push   %ebx
  8015d9:	83 ec 0c             	sub    $0xc,%esp
  8015dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015df:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8015e5:	85 db                	test   %ebx,%ebx
  8015e7:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8015ec:	0f 44 d8             	cmove  %eax,%ebx
  8015ef:	eb 05                	jmp    8015f6 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8015f1:	e8 79 f7 ff ff       	call   800d6f <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8015f6:	ff 75 14             	pushl  0x14(%ebp)
  8015f9:	53                   	push   %ebx
  8015fa:	56                   	push   %esi
  8015fb:	57                   	push   %edi
  8015fc:	e8 1a f9 ff ff       	call   800f1b <sys_ipc_try_send>
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	85 c0                	test   %eax,%eax
  801606:	74 1b                	je     801623 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801608:	79 e7                	jns    8015f1 <ipc_send+0x1e>
  80160a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80160d:	74 e2                	je     8015f1 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80160f:	83 ec 04             	sub    $0x4,%esp
  801612:	68 43 30 80 00       	push   $0x803043
  801617:	6a 46                	push   $0x46
  801619:	68 58 30 80 00       	push   $0x803058
  80161e:	e8 99 11 00 00       	call   8027bc <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801623:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801626:	5b                   	pop    %ebx
  801627:	5e                   	pop    %esi
  801628:	5f                   	pop    %edi
  801629:	5d                   	pop    %ebp
  80162a:	c3                   	ret    

0080162b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801631:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801636:	89 c2                	mov    %eax,%edx
  801638:	c1 e2 07             	shl    $0x7,%edx
  80163b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801641:	8b 52 50             	mov    0x50(%edx),%edx
  801644:	39 ca                	cmp    %ecx,%edx
  801646:	74 11                	je     801659 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801648:	83 c0 01             	add    $0x1,%eax
  80164b:	3d 00 04 00 00       	cmp    $0x400,%eax
  801650:	75 e4                	jne    801636 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801652:	b8 00 00 00 00       	mov    $0x0,%eax
  801657:	eb 0b                	jmp    801664 <ipc_find_env+0x39>
			return envs[i].env_id;
  801659:	c1 e0 07             	shl    $0x7,%eax
  80165c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801661:	8b 40 48             	mov    0x48(%eax),%eax
}
  801664:	5d                   	pop    %ebp
  801665:	c3                   	ret    

00801666 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	05 00 00 00 30       	add    $0x30000000,%eax
  801671:	c1 e8 0c             	shr    $0xc,%eax
}
  801674:	5d                   	pop    %ebp
  801675:	c3                   	ret    

00801676 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801681:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801686:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80168b:	5d                   	pop    %ebp
  80168c:	c3                   	ret    

0080168d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801695:	89 c2                	mov    %eax,%edx
  801697:	c1 ea 16             	shr    $0x16,%edx
  80169a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016a1:	f6 c2 01             	test   $0x1,%dl
  8016a4:	74 2d                	je     8016d3 <fd_alloc+0x46>
  8016a6:	89 c2                	mov    %eax,%edx
  8016a8:	c1 ea 0c             	shr    $0xc,%edx
  8016ab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016b2:	f6 c2 01             	test   $0x1,%dl
  8016b5:	74 1c                	je     8016d3 <fd_alloc+0x46>
  8016b7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016bc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016c1:	75 d2                	jne    801695 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8016cc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8016d1:	eb 0a                	jmp    8016dd <fd_alloc+0x50>
			*fd_store = fd;
  8016d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016d6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016dd:	5d                   	pop    %ebp
  8016de:	c3                   	ret    

008016df <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016e5:	83 f8 1f             	cmp    $0x1f,%eax
  8016e8:	77 30                	ja     80171a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016ea:	c1 e0 0c             	shl    $0xc,%eax
  8016ed:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016f2:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8016f8:	f6 c2 01             	test   $0x1,%dl
  8016fb:	74 24                	je     801721 <fd_lookup+0x42>
  8016fd:	89 c2                	mov    %eax,%edx
  8016ff:	c1 ea 0c             	shr    $0xc,%edx
  801702:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801709:	f6 c2 01             	test   $0x1,%dl
  80170c:	74 1a                	je     801728 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80170e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801711:	89 02                	mov    %eax,(%edx)
	return 0;
  801713:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801718:	5d                   	pop    %ebp
  801719:	c3                   	ret    
		return -E_INVAL;
  80171a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80171f:	eb f7                	jmp    801718 <fd_lookup+0x39>
		return -E_INVAL;
  801721:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801726:	eb f0                	jmp    801718 <fd_lookup+0x39>
  801728:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80172d:	eb e9                	jmp    801718 <fd_lookup+0x39>

0080172f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 08             	sub    $0x8,%esp
  801735:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801738:	ba 00 00 00 00       	mov    $0x0,%edx
  80173d:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801742:	39 08                	cmp    %ecx,(%eax)
  801744:	74 38                	je     80177e <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801746:	83 c2 01             	add    $0x1,%edx
  801749:	8b 04 95 e0 30 80 00 	mov    0x8030e0(,%edx,4),%eax
  801750:	85 c0                	test   %eax,%eax
  801752:	75 ee                	jne    801742 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801754:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801759:	8b 40 48             	mov    0x48(%eax),%eax
  80175c:	83 ec 04             	sub    $0x4,%esp
  80175f:	51                   	push   %ecx
  801760:	50                   	push   %eax
  801761:	68 64 30 80 00       	push   $0x803064
  801766:	e8 d2 ea ff ff       	call   80023d <cprintf>
	*dev = 0;
  80176b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    
			*dev = devtab[i];
  80177e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801781:	89 01                	mov    %eax,(%ecx)
			return 0;
  801783:	b8 00 00 00 00       	mov    $0x0,%eax
  801788:	eb f2                	jmp    80177c <dev_lookup+0x4d>

0080178a <fd_close>:
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	57                   	push   %edi
  80178e:	56                   	push   %esi
  80178f:	53                   	push   %ebx
  801790:	83 ec 24             	sub    $0x24,%esp
  801793:	8b 75 08             	mov    0x8(%ebp),%esi
  801796:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801799:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80179c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80179d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017a3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017a6:	50                   	push   %eax
  8017a7:	e8 33 ff ff ff       	call   8016df <fd_lookup>
  8017ac:	89 c3                	mov    %eax,%ebx
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	78 05                	js     8017ba <fd_close+0x30>
	    || fd != fd2)
  8017b5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017b8:	74 16                	je     8017d0 <fd_close+0x46>
		return (must_exist ? r : 0);
  8017ba:	89 f8                	mov    %edi,%eax
  8017bc:	84 c0                	test   %al,%al
  8017be:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c3:	0f 44 d8             	cmove  %eax,%ebx
}
  8017c6:	89 d8                	mov    %ebx,%eax
  8017c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017cb:	5b                   	pop    %ebx
  8017cc:	5e                   	pop    %esi
  8017cd:	5f                   	pop    %edi
  8017ce:	5d                   	pop    %ebp
  8017cf:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017d0:	83 ec 08             	sub    $0x8,%esp
  8017d3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017d6:	50                   	push   %eax
  8017d7:	ff 36                	pushl  (%esi)
  8017d9:	e8 51 ff ff ff       	call   80172f <dev_lookup>
  8017de:	89 c3                	mov    %eax,%ebx
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	78 1a                	js     801801 <fd_close+0x77>
		if (dev->dev_close)
  8017e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017ea:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8017ed:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017f2:	85 c0                	test   %eax,%eax
  8017f4:	74 0b                	je     801801 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8017f6:	83 ec 0c             	sub    $0xc,%esp
  8017f9:	56                   	push   %esi
  8017fa:	ff d0                	call   *%eax
  8017fc:	89 c3                	mov    %eax,%ebx
  8017fe:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801801:	83 ec 08             	sub    $0x8,%esp
  801804:	56                   	push   %esi
  801805:	6a 00                	push   $0x0
  801807:	e8 07 f6 ff ff       	call   800e13 <sys_page_unmap>
	return r;
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	eb b5                	jmp    8017c6 <fd_close+0x3c>

00801811 <close>:

int
close(int fdnum)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801817:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80181a:	50                   	push   %eax
  80181b:	ff 75 08             	pushl  0x8(%ebp)
  80181e:	e8 bc fe ff ff       	call   8016df <fd_lookup>
  801823:	83 c4 10             	add    $0x10,%esp
  801826:	85 c0                	test   %eax,%eax
  801828:	79 02                	jns    80182c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    
		return fd_close(fd, 1);
  80182c:	83 ec 08             	sub    $0x8,%esp
  80182f:	6a 01                	push   $0x1
  801831:	ff 75 f4             	pushl  -0xc(%ebp)
  801834:	e8 51 ff ff ff       	call   80178a <fd_close>
  801839:	83 c4 10             	add    $0x10,%esp
  80183c:	eb ec                	jmp    80182a <close+0x19>

0080183e <close_all>:

void
close_all(void)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	53                   	push   %ebx
  801842:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801845:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80184a:	83 ec 0c             	sub    $0xc,%esp
  80184d:	53                   	push   %ebx
  80184e:	e8 be ff ff ff       	call   801811 <close>
	for (i = 0; i < MAXFD; i++)
  801853:	83 c3 01             	add    $0x1,%ebx
  801856:	83 c4 10             	add    $0x10,%esp
  801859:	83 fb 20             	cmp    $0x20,%ebx
  80185c:	75 ec                	jne    80184a <close_all+0xc>
}
  80185e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	57                   	push   %edi
  801867:	56                   	push   %esi
  801868:	53                   	push   %ebx
  801869:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80186c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80186f:	50                   	push   %eax
  801870:	ff 75 08             	pushl  0x8(%ebp)
  801873:	e8 67 fe ff ff       	call   8016df <fd_lookup>
  801878:	89 c3                	mov    %eax,%ebx
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	85 c0                	test   %eax,%eax
  80187f:	0f 88 81 00 00 00    	js     801906 <dup+0xa3>
		return r;
	close(newfdnum);
  801885:	83 ec 0c             	sub    $0xc,%esp
  801888:	ff 75 0c             	pushl  0xc(%ebp)
  80188b:	e8 81 ff ff ff       	call   801811 <close>

	newfd = INDEX2FD(newfdnum);
  801890:	8b 75 0c             	mov    0xc(%ebp),%esi
  801893:	c1 e6 0c             	shl    $0xc,%esi
  801896:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80189c:	83 c4 04             	add    $0x4,%esp
  80189f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018a2:	e8 cf fd ff ff       	call   801676 <fd2data>
  8018a7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018a9:	89 34 24             	mov    %esi,(%esp)
  8018ac:	e8 c5 fd ff ff       	call   801676 <fd2data>
  8018b1:	83 c4 10             	add    $0x10,%esp
  8018b4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018b6:	89 d8                	mov    %ebx,%eax
  8018b8:	c1 e8 16             	shr    $0x16,%eax
  8018bb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018c2:	a8 01                	test   $0x1,%al
  8018c4:	74 11                	je     8018d7 <dup+0x74>
  8018c6:	89 d8                	mov    %ebx,%eax
  8018c8:	c1 e8 0c             	shr    $0xc,%eax
  8018cb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018d2:	f6 c2 01             	test   $0x1,%dl
  8018d5:	75 39                	jne    801910 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018da:	89 d0                	mov    %edx,%eax
  8018dc:	c1 e8 0c             	shr    $0xc,%eax
  8018df:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018e6:	83 ec 0c             	sub    $0xc,%esp
  8018e9:	25 07 0e 00 00       	and    $0xe07,%eax
  8018ee:	50                   	push   %eax
  8018ef:	56                   	push   %esi
  8018f0:	6a 00                	push   $0x0
  8018f2:	52                   	push   %edx
  8018f3:	6a 00                	push   $0x0
  8018f5:	e8 d7 f4 ff ff       	call   800dd1 <sys_page_map>
  8018fa:	89 c3                	mov    %eax,%ebx
  8018fc:	83 c4 20             	add    $0x20,%esp
  8018ff:	85 c0                	test   %eax,%eax
  801901:	78 31                	js     801934 <dup+0xd1>
		goto err;

	return newfdnum;
  801903:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801906:	89 d8                	mov    %ebx,%eax
  801908:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80190b:	5b                   	pop    %ebx
  80190c:	5e                   	pop    %esi
  80190d:	5f                   	pop    %edi
  80190e:	5d                   	pop    %ebp
  80190f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801910:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801917:	83 ec 0c             	sub    $0xc,%esp
  80191a:	25 07 0e 00 00       	and    $0xe07,%eax
  80191f:	50                   	push   %eax
  801920:	57                   	push   %edi
  801921:	6a 00                	push   $0x0
  801923:	53                   	push   %ebx
  801924:	6a 00                	push   $0x0
  801926:	e8 a6 f4 ff ff       	call   800dd1 <sys_page_map>
  80192b:	89 c3                	mov    %eax,%ebx
  80192d:	83 c4 20             	add    $0x20,%esp
  801930:	85 c0                	test   %eax,%eax
  801932:	79 a3                	jns    8018d7 <dup+0x74>
	sys_page_unmap(0, newfd);
  801934:	83 ec 08             	sub    $0x8,%esp
  801937:	56                   	push   %esi
  801938:	6a 00                	push   $0x0
  80193a:	e8 d4 f4 ff ff       	call   800e13 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80193f:	83 c4 08             	add    $0x8,%esp
  801942:	57                   	push   %edi
  801943:	6a 00                	push   $0x0
  801945:	e8 c9 f4 ff ff       	call   800e13 <sys_page_unmap>
	return r;
  80194a:	83 c4 10             	add    $0x10,%esp
  80194d:	eb b7                	jmp    801906 <dup+0xa3>

0080194f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	53                   	push   %ebx
  801953:	83 ec 1c             	sub    $0x1c,%esp
  801956:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801959:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80195c:	50                   	push   %eax
  80195d:	53                   	push   %ebx
  80195e:	e8 7c fd ff ff       	call   8016df <fd_lookup>
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	85 c0                	test   %eax,%eax
  801968:	78 3f                	js     8019a9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80196a:	83 ec 08             	sub    $0x8,%esp
  80196d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801970:	50                   	push   %eax
  801971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801974:	ff 30                	pushl  (%eax)
  801976:	e8 b4 fd ff ff       	call   80172f <dev_lookup>
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	85 c0                	test   %eax,%eax
  801980:	78 27                	js     8019a9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801982:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801985:	8b 42 08             	mov    0x8(%edx),%eax
  801988:	83 e0 03             	and    $0x3,%eax
  80198b:	83 f8 01             	cmp    $0x1,%eax
  80198e:	74 1e                	je     8019ae <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801993:	8b 40 08             	mov    0x8(%eax),%eax
  801996:	85 c0                	test   %eax,%eax
  801998:	74 35                	je     8019cf <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80199a:	83 ec 04             	sub    $0x4,%esp
  80199d:	ff 75 10             	pushl  0x10(%ebp)
  8019a0:	ff 75 0c             	pushl  0xc(%ebp)
  8019a3:	52                   	push   %edx
  8019a4:	ff d0                	call   *%eax
  8019a6:	83 c4 10             	add    $0x10,%esp
}
  8019a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019ae:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8019b3:	8b 40 48             	mov    0x48(%eax),%eax
  8019b6:	83 ec 04             	sub    $0x4,%esp
  8019b9:	53                   	push   %ebx
  8019ba:	50                   	push   %eax
  8019bb:	68 a5 30 80 00       	push   $0x8030a5
  8019c0:	e8 78 e8 ff ff       	call   80023d <cprintf>
		return -E_INVAL;
  8019c5:	83 c4 10             	add    $0x10,%esp
  8019c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019cd:	eb da                	jmp    8019a9 <read+0x5a>
		return -E_NOT_SUPP;
  8019cf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019d4:	eb d3                	jmp    8019a9 <read+0x5a>

008019d6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	57                   	push   %edi
  8019da:	56                   	push   %esi
  8019db:	53                   	push   %ebx
  8019dc:	83 ec 0c             	sub    $0xc,%esp
  8019df:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019e2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019ea:	39 f3                	cmp    %esi,%ebx
  8019ec:	73 23                	jae    801a11 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019ee:	83 ec 04             	sub    $0x4,%esp
  8019f1:	89 f0                	mov    %esi,%eax
  8019f3:	29 d8                	sub    %ebx,%eax
  8019f5:	50                   	push   %eax
  8019f6:	89 d8                	mov    %ebx,%eax
  8019f8:	03 45 0c             	add    0xc(%ebp),%eax
  8019fb:	50                   	push   %eax
  8019fc:	57                   	push   %edi
  8019fd:	e8 4d ff ff ff       	call   80194f <read>
		if (m < 0)
  801a02:	83 c4 10             	add    $0x10,%esp
  801a05:	85 c0                	test   %eax,%eax
  801a07:	78 06                	js     801a0f <readn+0x39>
			return m;
		if (m == 0)
  801a09:	74 06                	je     801a11 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a0b:	01 c3                	add    %eax,%ebx
  801a0d:	eb db                	jmp    8019ea <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a0f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a11:	89 d8                	mov    %ebx,%eax
  801a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a16:	5b                   	pop    %ebx
  801a17:	5e                   	pop    %esi
  801a18:	5f                   	pop    %edi
  801a19:	5d                   	pop    %ebp
  801a1a:	c3                   	ret    

00801a1b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	53                   	push   %ebx
  801a1f:	83 ec 1c             	sub    $0x1c,%esp
  801a22:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a25:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a28:	50                   	push   %eax
  801a29:	53                   	push   %ebx
  801a2a:	e8 b0 fc ff ff       	call   8016df <fd_lookup>
  801a2f:	83 c4 10             	add    $0x10,%esp
  801a32:	85 c0                	test   %eax,%eax
  801a34:	78 3a                	js     801a70 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a36:	83 ec 08             	sub    $0x8,%esp
  801a39:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a3c:	50                   	push   %eax
  801a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a40:	ff 30                	pushl  (%eax)
  801a42:	e8 e8 fc ff ff       	call   80172f <dev_lookup>
  801a47:	83 c4 10             	add    $0x10,%esp
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	78 22                	js     801a70 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a51:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a55:	74 1e                	je     801a75 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a5a:	8b 52 0c             	mov    0xc(%edx),%edx
  801a5d:	85 d2                	test   %edx,%edx
  801a5f:	74 35                	je     801a96 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a61:	83 ec 04             	sub    $0x4,%esp
  801a64:	ff 75 10             	pushl  0x10(%ebp)
  801a67:	ff 75 0c             	pushl  0xc(%ebp)
  801a6a:	50                   	push   %eax
  801a6b:	ff d2                	call   *%edx
  801a6d:	83 c4 10             	add    $0x10,%esp
}
  801a70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a75:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801a7a:	8b 40 48             	mov    0x48(%eax),%eax
  801a7d:	83 ec 04             	sub    $0x4,%esp
  801a80:	53                   	push   %ebx
  801a81:	50                   	push   %eax
  801a82:	68 c1 30 80 00       	push   $0x8030c1
  801a87:	e8 b1 e7 ff ff       	call   80023d <cprintf>
		return -E_INVAL;
  801a8c:	83 c4 10             	add    $0x10,%esp
  801a8f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a94:	eb da                	jmp    801a70 <write+0x55>
		return -E_NOT_SUPP;
  801a96:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a9b:	eb d3                	jmp    801a70 <write+0x55>

00801a9d <seek>:

int
seek(int fdnum, off_t offset)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aa3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa6:	50                   	push   %eax
  801aa7:	ff 75 08             	pushl  0x8(%ebp)
  801aaa:	e8 30 fc ff ff       	call   8016df <fd_lookup>
  801aaf:	83 c4 10             	add    $0x10,%esp
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	78 0e                	js     801ac4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abc:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801abf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	53                   	push   %ebx
  801aca:	83 ec 1c             	sub    $0x1c,%esp
  801acd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ad0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ad3:	50                   	push   %eax
  801ad4:	53                   	push   %ebx
  801ad5:	e8 05 fc ff ff       	call   8016df <fd_lookup>
  801ada:	83 c4 10             	add    $0x10,%esp
  801add:	85 c0                	test   %eax,%eax
  801adf:	78 37                	js     801b18 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ae1:	83 ec 08             	sub    $0x8,%esp
  801ae4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae7:	50                   	push   %eax
  801ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aeb:	ff 30                	pushl  (%eax)
  801aed:	e8 3d fc ff ff       	call   80172f <dev_lookup>
  801af2:	83 c4 10             	add    $0x10,%esp
  801af5:	85 c0                	test   %eax,%eax
  801af7:	78 1f                	js     801b18 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b00:	74 1b                	je     801b1d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b05:	8b 52 18             	mov    0x18(%edx),%edx
  801b08:	85 d2                	test   %edx,%edx
  801b0a:	74 32                	je     801b3e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b0c:	83 ec 08             	sub    $0x8,%esp
  801b0f:	ff 75 0c             	pushl  0xc(%ebp)
  801b12:	50                   	push   %eax
  801b13:	ff d2                	call   *%edx
  801b15:	83 c4 10             	add    $0x10,%esp
}
  801b18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b1d:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b22:	8b 40 48             	mov    0x48(%eax),%eax
  801b25:	83 ec 04             	sub    $0x4,%esp
  801b28:	53                   	push   %ebx
  801b29:	50                   	push   %eax
  801b2a:	68 84 30 80 00       	push   $0x803084
  801b2f:	e8 09 e7 ff ff       	call   80023d <cprintf>
		return -E_INVAL;
  801b34:	83 c4 10             	add    $0x10,%esp
  801b37:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b3c:	eb da                	jmp    801b18 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b3e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b43:	eb d3                	jmp    801b18 <ftruncate+0x52>

00801b45 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	53                   	push   %ebx
  801b49:	83 ec 1c             	sub    $0x1c,%esp
  801b4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b4f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b52:	50                   	push   %eax
  801b53:	ff 75 08             	pushl  0x8(%ebp)
  801b56:	e8 84 fb ff ff       	call   8016df <fd_lookup>
  801b5b:	83 c4 10             	add    $0x10,%esp
  801b5e:	85 c0                	test   %eax,%eax
  801b60:	78 4b                	js     801bad <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b62:	83 ec 08             	sub    $0x8,%esp
  801b65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b68:	50                   	push   %eax
  801b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6c:	ff 30                	pushl  (%eax)
  801b6e:	e8 bc fb ff ff       	call   80172f <dev_lookup>
  801b73:	83 c4 10             	add    $0x10,%esp
  801b76:	85 c0                	test   %eax,%eax
  801b78:	78 33                	js     801bad <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b81:	74 2f                	je     801bb2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b83:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b86:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b8d:	00 00 00 
	stat->st_isdir = 0;
  801b90:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b97:	00 00 00 
	stat->st_dev = dev;
  801b9a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ba0:	83 ec 08             	sub    $0x8,%esp
  801ba3:	53                   	push   %ebx
  801ba4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ba7:	ff 50 14             	call   *0x14(%eax)
  801baa:	83 c4 10             	add    $0x10,%esp
}
  801bad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    
		return -E_NOT_SUPP;
  801bb2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bb7:	eb f4                	jmp    801bad <fstat+0x68>

00801bb9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	56                   	push   %esi
  801bbd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bbe:	83 ec 08             	sub    $0x8,%esp
  801bc1:	6a 00                	push   $0x0
  801bc3:	ff 75 08             	pushl  0x8(%ebp)
  801bc6:	e8 22 02 00 00       	call   801ded <open>
  801bcb:	89 c3                	mov    %eax,%ebx
  801bcd:	83 c4 10             	add    $0x10,%esp
  801bd0:	85 c0                	test   %eax,%eax
  801bd2:	78 1b                	js     801bef <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801bd4:	83 ec 08             	sub    $0x8,%esp
  801bd7:	ff 75 0c             	pushl  0xc(%ebp)
  801bda:	50                   	push   %eax
  801bdb:	e8 65 ff ff ff       	call   801b45 <fstat>
  801be0:	89 c6                	mov    %eax,%esi
	close(fd);
  801be2:	89 1c 24             	mov    %ebx,(%esp)
  801be5:	e8 27 fc ff ff       	call   801811 <close>
	return r;
  801bea:	83 c4 10             	add    $0x10,%esp
  801bed:	89 f3                	mov    %esi,%ebx
}
  801bef:	89 d8                	mov    %ebx,%eax
  801bf1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf4:	5b                   	pop    %ebx
  801bf5:	5e                   	pop    %esi
  801bf6:	5d                   	pop    %ebp
  801bf7:	c3                   	ret    

00801bf8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	56                   	push   %esi
  801bfc:	53                   	push   %ebx
  801bfd:	89 c6                	mov    %eax,%esi
  801bff:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c01:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c08:	74 27                	je     801c31 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c0a:	6a 07                	push   $0x7
  801c0c:	68 00 60 80 00       	push   $0x806000
  801c11:	56                   	push   %esi
  801c12:	ff 35 00 50 80 00    	pushl  0x805000
  801c18:	e8 b6 f9 ff ff       	call   8015d3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c1d:	83 c4 0c             	add    $0xc,%esp
  801c20:	6a 00                	push   $0x0
  801c22:	53                   	push   %ebx
  801c23:	6a 00                	push   $0x0
  801c25:	e8 40 f9 ff ff       	call   80156a <ipc_recv>
}
  801c2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c2d:	5b                   	pop    %ebx
  801c2e:	5e                   	pop    %esi
  801c2f:	5d                   	pop    %ebp
  801c30:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c31:	83 ec 0c             	sub    $0xc,%esp
  801c34:	6a 01                	push   $0x1
  801c36:	e8 f0 f9 ff ff       	call   80162b <ipc_find_env>
  801c3b:	a3 00 50 80 00       	mov    %eax,0x805000
  801c40:	83 c4 10             	add    $0x10,%esp
  801c43:	eb c5                	jmp    801c0a <fsipc+0x12>

00801c45 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801c51:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c59:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c63:	b8 02 00 00 00       	mov    $0x2,%eax
  801c68:	e8 8b ff ff ff       	call   801bf8 <fsipc>
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <devfile_flush>:
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	8b 40 0c             	mov    0xc(%eax),%eax
  801c7b:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c80:	ba 00 00 00 00       	mov    $0x0,%edx
  801c85:	b8 06 00 00 00       	mov    $0x6,%eax
  801c8a:	e8 69 ff ff ff       	call   801bf8 <fsipc>
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <devfile_stat>:
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	53                   	push   %ebx
  801c95:	83 ec 04             	sub    $0x4,%esp
  801c98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca1:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ca6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cab:	b8 05 00 00 00       	mov    $0x5,%eax
  801cb0:	e8 43 ff ff ff       	call   801bf8 <fsipc>
  801cb5:	85 c0                	test   %eax,%eax
  801cb7:	78 2c                	js     801ce5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cb9:	83 ec 08             	sub    $0x8,%esp
  801cbc:	68 00 60 80 00       	push   $0x806000
  801cc1:	53                   	push   %ebx
  801cc2:	e8 d5 ec ff ff       	call   80099c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cc7:	a1 80 60 80 00       	mov    0x806080,%eax
  801ccc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cd2:	a1 84 60 80 00       	mov    0x806084,%eax
  801cd7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <devfile_write>:
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	53                   	push   %ebx
  801cee:	83 ec 08             	sub    $0x8,%esp
  801cf1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	8b 40 0c             	mov    0xc(%eax),%eax
  801cfa:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801cff:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d05:	53                   	push   %ebx
  801d06:	ff 75 0c             	pushl  0xc(%ebp)
  801d09:	68 08 60 80 00       	push   $0x806008
  801d0e:	e8 79 ee ff ff       	call   800b8c <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d13:	ba 00 00 00 00       	mov    $0x0,%edx
  801d18:	b8 04 00 00 00       	mov    $0x4,%eax
  801d1d:	e8 d6 fe ff ff       	call   801bf8 <fsipc>
  801d22:	83 c4 10             	add    $0x10,%esp
  801d25:	85 c0                	test   %eax,%eax
  801d27:	78 0b                	js     801d34 <devfile_write+0x4a>
	assert(r <= n);
  801d29:	39 d8                	cmp    %ebx,%eax
  801d2b:	77 0c                	ja     801d39 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d2d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d32:	7f 1e                	jg     801d52 <devfile_write+0x68>
}
  801d34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    
	assert(r <= n);
  801d39:	68 f4 30 80 00       	push   $0x8030f4
  801d3e:	68 fb 30 80 00       	push   $0x8030fb
  801d43:	68 98 00 00 00       	push   $0x98
  801d48:	68 10 31 80 00       	push   $0x803110
  801d4d:	e8 6a 0a 00 00       	call   8027bc <_panic>
	assert(r <= PGSIZE);
  801d52:	68 1b 31 80 00       	push   $0x80311b
  801d57:	68 fb 30 80 00       	push   $0x8030fb
  801d5c:	68 99 00 00 00       	push   $0x99
  801d61:	68 10 31 80 00       	push   $0x803110
  801d66:	e8 51 0a 00 00       	call   8027bc <_panic>

00801d6b <devfile_read>:
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	56                   	push   %esi
  801d6f:	53                   	push   %ebx
  801d70:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d73:	8b 45 08             	mov    0x8(%ebp),%eax
  801d76:	8b 40 0c             	mov    0xc(%eax),%eax
  801d79:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d7e:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d84:	ba 00 00 00 00       	mov    $0x0,%edx
  801d89:	b8 03 00 00 00       	mov    $0x3,%eax
  801d8e:	e8 65 fe ff ff       	call   801bf8 <fsipc>
  801d93:	89 c3                	mov    %eax,%ebx
  801d95:	85 c0                	test   %eax,%eax
  801d97:	78 1f                	js     801db8 <devfile_read+0x4d>
	assert(r <= n);
  801d99:	39 f0                	cmp    %esi,%eax
  801d9b:	77 24                	ja     801dc1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d9d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801da2:	7f 33                	jg     801dd7 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801da4:	83 ec 04             	sub    $0x4,%esp
  801da7:	50                   	push   %eax
  801da8:	68 00 60 80 00       	push   $0x806000
  801dad:	ff 75 0c             	pushl  0xc(%ebp)
  801db0:	e8 75 ed ff ff       	call   800b2a <memmove>
	return r;
  801db5:	83 c4 10             	add    $0x10,%esp
}
  801db8:	89 d8                	mov    %ebx,%eax
  801dba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dbd:	5b                   	pop    %ebx
  801dbe:	5e                   	pop    %esi
  801dbf:	5d                   	pop    %ebp
  801dc0:	c3                   	ret    
	assert(r <= n);
  801dc1:	68 f4 30 80 00       	push   $0x8030f4
  801dc6:	68 fb 30 80 00       	push   $0x8030fb
  801dcb:	6a 7c                	push   $0x7c
  801dcd:	68 10 31 80 00       	push   $0x803110
  801dd2:	e8 e5 09 00 00       	call   8027bc <_panic>
	assert(r <= PGSIZE);
  801dd7:	68 1b 31 80 00       	push   $0x80311b
  801ddc:	68 fb 30 80 00       	push   $0x8030fb
  801de1:	6a 7d                	push   $0x7d
  801de3:	68 10 31 80 00       	push   $0x803110
  801de8:	e8 cf 09 00 00       	call   8027bc <_panic>

00801ded <open>:
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	56                   	push   %esi
  801df1:	53                   	push   %ebx
  801df2:	83 ec 1c             	sub    $0x1c,%esp
  801df5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801df8:	56                   	push   %esi
  801df9:	e8 65 eb ff ff       	call   800963 <strlen>
  801dfe:	83 c4 10             	add    $0x10,%esp
  801e01:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e06:	7f 6c                	jg     801e74 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e08:	83 ec 0c             	sub    $0xc,%esp
  801e0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e0e:	50                   	push   %eax
  801e0f:	e8 79 f8 ff ff       	call   80168d <fd_alloc>
  801e14:	89 c3                	mov    %eax,%ebx
  801e16:	83 c4 10             	add    $0x10,%esp
  801e19:	85 c0                	test   %eax,%eax
  801e1b:	78 3c                	js     801e59 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e1d:	83 ec 08             	sub    $0x8,%esp
  801e20:	56                   	push   %esi
  801e21:	68 00 60 80 00       	push   $0x806000
  801e26:	e8 71 eb ff ff       	call   80099c <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2e:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e36:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3b:	e8 b8 fd ff ff       	call   801bf8 <fsipc>
  801e40:	89 c3                	mov    %eax,%ebx
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	85 c0                	test   %eax,%eax
  801e47:	78 19                	js     801e62 <open+0x75>
	return fd2num(fd);
  801e49:	83 ec 0c             	sub    $0xc,%esp
  801e4c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4f:	e8 12 f8 ff ff       	call   801666 <fd2num>
  801e54:	89 c3                	mov    %eax,%ebx
  801e56:	83 c4 10             	add    $0x10,%esp
}
  801e59:	89 d8                	mov    %ebx,%eax
  801e5b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e5e:	5b                   	pop    %ebx
  801e5f:	5e                   	pop    %esi
  801e60:	5d                   	pop    %ebp
  801e61:	c3                   	ret    
		fd_close(fd, 0);
  801e62:	83 ec 08             	sub    $0x8,%esp
  801e65:	6a 00                	push   $0x0
  801e67:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6a:	e8 1b f9 ff ff       	call   80178a <fd_close>
		return r;
  801e6f:	83 c4 10             	add    $0x10,%esp
  801e72:	eb e5                	jmp    801e59 <open+0x6c>
		return -E_BAD_PATH;
  801e74:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e79:	eb de                	jmp    801e59 <open+0x6c>

00801e7b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e81:	ba 00 00 00 00       	mov    $0x0,%edx
  801e86:	b8 08 00 00 00       	mov    $0x8,%eax
  801e8b:	e8 68 fd ff ff       	call   801bf8 <fsipc>
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e98:	68 27 31 80 00       	push   $0x803127
  801e9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ea0:	e8 f7 ea ff ff       	call   80099c <strcpy>
	return 0;
}
  801ea5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <devsock_close>:
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	53                   	push   %ebx
  801eb0:	83 ec 10             	sub    $0x10,%esp
  801eb3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801eb6:	53                   	push   %ebx
  801eb7:	e8 f6 09 00 00       	call   8028b2 <pageref>
  801ebc:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ebf:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ec4:	83 f8 01             	cmp    $0x1,%eax
  801ec7:	74 07                	je     801ed0 <devsock_close+0x24>
}
  801ec9:	89 d0                	mov    %edx,%eax
  801ecb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ed0:	83 ec 0c             	sub    $0xc,%esp
  801ed3:	ff 73 0c             	pushl  0xc(%ebx)
  801ed6:	e8 b9 02 00 00       	call   802194 <nsipc_close>
  801edb:	89 c2                	mov    %eax,%edx
  801edd:	83 c4 10             	add    $0x10,%esp
  801ee0:	eb e7                	jmp    801ec9 <devsock_close+0x1d>

00801ee2 <devsock_write>:
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ee8:	6a 00                	push   $0x0
  801eea:	ff 75 10             	pushl  0x10(%ebp)
  801eed:	ff 75 0c             	pushl  0xc(%ebp)
  801ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef3:	ff 70 0c             	pushl  0xc(%eax)
  801ef6:	e8 76 03 00 00       	call   802271 <nsipc_send>
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <devsock_read>:
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f03:	6a 00                	push   $0x0
  801f05:	ff 75 10             	pushl  0x10(%ebp)
  801f08:	ff 75 0c             	pushl  0xc(%ebp)
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	ff 70 0c             	pushl  0xc(%eax)
  801f11:	e8 ef 02 00 00       	call   802205 <nsipc_recv>
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <fd2sockid>:
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f1e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f21:	52                   	push   %edx
  801f22:	50                   	push   %eax
  801f23:	e8 b7 f7 ff ff       	call   8016df <fd_lookup>
  801f28:	83 c4 10             	add    $0x10,%esp
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	78 10                	js     801f3f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f32:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f38:	39 08                	cmp    %ecx,(%eax)
  801f3a:	75 05                	jne    801f41 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f3c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    
		return -E_NOT_SUPP;
  801f41:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f46:	eb f7                	jmp    801f3f <fd2sockid+0x27>

00801f48 <alloc_sockfd>:
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	56                   	push   %esi
  801f4c:	53                   	push   %ebx
  801f4d:	83 ec 1c             	sub    $0x1c,%esp
  801f50:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f52:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f55:	50                   	push   %eax
  801f56:	e8 32 f7 ff ff       	call   80168d <fd_alloc>
  801f5b:	89 c3                	mov    %eax,%ebx
  801f5d:	83 c4 10             	add    $0x10,%esp
  801f60:	85 c0                	test   %eax,%eax
  801f62:	78 43                	js     801fa7 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f64:	83 ec 04             	sub    $0x4,%esp
  801f67:	68 07 04 00 00       	push   $0x407
  801f6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f6f:	6a 00                	push   $0x0
  801f71:	e8 18 ee ff ff       	call   800d8e <sys_page_alloc>
  801f76:	89 c3                	mov    %eax,%ebx
  801f78:	83 c4 10             	add    $0x10,%esp
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	78 28                	js     801fa7 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f82:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f88:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f94:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f97:	83 ec 0c             	sub    $0xc,%esp
  801f9a:	50                   	push   %eax
  801f9b:	e8 c6 f6 ff ff       	call   801666 <fd2num>
  801fa0:	89 c3                	mov    %eax,%ebx
  801fa2:	83 c4 10             	add    $0x10,%esp
  801fa5:	eb 0c                	jmp    801fb3 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fa7:	83 ec 0c             	sub    $0xc,%esp
  801faa:	56                   	push   %esi
  801fab:	e8 e4 01 00 00       	call   802194 <nsipc_close>
		return r;
  801fb0:	83 c4 10             	add    $0x10,%esp
}
  801fb3:	89 d8                	mov    %ebx,%eax
  801fb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb8:	5b                   	pop    %ebx
  801fb9:	5e                   	pop    %esi
  801fba:	5d                   	pop    %ebp
  801fbb:	c3                   	ret    

00801fbc <accept>:
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	e8 4e ff ff ff       	call   801f18 <fd2sockid>
  801fca:	85 c0                	test   %eax,%eax
  801fcc:	78 1b                	js     801fe9 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fce:	83 ec 04             	sub    $0x4,%esp
  801fd1:	ff 75 10             	pushl  0x10(%ebp)
  801fd4:	ff 75 0c             	pushl  0xc(%ebp)
  801fd7:	50                   	push   %eax
  801fd8:	e8 0e 01 00 00       	call   8020eb <nsipc_accept>
  801fdd:	83 c4 10             	add    $0x10,%esp
  801fe0:	85 c0                	test   %eax,%eax
  801fe2:	78 05                	js     801fe9 <accept+0x2d>
	return alloc_sockfd(r);
  801fe4:	e8 5f ff ff ff       	call   801f48 <alloc_sockfd>
}
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <bind>:
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	e8 1f ff ff ff       	call   801f18 <fd2sockid>
  801ff9:	85 c0                	test   %eax,%eax
  801ffb:	78 12                	js     80200f <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ffd:	83 ec 04             	sub    $0x4,%esp
  802000:	ff 75 10             	pushl  0x10(%ebp)
  802003:	ff 75 0c             	pushl  0xc(%ebp)
  802006:	50                   	push   %eax
  802007:	e8 31 01 00 00       	call   80213d <nsipc_bind>
  80200c:	83 c4 10             	add    $0x10,%esp
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <shutdown>:
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	e8 f9 fe ff ff       	call   801f18 <fd2sockid>
  80201f:	85 c0                	test   %eax,%eax
  802021:	78 0f                	js     802032 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802023:	83 ec 08             	sub    $0x8,%esp
  802026:	ff 75 0c             	pushl  0xc(%ebp)
  802029:	50                   	push   %eax
  80202a:	e8 43 01 00 00       	call   802172 <nsipc_shutdown>
  80202f:	83 c4 10             	add    $0x10,%esp
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <connect>:
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	e8 d6 fe ff ff       	call   801f18 <fd2sockid>
  802042:	85 c0                	test   %eax,%eax
  802044:	78 12                	js     802058 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802046:	83 ec 04             	sub    $0x4,%esp
  802049:	ff 75 10             	pushl  0x10(%ebp)
  80204c:	ff 75 0c             	pushl  0xc(%ebp)
  80204f:	50                   	push   %eax
  802050:	e8 59 01 00 00       	call   8021ae <nsipc_connect>
  802055:	83 c4 10             	add    $0x10,%esp
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <listen>:
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	e8 b0 fe ff ff       	call   801f18 <fd2sockid>
  802068:	85 c0                	test   %eax,%eax
  80206a:	78 0f                	js     80207b <listen+0x21>
	return nsipc_listen(r, backlog);
  80206c:	83 ec 08             	sub    $0x8,%esp
  80206f:	ff 75 0c             	pushl  0xc(%ebp)
  802072:	50                   	push   %eax
  802073:	e8 6b 01 00 00       	call   8021e3 <nsipc_listen>
  802078:	83 c4 10             	add    $0x10,%esp
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <socket>:

int
socket(int domain, int type, int protocol)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802083:	ff 75 10             	pushl  0x10(%ebp)
  802086:	ff 75 0c             	pushl  0xc(%ebp)
  802089:	ff 75 08             	pushl  0x8(%ebp)
  80208c:	e8 3e 02 00 00       	call   8022cf <nsipc_socket>
  802091:	83 c4 10             	add    $0x10,%esp
  802094:	85 c0                	test   %eax,%eax
  802096:	78 05                	js     80209d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802098:	e8 ab fe ff ff       	call   801f48 <alloc_sockfd>
}
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	53                   	push   %ebx
  8020a3:	83 ec 04             	sub    $0x4,%esp
  8020a6:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020a8:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020af:	74 26                	je     8020d7 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020b1:	6a 07                	push   $0x7
  8020b3:	68 00 70 80 00       	push   $0x807000
  8020b8:	53                   	push   %ebx
  8020b9:	ff 35 04 50 80 00    	pushl  0x805004
  8020bf:	e8 0f f5 ff ff       	call   8015d3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020c4:	83 c4 0c             	add    $0xc,%esp
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	e8 98 f4 ff ff       	call   80156a <ipc_recv>
}
  8020d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020d7:	83 ec 0c             	sub    $0xc,%esp
  8020da:	6a 02                	push   $0x2
  8020dc:	e8 4a f5 ff ff       	call   80162b <ipc_find_env>
  8020e1:	a3 04 50 80 00       	mov    %eax,0x805004
  8020e6:	83 c4 10             	add    $0x10,%esp
  8020e9:	eb c6                	jmp    8020b1 <nsipc+0x12>

008020eb <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	56                   	push   %esi
  8020ef:	53                   	push   %ebx
  8020f0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020fb:	8b 06                	mov    (%esi),%eax
  8020fd:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802102:	b8 01 00 00 00       	mov    $0x1,%eax
  802107:	e8 93 ff ff ff       	call   80209f <nsipc>
  80210c:	89 c3                	mov    %eax,%ebx
  80210e:	85 c0                	test   %eax,%eax
  802110:	79 09                	jns    80211b <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802112:	89 d8                	mov    %ebx,%eax
  802114:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802117:	5b                   	pop    %ebx
  802118:	5e                   	pop    %esi
  802119:	5d                   	pop    %ebp
  80211a:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80211b:	83 ec 04             	sub    $0x4,%esp
  80211e:	ff 35 10 70 80 00    	pushl  0x807010
  802124:	68 00 70 80 00       	push   $0x807000
  802129:	ff 75 0c             	pushl  0xc(%ebp)
  80212c:	e8 f9 e9 ff ff       	call   800b2a <memmove>
		*addrlen = ret->ret_addrlen;
  802131:	a1 10 70 80 00       	mov    0x807010,%eax
  802136:	89 06                	mov    %eax,(%esi)
  802138:	83 c4 10             	add    $0x10,%esp
	return r;
  80213b:	eb d5                	jmp    802112 <nsipc_accept+0x27>

0080213d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
  802140:	53                   	push   %ebx
  802141:	83 ec 08             	sub    $0x8,%esp
  802144:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80214f:	53                   	push   %ebx
  802150:	ff 75 0c             	pushl  0xc(%ebp)
  802153:	68 04 70 80 00       	push   $0x807004
  802158:	e8 cd e9 ff ff       	call   800b2a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80215d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802163:	b8 02 00 00 00       	mov    $0x2,%eax
  802168:	e8 32 ff ff ff       	call   80209f <nsipc>
}
  80216d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
  802175:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802180:	8b 45 0c             	mov    0xc(%ebp),%eax
  802183:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802188:	b8 03 00 00 00       	mov    $0x3,%eax
  80218d:	e8 0d ff ff ff       	call   80209f <nsipc>
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <nsipc_close>:

int
nsipc_close(int s)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
  802197:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021a2:	b8 04 00 00 00       	mov    $0x4,%eax
  8021a7:	e8 f3 fe ff ff       	call   80209f <nsipc>
}
  8021ac:	c9                   	leave  
  8021ad:	c3                   	ret    

008021ae <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	53                   	push   %ebx
  8021b2:	83 ec 08             	sub    $0x8,%esp
  8021b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021c0:	53                   	push   %ebx
  8021c1:	ff 75 0c             	pushl  0xc(%ebp)
  8021c4:	68 04 70 80 00       	push   $0x807004
  8021c9:	e8 5c e9 ff ff       	call   800b2a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021ce:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021d4:	b8 05 00 00 00       	mov    $0x5,%eax
  8021d9:	e8 c1 fe ff ff       	call   80209f <nsipc>
}
  8021de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
  8021e6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f4:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021f9:	b8 06 00 00 00       	mov    $0x6,%eax
  8021fe:	e8 9c fe ff ff       	call   80209f <nsipc>
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	56                   	push   %esi
  802209:	53                   	push   %ebx
  80220a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802215:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80221b:	8b 45 14             	mov    0x14(%ebp),%eax
  80221e:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802223:	b8 07 00 00 00       	mov    $0x7,%eax
  802228:	e8 72 fe ff ff       	call   80209f <nsipc>
  80222d:	89 c3                	mov    %eax,%ebx
  80222f:	85 c0                	test   %eax,%eax
  802231:	78 1f                	js     802252 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802233:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802238:	7f 21                	jg     80225b <nsipc_recv+0x56>
  80223a:	39 c6                	cmp    %eax,%esi
  80223c:	7c 1d                	jl     80225b <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80223e:	83 ec 04             	sub    $0x4,%esp
  802241:	50                   	push   %eax
  802242:	68 00 70 80 00       	push   $0x807000
  802247:	ff 75 0c             	pushl  0xc(%ebp)
  80224a:	e8 db e8 ff ff       	call   800b2a <memmove>
  80224f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802252:	89 d8                	mov    %ebx,%eax
  802254:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802257:	5b                   	pop    %ebx
  802258:	5e                   	pop    %esi
  802259:	5d                   	pop    %ebp
  80225a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80225b:	68 33 31 80 00       	push   $0x803133
  802260:	68 fb 30 80 00       	push   $0x8030fb
  802265:	6a 62                	push   $0x62
  802267:	68 48 31 80 00       	push   $0x803148
  80226c:	e8 4b 05 00 00       	call   8027bc <_panic>

00802271 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	53                   	push   %ebx
  802275:	83 ec 04             	sub    $0x4,%esp
  802278:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802283:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802289:	7f 2e                	jg     8022b9 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80228b:	83 ec 04             	sub    $0x4,%esp
  80228e:	53                   	push   %ebx
  80228f:	ff 75 0c             	pushl  0xc(%ebp)
  802292:	68 0c 70 80 00       	push   $0x80700c
  802297:	e8 8e e8 ff ff       	call   800b2a <memmove>
	nsipcbuf.send.req_size = size;
  80229c:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8022a5:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022aa:	b8 08 00 00 00       	mov    $0x8,%eax
  8022af:	e8 eb fd ff ff       	call   80209f <nsipc>
}
  8022b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    
	assert(size < 1600);
  8022b9:	68 54 31 80 00       	push   $0x803154
  8022be:	68 fb 30 80 00       	push   $0x8030fb
  8022c3:	6a 6d                	push   $0x6d
  8022c5:	68 48 31 80 00       	push   $0x803148
  8022ca:	e8 ed 04 00 00       	call   8027bc <_panic>

008022cf <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
  8022d2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e0:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8022e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e8:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022ed:	b8 09 00 00 00       	mov    $0x9,%eax
  8022f2:	e8 a8 fd ff ff       	call   80209f <nsipc>
}
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
  8022fc:	56                   	push   %esi
  8022fd:	53                   	push   %ebx
  8022fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802301:	83 ec 0c             	sub    $0xc,%esp
  802304:	ff 75 08             	pushl  0x8(%ebp)
  802307:	e8 6a f3 ff ff       	call   801676 <fd2data>
  80230c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80230e:	83 c4 08             	add    $0x8,%esp
  802311:	68 60 31 80 00       	push   $0x803160
  802316:	53                   	push   %ebx
  802317:	e8 80 e6 ff ff       	call   80099c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80231c:	8b 46 04             	mov    0x4(%esi),%eax
  80231f:	2b 06                	sub    (%esi),%eax
  802321:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802327:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80232e:	00 00 00 
	stat->st_dev = &devpipe;
  802331:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802338:	40 80 00 
	return 0;
}
  80233b:	b8 00 00 00 00       	mov    $0x0,%eax
  802340:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802343:	5b                   	pop    %ebx
  802344:	5e                   	pop    %esi
  802345:	5d                   	pop    %ebp
  802346:	c3                   	ret    

00802347 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
  80234a:	53                   	push   %ebx
  80234b:	83 ec 0c             	sub    $0xc,%esp
  80234e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802351:	53                   	push   %ebx
  802352:	6a 00                	push   $0x0
  802354:	e8 ba ea ff ff       	call   800e13 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802359:	89 1c 24             	mov    %ebx,(%esp)
  80235c:	e8 15 f3 ff ff       	call   801676 <fd2data>
  802361:	83 c4 08             	add    $0x8,%esp
  802364:	50                   	push   %eax
  802365:	6a 00                	push   $0x0
  802367:	e8 a7 ea ff ff       	call   800e13 <sys_page_unmap>
}
  80236c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <_pipeisclosed>:
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
  802374:	57                   	push   %edi
  802375:	56                   	push   %esi
  802376:	53                   	push   %ebx
  802377:	83 ec 1c             	sub    $0x1c,%esp
  80237a:	89 c7                	mov    %eax,%edi
  80237c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80237e:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802383:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802386:	83 ec 0c             	sub    $0xc,%esp
  802389:	57                   	push   %edi
  80238a:	e8 23 05 00 00       	call   8028b2 <pageref>
  80238f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802392:	89 34 24             	mov    %esi,(%esp)
  802395:	e8 18 05 00 00       	call   8028b2 <pageref>
		nn = thisenv->env_runs;
  80239a:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  8023a0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023a3:	83 c4 10             	add    $0x10,%esp
  8023a6:	39 cb                	cmp    %ecx,%ebx
  8023a8:	74 1b                	je     8023c5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023aa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023ad:	75 cf                	jne    80237e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023af:	8b 42 58             	mov    0x58(%edx),%eax
  8023b2:	6a 01                	push   $0x1
  8023b4:	50                   	push   %eax
  8023b5:	53                   	push   %ebx
  8023b6:	68 67 31 80 00       	push   $0x803167
  8023bb:	e8 7d de ff ff       	call   80023d <cprintf>
  8023c0:	83 c4 10             	add    $0x10,%esp
  8023c3:	eb b9                	jmp    80237e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8023c5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023c8:	0f 94 c0             	sete   %al
  8023cb:	0f b6 c0             	movzbl %al,%eax
}
  8023ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023d1:	5b                   	pop    %ebx
  8023d2:	5e                   	pop    %esi
  8023d3:	5f                   	pop    %edi
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    

008023d6 <devpipe_write>:
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	57                   	push   %edi
  8023da:	56                   	push   %esi
  8023db:	53                   	push   %ebx
  8023dc:	83 ec 28             	sub    $0x28,%esp
  8023df:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8023e2:	56                   	push   %esi
  8023e3:	e8 8e f2 ff ff       	call   801676 <fd2data>
  8023e8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023ea:	83 c4 10             	add    $0x10,%esp
  8023ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023f5:	74 4f                	je     802446 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8023f7:	8b 43 04             	mov    0x4(%ebx),%eax
  8023fa:	8b 0b                	mov    (%ebx),%ecx
  8023fc:	8d 51 20             	lea    0x20(%ecx),%edx
  8023ff:	39 d0                	cmp    %edx,%eax
  802401:	72 14                	jb     802417 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802403:	89 da                	mov    %ebx,%edx
  802405:	89 f0                	mov    %esi,%eax
  802407:	e8 65 ff ff ff       	call   802371 <_pipeisclosed>
  80240c:	85 c0                	test   %eax,%eax
  80240e:	75 3b                	jne    80244b <devpipe_write+0x75>
			sys_yield();
  802410:	e8 5a e9 ff ff       	call   800d6f <sys_yield>
  802415:	eb e0                	jmp    8023f7 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802417:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80241a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80241e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802421:	89 c2                	mov    %eax,%edx
  802423:	c1 fa 1f             	sar    $0x1f,%edx
  802426:	89 d1                	mov    %edx,%ecx
  802428:	c1 e9 1b             	shr    $0x1b,%ecx
  80242b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80242e:	83 e2 1f             	and    $0x1f,%edx
  802431:	29 ca                	sub    %ecx,%edx
  802433:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802437:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80243b:	83 c0 01             	add    $0x1,%eax
  80243e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802441:	83 c7 01             	add    $0x1,%edi
  802444:	eb ac                	jmp    8023f2 <devpipe_write+0x1c>
	return i;
  802446:	8b 45 10             	mov    0x10(%ebp),%eax
  802449:	eb 05                	jmp    802450 <devpipe_write+0x7a>
				return 0;
  80244b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802450:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802453:	5b                   	pop    %ebx
  802454:	5e                   	pop    %esi
  802455:	5f                   	pop    %edi
  802456:	5d                   	pop    %ebp
  802457:	c3                   	ret    

00802458 <devpipe_read>:
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	57                   	push   %edi
  80245c:	56                   	push   %esi
  80245d:	53                   	push   %ebx
  80245e:	83 ec 18             	sub    $0x18,%esp
  802461:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802464:	57                   	push   %edi
  802465:	e8 0c f2 ff ff       	call   801676 <fd2data>
  80246a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80246c:	83 c4 10             	add    $0x10,%esp
  80246f:	be 00 00 00 00       	mov    $0x0,%esi
  802474:	3b 75 10             	cmp    0x10(%ebp),%esi
  802477:	75 14                	jne    80248d <devpipe_read+0x35>
	return i;
  802479:	8b 45 10             	mov    0x10(%ebp),%eax
  80247c:	eb 02                	jmp    802480 <devpipe_read+0x28>
				return i;
  80247e:	89 f0                	mov    %esi,%eax
}
  802480:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802483:	5b                   	pop    %ebx
  802484:	5e                   	pop    %esi
  802485:	5f                   	pop    %edi
  802486:	5d                   	pop    %ebp
  802487:	c3                   	ret    
			sys_yield();
  802488:	e8 e2 e8 ff ff       	call   800d6f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80248d:	8b 03                	mov    (%ebx),%eax
  80248f:	3b 43 04             	cmp    0x4(%ebx),%eax
  802492:	75 18                	jne    8024ac <devpipe_read+0x54>
			if (i > 0)
  802494:	85 f6                	test   %esi,%esi
  802496:	75 e6                	jne    80247e <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802498:	89 da                	mov    %ebx,%edx
  80249a:	89 f8                	mov    %edi,%eax
  80249c:	e8 d0 fe ff ff       	call   802371 <_pipeisclosed>
  8024a1:	85 c0                	test   %eax,%eax
  8024a3:	74 e3                	je     802488 <devpipe_read+0x30>
				return 0;
  8024a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024aa:	eb d4                	jmp    802480 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024ac:	99                   	cltd   
  8024ad:	c1 ea 1b             	shr    $0x1b,%edx
  8024b0:	01 d0                	add    %edx,%eax
  8024b2:	83 e0 1f             	and    $0x1f,%eax
  8024b5:	29 d0                	sub    %edx,%eax
  8024b7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024bf:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024c2:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8024c5:	83 c6 01             	add    $0x1,%esi
  8024c8:	eb aa                	jmp    802474 <devpipe_read+0x1c>

008024ca <pipe>:
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
  8024cd:	56                   	push   %esi
  8024ce:	53                   	push   %ebx
  8024cf:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8024d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024d5:	50                   	push   %eax
  8024d6:	e8 b2 f1 ff ff       	call   80168d <fd_alloc>
  8024db:	89 c3                	mov    %eax,%ebx
  8024dd:	83 c4 10             	add    $0x10,%esp
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	0f 88 23 01 00 00    	js     80260b <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024e8:	83 ec 04             	sub    $0x4,%esp
  8024eb:	68 07 04 00 00       	push   $0x407
  8024f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8024f3:	6a 00                	push   $0x0
  8024f5:	e8 94 e8 ff ff       	call   800d8e <sys_page_alloc>
  8024fa:	89 c3                	mov    %eax,%ebx
  8024fc:	83 c4 10             	add    $0x10,%esp
  8024ff:	85 c0                	test   %eax,%eax
  802501:	0f 88 04 01 00 00    	js     80260b <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802507:	83 ec 0c             	sub    $0xc,%esp
  80250a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80250d:	50                   	push   %eax
  80250e:	e8 7a f1 ff ff       	call   80168d <fd_alloc>
  802513:	89 c3                	mov    %eax,%ebx
  802515:	83 c4 10             	add    $0x10,%esp
  802518:	85 c0                	test   %eax,%eax
  80251a:	0f 88 db 00 00 00    	js     8025fb <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802520:	83 ec 04             	sub    $0x4,%esp
  802523:	68 07 04 00 00       	push   $0x407
  802528:	ff 75 f0             	pushl  -0x10(%ebp)
  80252b:	6a 00                	push   $0x0
  80252d:	e8 5c e8 ff ff       	call   800d8e <sys_page_alloc>
  802532:	89 c3                	mov    %eax,%ebx
  802534:	83 c4 10             	add    $0x10,%esp
  802537:	85 c0                	test   %eax,%eax
  802539:	0f 88 bc 00 00 00    	js     8025fb <pipe+0x131>
	va = fd2data(fd0);
  80253f:	83 ec 0c             	sub    $0xc,%esp
  802542:	ff 75 f4             	pushl  -0xc(%ebp)
  802545:	e8 2c f1 ff ff       	call   801676 <fd2data>
  80254a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80254c:	83 c4 0c             	add    $0xc,%esp
  80254f:	68 07 04 00 00       	push   $0x407
  802554:	50                   	push   %eax
  802555:	6a 00                	push   $0x0
  802557:	e8 32 e8 ff ff       	call   800d8e <sys_page_alloc>
  80255c:	89 c3                	mov    %eax,%ebx
  80255e:	83 c4 10             	add    $0x10,%esp
  802561:	85 c0                	test   %eax,%eax
  802563:	0f 88 82 00 00 00    	js     8025eb <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802569:	83 ec 0c             	sub    $0xc,%esp
  80256c:	ff 75 f0             	pushl  -0x10(%ebp)
  80256f:	e8 02 f1 ff ff       	call   801676 <fd2data>
  802574:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80257b:	50                   	push   %eax
  80257c:	6a 00                	push   $0x0
  80257e:	56                   	push   %esi
  80257f:	6a 00                	push   $0x0
  802581:	e8 4b e8 ff ff       	call   800dd1 <sys_page_map>
  802586:	89 c3                	mov    %eax,%ebx
  802588:	83 c4 20             	add    $0x20,%esp
  80258b:	85 c0                	test   %eax,%eax
  80258d:	78 4e                	js     8025dd <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80258f:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802594:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802597:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802599:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a6:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ab:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025b2:	83 ec 0c             	sub    $0xc,%esp
  8025b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b8:	e8 a9 f0 ff ff       	call   801666 <fd2num>
  8025bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025c0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025c2:	83 c4 04             	add    $0x4,%esp
  8025c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8025c8:	e8 99 f0 ff ff       	call   801666 <fd2num>
  8025cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025d0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025d3:	83 c4 10             	add    $0x10,%esp
  8025d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025db:	eb 2e                	jmp    80260b <pipe+0x141>
	sys_page_unmap(0, va);
  8025dd:	83 ec 08             	sub    $0x8,%esp
  8025e0:	56                   	push   %esi
  8025e1:	6a 00                	push   $0x0
  8025e3:	e8 2b e8 ff ff       	call   800e13 <sys_page_unmap>
  8025e8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8025eb:	83 ec 08             	sub    $0x8,%esp
  8025ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8025f1:	6a 00                	push   $0x0
  8025f3:	e8 1b e8 ff ff       	call   800e13 <sys_page_unmap>
  8025f8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8025fb:	83 ec 08             	sub    $0x8,%esp
  8025fe:	ff 75 f4             	pushl  -0xc(%ebp)
  802601:	6a 00                	push   $0x0
  802603:	e8 0b e8 ff ff       	call   800e13 <sys_page_unmap>
  802608:	83 c4 10             	add    $0x10,%esp
}
  80260b:	89 d8                	mov    %ebx,%eax
  80260d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802610:	5b                   	pop    %ebx
  802611:	5e                   	pop    %esi
  802612:	5d                   	pop    %ebp
  802613:	c3                   	ret    

00802614 <pipeisclosed>:
{
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
  802617:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80261a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80261d:	50                   	push   %eax
  80261e:	ff 75 08             	pushl  0x8(%ebp)
  802621:	e8 b9 f0 ff ff       	call   8016df <fd_lookup>
  802626:	83 c4 10             	add    $0x10,%esp
  802629:	85 c0                	test   %eax,%eax
  80262b:	78 18                	js     802645 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80262d:	83 ec 0c             	sub    $0xc,%esp
  802630:	ff 75 f4             	pushl  -0xc(%ebp)
  802633:	e8 3e f0 ff ff       	call   801676 <fd2data>
	return _pipeisclosed(fd, p);
  802638:	89 c2                	mov    %eax,%edx
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	e8 2f fd ff ff       	call   802371 <_pipeisclosed>
  802642:	83 c4 10             	add    $0x10,%esp
}
  802645:	c9                   	leave  
  802646:	c3                   	ret    

00802647 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802647:	b8 00 00 00 00       	mov    $0x0,%eax
  80264c:	c3                   	ret    

0080264d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
  802650:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802653:	68 7f 31 80 00       	push   $0x80317f
  802658:	ff 75 0c             	pushl  0xc(%ebp)
  80265b:	e8 3c e3 ff ff       	call   80099c <strcpy>
	return 0;
}
  802660:	b8 00 00 00 00       	mov    $0x0,%eax
  802665:	c9                   	leave  
  802666:	c3                   	ret    

00802667 <devcons_write>:
{
  802667:	55                   	push   %ebp
  802668:	89 e5                	mov    %esp,%ebp
  80266a:	57                   	push   %edi
  80266b:	56                   	push   %esi
  80266c:	53                   	push   %ebx
  80266d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802673:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802678:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80267e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802681:	73 31                	jae    8026b4 <devcons_write+0x4d>
		m = n - tot;
  802683:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802686:	29 f3                	sub    %esi,%ebx
  802688:	83 fb 7f             	cmp    $0x7f,%ebx
  80268b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802690:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802693:	83 ec 04             	sub    $0x4,%esp
  802696:	53                   	push   %ebx
  802697:	89 f0                	mov    %esi,%eax
  802699:	03 45 0c             	add    0xc(%ebp),%eax
  80269c:	50                   	push   %eax
  80269d:	57                   	push   %edi
  80269e:	e8 87 e4 ff ff       	call   800b2a <memmove>
		sys_cputs(buf, m);
  8026a3:	83 c4 08             	add    $0x8,%esp
  8026a6:	53                   	push   %ebx
  8026a7:	57                   	push   %edi
  8026a8:	e8 25 e6 ff ff       	call   800cd2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8026ad:	01 de                	add    %ebx,%esi
  8026af:	83 c4 10             	add    $0x10,%esp
  8026b2:	eb ca                	jmp    80267e <devcons_write+0x17>
}
  8026b4:	89 f0                	mov    %esi,%eax
  8026b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026b9:	5b                   	pop    %ebx
  8026ba:	5e                   	pop    %esi
  8026bb:	5f                   	pop    %edi
  8026bc:	5d                   	pop    %ebp
  8026bd:	c3                   	ret    

008026be <devcons_read>:
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
  8026c1:	83 ec 08             	sub    $0x8,%esp
  8026c4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8026c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026cd:	74 21                	je     8026f0 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8026cf:	e8 1c e6 ff ff       	call   800cf0 <sys_cgetc>
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	75 07                	jne    8026df <devcons_read+0x21>
		sys_yield();
  8026d8:	e8 92 e6 ff ff       	call   800d6f <sys_yield>
  8026dd:	eb f0                	jmp    8026cf <devcons_read+0x11>
	if (c < 0)
  8026df:	78 0f                	js     8026f0 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8026e1:	83 f8 04             	cmp    $0x4,%eax
  8026e4:	74 0c                	je     8026f2 <devcons_read+0x34>
	*(char*)vbuf = c;
  8026e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026e9:	88 02                	mov    %al,(%edx)
	return 1;
  8026eb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8026f0:	c9                   	leave  
  8026f1:	c3                   	ret    
		return 0;
  8026f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f7:	eb f7                	jmp    8026f0 <devcons_read+0x32>

008026f9 <cputchar>:
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
  8026fc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8026ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802702:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802705:	6a 01                	push   $0x1
  802707:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80270a:	50                   	push   %eax
  80270b:	e8 c2 e5 ff ff       	call   800cd2 <sys_cputs>
}
  802710:	83 c4 10             	add    $0x10,%esp
  802713:	c9                   	leave  
  802714:	c3                   	ret    

00802715 <getchar>:
{
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
  802718:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80271b:	6a 01                	push   $0x1
  80271d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802720:	50                   	push   %eax
  802721:	6a 00                	push   $0x0
  802723:	e8 27 f2 ff ff       	call   80194f <read>
	if (r < 0)
  802728:	83 c4 10             	add    $0x10,%esp
  80272b:	85 c0                	test   %eax,%eax
  80272d:	78 06                	js     802735 <getchar+0x20>
	if (r < 1)
  80272f:	74 06                	je     802737 <getchar+0x22>
	return c;
  802731:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802735:	c9                   	leave  
  802736:	c3                   	ret    
		return -E_EOF;
  802737:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80273c:	eb f7                	jmp    802735 <getchar+0x20>

0080273e <iscons>:
{
  80273e:	55                   	push   %ebp
  80273f:	89 e5                	mov    %esp,%ebp
  802741:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802744:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802747:	50                   	push   %eax
  802748:	ff 75 08             	pushl  0x8(%ebp)
  80274b:	e8 8f ef ff ff       	call   8016df <fd_lookup>
  802750:	83 c4 10             	add    $0x10,%esp
  802753:	85 c0                	test   %eax,%eax
  802755:	78 11                	js     802768 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802760:	39 10                	cmp    %edx,(%eax)
  802762:	0f 94 c0             	sete   %al
  802765:	0f b6 c0             	movzbl %al,%eax
}
  802768:	c9                   	leave  
  802769:	c3                   	ret    

0080276a <opencons>:
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802770:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802773:	50                   	push   %eax
  802774:	e8 14 ef ff ff       	call   80168d <fd_alloc>
  802779:	83 c4 10             	add    $0x10,%esp
  80277c:	85 c0                	test   %eax,%eax
  80277e:	78 3a                	js     8027ba <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802780:	83 ec 04             	sub    $0x4,%esp
  802783:	68 07 04 00 00       	push   $0x407
  802788:	ff 75 f4             	pushl  -0xc(%ebp)
  80278b:	6a 00                	push   $0x0
  80278d:	e8 fc e5 ff ff       	call   800d8e <sys_page_alloc>
  802792:	83 c4 10             	add    $0x10,%esp
  802795:	85 c0                	test   %eax,%eax
  802797:	78 21                	js     8027ba <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027a2:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027ae:	83 ec 0c             	sub    $0xc,%esp
  8027b1:	50                   	push   %eax
  8027b2:	e8 af ee ff ff       	call   801666 <fd2num>
  8027b7:	83 c4 10             	add    $0x10,%esp
}
  8027ba:	c9                   	leave  
  8027bb:	c3                   	ret    

008027bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8027bc:	55                   	push   %ebp
  8027bd:	89 e5                	mov    %esp,%ebp
  8027bf:	56                   	push   %esi
  8027c0:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8027c1:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8027c6:	8b 40 48             	mov    0x48(%eax),%eax
  8027c9:	83 ec 04             	sub    $0x4,%esp
  8027cc:	68 b0 31 80 00       	push   $0x8031b0
  8027d1:	50                   	push   %eax
  8027d2:	68 98 2b 80 00       	push   $0x802b98
  8027d7:	e8 61 da ff ff       	call   80023d <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8027dc:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8027df:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8027e5:	e8 66 e5 ff ff       	call   800d50 <sys_getenvid>
  8027ea:	83 c4 04             	add    $0x4,%esp
  8027ed:	ff 75 0c             	pushl  0xc(%ebp)
  8027f0:	ff 75 08             	pushl  0x8(%ebp)
  8027f3:	56                   	push   %esi
  8027f4:	50                   	push   %eax
  8027f5:	68 8c 31 80 00       	push   $0x80318c
  8027fa:	e8 3e da ff ff       	call   80023d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8027ff:	83 c4 18             	add    $0x18,%esp
  802802:	53                   	push   %ebx
  802803:	ff 75 10             	pushl  0x10(%ebp)
  802806:	e8 e1 d9 ff ff       	call   8001ec <vcprintf>
	cprintf("\n");
  80280b:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  802812:	e8 26 da ff ff       	call   80023d <cprintf>
  802817:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80281a:	cc                   	int3   
  80281b:	eb fd                	jmp    80281a <_panic+0x5e>

0080281d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80281d:	55                   	push   %ebp
  80281e:	89 e5                	mov    %esp,%ebp
  802820:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802823:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80282a:	74 0a                	je     802836 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80282c:	8b 45 08             	mov    0x8(%ebp),%eax
  80282f:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802834:	c9                   	leave  
  802835:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802836:	83 ec 04             	sub    $0x4,%esp
  802839:	6a 07                	push   $0x7
  80283b:	68 00 f0 bf ee       	push   $0xeebff000
  802840:	6a 00                	push   $0x0
  802842:	e8 47 e5 ff ff       	call   800d8e <sys_page_alloc>
		if(r < 0)
  802847:	83 c4 10             	add    $0x10,%esp
  80284a:	85 c0                	test   %eax,%eax
  80284c:	78 2a                	js     802878 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80284e:	83 ec 08             	sub    $0x8,%esp
  802851:	68 8c 28 80 00       	push   $0x80288c
  802856:	6a 00                	push   $0x0
  802858:	e8 7c e6 ff ff       	call   800ed9 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80285d:	83 c4 10             	add    $0x10,%esp
  802860:	85 c0                	test   %eax,%eax
  802862:	79 c8                	jns    80282c <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802864:	83 ec 04             	sub    $0x4,%esp
  802867:	68 e8 31 80 00       	push   $0x8031e8
  80286c:	6a 25                	push   $0x25
  80286e:	68 24 32 80 00       	push   $0x803224
  802873:	e8 44 ff ff ff       	call   8027bc <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802878:	83 ec 04             	sub    $0x4,%esp
  80287b:	68 b8 31 80 00       	push   $0x8031b8
  802880:	6a 22                	push   $0x22
  802882:	68 24 32 80 00       	push   $0x803224
  802887:	e8 30 ff ff ff       	call   8027bc <_panic>

0080288c <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80288c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80288d:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802892:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802894:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802897:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80289b:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80289f:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8028a2:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8028a4:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8028a8:	83 c4 08             	add    $0x8,%esp
	popal
  8028ab:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8028ac:	83 c4 04             	add    $0x4,%esp
	popfl
  8028af:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8028b0:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8028b1:	c3                   	ret    

008028b2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028b2:	55                   	push   %ebp
  8028b3:	89 e5                	mov    %esp,%ebp
  8028b5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028b8:	89 d0                	mov    %edx,%eax
  8028ba:	c1 e8 16             	shr    $0x16,%eax
  8028bd:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028c4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028c9:	f6 c1 01             	test   $0x1,%cl
  8028cc:	74 1d                	je     8028eb <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028ce:	c1 ea 0c             	shr    $0xc,%edx
  8028d1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028d8:	f6 c2 01             	test   $0x1,%dl
  8028db:	74 0e                	je     8028eb <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028dd:	c1 ea 0c             	shr    $0xc,%edx
  8028e0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028e7:	ef 
  8028e8:	0f b7 c0             	movzwl %ax,%eax
}
  8028eb:	5d                   	pop    %ebp
  8028ec:	c3                   	ret    
  8028ed:	66 90                	xchg   %ax,%ax
  8028ef:	90                   	nop

008028f0 <__udivdi3>:
  8028f0:	55                   	push   %ebp
  8028f1:	57                   	push   %edi
  8028f2:	56                   	push   %esi
  8028f3:	53                   	push   %ebx
  8028f4:	83 ec 1c             	sub    $0x1c,%esp
  8028f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8028fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8028ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802903:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802907:	85 d2                	test   %edx,%edx
  802909:	75 4d                	jne    802958 <__udivdi3+0x68>
  80290b:	39 f3                	cmp    %esi,%ebx
  80290d:	76 19                	jbe    802928 <__udivdi3+0x38>
  80290f:	31 ff                	xor    %edi,%edi
  802911:	89 e8                	mov    %ebp,%eax
  802913:	89 f2                	mov    %esi,%edx
  802915:	f7 f3                	div    %ebx
  802917:	89 fa                	mov    %edi,%edx
  802919:	83 c4 1c             	add    $0x1c,%esp
  80291c:	5b                   	pop    %ebx
  80291d:	5e                   	pop    %esi
  80291e:	5f                   	pop    %edi
  80291f:	5d                   	pop    %ebp
  802920:	c3                   	ret    
  802921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802928:	89 d9                	mov    %ebx,%ecx
  80292a:	85 db                	test   %ebx,%ebx
  80292c:	75 0b                	jne    802939 <__udivdi3+0x49>
  80292e:	b8 01 00 00 00       	mov    $0x1,%eax
  802933:	31 d2                	xor    %edx,%edx
  802935:	f7 f3                	div    %ebx
  802937:	89 c1                	mov    %eax,%ecx
  802939:	31 d2                	xor    %edx,%edx
  80293b:	89 f0                	mov    %esi,%eax
  80293d:	f7 f1                	div    %ecx
  80293f:	89 c6                	mov    %eax,%esi
  802941:	89 e8                	mov    %ebp,%eax
  802943:	89 f7                	mov    %esi,%edi
  802945:	f7 f1                	div    %ecx
  802947:	89 fa                	mov    %edi,%edx
  802949:	83 c4 1c             	add    $0x1c,%esp
  80294c:	5b                   	pop    %ebx
  80294d:	5e                   	pop    %esi
  80294e:	5f                   	pop    %edi
  80294f:	5d                   	pop    %ebp
  802950:	c3                   	ret    
  802951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802958:	39 f2                	cmp    %esi,%edx
  80295a:	77 1c                	ja     802978 <__udivdi3+0x88>
  80295c:	0f bd fa             	bsr    %edx,%edi
  80295f:	83 f7 1f             	xor    $0x1f,%edi
  802962:	75 2c                	jne    802990 <__udivdi3+0xa0>
  802964:	39 f2                	cmp    %esi,%edx
  802966:	72 06                	jb     80296e <__udivdi3+0x7e>
  802968:	31 c0                	xor    %eax,%eax
  80296a:	39 eb                	cmp    %ebp,%ebx
  80296c:	77 a9                	ja     802917 <__udivdi3+0x27>
  80296e:	b8 01 00 00 00       	mov    $0x1,%eax
  802973:	eb a2                	jmp    802917 <__udivdi3+0x27>
  802975:	8d 76 00             	lea    0x0(%esi),%esi
  802978:	31 ff                	xor    %edi,%edi
  80297a:	31 c0                	xor    %eax,%eax
  80297c:	89 fa                	mov    %edi,%edx
  80297e:	83 c4 1c             	add    $0x1c,%esp
  802981:	5b                   	pop    %ebx
  802982:	5e                   	pop    %esi
  802983:	5f                   	pop    %edi
  802984:	5d                   	pop    %ebp
  802985:	c3                   	ret    
  802986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80298d:	8d 76 00             	lea    0x0(%esi),%esi
  802990:	89 f9                	mov    %edi,%ecx
  802992:	b8 20 00 00 00       	mov    $0x20,%eax
  802997:	29 f8                	sub    %edi,%eax
  802999:	d3 e2                	shl    %cl,%edx
  80299b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80299f:	89 c1                	mov    %eax,%ecx
  8029a1:	89 da                	mov    %ebx,%edx
  8029a3:	d3 ea                	shr    %cl,%edx
  8029a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029a9:	09 d1                	or     %edx,%ecx
  8029ab:	89 f2                	mov    %esi,%edx
  8029ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029b1:	89 f9                	mov    %edi,%ecx
  8029b3:	d3 e3                	shl    %cl,%ebx
  8029b5:	89 c1                	mov    %eax,%ecx
  8029b7:	d3 ea                	shr    %cl,%edx
  8029b9:	89 f9                	mov    %edi,%ecx
  8029bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029bf:	89 eb                	mov    %ebp,%ebx
  8029c1:	d3 e6                	shl    %cl,%esi
  8029c3:	89 c1                	mov    %eax,%ecx
  8029c5:	d3 eb                	shr    %cl,%ebx
  8029c7:	09 de                	or     %ebx,%esi
  8029c9:	89 f0                	mov    %esi,%eax
  8029cb:	f7 74 24 08          	divl   0x8(%esp)
  8029cf:	89 d6                	mov    %edx,%esi
  8029d1:	89 c3                	mov    %eax,%ebx
  8029d3:	f7 64 24 0c          	mull   0xc(%esp)
  8029d7:	39 d6                	cmp    %edx,%esi
  8029d9:	72 15                	jb     8029f0 <__udivdi3+0x100>
  8029db:	89 f9                	mov    %edi,%ecx
  8029dd:	d3 e5                	shl    %cl,%ebp
  8029df:	39 c5                	cmp    %eax,%ebp
  8029e1:	73 04                	jae    8029e7 <__udivdi3+0xf7>
  8029e3:	39 d6                	cmp    %edx,%esi
  8029e5:	74 09                	je     8029f0 <__udivdi3+0x100>
  8029e7:	89 d8                	mov    %ebx,%eax
  8029e9:	31 ff                	xor    %edi,%edi
  8029eb:	e9 27 ff ff ff       	jmp    802917 <__udivdi3+0x27>
  8029f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029f3:	31 ff                	xor    %edi,%edi
  8029f5:	e9 1d ff ff ff       	jmp    802917 <__udivdi3+0x27>
  8029fa:	66 90                	xchg   %ax,%ax
  8029fc:	66 90                	xchg   %ax,%ax
  8029fe:	66 90                	xchg   %ax,%ax

00802a00 <__umoddi3>:
  802a00:	55                   	push   %ebp
  802a01:	57                   	push   %edi
  802a02:	56                   	push   %esi
  802a03:	53                   	push   %ebx
  802a04:	83 ec 1c             	sub    $0x1c,%esp
  802a07:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a0f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a17:	89 da                	mov    %ebx,%edx
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	75 43                	jne    802a60 <__umoddi3+0x60>
  802a1d:	39 df                	cmp    %ebx,%edi
  802a1f:	76 17                	jbe    802a38 <__umoddi3+0x38>
  802a21:	89 f0                	mov    %esi,%eax
  802a23:	f7 f7                	div    %edi
  802a25:	89 d0                	mov    %edx,%eax
  802a27:	31 d2                	xor    %edx,%edx
  802a29:	83 c4 1c             	add    $0x1c,%esp
  802a2c:	5b                   	pop    %ebx
  802a2d:	5e                   	pop    %esi
  802a2e:	5f                   	pop    %edi
  802a2f:	5d                   	pop    %ebp
  802a30:	c3                   	ret    
  802a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a38:	89 fd                	mov    %edi,%ebp
  802a3a:	85 ff                	test   %edi,%edi
  802a3c:	75 0b                	jne    802a49 <__umoddi3+0x49>
  802a3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a43:	31 d2                	xor    %edx,%edx
  802a45:	f7 f7                	div    %edi
  802a47:	89 c5                	mov    %eax,%ebp
  802a49:	89 d8                	mov    %ebx,%eax
  802a4b:	31 d2                	xor    %edx,%edx
  802a4d:	f7 f5                	div    %ebp
  802a4f:	89 f0                	mov    %esi,%eax
  802a51:	f7 f5                	div    %ebp
  802a53:	89 d0                	mov    %edx,%eax
  802a55:	eb d0                	jmp    802a27 <__umoddi3+0x27>
  802a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a5e:	66 90                	xchg   %ax,%ax
  802a60:	89 f1                	mov    %esi,%ecx
  802a62:	39 d8                	cmp    %ebx,%eax
  802a64:	76 0a                	jbe    802a70 <__umoddi3+0x70>
  802a66:	89 f0                	mov    %esi,%eax
  802a68:	83 c4 1c             	add    $0x1c,%esp
  802a6b:	5b                   	pop    %ebx
  802a6c:	5e                   	pop    %esi
  802a6d:	5f                   	pop    %edi
  802a6e:	5d                   	pop    %ebp
  802a6f:	c3                   	ret    
  802a70:	0f bd e8             	bsr    %eax,%ebp
  802a73:	83 f5 1f             	xor    $0x1f,%ebp
  802a76:	75 20                	jne    802a98 <__umoddi3+0x98>
  802a78:	39 d8                	cmp    %ebx,%eax
  802a7a:	0f 82 b0 00 00 00    	jb     802b30 <__umoddi3+0x130>
  802a80:	39 f7                	cmp    %esi,%edi
  802a82:	0f 86 a8 00 00 00    	jbe    802b30 <__umoddi3+0x130>
  802a88:	89 c8                	mov    %ecx,%eax
  802a8a:	83 c4 1c             	add    $0x1c,%esp
  802a8d:	5b                   	pop    %ebx
  802a8e:	5e                   	pop    %esi
  802a8f:	5f                   	pop    %edi
  802a90:	5d                   	pop    %ebp
  802a91:	c3                   	ret    
  802a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a98:	89 e9                	mov    %ebp,%ecx
  802a9a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a9f:	29 ea                	sub    %ebp,%edx
  802aa1:	d3 e0                	shl    %cl,%eax
  802aa3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802aa7:	89 d1                	mov    %edx,%ecx
  802aa9:	89 f8                	mov    %edi,%eax
  802aab:	d3 e8                	shr    %cl,%eax
  802aad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ab1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ab5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ab9:	09 c1                	or     %eax,%ecx
  802abb:	89 d8                	mov    %ebx,%eax
  802abd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ac1:	89 e9                	mov    %ebp,%ecx
  802ac3:	d3 e7                	shl    %cl,%edi
  802ac5:	89 d1                	mov    %edx,%ecx
  802ac7:	d3 e8                	shr    %cl,%eax
  802ac9:	89 e9                	mov    %ebp,%ecx
  802acb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802acf:	d3 e3                	shl    %cl,%ebx
  802ad1:	89 c7                	mov    %eax,%edi
  802ad3:	89 d1                	mov    %edx,%ecx
  802ad5:	89 f0                	mov    %esi,%eax
  802ad7:	d3 e8                	shr    %cl,%eax
  802ad9:	89 e9                	mov    %ebp,%ecx
  802adb:	89 fa                	mov    %edi,%edx
  802add:	d3 e6                	shl    %cl,%esi
  802adf:	09 d8                	or     %ebx,%eax
  802ae1:	f7 74 24 08          	divl   0x8(%esp)
  802ae5:	89 d1                	mov    %edx,%ecx
  802ae7:	89 f3                	mov    %esi,%ebx
  802ae9:	f7 64 24 0c          	mull   0xc(%esp)
  802aed:	89 c6                	mov    %eax,%esi
  802aef:	89 d7                	mov    %edx,%edi
  802af1:	39 d1                	cmp    %edx,%ecx
  802af3:	72 06                	jb     802afb <__umoddi3+0xfb>
  802af5:	75 10                	jne    802b07 <__umoddi3+0x107>
  802af7:	39 c3                	cmp    %eax,%ebx
  802af9:	73 0c                	jae    802b07 <__umoddi3+0x107>
  802afb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802aff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b03:	89 d7                	mov    %edx,%edi
  802b05:	89 c6                	mov    %eax,%esi
  802b07:	89 ca                	mov    %ecx,%edx
  802b09:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b0e:	29 f3                	sub    %esi,%ebx
  802b10:	19 fa                	sbb    %edi,%edx
  802b12:	89 d0                	mov    %edx,%eax
  802b14:	d3 e0                	shl    %cl,%eax
  802b16:	89 e9                	mov    %ebp,%ecx
  802b18:	d3 eb                	shr    %cl,%ebx
  802b1a:	d3 ea                	shr    %cl,%edx
  802b1c:	09 d8                	or     %ebx,%eax
  802b1e:	83 c4 1c             	add    $0x1c,%esp
  802b21:	5b                   	pop    %ebx
  802b22:	5e                   	pop    %esi
  802b23:	5f                   	pop    %edi
  802b24:	5d                   	pop    %ebp
  802b25:	c3                   	ret    
  802b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b2d:	8d 76 00             	lea    0x0(%esi),%esi
  802b30:	89 da                	mov    %ebx,%edx
  802b32:	29 fe                	sub    %edi,%esi
  802b34:	19 c2                	sbb    %eax,%edx
  802b36:	89 f1                	mov    %esi,%ecx
  802b38:	89 c8                	mov    %ecx,%eax
  802b3a:	e9 4b ff ff ff       	jmp    802a8a <__umoddi3+0x8a>
