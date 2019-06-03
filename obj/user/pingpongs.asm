
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
  80003a:	e8 63 13 00 00       	call   8013a2 <sfork>
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
  800051:	e8 b7 14 00 00       	call   80150d <ipc_recv>
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
  800074:	e8 fd 14 00 00       	call   801576 <ipc_send>
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
  800091:	e8 e0 14 00 00       	call   801576 <ipc_send>
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
  8000ae:	e8 4c 0c 00 00       	call   800cff <sys_getenvid>
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

	cprintf("call umain!\n");
  800112:	83 ec 0c             	sub    $0xc,%esp
  800115:	68 e0 2a 80 00       	push   $0x802ae0
  80011a:	e8 cd 00 00 00       	call   8001ec <cprintf>
	// call user main routine
	umain(argc, argv);
  80011f:	83 c4 08             	add    $0x8,%esp
  800122:	ff 75 0c             	pushl  0xc(%ebp)
  800125:	ff 75 08             	pushl  0x8(%ebp)
  800128:	e8 06 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80012d:	e8 0b 00 00 00       	call   80013d <exit>
}
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800138:	5b                   	pop    %ebx
  800139:	5e                   	pop    %esi
  80013a:	5f                   	pop    %edi
  80013b:	5d                   	pop    %ebp
  80013c:	c3                   	ret    

0080013d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013d:	55                   	push   %ebp
  80013e:	89 e5                	mov    %esp,%ebp
  800140:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800143:	e8 99 16 00 00       	call   8017e1 <close_all>
	sys_env_destroy(0);
  800148:	83 ec 0c             	sub    $0xc,%esp
  80014b:	6a 00                	push   $0x0
  80014d:	e8 6c 0b 00 00       	call   800cbe <sys_env_destroy>
}
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	c9                   	leave  
  800156:	c3                   	ret    

00800157 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	53                   	push   %ebx
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800161:	8b 13                	mov    (%ebx),%edx
  800163:	8d 42 01             	lea    0x1(%edx),%eax
  800166:	89 03                	mov    %eax,(%ebx)
  800168:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80016f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800174:	74 09                	je     80017f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800176:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80017d:	c9                   	leave  
  80017e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	68 ff 00 00 00       	push   $0xff
  800187:	8d 43 08             	lea    0x8(%ebx),%eax
  80018a:	50                   	push   %eax
  80018b:	e8 f1 0a 00 00       	call   800c81 <sys_cputs>
		b->idx = 0;
  800190:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	eb db                	jmp    800176 <putch+0x1f>

0080019b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ab:	00 00 00 
	b.cnt = 0;
  8001ae:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001b8:	ff 75 0c             	pushl  0xc(%ebp)
  8001bb:	ff 75 08             	pushl  0x8(%ebp)
  8001be:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c4:	50                   	push   %eax
  8001c5:	68 57 01 80 00       	push   $0x800157
  8001ca:	e8 4a 01 00 00       	call   800319 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001cf:	83 c4 08             	add    $0x8,%esp
  8001d2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001d8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001de:	50                   	push   %eax
  8001df:	e8 9d 0a 00 00       	call   800c81 <sys_cputs>

	return b.cnt;
}
  8001e4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ea:	c9                   	leave  
  8001eb:	c3                   	ret    

008001ec <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f5:	50                   	push   %eax
  8001f6:	ff 75 08             	pushl  0x8(%ebp)
  8001f9:	e8 9d ff ff ff       	call   80019b <vcprintf>
	va_end(ap);

	return cnt;
}
  8001fe:	c9                   	leave  
  8001ff:	c3                   	ret    

00800200 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800200:	55                   	push   %ebp
  800201:	89 e5                	mov    %esp,%ebp
  800203:	57                   	push   %edi
  800204:	56                   	push   %esi
  800205:	53                   	push   %ebx
  800206:	83 ec 1c             	sub    $0x1c,%esp
  800209:	89 c6                	mov    %eax,%esi
  80020b:	89 d7                	mov    %edx,%edi
  80020d:	8b 45 08             	mov    0x8(%ebp),%eax
  800210:	8b 55 0c             	mov    0xc(%ebp),%edx
  800213:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800216:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800219:	8b 45 10             	mov    0x10(%ebp),%eax
  80021c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80021f:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800223:	74 2c                	je     800251 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800225:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800228:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80022f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800232:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800235:	39 c2                	cmp    %eax,%edx
  800237:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80023a:	73 43                	jae    80027f <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80023c:	83 eb 01             	sub    $0x1,%ebx
  80023f:	85 db                	test   %ebx,%ebx
  800241:	7e 6c                	jle    8002af <printnum+0xaf>
				putch(padc, putdat);
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	57                   	push   %edi
  800247:	ff 75 18             	pushl  0x18(%ebp)
  80024a:	ff d6                	call   *%esi
  80024c:	83 c4 10             	add    $0x10,%esp
  80024f:	eb eb                	jmp    80023c <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800251:	83 ec 0c             	sub    $0xc,%esp
  800254:	6a 20                	push   $0x20
  800256:	6a 00                	push   $0x0
  800258:	50                   	push   %eax
  800259:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025c:	ff 75 e0             	pushl  -0x20(%ebp)
  80025f:	89 fa                	mov    %edi,%edx
  800261:	89 f0                	mov    %esi,%eax
  800263:	e8 98 ff ff ff       	call   800200 <printnum>
		while (--width > 0)
  800268:	83 c4 20             	add    $0x20,%esp
  80026b:	83 eb 01             	sub    $0x1,%ebx
  80026e:	85 db                	test   %ebx,%ebx
  800270:	7e 65                	jle    8002d7 <printnum+0xd7>
			putch(padc, putdat);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	57                   	push   %edi
  800276:	6a 20                	push   $0x20
  800278:	ff d6                	call   *%esi
  80027a:	83 c4 10             	add    $0x10,%esp
  80027d:	eb ec                	jmp    80026b <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	ff 75 18             	pushl  0x18(%ebp)
  800285:	83 eb 01             	sub    $0x1,%ebx
  800288:	53                   	push   %ebx
  800289:	50                   	push   %eax
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	ff 75 dc             	pushl  -0x24(%ebp)
  800290:	ff 75 d8             	pushl  -0x28(%ebp)
  800293:	ff 75 e4             	pushl  -0x1c(%ebp)
  800296:	ff 75 e0             	pushl  -0x20(%ebp)
  800299:	e8 f2 25 00 00       	call   802890 <__udivdi3>
  80029e:	83 c4 18             	add    $0x18,%esp
  8002a1:	52                   	push   %edx
  8002a2:	50                   	push   %eax
  8002a3:	89 fa                	mov    %edi,%edx
  8002a5:	89 f0                	mov    %esi,%eax
  8002a7:	e8 54 ff ff ff       	call   800200 <printnum>
  8002ac:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002af:	83 ec 08             	sub    $0x8,%esp
  8002b2:	57                   	push   %edi
  8002b3:	83 ec 04             	sub    $0x4,%esp
  8002b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c2:	e8 d9 26 00 00       	call   8029a0 <__umoddi3>
  8002c7:	83 c4 14             	add    $0x14,%esp
  8002ca:	0f be 80 f7 2a 80 00 	movsbl 0x802af7(%eax),%eax
  8002d1:	50                   	push   %eax
  8002d2:	ff d6                	call   *%esi
  8002d4:	83 c4 10             	add    $0x10,%esp
	}
}
  8002d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002da:	5b                   	pop    %ebx
  8002db:	5e                   	pop    %esi
  8002dc:	5f                   	pop    %edi
  8002dd:	5d                   	pop    %ebp
  8002de:	c3                   	ret    

008002df <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ee:	73 0a                	jae    8002fa <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f3:	89 08                	mov    %ecx,(%eax)
  8002f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f8:	88 02                	mov    %al,(%edx)
}
  8002fa:	5d                   	pop    %ebp
  8002fb:	c3                   	ret    

008002fc <printfmt>:
{
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800302:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800305:	50                   	push   %eax
  800306:	ff 75 10             	pushl  0x10(%ebp)
  800309:	ff 75 0c             	pushl  0xc(%ebp)
  80030c:	ff 75 08             	pushl  0x8(%ebp)
  80030f:	e8 05 00 00 00       	call   800319 <vprintfmt>
}
  800314:	83 c4 10             	add    $0x10,%esp
  800317:	c9                   	leave  
  800318:	c3                   	ret    

00800319 <vprintfmt>:
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	57                   	push   %edi
  80031d:	56                   	push   %esi
  80031e:	53                   	push   %ebx
  80031f:	83 ec 3c             	sub    $0x3c,%esp
  800322:	8b 75 08             	mov    0x8(%ebp),%esi
  800325:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800328:	8b 7d 10             	mov    0x10(%ebp),%edi
  80032b:	e9 32 04 00 00       	jmp    800762 <vprintfmt+0x449>
		padc = ' ';
  800330:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800334:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80033b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800342:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800349:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800350:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800357:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035c:	8d 47 01             	lea    0x1(%edi),%eax
  80035f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800362:	0f b6 17             	movzbl (%edi),%edx
  800365:	8d 42 dd             	lea    -0x23(%edx),%eax
  800368:	3c 55                	cmp    $0x55,%al
  80036a:	0f 87 12 05 00 00    	ja     800882 <vprintfmt+0x569>
  800370:	0f b6 c0             	movzbl %al,%eax
  800373:	ff 24 85 e0 2c 80 00 	jmp    *0x802ce0(,%eax,4)
  80037a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80037d:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800381:	eb d9                	jmp    80035c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800383:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800386:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80038a:	eb d0                	jmp    80035c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80038c:	0f b6 d2             	movzbl %dl,%edx
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800392:	b8 00 00 00 00       	mov    $0x0,%eax
  800397:	89 75 08             	mov    %esi,0x8(%ebp)
  80039a:	eb 03                	jmp    80039f <vprintfmt+0x86>
  80039c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80039f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a9:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003ac:	83 fe 09             	cmp    $0x9,%esi
  8003af:	76 eb                	jbe    80039c <vprintfmt+0x83>
  8003b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003b7:	eb 14                	jmp    8003cd <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bc:	8b 00                	mov    (%eax),%eax
  8003be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c4:	8d 40 04             	lea    0x4(%eax),%eax
  8003c7:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003cd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d1:	79 89                	jns    80035c <vprintfmt+0x43>
				width = precision, precision = -1;
  8003d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003e0:	e9 77 ff ff ff       	jmp    80035c <vprintfmt+0x43>
  8003e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e8:	85 c0                	test   %eax,%eax
  8003ea:	0f 48 c1             	cmovs  %ecx,%eax
  8003ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f3:	e9 64 ff ff ff       	jmp    80035c <vprintfmt+0x43>
  8003f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003fb:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800402:	e9 55 ff ff ff       	jmp    80035c <vprintfmt+0x43>
			lflag++;
  800407:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80040b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80040e:	e9 49 ff ff ff       	jmp    80035c <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800413:	8b 45 14             	mov    0x14(%ebp),%eax
  800416:	8d 78 04             	lea    0x4(%eax),%edi
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	53                   	push   %ebx
  80041d:	ff 30                	pushl  (%eax)
  80041f:	ff d6                	call   *%esi
			break;
  800421:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800424:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800427:	e9 33 03 00 00       	jmp    80075f <vprintfmt+0x446>
			err = va_arg(ap, int);
  80042c:	8b 45 14             	mov    0x14(%ebp),%eax
  80042f:	8d 78 04             	lea    0x4(%eax),%edi
  800432:	8b 00                	mov    (%eax),%eax
  800434:	99                   	cltd   
  800435:	31 d0                	xor    %edx,%eax
  800437:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800439:	83 f8 10             	cmp    $0x10,%eax
  80043c:	7f 23                	jg     800461 <vprintfmt+0x148>
  80043e:	8b 14 85 40 2e 80 00 	mov    0x802e40(,%eax,4),%edx
  800445:	85 d2                	test   %edx,%edx
  800447:	74 18                	je     800461 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800449:	52                   	push   %edx
  80044a:	68 71 30 80 00       	push   $0x803071
  80044f:	53                   	push   %ebx
  800450:	56                   	push   %esi
  800451:	e8 a6 fe ff ff       	call   8002fc <printfmt>
  800456:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800459:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045c:	e9 fe 02 00 00       	jmp    80075f <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800461:	50                   	push   %eax
  800462:	68 0f 2b 80 00       	push   $0x802b0f
  800467:	53                   	push   %ebx
  800468:	56                   	push   %esi
  800469:	e8 8e fe ff ff       	call   8002fc <printfmt>
  80046e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800471:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800474:	e9 e6 02 00 00       	jmp    80075f <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800479:	8b 45 14             	mov    0x14(%ebp),%eax
  80047c:	83 c0 04             	add    $0x4,%eax
  80047f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800482:	8b 45 14             	mov    0x14(%ebp),%eax
  800485:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800487:	85 c9                	test   %ecx,%ecx
  800489:	b8 08 2b 80 00       	mov    $0x802b08,%eax
  80048e:	0f 45 c1             	cmovne %ecx,%eax
  800491:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800494:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800498:	7e 06                	jle    8004a0 <vprintfmt+0x187>
  80049a:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80049e:	75 0d                	jne    8004ad <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a3:	89 c7                	mov    %eax,%edi
  8004a5:	03 45 e0             	add    -0x20(%ebp),%eax
  8004a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ab:	eb 53                	jmp    800500 <vprintfmt+0x1e7>
  8004ad:	83 ec 08             	sub    $0x8,%esp
  8004b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b3:	50                   	push   %eax
  8004b4:	e8 71 04 00 00       	call   80092a <strnlen>
  8004b9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004bc:	29 c1                	sub    %eax,%ecx
  8004be:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004c1:	83 c4 10             	add    $0x10,%esp
  8004c4:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004c6:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cd:	eb 0f                	jmp    8004de <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	53                   	push   %ebx
  8004d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d8:	83 ef 01             	sub    $0x1,%edi
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	85 ff                	test   %edi,%edi
  8004e0:	7f ed                	jg     8004cf <vprintfmt+0x1b6>
  8004e2:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004e5:	85 c9                	test   %ecx,%ecx
  8004e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ec:	0f 49 c1             	cmovns %ecx,%eax
  8004ef:	29 c1                	sub    %eax,%ecx
  8004f1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004f4:	eb aa                	jmp    8004a0 <vprintfmt+0x187>
					putch(ch, putdat);
  8004f6:	83 ec 08             	sub    $0x8,%esp
  8004f9:	53                   	push   %ebx
  8004fa:	52                   	push   %edx
  8004fb:	ff d6                	call   *%esi
  8004fd:	83 c4 10             	add    $0x10,%esp
  800500:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800503:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800505:	83 c7 01             	add    $0x1,%edi
  800508:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80050c:	0f be d0             	movsbl %al,%edx
  80050f:	85 d2                	test   %edx,%edx
  800511:	74 4b                	je     80055e <vprintfmt+0x245>
  800513:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800517:	78 06                	js     80051f <vprintfmt+0x206>
  800519:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80051d:	78 1e                	js     80053d <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80051f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800523:	74 d1                	je     8004f6 <vprintfmt+0x1dd>
  800525:	0f be c0             	movsbl %al,%eax
  800528:	83 e8 20             	sub    $0x20,%eax
  80052b:	83 f8 5e             	cmp    $0x5e,%eax
  80052e:	76 c6                	jbe    8004f6 <vprintfmt+0x1dd>
					putch('?', putdat);
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	53                   	push   %ebx
  800534:	6a 3f                	push   $0x3f
  800536:	ff d6                	call   *%esi
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	eb c3                	jmp    800500 <vprintfmt+0x1e7>
  80053d:	89 cf                	mov    %ecx,%edi
  80053f:	eb 0e                	jmp    80054f <vprintfmt+0x236>
				putch(' ', putdat);
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	53                   	push   %ebx
  800545:	6a 20                	push   $0x20
  800547:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800549:	83 ef 01             	sub    $0x1,%edi
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	85 ff                	test   %edi,%edi
  800551:	7f ee                	jg     800541 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800553:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800556:	89 45 14             	mov    %eax,0x14(%ebp)
  800559:	e9 01 02 00 00       	jmp    80075f <vprintfmt+0x446>
  80055e:	89 cf                	mov    %ecx,%edi
  800560:	eb ed                	jmp    80054f <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800562:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800565:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80056c:	e9 eb fd ff ff       	jmp    80035c <vprintfmt+0x43>
	if (lflag >= 2)
  800571:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800575:	7f 21                	jg     800598 <vprintfmt+0x27f>
	else if (lflag)
  800577:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80057b:	74 68                	je     8005e5 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800585:	89 c1                	mov    %eax,%ecx
  800587:	c1 f9 1f             	sar    $0x1f,%ecx
  80058a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8d 40 04             	lea    0x4(%eax),%eax
  800593:	89 45 14             	mov    %eax,0x14(%ebp)
  800596:	eb 17                	jmp    8005af <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8b 50 04             	mov    0x4(%eax),%edx
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8d 40 08             	lea    0x8(%eax),%eax
  8005ac:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005bb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005bf:	78 3f                	js     800600 <vprintfmt+0x2e7>
			base = 10;
  8005c1:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005c6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005ca:	0f 84 71 01 00 00    	je     800741 <vprintfmt+0x428>
				putch('+', putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	53                   	push   %ebx
  8005d4:	6a 2b                	push   $0x2b
  8005d6:	ff d6                	call   *%esi
  8005d8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005db:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e0:	e9 5c 01 00 00       	jmp    800741 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ed:	89 c1                	mov    %eax,%ecx
  8005ef:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8d 40 04             	lea    0x4(%eax),%eax
  8005fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fe:	eb af                	jmp    8005af <vprintfmt+0x296>
				putch('-', putdat);
  800600:	83 ec 08             	sub    $0x8,%esp
  800603:	53                   	push   %ebx
  800604:	6a 2d                	push   $0x2d
  800606:	ff d6                	call   *%esi
				num = -(long long) num;
  800608:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80060b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80060e:	f7 d8                	neg    %eax
  800610:	83 d2 00             	adc    $0x0,%edx
  800613:	f7 da                	neg    %edx
  800615:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800618:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80061e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800623:	e9 19 01 00 00       	jmp    800741 <vprintfmt+0x428>
	if (lflag >= 2)
  800628:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80062c:	7f 29                	jg     800657 <vprintfmt+0x33e>
	else if (lflag)
  80062e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800632:	74 44                	je     800678 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8b 00                	mov    (%eax),%eax
  800639:	ba 00 00 00 00       	mov    $0x0,%edx
  80063e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800641:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8d 40 04             	lea    0x4(%eax),%eax
  80064a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800652:	e9 ea 00 00 00       	jmp    800741 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8b 50 04             	mov    0x4(%eax),%edx
  80065d:	8b 00                	mov    (%eax),%eax
  80065f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800662:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8d 40 08             	lea    0x8(%eax),%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800673:	e9 c9 00 00 00       	jmp    800741 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8b 00                	mov    (%eax),%eax
  80067d:	ba 00 00 00 00       	mov    $0x0,%edx
  800682:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800685:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8d 40 04             	lea    0x4(%eax),%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800691:	b8 0a 00 00 00       	mov    $0xa,%eax
  800696:	e9 a6 00 00 00       	jmp    800741 <vprintfmt+0x428>
			putch('0', putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	53                   	push   %ebx
  80069f:	6a 30                	push   $0x30
  8006a1:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006a3:	83 c4 10             	add    $0x10,%esp
  8006a6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006aa:	7f 26                	jg     8006d2 <vprintfmt+0x3b9>
	else if (lflag)
  8006ac:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006b0:	74 3e                	je     8006f0 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8d 40 04             	lea    0x4(%eax),%eax
  8006c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006cb:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d0:	eb 6f                	jmp    800741 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8b 50 04             	mov    0x4(%eax),%edx
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8d 40 08             	lea    0x8(%eax),%eax
  8006e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e9:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ee:	eb 51                	jmp    800741 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 40 04             	lea    0x4(%eax),%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800709:	b8 08 00 00 00       	mov    $0x8,%eax
  80070e:	eb 31                	jmp    800741 <vprintfmt+0x428>
			putch('0', putdat);
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	53                   	push   %ebx
  800714:	6a 30                	push   $0x30
  800716:	ff d6                	call   *%esi
			putch('x', putdat);
  800718:	83 c4 08             	add    $0x8,%esp
  80071b:	53                   	push   %ebx
  80071c:	6a 78                	push   $0x78
  80071e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8b 00                	mov    (%eax),%eax
  800725:	ba 00 00 00 00       	mov    $0x0,%edx
  80072a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800730:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8d 40 04             	lea    0x4(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800741:	83 ec 0c             	sub    $0xc,%esp
  800744:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800748:	52                   	push   %edx
  800749:	ff 75 e0             	pushl  -0x20(%ebp)
  80074c:	50                   	push   %eax
  80074d:	ff 75 dc             	pushl  -0x24(%ebp)
  800750:	ff 75 d8             	pushl  -0x28(%ebp)
  800753:	89 da                	mov    %ebx,%edx
  800755:	89 f0                	mov    %esi,%eax
  800757:	e8 a4 fa ff ff       	call   800200 <printnum>
			break;
  80075c:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80075f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800762:	83 c7 01             	add    $0x1,%edi
  800765:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800769:	83 f8 25             	cmp    $0x25,%eax
  80076c:	0f 84 be fb ff ff    	je     800330 <vprintfmt+0x17>
			if (ch == '\0')
  800772:	85 c0                	test   %eax,%eax
  800774:	0f 84 28 01 00 00    	je     8008a2 <vprintfmt+0x589>
			putch(ch, putdat);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	53                   	push   %ebx
  80077e:	50                   	push   %eax
  80077f:	ff d6                	call   *%esi
  800781:	83 c4 10             	add    $0x10,%esp
  800784:	eb dc                	jmp    800762 <vprintfmt+0x449>
	if (lflag >= 2)
  800786:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80078a:	7f 26                	jg     8007b2 <vprintfmt+0x499>
	else if (lflag)
  80078c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800790:	74 41                	je     8007d3 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	ba 00 00 00 00       	mov    $0x0,%edx
  80079c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	8d 40 04             	lea    0x4(%eax),%eax
  8007a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ab:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b0:	eb 8f                	jmp    800741 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8b 50 04             	mov    0x4(%eax),%edx
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	8d 40 08             	lea    0x8(%eax),%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c9:	b8 10 00 00 00       	mov    $0x10,%eax
  8007ce:	e9 6e ff ff ff       	jmp    800741 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8d 40 04             	lea    0x4(%eax),%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ec:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f1:	e9 4b ff ff ff       	jmp    800741 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	83 c0 04             	add    $0x4,%eax
  8007fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	85 c0                	test   %eax,%eax
  800806:	74 14                	je     80081c <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800808:	8b 13                	mov    (%ebx),%edx
  80080a:	83 fa 7f             	cmp    $0x7f,%edx
  80080d:	7f 37                	jg     800846 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80080f:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800811:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800814:	89 45 14             	mov    %eax,0x14(%ebp)
  800817:	e9 43 ff ff ff       	jmp    80075f <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80081c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800821:	bf 2d 2c 80 00       	mov    $0x802c2d,%edi
							putch(ch, putdat);
  800826:	83 ec 08             	sub    $0x8,%esp
  800829:	53                   	push   %ebx
  80082a:	50                   	push   %eax
  80082b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80082d:	83 c7 01             	add    $0x1,%edi
  800830:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800834:	83 c4 10             	add    $0x10,%esp
  800837:	85 c0                	test   %eax,%eax
  800839:	75 eb                	jne    800826 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80083b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
  800841:	e9 19 ff ff ff       	jmp    80075f <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800846:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800848:	b8 0a 00 00 00       	mov    $0xa,%eax
  80084d:	bf 65 2c 80 00       	mov    $0x802c65,%edi
							putch(ch, putdat);
  800852:	83 ec 08             	sub    $0x8,%esp
  800855:	53                   	push   %ebx
  800856:	50                   	push   %eax
  800857:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800859:	83 c7 01             	add    $0x1,%edi
  80085c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800860:	83 c4 10             	add    $0x10,%esp
  800863:	85 c0                	test   %eax,%eax
  800865:	75 eb                	jne    800852 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800867:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80086a:	89 45 14             	mov    %eax,0x14(%ebp)
  80086d:	e9 ed fe ff ff       	jmp    80075f <vprintfmt+0x446>
			putch(ch, putdat);
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	53                   	push   %ebx
  800876:	6a 25                	push   $0x25
  800878:	ff d6                	call   *%esi
			break;
  80087a:	83 c4 10             	add    $0x10,%esp
  80087d:	e9 dd fe ff ff       	jmp    80075f <vprintfmt+0x446>
			putch('%', putdat);
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	53                   	push   %ebx
  800886:	6a 25                	push   $0x25
  800888:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80088a:	83 c4 10             	add    $0x10,%esp
  80088d:	89 f8                	mov    %edi,%eax
  80088f:	eb 03                	jmp    800894 <vprintfmt+0x57b>
  800891:	83 e8 01             	sub    $0x1,%eax
  800894:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800898:	75 f7                	jne    800891 <vprintfmt+0x578>
  80089a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089d:	e9 bd fe ff ff       	jmp    80075f <vprintfmt+0x446>
}
  8008a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008a5:	5b                   	pop    %ebx
  8008a6:	5e                   	pop    %esi
  8008a7:	5f                   	pop    %edi
  8008a8:	5d                   	pop    %ebp
  8008a9:	c3                   	ret    

008008aa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	83 ec 18             	sub    $0x18,%esp
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008b9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008bd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008c7:	85 c0                	test   %eax,%eax
  8008c9:	74 26                	je     8008f1 <vsnprintf+0x47>
  8008cb:	85 d2                	test   %edx,%edx
  8008cd:	7e 22                	jle    8008f1 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008cf:	ff 75 14             	pushl  0x14(%ebp)
  8008d2:	ff 75 10             	pushl  0x10(%ebp)
  8008d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d8:	50                   	push   %eax
  8008d9:	68 df 02 80 00       	push   $0x8002df
  8008de:	e8 36 fa ff ff       	call   800319 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ec:	83 c4 10             	add    $0x10,%esp
}
  8008ef:	c9                   	leave  
  8008f0:	c3                   	ret    
		return -E_INVAL;
  8008f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f6:	eb f7                	jmp    8008ef <vsnprintf+0x45>

008008f8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008fe:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800901:	50                   	push   %eax
  800902:	ff 75 10             	pushl  0x10(%ebp)
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	ff 75 08             	pushl  0x8(%ebp)
  80090b:	e8 9a ff ff ff       	call   8008aa <vsnprintf>
	va_end(ap);

	return rc;
}
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800918:	b8 00 00 00 00       	mov    $0x0,%eax
  80091d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800921:	74 05                	je     800928 <strlen+0x16>
		n++;
  800923:	83 c0 01             	add    $0x1,%eax
  800926:	eb f5                	jmp    80091d <strlen+0xb>
	return n;
}
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800930:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800933:	ba 00 00 00 00       	mov    $0x0,%edx
  800938:	39 c2                	cmp    %eax,%edx
  80093a:	74 0d                	je     800949 <strnlen+0x1f>
  80093c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800940:	74 05                	je     800947 <strnlen+0x1d>
		n++;
  800942:	83 c2 01             	add    $0x1,%edx
  800945:	eb f1                	jmp    800938 <strnlen+0xe>
  800947:	89 d0                	mov    %edx,%eax
	return n;
}
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	53                   	push   %ebx
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800955:	ba 00 00 00 00       	mov    $0x0,%edx
  80095a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80095e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800961:	83 c2 01             	add    $0x1,%edx
  800964:	84 c9                	test   %cl,%cl
  800966:	75 f2                	jne    80095a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800968:	5b                   	pop    %ebx
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	53                   	push   %ebx
  80096f:	83 ec 10             	sub    $0x10,%esp
  800972:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800975:	53                   	push   %ebx
  800976:	e8 97 ff ff ff       	call   800912 <strlen>
  80097b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	01 d8                	add    %ebx,%eax
  800983:	50                   	push   %eax
  800984:	e8 c2 ff ff ff       	call   80094b <strcpy>
	return dst;
}
  800989:	89 d8                	mov    %ebx,%eax
  80098b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80098e:	c9                   	leave  
  80098f:	c3                   	ret    

00800990 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	56                   	push   %esi
  800994:	53                   	push   %ebx
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80099b:	89 c6                	mov    %eax,%esi
  80099d:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a0:	89 c2                	mov    %eax,%edx
  8009a2:	39 f2                	cmp    %esi,%edx
  8009a4:	74 11                	je     8009b7 <strncpy+0x27>
		*dst++ = *src;
  8009a6:	83 c2 01             	add    $0x1,%edx
  8009a9:	0f b6 19             	movzbl (%ecx),%ebx
  8009ac:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009af:	80 fb 01             	cmp    $0x1,%bl
  8009b2:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009b5:	eb eb                	jmp    8009a2 <strncpy+0x12>
	}
	return ret;
}
  8009b7:	5b                   	pop    %ebx
  8009b8:	5e                   	pop    %esi
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	56                   	push   %esi
  8009bf:	53                   	push   %ebx
  8009c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c6:	8b 55 10             	mov    0x10(%ebp),%edx
  8009c9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009cb:	85 d2                	test   %edx,%edx
  8009cd:	74 21                	je     8009f0 <strlcpy+0x35>
  8009cf:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009d5:	39 c2                	cmp    %eax,%edx
  8009d7:	74 14                	je     8009ed <strlcpy+0x32>
  8009d9:	0f b6 19             	movzbl (%ecx),%ebx
  8009dc:	84 db                	test   %bl,%bl
  8009de:	74 0b                	je     8009eb <strlcpy+0x30>
			*dst++ = *src++;
  8009e0:	83 c1 01             	add    $0x1,%ecx
  8009e3:	83 c2 01             	add    $0x1,%edx
  8009e6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009e9:	eb ea                	jmp    8009d5 <strlcpy+0x1a>
  8009eb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ed:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f0:	29 f0                	sub    %esi,%eax
}
  8009f2:	5b                   	pop    %ebx
  8009f3:	5e                   	pop    %esi
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fc:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ff:	0f b6 01             	movzbl (%ecx),%eax
  800a02:	84 c0                	test   %al,%al
  800a04:	74 0c                	je     800a12 <strcmp+0x1c>
  800a06:	3a 02                	cmp    (%edx),%al
  800a08:	75 08                	jne    800a12 <strcmp+0x1c>
		p++, q++;
  800a0a:	83 c1 01             	add    $0x1,%ecx
  800a0d:	83 c2 01             	add    $0x1,%edx
  800a10:	eb ed                	jmp    8009ff <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a12:	0f b6 c0             	movzbl %al,%eax
  800a15:	0f b6 12             	movzbl (%edx),%edx
  800a18:	29 d0                	sub    %edx,%eax
}
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	53                   	push   %ebx
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a26:	89 c3                	mov    %eax,%ebx
  800a28:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a2b:	eb 06                	jmp    800a33 <strncmp+0x17>
		n--, p++, q++;
  800a2d:	83 c0 01             	add    $0x1,%eax
  800a30:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a33:	39 d8                	cmp    %ebx,%eax
  800a35:	74 16                	je     800a4d <strncmp+0x31>
  800a37:	0f b6 08             	movzbl (%eax),%ecx
  800a3a:	84 c9                	test   %cl,%cl
  800a3c:	74 04                	je     800a42 <strncmp+0x26>
  800a3e:	3a 0a                	cmp    (%edx),%cl
  800a40:	74 eb                	je     800a2d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a42:	0f b6 00             	movzbl (%eax),%eax
  800a45:	0f b6 12             	movzbl (%edx),%edx
  800a48:	29 d0                	sub    %edx,%eax
}
  800a4a:	5b                   	pop    %ebx
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    
		return 0;
  800a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a52:	eb f6                	jmp    800a4a <strncmp+0x2e>

00800a54 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5e:	0f b6 10             	movzbl (%eax),%edx
  800a61:	84 d2                	test   %dl,%dl
  800a63:	74 09                	je     800a6e <strchr+0x1a>
		if (*s == c)
  800a65:	38 ca                	cmp    %cl,%dl
  800a67:	74 0a                	je     800a73 <strchr+0x1f>
	for (; *s; s++)
  800a69:	83 c0 01             	add    $0x1,%eax
  800a6c:	eb f0                	jmp    800a5e <strchr+0xa>
			return (char *) s;
	return 0;
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a82:	38 ca                	cmp    %cl,%dl
  800a84:	74 09                	je     800a8f <strfind+0x1a>
  800a86:	84 d2                	test   %dl,%dl
  800a88:	74 05                	je     800a8f <strfind+0x1a>
	for (; *s; s++)
  800a8a:	83 c0 01             	add    $0x1,%eax
  800a8d:	eb f0                	jmp    800a7f <strfind+0xa>
			break;
	return (char *) s;
}
  800a8f:	5d                   	pop    %ebp
  800a90:	c3                   	ret    

00800a91 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	57                   	push   %edi
  800a95:	56                   	push   %esi
  800a96:	53                   	push   %ebx
  800a97:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a9d:	85 c9                	test   %ecx,%ecx
  800a9f:	74 31                	je     800ad2 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa1:	89 f8                	mov    %edi,%eax
  800aa3:	09 c8                	or     %ecx,%eax
  800aa5:	a8 03                	test   $0x3,%al
  800aa7:	75 23                	jne    800acc <memset+0x3b>
		c &= 0xFF;
  800aa9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aad:	89 d3                	mov    %edx,%ebx
  800aaf:	c1 e3 08             	shl    $0x8,%ebx
  800ab2:	89 d0                	mov    %edx,%eax
  800ab4:	c1 e0 18             	shl    $0x18,%eax
  800ab7:	89 d6                	mov    %edx,%esi
  800ab9:	c1 e6 10             	shl    $0x10,%esi
  800abc:	09 f0                	or     %esi,%eax
  800abe:	09 c2                	or     %eax,%edx
  800ac0:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ac5:	89 d0                	mov    %edx,%eax
  800ac7:	fc                   	cld    
  800ac8:	f3 ab                	rep stos %eax,%es:(%edi)
  800aca:	eb 06                	jmp    800ad2 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acf:	fc                   	cld    
  800ad0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ad2:	89 f8                	mov    %edi,%eax
  800ad4:	5b                   	pop    %ebx
  800ad5:	5e                   	pop    %esi
  800ad6:	5f                   	pop    %edi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	57                   	push   %edi
  800add:	56                   	push   %esi
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ae7:	39 c6                	cmp    %eax,%esi
  800ae9:	73 32                	jae    800b1d <memmove+0x44>
  800aeb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aee:	39 c2                	cmp    %eax,%edx
  800af0:	76 2b                	jbe    800b1d <memmove+0x44>
		s += n;
		d += n;
  800af2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af5:	89 fe                	mov    %edi,%esi
  800af7:	09 ce                	or     %ecx,%esi
  800af9:	09 d6                	or     %edx,%esi
  800afb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b01:	75 0e                	jne    800b11 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b03:	83 ef 04             	sub    $0x4,%edi
  800b06:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b09:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b0c:	fd                   	std    
  800b0d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b0f:	eb 09                	jmp    800b1a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b11:	83 ef 01             	sub    $0x1,%edi
  800b14:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b17:	fd                   	std    
  800b18:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b1a:	fc                   	cld    
  800b1b:	eb 1a                	jmp    800b37 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1d:	89 c2                	mov    %eax,%edx
  800b1f:	09 ca                	or     %ecx,%edx
  800b21:	09 f2                	or     %esi,%edx
  800b23:	f6 c2 03             	test   $0x3,%dl
  800b26:	75 0a                	jne    800b32 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b28:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b2b:	89 c7                	mov    %eax,%edi
  800b2d:	fc                   	cld    
  800b2e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b30:	eb 05                	jmp    800b37 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b32:	89 c7                	mov    %eax,%edi
  800b34:	fc                   	cld    
  800b35:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b37:	5e                   	pop    %esi
  800b38:	5f                   	pop    %edi
  800b39:	5d                   	pop    %ebp
  800b3a:	c3                   	ret    

00800b3b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b41:	ff 75 10             	pushl  0x10(%ebp)
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	ff 75 08             	pushl  0x8(%ebp)
  800b4a:	e8 8a ff ff ff       	call   800ad9 <memmove>
}
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	56                   	push   %esi
  800b55:	53                   	push   %ebx
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5c:	89 c6                	mov    %eax,%esi
  800b5e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b61:	39 f0                	cmp    %esi,%eax
  800b63:	74 1c                	je     800b81 <memcmp+0x30>
		if (*s1 != *s2)
  800b65:	0f b6 08             	movzbl (%eax),%ecx
  800b68:	0f b6 1a             	movzbl (%edx),%ebx
  800b6b:	38 d9                	cmp    %bl,%cl
  800b6d:	75 08                	jne    800b77 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b6f:	83 c0 01             	add    $0x1,%eax
  800b72:	83 c2 01             	add    $0x1,%edx
  800b75:	eb ea                	jmp    800b61 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b77:	0f b6 c1             	movzbl %cl,%eax
  800b7a:	0f b6 db             	movzbl %bl,%ebx
  800b7d:	29 d8                	sub    %ebx,%eax
  800b7f:	eb 05                	jmp    800b86 <memcmp+0x35>
	}

	return 0;
  800b81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b86:	5b                   	pop    %ebx
  800b87:	5e                   	pop    %esi
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b93:	89 c2                	mov    %eax,%edx
  800b95:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b98:	39 d0                	cmp    %edx,%eax
  800b9a:	73 09                	jae    800ba5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b9c:	38 08                	cmp    %cl,(%eax)
  800b9e:	74 05                	je     800ba5 <memfind+0x1b>
	for (; s < ends; s++)
  800ba0:	83 c0 01             	add    $0x1,%eax
  800ba3:	eb f3                	jmp    800b98 <memfind+0xe>
			break;
	return (void *) s;
}
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	57                   	push   %edi
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
  800bad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bb3:	eb 03                	jmp    800bb8 <strtol+0x11>
		s++;
  800bb5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bb8:	0f b6 01             	movzbl (%ecx),%eax
  800bbb:	3c 20                	cmp    $0x20,%al
  800bbd:	74 f6                	je     800bb5 <strtol+0xe>
  800bbf:	3c 09                	cmp    $0x9,%al
  800bc1:	74 f2                	je     800bb5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bc3:	3c 2b                	cmp    $0x2b,%al
  800bc5:	74 2a                	je     800bf1 <strtol+0x4a>
	int neg = 0;
  800bc7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bcc:	3c 2d                	cmp    $0x2d,%al
  800bce:	74 2b                	je     800bfb <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bd6:	75 0f                	jne    800be7 <strtol+0x40>
  800bd8:	80 39 30             	cmpb   $0x30,(%ecx)
  800bdb:	74 28                	je     800c05 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bdd:	85 db                	test   %ebx,%ebx
  800bdf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800be4:	0f 44 d8             	cmove  %eax,%ebx
  800be7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bec:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bef:	eb 50                	jmp    800c41 <strtol+0x9a>
		s++;
  800bf1:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bf4:	bf 00 00 00 00       	mov    $0x0,%edi
  800bf9:	eb d5                	jmp    800bd0 <strtol+0x29>
		s++, neg = 1;
  800bfb:	83 c1 01             	add    $0x1,%ecx
  800bfe:	bf 01 00 00 00       	mov    $0x1,%edi
  800c03:	eb cb                	jmp    800bd0 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c05:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c09:	74 0e                	je     800c19 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c0b:	85 db                	test   %ebx,%ebx
  800c0d:	75 d8                	jne    800be7 <strtol+0x40>
		s++, base = 8;
  800c0f:	83 c1 01             	add    $0x1,%ecx
  800c12:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c17:	eb ce                	jmp    800be7 <strtol+0x40>
		s += 2, base = 16;
  800c19:	83 c1 02             	add    $0x2,%ecx
  800c1c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c21:	eb c4                	jmp    800be7 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c23:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c26:	89 f3                	mov    %esi,%ebx
  800c28:	80 fb 19             	cmp    $0x19,%bl
  800c2b:	77 29                	ja     800c56 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c2d:	0f be d2             	movsbl %dl,%edx
  800c30:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c33:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c36:	7d 30                	jge    800c68 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c38:	83 c1 01             	add    $0x1,%ecx
  800c3b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c3f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c41:	0f b6 11             	movzbl (%ecx),%edx
  800c44:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c47:	89 f3                	mov    %esi,%ebx
  800c49:	80 fb 09             	cmp    $0x9,%bl
  800c4c:	77 d5                	ja     800c23 <strtol+0x7c>
			dig = *s - '0';
  800c4e:	0f be d2             	movsbl %dl,%edx
  800c51:	83 ea 30             	sub    $0x30,%edx
  800c54:	eb dd                	jmp    800c33 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c56:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c59:	89 f3                	mov    %esi,%ebx
  800c5b:	80 fb 19             	cmp    $0x19,%bl
  800c5e:	77 08                	ja     800c68 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c60:	0f be d2             	movsbl %dl,%edx
  800c63:	83 ea 37             	sub    $0x37,%edx
  800c66:	eb cb                	jmp    800c33 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6c:	74 05                	je     800c73 <strtol+0xcc>
		*endptr = (char *) s;
  800c6e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c71:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c73:	89 c2                	mov    %eax,%edx
  800c75:	f7 da                	neg    %edx
  800c77:	85 ff                	test   %edi,%edi
  800c79:	0f 45 c2             	cmovne %edx,%eax
}
  800c7c:	5b                   	pop    %ebx
  800c7d:	5e                   	pop    %esi
  800c7e:	5f                   	pop    %edi
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	57                   	push   %edi
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c87:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c92:	89 c3                	mov    %eax,%ebx
  800c94:	89 c7                	mov    %eax,%edi
  800c96:	89 c6                	mov    %eax,%esi
  800c98:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c9a:	5b                   	pop    %ebx
  800c9b:	5e                   	pop    %esi
  800c9c:	5f                   	pop    %edi
  800c9d:	5d                   	pop    %ebp
  800c9e:	c3                   	ret    

00800c9f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	57                   	push   %edi
  800ca3:	56                   	push   %esi
  800ca4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca5:	ba 00 00 00 00       	mov    $0x0,%edx
  800caa:	b8 01 00 00 00       	mov    $0x1,%eax
  800caf:	89 d1                	mov    %edx,%ecx
  800cb1:	89 d3                	mov    %edx,%ebx
  800cb3:	89 d7                	mov    %edx,%edi
  800cb5:	89 d6                	mov    %edx,%esi
  800cb7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cb9:	5b                   	pop    %ebx
  800cba:	5e                   	pop    %esi
  800cbb:	5f                   	pop    %edi
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    

00800cbe <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	57                   	push   %edi
  800cc2:	56                   	push   %esi
  800cc3:	53                   	push   %ebx
  800cc4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccf:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd4:	89 cb                	mov    %ecx,%ebx
  800cd6:	89 cf                	mov    %ecx,%edi
  800cd8:	89 ce                	mov    %ecx,%esi
  800cda:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cdc:	85 c0                	test   %eax,%eax
  800cde:	7f 08                	jg     800ce8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce3:	5b                   	pop    %ebx
  800ce4:	5e                   	pop    %esi
  800ce5:	5f                   	pop    %edi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce8:	83 ec 0c             	sub    $0xc,%esp
  800ceb:	50                   	push   %eax
  800cec:	6a 03                	push   $0x3
  800cee:	68 84 2e 80 00       	push   $0x802e84
  800cf3:	6a 43                	push   $0x43
  800cf5:	68 a1 2e 80 00       	push   $0x802ea1
  800cfa:	e8 60 1a 00 00       	call   80275f <_panic>

00800cff <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	57                   	push   %edi
  800d03:	56                   	push   %esi
  800d04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d05:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0a:	b8 02 00 00 00       	mov    $0x2,%eax
  800d0f:	89 d1                	mov    %edx,%ecx
  800d11:	89 d3                	mov    %edx,%ebx
  800d13:	89 d7                	mov    %edx,%edi
  800d15:	89 d6                	mov    %edx,%esi
  800d17:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d19:	5b                   	pop    %ebx
  800d1a:	5e                   	pop    %esi
  800d1b:	5f                   	pop    %edi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <sys_yield>:

void
sys_yield(void)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	57                   	push   %edi
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d24:	ba 00 00 00 00       	mov    $0x0,%edx
  800d29:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d2e:	89 d1                	mov    %edx,%ecx
  800d30:	89 d3                	mov    %edx,%ebx
  800d32:	89 d7                	mov    %edx,%edi
  800d34:	89 d6                	mov    %edx,%esi
  800d36:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	57                   	push   %edi
  800d41:	56                   	push   %esi
  800d42:	53                   	push   %ebx
  800d43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d46:	be 00 00 00 00       	mov    $0x0,%esi
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d51:	b8 04 00 00 00       	mov    $0x4,%eax
  800d56:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d59:	89 f7                	mov    %esi,%edi
  800d5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5d:	85 c0                	test   %eax,%eax
  800d5f:	7f 08                	jg     800d69 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d69:	83 ec 0c             	sub    $0xc,%esp
  800d6c:	50                   	push   %eax
  800d6d:	6a 04                	push   $0x4
  800d6f:	68 84 2e 80 00       	push   $0x802e84
  800d74:	6a 43                	push   $0x43
  800d76:	68 a1 2e 80 00       	push   $0x802ea1
  800d7b:	e8 df 19 00 00       	call   80275f <_panic>

00800d80 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d89:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8f:	b8 05 00 00 00       	mov    $0x5,%eax
  800d94:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d97:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d9a:	8b 75 18             	mov    0x18(%ebp),%esi
  800d9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9f:	85 c0                	test   %eax,%eax
  800da1:	7f 08                	jg     800dab <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da6:	5b                   	pop    %ebx
  800da7:	5e                   	pop    %esi
  800da8:	5f                   	pop    %edi
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dab:	83 ec 0c             	sub    $0xc,%esp
  800dae:	50                   	push   %eax
  800daf:	6a 05                	push   $0x5
  800db1:	68 84 2e 80 00       	push   $0x802e84
  800db6:	6a 43                	push   $0x43
  800db8:	68 a1 2e 80 00       	push   $0x802ea1
  800dbd:	e8 9d 19 00 00       	call   80275f <_panic>

00800dc2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	57                   	push   %edi
  800dc6:	56                   	push   %esi
  800dc7:	53                   	push   %ebx
  800dc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd6:	b8 06 00 00 00       	mov    $0x6,%eax
  800ddb:	89 df                	mov    %ebx,%edi
  800ddd:	89 de                	mov    %ebx,%esi
  800ddf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de1:	85 c0                	test   %eax,%eax
  800de3:	7f 08                	jg     800ded <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800de5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de8:	5b                   	pop    %ebx
  800de9:	5e                   	pop    %esi
  800dea:	5f                   	pop    %edi
  800deb:	5d                   	pop    %ebp
  800dec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ded:	83 ec 0c             	sub    $0xc,%esp
  800df0:	50                   	push   %eax
  800df1:	6a 06                	push   $0x6
  800df3:	68 84 2e 80 00       	push   $0x802e84
  800df8:	6a 43                	push   $0x43
  800dfa:	68 a1 2e 80 00       	push   $0x802ea1
  800dff:	e8 5b 19 00 00       	call   80275f <_panic>

00800e04 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
  800e0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e12:	8b 55 08             	mov    0x8(%ebp),%edx
  800e15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e18:	b8 08 00 00 00       	mov    $0x8,%eax
  800e1d:	89 df                	mov    %ebx,%edi
  800e1f:	89 de                	mov    %ebx,%esi
  800e21:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e23:	85 c0                	test   %eax,%eax
  800e25:	7f 08                	jg     800e2f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2a:	5b                   	pop    %ebx
  800e2b:	5e                   	pop    %esi
  800e2c:	5f                   	pop    %edi
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2f:	83 ec 0c             	sub    $0xc,%esp
  800e32:	50                   	push   %eax
  800e33:	6a 08                	push   $0x8
  800e35:	68 84 2e 80 00       	push   $0x802e84
  800e3a:	6a 43                	push   $0x43
  800e3c:	68 a1 2e 80 00       	push   $0x802ea1
  800e41:	e8 19 19 00 00       	call   80275f <_panic>

00800e46 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
  800e4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e54:	8b 55 08             	mov    0x8(%ebp),%edx
  800e57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e5f:	89 df                	mov    %ebx,%edi
  800e61:	89 de                	mov    %ebx,%esi
  800e63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e65:	85 c0                	test   %eax,%eax
  800e67:	7f 08                	jg     800e71 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6c:	5b                   	pop    %ebx
  800e6d:	5e                   	pop    %esi
  800e6e:	5f                   	pop    %edi
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e71:	83 ec 0c             	sub    $0xc,%esp
  800e74:	50                   	push   %eax
  800e75:	6a 09                	push   $0x9
  800e77:	68 84 2e 80 00       	push   $0x802e84
  800e7c:	6a 43                	push   $0x43
  800e7e:	68 a1 2e 80 00       	push   $0x802ea1
  800e83:	e8 d7 18 00 00       	call   80275f <_panic>

00800e88 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	57                   	push   %edi
  800e8c:	56                   	push   %esi
  800e8d:	53                   	push   %ebx
  800e8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e91:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea1:	89 df                	mov    %ebx,%edi
  800ea3:	89 de                	mov    %ebx,%esi
  800ea5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea7:	85 c0                	test   %eax,%eax
  800ea9:	7f 08                	jg     800eb3 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eae:	5b                   	pop    %ebx
  800eaf:	5e                   	pop    %esi
  800eb0:	5f                   	pop    %edi
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb3:	83 ec 0c             	sub    $0xc,%esp
  800eb6:	50                   	push   %eax
  800eb7:	6a 0a                	push   $0xa
  800eb9:	68 84 2e 80 00       	push   $0x802e84
  800ebe:	6a 43                	push   $0x43
  800ec0:	68 a1 2e 80 00       	push   $0x802ea1
  800ec5:	e8 95 18 00 00       	call   80275f <_panic>

00800eca <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	57                   	push   %edi
  800ece:	56                   	push   %esi
  800ecf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800edb:	be 00 00 00 00       	mov    $0x0,%esi
  800ee0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ee8:	5b                   	pop    %ebx
  800ee9:	5e                   	pop    %esi
  800eea:	5f                   	pop    %edi
  800eeb:	5d                   	pop    %ebp
  800eec:	c3                   	ret    

00800eed <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	57                   	push   %edi
  800ef1:	56                   	push   %esi
  800ef2:	53                   	push   %ebx
  800ef3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800efb:	8b 55 08             	mov    0x8(%ebp),%edx
  800efe:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f03:	89 cb                	mov    %ecx,%ebx
  800f05:	89 cf                	mov    %ecx,%edi
  800f07:	89 ce                	mov    %ecx,%esi
  800f09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0b:	85 c0                	test   %eax,%eax
  800f0d:	7f 08                	jg     800f17 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f12:	5b                   	pop    %ebx
  800f13:	5e                   	pop    %esi
  800f14:	5f                   	pop    %edi
  800f15:	5d                   	pop    %ebp
  800f16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f17:	83 ec 0c             	sub    $0xc,%esp
  800f1a:	50                   	push   %eax
  800f1b:	6a 0d                	push   $0xd
  800f1d:	68 84 2e 80 00       	push   $0x802e84
  800f22:	6a 43                	push   $0x43
  800f24:	68 a1 2e 80 00       	push   $0x802ea1
  800f29:	e8 31 18 00 00       	call   80275f <_panic>

00800f2e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f39:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f44:	89 df                	mov    %ebx,%edi
  800f46:	89 de                	mov    %ebx,%esi
  800f48:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f4a:	5b                   	pop    %ebx
  800f4b:	5e                   	pop    %esi
  800f4c:	5f                   	pop    %edi
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    

00800f4f <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	57                   	push   %edi
  800f53:	56                   	push   %esi
  800f54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f55:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f62:	89 cb                	mov    %ecx,%ebx
  800f64:	89 cf                	mov    %ecx,%edi
  800f66:	89 ce                	mov    %ecx,%esi
  800f68:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f6a:	5b                   	pop    %ebx
  800f6b:	5e                   	pop    %esi
  800f6c:	5f                   	pop    %edi
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f75:	ba 00 00 00 00       	mov    $0x0,%edx
  800f7a:	b8 10 00 00 00       	mov    $0x10,%eax
  800f7f:	89 d1                	mov    %edx,%ecx
  800f81:	89 d3                	mov    %edx,%ebx
  800f83:	89 d7                	mov    %edx,%edi
  800f85:	89 d6                	mov    %edx,%esi
  800f87:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f89:	5b                   	pop    %ebx
  800f8a:	5e                   	pop    %esi
  800f8b:	5f                   	pop    %edi
  800f8c:	5d                   	pop    %ebp
  800f8d:	c3                   	ret    

00800f8e <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9f:	b8 11 00 00 00       	mov    $0x11,%eax
  800fa4:	89 df                	mov    %ebx,%edi
  800fa6:	89 de                	mov    %ebx,%esi
  800fa8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800faa:	5b                   	pop    %ebx
  800fab:	5e                   	pop    %esi
  800fac:	5f                   	pop    %edi
  800fad:	5d                   	pop    %ebp
  800fae:	c3                   	ret    

00800faf <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	57                   	push   %edi
  800fb3:	56                   	push   %esi
  800fb4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fba:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc0:	b8 12 00 00 00       	mov    $0x12,%eax
  800fc5:	89 df                	mov    %ebx,%edi
  800fc7:	89 de                	mov    %ebx,%esi
  800fc9:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fcb:	5b                   	pop    %ebx
  800fcc:	5e                   	pop    %esi
  800fcd:	5f                   	pop    %edi
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    

00800fd0 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	57                   	push   %edi
  800fd4:	56                   	push   %esi
  800fd5:	53                   	push   %ebx
  800fd6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fde:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe4:	b8 13 00 00 00       	mov    $0x13,%eax
  800fe9:	89 df                	mov    %ebx,%edi
  800feb:	89 de                	mov    %ebx,%esi
  800fed:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fef:	85 c0                	test   %eax,%eax
  800ff1:	7f 08                	jg     800ffb <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff6:	5b                   	pop    %ebx
  800ff7:	5e                   	pop    %esi
  800ff8:	5f                   	pop    %edi
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffb:	83 ec 0c             	sub    $0xc,%esp
  800ffe:	50                   	push   %eax
  800fff:	6a 13                	push   $0x13
  801001:	68 84 2e 80 00       	push   $0x802e84
  801006:	6a 43                	push   $0x43
  801008:	68 a1 2e 80 00       	push   $0x802ea1
  80100d:	e8 4d 17 00 00       	call   80275f <_panic>

00801012 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	53                   	push   %ebx
  801016:	83 ec 04             	sub    $0x4,%esp
  801019:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80101c:	8b 02                	mov    (%edx),%eax
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80101e:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801022:	0f 84 99 00 00 00    	je     8010c1 <pgfault+0xaf>
  801028:	89 c2                	mov    %eax,%edx
  80102a:	c1 ea 16             	shr    $0x16,%edx
  80102d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801034:	f6 c2 01             	test   $0x1,%dl
  801037:	0f 84 84 00 00 00    	je     8010c1 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80103d:	89 c2                	mov    %eax,%edx
  80103f:	c1 ea 0c             	shr    $0xc,%edx
  801042:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801049:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80104f:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801055:	75 6a                	jne    8010c1 <pgfault+0xaf>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	addr = ROUNDDOWN(addr, PGSIZE);
  801057:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80105c:	89 c3                	mov    %eax,%ebx
	int ret;
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80105e:	83 ec 04             	sub    $0x4,%esp
  801061:	6a 07                	push   $0x7
  801063:	68 00 f0 7f 00       	push   $0x7ff000
  801068:	6a 00                	push   $0x0
  80106a:	e8 ce fc ff ff       	call   800d3d <sys_page_alloc>
	if(ret < 0)
  80106f:	83 c4 10             	add    $0x10,%esp
  801072:	85 c0                	test   %eax,%eax
  801074:	78 5f                	js     8010d5 <pgfault+0xc3>
		panic("panic in sys_page_alloc()\n");
	
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801076:	83 ec 04             	sub    $0x4,%esp
  801079:	68 00 10 00 00       	push   $0x1000
  80107e:	53                   	push   %ebx
  80107f:	68 00 f0 7f 00       	push   $0x7ff000
  801084:	e8 b2 fa ff ff       	call   800b3b <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801089:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801090:	53                   	push   %ebx
  801091:	6a 00                	push   $0x0
  801093:	68 00 f0 7f 00       	push   $0x7ff000
  801098:	6a 00                	push   $0x0
  80109a:	e8 e1 fc ff ff       	call   800d80 <sys_page_map>
	if(ret < 0)
  80109f:	83 c4 20             	add    $0x20,%esp
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	78 43                	js     8010e9 <pgfault+0xd7>
		panic("panic in sys_page_map()\n");
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8010a6:	83 ec 08             	sub    $0x8,%esp
  8010a9:	68 00 f0 7f 00       	push   $0x7ff000
  8010ae:	6a 00                	push   $0x0
  8010b0:	e8 0d fd ff ff       	call   800dc2 <sys_page_unmap>
	if(ret < 0)
  8010b5:	83 c4 10             	add    $0x10,%esp
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	78 41                	js     8010fd <pgfault+0xeb>
		panic("panic in sys_page_unmap()\n");
	// LAB 4: Your code here.

	// panic("pgfault not implemented");

}
  8010bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010bf:	c9                   	leave  
  8010c0:	c3                   	ret    
		panic("panic at pgfault()\n");
  8010c1:	83 ec 04             	sub    $0x4,%esp
  8010c4:	68 af 2e 80 00       	push   $0x802eaf
  8010c9:	6a 26                	push   $0x26
  8010cb:	68 c3 2e 80 00       	push   $0x802ec3
  8010d0:	e8 8a 16 00 00       	call   80275f <_panic>
		panic("panic in sys_page_alloc()\n");
  8010d5:	83 ec 04             	sub    $0x4,%esp
  8010d8:	68 ce 2e 80 00       	push   $0x802ece
  8010dd:	6a 31                	push   $0x31
  8010df:	68 c3 2e 80 00       	push   $0x802ec3
  8010e4:	e8 76 16 00 00       	call   80275f <_panic>
		panic("panic in sys_page_map()\n");
  8010e9:	83 ec 04             	sub    $0x4,%esp
  8010ec:	68 e9 2e 80 00       	push   $0x802ee9
  8010f1:	6a 36                	push   $0x36
  8010f3:	68 c3 2e 80 00       	push   $0x802ec3
  8010f8:	e8 62 16 00 00       	call   80275f <_panic>
		panic("panic in sys_page_unmap()\n");
  8010fd:	83 ec 04             	sub    $0x4,%esp
  801100:	68 02 2f 80 00       	push   $0x802f02
  801105:	6a 39                	push   $0x39
  801107:	68 c3 2e 80 00       	push   $0x802ec3
  80110c:	e8 4e 16 00 00       	call   80275f <_panic>

00801111 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	56                   	push   %esi
  801115:	53                   	push   %ebx
  801116:	89 c6                	mov    %eax,%esi
  801118:	89 d3                	mov    %edx,%ebx
	cprintf("in %s\n", __FUNCTION__);
  80111a:	83 ec 08             	sub    $0x8,%esp
  80111d:	68 a0 2f 80 00       	push   $0x802fa0
  801122:	68 f3 30 80 00       	push   $0x8030f3
  801127:	e8 c0 f0 ff ff       	call   8001ec <cprintf>
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  80112c:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801133:	83 c4 10             	add    $0x10,%esp
  801136:	f6 c4 04             	test   $0x4,%ah
  801139:	75 45                	jne    801180 <duppage+0x6f>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80113b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801142:	83 e0 07             	and    $0x7,%eax
  801145:	83 f8 07             	cmp    $0x7,%eax
  801148:	74 6e                	je     8011b8 <duppage+0xa7>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80114a:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801151:	25 05 08 00 00       	and    $0x805,%eax
  801156:	3d 05 08 00 00       	cmp    $0x805,%eax
  80115b:	0f 84 b5 00 00 00    	je     801216 <duppage+0x105>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801161:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801168:	83 e0 05             	and    $0x5,%eax
  80116b:	83 f8 05             	cmp    $0x5,%eax
  80116e:	0f 84 d6 00 00 00    	je     80124a <duppage+0x139>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801174:	b8 00 00 00 00       	mov    $0x0,%eax
  801179:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80117c:	5b                   	pop    %ebx
  80117d:	5e                   	pop    %esi
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801180:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801187:	c1 e3 0c             	shl    $0xc,%ebx
  80118a:	83 ec 0c             	sub    $0xc,%esp
  80118d:	25 07 0e 00 00       	and    $0xe07,%eax
  801192:	50                   	push   %eax
  801193:	53                   	push   %ebx
  801194:	56                   	push   %esi
  801195:	53                   	push   %ebx
  801196:	6a 00                	push   $0x0
  801198:	e8 e3 fb ff ff       	call   800d80 <sys_page_map>
		if(r < 0)
  80119d:	83 c4 20             	add    $0x20,%esp
  8011a0:	85 c0                	test   %eax,%eax
  8011a2:	79 d0                	jns    801174 <duppage+0x63>
			panic("sys_page_map() panic\n");
  8011a4:	83 ec 04             	sub    $0x4,%esp
  8011a7:	68 1d 2f 80 00       	push   $0x802f1d
  8011ac:	6a 55                	push   $0x55
  8011ae:	68 c3 2e 80 00       	push   $0x802ec3
  8011b3:	e8 a7 15 00 00       	call   80275f <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011b8:	c1 e3 0c             	shl    $0xc,%ebx
  8011bb:	83 ec 0c             	sub    $0xc,%esp
  8011be:	68 05 08 00 00       	push   $0x805
  8011c3:	53                   	push   %ebx
  8011c4:	56                   	push   %esi
  8011c5:	53                   	push   %ebx
  8011c6:	6a 00                	push   $0x0
  8011c8:	e8 b3 fb ff ff       	call   800d80 <sys_page_map>
		if(r < 0)
  8011cd:	83 c4 20             	add    $0x20,%esp
  8011d0:	85 c0                	test   %eax,%eax
  8011d2:	78 2e                	js     801202 <duppage+0xf1>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8011d4:	83 ec 0c             	sub    $0xc,%esp
  8011d7:	68 05 08 00 00       	push   $0x805
  8011dc:	53                   	push   %ebx
  8011dd:	6a 00                	push   $0x0
  8011df:	53                   	push   %ebx
  8011e0:	6a 00                	push   $0x0
  8011e2:	e8 99 fb ff ff       	call   800d80 <sys_page_map>
		if(r < 0)
  8011e7:	83 c4 20             	add    $0x20,%esp
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	79 86                	jns    801174 <duppage+0x63>
			panic("sys_page_map() panic\n");
  8011ee:	83 ec 04             	sub    $0x4,%esp
  8011f1:	68 1d 2f 80 00       	push   $0x802f1d
  8011f6:	6a 60                	push   $0x60
  8011f8:	68 c3 2e 80 00       	push   $0x802ec3
  8011fd:	e8 5d 15 00 00       	call   80275f <_panic>
			panic("sys_page_map() panic\n");
  801202:	83 ec 04             	sub    $0x4,%esp
  801205:	68 1d 2f 80 00       	push   $0x802f1d
  80120a:	6a 5c                	push   $0x5c
  80120c:	68 c3 2e 80 00       	push   $0x802ec3
  801211:	e8 49 15 00 00       	call   80275f <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801216:	c1 e3 0c             	shl    $0xc,%ebx
  801219:	83 ec 0c             	sub    $0xc,%esp
  80121c:	68 05 08 00 00       	push   $0x805
  801221:	53                   	push   %ebx
  801222:	56                   	push   %esi
  801223:	53                   	push   %ebx
  801224:	6a 00                	push   $0x0
  801226:	e8 55 fb ff ff       	call   800d80 <sys_page_map>
		if(r < 0)
  80122b:	83 c4 20             	add    $0x20,%esp
  80122e:	85 c0                	test   %eax,%eax
  801230:	0f 89 3e ff ff ff    	jns    801174 <duppage+0x63>
			panic("sys_page_map() panic\n");
  801236:	83 ec 04             	sub    $0x4,%esp
  801239:	68 1d 2f 80 00       	push   $0x802f1d
  80123e:	6a 67                	push   $0x67
  801240:	68 c3 2e 80 00       	push   $0x802ec3
  801245:	e8 15 15 00 00       	call   80275f <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80124a:	c1 e3 0c             	shl    $0xc,%ebx
  80124d:	83 ec 0c             	sub    $0xc,%esp
  801250:	6a 05                	push   $0x5
  801252:	53                   	push   %ebx
  801253:	56                   	push   %esi
  801254:	53                   	push   %ebx
  801255:	6a 00                	push   $0x0
  801257:	e8 24 fb ff ff       	call   800d80 <sys_page_map>
		if(r < 0)
  80125c:	83 c4 20             	add    $0x20,%esp
  80125f:	85 c0                	test   %eax,%eax
  801261:	0f 89 0d ff ff ff    	jns    801174 <duppage+0x63>
			panic("sys_page_map() panic\n");
  801267:	83 ec 04             	sub    $0x4,%esp
  80126a:	68 1d 2f 80 00       	push   $0x802f1d
  80126f:	6a 6e                	push   $0x6e
  801271:	68 c3 2e 80 00       	push   $0x802ec3
  801276:	e8 e4 14 00 00       	call   80275f <_panic>

0080127b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	57                   	push   %edi
  80127f:	56                   	push   %esi
  801280:	53                   	push   %ebx
  801281:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801284:	68 12 10 80 00       	push   $0x801012
  801289:	e8 32 15 00 00       	call   8027c0 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80128e:	b8 07 00 00 00       	mov    $0x7,%eax
  801293:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801295:	83 c4 10             	add    $0x10,%esp
  801298:	85 c0                	test   %eax,%eax
  80129a:	78 27                	js     8012c3 <fork+0x48>
  80129c:	89 c6                	mov    %eax,%esi
  80129e:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012a0:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8012a5:	75 48                	jne    8012ef <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012a7:	e8 53 fa ff ff       	call   800cff <sys_getenvid>
  8012ac:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012b1:	c1 e0 07             	shl    $0x7,%eax
  8012b4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012b9:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8012be:	e9 90 00 00 00       	jmp    801353 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8012c3:	83 ec 04             	sub    $0x4,%esp
  8012c6:	68 34 2f 80 00       	push   $0x802f34
  8012cb:	68 8d 00 00 00       	push   $0x8d
  8012d0:	68 c3 2e 80 00       	push   $0x802ec3
  8012d5:	e8 85 14 00 00       	call   80275f <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8012da:	89 f8                	mov    %edi,%eax
  8012dc:	e8 30 fe ff ff       	call   801111 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012e7:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8012ed:	74 26                	je     801315 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8012ef:	89 d8                	mov    %ebx,%eax
  8012f1:	c1 e8 16             	shr    $0x16,%eax
  8012f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012fb:	a8 01                	test   $0x1,%al
  8012fd:	74 e2                	je     8012e1 <fork+0x66>
  8012ff:	89 da                	mov    %ebx,%edx
  801301:	c1 ea 0c             	shr    $0xc,%edx
  801304:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80130b:	83 e0 05             	and    $0x5,%eax
  80130e:	83 f8 05             	cmp    $0x5,%eax
  801311:	75 ce                	jne    8012e1 <fork+0x66>
  801313:	eb c5                	jmp    8012da <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801315:	83 ec 04             	sub    $0x4,%esp
  801318:	6a 07                	push   $0x7
  80131a:	68 00 f0 bf ee       	push   $0xeebff000
  80131f:	56                   	push   %esi
  801320:	e8 18 fa ff ff       	call   800d3d <sys_page_alloc>
	if(ret < 0)
  801325:	83 c4 10             	add    $0x10,%esp
  801328:	85 c0                	test   %eax,%eax
  80132a:	78 31                	js     80135d <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80132c:	83 ec 08             	sub    $0x8,%esp
  80132f:	68 2f 28 80 00       	push   $0x80282f
  801334:	56                   	push   %esi
  801335:	e8 4e fb ff ff       	call   800e88 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	85 c0                	test   %eax,%eax
  80133f:	78 33                	js     801374 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801341:	83 ec 08             	sub    $0x8,%esp
  801344:	6a 02                	push   $0x2
  801346:	56                   	push   %esi
  801347:	e8 b8 fa ff ff       	call   800e04 <sys_env_set_status>
	if(ret < 0)
  80134c:	83 c4 10             	add    $0x10,%esp
  80134f:	85 c0                	test   %eax,%eax
  801351:	78 38                	js     80138b <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801353:	89 f0                	mov    %esi,%eax
  801355:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801358:	5b                   	pop    %ebx
  801359:	5e                   	pop    %esi
  80135a:	5f                   	pop    %edi
  80135b:	5d                   	pop    %ebp
  80135c:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80135d:	83 ec 04             	sub    $0x4,%esp
  801360:	68 ce 2e 80 00       	push   $0x802ece
  801365:	68 99 00 00 00       	push   $0x99
  80136a:	68 c3 2e 80 00       	push   $0x802ec3
  80136f:	e8 eb 13 00 00       	call   80275f <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801374:	83 ec 04             	sub    $0x4,%esp
  801377:	68 58 2f 80 00       	push   $0x802f58
  80137c:	68 9c 00 00 00       	push   $0x9c
  801381:	68 c3 2e 80 00       	push   $0x802ec3
  801386:	e8 d4 13 00 00       	call   80275f <_panic>
		panic("panic in sys_env_set_status()\n");
  80138b:	83 ec 04             	sub    $0x4,%esp
  80138e:	68 80 2f 80 00       	push   $0x802f80
  801393:	68 9f 00 00 00       	push   $0x9f
  801398:	68 c3 2e 80 00       	push   $0x802ec3
  80139d:	e8 bd 13 00 00       	call   80275f <_panic>

008013a2 <sfork>:

// Challenge!
int
sfork(void)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	57                   	push   %edi
  8013a6:	56                   	push   %esi
  8013a7:	53                   	push   %ebx
  8013a8:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8013ab:	68 12 10 80 00       	push   $0x801012
  8013b0:	e8 0b 14 00 00       	call   8027c0 <set_pgfault_handler>
  8013b5:	b8 07 00 00 00       	mov    $0x7,%eax
  8013ba:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013bc:	83 c4 10             	add    $0x10,%esp
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	78 27                	js     8013ea <sfork+0x48>
  8013c3:	89 c7                	mov    %eax,%edi
  8013c5:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013c7:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013cc:	75 55                	jne    801423 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013ce:	e8 2c f9 ff ff       	call   800cff <sys_getenvid>
  8013d3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013d8:	c1 e0 07             	shl    $0x7,%eax
  8013db:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013e0:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8013e5:	e9 d4 00 00 00       	jmp    8014be <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8013ea:	83 ec 04             	sub    $0x4,%esp
  8013ed:	68 34 2f 80 00       	push   $0x802f34
  8013f2:	68 b0 00 00 00       	push   $0xb0
  8013f7:	68 c3 2e 80 00       	push   $0x802ec3
  8013fc:	e8 5e 13 00 00       	call   80275f <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801401:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801406:	89 f0                	mov    %esi,%eax
  801408:	e8 04 fd ff ff       	call   801111 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80140d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801413:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801419:	77 65                	ja     801480 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  80141b:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801421:	74 de                	je     801401 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801423:	89 d8                	mov    %ebx,%eax
  801425:	c1 e8 16             	shr    $0x16,%eax
  801428:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80142f:	a8 01                	test   $0x1,%al
  801431:	74 da                	je     80140d <sfork+0x6b>
  801433:	89 da                	mov    %ebx,%edx
  801435:	c1 ea 0c             	shr    $0xc,%edx
  801438:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80143f:	83 e0 05             	and    $0x5,%eax
  801442:	83 f8 05             	cmp    $0x5,%eax
  801445:	75 c6                	jne    80140d <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801447:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80144e:	c1 e2 0c             	shl    $0xc,%edx
  801451:	83 ec 0c             	sub    $0xc,%esp
  801454:	83 e0 07             	and    $0x7,%eax
  801457:	50                   	push   %eax
  801458:	52                   	push   %edx
  801459:	56                   	push   %esi
  80145a:	52                   	push   %edx
  80145b:	6a 00                	push   $0x0
  80145d:	e8 1e f9 ff ff       	call   800d80 <sys_page_map>
  801462:	83 c4 20             	add    $0x20,%esp
  801465:	85 c0                	test   %eax,%eax
  801467:	74 a4                	je     80140d <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801469:	83 ec 04             	sub    $0x4,%esp
  80146c:	68 1d 2f 80 00       	push   $0x802f1d
  801471:	68 bb 00 00 00       	push   $0xbb
  801476:	68 c3 2e 80 00       	push   $0x802ec3
  80147b:	e8 df 12 00 00       	call   80275f <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801480:	83 ec 04             	sub    $0x4,%esp
  801483:	6a 07                	push   $0x7
  801485:	68 00 f0 bf ee       	push   $0xeebff000
  80148a:	57                   	push   %edi
  80148b:	e8 ad f8 ff ff       	call   800d3d <sys_page_alloc>
	if(ret < 0)
  801490:	83 c4 10             	add    $0x10,%esp
  801493:	85 c0                	test   %eax,%eax
  801495:	78 31                	js     8014c8 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801497:	83 ec 08             	sub    $0x8,%esp
  80149a:	68 2f 28 80 00       	push   $0x80282f
  80149f:	57                   	push   %edi
  8014a0:	e8 e3 f9 ff ff       	call   800e88 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014a5:	83 c4 10             	add    $0x10,%esp
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	78 33                	js     8014df <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014ac:	83 ec 08             	sub    $0x8,%esp
  8014af:	6a 02                	push   $0x2
  8014b1:	57                   	push   %edi
  8014b2:	e8 4d f9 ff ff       	call   800e04 <sys_env_set_status>
	if(ret < 0)
  8014b7:	83 c4 10             	add    $0x10,%esp
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	78 38                	js     8014f6 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8014be:	89 f8                	mov    %edi,%eax
  8014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c3:	5b                   	pop    %ebx
  8014c4:	5e                   	pop    %esi
  8014c5:	5f                   	pop    %edi
  8014c6:	5d                   	pop    %ebp
  8014c7:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014c8:	83 ec 04             	sub    $0x4,%esp
  8014cb:	68 ce 2e 80 00       	push   $0x802ece
  8014d0:	68 c1 00 00 00       	push   $0xc1
  8014d5:	68 c3 2e 80 00       	push   $0x802ec3
  8014da:	e8 80 12 00 00       	call   80275f <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014df:	83 ec 04             	sub    $0x4,%esp
  8014e2:	68 58 2f 80 00       	push   $0x802f58
  8014e7:	68 c4 00 00 00       	push   $0xc4
  8014ec:	68 c3 2e 80 00       	push   $0x802ec3
  8014f1:	e8 69 12 00 00       	call   80275f <_panic>
		panic("panic in sys_env_set_status()\n");
  8014f6:	83 ec 04             	sub    $0x4,%esp
  8014f9:	68 80 2f 80 00       	push   $0x802f80
  8014fe:	68 c7 00 00 00       	push   $0xc7
  801503:	68 c3 2e 80 00       	push   $0x802ec3
  801508:	e8 52 12 00 00       	call   80275f <_panic>

0080150d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	56                   	push   %esi
  801511:	53                   	push   %ebx
  801512:	8b 75 08             	mov    0x8(%ebp),%esi
  801515:	8b 45 0c             	mov    0xc(%ebp),%eax
  801518:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80151b:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80151d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801522:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801525:	83 ec 0c             	sub    $0xc,%esp
  801528:	50                   	push   %eax
  801529:	e8 bf f9 ff ff       	call   800eed <sys_ipc_recv>
	if(ret < 0){
  80152e:	83 c4 10             	add    $0x10,%esp
  801531:	85 c0                	test   %eax,%eax
  801533:	78 2b                	js     801560 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801535:	85 f6                	test   %esi,%esi
  801537:	74 0a                	je     801543 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  801539:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80153e:	8b 40 74             	mov    0x74(%eax),%eax
  801541:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801543:	85 db                	test   %ebx,%ebx
  801545:	74 0a                	je     801551 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801547:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80154c:	8b 40 78             	mov    0x78(%eax),%eax
  80154f:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  801551:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801556:	8b 40 70             	mov    0x70(%eax),%eax
}
  801559:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80155c:	5b                   	pop    %ebx
  80155d:	5e                   	pop    %esi
  80155e:	5d                   	pop    %ebp
  80155f:	c3                   	ret    
		if(from_env_store)
  801560:	85 f6                	test   %esi,%esi
  801562:	74 06                	je     80156a <ipc_recv+0x5d>
			*from_env_store = 0;
  801564:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80156a:	85 db                	test   %ebx,%ebx
  80156c:	74 eb                	je     801559 <ipc_recv+0x4c>
			*perm_store = 0;
  80156e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801574:	eb e3                	jmp    801559 <ipc_recv+0x4c>

00801576 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	57                   	push   %edi
  80157a:	56                   	push   %esi
  80157b:	53                   	push   %ebx
  80157c:	83 ec 0c             	sub    $0xc,%esp
  80157f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801582:	8b 75 0c             	mov    0xc(%ebp),%esi
  801585:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801588:	85 db                	test   %ebx,%ebx
  80158a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80158f:	0f 44 d8             	cmove  %eax,%ebx
  801592:	eb 05                	jmp    801599 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801594:	e8 85 f7 ff ff       	call   800d1e <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801599:	ff 75 14             	pushl  0x14(%ebp)
  80159c:	53                   	push   %ebx
  80159d:	56                   	push   %esi
  80159e:	57                   	push   %edi
  80159f:	e8 26 f9 ff ff       	call   800eca <sys_ipc_try_send>
  8015a4:	83 c4 10             	add    $0x10,%esp
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	74 1b                	je     8015c6 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8015ab:	79 e7                	jns    801594 <ipc_send+0x1e>
  8015ad:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8015b0:	74 e2                	je     801594 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8015b2:	83 ec 04             	sub    $0x4,%esp
  8015b5:	68 a8 2f 80 00       	push   $0x802fa8
  8015ba:	6a 48                	push   $0x48
  8015bc:	68 bd 2f 80 00       	push   $0x802fbd
  8015c1:	e8 99 11 00 00       	call   80275f <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8015c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c9:	5b                   	pop    %ebx
  8015ca:	5e                   	pop    %esi
  8015cb:	5f                   	pop    %edi
  8015cc:	5d                   	pop    %ebp
  8015cd:	c3                   	ret    

008015ce <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8015d4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8015d9:	89 c2                	mov    %eax,%edx
  8015db:	c1 e2 07             	shl    $0x7,%edx
  8015de:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8015e4:	8b 52 50             	mov    0x50(%edx),%edx
  8015e7:	39 ca                	cmp    %ecx,%edx
  8015e9:	74 11                	je     8015fc <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8015eb:	83 c0 01             	add    $0x1,%eax
  8015ee:	3d 00 04 00 00       	cmp    $0x400,%eax
  8015f3:	75 e4                	jne    8015d9 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8015f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fa:	eb 0b                	jmp    801607 <ipc_find_env+0x39>
			return envs[i].env_id;
  8015fc:	c1 e0 07             	shl    $0x7,%eax
  8015ff:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801604:	8b 40 48             	mov    0x48(%eax),%eax
}
  801607:	5d                   	pop    %ebp
  801608:	c3                   	ret    

00801609 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	05 00 00 00 30       	add    $0x30000000,%eax
  801614:	c1 e8 0c             	shr    $0xc,%eax
}
  801617:	5d                   	pop    %ebp
  801618:	c3                   	ret    

00801619 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801624:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801629:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80162e:	5d                   	pop    %ebp
  80162f:	c3                   	ret    

00801630 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801638:	89 c2                	mov    %eax,%edx
  80163a:	c1 ea 16             	shr    $0x16,%edx
  80163d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801644:	f6 c2 01             	test   $0x1,%dl
  801647:	74 2d                	je     801676 <fd_alloc+0x46>
  801649:	89 c2                	mov    %eax,%edx
  80164b:	c1 ea 0c             	shr    $0xc,%edx
  80164e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801655:	f6 c2 01             	test   $0x1,%dl
  801658:	74 1c                	je     801676 <fd_alloc+0x46>
  80165a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80165f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801664:	75 d2                	jne    801638 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80166f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801674:	eb 0a                	jmp    801680 <fd_alloc+0x50>
			*fd_store = fd;
  801676:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801679:	89 01                	mov    %eax,(%ecx)
			return 0;
  80167b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801680:	5d                   	pop    %ebp
  801681:	c3                   	ret    

00801682 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801688:	83 f8 1f             	cmp    $0x1f,%eax
  80168b:	77 30                	ja     8016bd <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80168d:	c1 e0 0c             	shl    $0xc,%eax
  801690:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801695:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80169b:	f6 c2 01             	test   $0x1,%dl
  80169e:	74 24                	je     8016c4 <fd_lookup+0x42>
  8016a0:	89 c2                	mov    %eax,%edx
  8016a2:	c1 ea 0c             	shr    $0xc,%edx
  8016a5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016ac:	f6 c2 01             	test   $0x1,%dl
  8016af:	74 1a                	je     8016cb <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b4:	89 02                	mov    %eax,(%edx)
	return 0;
  8016b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bb:	5d                   	pop    %ebp
  8016bc:	c3                   	ret    
		return -E_INVAL;
  8016bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c2:	eb f7                	jmp    8016bb <fd_lookup+0x39>
		return -E_INVAL;
  8016c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c9:	eb f0                	jmp    8016bb <fd_lookup+0x39>
  8016cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d0:	eb e9                	jmp    8016bb <fd_lookup+0x39>

008016d2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	83 ec 08             	sub    $0x8,%esp
  8016d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8016db:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e0:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8016e5:	39 08                	cmp    %ecx,(%eax)
  8016e7:	74 38                	je     801721 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8016e9:	83 c2 01             	add    $0x1,%edx
  8016ec:	8b 04 95 44 30 80 00 	mov    0x803044(,%edx,4),%eax
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	75 ee                	jne    8016e5 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016f7:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8016fc:	8b 40 48             	mov    0x48(%eax),%eax
  8016ff:	83 ec 04             	sub    $0x4,%esp
  801702:	51                   	push   %ecx
  801703:	50                   	push   %eax
  801704:	68 c8 2f 80 00       	push   $0x802fc8
  801709:	e8 de ea ff ff       	call   8001ec <cprintf>
	*dev = 0;
  80170e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801711:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    
			*dev = devtab[i];
  801721:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801724:	89 01                	mov    %eax,(%ecx)
			return 0;
  801726:	b8 00 00 00 00       	mov    $0x0,%eax
  80172b:	eb f2                	jmp    80171f <dev_lookup+0x4d>

0080172d <fd_close>:
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	57                   	push   %edi
  801731:	56                   	push   %esi
  801732:	53                   	push   %ebx
  801733:	83 ec 24             	sub    $0x24,%esp
  801736:	8b 75 08             	mov    0x8(%ebp),%esi
  801739:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80173c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80173f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801740:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801746:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801749:	50                   	push   %eax
  80174a:	e8 33 ff ff ff       	call   801682 <fd_lookup>
  80174f:	89 c3                	mov    %eax,%ebx
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	85 c0                	test   %eax,%eax
  801756:	78 05                	js     80175d <fd_close+0x30>
	    || fd != fd2)
  801758:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80175b:	74 16                	je     801773 <fd_close+0x46>
		return (must_exist ? r : 0);
  80175d:	89 f8                	mov    %edi,%eax
  80175f:	84 c0                	test   %al,%al
  801761:	b8 00 00 00 00       	mov    $0x0,%eax
  801766:	0f 44 d8             	cmove  %eax,%ebx
}
  801769:	89 d8                	mov    %ebx,%eax
  80176b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80176e:	5b                   	pop    %ebx
  80176f:	5e                   	pop    %esi
  801770:	5f                   	pop    %edi
  801771:	5d                   	pop    %ebp
  801772:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801773:	83 ec 08             	sub    $0x8,%esp
  801776:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801779:	50                   	push   %eax
  80177a:	ff 36                	pushl  (%esi)
  80177c:	e8 51 ff ff ff       	call   8016d2 <dev_lookup>
  801781:	89 c3                	mov    %eax,%ebx
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	85 c0                	test   %eax,%eax
  801788:	78 1a                	js     8017a4 <fd_close+0x77>
		if (dev->dev_close)
  80178a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80178d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801790:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801795:	85 c0                	test   %eax,%eax
  801797:	74 0b                	je     8017a4 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801799:	83 ec 0c             	sub    $0xc,%esp
  80179c:	56                   	push   %esi
  80179d:	ff d0                	call   *%eax
  80179f:	89 c3                	mov    %eax,%ebx
  8017a1:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8017a4:	83 ec 08             	sub    $0x8,%esp
  8017a7:	56                   	push   %esi
  8017a8:	6a 00                	push   $0x0
  8017aa:	e8 13 f6 ff ff       	call   800dc2 <sys_page_unmap>
	return r;
  8017af:	83 c4 10             	add    $0x10,%esp
  8017b2:	eb b5                	jmp    801769 <fd_close+0x3c>

008017b4 <close>:

int
close(int fdnum)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017bd:	50                   	push   %eax
  8017be:	ff 75 08             	pushl  0x8(%ebp)
  8017c1:	e8 bc fe ff ff       	call   801682 <fd_lookup>
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	79 02                	jns    8017cf <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    
		return fd_close(fd, 1);
  8017cf:	83 ec 08             	sub    $0x8,%esp
  8017d2:	6a 01                	push   $0x1
  8017d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d7:	e8 51 ff ff ff       	call   80172d <fd_close>
  8017dc:	83 c4 10             	add    $0x10,%esp
  8017df:	eb ec                	jmp    8017cd <close+0x19>

008017e1 <close_all>:

void
close_all(void)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	53                   	push   %ebx
  8017e5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017e8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017ed:	83 ec 0c             	sub    $0xc,%esp
  8017f0:	53                   	push   %ebx
  8017f1:	e8 be ff ff ff       	call   8017b4 <close>
	for (i = 0; i < MAXFD; i++)
  8017f6:	83 c3 01             	add    $0x1,%ebx
  8017f9:	83 c4 10             	add    $0x10,%esp
  8017fc:	83 fb 20             	cmp    $0x20,%ebx
  8017ff:	75 ec                	jne    8017ed <close_all+0xc>
}
  801801:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	57                   	push   %edi
  80180a:	56                   	push   %esi
  80180b:	53                   	push   %ebx
  80180c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80180f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801812:	50                   	push   %eax
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	e8 67 fe ff ff       	call   801682 <fd_lookup>
  80181b:	89 c3                	mov    %eax,%ebx
  80181d:	83 c4 10             	add    $0x10,%esp
  801820:	85 c0                	test   %eax,%eax
  801822:	0f 88 81 00 00 00    	js     8018a9 <dup+0xa3>
		return r;
	close(newfdnum);
  801828:	83 ec 0c             	sub    $0xc,%esp
  80182b:	ff 75 0c             	pushl  0xc(%ebp)
  80182e:	e8 81 ff ff ff       	call   8017b4 <close>

	newfd = INDEX2FD(newfdnum);
  801833:	8b 75 0c             	mov    0xc(%ebp),%esi
  801836:	c1 e6 0c             	shl    $0xc,%esi
  801839:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80183f:	83 c4 04             	add    $0x4,%esp
  801842:	ff 75 e4             	pushl  -0x1c(%ebp)
  801845:	e8 cf fd ff ff       	call   801619 <fd2data>
  80184a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80184c:	89 34 24             	mov    %esi,(%esp)
  80184f:	e8 c5 fd ff ff       	call   801619 <fd2data>
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801859:	89 d8                	mov    %ebx,%eax
  80185b:	c1 e8 16             	shr    $0x16,%eax
  80185e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801865:	a8 01                	test   $0x1,%al
  801867:	74 11                	je     80187a <dup+0x74>
  801869:	89 d8                	mov    %ebx,%eax
  80186b:	c1 e8 0c             	shr    $0xc,%eax
  80186e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801875:	f6 c2 01             	test   $0x1,%dl
  801878:	75 39                	jne    8018b3 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80187a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80187d:	89 d0                	mov    %edx,%eax
  80187f:	c1 e8 0c             	shr    $0xc,%eax
  801882:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801889:	83 ec 0c             	sub    $0xc,%esp
  80188c:	25 07 0e 00 00       	and    $0xe07,%eax
  801891:	50                   	push   %eax
  801892:	56                   	push   %esi
  801893:	6a 00                	push   $0x0
  801895:	52                   	push   %edx
  801896:	6a 00                	push   $0x0
  801898:	e8 e3 f4 ff ff       	call   800d80 <sys_page_map>
  80189d:	89 c3                	mov    %eax,%ebx
  80189f:	83 c4 20             	add    $0x20,%esp
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	78 31                	js     8018d7 <dup+0xd1>
		goto err;

	return newfdnum;
  8018a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018a9:	89 d8                	mov    %ebx,%eax
  8018ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ae:	5b                   	pop    %ebx
  8018af:	5e                   	pop    %esi
  8018b0:	5f                   	pop    %edi
  8018b1:	5d                   	pop    %ebp
  8018b2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018b3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018ba:	83 ec 0c             	sub    $0xc,%esp
  8018bd:	25 07 0e 00 00       	and    $0xe07,%eax
  8018c2:	50                   	push   %eax
  8018c3:	57                   	push   %edi
  8018c4:	6a 00                	push   $0x0
  8018c6:	53                   	push   %ebx
  8018c7:	6a 00                	push   $0x0
  8018c9:	e8 b2 f4 ff ff       	call   800d80 <sys_page_map>
  8018ce:	89 c3                	mov    %eax,%ebx
  8018d0:	83 c4 20             	add    $0x20,%esp
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	79 a3                	jns    80187a <dup+0x74>
	sys_page_unmap(0, newfd);
  8018d7:	83 ec 08             	sub    $0x8,%esp
  8018da:	56                   	push   %esi
  8018db:	6a 00                	push   $0x0
  8018dd:	e8 e0 f4 ff ff       	call   800dc2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018e2:	83 c4 08             	add    $0x8,%esp
  8018e5:	57                   	push   %edi
  8018e6:	6a 00                	push   $0x0
  8018e8:	e8 d5 f4 ff ff       	call   800dc2 <sys_page_unmap>
	return r;
  8018ed:	83 c4 10             	add    $0x10,%esp
  8018f0:	eb b7                	jmp    8018a9 <dup+0xa3>

008018f2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	53                   	push   %ebx
  8018f6:	83 ec 1c             	sub    $0x1c,%esp
  8018f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018ff:	50                   	push   %eax
  801900:	53                   	push   %ebx
  801901:	e8 7c fd ff ff       	call   801682 <fd_lookup>
  801906:	83 c4 10             	add    $0x10,%esp
  801909:	85 c0                	test   %eax,%eax
  80190b:	78 3f                	js     80194c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80190d:	83 ec 08             	sub    $0x8,%esp
  801910:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801913:	50                   	push   %eax
  801914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801917:	ff 30                	pushl  (%eax)
  801919:	e8 b4 fd ff ff       	call   8016d2 <dev_lookup>
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	85 c0                	test   %eax,%eax
  801923:	78 27                	js     80194c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801925:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801928:	8b 42 08             	mov    0x8(%edx),%eax
  80192b:	83 e0 03             	and    $0x3,%eax
  80192e:	83 f8 01             	cmp    $0x1,%eax
  801931:	74 1e                	je     801951 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801936:	8b 40 08             	mov    0x8(%eax),%eax
  801939:	85 c0                	test   %eax,%eax
  80193b:	74 35                	je     801972 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80193d:	83 ec 04             	sub    $0x4,%esp
  801940:	ff 75 10             	pushl  0x10(%ebp)
  801943:	ff 75 0c             	pushl  0xc(%ebp)
  801946:	52                   	push   %edx
  801947:	ff d0                	call   *%eax
  801949:	83 c4 10             	add    $0x10,%esp
}
  80194c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80194f:	c9                   	leave  
  801950:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801951:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801956:	8b 40 48             	mov    0x48(%eax),%eax
  801959:	83 ec 04             	sub    $0x4,%esp
  80195c:	53                   	push   %ebx
  80195d:	50                   	push   %eax
  80195e:	68 09 30 80 00       	push   $0x803009
  801963:	e8 84 e8 ff ff       	call   8001ec <cprintf>
		return -E_INVAL;
  801968:	83 c4 10             	add    $0x10,%esp
  80196b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801970:	eb da                	jmp    80194c <read+0x5a>
		return -E_NOT_SUPP;
  801972:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801977:	eb d3                	jmp    80194c <read+0x5a>

00801979 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	57                   	push   %edi
  80197d:	56                   	push   %esi
  80197e:	53                   	push   %ebx
  80197f:	83 ec 0c             	sub    $0xc,%esp
  801982:	8b 7d 08             	mov    0x8(%ebp),%edi
  801985:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801988:	bb 00 00 00 00       	mov    $0x0,%ebx
  80198d:	39 f3                	cmp    %esi,%ebx
  80198f:	73 23                	jae    8019b4 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	89 f0                	mov    %esi,%eax
  801996:	29 d8                	sub    %ebx,%eax
  801998:	50                   	push   %eax
  801999:	89 d8                	mov    %ebx,%eax
  80199b:	03 45 0c             	add    0xc(%ebp),%eax
  80199e:	50                   	push   %eax
  80199f:	57                   	push   %edi
  8019a0:	e8 4d ff ff ff       	call   8018f2 <read>
		if (m < 0)
  8019a5:	83 c4 10             	add    $0x10,%esp
  8019a8:	85 c0                	test   %eax,%eax
  8019aa:	78 06                	js     8019b2 <readn+0x39>
			return m;
		if (m == 0)
  8019ac:	74 06                	je     8019b4 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8019ae:	01 c3                	add    %eax,%ebx
  8019b0:	eb db                	jmp    80198d <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019b2:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019b4:	89 d8                	mov    %ebx,%eax
  8019b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019b9:	5b                   	pop    %ebx
  8019ba:	5e                   	pop    %esi
  8019bb:	5f                   	pop    %edi
  8019bc:	5d                   	pop    %ebp
  8019bd:	c3                   	ret    

008019be <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	53                   	push   %ebx
  8019c2:	83 ec 1c             	sub    $0x1c,%esp
  8019c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019cb:	50                   	push   %eax
  8019cc:	53                   	push   %ebx
  8019cd:	e8 b0 fc ff ff       	call   801682 <fd_lookup>
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	85 c0                	test   %eax,%eax
  8019d7:	78 3a                	js     801a13 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019d9:	83 ec 08             	sub    $0x8,%esp
  8019dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019df:	50                   	push   %eax
  8019e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e3:	ff 30                	pushl  (%eax)
  8019e5:	e8 e8 fc ff ff       	call   8016d2 <dev_lookup>
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	78 22                	js     801a13 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019f8:	74 1e                	je     801a18 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019fd:	8b 52 0c             	mov    0xc(%edx),%edx
  801a00:	85 d2                	test   %edx,%edx
  801a02:	74 35                	je     801a39 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a04:	83 ec 04             	sub    $0x4,%esp
  801a07:	ff 75 10             	pushl  0x10(%ebp)
  801a0a:	ff 75 0c             	pushl  0xc(%ebp)
  801a0d:	50                   	push   %eax
  801a0e:	ff d2                	call   *%edx
  801a10:	83 c4 10             	add    $0x10,%esp
}
  801a13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a18:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801a1d:	8b 40 48             	mov    0x48(%eax),%eax
  801a20:	83 ec 04             	sub    $0x4,%esp
  801a23:	53                   	push   %ebx
  801a24:	50                   	push   %eax
  801a25:	68 25 30 80 00       	push   $0x803025
  801a2a:	e8 bd e7 ff ff       	call   8001ec <cprintf>
		return -E_INVAL;
  801a2f:	83 c4 10             	add    $0x10,%esp
  801a32:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a37:	eb da                	jmp    801a13 <write+0x55>
		return -E_NOT_SUPP;
  801a39:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a3e:	eb d3                	jmp    801a13 <write+0x55>

00801a40 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a49:	50                   	push   %eax
  801a4a:	ff 75 08             	pushl  0x8(%ebp)
  801a4d:	e8 30 fc ff ff       	call   801682 <fd_lookup>
  801a52:	83 c4 10             	add    $0x10,%esp
  801a55:	85 c0                	test   %eax,%eax
  801a57:	78 0e                	js     801a67 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	53                   	push   %ebx
  801a6d:	83 ec 1c             	sub    $0x1c,%esp
  801a70:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a73:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a76:	50                   	push   %eax
  801a77:	53                   	push   %ebx
  801a78:	e8 05 fc ff ff       	call   801682 <fd_lookup>
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	85 c0                	test   %eax,%eax
  801a82:	78 37                	js     801abb <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a84:	83 ec 08             	sub    $0x8,%esp
  801a87:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a8a:	50                   	push   %eax
  801a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8e:	ff 30                	pushl  (%eax)
  801a90:	e8 3d fc ff ff       	call   8016d2 <dev_lookup>
  801a95:	83 c4 10             	add    $0x10,%esp
  801a98:	85 c0                	test   %eax,%eax
  801a9a:	78 1f                	js     801abb <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801aa3:	74 1b                	je     801ac0 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801aa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa8:	8b 52 18             	mov    0x18(%edx),%edx
  801aab:	85 d2                	test   %edx,%edx
  801aad:	74 32                	je     801ae1 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801aaf:	83 ec 08             	sub    $0x8,%esp
  801ab2:	ff 75 0c             	pushl  0xc(%ebp)
  801ab5:	50                   	push   %eax
  801ab6:	ff d2                	call   *%edx
  801ab8:	83 c4 10             	add    $0x10,%esp
}
  801abb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    
			thisenv->env_id, fdnum);
  801ac0:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ac5:	8b 40 48             	mov    0x48(%eax),%eax
  801ac8:	83 ec 04             	sub    $0x4,%esp
  801acb:	53                   	push   %ebx
  801acc:	50                   	push   %eax
  801acd:	68 e8 2f 80 00       	push   $0x802fe8
  801ad2:	e8 15 e7 ff ff       	call   8001ec <cprintf>
		return -E_INVAL;
  801ad7:	83 c4 10             	add    $0x10,%esp
  801ada:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801adf:	eb da                	jmp    801abb <ftruncate+0x52>
		return -E_NOT_SUPP;
  801ae1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ae6:	eb d3                	jmp    801abb <ftruncate+0x52>

00801ae8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	53                   	push   %ebx
  801aec:	83 ec 1c             	sub    $0x1c,%esp
  801aef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801af2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801af5:	50                   	push   %eax
  801af6:	ff 75 08             	pushl  0x8(%ebp)
  801af9:	e8 84 fb ff ff       	call   801682 <fd_lookup>
  801afe:	83 c4 10             	add    $0x10,%esp
  801b01:	85 c0                	test   %eax,%eax
  801b03:	78 4b                	js     801b50 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b05:	83 ec 08             	sub    $0x8,%esp
  801b08:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0b:	50                   	push   %eax
  801b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0f:	ff 30                	pushl  (%eax)
  801b11:	e8 bc fb ff ff       	call   8016d2 <dev_lookup>
  801b16:	83 c4 10             	add    $0x10,%esp
  801b19:	85 c0                	test   %eax,%eax
  801b1b:	78 33                	js     801b50 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b20:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b24:	74 2f                	je     801b55 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b26:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b29:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b30:	00 00 00 
	stat->st_isdir = 0;
  801b33:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b3a:	00 00 00 
	stat->st_dev = dev;
  801b3d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b43:	83 ec 08             	sub    $0x8,%esp
  801b46:	53                   	push   %ebx
  801b47:	ff 75 f0             	pushl  -0x10(%ebp)
  801b4a:	ff 50 14             	call   *0x14(%eax)
  801b4d:	83 c4 10             	add    $0x10,%esp
}
  801b50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    
		return -E_NOT_SUPP;
  801b55:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b5a:	eb f4                	jmp    801b50 <fstat+0x68>

00801b5c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	56                   	push   %esi
  801b60:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b61:	83 ec 08             	sub    $0x8,%esp
  801b64:	6a 00                	push   $0x0
  801b66:	ff 75 08             	pushl  0x8(%ebp)
  801b69:	e8 22 02 00 00       	call   801d90 <open>
  801b6e:	89 c3                	mov    %eax,%ebx
  801b70:	83 c4 10             	add    $0x10,%esp
  801b73:	85 c0                	test   %eax,%eax
  801b75:	78 1b                	js     801b92 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b77:	83 ec 08             	sub    $0x8,%esp
  801b7a:	ff 75 0c             	pushl  0xc(%ebp)
  801b7d:	50                   	push   %eax
  801b7e:	e8 65 ff ff ff       	call   801ae8 <fstat>
  801b83:	89 c6                	mov    %eax,%esi
	close(fd);
  801b85:	89 1c 24             	mov    %ebx,(%esp)
  801b88:	e8 27 fc ff ff       	call   8017b4 <close>
	return r;
  801b8d:	83 c4 10             	add    $0x10,%esp
  801b90:	89 f3                	mov    %esi,%ebx
}
  801b92:	89 d8                	mov    %ebx,%eax
  801b94:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b97:	5b                   	pop    %ebx
  801b98:	5e                   	pop    %esi
  801b99:	5d                   	pop    %ebp
  801b9a:	c3                   	ret    

00801b9b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	56                   	push   %esi
  801b9f:	53                   	push   %ebx
  801ba0:	89 c6                	mov    %eax,%esi
  801ba2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801ba4:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801bab:	74 27                	je     801bd4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bad:	6a 07                	push   $0x7
  801baf:	68 00 60 80 00       	push   $0x806000
  801bb4:	56                   	push   %esi
  801bb5:	ff 35 00 50 80 00    	pushl  0x805000
  801bbb:	e8 b6 f9 ff ff       	call   801576 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bc0:	83 c4 0c             	add    $0xc,%esp
  801bc3:	6a 00                	push   $0x0
  801bc5:	53                   	push   %ebx
  801bc6:	6a 00                	push   $0x0
  801bc8:	e8 40 f9 ff ff       	call   80150d <ipc_recv>
}
  801bcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd0:	5b                   	pop    %ebx
  801bd1:	5e                   	pop    %esi
  801bd2:	5d                   	pop    %ebp
  801bd3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bd4:	83 ec 0c             	sub    $0xc,%esp
  801bd7:	6a 01                	push   $0x1
  801bd9:	e8 f0 f9 ff ff       	call   8015ce <ipc_find_env>
  801bde:	a3 00 50 80 00       	mov    %eax,0x805000
  801be3:	83 c4 10             	add    $0x10,%esp
  801be6:	eb c5                	jmp    801bad <fsipc+0x12>

00801be8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bfc:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c01:	ba 00 00 00 00       	mov    $0x0,%edx
  801c06:	b8 02 00 00 00       	mov    $0x2,%eax
  801c0b:	e8 8b ff ff ff       	call   801b9b <fsipc>
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <devfile_flush>:
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	8b 40 0c             	mov    0xc(%eax),%eax
  801c1e:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c23:	ba 00 00 00 00       	mov    $0x0,%edx
  801c28:	b8 06 00 00 00       	mov    $0x6,%eax
  801c2d:	e8 69 ff ff ff       	call   801b9b <fsipc>
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <devfile_stat>:
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	53                   	push   %ebx
  801c38:	83 ec 04             	sub    $0x4,%esp
  801c3b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	8b 40 0c             	mov    0xc(%eax),%eax
  801c44:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c49:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4e:	b8 05 00 00 00       	mov    $0x5,%eax
  801c53:	e8 43 ff ff ff       	call   801b9b <fsipc>
  801c58:	85 c0                	test   %eax,%eax
  801c5a:	78 2c                	js     801c88 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c5c:	83 ec 08             	sub    $0x8,%esp
  801c5f:	68 00 60 80 00       	push   $0x806000
  801c64:	53                   	push   %ebx
  801c65:	e8 e1 ec ff ff       	call   80094b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c6a:	a1 80 60 80 00       	mov    0x806080,%eax
  801c6f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c75:	a1 84 60 80 00       	mov    0x806084,%eax
  801c7a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <devfile_write>:
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	53                   	push   %ebx
  801c91:	83 ec 08             	sub    $0x8,%esp
  801c94:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c9d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801ca2:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ca8:	53                   	push   %ebx
  801ca9:	ff 75 0c             	pushl  0xc(%ebp)
  801cac:	68 08 60 80 00       	push   $0x806008
  801cb1:	e8 85 ee ff ff       	call   800b3b <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801cb6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbb:	b8 04 00 00 00       	mov    $0x4,%eax
  801cc0:	e8 d6 fe ff ff       	call   801b9b <fsipc>
  801cc5:	83 c4 10             	add    $0x10,%esp
  801cc8:	85 c0                	test   %eax,%eax
  801cca:	78 0b                	js     801cd7 <devfile_write+0x4a>
	assert(r <= n);
  801ccc:	39 d8                	cmp    %ebx,%eax
  801cce:	77 0c                	ja     801cdc <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801cd0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cd5:	7f 1e                	jg     801cf5 <devfile_write+0x68>
}
  801cd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    
	assert(r <= n);
  801cdc:	68 58 30 80 00       	push   $0x803058
  801ce1:	68 5f 30 80 00       	push   $0x80305f
  801ce6:	68 98 00 00 00       	push   $0x98
  801ceb:	68 74 30 80 00       	push   $0x803074
  801cf0:	e8 6a 0a 00 00       	call   80275f <_panic>
	assert(r <= PGSIZE);
  801cf5:	68 7f 30 80 00       	push   $0x80307f
  801cfa:	68 5f 30 80 00       	push   $0x80305f
  801cff:	68 99 00 00 00       	push   $0x99
  801d04:	68 74 30 80 00       	push   $0x803074
  801d09:	e8 51 0a 00 00       	call   80275f <_panic>

00801d0e <devfile_read>:
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	56                   	push   %esi
  801d12:	53                   	push   %ebx
  801d13:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	8b 40 0c             	mov    0xc(%eax),%eax
  801d1c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d21:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d27:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2c:	b8 03 00 00 00       	mov    $0x3,%eax
  801d31:	e8 65 fe ff ff       	call   801b9b <fsipc>
  801d36:	89 c3                	mov    %eax,%ebx
  801d38:	85 c0                	test   %eax,%eax
  801d3a:	78 1f                	js     801d5b <devfile_read+0x4d>
	assert(r <= n);
  801d3c:	39 f0                	cmp    %esi,%eax
  801d3e:	77 24                	ja     801d64 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d40:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d45:	7f 33                	jg     801d7a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d47:	83 ec 04             	sub    $0x4,%esp
  801d4a:	50                   	push   %eax
  801d4b:	68 00 60 80 00       	push   $0x806000
  801d50:	ff 75 0c             	pushl  0xc(%ebp)
  801d53:	e8 81 ed ff ff       	call   800ad9 <memmove>
	return r;
  801d58:	83 c4 10             	add    $0x10,%esp
}
  801d5b:	89 d8                	mov    %ebx,%eax
  801d5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d60:	5b                   	pop    %ebx
  801d61:	5e                   	pop    %esi
  801d62:	5d                   	pop    %ebp
  801d63:	c3                   	ret    
	assert(r <= n);
  801d64:	68 58 30 80 00       	push   $0x803058
  801d69:	68 5f 30 80 00       	push   $0x80305f
  801d6e:	6a 7c                	push   $0x7c
  801d70:	68 74 30 80 00       	push   $0x803074
  801d75:	e8 e5 09 00 00       	call   80275f <_panic>
	assert(r <= PGSIZE);
  801d7a:	68 7f 30 80 00       	push   $0x80307f
  801d7f:	68 5f 30 80 00       	push   $0x80305f
  801d84:	6a 7d                	push   $0x7d
  801d86:	68 74 30 80 00       	push   $0x803074
  801d8b:	e8 cf 09 00 00       	call   80275f <_panic>

00801d90 <open>:
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	56                   	push   %esi
  801d94:	53                   	push   %ebx
  801d95:	83 ec 1c             	sub    $0x1c,%esp
  801d98:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d9b:	56                   	push   %esi
  801d9c:	e8 71 eb ff ff       	call   800912 <strlen>
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801da9:	7f 6c                	jg     801e17 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801dab:	83 ec 0c             	sub    $0xc,%esp
  801dae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801db1:	50                   	push   %eax
  801db2:	e8 79 f8 ff ff       	call   801630 <fd_alloc>
  801db7:	89 c3                	mov    %eax,%ebx
  801db9:	83 c4 10             	add    $0x10,%esp
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	78 3c                	js     801dfc <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801dc0:	83 ec 08             	sub    $0x8,%esp
  801dc3:	56                   	push   %esi
  801dc4:	68 00 60 80 00       	push   $0x806000
  801dc9:	e8 7d eb ff ff       	call   80094b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd1:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801dd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dde:	e8 b8 fd ff ff       	call   801b9b <fsipc>
  801de3:	89 c3                	mov    %eax,%ebx
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	85 c0                	test   %eax,%eax
  801dea:	78 19                	js     801e05 <open+0x75>
	return fd2num(fd);
  801dec:	83 ec 0c             	sub    $0xc,%esp
  801def:	ff 75 f4             	pushl  -0xc(%ebp)
  801df2:	e8 12 f8 ff ff       	call   801609 <fd2num>
  801df7:	89 c3                	mov    %eax,%ebx
  801df9:	83 c4 10             	add    $0x10,%esp
}
  801dfc:	89 d8                	mov    %ebx,%eax
  801dfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e01:	5b                   	pop    %ebx
  801e02:	5e                   	pop    %esi
  801e03:	5d                   	pop    %ebp
  801e04:	c3                   	ret    
		fd_close(fd, 0);
  801e05:	83 ec 08             	sub    $0x8,%esp
  801e08:	6a 00                	push   $0x0
  801e0a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e0d:	e8 1b f9 ff ff       	call   80172d <fd_close>
		return r;
  801e12:	83 c4 10             	add    $0x10,%esp
  801e15:	eb e5                	jmp    801dfc <open+0x6c>
		return -E_BAD_PATH;
  801e17:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e1c:	eb de                	jmp    801dfc <open+0x6c>

00801e1e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e24:	ba 00 00 00 00       	mov    $0x0,%edx
  801e29:	b8 08 00 00 00       	mov    $0x8,%eax
  801e2e:	e8 68 fd ff ff       	call   801b9b <fsipc>
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e3b:	68 8b 30 80 00       	push   $0x80308b
  801e40:	ff 75 0c             	pushl  0xc(%ebp)
  801e43:	e8 03 eb ff ff       	call   80094b <strcpy>
	return 0;
}
  801e48:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <devsock_close>:
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	53                   	push   %ebx
  801e53:	83 ec 10             	sub    $0x10,%esp
  801e56:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e59:	53                   	push   %ebx
  801e5a:	e8 f6 09 00 00       	call   802855 <pageref>
  801e5f:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e62:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e67:	83 f8 01             	cmp    $0x1,%eax
  801e6a:	74 07                	je     801e73 <devsock_close+0x24>
}
  801e6c:	89 d0                	mov    %edx,%eax
  801e6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e73:	83 ec 0c             	sub    $0xc,%esp
  801e76:	ff 73 0c             	pushl  0xc(%ebx)
  801e79:	e8 b9 02 00 00       	call   802137 <nsipc_close>
  801e7e:	89 c2                	mov    %eax,%edx
  801e80:	83 c4 10             	add    $0x10,%esp
  801e83:	eb e7                	jmp    801e6c <devsock_close+0x1d>

00801e85 <devsock_write>:
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	ff 75 10             	pushl  0x10(%ebp)
  801e90:	ff 75 0c             	pushl  0xc(%ebp)
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	ff 70 0c             	pushl  0xc(%eax)
  801e99:	e8 76 03 00 00       	call   802214 <nsipc_send>
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <devsock_read>:
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ea6:	6a 00                	push   $0x0
  801ea8:	ff 75 10             	pushl  0x10(%ebp)
  801eab:	ff 75 0c             	pushl  0xc(%ebp)
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	ff 70 0c             	pushl  0xc(%eax)
  801eb4:	e8 ef 02 00 00       	call   8021a8 <nsipc_recv>
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <fd2sockid>:
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ec1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ec4:	52                   	push   %edx
  801ec5:	50                   	push   %eax
  801ec6:	e8 b7 f7 ff ff       	call   801682 <fd_lookup>
  801ecb:	83 c4 10             	add    $0x10,%esp
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	78 10                	js     801ee2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801edb:	39 08                	cmp    %ecx,(%eax)
  801edd:	75 05                	jne    801ee4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801edf:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    
		return -E_NOT_SUPP;
  801ee4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ee9:	eb f7                	jmp    801ee2 <fd2sockid+0x27>

00801eeb <alloc_sockfd>:
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	56                   	push   %esi
  801eef:	53                   	push   %ebx
  801ef0:	83 ec 1c             	sub    $0x1c,%esp
  801ef3:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ef5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef8:	50                   	push   %eax
  801ef9:	e8 32 f7 ff ff       	call   801630 <fd_alloc>
  801efe:	89 c3                	mov    %eax,%ebx
  801f00:	83 c4 10             	add    $0x10,%esp
  801f03:	85 c0                	test   %eax,%eax
  801f05:	78 43                	js     801f4a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f07:	83 ec 04             	sub    $0x4,%esp
  801f0a:	68 07 04 00 00       	push   $0x407
  801f0f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f12:	6a 00                	push   $0x0
  801f14:	e8 24 ee ff ff       	call   800d3d <sys_page_alloc>
  801f19:	89 c3                	mov    %eax,%ebx
  801f1b:	83 c4 10             	add    $0x10,%esp
  801f1e:	85 c0                	test   %eax,%eax
  801f20:	78 28                	js     801f4a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f25:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f2b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f30:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f37:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f3a:	83 ec 0c             	sub    $0xc,%esp
  801f3d:	50                   	push   %eax
  801f3e:	e8 c6 f6 ff ff       	call   801609 <fd2num>
  801f43:	89 c3                	mov    %eax,%ebx
  801f45:	83 c4 10             	add    $0x10,%esp
  801f48:	eb 0c                	jmp    801f56 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f4a:	83 ec 0c             	sub    $0xc,%esp
  801f4d:	56                   	push   %esi
  801f4e:	e8 e4 01 00 00       	call   802137 <nsipc_close>
		return r;
  801f53:	83 c4 10             	add    $0x10,%esp
}
  801f56:	89 d8                	mov    %ebx,%eax
  801f58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f5b:	5b                   	pop    %ebx
  801f5c:	5e                   	pop    %esi
  801f5d:	5d                   	pop    %ebp
  801f5e:	c3                   	ret    

00801f5f <accept>:
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	e8 4e ff ff ff       	call   801ebb <fd2sockid>
  801f6d:	85 c0                	test   %eax,%eax
  801f6f:	78 1b                	js     801f8c <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f71:	83 ec 04             	sub    $0x4,%esp
  801f74:	ff 75 10             	pushl  0x10(%ebp)
  801f77:	ff 75 0c             	pushl  0xc(%ebp)
  801f7a:	50                   	push   %eax
  801f7b:	e8 0e 01 00 00       	call   80208e <nsipc_accept>
  801f80:	83 c4 10             	add    $0x10,%esp
  801f83:	85 c0                	test   %eax,%eax
  801f85:	78 05                	js     801f8c <accept+0x2d>
	return alloc_sockfd(r);
  801f87:	e8 5f ff ff ff       	call   801eeb <alloc_sockfd>
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <bind>:
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	e8 1f ff ff ff       	call   801ebb <fd2sockid>
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	78 12                	js     801fb2 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801fa0:	83 ec 04             	sub    $0x4,%esp
  801fa3:	ff 75 10             	pushl  0x10(%ebp)
  801fa6:	ff 75 0c             	pushl  0xc(%ebp)
  801fa9:	50                   	push   %eax
  801faa:	e8 31 01 00 00       	call   8020e0 <nsipc_bind>
  801faf:	83 c4 10             	add    $0x10,%esp
}
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <shutdown>:
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fba:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbd:	e8 f9 fe ff ff       	call   801ebb <fd2sockid>
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	78 0f                	js     801fd5 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801fc6:	83 ec 08             	sub    $0x8,%esp
  801fc9:	ff 75 0c             	pushl  0xc(%ebp)
  801fcc:	50                   	push   %eax
  801fcd:	e8 43 01 00 00       	call   802115 <nsipc_shutdown>
  801fd2:	83 c4 10             	add    $0x10,%esp
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <connect>:
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	e8 d6 fe ff ff       	call   801ebb <fd2sockid>
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	78 12                	js     801ffb <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801fe9:	83 ec 04             	sub    $0x4,%esp
  801fec:	ff 75 10             	pushl  0x10(%ebp)
  801fef:	ff 75 0c             	pushl  0xc(%ebp)
  801ff2:	50                   	push   %eax
  801ff3:	e8 59 01 00 00       	call   802151 <nsipc_connect>
  801ff8:	83 c4 10             	add    $0x10,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <listen>:
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
  802000:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802003:	8b 45 08             	mov    0x8(%ebp),%eax
  802006:	e8 b0 fe ff ff       	call   801ebb <fd2sockid>
  80200b:	85 c0                	test   %eax,%eax
  80200d:	78 0f                	js     80201e <listen+0x21>
	return nsipc_listen(r, backlog);
  80200f:	83 ec 08             	sub    $0x8,%esp
  802012:	ff 75 0c             	pushl  0xc(%ebp)
  802015:	50                   	push   %eax
  802016:	e8 6b 01 00 00       	call   802186 <nsipc_listen>
  80201b:	83 c4 10             	add    $0x10,%esp
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <socket>:

int
socket(int domain, int type, int protocol)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802026:	ff 75 10             	pushl  0x10(%ebp)
  802029:	ff 75 0c             	pushl  0xc(%ebp)
  80202c:	ff 75 08             	pushl  0x8(%ebp)
  80202f:	e8 3e 02 00 00       	call   802272 <nsipc_socket>
  802034:	83 c4 10             	add    $0x10,%esp
  802037:	85 c0                	test   %eax,%eax
  802039:	78 05                	js     802040 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80203b:	e8 ab fe ff ff       	call   801eeb <alloc_sockfd>
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	53                   	push   %ebx
  802046:	83 ec 04             	sub    $0x4,%esp
  802049:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80204b:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802052:	74 26                	je     80207a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802054:	6a 07                	push   $0x7
  802056:	68 00 70 80 00       	push   $0x807000
  80205b:	53                   	push   %ebx
  80205c:	ff 35 04 50 80 00    	pushl  0x805004
  802062:	e8 0f f5 ff ff       	call   801576 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802067:	83 c4 0c             	add    $0xc,%esp
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	e8 98 f4 ff ff       	call   80150d <ipc_recv>
}
  802075:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802078:	c9                   	leave  
  802079:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80207a:	83 ec 0c             	sub    $0xc,%esp
  80207d:	6a 02                	push   $0x2
  80207f:	e8 4a f5 ff ff       	call   8015ce <ipc_find_env>
  802084:	a3 04 50 80 00       	mov    %eax,0x805004
  802089:	83 c4 10             	add    $0x10,%esp
  80208c:	eb c6                	jmp    802054 <nsipc+0x12>

0080208e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	56                   	push   %esi
  802092:	53                   	push   %ebx
  802093:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80209e:	8b 06                	mov    (%esi),%eax
  8020a0:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8020aa:	e8 93 ff ff ff       	call   802042 <nsipc>
  8020af:	89 c3                	mov    %eax,%ebx
  8020b1:	85 c0                	test   %eax,%eax
  8020b3:	79 09                	jns    8020be <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8020b5:	89 d8                	mov    %ebx,%eax
  8020b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ba:	5b                   	pop    %ebx
  8020bb:	5e                   	pop    %esi
  8020bc:	5d                   	pop    %ebp
  8020bd:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020be:	83 ec 04             	sub    $0x4,%esp
  8020c1:	ff 35 10 70 80 00    	pushl  0x807010
  8020c7:	68 00 70 80 00       	push   $0x807000
  8020cc:	ff 75 0c             	pushl  0xc(%ebp)
  8020cf:	e8 05 ea ff ff       	call   800ad9 <memmove>
		*addrlen = ret->ret_addrlen;
  8020d4:	a1 10 70 80 00       	mov    0x807010,%eax
  8020d9:	89 06                	mov    %eax,(%esi)
  8020db:	83 c4 10             	add    $0x10,%esp
	return r;
  8020de:	eb d5                	jmp    8020b5 <nsipc_accept+0x27>

008020e0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	53                   	push   %ebx
  8020e4:	83 ec 08             	sub    $0x8,%esp
  8020e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020f2:	53                   	push   %ebx
  8020f3:	ff 75 0c             	pushl  0xc(%ebp)
  8020f6:	68 04 70 80 00       	push   $0x807004
  8020fb:	e8 d9 e9 ff ff       	call   800ad9 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802100:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802106:	b8 02 00 00 00       	mov    $0x2,%eax
  80210b:	e8 32 ff ff ff       	call   802042 <nsipc>
}
  802110:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802123:	8b 45 0c             	mov    0xc(%ebp),%eax
  802126:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80212b:	b8 03 00 00 00       	mov    $0x3,%eax
  802130:	e8 0d ff ff ff       	call   802042 <nsipc>
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <nsipc_close>:

int
nsipc_close(int s)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802145:	b8 04 00 00 00       	mov    $0x4,%eax
  80214a:	e8 f3 fe ff ff       	call   802042 <nsipc>
}
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	53                   	push   %ebx
  802155:	83 ec 08             	sub    $0x8,%esp
  802158:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802163:	53                   	push   %ebx
  802164:	ff 75 0c             	pushl  0xc(%ebp)
  802167:	68 04 70 80 00       	push   $0x807004
  80216c:	e8 68 e9 ff ff       	call   800ad9 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802171:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802177:	b8 05 00 00 00       	mov    $0x5,%eax
  80217c:	e8 c1 fe ff ff       	call   802042 <nsipc>
}
  802181:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802194:	8b 45 0c             	mov    0xc(%ebp),%eax
  802197:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80219c:	b8 06 00 00 00       	mov    $0x6,%eax
  8021a1:	e8 9c fe ff ff       	call   802042 <nsipc>
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	56                   	push   %esi
  8021ac:	53                   	push   %ebx
  8021ad:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021b8:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021be:	8b 45 14             	mov    0x14(%ebp),%eax
  8021c1:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021c6:	b8 07 00 00 00       	mov    $0x7,%eax
  8021cb:	e8 72 fe ff ff       	call   802042 <nsipc>
  8021d0:	89 c3                	mov    %eax,%ebx
  8021d2:	85 c0                	test   %eax,%eax
  8021d4:	78 1f                	js     8021f5 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021d6:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021db:	7f 21                	jg     8021fe <nsipc_recv+0x56>
  8021dd:	39 c6                	cmp    %eax,%esi
  8021df:	7c 1d                	jl     8021fe <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021e1:	83 ec 04             	sub    $0x4,%esp
  8021e4:	50                   	push   %eax
  8021e5:	68 00 70 80 00       	push   $0x807000
  8021ea:	ff 75 0c             	pushl  0xc(%ebp)
  8021ed:	e8 e7 e8 ff ff       	call   800ad9 <memmove>
  8021f2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8021f5:	89 d8                	mov    %ebx,%eax
  8021f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021fa:	5b                   	pop    %ebx
  8021fb:	5e                   	pop    %esi
  8021fc:	5d                   	pop    %ebp
  8021fd:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021fe:	68 97 30 80 00       	push   $0x803097
  802203:	68 5f 30 80 00       	push   $0x80305f
  802208:	6a 62                	push   $0x62
  80220a:	68 ac 30 80 00       	push   $0x8030ac
  80220f:	e8 4b 05 00 00       	call   80275f <_panic>

00802214 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	53                   	push   %ebx
  802218:	83 ec 04             	sub    $0x4,%esp
  80221b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802226:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80222c:	7f 2e                	jg     80225c <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80222e:	83 ec 04             	sub    $0x4,%esp
  802231:	53                   	push   %ebx
  802232:	ff 75 0c             	pushl  0xc(%ebp)
  802235:	68 0c 70 80 00       	push   $0x80700c
  80223a:	e8 9a e8 ff ff       	call   800ad9 <memmove>
	nsipcbuf.send.req_size = size;
  80223f:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802245:	8b 45 14             	mov    0x14(%ebp),%eax
  802248:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80224d:	b8 08 00 00 00       	mov    $0x8,%eax
  802252:	e8 eb fd ff ff       	call   802042 <nsipc>
}
  802257:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    
	assert(size < 1600);
  80225c:	68 b8 30 80 00       	push   $0x8030b8
  802261:	68 5f 30 80 00       	push   $0x80305f
  802266:	6a 6d                	push   $0x6d
  802268:	68 ac 30 80 00       	push   $0x8030ac
  80226d:	e8 ed 04 00 00       	call   80275f <_panic>

00802272 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
  802275:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802280:	8b 45 0c             	mov    0xc(%ebp),%eax
  802283:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802288:	8b 45 10             	mov    0x10(%ebp),%eax
  80228b:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802290:	b8 09 00 00 00       	mov    $0x9,%eax
  802295:	e8 a8 fd ff ff       	call   802042 <nsipc>
}
  80229a:	c9                   	leave  
  80229b:	c3                   	ret    

0080229c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
  80229f:	56                   	push   %esi
  8022a0:	53                   	push   %ebx
  8022a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8022a4:	83 ec 0c             	sub    $0xc,%esp
  8022a7:	ff 75 08             	pushl  0x8(%ebp)
  8022aa:	e8 6a f3 ff ff       	call   801619 <fd2data>
  8022af:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8022b1:	83 c4 08             	add    $0x8,%esp
  8022b4:	68 c4 30 80 00       	push   $0x8030c4
  8022b9:	53                   	push   %ebx
  8022ba:	e8 8c e6 ff ff       	call   80094b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022bf:	8b 46 04             	mov    0x4(%esi),%eax
  8022c2:	2b 06                	sub    (%esi),%eax
  8022c4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022ca:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022d1:	00 00 00 
	stat->st_dev = &devpipe;
  8022d4:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8022db:	40 80 00 
	return 0;
}
  8022de:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022e6:	5b                   	pop    %ebx
  8022e7:	5e                   	pop    %esi
  8022e8:	5d                   	pop    %ebp
  8022e9:	c3                   	ret    

008022ea <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
  8022ed:	53                   	push   %ebx
  8022ee:	83 ec 0c             	sub    $0xc,%esp
  8022f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022f4:	53                   	push   %ebx
  8022f5:	6a 00                	push   $0x0
  8022f7:	e8 c6 ea ff ff       	call   800dc2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022fc:	89 1c 24             	mov    %ebx,(%esp)
  8022ff:	e8 15 f3 ff ff       	call   801619 <fd2data>
  802304:	83 c4 08             	add    $0x8,%esp
  802307:	50                   	push   %eax
  802308:	6a 00                	push   $0x0
  80230a:	e8 b3 ea ff ff       	call   800dc2 <sys_page_unmap>
}
  80230f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802312:	c9                   	leave  
  802313:	c3                   	ret    

00802314 <_pipeisclosed>:
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	57                   	push   %edi
  802318:	56                   	push   %esi
  802319:	53                   	push   %ebx
  80231a:	83 ec 1c             	sub    $0x1c,%esp
  80231d:	89 c7                	mov    %eax,%edi
  80231f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802321:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802326:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802329:	83 ec 0c             	sub    $0xc,%esp
  80232c:	57                   	push   %edi
  80232d:	e8 23 05 00 00       	call   802855 <pageref>
  802332:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802335:	89 34 24             	mov    %esi,(%esp)
  802338:	e8 18 05 00 00       	call   802855 <pageref>
		nn = thisenv->env_runs;
  80233d:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  802343:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802346:	83 c4 10             	add    $0x10,%esp
  802349:	39 cb                	cmp    %ecx,%ebx
  80234b:	74 1b                	je     802368 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80234d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802350:	75 cf                	jne    802321 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802352:	8b 42 58             	mov    0x58(%edx),%eax
  802355:	6a 01                	push   $0x1
  802357:	50                   	push   %eax
  802358:	53                   	push   %ebx
  802359:	68 cb 30 80 00       	push   $0x8030cb
  80235e:	e8 89 de ff ff       	call   8001ec <cprintf>
  802363:	83 c4 10             	add    $0x10,%esp
  802366:	eb b9                	jmp    802321 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802368:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80236b:	0f 94 c0             	sete   %al
  80236e:	0f b6 c0             	movzbl %al,%eax
}
  802371:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802374:	5b                   	pop    %ebx
  802375:	5e                   	pop    %esi
  802376:	5f                   	pop    %edi
  802377:	5d                   	pop    %ebp
  802378:	c3                   	ret    

00802379 <devpipe_write>:
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
  80237c:	57                   	push   %edi
  80237d:	56                   	push   %esi
  80237e:	53                   	push   %ebx
  80237f:	83 ec 28             	sub    $0x28,%esp
  802382:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802385:	56                   	push   %esi
  802386:	e8 8e f2 ff ff       	call   801619 <fd2data>
  80238b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80238d:	83 c4 10             	add    $0x10,%esp
  802390:	bf 00 00 00 00       	mov    $0x0,%edi
  802395:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802398:	74 4f                	je     8023e9 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80239a:	8b 43 04             	mov    0x4(%ebx),%eax
  80239d:	8b 0b                	mov    (%ebx),%ecx
  80239f:	8d 51 20             	lea    0x20(%ecx),%edx
  8023a2:	39 d0                	cmp    %edx,%eax
  8023a4:	72 14                	jb     8023ba <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8023a6:	89 da                	mov    %ebx,%edx
  8023a8:	89 f0                	mov    %esi,%eax
  8023aa:	e8 65 ff ff ff       	call   802314 <_pipeisclosed>
  8023af:	85 c0                	test   %eax,%eax
  8023b1:	75 3b                	jne    8023ee <devpipe_write+0x75>
			sys_yield();
  8023b3:	e8 66 e9 ff ff       	call   800d1e <sys_yield>
  8023b8:	eb e0                	jmp    80239a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023bd:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8023c1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8023c4:	89 c2                	mov    %eax,%edx
  8023c6:	c1 fa 1f             	sar    $0x1f,%edx
  8023c9:	89 d1                	mov    %edx,%ecx
  8023cb:	c1 e9 1b             	shr    $0x1b,%ecx
  8023ce:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8023d1:	83 e2 1f             	and    $0x1f,%edx
  8023d4:	29 ca                	sub    %ecx,%edx
  8023d6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8023da:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8023de:	83 c0 01             	add    $0x1,%eax
  8023e1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8023e4:	83 c7 01             	add    $0x1,%edi
  8023e7:	eb ac                	jmp    802395 <devpipe_write+0x1c>
	return i;
  8023e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ec:	eb 05                	jmp    8023f3 <devpipe_write+0x7a>
				return 0;
  8023ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023f6:	5b                   	pop    %ebx
  8023f7:	5e                   	pop    %esi
  8023f8:	5f                   	pop    %edi
  8023f9:	5d                   	pop    %ebp
  8023fa:	c3                   	ret    

008023fb <devpipe_read>:
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	57                   	push   %edi
  8023ff:	56                   	push   %esi
  802400:	53                   	push   %ebx
  802401:	83 ec 18             	sub    $0x18,%esp
  802404:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802407:	57                   	push   %edi
  802408:	e8 0c f2 ff ff       	call   801619 <fd2data>
  80240d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80240f:	83 c4 10             	add    $0x10,%esp
  802412:	be 00 00 00 00       	mov    $0x0,%esi
  802417:	3b 75 10             	cmp    0x10(%ebp),%esi
  80241a:	75 14                	jne    802430 <devpipe_read+0x35>
	return i;
  80241c:	8b 45 10             	mov    0x10(%ebp),%eax
  80241f:	eb 02                	jmp    802423 <devpipe_read+0x28>
				return i;
  802421:	89 f0                	mov    %esi,%eax
}
  802423:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802426:	5b                   	pop    %ebx
  802427:	5e                   	pop    %esi
  802428:	5f                   	pop    %edi
  802429:	5d                   	pop    %ebp
  80242a:	c3                   	ret    
			sys_yield();
  80242b:	e8 ee e8 ff ff       	call   800d1e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802430:	8b 03                	mov    (%ebx),%eax
  802432:	3b 43 04             	cmp    0x4(%ebx),%eax
  802435:	75 18                	jne    80244f <devpipe_read+0x54>
			if (i > 0)
  802437:	85 f6                	test   %esi,%esi
  802439:	75 e6                	jne    802421 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80243b:	89 da                	mov    %ebx,%edx
  80243d:	89 f8                	mov    %edi,%eax
  80243f:	e8 d0 fe ff ff       	call   802314 <_pipeisclosed>
  802444:	85 c0                	test   %eax,%eax
  802446:	74 e3                	je     80242b <devpipe_read+0x30>
				return 0;
  802448:	b8 00 00 00 00       	mov    $0x0,%eax
  80244d:	eb d4                	jmp    802423 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80244f:	99                   	cltd   
  802450:	c1 ea 1b             	shr    $0x1b,%edx
  802453:	01 d0                	add    %edx,%eax
  802455:	83 e0 1f             	and    $0x1f,%eax
  802458:	29 d0                	sub    %edx,%eax
  80245a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80245f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802462:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802465:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802468:	83 c6 01             	add    $0x1,%esi
  80246b:	eb aa                	jmp    802417 <devpipe_read+0x1c>

0080246d <pipe>:
{
  80246d:	55                   	push   %ebp
  80246e:	89 e5                	mov    %esp,%ebp
  802470:	56                   	push   %esi
  802471:	53                   	push   %ebx
  802472:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802475:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802478:	50                   	push   %eax
  802479:	e8 b2 f1 ff ff       	call   801630 <fd_alloc>
  80247e:	89 c3                	mov    %eax,%ebx
  802480:	83 c4 10             	add    $0x10,%esp
  802483:	85 c0                	test   %eax,%eax
  802485:	0f 88 23 01 00 00    	js     8025ae <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80248b:	83 ec 04             	sub    $0x4,%esp
  80248e:	68 07 04 00 00       	push   $0x407
  802493:	ff 75 f4             	pushl  -0xc(%ebp)
  802496:	6a 00                	push   $0x0
  802498:	e8 a0 e8 ff ff       	call   800d3d <sys_page_alloc>
  80249d:	89 c3                	mov    %eax,%ebx
  80249f:	83 c4 10             	add    $0x10,%esp
  8024a2:	85 c0                	test   %eax,%eax
  8024a4:	0f 88 04 01 00 00    	js     8025ae <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8024aa:	83 ec 0c             	sub    $0xc,%esp
  8024ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024b0:	50                   	push   %eax
  8024b1:	e8 7a f1 ff ff       	call   801630 <fd_alloc>
  8024b6:	89 c3                	mov    %eax,%ebx
  8024b8:	83 c4 10             	add    $0x10,%esp
  8024bb:	85 c0                	test   %eax,%eax
  8024bd:	0f 88 db 00 00 00    	js     80259e <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024c3:	83 ec 04             	sub    $0x4,%esp
  8024c6:	68 07 04 00 00       	push   $0x407
  8024cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8024ce:	6a 00                	push   $0x0
  8024d0:	e8 68 e8 ff ff       	call   800d3d <sys_page_alloc>
  8024d5:	89 c3                	mov    %eax,%ebx
  8024d7:	83 c4 10             	add    $0x10,%esp
  8024da:	85 c0                	test   %eax,%eax
  8024dc:	0f 88 bc 00 00 00    	js     80259e <pipe+0x131>
	va = fd2data(fd0);
  8024e2:	83 ec 0c             	sub    $0xc,%esp
  8024e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8024e8:	e8 2c f1 ff ff       	call   801619 <fd2data>
  8024ed:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024ef:	83 c4 0c             	add    $0xc,%esp
  8024f2:	68 07 04 00 00       	push   $0x407
  8024f7:	50                   	push   %eax
  8024f8:	6a 00                	push   $0x0
  8024fa:	e8 3e e8 ff ff       	call   800d3d <sys_page_alloc>
  8024ff:	89 c3                	mov    %eax,%ebx
  802501:	83 c4 10             	add    $0x10,%esp
  802504:	85 c0                	test   %eax,%eax
  802506:	0f 88 82 00 00 00    	js     80258e <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80250c:	83 ec 0c             	sub    $0xc,%esp
  80250f:	ff 75 f0             	pushl  -0x10(%ebp)
  802512:	e8 02 f1 ff ff       	call   801619 <fd2data>
  802517:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80251e:	50                   	push   %eax
  80251f:	6a 00                	push   $0x0
  802521:	56                   	push   %esi
  802522:	6a 00                	push   $0x0
  802524:	e8 57 e8 ff ff       	call   800d80 <sys_page_map>
  802529:	89 c3                	mov    %eax,%ebx
  80252b:	83 c4 20             	add    $0x20,%esp
  80252e:	85 c0                	test   %eax,%eax
  802530:	78 4e                	js     802580 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802532:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802537:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80253a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80253c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80253f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802546:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802549:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80254b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802555:	83 ec 0c             	sub    $0xc,%esp
  802558:	ff 75 f4             	pushl  -0xc(%ebp)
  80255b:	e8 a9 f0 ff ff       	call   801609 <fd2num>
  802560:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802563:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802565:	83 c4 04             	add    $0x4,%esp
  802568:	ff 75 f0             	pushl  -0x10(%ebp)
  80256b:	e8 99 f0 ff ff       	call   801609 <fd2num>
  802570:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802573:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802576:	83 c4 10             	add    $0x10,%esp
  802579:	bb 00 00 00 00       	mov    $0x0,%ebx
  80257e:	eb 2e                	jmp    8025ae <pipe+0x141>
	sys_page_unmap(0, va);
  802580:	83 ec 08             	sub    $0x8,%esp
  802583:	56                   	push   %esi
  802584:	6a 00                	push   $0x0
  802586:	e8 37 e8 ff ff       	call   800dc2 <sys_page_unmap>
  80258b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80258e:	83 ec 08             	sub    $0x8,%esp
  802591:	ff 75 f0             	pushl  -0x10(%ebp)
  802594:	6a 00                	push   $0x0
  802596:	e8 27 e8 ff ff       	call   800dc2 <sys_page_unmap>
  80259b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80259e:	83 ec 08             	sub    $0x8,%esp
  8025a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8025a4:	6a 00                	push   $0x0
  8025a6:	e8 17 e8 ff ff       	call   800dc2 <sys_page_unmap>
  8025ab:	83 c4 10             	add    $0x10,%esp
}
  8025ae:	89 d8                	mov    %ebx,%eax
  8025b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025b3:	5b                   	pop    %ebx
  8025b4:	5e                   	pop    %esi
  8025b5:	5d                   	pop    %ebp
  8025b6:	c3                   	ret    

008025b7 <pipeisclosed>:
{
  8025b7:	55                   	push   %ebp
  8025b8:	89 e5                	mov    %esp,%ebp
  8025ba:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025c0:	50                   	push   %eax
  8025c1:	ff 75 08             	pushl  0x8(%ebp)
  8025c4:	e8 b9 f0 ff ff       	call   801682 <fd_lookup>
  8025c9:	83 c4 10             	add    $0x10,%esp
  8025cc:	85 c0                	test   %eax,%eax
  8025ce:	78 18                	js     8025e8 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8025d0:	83 ec 0c             	sub    $0xc,%esp
  8025d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8025d6:	e8 3e f0 ff ff       	call   801619 <fd2data>
	return _pipeisclosed(fd, p);
  8025db:	89 c2                	mov    %eax,%edx
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	e8 2f fd ff ff       	call   802314 <_pipeisclosed>
  8025e5:	83 c4 10             	add    $0x10,%esp
}
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    

008025ea <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8025ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ef:	c3                   	ret    

008025f0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
  8025f3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8025f6:	68 e3 30 80 00       	push   $0x8030e3
  8025fb:	ff 75 0c             	pushl  0xc(%ebp)
  8025fe:	e8 48 e3 ff ff       	call   80094b <strcpy>
	return 0;
}
  802603:	b8 00 00 00 00       	mov    $0x0,%eax
  802608:	c9                   	leave  
  802609:	c3                   	ret    

0080260a <devcons_write>:
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	57                   	push   %edi
  80260e:	56                   	push   %esi
  80260f:	53                   	push   %ebx
  802610:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802616:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80261b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802621:	3b 75 10             	cmp    0x10(%ebp),%esi
  802624:	73 31                	jae    802657 <devcons_write+0x4d>
		m = n - tot;
  802626:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802629:	29 f3                	sub    %esi,%ebx
  80262b:	83 fb 7f             	cmp    $0x7f,%ebx
  80262e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802633:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802636:	83 ec 04             	sub    $0x4,%esp
  802639:	53                   	push   %ebx
  80263a:	89 f0                	mov    %esi,%eax
  80263c:	03 45 0c             	add    0xc(%ebp),%eax
  80263f:	50                   	push   %eax
  802640:	57                   	push   %edi
  802641:	e8 93 e4 ff ff       	call   800ad9 <memmove>
		sys_cputs(buf, m);
  802646:	83 c4 08             	add    $0x8,%esp
  802649:	53                   	push   %ebx
  80264a:	57                   	push   %edi
  80264b:	e8 31 e6 ff ff       	call   800c81 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802650:	01 de                	add    %ebx,%esi
  802652:	83 c4 10             	add    $0x10,%esp
  802655:	eb ca                	jmp    802621 <devcons_write+0x17>
}
  802657:	89 f0                	mov    %esi,%eax
  802659:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80265c:	5b                   	pop    %ebx
  80265d:	5e                   	pop    %esi
  80265e:	5f                   	pop    %edi
  80265f:	5d                   	pop    %ebp
  802660:	c3                   	ret    

00802661 <devcons_read>:
{
  802661:	55                   	push   %ebp
  802662:	89 e5                	mov    %esp,%ebp
  802664:	83 ec 08             	sub    $0x8,%esp
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80266c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802670:	74 21                	je     802693 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802672:	e8 28 e6 ff ff       	call   800c9f <sys_cgetc>
  802677:	85 c0                	test   %eax,%eax
  802679:	75 07                	jne    802682 <devcons_read+0x21>
		sys_yield();
  80267b:	e8 9e e6 ff ff       	call   800d1e <sys_yield>
  802680:	eb f0                	jmp    802672 <devcons_read+0x11>
	if (c < 0)
  802682:	78 0f                	js     802693 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802684:	83 f8 04             	cmp    $0x4,%eax
  802687:	74 0c                	je     802695 <devcons_read+0x34>
	*(char*)vbuf = c;
  802689:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268c:	88 02                	mov    %al,(%edx)
	return 1;
  80268e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802693:	c9                   	leave  
  802694:	c3                   	ret    
		return 0;
  802695:	b8 00 00 00 00       	mov    $0x0,%eax
  80269a:	eb f7                	jmp    802693 <devcons_read+0x32>

0080269c <cputchar>:
{
  80269c:	55                   	push   %ebp
  80269d:	89 e5                	mov    %esp,%ebp
  80269f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8026a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8026a8:	6a 01                	push   $0x1
  8026aa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026ad:	50                   	push   %eax
  8026ae:	e8 ce e5 ff ff       	call   800c81 <sys_cputs>
}
  8026b3:	83 c4 10             	add    $0x10,%esp
  8026b6:	c9                   	leave  
  8026b7:	c3                   	ret    

008026b8 <getchar>:
{
  8026b8:	55                   	push   %ebp
  8026b9:	89 e5                	mov    %esp,%ebp
  8026bb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8026be:	6a 01                	push   $0x1
  8026c0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026c3:	50                   	push   %eax
  8026c4:	6a 00                	push   $0x0
  8026c6:	e8 27 f2 ff ff       	call   8018f2 <read>
	if (r < 0)
  8026cb:	83 c4 10             	add    $0x10,%esp
  8026ce:	85 c0                	test   %eax,%eax
  8026d0:	78 06                	js     8026d8 <getchar+0x20>
	if (r < 1)
  8026d2:	74 06                	je     8026da <getchar+0x22>
	return c;
  8026d4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026d8:	c9                   	leave  
  8026d9:	c3                   	ret    
		return -E_EOF;
  8026da:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8026df:	eb f7                	jmp    8026d8 <getchar+0x20>

008026e1 <iscons>:
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
  8026e4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026ea:	50                   	push   %eax
  8026eb:	ff 75 08             	pushl  0x8(%ebp)
  8026ee:	e8 8f ef ff ff       	call   801682 <fd_lookup>
  8026f3:	83 c4 10             	add    $0x10,%esp
  8026f6:	85 c0                	test   %eax,%eax
  8026f8:	78 11                	js     80270b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802703:	39 10                	cmp    %edx,(%eax)
  802705:	0f 94 c0             	sete   %al
  802708:	0f b6 c0             	movzbl %al,%eax
}
  80270b:	c9                   	leave  
  80270c:	c3                   	ret    

0080270d <opencons>:
{
  80270d:	55                   	push   %ebp
  80270e:	89 e5                	mov    %esp,%ebp
  802710:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802713:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802716:	50                   	push   %eax
  802717:	e8 14 ef ff ff       	call   801630 <fd_alloc>
  80271c:	83 c4 10             	add    $0x10,%esp
  80271f:	85 c0                	test   %eax,%eax
  802721:	78 3a                	js     80275d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802723:	83 ec 04             	sub    $0x4,%esp
  802726:	68 07 04 00 00       	push   $0x407
  80272b:	ff 75 f4             	pushl  -0xc(%ebp)
  80272e:	6a 00                	push   $0x0
  802730:	e8 08 e6 ff ff       	call   800d3d <sys_page_alloc>
  802735:	83 c4 10             	add    $0x10,%esp
  802738:	85 c0                	test   %eax,%eax
  80273a:	78 21                	js     80275d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802745:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802751:	83 ec 0c             	sub    $0xc,%esp
  802754:	50                   	push   %eax
  802755:	e8 af ee ff ff       	call   801609 <fd2num>
  80275a:	83 c4 10             	add    $0x10,%esp
}
  80275d:	c9                   	leave  
  80275e:	c3                   	ret    

0080275f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80275f:	55                   	push   %ebp
  802760:	89 e5                	mov    %esp,%ebp
  802762:	56                   	push   %esi
  802763:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802764:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802769:	8b 40 48             	mov    0x48(%eax),%eax
  80276c:	83 ec 04             	sub    $0x4,%esp
  80276f:	68 20 31 80 00       	push   $0x803120
  802774:	50                   	push   %eax
  802775:	68 ef 30 80 00       	push   $0x8030ef
  80277a:	e8 6d da ff ff       	call   8001ec <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80277f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802782:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802788:	e8 72 e5 ff ff       	call   800cff <sys_getenvid>
  80278d:	83 c4 04             	add    $0x4,%esp
  802790:	ff 75 0c             	pushl  0xc(%ebp)
  802793:	ff 75 08             	pushl  0x8(%ebp)
  802796:	56                   	push   %esi
  802797:	50                   	push   %eax
  802798:	68 fc 30 80 00       	push   $0x8030fc
  80279d:	e8 4a da ff ff       	call   8001ec <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8027a2:	83 c4 18             	add    $0x18,%esp
  8027a5:	53                   	push   %ebx
  8027a6:	ff 75 10             	pushl  0x10(%ebp)
  8027a9:	e8 ed d9 ff ff       	call   80019b <vcprintf>
	cprintf("\n");
  8027ae:	c7 04 24 eb 2a 80 00 	movl   $0x802aeb,(%esp)
  8027b5:	e8 32 da ff ff       	call   8001ec <cprintf>
  8027ba:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8027bd:	cc                   	int3   
  8027be:	eb fd                	jmp    8027bd <_panic+0x5e>

008027c0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
  8027c3:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8027c6:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8027cd:	74 0a                	je     8027d9 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8027cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d2:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8027d7:	c9                   	leave  
  8027d8:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8027d9:	83 ec 04             	sub    $0x4,%esp
  8027dc:	6a 07                	push   $0x7
  8027de:	68 00 f0 bf ee       	push   $0xeebff000
  8027e3:	6a 00                	push   $0x0
  8027e5:	e8 53 e5 ff ff       	call   800d3d <sys_page_alloc>
		if(r < 0)
  8027ea:	83 c4 10             	add    $0x10,%esp
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	78 2a                	js     80281b <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8027f1:	83 ec 08             	sub    $0x8,%esp
  8027f4:	68 2f 28 80 00       	push   $0x80282f
  8027f9:	6a 00                	push   $0x0
  8027fb:	e8 88 e6 ff ff       	call   800e88 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802800:	83 c4 10             	add    $0x10,%esp
  802803:	85 c0                	test   %eax,%eax
  802805:	79 c8                	jns    8027cf <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802807:	83 ec 04             	sub    $0x4,%esp
  80280a:	68 58 31 80 00       	push   $0x803158
  80280f:	6a 25                	push   $0x25
  802811:	68 94 31 80 00       	push   $0x803194
  802816:	e8 44 ff ff ff       	call   80275f <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80281b:	83 ec 04             	sub    $0x4,%esp
  80281e:	68 28 31 80 00       	push   $0x803128
  802823:	6a 22                	push   $0x22
  802825:	68 94 31 80 00       	push   $0x803194
  80282a:	e8 30 ff ff ff       	call   80275f <_panic>

0080282f <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80282f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802830:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802835:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802837:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80283a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80283e:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802842:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802845:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802847:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80284b:	83 c4 08             	add    $0x8,%esp
	popal
  80284e:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80284f:	83 c4 04             	add    $0x4,%esp
	popfl
  802852:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802853:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802854:	c3                   	ret    

00802855 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802855:	55                   	push   %ebp
  802856:	89 e5                	mov    %esp,%ebp
  802858:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80285b:	89 d0                	mov    %edx,%eax
  80285d:	c1 e8 16             	shr    $0x16,%eax
  802860:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802867:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80286c:	f6 c1 01             	test   $0x1,%cl
  80286f:	74 1d                	je     80288e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802871:	c1 ea 0c             	shr    $0xc,%edx
  802874:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80287b:	f6 c2 01             	test   $0x1,%dl
  80287e:	74 0e                	je     80288e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802880:	c1 ea 0c             	shr    $0xc,%edx
  802883:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80288a:	ef 
  80288b:	0f b7 c0             	movzwl %ax,%eax
}
  80288e:	5d                   	pop    %ebp
  80288f:	c3                   	ret    

00802890 <__udivdi3>:
  802890:	55                   	push   %ebp
  802891:	57                   	push   %edi
  802892:	56                   	push   %esi
  802893:	53                   	push   %ebx
  802894:	83 ec 1c             	sub    $0x1c,%esp
  802897:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80289b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80289f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8028a7:	85 d2                	test   %edx,%edx
  8028a9:	75 4d                	jne    8028f8 <__udivdi3+0x68>
  8028ab:	39 f3                	cmp    %esi,%ebx
  8028ad:	76 19                	jbe    8028c8 <__udivdi3+0x38>
  8028af:	31 ff                	xor    %edi,%edi
  8028b1:	89 e8                	mov    %ebp,%eax
  8028b3:	89 f2                	mov    %esi,%edx
  8028b5:	f7 f3                	div    %ebx
  8028b7:	89 fa                	mov    %edi,%edx
  8028b9:	83 c4 1c             	add    $0x1c,%esp
  8028bc:	5b                   	pop    %ebx
  8028bd:	5e                   	pop    %esi
  8028be:	5f                   	pop    %edi
  8028bf:	5d                   	pop    %ebp
  8028c0:	c3                   	ret    
  8028c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028c8:	89 d9                	mov    %ebx,%ecx
  8028ca:	85 db                	test   %ebx,%ebx
  8028cc:	75 0b                	jne    8028d9 <__udivdi3+0x49>
  8028ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8028d3:	31 d2                	xor    %edx,%edx
  8028d5:	f7 f3                	div    %ebx
  8028d7:	89 c1                	mov    %eax,%ecx
  8028d9:	31 d2                	xor    %edx,%edx
  8028db:	89 f0                	mov    %esi,%eax
  8028dd:	f7 f1                	div    %ecx
  8028df:	89 c6                	mov    %eax,%esi
  8028e1:	89 e8                	mov    %ebp,%eax
  8028e3:	89 f7                	mov    %esi,%edi
  8028e5:	f7 f1                	div    %ecx
  8028e7:	89 fa                	mov    %edi,%edx
  8028e9:	83 c4 1c             	add    $0x1c,%esp
  8028ec:	5b                   	pop    %ebx
  8028ed:	5e                   	pop    %esi
  8028ee:	5f                   	pop    %edi
  8028ef:	5d                   	pop    %ebp
  8028f0:	c3                   	ret    
  8028f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028f8:	39 f2                	cmp    %esi,%edx
  8028fa:	77 1c                	ja     802918 <__udivdi3+0x88>
  8028fc:	0f bd fa             	bsr    %edx,%edi
  8028ff:	83 f7 1f             	xor    $0x1f,%edi
  802902:	75 2c                	jne    802930 <__udivdi3+0xa0>
  802904:	39 f2                	cmp    %esi,%edx
  802906:	72 06                	jb     80290e <__udivdi3+0x7e>
  802908:	31 c0                	xor    %eax,%eax
  80290a:	39 eb                	cmp    %ebp,%ebx
  80290c:	77 a9                	ja     8028b7 <__udivdi3+0x27>
  80290e:	b8 01 00 00 00       	mov    $0x1,%eax
  802913:	eb a2                	jmp    8028b7 <__udivdi3+0x27>
  802915:	8d 76 00             	lea    0x0(%esi),%esi
  802918:	31 ff                	xor    %edi,%edi
  80291a:	31 c0                	xor    %eax,%eax
  80291c:	89 fa                	mov    %edi,%edx
  80291e:	83 c4 1c             	add    $0x1c,%esp
  802921:	5b                   	pop    %ebx
  802922:	5e                   	pop    %esi
  802923:	5f                   	pop    %edi
  802924:	5d                   	pop    %ebp
  802925:	c3                   	ret    
  802926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80292d:	8d 76 00             	lea    0x0(%esi),%esi
  802930:	89 f9                	mov    %edi,%ecx
  802932:	b8 20 00 00 00       	mov    $0x20,%eax
  802937:	29 f8                	sub    %edi,%eax
  802939:	d3 e2                	shl    %cl,%edx
  80293b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80293f:	89 c1                	mov    %eax,%ecx
  802941:	89 da                	mov    %ebx,%edx
  802943:	d3 ea                	shr    %cl,%edx
  802945:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802949:	09 d1                	or     %edx,%ecx
  80294b:	89 f2                	mov    %esi,%edx
  80294d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802951:	89 f9                	mov    %edi,%ecx
  802953:	d3 e3                	shl    %cl,%ebx
  802955:	89 c1                	mov    %eax,%ecx
  802957:	d3 ea                	shr    %cl,%edx
  802959:	89 f9                	mov    %edi,%ecx
  80295b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80295f:	89 eb                	mov    %ebp,%ebx
  802961:	d3 e6                	shl    %cl,%esi
  802963:	89 c1                	mov    %eax,%ecx
  802965:	d3 eb                	shr    %cl,%ebx
  802967:	09 de                	or     %ebx,%esi
  802969:	89 f0                	mov    %esi,%eax
  80296b:	f7 74 24 08          	divl   0x8(%esp)
  80296f:	89 d6                	mov    %edx,%esi
  802971:	89 c3                	mov    %eax,%ebx
  802973:	f7 64 24 0c          	mull   0xc(%esp)
  802977:	39 d6                	cmp    %edx,%esi
  802979:	72 15                	jb     802990 <__udivdi3+0x100>
  80297b:	89 f9                	mov    %edi,%ecx
  80297d:	d3 e5                	shl    %cl,%ebp
  80297f:	39 c5                	cmp    %eax,%ebp
  802981:	73 04                	jae    802987 <__udivdi3+0xf7>
  802983:	39 d6                	cmp    %edx,%esi
  802985:	74 09                	je     802990 <__udivdi3+0x100>
  802987:	89 d8                	mov    %ebx,%eax
  802989:	31 ff                	xor    %edi,%edi
  80298b:	e9 27 ff ff ff       	jmp    8028b7 <__udivdi3+0x27>
  802990:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802993:	31 ff                	xor    %edi,%edi
  802995:	e9 1d ff ff ff       	jmp    8028b7 <__udivdi3+0x27>
  80299a:	66 90                	xchg   %ax,%ax
  80299c:	66 90                	xchg   %ax,%ax
  80299e:	66 90                	xchg   %ax,%ax

008029a0 <__umoddi3>:
  8029a0:	55                   	push   %ebp
  8029a1:	57                   	push   %edi
  8029a2:	56                   	push   %esi
  8029a3:	53                   	push   %ebx
  8029a4:	83 ec 1c             	sub    $0x1c,%esp
  8029a7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8029b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029b7:	89 da                	mov    %ebx,%edx
  8029b9:	85 c0                	test   %eax,%eax
  8029bb:	75 43                	jne    802a00 <__umoddi3+0x60>
  8029bd:	39 df                	cmp    %ebx,%edi
  8029bf:	76 17                	jbe    8029d8 <__umoddi3+0x38>
  8029c1:	89 f0                	mov    %esi,%eax
  8029c3:	f7 f7                	div    %edi
  8029c5:	89 d0                	mov    %edx,%eax
  8029c7:	31 d2                	xor    %edx,%edx
  8029c9:	83 c4 1c             	add    $0x1c,%esp
  8029cc:	5b                   	pop    %ebx
  8029cd:	5e                   	pop    %esi
  8029ce:	5f                   	pop    %edi
  8029cf:	5d                   	pop    %ebp
  8029d0:	c3                   	ret    
  8029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029d8:	89 fd                	mov    %edi,%ebp
  8029da:	85 ff                	test   %edi,%edi
  8029dc:	75 0b                	jne    8029e9 <__umoddi3+0x49>
  8029de:	b8 01 00 00 00       	mov    $0x1,%eax
  8029e3:	31 d2                	xor    %edx,%edx
  8029e5:	f7 f7                	div    %edi
  8029e7:	89 c5                	mov    %eax,%ebp
  8029e9:	89 d8                	mov    %ebx,%eax
  8029eb:	31 d2                	xor    %edx,%edx
  8029ed:	f7 f5                	div    %ebp
  8029ef:	89 f0                	mov    %esi,%eax
  8029f1:	f7 f5                	div    %ebp
  8029f3:	89 d0                	mov    %edx,%eax
  8029f5:	eb d0                	jmp    8029c7 <__umoddi3+0x27>
  8029f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029fe:	66 90                	xchg   %ax,%ax
  802a00:	89 f1                	mov    %esi,%ecx
  802a02:	39 d8                	cmp    %ebx,%eax
  802a04:	76 0a                	jbe    802a10 <__umoddi3+0x70>
  802a06:	89 f0                	mov    %esi,%eax
  802a08:	83 c4 1c             	add    $0x1c,%esp
  802a0b:	5b                   	pop    %ebx
  802a0c:	5e                   	pop    %esi
  802a0d:	5f                   	pop    %edi
  802a0e:	5d                   	pop    %ebp
  802a0f:	c3                   	ret    
  802a10:	0f bd e8             	bsr    %eax,%ebp
  802a13:	83 f5 1f             	xor    $0x1f,%ebp
  802a16:	75 20                	jne    802a38 <__umoddi3+0x98>
  802a18:	39 d8                	cmp    %ebx,%eax
  802a1a:	0f 82 b0 00 00 00    	jb     802ad0 <__umoddi3+0x130>
  802a20:	39 f7                	cmp    %esi,%edi
  802a22:	0f 86 a8 00 00 00    	jbe    802ad0 <__umoddi3+0x130>
  802a28:	89 c8                	mov    %ecx,%eax
  802a2a:	83 c4 1c             	add    $0x1c,%esp
  802a2d:	5b                   	pop    %ebx
  802a2e:	5e                   	pop    %esi
  802a2f:	5f                   	pop    %edi
  802a30:	5d                   	pop    %ebp
  802a31:	c3                   	ret    
  802a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a38:	89 e9                	mov    %ebp,%ecx
  802a3a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a3f:	29 ea                	sub    %ebp,%edx
  802a41:	d3 e0                	shl    %cl,%eax
  802a43:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a47:	89 d1                	mov    %edx,%ecx
  802a49:	89 f8                	mov    %edi,%eax
  802a4b:	d3 e8                	shr    %cl,%eax
  802a4d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a51:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a55:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a59:	09 c1                	or     %eax,%ecx
  802a5b:	89 d8                	mov    %ebx,%eax
  802a5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a61:	89 e9                	mov    %ebp,%ecx
  802a63:	d3 e7                	shl    %cl,%edi
  802a65:	89 d1                	mov    %edx,%ecx
  802a67:	d3 e8                	shr    %cl,%eax
  802a69:	89 e9                	mov    %ebp,%ecx
  802a6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a6f:	d3 e3                	shl    %cl,%ebx
  802a71:	89 c7                	mov    %eax,%edi
  802a73:	89 d1                	mov    %edx,%ecx
  802a75:	89 f0                	mov    %esi,%eax
  802a77:	d3 e8                	shr    %cl,%eax
  802a79:	89 e9                	mov    %ebp,%ecx
  802a7b:	89 fa                	mov    %edi,%edx
  802a7d:	d3 e6                	shl    %cl,%esi
  802a7f:	09 d8                	or     %ebx,%eax
  802a81:	f7 74 24 08          	divl   0x8(%esp)
  802a85:	89 d1                	mov    %edx,%ecx
  802a87:	89 f3                	mov    %esi,%ebx
  802a89:	f7 64 24 0c          	mull   0xc(%esp)
  802a8d:	89 c6                	mov    %eax,%esi
  802a8f:	89 d7                	mov    %edx,%edi
  802a91:	39 d1                	cmp    %edx,%ecx
  802a93:	72 06                	jb     802a9b <__umoddi3+0xfb>
  802a95:	75 10                	jne    802aa7 <__umoddi3+0x107>
  802a97:	39 c3                	cmp    %eax,%ebx
  802a99:	73 0c                	jae    802aa7 <__umoddi3+0x107>
  802a9b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a9f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802aa3:	89 d7                	mov    %edx,%edi
  802aa5:	89 c6                	mov    %eax,%esi
  802aa7:	89 ca                	mov    %ecx,%edx
  802aa9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802aae:	29 f3                	sub    %esi,%ebx
  802ab0:	19 fa                	sbb    %edi,%edx
  802ab2:	89 d0                	mov    %edx,%eax
  802ab4:	d3 e0                	shl    %cl,%eax
  802ab6:	89 e9                	mov    %ebp,%ecx
  802ab8:	d3 eb                	shr    %cl,%ebx
  802aba:	d3 ea                	shr    %cl,%edx
  802abc:	09 d8                	or     %ebx,%eax
  802abe:	83 c4 1c             	add    $0x1c,%esp
  802ac1:	5b                   	pop    %ebx
  802ac2:	5e                   	pop    %esi
  802ac3:	5f                   	pop    %edi
  802ac4:	5d                   	pop    %ebp
  802ac5:	c3                   	ret    
  802ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802acd:	8d 76 00             	lea    0x0(%esi),%esi
  802ad0:	89 da                	mov    %ebx,%edx
  802ad2:	29 fe                	sub    %edi,%esi
  802ad4:	19 c2                	sbb    %eax,%edx
  802ad6:	89 f1                	mov    %esi,%ecx
  802ad8:	89 c8                	mov    %ecx,%eax
  802ada:	e9 4b ff ff ff       	jmp    802a2a <__umoddi3+0x8a>
