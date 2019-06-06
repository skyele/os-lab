
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
  80003a:	e8 a0 13 00 00       	call   8013df <sfork>
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
  800051:	e8 f4 14 00 00       	call   80154a <ipc_recv>
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
  800074:	e8 3a 15 00 00       	call   8015b3 <ipc_send>
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
  800091:	e8 1d 15 00 00       	call   8015b3 <ipc_send>
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
  80011e:	68 20 2b 80 00       	push   $0x802b20
  800123:	e8 15 01 00 00       	call   80023d <cprintf>
	cprintf("before umain\n");
  800128:	c7 04 24 3e 2b 80 00 	movl   $0x802b3e,(%esp)
  80012f:	e8 09 01 00 00       	call   80023d <cprintf>
	// call user main routine
	umain(argc, argv);
  800134:	83 c4 08             	add    $0x8,%esp
  800137:	ff 75 0c             	pushl  0xc(%ebp)
  80013a:	ff 75 08             	pushl  0x8(%ebp)
  80013d:	e8 f1 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800142:	c7 04 24 4c 2b 80 00 	movl   $0x802b4c,(%esp)
  800149:	e8 ef 00 00 00       	call   80023d <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80014e:	a1 0c 50 80 00       	mov    0x80500c,%eax
  800153:	8b 40 48             	mov    0x48(%eax),%eax
  800156:	83 c4 08             	add    $0x8,%esp
  800159:	50                   	push   %eax
  80015a:	68 59 2b 80 00       	push   $0x802b59
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
  800182:	68 84 2b 80 00       	push   $0x802b84
  800187:	50                   	push   %eax
  800188:	68 78 2b 80 00       	push   $0x802b78
  80018d:	e8 ab 00 00 00       	call   80023d <cprintf>
	close_all();
  800192:	e8 87 16 00 00       	call   80181e <close_all>
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
  8002ea:	e8 e1 25 00 00       	call   8028d0 <__udivdi3>
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
  800313:	e8 c8 26 00 00       	call   8029e0 <__umoddi3>
  800318:	83 c4 14             	add    $0x14,%esp
  80031b:	0f be 80 89 2b 80 00 	movsbl 0x802b89(%eax),%eax
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
  8003c4:	ff 24 85 60 2d 80 00 	jmp    *0x802d60(,%eax,4)
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
  80048f:	8b 14 85 c0 2e 80 00 	mov    0x802ec0(,%eax,4),%edx
  800496:	85 d2                	test   %edx,%edx
  800498:	74 18                	je     8004b2 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80049a:	52                   	push   %edx
  80049b:	68 ed 30 80 00       	push   $0x8030ed
  8004a0:	53                   	push   %ebx
  8004a1:	56                   	push   %esi
  8004a2:	e8 a6 fe ff ff       	call   80034d <printfmt>
  8004a7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004aa:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004ad:	e9 fe 02 00 00       	jmp    8007b0 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004b2:	50                   	push   %eax
  8004b3:	68 a1 2b 80 00       	push   $0x802ba1
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
  8004da:	b8 9a 2b 80 00       	mov    $0x802b9a,%eax
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
  800872:	bf bd 2c 80 00       	mov    $0x802cbd,%edi
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
  80089e:	bf f5 2c 80 00       	mov    $0x802cf5,%edi
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
  800d3f:	68 08 2f 80 00       	push   $0x802f08
  800d44:	6a 43                	push   $0x43
  800d46:	68 25 2f 80 00       	push   $0x802f25
  800d4b:	e8 4c 1a 00 00       	call   80279c <_panic>

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
  800dc0:	68 08 2f 80 00       	push   $0x802f08
  800dc5:	6a 43                	push   $0x43
  800dc7:	68 25 2f 80 00       	push   $0x802f25
  800dcc:	e8 cb 19 00 00       	call   80279c <_panic>

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
  800e02:	68 08 2f 80 00       	push   $0x802f08
  800e07:	6a 43                	push   $0x43
  800e09:	68 25 2f 80 00       	push   $0x802f25
  800e0e:	e8 89 19 00 00       	call   80279c <_panic>

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
  800e44:	68 08 2f 80 00       	push   $0x802f08
  800e49:	6a 43                	push   $0x43
  800e4b:	68 25 2f 80 00       	push   $0x802f25
  800e50:	e8 47 19 00 00       	call   80279c <_panic>

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
  800e86:	68 08 2f 80 00       	push   $0x802f08
  800e8b:	6a 43                	push   $0x43
  800e8d:	68 25 2f 80 00       	push   $0x802f25
  800e92:	e8 05 19 00 00       	call   80279c <_panic>

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
  800ec8:	68 08 2f 80 00       	push   $0x802f08
  800ecd:	6a 43                	push   $0x43
  800ecf:	68 25 2f 80 00       	push   $0x802f25
  800ed4:	e8 c3 18 00 00       	call   80279c <_panic>

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
  800f0a:	68 08 2f 80 00       	push   $0x802f08
  800f0f:	6a 43                	push   $0x43
  800f11:	68 25 2f 80 00       	push   $0x802f25
  800f16:	e8 81 18 00 00       	call   80279c <_panic>

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
  800f6e:	68 08 2f 80 00       	push   $0x802f08
  800f73:	6a 43                	push   $0x43
  800f75:	68 25 2f 80 00       	push   $0x802f25
  800f7a:	e8 1d 18 00 00       	call   80279c <_panic>

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
  801052:	68 08 2f 80 00       	push   $0x802f08
  801057:	6a 43                	push   $0x43
  801059:	68 25 2f 80 00       	push   $0x802f25
  80105e:	e8 39 17 00 00       	call   80279c <_panic>

00801063 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	53                   	push   %ebx
  801067:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  80106a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801071:	f6 c5 04             	test   $0x4,%ch
  801074:	75 45                	jne    8010bb <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801076:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80107d:	83 e1 07             	and    $0x7,%ecx
  801080:	83 f9 07             	cmp    $0x7,%ecx
  801083:	74 6f                	je     8010f4 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801085:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80108c:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801092:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801098:	0f 84 b6 00 00 00    	je     801154 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80109e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010a5:	83 e1 05             	and    $0x5,%ecx
  8010a8:	83 f9 05             	cmp    $0x5,%ecx
  8010ab:	0f 84 d7 00 00 00    	je     801188 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8010b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b9:	c9                   	leave  
  8010ba:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8010bb:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010c2:	c1 e2 0c             	shl    $0xc,%edx
  8010c5:	83 ec 0c             	sub    $0xc,%esp
  8010c8:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8010ce:	51                   	push   %ecx
  8010cf:	52                   	push   %edx
  8010d0:	50                   	push   %eax
  8010d1:	52                   	push   %edx
  8010d2:	6a 00                	push   $0x0
  8010d4:	e8 f8 fc ff ff       	call   800dd1 <sys_page_map>
		if(r < 0)
  8010d9:	83 c4 20             	add    $0x20,%esp
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	79 d1                	jns    8010b1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8010e0:	83 ec 04             	sub    $0x4,%esp
  8010e3:	68 33 2f 80 00       	push   $0x802f33
  8010e8:	6a 54                	push   $0x54
  8010ea:	68 49 2f 80 00       	push   $0x802f49
  8010ef:	e8 a8 16 00 00       	call   80279c <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010f4:	89 d3                	mov    %edx,%ebx
  8010f6:	c1 e3 0c             	shl    $0xc,%ebx
  8010f9:	83 ec 0c             	sub    $0xc,%esp
  8010fc:	68 05 08 00 00       	push   $0x805
  801101:	53                   	push   %ebx
  801102:	50                   	push   %eax
  801103:	53                   	push   %ebx
  801104:	6a 00                	push   $0x0
  801106:	e8 c6 fc ff ff       	call   800dd1 <sys_page_map>
		if(r < 0)
  80110b:	83 c4 20             	add    $0x20,%esp
  80110e:	85 c0                	test   %eax,%eax
  801110:	78 2e                	js     801140 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801112:	83 ec 0c             	sub    $0xc,%esp
  801115:	68 05 08 00 00       	push   $0x805
  80111a:	53                   	push   %ebx
  80111b:	6a 00                	push   $0x0
  80111d:	53                   	push   %ebx
  80111e:	6a 00                	push   $0x0
  801120:	e8 ac fc ff ff       	call   800dd1 <sys_page_map>
		if(r < 0)
  801125:	83 c4 20             	add    $0x20,%esp
  801128:	85 c0                	test   %eax,%eax
  80112a:	79 85                	jns    8010b1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80112c:	83 ec 04             	sub    $0x4,%esp
  80112f:	68 33 2f 80 00       	push   $0x802f33
  801134:	6a 5f                	push   $0x5f
  801136:	68 49 2f 80 00       	push   $0x802f49
  80113b:	e8 5c 16 00 00       	call   80279c <_panic>
			panic("sys_page_map() panic\n");
  801140:	83 ec 04             	sub    $0x4,%esp
  801143:	68 33 2f 80 00       	push   $0x802f33
  801148:	6a 5b                	push   $0x5b
  80114a:	68 49 2f 80 00       	push   $0x802f49
  80114f:	e8 48 16 00 00       	call   80279c <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801154:	c1 e2 0c             	shl    $0xc,%edx
  801157:	83 ec 0c             	sub    $0xc,%esp
  80115a:	68 05 08 00 00       	push   $0x805
  80115f:	52                   	push   %edx
  801160:	50                   	push   %eax
  801161:	52                   	push   %edx
  801162:	6a 00                	push   $0x0
  801164:	e8 68 fc ff ff       	call   800dd1 <sys_page_map>
		if(r < 0)
  801169:	83 c4 20             	add    $0x20,%esp
  80116c:	85 c0                	test   %eax,%eax
  80116e:	0f 89 3d ff ff ff    	jns    8010b1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801174:	83 ec 04             	sub    $0x4,%esp
  801177:	68 33 2f 80 00       	push   $0x802f33
  80117c:	6a 66                	push   $0x66
  80117e:	68 49 2f 80 00       	push   $0x802f49
  801183:	e8 14 16 00 00       	call   80279c <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801188:	c1 e2 0c             	shl    $0xc,%edx
  80118b:	83 ec 0c             	sub    $0xc,%esp
  80118e:	6a 05                	push   $0x5
  801190:	52                   	push   %edx
  801191:	50                   	push   %eax
  801192:	52                   	push   %edx
  801193:	6a 00                	push   $0x0
  801195:	e8 37 fc ff ff       	call   800dd1 <sys_page_map>
		if(r < 0)
  80119a:	83 c4 20             	add    $0x20,%esp
  80119d:	85 c0                	test   %eax,%eax
  80119f:	0f 89 0c ff ff ff    	jns    8010b1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011a5:	83 ec 04             	sub    $0x4,%esp
  8011a8:	68 33 2f 80 00       	push   $0x802f33
  8011ad:	6a 6d                	push   $0x6d
  8011af:	68 49 2f 80 00       	push   $0x802f49
  8011b4:	e8 e3 15 00 00       	call   80279c <_panic>

008011b9 <pgfault>:
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
  8011bc:	53                   	push   %ebx
  8011bd:	83 ec 04             	sub    $0x4,%esp
  8011c0:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8011c3:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011c5:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8011c9:	0f 84 99 00 00 00    	je     801268 <pgfault+0xaf>
  8011cf:	89 c2                	mov    %eax,%edx
  8011d1:	c1 ea 16             	shr    $0x16,%edx
  8011d4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011db:	f6 c2 01             	test   $0x1,%dl
  8011de:	0f 84 84 00 00 00    	je     801268 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8011e4:	89 c2                	mov    %eax,%edx
  8011e6:	c1 ea 0c             	shr    $0xc,%edx
  8011e9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011f0:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011f6:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8011fc:	75 6a                	jne    801268 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8011fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801203:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801205:	83 ec 04             	sub    $0x4,%esp
  801208:	6a 07                	push   $0x7
  80120a:	68 00 f0 7f 00       	push   $0x7ff000
  80120f:	6a 00                	push   $0x0
  801211:	e8 78 fb ff ff       	call   800d8e <sys_page_alloc>
	if(ret < 0)
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	85 c0                	test   %eax,%eax
  80121b:	78 5f                	js     80127c <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80121d:	83 ec 04             	sub    $0x4,%esp
  801220:	68 00 10 00 00       	push   $0x1000
  801225:	53                   	push   %ebx
  801226:	68 00 f0 7f 00       	push   $0x7ff000
  80122b:	e8 5c f9 ff ff       	call   800b8c <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801230:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801237:	53                   	push   %ebx
  801238:	6a 00                	push   $0x0
  80123a:	68 00 f0 7f 00       	push   $0x7ff000
  80123f:	6a 00                	push   $0x0
  801241:	e8 8b fb ff ff       	call   800dd1 <sys_page_map>
	if(ret < 0)
  801246:	83 c4 20             	add    $0x20,%esp
  801249:	85 c0                	test   %eax,%eax
  80124b:	78 43                	js     801290 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  80124d:	83 ec 08             	sub    $0x8,%esp
  801250:	68 00 f0 7f 00       	push   $0x7ff000
  801255:	6a 00                	push   $0x0
  801257:	e8 b7 fb ff ff       	call   800e13 <sys_page_unmap>
	if(ret < 0)
  80125c:	83 c4 10             	add    $0x10,%esp
  80125f:	85 c0                	test   %eax,%eax
  801261:	78 41                	js     8012a4 <pgfault+0xeb>
}
  801263:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801266:	c9                   	leave  
  801267:	c3                   	ret    
		panic("panic at pgfault()\n");
  801268:	83 ec 04             	sub    $0x4,%esp
  80126b:	68 54 2f 80 00       	push   $0x802f54
  801270:	6a 26                	push   $0x26
  801272:	68 49 2f 80 00       	push   $0x802f49
  801277:	e8 20 15 00 00       	call   80279c <_panic>
		panic("panic in sys_page_alloc()\n");
  80127c:	83 ec 04             	sub    $0x4,%esp
  80127f:	68 68 2f 80 00       	push   $0x802f68
  801284:	6a 31                	push   $0x31
  801286:	68 49 2f 80 00       	push   $0x802f49
  80128b:	e8 0c 15 00 00       	call   80279c <_panic>
		panic("panic in sys_page_map()\n");
  801290:	83 ec 04             	sub    $0x4,%esp
  801293:	68 83 2f 80 00       	push   $0x802f83
  801298:	6a 36                	push   $0x36
  80129a:	68 49 2f 80 00       	push   $0x802f49
  80129f:	e8 f8 14 00 00       	call   80279c <_panic>
		panic("panic in sys_page_unmap()\n");
  8012a4:	83 ec 04             	sub    $0x4,%esp
  8012a7:	68 9c 2f 80 00       	push   $0x802f9c
  8012ac:	6a 39                	push   $0x39
  8012ae:	68 49 2f 80 00       	push   $0x802f49
  8012b3:	e8 e4 14 00 00       	call   80279c <_panic>

008012b8 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	57                   	push   %edi
  8012bc:	56                   	push   %esi
  8012bd:	53                   	push   %ebx
  8012be:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8012c1:	68 b9 11 80 00       	push   $0x8011b9
  8012c6:	e8 32 15 00 00       	call   8027fd <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8012cb:	b8 07 00 00 00       	mov    $0x7,%eax
  8012d0:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	78 27                	js     801300 <fork+0x48>
  8012d9:	89 c6                	mov    %eax,%esi
  8012db:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012dd:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8012e2:	75 48                	jne    80132c <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012e4:	e8 67 fa ff ff       	call   800d50 <sys_getenvid>
  8012e9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012ee:	c1 e0 07             	shl    $0x7,%eax
  8012f1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012f6:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8012fb:	e9 90 00 00 00       	jmp    801390 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801300:	83 ec 04             	sub    $0x4,%esp
  801303:	68 b8 2f 80 00       	push   $0x802fb8
  801308:	68 8c 00 00 00       	push   $0x8c
  80130d:	68 49 2f 80 00       	push   $0x802f49
  801312:	e8 85 14 00 00       	call   80279c <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801317:	89 f8                	mov    %edi,%eax
  801319:	e8 45 fd ff ff       	call   801063 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80131e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801324:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80132a:	74 26                	je     801352 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  80132c:	89 d8                	mov    %ebx,%eax
  80132e:	c1 e8 16             	shr    $0x16,%eax
  801331:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801338:	a8 01                	test   $0x1,%al
  80133a:	74 e2                	je     80131e <fork+0x66>
  80133c:	89 da                	mov    %ebx,%edx
  80133e:	c1 ea 0c             	shr    $0xc,%edx
  801341:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801348:	83 e0 05             	and    $0x5,%eax
  80134b:	83 f8 05             	cmp    $0x5,%eax
  80134e:	75 ce                	jne    80131e <fork+0x66>
  801350:	eb c5                	jmp    801317 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801352:	83 ec 04             	sub    $0x4,%esp
  801355:	6a 07                	push   $0x7
  801357:	68 00 f0 bf ee       	push   $0xeebff000
  80135c:	56                   	push   %esi
  80135d:	e8 2c fa ff ff       	call   800d8e <sys_page_alloc>
	if(ret < 0)
  801362:	83 c4 10             	add    $0x10,%esp
  801365:	85 c0                	test   %eax,%eax
  801367:	78 31                	js     80139a <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801369:	83 ec 08             	sub    $0x8,%esp
  80136c:	68 6c 28 80 00       	push   $0x80286c
  801371:	56                   	push   %esi
  801372:	e8 62 fb ff ff       	call   800ed9 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801377:	83 c4 10             	add    $0x10,%esp
  80137a:	85 c0                	test   %eax,%eax
  80137c:	78 33                	js     8013b1 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80137e:	83 ec 08             	sub    $0x8,%esp
  801381:	6a 02                	push   $0x2
  801383:	56                   	push   %esi
  801384:	e8 cc fa ff ff       	call   800e55 <sys_env_set_status>
	if(ret < 0)
  801389:	83 c4 10             	add    $0x10,%esp
  80138c:	85 c0                	test   %eax,%eax
  80138e:	78 38                	js     8013c8 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801390:	89 f0                	mov    %esi,%eax
  801392:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801395:	5b                   	pop    %ebx
  801396:	5e                   	pop    %esi
  801397:	5f                   	pop    %edi
  801398:	5d                   	pop    %ebp
  801399:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80139a:	83 ec 04             	sub    $0x4,%esp
  80139d:	68 68 2f 80 00       	push   $0x802f68
  8013a2:	68 98 00 00 00       	push   $0x98
  8013a7:	68 49 2f 80 00       	push   $0x802f49
  8013ac:	e8 eb 13 00 00       	call   80279c <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8013b1:	83 ec 04             	sub    $0x4,%esp
  8013b4:	68 dc 2f 80 00       	push   $0x802fdc
  8013b9:	68 9b 00 00 00       	push   $0x9b
  8013be:	68 49 2f 80 00       	push   $0x802f49
  8013c3:	e8 d4 13 00 00       	call   80279c <_panic>
		panic("panic in sys_env_set_status()\n");
  8013c8:	83 ec 04             	sub    $0x4,%esp
  8013cb:	68 04 30 80 00       	push   $0x803004
  8013d0:	68 9e 00 00 00       	push   $0x9e
  8013d5:	68 49 2f 80 00       	push   $0x802f49
  8013da:	e8 bd 13 00 00       	call   80279c <_panic>

008013df <sfork>:

// Challenge!
int
sfork(void)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	57                   	push   %edi
  8013e3:	56                   	push   %esi
  8013e4:	53                   	push   %ebx
  8013e5:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8013e8:	68 b9 11 80 00       	push   $0x8011b9
  8013ed:	e8 0b 14 00 00       	call   8027fd <set_pgfault_handler>
  8013f2:	b8 07 00 00 00       	mov    $0x7,%eax
  8013f7:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013f9:	83 c4 10             	add    $0x10,%esp
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	78 27                	js     801427 <sfork+0x48>
  801400:	89 c7                	mov    %eax,%edi
  801402:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801404:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801409:	75 55                	jne    801460 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  80140b:	e8 40 f9 ff ff       	call   800d50 <sys_getenvid>
  801410:	25 ff 03 00 00       	and    $0x3ff,%eax
  801415:	c1 e0 07             	shl    $0x7,%eax
  801418:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80141d:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  801422:	e9 d4 00 00 00       	jmp    8014fb <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801427:	83 ec 04             	sub    $0x4,%esp
  80142a:	68 b8 2f 80 00       	push   $0x802fb8
  80142f:	68 af 00 00 00       	push   $0xaf
  801434:	68 49 2f 80 00       	push   $0x802f49
  801439:	e8 5e 13 00 00       	call   80279c <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80143e:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801443:	89 f0                	mov    %esi,%eax
  801445:	e8 19 fc ff ff       	call   801063 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80144a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801450:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801456:	77 65                	ja     8014bd <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801458:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80145e:	74 de                	je     80143e <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801460:	89 d8                	mov    %ebx,%eax
  801462:	c1 e8 16             	shr    $0x16,%eax
  801465:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80146c:	a8 01                	test   $0x1,%al
  80146e:	74 da                	je     80144a <sfork+0x6b>
  801470:	89 da                	mov    %ebx,%edx
  801472:	c1 ea 0c             	shr    $0xc,%edx
  801475:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80147c:	83 e0 05             	and    $0x5,%eax
  80147f:	83 f8 05             	cmp    $0x5,%eax
  801482:	75 c6                	jne    80144a <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801484:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80148b:	c1 e2 0c             	shl    $0xc,%edx
  80148e:	83 ec 0c             	sub    $0xc,%esp
  801491:	83 e0 07             	and    $0x7,%eax
  801494:	50                   	push   %eax
  801495:	52                   	push   %edx
  801496:	56                   	push   %esi
  801497:	52                   	push   %edx
  801498:	6a 00                	push   $0x0
  80149a:	e8 32 f9 ff ff       	call   800dd1 <sys_page_map>
  80149f:	83 c4 20             	add    $0x20,%esp
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	74 a4                	je     80144a <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8014a6:	83 ec 04             	sub    $0x4,%esp
  8014a9:	68 33 2f 80 00       	push   $0x802f33
  8014ae:	68 ba 00 00 00       	push   $0xba
  8014b3:	68 49 2f 80 00       	push   $0x802f49
  8014b8:	e8 df 12 00 00       	call   80279c <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014bd:	83 ec 04             	sub    $0x4,%esp
  8014c0:	6a 07                	push   $0x7
  8014c2:	68 00 f0 bf ee       	push   $0xeebff000
  8014c7:	57                   	push   %edi
  8014c8:	e8 c1 f8 ff ff       	call   800d8e <sys_page_alloc>
	if(ret < 0)
  8014cd:	83 c4 10             	add    $0x10,%esp
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	78 31                	js     801505 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014d4:	83 ec 08             	sub    $0x8,%esp
  8014d7:	68 6c 28 80 00       	push   $0x80286c
  8014dc:	57                   	push   %edi
  8014dd:	e8 f7 f9 ff ff       	call   800ed9 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	85 c0                	test   %eax,%eax
  8014e7:	78 33                	js     80151c <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014e9:	83 ec 08             	sub    $0x8,%esp
  8014ec:	6a 02                	push   $0x2
  8014ee:	57                   	push   %edi
  8014ef:	e8 61 f9 ff ff       	call   800e55 <sys_env_set_status>
	if(ret < 0)
  8014f4:	83 c4 10             	add    $0x10,%esp
  8014f7:	85 c0                	test   %eax,%eax
  8014f9:	78 38                	js     801533 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8014fb:	89 f8                	mov    %edi,%eax
  8014fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801500:	5b                   	pop    %ebx
  801501:	5e                   	pop    %esi
  801502:	5f                   	pop    %edi
  801503:	5d                   	pop    %ebp
  801504:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801505:	83 ec 04             	sub    $0x4,%esp
  801508:	68 68 2f 80 00       	push   $0x802f68
  80150d:	68 c0 00 00 00       	push   $0xc0
  801512:	68 49 2f 80 00       	push   $0x802f49
  801517:	e8 80 12 00 00       	call   80279c <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80151c:	83 ec 04             	sub    $0x4,%esp
  80151f:	68 dc 2f 80 00       	push   $0x802fdc
  801524:	68 c3 00 00 00       	push   $0xc3
  801529:	68 49 2f 80 00       	push   $0x802f49
  80152e:	e8 69 12 00 00       	call   80279c <_panic>
		panic("panic in sys_env_set_status()\n");
  801533:	83 ec 04             	sub    $0x4,%esp
  801536:	68 04 30 80 00       	push   $0x803004
  80153b:	68 c6 00 00 00       	push   $0xc6
  801540:	68 49 2f 80 00       	push   $0x802f49
  801545:	e8 52 12 00 00       	call   80279c <_panic>

0080154a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
  80154d:	56                   	push   %esi
  80154e:	53                   	push   %ebx
  80154f:	8b 75 08             	mov    0x8(%ebp),%esi
  801552:	8b 45 0c             	mov    0xc(%ebp),%eax
  801555:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801558:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80155a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80155f:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801562:	83 ec 0c             	sub    $0xc,%esp
  801565:	50                   	push   %eax
  801566:	e8 d3 f9 ff ff       	call   800f3e <sys_ipc_recv>
	if(ret < 0){
  80156b:	83 c4 10             	add    $0x10,%esp
  80156e:	85 c0                	test   %eax,%eax
  801570:	78 2b                	js     80159d <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801572:	85 f6                	test   %esi,%esi
  801574:	74 0a                	je     801580 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801576:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80157b:	8b 40 74             	mov    0x74(%eax),%eax
  80157e:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801580:	85 db                	test   %ebx,%ebx
  801582:	74 0a                	je     80158e <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801584:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801589:	8b 40 78             	mov    0x78(%eax),%eax
  80158c:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80158e:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801593:	8b 40 70             	mov    0x70(%eax),%eax
}
  801596:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801599:	5b                   	pop    %ebx
  80159a:	5e                   	pop    %esi
  80159b:	5d                   	pop    %ebp
  80159c:	c3                   	ret    
		if(from_env_store)
  80159d:	85 f6                	test   %esi,%esi
  80159f:	74 06                	je     8015a7 <ipc_recv+0x5d>
			*from_env_store = 0;
  8015a1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8015a7:	85 db                	test   %ebx,%ebx
  8015a9:	74 eb                	je     801596 <ipc_recv+0x4c>
			*perm_store = 0;
  8015ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8015b1:	eb e3                	jmp    801596 <ipc_recv+0x4c>

008015b3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	57                   	push   %edi
  8015b7:	56                   	push   %esi
  8015b8:	53                   	push   %ebx
  8015b9:	83 ec 0c             	sub    $0xc,%esp
  8015bc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8015c5:	85 db                	test   %ebx,%ebx
  8015c7:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8015cc:	0f 44 d8             	cmove  %eax,%ebx
  8015cf:	eb 05                	jmp    8015d6 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8015d1:	e8 99 f7 ff ff       	call   800d6f <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8015d6:	ff 75 14             	pushl  0x14(%ebp)
  8015d9:	53                   	push   %ebx
  8015da:	56                   	push   %esi
  8015db:	57                   	push   %edi
  8015dc:	e8 3a f9 ff ff       	call   800f1b <sys_ipc_try_send>
  8015e1:	83 c4 10             	add    $0x10,%esp
  8015e4:	85 c0                	test   %eax,%eax
  8015e6:	74 1b                	je     801603 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8015e8:	79 e7                	jns    8015d1 <ipc_send+0x1e>
  8015ea:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8015ed:	74 e2                	je     8015d1 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8015ef:	83 ec 04             	sub    $0x4,%esp
  8015f2:	68 23 30 80 00       	push   $0x803023
  8015f7:	6a 46                	push   $0x46
  8015f9:	68 38 30 80 00       	push   $0x803038
  8015fe:	e8 99 11 00 00       	call   80279c <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801603:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801606:	5b                   	pop    %ebx
  801607:	5e                   	pop    %esi
  801608:	5f                   	pop    %edi
  801609:	5d                   	pop    %ebp
  80160a:	c3                   	ret    

0080160b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801611:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801616:	89 c2                	mov    %eax,%edx
  801618:	c1 e2 07             	shl    $0x7,%edx
  80161b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801621:	8b 52 50             	mov    0x50(%edx),%edx
  801624:	39 ca                	cmp    %ecx,%edx
  801626:	74 11                	je     801639 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801628:	83 c0 01             	add    $0x1,%eax
  80162b:	3d 00 04 00 00       	cmp    $0x400,%eax
  801630:	75 e4                	jne    801616 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801632:	b8 00 00 00 00       	mov    $0x0,%eax
  801637:	eb 0b                	jmp    801644 <ipc_find_env+0x39>
			return envs[i].env_id;
  801639:	c1 e0 07             	shl    $0x7,%eax
  80163c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801641:	8b 40 48             	mov    0x48(%eax),%eax
}
  801644:	5d                   	pop    %ebp
  801645:	c3                   	ret    

00801646 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	05 00 00 00 30       	add    $0x30000000,%eax
  801651:	c1 e8 0c             	shr    $0xc,%eax
}
  801654:	5d                   	pop    %ebp
  801655:	c3                   	ret    

00801656 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801661:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801666:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80166b:	5d                   	pop    %ebp
  80166c:	c3                   	ret    

0080166d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801675:	89 c2                	mov    %eax,%edx
  801677:	c1 ea 16             	shr    $0x16,%edx
  80167a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801681:	f6 c2 01             	test   $0x1,%dl
  801684:	74 2d                	je     8016b3 <fd_alloc+0x46>
  801686:	89 c2                	mov    %eax,%edx
  801688:	c1 ea 0c             	shr    $0xc,%edx
  80168b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801692:	f6 c2 01             	test   $0x1,%dl
  801695:	74 1c                	je     8016b3 <fd_alloc+0x46>
  801697:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80169c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016a1:	75 d2                	jne    801675 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8016ac:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8016b1:	eb 0a                	jmp    8016bd <fd_alloc+0x50>
			*fd_store = fd;
  8016b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016b6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bd:	5d                   	pop    %ebp
  8016be:	c3                   	ret    

008016bf <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016c5:	83 f8 1f             	cmp    $0x1f,%eax
  8016c8:	77 30                	ja     8016fa <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016ca:	c1 e0 0c             	shl    $0xc,%eax
  8016cd:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016d2:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8016d8:	f6 c2 01             	test   $0x1,%dl
  8016db:	74 24                	je     801701 <fd_lookup+0x42>
  8016dd:	89 c2                	mov    %eax,%edx
  8016df:	c1 ea 0c             	shr    $0xc,%edx
  8016e2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016e9:	f6 c2 01             	test   $0x1,%dl
  8016ec:	74 1a                	je     801708 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f1:	89 02                	mov    %eax,(%edx)
	return 0;
  8016f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f8:	5d                   	pop    %ebp
  8016f9:	c3                   	ret    
		return -E_INVAL;
  8016fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ff:	eb f7                	jmp    8016f8 <fd_lookup+0x39>
		return -E_INVAL;
  801701:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801706:	eb f0                	jmp    8016f8 <fd_lookup+0x39>
  801708:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80170d:	eb e9                	jmp    8016f8 <fd_lookup+0x39>

0080170f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	83 ec 08             	sub    $0x8,%esp
  801715:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801718:	ba 00 00 00 00       	mov    $0x0,%edx
  80171d:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801722:	39 08                	cmp    %ecx,(%eax)
  801724:	74 38                	je     80175e <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801726:	83 c2 01             	add    $0x1,%edx
  801729:	8b 04 95 c0 30 80 00 	mov    0x8030c0(,%edx,4),%eax
  801730:	85 c0                	test   %eax,%eax
  801732:	75 ee                	jne    801722 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801734:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801739:	8b 40 48             	mov    0x48(%eax),%eax
  80173c:	83 ec 04             	sub    $0x4,%esp
  80173f:	51                   	push   %ecx
  801740:	50                   	push   %eax
  801741:	68 44 30 80 00       	push   $0x803044
  801746:	e8 f2 ea ff ff       	call   80023d <cprintf>
	*dev = 0;
  80174b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801754:	83 c4 10             	add    $0x10,%esp
  801757:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    
			*dev = devtab[i];
  80175e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801761:	89 01                	mov    %eax,(%ecx)
			return 0;
  801763:	b8 00 00 00 00       	mov    $0x0,%eax
  801768:	eb f2                	jmp    80175c <dev_lookup+0x4d>

0080176a <fd_close>:
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	57                   	push   %edi
  80176e:	56                   	push   %esi
  80176f:	53                   	push   %ebx
  801770:	83 ec 24             	sub    $0x24,%esp
  801773:	8b 75 08             	mov    0x8(%ebp),%esi
  801776:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801779:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80177c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80177d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801783:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801786:	50                   	push   %eax
  801787:	e8 33 ff ff ff       	call   8016bf <fd_lookup>
  80178c:	89 c3                	mov    %eax,%ebx
  80178e:	83 c4 10             	add    $0x10,%esp
  801791:	85 c0                	test   %eax,%eax
  801793:	78 05                	js     80179a <fd_close+0x30>
	    || fd != fd2)
  801795:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801798:	74 16                	je     8017b0 <fd_close+0x46>
		return (must_exist ? r : 0);
  80179a:	89 f8                	mov    %edi,%eax
  80179c:	84 c0                	test   %al,%al
  80179e:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a3:	0f 44 d8             	cmove  %eax,%ebx
}
  8017a6:	89 d8                	mov    %ebx,%eax
  8017a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017ab:	5b                   	pop    %ebx
  8017ac:	5e                   	pop    %esi
  8017ad:	5f                   	pop    %edi
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017b0:	83 ec 08             	sub    $0x8,%esp
  8017b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017b6:	50                   	push   %eax
  8017b7:	ff 36                	pushl  (%esi)
  8017b9:	e8 51 ff ff ff       	call   80170f <dev_lookup>
  8017be:	89 c3                	mov    %eax,%ebx
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	78 1a                	js     8017e1 <fd_close+0x77>
		if (dev->dev_close)
  8017c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017ca:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8017cd:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	74 0b                	je     8017e1 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	56                   	push   %esi
  8017da:	ff d0                	call   *%eax
  8017dc:	89 c3                	mov    %eax,%ebx
  8017de:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8017e1:	83 ec 08             	sub    $0x8,%esp
  8017e4:	56                   	push   %esi
  8017e5:	6a 00                	push   $0x0
  8017e7:	e8 27 f6 ff ff       	call   800e13 <sys_page_unmap>
	return r;
  8017ec:	83 c4 10             	add    $0x10,%esp
  8017ef:	eb b5                	jmp    8017a6 <fd_close+0x3c>

008017f1 <close>:

int
close(int fdnum)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017fa:	50                   	push   %eax
  8017fb:	ff 75 08             	pushl  0x8(%ebp)
  8017fe:	e8 bc fe ff ff       	call   8016bf <fd_lookup>
  801803:	83 c4 10             	add    $0x10,%esp
  801806:	85 c0                	test   %eax,%eax
  801808:	79 02                	jns    80180c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    
		return fd_close(fd, 1);
  80180c:	83 ec 08             	sub    $0x8,%esp
  80180f:	6a 01                	push   $0x1
  801811:	ff 75 f4             	pushl  -0xc(%ebp)
  801814:	e8 51 ff ff ff       	call   80176a <fd_close>
  801819:	83 c4 10             	add    $0x10,%esp
  80181c:	eb ec                	jmp    80180a <close+0x19>

0080181e <close_all>:

void
close_all(void)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	53                   	push   %ebx
  801822:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801825:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80182a:	83 ec 0c             	sub    $0xc,%esp
  80182d:	53                   	push   %ebx
  80182e:	e8 be ff ff ff       	call   8017f1 <close>
	for (i = 0; i < MAXFD; i++)
  801833:	83 c3 01             	add    $0x1,%ebx
  801836:	83 c4 10             	add    $0x10,%esp
  801839:	83 fb 20             	cmp    $0x20,%ebx
  80183c:	75 ec                	jne    80182a <close_all+0xc>
}
  80183e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	57                   	push   %edi
  801847:	56                   	push   %esi
  801848:	53                   	push   %ebx
  801849:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80184c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80184f:	50                   	push   %eax
  801850:	ff 75 08             	pushl  0x8(%ebp)
  801853:	e8 67 fe ff ff       	call   8016bf <fd_lookup>
  801858:	89 c3                	mov    %eax,%ebx
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	85 c0                	test   %eax,%eax
  80185f:	0f 88 81 00 00 00    	js     8018e6 <dup+0xa3>
		return r;
	close(newfdnum);
  801865:	83 ec 0c             	sub    $0xc,%esp
  801868:	ff 75 0c             	pushl  0xc(%ebp)
  80186b:	e8 81 ff ff ff       	call   8017f1 <close>

	newfd = INDEX2FD(newfdnum);
  801870:	8b 75 0c             	mov    0xc(%ebp),%esi
  801873:	c1 e6 0c             	shl    $0xc,%esi
  801876:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80187c:	83 c4 04             	add    $0x4,%esp
  80187f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801882:	e8 cf fd ff ff       	call   801656 <fd2data>
  801887:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801889:	89 34 24             	mov    %esi,(%esp)
  80188c:	e8 c5 fd ff ff       	call   801656 <fd2data>
  801891:	83 c4 10             	add    $0x10,%esp
  801894:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801896:	89 d8                	mov    %ebx,%eax
  801898:	c1 e8 16             	shr    $0x16,%eax
  80189b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018a2:	a8 01                	test   $0x1,%al
  8018a4:	74 11                	je     8018b7 <dup+0x74>
  8018a6:	89 d8                	mov    %ebx,%eax
  8018a8:	c1 e8 0c             	shr    $0xc,%eax
  8018ab:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018b2:	f6 c2 01             	test   $0x1,%dl
  8018b5:	75 39                	jne    8018f0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018ba:	89 d0                	mov    %edx,%eax
  8018bc:	c1 e8 0c             	shr    $0xc,%eax
  8018bf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018c6:	83 ec 0c             	sub    $0xc,%esp
  8018c9:	25 07 0e 00 00       	and    $0xe07,%eax
  8018ce:	50                   	push   %eax
  8018cf:	56                   	push   %esi
  8018d0:	6a 00                	push   $0x0
  8018d2:	52                   	push   %edx
  8018d3:	6a 00                	push   $0x0
  8018d5:	e8 f7 f4 ff ff       	call   800dd1 <sys_page_map>
  8018da:	89 c3                	mov    %eax,%ebx
  8018dc:	83 c4 20             	add    $0x20,%esp
  8018df:	85 c0                	test   %eax,%eax
  8018e1:	78 31                	js     801914 <dup+0xd1>
		goto err;

	return newfdnum;
  8018e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018e6:	89 d8                	mov    %ebx,%eax
  8018e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018eb:	5b                   	pop    %ebx
  8018ec:	5e                   	pop    %esi
  8018ed:	5f                   	pop    %edi
  8018ee:	5d                   	pop    %ebp
  8018ef:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018f0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018f7:	83 ec 0c             	sub    $0xc,%esp
  8018fa:	25 07 0e 00 00       	and    $0xe07,%eax
  8018ff:	50                   	push   %eax
  801900:	57                   	push   %edi
  801901:	6a 00                	push   $0x0
  801903:	53                   	push   %ebx
  801904:	6a 00                	push   $0x0
  801906:	e8 c6 f4 ff ff       	call   800dd1 <sys_page_map>
  80190b:	89 c3                	mov    %eax,%ebx
  80190d:	83 c4 20             	add    $0x20,%esp
  801910:	85 c0                	test   %eax,%eax
  801912:	79 a3                	jns    8018b7 <dup+0x74>
	sys_page_unmap(0, newfd);
  801914:	83 ec 08             	sub    $0x8,%esp
  801917:	56                   	push   %esi
  801918:	6a 00                	push   $0x0
  80191a:	e8 f4 f4 ff ff       	call   800e13 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80191f:	83 c4 08             	add    $0x8,%esp
  801922:	57                   	push   %edi
  801923:	6a 00                	push   $0x0
  801925:	e8 e9 f4 ff ff       	call   800e13 <sys_page_unmap>
	return r;
  80192a:	83 c4 10             	add    $0x10,%esp
  80192d:	eb b7                	jmp    8018e6 <dup+0xa3>

0080192f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	53                   	push   %ebx
  801933:	83 ec 1c             	sub    $0x1c,%esp
  801936:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801939:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80193c:	50                   	push   %eax
  80193d:	53                   	push   %ebx
  80193e:	e8 7c fd ff ff       	call   8016bf <fd_lookup>
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	85 c0                	test   %eax,%eax
  801948:	78 3f                	js     801989 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80194a:	83 ec 08             	sub    $0x8,%esp
  80194d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801950:	50                   	push   %eax
  801951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801954:	ff 30                	pushl  (%eax)
  801956:	e8 b4 fd ff ff       	call   80170f <dev_lookup>
  80195b:	83 c4 10             	add    $0x10,%esp
  80195e:	85 c0                	test   %eax,%eax
  801960:	78 27                	js     801989 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801962:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801965:	8b 42 08             	mov    0x8(%edx),%eax
  801968:	83 e0 03             	and    $0x3,%eax
  80196b:	83 f8 01             	cmp    $0x1,%eax
  80196e:	74 1e                	je     80198e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801973:	8b 40 08             	mov    0x8(%eax),%eax
  801976:	85 c0                	test   %eax,%eax
  801978:	74 35                	je     8019af <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80197a:	83 ec 04             	sub    $0x4,%esp
  80197d:	ff 75 10             	pushl  0x10(%ebp)
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	52                   	push   %edx
  801984:	ff d0                	call   *%eax
  801986:	83 c4 10             	add    $0x10,%esp
}
  801989:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80198e:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801993:	8b 40 48             	mov    0x48(%eax),%eax
  801996:	83 ec 04             	sub    $0x4,%esp
  801999:	53                   	push   %ebx
  80199a:	50                   	push   %eax
  80199b:	68 85 30 80 00       	push   $0x803085
  8019a0:	e8 98 e8 ff ff       	call   80023d <cprintf>
		return -E_INVAL;
  8019a5:	83 c4 10             	add    $0x10,%esp
  8019a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019ad:	eb da                	jmp    801989 <read+0x5a>
		return -E_NOT_SUPP;
  8019af:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019b4:	eb d3                	jmp    801989 <read+0x5a>

008019b6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	57                   	push   %edi
  8019ba:	56                   	push   %esi
  8019bb:	53                   	push   %ebx
  8019bc:	83 ec 0c             	sub    $0xc,%esp
  8019bf:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019c2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019ca:	39 f3                	cmp    %esi,%ebx
  8019cc:	73 23                	jae    8019f1 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019ce:	83 ec 04             	sub    $0x4,%esp
  8019d1:	89 f0                	mov    %esi,%eax
  8019d3:	29 d8                	sub    %ebx,%eax
  8019d5:	50                   	push   %eax
  8019d6:	89 d8                	mov    %ebx,%eax
  8019d8:	03 45 0c             	add    0xc(%ebp),%eax
  8019db:	50                   	push   %eax
  8019dc:	57                   	push   %edi
  8019dd:	e8 4d ff ff ff       	call   80192f <read>
		if (m < 0)
  8019e2:	83 c4 10             	add    $0x10,%esp
  8019e5:	85 c0                	test   %eax,%eax
  8019e7:	78 06                	js     8019ef <readn+0x39>
			return m;
		if (m == 0)
  8019e9:	74 06                	je     8019f1 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8019eb:	01 c3                	add    %eax,%ebx
  8019ed:	eb db                	jmp    8019ca <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019ef:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019f1:	89 d8                	mov    %ebx,%eax
  8019f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019f6:	5b                   	pop    %ebx
  8019f7:	5e                   	pop    %esi
  8019f8:	5f                   	pop    %edi
  8019f9:	5d                   	pop    %ebp
  8019fa:	c3                   	ret    

008019fb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	53                   	push   %ebx
  8019ff:	83 ec 1c             	sub    $0x1c,%esp
  801a02:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a05:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a08:	50                   	push   %eax
  801a09:	53                   	push   %ebx
  801a0a:	e8 b0 fc ff ff       	call   8016bf <fd_lookup>
  801a0f:	83 c4 10             	add    $0x10,%esp
  801a12:	85 c0                	test   %eax,%eax
  801a14:	78 3a                	js     801a50 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a16:	83 ec 08             	sub    $0x8,%esp
  801a19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1c:	50                   	push   %eax
  801a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a20:	ff 30                	pushl  (%eax)
  801a22:	e8 e8 fc ff ff       	call   80170f <dev_lookup>
  801a27:	83 c4 10             	add    $0x10,%esp
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 22                	js     801a50 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a31:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a35:	74 1e                	je     801a55 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a3a:	8b 52 0c             	mov    0xc(%edx),%edx
  801a3d:	85 d2                	test   %edx,%edx
  801a3f:	74 35                	je     801a76 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a41:	83 ec 04             	sub    $0x4,%esp
  801a44:	ff 75 10             	pushl  0x10(%ebp)
  801a47:	ff 75 0c             	pushl  0xc(%ebp)
  801a4a:	50                   	push   %eax
  801a4b:	ff d2                	call   *%edx
  801a4d:	83 c4 10             	add    $0x10,%esp
}
  801a50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a55:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801a5a:	8b 40 48             	mov    0x48(%eax),%eax
  801a5d:	83 ec 04             	sub    $0x4,%esp
  801a60:	53                   	push   %ebx
  801a61:	50                   	push   %eax
  801a62:	68 a1 30 80 00       	push   $0x8030a1
  801a67:	e8 d1 e7 ff ff       	call   80023d <cprintf>
		return -E_INVAL;
  801a6c:	83 c4 10             	add    $0x10,%esp
  801a6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a74:	eb da                	jmp    801a50 <write+0x55>
		return -E_NOT_SUPP;
  801a76:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a7b:	eb d3                	jmp    801a50 <write+0x55>

00801a7d <seek>:

int
seek(int fdnum, off_t offset)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a86:	50                   	push   %eax
  801a87:	ff 75 08             	pushl  0x8(%ebp)
  801a8a:	e8 30 fc ff ff       	call   8016bf <fd_lookup>
  801a8f:	83 c4 10             	add    $0x10,%esp
  801a92:	85 c0                	test   %eax,%eax
  801a94:	78 0e                	js     801aa4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	53                   	push   %ebx
  801aaa:	83 ec 1c             	sub    $0x1c,%esp
  801aad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ab0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ab3:	50                   	push   %eax
  801ab4:	53                   	push   %ebx
  801ab5:	e8 05 fc ff ff       	call   8016bf <fd_lookup>
  801aba:	83 c4 10             	add    $0x10,%esp
  801abd:	85 c0                	test   %eax,%eax
  801abf:	78 37                	js     801af8 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ac1:	83 ec 08             	sub    $0x8,%esp
  801ac4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ac7:	50                   	push   %eax
  801ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801acb:	ff 30                	pushl  (%eax)
  801acd:	e8 3d fc ff ff       	call   80170f <dev_lookup>
  801ad2:	83 c4 10             	add    $0x10,%esp
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	78 1f                	js     801af8 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801adc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ae0:	74 1b                	je     801afd <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801ae2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ae5:	8b 52 18             	mov    0x18(%edx),%edx
  801ae8:	85 d2                	test   %edx,%edx
  801aea:	74 32                	je     801b1e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801aec:	83 ec 08             	sub    $0x8,%esp
  801aef:	ff 75 0c             	pushl  0xc(%ebp)
  801af2:	50                   	push   %eax
  801af3:	ff d2                	call   *%edx
  801af5:	83 c4 10             	add    $0x10,%esp
}
  801af8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    
			thisenv->env_id, fdnum);
  801afd:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b02:	8b 40 48             	mov    0x48(%eax),%eax
  801b05:	83 ec 04             	sub    $0x4,%esp
  801b08:	53                   	push   %ebx
  801b09:	50                   	push   %eax
  801b0a:	68 64 30 80 00       	push   $0x803064
  801b0f:	e8 29 e7 ff ff       	call   80023d <cprintf>
		return -E_INVAL;
  801b14:	83 c4 10             	add    $0x10,%esp
  801b17:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b1c:	eb da                	jmp    801af8 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b1e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b23:	eb d3                	jmp    801af8 <ftruncate+0x52>

00801b25 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
  801b28:	53                   	push   %ebx
  801b29:	83 ec 1c             	sub    $0x1c,%esp
  801b2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b2f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b32:	50                   	push   %eax
  801b33:	ff 75 08             	pushl  0x8(%ebp)
  801b36:	e8 84 fb ff ff       	call   8016bf <fd_lookup>
  801b3b:	83 c4 10             	add    $0x10,%esp
  801b3e:	85 c0                	test   %eax,%eax
  801b40:	78 4b                	js     801b8d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b42:	83 ec 08             	sub    $0x8,%esp
  801b45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b48:	50                   	push   %eax
  801b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4c:	ff 30                	pushl  (%eax)
  801b4e:	e8 bc fb ff ff       	call   80170f <dev_lookup>
  801b53:	83 c4 10             	add    $0x10,%esp
  801b56:	85 c0                	test   %eax,%eax
  801b58:	78 33                	js     801b8d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b61:	74 2f                	je     801b92 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b63:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b66:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b6d:	00 00 00 
	stat->st_isdir = 0;
  801b70:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b77:	00 00 00 
	stat->st_dev = dev;
  801b7a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b80:	83 ec 08             	sub    $0x8,%esp
  801b83:	53                   	push   %ebx
  801b84:	ff 75 f0             	pushl  -0x10(%ebp)
  801b87:	ff 50 14             	call   *0x14(%eax)
  801b8a:	83 c4 10             	add    $0x10,%esp
}
  801b8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    
		return -E_NOT_SUPP;
  801b92:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b97:	eb f4                	jmp    801b8d <fstat+0x68>

00801b99 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	56                   	push   %esi
  801b9d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b9e:	83 ec 08             	sub    $0x8,%esp
  801ba1:	6a 00                	push   $0x0
  801ba3:	ff 75 08             	pushl  0x8(%ebp)
  801ba6:	e8 22 02 00 00       	call   801dcd <open>
  801bab:	89 c3                	mov    %eax,%ebx
  801bad:	83 c4 10             	add    $0x10,%esp
  801bb0:	85 c0                	test   %eax,%eax
  801bb2:	78 1b                	js     801bcf <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801bb4:	83 ec 08             	sub    $0x8,%esp
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	50                   	push   %eax
  801bbb:	e8 65 ff ff ff       	call   801b25 <fstat>
  801bc0:	89 c6                	mov    %eax,%esi
	close(fd);
  801bc2:	89 1c 24             	mov    %ebx,(%esp)
  801bc5:	e8 27 fc ff ff       	call   8017f1 <close>
	return r;
  801bca:	83 c4 10             	add    $0x10,%esp
  801bcd:	89 f3                	mov    %esi,%ebx
}
  801bcf:	89 d8                	mov    %ebx,%eax
  801bd1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd4:	5b                   	pop    %ebx
  801bd5:	5e                   	pop    %esi
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    

00801bd8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	56                   	push   %esi
  801bdc:	53                   	push   %ebx
  801bdd:	89 c6                	mov    %eax,%esi
  801bdf:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801be1:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801be8:	74 27                	je     801c11 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bea:	6a 07                	push   $0x7
  801bec:	68 00 60 80 00       	push   $0x806000
  801bf1:	56                   	push   %esi
  801bf2:	ff 35 00 50 80 00    	pushl  0x805000
  801bf8:	e8 b6 f9 ff ff       	call   8015b3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bfd:	83 c4 0c             	add    $0xc,%esp
  801c00:	6a 00                	push   $0x0
  801c02:	53                   	push   %ebx
  801c03:	6a 00                	push   $0x0
  801c05:	e8 40 f9 ff ff       	call   80154a <ipc_recv>
}
  801c0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c0d:	5b                   	pop    %ebx
  801c0e:	5e                   	pop    %esi
  801c0f:	5d                   	pop    %ebp
  801c10:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c11:	83 ec 0c             	sub    $0xc,%esp
  801c14:	6a 01                	push   $0x1
  801c16:	e8 f0 f9 ff ff       	call   80160b <ipc_find_env>
  801c1b:	a3 00 50 80 00       	mov    %eax,0x805000
  801c20:	83 c4 10             	add    $0x10,%esp
  801c23:	eb c5                	jmp    801bea <fsipc+0x12>

00801c25 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	8b 40 0c             	mov    0xc(%eax),%eax
  801c31:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c39:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c43:	b8 02 00 00 00       	mov    $0x2,%eax
  801c48:	e8 8b ff ff ff       	call   801bd8 <fsipc>
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <devfile_flush>:
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	8b 40 0c             	mov    0xc(%eax),%eax
  801c5b:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c60:	ba 00 00 00 00       	mov    $0x0,%edx
  801c65:	b8 06 00 00 00       	mov    $0x6,%eax
  801c6a:	e8 69 ff ff ff       	call   801bd8 <fsipc>
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <devfile_stat>:
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	53                   	push   %ebx
  801c75:	83 ec 04             	sub    $0x4,%esp
  801c78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	8b 40 0c             	mov    0xc(%eax),%eax
  801c81:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c86:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8b:	b8 05 00 00 00       	mov    $0x5,%eax
  801c90:	e8 43 ff ff ff       	call   801bd8 <fsipc>
  801c95:	85 c0                	test   %eax,%eax
  801c97:	78 2c                	js     801cc5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c99:	83 ec 08             	sub    $0x8,%esp
  801c9c:	68 00 60 80 00       	push   $0x806000
  801ca1:	53                   	push   %ebx
  801ca2:	e8 f5 ec ff ff       	call   80099c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ca7:	a1 80 60 80 00       	mov    0x806080,%eax
  801cac:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cb2:	a1 84 60 80 00       	mov    0x806084,%eax
  801cb7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801cbd:	83 c4 10             	add    $0x10,%esp
  801cc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <devfile_write>:
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	53                   	push   %ebx
  801cce:	83 ec 08             	sub    $0x8,%esp
  801cd1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	8b 40 0c             	mov    0xc(%eax),%eax
  801cda:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801cdf:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ce5:	53                   	push   %ebx
  801ce6:	ff 75 0c             	pushl  0xc(%ebp)
  801ce9:	68 08 60 80 00       	push   $0x806008
  801cee:	e8 99 ee ff ff       	call   800b8c <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801cf3:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf8:	b8 04 00 00 00       	mov    $0x4,%eax
  801cfd:	e8 d6 fe ff ff       	call   801bd8 <fsipc>
  801d02:	83 c4 10             	add    $0x10,%esp
  801d05:	85 c0                	test   %eax,%eax
  801d07:	78 0b                	js     801d14 <devfile_write+0x4a>
	assert(r <= n);
  801d09:	39 d8                	cmp    %ebx,%eax
  801d0b:	77 0c                	ja     801d19 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d0d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d12:	7f 1e                	jg     801d32 <devfile_write+0x68>
}
  801d14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    
	assert(r <= n);
  801d19:	68 d4 30 80 00       	push   $0x8030d4
  801d1e:	68 db 30 80 00       	push   $0x8030db
  801d23:	68 98 00 00 00       	push   $0x98
  801d28:	68 f0 30 80 00       	push   $0x8030f0
  801d2d:	e8 6a 0a 00 00       	call   80279c <_panic>
	assert(r <= PGSIZE);
  801d32:	68 fb 30 80 00       	push   $0x8030fb
  801d37:	68 db 30 80 00       	push   $0x8030db
  801d3c:	68 99 00 00 00       	push   $0x99
  801d41:	68 f0 30 80 00       	push   $0x8030f0
  801d46:	e8 51 0a 00 00       	call   80279c <_panic>

00801d4b <devfile_read>:
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	56                   	push   %esi
  801d4f:	53                   	push   %ebx
  801d50:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d53:	8b 45 08             	mov    0x8(%ebp),%eax
  801d56:	8b 40 0c             	mov    0xc(%eax),%eax
  801d59:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d5e:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d64:	ba 00 00 00 00       	mov    $0x0,%edx
  801d69:	b8 03 00 00 00       	mov    $0x3,%eax
  801d6e:	e8 65 fe ff ff       	call   801bd8 <fsipc>
  801d73:	89 c3                	mov    %eax,%ebx
  801d75:	85 c0                	test   %eax,%eax
  801d77:	78 1f                	js     801d98 <devfile_read+0x4d>
	assert(r <= n);
  801d79:	39 f0                	cmp    %esi,%eax
  801d7b:	77 24                	ja     801da1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d7d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d82:	7f 33                	jg     801db7 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d84:	83 ec 04             	sub    $0x4,%esp
  801d87:	50                   	push   %eax
  801d88:	68 00 60 80 00       	push   $0x806000
  801d8d:	ff 75 0c             	pushl  0xc(%ebp)
  801d90:	e8 95 ed ff ff       	call   800b2a <memmove>
	return r;
  801d95:	83 c4 10             	add    $0x10,%esp
}
  801d98:	89 d8                	mov    %ebx,%eax
  801d9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d9d:	5b                   	pop    %ebx
  801d9e:	5e                   	pop    %esi
  801d9f:	5d                   	pop    %ebp
  801da0:	c3                   	ret    
	assert(r <= n);
  801da1:	68 d4 30 80 00       	push   $0x8030d4
  801da6:	68 db 30 80 00       	push   $0x8030db
  801dab:	6a 7c                	push   $0x7c
  801dad:	68 f0 30 80 00       	push   $0x8030f0
  801db2:	e8 e5 09 00 00       	call   80279c <_panic>
	assert(r <= PGSIZE);
  801db7:	68 fb 30 80 00       	push   $0x8030fb
  801dbc:	68 db 30 80 00       	push   $0x8030db
  801dc1:	6a 7d                	push   $0x7d
  801dc3:	68 f0 30 80 00       	push   $0x8030f0
  801dc8:	e8 cf 09 00 00       	call   80279c <_panic>

00801dcd <open>:
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	56                   	push   %esi
  801dd1:	53                   	push   %ebx
  801dd2:	83 ec 1c             	sub    $0x1c,%esp
  801dd5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801dd8:	56                   	push   %esi
  801dd9:	e8 85 eb ff ff       	call   800963 <strlen>
  801dde:	83 c4 10             	add    $0x10,%esp
  801de1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801de6:	7f 6c                	jg     801e54 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801de8:	83 ec 0c             	sub    $0xc,%esp
  801deb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dee:	50                   	push   %eax
  801def:	e8 79 f8 ff ff       	call   80166d <fd_alloc>
  801df4:	89 c3                	mov    %eax,%ebx
  801df6:	83 c4 10             	add    $0x10,%esp
  801df9:	85 c0                	test   %eax,%eax
  801dfb:	78 3c                	js     801e39 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801dfd:	83 ec 08             	sub    $0x8,%esp
  801e00:	56                   	push   %esi
  801e01:	68 00 60 80 00       	push   $0x806000
  801e06:	e8 91 eb ff ff       	call   80099c <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0e:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e16:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1b:	e8 b8 fd ff ff       	call   801bd8 <fsipc>
  801e20:	89 c3                	mov    %eax,%ebx
  801e22:	83 c4 10             	add    $0x10,%esp
  801e25:	85 c0                	test   %eax,%eax
  801e27:	78 19                	js     801e42 <open+0x75>
	return fd2num(fd);
  801e29:	83 ec 0c             	sub    $0xc,%esp
  801e2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2f:	e8 12 f8 ff ff       	call   801646 <fd2num>
  801e34:	89 c3                	mov    %eax,%ebx
  801e36:	83 c4 10             	add    $0x10,%esp
}
  801e39:	89 d8                	mov    %ebx,%eax
  801e3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e3e:	5b                   	pop    %ebx
  801e3f:	5e                   	pop    %esi
  801e40:	5d                   	pop    %ebp
  801e41:	c3                   	ret    
		fd_close(fd, 0);
  801e42:	83 ec 08             	sub    $0x8,%esp
  801e45:	6a 00                	push   $0x0
  801e47:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4a:	e8 1b f9 ff ff       	call   80176a <fd_close>
		return r;
  801e4f:	83 c4 10             	add    $0x10,%esp
  801e52:	eb e5                	jmp    801e39 <open+0x6c>
		return -E_BAD_PATH;
  801e54:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e59:	eb de                	jmp    801e39 <open+0x6c>

00801e5b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e61:	ba 00 00 00 00       	mov    $0x0,%edx
  801e66:	b8 08 00 00 00       	mov    $0x8,%eax
  801e6b:	e8 68 fd ff ff       	call   801bd8 <fsipc>
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e78:	68 07 31 80 00       	push   $0x803107
  801e7d:	ff 75 0c             	pushl  0xc(%ebp)
  801e80:	e8 17 eb ff ff       	call   80099c <strcpy>
	return 0;
}
  801e85:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <devsock_close>:
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	53                   	push   %ebx
  801e90:	83 ec 10             	sub    $0x10,%esp
  801e93:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e96:	53                   	push   %ebx
  801e97:	e8 f6 09 00 00       	call   802892 <pageref>
  801e9c:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e9f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ea4:	83 f8 01             	cmp    $0x1,%eax
  801ea7:	74 07                	je     801eb0 <devsock_close+0x24>
}
  801ea9:	89 d0                	mov    %edx,%eax
  801eab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801eb0:	83 ec 0c             	sub    $0xc,%esp
  801eb3:	ff 73 0c             	pushl  0xc(%ebx)
  801eb6:	e8 b9 02 00 00       	call   802174 <nsipc_close>
  801ebb:	89 c2                	mov    %eax,%edx
  801ebd:	83 c4 10             	add    $0x10,%esp
  801ec0:	eb e7                	jmp    801ea9 <devsock_close+0x1d>

00801ec2 <devsock_write>:
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ec8:	6a 00                	push   $0x0
  801eca:	ff 75 10             	pushl  0x10(%ebp)
  801ecd:	ff 75 0c             	pushl  0xc(%ebp)
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	ff 70 0c             	pushl  0xc(%eax)
  801ed6:	e8 76 03 00 00       	call   802251 <nsipc_send>
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <devsock_read>:
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ee3:	6a 00                	push   $0x0
  801ee5:	ff 75 10             	pushl  0x10(%ebp)
  801ee8:	ff 75 0c             	pushl  0xc(%ebp)
  801eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801eee:	ff 70 0c             	pushl  0xc(%eax)
  801ef1:	e8 ef 02 00 00       	call   8021e5 <nsipc_recv>
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <fd2sockid>:
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801efe:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f01:	52                   	push   %edx
  801f02:	50                   	push   %eax
  801f03:	e8 b7 f7 ff ff       	call   8016bf <fd_lookup>
  801f08:	83 c4 10             	add    $0x10,%esp
  801f0b:	85 c0                	test   %eax,%eax
  801f0d:	78 10                	js     801f1f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f12:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f18:	39 08                	cmp    %ecx,(%eax)
  801f1a:	75 05                	jne    801f21 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f1c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    
		return -E_NOT_SUPP;
  801f21:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f26:	eb f7                	jmp    801f1f <fd2sockid+0x27>

00801f28 <alloc_sockfd>:
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	56                   	push   %esi
  801f2c:	53                   	push   %ebx
  801f2d:	83 ec 1c             	sub    $0x1c,%esp
  801f30:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f32:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f35:	50                   	push   %eax
  801f36:	e8 32 f7 ff ff       	call   80166d <fd_alloc>
  801f3b:	89 c3                	mov    %eax,%ebx
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	85 c0                	test   %eax,%eax
  801f42:	78 43                	js     801f87 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f44:	83 ec 04             	sub    $0x4,%esp
  801f47:	68 07 04 00 00       	push   $0x407
  801f4c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4f:	6a 00                	push   $0x0
  801f51:	e8 38 ee ff ff       	call   800d8e <sys_page_alloc>
  801f56:	89 c3                	mov    %eax,%ebx
  801f58:	83 c4 10             	add    $0x10,%esp
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	78 28                	js     801f87 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f62:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f68:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f74:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f77:	83 ec 0c             	sub    $0xc,%esp
  801f7a:	50                   	push   %eax
  801f7b:	e8 c6 f6 ff ff       	call   801646 <fd2num>
  801f80:	89 c3                	mov    %eax,%ebx
  801f82:	83 c4 10             	add    $0x10,%esp
  801f85:	eb 0c                	jmp    801f93 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f87:	83 ec 0c             	sub    $0xc,%esp
  801f8a:	56                   	push   %esi
  801f8b:	e8 e4 01 00 00       	call   802174 <nsipc_close>
		return r;
  801f90:	83 c4 10             	add    $0x10,%esp
}
  801f93:	89 d8                	mov    %ebx,%eax
  801f95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f98:	5b                   	pop    %ebx
  801f99:	5e                   	pop    %esi
  801f9a:	5d                   	pop    %ebp
  801f9b:	c3                   	ret    

00801f9c <accept>:
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa5:	e8 4e ff ff ff       	call   801ef8 <fd2sockid>
  801faa:	85 c0                	test   %eax,%eax
  801fac:	78 1b                	js     801fc9 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fae:	83 ec 04             	sub    $0x4,%esp
  801fb1:	ff 75 10             	pushl  0x10(%ebp)
  801fb4:	ff 75 0c             	pushl  0xc(%ebp)
  801fb7:	50                   	push   %eax
  801fb8:	e8 0e 01 00 00       	call   8020cb <nsipc_accept>
  801fbd:	83 c4 10             	add    $0x10,%esp
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	78 05                	js     801fc9 <accept+0x2d>
	return alloc_sockfd(r);
  801fc4:	e8 5f ff ff ff       	call   801f28 <alloc_sockfd>
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <bind>:
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	e8 1f ff ff ff       	call   801ef8 <fd2sockid>
  801fd9:	85 c0                	test   %eax,%eax
  801fdb:	78 12                	js     801fef <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801fdd:	83 ec 04             	sub    $0x4,%esp
  801fe0:	ff 75 10             	pushl  0x10(%ebp)
  801fe3:	ff 75 0c             	pushl  0xc(%ebp)
  801fe6:	50                   	push   %eax
  801fe7:	e8 31 01 00 00       	call   80211d <nsipc_bind>
  801fec:	83 c4 10             	add    $0x10,%esp
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <shutdown>:
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	e8 f9 fe ff ff       	call   801ef8 <fd2sockid>
  801fff:	85 c0                	test   %eax,%eax
  802001:	78 0f                	js     802012 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802003:	83 ec 08             	sub    $0x8,%esp
  802006:	ff 75 0c             	pushl  0xc(%ebp)
  802009:	50                   	push   %eax
  80200a:	e8 43 01 00 00       	call   802152 <nsipc_shutdown>
  80200f:	83 c4 10             	add    $0x10,%esp
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <connect>:
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	e8 d6 fe ff ff       	call   801ef8 <fd2sockid>
  802022:	85 c0                	test   %eax,%eax
  802024:	78 12                	js     802038 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	ff 75 10             	pushl  0x10(%ebp)
  80202c:	ff 75 0c             	pushl  0xc(%ebp)
  80202f:	50                   	push   %eax
  802030:	e8 59 01 00 00       	call   80218e <nsipc_connect>
  802035:	83 c4 10             	add    $0x10,%esp
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <listen>:
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	e8 b0 fe ff ff       	call   801ef8 <fd2sockid>
  802048:	85 c0                	test   %eax,%eax
  80204a:	78 0f                	js     80205b <listen+0x21>
	return nsipc_listen(r, backlog);
  80204c:	83 ec 08             	sub    $0x8,%esp
  80204f:	ff 75 0c             	pushl  0xc(%ebp)
  802052:	50                   	push   %eax
  802053:	e8 6b 01 00 00       	call   8021c3 <nsipc_listen>
  802058:	83 c4 10             	add    $0x10,%esp
}
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <socket>:

int
socket(int domain, int type, int protocol)
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802063:	ff 75 10             	pushl  0x10(%ebp)
  802066:	ff 75 0c             	pushl  0xc(%ebp)
  802069:	ff 75 08             	pushl  0x8(%ebp)
  80206c:	e8 3e 02 00 00       	call   8022af <nsipc_socket>
  802071:	83 c4 10             	add    $0x10,%esp
  802074:	85 c0                	test   %eax,%eax
  802076:	78 05                	js     80207d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802078:	e8 ab fe ff ff       	call   801f28 <alloc_sockfd>
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	53                   	push   %ebx
  802083:	83 ec 04             	sub    $0x4,%esp
  802086:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802088:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80208f:	74 26                	je     8020b7 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802091:	6a 07                	push   $0x7
  802093:	68 00 70 80 00       	push   $0x807000
  802098:	53                   	push   %ebx
  802099:	ff 35 04 50 80 00    	pushl  0x805004
  80209f:	e8 0f f5 ff ff       	call   8015b3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020a4:	83 c4 0c             	add    $0xc,%esp
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	e8 98 f4 ff ff       	call   80154a <ipc_recv>
}
  8020b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020b7:	83 ec 0c             	sub    $0xc,%esp
  8020ba:	6a 02                	push   $0x2
  8020bc:	e8 4a f5 ff ff       	call   80160b <ipc_find_env>
  8020c1:	a3 04 50 80 00       	mov    %eax,0x805004
  8020c6:	83 c4 10             	add    $0x10,%esp
  8020c9:	eb c6                	jmp    802091 <nsipc+0x12>

008020cb <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	56                   	push   %esi
  8020cf:	53                   	push   %ebx
  8020d0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020db:	8b 06                	mov    (%esi),%eax
  8020dd:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e7:	e8 93 ff ff ff       	call   80207f <nsipc>
  8020ec:	89 c3                	mov    %eax,%ebx
  8020ee:	85 c0                	test   %eax,%eax
  8020f0:	79 09                	jns    8020fb <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8020f2:	89 d8                	mov    %ebx,%eax
  8020f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020f7:	5b                   	pop    %ebx
  8020f8:	5e                   	pop    %esi
  8020f9:	5d                   	pop    %ebp
  8020fa:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020fb:	83 ec 04             	sub    $0x4,%esp
  8020fe:	ff 35 10 70 80 00    	pushl  0x807010
  802104:	68 00 70 80 00       	push   $0x807000
  802109:	ff 75 0c             	pushl  0xc(%ebp)
  80210c:	e8 19 ea ff ff       	call   800b2a <memmove>
		*addrlen = ret->ret_addrlen;
  802111:	a1 10 70 80 00       	mov    0x807010,%eax
  802116:	89 06                	mov    %eax,(%esi)
  802118:	83 c4 10             	add    $0x10,%esp
	return r;
  80211b:	eb d5                	jmp    8020f2 <nsipc_accept+0x27>

0080211d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
  802120:	53                   	push   %ebx
  802121:	83 ec 08             	sub    $0x8,%esp
  802124:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80212f:	53                   	push   %ebx
  802130:	ff 75 0c             	pushl  0xc(%ebp)
  802133:	68 04 70 80 00       	push   $0x807004
  802138:	e8 ed e9 ff ff       	call   800b2a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80213d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802143:	b8 02 00 00 00       	mov    $0x2,%eax
  802148:	e8 32 ff ff ff       	call   80207f <nsipc>
}
  80214d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
  802155:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802160:	8b 45 0c             	mov    0xc(%ebp),%eax
  802163:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802168:	b8 03 00 00 00       	mov    $0x3,%eax
  80216d:	e8 0d ff ff ff       	call   80207f <nsipc>
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <nsipc_close>:

int
nsipc_close(int s)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802182:	b8 04 00 00 00       	mov    $0x4,%eax
  802187:	e8 f3 fe ff ff       	call   80207f <nsipc>
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	53                   	push   %ebx
  802192:	83 ec 08             	sub    $0x8,%esp
  802195:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021a0:	53                   	push   %ebx
  8021a1:	ff 75 0c             	pushl  0xc(%ebp)
  8021a4:	68 04 70 80 00       	push   $0x807004
  8021a9:	e8 7c e9 ff ff       	call   800b2a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021ae:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021b4:	b8 05 00 00 00       	mov    $0x5,%eax
  8021b9:	e8 c1 fe ff ff       	call   80207f <nsipc>
}
  8021be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d4:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021d9:	b8 06 00 00 00       	mov    $0x6,%eax
  8021de:	e8 9c fe ff ff       	call   80207f <nsipc>
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
  8021e8:	56                   	push   %esi
  8021e9:	53                   	push   %ebx
  8021ea:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021f5:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8021fe:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802203:	b8 07 00 00 00       	mov    $0x7,%eax
  802208:	e8 72 fe ff ff       	call   80207f <nsipc>
  80220d:	89 c3                	mov    %eax,%ebx
  80220f:	85 c0                	test   %eax,%eax
  802211:	78 1f                	js     802232 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802213:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802218:	7f 21                	jg     80223b <nsipc_recv+0x56>
  80221a:	39 c6                	cmp    %eax,%esi
  80221c:	7c 1d                	jl     80223b <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80221e:	83 ec 04             	sub    $0x4,%esp
  802221:	50                   	push   %eax
  802222:	68 00 70 80 00       	push   $0x807000
  802227:	ff 75 0c             	pushl  0xc(%ebp)
  80222a:	e8 fb e8 ff ff       	call   800b2a <memmove>
  80222f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802232:	89 d8                	mov    %ebx,%eax
  802234:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802237:	5b                   	pop    %ebx
  802238:	5e                   	pop    %esi
  802239:	5d                   	pop    %ebp
  80223a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80223b:	68 13 31 80 00       	push   $0x803113
  802240:	68 db 30 80 00       	push   $0x8030db
  802245:	6a 62                	push   $0x62
  802247:	68 28 31 80 00       	push   $0x803128
  80224c:	e8 4b 05 00 00       	call   80279c <_panic>

00802251 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
  802254:	53                   	push   %ebx
  802255:	83 ec 04             	sub    $0x4,%esp
  802258:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802263:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802269:	7f 2e                	jg     802299 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80226b:	83 ec 04             	sub    $0x4,%esp
  80226e:	53                   	push   %ebx
  80226f:	ff 75 0c             	pushl  0xc(%ebp)
  802272:	68 0c 70 80 00       	push   $0x80700c
  802277:	e8 ae e8 ff ff       	call   800b2a <memmove>
	nsipcbuf.send.req_size = size;
  80227c:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802282:	8b 45 14             	mov    0x14(%ebp),%eax
  802285:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80228a:	b8 08 00 00 00       	mov    $0x8,%eax
  80228f:	e8 eb fd ff ff       	call   80207f <nsipc>
}
  802294:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802297:	c9                   	leave  
  802298:	c3                   	ret    
	assert(size < 1600);
  802299:	68 34 31 80 00       	push   $0x803134
  80229e:	68 db 30 80 00       	push   $0x8030db
  8022a3:	6a 6d                	push   $0x6d
  8022a5:	68 28 31 80 00       	push   $0x803128
  8022aa:	e8 ed 04 00 00       	call   80279c <_panic>

008022af <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c0:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8022c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c8:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022cd:	b8 09 00 00 00       	mov    $0x9,%eax
  8022d2:	e8 a8 fd ff ff       	call   80207f <nsipc>
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	56                   	push   %esi
  8022dd:	53                   	push   %ebx
  8022de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8022e1:	83 ec 0c             	sub    $0xc,%esp
  8022e4:	ff 75 08             	pushl  0x8(%ebp)
  8022e7:	e8 6a f3 ff ff       	call   801656 <fd2data>
  8022ec:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8022ee:	83 c4 08             	add    $0x8,%esp
  8022f1:	68 40 31 80 00       	push   $0x803140
  8022f6:	53                   	push   %ebx
  8022f7:	e8 a0 e6 ff ff       	call   80099c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022fc:	8b 46 04             	mov    0x4(%esi),%eax
  8022ff:	2b 06                	sub    (%esi),%eax
  802301:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802307:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80230e:	00 00 00 
	stat->st_dev = &devpipe;
  802311:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802318:	40 80 00 
	return 0;
}
  80231b:	b8 00 00 00 00       	mov    $0x0,%eax
  802320:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802323:	5b                   	pop    %ebx
  802324:	5e                   	pop    %esi
  802325:	5d                   	pop    %ebp
  802326:	c3                   	ret    

00802327 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	53                   	push   %ebx
  80232b:	83 ec 0c             	sub    $0xc,%esp
  80232e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802331:	53                   	push   %ebx
  802332:	6a 00                	push   $0x0
  802334:	e8 da ea ff ff       	call   800e13 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802339:	89 1c 24             	mov    %ebx,(%esp)
  80233c:	e8 15 f3 ff ff       	call   801656 <fd2data>
  802341:	83 c4 08             	add    $0x8,%esp
  802344:	50                   	push   %eax
  802345:	6a 00                	push   $0x0
  802347:	e8 c7 ea ff ff       	call   800e13 <sys_page_unmap>
}
  80234c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80234f:	c9                   	leave  
  802350:	c3                   	ret    

00802351 <_pipeisclosed>:
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	57                   	push   %edi
  802355:	56                   	push   %esi
  802356:	53                   	push   %ebx
  802357:	83 ec 1c             	sub    $0x1c,%esp
  80235a:	89 c7                	mov    %eax,%edi
  80235c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80235e:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802363:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802366:	83 ec 0c             	sub    $0xc,%esp
  802369:	57                   	push   %edi
  80236a:	e8 23 05 00 00       	call   802892 <pageref>
  80236f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802372:	89 34 24             	mov    %esi,(%esp)
  802375:	e8 18 05 00 00       	call   802892 <pageref>
		nn = thisenv->env_runs;
  80237a:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  802380:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802383:	83 c4 10             	add    $0x10,%esp
  802386:	39 cb                	cmp    %ecx,%ebx
  802388:	74 1b                	je     8023a5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80238a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80238d:	75 cf                	jne    80235e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80238f:	8b 42 58             	mov    0x58(%edx),%eax
  802392:	6a 01                	push   $0x1
  802394:	50                   	push   %eax
  802395:	53                   	push   %ebx
  802396:	68 47 31 80 00       	push   $0x803147
  80239b:	e8 9d de ff ff       	call   80023d <cprintf>
  8023a0:	83 c4 10             	add    $0x10,%esp
  8023a3:	eb b9                	jmp    80235e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8023a5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023a8:	0f 94 c0             	sete   %al
  8023ab:	0f b6 c0             	movzbl %al,%eax
}
  8023ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023b1:	5b                   	pop    %ebx
  8023b2:	5e                   	pop    %esi
  8023b3:	5f                   	pop    %edi
  8023b4:	5d                   	pop    %ebp
  8023b5:	c3                   	ret    

008023b6 <devpipe_write>:
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
  8023b9:	57                   	push   %edi
  8023ba:	56                   	push   %esi
  8023bb:	53                   	push   %ebx
  8023bc:	83 ec 28             	sub    $0x28,%esp
  8023bf:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8023c2:	56                   	push   %esi
  8023c3:	e8 8e f2 ff ff       	call   801656 <fd2data>
  8023c8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023ca:	83 c4 10             	add    $0x10,%esp
  8023cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8023d2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023d5:	74 4f                	je     802426 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8023d7:	8b 43 04             	mov    0x4(%ebx),%eax
  8023da:	8b 0b                	mov    (%ebx),%ecx
  8023dc:	8d 51 20             	lea    0x20(%ecx),%edx
  8023df:	39 d0                	cmp    %edx,%eax
  8023e1:	72 14                	jb     8023f7 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8023e3:	89 da                	mov    %ebx,%edx
  8023e5:	89 f0                	mov    %esi,%eax
  8023e7:	e8 65 ff ff ff       	call   802351 <_pipeisclosed>
  8023ec:	85 c0                	test   %eax,%eax
  8023ee:	75 3b                	jne    80242b <devpipe_write+0x75>
			sys_yield();
  8023f0:	e8 7a e9 ff ff       	call   800d6f <sys_yield>
  8023f5:	eb e0                	jmp    8023d7 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023fa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8023fe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802401:	89 c2                	mov    %eax,%edx
  802403:	c1 fa 1f             	sar    $0x1f,%edx
  802406:	89 d1                	mov    %edx,%ecx
  802408:	c1 e9 1b             	shr    $0x1b,%ecx
  80240b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80240e:	83 e2 1f             	and    $0x1f,%edx
  802411:	29 ca                	sub    %ecx,%edx
  802413:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802417:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80241b:	83 c0 01             	add    $0x1,%eax
  80241e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802421:	83 c7 01             	add    $0x1,%edi
  802424:	eb ac                	jmp    8023d2 <devpipe_write+0x1c>
	return i;
  802426:	8b 45 10             	mov    0x10(%ebp),%eax
  802429:	eb 05                	jmp    802430 <devpipe_write+0x7a>
				return 0;
  80242b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802430:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802433:	5b                   	pop    %ebx
  802434:	5e                   	pop    %esi
  802435:	5f                   	pop    %edi
  802436:	5d                   	pop    %ebp
  802437:	c3                   	ret    

00802438 <devpipe_read>:
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	57                   	push   %edi
  80243c:	56                   	push   %esi
  80243d:	53                   	push   %ebx
  80243e:	83 ec 18             	sub    $0x18,%esp
  802441:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802444:	57                   	push   %edi
  802445:	e8 0c f2 ff ff       	call   801656 <fd2data>
  80244a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80244c:	83 c4 10             	add    $0x10,%esp
  80244f:	be 00 00 00 00       	mov    $0x0,%esi
  802454:	3b 75 10             	cmp    0x10(%ebp),%esi
  802457:	75 14                	jne    80246d <devpipe_read+0x35>
	return i;
  802459:	8b 45 10             	mov    0x10(%ebp),%eax
  80245c:	eb 02                	jmp    802460 <devpipe_read+0x28>
				return i;
  80245e:	89 f0                	mov    %esi,%eax
}
  802460:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802463:	5b                   	pop    %ebx
  802464:	5e                   	pop    %esi
  802465:	5f                   	pop    %edi
  802466:	5d                   	pop    %ebp
  802467:	c3                   	ret    
			sys_yield();
  802468:	e8 02 e9 ff ff       	call   800d6f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80246d:	8b 03                	mov    (%ebx),%eax
  80246f:	3b 43 04             	cmp    0x4(%ebx),%eax
  802472:	75 18                	jne    80248c <devpipe_read+0x54>
			if (i > 0)
  802474:	85 f6                	test   %esi,%esi
  802476:	75 e6                	jne    80245e <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802478:	89 da                	mov    %ebx,%edx
  80247a:	89 f8                	mov    %edi,%eax
  80247c:	e8 d0 fe ff ff       	call   802351 <_pipeisclosed>
  802481:	85 c0                	test   %eax,%eax
  802483:	74 e3                	je     802468 <devpipe_read+0x30>
				return 0;
  802485:	b8 00 00 00 00       	mov    $0x0,%eax
  80248a:	eb d4                	jmp    802460 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80248c:	99                   	cltd   
  80248d:	c1 ea 1b             	shr    $0x1b,%edx
  802490:	01 d0                	add    %edx,%eax
  802492:	83 e0 1f             	and    $0x1f,%eax
  802495:	29 d0                	sub    %edx,%eax
  802497:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80249c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80249f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024a2:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8024a5:	83 c6 01             	add    $0x1,%esi
  8024a8:	eb aa                	jmp    802454 <devpipe_read+0x1c>

008024aa <pipe>:
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	56                   	push   %esi
  8024ae:	53                   	push   %ebx
  8024af:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8024b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024b5:	50                   	push   %eax
  8024b6:	e8 b2 f1 ff ff       	call   80166d <fd_alloc>
  8024bb:	89 c3                	mov    %eax,%ebx
  8024bd:	83 c4 10             	add    $0x10,%esp
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	0f 88 23 01 00 00    	js     8025eb <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024c8:	83 ec 04             	sub    $0x4,%esp
  8024cb:	68 07 04 00 00       	push   $0x407
  8024d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8024d3:	6a 00                	push   $0x0
  8024d5:	e8 b4 e8 ff ff       	call   800d8e <sys_page_alloc>
  8024da:	89 c3                	mov    %eax,%ebx
  8024dc:	83 c4 10             	add    $0x10,%esp
  8024df:	85 c0                	test   %eax,%eax
  8024e1:	0f 88 04 01 00 00    	js     8025eb <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8024e7:	83 ec 0c             	sub    $0xc,%esp
  8024ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024ed:	50                   	push   %eax
  8024ee:	e8 7a f1 ff ff       	call   80166d <fd_alloc>
  8024f3:	89 c3                	mov    %eax,%ebx
  8024f5:	83 c4 10             	add    $0x10,%esp
  8024f8:	85 c0                	test   %eax,%eax
  8024fa:	0f 88 db 00 00 00    	js     8025db <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802500:	83 ec 04             	sub    $0x4,%esp
  802503:	68 07 04 00 00       	push   $0x407
  802508:	ff 75 f0             	pushl  -0x10(%ebp)
  80250b:	6a 00                	push   $0x0
  80250d:	e8 7c e8 ff ff       	call   800d8e <sys_page_alloc>
  802512:	89 c3                	mov    %eax,%ebx
  802514:	83 c4 10             	add    $0x10,%esp
  802517:	85 c0                	test   %eax,%eax
  802519:	0f 88 bc 00 00 00    	js     8025db <pipe+0x131>
	va = fd2data(fd0);
  80251f:	83 ec 0c             	sub    $0xc,%esp
  802522:	ff 75 f4             	pushl  -0xc(%ebp)
  802525:	e8 2c f1 ff ff       	call   801656 <fd2data>
  80252a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80252c:	83 c4 0c             	add    $0xc,%esp
  80252f:	68 07 04 00 00       	push   $0x407
  802534:	50                   	push   %eax
  802535:	6a 00                	push   $0x0
  802537:	e8 52 e8 ff ff       	call   800d8e <sys_page_alloc>
  80253c:	89 c3                	mov    %eax,%ebx
  80253e:	83 c4 10             	add    $0x10,%esp
  802541:	85 c0                	test   %eax,%eax
  802543:	0f 88 82 00 00 00    	js     8025cb <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802549:	83 ec 0c             	sub    $0xc,%esp
  80254c:	ff 75 f0             	pushl  -0x10(%ebp)
  80254f:	e8 02 f1 ff ff       	call   801656 <fd2data>
  802554:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80255b:	50                   	push   %eax
  80255c:	6a 00                	push   $0x0
  80255e:	56                   	push   %esi
  80255f:	6a 00                	push   $0x0
  802561:	e8 6b e8 ff ff       	call   800dd1 <sys_page_map>
  802566:	89 c3                	mov    %eax,%ebx
  802568:	83 c4 20             	add    $0x20,%esp
  80256b:	85 c0                	test   %eax,%eax
  80256d:	78 4e                	js     8025bd <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80256f:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802574:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802577:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802579:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802583:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802586:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802592:	83 ec 0c             	sub    $0xc,%esp
  802595:	ff 75 f4             	pushl  -0xc(%ebp)
  802598:	e8 a9 f0 ff ff       	call   801646 <fd2num>
  80259d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025a0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025a2:	83 c4 04             	add    $0x4,%esp
  8025a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8025a8:	e8 99 f0 ff ff       	call   801646 <fd2num>
  8025ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025b0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025b3:	83 c4 10             	add    $0x10,%esp
  8025b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025bb:	eb 2e                	jmp    8025eb <pipe+0x141>
	sys_page_unmap(0, va);
  8025bd:	83 ec 08             	sub    $0x8,%esp
  8025c0:	56                   	push   %esi
  8025c1:	6a 00                	push   $0x0
  8025c3:	e8 4b e8 ff ff       	call   800e13 <sys_page_unmap>
  8025c8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8025cb:	83 ec 08             	sub    $0x8,%esp
  8025ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8025d1:	6a 00                	push   $0x0
  8025d3:	e8 3b e8 ff ff       	call   800e13 <sys_page_unmap>
  8025d8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8025db:	83 ec 08             	sub    $0x8,%esp
  8025de:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e1:	6a 00                	push   $0x0
  8025e3:	e8 2b e8 ff ff       	call   800e13 <sys_page_unmap>
  8025e8:	83 c4 10             	add    $0x10,%esp
}
  8025eb:	89 d8                	mov    %ebx,%eax
  8025ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025f0:	5b                   	pop    %ebx
  8025f1:	5e                   	pop    %esi
  8025f2:	5d                   	pop    %ebp
  8025f3:	c3                   	ret    

008025f4 <pipeisclosed>:
{
  8025f4:	55                   	push   %ebp
  8025f5:	89 e5                	mov    %esp,%ebp
  8025f7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025fd:	50                   	push   %eax
  8025fe:	ff 75 08             	pushl  0x8(%ebp)
  802601:	e8 b9 f0 ff ff       	call   8016bf <fd_lookup>
  802606:	83 c4 10             	add    $0x10,%esp
  802609:	85 c0                	test   %eax,%eax
  80260b:	78 18                	js     802625 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80260d:	83 ec 0c             	sub    $0xc,%esp
  802610:	ff 75 f4             	pushl  -0xc(%ebp)
  802613:	e8 3e f0 ff ff       	call   801656 <fd2data>
	return _pipeisclosed(fd, p);
  802618:	89 c2                	mov    %eax,%edx
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	e8 2f fd ff ff       	call   802351 <_pipeisclosed>
  802622:	83 c4 10             	add    $0x10,%esp
}
  802625:	c9                   	leave  
  802626:	c3                   	ret    

00802627 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802627:	b8 00 00 00 00       	mov    $0x0,%eax
  80262c:	c3                   	ret    

0080262d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80262d:	55                   	push   %ebp
  80262e:	89 e5                	mov    %esp,%ebp
  802630:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802633:	68 5f 31 80 00       	push   $0x80315f
  802638:	ff 75 0c             	pushl  0xc(%ebp)
  80263b:	e8 5c e3 ff ff       	call   80099c <strcpy>
	return 0;
}
  802640:	b8 00 00 00 00       	mov    $0x0,%eax
  802645:	c9                   	leave  
  802646:	c3                   	ret    

00802647 <devcons_write>:
{
  802647:	55                   	push   %ebp
  802648:	89 e5                	mov    %esp,%ebp
  80264a:	57                   	push   %edi
  80264b:	56                   	push   %esi
  80264c:	53                   	push   %ebx
  80264d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802653:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802658:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80265e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802661:	73 31                	jae    802694 <devcons_write+0x4d>
		m = n - tot;
  802663:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802666:	29 f3                	sub    %esi,%ebx
  802668:	83 fb 7f             	cmp    $0x7f,%ebx
  80266b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802670:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802673:	83 ec 04             	sub    $0x4,%esp
  802676:	53                   	push   %ebx
  802677:	89 f0                	mov    %esi,%eax
  802679:	03 45 0c             	add    0xc(%ebp),%eax
  80267c:	50                   	push   %eax
  80267d:	57                   	push   %edi
  80267e:	e8 a7 e4 ff ff       	call   800b2a <memmove>
		sys_cputs(buf, m);
  802683:	83 c4 08             	add    $0x8,%esp
  802686:	53                   	push   %ebx
  802687:	57                   	push   %edi
  802688:	e8 45 e6 ff ff       	call   800cd2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80268d:	01 de                	add    %ebx,%esi
  80268f:	83 c4 10             	add    $0x10,%esp
  802692:	eb ca                	jmp    80265e <devcons_write+0x17>
}
  802694:	89 f0                	mov    %esi,%eax
  802696:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802699:	5b                   	pop    %ebx
  80269a:	5e                   	pop    %esi
  80269b:	5f                   	pop    %edi
  80269c:	5d                   	pop    %ebp
  80269d:	c3                   	ret    

0080269e <devcons_read>:
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
  8026a1:	83 ec 08             	sub    $0x8,%esp
  8026a4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8026a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026ad:	74 21                	je     8026d0 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8026af:	e8 3c e6 ff ff       	call   800cf0 <sys_cgetc>
  8026b4:	85 c0                	test   %eax,%eax
  8026b6:	75 07                	jne    8026bf <devcons_read+0x21>
		sys_yield();
  8026b8:	e8 b2 e6 ff ff       	call   800d6f <sys_yield>
  8026bd:	eb f0                	jmp    8026af <devcons_read+0x11>
	if (c < 0)
  8026bf:	78 0f                	js     8026d0 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8026c1:	83 f8 04             	cmp    $0x4,%eax
  8026c4:	74 0c                	je     8026d2 <devcons_read+0x34>
	*(char*)vbuf = c;
  8026c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c9:	88 02                	mov    %al,(%edx)
	return 1;
  8026cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8026d0:	c9                   	leave  
  8026d1:	c3                   	ret    
		return 0;
  8026d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d7:	eb f7                	jmp    8026d0 <devcons_read+0x32>

008026d9 <cputchar>:
{
  8026d9:	55                   	push   %ebp
  8026da:	89 e5                	mov    %esp,%ebp
  8026dc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8026df:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8026e5:	6a 01                	push   $0x1
  8026e7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026ea:	50                   	push   %eax
  8026eb:	e8 e2 e5 ff ff       	call   800cd2 <sys_cputs>
}
  8026f0:	83 c4 10             	add    $0x10,%esp
  8026f3:	c9                   	leave  
  8026f4:	c3                   	ret    

008026f5 <getchar>:
{
  8026f5:	55                   	push   %ebp
  8026f6:	89 e5                	mov    %esp,%ebp
  8026f8:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8026fb:	6a 01                	push   $0x1
  8026fd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802700:	50                   	push   %eax
  802701:	6a 00                	push   $0x0
  802703:	e8 27 f2 ff ff       	call   80192f <read>
	if (r < 0)
  802708:	83 c4 10             	add    $0x10,%esp
  80270b:	85 c0                	test   %eax,%eax
  80270d:	78 06                	js     802715 <getchar+0x20>
	if (r < 1)
  80270f:	74 06                	je     802717 <getchar+0x22>
	return c;
  802711:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802715:	c9                   	leave  
  802716:	c3                   	ret    
		return -E_EOF;
  802717:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80271c:	eb f7                	jmp    802715 <getchar+0x20>

0080271e <iscons>:
{
  80271e:	55                   	push   %ebp
  80271f:	89 e5                	mov    %esp,%ebp
  802721:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802724:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802727:	50                   	push   %eax
  802728:	ff 75 08             	pushl  0x8(%ebp)
  80272b:	e8 8f ef ff ff       	call   8016bf <fd_lookup>
  802730:	83 c4 10             	add    $0x10,%esp
  802733:	85 c0                	test   %eax,%eax
  802735:	78 11                	js     802748 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802740:	39 10                	cmp    %edx,(%eax)
  802742:	0f 94 c0             	sete   %al
  802745:	0f b6 c0             	movzbl %al,%eax
}
  802748:	c9                   	leave  
  802749:	c3                   	ret    

0080274a <opencons>:
{
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
  80274d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802750:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802753:	50                   	push   %eax
  802754:	e8 14 ef ff ff       	call   80166d <fd_alloc>
  802759:	83 c4 10             	add    $0x10,%esp
  80275c:	85 c0                	test   %eax,%eax
  80275e:	78 3a                	js     80279a <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802760:	83 ec 04             	sub    $0x4,%esp
  802763:	68 07 04 00 00       	push   $0x407
  802768:	ff 75 f4             	pushl  -0xc(%ebp)
  80276b:	6a 00                	push   $0x0
  80276d:	e8 1c e6 ff ff       	call   800d8e <sys_page_alloc>
  802772:	83 c4 10             	add    $0x10,%esp
  802775:	85 c0                	test   %eax,%eax
  802777:	78 21                	js     80279a <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802782:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80278e:	83 ec 0c             	sub    $0xc,%esp
  802791:	50                   	push   %eax
  802792:	e8 af ee ff ff       	call   801646 <fd2num>
  802797:	83 c4 10             	add    $0x10,%esp
}
  80279a:	c9                   	leave  
  80279b:	c3                   	ret    

0080279c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80279c:	55                   	push   %ebp
  80279d:	89 e5                	mov    %esp,%ebp
  80279f:	56                   	push   %esi
  8027a0:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8027a1:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8027a6:	8b 40 48             	mov    0x48(%eax),%eax
  8027a9:	83 ec 04             	sub    $0x4,%esp
  8027ac:	68 90 31 80 00       	push   $0x803190
  8027b1:	50                   	push   %eax
  8027b2:	68 78 2b 80 00       	push   $0x802b78
  8027b7:	e8 81 da ff ff       	call   80023d <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8027bc:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8027bf:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8027c5:	e8 86 e5 ff ff       	call   800d50 <sys_getenvid>
  8027ca:	83 c4 04             	add    $0x4,%esp
  8027cd:	ff 75 0c             	pushl  0xc(%ebp)
  8027d0:	ff 75 08             	pushl  0x8(%ebp)
  8027d3:	56                   	push   %esi
  8027d4:	50                   	push   %eax
  8027d5:	68 6c 31 80 00       	push   $0x80316c
  8027da:	e8 5e da ff ff       	call   80023d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8027df:	83 c4 18             	add    $0x18,%esp
  8027e2:	53                   	push   %ebx
  8027e3:	ff 75 10             	pushl  0x10(%ebp)
  8027e6:	e8 01 da ff ff       	call   8001ec <vcprintf>
	cprintf("\n");
  8027eb:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  8027f2:	e8 46 da ff ff       	call   80023d <cprintf>
  8027f7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8027fa:	cc                   	int3   
  8027fb:	eb fd                	jmp    8027fa <_panic+0x5e>

008027fd <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8027fd:	55                   	push   %ebp
  8027fe:	89 e5                	mov    %esp,%ebp
  802800:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802803:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80280a:	74 0a                	je     802816 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80280c:	8b 45 08             	mov    0x8(%ebp),%eax
  80280f:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802814:	c9                   	leave  
  802815:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802816:	83 ec 04             	sub    $0x4,%esp
  802819:	6a 07                	push   $0x7
  80281b:	68 00 f0 bf ee       	push   $0xeebff000
  802820:	6a 00                	push   $0x0
  802822:	e8 67 e5 ff ff       	call   800d8e <sys_page_alloc>
		if(r < 0)
  802827:	83 c4 10             	add    $0x10,%esp
  80282a:	85 c0                	test   %eax,%eax
  80282c:	78 2a                	js     802858 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80282e:	83 ec 08             	sub    $0x8,%esp
  802831:	68 6c 28 80 00       	push   $0x80286c
  802836:	6a 00                	push   $0x0
  802838:	e8 9c e6 ff ff       	call   800ed9 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80283d:	83 c4 10             	add    $0x10,%esp
  802840:	85 c0                	test   %eax,%eax
  802842:	79 c8                	jns    80280c <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802844:	83 ec 04             	sub    $0x4,%esp
  802847:	68 c8 31 80 00       	push   $0x8031c8
  80284c:	6a 25                	push   $0x25
  80284e:	68 04 32 80 00       	push   $0x803204
  802853:	e8 44 ff ff ff       	call   80279c <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802858:	83 ec 04             	sub    $0x4,%esp
  80285b:	68 98 31 80 00       	push   $0x803198
  802860:	6a 22                	push   $0x22
  802862:	68 04 32 80 00       	push   $0x803204
  802867:	e8 30 ff ff ff       	call   80279c <_panic>

0080286c <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80286c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80286d:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802872:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802874:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802877:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80287b:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80287f:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802882:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802884:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802888:	83 c4 08             	add    $0x8,%esp
	popal
  80288b:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80288c:	83 c4 04             	add    $0x4,%esp
	popfl
  80288f:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802890:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802891:	c3                   	ret    

00802892 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802892:	55                   	push   %ebp
  802893:	89 e5                	mov    %esp,%ebp
  802895:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802898:	89 d0                	mov    %edx,%eax
  80289a:	c1 e8 16             	shr    $0x16,%eax
  80289d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028a4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028a9:	f6 c1 01             	test   $0x1,%cl
  8028ac:	74 1d                	je     8028cb <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028ae:	c1 ea 0c             	shr    $0xc,%edx
  8028b1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028b8:	f6 c2 01             	test   $0x1,%dl
  8028bb:	74 0e                	je     8028cb <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028bd:	c1 ea 0c             	shr    $0xc,%edx
  8028c0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028c7:	ef 
  8028c8:	0f b7 c0             	movzwl %ax,%eax
}
  8028cb:	5d                   	pop    %ebp
  8028cc:	c3                   	ret    
  8028cd:	66 90                	xchg   %ax,%ax
  8028cf:	90                   	nop

008028d0 <__udivdi3>:
  8028d0:	55                   	push   %ebp
  8028d1:	57                   	push   %edi
  8028d2:	56                   	push   %esi
  8028d3:	53                   	push   %ebx
  8028d4:	83 ec 1c             	sub    $0x1c,%esp
  8028d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8028db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8028df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8028e7:	85 d2                	test   %edx,%edx
  8028e9:	75 4d                	jne    802938 <__udivdi3+0x68>
  8028eb:	39 f3                	cmp    %esi,%ebx
  8028ed:	76 19                	jbe    802908 <__udivdi3+0x38>
  8028ef:	31 ff                	xor    %edi,%edi
  8028f1:	89 e8                	mov    %ebp,%eax
  8028f3:	89 f2                	mov    %esi,%edx
  8028f5:	f7 f3                	div    %ebx
  8028f7:	89 fa                	mov    %edi,%edx
  8028f9:	83 c4 1c             	add    $0x1c,%esp
  8028fc:	5b                   	pop    %ebx
  8028fd:	5e                   	pop    %esi
  8028fe:	5f                   	pop    %edi
  8028ff:	5d                   	pop    %ebp
  802900:	c3                   	ret    
  802901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802908:	89 d9                	mov    %ebx,%ecx
  80290a:	85 db                	test   %ebx,%ebx
  80290c:	75 0b                	jne    802919 <__udivdi3+0x49>
  80290e:	b8 01 00 00 00       	mov    $0x1,%eax
  802913:	31 d2                	xor    %edx,%edx
  802915:	f7 f3                	div    %ebx
  802917:	89 c1                	mov    %eax,%ecx
  802919:	31 d2                	xor    %edx,%edx
  80291b:	89 f0                	mov    %esi,%eax
  80291d:	f7 f1                	div    %ecx
  80291f:	89 c6                	mov    %eax,%esi
  802921:	89 e8                	mov    %ebp,%eax
  802923:	89 f7                	mov    %esi,%edi
  802925:	f7 f1                	div    %ecx
  802927:	89 fa                	mov    %edi,%edx
  802929:	83 c4 1c             	add    $0x1c,%esp
  80292c:	5b                   	pop    %ebx
  80292d:	5e                   	pop    %esi
  80292e:	5f                   	pop    %edi
  80292f:	5d                   	pop    %ebp
  802930:	c3                   	ret    
  802931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802938:	39 f2                	cmp    %esi,%edx
  80293a:	77 1c                	ja     802958 <__udivdi3+0x88>
  80293c:	0f bd fa             	bsr    %edx,%edi
  80293f:	83 f7 1f             	xor    $0x1f,%edi
  802942:	75 2c                	jne    802970 <__udivdi3+0xa0>
  802944:	39 f2                	cmp    %esi,%edx
  802946:	72 06                	jb     80294e <__udivdi3+0x7e>
  802948:	31 c0                	xor    %eax,%eax
  80294a:	39 eb                	cmp    %ebp,%ebx
  80294c:	77 a9                	ja     8028f7 <__udivdi3+0x27>
  80294e:	b8 01 00 00 00       	mov    $0x1,%eax
  802953:	eb a2                	jmp    8028f7 <__udivdi3+0x27>
  802955:	8d 76 00             	lea    0x0(%esi),%esi
  802958:	31 ff                	xor    %edi,%edi
  80295a:	31 c0                	xor    %eax,%eax
  80295c:	89 fa                	mov    %edi,%edx
  80295e:	83 c4 1c             	add    $0x1c,%esp
  802961:	5b                   	pop    %ebx
  802962:	5e                   	pop    %esi
  802963:	5f                   	pop    %edi
  802964:	5d                   	pop    %ebp
  802965:	c3                   	ret    
  802966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80296d:	8d 76 00             	lea    0x0(%esi),%esi
  802970:	89 f9                	mov    %edi,%ecx
  802972:	b8 20 00 00 00       	mov    $0x20,%eax
  802977:	29 f8                	sub    %edi,%eax
  802979:	d3 e2                	shl    %cl,%edx
  80297b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80297f:	89 c1                	mov    %eax,%ecx
  802981:	89 da                	mov    %ebx,%edx
  802983:	d3 ea                	shr    %cl,%edx
  802985:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802989:	09 d1                	or     %edx,%ecx
  80298b:	89 f2                	mov    %esi,%edx
  80298d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802991:	89 f9                	mov    %edi,%ecx
  802993:	d3 e3                	shl    %cl,%ebx
  802995:	89 c1                	mov    %eax,%ecx
  802997:	d3 ea                	shr    %cl,%edx
  802999:	89 f9                	mov    %edi,%ecx
  80299b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80299f:	89 eb                	mov    %ebp,%ebx
  8029a1:	d3 e6                	shl    %cl,%esi
  8029a3:	89 c1                	mov    %eax,%ecx
  8029a5:	d3 eb                	shr    %cl,%ebx
  8029a7:	09 de                	or     %ebx,%esi
  8029a9:	89 f0                	mov    %esi,%eax
  8029ab:	f7 74 24 08          	divl   0x8(%esp)
  8029af:	89 d6                	mov    %edx,%esi
  8029b1:	89 c3                	mov    %eax,%ebx
  8029b3:	f7 64 24 0c          	mull   0xc(%esp)
  8029b7:	39 d6                	cmp    %edx,%esi
  8029b9:	72 15                	jb     8029d0 <__udivdi3+0x100>
  8029bb:	89 f9                	mov    %edi,%ecx
  8029bd:	d3 e5                	shl    %cl,%ebp
  8029bf:	39 c5                	cmp    %eax,%ebp
  8029c1:	73 04                	jae    8029c7 <__udivdi3+0xf7>
  8029c3:	39 d6                	cmp    %edx,%esi
  8029c5:	74 09                	je     8029d0 <__udivdi3+0x100>
  8029c7:	89 d8                	mov    %ebx,%eax
  8029c9:	31 ff                	xor    %edi,%edi
  8029cb:	e9 27 ff ff ff       	jmp    8028f7 <__udivdi3+0x27>
  8029d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029d3:	31 ff                	xor    %edi,%edi
  8029d5:	e9 1d ff ff ff       	jmp    8028f7 <__udivdi3+0x27>
  8029da:	66 90                	xchg   %ax,%ax
  8029dc:	66 90                	xchg   %ax,%ax
  8029de:	66 90                	xchg   %ax,%ax

008029e0 <__umoddi3>:
  8029e0:	55                   	push   %ebp
  8029e1:	57                   	push   %edi
  8029e2:	56                   	push   %esi
  8029e3:	53                   	push   %ebx
  8029e4:	83 ec 1c             	sub    $0x1c,%esp
  8029e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8029f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029f7:	89 da                	mov    %ebx,%edx
  8029f9:	85 c0                	test   %eax,%eax
  8029fb:	75 43                	jne    802a40 <__umoddi3+0x60>
  8029fd:	39 df                	cmp    %ebx,%edi
  8029ff:	76 17                	jbe    802a18 <__umoddi3+0x38>
  802a01:	89 f0                	mov    %esi,%eax
  802a03:	f7 f7                	div    %edi
  802a05:	89 d0                	mov    %edx,%eax
  802a07:	31 d2                	xor    %edx,%edx
  802a09:	83 c4 1c             	add    $0x1c,%esp
  802a0c:	5b                   	pop    %ebx
  802a0d:	5e                   	pop    %esi
  802a0e:	5f                   	pop    %edi
  802a0f:	5d                   	pop    %ebp
  802a10:	c3                   	ret    
  802a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a18:	89 fd                	mov    %edi,%ebp
  802a1a:	85 ff                	test   %edi,%edi
  802a1c:	75 0b                	jne    802a29 <__umoddi3+0x49>
  802a1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a23:	31 d2                	xor    %edx,%edx
  802a25:	f7 f7                	div    %edi
  802a27:	89 c5                	mov    %eax,%ebp
  802a29:	89 d8                	mov    %ebx,%eax
  802a2b:	31 d2                	xor    %edx,%edx
  802a2d:	f7 f5                	div    %ebp
  802a2f:	89 f0                	mov    %esi,%eax
  802a31:	f7 f5                	div    %ebp
  802a33:	89 d0                	mov    %edx,%eax
  802a35:	eb d0                	jmp    802a07 <__umoddi3+0x27>
  802a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a3e:	66 90                	xchg   %ax,%ax
  802a40:	89 f1                	mov    %esi,%ecx
  802a42:	39 d8                	cmp    %ebx,%eax
  802a44:	76 0a                	jbe    802a50 <__umoddi3+0x70>
  802a46:	89 f0                	mov    %esi,%eax
  802a48:	83 c4 1c             	add    $0x1c,%esp
  802a4b:	5b                   	pop    %ebx
  802a4c:	5e                   	pop    %esi
  802a4d:	5f                   	pop    %edi
  802a4e:	5d                   	pop    %ebp
  802a4f:	c3                   	ret    
  802a50:	0f bd e8             	bsr    %eax,%ebp
  802a53:	83 f5 1f             	xor    $0x1f,%ebp
  802a56:	75 20                	jne    802a78 <__umoddi3+0x98>
  802a58:	39 d8                	cmp    %ebx,%eax
  802a5a:	0f 82 b0 00 00 00    	jb     802b10 <__umoddi3+0x130>
  802a60:	39 f7                	cmp    %esi,%edi
  802a62:	0f 86 a8 00 00 00    	jbe    802b10 <__umoddi3+0x130>
  802a68:	89 c8                	mov    %ecx,%eax
  802a6a:	83 c4 1c             	add    $0x1c,%esp
  802a6d:	5b                   	pop    %ebx
  802a6e:	5e                   	pop    %esi
  802a6f:	5f                   	pop    %edi
  802a70:	5d                   	pop    %ebp
  802a71:	c3                   	ret    
  802a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a78:	89 e9                	mov    %ebp,%ecx
  802a7a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a7f:	29 ea                	sub    %ebp,%edx
  802a81:	d3 e0                	shl    %cl,%eax
  802a83:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a87:	89 d1                	mov    %edx,%ecx
  802a89:	89 f8                	mov    %edi,%eax
  802a8b:	d3 e8                	shr    %cl,%eax
  802a8d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a91:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a95:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a99:	09 c1                	or     %eax,%ecx
  802a9b:	89 d8                	mov    %ebx,%eax
  802a9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802aa1:	89 e9                	mov    %ebp,%ecx
  802aa3:	d3 e7                	shl    %cl,%edi
  802aa5:	89 d1                	mov    %edx,%ecx
  802aa7:	d3 e8                	shr    %cl,%eax
  802aa9:	89 e9                	mov    %ebp,%ecx
  802aab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802aaf:	d3 e3                	shl    %cl,%ebx
  802ab1:	89 c7                	mov    %eax,%edi
  802ab3:	89 d1                	mov    %edx,%ecx
  802ab5:	89 f0                	mov    %esi,%eax
  802ab7:	d3 e8                	shr    %cl,%eax
  802ab9:	89 e9                	mov    %ebp,%ecx
  802abb:	89 fa                	mov    %edi,%edx
  802abd:	d3 e6                	shl    %cl,%esi
  802abf:	09 d8                	or     %ebx,%eax
  802ac1:	f7 74 24 08          	divl   0x8(%esp)
  802ac5:	89 d1                	mov    %edx,%ecx
  802ac7:	89 f3                	mov    %esi,%ebx
  802ac9:	f7 64 24 0c          	mull   0xc(%esp)
  802acd:	89 c6                	mov    %eax,%esi
  802acf:	89 d7                	mov    %edx,%edi
  802ad1:	39 d1                	cmp    %edx,%ecx
  802ad3:	72 06                	jb     802adb <__umoddi3+0xfb>
  802ad5:	75 10                	jne    802ae7 <__umoddi3+0x107>
  802ad7:	39 c3                	cmp    %eax,%ebx
  802ad9:	73 0c                	jae    802ae7 <__umoddi3+0x107>
  802adb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802adf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802ae3:	89 d7                	mov    %edx,%edi
  802ae5:	89 c6                	mov    %eax,%esi
  802ae7:	89 ca                	mov    %ecx,%edx
  802ae9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802aee:	29 f3                	sub    %esi,%ebx
  802af0:	19 fa                	sbb    %edi,%edx
  802af2:	89 d0                	mov    %edx,%eax
  802af4:	d3 e0                	shl    %cl,%eax
  802af6:	89 e9                	mov    %ebp,%ecx
  802af8:	d3 eb                	shr    %cl,%ebx
  802afa:	d3 ea                	shr    %cl,%edx
  802afc:	09 d8                	or     %ebx,%eax
  802afe:	83 c4 1c             	add    $0x1c,%esp
  802b01:	5b                   	pop    %ebx
  802b02:	5e                   	pop    %esi
  802b03:	5f                   	pop    %edi
  802b04:	5d                   	pop    %ebp
  802b05:	c3                   	ret    
  802b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b0d:	8d 76 00             	lea    0x0(%esi),%esi
  802b10:	89 da                	mov    %ebx,%edx
  802b12:	29 fe                	sub    %edi,%esi
  802b14:	19 c2                	sbb    %eax,%edx
  802b16:	89 f1                	mov    %esi,%ecx
  802b18:	89 c8                	mov    %ecx,%eax
  802b1a:	e9 4b ff ff ff       	jmp    802a6a <__umoddi3+0x8a>
