
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
  80003a:	e8 33 13 00 00       	call   801372 <sfork>
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
  800051:	e8 8a 14 00 00       	call   8014e0 <ipc_recv>
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
  800074:	e8 d0 14 00 00       	call   801549 <ipc_send>
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
  800091:	e8 b3 14 00 00       	call   801549 <ipc_send>
  800096:	83 c4 10             	add    $0x10,%esp
  800099:	eb ab                	jmp    800046 <umain+0x13>

0080009b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009b:	55                   	push   %ebp
  80009c:	89 e5                	mov    %esp,%ebp
  80009e:	56                   	push   %esi
  80009f:	53                   	push   %ebx
  8000a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8000a6:	e8 15 0c 00 00       	call   800cc0 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8000ab:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b0:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000b6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000bb:	a3 0c 50 80 00       	mov    %eax,0x80500c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c0:	85 db                	test   %ebx,%ebx
  8000c2:	7e 07                	jle    8000cb <libmain+0x30>
		binaryname = argv[0];
  8000c4:	8b 06                	mov    (%esi),%eax
  8000c6:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8000cb:	83 ec 08             	sub    $0x8,%esp
  8000ce:	56                   	push   %esi
  8000cf:	53                   	push   %ebx
  8000d0:	e8 5e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d5:	e8 0a 00 00 00       	call   8000e4 <exit>
}
  8000da:	83 c4 10             	add    $0x10,%esp
  8000dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e0:	5b                   	pop    %ebx
  8000e1:	5e                   	pop    %esi
  8000e2:	5d                   	pop    %ebp
  8000e3:	c3                   	ret    

008000e4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8000ea:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8000ef:	8b 40 48             	mov    0x48(%eax),%eax
  8000f2:	68 d8 2a 80 00       	push   $0x802ad8
  8000f7:	50                   	push   %eax
  8000f8:	68 ca 2a 80 00       	push   $0x802aca
  8000fd:	e8 ab 00 00 00       	call   8001ad <cprintf>
	close_all();
  800102:	e8 b1 16 00 00       	call   8017b8 <close_all>
	sys_env_destroy(0);
  800107:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80010e:	e8 6c 0b 00 00       	call   800c7f <sys_env_destroy>
}
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	c9                   	leave  
  800117:	c3                   	ret    

00800118 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	53                   	push   %ebx
  80011c:	83 ec 04             	sub    $0x4,%esp
  80011f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800122:	8b 13                	mov    (%ebx),%edx
  800124:	8d 42 01             	lea    0x1(%edx),%eax
  800127:	89 03                	mov    %eax,(%ebx)
  800129:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800130:	3d ff 00 00 00       	cmp    $0xff,%eax
  800135:	74 09                	je     800140 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800137:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013e:	c9                   	leave  
  80013f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800140:	83 ec 08             	sub    $0x8,%esp
  800143:	68 ff 00 00 00       	push   $0xff
  800148:	8d 43 08             	lea    0x8(%ebx),%eax
  80014b:	50                   	push   %eax
  80014c:	e8 f1 0a 00 00       	call   800c42 <sys_cputs>
		b->idx = 0;
  800151:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	eb db                	jmp    800137 <putch+0x1f>

0080015c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800165:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016c:	00 00 00 
	b.cnt = 0;
  80016f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800176:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800179:	ff 75 0c             	pushl  0xc(%ebp)
  80017c:	ff 75 08             	pushl  0x8(%ebp)
  80017f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800185:	50                   	push   %eax
  800186:	68 18 01 80 00       	push   $0x800118
  80018b:	e8 4a 01 00 00       	call   8002da <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800190:	83 c4 08             	add    $0x8,%esp
  800193:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800199:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019f:	50                   	push   %eax
  8001a0:	e8 9d 0a 00 00       	call   800c42 <sys_cputs>

	return b.cnt;
}
  8001a5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b6:	50                   	push   %eax
  8001b7:	ff 75 08             	pushl  0x8(%ebp)
  8001ba:	e8 9d ff ff ff       	call   80015c <vcprintf>
	va_end(ap);

	return cnt;
}
  8001bf:	c9                   	leave  
  8001c0:	c3                   	ret    

008001c1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c1:	55                   	push   %ebp
  8001c2:	89 e5                	mov    %esp,%ebp
  8001c4:	57                   	push   %edi
  8001c5:	56                   	push   %esi
  8001c6:	53                   	push   %ebx
  8001c7:	83 ec 1c             	sub    $0x1c,%esp
  8001ca:	89 c6                	mov    %eax,%esi
  8001cc:	89 d7                	mov    %edx,%edi
  8001ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001d7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001da:	8b 45 10             	mov    0x10(%ebp),%eax
  8001dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001e0:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001e4:	74 2c                	je     800212 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001f3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001f6:	39 c2                	cmp    %eax,%edx
  8001f8:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001fb:	73 43                	jae    800240 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001fd:	83 eb 01             	sub    $0x1,%ebx
  800200:	85 db                	test   %ebx,%ebx
  800202:	7e 6c                	jle    800270 <printnum+0xaf>
				putch(padc, putdat);
  800204:	83 ec 08             	sub    $0x8,%esp
  800207:	57                   	push   %edi
  800208:	ff 75 18             	pushl  0x18(%ebp)
  80020b:	ff d6                	call   *%esi
  80020d:	83 c4 10             	add    $0x10,%esp
  800210:	eb eb                	jmp    8001fd <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	6a 20                	push   $0x20
  800217:	6a 00                	push   $0x0
  800219:	50                   	push   %eax
  80021a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021d:	ff 75 e0             	pushl  -0x20(%ebp)
  800220:	89 fa                	mov    %edi,%edx
  800222:	89 f0                	mov    %esi,%eax
  800224:	e8 98 ff ff ff       	call   8001c1 <printnum>
		while (--width > 0)
  800229:	83 c4 20             	add    $0x20,%esp
  80022c:	83 eb 01             	sub    $0x1,%ebx
  80022f:	85 db                	test   %ebx,%ebx
  800231:	7e 65                	jle    800298 <printnum+0xd7>
			putch(padc, putdat);
  800233:	83 ec 08             	sub    $0x8,%esp
  800236:	57                   	push   %edi
  800237:	6a 20                	push   $0x20
  800239:	ff d6                	call   *%esi
  80023b:	83 c4 10             	add    $0x10,%esp
  80023e:	eb ec                	jmp    80022c <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	ff 75 18             	pushl  0x18(%ebp)
  800246:	83 eb 01             	sub    $0x1,%ebx
  800249:	53                   	push   %ebx
  80024a:	50                   	push   %eax
  80024b:	83 ec 08             	sub    $0x8,%esp
  80024e:	ff 75 dc             	pushl  -0x24(%ebp)
  800251:	ff 75 d8             	pushl  -0x28(%ebp)
  800254:	ff 75 e4             	pushl  -0x1c(%ebp)
  800257:	ff 75 e0             	pushl  -0x20(%ebp)
  80025a:	e8 11 26 00 00       	call   802870 <__udivdi3>
  80025f:	83 c4 18             	add    $0x18,%esp
  800262:	52                   	push   %edx
  800263:	50                   	push   %eax
  800264:	89 fa                	mov    %edi,%edx
  800266:	89 f0                	mov    %esi,%eax
  800268:	e8 54 ff ff ff       	call   8001c1 <printnum>
  80026d:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800270:	83 ec 08             	sub    $0x8,%esp
  800273:	57                   	push   %edi
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	ff 75 dc             	pushl  -0x24(%ebp)
  80027a:	ff 75 d8             	pushl  -0x28(%ebp)
  80027d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800280:	ff 75 e0             	pushl  -0x20(%ebp)
  800283:	e8 f8 26 00 00       	call   802980 <__umoddi3>
  800288:	83 c4 14             	add    $0x14,%esp
  80028b:	0f be 80 dd 2a 80 00 	movsbl 0x802add(%eax),%eax
  800292:	50                   	push   %eax
  800293:	ff d6                	call   *%esi
  800295:	83 c4 10             	add    $0x10,%esp
	}
}
  800298:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029b:	5b                   	pop    %ebx
  80029c:	5e                   	pop    %esi
  80029d:	5f                   	pop    %edi
  80029e:	5d                   	pop    %ebp
  80029f:	c3                   	ret    

008002a0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002aa:	8b 10                	mov    (%eax),%edx
  8002ac:	3b 50 04             	cmp    0x4(%eax),%edx
  8002af:	73 0a                	jae    8002bb <sprintputch+0x1b>
		*b->buf++ = ch;
  8002b1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002b4:	89 08                	mov    %ecx,(%eax)
  8002b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b9:	88 02                	mov    %al,(%edx)
}
  8002bb:	5d                   	pop    %ebp
  8002bc:	c3                   	ret    

008002bd <printfmt>:
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002c3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c6:	50                   	push   %eax
  8002c7:	ff 75 10             	pushl  0x10(%ebp)
  8002ca:	ff 75 0c             	pushl  0xc(%ebp)
  8002cd:	ff 75 08             	pushl  0x8(%ebp)
  8002d0:	e8 05 00 00 00       	call   8002da <vprintfmt>
}
  8002d5:	83 c4 10             	add    $0x10,%esp
  8002d8:	c9                   	leave  
  8002d9:	c3                   	ret    

008002da <vprintfmt>:
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	57                   	push   %edi
  8002de:	56                   	push   %esi
  8002df:	53                   	push   %ebx
  8002e0:	83 ec 3c             	sub    $0x3c,%esp
  8002e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ec:	e9 32 04 00 00       	jmp    800723 <vprintfmt+0x449>
		padc = ' ';
  8002f1:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002f5:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002fc:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800303:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80030a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800311:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800318:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80031d:	8d 47 01             	lea    0x1(%edi),%eax
  800320:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800323:	0f b6 17             	movzbl (%edi),%edx
  800326:	8d 42 dd             	lea    -0x23(%edx),%eax
  800329:	3c 55                	cmp    $0x55,%al
  80032b:	0f 87 12 05 00 00    	ja     800843 <vprintfmt+0x569>
  800331:	0f b6 c0             	movzbl %al,%eax
  800334:	ff 24 85 c0 2c 80 00 	jmp    *0x802cc0(,%eax,4)
  80033b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80033e:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800342:	eb d9                	jmp    80031d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800344:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800347:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80034b:	eb d0                	jmp    80031d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80034d:	0f b6 d2             	movzbl %dl,%edx
  800350:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800353:	b8 00 00 00 00       	mov    $0x0,%eax
  800358:	89 75 08             	mov    %esi,0x8(%ebp)
  80035b:	eb 03                	jmp    800360 <vprintfmt+0x86>
  80035d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800360:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800363:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800367:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80036a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80036d:	83 fe 09             	cmp    $0x9,%esi
  800370:	76 eb                	jbe    80035d <vprintfmt+0x83>
  800372:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800375:	8b 75 08             	mov    0x8(%ebp),%esi
  800378:	eb 14                	jmp    80038e <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80037a:	8b 45 14             	mov    0x14(%ebp),%eax
  80037d:	8b 00                	mov    (%eax),%eax
  80037f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800382:	8b 45 14             	mov    0x14(%ebp),%eax
  800385:	8d 40 04             	lea    0x4(%eax),%eax
  800388:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80038e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800392:	79 89                	jns    80031d <vprintfmt+0x43>
				width = precision, precision = -1;
  800394:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800397:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80039a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003a1:	e9 77 ff ff ff       	jmp    80031d <vprintfmt+0x43>
  8003a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a9:	85 c0                	test   %eax,%eax
  8003ab:	0f 48 c1             	cmovs  %ecx,%eax
  8003ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b4:	e9 64 ff ff ff       	jmp    80031d <vprintfmt+0x43>
  8003b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003bc:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003c3:	e9 55 ff ff ff       	jmp    80031d <vprintfmt+0x43>
			lflag++;
  8003c8:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003cf:	e9 49 ff ff ff       	jmp    80031d <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d7:	8d 78 04             	lea    0x4(%eax),%edi
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	53                   	push   %ebx
  8003de:	ff 30                	pushl  (%eax)
  8003e0:	ff d6                	call   *%esi
			break;
  8003e2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003e5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003e8:	e9 33 03 00 00       	jmp    800720 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f0:	8d 78 04             	lea    0x4(%eax),%edi
  8003f3:	8b 00                	mov    (%eax),%eax
  8003f5:	99                   	cltd   
  8003f6:	31 d0                	xor    %edx,%eax
  8003f8:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003fa:	83 f8 11             	cmp    $0x11,%eax
  8003fd:	7f 23                	jg     800422 <vprintfmt+0x148>
  8003ff:	8b 14 85 20 2e 80 00 	mov    0x802e20(,%eax,4),%edx
  800406:	85 d2                	test   %edx,%edx
  800408:	74 18                	je     800422 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80040a:	52                   	push   %edx
  80040b:	68 4d 30 80 00       	push   $0x80304d
  800410:	53                   	push   %ebx
  800411:	56                   	push   %esi
  800412:	e8 a6 fe ff ff       	call   8002bd <printfmt>
  800417:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80041d:	e9 fe 02 00 00       	jmp    800720 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800422:	50                   	push   %eax
  800423:	68 f5 2a 80 00       	push   $0x802af5
  800428:	53                   	push   %ebx
  800429:	56                   	push   %esi
  80042a:	e8 8e fe ff ff       	call   8002bd <printfmt>
  80042f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800432:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800435:	e9 e6 02 00 00       	jmp    800720 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80043a:	8b 45 14             	mov    0x14(%ebp),%eax
  80043d:	83 c0 04             	add    $0x4,%eax
  800440:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800443:	8b 45 14             	mov    0x14(%ebp),%eax
  800446:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800448:	85 c9                	test   %ecx,%ecx
  80044a:	b8 ee 2a 80 00       	mov    $0x802aee,%eax
  80044f:	0f 45 c1             	cmovne %ecx,%eax
  800452:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800455:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800459:	7e 06                	jle    800461 <vprintfmt+0x187>
  80045b:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80045f:	75 0d                	jne    80046e <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800461:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800464:	89 c7                	mov    %eax,%edi
  800466:	03 45 e0             	add    -0x20(%ebp),%eax
  800469:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80046c:	eb 53                	jmp    8004c1 <vprintfmt+0x1e7>
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	ff 75 d8             	pushl  -0x28(%ebp)
  800474:	50                   	push   %eax
  800475:	e8 71 04 00 00       	call   8008eb <strnlen>
  80047a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80047d:	29 c1                	sub    %eax,%ecx
  80047f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800482:	83 c4 10             	add    $0x10,%esp
  800485:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800487:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80048b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80048e:	eb 0f                	jmp    80049f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	53                   	push   %ebx
  800494:	ff 75 e0             	pushl  -0x20(%ebp)
  800497:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800499:	83 ef 01             	sub    $0x1,%edi
  80049c:	83 c4 10             	add    $0x10,%esp
  80049f:	85 ff                	test   %edi,%edi
  8004a1:	7f ed                	jg     800490 <vprintfmt+0x1b6>
  8004a3:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004a6:	85 c9                	test   %ecx,%ecx
  8004a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ad:	0f 49 c1             	cmovns %ecx,%eax
  8004b0:	29 c1                	sub    %eax,%ecx
  8004b2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004b5:	eb aa                	jmp    800461 <vprintfmt+0x187>
					putch(ch, putdat);
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	53                   	push   %ebx
  8004bb:	52                   	push   %edx
  8004bc:	ff d6                	call   *%esi
  8004be:	83 c4 10             	add    $0x10,%esp
  8004c1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004c6:	83 c7 01             	add    $0x1,%edi
  8004c9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004cd:	0f be d0             	movsbl %al,%edx
  8004d0:	85 d2                	test   %edx,%edx
  8004d2:	74 4b                	je     80051f <vprintfmt+0x245>
  8004d4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004d8:	78 06                	js     8004e0 <vprintfmt+0x206>
  8004da:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004de:	78 1e                	js     8004fe <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004e4:	74 d1                	je     8004b7 <vprintfmt+0x1dd>
  8004e6:	0f be c0             	movsbl %al,%eax
  8004e9:	83 e8 20             	sub    $0x20,%eax
  8004ec:	83 f8 5e             	cmp    $0x5e,%eax
  8004ef:	76 c6                	jbe    8004b7 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	53                   	push   %ebx
  8004f5:	6a 3f                	push   $0x3f
  8004f7:	ff d6                	call   *%esi
  8004f9:	83 c4 10             	add    $0x10,%esp
  8004fc:	eb c3                	jmp    8004c1 <vprintfmt+0x1e7>
  8004fe:	89 cf                	mov    %ecx,%edi
  800500:	eb 0e                	jmp    800510 <vprintfmt+0x236>
				putch(' ', putdat);
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	53                   	push   %ebx
  800506:	6a 20                	push   $0x20
  800508:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80050a:	83 ef 01             	sub    $0x1,%edi
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	85 ff                	test   %edi,%edi
  800512:	7f ee                	jg     800502 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800514:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800517:	89 45 14             	mov    %eax,0x14(%ebp)
  80051a:	e9 01 02 00 00       	jmp    800720 <vprintfmt+0x446>
  80051f:	89 cf                	mov    %ecx,%edi
  800521:	eb ed                	jmp    800510 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800523:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800526:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80052d:	e9 eb fd ff ff       	jmp    80031d <vprintfmt+0x43>
	if (lflag >= 2)
  800532:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800536:	7f 21                	jg     800559 <vprintfmt+0x27f>
	else if (lflag)
  800538:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80053c:	74 68                	je     8005a6 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80053e:	8b 45 14             	mov    0x14(%ebp),%eax
  800541:	8b 00                	mov    (%eax),%eax
  800543:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800546:	89 c1                	mov    %eax,%ecx
  800548:	c1 f9 1f             	sar    $0x1f,%ecx
  80054b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80054e:	8b 45 14             	mov    0x14(%ebp),%eax
  800551:	8d 40 04             	lea    0x4(%eax),%eax
  800554:	89 45 14             	mov    %eax,0x14(%ebp)
  800557:	eb 17                	jmp    800570 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8b 50 04             	mov    0x4(%eax),%edx
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800564:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 40 08             	lea    0x8(%eax),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800570:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800573:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800576:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800579:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80057c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800580:	78 3f                	js     8005c1 <vprintfmt+0x2e7>
			base = 10;
  800582:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800587:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80058b:	0f 84 71 01 00 00    	je     800702 <vprintfmt+0x428>
				putch('+', putdat);
  800591:	83 ec 08             	sub    $0x8,%esp
  800594:	53                   	push   %ebx
  800595:	6a 2b                	push   $0x2b
  800597:	ff d6                	call   *%esi
  800599:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80059c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a1:	e9 5c 01 00 00       	jmp    800702 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ae:	89 c1                	mov    %eax,%ecx
  8005b0:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b3:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8d 40 04             	lea    0x4(%eax),%eax
  8005bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bf:	eb af                	jmp    800570 <vprintfmt+0x296>
				putch('-', putdat);
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	53                   	push   %ebx
  8005c5:	6a 2d                	push   $0x2d
  8005c7:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005cf:	f7 d8                	neg    %eax
  8005d1:	83 d2 00             	adc    $0x0,%edx
  8005d4:	f7 da                	neg    %edx
  8005d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005dc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005df:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e4:	e9 19 01 00 00       	jmp    800702 <vprintfmt+0x428>
	if (lflag >= 2)
  8005e9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005ed:	7f 29                	jg     800618 <vprintfmt+0x33e>
	else if (lflag)
  8005ef:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005f3:	74 44                	je     800639 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8b 00                	mov    (%eax),%eax
  8005fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800602:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	8d 40 04             	lea    0x4(%eax),%eax
  80060b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800613:	e9 ea 00 00 00       	jmp    800702 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8b 50 04             	mov    0x4(%eax),%edx
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800623:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8d 40 08             	lea    0x8(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800634:	e9 c9 00 00 00       	jmp    800702 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	ba 00 00 00 00       	mov    $0x0,%edx
  800643:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800646:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8d 40 04             	lea    0x4(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800652:	b8 0a 00 00 00       	mov    $0xa,%eax
  800657:	e9 a6 00 00 00       	jmp    800702 <vprintfmt+0x428>
			putch('0', putdat);
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	53                   	push   %ebx
  800660:	6a 30                	push   $0x30
  800662:	ff d6                	call   *%esi
	if (lflag >= 2)
  800664:	83 c4 10             	add    $0x10,%esp
  800667:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80066b:	7f 26                	jg     800693 <vprintfmt+0x3b9>
	else if (lflag)
  80066d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800671:	74 3e                	je     8006b1 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	ba 00 00 00 00       	mov    $0x0,%edx
  80067d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800680:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8d 40 04             	lea    0x4(%eax),%eax
  800689:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068c:	b8 08 00 00 00       	mov    $0x8,%eax
  800691:	eb 6f                	jmp    800702 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8b 50 04             	mov    0x4(%eax),%edx
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8d 40 08             	lea    0x8(%eax),%eax
  8006a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006aa:	b8 08 00 00 00       	mov    $0x8,%eax
  8006af:	eb 51                	jmp    800702 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
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
  8006cf:	eb 31                	jmp    800702 <vprintfmt+0x428>
			putch('0', putdat);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	53                   	push   %ebx
  8006d5:	6a 30                	push   $0x30
  8006d7:	ff d6                	call   *%esi
			putch('x', putdat);
  8006d9:	83 c4 08             	add    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	6a 78                	push   $0x78
  8006df:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ee:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006f1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8d 40 04             	lea    0x4(%eax),%eax
  8006fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006fd:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800702:	83 ec 0c             	sub    $0xc,%esp
  800705:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800709:	52                   	push   %edx
  80070a:	ff 75 e0             	pushl  -0x20(%ebp)
  80070d:	50                   	push   %eax
  80070e:	ff 75 dc             	pushl  -0x24(%ebp)
  800711:	ff 75 d8             	pushl  -0x28(%ebp)
  800714:	89 da                	mov    %ebx,%edx
  800716:	89 f0                	mov    %esi,%eax
  800718:	e8 a4 fa ff ff       	call   8001c1 <printnum>
			break;
  80071d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800720:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800723:	83 c7 01             	add    $0x1,%edi
  800726:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80072a:	83 f8 25             	cmp    $0x25,%eax
  80072d:	0f 84 be fb ff ff    	je     8002f1 <vprintfmt+0x17>
			if (ch == '\0')
  800733:	85 c0                	test   %eax,%eax
  800735:	0f 84 28 01 00 00    	je     800863 <vprintfmt+0x589>
			putch(ch, putdat);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	53                   	push   %ebx
  80073f:	50                   	push   %eax
  800740:	ff d6                	call   *%esi
  800742:	83 c4 10             	add    $0x10,%esp
  800745:	eb dc                	jmp    800723 <vprintfmt+0x449>
	if (lflag >= 2)
  800747:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80074b:	7f 26                	jg     800773 <vprintfmt+0x499>
	else if (lflag)
  80074d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800751:	74 41                	je     800794 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	ba 00 00 00 00       	mov    $0x0,%edx
  80075d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800760:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800763:	8b 45 14             	mov    0x14(%ebp),%eax
  800766:	8d 40 04             	lea    0x4(%eax),%eax
  800769:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076c:	b8 10 00 00 00       	mov    $0x10,%eax
  800771:	eb 8f                	jmp    800702 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8b 50 04             	mov    0x4(%eax),%edx
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8d 40 08             	lea    0x8(%eax),%eax
  800787:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078a:	b8 10 00 00 00       	mov    $0x10,%eax
  80078f:	e9 6e ff ff ff       	jmp    800702 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8b 00                	mov    (%eax),%eax
  800799:	ba 00 00 00 00       	mov    $0x0,%edx
  80079e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8d 40 04             	lea    0x4(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ad:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b2:	e9 4b ff ff ff       	jmp    800702 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	83 c0 04             	add    $0x4,%eax
  8007bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	85 c0                	test   %eax,%eax
  8007c7:	74 14                	je     8007dd <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007c9:	8b 13                	mov    (%ebx),%edx
  8007cb:	83 fa 7f             	cmp    $0x7f,%edx
  8007ce:	7f 37                	jg     800807 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007d0:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d8:	e9 43 ff ff ff       	jmp    800720 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007dd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e2:	bf 11 2c 80 00       	mov    $0x802c11,%edi
							putch(ch, putdat);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	53                   	push   %ebx
  8007eb:	50                   	push   %eax
  8007ec:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007ee:	83 c7 01             	add    $0x1,%edi
  8007f1:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007f5:	83 c4 10             	add    $0x10,%esp
  8007f8:	85 c0                	test   %eax,%eax
  8007fa:	75 eb                	jne    8007e7 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800802:	e9 19 ff ff ff       	jmp    800720 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800807:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800809:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080e:	bf 49 2c 80 00       	mov    $0x802c49,%edi
							putch(ch, putdat);
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	53                   	push   %ebx
  800817:	50                   	push   %eax
  800818:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80081a:	83 c7 01             	add    $0x1,%edi
  80081d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800821:	83 c4 10             	add    $0x10,%esp
  800824:	85 c0                	test   %eax,%eax
  800826:	75 eb                	jne    800813 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800828:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80082b:	89 45 14             	mov    %eax,0x14(%ebp)
  80082e:	e9 ed fe ff ff       	jmp    800720 <vprintfmt+0x446>
			putch(ch, putdat);
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	53                   	push   %ebx
  800837:	6a 25                	push   $0x25
  800839:	ff d6                	call   *%esi
			break;
  80083b:	83 c4 10             	add    $0x10,%esp
  80083e:	e9 dd fe ff ff       	jmp    800720 <vprintfmt+0x446>
			putch('%', putdat);
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	53                   	push   %ebx
  800847:	6a 25                	push   $0x25
  800849:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80084b:	83 c4 10             	add    $0x10,%esp
  80084e:	89 f8                	mov    %edi,%eax
  800850:	eb 03                	jmp    800855 <vprintfmt+0x57b>
  800852:	83 e8 01             	sub    $0x1,%eax
  800855:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800859:	75 f7                	jne    800852 <vprintfmt+0x578>
  80085b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80085e:	e9 bd fe ff ff       	jmp    800720 <vprintfmt+0x446>
}
  800863:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800866:	5b                   	pop    %ebx
  800867:	5e                   	pop    %esi
  800868:	5f                   	pop    %edi
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	83 ec 18             	sub    $0x18,%esp
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800877:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80087a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80087e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800881:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800888:	85 c0                	test   %eax,%eax
  80088a:	74 26                	je     8008b2 <vsnprintf+0x47>
  80088c:	85 d2                	test   %edx,%edx
  80088e:	7e 22                	jle    8008b2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800890:	ff 75 14             	pushl  0x14(%ebp)
  800893:	ff 75 10             	pushl  0x10(%ebp)
  800896:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800899:	50                   	push   %eax
  80089a:	68 a0 02 80 00       	push   $0x8002a0
  80089f:	e8 36 fa ff ff       	call   8002da <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ad:	83 c4 10             	add    $0x10,%esp
}
  8008b0:	c9                   	leave  
  8008b1:	c3                   	ret    
		return -E_INVAL;
  8008b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008b7:	eb f7                	jmp    8008b0 <vsnprintf+0x45>

008008b9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008bf:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008c2:	50                   	push   %eax
  8008c3:	ff 75 10             	pushl  0x10(%ebp)
  8008c6:	ff 75 0c             	pushl  0xc(%ebp)
  8008c9:	ff 75 08             	pushl  0x8(%ebp)
  8008cc:	e8 9a ff ff ff       	call   80086b <vsnprintf>
	va_end(ap);

	return rc;
}
  8008d1:	c9                   	leave  
  8008d2:	c3                   	ret    

008008d3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008d3:	55                   	push   %ebp
  8008d4:	89 e5                	mov    %esp,%ebp
  8008d6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008de:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e2:	74 05                	je     8008e9 <strlen+0x16>
		n++;
  8008e4:	83 c0 01             	add    $0x1,%eax
  8008e7:	eb f5                	jmp    8008de <strlen+0xb>
	return n;
}
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f1:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f9:	39 c2                	cmp    %eax,%edx
  8008fb:	74 0d                	je     80090a <strnlen+0x1f>
  8008fd:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800901:	74 05                	je     800908 <strnlen+0x1d>
		n++;
  800903:	83 c2 01             	add    $0x1,%edx
  800906:	eb f1                	jmp    8008f9 <strnlen+0xe>
  800908:	89 d0                	mov    %edx,%eax
	return n;
}
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    

0080090c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	53                   	push   %ebx
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800916:	ba 00 00 00 00       	mov    $0x0,%edx
  80091b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80091f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800922:	83 c2 01             	add    $0x1,%edx
  800925:	84 c9                	test   %cl,%cl
  800927:	75 f2                	jne    80091b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800929:	5b                   	pop    %ebx
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	53                   	push   %ebx
  800930:	83 ec 10             	sub    $0x10,%esp
  800933:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800936:	53                   	push   %ebx
  800937:	e8 97 ff ff ff       	call   8008d3 <strlen>
  80093c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	01 d8                	add    %ebx,%eax
  800944:	50                   	push   %eax
  800945:	e8 c2 ff ff ff       	call   80090c <strcpy>
	return dst;
}
  80094a:	89 d8                	mov    %ebx,%eax
  80094c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80094f:	c9                   	leave  
  800950:	c3                   	ret    

00800951 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	56                   	push   %esi
  800955:	53                   	push   %ebx
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80095c:	89 c6                	mov    %eax,%esi
  80095e:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800961:	89 c2                	mov    %eax,%edx
  800963:	39 f2                	cmp    %esi,%edx
  800965:	74 11                	je     800978 <strncpy+0x27>
		*dst++ = *src;
  800967:	83 c2 01             	add    $0x1,%edx
  80096a:	0f b6 19             	movzbl (%ecx),%ebx
  80096d:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800970:	80 fb 01             	cmp    $0x1,%bl
  800973:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800976:	eb eb                	jmp    800963 <strncpy+0x12>
	}
	return ret;
}
  800978:	5b                   	pop    %ebx
  800979:	5e                   	pop    %esi
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	56                   	push   %esi
  800980:	53                   	push   %ebx
  800981:	8b 75 08             	mov    0x8(%ebp),%esi
  800984:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800987:	8b 55 10             	mov    0x10(%ebp),%edx
  80098a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80098c:	85 d2                	test   %edx,%edx
  80098e:	74 21                	je     8009b1 <strlcpy+0x35>
  800990:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800994:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800996:	39 c2                	cmp    %eax,%edx
  800998:	74 14                	je     8009ae <strlcpy+0x32>
  80099a:	0f b6 19             	movzbl (%ecx),%ebx
  80099d:	84 db                	test   %bl,%bl
  80099f:	74 0b                	je     8009ac <strlcpy+0x30>
			*dst++ = *src++;
  8009a1:	83 c1 01             	add    $0x1,%ecx
  8009a4:	83 c2 01             	add    $0x1,%edx
  8009a7:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009aa:	eb ea                	jmp    800996 <strlcpy+0x1a>
  8009ac:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ae:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009b1:	29 f0                	sub    %esi,%eax
}
  8009b3:	5b                   	pop    %ebx
  8009b4:	5e                   	pop    %esi
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009bd:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009c0:	0f b6 01             	movzbl (%ecx),%eax
  8009c3:	84 c0                	test   %al,%al
  8009c5:	74 0c                	je     8009d3 <strcmp+0x1c>
  8009c7:	3a 02                	cmp    (%edx),%al
  8009c9:	75 08                	jne    8009d3 <strcmp+0x1c>
		p++, q++;
  8009cb:	83 c1 01             	add    $0x1,%ecx
  8009ce:	83 c2 01             	add    $0x1,%edx
  8009d1:	eb ed                	jmp    8009c0 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d3:	0f b6 c0             	movzbl %al,%eax
  8009d6:	0f b6 12             	movzbl (%edx),%edx
  8009d9:	29 d0                	sub    %edx,%eax
}
  8009db:	5d                   	pop    %ebp
  8009dc:	c3                   	ret    

008009dd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	53                   	push   %ebx
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e7:	89 c3                	mov    %eax,%ebx
  8009e9:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009ec:	eb 06                	jmp    8009f4 <strncmp+0x17>
		n--, p++, q++;
  8009ee:	83 c0 01             	add    $0x1,%eax
  8009f1:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009f4:	39 d8                	cmp    %ebx,%eax
  8009f6:	74 16                	je     800a0e <strncmp+0x31>
  8009f8:	0f b6 08             	movzbl (%eax),%ecx
  8009fb:	84 c9                	test   %cl,%cl
  8009fd:	74 04                	je     800a03 <strncmp+0x26>
  8009ff:	3a 0a                	cmp    (%edx),%cl
  800a01:	74 eb                	je     8009ee <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a03:	0f b6 00             	movzbl (%eax),%eax
  800a06:	0f b6 12             	movzbl (%edx),%edx
  800a09:	29 d0                	sub    %edx,%eax
}
  800a0b:	5b                   	pop    %ebx
  800a0c:	5d                   	pop    %ebp
  800a0d:	c3                   	ret    
		return 0;
  800a0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a13:	eb f6                	jmp    800a0b <strncmp+0x2e>

00800a15 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1f:	0f b6 10             	movzbl (%eax),%edx
  800a22:	84 d2                	test   %dl,%dl
  800a24:	74 09                	je     800a2f <strchr+0x1a>
		if (*s == c)
  800a26:	38 ca                	cmp    %cl,%dl
  800a28:	74 0a                	je     800a34 <strchr+0x1f>
	for (; *s; s++)
  800a2a:	83 c0 01             	add    $0x1,%eax
  800a2d:	eb f0                	jmp    800a1f <strchr+0xa>
			return (char *) s;
	return 0;
  800a2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a34:	5d                   	pop    %ebp
  800a35:	c3                   	ret    

00800a36 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a40:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a43:	38 ca                	cmp    %cl,%dl
  800a45:	74 09                	je     800a50 <strfind+0x1a>
  800a47:	84 d2                	test   %dl,%dl
  800a49:	74 05                	je     800a50 <strfind+0x1a>
	for (; *s; s++)
  800a4b:	83 c0 01             	add    $0x1,%eax
  800a4e:	eb f0                	jmp    800a40 <strfind+0xa>
			break;
	return (char *) s;
}
  800a50:	5d                   	pop    %ebp
  800a51:	c3                   	ret    

00800a52 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a52:	55                   	push   %ebp
  800a53:	89 e5                	mov    %esp,%ebp
  800a55:	57                   	push   %edi
  800a56:	56                   	push   %esi
  800a57:	53                   	push   %ebx
  800a58:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a5e:	85 c9                	test   %ecx,%ecx
  800a60:	74 31                	je     800a93 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a62:	89 f8                	mov    %edi,%eax
  800a64:	09 c8                	or     %ecx,%eax
  800a66:	a8 03                	test   $0x3,%al
  800a68:	75 23                	jne    800a8d <memset+0x3b>
		c &= 0xFF;
  800a6a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a6e:	89 d3                	mov    %edx,%ebx
  800a70:	c1 e3 08             	shl    $0x8,%ebx
  800a73:	89 d0                	mov    %edx,%eax
  800a75:	c1 e0 18             	shl    $0x18,%eax
  800a78:	89 d6                	mov    %edx,%esi
  800a7a:	c1 e6 10             	shl    $0x10,%esi
  800a7d:	09 f0                	or     %esi,%eax
  800a7f:	09 c2                	or     %eax,%edx
  800a81:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a83:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a86:	89 d0                	mov    %edx,%eax
  800a88:	fc                   	cld    
  800a89:	f3 ab                	rep stos %eax,%es:(%edi)
  800a8b:	eb 06                	jmp    800a93 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a90:	fc                   	cld    
  800a91:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a93:	89 f8                	mov    %edi,%eax
  800a95:	5b                   	pop    %ebx
  800a96:	5e                   	pop    %esi
  800a97:	5f                   	pop    %edi
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    

00800a9a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	57                   	push   %edi
  800a9e:	56                   	push   %esi
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aa8:	39 c6                	cmp    %eax,%esi
  800aaa:	73 32                	jae    800ade <memmove+0x44>
  800aac:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aaf:	39 c2                	cmp    %eax,%edx
  800ab1:	76 2b                	jbe    800ade <memmove+0x44>
		s += n;
		d += n;
  800ab3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab6:	89 fe                	mov    %edi,%esi
  800ab8:	09 ce                	or     %ecx,%esi
  800aba:	09 d6                	or     %edx,%esi
  800abc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac2:	75 0e                	jne    800ad2 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac4:	83 ef 04             	sub    $0x4,%edi
  800ac7:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aca:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800acd:	fd                   	std    
  800ace:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad0:	eb 09                	jmp    800adb <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ad2:	83 ef 01             	sub    $0x1,%edi
  800ad5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ad8:	fd                   	std    
  800ad9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800adb:	fc                   	cld    
  800adc:	eb 1a                	jmp    800af8 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ade:	89 c2                	mov    %eax,%edx
  800ae0:	09 ca                	or     %ecx,%edx
  800ae2:	09 f2                	or     %esi,%edx
  800ae4:	f6 c2 03             	test   $0x3,%dl
  800ae7:	75 0a                	jne    800af3 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ae9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aec:	89 c7                	mov    %eax,%edi
  800aee:	fc                   	cld    
  800aef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af1:	eb 05                	jmp    800af8 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800af3:	89 c7                	mov    %eax,%edi
  800af5:	fc                   	cld    
  800af6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800af8:	5e                   	pop    %esi
  800af9:	5f                   	pop    %edi
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b02:	ff 75 10             	pushl  0x10(%ebp)
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	ff 75 08             	pushl  0x8(%ebp)
  800b0b:	e8 8a ff ff ff       	call   800a9a <memmove>
}
  800b10:	c9                   	leave  
  800b11:	c3                   	ret    

00800b12 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	56                   	push   %esi
  800b16:	53                   	push   %ebx
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1d:	89 c6                	mov    %eax,%esi
  800b1f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b22:	39 f0                	cmp    %esi,%eax
  800b24:	74 1c                	je     800b42 <memcmp+0x30>
		if (*s1 != *s2)
  800b26:	0f b6 08             	movzbl (%eax),%ecx
  800b29:	0f b6 1a             	movzbl (%edx),%ebx
  800b2c:	38 d9                	cmp    %bl,%cl
  800b2e:	75 08                	jne    800b38 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b30:	83 c0 01             	add    $0x1,%eax
  800b33:	83 c2 01             	add    $0x1,%edx
  800b36:	eb ea                	jmp    800b22 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b38:	0f b6 c1             	movzbl %cl,%eax
  800b3b:	0f b6 db             	movzbl %bl,%ebx
  800b3e:	29 d8                	sub    %ebx,%eax
  800b40:	eb 05                	jmp    800b47 <memcmp+0x35>
	}

	return 0;
  800b42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b47:	5b                   	pop    %ebx
  800b48:	5e                   	pop    %esi
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b54:	89 c2                	mov    %eax,%edx
  800b56:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b59:	39 d0                	cmp    %edx,%eax
  800b5b:	73 09                	jae    800b66 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b5d:	38 08                	cmp    %cl,(%eax)
  800b5f:	74 05                	je     800b66 <memfind+0x1b>
	for (; s < ends; s++)
  800b61:	83 c0 01             	add    $0x1,%eax
  800b64:	eb f3                	jmp    800b59 <memfind+0xe>
			break;
	return (void *) s;
}
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	57                   	push   %edi
  800b6c:	56                   	push   %esi
  800b6d:	53                   	push   %ebx
  800b6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b71:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b74:	eb 03                	jmp    800b79 <strtol+0x11>
		s++;
  800b76:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b79:	0f b6 01             	movzbl (%ecx),%eax
  800b7c:	3c 20                	cmp    $0x20,%al
  800b7e:	74 f6                	je     800b76 <strtol+0xe>
  800b80:	3c 09                	cmp    $0x9,%al
  800b82:	74 f2                	je     800b76 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b84:	3c 2b                	cmp    $0x2b,%al
  800b86:	74 2a                	je     800bb2 <strtol+0x4a>
	int neg = 0;
  800b88:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b8d:	3c 2d                	cmp    $0x2d,%al
  800b8f:	74 2b                	je     800bbc <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b91:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b97:	75 0f                	jne    800ba8 <strtol+0x40>
  800b99:	80 39 30             	cmpb   $0x30,(%ecx)
  800b9c:	74 28                	je     800bc6 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b9e:	85 db                	test   %ebx,%ebx
  800ba0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ba5:	0f 44 d8             	cmove  %eax,%ebx
  800ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bad:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bb0:	eb 50                	jmp    800c02 <strtol+0x9a>
		s++;
  800bb2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bb5:	bf 00 00 00 00       	mov    $0x0,%edi
  800bba:	eb d5                	jmp    800b91 <strtol+0x29>
		s++, neg = 1;
  800bbc:	83 c1 01             	add    $0x1,%ecx
  800bbf:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc4:	eb cb                	jmp    800b91 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bca:	74 0e                	je     800bda <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bcc:	85 db                	test   %ebx,%ebx
  800bce:	75 d8                	jne    800ba8 <strtol+0x40>
		s++, base = 8;
  800bd0:	83 c1 01             	add    $0x1,%ecx
  800bd3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bd8:	eb ce                	jmp    800ba8 <strtol+0x40>
		s += 2, base = 16;
  800bda:	83 c1 02             	add    $0x2,%ecx
  800bdd:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be2:	eb c4                	jmp    800ba8 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800be4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800be7:	89 f3                	mov    %esi,%ebx
  800be9:	80 fb 19             	cmp    $0x19,%bl
  800bec:	77 29                	ja     800c17 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bee:	0f be d2             	movsbl %dl,%edx
  800bf1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bf4:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bf7:	7d 30                	jge    800c29 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bf9:	83 c1 01             	add    $0x1,%ecx
  800bfc:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c00:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c02:	0f b6 11             	movzbl (%ecx),%edx
  800c05:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c08:	89 f3                	mov    %esi,%ebx
  800c0a:	80 fb 09             	cmp    $0x9,%bl
  800c0d:	77 d5                	ja     800be4 <strtol+0x7c>
			dig = *s - '0';
  800c0f:	0f be d2             	movsbl %dl,%edx
  800c12:	83 ea 30             	sub    $0x30,%edx
  800c15:	eb dd                	jmp    800bf4 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c17:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c1a:	89 f3                	mov    %esi,%ebx
  800c1c:	80 fb 19             	cmp    $0x19,%bl
  800c1f:	77 08                	ja     800c29 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c21:	0f be d2             	movsbl %dl,%edx
  800c24:	83 ea 37             	sub    $0x37,%edx
  800c27:	eb cb                	jmp    800bf4 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c29:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2d:	74 05                	je     800c34 <strtol+0xcc>
		*endptr = (char *) s;
  800c2f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c32:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c34:	89 c2                	mov    %eax,%edx
  800c36:	f7 da                	neg    %edx
  800c38:	85 ff                	test   %edi,%edi
  800c3a:	0f 45 c2             	cmovne %edx,%eax
}
  800c3d:	5b                   	pop    %ebx
  800c3e:	5e                   	pop    %esi
  800c3f:	5f                   	pop    %edi
  800c40:	5d                   	pop    %ebp
  800c41:	c3                   	ret    

00800c42 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	57                   	push   %edi
  800c46:	56                   	push   %esi
  800c47:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c48:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c53:	89 c3                	mov    %eax,%ebx
  800c55:	89 c7                	mov    %eax,%edi
  800c57:	89 c6                	mov    %eax,%esi
  800c59:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c5b:	5b                   	pop    %ebx
  800c5c:	5e                   	pop    %esi
  800c5d:	5f                   	pop    %edi
  800c5e:	5d                   	pop    %ebp
  800c5f:	c3                   	ret    

00800c60 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	57                   	push   %edi
  800c64:	56                   	push   %esi
  800c65:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c66:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6b:	b8 01 00 00 00       	mov    $0x1,%eax
  800c70:	89 d1                	mov    %edx,%ecx
  800c72:	89 d3                	mov    %edx,%ebx
  800c74:	89 d7                	mov    %edx,%edi
  800c76:	89 d6                	mov    %edx,%esi
  800c78:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c7a:	5b                   	pop    %ebx
  800c7b:	5e                   	pop    %esi
  800c7c:	5f                   	pop    %edi
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    

00800c7f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	57                   	push   %edi
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
  800c85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c88:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c90:	b8 03 00 00 00       	mov    $0x3,%eax
  800c95:	89 cb                	mov    %ecx,%ebx
  800c97:	89 cf                	mov    %ecx,%edi
  800c99:	89 ce                	mov    %ecx,%esi
  800c9b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9d:	85 c0                	test   %eax,%eax
  800c9f:	7f 08                	jg     800ca9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ca1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca9:	83 ec 0c             	sub    $0xc,%esp
  800cac:	50                   	push   %eax
  800cad:	6a 03                	push   $0x3
  800caf:	68 68 2e 80 00       	push   $0x802e68
  800cb4:	6a 43                	push   $0x43
  800cb6:	68 85 2e 80 00       	push   $0x802e85
  800cbb:	e8 76 1a 00 00       	call   802736 <_panic>

00800cc0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	57                   	push   %edi
  800cc4:	56                   	push   %esi
  800cc5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccb:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd0:	89 d1                	mov    %edx,%ecx
  800cd2:	89 d3                	mov    %edx,%ebx
  800cd4:	89 d7                	mov    %edx,%edi
  800cd6:	89 d6                	mov    %edx,%esi
  800cd8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cda:	5b                   	pop    %ebx
  800cdb:	5e                   	pop    %esi
  800cdc:	5f                   	pop    %edi
  800cdd:	5d                   	pop    %ebp
  800cde:	c3                   	ret    

00800cdf <sys_yield>:

void
sys_yield(void)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	57                   	push   %edi
  800ce3:	56                   	push   %esi
  800ce4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cea:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cef:	89 d1                	mov    %edx,%ecx
  800cf1:	89 d3                	mov    %edx,%ebx
  800cf3:	89 d7                	mov    %edx,%edi
  800cf5:	89 d6                	mov    %edx,%esi
  800cf7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cf9:	5b                   	pop    %ebx
  800cfa:	5e                   	pop    %esi
  800cfb:	5f                   	pop    %edi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	57                   	push   %edi
  800d02:	56                   	push   %esi
  800d03:	53                   	push   %ebx
  800d04:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d07:	be 00 00 00 00       	mov    $0x0,%esi
  800d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d12:	b8 04 00 00 00       	mov    $0x4,%eax
  800d17:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1a:	89 f7                	mov    %esi,%edi
  800d1c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1e:	85 c0                	test   %eax,%eax
  800d20:	7f 08                	jg     800d2a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2a:	83 ec 0c             	sub    $0xc,%esp
  800d2d:	50                   	push   %eax
  800d2e:	6a 04                	push   $0x4
  800d30:	68 68 2e 80 00       	push   $0x802e68
  800d35:	6a 43                	push   $0x43
  800d37:	68 85 2e 80 00       	push   $0x802e85
  800d3c:	e8 f5 19 00 00       	call   802736 <_panic>

00800d41 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	57                   	push   %edi
  800d45:	56                   	push   %esi
  800d46:	53                   	push   %ebx
  800d47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d50:	b8 05 00 00 00       	mov    $0x5,%eax
  800d55:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d58:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d5b:	8b 75 18             	mov    0x18(%ebp),%esi
  800d5e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d60:	85 c0                	test   %eax,%eax
  800d62:	7f 08                	jg     800d6c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d67:	5b                   	pop    %ebx
  800d68:	5e                   	pop    %esi
  800d69:	5f                   	pop    %edi
  800d6a:	5d                   	pop    %ebp
  800d6b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6c:	83 ec 0c             	sub    $0xc,%esp
  800d6f:	50                   	push   %eax
  800d70:	6a 05                	push   $0x5
  800d72:	68 68 2e 80 00       	push   $0x802e68
  800d77:	6a 43                	push   $0x43
  800d79:	68 85 2e 80 00       	push   $0x802e85
  800d7e:	e8 b3 19 00 00       	call   802736 <_panic>

00800d83 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	57                   	push   %edi
  800d87:	56                   	push   %esi
  800d88:	53                   	push   %ebx
  800d89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d91:	8b 55 08             	mov    0x8(%ebp),%edx
  800d94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d97:	b8 06 00 00 00       	mov    $0x6,%eax
  800d9c:	89 df                	mov    %ebx,%edi
  800d9e:	89 de                	mov    %ebx,%esi
  800da0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da2:	85 c0                	test   %eax,%eax
  800da4:	7f 08                	jg     800dae <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800da6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da9:	5b                   	pop    %ebx
  800daa:	5e                   	pop    %esi
  800dab:	5f                   	pop    %edi
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dae:	83 ec 0c             	sub    $0xc,%esp
  800db1:	50                   	push   %eax
  800db2:	6a 06                	push   $0x6
  800db4:	68 68 2e 80 00       	push   $0x802e68
  800db9:	6a 43                	push   $0x43
  800dbb:	68 85 2e 80 00       	push   $0x802e85
  800dc0:	e8 71 19 00 00       	call   802736 <_panic>

00800dc5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	57                   	push   %edi
  800dc9:	56                   	push   %esi
  800dca:	53                   	push   %ebx
  800dcb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dce:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd9:	b8 08 00 00 00       	mov    $0x8,%eax
  800dde:	89 df                	mov    %ebx,%edi
  800de0:	89 de                	mov    %ebx,%esi
  800de2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de4:	85 c0                	test   %eax,%eax
  800de6:	7f 08                	jg     800df0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800deb:	5b                   	pop    %ebx
  800dec:	5e                   	pop    %esi
  800ded:	5f                   	pop    %edi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df0:	83 ec 0c             	sub    $0xc,%esp
  800df3:	50                   	push   %eax
  800df4:	6a 08                	push   $0x8
  800df6:	68 68 2e 80 00       	push   $0x802e68
  800dfb:	6a 43                	push   $0x43
  800dfd:	68 85 2e 80 00       	push   $0x802e85
  800e02:	e8 2f 19 00 00       	call   802736 <_panic>

00800e07 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	57                   	push   %edi
  800e0b:	56                   	push   %esi
  800e0c:	53                   	push   %ebx
  800e0d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e10:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e15:	8b 55 08             	mov    0x8(%ebp),%edx
  800e18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1b:	b8 09 00 00 00       	mov    $0x9,%eax
  800e20:	89 df                	mov    %ebx,%edi
  800e22:	89 de                	mov    %ebx,%esi
  800e24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e26:	85 c0                	test   %eax,%eax
  800e28:	7f 08                	jg     800e32 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2d:	5b                   	pop    %ebx
  800e2e:	5e                   	pop    %esi
  800e2f:	5f                   	pop    %edi
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e32:	83 ec 0c             	sub    $0xc,%esp
  800e35:	50                   	push   %eax
  800e36:	6a 09                	push   $0x9
  800e38:	68 68 2e 80 00       	push   $0x802e68
  800e3d:	6a 43                	push   $0x43
  800e3f:	68 85 2e 80 00       	push   $0x802e85
  800e44:	e8 ed 18 00 00       	call   802736 <_panic>

00800e49 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	57                   	push   %edi
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e52:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e57:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e62:	89 df                	mov    %ebx,%edi
  800e64:	89 de                	mov    %ebx,%esi
  800e66:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e68:	85 c0                	test   %eax,%eax
  800e6a:	7f 08                	jg     800e74 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6f:	5b                   	pop    %ebx
  800e70:	5e                   	pop    %esi
  800e71:	5f                   	pop    %edi
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e74:	83 ec 0c             	sub    $0xc,%esp
  800e77:	50                   	push   %eax
  800e78:	6a 0a                	push   $0xa
  800e7a:	68 68 2e 80 00       	push   $0x802e68
  800e7f:	6a 43                	push   $0x43
  800e81:	68 85 2e 80 00       	push   $0x802e85
  800e86:	e8 ab 18 00 00       	call   802736 <_panic>

00800e8b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	57                   	push   %edi
  800e8f:	56                   	push   %esi
  800e90:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e91:	8b 55 08             	mov    0x8(%ebp),%edx
  800e94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e97:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e9c:	be 00 00 00 00       	mov    $0x0,%esi
  800ea1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ea7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ea9:	5b                   	pop    %ebx
  800eaa:	5e                   	pop    %esi
  800eab:	5f                   	pop    %edi
  800eac:	5d                   	pop    %ebp
  800ead:	c3                   	ret    

00800eae <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	57                   	push   %edi
  800eb2:	56                   	push   %esi
  800eb3:	53                   	push   %ebx
  800eb4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebf:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ec4:	89 cb                	mov    %ecx,%ebx
  800ec6:	89 cf                	mov    %ecx,%edi
  800ec8:	89 ce                	mov    %ecx,%esi
  800eca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ecc:	85 c0                	test   %eax,%eax
  800ece:	7f 08                	jg     800ed8 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed3:	5b                   	pop    %ebx
  800ed4:	5e                   	pop    %esi
  800ed5:	5f                   	pop    %edi
  800ed6:	5d                   	pop    %ebp
  800ed7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed8:	83 ec 0c             	sub    $0xc,%esp
  800edb:	50                   	push   %eax
  800edc:	6a 0d                	push   $0xd
  800ede:	68 68 2e 80 00       	push   $0x802e68
  800ee3:	6a 43                	push   $0x43
  800ee5:	68 85 2e 80 00       	push   $0x802e85
  800eea:	e8 47 18 00 00       	call   802736 <_panic>

00800eef <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	57                   	push   %edi
  800ef3:	56                   	push   %esi
  800ef4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efa:	8b 55 08             	mov    0x8(%ebp),%edx
  800efd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f00:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f05:	89 df                	mov    %ebx,%edi
  800f07:	89 de                	mov    %ebx,%esi
  800f09:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f0b:	5b                   	pop    %ebx
  800f0c:	5e                   	pop    %esi
  800f0d:	5f                   	pop    %edi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	57                   	push   %edi
  800f14:	56                   	push   %esi
  800f15:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f16:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f23:	89 cb                	mov    %ecx,%ebx
  800f25:	89 cf                	mov    %ecx,%edi
  800f27:	89 ce                	mov    %ecx,%esi
  800f29:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f2b:	5b                   	pop    %ebx
  800f2c:	5e                   	pop    %esi
  800f2d:	5f                   	pop    %edi
  800f2e:	5d                   	pop    %ebp
  800f2f:	c3                   	ret    

00800f30 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	57                   	push   %edi
  800f34:	56                   	push   %esi
  800f35:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f36:	ba 00 00 00 00       	mov    $0x0,%edx
  800f3b:	b8 10 00 00 00       	mov    $0x10,%eax
  800f40:	89 d1                	mov    %edx,%ecx
  800f42:	89 d3                	mov    %edx,%ebx
  800f44:	89 d7                	mov    %edx,%edi
  800f46:	89 d6                	mov    %edx,%esi
  800f48:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f4a:	5b                   	pop    %ebx
  800f4b:	5e                   	pop    %esi
  800f4c:	5f                   	pop    %edi
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    

00800f4f <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	57                   	push   %edi
  800f53:	56                   	push   %esi
  800f54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f55:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f60:	b8 11 00 00 00       	mov    $0x11,%eax
  800f65:	89 df                	mov    %ebx,%edi
  800f67:	89 de                	mov    %ebx,%esi
  800f69:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f6b:	5b                   	pop    %ebx
  800f6c:	5e                   	pop    %esi
  800f6d:	5f                   	pop    %edi
  800f6e:	5d                   	pop    %ebp
  800f6f:	c3                   	ret    

00800f70 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	57                   	push   %edi
  800f74:	56                   	push   %esi
  800f75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f81:	b8 12 00 00 00       	mov    $0x12,%eax
  800f86:	89 df                	mov    %ebx,%edi
  800f88:	89 de                	mov    %ebx,%esi
  800f8a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f8c:	5b                   	pop    %ebx
  800f8d:	5e                   	pop    %esi
  800f8e:	5f                   	pop    %edi
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    

00800f91 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	57                   	push   %edi
  800f95:	56                   	push   %esi
  800f96:	53                   	push   %ebx
  800f97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa5:	b8 13 00 00 00       	mov    $0x13,%eax
  800faa:	89 df                	mov    %ebx,%edi
  800fac:	89 de                	mov    %ebx,%esi
  800fae:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	7f 08                	jg     800fbc <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb7:	5b                   	pop    %ebx
  800fb8:	5e                   	pop    %esi
  800fb9:	5f                   	pop    %edi
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbc:	83 ec 0c             	sub    $0xc,%esp
  800fbf:	50                   	push   %eax
  800fc0:	6a 13                	push   $0x13
  800fc2:	68 68 2e 80 00       	push   $0x802e68
  800fc7:	6a 43                	push   $0x43
  800fc9:	68 85 2e 80 00       	push   $0x802e85
  800fce:	e8 63 17 00 00       	call   802736 <_panic>

00800fd3 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	57                   	push   %edi
  800fd7:	56                   	push   %esi
  800fd8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fde:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe1:	b8 14 00 00 00       	mov    $0x14,%eax
  800fe6:	89 cb                	mov    %ecx,%ebx
  800fe8:	89 cf                	mov    %ecx,%edi
  800fea:	89 ce                	mov    %ecx,%esi
  800fec:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  800fee:	5b                   	pop    %ebx
  800fef:	5e                   	pop    %esi
  800ff0:	5f                   	pop    %edi
  800ff1:	5d                   	pop    %ebp
  800ff2:	c3                   	ret    

00800ff3 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	53                   	push   %ebx
  800ff7:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  800ffa:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801001:	f6 c5 04             	test   $0x4,%ch
  801004:	75 45                	jne    80104b <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801006:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80100d:	83 e1 07             	and    $0x7,%ecx
  801010:	83 f9 07             	cmp    $0x7,%ecx
  801013:	74 6f                	je     801084 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801015:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80101c:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801022:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801028:	0f 84 b6 00 00 00    	je     8010e4 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80102e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801035:	83 e1 05             	and    $0x5,%ecx
  801038:	83 f9 05             	cmp    $0x5,%ecx
  80103b:	0f 84 d7 00 00 00    	je     801118 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801041:	b8 00 00 00 00       	mov    $0x0,%eax
  801046:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801049:	c9                   	leave  
  80104a:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  80104b:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801052:	c1 e2 0c             	shl    $0xc,%edx
  801055:	83 ec 0c             	sub    $0xc,%esp
  801058:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80105e:	51                   	push   %ecx
  80105f:	52                   	push   %edx
  801060:	50                   	push   %eax
  801061:	52                   	push   %edx
  801062:	6a 00                	push   $0x0
  801064:	e8 d8 fc ff ff       	call   800d41 <sys_page_map>
		if(r < 0)
  801069:	83 c4 20             	add    $0x20,%esp
  80106c:	85 c0                	test   %eax,%eax
  80106e:	79 d1                	jns    801041 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801070:	83 ec 04             	sub    $0x4,%esp
  801073:	68 93 2e 80 00       	push   $0x802e93
  801078:	6a 54                	push   $0x54
  80107a:	68 a9 2e 80 00       	push   $0x802ea9
  80107f:	e8 b2 16 00 00       	call   802736 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801084:	89 d3                	mov    %edx,%ebx
  801086:	c1 e3 0c             	shl    $0xc,%ebx
  801089:	83 ec 0c             	sub    $0xc,%esp
  80108c:	68 05 08 00 00       	push   $0x805
  801091:	53                   	push   %ebx
  801092:	50                   	push   %eax
  801093:	53                   	push   %ebx
  801094:	6a 00                	push   $0x0
  801096:	e8 a6 fc ff ff       	call   800d41 <sys_page_map>
		if(r < 0)
  80109b:	83 c4 20             	add    $0x20,%esp
  80109e:	85 c0                	test   %eax,%eax
  8010a0:	78 2e                	js     8010d0 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8010a2:	83 ec 0c             	sub    $0xc,%esp
  8010a5:	68 05 08 00 00       	push   $0x805
  8010aa:	53                   	push   %ebx
  8010ab:	6a 00                	push   $0x0
  8010ad:	53                   	push   %ebx
  8010ae:	6a 00                	push   $0x0
  8010b0:	e8 8c fc ff ff       	call   800d41 <sys_page_map>
		if(r < 0)
  8010b5:	83 c4 20             	add    $0x20,%esp
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	79 85                	jns    801041 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8010bc:	83 ec 04             	sub    $0x4,%esp
  8010bf:	68 93 2e 80 00       	push   $0x802e93
  8010c4:	6a 5f                	push   $0x5f
  8010c6:	68 a9 2e 80 00       	push   $0x802ea9
  8010cb:	e8 66 16 00 00       	call   802736 <_panic>
			panic("sys_page_map() panic\n");
  8010d0:	83 ec 04             	sub    $0x4,%esp
  8010d3:	68 93 2e 80 00       	push   $0x802e93
  8010d8:	6a 5b                	push   $0x5b
  8010da:	68 a9 2e 80 00       	push   $0x802ea9
  8010df:	e8 52 16 00 00       	call   802736 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010e4:	c1 e2 0c             	shl    $0xc,%edx
  8010e7:	83 ec 0c             	sub    $0xc,%esp
  8010ea:	68 05 08 00 00       	push   $0x805
  8010ef:	52                   	push   %edx
  8010f0:	50                   	push   %eax
  8010f1:	52                   	push   %edx
  8010f2:	6a 00                	push   $0x0
  8010f4:	e8 48 fc ff ff       	call   800d41 <sys_page_map>
		if(r < 0)
  8010f9:	83 c4 20             	add    $0x20,%esp
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	0f 89 3d ff ff ff    	jns    801041 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801104:	83 ec 04             	sub    $0x4,%esp
  801107:	68 93 2e 80 00       	push   $0x802e93
  80110c:	6a 66                	push   $0x66
  80110e:	68 a9 2e 80 00       	push   $0x802ea9
  801113:	e8 1e 16 00 00       	call   802736 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801118:	c1 e2 0c             	shl    $0xc,%edx
  80111b:	83 ec 0c             	sub    $0xc,%esp
  80111e:	6a 05                	push   $0x5
  801120:	52                   	push   %edx
  801121:	50                   	push   %eax
  801122:	52                   	push   %edx
  801123:	6a 00                	push   $0x0
  801125:	e8 17 fc ff ff       	call   800d41 <sys_page_map>
		if(r < 0)
  80112a:	83 c4 20             	add    $0x20,%esp
  80112d:	85 c0                	test   %eax,%eax
  80112f:	0f 89 0c ff ff ff    	jns    801041 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801135:	83 ec 04             	sub    $0x4,%esp
  801138:	68 93 2e 80 00       	push   $0x802e93
  80113d:	6a 6d                	push   $0x6d
  80113f:	68 a9 2e 80 00       	push   $0x802ea9
  801144:	e8 ed 15 00 00       	call   802736 <_panic>

00801149 <pgfault>:
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	53                   	push   %ebx
  80114d:	83 ec 04             	sub    $0x4,%esp
  801150:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801153:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801155:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801159:	0f 84 99 00 00 00    	je     8011f8 <pgfault+0xaf>
  80115f:	89 c2                	mov    %eax,%edx
  801161:	c1 ea 16             	shr    $0x16,%edx
  801164:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80116b:	f6 c2 01             	test   $0x1,%dl
  80116e:	0f 84 84 00 00 00    	je     8011f8 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801174:	89 c2                	mov    %eax,%edx
  801176:	c1 ea 0c             	shr    $0xc,%edx
  801179:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801180:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801186:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  80118c:	75 6a                	jne    8011f8 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  80118e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801193:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801195:	83 ec 04             	sub    $0x4,%esp
  801198:	6a 07                	push   $0x7
  80119a:	68 00 f0 7f 00       	push   $0x7ff000
  80119f:	6a 00                	push   $0x0
  8011a1:	e8 58 fb ff ff       	call   800cfe <sys_page_alloc>
	if(ret < 0)
  8011a6:	83 c4 10             	add    $0x10,%esp
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	78 5f                	js     80120c <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8011ad:	83 ec 04             	sub    $0x4,%esp
  8011b0:	68 00 10 00 00       	push   $0x1000
  8011b5:	53                   	push   %ebx
  8011b6:	68 00 f0 7f 00       	push   $0x7ff000
  8011bb:	e8 3c f9 ff ff       	call   800afc <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8011c0:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8011c7:	53                   	push   %ebx
  8011c8:	6a 00                	push   $0x0
  8011ca:	68 00 f0 7f 00       	push   $0x7ff000
  8011cf:	6a 00                	push   $0x0
  8011d1:	e8 6b fb ff ff       	call   800d41 <sys_page_map>
	if(ret < 0)
  8011d6:	83 c4 20             	add    $0x20,%esp
  8011d9:	85 c0                	test   %eax,%eax
  8011db:	78 43                	js     801220 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8011dd:	83 ec 08             	sub    $0x8,%esp
  8011e0:	68 00 f0 7f 00       	push   $0x7ff000
  8011e5:	6a 00                	push   $0x0
  8011e7:	e8 97 fb ff ff       	call   800d83 <sys_page_unmap>
	if(ret < 0)
  8011ec:	83 c4 10             	add    $0x10,%esp
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	78 41                	js     801234 <pgfault+0xeb>
}
  8011f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f6:	c9                   	leave  
  8011f7:	c3                   	ret    
		panic("panic at pgfault()\n");
  8011f8:	83 ec 04             	sub    $0x4,%esp
  8011fb:	68 b4 2e 80 00       	push   $0x802eb4
  801200:	6a 26                	push   $0x26
  801202:	68 a9 2e 80 00       	push   $0x802ea9
  801207:	e8 2a 15 00 00       	call   802736 <_panic>
		panic("panic in sys_page_alloc()\n");
  80120c:	83 ec 04             	sub    $0x4,%esp
  80120f:	68 c8 2e 80 00       	push   $0x802ec8
  801214:	6a 31                	push   $0x31
  801216:	68 a9 2e 80 00       	push   $0x802ea9
  80121b:	e8 16 15 00 00       	call   802736 <_panic>
		panic("panic in sys_page_map()\n");
  801220:	83 ec 04             	sub    $0x4,%esp
  801223:	68 e3 2e 80 00       	push   $0x802ee3
  801228:	6a 36                	push   $0x36
  80122a:	68 a9 2e 80 00       	push   $0x802ea9
  80122f:	e8 02 15 00 00       	call   802736 <_panic>
		panic("panic in sys_page_unmap()\n");
  801234:	83 ec 04             	sub    $0x4,%esp
  801237:	68 fc 2e 80 00       	push   $0x802efc
  80123c:	6a 39                	push   $0x39
  80123e:	68 a9 2e 80 00       	push   $0x802ea9
  801243:	e8 ee 14 00 00       	call   802736 <_panic>

00801248 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
  80124b:	57                   	push   %edi
  80124c:	56                   	push   %esi
  80124d:	53                   	push   %ebx
  80124e:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801251:	68 49 11 80 00       	push   $0x801149
  801256:	e8 3c 15 00 00       	call   802797 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80125b:	b8 07 00 00 00       	mov    $0x7,%eax
  801260:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801262:	83 c4 10             	add    $0x10,%esp
  801265:	85 c0                	test   %eax,%eax
  801267:	78 2a                	js     801293 <fork+0x4b>
  801269:	89 c6                	mov    %eax,%esi
  80126b:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80126d:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801272:	75 4b                	jne    8012bf <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  801274:	e8 47 fa ff ff       	call   800cc0 <sys_getenvid>
  801279:	25 ff 03 00 00       	and    $0x3ff,%eax
  80127e:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801284:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801289:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  80128e:	e9 90 00 00 00       	jmp    801323 <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  801293:	83 ec 04             	sub    $0x4,%esp
  801296:	68 18 2f 80 00       	push   $0x802f18
  80129b:	68 8c 00 00 00       	push   $0x8c
  8012a0:	68 a9 2e 80 00       	push   $0x802ea9
  8012a5:	e8 8c 14 00 00       	call   802736 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8012aa:	89 f8                	mov    %edi,%eax
  8012ac:	e8 42 fd ff ff       	call   800ff3 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012b7:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8012bd:	74 26                	je     8012e5 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8012bf:	89 d8                	mov    %ebx,%eax
  8012c1:	c1 e8 16             	shr    $0x16,%eax
  8012c4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012cb:	a8 01                	test   $0x1,%al
  8012cd:	74 e2                	je     8012b1 <fork+0x69>
  8012cf:	89 da                	mov    %ebx,%edx
  8012d1:	c1 ea 0c             	shr    $0xc,%edx
  8012d4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8012db:	83 e0 05             	and    $0x5,%eax
  8012de:	83 f8 05             	cmp    $0x5,%eax
  8012e1:	75 ce                	jne    8012b1 <fork+0x69>
  8012e3:	eb c5                	jmp    8012aa <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8012e5:	83 ec 04             	sub    $0x4,%esp
  8012e8:	6a 07                	push   $0x7
  8012ea:	68 00 f0 bf ee       	push   $0xeebff000
  8012ef:	56                   	push   %esi
  8012f0:	e8 09 fa ff ff       	call   800cfe <sys_page_alloc>
	if(ret < 0)
  8012f5:	83 c4 10             	add    $0x10,%esp
  8012f8:	85 c0                	test   %eax,%eax
  8012fa:	78 31                	js     80132d <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8012fc:	83 ec 08             	sub    $0x8,%esp
  8012ff:	68 06 28 80 00       	push   $0x802806
  801304:	56                   	push   %esi
  801305:	e8 3f fb ff ff       	call   800e49 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80130a:	83 c4 10             	add    $0x10,%esp
  80130d:	85 c0                	test   %eax,%eax
  80130f:	78 33                	js     801344 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801311:	83 ec 08             	sub    $0x8,%esp
  801314:	6a 02                	push   $0x2
  801316:	56                   	push   %esi
  801317:	e8 a9 fa ff ff       	call   800dc5 <sys_env_set_status>
	if(ret < 0)
  80131c:	83 c4 10             	add    $0x10,%esp
  80131f:	85 c0                	test   %eax,%eax
  801321:	78 38                	js     80135b <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801323:	89 f0                	mov    %esi,%eax
  801325:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801328:	5b                   	pop    %ebx
  801329:	5e                   	pop    %esi
  80132a:	5f                   	pop    %edi
  80132b:	5d                   	pop    %ebp
  80132c:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80132d:	83 ec 04             	sub    $0x4,%esp
  801330:	68 c8 2e 80 00       	push   $0x802ec8
  801335:	68 98 00 00 00       	push   $0x98
  80133a:	68 a9 2e 80 00       	push   $0x802ea9
  80133f:	e8 f2 13 00 00       	call   802736 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801344:	83 ec 04             	sub    $0x4,%esp
  801347:	68 3c 2f 80 00       	push   $0x802f3c
  80134c:	68 9b 00 00 00       	push   $0x9b
  801351:	68 a9 2e 80 00       	push   $0x802ea9
  801356:	e8 db 13 00 00       	call   802736 <_panic>
		panic("panic in sys_env_set_status()\n");
  80135b:	83 ec 04             	sub    $0x4,%esp
  80135e:	68 64 2f 80 00       	push   $0x802f64
  801363:	68 9e 00 00 00       	push   $0x9e
  801368:	68 a9 2e 80 00       	push   $0x802ea9
  80136d:	e8 c4 13 00 00       	call   802736 <_panic>

00801372 <sfork>:

// Challenge!
int
sfork(void)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
  801375:	57                   	push   %edi
  801376:	56                   	push   %esi
  801377:	53                   	push   %ebx
  801378:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  80137b:	68 49 11 80 00       	push   $0x801149
  801380:	e8 12 14 00 00       	call   802797 <set_pgfault_handler>
  801385:	b8 07 00 00 00       	mov    $0x7,%eax
  80138a:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80138c:	83 c4 10             	add    $0x10,%esp
  80138f:	85 c0                	test   %eax,%eax
  801391:	78 2a                	js     8013bd <sfork+0x4b>
  801393:	89 c7                	mov    %eax,%edi
  801395:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801397:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80139c:	75 58                	jne    8013f6 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  80139e:	e8 1d f9 ff ff       	call   800cc0 <sys_getenvid>
  8013a3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013a8:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8013ae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013b3:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8013b8:	e9 d4 00 00 00       	jmp    801491 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  8013bd:	83 ec 04             	sub    $0x4,%esp
  8013c0:	68 18 2f 80 00       	push   $0x802f18
  8013c5:	68 af 00 00 00       	push   $0xaf
  8013ca:	68 a9 2e 80 00       	push   $0x802ea9
  8013cf:	e8 62 13 00 00       	call   802736 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8013d4:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8013d9:	89 f0                	mov    %esi,%eax
  8013db:	e8 13 fc ff ff       	call   800ff3 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013e0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013e6:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8013ec:	77 65                	ja     801453 <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  8013ee:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8013f4:	74 de                	je     8013d4 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8013f6:	89 d8                	mov    %ebx,%eax
  8013f8:	c1 e8 16             	shr    $0x16,%eax
  8013fb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801402:	a8 01                	test   $0x1,%al
  801404:	74 da                	je     8013e0 <sfork+0x6e>
  801406:	89 da                	mov    %ebx,%edx
  801408:	c1 ea 0c             	shr    $0xc,%edx
  80140b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801412:	83 e0 05             	and    $0x5,%eax
  801415:	83 f8 05             	cmp    $0x5,%eax
  801418:	75 c6                	jne    8013e0 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80141a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801421:	c1 e2 0c             	shl    $0xc,%edx
  801424:	83 ec 0c             	sub    $0xc,%esp
  801427:	83 e0 07             	and    $0x7,%eax
  80142a:	50                   	push   %eax
  80142b:	52                   	push   %edx
  80142c:	56                   	push   %esi
  80142d:	52                   	push   %edx
  80142e:	6a 00                	push   $0x0
  801430:	e8 0c f9 ff ff       	call   800d41 <sys_page_map>
  801435:	83 c4 20             	add    $0x20,%esp
  801438:	85 c0                	test   %eax,%eax
  80143a:	74 a4                	je     8013e0 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	68 93 2e 80 00       	push   $0x802e93
  801444:	68 ba 00 00 00       	push   $0xba
  801449:	68 a9 2e 80 00       	push   $0x802ea9
  80144e:	e8 e3 12 00 00       	call   802736 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801453:	83 ec 04             	sub    $0x4,%esp
  801456:	6a 07                	push   $0x7
  801458:	68 00 f0 bf ee       	push   $0xeebff000
  80145d:	57                   	push   %edi
  80145e:	e8 9b f8 ff ff       	call   800cfe <sys_page_alloc>
	if(ret < 0)
  801463:	83 c4 10             	add    $0x10,%esp
  801466:	85 c0                	test   %eax,%eax
  801468:	78 31                	js     80149b <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80146a:	83 ec 08             	sub    $0x8,%esp
  80146d:	68 06 28 80 00       	push   $0x802806
  801472:	57                   	push   %edi
  801473:	e8 d1 f9 ff ff       	call   800e49 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	85 c0                	test   %eax,%eax
  80147d:	78 33                	js     8014b2 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80147f:	83 ec 08             	sub    $0x8,%esp
  801482:	6a 02                	push   $0x2
  801484:	57                   	push   %edi
  801485:	e8 3b f9 ff ff       	call   800dc5 <sys_env_set_status>
	if(ret < 0)
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	85 c0                	test   %eax,%eax
  80148f:	78 38                	js     8014c9 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801491:	89 f8                	mov    %edi,%eax
  801493:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801496:	5b                   	pop    %ebx
  801497:	5e                   	pop    %esi
  801498:	5f                   	pop    %edi
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80149b:	83 ec 04             	sub    $0x4,%esp
  80149e:	68 c8 2e 80 00       	push   $0x802ec8
  8014a3:	68 c0 00 00 00       	push   $0xc0
  8014a8:	68 a9 2e 80 00       	push   $0x802ea9
  8014ad:	e8 84 12 00 00       	call   802736 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014b2:	83 ec 04             	sub    $0x4,%esp
  8014b5:	68 3c 2f 80 00       	push   $0x802f3c
  8014ba:	68 c3 00 00 00       	push   $0xc3
  8014bf:	68 a9 2e 80 00       	push   $0x802ea9
  8014c4:	e8 6d 12 00 00       	call   802736 <_panic>
		panic("panic in sys_env_set_status()\n");
  8014c9:	83 ec 04             	sub    $0x4,%esp
  8014cc:	68 64 2f 80 00       	push   $0x802f64
  8014d1:	68 c6 00 00 00       	push   $0xc6
  8014d6:	68 a9 2e 80 00       	push   $0x802ea9
  8014db:	e8 56 12 00 00       	call   802736 <_panic>

008014e0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	56                   	push   %esi
  8014e4:	53                   	push   %ebx
  8014e5:	8b 75 08             	mov    0x8(%ebp),%esi
  8014e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8014ee:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8014f0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8014f5:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8014f8:	83 ec 0c             	sub    $0xc,%esp
  8014fb:	50                   	push   %eax
  8014fc:	e8 ad f9 ff ff       	call   800eae <sys_ipc_recv>
	if(ret < 0){
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	85 c0                	test   %eax,%eax
  801506:	78 2b                	js     801533 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801508:	85 f6                	test   %esi,%esi
  80150a:	74 0a                	je     801516 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80150c:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801511:	8b 40 78             	mov    0x78(%eax),%eax
  801514:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801516:	85 db                	test   %ebx,%ebx
  801518:	74 0a                	je     801524 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80151a:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80151f:	8b 40 7c             	mov    0x7c(%eax),%eax
  801522:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801524:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801529:	8b 40 74             	mov    0x74(%eax),%eax
}
  80152c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80152f:	5b                   	pop    %ebx
  801530:	5e                   	pop    %esi
  801531:	5d                   	pop    %ebp
  801532:	c3                   	ret    
		if(from_env_store)
  801533:	85 f6                	test   %esi,%esi
  801535:	74 06                	je     80153d <ipc_recv+0x5d>
			*from_env_store = 0;
  801537:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80153d:	85 db                	test   %ebx,%ebx
  80153f:	74 eb                	je     80152c <ipc_recv+0x4c>
			*perm_store = 0;
  801541:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801547:	eb e3                	jmp    80152c <ipc_recv+0x4c>

00801549 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	57                   	push   %edi
  80154d:	56                   	push   %esi
  80154e:	53                   	push   %ebx
  80154f:	83 ec 0c             	sub    $0xc,%esp
  801552:	8b 7d 08             	mov    0x8(%ebp),%edi
  801555:	8b 75 0c             	mov    0xc(%ebp),%esi
  801558:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80155b:	85 db                	test   %ebx,%ebx
  80155d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801562:	0f 44 d8             	cmove  %eax,%ebx
  801565:	eb 05                	jmp    80156c <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801567:	e8 73 f7 ff ff       	call   800cdf <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80156c:	ff 75 14             	pushl  0x14(%ebp)
  80156f:	53                   	push   %ebx
  801570:	56                   	push   %esi
  801571:	57                   	push   %edi
  801572:	e8 14 f9 ff ff       	call   800e8b <sys_ipc_try_send>
  801577:	83 c4 10             	add    $0x10,%esp
  80157a:	85 c0                	test   %eax,%eax
  80157c:	74 1b                	je     801599 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80157e:	79 e7                	jns    801567 <ipc_send+0x1e>
  801580:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801583:	74 e2                	je     801567 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801585:	83 ec 04             	sub    $0x4,%esp
  801588:	68 83 2f 80 00       	push   $0x802f83
  80158d:	6a 46                	push   $0x46
  80158f:	68 98 2f 80 00       	push   $0x802f98
  801594:	e8 9d 11 00 00       	call   802736 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801599:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80159c:	5b                   	pop    %ebx
  80159d:	5e                   	pop    %esi
  80159e:	5f                   	pop    %edi
  80159f:	5d                   	pop    %ebp
  8015a0:	c3                   	ret    

008015a1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8015a7:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8015ac:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8015b2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8015b8:	8b 52 50             	mov    0x50(%edx),%edx
  8015bb:	39 ca                	cmp    %ecx,%edx
  8015bd:	74 11                	je     8015d0 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8015bf:	83 c0 01             	add    $0x1,%eax
  8015c2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8015c7:	75 e3                	jne    8015ac <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8015c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ce:	eb 0e                	jmp    8015de <ipc_find_env+0x3d>
			return envs[i].env_id;
  8015d0:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8015d6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015db:	8b 40 48             	mov    0x48(%eax),%eax
}
  8015de:	5d                   	pop    %ebp
  8015df:	c3                   	ret    

008015e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8015eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8015ee:	5d                   	pop    %ebp
  8015ef:	c3                   	ret    

008015f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8015fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801600:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801605:	5d                   	pop    %ebp
  801606:	c3                   	ret    

00801607 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80160f:	89 c2                	mov    %eax,%edx
  801611:	c1 ea 16             	shr    $0x16,%edx
  801614:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80161b:	f6 c2 01             	test   $0x1,%dl
  80161e:	74 2d                	je     80164d <fd_alloc+0x46>
  801620:	89 c2                	mov    %eax,%edx
  801622:	c1 ea 0c             	shr    $0xc,%edx
  801625:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80162c:	f6 c2 01             	test   $0x1,%dl
  80162f:	74 1c                	je     80164d <fd_alloc+0x46>
  801631:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801636:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80163b:	75 d2                	jne    80160f <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801646:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80164b:	eb 0a                	jmp    801657 <fd_alloc+0x50>
			*fd_store = fd;
  80164d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801650:	89 01                	mov    %eax,(%ecx)
			return 0;
  801652:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801657:	5d                   	pop    %ebp
  801658:	c3                   	ret    

00801659 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80165f:	83 f8 1f             	cmp    $0x1f,%eax
  801662:	77 30                	ja     801694 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801664:	c1 e0 0c             	shl    $0xc,%eax
  801667:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80166c:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801672:	f6 c2 01             	test   $0x1,%dl
  801675:	74 24                	je     80169b <fd_lookup+0x42>
  801677:	89 c2                	mov    %eax,%edx
  801679:	c1 ea 0c             	shr    $0xc,%edx
  80167c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801683:	f6 c2 01             	test   $0x1,%dl
  801686:	74 1a                	je     8016a2 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168b:	89 02                	mov    %eax,(%edx)
	return 0;
  80168d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801692:	5d                   	pop    %ebp
  801693:	c3                   	ret    
		return -E_INVAL;
  801694:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801699:	eb f7                	jmp    801692 <fd_lookup+0x39>
		return -E_INVAL;
  80169b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a0:	eb f0                	jmp    801692 <fd_lookup+0x39>
  8016a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a7:	eb e9                	jmp    801692 <fd_lookup+0x39>

008016a9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 08             	sub    $0x8,%esp
  8016af:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8016b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b7:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8016bc:	39 08                	cmp    %ecx,(%eax)
  8016be:	74 38                	je     8016f8 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8016c0:	83 c2 01             	add    $0x1,%edx
  8016c3:	8b 04 95 20 30 80 00 	mov    0x803020(,%edx,4),%eax
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	75 ee                	jne    8016bc <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016ce:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8016d3:	8b 40 48             	mov    0x48(%eax),%eax
  8016d6:	83 ec 04             	sub    $0x4,%esp
  8016d9:	51                   	push   %ecx
  8016da:	50                   	push   %eax
  8016db:	68 a4 2f 80 00       	push   $0x802fa4
  8016e0:	e8 c8 ea ff ff       	call   8001ad <cprintf>
	*dev = 0;
  8016e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    
			*dev = devtab[i];
  8016f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016fb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801702:	eb f2                	jmp    8016f6 <dev_lookup+0x4d>

00801704 <fd_close>:
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	57                   	push   %edi
  801708:	56                   	push   %esi
  801709:	53                   	push   %ebx
  80170a:	83 ec 24             	sub    $0x24,%esp
  80170d:	8b 75 08             	mov    0x8(%ebp),%esi
  801710:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801713:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801716:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801717:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80171d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801720:	50                   	push   %eax
  801721:	e8 33 ff ff ff       	call   801659 <fd_lookup>
  801726:	89 c3                	mov    %eax,%ebx
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	85 c0                	test   %eax,%eax
  80172d:	78 05                	js     801734 <fd_close+0x30>
	    || fd != fd2)
  80172f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801732:	74 16                	je     80174a <fd_close+0x46>
		return (must_exist ? r : 0);
  801734:	89 f8                	mov    %edi,%eax
  801736:	84 c0                	test   %al,%al
  801738:	b8 00 00 00 00       	mov    $0x0,%eax
  80173d:	0f 44 d8             	cmove  %eax,%ebx
}
  801740:	89 d8                	mov    %ebx,%eax
  801742:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801745:	5b                   	pop    %ebx
  801746:	5e                   	pop    %esi
  801747:	5f                   	pop    %edi
  801748:	5d                   	pop    %ebp
  801749:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80174a:	83 ec 08             	sub    $0x8,%esp
  80174d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801750:	50                   	push   %eax
  801751:	ff 36                	pushl  (%esi)
  801753:	e8 51 ff ff ff       	call   8016a9 <dev_lookup>
  801758:	89 c3                	mov    %eax,%ebx
  80175a:	83 c4 10             	add    $0x10,%esp
  80175d:	85 c0                	test   %eax,%eax
  80175f:	78 1a                	js     80177b <fd_close+0x77>
		if (dev->dev_close)
  801761:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801764:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801767:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80176c:	85 c0                	test   %eax,%eax
  80176e:	74 0b                	je     80177b <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801770:	83 ec 0c             	sub    $0xc,%esp
  801773:	56                   	push   %esi
  801774:	ff d0                	call   *%eax
  801776:	89 c3                	mov    %eax,%ebx
  801778:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80177b:	83 ec 08             	sub    $0x8,%esp
  80177e:	56                   	push   %esi
  80177f:	6a 00                	push   $0x0
  801781:	e8 fd f5 ff ff       	call   800d83 <sys_page_unmap>
	return r;
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	eb b5                	jmp    801740 <fd_close+0x3c>

0080178b <close>:

int
close(int fdnum)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801791:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801794:	50                   	push   %eax
  801795:	ff 75 08             	pushl  0x8(%ebp)
  801798:	e8 bc fe ff ff       	call   801659 <fd_lookup>
  80179d:	83 c4 10             	add    $0x10,%esp
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	79 02                	jns    8017a6 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    
		return fd_close(fd, 1);
  8017a6:	83 ec 08             	sub    $0x8,%esp
  8017a9:	6a 01                	push   $0x1
  8017ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ae:	e8 51 ff ff ff       	call   801704 <fd_close>
  8017b3:	83 c4 10             	add    $0x10,%esp
  8017b6:	eb ec                	jmp    8017a4 <close+0x19>

008017b8 <close_all>:

void
close_all(void)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	53                   	push   %ebx
  8017bc:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017bf:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017c4:	83 ec 0c             	sub    $0xc,%esp
  8017c7:	53                   	push   %ebx
  8017c8:	e8 be ff ff ff       	call   80178b <close>
	for (i = 0; i < MAXFD; i++)
  8017cd:	83 c3 01             	add    $0x1,%ebx
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	83 fb 20             	cmp    $0x20,%ebx
  8017d6:	75 ec                	jne    8017c4 <close_all+0xc>
}
  8017d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	57                   	push   %edi
  8017e1:	56                   	push   %esi
  8017e2:	53                   	push   %ebx
  8017e3:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017e6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017e9:	50                   	push   %eax
  8017ea:	ff 75 08             	pushl  0x8(%ebp)
  8017ed:	e8 67 fe ff ff       	call   801659 <fd_lookup>
  8017f2:	89 c3                	mov    %eax,%ebx
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	0f 88 81 00 00 00    	js     801880 <dup+0xa3>
		return r;
	close(newfdnum);
  8017ff:	83 ec 0c             	sub    $0xc,%esp
  801802:	ff 75 0c             	pushl  0xc(%ebp)
  801805:	e8 81 ff ff ff       	call   80178b <close>

	newfd = INDEX2FD(newfdnum);
  80180a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80180d:	c1 e6 0c             	shl    $0xc,%esi
  801810:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801816:	83 c4 04             	add    $0x4,%esp
  801819:	ff 75 e4             	pushl  -0x1c(%ebp)
  80181c:	e8 cf fd ff ff       	call   8015f0 <fd2data>
  801821:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801823:	89 34 24             	mov    %esi,(%esp)
  801826:	e8 c5 fd ff ff       	call   8015f0 <fd2data>
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801830:	89 d8                	mov    %ebx,%eax
  801832:	c1 e8 16             	shr    $0x16,%eax
  801835:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80183c:	a8 01                	test   $0x1,%al
  80183e:	74 11                	je     801851 <dup+0x74>
  801840:	89 d8                	mov    %ebx,%eax
  801842:	c1 e8 0c             	shr    $0xc,%eax
  801845:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80184c:	f6 c2 01             	test   $0x1,%dl
  80184f:	75 39                	jne    80188a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801851:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801854:	89 d0                	mov    %edx,%eax
  801856:	c1 e8 0c             	shr    $0xc,%eax
  801859:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801860:	83 ec 0c             	sub    $0xc,%esp
  801863:	25 07 0e 00 00       	and    $0xe07,%eax
  801868:	50                   	push   %eax
  801869:	56                   	push   %esi
  80186a:	6a 00                	push   $0x0
  80186c:	52                   	push   %edx
  80186d:	6a 00                	push   $0x0
  80186f:	e8 cd f4 ff ff       	call   800d41 <sys_page_map>
  801874:	89 c3                	mov    %eax,%ebx
  801876:	83 c4 20             	add    $0x20,%esp
  801879:	85 c0                	test   %eax,%eax
  80187b:	78 31                	js     8018ae <dup+0xd1>
		goto err;

	return newfdnum;
  80187d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801880:	89 d8                	mov    %ebx,%eax
  801882:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801885:	5b                   	pop    %ebx
  801886:	5e                   	pop    %esi
  801887:	5f                   	pop    %edi
  801888:	5d                   	pop    %ebp
  801889:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80188a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801891:	83 ec 0c             	sub    $0xc,%esp
  801894:	25 07 0e 00 00       	and    $0xe07,%eax
  801899:	50                   	push   %eax
  80189a:	57                   	push   %edi
  80189b:	6a 00                	push   $0x0
  80189d:	53                   	push   %ebx
  80189e:	6a 00                	push   $0x0
  8018a0:	e8 9c f4 ff ff       	call   800d41 <sys_page_map>
  8018a5:	89 c3                	mov    %eax,%ebx
  8018a7:	83 c4 20             	add    $0x20,%esp
  8018aa:	85 c0                	test   %eax,%eax
  8018ac:	79 a3                	jns    801851 <dup+0x74>
	sys_page_unmap(0, newfd);
  8018ae:	83 ec 08             	sub    $0x8,%esp
  8018b1:	56                   	push   %esi
  8018b2:	6a 00                	push   $0x0
  8018b4:	e8 ca f4 ff ff       	call   800d83 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018b9:	83 c4 08             	add    $0x8,%esp
  8018bc:	57                   	push   %edi
  8018bd:	6a 00                	push   $0x0
  8018bf:	e8 bf f4 ff ff       	call   800d83 <sys_page_unmap>
	return r;
  8018c4:	83 c4 10             	add    $0x10,%esp
  8018c7:	eb b7                	jmp    801880 <dup+0xa3>

008018c9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	53                   	push   %ebx
  8018cd:	83 ec 1c             	sub    $0x1c,%esp
  8018d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018d6:	50                   	push   %eax
  8018d7:	53                   	push   %ebx
  8018d8:	e8 7c fd ff ff       	call   801659 <fd_lookup>
  8018dd:	83 c4 10             	add    $0x10,%esp
  8018e0:	85 c0                	test   %eax,%eax
  8018e2:	78 3f                	js     801923 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018e4:	83 ec 08             	sub    $0x8,%esp
  8018e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ea:	50                   	push   %eax
  8018eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ee:	ff 30                	pushl  (%eax)
  8018f0:	e8 b4 fd ff ff       	call   8016a9 <dev_lookup>
  8018f5:	83 c4 10             	add    $0x10,%esp
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	78 27                	js     801923 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ff:	8b 42 08             	mov    0x8(%edx),%eax
  801902:	83 e0 03             	and    $0x3,%eax
  801905:	83 f8 01             	cmp    $0x1,%eax
  801908:	74 1e                	je     801928 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80190a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190d:	8b 40 08             	mov    0x8(%eax),%eax
  801910:	85 c0                	test   %eax,%eax
  801912:	74 35                	je     801949 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801914:	83 ec 04             	sub    $0x4,%esp
  801917:	ff 75 10             	pushl  0x10(%ebp)
  80191a:	ff 75 0c             	pushl  0xc(%ebp)
  80191d:	52                   	push   %edx
  80191e:	ff d0                	call   *%eax
  801920:	83 c4 10             	add    $0x10,%esp
}
  801923:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801926:	c9                   	leave  
  801927:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801928:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80192d:	8b 40 48             	mov    0x48(%eax),%eax
  801930:	83 ec 04             	sub    $0x4,%esp
  801933:	53                   	push   %ebx
  801934:	50                   	push   %eax
  801935:	68 e5 2f 80 00       	push   $0x802fe5
  80193a:	e8 6e e8 ff ff       	call   8001ad <cprintf>
		return -E_INVAL;
  80193f:	83 c4 10             	add    $0x10,%esp
  801942:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801947:	eb da                	jmp    801923 <read+0x5a>
		return -E_NOT_SUPP;
  801949:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80194e:	eb d3                	jmp    801923 <read+0x5a>

00801950 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	57                   	push   %edi
  801954:	56                   	push   %esi
  801955:	53                   	push   %ebx
  801956:	83 ec 0c             	sub    $0xc,%esp
  801959:	8b 7d 08             	mov    0x8(%ebp),%edi
  80195c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80195f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801964:	39 f3                	cmp    %esi,%ebx
  801966:	73 23                	jae    80198b <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801968:	83 ec 04             	sub    $0x4,%esp
  80196b:	89 f0                	mov    %esi,%eax
  80196d:	29 d8                	sub    %ebx,%eax
  80196f:	50                   	push   %eax
  801970:	89 d8                	mov    %ebx,%eax
  801972:	03 45 0c             	add    0xc(%ebp),%eax
  801975:	50                   	push   %eax
  801976:	57                   	push   %edi
  801977:	e8 4d ff ff ff       	call   8018c9 <read>
		if (m < 0)
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	85 c0                	test   %eax,%eax
  801981:	78 06                	js     801989 <readn+0x39>
			return m;
		if (m == 0)
  801983:	74 06                	je     80198b <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801985:	01 c3                	add    %eax,%ebx
  801987:	eb db                	jmp    801964 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801989:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80198b:	89 d8                	mov    %ebx,%eax
  80198d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801990:	5b                   	pop    %ebx
  801991:	5e                   	pop    %esi
  801992:	5f                   	pop    %edi
  801993:	5d                   	pop    %ebp
  801994:	c3                   	ret    

00801995 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	53                   	push   %ebx
  801999:	83 ec 1c             	sub    $0x1c,%esp
  80199c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80199f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a2:	50                   	push   %eax
  8019a3:	53                   	push   %ebx
  8019a4:	e8 b0 fc ff ff       	call   801659 <fd_lookup>
  8019a9:	83 c4 10             	add    $0x10,%esp
  8019ac:	85 c0                	test   %eax,%eax
  8019ae:	78 3a                	js     8019ea <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019b0:	83 ec 08             	sub    $0x8,%esp
  8019b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b6:	50                   	push   %eax
  8019b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ba:	ff 30                	pushl  (%eax)
  8019bc:	e8 e8 fc ff ff       	call   8016a9 <dev_lookup>
  8019c1:	83 c4 10             	add    $0x10,%esp
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	78 22                	js     8019ea <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019cf:	74 1e                	je     8019ef <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019d4:	8b 52 0c             	mov    0xc(%edx),%edx
  8019d7:	85 d2                	test   %edx,%edx
  8019d9:	74 35                	je     801a10 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019db:	83 ec 04             	sub    $0x4,%esp
  8019de:	ff 75 10             	pushl  0x10(%ebp)
  8019e1:	ff 75 0c             	pushl  0xc(%ebp)
  8019e4:	50                   	push   %eax
  8019e5:	ff d2                	call   *%edx
  8019e7:	83 c4 10             	add    $0x10,%esp
}
  8019ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019ef:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8019f4:	8b 40 48             	mov    0x48(%eax),%eax
  8019f7:	83 ec 04             	sub    $0x4,%esp
  8019fa:	53                   	push   %ebx
  8019fb:	50                   	push   %eax
  8019fc:	68 01 30 80 00       	push   $0x803001
  801a01:	e8 a7 e7 ff ff       	call   8001ad <cprintf>
		return -E_INVAL;
  801a06:	83 c4 10             	add    $0x10,%esp
  801a09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a0e:	eb da                	jmp    8019ea <write+0x55>
		return -E_NOT_SUPP;
  801a10:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a15:	eb d3                	jmp    8019ea <write+0x55>

00801a17 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a20:	50                   	push   %eax
  801a21:	ff 75 08             	pushl  0x8(%ebp)
  801a24:	e8 30 fc ff ff       	call   801659 <fd_lookup>
  801a29:	83 c4 10             	add    $0x10,%esp
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	78 0e                	js     801a3e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a36:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	53                   	push   %ebx
  801a44:	83 ec 1c             	sub    $0x1c,%esp
  801a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a4a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a4d:	50                   	push   %eax
  801a4e:	53                   	push   %ebx
  801a4f:	e8 05 fc ff ff       	call   801659 <fd_lookup>
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	85 c0                	test   %eax,%eax
  801a59:	78 37                	js     801a92 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a5b:	83 ec 08             	sub    $0x8,%esp
  801a5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a61:	50                   	push   %eax
  801a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a65:	ff 30                	pushl  (%eax)
  801a67:	e8 3d fc ff ff       	call   8016a9 <dev_lookup>
  801a6c:	83 c4 10             	add    $0x10,%esp
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	78 1f                	js     801a92 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a76:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a7a:	74 1b                	je     801a97 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a7f:	8b 52 18             	mov    0x18(%edx),%edx
  801a82:	85 d2                	test   %edx,%edx
  801a84:	74 32                	je     801ab8 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a86:	83 ec 08             	sub    $0x8,%esp
  801a89:	ff 75 0c             	pushl  0xc(%ebp)
  801a8c:	50                   	push   %eax
  801a8d:	ff d2                	call   *%edx
  801a8f:	83 c4 10             	add    $0x10,%esp
}
  801a92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a97:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a9c:	8b 40 48             	mov    0x48(%eax),%eax
  801a9f:	83 ec 04             	sub    $0x4,%esp
  801aa2:	53                   	push   %ebx
  801aa3:	50                   	push   %eax
  801aa4:	68 c4 2f 80 00       	push   $0x802fc4
  801aa9:	e8 ff e6 ff ff       	call   8001ad <cprintf>
		return -E_INVAL;
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ab6:	eb da                	jmp    801a92 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801ab8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801abd:	eb d3                	jmp    801a92 <ftruncate+0x52>

00801abf <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	53                   	push   %ebx
  801ac3:	83 ec 1c             	sub    $0x1c,%esp
  801ac6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ac9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801acc:	50                   	push   %eax
  801acd:	ff 75 08             	pushl  0x8(%ebp)
  801ad0:	e8 84 fb ff ff       	call   801659 <fd_lookup>
  801ad5:	83 c4 10             	add    $0x10,%esp
  801ad8:	85 c0                	test   %eax,%eax
  801ada:	78 4b                	js     801b27 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801adc:	83 ec 08             	sub    $0x8,%esp
  801adf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae2:	50                   	push   %eax
  801ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae6:	ff 30                	pushl  (%eax)
  801ae8:	e8 bc fb ff ff       	call   8016a9 <dev_lookup>
  801aed:	83 c4 10             	add    $0x10,%esp
  801af0:	85 c0                	test   %eax,%eax
  801af2:	78 33                	js     801b27 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af7:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801afb:	74 2f                	je     801b2c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801afd:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b00:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b07:	00 00 00 
	stat->st_isdir = 0;
  801b0a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b11:	00 00 00 
	stat->st_dev = dev;
  801b14:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b1a:	83 ec 08             	sub    $0x8,%esp
  801b1d:	53                   	push   %ebx
  801b1e:	ff 75 f0             	pushl  -0x10(%ebp)
  801b21:	ff 50 14             	call   *0x14(%eax)
  801b24:	83 c4 10             	add    $0x10,%esp
}
  801b27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    
		return -E_NOT_SUPP;
  801b2c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b31:	eb f4                	jmp    801b27 <fstat+0x68>

00801b33 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	56                   	push   %esi
  801b37:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b38:	83 ec 08             	sub    $0x8,%esp
  801b3b:	6a 00                	push   $0x0
  801b3d:	ff 75 08             	pushl  0x8(%ebp)
  801b40:	e8 22 02 00 00       	call   801d67 <open>
  801b45:	89 c3                	mov    %eax,%ebx
  801b47:	83 c4 10             	add    $0x10,%esp
  801b4a:	85 c0                	test   %eax,%eax
  801b4c:	78 1b                	js     801b69 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b4e:	83 ec 08             	sub    $0x8,%esp
  801b51:	ff 75 0c             	pushl  0xc(%ebp)
  801b54:	50                   	push   %eax
  801b55:	e8 65 ff ff ff       	call   801abf <fstat>
  801b5a:	89 c6                	mov    %eax,%esi
	close(fd);
  801b5c:	89 1c 24             	mov    %ebx,(%esp)
  801b5f:	e8 27 fc ff ff       	call   80178b <close>
	return r;
  801b64:	83 c4 10             	add    $0x10,%esp
  801b67:	89 f3                	mov    %esi,%ebx
}
  801b69:	89 d8                	mov    %ebx,%eax
  801b6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b6e:	5b                   	pop    %ebx
  801b6f:	5e                   	pop    %esi
  801b70:	5d                   	pop    %ebp
  801b71:	c3                   	ret    

00801b72 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	56                   	push   %esi
  801b76:	53                   	push   %ebx
  801b77:	89 c6                	mov    %eax,%esi
  801b79:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b7b:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b82:	74 27                	je     801bab <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b84:	6a 07                	push   $0x7
  801b86:	68 00 60 80 00       	push   $0x806000
  801b8b:	56                   	push   %esi
  801b8c:	ff 35 00 50 80 00    	pushl  0x805000
  801b92:	e8 b2 f9 ff ff       	call   801549 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b97:	83 c4 0c             	add    $0xc,%esp
  801b9a:	6a 00                	push   $0x0
  801b9c:	53                   	push   %ebx
  801b9d:	6a 00                	push   $0x0
  801b9f:	e8 3c f9 ff ff       	call   8014e0 <ipc_recv>
}
  801ba4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba7:	5b                   	pop    %ebx
  801ba8:	5e                   	pop    %esi
  801ba9:	5d                   	pop    %ebp
  801baa:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bab:	83 ec 0c             	sub    $0xc,%esp
  801bae:	6a 01                	push   $0x1
  801bb0:	e8 ec f9 ff ff       	call   8015a1 <ipc_find_env>
  801bb5:	a3 00 50 80 00       	mov    %eax,0x805000
  801bba:	83 c4 10             	add    $0x10,%esp
  801bbd:	eb c5                	jmp    801b84 <fsipc+0x12>

00801bbf <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	8b 40 0c             	mov    0xc(%eax),%eax
  801bcb:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd3:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801bd8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bdd:	b8 02 00 00 00       	mov    $0x2,%eax
  801be2:	e8 8b ff ff ff       	call   801b72 <fsipc>
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <devfile_flush>:
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf5:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801bff:	b8 06 00 00 00       	mov    $0x6,%eax
  801c04:	e8 69 ff ff ff       	call   801b72 <fsipc>
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <devfile_stat>:
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	53                   	push   %ebx
  801c0f:	83 ec 04             	sub    $0x4,%esp
  801c12:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	8b 40 0c             	mov    0xc(%eax),%eax
  801c1b:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c20:	ba 00 00 00 00       	mov    $0x0,%edx
  801c25:	b8 05 00 00 00       	mov    $0x5,%eax
  801c2a:	e8 43 ff ff ff       	call   801b72 <fsipc>
  801c2f:	85 c0                	test   %eax,%eax
  801c31:	78 2c                	js     801c5f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c33:	83 ec 08             	sub    $0x8,%esp
  801c36:	68 00 60 80 00       	push   $0x806000
  801c3b:	53                   	push   %ebx
  801c3c:	e8 cb ec ff ff       	call   80090c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c41:	a1 80 60 80 00       	mov    0x806080,%eax
  801c46:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c4c:	a1 84 60 80 00       	mov    0x806084,%eax
  801c51:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c57:	83 c4 10             	add    $0x10,%esp
  801c5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <devfile_write>:
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
  801c67:	53                   	push   %ebx
  801c68:	83 ec 08             	sub    $0x8,%esp
  801c6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	8b 40 0c             	mov    0xc(%eax),%eax
  801c74:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801c79:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801c7f:	53                   	push   %ebx
  801c80:	ff 75 0c             	pushl  0xc(%ebp)
  801c83:	68 08 60 80 00       	push   $0x806008
  801c88:	e8 6f ee ff ff       	call   800afc <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c92:	b8 04 00 00 00       	mov    $0x4,%eax
  801c97:	e8 d6 fe ff ff       	call   801b72 <fsipc>
  801c9c:	83 c4 10             	add    $0x10,%esp
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	78 0b                	js     801cae <devfile_write+0x4a>
	assert(r <= n);
  801ca3:	39 d8                	cmp    %ebx,%eax
  801ca5:	77 0c                	ja     801cb3 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801ca7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cac:	7f 1e                	jg     801ccc <devfile_write+0x68>
}
  801cae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    
	assert(r <= n);
  801cb3:	68 34 30 80 00       	push   $0x803034
  801cb8:	68 3b 30 80 00       	push   $0x80303b
  801cbd:	68 98 00 00 00       	push   $0x98
  801cc2:	68 50 30 80 00       	push   $0x803050
  801cc7:	e8 6a 0a 00 00       	call   802736 <_panic>
	assert(r <= PGSIZE);
  801ccc:	68 5b 30 80 00       	push   $0x80305b
  801cd1:	68 3b 30 80 00       	push   $0x80303b
  801cd6:	68 99 00 00 00       	push   $0x99
  801cdb:	68 50 30 80 00       	push   $0x803050
  801ce0:	e8 51 0a 00 00       	call   802736 <_panic>

00801ce5 <devfile_read>:
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	56                   	push   %esi
  801ce9:	53                   	push   %ebx
  801cea:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801cf8:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cfe:	ba 00 00 00 00       	mov    $0x0,%edx
  801d03:	b8 03 00 00 00       	mov    $0x3,%eax
  801d08:	e8 65 fe ff ff       	call   801b72 <fsipc>
  801d0d:	89 c3                	mov    %eax,%ebx
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	78 1f                	js     801d32 <devfile_read+0x4d>
	assert(r <= n);
  801d13:	39 f0                	cmp    %esi,%eax
  801d15:	77 24                	ja     801d3b <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d17:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d1c:	7f 33                	jg     801d51 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d1e:	83 ec 04             	sub    $0x4,%esp
  801d21:	50                   	push   %eax
  801d22:	68 00 60 80 00       	push   $0x806000
  801d27:	ff 75 0c             	pushl  0xc(%ebp)
  801d2a:	e8 6b ed ff ff       	call   800a9a <memmove>
	return r;
  801d2f:	83 c4 10             	add    $0x10,%esp
}
  801d32:	89 d8                	mov    %ebx,%eax
  801d34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d37:	5b                   	pop    %ebx
  801d38:	5e                   	pop    %esi
  801d39:	5d                   	pop    %ebp
  801d3a:	c3                   	ret    
	assert(r <= n);
  801d3b:	68 34 30 80 00       	push   $0x803034
  801d40:	68 3b 30 80 00       	push   $0x80303b
  801d45:	6a 7c                	push   $0x7c
  801d47:	68 50 30 80 00       	push   $0x803050
  801d4c:	e8 e5 09 00 00       	call   802736 <_panic>
	assert(r <= PGSIZE);
  801d51:	68 5b 30 80 00       	push   $0x80305b
  801d56:	68 3b 30 80 00       	push   $0x80303b
  801d5b:	6a 7d                	push   $0x7d
  801d5d:	68 50 30 80 00       	push   $0x803050
  801d62:	e8 cf 09 00 00       	call   802736 <_panic>

00801d67 <open>:
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	56                   	push   %esi
  801d6b:	53                   	push   %ebx
  801d6c:	83 ec 1c             	sub    $0x1c,%esp
  801d6f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d72:	56                   	push   %esi
  801d73:	e8 5b eb ff ff       	call   8008d3 <strlen>
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d80:	7f 6c                	jg     801dee <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d82:	83 ec 0c             	sub    $0xc,%esp
  801d85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d88:	50                   	push   %eax
  801d89:	e8 79 f8 ff ff       	call   801607 <fd_alloc>
  801d8e:	89 c3                	mov    %eax,%ebx
  801d90:	83 c4 10             	add    $0x10,%esp
  801d93:	85 c0                	test   %eax,%eax
  801d95:	78 3c                	js     801dd3 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d97:	83 ec 08             	sub    $0x8,%esp
  801d9a:	56                   	push   %esi
  801d9b:	68 00 60 80 00       	push   $0x806000
  801da0:	e8 67 eb ff ff       	call   80090c <strcpy>
	fsipcbuf.open.req_omode = mode;
  801da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da8:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801dad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801db0:	b8 01 00 00 00       	mov    $0x1,%eax
  801db5:	e8 b8 fd ff ff       	call   801b72 <fsipc>
  801dba:	89 c3                	mov    %eax,%ebx
  801dbc:	83 c4 10             	add    $0x10,%esp
  801dbf:	85 c0                	test   %eax,%eax
  801dc1:	78 19                	js     801ddc <open+0x75>
	return fd2num(fd);
  801dc3:	83 ec 0c             	sub    $0xc,%esp
  801dc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc9:	e8 12 f8 ff ff       	call   8015e0 <fd2num>
  801dce:	89 c3                	mov    %eax,%ebx
  801dd0:	83 c4 10             	add    $0x10,%esp
}
  801dd3:	89 d8                	mov    %ebx,%eax
  801dd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd8:	5b                   	pop    %ebx
  801dd9:	5e                   	pop    %esi
  801dda:	5d                   	pop    %ebp
  801ddb:	c3                   	ret    
		fd_close(fd, 0);
  801ddc:	83 ec 08             	sub    $0x8,%esp
  801ddf:	6a 00                	push   $0x0
  801de1:	ff 75 f4             	pushl  -0xc(%ebp)
  801de4:	e8 1b f9 ff ff       	call   801704 <fd_close>
		return r;
  801de9:	83 c4 10             	add    $0x10,%esp
  801dec:	eb e5                	jmp    801dd3 <open+0x6c>
		return -E_BAD_PATH;
  801dee:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801df3:	eb de                	jmp    801dd3 <open+0x6c>

00801df5 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801dfb:	ba 00 00 00 00       	mov    $0x0,%edx
  801e00:	b8 08 00 00 00       	mov    $0x8,%eax
  801e05:	e8 68 fd ff ff       	call   801b72 <fsipc>
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e12:	68 67 30 80 00       	push   $0x803067
  801e17:	ff 75 0c             	pushl  0xc(%ebp)
  801e1a:	e8 ed ea ff ff       	call   80090c <strcpy>
	return 0;
}
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <devsock_close>:
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	53                   	push   %ebx
  801e2a:	83 ec 10             	sub    $0x10,%esp
  801e2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e30:	53                   	push   %ebx
  801e31:	e8 f6 09 00 00       	call   80282c <pageref>
  801e36:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e39:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e3e:	83 f8 01             	cmp    $0x1,%eax
  801e41:	74 07                	je     801e4a <devsock_close+0x24>
}
  801e43:	89 d0                	mov    %edx,%eax
  801e45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e4a:	83 ec 0c             	sub    $0xc,%esp
  801e4d:	ff 73 0c             	pushl  0xc(%ebx)
  801e50:	e8 b9 02 00 00       	call   80210e <nsipc_close>
  801e55:	89 c2                	mov    %eax,%edx
  801e57:	83 c4 10             	add    $0x10,%esp
  801e5a:	eb e7                	jmp    801e43 <devsock_close+0x1d>

00801e5c <devsock_write>:
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e62:	6a 00                	push   $0x0
  801e64:	ff 75 10             	pushl  0x10(%ebp)
  801e67:	ff 75 0c             	pushl  0xc(%ebp)
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	ff 70 0c             	pushl  0xc(%eax)
  801e70:	e8 76 03 00 00       	call   8021eb <nsipc_send>
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <devsock_read>:
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e7d:	6a 00                	push   $0x0
  801e7f:	ff 75 10             	pushl  0x10(%ebp)
  801e82:	ff 75 0c             	pushl  0xc(%ebp)
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
  801e88:	ff 70 0c             	pushl  0xc(%eax)
  801e8b:	e8 ef 02 00 00       	call   80217f <nsipc_recv>
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <fd2sockid>:
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e98:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e9b:	52                   	push   %edx
  801e9c:	50                   	push   %eax
  801e9d:	e8 b7 f7 ff ff       	call   801659 <fd_lookup>
  801ea2:	83 c4 10             	add    $0x10,%esp
  801ea5:	85 c0                	test   %eax,%eax
  801ea7:	78 10                	js     801eb9 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eac:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801eb2:	39 08                	cmp    %ecx,(%eax)
  801eb4:	75 05                	jne    801ebb <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801eb6:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    
		return -E_NOT_SUPP;
  801ebb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ec0:	eb f7                	jmp    801eb9 <fd2sockid+0x27>

00801ec2 <alloc_sockfd>:
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	56                   	push   %esi
  801ec6:	53                   	push   %ebx
  801ec7:	83 ec 1c             	sub    $0x1c,%esp
  801eca:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ecc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ecf:	50                   	push   %eax
  801ed0:	e8 32 f7 ff ff       	call   801607 <fd_alloc>
  801ed5:	89 c3                	mov    %eax,%ebx
  801ed7:	83 c4 10             	add    $0x10,%esp
  801eda:	85 c0                	test   %eax,%eax
  801edc:	78 43                	js     801f21 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ede:	83 ec 04             	sub    $0x4,%esp
  801ee1:	68 07 04 00 00       	push   $0x407
  801ee6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee9:	6a 00                	push   $0x0
  801eeb:	e8 0e ee ff ff       	call   800cfe <sys_page_alloc>
  801ef0:	89 c3                	mov    %eax,%ebx
  801ef2:	83 c4 10             	add    $0x10,%esp
  801ef5:	85 c0                	test   %eax,%eax
  801ef7:	78 28                	js     801f21 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efc:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f02:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f07:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f0e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f11:	83 ec 0c             	sub    $0xc,%esp
  801f14:	50                   	push   %eax
  801f15:	e8 c6 f6 ff ff       	call   8015e0 <fd2num>
  801f1a:	89 c3                	mov    %eax,%ebx
  801f1c:	83 c4 10             	add    $0x10,%esp
  801f1f:	eb 0c                	jmp    801f2d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f21:	83 ec 0c             	sub    $0xc,%esp
  801f24:	56                   	push   %esi
  801f25:	e8 e4 01 00 00       	call   80210e <nsipc_close>
		return r;
  801f2a:	83 c4 10             	add    $0x10,%esp
}
  801f2d:	89 d8                	mov    %ebx,%eax
  801f2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f32:	5b                   	pop    %ebx
  801f33:	5e                   	pop    %esi
  801f34:	5d                   	pop    %ebp
  801f35:	c3                   	ret    

00801f36 <accept>:
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	e8 4e ff ff ff       	call   801e92 <fd2sockid>
  801f44:	85 c0                	test   %eax,%eax
  801f46:	78 1b                	js     801f63 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f48:	83 ec 04             	sub    $0x4,%esp
  801f4b:	ff 75 10             	pushl  0x10(%ebp)
  801f4e:	ff 75 0c             	pushl  0xc(%ebp)
  801f51:	50                   	push   %eax
  801f52:	e8 0e 01 00 00       	call   802065 <nsipc_accept>
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	78 05                	js     801f63 <accept+0x2d>
	return alloc_sockfd(r);
  801f5e:	e8 5f ff ff ff       	call   801ec2 <alloc_sockfd>
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <bind>:
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	e8 1f ff ff ff       	call   801e92 <fd2sockid>
  801f73:	85 c0                	test   %eax,%eax
  801f75:	78 12                	js     801f89 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f77:	83 ec 04             	sub    $0x4,%esp
  801f7a:	ff 75 10             	pushl  0x10(%ebp)
  801f7d:	ff 75 0c             	pushl  0xc(%ebp)
  801f80:	50                   	push   %eax
  801f81:	e8 31 01 00 00       	call   8020b7 <nsipc_bind>
  801f86:	83 c4 10             	add    $0x10,%esp
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <shutdown>:
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	e8 f9 fe ff ff       	call   801e92 <fd2sockid>
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	78 0f                	js     801fac <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f9d:	83 ec 08             	sub    $0x8,%esp
  801fa0:	ff 75 0c             	pushl  0xc(%ebp)
  801fa3:	50                   	push   %eax
  801fa4:	e8 43 01 00 00       	call   8020ec <nsipc_shutdown>
  801fa9:	83 c4 10             	add    $0x10,%esp
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <connect>:
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	e8 d6 fe ff ff       	call   801e92 <fd2sockid>
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	78 12                	js     801fd2 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801fc0:	83 ec 04             	sub    $0x4,%esp
  801fc3:	ff 75 10             	pushl  0x10(%ebp)
  801fc6:	ff 75 0c             	pushl  0xc(%ebp)
  801fc9:	50                   	push   %eax
  801fca:	e8 59 01 00 00       	call   802128 <nsipc_connect>
  801fcf:	83 c4 10             	add    $0x10,%esp
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <listen>:
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	e8 b0 fe ff ff       	call   801e92 <fd2sockid>
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	78 0f                	js     801ff5 <listen+0x21>
	return nsipc_listen(r, backlog);
  801fe6:	83 ec 08             	sub    $0x8,%esp
  801fe9:	ff 75 0c             	pushl  0xc(%ebp)
  801fec:	50                   	push   %eax
  801fed:	e8 6b 01 00 00       	call   80215d <nsipc_listen>
  801ff2:	83 c4 10             	add    $0x10,%esp
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ffd:	ff 75 10             	pushl  0x10(%ebp)
  802000:	ff 75 0c             	pushl  0xc(%ebp)
  802003:	ff 75 08             	pushl  0x8(%ebp)
  802006:	e8 3e 02 00 00       	call   802249 <nsipc_socket>
  80200b:	83 c4 10             	add    $0x10,%esp
  80200e:	85 c0                	test   %eax,%eax
  802010:	78 05                	js     802017 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802012:	e8 ab fe ff ff       	call   801ec2 <alloc_sockfd>
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	53                   	push   %ebx
  80201d:	83 ec 04             	sub    $0x4,%esp
  802020:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802022:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802029:	74 26                	je     802051 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80202b:	6a 07                	push   $0x7
  80202d:	68 00 70 80 00       	push   $0x807000
  802032:	53                   	push   %ebx
  802033:	ff 35 04 50 80 00    	pushl  0x805004
  802039:	e8 0b f5 ff ff       	call   801549 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80203e:	83 c4 0c             	add    $0xc,%esp
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	e8 94 f4 ff ff       	call   8014e0 <ipc_recv>
}
  80204c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80204f:	c9                   	leave  
  802050:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802051:	83 ec 0c             	sub    $0xc,%esp
  802054:	6a 02                	push   $0x2
  802056:	e8 46 f5 ff ff       	call   8015a1 <ipc_find_env>
  80205b:	a3 04 50 80 00       	mov    %eax,0x805004
  802060:	83 c4 10             	add    $0x10,%esp
  802063:	eb c6                	jmp    80202b <nsipc+0x12>

00802065 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	56                   	push   %esi
  802069:	53                   	push   %ebx
  80206a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802075:	8b 06                	mov    (%esi),%eax
  802077:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80207c:	b8 01 00 00 00       	mov    $0x1,%eax
  802081:	e8 93 ff ff ff       	call   802019 <nsipc>
  802086:	89 c3                	mov    %eax,%ebx
  802088:	85 c0                	test   %eax,%eax
  80208a:	79 09                	jns    802095 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80208c:	89 d8                	mov    %ebx,%eax
  80208e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802091:	5b                   	pop    %ebx
  802092:	5e                   	pop    %esi
  802093:	5d                   	pop    %ebp
  802094:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802095:	83 ec 04             	sub    $0x4,%esp
  802098:	ff 35 10 70 80 00    	pushl  0x807010
  80209e:	68 00 70 80 00       	push   $0x807000
  8020a3:	ff 75 0c             	pushl  0xc(%ebp)
  8020a6:	e8 ef e9 ff ff       	call   800a9a <memmove>
		*addrlen = ret->ret_addrlen;
  8020ab:	a1 10 70 80 00       	mov    0x807010,%eax
  8020b0:	89 06                	mov    %eax,(%esi)
  8020b2:	83 c4 10             	add    $0x10,%esp
	return r;
  8020b5:	eb d5                	jmp    80208c <nsipc_accept+0x27>

008020b7 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	53                   	push   %ebx
  8020bb:	83 ec 08             	sub    $0x8,%esp
  8020be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020c9:	53                   	push   %ebx
  8020ca:	ff 75 0c             	pushl  0xc(%ebp)
  8020cd:	68 04 70 80 00       	push   $0x807004
  8020d2:	e8 c3 e9 ff ff       	call   800a9a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020d7:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8020dd:	b8 02 00 00 00       	mov    $0x2,%eax
  8020e2:	e8 32 ff ff ff       	call   802019 <nsipc>
}
  8020e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8020fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fd:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802102:	b8 03 00 00 00       	mov    $0x3,%eax
  802107:	e8 0d ff ff ff       	call   802019 <nsipc>
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <nsipc_close>:

int
nsipc_close(int s)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80211c:	b8 04 00 00 00       	mov    $0x4,%eax
  802121:	e8 f3 fe ff ff       	call   802019 <nsipc>
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	53                   	push   %ebx
  80212c:	83 ec 08             	sub    $0x8,%esp
  80212f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80213a:	53                   	push   %ebx
  80213b:	ff 75 0c             	pushl  0xc(%ebp)
  80213e:	68 04 70 80 00       	push   $0x807004
  802143:	e8 52 e9 ff ff       	call   800a9a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802148:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80214e:	b8 05 00 00 00       	mov    $0x5,%eax
  802153:	e8 c1 fe ff ff       	call   802019 <nsipc>
}
  802158:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80216b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216e:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802173:	b8 06 00 00 00       	mov    $0x6,%eax
  802178:	e8 9c fe ff ff       	call   802019 <nsipc>
}
  80217d:	c9                   	leave  
  80217e:	c3                   	ret    

0080217f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
  802182:	56                   	push   %esi
  802183:	53                   	push   %ebx
  802184:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80218f:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802195:	8b 45 14             	mov    0x14(%ebp),%eax
  802198:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80219d:	b8 07 00 00 00       	mov    $0x7,%eax
  8021a2:	e8 72 fe ff ff       	call   802019 <nsipc>
  8021a7:	89 c3                	mov    %eax,%ebx
  8021a9:	85 c0                	test   %eax,%eax
  8021ab:	78 1f                	js     8021cc <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021ad:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021b2:	7f 21                	jg     8021d5 <nsipc_recv+0x56>
  8021b4:	39 c6                	cmp    %eax,%esi
  8021b6:	7c 1d                	jl     8021d5 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021b8:	83 ec 04             	sub    $0x4,%esp
  8021bb:	50                   	push   %eax
  8021bc:	68 00 70 80 00       	push   $0x807000
  8021c1:	ff 75 0c             	pushl  0xc(%ebp)
  8021c4:	e8 d1 e8 ff ff       	call   800a9a <memmove>
  8021c9:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8021cc:	89 d8                	mov    %ebx,%eax
  8021ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021d1:	5b                   	pop    %ebx
  8021d2:	5e                   	pop    %esi
  8021d3:	5d                   	pop    %ebp
  8021d4:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021d5:	68 73 30 80 00       	push   $0x803073
  8021da:	68 3b 30 80 00       	push   $0x80303b
  8021df:	6a 62                	push   $0x62
  8021e1:	68 88 30 80 00       	push   $0x803088
  8021e6:	e8 4b 05 00 00       	call   802736 <_panic>

008021eb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	53                   	push   %ebx
  8021ef:	83 ec 04             	sub    $0x4,%esp
  8021f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021fd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802203:	7f 2e                	jg     802233 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802205:	83 ec 04             	sub    $0x4,%esp
  802208:	53                   	push   %ebx
  802209:	ff 75 0c             	pushl  0xc(%ebp)
  80220c:	68 0c 70 80 00       	push   $0x80700c
  802211:	e8 84 e8 ff ff       	call   800a9a <memmove>
	nsipcbuf.send.req_size = size;
  802216:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80221c:	8b 45 14             	mov    0x14(%ebp),%eax
  80221f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802224:	b8 08 00 00 00       	mov    $0x8,%eax
  802229:	e8 eb fd ff ff       	call   802019 <nsipc>
}
  80222e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802231:	c9                   	leave  
  802232:	c3                   	ret    
	assert(size < 1600);
  802233:	68 94 30 80 00       	push   $0x803094
  802238:	68 3b 30 80 00       	push   $0x80303b
  80223d:	6a 6d                	push   $0x6d
  80223f:	68 88 30 80 00       	push   $0x803088
  802244:	e8 ed 04 00 00       	call   802736 <_panic>

00802249 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
  80224c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80224f:	8b 45 08             	mov    0x8(%ebp),%eax
  802252:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225a:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80225f:	8b 45 10             	mov    0x10(%ebp),%eax
  802262:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802267:	b8 09 00 00 00       	mov    $0x9,%eax
  80226c:	e8 a8 fd ff ff       	call   802019 <nsipc>
}
  802271:	c9                   	leave  
  802272:	c3                   	ret    

00802273 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
  802276:	56                   	push   %esi
  802277:	53                   	push   %ebx
  802278:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80227b:	83 ec 0c             	sub    $0xc,%esp
  80227e:	ff 75 08             	pushl  0x8(%ebp)
  802281:	e8 6a f3 ff ff       	call   8015f0 <fd2data>
  802286:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802288:	83 c4 08             	add    $0x8,%esp
  80228b:	68 a0 30 80 00       	push   $0x8030a0
  802290:	53                   	push   %ebx
  802291:	e8 76 e6 ff ff       	call   80090c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802296:	8b 46 04             	mov    0x4(%esi),%eax
  802299:	2b 06                	sub    (%esi),%eax
  80229b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022a1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022a8:	00 00 00 
	stat->st_dev = &devpipe;
  8022ab:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8022b2:	40 80 00 
	return 0;
}
  8022b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022bd:	5b                   	pop    %ebx
  8022be:	5e                   	pop    %esi
  8022bf:	5d                   	pop    %ebp
  8022c0:	c3                   	ret    

008022c1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	53                   	push   %ebx
  8022c5:	83 ec 0c             	sub    $0xc,%esp
  8022c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022cb:	53                   	push   %ebx
  8022cc:	6a 00                	push   $0x0
  8022ce:	e8 b0 ea ff ff       	call   800d83 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022d3:	89 1c 24             	mov    %ebx,(%esp)
  8022d6:	e8 15 f3 ff ff       	call   8015f0 <fd2data>
  8022db:	83 c4 08             	add    $0x8,%esp
  8022de:	50                   	push   %eax
  8022df:	6a 00                	push   $0x0
  8022e1:	e8 9d ea ff ff       	call   800d83 <sys_page_unmap>
}
  8022e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e9:	c9                   	leave  
  8022ea:	c3                   	ret    

008022eb <_pipeisclosed>:
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	57                   	push   %edi
  8022ef:	56                   	push   %esi
  8022f0:	53                   	push   %ebx
  8022f1:	83 ec 1c             	sub    $0x1c,%esp
  8022f4:	89 c7                	mov    %eax,%edi
  8022f6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8022f8:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8022fd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802300:	83 ec 0c             	sub    $0xc,%esp
  802303:	57                   	push   %edi
  802304:	e8 23 05 00 00       	call   80282c <pageref>
  802309:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80230c:	89 34 24             	mov    %esi,(%esp)
  80230f:	e8 18 05 00 00       	call   80282c <pageref>
		nn = thisenv->env_runs;
  802314:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  80231a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80231d:	83 c4 10             	add    $0x10,%esp
  802320:	39 cb                	cmp    %ecx,%ebx
  802322:	74 1b                	je     80233f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802324:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802327:	75 cf                	jne    8022f8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802329:	8b 42 58             	mov    0x58(%edx),%eax
  80232c:	6a 01                	push   $0x1
  80232e:	50                   	push   %eax
  80232f:	53                   	push   %ebx
  802330:	68 a7 30 80 00       	push   $0x8030a7
  802335:	e8 73 de ff ff       	call   8001ad <cprintf>
  80233a:	83 c4 10             	add    $0x10,%esp
  80233d:	eb b9                	jmp    8022f8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80233f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802342:	0f 94 c0             	sete   %al
  802345:	0f b6 c0             	movzbl %al,%eax
}
  802348:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80234b:	5b                   	pop    %ebx
  80234c:	5e                   	pop    %esi
  80234d:	5f                   	pop    %edi
  80234e:	5d                   	pop    %ebp
  80234f:	c3                   	ret    

00802350 <devpipe_write>:
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
  802353:	57                   	push   %edi
  802354:	56                   	push   %esi
  802355:	53                   	push   %ebx
  802356:	83 ec 28             	sub    $0x28,%esp
  802359:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80235c:	56                   	push   %esi
  80235d:	e8 8e f2 ff ff       	call   8015f0 <fd2data>
  802362:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802364:	83 c4 10             	add    $0x10,%esp
  802367:	bf 00 00 00 00       	mov    $0x0,%edi
  80236c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80236f:	74 4f                	je     8023c0 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802371:	8b 43 04             	mov    0x4(%ebx),%eax
  802374:	8b 0b                	mov    (%ebx),%ecx
  802376:	8d 51 20             	lea    0x20(%ecx),%edx
  802379:	39 d0                	cmp    %edx,%eax
  80237b:	72 14                	jb     802391 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80237d:	89 da                	mov    %ebx,%edx
  80237f:	89 f0                	mov    %esi,%eax
  802381:	e8 65 ff ff ff       	call   8022eb <_pipeisclosed>
  802386:	85 c0                	test   %eax,%eax
  802388:	75 3b                	jne    8023c5 <devpipe_write+0x75>
			sys_yield();
  80238a:	e8 50 e9 ff ff       	call   800cdf <sys_yield>
  80238f:	eb e0                	jmp    802371 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802391:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802394:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802398:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80239b:	89 c2                	mov    %eax,%edx
  80239d:	c1 fa 1f             	sar    $0x1f,%edx
  8023a0:	89 d1                	mov    %edx,%ecx
  8023a2:	c1 e9 1b             	shr    $0x1b,%ecx
  8023a5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8023a8:	83 e2 1f             	and    $0x1f,%edx
  8023ab:	29 ca                	sub    %ecx,%edx
  8023ad:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8023b1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8023b5:	83 c0 01             	add    $0x1,%eax
  8023b8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8023bb:	83 c7 01             	add    $0x1,%edi
  8023be:	eb ac                	jmp    80236c <devpipe_write+0x1c>
	return i;
  8023c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c3:	eb 05                	jmp    8023ca <devpipe_write+0x7a>
				return 0;
  8023c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023cd:	5b                   	pop    %ebx
  8023ce:	5e                   	pop    %esi
  8023cf:	5f                   	pop    %edi
  8023d0:	5d                   	pop    %ebp
  8023d1:	c3                   	ret    

008023d2 <devpipe_read>:
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
  8023d5:	57                   	push   %edi
  8023d6:	56                   	push   %esi
  8023d7:	53                   	push   %ebx
  8023d8:	83 ec 18             	sub    $0x18,%esp
  8023db:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8023de:	57                   	push   %edi
  8023df:	e8 0c f2 ff ff       	call   8015f0 <fd2data>
  8023e4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023e6:	83 c4 10             	add    $0x10,%esp
  8023e9:	be 00 00 00 00       	mov    $0x0,%esi
  8023ee:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023f1:	75 14                	jne    802407 <devpipe_read+0x35>
	return i;
  8023f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8023f6:	eb 02                	jmp    8023fa <devpipe_read+0x28>
				return i;
  8023f8:	89 f0                	mov    %esi,%eax
}
  8023fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023fd:	5b                   	pop    %ebx
  8023fe:	5e                   	pop    %esi
  8023ff:	5f                   	pop    %edi
  802400:	5d                   	pop    %ebp
  802401:	c3                   	ret    
			sys_yield();
  802402:	e8 d8 e8 ff ff       	call   800cdf <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802407:	8b 03                	mov    (%ebx),%eax
  802409:	3b 43 04             	cmp    0x4(%ebx),%eax
  80240c:	75 18                	jne    802426 <devpipe_read+0x54>
			if (i > 0)
  80240e:	85 f6                	test   %esi,%esi
  802410:	75 e6                	jne    8023f8 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802412:	89 da                	mov    %ebx,%edx
  802414:	89 f8                	mov    %edi,%eax
  802416:	e8 d0 fe ff ff       	call   8022eb <_pipeisclosed>
  80241b:	85 c0                	test   %eax,%eax
  80241d:	74 e3                	je     802402 <devpipe_read+0x30>
				return 0;
  80241f:	b8 00 00 00 00       	mov    $0x0,%eax
  802424:	eb d4                	jmp    8023fa <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802426:	99                   	cltd   
  802427:	c1 ea 1b             	shr    $0x1b,%edx
  80242a:	01 d0                	add    %edx,%eax
  80242c:	83 e0 1f             	and    $0x1f,%eax
  80242f:	29 d0                	sub    %edx,%eax
  802431:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802436:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802439:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80243c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80243f:	83 c6 01             	add    $0x1,%esi
  802442:	eb aa                	jmp    8023ee <devpipe_read+0x1c>

00802444 <pipe>:
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
  802447:	56                   	push   %esi
  802448:	53                   	push   %ebx
  802449:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80244c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80244f:	50                   	push   %eax
  802450:	e8 b2 f1 ff ff       	call   801607 <fd_alloc>
  802455:	89 c3                	mov    %eax,%ebx
  802457:	83 c4 10             	add    $0x10,%esp
  80245a:	85 c0                	test   %eax,%eax
  80245c:	0f 88 23 01 00 00    	js     802585 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802462:	83 ec 04             	sub    $0x4,%esp
  802465:	68 07 04 00 00       	push   $0x407
  80246a:	ff 75 f4             	pushl  -0xc(%ebp)
  80246d:	6a 00                	push   $0x0
  80246f:	e8 8a e8 ff ff       	call   800cfe <sys_page_alloc>
  802474:	89 c3                	mov    %eax,%ebx
  802476:	83 c4 10             	add    $0x10,%esp
  802479:	85 c0                	test   %eax,%eax
  80247b:	0f 88 04 01 00 00    	js     802585 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802481:	83 ec 0c             	sub    $0xc,%esp
  802484:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802487:	50                   	push   %eax
  802488:	e8 7a f1 ff ff       	call   801607 <fd_alloc>
  80248d:	89 c3                	mov    %eax,%ebx
  80248f:	83 c4 10             	add    $0x10,%esp
  802492:	85 c0                	test   %eax,%eax
  802494:	0f 88 db 00 00 00    	js     802575 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80249a:	83 ec 04             	sub    $0x4,%esp
  80249d:	68 07 04 00 00       	push   $0x407
  8024a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8024a5:	6a 00                	push   $0x0
  8024a7:	e8 52 e8 ff ff       	call   800cfe <sys_page_alloc>
  8024ac:	89 c3                	mov    %eax,%ebx
  8024ae:	83 c4 10             	add    $0x10,%esp
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	0f 88 bc 00 00 00    	js     802575 <pipe+0x131>
	va = fd2data(fd0);
  8024b9:	83 ec 0c             	sub    $0xc,%esp
  8024bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8024bf:	e8 2c f1 ff ff       	call   8015f0 <fd2data>
  8024c4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024c6:	83 c4 0c             	add    $0xc,%esp
  8024c9:	68 07 04 00 00       	push   $0x407
  8024ce:	50                   	push   %eax
  8024cf:	6a 00                	push   $0x0
  8024d1:	e8 28 e8 ff ff       	call   800cfe <sys_page_alloc>
  8024d6:	89 c3                	mov    %eax,%ebx
  8024d8:	83 c4 10             	add    $0x10,%esp
  8024db:	85 c0                	test   %eax,%eax
  8024dd:	0f 88 82 00 00 00    	js     802565 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024e3:	83 ec 0c             	sub    $0xc,%esp
  8024e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8024e9:	e8 02 f1 ff ff       	call   8015f0 <fd2data>
  8024ee:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8024f5:	50                   	push   %eax
  8024f6:	6a 00                	push   $0x0
  8024f8:	56                   	push   %esi
  8024f9:	6a 00                	push   $0x0
  8024fb:	e8 41 e8 ff ff       	call   800d41 <sys_page_map>
  802500:	89 c3                	mov    %eax,%ebx
  802502:	83 c4 20             	add    $0x20,%esp
  802505:	85 c0                	test   %eax,%eax
  802507:	78 4e                	js     802557 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802509:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80250e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802511:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802513:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802516:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80251d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802520:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802525:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80252c:	83 ec 0c             	sub    $0xc,%esp
  80252f:	ff 75 f4             	pushl  -0xc(%ebp)
  802532:	e8 a9 f0 ff ff       	call   8015e0 <fd2num>
  802537:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80253a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80253c:	83 c4 04             	add    $0x4,%esp
  80253f:	ff 75 f0             	pushl  -0x10(%ebp)
  802542:	e8 99 f0 ff ff       	call   8015e0 <fd2num>
  802547:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80254a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80254d:	83 c4 10             	add    $0x10,%esp
  802550:	bb 00 00 00 00       	mov    $0x0,%ebx
  802555:	eb 2e                	jmp    802585 <pipe+0x141>
	sys_page_unmap(0, va);
  802557:	83 ec 08             	sub    $0x8,%esp
  80255a:	56                   	push   %esi
  80255b:	6a 00                	push   $0x0
  80255d:	e8 21 e8 ff ff       	call   800d83 <sys_page_unmap>
  802562:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802565:	83 ec 08             	sub    $0x8,%esp
  802568:	ff 75 f0             	pushl  -0x10(%ebp)
  80256b:	6a 00                	push   $0x0
  80256d:	e8 11 e8 ff ff       	call   800d83 <sys_page_unmap>
  802572:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802575:	83 ec 08             	sub    $0x8,%esp
  802578:	ff 75 f4             	pushl  -0xc(%ebp)
  80257b:	6a 00                	push   $0x0
  80257d:	e8 01 e8 ff ff       	call   800d83 <sys_page_unmap>
  802582:	83 c4 10             	add    $0x10,%esp
}
  802585:	89 d8                	mov    %ebx,%eax
  802587:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80258a:	5b                   	pop    %ebx
  80258b:	5e                   	pop    %esi
  80258c:	5d                   	pop    %ebp
  80258d:	c3                   	ret    

0080258e <pipeisclosed>:
{
  80258e:	55                   	push   %ebp
  80258f:	89 e5                	mov    %esp,%ebp
  802591:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802594:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802597:	50                   	push   %eax
  802598:	ff 75 08             	pushl  0x8(%ebp)
  80259b:	e8 b9 f0 ff ff       	call   801659 <fd_lookup>
  8025a0:	83 c4 10             	add    $0x10,%esp
  8025a3:	85 c0                	test   %eax,%eax
  8025a5:	78 18                	js     8025bf <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8025a7:	83 ec 0c             	sub    $0xc,%esp
  8025aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8025ad:	e8 3e f0 ff ff       	call   8015f0 <fd2data>
	return _pipeisclosed(fd, p);
  8025b2:	89 c2                	mov    %eax,%edx
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	e8 2f fd ff ff       	call   8022eb <_pipeisclosed>
  8025bc:	83 c4 10             	add    $0x10,%esp
}
  8025bf:	c9                   	leave  
  8025c0:	c3                   	ret    

008025c1 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8025c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c6:	c3                   	ret    

008025c7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025c7:	55                   	push   %ebp
  8025c8:	89 e5                	mov    %esp,%ebp
  8025ca:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8025cd:	68 bf 30 80 00       	push   $0x8030bf
  8025d2:	ff 75 0c             	pushl  0xc(%ebp)
  8025d5:	e8 32 e3 ff ff       	call   80090c <strcpy>
	return 0;
}
  8025da:	b8 00 00 00 00       	mov    $0x0,%eax
  8025df:	c9                   	leave  
  8025e0:	c3                   	ret    

008025e1 <devcons_write>:
{
  8025e1:	55                   	push   %ebp
  8025e2:	89 e5                	mov    %esp,%ebp
  8025e4:	57                   	push   %edi
  8025e5:	56                   	push   %esi
  8025e6:	53                   	push   %ebx
  8025e7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8025ed:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8025f2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8025f8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025fb:	73 31                	jae    80262e <devcons_write+0x4d>
		m = n - tot;
  8025fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802600:	29 f3                	sub    %esi,%ebx
  802602:	83 fb 7f             	cmp    $0x7f,%ebx
  802605:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80260a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80260d:	83 ec 04             	sub    $0x4,%esp
  802610:	53                   	push   %ebx
  802611:	89 f0                	mov    %esi,%eax
  802613:	03 45 0c             	add    0xc(%ebp),%eax
  802616:	50                   	push   %eax
  802617:	57                   	push   %edi
  802618:	e8 7d e4 ff ff       	call   800a9a <memmove>
		sys_cputs(buf, m);
  80261d:	83 c4 08             	add    $0x8,%esp
  802620:	53                   	push   %ebx
  802621:	57                   	push   %edi
  802622:	e8 1b e6 ff ff       	call   800c42 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802627:	01 de                	add    %ebx,%esi
  802629:	83 c4 10             	add    $0x10,%esp
  80262c:	eb ca                	jmp    8025f8 <devcons_write+0x17>
}
  80262e:	89 f0                	mov    %esi,%eax
  802630:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802633:	5b                   	pop    %ebx
  802634:	5e                   	pop    %esi
  802635:	5f                   	pop    %edi
  802636:	5d                   	pop    %ebp
  802637:	c3                   	ret    

00802638 <devcons_read>:
{
  802638:	55                   	push   %ebp
  802639:	89 e5                	mov    %esp,%ebp
  80263b:	83 ec 08             	sub    $0x8,%esp
  80263e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802643:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802647:	74 21                	je     80266a <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802649:	e8 12 e6 ff ff       	call   800c60 <sys_cgetc>
  80264e:	85 c0                	test   %eax,%eax
  802650:	75 07                	jne    802659 <devcons_read+0x21>
		sys_yield();
  802652:	e8 88 e6 ff ff       	call   800cdf <sys_yield>
  802657:	eb f0                	jmp    802649 <devcons_read+0x11>
	if (c < 0)
  802659:	78 0f                	js     80266a <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80265b:	83 f8 04             	cmp    $0x4,%eax
  80265e:	74 0c                	je     80266c <devcons_read+0x34>
	*(char*)vbuf = c;
  802660:	8b 55 0c             	mov    0xc(%ebp),%edx
  802663:	88 02                	mov    %al,(%edx)
	return 1;
  802665:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80266a:	c9                   	leave  
  80266b:	c3                   	ret    
		return 0;
  80266c:	b8 00 00 00 00       	mov    $0x0,%eax
  802671:	eb f7                	jmp    80266a <devcons_read+0x32>

00802673 <cputchar>:
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
  802676:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802679:	8b 45 08             	mov    0x8(%ebp),%eax
  80267c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80267f:	6a 01                	push   $0x1
  802681:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802684:	50                   	push   %eax
  802685:	e8 b8 e5 ff ff       	call   800c42 <sys_cputs>
}
  80268a:	83 c4 10             	add    $0x10,%esp
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    

0080268f <getchar>:
{
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
  802692:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802695:	6a 01                	push   $0x1
  802697:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80269a:	50                   	push   %eax
  80269b:	6a 00                	push   $0x0
  80269d:	e8 27 f2 ff ff       	call   8018c9 <read>
	if (r < 0)
  8026a2:	83 c4 10             	add    $0x10,%esp
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	78 06                	js     8026af <getchar+0x20>
	if (r < 1)
  8026a9:	74 06                	je     8026b1 <getchar+0x22>
	return c;
  8026ab:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026af:	c9                   	leave  
  8026b0:	c3                   	ret    
		return -E_EOF;
  8026b1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8026b6:	eb f7                	jmp    8026af <getchar+0x20>

008026b8 <iscons>:
{
  8026b8:	55                   	push   %ebp
  8026b9:	89 e5                	mov    %esp,%ebp
  8026bb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026c1:	50                   	push   %eax
  8026c2:	ff 75 08             	pushl  0x8(%ebp)
  8026c5:	e8 8f ef ff ff       	call   801659 <fd_lookup>
  8026ca:	83 c4 10             	add    $0x10,%esp
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	78 11                	js     8026e2 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026da:	39 10                	cmp    %edx,(%eax)
  8026dc:	0f 94 c0             	sete   %al
  8026df:	0f b6 c0             	movzbl %al,%eax
}
  8026e2:	c9                   	leave  
  8026e3:	c3                   	ret    

008026e4 <opencons>:
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
  8026e7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8026ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026ed:	50                   	push   %eax
  8026ee:	e8 14 ef ff ff       	call   801607 <fd_alloc>
  8026f3:	83 c4 10             	add    $0x10,%esp
  8026f6:	85 c0                	test   %eax,%eax
  8026f8:	78 3a                	js     802734 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026fa:	83 ec 04             	sub    $0x4,%esp
  8026fd:	68 07 04 00 00       	push   $0x407
  802702:	ff 75 f4             	pushl  -0xc(%ebp)
  802705:	6a 00                	push   $0x0
  802707:	e8 f2 e5 ff ff       	call   800cfe <sys_page_alloc>
  80270c:	83 c4 10             	add    $0x10,%esp
  80270f:	85 c0                	test   %eax,%eax
  802711:	78 21                	js     802734 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80271c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802728:	83 ec 0c             	sub    $0xc,%esp
  80272b:	50                   	push   %eax
  80272c:	e8 af ee ff ff       	call   8015e0 <fd2num>
  802731:	83 c4 10             	add    $0x10,%esp
}
  802734:	c9                   	leave  
  802735:	c3                   	ret    

00802736 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
  802739:	56                   	push   %esi
  80273a:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80273b:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802740:	8b 40 48             	mov    0x48(%eax),%eax
  802743:	83 ec 04             	sub    $0x4,%esp
  802746:	68 f0 30 80 00       	push   $0x8030f0
  80274b:	50                   	push   %eax
  80274c:	68 ca 2a 80 00       	push   $0x802aca
  802751:	e8 57 da ff ff       	call   8001ad <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802756:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802759:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80275f:	e8 5c e5 ff ff       	call   800cc0 <sys_getenvid>
  802764:	83 c4 04             	add    $0x4,%esp
  802767:	ff 75 0c             	pushl  0xc(%ebp)
  80276a:	ff 75 08             	pushl  0x8(%ebp)
  80276d:	56                   	push   %esi
  80276e:	50                   	push   %eax
  80276f:	68 cc 30 80 00       	push   $0x8030cc
  802774:	e8 34 da ff ff       	call   8001ad <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802779:	83 c4 18             	add    $0x18,%esp
  80277c:	53                   	push   %ebx
  80277d:	ff 75 10             	pushl  0x10(%ebp)
  802780:	e8 d7 d9 ff ff       	call   80015c <vcprintf>
	cprintf("\n");
  802785:	c7 04 24 e1 2e 80 00 	movl   $0x802ee1,(%esp)
  80278c:	e8 1c da ff ff       	call   8001ad <cprintf>
  802791:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802794:	cc                   	int3   
  802795:	eb fd                	jmp    802794 <_panic+0x5e>

00802797 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802797:	55                   	push   %ebp
  802798:	89 e5                	mov    %esp,%ebp
  80279a:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80279d:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8027a4:	74 0a                	je     8027b0 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8027a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a9:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8027ae:	c9                   	leave  
  8027af:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8027b0:	83 ec 04             	sub    $0x4,%esp
  8027b3:	6a 07                	push   $0x7
  8027b5:	68 00 f0 bf ee       	push   $0xeebff000
  8027ba:	6a 00                	push   $0x0
  8027bc:	e8 3d e5 ff ff       	call   800cfe <sys_page_alloc>
		if(r < 0)
  8027c1:	83 c4 10             	add    $0x10,%esp
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	78 2a                	js     8027f2 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8027c8:	83 ec 08             	sub    $0x8,%esp
  8027cb:	68 06 28 80 00       	push   $0x802806
  8027d0:	6a 00                	push   $0x0
  8027d2:	e8 72 e6 ff ff       	call   800e49 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8027d7:	83 c4 10             	add    $0x10,%esp
  8027da:	85 c0                	test   %eax,%eax
  8027dc:	79 c8                	jns    8027a6 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8027de:	83 ec 04             	sub    $0x4,%esp
  8027e1:	68 28 31 80 00       	push   $0x803128
  8027e6:	6a 25                	push   $0x25
  8027e8:	68 64 31 80 00       	push   $0x803164
  8027ed:	e8 44 ff ff ff       	call   802736 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8027f2:	83 ec 04             	sub    $0x4,%esp
  8027f5:	68 f8 30 80 00       	push   $0x8030f8
  8027fa:	6a 22                	push   $0x22
  8027fc:	68 64 31 80 00       	push   $0x803164
  802801:	e8 30 ff ff ff       	call   802736 <_panic>

00802806 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802806:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802807:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80280c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80280e:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802811:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802815:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802819:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80281c:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80281e:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802822:	83 c4 08             	add    $0x8,%esp
	popal
  802825:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802826:	83 c4 04             	add    $0x4,%esp
	popfl
  802829:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80282a:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80282b:	c3                   	ret    

0080282c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80282c:	55                   	push   %ebp
  80282d:	89 e5                	mov    %esp,%ebp
  80282f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802832:	89 d0                	mov    %edx,%eax
  802834:	c1 e8 16             	shr    $0x16,%eax
  802837:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80283e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802843:	f6 c1 01             	test   $0x1,%cl
  802846:	74 1d                	je     802865 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802848:	c1 ea 0c             	shr    $0xc,%edx
  80284b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802852:	f6 c2 01             	test   $0x1,%dl
  802855:	74 0e                	je     802865 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802857:	c1 ea 0c             	shr    $0xc,%edx
  80285a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802861:	ef 
  802862:	0f b7 c0             	movzwl %ax,%eax
}
  802865:	5d                   	pop    %ebp
  802866:	c3                   	ret    
  802867:	66 90                	xchg   %ax,%ax
  802869:	66 90                	xchg   %ax,%ax
  80286b:	66 90                	xchg   %ax,%ax
  80286d:	66 90                	xchg   %ax,%ax
  80286f:	90                   	nop

00802870 <__udivdi3>:
  802870:	55                   	push   %ebp
  802871:	57                   	push   %edi
  802872:	56                   	push   %esi
  802873:	53                   	push   %ebx
  802874:	83 ec 1c             	sub    $0x1c,%esp
  802877:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80287b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80287f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802883:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802887:	85 d2                	test   %edx,%edx
  802889:	75 4d                	jne    8028d8 <__udivdi3+0x68>
  80288b:	39 f3                	cmp    %esi,%ebx
  80288d:	76 19                	jbe    8028a8 <__udivdi3+0x38>
  80288f:	31 ff                	xor    %edi,%edi
  802891:	89 e8                	mov    %ebp,%eax
  802893:	89 f2                	mov    %esi,%edx
  802895:	f7 f3                	div    %ebx
  802897:	89 fa                	mov    %edi,%edx
  802899:	83 c4 1c             	add    $0x1c,%esp
  80289c:	5b                   	pop    %ebx
  80289d:	5e                   	pop    %esi
  80289e:	5f                   	pop    %edi
  80289f:	5d                   	pop    %ebp
  8028a0:	c3                   	ret    
  8028a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028a8:	89 d9                	mov    %ebx,%ecx
  8028aa:	85 db                	test   %ebx,%ebx
  8028ac:	75 0b                	jne    8028b9 <__udivdi3+0x49>
  8028ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8028b3:	31 d2                	xor    %edx,%edx
  8028b5:	f7 f3                	div    %ebx
  8028b7:	89 c1                	mov    %eax,%ecx
  8028b9:	31 d2                	xor    %edx,%edx
  8028bb:	89 f0                	mov    %esi,%eax
  8028bd:	f7 f1                	div    %ecx
  8028bf:	89 c6                	mov    %eax,%esi
  8028c1:	89 e8                	mov    %ebp,%eax
  8028c3:	89 f7                	mov    %esi,%edi
  8028c5:	f7 f1                	div    %ecx
  8028c7:	89 fa                	mov    %edi,%edx
  8028c9:	83 c4 1c             	add    $0x1c,%esp
  8028cc:	5b                   	pop    %ebx
  8028cd:	5e                   	pop    %esi
  8028ce:	5f                   	pop    %edi
  8028cf:	5d                   	pop    %ebp
  8028d0:	c3                   	ret    
  8028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028d8:	39 f2                	cmp    %esi,%edx
  8028da:	77 1c                	ja     8028f8 <__udivdi3+0x88>
  8028dc:	0f bd fa             	bsr    %edx,%edi
  8028df:	83 f7 1f             	xor    $0x1f,%edi
  8028e2:	75 2c                	jne    802910 <__udivdi3+0xa0>
  8028e4:	39 f2                	cmp    %esi,%edx
  8028e6:	72 06                	jb     8028ee <__udivdi3+0x7e>
  8028e8:	31 c0                	xor    %eax,%eax
  8028ea:	39 eb                	cmp    %ebp,%ebx
  8028ec:	77 a9                	ja     802897 <__udivdi3+0x27>
  8028ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8028f3:	eb a2                	jmp    802897 <__udivdi3+0x27>
  8028f5:	8d 76 00             	lea    0x0(%esi),%esi
  8028f8:	31 ff                	xor    %edi,%edi
  8028fa:	31 c0                	xor    %eax,%eax
  8028fc:	89 fa                	mov    %edi,%edx
  8028fe:	83 c4 1c             	add    $0x1c,%esp
  802901:	5b                   	pop    %ebx
  802902:	5e                   	pop    %esi
  802903:	5f                   	pop    %edi
  802904:	5d                   	pop    %ebp
  802905:	c3                   	ret    
  802906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80290d:	8d 76 00             	lea    0x0(%esi),%esi
  802910:	89 f9                	mov    %edi,%ecx
  802912:	b8 20 00 00 00       	mov    $0x20,%eax
  802917:	29 f8                	sub    %edi,%eax
  802919:	d3 e2                	shl    %cl,%edx
  80291b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80291f:	89 c1                	mov    %eax,%ecx
  802921:	89 da                	mov    %ebx,%edx
  802923:	d3 ea                	shr    %cl,%edx
  802925:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802929:	09 d1                	or     %edx,%ecx
  80292b:	89 f2                	mov    %esi,%edx
  80292d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802931:	89 f9                	mov    %edi,%ecx
  802933:	d3 e3                	shl    %cl,%ebx
  802935:	89 c1                	mov    %eax,%ecx
  802937:	d3 ea                	shr    %cl,%edx
  802939:	89 f9                	mov    %edi,%ecx
  80293b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80293f:	89 eb                	mov    %ebp,%ebx
  802941:	d3 e6                	shl    %cl,%esi
  802943:	89 c1                	mov    %eax,%ecx
  802945:	d3 eb                	shr    %cl,%ebx
  802947:	09 de                	or     %ebx,%esi
  802949:	89 f0                	mov    %esi,%eax
  80294b:	f7 74 24 08          	divl   0x8(%esp)
  80294f:	89 d6                	mov    %edx,%esi
  802951:	89 c3                	mov    %eax,%ebx
  802953:	f7 64 24 0c          	mull   0xc(%esp)
  802957:	39 d6                	cmp    %edx,%esi
  802959:	72 15                	jb     802970 <__udivdi3+0x100>
  80295b:	89 f9                	mov    %edi,%ecx
  80295d:	d3 e5                	shl    %cl,%ebp
  80295f:	39 c5                	cmp    %eax,%ebp
  802961:	73 04                	jae    802967 <__udivdi3+0xf7>
  802963:	39 d6                	cmp    %edx,%esi
  802965:	74 09                	je     802970 <__udivdi3+0x100>
  802967:	89 d8                	mov    %ebx,%eax
  802969:	31 ff                	xor    %edi,%edi
  80296b:	e9 27 ff ff ff       	jmp    802897 <__udivdi3+0x27>
  802970:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802973:	31 ff                	xor    %edi,%edi
  802975:	e9 1d ff ff ff       	jmp    802897 <__udivdi3+0x27>
  80297a:	66 90                	xchg   %ax,%ax
  80297c:	66 90                	xchg   %ax,%ax
  80297e:	66 90                	xchg   %ax,%ax

00802980 <__umoddi3>:
  802980:	55                   	push   %ebp
  802981:	57                   	push   %edi
  802982:	56                   	push   %esi
  802983:	53                   	push   %ebx
  802984:	83 ec 1c             	sub    $0x1c,%esp
  802987:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80298b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80298f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802993:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802997:	89 da                	mov    %ebx,%edx
  802999:	85 c0                	test   %eax,%eax
  80299b:	75 43                	jne    8029e0 <__umoddi3+0x60>
  80299d:	39 df                	cmp    %ebx,%edi
  80299f:	76 17                	jbe    8029b8 <__umoddi3+0x38>
  8029a1:	89 f0                	mov    %esi,%eax
  8029a3:	f7 f7                	div    %edi
  8029a5:	89 d0                	mov    %edx,%eax
  8029a7:	31 d2                	xor    %edx,%edx
  8029a9:	83 c4 1c             	add    $0x1c,%esp
  8029ac:	5b                   	pop    %ebx
  8029ad:	5e                   	pop    %esi
  8029ae:	5f                   	pop    %edi
  8029af:	5d                   	pop    %ebp
  8029b0:	c3                   	ret    
  8029b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029b8:	89 fd                	mov    %edi,%ebp
  8029ba:	85 ff                	test   %edi,%edi
  8029bc:	75 0b                	jne    8029c9 <__umoddi3+0x49>
  8029be:	b8 01 00 00 00       	mov    $0x1,%eax
  8029c3:	31 d2                	xor    %edx,%edx
  8029c5:	f7 f7                	div    %edi
  8029c7:	89 c5                	mov    %eax,%ebp
  8029c9:	89 d8                	mov    %ebx,%eax
  8029cb:	31 d2                	xor    %edx,%edx
  8029cd:	f7 f5                	div    %ebp
  8029cf:	89 f0                	mov    %esi,%eax
  8029d1:	f7 f5                	div    %ebp
  8029d3:	89 d0                	mov    %edx,%eax
  8029d5:	eb d0                	jmp    8029a7 <__umoddi3+0x27>
  8029d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029de:	66 90                	xchg   %ax,%ax
  8029e0:	89 f1                	mov    %esi,%ecx
  8029e2:	39 d8                	cmp    %ebx,%eax
  8029e4:	76 0a                	jbe    8029f0 <__umoddi3+0x70>
  8029e6:	89 f0                	mov    %esi,%eax
  8029e8:	83 c4 1c             	add    $0x1c,%esp
  8029eb:	5b                   	pop    %ebx
  8029ec:	5e                   	pop    %esi
  8029ed:	5f                   	pop    %edi
  8029ee:	5d                   	pop    %ebp
  8029ef:	c3                   	ret    
  8029f0:	0f bd e8             	bsr    %eax,%ebp
  8029f3:	83 f5 1f             	xor    $0x1f,%ebp
  8029f6:	75 20                	jne    802a18 <__umoddi3+0x98>
  8029f8:	39 d8                	cmp    %ebx,%eax
  8029fa:	0f 82 b0 00 00 00    	jb     802ab0 <__umoddi3+0x130>
  802a00:	39 f7                	cmp    %esi,%edi
  802a02:	0f 86 a8 00 00 00    	jbe    802ab0 <__umoddi3+0x130>
  802a08:	89 c8                	mov    %ecx,%eax
  802a0a:	83 c4 1c             	add    $0x1c,%esp
  802a0d:	5b                   	pop    %ebx
  802a0e:	5e                   	pop    %esi
  802a0f:	5f                   	pop    %edi
  802a10:	5d                   	pop    %ebp
  802a11:	c3                   	ret    
  802a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a18:	89 e9                	mov    %ebp,%ecx
  802a1a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a1f:	29 ea                	sub    %ebp,%edx
  802a21:	d3 e0                	shl    %cl,%eax
  802a23:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a27:	89 d1                	mov    %edx,%ecx
  802a29:	89 f8                	mov    %edi,%eax
  802a2b:	d3 e8                	shr    %cl,%eax
  802a2d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a31:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a35:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a39:	09 c1                	or     %eax,%ecx
  802a3b:	89 d8                	mov    %ebx,%eax
  802a3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a41:	89 e9                	mov    %ebp,%ecx
  802a43:	d3 e7                	shl    %cl,%edi
  802a45:	89 d1                	mov    %edx,%ecx
  802a47:	d3 e8                	shr    %cl,%eax
  802a49:	89 e9                	mov    %ebp,%ecx
  802a4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a4f:	d3 e3                	shl    %cl,%ebx
  802a51:	89 c7                	mov    %eax,%edi
  802a53:	89 d1                	mov    %edx,%ecx
  802a55:	89 f0                	mov    %esi,%eax
  802a57:	d3 e8                	shr    %cl,%eax
  802a59:	89 e9                	mov    %ebp,%ecx
  802a5b:	89 fa                	mov    %edi,%edx
  802a5d:	d3 e6                	shl    %cl,%esi
  802a5f:	09 d8                	or     %ebx,%eax
  802a61:	f7 74 24 08          	divl   0x8(%esp)
  802a65:	89 d1                	mov    %edx,%ecx
  802a67:	89 f3                	mov    %esi,%ebx
  802a69:	f7 64 24 0c          	mull   0xc(%esp)
  802a6d:	89 c6                	mov    %eax,%esi
  802a6f:	89 d7                	mov    %edx,%edi
  802a71:	39 d1                	cmp    %edx,%ecx
  802a73:	72 06                	jb     802a7b <__umoddi3+0xfb>
  802a75:	75 10                	jne    802a87 <__umoddi3+0x107>
  802a77:	39 c3                	cmp    %eax,%ebx
  802a79:	73 0c                	jae    802a87 <__umoddi3+0x107>
  802a7b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a7f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802a83:	89 d7                	mov    %edx,%edi
  802a85:	89 c6                	mov    %eax,%esi
  802a87:	89 ca                	mov    %ecx,%edx
  802a89:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a8e:	29 f3                	sub    %esi,%ebx
  802a90:	19 fa                	sbb    %edi,%edx
  802a92:	89 d0                	mov    %edx,%eax
  802a94:	d3 e0                	shl    %cl,%eax
  802a96:	89 e9                	mov    %ebp,%ecx
  802a98:	d3 eb                	shr    %cl,%ebx
  802a9a:	d3 ea                	shr    %cl,%edx
  802a9c:	09 d8                	or     %ebx,%eax
  802a9e:	83 c4 1c             	add    $0x1c,%esp
  802aa1:	5b                   	pop    %ebx
  802aa2:	5e                   	pop    %esi
  802aa3:	5f                   	pop    %edi
  802aa4:	5d                   	pop    %ebp
  802aa5:	c3                   	ret    
  802aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802aad:	8d 76 00             	lea    0x0(%esi),%esi
  802ab0:	89 da                	mov    %ebx,%edx
  802ab2:	29 fe                	sub    %edi,%esi
  802ab4:	19 c2                	sbb    %eax,%edx
  802ab6:	89 f1                	mov    %esi,%ecx
  802ab8:	89 c8                	mov    %ecx,%eax
  802aba:	e9 4b ff ff ff       	jmp    802a0a <__umoddi3+0x8a>
