
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
  80003a:	e8 4f 13 00 00       	call   80138e <sfork>
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
  800051:	e8 a3 14 00 00       	call   8014f9 <ipc_recv>
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
  800074:	e8 e9 14 00 00       	call   801562 <ipc_send>
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
  800091:	e8 cc 14 00 00       	call   801562 <ipc_send>
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

	cprintf("in libmain.c call umain!\n");
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
  800143:	e8 85 16 00 00       	call   8017cd <close_all>
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
  800299:	e8 e2 25 00 00       	call   802880 <__udivdi3>
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
  8002c2:	e8 c9 26 00 00       	call   802990 <__umoddi3>
  8002c7:	83 c4 14             	add    $0x14,%esp
  8002ca:	0f be 80 04 2b 80 00 	movsbl 0x802b04(%eax),%eax
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
  80044a:	68 69 30 80 00       	push   $0x803069
  80044f:	53                   	push   %ebx
  800450:	56                   	push   %esi
  800451:	e8 a6 fe ff ff       	call   8002fc <printfmt>
  800456:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800459:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045c:	e9 fe 02 00 00       	jmp    80075f <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800461:	50                   	push   %eax
  800462:	68 1c 2b 80 00       	push   $0x802b1c
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
  800489:	b8 15 2b 80 00       	mov    $0x802b15,%eax
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
  800821:	bf 39 2c 80 00       	mov    $0x802c39,%edi
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
  80084d:	bf 71 2c 80 00       	mov    $0x802c71,%edi
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
  800cfa:	e8 4c 1a 00 00       	call   80274b <_panic>

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
  800d7b:	e8 cb 19 00 00       	call   80274b <_panic>

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
  800dbd:	e8 89 19 00 00       	call   80274b <_panic>

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
  800dff:	e8 47 19 00 00       	call   80274b <_panic>

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
  800e41:	e8 05 19 00 00       	call   80274b <_panic>

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
  800e83:	e8 c3 18 00 00       	call   80274b <_panic>

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
  800ec5:	e8 81 18 00 00       	call   80274b <_panic>

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
  800f29:	e8 1d 18 00 00       	call   80274b <_panic>

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
  80100d:	e8 39 17 00 00       	call   80274b <_panic>

00801012 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	53                   	push   %ebx
  801016:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801019:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801020:	f6 c5 04             	test   $0x4,%ch
  801023:	75 45                	jne    80106a <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801025:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80102c:	83 e1 07             	and    $0x7,%ecx
  80102f:	83 f9 07             	cmp    $0x7,%ecx
  801032:	74 6f                	je     8010a3 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801034:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80103b:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801041:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801047:	0f 84 b6 00 00 00    	je     801103 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80104d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801054:	83 e1 05             	and    $0x5,%ecx
  801057:	83 f9 05             	cmp    $0x5,%ecx
  80105a:	0f 84 d7 00 00 00    	je     801137 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801060:	b8 00 00 00 00       	mov    $0x0,%eax
  801065:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801068:	c9                   	leave  
  801069:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  80106a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801071:	c1 e2 0c             	shl    $0xc,%edx
  801074:	83 ec 0c             	sub    $0xc,%esp
  801077:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80107d:	51                   	push   %ecx
  80107e:	52                   	push   %edx
  80107f:	50                   	push   %eax
  801080:	52                   	push   %edx
  801081:	6a 00                	push   $0x0
  801083:	e8 f8 fc ff ff       	call   800d80 <sys_page_map>
		if(r < 0)
  801088:	83 c4 20             	add    $0x20,%esp
  80108b:	85 c0                	test   %eax,%eax
  80108d:	79 d1                	jns    801060 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80108f:	83 ec 04             	sub    $0x4,%esp
  801092:	68 af 2e 80 00       	push   $0x802eaf
  801097:	6a 54                	push   $0x54
  801099:	68 c5 2e 80 00       	push   $0x802ec5
  80109e:	e8 a8 16 00 00       	call   80274b <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010a3:	89 d3                	mov    %edx,%ebx
  8010a5:	c1 e3 0c             	shl    $0xc,%ebx
  8010a8:	83 ec 0c             	sub    $0xc,%esp
  8010ab:	68 05 08 00 00       	push   $0x805
  8010b0:	53                   	push   %ebx
  8010b1:	50                   	push   %eax
  8010b2:	53                   	push   %ebx
  8010b3:	6a 00                	push   $0x0
  8010b5:	e8 c6 fc ff ff       	call   800d80 <sys_page_map>
		if(r < 0)
  8010ba:	83 c4 20             	add    $0x20,%esp
  8010bd:	85 c0                	test   %eax,%eax
  8010bf:	78 2e                	js     8010ef <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8010c1:	83 ec 0c             	sub    $0xc,%esp
  8010c4:	68 05 08 00 00       	push   $0x805
  8010c9:	53                   	push   %ebx
  8010ca:	6a 00                	push   $0x0
  8010cc:	53                   	push   %ebx
  8010cd:	6a 00                	push   $0x0
  8010cf:	e8 ac fc ff ff       	call   800d80 <sys_page_map>
		if(r < 0)
  8010d4:	83 c4 20             	add    $0x20,%esp
  8010d7:	85 c0                	test   %eax,%eax
  8010d9:	79 85                	jns    801060 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8010db:	83 ec 04             	sub    $0x4,%esp
  8010de:	68 af 2e 80 00       	push   $0x802eaf
  8010e3:	6a 5f                	push   $0x5f
  8010e5:	68 c5 2e 80 00       	push   $0x802ec5
  8010ea:	e8 5c 16 00 00       	call   80274b <_panic>
			panic("sys_page_map() panic\n");
  8010ef:	83 ec 04             	sub    $0x4,%esp
  8010f2:	68 af 2e 80 00       	push   $0x802eaf
  8010f7:	6a 5b                	push   $0x5b
  8010f9:	68 c5 2e 80 00       	push   $0x802ec5
  8010fe:	e8 48 16 00 00       	call   80274b <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801103:	c1 e2 0c             	shl    $0xc,%edx
  801106:	83 ec 0c             	sub    $0xc,%esp
  801109:	68 05 08 00 00       	push   $0x805
  80110e:	52                   	push   %edx
  80110f:	50                   	push   %eax
  801110:	52                   	push   %edx
  801111:	6a 00                	push   $0x0
  801113:	e8 68 fc ff ff       	call   800d80 <sys_page_map>
		if(r < 0)
  801118:	83 c4 20             	add    $0x20,%esp
  80111b:	85 c0                	test   %eax,%eax
  80111d:	0f 89 3d ff ff ff    	jns    801060 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801123:	83 ec 04             	sub    $0x4,%esp
  801126:	68 af 2e 80 00       	push   $0x802eaf
  80112b:	6a 66                	push   $0x66
  80112d:	68 c5 2e 80 00       	push   $0x802ec5
  801132:	e8 14 16 00 00       	call   80274b <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801137:	c1 e2 0c             	shl    $0xc,%edx
  80113a:	83 ec 0c             	sub    $0xc,%esp
  80113d:	6a 05                	push   $0x5
  80113f:	52                   	push   %edx
  801140:	50                   	push   %eax
  801141:	52                   	push   %edx
  801142:	6a 00                	push   $0x0
  801144:	e8 37 fc ff ff       	call   800d80 <sys_page_map>
		if(r < 0)
  801149:	83 c4 20             	add    $0x20,%esp
  80114c:	85 c0                	test   %eax,%eax
  80114e:	0f 89 0c ff ff ff    	jns    801060 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801154:	83 ec 04             	sub    $0x4,%esp
  801157:	68 af 2e 80 00       	push   $0x802eaf
  80115c:	6a 6d                	push   $0x6d
  80115e:	68 c5 2e 80 00       	push   $0x802ec5
  801163:	e8 e3 15 00 00       	call   80274b <_panic>

00801168 <pgfault>:
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	53                   	push   %ebx
  80116c:	83 ec 04             	sub    $0x4,%esp
  80116f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801172:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801174:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801178:	0f 84 99 00 00 00    	je     801217 <pgfault+0xaf>
  80117e:	89 c2                	mov    %eax,%edx
  801180:	c1 ea 16             	shr    $0x16,%edx
  801183:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80118a:	f6 c2 01             	test   $0x1,%dl
  80118d:	0f 84 84 00 00 00    	je     801217 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801193:	89 c2                	mov    %eax,%edx
  801195:	c1 ea 0c             	shr    $0xc,%edx
  801198:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80119f:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011a5:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8011ab:	75 6a                	jne    801217 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8011ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011b2:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8011b4:	83 ec 04             	sub    $0x4,%esp
  8011b7:	6a 07                	push   $0x7
  8011b9:	68 00 f0 7f 00       	push   $0x7ff000
  8011be:	6a 00                	push   $0x0
  8011c0:	e8 78 fb ff ff       	call   800d3d <sys_page_alloc>
	if(ret < 0)
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	85 c0                	test   %eax,%eax
  8011ca:	78 5f                	js     80122b <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8011cc:	83 ec 04             	sub    $0x4,%esp
  8011cf:	68 00 10 00 00       	push   $0x1000
  8011d4:	53                   	push   %ebx
  8011d5:	68 00 f0 7f 00       	push   $0x7ff000
  8011da:	e8 5c f9 ff ff       	call   800b3b <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8011df:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8011e6:	53                   	push   %ebx
  8011e7:	6a 00                	push   $0x0
  8011e9:	68 00 f0 7f 00       	push   $0x7ff000
  8011ee:	6a 00                	push   $0x0
  8011f0:	e8 8b fb ff ff       	call   800d80 <sys_page_map>
	if(ret < 0)
  8011f5:	83 c4 20             	add    $0x20,%esp
  8011f8:	85 c0                	test   %eax,%eax
  8011fa:	78 43                	js     80123f <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8011fc:	83 ec 08             	sub    $0x8,%esp
  8011ff:	68 00 f0 7f 00       	push   $0x7ff000
  801204:	6a 00                	push   $0x0
  801206:	e8 b7 fb ff ff       	call   800dc2 <sys_page_unmap>
	if(ret < 0)
  80120b:	83 c4 10             	add    $0x10,%esp
  80120e:	85 c0                	test   %eax,%eax
  801210:	78 41                	js     801253 <pgfault+0xeb>
}
  801212:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801215:	c9                   	leave  
  801216:	c3                   	ret    
		panic("panic at pgfault()\n");
  801217:	83 ec 04             	sub    $0x4,%esp
  80121a:	68 d0 2e 80 00       	push   $0x802ed0
  80121f:	6a 26                	push   $0x26
  801221:	68 c5 2e 80 00       	push   $0x802ec5
  801226:	e8 20 15 00 00       	call   80274b <_panic>
		panic("panic in sys_page_alloc()\n");
  80122b:	83 ec 04             	sub    $0x4,%esp
  80122e:	68 e4 2e 80 00       	push   $0x802ee4
  801233:	6a 31                	push   $0x31
  801235:	68 c5 2e 80 00       	push   $0x802ec5
  80123a:	e8 0c 15 00 00       	call   80274b <_panic>
		panic("panic in sys_page_map()\n");
  80123f:	83 ec 04             	sub    $0x4,%esp
  801242:	68 ff 2e 80 00       	push   $0x802eff
  801247:	6a 36                	push   $0x36
  801249:	68 c5 2e 80 00       	push   $0x802ec5
  80124e:	e8 f8 14 00 00       	call   80274b <_panic>
		panic("panic in sys_page_unmap()\n");
  801253:	83 ec 04             	sub    $0x4,%esp
  801256:	68 18 2f 80 00       	push   $0x802f18
  80125b:	6a 39                	push   $0x39
  80125d:	68 c5 2e 80 00       	push   $0x802ec5
  801262:	e8 e4 14 00 00       	call   80274b <_panic>

00801267 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	57                   	push   %edi
  80126b:	56                   	push   %esi
  80126c:	53                   	push   %ebx
  80126d:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801270:	68 68 11 80 00       	push   $0x801168
  801275:	e8 32 15 00 00       	call   8027ac <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80127a:	b8 07 00 00 00       	mov    $0x7,%eax
  80127f:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801281:	83 c4 10             	add    $0x10,%esp
  801284:	85 c0                	test   %eax,%eax
  801286:	78 27                	js     8012af <fork+0x48>
  801288:	89 c6                	mov    %eax,%esi
  80128a:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80128c:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801291:	75 48                	jne    8012db <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801293:	e8 67 fa ff ff       	call   800cff <sys_getenvid>
  801298:	25 ff 03 00 00       	and    $0x3ff,%eax
  80129d:	c1 e0 07             	shl    $0x7,%eax
  8012a0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012a5:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8012aa:	e9 90 00 00 00       	jmp    80133f <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8012af:	83 ec 04             	sub    $0x4,%esp
  8012b2:	68 34 2f 80 00       	push   $0x802f34
  8012b7:	68 8c 00 00 00       	push   $0x8c
  8012bc:	68 c5 2e 80 00       	push   $0x802ec5
  8012c1:	e8 85 14 00 00       	call   80274b <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8012c6:	89 f8                	mov    %edi,%eax
  8012c8:	e8 45 fd ff ff       	call   801012 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012cd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012d3:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8012d9:	74 26                	je     801301 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8012db:	89 d8                	mov    %ebx,%eax
  8012dd:	c1 e8 16             	shr    $0x16,%eax
  8012e0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012e7:	a8 01                	test   $0x1,%al
  8012e9:	74 e2                	je     8012cd <fork+0x66>
  8012eb:	89 da                	mov    %ebx,%edx
  8012ed:	c1 ea 0c             	shr    $0xc,%edx
  8012f0:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8012f7:	83 e0 05             	and    $0x5,%eax
  8012fa:	83 f8 05             	cmp    $0x5,%eax
  8012fd:	75 ce                	jne    8012cd <fork+0x66>
  8012ff:	eb c5                	jmp    8012c6 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801301:	83 ec 04             	sub    $0x4,%esp
  801304:	6a 07                	push   $0x7
  801306:	68 00 f0 bf ee       	push   $0xeebff000
  80130b:	56                   	push   %esi
  80130c:	e8 2c fa ff ff       	call   800d3d <sys_page_alloc>
	if(ret < 0)
  801311:	83 c4 10             	add    $0x10,%esp
  801314:	85 c0                	test   %eax,%eax
  801316:	78 31                	js     801349 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801318:	83 ec 08             	sub    $0x8,%esp
  80131b:	68 1b 28 80 00       	push   $0x80281b
  801320:	56                   	push   %esi
  801321:	e8 62 fb ff ff       	call   800e88 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801326:	83 c4 10             	add    $0x10,%esp
  801329:	85 c0                	test   %eax,%eax
  80132b:	78 33                	js     801360 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80132d:	83 ec 08             	sub    $0x8,%esp
  801330:	6a 02                	push   $0x2
  801332:	56                   	push   %esi
  801333:	e8 cc fa ff ff       	call   800e04 <sys_env_set_status>
	if(ret < 0)
  801338:	83 c4 10             	add    $0x10,%esp
  80133b:	85 c0                	test   %eax,%eax
  80133d:	78 38                	js     801377 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80133f:	89 f0                	mov    %esi,%eax
  801341:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801344:	5b                   	pop    %ebx
  801345:	5e                   	pop    %esi
  801346:	5f                   	pop    %edi
  801347:	5d                   	pop    %ebp
  801348:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801349:	83 ec 04             	sub    $0x4,%esp
  80134c:	68 e4 2e 80 00       	push   $0x802ee4
  801351:	68 98 00 00 00       	push   $0x98
  801356:	68 c5 2e 80 00       	push   $0x802ec5
  80135b:	e8 eb 13 00 00       	call   80274b <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801360:	83 ec 04             	sub    $0x4,%esp
  801363:	68 58 2f 80 00       	push   $0x802f58
  801368:	68 9b 00 00 00       	push   $0x9b
  80136d:	68 c5 2e 80 00       	push   $0x802ec5
  801372:	e8 d4 13 00 00       	call   80274b <_panic>
		panic("panic in sys_env_set_status()\n");
  801377:	83 ec 04             	sub    $0x4,%esp
  80137a:	68 80 2f 80 00       	push   $0x802f80
  80137f:	68 9e 00 00 00       	push   $0x9e
  801384:	68 c5 2e 80 00       	push   $0x802ec5
  801389:	e8 bd 13 00 00       	call   80274b <_panic>

0080138e <sfork>:

// Challenge!
int
sfork(void)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	57                   	push   %edi
  801392:	56                   	push   %esi
  801393:	53                   	push   %ebx
  801394:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801397:	68 68 11 80 00       	push   $0x801168
  80139c:	e8 0b 14 00 00       	call   8027ac <set_pgfault_handler>
  8013a1:	b8 07 00 00 00       	mov    $0x7,%eax
  8013a6:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013a8:	83 c4 10             	add    $0x10,%esp
  8013ab:	85 c0                	test   %eax,%eax
  8013ad:	78 27                	js     8013d6 <sfork+0x48>
  8013af:	89 c7                	mov    %eax,%edi
  8013b1:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013b3:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013b8:	75 55                	jne    80140f <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013ba:	e8 40 f9 ff ff       	call   800cff <sys_getenvid>
  8013bf:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013c4:	c1 e0 07             	shl    $0x7,%eax
  8013c7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013cc:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8013d1:	e9 d4 00 00 00       	jmp    8014aa <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8013d6:	83 ec 04             	sub    $0x4,%esp
  8013d9:	68 34 2f 80 00       	push   $0x802f34
  8013de:	68 af 00 00 00       	push   $0xaf
  8013e3:	68 c5 2e 80 00       	push   $0x802ec5
  8013e8:	e8 5e 13 00 00       	call   80274b <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8013ed:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8013f2:	89 f0                	mov    %esi,%eax
  8013f4:	e8 19 fc ff ff       	call   801012 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013ff:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801405:	77 65                	ja     80146c <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801407:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80140d:	74 de                	je     8013ed <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80140f:	89 d8                	mov    %ebx,%eax
  801411:	c1 e8 16             	shr    $0x16,%eax
  801414:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80141b:	a8 01                	test   $0x1,%al
  80141d:	74 da                	je     8013f9 <sfork+0x6b>
  80141f:	89 da                	mov    %ebx,%edx
  801421:	c1 ea 0c             	shr    $0xc,%edx
  801424:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80142b:	83 e0 05             	and    $0x5,%eax
  80142e:	83 f8 05             	cmp    $0x5,%eax
  801431:	75 c6                	jne    8013f9 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801433:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80143a:	c1 e2 0c             	shl    $0xc,%edx
  80143d:	83 ec 0c             	sub    $0xc,%esp
  801440:	83 e0 07             	and    $0x7,%eax
  801443:	50                   	push   %eax
  801444:	52                   	push   %edx
  801445:	56                   	push   %esi
  801446:	52                   	push   %edx
  801447:	6a 00                	push   $0x0
  801449:	e8 32 f9 ff ff       	call   800d80 <sys_page_map>
  80144e:	83 c4 20             	add    $0x20,%esp
  801451:	85 c0                	test   %eax,%eax
  801453:	74 a4                	je     8013f9 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801455:	83 ec 04             	sub    $0x4,%esp
  801458:	68 af 2e 80 00       	push   $0x802eaf
  80145d:	68 ba 00 00 00       	push   $0xba
  801462:	68 c5 2e 80 00       	push   $0x802ec5
  801467:	e8 df 12 00 00       	call   80274b <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80146c:	83 ec 04             	sub    $0x4,%esp
  80146f:	6a 07                	push   $0x7
  801471:	68 00 f0 bf ee       	push   $0xeebff000
  801476:	57                   	push   %edi
  801477:	e8 c1 f8 ff ff       	call   800d3d <sys_page_alloc>
	if(ret < 0)
  80147c:	83 c4 10             	add    $0x10,%esp
  80147f:	85 c0                	test   %eax,%eax
  801481:	78 31                	js     8014b4 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801483:	83 ec 08             	sub    $0x8,%esp
  801486:	68 1b 28 80 00       	push   $0x80281b
  80148b:	57                   	push   %edi
  80148c:	e8 f7 f9 ff ff       	call   800e88 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	85 c0                	test   %eax,%eax
  801496:	78 33                	js     8014cb <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801498:	83 ec 08             	sub    $0x8,%esp
  80149b:	6a 02                	push   $0x2
  80149d:	57                   	push   %edi
  80149e:	e8 61 f9 ff ff       	call   800e04 <sys_env_set_status>
	if(ret < 0)
  8014a3:	83 c4 10             	add    $0x10,%esp
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	78 38                	js     8014e2 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8014aa:	89 f8                	mov    %edi,%eax
  8014ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014af:	5b                   	pop    %ebx
  8014b0:	5e                   	pop    %esi
  8014b1:	5f                   	pop    %edi
  8014b2:	5d                   	pop    %ebp
  8014b3:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014b4:	83 ec 04             	sub    $0x4,%esp
  8014b7:	68 e4 2e 80 00       	push   $0x802ee4
  8014bc:	68 c0 00 00 00       	push   $0xc0
  8014c1:	68 c5 2e 80 00       	push   $0x802ec5
  8014c6:	e8 80 12 00 00       	call   80274b <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014cb:	83 ec 04             	sub    $0x4,%esp
  8014ce:	68 58 2f 80 00       	push   $0x802f58
  8014d3:	68 c3 00 00 00       	push   $0xc3
  8014d8:	68 c5 2e 80 00       	push   $0x802ec5
  8014dd:	e8 69 12 00 00       	call   80274b <_panic>
		panic("panic in sys_env_set_status()\n");
  8014e2:	83 ec 04             	sub    $0x4,%esp
  8014e5:	68 80 2f 80 00       	push   $0x802f80
  8014ea:	68 c6 00 00 00       	push   $0xc6
  8014ef:	68 c5 2e 80 00       	push   $0x802ec5
  8014f4:	e8 52 12 00 00       	call   80274b <_panic>

008014f9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	56                   	push   %esi
  8014fd:	53                   	push   %ebx
  8014fe:	8b 75 08             	mov    0x8(%ebp),%esi
  801501:	8b 45 0c             	mov    0xc(%ebp),%eax
  801504:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801507:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801509:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80150e:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801511:	83 ec 0c             	sub    $0xc,%esp
  801514:	50                   	push   %eax
  801515:	e8 d3 f9 ff ff       	call   800eed <sys_ipc_recv>
	if(ret < 0){
  80151a:	83 c4 10             	add    $0x10,%esp
  80151d:	85 c0                	test   %eax,%eax
  80151f:	78 2b                	js     80154c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801521:	85 f6                	test   %esi,%esi
  801523:	74 0a                	je     80152f <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  801525:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80152a:	8b 40 74             	mov    0x74(%eax),%eax
  80152d:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80152f:	85 db                	test   %ebx,%ebx
  801531:	74 0a                	je     80153d <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801533:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801538:	8b 40 78             	mov    0x78(%eax),%eax
  80153b:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80153d:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801542:	8b 40 70             	mov    0x70(%eax),%eax
}
  801545:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801548:	5b                   	pop    %ebx
  801549:	5e                   	pop    %esi
  80154a:	5d                   	pop    %ebp
  80154b:	c3                   	ret    
		if(from_env_store)
  80154c:	85 f6                	test   %esi,%esi
  80154e:	74 06                	je     801556 <ipc_recv+0x5d>
			*from_env_store = 0;
  801550:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801556:	85 db                	test   %ebx,%ebx
  801558:	74 eb                	je     801545 <ipc_recv+0x4c>
			*perm_store = 0;
  80155a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801560:	eb e3                	jmp    801545 <ipc_recv+0x4c>

00801562 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	57                   	push   %edi
  801566:	56                   	push   %esi
  801567:	53                   	push   %ebx
  801568:	83 ec 0c             	sub    $0xc,%esp
  80156b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80156e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801571:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801574:	85 db                	test   %ebx,%ebx
  801576:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80157b:	0f 44 d8             	cmove  %eax,%ebx
  80157e:	eb 05                	jmp    801585 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801580:	e8 99 f7 ff ff       	call   800d1e <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801585:	ff 75 14             	pushl  0x14(%ebp)
  801588:	53                   	push   %ebx
  801589:	56                   	push   %esi
  80158a:	57                   	push   %edi
  80158b:	e8 3a f9 ff ff       	call   800eca <sys_ipc_try_send>
  801590:	83 c4 10             	add    $0x10,%esp
  801593:	85 c0                	test   %eax,%eax
  801595:	74 1b                	je     8015b2 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801597:	79 e7                	jns    801580 <ipc_send+0x1e>
  801599:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80159c:	74 e2                	je     801580 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	68 9f 2f 80 00       	push   $0x802f9f
  8015a6:	6a 48                	push   $0x48
  8015a8:	68 b4 2f 80 00       	push   $0x802fb4
  8015ad:	e8 99 11 00 00       	call   80274b <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8015b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015b5:	5b                   	pop    %ebx
  8015b6:	5e                   	pop    %esi
  8015b7:	5f                   	pop    %edi
  8015b8:	5d                   	pop    %ebp
  8015b9:	c3                   	ret    

008015ba <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8015c0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8015c5:	89 c2                	mov    %eax,%edx
  8015c7:	c1 e2 07             	shl    $0x7,%edx
  8015ca:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8015d0:	8b 52 50             	mov    0x50(%edx),%edx
  8015d3:	39 ca                	cmp    %ecx,%edx
  8015d5:	74 11                	je     8015e8 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8015d7:	83 c0 01             	add    $0x1,%eax
  8015da:	3d 00 04 00 00       	cmp    $0x400,%eax
  8015df:	75 e4                	jne    8015c5 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8015e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e6:	eb 0b                	jmp    8015f3 <ipc_find_env+0x39>
			return envs[i].env_id;
  8015e8:	c1 e0 07             	shl    $0x7,%eax
  8015eb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015f0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8015f3:	5d                   	pop    %ebp
  8015f4:	c3                   	ret    

008015f5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fb:	05 00 00 00 30       	add    $0x30000000,%eax
  801600:	c1 e8 0c             	shr    $0xc,%eax
}
  801603:	5d                   	pop    %ebp
  801604:	c3                   	ret    

00801605 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801610:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801615:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80161a:	5d                   	pop    %ebp
  80161b:	c3                   	ret    

0080161c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801624:	89 c2                	mov    %eax,%edx
  801626:	c1 ea 16             	shr    $0x16,%edx
  801629:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801630:	f6 c2 01             	test   $0x1,%dl
  801633:	74 2d                	je     801662 <fd_alloc+0x46>
  801635:	89 c2                	mov    %eax,%edx
  801637:	c1 ea 0c             	shr    $0xc,%edx
  80163a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801641:	f6 c2 01             	test   $0x1,%dl
  801644:	74 1c                	je     801662 <fd_alloc+0x46>
  801646:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80164b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801650:	75 d2                	jne    801624 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80165b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801660:	eb 0a                	jmp    80166c <fd_alloc+0x50>
			*fd_store = fd;
  801662:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801665:	89 01                	mov    %eax,(%ecx)
			return 0;
  801667:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166c:	5d                   	pop    %ebp
  80166d:	c3                   	ret    

0080166e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801674:	83 f8 1f             	cmp    $0x1f,%eax
  801677:	77 30                	ja     8016a9 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801679:	c1 e0 0c             	shl    $0xc,%eax
  80167c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801681:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801687:	f6 c2 01             	test   $0x1,%dl
  80168a:	74 24                	je     8016b0 <fd_lookup+0x42>
  80168c:	89 c2                	mov    %eax,%edx
  80168e:	c1 ea 0c             	shr    $0xc,%edx
  801691:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801698:	f6 c2 01             	test   $0x1,%dl
  80169b:	74 1a                	je     8016b7 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80169d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a0:	89 02                	mov    %eax,(%edx)
	return 0;
  8016a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a7:	5d                   	pop    %ebp
  8016a8:	c3                   	ret    
		return -E_INVAL;
  8016a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ae:	eb f7                	jmp    8016a7 <fd_lookup+0x39>
		return -E_INVAL;
  8016b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b5:	eb f0                	jmp    8016a7 <fd_lookup+0x39>
  8016b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016bc:	eb e9                	jmp    8016a7 <fd_lookup+0x39>

008016be <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8016c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016cc:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8016d1:	39 08                	cmp    %ecx,(%eax)
  8016d3:	74 38                	je     80170d <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8016d5:	83 c2 01             	add    $0x1,%edx
  8016d8:	8b 04 95 3c 30 80 00 	mov    0x80303c(,%edx,4),%eax
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	75 ee                	jne    8016d1 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016e3:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8016e8:	8b 40 48             	mov    0x48(%eax),%eax
  8016eb:	83 ec 04             	sub    $0x4,%esp
  8016ee:	51                   	push   %ecx
  8016ef:	50                   	push   %eax
  8016f0:	68 c0 2f 80 00       	push   $0x802fc0
  8016f5:	e8 f2 ea ff ff       	call   8001ec <cprintf>
	*dev = 0;
  8016fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801703:	83 c4 10             	add    $0x10,%esp
  801706:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    
			*dev = devtab[i];
  80170d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801710:	89 01                	mov    %eax,(%ecx)
			return 0;
  801712:	b8 00 00 00 00       	mov    $0x0,%eax
  801717:	eb f2                	jmp    80170b <dev_lookup+0x4d>

00801719 <fd_close>:
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	57                   	push   %edi
  80171d:	56                   	push   %esi
  80171e:	53                   	push   %ebx
  80171f:	83 ec 24             	sub    $0x24,%esp
  801722:	8b 75 08             	mov    0x8(%ebp),%esi
  801725:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801728:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80172b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80172c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801732:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801735:	50                   	push   %eax
  801736:	e8 33 ff ff ff       	call   80166e <fd_lookup>
  80173b:	89 c3                	mov    %eax,%ebx
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	85 c0                	test   %eax,%eax
  801742:	78 05                	js     801749 <fd_close+0x30>
	    || fd != fd2)
  801744:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801747:	74 16                	je     80175f <fd_close+0x46>
		return (must_exist ? r : 0);
  801749:	89 f8                	mov    %edi,%eax
  80174b:	84 c0                	test   %al,%al
  80174d:	b8 00 00 00 00       	mov    $0x0,%eax
  801752:	0f 44 d8             	cmove  %eax,%ebx
}
  801755:	89 d8                	mov    %ebx,%eax
  801757:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80175a:	5b                   	pop    %ebx
  80175b:	5e                   	pop    %esi
  80175c:	5f                   	pop    %edi
  80175d:	5d                   	pop    %ebp
  80175e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80175f:	83 ec 08             	sub    $0x8,%esp
  801762:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801765:	50                   	push   %eax
  801766:	ff 36                	pushl  (%esi)
  801768:	e8 51 ff ff ff       	call   8016be <dev_lookup>
  80176d:	89 c3                	mov    %eax,%ebx
  80176f:	83 c4 10             	add    $0x10,%esp
  801772:	85 c0                	test   %eax,%eax
  801774:	78 1a                	js     801790 <fd_close+0x77>
		if (dev->dev_close)
  801776:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801779:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80177c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801781:	85 c0                	test   %eax,%eax
  801783:	74 0b                	je     801790 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801785:	83 ec 0c             	sub    $0xc,%esp
  801788:	56                   	push   %esi
  801789:	ff d0                	call   *%eax
  80178b:	89 c3                	mov    %eax,%ebx
  80178d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801790:	83 ec 08             	sub    $0x8,%esp
  801793:	56                   	push   %esi
  801794:	6a 00                	push   $0x0
  801796:	e8 27 f6 ff ff       	call   800dc2 <sys_page_unmap>
	return r;
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	eb b5                	jmp    801755 <fd_close+0x3c>

008017a0 <close>:

int
close(int fdnum)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a9:	50                   	push   %eax
  8017aa:	ff 75 08             	pushl  0x8(%ebp)
  8017ad:	e8 bc fe ff ff       	call   80166e <fd_lookup>
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	79 02                	jns    8017bb <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    
		return fd_close(fd, 1);
  8017bb:	83 ec 08             	sub    $0x8,%esp
  8017be:	6a 01                	push   $0x1
  8017c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c3:	e8 51 ff ff ff       	call   801719 <fd_close>
  8017c8:	83 c4 10             	add    $0x10,%esp
  8017cb:	eb ec                	jmp    8017b9 <close+0x19>

008017cd <close_all>:

void
close_all(void)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	53                   	push   %ebx
  8017d1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017d4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017d9:	83 ec 0c             	sub    $0xc,%esp
  8017dc:	53                   	push   %ebx
  8017dd:	e8 be ff ff ff       	call   8017a0 <close>
	for (i = 0; i < MAXFD; i++)
  8017e2:	83 c3 01             	add    $0x1,%ebx
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	83 fb 20             	cmp    $0x20,%ebx
  8017eb:	75 ec                	jne    8017d9 <close_all+0xc>
}
  8017ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	57                   	push   %edi
  8017f6:	56                   	push   %esi
  8017f7:	53                   	push   %ebx
  8017f8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017fe:	50                   	push   %eax
  8017ff:	ff 75 08             	pushl  0x8(%ebp)
  801802:	e8 67 fe ff ff       	call   80166e <fd_lookup>
  801807:	89 c3                	mov    %eax,%ebx
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	85 c0                	test   %eax,%eax
  80180e:	0f 88 81 00 00 00    	js     801895 <dup+0xa3>
		return r;
	close(newfdnum);
  801814:	83 ec 0c             	sub    $0xc,%esp
  801817:	ff 75 0c             	pushl  0xc(%ebp)
  80181a:	e8 81 ff ff ff       	call   8017a0 <close>

	newfd = INDEX2FD(newfdnum);
  80181f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801822:	c1 e6 0c             	shl    $0xc,%esi
  801825:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80182b:	83 c4 04             	add    $0x4,%esp
  80182e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801831:	e8 cf fd ff ff       	call   801605 <fd2data>
  801836:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801838:	89 34 24             	mov    %esi,(%esp)
  80183b:	e8 c5 fd ff ff       	call   801605 <fd2data>
  801840:	83 c4 10             	add    $0x10,%esp
  801843:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801845:	89 d8                	mov    %ebx,%eax
  801847:	c1 e8 16             	shr    $0x16,%eax
  80184a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801851:	a8 01                	test   $0x1,%al
  801853:	74 11                	je     801866 <dup+0x74>
  801855:	89 d8                	mov    %ebx,%eax
  801857:	c1 e8 0c             	shr    $0xc,%eax
  80185a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801861:	f6 c2 01             	test   $0x1,%dl
  801864:	75 39                	jne    80189f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801866:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801869:	89 d0                	mov    %edx,%eax
  80186b:	c1 e8 0c             	shr    $0xc,%eax
  80186e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801875:	83 ec 0c             	sub    $0xc,%esp
  801878:	25 07 0e 00 00       	and    $0xe07,%eax
  80187d:	50                   	push   %eax
  80187e:	56                   	push   %esi
  80187f:	6a 00                	push   $0x0
  801881:	52                   	push   %edx
  801882:	6a 00                	push   $0x0
  801884:	e8 f7 f4 ff ff       	call   800d80 <sys_page_map>
  801889:	89 c3                	mov    %eax,%ebx
  80188b:	83 c4 20             	add    $0x20,%esp
  80188e:	85 c0                	test   %eax,%eax
  801890:	78 31                	js     8018c3 <dup+0xd1>
		goto err;

	return newfdnum;
  801892:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801895:	89 d8                	mov    %ebx,%eax
  801897:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80189a:	5b                   	pop    %ebx
  80189b:	5e                   	pop    %esi
  80189c:	5f                   	pop    %edi
  80189d:	5d                   	pop    %ebp
  80189e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80189f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018a6:	83 ec 0c             	sub    $0xc,%esp
  8018a9:	25 07 0e 00 00       	and    $0xe07,%eax
  8018ae:	50                   	push   %eax
  8018af:	57                   	push   %edi
  8018b0:	6a 00                	push   $0x0
  8018b2:	53                   	push   %ebx
  8018b3:	6a 00                	push   $0x0
  8018b5:	e8 c6 f4 ff ff       	call   800d80 <sys_page_map>
  8018ba:	89 c3                	mov    %eax,%ebx
  8018bc:	83 c4 20             	add    $0x20,%esp
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	79 a3                	jns    801866 <dup+0x74>
	sys_page_unmap(0, newfd);
  8018c3:	83 ec 08             	sub    $0x8,%esp
  8018c6:	56                   	push   %esi
  8018c7:	6a 00                	push   $0x0
  8018c9:	e8 f4 f4 ff ff       	call   800dc2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018ce:	83 c4 08             	add    $0x8,%esp
  8018d1:	57                   	push   %edi
  8018d2:	6a 00                	push   $0x0
  8018d4:	e8 e9 f4 ff ff       	call   800dc2 <sys_page_unmap>
	return r;
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	eb b7                	jmp    801895 <dup+0xa3>

008018de <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	53                   	push   %ebx
  8018e2:	83 ec 1c             	sub    $0x1c,%esp
  8018e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018eb:	50                   	push   %eax
  8018ec:	53                   	push   %ebx
  8018ed:	e8 7c fd ff ff       	call   80166e <fd_lookup>
  8018f2:	83 c4 10             	add    $0x10,%esp
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	78 3f                	js     801938 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f9:	83 ec 08             	sub    $0x8,%esp
  8018fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ff:	50                   	push   %eax
  801900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801903:	ff 30                	pushl  (%eax)
  801905:	e8 b4 fd ff ff       	call   8016be <dev_lookup>
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	85 c0                	test   %eax,%eax
  80190f:	78 27                	js     801938 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801911:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801914:	8b 42 08             	mov    0x8(%edx),%eax
  801917:	83 e0 03             	and    $0x3,%eax
  80191a:	83 f8 01             	cmp    $0x1,%eax
  80191d:	74 1e                	je     80193d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801922:	8b 40 08             	mov    0x8(%eax),%eax
  801925:	85 c0                	test   %eax,%eax
  801927:	74 35                	je     80195e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	ff 75 10             	pushl  0x10(%ebp)
  80192f:	ff 75 0c             	pushl  0xc(%ebp)
  801932:	52                   	push   %edx
  801933:	ff d0                	call   *%eax
  801935:	83 c4 10             	add    $0x10,%esp
}
  801938:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80193d:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801942:	8b 40 48             	mov    0x48(%eax),%eax
  801945:	83 ec 04             	sub    $0x4,%esp
  801948:	53                   	push   %ebx
  801949:	50                   	push   %eax
  80194a:	68 01 30 80 00       	push   $0x803001
  80194f:	e8 98 e8 ff ff       	call   8001ec <cprintf>
		return -E_INVAL;
  801954:	83 c4 10             	add    $0x10,%esp
  801957:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80195c:	eb da                	jmp    801938 <read+0x5a>
		return -E_NOT_SUPP;
  80195e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801963:	eb d3                	jmp    801938 <read+0x5a>

00801965 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	57                   	push   %edi
  801969:	56                   	push   %esi
  80196a:	53                   	push   %ebx
  80196b:	83 ec 0c             	sub    $0xc,%esp
  80196e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801971:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801974:	bb 00 00 00 00       	mov    $0x0,%ebx
  801979:	39 f3                	cmp    %esi,%ebx
  80197b:	73 23                	jae    8019a0 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80197d:	83 ec 04             	sub    $0x4,%esp
  801980:	89 f0                	mov    %esi,%eax
  801982:	29 d8                	sub    %ebx,%eax
  801984:	50                   	push   %eax
  801985:	89 d8                	mov    %ebx,%eax
  801987:	03 45 0c             	add    0xc(%ebp),%eax
  80198a:	50                   	push   %eax
  80198b:	57                   	push   %edi
  80198c:	e8 4d ff ff ff       	call   8018de <read>
		if (m < 0)
  801991:	83 c4 10             	add    $0x10,%esp
  801994:	85 c0                	test   %eax,%eax
  801996:	78 06                	js     80199e <readn+0x39>
			return m;
		if (m == 0)
  801998:	74 06                	je     8019a0 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80199a:	01 c3                	add    %eax,%ebx
  80199c:	eb db                	jmp    801979 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80199e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019a0:	89 d8                	mov    %ebx,%eax
  8019a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019a5:	5b                   	pop    %ebx
  8019a6:	5e                   	pop    %esi
  8019a7:	5f                   	pop    %edi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    

008019aa <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	53                   	push   %ebx
  8019ae:	83 ec 1c             	sub    $0x1c,%esp
  8019b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019b7:	50                   	push   %eax
  8019b8:	53                   	push   %ebx
  8019b9:	e8 b0 fc ff ff       	call   80166e <fd_lookup>
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	85 c0                	test   %eax,%eax
  8019c3:	78 3a                	js     8019ff <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019c5:	83 ec 08             	sub    $0x8,%esp
  8019c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019cb:	50                   	push   %eax
  8019cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cf:	ff 30                	pushl  (%eax)
  8019d1:	e8 e8 fc ff ff       	call   8016be <dev_lookup>
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	78 22                	js     8019ff <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019e4:	74 1e                	je     801a04 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019e9:	8b 52 0c             	mov    0xc(%edx),%edx
  8019ec:	85 d2                	test   %edx,%edx
  8019ee:	74 35                	je     801a25 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019f0:	83 ec 04             	sub    $0x4,%esp
  8019f3:	ff 75 10             	pushl  0x10(%ebp)
  8019f6:	ff 75 0c             	pushl  0xc(%ebp)
  8019f9:	50                   	push   %eax
  8019fa:	ff d2                	call   *%edx
  8019fc:	83 c4 10             	add    $0x10,%esp
}
  8019ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a04:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801a09:	8b 40 48             	mov    0x48(%eax),%eax
  801a0c:	83 ec 04             	sub    $0x4,%esp
  801a0f:	53                   	push   %ebx
  801a10:	50                   	push   %eax
  801a11:	68 1d 30 80 00       	push   $0x80301d
  801a16:	e8 d1 e7 ff ff       	call   8001ec <cprintf>
		return -E_INVAL;
  801a1b:	83 c4 10             	add    $0x10,%esp
  801a1e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a23:	eb da                	jmp    8019ff <write+0x55>
		return -E_NOT_SUPP;
  801a25:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a2a:	eb d3                	jmp    8019ff <write+0x55>

00801a2c <seek>:

int
seek(int fdnum, off_t offset)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a32:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a35:	50                   	push   %eax
  801a36:	ff 75 08             	pushl  0x8(%ebp)
  801a39:	e8 30 fc ff ff       	call   80166e <fd_lookup>
  801a3e:	83 c4 10             	add    $0x10,%esp
  801a41:	85 c0                	test   %eax,%eax
  801a43:	78 0e                	js     801a53 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	53                   	push   %ebx
  801a59:	83 ec 1c             	sub    $0x1c,%esp
  801a5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a5f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a62:	50                   	push   %eax
  801a63:	53                   	push   %ebx
  801a64:	e8 05 fc ff ff       	call   80166e <fd_lookup>
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	78 37                	js     801aa7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a70:	83 ec 08             	sub    $0x8,%esp
  801a73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a76:	50                   	push   %eax
  801a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7a:	ff 30                	pushl  (%eax)
  801a7c:	e8 3d fc ff ff       	call   8016be <dev_lookup>
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	85 c0                	test   %eax,%eax
  801a86:	78 1f                	js     801aa7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a8f:	74 1b                	je     801aac <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a94:	8b 52 18             	mov    0x18(%edx),%edx
  801a97:	85 d2                	test   %edx,%edx
  801a99:	74 32                	je     801acd <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a9b:	83 ec 08             	sub    $0x8,%esp
  801a9e:	ff 75 0c             	pushl  0xc(%ebp)
  801aa1:	50                   	push   %eax
  801aa2:	ff d2                	call   *%edx
  801aa4:	83 c4 10             	add    $0x10,%esp
}
  801aa7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    
			thisenv->env_id, fdnum);
  801aac:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ab1:	8b 40 48             	mov    0x48(%eax),%eax
  801ab4:	83 ec 04             	sub    $0x4,%esp
  801ab7:	53                   	push   %ebx
  801ab8:	50                   	push   %eax
  801ab9:	68 e0 2f 80 00       	push   $0x802fe0
  801abe:	e8 29 e7 ff ff       	call   8001ec <cprintf>
		return -E_INVAL;
  801ac3:	83 c4 10             	add    $0x10,%esp
  801ac6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801acb:	eb da                	jmp    801aa7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801acd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ad2:	eb d3                	jmp    801aa7 <ftruncate+0x52>

00801ad4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	53                   	push   %ebx
  801ad8:	83 ec 1c             	sub    $0x1c,%esp
  801adb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ade:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ae1:	50                   	push   %eax
  801ae2:	ff 75 08             	pushl  0x8(%ebp)
  801ae5:	e8 84 fb ff ff       	call   80166e <fd_lookup>
  801aea:	83 c4 10             	add    $0x10,%esp
  801aed:	85 c0                	test   %eax,%eax
  801aef:	78 4b                	js     801b3c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801af1:	83 ec 08             	sub    $0x8,%esp
  801af4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af7:	50                   	push   %eax
  801af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afb:	ff 30                	pushl  (%eax)
  801afd:	e8 bc fb ff ff       	call   8016be <dev_lookup>
  801b02:	83 c4 10             	add    $0x10,%esp
  801b05:	85 c0                	test   %eax,%eax
  801b07:	78 33                	js     801b3c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b10:	74 2f                	je     801b41 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b12:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b15:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b1c:	00 00 00 
	stat->st_isdir = 0;
  801b1f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b26:	00 00 00 
	stat->st_dev = dev;
  801b29:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b2f:	83 ec 08             	sub    $0x8,%esp
  801b32:	53                   	push   %ebx
  801b33:	ff 75 f0             	pushl  -0x10(%ebp)
  801b36:	ff 50 14             	call   *0x14(%eax)
  801b39:	83 c4 10             	add    $0x10,%esp
}
  801b3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    
		return -E_NOT_SUPP;
  801b41:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b46:	eb f4                	jmp    801b3c <fstat+0x68>

00801b48 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	56                   	push   %esi
  801b4c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b4d:	83 ec 08             	sub    $0x8,%esp
  801b50:	6a 00                	push   $0x0
  801b52:	ff 75 08             	pushl  0x8(%ebp)
  801b55:	e8 22 02 00 00       	call   801d7c <open>
  801b5a:	89 c3                	mov    %eax,%ebx
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 1b                	js     801b7e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b63:	83 ec 08             	sub    $0x8,%esp
  801b66:	ff 75 0c             	pushl  0xc(%ebp)
  801b69:	50                   	push   %eax
  801b6a:	e8 65 ff ff ff       	call   801ad4 <fstat>
  801b6f:	89 c6                	mov    %eax,%esi
	close(fd);
  801b71:	89 1c 24             	mov    %ebx,(%esp)
  801b74:	e8 27 fc ff ff       	call   8017a0 <close>
	return r;
  801b79:	83 c4 10             	add    $0x10,%esp
  801b7c:	89 f3                	mov    %esi,%ebx
}
  801b7e:	89 d8                	mov    %ebx,%eax
  801b80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b83:	5b                   	pop    %ebx
  801b84:	5e                   	pop    %esi
  801b85:	5d                   	pop    %ebp
  801b86:	c3                   	ret    

00801b87 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
  801b8a:	56                   	push   %esi
  801b8b:	53                   	push   %ebx
  801b8c:	89 c6                	mov    %eax,%esi
  801b8e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b90:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b97:	74 27                	je     801bc0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b99:	6a 07                	push   $0x7
  801b9b:	68 00 60 80 00       	push   $0x806000
  801ba0:	56                   	push   %esi
  801ba1:	ff 35 00 50 80 00    	pushl  0x805000
  801ba7:	e8 b6 f9 ff ff       	call   801562 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bac:	83 c4 0c             	add    $0xc,%esp
  801baf:	6a 00                	push   $0x0
  801bb1:	53                   	push   %ebx
  801bb2:	6a 00                	push   $0x0
  801bb4:	e8 40 f9 ff ff       	call   8014f9 <ipc_recv>
}
  801bb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bbc:	5b                   	pop    %ebx
  801bbd:	5e                   	pop    %esi
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bc0:	83 ec 0c             	sub    $0xc,%esp
  801bc3:	6a 01                	push   $0x1
  801bc5:	e8 f0 f9 ff ff       	call   8015ba <ipc_find_env>
  801bca:	a3 00 50 80 00       	mov    %eax,0x805000
  801bcf:	83 c4 10             	add    $0x10,%esp
  801bd2:	eb c5                	jmp    801b99 <fsipc+0x12>

00801bd4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
  801bd7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	8b 40 0c             	mov    0xc(%eax),%eax
  801be0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be8:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801bed:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf2:	b8 02 00 00 00       	mov    $0x2,%eax
  801bf7:	e8 8b ff ff ff       	call   801b87 <fsipc>
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <devfile_flush>:
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	8b 40 0c             	mov    0xc(%eax),%eax
  801c0a:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c0f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c14:	b8 06 00 00 00       	mov    $0x6,%eax
  801c19:	e8 69 ff ff ff       	call   801b87 <fsipc>
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <devfile_stat>:
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	53                   	push   %ebx
  801c24:	83 ec 04             	sub    $0x4,%esp
  801c27:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c30:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c35:	ba 00 00 00 00       	mov    $0x0,%edx
  801c3a:	b8 05 00 00 00       	mov    $0x5,%eax
  801c3f:	e8 43 ff ff ff       	call   801b87 <fsipc>
  801c44:	85 c0                	test   %eax,%eax
  801c46:	78 2c                	js     801c74 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c48:	83 ec 08             	sub    $0x8,%esp
  801c4b:	68 00 60 80 00       	push   $0x806000
  801c50:	53                   	push   %ebx
  801c51:	e8 f5 ec ff ff       	call   80094b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c56:	a1 80 60 80 00       	mov    0x806080,%eax
  801c5b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c61:	a1 84 60 80 00       	mov    0x806084,%eax
  801c66:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c6c:	83 c4 10             	add    $0x10,%esp
  801c6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <devfile_write>:
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	53                   	push   %ebx
  801c7d:	83 ec 08             	sub    $0x8,%esp
  801c80:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	8b 40 0c             	mov    0xc(%eax),%eax
  801c89:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801c8e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801c94:	53                   	push   %ebx
  801c95:	ff 75 0c             	pushl  0xc(%ebp)
  801c98:	68 08 60 80 00       	push   $0x806008
  801c9d:	e8 99 ee ff ff       	call   800b3b <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ca2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca7:	b8 04 00 00 00       	mov    $0x4,%eax
  801cac:	e8 d6 fe ff ff       	call   801b87 <fsipc>
  801cb1:	83 c4 10             	add    $0x10,%esp
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	78 0b                	js     801cc3 <devfile_write+0x4a>
	assert(r <= n);
  801cb8:	39 d8                	cmp    %ebx,%eax
  801cba:	77 0c                	ja     801cc8 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801cbc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cc1:	7f 1e                	jg     801ce1 <devfile_write+0x68>
}
  801cc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    
	assert(r <= n);
  801cc8:	68 50 30 80 00       	push   $0x803050
  801ccd:	68 57 30 80 00       	push   $0x803057
  801cd2:	68 98 00 00 00       	push   $0x98
  801cd7:	68 6c 30 80 00       	push   $0x80306c
  801cdc:	e8 6a 0a 00 00       	call   80274b <_panic>
	assert(r <= PGSIZE);
  801ce1:	68 77 30 80 00       	push   $0x803077
  801ce6:	68 57 30 80 00       	push   $0x803057
  801ceb:	68 99 00 00 00       	push   $0x99
  801cf0:	68 6c 30 80 00       	push   $0x80306c
  801cf5:	e8 51 0a 00 00       	call   80274b <_panic>

00801cfa <devfile_read>:
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	56                   	push   %esi
  801cfe:	53                   	push   %ebx
  801cff:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	8b 40 0c             	mov    0xc(%eax),%eax
  801d08:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d0d:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d13:	ba 00 00 00 00       	mov    $0x0,%edx
  801d18:	b8 03 00 00 00       	mov    $0x3,%eax
  801d1d:	e8 65 fe ff ff       	call   801b87 <fsipc>
  801d22:	89 c3                	mov    %eax,%ebx
  801d24:	85 c0                	test   %eax,%eax
  801d26:	78 1f                	js     801d47 <devfile_read+0x4d>
	assert(r <= n);
  801d28:	39 f0                	cmp    %esi,%eax
  801d2a:	77 24                	ja     801d50 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d2c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d31:	7f 33                	jg     801d66 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d33:	83 ec 04             	sub    $0x4,%esp
  801d36:	50                   	push   %eax
  801d37:	68 00 60 80 00       	push   $0x806000
  801d3c:	ff 75 0c             	pushl  0xc(%ebp)
  801d3f:	e8 95 ed ff ff       	call   800ad9 <memmove>
	return r;
  801d44:	83 c4 10             	add    $0x10,%esp
}
  801d47:	89 d8                	mov    %ebx,%eax
  801d49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d4c:	5b                   	pop    %ebx
  801d4d:	5e                   	pop    %esi
  801d4e:	5d                   	pop    %ebp
  801d4f:	c3                   	ret    
	assert(r <= n);
  801d50:	68 50 30 80 00       	push   $0x803050
  801d55:	68 57 30 80 00       	push   $0x803057
  801d5a:	6a 7c                	push   $0x7c
  801d5c:	68 6c 30 80 00       	push   $0x80306c
  801d61:	e8 e5 09 00 00       	call   80274b <_panic>
	assert(r <= PGSIZE);
  801d66:	68 77 30 80 00       	push   $0x803077
  801d6b:	68 57 30 80 00       	push   $0x803057
  801d70:	6a 7d                	push   $0x7d
  801d72:	68 6c 30 80 00       	push   $0x80306c
  801d77:	e8 cf 09 00 00       	call   80274b <_panic>

00801d7c <open>:
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	56                   	push   %esi
  801d80:	53                   	push   %ebx
  801d81:	83 ec 1c             	sub    $0x1c,%esp
  801d84:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d87:	56                   	push   %esi
  801d88:	e8 85 eb ff ff       	call   800912 <strlen>
  801d8d:	83 c4 10             	add    $0x10,%esp
  801d90:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d95:	7f 6c                	jg     801e03 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d97:	83 ec 0c             	sub    $0xc,%esp
  801d9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d9d:	50                   	push   %eax
  801d9e:	e8 79 f8 ff ff       	call   80161c <fd_alloc>
  801da3:	89 c3                	mov    %eax,%ebx
  801da5:	83 c4 10             	add    $0x10,%esp
  801da8:	85 c0                	test   %eax,%eax
  801daa:	78 3c                	js     801de8 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801dac:	83 ec 08             	sub    $0x8,%esp
  801daf:	56                   	push   %esi
  801db0:	68 00 60 80 00       	push   $0x806000
  801db5:	e8 91 eb ff ff       	call   80094b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbd:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801dc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dc5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dca:	e8 b8 fd ff ff       	call   801b87 <fsipc>
  801dcf:	89 c3                	mov    %eax,%ebx
  801dd1:	83 c4 10             	add    $0x10,%esp
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	78 19                	js     801df1 <open+0x75>
	return fd2num(fd);
  801dd8:	83 ec 0c             	sub    $0xc,%esp
  801ddb:	ff 75 f4             	pushl  -0xc(%ebp)
  801dde:	e8 12 f8 ff ff       	call   8015f5 <fd2num>
  801de3:	89 c3                	mov    %eax,%ebx
  801de5:	83 c4 10             	add    $0x10,%esp
}
  801de8:	89 d8                	mov    %ebx,%eax
  801dea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ded:	5b                   	pop    %ebx
  801dee:	5e                   	pop    %esi
  801def:	5d                   	pop    %ebp
  801df0:	c3                   	ret    
		fd_close(fd, 0);
  801df1:	83 ec 08             	sub    $0x8,%esp
  801df4:	6a 00                	push   $0x0
  801df6:	ff 75 f4             	pushl  -0xc(%ebp)
  801df9:	e8 1b f9 ff ff       	call   801719 <fd_close>
		return r;
  801dfe:	83 c4 10             	add    $0x10,%esp
  801e01:	eb e5                	jmp    801de8 <open+0x6c>
		return -E_BAD_PATH;
  801e03:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e08:	eb de                	jmp    801de8 <open+0x6c>

00801e0a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e10:	ba 00 00 00 00       	mov    $0x0,%edx
  801e15:	b8 08 00 00 00       	mov    $0x8,%eax
  801e1a:	e8 68 fd ff ff       	call   801b87 <fsipc>
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e27:	68 83 30 80 00       	push   $0x803083
  801e2c:	ff 75 0c             	pushl  0xc(%ebp)
  801e2f:	e8 17 eb ff ff       	call   80094b <strcpy>
	return 0;
}
  801e34:	b8 00 00 00 00       	mov    $0x0,%eax
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <devsock_close>:
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	53                   	push   %ebx
  801e3f:	83 ec 10             	sub    $0x10,%esp
  801e42:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e45:	53                   	push   %ebx
  801e46:	e8 f6 09 00 00       	call   802841 <pageref>
  801e4b:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e4e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e53:	83 f8 01             	cmp    $0x1,%eax
  801e56:	74 07                	je     801e5f <devsock_close+0x24>
}
  801e58:	89 d0                	mov    %edx,%eax
  801e5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e5f:	83 ec 0c             	sub    $0xc,%esp
  801e62:	ff 73 0c             	pushl  0xc(%ebx)
  801e65:	e8 b9 02 00 00       	call   802123 <nsipc_close>
  801e6a:	89 c2                	mov    %eax,%edx
  801e6c:	83 c4 10             	add    $0x10,%esp
  801e6f:	eb e7                	jmp    801e58 <devsock_close+0x1d>

00801e71 <devsock_write>:
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e77:	6a 00                	push   $0x0
  801e79:	ff 75 10             	pushl  0x10(%ebp)
  801e7c:	ff 75 0c             	pushl  0xc(%ebp)
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	ff 70 0c             	pushl  0xc(%eax)
  801e85:	e8 76 03 00 00       	call   802200 <nsipc_send>
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <devsock_read>:
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e92:	6a 00                	push   $0x0
  801e94:	ff 75 10             	pushl  0x10(%ebp)
  801e97:	ff 75 0c             	pushl  0xc(%ebp)
  801e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9d:	ff 70 0c             	pushl  0xc(%eax)
  801ea0:	e8 ef 02 00 00       	call   802194 <nsipc_recv>
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <fd2sockid>:
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ead:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801eb0:	52                   	push   %edx
  801eb1:	50                   	push   %eax
  801eb2:	e8 b7 f7 ff ff       	call   80166e <fd_lookup>
  801eb7:	83 c4 10             	add    $0x10,%esp
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	78 10                	js     801ece <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec1:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801ec7:	39 08                	cmp    %ecx,(%eax)
  801ec9:	75 05                	jne    801ed0 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ecb:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    
		return -E_NOT_SUPP;
  801ed0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ed5:	eb f7                	jmp    801ece <fd2sockid+0x27>

00801ed7 <alloc_sockfd>:
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	56                   	push   %esi
  801edb:	53                   	push   %ebx
  801edc:	83 ec 1c             	sub    $0x1c,%esp
  801edf:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ee1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ee4:	50                   	push   %eax
  801ee5:	e8 32 f7 ff ff       	call   80161c <fd_alloc>
  801eea:	89 c3                	mov    %eax,%ebx
  801eec:	83 c4 10             	add    $0x10,%esp
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	78 43                	js     801f36 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ef3:	83 ec 04             	sub    $0x4,%esp
  801ef6:	68 07 04 00 00       	push   $0x407
  801efb:	ff 75 f4             	pushl  -0xc(%ebp)
  801efe:	6a 00                	push   $0x0
  801f00:	e8 38 ee ff ff       	call   800d3d <sys_page_alloc>
  801f05:	89 c3                	mov    %eax,%ebx
  801f07:	83 c4 10             	add    $0x10,%esp
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	78 28                	js     801f36 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f11:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f17:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f23:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f26:	83 ec 0c             	sub    $0xc,%esp
  801f29:	50                   	push   %eax
  801f2a:	e8 c6 f6 ff ff       	call   8015f5 <fd2num>
  801f2f:	89 c3                	mov    %eax,%ebx
  801f31:	83 c4 10             	add    $0x10,%esp
  801f34:	eb 0c                	jmp    801f42 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f36:	83 ec 0c             	sub    $0xc,%esp
  801f39:	56                   	push   %esi
  801f3a:	e8 e4 01 00 00       	call   802123 <nsipc_close>
		return r;
  801f3f:	83 c4 10             	add    $0x10,%esp
}
  801f42:	89 d8                	mov    %ebx,%eax
  801f44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f47:	5b                   	pop    %ebx
  801f48:	5e                   	pop    %esi
  801f49:	5d                   	pop    %ebp
  801f4a:	c3                   	ret    

00801f4b <accept>:
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f51:	8b 45 08             	mov    0x8(%ebp),%eax
  801f54:	e8 4e ff ff ff       	call   801ea7 <fd2sockid>
  801f59:	85 c0                	test   %eax,%eax
  801f5b:	78 1b                	js     801f78 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f5d:	83 ec 04             	sub    $0x4,%esp
  801f60:	ff 75 10             	pushl  0x10(%ebp)
  801f63:	ff 75 0c             	pushl  0xc(%ebp)
  801f66:	50                   	push   %eax
  801f67:	e8 0e 01 00 00       	call   80207a <nsipc_accept>
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	85 c0                	test   %eax,%eax
  801f71:	78 05                	js     801f78 <accept+0x2d>
	return alloc_sockfd(r);
  801f73:	e8 5f ff ff ff       	call   801ed7 <alloc_sockfd>
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <bind>:
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f80:	8b 45 08             	mov    0x8(%ebp),%eax
  801f83:	e8 1f ff ff ff       	call   801ea7 <fd2sockid>
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	78 12                	js     801f9e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f8c:	83 ec 04             	sub    $0x4,%esp
  801f8f:	ff 75 10             	pushl  0x10(%ebp)
  801f92:	ff 75 0c             	pushl  0xc(%ebp)
  801f95:	50                   	push   %eax
  801f96:	e8 31 01 00 00       	call   8020cc <nsipc_bind>
  801f9b:	83 c4 10             	add    $0x10,%esp
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <shutdown>:
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	e8 f9 fe ff ff       	call   801ea7 <fd2sockid>
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	78 0f                	js     801fc1 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801fb2:	83 ec 08             	sub    $0x8,%esp
  801fb5:	ff 75 0c             	pushl  0xc(%ebp)
  801fb8:	50                   	push   %eax
  801fb9:	e8 43 01 00 00       	call   802101 <nsipc_shutdown>
  801fbe:	83 c4 10             	add    $0x10,%esp
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <connect>:
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
  801fc6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	e8 d6 fe ff ff       	call   801ea7 <fd2sockid>
  801fd1:	85 c0                	test   %eax,%eax
  801fd3:	78 12                	js     801fe7 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801fd5:	83 ec 04             	sub    $0x4,%esp
  801fd8:	ff 75 10             	pushl  0x10(%ebp)
  801fdb:	ff 75 0c             	pushl  0xc(%ebp)
  801fde:	50                   	push   %eax
  801fdf:	e8 59 01 00 00       	call   80213d <nsipc_connect>
  801fe4:	83 c4 10             	add    $0x10,%esp
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <listen>:
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	e8 b0 fe ff ff       	call   801ea7 <fd2sockid>
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	78 0f                	js     80200a <listen+0x21>
	return nsipc_listen(r, backlog);
  801ffb:	83 ec 08             	sub    $0x8,%esp
  801ffe:	ff 75 0c             	pushl  0xc(%ebp)
  802001:	50                   	push   %eax
  802002:	e8 6b 01 00 00       	call   802172 <nsipc_listen>
  802007:	83 c4 10             	add    $0x10,%esp
}
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <socket>:

int
socket(int domain, int type, int protocol)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802012:	ff 75 10             	pushl  0x10(%ebp)
  802015:	ff 75 0c             	pushl  0xc(%ebp)
  802018:	ff 75 08             	pushl  0x8(%ebp)
  80201b:	e8 3e 02 00 00       	call   80225e <nsipc_socket>
  802020:	83 c4 10             	add    $0x10,%esp
  802023:	85 c0                	test   %eax,%eax
  802025:	78 05                	js     80202c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802027:	e8 ab fe ff ff       	call   801ed7 <alloc_sockfd>
}
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	53                   	push   %ebx
  802032:	83 ec 04             	sub    $0x4,%esp
  802035:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802037:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80203e:	74 26                	je     802066 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802040:	6a 07                	push   $0x7
  802042:	68 00 70 80 00       	push   $0x807000
  802047:	53                   	push   %ebx
  802048:	ff 35 04 50 80 00    	pushl  0x805004
  80204e:	e8 0f f5 ff ff       	call   801562 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802053:	83 c4 0c             	add    $0xc,%esp
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	e8 98 f4 ff ff       	call   8014f9 <ipc_recv>
}
  802061:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802064:	c9                   	leave  
  802065:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802066:	83 ec 0c             	sub    $0xc,%esp
  802069:	6a 02                	push   $0x2
  80206b:	e8 4a f5 ff ff       	call   8015ba <ipc_find_env>
  802070:	a3 04 50 80 00       	mov    %eax,0x805004
  802075:	83 c4 10             	add    $0x10,%esp
  802078:	eb c6                	jmp    802040 <nsipc+0x12>

0080207a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	56                   	push   %esi
  80207e:	53                   	push   %ebx
  80207f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80208a:	8b 06                	mov    (%esi),%eax
  80208c:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802091:	b8 01 00 00 00       	mov    $0x1,%eax
  802096:	e8 93 ff ff ff       	call   80202e <nsipc>
  80209b:	89 c3                	mov    %eax,%ebx
  80209d:	85 c0                	test   %eax,%eax
  80209f:	79 09                	jns    8020aa <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8020a1:	89 d8                	mov    %ebx,%eax
  8020a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020a6:	5b                   	pop    %ebx
  8020a7:	5e                   	pop    %esi
  8020a8:	5d                   	pop    %ebp
  8020a9:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020aa:	83 ec 04             	sub    $0x4,%esp
  8020ad:	ff 35 10 70 80 00    	pushl  0x807010
  8020b3:	68 00 70 80 00       	push   $0x807000
  8020b8:	ff 75 0c             	pushl  0xc(%ebp)
  8020bb:	e8 19 ea ff ff       	call   800ad9 <memmove>
		*addrlen = ret->ret_addrlen;
  8020c0:	a1 10 70 80 00       	mov    0x807010,%eax
  8020c5:	89 06                	mov    %eax,(%esi)
  8020c7:	83 c4 10             	add    $0x10,%esp
	return r;
  8020ca:	eb d5                	jmp    8020a1 <nsipc_accept+0x27>

008020cc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	53                   	push   %ebx
  8020d0:	83 ec 08             	sub    $0x8,%esp
  8020d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020de:	53                   	push   %ebx
  8020df:	ff 75 0c             	pushl  0xc(%ebp)
  8020e2:	68 04 70 80 00       	push   $0x807004
  8020e7:	e8 ed e9 ff ff       	call   800ad9 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020ec:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8020f2:	b8 02 00 00 00       	mov    $0x2,%eax
  8020f7:	e8 32 ff ff ff       	call   80202e <nsipc>
}
  8020fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ff:	c9                   	leave  
  802100:	c3                   	ret    

00802101 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
  802104:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80210f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802112:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802117:	b8 03 00 00 00       	mov    $0x3,%eax
  80211c:	e8 0d ff ff ff       	call   80202e <nsipc>
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <nsipc_close>:

int
nsipc_close(int s)
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
  802126:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802131:	b8 04 00 00 00       	mov    $0x4,%eax
  802136:	e8 f3 fe ff ff       	call   80202e <nsipc>
}
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
  802140:	53                   	push   %ebx
  802141:	83 ec 08             	sub    $0x8,%esp
  802144:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80214f:	53                   	push   %ebx
  802150:	ff 75 0c             	pushl  0xc(%ebp)
  802153:	68 04 70 80 00       	push   $0x807004
  802158:	e8 7c e9 ff ff       	call   800ad9 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80215d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802163:	b8 05 00 00 00       	mov    $0x5,%eax
  802168:	e8 c1 fe ff ff       	call   80202e <nsipc>
}
  80216d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
  802175:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802180:	8b 45 0c             	mov    0xc(%ebp),%eax
  802183:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802188:	b8 06 00 00 00       	mov    $0x6,%eax
  80218d:	e8 9c fe ff ff       	call   80202e <nsipc>
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
  802197:	56                   	push   %esi
  802198:	53                   	push   %ebx
  802199:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021a4:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ad:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021b2:	b8 07 00 00 00       	mov    $0x7,%eax
  8021b7:	e8 72 fe ff ff       	call   80202e <nsipc>
  8021bc:	89 c3                	mov    %eax,%ebx
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	78 1f                	js     8021e1 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021c2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021c7:	7f 21                	jg     8021ea <nsipc_recv+0x56>
  8021c9:	39 c6                	cmp    %eax,%esi
  8021cb:	7c 1d                	jl     8021ea <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021cd:	83 ec 04             	sub    $0x4,%esp
  8021d0:	50                   	push   %eax
  8021d1:	68 00 70 80 00       	push   $0x807000
  8021d6:	ff 75 0c             	pushl  0xc(%ebp)
  8021d9:	e8 fb e8 ff ff       	call   800ad9 <memmove>
  8021de:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8021e1:	89 d8                	mov    %ebx,%eax
  8021e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021e6:	5b                   	pop    %ebx
  8021e7:	5e                   	pop    %esi
  8021e8:	5d                   	pop    %ebp
  8021e9:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021ea:	68 8f 30 80 00       	push   $0x80308f
  8021ef:	68 57 30 80 00       	push   $0x803057
  8021f4:	6a 62                	push   $0x62
  8021f6:	68 a4 30 80 00       	push   $0x8030a4
  8021fb:	e8 4b 05 00 00       	call   80274b <_panic>

00802200 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	53                   	push   %ebx
  802204:	83 ec 04             	sub    $0x4,%esp
  802207:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802212:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802218:	7f 2e                	jg     802248 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80221a:	83 ec 04             	sub    $0x4,%esp
  80221d:	53                   	push   %ebx
  80221e:	ff 75 0c             	pushl  0xc(%ebp)
  802221:	68 0c 70 80 00       	push   $0x80700c
  802226:	e8 ae e8 ff ff       	call   800ad9 <memmove>
	nsipcbuf.send.req_size = size;
  80222b:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802231:	8b 45 14             	mov    0x14(%ebp),%eax
  802234:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802239:	b8 08 00 00 00       	mov    $0x8,%eax
  80223e:	e8 eb fd ff ff       	call   80202e <nsipc>
}
  802243:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802246:	c9                   	leave  
  802247:	c3                   	ret    
	assert(size < 1600);
  802248:	68 b0 30 80 00       	push   $0x8030b0
  80224d:	68 57 30 80 00       	push   $0x803057
  802252:	6a 6d                	push   $0x6d
  802254:	68 a4 30 80 00       	push   $0x8030a4
  802259:	e8 ed 04 00 00       	call   80274b <_panic>

0080225e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80226c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802274:	8b 45 10             	mov    0x10(%ebp),%eax
  802277:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80227c:	b8 09 00 00 00       	mov    $0x9,%eax
  802281:	e8 a8 fd ff ff       	call   80202e <nsipc>
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	56                   	push   %esi
  80228c:	53                   	push   %ebx
  80228d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802290:	83 ec 0c             	sub    $0xc,%esp
  802293:	ff 75 08             	pushl  0x8(%ebp)
  802296:	e8 6a f3 ff ff       	call   801605 <fd2data>
  80229b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80229d:	83 c4 08             	add    $0x8,%esp
  8022a0:	68 bc 30 80 00       	push   $0x8030bc
  8022a5:	53                   	push   %ebx
  8022a6:	e8 a0 e6 ff ff       	call   80094b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022ab:	8b 46 04             	mov    0x4(%esi),%eax
  8022ae:	2b 06                	sub    (%esi),%eax
  8022b0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022bd:	00 00 00 
	stat->st_dev = &devpipe;
  8022c0:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8022c7:	40 80 00 
	return 0;
}
  8022ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022d2:	5b                   	pop    %ebx
  8022d3:	5e                   	pop    %esi
  8022d4:	5d                   	pop    %ebp
  8022d5:	c3                   	ret    

008022d6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	53                   	push   %ebx
  8022da:	83 ec 0c             	sub    $0xc,%esp
  8022dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022e0:	53                   	push   %ebx
  8022e1:	6a 00                	push   $0x0
  8022e3:	e8 da ea ff ff       	call   800dc2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022e8:	89 1c 24             	mov    %ebx,(%esp)
  8022eb:	e8 15 f3 ff ff       	call   801605 <fd2data>
  8022f0:	83 c4 08             	add    $0x8,%esp
  8022f3:	50                   	push   %eax
  8022f4:	6a 00                	push   $0x0
  8022f6:	e8 c7 ea ff ff       	call   800dc2 <sys_page_unmap>
}
  8022fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <_pipeisclosed>:
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	57                   	push   %edi
  802304:	56                   	push   %esi
  802305:	53                   	push   %ebx
  802306:	83 ec 1c             	sub    $0x1c,%esp
  802309:	89 c7                	mov    %eax,%edi
  80230b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80230d:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802312:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802315:	83 ec 0c             	sub    $0xc,%esp
  802318:	57                   	push   %edi
  802319:	e8 23 05 00 00       	call   802841 <pageref>
  80231e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802321:	89 34 24             	mov    %esi,(%esp)
  802324:	e8 18 05 00 00       	call   802841 <pageref>
		nn = thisenv->env_runs;
  802329:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  80232f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802332:	83 c4 10             	add    $0x10,%esp
  802335:	39 cb                	cmp    %ecx,%ebx
  802337:	74 1b                	je     802354 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802339:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80233c:	75 cf                	jne    80230d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80233e:	8b 42 58             	mov    0x58(%edx),%eax
  802341:	6a 01                	push   $0x1
  802343:	50                   	push   %eax
  802344:	53                   	push   %ebx
  802345:	68 c3 30 80 00       	push   $0x8030c3
  80234a:	e8 9d de ff ff       	call   8001ec <cprintf>
  80234f:	83 c4 10             	add    $0x10,%esp
  802352:	eb b9                	jmp    80230d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802354:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802357:	0f 94 c0             	sete   %al
  80235a:	0f b6 c0             	movzbl %al,%eax
}
  80235d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802360:	5b                   	pop    %ebx
  802361:	5e                   	pop    %esi
  802362:	5f                   	pop    %edi
  802363:	5d                   	pop    %ebp
  802364:	c3                   	ret    

00802365 <devpipe_write>:
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	57                   	push   %edi
  802369:	56                   	push   %esi
  80236a:	53                   	push   %ebx
  80236b:	83 ec 28             	sub    $0x28,%esp
  80236e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802371:	56                   	push   %esi
  802372:	e8 8e f2 ff ff       	call   801605 <fd2data>
  802377:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802379:	83 c4 10             	add    $0x10,%esp
  80237c:	bf 00 00 00 00       	mov    $0x0,%edi
  802381:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802384:	74 4f                	je     8023d5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802386:	8b 43 04             	mov    0x4(%ebx),%eax
  802389:	8b 0b                	mov    (%ebx),%ecx
  80238b:	8d 51 20             	lea    0x20(%ecx),%edx
  80238e:	39 d0                	cmp    %edx,%eax
  802390:	72 14                	jb     8023a6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802392:	89 da                	mov    %ebx,%edx
  802394:	89 f0                	mov    %esi,%eax
  802396:	e8 65 ff ff ff       	call   802300 <_pipeisclosed>
  80239b:	85 c0                	test   %eax,%eax
  80239d:	75 3b                	jne    8023da <devpipe_write+0x75>
			sys_yield();
  80239f:	e8 7a e9 ff ff       	call   800d1e <sys_yield>
  8023a4:	eb e0                	jmp    802386 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023a9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8023ad:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8023b0:	89 c2                	mov    %eax,%edx
  8023b2:	c1 fa 1f             	sar    $0x1f,%edx
  8023b5:	89 d1                	mov    %edx,%ecx
  8023b7:	c1 e9 1b             	shr    $0x1b,%ecx
  8023ba:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8023bd:	83 e2 1f             	and    $0x1f,%edx
  8023c0:	29 ca                	sub    %ecx,%edx
  8023c2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8023c6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8023ca:	83 c0 01             	add    $0x1,%eax
  8023cd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8023d0:	83 c7 01             	add    $0x1,%edi
  8023d3:	eb ac                	jmp    802381 <devpipe_write+0x1c>
	return i;
  8023d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d8:	eb 05                	jmp    8023df <devpipe_write+0x7a>
				return 0;
  8023da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023e2:	5b                   	pop    %ebx
  8023e3:	5e                   	pop    %esi
  8023e4:	5f                   	pop    %edi
  8023e5:	5d                   	pop    %ebp
  8023e6:	c3                   	ret    

008023e7 <devpipe_read>:
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
  8023ea:	57                   	push   %edi
  8023eb:	56                   	push   %esi
  8023ec:	53                   	push   %ebx
  8023ed:	83 ec 18             	sub    $0x18,%esp
  8023f0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8023f3:	57                   	push   %edi
  8023f4:	e8 0c f2 ff ff       	call   801605 <fd2data>
  8023f9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023fb:	83 c4 10             	add    $0x10,%esp
  8023fe:	be 00 00 00 00       	mov    $0x0,%esi
  802403:	3b 75 10             	cmp    0x10(%ebp),%esi
  802406:	75 14                	jne    80241c <devpipe_read+0x35>
	return i;
  802408:	8b 45 10             	mov    0x10(%ebp),%eax
  80240b:	eb 02                	jmp    80240f <devpipe_read+0x28>
				return i;
  80240d:	89 f0                	mov    %esi,%eax
}
  80240f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802412:	5b                   	pop    %ebx
  802413:	5e                   	pop    %esi
  802414:	5f                   	pop    %edi
  802415:	5d                   	pop    %ebp
  802416:	c3                   	ret    
			sys_yield();
  802417:	e8 02 e9 ff ff       	call   800d1e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80241c:	8b 03                	mov    (%ebx),%eax
  80241e:	3b 43 04             	cmp    0x4(%ebx),%eax
  802421:	75 18                	jne    80243b <devpipe_read+0x54>
			if (i > 0)
  802423:	85 f6                	test   %esi,%esi
  802425:	75 e6                	jne    80240d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802427:	89 da                	mov    %ebx,%edx
  802429:	89 f8                	mov    %edi,%eax
  80242b:	e8 d0 fe ff ff       	call   802300 <_pipeisclosed>
  802430:	85 c0                	test   %eax,%eax
  802432:	74 e3                	je     802417 <devpipe_read+0x30>
				return 0;
  802434:	b8 00 00 00 00       	mov    $0x0,%eax
  802439:	eb d4                	jmp    80240f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80243b:	99                   	cltd   
  80243c:	c1 ea 1b             	shr    $0x1b,%edx
  80243f:	01 d0                	add    %edx,%eax
  802441:	83 e0 1f             	and    $0x1f,%eax
  802444:	29 d0                	sub    %edx,%eax
  802446:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80244b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80244e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802451:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802454:	83 c6 01             	add    $0x1,%esi
  802457:	eb aa                	jmp    802403 <devpipe_read+0x1c>

00802459 <pipe>:
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	56                   	push   %esi
  80245d:	53                   	push   %ebx
  80245e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802461:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802464:	50                   	push   %eax
  802465:	e8 b2 f1 ff ff       	call   80161c <fd_alloc>
  80246a:	89 c3                	mov    %eax,%ebx
  80246c:	83 c4 10             	add    $0x10,%esp
  80246f:	85 c0                	test   %eax,%eax
  802471:	0f 88 23 01 00 00    	js     80259a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802477:	83 ec 04             	sub    $0x4,%esp
  80247a:	68 07 04 00 00       	push   $0x407
  80247f:	ff 75 f4             	pushl  -0xc(%ebp)
  802482:	6a 00                	push   $0x0
  802484:	e8 b4 e8 ff ff       	call   800d3d <sys_page_alloc>
  802489:	89 c3                	mov    %eax,%ebx
  80248b:	83 c4 10             	add    $0x10,%esp
  80248e:	85 c0                	test   %eax,%eax
  802490:	0f 88 04 01 00 00    	js     80259a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802496:	83 ec 0c             	sub    $0xc,%esp
  802499:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80249c:	50                   	push   %eax
  80249d:	e8 7a f1 ff ff       	call   80161c <fd_alloc>
  8024a2:	89 c3                	mov    %eax,%ebx
  8024a4:	83 c4 10             	add    $0x10,%esp
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	0f 88 db 00 00 00    	js     80258a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024af:	83 ec 04             	sub    $0x4,%esp
  8024b2:	68 07 04 00 00       	push   $0x407
  8024b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8024ba:	6a 00                	push   $0x0
  8024bc:	e8 7c e8 ff ff       	call   800d3d <sys_page_alloc>
  8024c1:	89 c3                	mov    %eax,%ebx
  8024c3:	83 c4 10             	add    $0x10,%esp
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	0f 88 bc 00 00 00    	js     80258a <pipe+0x131>
	va = fd2data(fd0);
  8024ce:	83 ec 0c             	sub    $0xc,%esp
  8024d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8024d4:	e8 2c f1 ff ff       	call   801605 <fd2data>
  8024d9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024db:	83 c4 0c             	add    $0xc,%esp
  8024de:	68 07 04 00 00       	push   $0x407
  8024e3:	50                   	push   %eax
  8024e4:	6a 00                	push   $0x0
  8024e6:	e8 52 e8 ff ff       	call   800d3d <sys_page_alloc>
  8024eb:	89 c3                	mov    %eax,%ebx
  8024ed:	83 c4 10             	add    $0x10,%esp
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	0f 88 82 00 00 00    	js     80257a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024f8:	83 ec 0c             	sub    $0xc,%esp
  8024fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8024fe:	e8 02 f1 ff ff       	call   801605 <fd2data>
  802503:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80250a:	50                   	push   %eax
  80250b:	6a 00                	push   $0x0
  80250d:	56                   	push   %esi
  80250e:	6a 00                	push   $0x0
  802510:	e8 6b e8 ff ff       	call   800d80 <sys_page_map>
  802515:	89 c3                	mov    %eax,%ebx
  802517:	83 c4 20             	add    $0x20,%esp
  80251a:	85 c0                	test   %eax,%eax
  80251c:	78 4e                	js     80256c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80251e:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802523:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802526:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802528:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802532:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802535:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802541:	83 ec 0c             	sub    $0xc,%esp
  802544:	ff 75 f4             	pushl  -0xc(%ebp)
  802547:	e8 a9 f0 ff ff       	call   8015f5 <fd2num>
  80254c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80254f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802551:	83 c4 04             	add    $0x4,%esp
  802554:	ff 75 f0             	pushl  -0x10(%ebp)
  802557:	e8 99 f0 ff ff       	call   8015f5 <fd2num>
  80255c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80255f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802562:	83 c4 10             	add    $0x10,%esp
  802565:	bb 00 00 00 00       	mov    $0x0,%ebx
  80256a:	eb 2e                	jmp    80259a <pipe+0x141>
	sys_page_unmap(0, va);
  80256c:	83 ec 08             	sub    $0x8,%esp
  80256f:	56                   	push   %esi
  802570:	6a 00                	push   $0x0
  802572:	e8 4b e8 ff ff       	call   800dc2 <sys_page_unmap>
  802577:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80257a:	83 ec 08             	sub    $0x8,%esp
  80257d:	ff 75 f0             	pushl  -0x10(%ebp)
  802580:	6a 00                	push   $0x0
  802582:	e8 3b e8 ff ff       	call   800dc2 <sys_page_unmap>
  802587:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80258a:	83 ec 08             	sub    $0x8,%esp
  80258d:	ff 75 f4             	pushl  -0xc(%ebp)
  802590:	6a 00                	push   $0x0
  802592:	e8 2b e8 ff ff       	call   800dc2 <sys_page_unmap>
  802597:	83 c4 10             	add    $0x10,%esp
}
  80259a:	89 d8                	mov    %ebx,%eax
  80259c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80259f:	5b                   	pop    %ebx
  8025a0:	5e                   	pop    %esi
  8025a1:	5d                   	pop    %ebp
  8025a2:	c3                   	ret    

008025a3 <pipeisclosed>:
{
  8025a3:	55                   	push   %ebp
  8025a4:	89 e5                	mov    %esp,%ebp
  8025a6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ac:	50                   	push   %eax
  8025ad:	ff 75 08             	pushl  0x8(%ebp)
  8025b0:	e8 b9 f0 ff ff       	call   80166e <fd_lookup>
  8025b5:	83 c4 10             	add    $0x10,%esp
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	78 18                	js     8025d4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8025bc:	83 ec 0c             	sub    $0xc,%esp
  8025bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c2:	e8 3e f0 ff ff       	call   801605 <fd2data>
	return _pipeisclosed(fd, p);
  8025c7:	89 c2                	mov    %eax,%edx
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	e8 2f fd ff ff       	call   802300 <_pipeisclosed>
  8025d1:	83 c4 10             	add    $0x10,%esp
}
  8025d4:	c9                   	leave  
  8025d5:	c3                   	ret    

008025d6 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8025d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025db:	c3                   	ret    

008025dc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8025e2:	68 db 30 80 00       	push   $0x8030db
  8025e7:	ff 75 0c             	pushl  0xc(%ebp)
  8025ea:	e8 5c e3 ff ff       	call   80094b <strcpy>
	return 0;
}
  8025ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f4:	c9                   	leave  
  8025f5:	c3                   	ret    

008025f6 <devcons_write>:
{
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
  8025f9:	57                   	push   %edi
  8025fa:	56                   	push   %esi
  8025fb:	53                   	push   %ebx
  8025fc:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802602:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802607:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80260d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802610:	73 31                	jae    802643 <devcons_write+0x4d>
		m = n - tot;
  802612:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802615:	29 f3                	sub    %esi,%ebx
  802617:	83 fb 7f             	cmp    $0x7f,%ebx
  80261a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80261f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802622:	83 ec 04             	sub    $0x4,%esp
  802625:	53                   	push   %ebx
  802626:	89 f0                	mov    %esi,%eax
  802628:	03 45 0c             	add    0xc(%ebp),%eax
  80262b:	50                   	push   %eax
  80262c:	57                   	push   %edi
  80262d:	e8 a7 e4 ff ff       	call   800ad9 <memmove>
		sys_cputs(buf, m);
  802632:	83 c4 08             	add    $0x8,%esp
  802635:	53                   	push   %ebx
  802636:	57                   	push   %edi
  802637:	e8 45 e6 ff ff       	call   800c81 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80263c:	01 de                	add    %ebx,%esi
  80263e:	83 c4 10             	add    $0x10,%esp
  802641:	eb ca                	jmp    80260d <devcons_write+0x17>
}
  802643:	89 f0                	mov    %esi,%eax
  802645:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802648:	5b                   	pop    %ebx
  802649:	5e                   	pop    %esi
  80264a:	5f                   	pop    %edi
  80264b:	5d                   	pop    %ebp
  80264c:	c3                   	ret    

0080264d <devcons_read>:
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
  802650:	83 ec 08             	sub    $0x8,%esp
  802653:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802658:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80265c:	74 21                	je     80267f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80265e:	e8 3c e6 ff ff       	call   800c9f <sys_cgetc>
  802663:	85 c0                	test   %eax,%eax
  802665:	75 07                	jne    80266e <devcons_read+0x21>
		sys_yield();
  802667:	e8 b2 e6 ff ff       	call   800d1e <sys_yield>
  80266c:	eb f0                	jmp    80265e <devcons_read+0x11>
	if (c < 0)
  80266e:	78 0f                	js     80267f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802670:	83 f8 04             	cmp    $0x4,%eax
  802673:	74 0c                	je     802681 <devcons_read+0x34>
	*(char*)vbuf = c;
  802675:	8b 55 0c             	mov    0xc(%ebp),%edx
  802678:	88 02                	mov    %al,(%edx)
	return 1;
  80267a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80267f:	c9                   	leave  
  802680:	c3                   	ret    
		return 0;
  802681:	b8 00 00 00 00       	mov    $0x0,%eax
  802686:	eb f7                	jmp    80267f <devcons_read+0x32>

00802688 <cputchar>:
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
  80268b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80268e:	8b 45 08             	mov    0x8(%ebp),%eax
  802691:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802694:	6a 01                	push   $0x1
  802696:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802699:	50                   	push   %eax
  80269a:	e8 e2 e5 ff ff       	call   800c81 <sys_cputs>
}
  80269f:	83 c4 10             	add    $0x10,%esp
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <getchar>:
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
  8026a7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8026aa:	6a 01                	push   $0x1
  8026ac:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026af:	50                   	push   %eax
  8026b0:	6a 00                	push   $0x0
  8026b2:	e8 27 f2 ff ff       	call   8018de <read>
	if (r < 0)
  8026b7:	83 c4 10             	add    $0x10,%esp
  8026ba:	85 c0                	test   %eax,%eax
  8026bc:	78 06                	js     8026c4 <getchar+0x20>
	if (r < 1)
  8026be:	74 06                	je     8026c6 <getchar+0x22>
	return c;
  8026c0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026c4:	c9                   	leave  
  8026c5:	c3                   	ret    
		return -E_EOF;
  8026c6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8026cb:	eb f7                	jmp    8026c4 <getchar+0x20>

008026cd <iscons>:
{
  8026cd:	55                   	push   %ebp
  8026ce:	89 e5                	mov    %esp,%ebp
  8026d0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026d6:	50                   	push   %eax
  8026d7:	ff 75 08             	pushl  0x8(%ebp)
  8026da:	e8 8f ef ff ff       	call   80166e <fd_lookup>
  8026df:	83 c4 10             	add    $0x10,%esp
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	78 11                	js     8026f7 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026ef:	39 10                	cmp    %edx,(%eax)
  8026f1:	0f 94 c0             	sete   %al
  8026f4:	0f b6 c0             	movzbl %al,%eax
}
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <opencons>:
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
  8026fc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8026ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802702:	50                   	push   %eax
  802703:	e8 14 ef ff ff       	call   80161c <fd_alloc>
  802708:	83 c4 10             	add    $0x10,%esp
  80270b:	85 c0                	test   %eax,%eax
  80270d:	78 3a                	js     802749 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80270f:	83 ec 04             	sub    $0x4,%esp
  802712:	68 07 04 00 00       	push   $0x407
  802717:	ff 75 f4             	pushl  -0xc(%ebp)
  80271a:	6a 00                	push   $0x0
  80271c:	e8 1c e6 ff ff       	call   800d3d <sys_page_alloc>
  802721:	83 c4 10             	add    $0x10,%esp
  802724:	85 c0                	test   %eax,%eax
  802726:	78 21                	js     802749 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802731:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80273d:	83 ec 0c             	sub    $0xc,%esp
  802740:	50                   	push   %eax
  802741:	e8 af ee ff ff       	call   8015f5 <fd2num>
  802746:	83 c4 10             	add    $0x10,%esp
}
  802749:	c9                   	leave  
  80274a:	c3                   	ret    

0080274b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80274b:	55                   	push   %ebp
  80274c:	89 e5                	mov    %esp,%ebp
  80274e:	56                   	push   %esi
  80274f:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802750:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802755:	8b 40 48             	mov    0x48(%eax),%eax
  802758:	83 ec 04             	sub    $0x4,%esp
  80275b:	68 18 31 80 00       	push   $0x803118
  802760:	50                   	push   %eax
  802761:	68 e7 30 80 00       	push   $0x8030e7
  802766:	e8 81 da ff ff       	call   8001ec <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80276b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80276e:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802774:	e8 86 e5 ff ff       	call   800cff <sys_getenvid>
  802779:	83 c4 04             	add    $0x4,%esp
  80277c:	ff 75 0c             	pushl  0xc(%ebp)
  80277f:	ff 75 08             	pushl  0x8(%ebp)
  802782:	56                   	push   %esi
  802783:	50                   	push   %eax
  802784:	68 f4 30 80 00       	push   $0x8030f4
  802789:	e8 5e da ff ff       	call   8001ec <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80278e:	83 c4 18             	add    $0x18,%esp
  802791:	53                   	push   %ebx
  802792:	ff 75 10             	pushl  0x10(%ebp)
  802795:	e8 01 da ff ff       	call   80019b <vcprintf>
	cprintf("\n");
  80279a:	c7 04 24 f8 2a 80 00 	movl   $0x802af8,(%esp)
  8027a1:	e8 46 da ff ff       	call   8001ec <cprintf>
  8027a6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8027a9:	cc                   	int3   
  8027aa:	eb fd                	jmp    8027a9 <_panic+0x5e>

008027ac <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8027ac:	55                   	push   %ebp
  8027ad:	89 e5                	mov    %esp,%ebp
  8027af:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8027b2:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8027b9:	74 0a                	je     8027c5 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8027c3:	c9                   	leave  
  8027c4:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8027c5:	83 ec 04             	sub    $0x4,%esp
  8027c8:	6a 07                	push   $0x7
  8027ca:	68 00 f0 bf ee       	push   $0xeebff000
  8027cf:	6a 00                	push   $0x0
  8027d1:	e8 67 e5 ff ff       	call   800d3d <sys_page_alloc>
		if(r < 0)
  8027d6:	83 c4 10             	add    $0x10,%esp
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	78 2a                	js     802807 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8027dd:	83 ec 08             	sub    $0x8,%esp
  8027e0:	68 1b 28 80 00       	push   $0x80281b
  8027e5:	6a 00                	push   $0x0
  8027e7:	e8 9c e6 ff ff       	call   800e88 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8027ec:	83 c4 10             	add    $0x10,%esp
  8027ef:	85 c0                	test   %eax,%eax
  8027f1:	79 c8                	jns    8027bb <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8027f3:	83 ec 04             	sub    $0x4,%esp
  8027f6:	68 50 31 80 00       	push   $0x803150
  8027fb:	6a 25                	push   $0x25
  8027fd:	68 8c 31 80 00       	push   $0x80318c
  802802:	e8 44 ff ff ff       	call   80274b <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802807:	83 ec 04             	sub    $0x4,%esp
  80280a:	68 20 31 80 00       	push   $0x803120
  80280f:	6a 22                	push   $0x22
  802811:	68 8c 31 80 00       	push   $0x80318c
  802816:	e8 30 ff ff ff       	call   80274b <_panic>

0080281b <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80281b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80281c:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802821:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802823:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802826:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80282a:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80282e:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802831:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802833:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802837:	83 c4 08             	add    $0x8,%esp
	popal
  80283a:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80283b:	83 c4 04             	add    $0x4,%esp
	popfl
  80283e:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80283f:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802840:	c3                   	ret    

00802841 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802841:	55                   	push   %ebp
  802842:	89 e5                	mov    %esp,%ebp
  802844:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802847:	89 d0                	mov    %edx,%eax
  802849:	c1 e8 16             	shr    $0x16,%eax
  80284c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802853:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802858:	f6 c1 01             	test   $0x1,%cl
  80285b:	74 1d                	je     80287a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80285d:	c1 ea 0c             	shr    $0xc,%edx
  802860:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802867:	f6 c2 01             	test   $0x1,%dl
  80286a:	74 0e                	je     80287a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80286c:	c1 ea 0c             	shr    $0xc,%edx
  80286f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802876:	ef 
  802877:	0f b7 c0             	movzwl %ax,%eax
}
  80287a:	5d                   	pop    %ebp
  80287b:	c3                   	ret    
  80287c:	66 90                	xchg   %ax,%ax
  80287e:	66 90                	xchg   %ax,%ax

00802880 <__udivdi3>:
  802880:	55                   	push   %ebp
  802881:	57                   	push   %edi
  802882:	56                   	push   %esi
  802883:	53                   	push   %ebx
  802884:	83 ec 1c             	sub    $0x1c,%esp
  802887:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80288b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80288f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802893:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802897:	85 d2                	test   %edx,%edx
  802899:	75 4d                	jne    8028e8 <__udivdi3+0x68>
  80289b:	39 f3                	cmp    %esi,%ebx
  80289d:	76 19                	jbe    8028b8 <__udivdi3+0x38>
  80289f:	31 ff                	xor    %edi,%edi
  8028a1:	89 e8                	mov    %ebp,%eax
  8028a3:	89 f2                	mov    %esi,%edx
  8028a5:	f7 f3                	div    %ebx
  8028a7:	89 fa                	mov    %edi,%edx
  8028a9:	83 c4 1c             	add    $0x1c,%esp
  8028ac:	5b                   	pop    %ebx
  8028ad:	5e                   	pop    %esi
  8028ae:	5f                   	pop    %edi
  8028af:	5d                   	pop    %ebp
  8028b0:	c3                   	ret    
  8028b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028b8:	89 d9                	mov    %ebx,%ecx
  8028ba:	85 db                	test   %ebx,%ebx
  8028bc:	75 0b                	jne    8028c9 <__udivdi3+0x49>
  8028be:	b8 01 00 00 00       	mov    $0x1,%eax
  8028c3:	31 d2                	xor    %edx,%edx
  8028c5:	f7 f3                	div    %ebx
  8028c7:	89 c1                	mov    %eax,%ecx
  8028c9:	31 d2                	xor    %edx,%edx
  8028cb:	89 f0                	mov    %esi,%eax
  8028cd:	f7 f1                	div    %ecx
  8028cf:	89 c6                	mov    %eax,%esi
  8028d1:	89 e8                	mov    %ebp,%eax
  8028d3:	89 f7                	mov    %esi,%edi
  8028d5:	f7 f1                	div    %ecx
  8028d7:	89 fa                	mov    %edi,%edx
  8028d9:	83 c4 1c             	add    $0x1c,%esp
  8028dc:	5b                   	pop    %ebx
  8028dd:	5e                   	pop    %esi
  8028de:	5f                   	pop    %edi
  8028df:	5d                   	pop    %ebp
  8028e0:	c3                   	ret    
  8028e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028e8:	39 f2                	cmp    %esi,%edx
  8028ea:	77 1c                	ja     802908 <__udivdi3+0x88>
  8028ec:	0f bd fa             	bsr    %edx,%edi
  8028ef:	83 f7 1f             	xor    $0x1f,%edi
  8028f2:	75 2c                	jne    802920 <__udivdi3+0xa0>
  8028f4:	39 f2                	cmp    %esi,%edx
  8028f6:	72 06                	jb     8028fe <__udivdi3+0x7e>
  8028f8:	31 c0                	xor    %eax,%eax
  8028fa:	39 eb                	cmp    %ebp,%ebx
  8028fc:	77 a9                	ja     8028a7 <__udivdi3+0x27>
  8028fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802903:	eb a2                	jmp    8028a7 <__udivdi3+0x27>
  802905:	8d 76 00             	lea    0x0(%esi),%esi
  802908:	31 ff                	xor    %edi,%edi
  80290a:	31 c0                	xor    %eax,%eax
  80290c:	89 fa                	mov    %edi,%edx
  80290e:	83 c4 1c             	add    $0x1c,%esp
  802911:	5b                   	pop    %ebx
  802912:	5e                   	pop    %esi
  802913:	5f                   	pop    %edi
  802914:	5d                   	pop    %ebp
  802915:	c3                   	ret    
  802916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80291d:	8d 76 00             	lea    0x0(%esi),%esi
  802920:	89 f9                	mov    %edi,%ecx
  802922:	b8 20 00 00 00       	mov    $0x20,%eax
  802927:	29 f8                	sub    %edi,%eax
  802929:	d3 e2                	shl    %cl,%edx
  80292b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80292f:	89 c1                	mov    %eax,%ecx
  802931:	89 da                	mov    %ebx,%edx
  802933:	d3 ea                	shr    %cl,%edx
  802935:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802939:	09 d1                	or     %edx,%ecx
  80293b:	89 f2                	mov    %esi,%edx
  80293d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802941:	89 f9                	mov    %edi,%ecx
  802943:	d3 e3                	shl    %cl,%ebx
  802945:	89 c1                	mov    %eax,%ecx
  802947:	d3 ea                	shr    %cl,%edx
  802949:	89 f9                	mov    %edi,%ecx
  80294b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80294f:	89 eb                	mov    %ebp,%ebx
  802951:	d3 e6                	shl    %cl,%esi
  802953:	89 c1                	mov    %eax,%ecx
  802955:	d3 eb                	shr    %cl,%ebx
  802957:	09 de                	or     %ebx,%esi
  802959:	89 f0                	mov    %esi,%eax
  80295b:	f7 74 24 08          	divl   0x8(%esp)
  80295f:	89 d6                	mov    %edx,%esi
  802961:	89 c3                	mov    %eax,%ebx
  802963:	f7 64 24 0c          	mull   0xc(%esp)
  802967:	39 d6                	cmp    %edx,%esi
  802969:	72 15                	jb     802980 <__udivdi3+0x100>
  80296b:	89 f9                	mov    %edi,%ecx
  80296d:	d3 e5                	shl    %cl,%ebp
  80296f:	39 c5                	cmp    %eax,%ebp
  802971:	73 04                	jae    802977 <__udivdi3+0xf7>
  802973:	39 d6                	cmp    %edx,%esi
  802975:	74 09                	je     802980 <__udivdi3+0x100>
  802977:	89 d8                	mov    %ebx,%eax
  802979:	31 ff                	xor    %edi,%edi
  80297b:	e9 27 ff ff ff       	jmp    8028a7 <__udivdi3+0x27>
  802980:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802983:	31 ff                	xor    %edi,%edi
  802985:	e9 1d ff ff ff       	jmp    8028a7 <__udivdi3+0x27>
  80298a:	66 90                	xchg   %ax,%ax
  80298c:	66 90                	xchg   %ax,%ax
  80298e:	66 90                	xchg   %ax,%ax

00802990 <__umoddi3>:
  802990:	55                   	push   %ebp
  802991:	57                   	push   %edi
  802992:	56                   	push   %esi
  802993:	53                   	push   %ebx
  802994:	83 ec 1c             	sub    $0x1c,%esp
  802997:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80299b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80299f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8029a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029a7:	89 da                	mov    %ebx,%edx
  8029a9:	85 c0                	test   %eax,%eax
  8029ab:	75 43                	jne    8029f0 <__umoddi3+0x60>
  8029ad:	39 df                	cmp    %ebx,%edi
  8029af:	76 17                	jbe    8029c8 <__umoddi3+0x38>
  8029b1:	89 f0                	mov    %esi,%eax
  8029b3:	f7 f7                	div    %edi
  8029b5:	89 d0                	mov    %edx,%eax
  8029b7:	31 d2                	xor    %edx,%edx
  8029b9:	83 c4 1c             	add    $0x1c,%esp
  8029bc:	5b                   	pop    %ebx
  8029bd:	5e                   	pop    %esi
  8029be:	5f                   	pop    %edi
  8029bf:	5d                   	pop    %ebp
  8029c0:	c3                   	ret    
  8029c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029c8:	89 fd                	mov    %edi,%ebp
  8029ca:	85 ff                	test   %edi,%edi
  8029cc:	75 0b                	jne    8029d9 <__umoddi3+0x49>
  8029ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8029d3:	31 d2                	xor    %edx,%edx
  8029d5:	f7 f7                	div    %edi
  8029d7:	89 c5                	mov    %eax,%ebp
  8029d9:	89 d8                	mov    %ebx,%eax
  8029db:	31 d2                	xor    %edx,%edx
  8029dd:	f7 f5                	div    %ebp
  8029df:	89 f0                	mov    %esi,%eax
  8029e1:	f7 f5                	div    %ebp
  8029e3:	89 d0                	mov    %edx,%eax
  8029e5:	eb d0                	jmp    8029b7 <__umoddi3+0x27>
  8029e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029ee:	66 90                	xchg   %ax,%ax
  8029f0:	89 f1                	mov    %esi,%ecx
  8029f2:	39 d8                	cmp    %ebx,%eax
  8029f4:	76 0a                	jbe    802a00 <__umoddi3+0x70>
  8029f6:	89 f0                	mov    %esi,%eax
  8029f8:	83 c4 1c             	add    $0x1c,%esp
  8029fb:	5b                   	pop    %ebx
  8029fc:	5e                   	pop    %esi
  8029fd:	5f                   	pop    %edi
  8029fe:	5d                   	pop    %ebp
  8029ff:	c3                   	ret    
  802a00:	0f bd e8             	bsr    %eax,%ebp
  802a03:	83 f5 1f             	xor    $0x1f,%ebp
  802a06:	75 20                	jne    802a28 <__umoddi3+0x98>
  802a08:	39 d8                	cmp    %ebx,%eax
  802a0a:	0f 82 b0 00 00 00    	jb     802ac0 <__umoddi3+0x130>
  802a10:	39 f7                	cmp    %esi,%edi
  802a12:	0f 86 a8 00 00 00    	jbe    802ac0 <__umoddi3+0x130>
  802a18:	89 c8                	mov    %ecx,%eax
  802a1a:	83 c4 1c             	add    $0x1c,%esp
  802a1d:	5b                   	pop    %ebx
  802a1e:	5e                   	pop    %esi
  802a1f:	5f                   	pop    %edi
  802a20:	5d                   	pop    %ebp
  802a21:	c3                   	ret    
  802a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a28:	89 e9                	mov    %ebp,%ecx
  802a2a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a2f:	29 ea                	sub    %ebp,%edx
  802a31:	d3 e0                	shl    %cl,%eax
  802a33:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a37:	89 d1                	mov    %edx,%ecx
  802a39:	89 f8                	mov    %edi,%eax
  802a3b:	d3 e8                	shr    %cl,%eax
  802a3d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a41:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a45:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a49:	09 c1                	or     %eax,%ecx
  802a4b:	89 d8                	mov    %ebx,%eax
  802a4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a51:	89 e9                	mov    %ebp,%ecx
  802a53:	d3 e7                	shl    %cl,%edi
  802a55:	89 d1                	mov    %edx,%ecx
  802a57:	d3 e8                	shr    %cl,%eax
  802a59:	89 e9                	mov    %ebp,%ecx
  802a5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a5f:	d3 e3                	shl    %cl,%ebx
  802a61:	89 c7                	mov    %eax,%edi
  802a63:	89 d1                	mov    %edx,%ecx
  802a65:	89 f0                	mov    %esi,%eax
  802a67:	d3 e8                	shr    %cl,%eax
  802a69:	89 e9                	mov    %ebp,%ecx
  802a6b:	89 fa                	mov    %edi,%edx
  802a6d:	d3 e6                	shl    %cl,%esi
  802a6f:	09 d8                	or     %ebx,%eax
  802a71:	f7 74 24 08          	divl   0x8(%esp)
  802a75:	89 d1                	mov    %edx,%ecx
  802a77:	89 f3                	mov    %esi,%ebx
  802a79:	f7 64 24 0c          	mull   0xc(%esp)
  802a7d:	89 c6                	mov    %eax,%esi
  802a7f:	89 d7                	mov    %edx,%edi
  802a81:	39 d1                	cmp    %edx,%ecx
  802a83:	72 06                	jb     802a8b <__umoddi3+0xfb>
  802a85:	75 10                	jne    802a97 <__umoddi3+0x107>
  802a87:	39 c3                	cmp    %eax,%ebx
  802a89:	73 0c                	jae    802a97 <__umoddi3+0x107>
  802a8b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a8f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802a93:	89 d7                	mov    %edx,%edi
  802a95:	89 c6                	mov    %eax,%esi
  802a97:	89 ca                	mov    %ecx,%edx
  802a99:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a9e:	29 f3                	sub    %esi,%ebx
  802aa0:	19 fa                	sbb    %edi,%edx
  802aa2:	89 d0                	mov    %edx,%eax
  802aa4:	d3 e0                	shl    %cl,%eax
  802aa6:	89 e9                	mov    %ebp,%ecx
  802aa8:	d3 eb                	shr    %cl,%ebx
  802aaa:	d3 ea                	shr    %cl,%edx
  802aac:	09 d8                	or     %ebx,%eax
  802aae:	83 c4 1c             	add    $0x1c,%esp
  802ab1:	5b                   	pop    %ebx
  802ab2:	5e                   	pop    %esi
  802ab3:	5f                   	pop    %edi
  802ab4:	5d                   	pop    %ebp
  802ab5:	c3                   	ret    
  802ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802abd:	8d 76 00             	lea    0x0(%esi),%esi
  802ac0:	89 da                	mov    %ebx,%edx
  802ac2:	29 fe                	sub    %edi,%esi
  802ac4:	19 c2                	sbb    %eax,%edx
  802ac6:	89 f1                	mov    %esi,%ecx
  802ac8:	89 c8                	mov    %ecx,%eax
  802aca:	e9 4b ff ff ff       	jmp    802a1a <__umoddi3+0x8a>
