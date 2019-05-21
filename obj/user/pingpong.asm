
obj/user/pingpong.debug:     file format elf32-i386


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
  80002c:	e8 8f 00 00 00       	call   8000c0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 4a 11 00 00       	call   80118b <fork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 4f                	jne    800097 <umain+0x64>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800048:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004b:	83 ec 04             	sub    $0x4,%esp
  80004e:	6a 00                	push   $0x0
  800050:	6a 00                	push   $0x0
  800052:	56                   	push   %esi
  800053:	e8 df 13 00 00       	call   801437 <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 ad 0c 00 00       	call   800d0f <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 96 18 80 00       	push   $0x801896
  80006a:	e8 8d 01 00 00       	call   8001fc <cprintf>
		if (i == 10)
  80006f:	83 c4 20             	add    $0x20,%esp
  800072:	83 fb 0a             	cmp    $0xa,%ebx
  800075:	74 18                	je     80008f <umain+0x5c>
			return;
		i++;
  800077:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  80007a:	6a 00                	push   $0x0
  80007c:	6a 00                	push   $0x0
  80007e:	53                   	push   %ebx
  80007f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800082:	e8 19 14 00 00       	call   8014a0 <ipc_send>
		if (i == 10)
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	83 fb 0a             	cmp    $0xa,%ebx
  80008d:	75 bc                	jne    80004b <umain+0x18>
			return;
	}

}
  80008f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800092:	5b                   	pop    %ebx
  800093:	5e                   	pop    %esi
  800094:	5f                   	pop    %edi
  800095:	5d                   	pop    %ebp
  800096:	c3                   	ret    
  800097:	89 c3                	mov    %eax,%ebx
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800099:	e8 71 0c 00 00       	call   800d0f <sys_getenvid>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	50                   	push   %eax
  8000a3:	68 80 18 80 00       	push   $0x801880
  8000a8:	e8 4f 01 00 00       	call   8001fc <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	e8 e5 13 00 00       	call   8014a0 <ipc_send>
  8000bb:	83 c4 20             	add    $0x20,%esp
  8000be:	eb 88                	jmp    800048 <umain+0x15>

008000c0 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
  8000c6:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000c9:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  8000d0:	00 00 00 
	envid_t find = sys_getenvid();
  8000d3:	e8 37 0c 00 00       	call   800d0f <sys_getenvid>
  8000d8:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  8000de:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000e3:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000e8:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ed:	eb 0b                	jmp    8000fa <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000ef:	83 c2 01             	add    $0x1,%edx
  8000f2:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000f8:	74 21                	je     80011b <libmain+0x5b>
		if(envs[i].env_id == find)
  8000fa:	89 d1                	mov    %edx,%ecx
  8000fc:	c1 e1 07             	shl    $0x7,%ecx
  8000ff:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800105:	8b 49 48             	mov    0x48(%ecx),%ecx
  800108:	39 c1                	cmp    %eax,%ecx
  80010a:	75 e3                	jne    8000ef <libmain+0x2f>
  80010c:	89 d3                	mov    %edx,%ebx
  80010e:	c1 e3 07             	shl    $0x7,%ebx
  800111:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800117:	89 fe                	mov    %edi,%esi
  800119:	eb d4                	jmp    8000ef <libmain+0x2f>
  80011b:	89 f0                	mov    %esi,%eax
  80011d:	84 c0                	test   %al,%al
  80011f:	74 06                	je     800127 <libmain+0x67>
  800121:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800127:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80012b:	7e 0a                	jle    800137 <libmain+0x77>
		binaryname = argv[0];
  80012d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800130:	8b 00                	mov    (%eax),%eax
  800132:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800137:	83 ec 08             	sub    $0x8,%esp
  80013a:	ff 75 0c             	pushl  0xc(%ebp)
  80013d:	ff 75 08             	pushl  0x8(%ebp)
  800140:	e8 ee fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800145:	e8 0b 00 00 00       	call   800155 <exit>
}
  80014a:	83 c4 10             	add    $0x10,%esp
  80014d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800150:	5b                   	pop    %ebx
  800151:	5e                   	pop    %esi
  800152:	5f                   	pop    %edi
  800153:	5d                   	pop    %ebp
  800154:	c3                   	ret    

00800155 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80015b:	6a 00                	push   $0x0
  80015d:	e8 6c 0b 00 00       	call   800cce <sys_env_destroy>
}
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	53                   	push   %ebx
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800171:	8b 13                	mov    (%ebx),%edx
  800173:	8d 42 01             	lea    0x1(%edx),%eax
  800176:	89 03                	mov    %eax,(%ebx)
  800178:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80017b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80017f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800184:	74 09                	je     80018f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800186:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80018a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80018f:	83 ec 08             	sub    $0x8,%esp
  800192:	68 ff 00 00 00       	push   $0xff
  800197:	8d 43 08             	lea    0x8(%ebx),%eax
  80019a:	50                   	push   %eax
  80019b:	e8 f1 0a 00 00       	call   800c91 <sys_cputs>
		b->idx = 0;
  8001a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001a6:	83 c4 10             	add    $0x10,%esp
  8001a9:	eb db                	jmp    800186 <putch+0x1f>

008001ab <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001bb:	00 00 00 
	b.cnt = 0;
  8001be:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c8:	ff 75 0c             	pushl  0xc(%ebp)
  8001cb:	ff 75 08             	pushl  0x8(%ebp)
  8001ce:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d4:	50                   	push   %eax
  8001d5:	68 67 01 80 00       	push   $0x800167
  8001da:	e8 4a 01 00 00       	call   800329 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001df:	83 c4 08             	add    $0x8,%esp
  8001e2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ee:	50                   	push   %eax
  8001ef:	e8 9d 0a 00 00       	call   800c91 <sys_cputs>

	return b.cnt;
}
  8001f4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    

008001fc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800202:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800205:	50                   	push   %eax
  800206:	ff 75 08             	pushl  0x8(%ebp)
  800209:	e8 9d ff ff ff       	call   8001ab <vcprintf>
	va_end(ap);

	return cnt;
}
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	57                   	push   %edi
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
  800216:	83 ec 1c             	sub    $0x1c,%esp
  800219:	89 c6                	mov    %eax,%esi
  80021b:	89 d7                	mov    %edx,%edi
  80021d:	8b 45 08             	mov    0x8(%ebp),%eax
  800220:	8b 55 0c             	mov    0xc(%ebp),%edx
  800223:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800226:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800229:	8b 45 10             	mov    0x10(%ebp),%eax
  80022c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80022f:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800233:	74 2c                	je     800261 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800235:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800238:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80023f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800242:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800245:	39 c2                	cmp    %eax,%edx
  800247:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80024a:	73 43                	jae    80028f <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80024c:	83 eb 01             	sub    $0x1,%ebx
  80024f:	85 db                	test   %ebx,%ebx
  800251:	7e 6c                	jle    8002bf <printnum+0xaf>
				putch(padc, putdat);
  800253:	83 ec 08             	sub    $0x8,%esp
  800256:	57                   	push   %edi
  800257:	ff 75 18             	pushl  0x18(%ebp)
  80025a:	ff d6                	call   *%esi
  80025c:	83 c4 10             	add    $0x10,%esp
  80025f:	eb eb                	jmp    80024c <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	6a 20                	push   $0x20
  800266:	6a 00                	push   $0x0
  800268:	50                   	push   %eax
  800269:	ff 75 e4             	pushl  -0x1c(%ebp)
  80026c:	ff 75 e0             	pushl  -0x20(%ebp)
  80026f:	89 fa                	mov    %edi,%edx
  800271:	89 f0                	mov    %esi,%eax
  800273:	e8 98 ff ff ff       	call   800210 <printnum>
		while (--width > 0)
  800278:	83 c4 20             	add    $0x20,%esp
  80027b:	83 eb 01             	sub    $0x1,%ebx
  80027e:	85 db                	test   %ebx,%ebx
  800280:	7e 65                	jle    8002e7 <printnum+0xd7>
			putch(padc, putdat);
  800282:	83 ec 08             	sub    $0x8,%esp
  800285:	57                   	push   %edi
  800286:	6a 20                	push   $0x20
  800288:	ff d6                	call   *%esi
  80028a:	83 c4 10             	add    $0x10,%esp
  80028d:	eb ec                	jmp    80027b <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	ff 75 18             	pushl  0x18(%ebp)
  800295:	83 eb 01             	sub    $0x1,%ebx
  800298:	53                   	push   %ebx
  800299:	50                   	push   %eax
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a9:	e8 82 13 00 00       	call   801630 <__udivdi3>
  8002ae:	83 c4 18             	add    $0x18,%esp
  8002b1:	52                   	push   %edx
  8002b2:	50                   	push   %eax
  8002b3:	89 fa                	mov    %edi,%edx
  8002b5:	89 f0                	mov    %esi,%eax
  8002b7:	e8 54 ff ff ff       	call   800210 <printnum>
  8002bc:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002bf:	83 ec 08             	sub    $0x8,%esp
  8002c2:	57                   	push   %edi
  8002c3:	83 ec 04             	sub    $0x4,%esp
  8002c6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d2:	e8 69 14 00 00       	call   801740 <__umoddi3>
  8002d7:	83 c4 14             	add    $0x14,%esp
  8002da:	0f be 80 b3 18 80 00 	movsbl 0x8018b3(%eax),%eax
  8002e1:	50                   	push   %eax
  8002e2:	ff d6                	call   *%esi
  8002e4:	83 c4 10             	add    $0x10,%esp
	}
}
  8002e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ea:	5b                   	pop    %ebx
  8002eb:	5e                   	pop    %esi
  8002ec:	5f                   	pop    %edi
  8002ed:	5d                   	pop    %ebp
  8002ee:	c3                   	ret    

008002ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f9:	8b 10                	mov    (%eax),%edx
  8002fb:	3b 50 04             	cmp    0x4(%eax),%edx
  8002fe:	73 0a                	jae    80030a <sprintputch+0x1b>
		*b->buf++ = ch;
  800300:	8d 4a 01             	lea    0x1(%edx),%ecx
  800303:	89 08                	mov    %ecx,(%eax)
  800305:	8b 45 08             	mov    0x8(%ebp),%eax
  800308:	88 02                	mov    %al,(%edx)
}
  80030a:	5d                   	pop    %ebp
  80030b:	c3                   	ret    

0080030c <printfmt>:
{
  80030c:	55                   	push   %ebp
  80030d:	89 e5                	mov    %esp,%ebp
  80030f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800312:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800315:	50                   	push   %eax
  800316:	ff 75 10             	pushl  0x10(%ebp)
  800319:	ff 75 0c             	pushl  0xc(%ebp)
  80031c:	ff 75 08             	pushl  0x8(%ebp)
  80031f:	e8 05 00 00 00       	call   800329 <vprintfmt>
}
  800324:	83 c4 10             	add    $0x10,%esp
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <vprintfmt>:
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	57                   	push   %edi
  80032d:	56                   	push   %esi
  80032e:	53                   	push   %ebx
  80032f:	83 ec 3c             	sub    $0x3c,%esp
  800332:	8b 75 08             	mov    0x8(%ebp),%esi
  800335:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800338:	8b 7d 10             	mov    0x10(%ebp),%edi
  80033b:	e9 32 04 00 00       	jmp    800772 <vprintfmt+0x449>
		padc = ' ';
  800340:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800344:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80034b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800352:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800359:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800360:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800367:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80036c:	8d 47 01             	lea    0x1(%edi),%eax
  80036f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800372:	0f b6 17             	movzbl (%edi),%edx
  800375:	8d 42 dd             	lea    -0x23(%edx),%eax
  800378:	3c 55                	cmp    $0x55,%al
  80037a:	0f 87 12 05 00 00    	ja     800892 <vprintfmt+0x569>
  800380:	0f b6 c0             	movzbl %al,%eax
  800383:	ff 24 85 a0 1a 80 00 	jmp    *0x801aa0(,%eax,4)
  80038a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80038d:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800391:	eb d9                	jmp    80036c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800393:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800396:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80039a:	eb d0                	jmp    80036c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80039c:	0f b6 d2             	movzbl %dl,%edx
  80039f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a7:	89 75 08             	mov    %esi,0x8(%ebp)
  8003aa:	eb 03                	jmp    8003af <vprintfmt+0x86>
  8003ac:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003af:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003b2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003b6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003b9:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003bc:	83 fe 09             	cmp    $0x9,%esi
  8003bf:	76 eb                	jbe    8003ac <vprintfmt+0x83>
  8003c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c7:	eb 14                	jmp    8003dd <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cc:	8b 00                	mov    (%eax),%eax
  8003ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d4:	8d 40 04             	lea    0x4(%eax),%eax
  8003d7:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e1:	79 89                	jns    80036c <vprintfmt+0x43>
				width = precision, precision = -1;
  8003e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003f0:	e9 77 ff ff ff       	jmp    80036c <vprintfmt+0x43>
  8003f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f8:	85 c0                	test   %eax,%eax
  8003fa:	0f 48 c1             	cmovs  %ecx,%eax
  8003fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800400:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800403:	e9 64 ff ff ff       	jmp    80036c <vprintfmt+0x43>
  800408:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80040b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800412:	e9 55 ff ff ff       	jmp    80036c <vprintfmt+0x43>
			lflag++;
  800417:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80041b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80041e:	e9 49 ff ff ff       	jmp    80036c <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800423:	8b 45 14             	mov    0x14(%ebp),%eax
  800426:	8d 78 04             	lea    0x4(%eax),%edi
  800429:	83 ec 08             	sub    $0x8,%esp
  80042c:	53                   	push   %ebx
  80042d:	ff 30                	pushl  (%eax)
  80042f:	ff d6                	call   *%esi
			break;
  800431:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800434:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800437:	e9 33 03 00 00       	jmp    80076f <vprintfmt+0x446>
			err = va_arg(ap, int);
  80043c:	8b 45 14             	mov    0x14(%ebp),%eax
  80043f:	8d 78 04             	lea    0x4(%eax),%edi
  800442:	8b 00                	mov    (%eax),%eax
  800444:	99                   	cltd   
  800445:	31 d0                	xor    %edx,%eax
  800447:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800449:	83 f8 0f             	cmp    $0xf,%eax
  80044c:	7f 23                	jg     800471 <vprintfmt+0x148>
  80044e:	8b 14 85 00 1c 80 00 	mov    0x801c00(,%eax,4),%edx
  800455:	85 d2                	test   %edx,%edx
  800457:	74 18                	je     800471 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800459:	52                   	push   %edx
  80045a:	68 d4 18 80 00       	push   $0x8018d4
  80045f:	53                   	push   %ebx
  800460:	56                   	push   %esi
  800461:	e8 a6 fe ff ff       	call   80030c <printfmt>
  800466:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800469:	89 7d 14             	mov    %edi,0x14(%ebp)
  80046c:	e9 fe 02 00 00       	jmp    80076f <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800471:	50                   	push   %eax
  800472:	68 cb 18 80 00       	push   $0x8018cb
  800477:	53                   	push   %ebx
  800478:	56                   	push   %esi
  800479:	e8 8e fe ff ff       	call   80030c <printfmt>
  80047e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800481:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800484:	e9 e6 02 00 00       	jmp    80076f <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800489:	8b 45 14             	mov    0x14(%ebp),%eax
  80048c:	83 c0 04             	add    $0x4,%eax
  80048f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800492:	8b 45 14             	mov    0x14(%ebp),%eax
  800495:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800497:	85 c9                	test   %ecx,%ecx
  800499:	b8 c4 18 80 00       	mov    $0x8018c4,%eax
  80049e:	0f 45 c1             	cmovne %ecx,%eax
  8004a1:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a8:	7e 06                	jle    8004b0 <vprintfmt+0x187>
  8004aa:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004ae:	75 0d                	jne    8004bd <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004b3:	89 c7                	mov    %eax,%edi
  8004b5:	03 45 e0             	add    -0x20(%ebp),%eax
  8004b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004bb:	eb 53                	jmp    800510 <vprintfmt+0x1e7>
  8004bd:	83 ec 08             	sub    $0x8,%esp
  8004c0:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c3:	50                   	push   %eax
  8004c4:	e8 71 04 00 00       	call   80093a <strnlen>
  8004c9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004cc:	29 c1                	sub    %eax,%ecx
  8004ce:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004d1:	83 c4 10             	add    $0x10,%esp
  8004d4:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004d6:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004da:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004dd:	eb 0f                	jmp    8004ee <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	53                   	push   %ebx
  8004e3:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e8:	83 ef 01             	sub    $0x1,%edi
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	85 ff                	test   %edi,%edi
  8004f0:	7f ed                	jg     8004df <vprintfmt+0x1b6>
  8004f2:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004f5:	85 c9                	test   %ecx,%ecx
  8004f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004fc:	0f 49 c1             	cmovns %ecx,%eax
  8004ff:	29 c1                	sub    %eax,%ecx
  800501:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800504:	eb aa                	jmp    8004b0 <vprintfmt+0x187>
					putch(ch, putdat);
  800506:	83 ec 08             	sub    $0x8,%esp
  800509:	53                   	push   %ebx
  80050a:	52                   	push   %edx
  80050b:	ff d6                	call   *%esi
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800513:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800515:	83 c7 01             	add    $0x1,%edi
  800518:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80051c:	0f be d0             	movsbl %al,%edx
  80051f:	85 d2                	test   %edx,%edx
  800521:	74 4b                	je     80056e <vprintfmt+0x245>
  800523:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800527:	78 06                	js     80052f <vprintfmt+0x206>
  800529:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80052d:	78 1e                	js     80054d <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80052f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800533:	74 d1                	je     800506 <vprintfmt+0x1dd>
  800535:	0f be c0             	movsbl %al,%eax
  800538:	83 e8 20             	sub    $0x20,%eax
  80053b:	83 f8 5e             	cmp    $0x5e,%eax
  80053e:	76 c6                	jbe    800506 <vprintfmt+0x1dd>
					putch('?', putdat);
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	53                   	push   %ebx
  800544:	6a 3f                	push   $0x3f
  800546:	ff d6                	call   *%esi
  800548:	83 c4 10             	add    $0x10,%esp
  80054b:	eb c3                	jmp    800510 <vprintfmt+0x1e7>
  80054d:	89 cf                	mov    %ecx,%edi
  80054f:	eb 0e                	jmp    80055f <vprintfmt+0x236>
				putch(' ', putdat);
  800551:	83 ec 08             	sub    $0x8,%esp
  800554:	53                   	push   %ebx
  800555:	6a 20                	push   $0x20
  800557:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800559:	83 ef 01             	sub    $0x1,%edi
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	85 ff                	test   %edi,%edi
  800561:	7f ee                	jg     800551 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800563:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800566:	89 45 14             	mov    %eax,0x14(%ebp)
  800569:	e9 01 02 00 00       	jmp    80076f <vprintfmt+0x446>
  80056e:	89 cf                	mov    %ecx,%edi
  800570:	eb ed                	jmp    80055f <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800572:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800575:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80057c:	e9 eb fd ff ff       	jmp    80036c <vprintfmt+0x43>
	if (lflag >= 2)
  800581:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800585:	7f 21                	jg     8005a8 <vprintfmt+0x27f>
	else if (lflag)
  800587:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80058b:	74 68                	je     8005f5 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800595:	89 c1                	mov    %eax,%ecx
  800597:	c1 f9 1f             	sar    $0x1f,%ecx
  80059a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	8d 40 04             	lea    0x4(%eax),%eax
  8005a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a6:	eb 17                	jmp    8005bf <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8b 50 04             	mov    0x4(%eax),%edx
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005b3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8d 40 08             	lea    0x8(%eax),%eax
  8005bc:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005c2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005cb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005cf:	78 3f                	js     800610 <vprintfmt+0x2e7>
			base = 10;
  8005d1:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005d6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005da:	0f 84 71 01 00 00    	je     800751 <vprintfmt+0x428>
				putch('+', putdat);
  8005e0:	83 ec 08             	sub    $0x8,%esp
  8005e3:	53                   	push   %ebx
  8005e4:	6a 2b                	push   $0x2b
  8005e6:	ff d6                	call   *%esi
  8005e8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f0:	e9 5c 01 00 00       	jmp    800751 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8b 00                	mov    (%eax),%eax
  8005fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005fd:	89 c1                	mov    %eax,%ecx
  8005ff:	c1 f9 1f             	sar    $0x1f,%ecx
  800602:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	8d 40 04             	lea    0x4(%eax),%eax
  80060b:	89 45 14             	mov    %eax,0x14(%ebp)
  80060e:	eb af                	jmp    8005bf <vprintfmt+0x296>
				putch('-', putdat);
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	53                   	push   %ebx
  800614:	6a 2d                	push   $0x2d
  800616:	ff d6                	call   *%esi
				num = -(long long) num;
  800618:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80061b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80061e:	f7 d8                	neg    %eax
  800620:	83 d2 00             	adc    $0x0,%edx
  800623:	f7 da                	neg    %edx
  800625:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800628:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800633:	e9 19 01 00 00       	jmp    800751 <vprintfmt+0x428>
	if (lflag >= 2)
  800638:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80063c:	7f 29                	jg     800667 <vprintfmt+0x33e>
	else if (lflag)
  80063e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800642:	74 44                	je     800688 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8b 00                	mov    (%eax),%eax
  800649:	ba 00 00 00 00       	mov    $0x0,%edx
  80064e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800651:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8d 40 04             	lea    0x4(%eax),%eax
  80065a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800662:	e9 ea 00 00 00       	jmp    800751 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8b 50 04             	mov    0x4(%eax),%edx
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800672:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8d 40 08             	lea    0x8(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800683:	e9 c9 00 00 00       	jmp    800751 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	ba 00 00 00 00       	mov    $0x0,%edx
  800692:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800695:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8d 40 04             	lea    0x4(%eax),%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a6:	e9 a6 00 00 00       	jmp    800751 <vprintfmt+0x428>
			putch('0', putdat);
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	53                   	push   %ebx
  8006af:	6a 30                	push   $0x30
  8006b1:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006b3:	83 c4 10             	add    $0x10,%esp
  8006b6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006ba:	7f 26                	jg     8006e2 <vprintfmt+0x3b9>
	else if (lflag)
  8006bc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006c0:	74 3e                	je     800700 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8d 40 04             	lea    0x4(%eax),%eax
  8006d8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006db:	b8 08 00 00 00       	mov    $0x8,%eax
  8006e0:	eb 6f                	jmp    800751 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8b 50 04             	mov    0x4(%eax),%edx
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8d 40 08             	lea    0x8(%eax),%eax
  8006f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f9:	b8 08 00 00 00       	mov    $0x8,%eax
  8006fe:	eb 51                	jmp    800751 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	ba 00 00 00 00       	mov    $0x0,%edx
  80070a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	8d 40 04             	lea    0x4(%eax),%eax
  800716:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800719:	b8 08 00 00 00       	mov    $0x8,%eax
  80071e:	eb 31                	jmp    800751 <vprintfmt+0x428>
			putch('0', putdat);
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	53                   	push   %ebx
  800724:	6a 30                	push   $0x30
  800726:	ff d6                	call   *%esi
			putch('x', putdat);
  800728:	83 c4 08             	add    $0x8,%esp
  80072b:	53                   	push   %ebx
  80072c:	6a 78                	push   $0x78
  80072e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	ba 00 00 00 00       	mov    $0x0,%edx
  80073a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800740:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8d 40 04             	lea    0x4(%eax),%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800751:	83 ec 0c             	sub    $0xc,%esp
  800754:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800758:	52                   	push   %edx
  800759:	ff 75 e0             	pushl  -0x20(%ebp)
  80075c:	50                   	push   %eax
  80075d:	ff 75 dc             	pushl  -0x24(%ebp)
  800760:	ff 75 d8             	pushl  -0x28(%ebp)
  800763:	89 da                	mov    %ebx,%edx
  800765:	89 f0                	mov    %esi,%eax
  800767:	e8 a4 fa ff ff       	call   800210 <printnum>
			break;
  80076c:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80076f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800772:	83 c7 01             	add    $0x1,%edi
  800775:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800779:	83 f8 25             	cmp    $0x25,%eax
  80077c:	0f 84 be fb ff ff    	je     800340 <vprintfmt+0x17>
			if (ch == '\0')
  800782:	85 c0                	test   %eax,%eax
  800784:	0f 84 28 01 00 00    	je     8008b2 <vprintfmt+0x589>
			putch(ch, putdat);
  80078a:	83 ec 08             	sub    $0x8,%esp
  80078d:	53                   	push   %ebx
  80078e:	50                   	push   %eax
  80078f:	ff d6                	call   *%esi
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	eb dc                	jmp    800772 <vprintfmt+0x449>
	if (lflag >= 2)
  800796:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80079a:	7f 26                	jg     8007c2 <vprintfmt+0x499>
	else if (lflag)
  80079c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007a0:	74 41                	je     8007e3 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8d 40 04             	lea    0x4(%eax),%eax
  8007b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007bb:	b8 10 00 00 00       	mov    $0x10,%eax
  8007c0:	eb 8f                	jmp    800751 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	8b 50 04             	mov    0x4(%eax),%edx
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	8d 40 08             	lea    0x8(%eax),%eax
  8007d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d9:	b8 10 00 00 00       	mov    $0x10,%eax
  8007de:	e9 6e ff ff ff       	jmp    800751 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
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
  800801:	e9 4b ff ff ff       	jmp    800751 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	83 c0 04             	add    $0x4,%eax
  80080c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	8b 00                	mov    (%eax),%eax
  800814:	85 c0                	test   %eax,%eax
  800816:	74 14                	je     80082c <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800818:	8b 13                	mov    (%ebx),%edx
  80081a:	83 fa 7f             	cmp    $0x7f,%edx
  80081d:	7f 37                	jg     800856 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80081f:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800821:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
  800827:	e9 43 ff ff ff       	jmp    80076f <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80082c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800831:	bf ed 19 80 00       	mov    $0x8019ed,%edi
							putch(ch, putdat);
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	53                   	push   %ebx
  80083a:	50                   	push   %eax
  80083b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80083d:	83 c7 01             	add    $0x1,%edi
  800840:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	85 c0                	test   %eax,%eax
  800849:	75 eb                	jne    800836 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80084b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80084e:	89 45 14             	mov    %eax,0x14(%ebp)
  800851:	e9 19 ff ff ff       	jmp    80076f <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800856:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800858:	b8 0a 00 00 00       	mov    $0xa,%eax
  80085d:	bf 25 1a 80 00       	mov    $0x801a25,%edi
							putch(ch, putdat);
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	53                   	push   %ebx
  800866:	50                   	push   %eax
  800867:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800869:	83 c7 01             	add    $0x1,%edi
  80086c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800870:	83 c4 10             	add    $0x10,%esp
  800873:	85 c0                	test   %eax,%eax
  800875:	75 eb                	jne    800862 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800877:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80087a:	89 45 14             	mov    %eax,0x14(%ebp)
  80087d:	e9 ed fe ff ff       	jmp    80076f <vprintfmt+0x446>
			putch(ch, putdat);
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	53                   	push   %ebx
  800886:	6a 25                	push   $0x25
  800888:	ff d6                	call   *%esi
			break;
  80088a:	83 c4 10             	add    $0x10,%esp
  80088d:	e9 dd fe ff ff       	jmp    80076f <vprintfmt+0x446>
			putch('%', putdat);
  800892:	83 ec 08             	sub    $0x8,%esp
  800895:	53                   	push   %ebx
  800896:	6a 25                	push   $0x25
  800898:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80089a:	83 c4 10             	add    $0x10,%esp
  80089d:	89 f8                	mov    %edi,%eax
  80089f:	eb 03                	jmp    8008a4 <vprintfmt+0x57b>
  8008a1:	83 e8 01             	sub    $0x1,%eax
  8008a4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008a8:	75 f7                	jne    8008a1 <vprintfmt+0x578>
  8008aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ad:	e9 bd fe ff ff       	jmp    80076f <vprintfmt+0x446>
}
  8008b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008b5:	5b                   	pop    %ebx
  8008b6:	5e                   	pop    %esi
  8008b7:	5f                   	pop    %edi
  8008b8:	5d                   	pop    %ebp
  8008b9:	c3                   	ret    

008008ba <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
  8008bd:	83 ec 18             	sub    $0x18,%esp
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008cd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008d7:	85 c0                	test   %eax,%eax
  8008d9:	74 26                	je     800901 <vsnprintf+0x47>
  8008db:	85 d2                	test   %edx,%edx
  8008dd:	7e 22                	jle    800901 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008df:	ff 75 14             	pushl  0x14(%ebp)
  8008e2:	ff 75 10             	pushl  0x10(%ebp)
  8008e5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008e8:	50                   	push   %eax
  8008e9:	68 ef 02 80 00       	push   $0x8002ef
  8008ee:	e8 36 fa ff ff       	call   800329 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008f6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
}
  8008ff:	c9                   	leave  
  800900:	c3                   	ret    
		return -E_INVAL;
  800901:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800906:	eb f7                	jmp    8008ff <vsnprintf+0x45>

00800908 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80090e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800911:	50                   	push   %eax
  800912:	ff 75 10             	pushl  0x10(%ebp)
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	ff 75 08             	pushl  0x8(%ebp)
  80091b:	e8 9a ff ff ff       	call   8008ba <vsnprintf>
	va_end(ap);

	return rc;
}
  800920:	c9                   	leave  
  800921:	c3                   	ret    

00800922 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800928:	b8 00 00 00 00       	mov    $0x0,%eax
  80092d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800931:	74 05                	je     800938 <strlen+0x16>
		n++;
  800933:	83 c0 01             	add    $0x1,%eax
  800936:	eb f5                	jmp    80092d <strlen+0xb>
	return n;
}
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800940:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800943:	ba 00 00 00 00       	mov    $0x0,%edx
  800948:	39 c2                	cmp    %eax,%edx
  80094a:	74 0d                	je     800959 <strnlen+0x1f>
  80094c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800950:	74 05                	je     800957 <strnlen+0x1d>
		n++;
  800952:	83 c2 01             	add    $0x1,%edx
  800955:	eb f1                	jmp    800948 <strnlen+0xe>
  800957:	89 d0                	mov    %edx,%eax
	return n;
}
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	53                   	push   %ebx
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800965:	ba 00 00 00 00       	mov    $0x0,%edx
  80096a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80096e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800971:	83 c2 01             	add    $0x1,%edx
  800974:	84 c9                	test   %cl,%cl
  800976:	75 f2                	jne    80096a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800978:	5b                   	pop    %ebx
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	53                   	push   %ebx
  80097f:	83 ec 10             	sub    $0x10,%esp
  800982:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800985:	53                   	push   %ebx
  800986:	e8 97 ff ff ff       	call   800922 <strlen>
  80098b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80098e:	ff 75 0c             	pushl  0xc(%ebp)
  800991:	01 d8                	add    %ebx,%eax
  800993:	50                   	push   %eax
  800994:	e8 c2 ff ff ff       	call   80095b <strcpy>
	return dst;
}
  800999:	89 d8                	mov    %ebx,%eax
  80099b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80099e:	c9                   	leave  
  80099f:	c3                   	ret    

008009a0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009a0:	55                   	push   %ebp
  8009a1:	89 e5                	mov    %esp,%ebp
  8009a3:	56                   	push   %esi
  8009a4:	53                   	push   %ebx
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ab:	89 c6                	mov    %eax,%esi
  8009ad:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b0:	89 c2                	mov    %eax,%edx
  8009b2:	39 f2                	cmp    %esi,%edx
  8009b4:	74 11                	je     8009c7 <strncpy+0x27>
		*dst++ = *src;
  8009b6:	83 c2 01             	add    $0x1,%edx
  8009b9:	0f b6 19             	movzbl (%ecx),%ebx
  8009bc:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009bf:	80 fb 01             	cmp    $0x1,%bl
  8009c2:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009c5:	eb eb                	jmp    8009b2 <strncpy+0x12>
	}
	return ret;
}
  8009c7:	5b                   	pop    %ebx
  8009c8:	5e                   	pop    %esi
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	56                   	push   %esi
  8009cf:	53                   	push   %ebx
  8009d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d6:	8b 55 10             	mov    0x10(%ebp),%edx
  8009d9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009db:	85 d2                	test   %edx,%edx
  8009dd:	74 21                	je     800a00 <strlcpy+0x35>
  8009df:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009e3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009e5:	39 c2                	cmp    %eax,%edx
  8009e7:	74 14                	je     8009fd <strlcpy+0x32>
  8009e9:	0f b6 19             	movzbl (%ecx),%ebx
  8009ec:	84 db                	test   %bl,%bl
  8009ee:	74 0b                	je     8009fb <strlcpy+0x30>
			*dst++ = *src++;
  8009f0:	83 c1 01             	add    $0x1,%ecx
  8009f3:	83 c2 01             	add    $0x1,%edx
  8009f6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009f9:	eb ea                	jmp    8009e5 <strlcpy+0x1a>
  8009fb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009fd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a00:	29 f0                	sub    %esi,%eax
}
  800a02:	5b                   	pop    %ebx
  800a03:	5e                   	pop    %esi
  800a04:	5d                   	pop    %ebp
  800a05:	c3                   	ret    

00800a06 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a0f:	0f b6 01             	movzbl (%ecx),%eax
  800a12:	84 c0                	test   %al,%al
  800a14:	74 0c                	je     800a22 <strcmp+0x1c>
  800a16:	3a 02                	cmp    (%edx),%al
  800a18:	75 08                	jne    800a22 <strcmp+0x1c>
		p++, q++;
  800a1a:	83 c1 01             	add    $0x1,%ecx
  800a1d:	83 c2 01             	add    $0x1,%edx
  800a20:	eb ed                	jmp    800a0f <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a22:	0f b6 c0             	movzbl %al,%eax
  800a25:	0f b6 12             	movzbl (%edx),%edx
  800a28:	29 d0                	sub    %edx,%eax
}
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	53                   	push   %ebx
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a36:	89 c3                	mov    %eax,%ebx
  800a38:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a3b:	eb 06                	jmp    800a43 <strncmp+0x17>
		n--, p++, q++;
  800a3d:	83 c0 01             	add    $0x1,%eax
  800a40:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a43:	39 d8                	cmp    %ebx,%eax
  800a45:	74 16                	je     800a5d <strncmp+0x31>
  800a47:	0f b6 08             	movzbl (%eax),%ecx
  800a4a:	84 c9                	test   %cl,%cl
  800a4c:	74 04                	je     800a52 <strncmp+0x26>
  800a4e:	3a 0a                	cmp    (%edx),%cl
  800a50:	74 eb                	je     800a3d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a52:	0f b6 00             	movzbl (%eax),%eax
  800a55:	0f b6 12             	movzbl (%edx),%edx
  800a58:	29 d0                	sub    %edx,%eax
}
  800a5a:	5b                   	pop    %ebx
  800a5b:	5d                   	pop    %ebp
  800a5c:	c3                   	ret    
		return 0;
  800a5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a62:	eb f6                	jmp    800a5a <strncmp+0x2e>

00800a64 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a6e:	0f b6 10             	movzbl (%eax),%edx
  800a71:	84 d2                	test   %dl,%dl
  800a73:	74 09                	je     800a7e <strchr+0x1a>
		if (*s == c)
  800a75:	38 ca                	cmp    %cl,%dl
  800a77:	74 0a                	je     800a83 <strchr+0x1f>
	for (; *s; s++)
  800a79:	83 c0 01             	add    $0x1,%eax
  800a7c:	eb f0                	jmp    800a6e <strchr+0xa>
			return (char *) s;
	return 0;
  800a7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a8f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a92:	38 ca                	cmp    %cl,%dl
  800a94:	74 09                	je     800a9f <strfind+0x1a>
  800a96:	84 d2                	test   %dl,%dl
  800a98:	74 05                	je     800a9f <strfind+0x1a>
	for (; *s; s++)
  800a9a:	83 c0 01             	add    $0x1,%eax
  800a9d:	eb f0                	jmp    800a8f <strfind+0xa>
			break;
	return (char *) s;
}
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	57                   	push   %edi
  800aa5:	56                   	push   %esi
  800aa6:	53                   	push   %ebx
  800aa7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aaa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aad:	85 c9                	test   %ecx,%ecx
  800aaf:	74 31                	je     800ae2 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ab1:	89 f8                	mov    %edi,%eax
  800ab3:	09 c8                	or     %ecx,%eax
  800ab5:	a8 03                	test   $0x3,%al
  800ab7:	75 23                	jne    800adc <memset+0x3b>
		c &= 0xFF;
  800ab9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800abd:	89 d3                	mov    %edx,%ebx
  800abf:	c1 e3 08             	shl    $0x8,%ebx
  800ac2:	89 d0                	mov    %edx,%eax
  800ac4:	c1 e0 18             	shl    $0x18,%eax
  800ac7:	89 d6                	mov    %edx,%esi
  800ac9:	c1 e6 10             	shl    $0x10,%esi
  800acc:	09 f0                	or     %esi,%eax
  800ace:	09 c2                	or     %eax,%edx
  800ad0:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ad2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ad5:	89 d0                	mov    %edx,%eax
  800ad7:	fc                   	cld    
  800ad8:	f3 ab                	rep stos %eax,%es:(%edi)
  800ada:	eb 06                	jmp    800ae2 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	fc                   	cld    
  800ae0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ae2:	89 f8                	mov    %edi,%eax
  800ae4:	5b                   	pop    %ebx
  800ae5:	5e                   	pop    %esi
  800ae6:	5f                   	pop    %edi
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	57                   	push   %edi
  800aed:	56                   	push   %esi
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af7:	39 c6                	cmp    %eax,%esi
  800af9:	73 32                	jae    800b2d <memmove+0x44>
  800afb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800afe:	39 c2                	cmp    %eax,%edx
  800b00:	76 2b                	jbe    800b2d <memmove+0x44>
		s += n;
		d += n;
  800b02:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b05:	89 fe                	mov    %edi,%esi
  800b07:	09 ce                	or     %ecx,%esi
  800b09:	09 d6                	or     %edx,%esi
  800b0b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b11:	75 0e                	jne    800b21 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b13:	83 ef 04             	sub    $0x4,%edi
  800b16:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b19:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b1c:	fd                   	std    
  800b1d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1f:	eb 09                	jmp    800b2a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b21:	83 ef 01             	sub    $0x1,%edi
  800b24:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b27:	fd                   	std    
  800b28:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b2a:	fc                   	cld    
  800b2b:	eb 1a                	jmp    800b47 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b2d:	89 c2                	mov    %eax,%edx
  800b2f:	09 ca                	or     %ecx,%edx
  800b31:	09 f2                	or     %esi,%edx
  800b33:	f6 c2 03             	test   $0x3,%dl
  800b36:	75 0a                	jne    800b42 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b38:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b3b:	89 c7                	mov    %eax,%edi
  800b3d:	fc                   	cld    
  800b3e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b40:	eb 05                	jmp    800b47 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b42:	89 c7                	mov    %eax,%edi
  800b44:	fc                   	cld    
  800b45:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b47:	5e                   	pop    %esi
  800b48:	5f                   	pop    %edi
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b51:	ff 75 10             	pushl  0x10(%ebp)
  800b54:	ff 75 0c             	pushl  0xc(%ebp)
  800b57:	ff 75 08             	pushl  0x8(%ebp)
  800b5a:	e8 8a ff ff ff       	call   800ae9 <memmove>
}
  800b5f:	c9                   	leave  
  800b60:	c3                   	ret    

00800b61 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	56                   	push   %esi
  800b65:	53                   	push   %ebx
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6c:	89 c6                	mov    %eax,%esi
  800b6e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b71:	39 f0                	cmp    %esi,%eax
  800b73:	74 1c                	je     800b91 <memcmp+0x30>
		if (*s1 != *s2)
  800b75:	0f b6 08             	movzbl (%eax),%ecx
  800b78:	0f b6 1a             	movzbl (%edx),%ebx
  800b7b:	38 d9                	cmp    %bl,%cl
  800b7d:	75 08                	jne    800b87 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b7f:	83 c0 01             	add    $0x1,%eax
  800b82:	83 c2 01             	add    $0x1,%edx
  800b85:	eb ea                	jmp    800b71 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b87:	0f b6 c1             	movzbl %cl,%eax
  800b8a:	0f b6 db             	movzbl %bl,%ebx
  800b8d:	29 d8                	sub    %ebx,%eax
  800b8f:	eb 05                	jmp    800b96 <memcmp+0x35>
	}

	return 0;
  800b91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b96:	5b                   	pop    %ebx
  800b97:	5e                   	pop    %esi
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    

00800b9a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ba3:	89 c2                	mov    %eax,%edx
  800ba5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ba8:	39 d0                	cmp    %edx,%eax
  800baa:	73 09                	jae    800bb5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bac:	38 08                	cmp    %cl,(%eax)
  800bae:	74 05                	je     800bb5 <memfind+0x1b>
	for (; s < ends; s++)
  800bb0:	83 c0 01             	add    $0x1,%eax
  800bb3:	eb f3                	jmp    800ba8 <memfind+0xe>
			break;
	return (void *) s;
}
  800bb5:	5d                   	pop    %ebp
  800bb6:	c3                   	ret    

00800bb7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	57                   	push   %edi
  800bbb:	56                   	push   %esi
  800bbc:	53                   	push   %ebx
  800bbd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bc3:	eb 03                	jmp    800bc8 <strtol+0x11>
		s++;
  800bc5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bc8:	0f b6 01             	movzbl (%ecx),%eax
  800bcb:	3c 20                	cmp    $0x20,%al
  800bcd:	74 f6                	je     800bc5 <strtol+0xe>
  800bcf:	3c 09                	cmp    $0x9,%al
  800bd1:	74 f2                	je     800bc5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bd3:	3c 2b                	cmp    $0x2b,%al
  800bd5:	74 2a                	je     800c01 <strtol+0x4a>
	int neg = 0;
  800bd7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bdc:	3c 2d                	cmp    $0x2d,%al
  800bde:	74 2b                	je     800c0b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800be6:	75 0f                	jne    800bf7 <strtol+0x40>
  800be8:	80 39 30             	cmpb   $0x30,(%ecx)
  800beb:	74 28                	je     800c15 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bed:	85 db                	test   %ebx,%ebx
  800bef:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bf4:	0f 44 d8             	cmove  %eax,%ebx
  800bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bff:	eb 50                	jmp    800c51 <strtol+0x9a>
		s++;
  800c01:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c04:	bf 00 00 00 00       	mov    $0x0,%edi
  800c09:	eb d5                	jmp    800be0 <strtol+0x29>
		s++, neg = 1;
  800c0b:	83 c1 01             	add    $0x1,%ecx
  800c0e:	bf 01 00 00 00       	mov    $0x1,%edi
  800c13:	eb cb                	jmp    800be0 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c15:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c19:	74 0e                	je     800c29 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c1b:	85 db                	test   %ebx,%ebx
  800c1d:	75 d8                	jne    800bf7 <strtol+0x40>
		s++, base = 8;
  800c1f:	83 c1 01             	add    $0x1,%ecx
  800c22:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c27:	eb ce                	jmp    800bf7 <strtol+0x40>
		s += 2, base = 16;
  800c29:	83 c1 02             	add    $0x2,%ecx
  800c2c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c31:	eb c4                	jmp    800bf7 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c33:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c36:	89 f3                	mov    %esi,%ebx
  800c38:	80 fb 19             	cmp    $0x19,%bl
  800c3b:	77 29                	ja     800c66 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c3d:	0f be d2             	movsbl %dl,%edx
  800c40:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c43:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c46:	7d 30                	jge    800c78 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c48:	83 c1 01             	add    $0x1,%ecx
  800c4b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c4f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c51:	0f b6 11             	movzbl (%ecx),%edx
  800c54:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c57:	89 f3                	mov    %esi,%ebx
  800c59:	80 fb 09             	cmp    $0x9,%bl
  800c5c:	77 d5                	ja     800c33 <strtol+0x7c>
			dig = *s - '0';
  800c5e:	0f be d2             	movsbl %dl,%edx
  800c61:	83 ea 30             	sub    $0x30,%edx
  800c64:	eb dd                	jmp    800c43 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c66:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c69:	89 f3                	mov    %esi,%ebx
  800c6b:	80 fb 19             	cmp    $0x19,%bl
  800c6e:	77 08                	ja     800c78 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c70:	0f be d2             	movsbl %dl,%edx
  800c73:	83 ea 37             	sub    $0x37,%edx
  800c76:	eb cb                	jmp    800c43 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7c:	74 05                	je     800c83 <strtol+0xcc>
		*endptr = (char *) s;
  800c7e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c81:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c83:	89 c2                	mov    %eax,%edx
  800c85:	f7 da                	neg    %edx
  800c87:	85 ff                	test   %edi,%edi
  800c89:	0f 45 c2             	cmovne %edx,%eax
}
  800c8c:	5b                   	pop    %ebx
  800c8d:	5e                   	pop    %esi
  800c8e:	5f                   	pop    %edi
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    

00800c91 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	57                   	push   %edi
  800c95:	56                   	push   %esi
  800c96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca2:	89 c3                	mov    %eax,%ebx
  800ca4:	89 c7                	mov    %eax,%edi
  800ca6:	89 c6                	mov    %eax,%esi
  800ca8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800caa:	5b                   	pop    %ebx
  800cab:	5e                   	pop    %esi
  800cac:	5f                   	pop    %edi
  800cad:	5d                   	pop    %ebp
  800cae:	c3                   	ret    

00800caf <sys_cgetc>:

int
sys_cgetc(void)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	57                   	push   %edi
  800cb3:	56                   	push   %esi
  800cb4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cba:	b8 01 00 00 00       	mov    $0x1,%eax
  800cbf:	89 d1                	mov    %edx,%ecx
  800cc1:	89 d3                	mov    %edx,%ebx
  800cc3:	89 d7                	mov    %edx,%edi
  800cc5:	89 d6                	mov    %edx,%esi
  800cc7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cc9:	5b                   	pop    %ebx
  800cca:	5e                   	pop    %esi
  800ccb:	5f                   	pop    %edi
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	57                   	push   %edi
  800cd2:	56                   	push   %esi
  800cd3:	53                   	push   %ebx
  800cd4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdf:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce4:	89 cb                	mov    %ecx,%ebx
  800ce6:	89 cf                	mov    %ecx,%edi
  800ce8:	89 ce                	mov    %ecx,%esi
  800cea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cec:	85 c0                	test   %eax,%eax
  800cee:	7f 08                	jg     800cf8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf3:	5b                   	pop    %ebx
  800cf4:	5e                   	pop    %esi
  800cf5:	5f                   	pop    %edi
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf8:	83 ec 0c             	sub    $0xc,%esp
  800cfb:	50                   	push   %eax
  800cfc:	6a 03                	push   $0x3
  800cfe:	68 40 1c 80 00       	push   $0x801c40
  800d03:	6a 43                	push   $0x43
  800d05:	68 5d 1c 80 00       	push   $0x801c5d
  800d0a:	e8 24 08 00 00       	call   801533 <_panic>

00800d0f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	57                   	push   %edi
  800d13:	56                   	push   %esi
  800d14:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d15:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1a:	b8 02 00 00 00       	mov    $0x2,%eax
  800d1f:	89 d1                	mov    %edx,%ecx
  800d21:	89 d3                	mov    %edx,%ebx
  800d23:	89 d7                	mov    %edx,%edi
  800d25:	89 d6                	mov    %edx,%esi
  800d27:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5f                   	pop    %edi
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    

00800d2e <sys_yield>:

void
sys_yield(void)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	57                   	push   %edi
  800d32:	56                   	push   %esi
  800d33:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d34:	ba 00 00 00 00       	mov    $0x0,%edx
  800d39:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d3e:	89 d1                	mov    %edx,%ecx
  800d40:	89 d3                	mov    %edx,%ebx
  800d42:	89 d7                	mov    %edx,%edi
  800d44:	89 d6                	mov    %edx,%esi
  800d46:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d48:	5b                   	pop    %ebx
  800d49:	5e                   	pop    %esi
  800d4a:	5f                   	pop    %edi
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    

00800d4d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	57                   	push   %edi
  800d51:	56                   	push   %esi
  800d52:	53                   	push   %ebx
  800d53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d56:	be 00 00 00 00       	mov    $0x0,%esi
  800d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d61:	b8 04 00 00 00       	mov    $0x4,%eax
  800d66:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d69:	89 f7                	mov    %esi,%edi
  800d6b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d6d:	85 c0                	test   %eax,%eax
  800d6f:	7f 08                	jg     800d79 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d74:	5b                   	pop    %ebx
  800d75:	5e                   	pop    %esi
  800d76:	5f                   	pop    %edi
  800d77:	5d                   	pop    %ebp
  800d78:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d79:	83 ec 0c             	sub    $0xc,%esp
  800d7c:	50                   	push   %eax
  800d7d:	6a 04                	push   $0x4
  800d7f:	68 40 1c 80 00       	push   $0x801c40
  800d84:	6a 43                	push   $0x43
  800d86:	68 5d 1c 80 00       	push   $0x801c5d
  800d8b:	e8 a3 07 00 00       	call   801533 <_panic>

00800d90 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	57                   	push   %edi
  800d94:	56                   	push   %esi
  800d95:	53                   	push   %ebx
  800d96:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9f:	b8 05 00 00 00       	mov    $0x5,%eax
  800da4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800daa:	8b 75 18             	mov    0x18(%ebp),%esi
  800dad:	cd 30                	int    $0x30
	if(check && ret > 0)
  800daf:	85 c0                	test   %eax,%eax
  800db1:	7f 08                	jg     800dbb <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800db3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db6:	5b                   	pop    %ebx
  800db7:	5e                   	pop    %esi
  800db8:	5f                   	pop    %edi
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbb:	83 ec 0c             	sub    $0xc,%esp
  800dbe:	50                   	push   %eax
  800dbf:	6a 05                	push   $0x5
  800dc1:	68 40 1c 80 00       	push   $0x801c40
  800dc6:	6a 43                	push   $0x43
  800dc8:	68 5d 1c 80 00       	push   $0x801c5d
  800dcd:	e8 61 07 00 00       	call   801533 <_panic>

00800dd2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	57                   	push   %edi
  800dd6:	56                   	push   %esi
  800dd7:	53                   	push   %ebx
  800dd8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ddb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de0:	8b 55 08             	mov    0x8(%ebp),%edx
  800de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de6:	b8 06 00 00 00       	mov    $0x6,%eax
  800deb:	89 df                	mov    %ebx,%edi
  800ded:	89 de                	mov    %ebx,%esi
  800def:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df1:	85 c0                	test   %eax,%eax
  800df3:	7f 08                	jg     800dfd <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800df5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df8:	5b                   	pop    %ebx
  800df9:	5e                   	pop    %esi
  800dfa:	5f                   	pop    %edi
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfd:	83 ec 0c             	sub    $0xc,%esp
  800e00:	50                   	push   %eax
  800e01:	6a 06                	push   $0x6
  800e03:	68 40 1c 80 00       	push   $0x801c40
  800e08:	6a 43                	push   $0x43
  800e0a:	68 5d 1c 80 00       	push   $0x801c5d
  800e0f:	e8 1f 07 00 00       	call   801533 <_panic>

00800e14 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	57                   	push   %edi
  800e18:	56                   	push   %esi
  800e19:	53                   	push   %ebx
  800e1a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e22:	8b 55 08             	mov    0x8(%ebp),%edx
  800e25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e28:	b8 08 00 00 00       	mov    $0x8,%eax
  800e2d:	89 df                	mov    %ebx,%edi
  800e2f:	89 de                	mov    %ebx,%esi
  800e31:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e33:	85 c0                	test   %eax,%eax
  800e35:	7f 08                	jg     800e3f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3a:	5b                   	pop    %ebx
  800e3b:	5e                   	pop    %esi
  800e3c:	5f                   	pop    %edi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3f:	83 ec 0c             	sub    $0xc,%esp
  800e42:	50                   	push   %eax
  800e43:	6a 08                	push   $0x8
  800e45:	68 40 1c 80 00       	push   $0x801c40
  800e4a:	6a 43                	push   $0x43
  800e4c:	68 5d 1c 80 00       	push   $0x801c5d
  800e51:	e8 dd 06 00 00       	call   801533 <_panic>

00800e56 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	57                   	push   %edi
  800e5a:	56                   	push   %esi
  800e5b:	53                   	push   %ebx
  800e5c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e64:	8b 55 08             	mov    0x8(%ebp),%edx
  800e67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e6f:	89 df                	mov    %ebx,%edi
  800e71:	89 de                	mov    %ebx,%esi
  800e73:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e75:	85 c0                	test   %eax,%eax
  800e77:	7f 08                	jg     800e81 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7c:	5b                   	pop    %ebx
  800e7d:	5e                   	pop    %esi
  800e7e:	5f                   	pop    %edi
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	50                   	push   %eax
  800e85:	6a 09                	push   $0x9
  800e87:	68 40 1c 80 00       	push   $0x801c40
  800e8c:	6a 43                	push   $0x43
  800e8e:	68 5d 1c 80 00       	push   $0x801c5d
  800e93:	e8 9b 06 00 00       	call   801533 <_panic>

00800e98 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	57                   	push   %edi
  800e9c:	56                   	push   %esi
  800e9d:	53                   	push   %ebx
  800e9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eac:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb1:	89 df                	mov    %ebx,%edi
  800eb3:	89 de                	mov    %ebx,%esi
  800eb5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	7f 08                	jg     800ec3 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ebb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec3:	83 ec 0c             	sub    $0xc,%esp
  800ec6:	50                   	push   %eax
  800ec7:	6a 0a                	push   $0xa
  800ec9:	68 40 1c 80 00       	push   $0x801c40
  800ece:	6a 43                	push   $0x43
  800ed0:	68 5d 1c 80 00       	push   $0x801c5d
  800ed5:	e8 59 06 00 00       	call   801533 <_panic>

00800eda <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eeb:	be 00 00 00 00       	mov    $0x0,%esi
  800ef0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ef6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	57                   	push   %edi
  800f01:	56                   	push   %esi
  800f02:	53                   	push   %ebx
  800f03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f06:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f13:	89 cb                	mov    %ecx,%ebx
  800f15:	89 cf                	mov    %ecx,%edi
  800f17:	89 ce                	mov    %ecx,%esi
  800f19:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f1b:	85 c0                	test   %eax,%eax
  800f1d:	7f 08                	jg     800f27 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5f                   	pop    %edi
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f27:	83 ec 0c             	sub    $0xc,%esp
  800f2a:	50                   	push   %eax
  800f2b:	6a 0d                	push   $0xd
  800f2d:	68 40 1c 80 00       	push   $0x801c40
  800f32:	6a 43                	push   $0x43
  800f34:	68 5d 1c 80 00       	push   $0x801c5d
  800f39:	e8 f5 05 00 00       	call   801533 <_panic>

00800f3e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	57                   	push   %edi
  800f42:	56                   	push   %esi
  800f43:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f44:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f49:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f54:	89 df                	mov    %ebx,%edi
  800f56:	89 de                	mov    %ebx,%esi
  800f58:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f5a:	5b                   	pop    %ebx
  800f5b:	5e                   	pop    %esi
  800f5c:	5f                   	pop    %edi
  800f5d:	5d                   	pop    %ebp
  800f5e:	c3                   	ret    

00800f5f <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	57                   	push   %edi
  800f63:	56                   	push   %esi
  800f64:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f65:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f72:	89 cb                	mov    %ecx,%ebx
  800f74:	89 cf                	mov    %ecx,%edi
  800f76:	89 ce                	mov    %ecx,%esi
  800f78:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f7a:	5b                   	pop    %ebx
  800f7b:	5e                   	pop    %esi
  800f7c:	5f                   	pop    %edi
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    

00800f7f <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	53                   	push   %ebx
  800f83:	83 ec 04             	sub    $0x4,%esp
	int r;
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  800f86:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800f8d:	83 e1 07             	and    $0x7,%ecx
  800f90:	83 f9 07             	cmp    $0x7,%ecx
  800f93:	74 32                	je     800fc7 <duppage+0x48>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  800f95:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800f9c:	81 e1 05 08 00 00    	and    $0x805,%ecx
  800fa2:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  800fa8:	74 7d                	je     801027 <duppage+0xa8>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  800faa:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  800fb1:	83 e1 05             	and    $0x5,%ecx
  800fb4:	83 f9 05             	cmp    $0x5,%ecx
  800fb7:	0f 84 9e 00 00 00    	je     80105b <duppage+0xdc>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  800fbd:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fc5:	c9                   	leave  
  800fc6:	c3                   	ret    
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  800fc7:	89 d3                	mov    %edx,%ebx
  800fc9:	c1 e3 0c             	shl    $0xc,%ebx
  800fcc:	83 ec 0c             	sub    $0xc,%esp
  800fcf:	68 05 08 00 00       	push   $0x805
  800fd4:	53                   	push   %ebx
  800fd5:	50                   	push   %eax
  800fd6:	53                   	push   %ebx
  800fd7:	6a 00                	push   $0x0
  800fd9:	e8 b2 fd ff ff       	call   800d90 <sys_page_map>
		if(r < 0)
  800fde:	83 c4 20             	add    $0x20,%esp
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	78 2e                	js     801013 <duppage+0x94>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  800fe5:	83 ec 0c             	sub    $0xc,%esp
  800fe8:	68 05 08 00 00       	push   $0x805
  800fed:	53                   	push   %ebx
  800fee:	6a 00                	push   $0x0
  800ff0:	53                   	push   %ebx
  800ff1:	6a 00                	push   $0x0
  800ff3:	e8 98 fd ff ff       	call   800d90 <sys_page_map>
		if(r < 0)
  800ff8:	83 c4 20             	add    $0x20,%esp
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	79 be                	jns    800fbd <duppage+0x3e>
			panic("sys_page_map() panic\n");
  800fff:	83 ec 04             	sub    $0x4,%esp
  801002:	68 6b 1c 80 00       	push   $0x801c6b
  801007:	6a 57                	push   $0x57
  801009:	68 81 1c 80 00       	push   $0x801c81
  80100e:	e8 20 05 00 00       	call   801533 <_panic>
			panic("sys_page_map() panic\n");
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	68 6b 1c 80 00       	push   $0x801c6b
  80101b:	6a 53                	push   $0x53
  80101d:	68 81 1c 80 00       	push   $0x801c81
  801022:	e8 0c 05 00 00       	call   801533 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801027:	c1 e2 0c             	shl    $0xc,%edx
  80102a:	83 ec 0c             	sub    $0xc,%esp
  80102d:	68 05 08 00 00       	push   $0x805
  801032:	52                   	push   %edx
  801033:	50                   	push   %eax
  801034:	52                   	push   %edx
  801035:	6a 00                	push   $0x0
  801037:	e8 54 fd ff ff       	call   800d90 <sys_page_map>
		if(r < 0)
  80103c:	83 c4 20             	add    $0x20,%esp
  80103f:	85 c0                	test   %eax,%eax
  801041:	0f 89 76 ff ff ff    	jns    800fbd <duppage+0x3e>
			panic("sys_page_map() panic\n");
  801047:	83 ec 04             	sub    $0x4,%esp
  80104a:	68 6b 1c 80 00       	push   $0x801c6b
  80104f:	6a 5e                	push   $0x5e
  801051:	68 81 1c 80 00       	push   $0x801c81
  801056:	e8 d8 04 00 00       	call   801533 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80105b:	c1 e2 0c             	shl    $0xc,%edx
  80105e:	83 ec 0c             	sub    $0xc,%esp
  801061:	6a 05                	push   $0x5
  801063:	52                   	push   %edx
  801064:	50                   	push   %eax
  801065:	52                   	push   %edx
  801066:	6a 00                	push   $0x0
  801068:	e8 23 fd ff ff       	call   800d90 <sys_page_map>
		if(r < 0)
  80106d:	83 c4 20             	add    $0x20,%esp
  801070:	85 c0                	test   %eax,%eax
  801072:	0f 89 45 ff ff ff    	jns    800fbd <duppage+0x3e>
			panic("sys_page_map() panic\n");
  801078:	83 ec 04             	sub    $0x4,%esp
  80107b:	68 6b 1c 80 00       	push   $0x801c6b
  801080:	6a 65                	push   $0x65
  801082:	68 81 1c 80 00       	push   $0x801c81
  801087:	e8 a7 04 00 00       	call   801533 <_panic>

0080108c <pgfault>:
{
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	53                   	push   %ebx
  801090:	83 ec 04             	sub    $0x4,%esp
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801096:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801098:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80109c:	0f 84 99 00 00 00    	je     80113b <pgfault+0xaf>
  8010a2:	89 c2                	mov    %eax,%edx
  8010a4:	c1 ea 16             	shr    $0x16,%edx
  8010a7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ae:	f6 c2 01             	test   $0x1,%dl
  8010b1:	0f 84 84 00 00 00    	je     80113b <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8010b7:	89 c2                	mov    %eax,%edx
  8010b9:	c1 ea 0c             	shr    $0xc,%edx
  8010bc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010c3:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8010c9:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8010cf:	75 6a                	jne    80113b <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8010d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010d6:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	6a 07                	push   $0x7
  8010dd:	68 00 f0 7f 00       	push   $0x7ff000
  8010e2:	6a 00                	push   $0x0
  8010e4:	e8 64 fc ff ff       	call   800d4d <sys_page_alloc>
	if(ret < 0)
  8010e9:	83 c4 10             	add    $0x10,%esp
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	78 5f                	js     80114f <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8010f0:	83 ec 04             	sub    $0x4,%esp
  8010f3:	68 00 10 00 00       	push   $0x1000
  8010f8:	53                   	push   %ebx
  8010f9:	68 00 f0 7f 00       	push   $0x7ff000
  8010fe:	e8 48 fa ff ff       	call   800b4b <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801103:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80110a:	53                   	push   %ebx
  80110b:	6a 00                	push   $0x0
  80110d:	68 00 f0 7f 00       	push   $0x7ff000
  801112:	6a 00                	push   $0x0
  801114:	e8 77 fc ff ff       	call   800d90 <sys_page_map>
	if(ret < 0)
  801119:	83 c4 20             	add    $0x20,%esp
  80111c:	85 c0                	test   %eax,%eax
  80111e:	78 43                	js     801163 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801120:	83 ec 08             	sub    $0x8,%esp
  801123:	68 00 f0 7f 00       	push   $0x7ff000
  801128:	6a 00                	push   $0x0
  80112a:	e8 a3 fc ff ff       	call   800dd2 <sys_page_unmap>
	if(ret < 0)
  80112f:	83 c4 10             	add    $0x10,%esp
  801132:	85 c0                	test   %eax,%eax
  801134:	78 41                	js     801177 <pgfault+0xeb>
}
  801136:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801139:	c9                   	leave  
  80113a:	c3                   	ret    
		panic("panic at pgfault()\n");
  80113b:	83 ec 04             	sub    $0x4,%esp
  80113e:	68 8c 1c 80 00       	push   $0x801c8c
  801143:	6a 26                	push   $0x26
  801145:	68 81 1c 80 00       	push   $0x801c81
  80114a:	e8 e4 03 00 00       	call   801533 <_panic>
		panic("panic in sys_page_alloc()\n");
  80114f:	83 ec 04             	sub    $0x4,%esp
  801152:	68 a0 1c 80 00       	push   $0x801ca0
  801157:	6a 31                	push   $0x31
  801159:	68 81 1c 80 00       	push   $0x801c81
  80115e:	e8 d0 03 00 00       	call   801533 <_panic>
		panic("panic in sys_page_map()\n");
  801163:	83 ec 04             	sub    $0x4,%esp
  801166:	68 bb 1c 80 00       	push   $0x801cbb
  80116b:	6a 36                	push   $0x36
  80116d:	68 81 1c 80 00       	push   $0x801c81
  801172:	e8 bc 03 00 00       	call   801533 <_panic>
		panic("panic in sys_page_unmap()\n");
  801177:	83 ec 04             	sub    $0x4,%esp
  80117a:	68 d4 1c 80 00       	push   $0x801cd4
  80117f:	6a 39                	push   $0x39
  801181:	68 81 1c 80 00       	push   $0x801c81
  801186:	e8 a8 03 00 00       	call   801533 <_panic>

0080118b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	57                   	push   %edi
  80118f:	56                   	push   %esi
  801190:	53                   	push   %ebx
  801191:	83 ec 18             	sub    $0x18,%esp
	// cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
	int ret;
	set_pgfault_handler(pgfault);
  801194:	68 8c 10 80 00       	push   $0x80108c
  801199:	e8 f6 03 00 00       	call   801594 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80119e:	b8 07 00 00 00       	mov    $0x7,%eax
  8011a3:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8011a5:	83 c4 10             	add    $0x10,%esp
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	78 27                	js     8011d3 <fork+0x48>
  8011ac:	89 c6                	mov    %eax,%esi
  8011ae:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8011b0:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8011b5:	75 48                	jne    8011ff <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011b7:	e8 53 fb ff ff       	call   800d0f <sys_getenvid>
  8011bc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011c1:	c1 e0 07             	shl    $0x7,%eax
  8011c4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011c9:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  8011ce:	e9 90 00 00 00       	jmp    801263 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8011d3:	83 ec 04             	sub    $0x4,%esp
  8011d6:	68 fc 1c 80 00       	push   $0x801cfc
  8011db:	68 85 00 00 00       	push   $0x85
  8011e0:	68 81 1c 80 00       	push   $0x801c81
  8011e5:	e8 49 03 00 00       	call   801533 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8011ea:	89 f8                	mov    %edi,%eax
  8011ec:	e8 8e fd ff ff       	call   800f7f <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8011f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011f7:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8011fd:	74 26                	je     801225 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8011ff:	89 d8                	mov    %ebx,%eax
  801201:	c1 e8 16             	shr    $0x16,%eax
  801204:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80120b:	a8 01                	test   $0x1,%al
  80120d:	74 e2                	je     8011f1 <fork+0x66>
  80120f:	89 da                	mov    %ebx,%edx
  801211:	c1 ea 0c             	shr    $0xc,%edx
  801214:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80121b:	83 e0 05             	and    $0x5,%eax
  80121e:	83 f8 05             	cmp    $0x5,%eax
  801221:	75 ce                	jne    8011f1 <fork+0x66>
  801223:	eb c5                	jmp    8011ea <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801225:	83 ec 04             	sub    $0x4,%esp
  801228:	6a 07                	push   $0x7
  80122a:	68 00 f0 bf ee       	push   $0xeebff000
  80122f:	56                   	push   %esi
  801230:	e8 18 fb ff ff       	call   800d4d <sys_page_alloc>
	if(ret < 0)
  801235:	83 c4 10             	add    $0x10,%esp
  801238:	85 c0                	test   %eax,%eax
  80123a:	78 31                	js     80126d <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80123c:	83 ec 08             	sub    $0x8,%esp
  80123f:	68 03 16 80 00       	push   $0x801603
  801244:	56                   	push   %esi
  801245:	e8 4e fc ff ff       	call   800e98 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80124a:	83 c4 10             	add    $0x10,%esp
  80124d:	85 c0                	test   %eax,%eax
  80124f:	78 33                	js     801284 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801251:	83 ec 08             	sub    $0x8,%esp
  801254:	6a 02                	push   $0x2
  801256:	56                   	push   %esi
  801257:	e8 b8 fb ff ff       	call   800e14 <sys_env_set_status>
	if(ret < 0)
  80125c:	83 c4 10             	add    $0x10,%esp
  80125f:	85 c0                	test   %eax,%eax
  801261:	78 38                	js     80129b <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801263:	89 f0                	mov    %esi,%eax
  801265:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801268:	5b                   	pop    %ebx
  801269:	5e                   	pop    %esi
  80126a:	5f                   	pop    %edi
  80126b:	5d                   	pop    %ebp
  80126c:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80126d:	83 ec 04             	sub    $0x4,%esp
  801270:	68 a0 1c 80 00       	push   $0x801ca0
  801275:	68 91 00 00 00       	push   $0x91
  80127a:	68 81 1c 80 00       	push   $0x801c81
  80127f:	e8 af 02 00 00       	call   801533 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801284:	83 ec 04             	sub    $0x4,%esp
  801287:	68 20 1d 80 00       	push   $0x801d20
  80128c:	68 94 00 00 00       	push   $0x94
  801291:	68 81 1c 80 00       	push   $0x801c81
  801296:	e8 98 02 00 00       	call   801533 <_panic>
		panic("panic in sys_env_set_status()\n");
  80129b:	83 ec 04             	sub    $0x4,%esp
  80129e:	68 48 1d 80 00       	push   $0x801d48
  8012a3:	68 97 00 00 00       	push   $0x97
  8012a8:	68 81 1c 80 00       	push   $0x801c81
  8012ad:	e8 81 02 00 00       	call   801533 <_panic>

008012b2 <sfork>:

// Challenge!
int
sfork(void)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	57                   	push   %edi
  8012b6:	56                   	push   %esi
  8012b7:	53                   	push   %ebx
  8012b8:	83 ec 10             	sub    $0x10,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8012bb:	a1 04 20 80 00       	mov    0x802004,%eax
  8012c0:	8b 40 48             	mov    0x48(%eax),%eax
  8012c3:	68 68 1d 80 00       	push   $0x801d68
  8012c8:	50                   	push   %eax
  8012c9:	68 ef 1c 80 00       	push   $0x801cef
  8012ce:	e8 29 ef ff ff       	call   8001fc <cprintf>
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8012d3:	c7 04 24 8c 10 80 00 	movl   $0x80108c,(%esp)
  8012da:	e8 b5 02 00 00       	call   801594 <set_pgfault_handler>
  8012df:	b8 07 00 00 00       	mov    $0x7,%eax
  8012e4:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8012e6:	83 c4 10             	add    $0x10,%esp
  8012e9:	85 c0                	test   %eax,%eax
  8012eb:	78 27                	js     801314 <sfork+0x62>
  8012ed:	89 c7                	mov    %eax,%edi
  8012ef:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012f1:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8012f6:	75 55                	jne    80134d <sfork+0x9b>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012f8:	e8 12 fa ff ff       	call   800d0f <sys_getenvid>
  8012fd:	25 ff 03 00 00       	and    $0x3ff,%eax
  801302:	c1 e0 07             	shl    $0x7,%eax
  801305:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80130a:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  80130f:	e9 d4 00 00 00       	jmp    8013e8 <sfork+0x136>
		panic("the fork panic! at sys_exofork()\n");
  801314:	83 ec 04             	sub    $0x4,%esp
  801317:	68 fc 1c 80 00       	push   $0x801cfc
  80131c:	68 a9 00 00 00       	push   $0xa9
  801321:	68 81 1c 80 00       	push   $0x801c81
  801326:	e8 08 02 00 00       	call   801533 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80132b:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801330:	89 f0                	mov    %esi,%eax
  801332:	e8 48 fc ff ff       	call   800f7f <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801337:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80133d:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801343:	77 65                	ja     8013aa <sfork+0xf8>
		if(i == (USTACKTOP - PGSIZE))
  801345:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80134b:	74 de                	je     80132b <sfork+0x79>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80134d:	89 d8                	mov    %ebx,%eax
  80134f:	c1 e8 16             	shr    $0x16,%eax
  801352:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801359:	a8 01                	test   $0x1,%al
  80135b:	74 da                	je     801337 <sfork+0x85>
  80135d:	89 da                	mov    %ebx,%edx
  80135f:	c1 ea 0c             	shr    $0xc,%edx
  801362:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801369:	83 e0 05             	and    $0x5,%eax
  80136c:	83 f8 05             	cmp    $0x5,%eax
  80136f:	75 c6                	jne    801337 <sfork+0x85>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801371:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801378:	c1 e2 0c             	shl    $0xc,%edx
  80137b:	83 ec 0c             	sub    $0xc,%esp
  80137e:	83 e0 07             	and    $0x7,%eax
  801381:	50                   	push   %eax
  801382:	52                   	push   %edx
  801383:	56                   	push   %esi
  801384:	52                   	push   %edx
  801385:	6a 00                	push   $0x0
  801387:	e8 04 fa ff ff       	call   800d90 <sys_page_map>
  80138c:	83 c4 20             	add    $0x20,%esp
  80138f:	85 c0                	test   %eax,%eax
  801391:	74 a4                	je     801337 <sfork+0x85>
				panic("sys_page_map() panic\n");
  801393:	83 ec 04             	sub    $0x4,%esp
  801396:	68 6b 1c 80 00       	push   $0x801c6b
  80139b:	68 b4 00 00 00       	push   $0xb4
  8013a0:	68 81 1c 80 00       	push   $0x801c81
  8013a5:	e8 89 01 00 00       	call   801533 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8013aa:	83 ec 04             	sub    $0x4,%esp
  8013ad:	6a 07                	push   $0x7
  8013af:	68 00 f0 bf ee       	push   $0xeebff000
  8013b4:	57                   	push   %edi
  8013b5:	e8 93 f9 ff ff       	call   800d4d <sys_page_alloc>
	if(ret < 0)
  8013ba:	83 c4 10             	add    $0x10,%esp
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	78 31                	js     8013f2 <sfork+0x140>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013c1:	83 ec 08             	sub    $0x8,%esp
  8013c4:	68 03 16 80 00       	push   $0x801603
  8013c9:	57                   	push   %edi
  8013ca:	e8 c9 fa ff ff       	call   800e98 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013cf:	83 c4 10             	add    $0x10,%esp
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	78 33                	js     801409 <sfork+0x157>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013d6:	83 ec 08             	sub    $0x8,%esp
  8013d9:	6a 02                	push   $0x2
  8013db:	57                   	push   %edi
  8013dc:	e8 33 fa ff ff       	call   800e14 <sys_env_set_status>
	if(ret < 0)
  8013e1:	83 c4 10             	add    $0x10,%esp
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	78 38                	js     801420 <sfork+0x16e>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8013e8:	89 f8                	mov    %edi,%eax
  8013ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ed:	5b                   	pop    %ebx
  8013ee:	5e                   	pop    %esi
  8013ef:	5f                   	pop    %edi
  8013f0:	5d                   	pop    %ebp
  8013f1:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013f2:	83 ec 04             	sub    $0x4,%esp
  8013f5:	68 a0 1c 80 00       	push   $0x801ca0
  8013fa:	68 ba 00 00 00       	push   $0xba
  8013ff:	68 81 1c 80 00       	push   $0x801c81
  801404:	e8 2a 01 00 00       	call   801533 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801409:	83 ec 04             	sub    $0x4,%esp
  80140c:	68 20 1d 80 00       	push   $0x801d20
  801411:	68 bd 00 00 00       	push   $0xbd
  801416:	68 81 1c 80 00       	push   $0x801c81
  80141b:	e8 13 01 00 00       	call   801533 <_panic>
		panic("panic in sys_env_set_status()\n");
  801420:	83 ec 04             	sub    $0x4,%esp
  801423:	68 48 1d 80 00       	push   $0x801d48
  801428:	68 c0 00 00 00       	push   $0xc0
  80142d:	68 81 1c 80 00       	push   $0x801c81
  801432:	e8 fc 00 00 00       	call   801533 <_panic>

00801437 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	56                   	push   %esi
  80143b:	53                   	push   %ebx
  80143c:	8b 75 08             	mov    0x8(%ebp),%esi
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  801445:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801447:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80144c:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80144f:	83 ec 0c             	sub    $0xc,%esp
  801452:	50                   	push   %eax
  801453:	e8 a5 fa ff ff       	call   800efd <sys_ipc_recv>
	if(ret < 0){
  801458:	83 c4 10             	add    $0x10,%esp
  80145b:	85 c0                	test   %eax,%eax
  80145d:	78 2b                	js     80148a <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80145f:	85 f6                	test   %esi,%esi
  801461:	74 0a                	je     80146d <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  801463:	a1 04 20 80 00       	mov    0x802004,%eax
  801468:	8b 40 74             	mov    0x74(%eax),%eax
  80146b:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80146d:	85 db                	test   %ebx,%ebx
  80146f:	74 0a                	je     80147b <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801471:	a1 04 20 80 00       	mov    0x802004,%eax
  801476:	8b 40 78             	mov    0x78(%eax),%eax
  801479:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80147b:	a1 04 20 80 00       	mov    0x802004,%eax
  801480:	8b 40 70             	mov    0x70(%eax),%eax
}
  801483:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801486:	5b                   	pop    %ebx
  801487:	5e                   	pop    %esi
  801488:	5d                   	pop    %ebp
  801489:	c3                   	ret    
		if(from_env_store)
  80148a:	85 f6                	test   %esi,%esi
  80148c:	74 06                	je     801494 <ipc_recv+0x5d>
			*from_env_store = 0;
  80148e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801494:	85 db                	test   %ebx,%ebx
  801496:	74 eb                	je     801483 <ipc_recv+0x4c>
			*perm_store = 0;
  801498:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80149e:	eb e3                	jmp    801483 <ipc_recv+0x4c>

008014a0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	57                   	push   %edi
  8014a4:	56                   	push   %esi
  8014a5:	53                   	push   %ebx
  8014a6:	83 ec 0c             	sub    $0xc,%esp
  8014a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014af:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8014b2:	85 db                	test   %ebx,%ebx
  8014b4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8014b9:	0f 44 d8             	cmove  %eax,%ebx
  8014bc:	eb 05                	jmp    8014c3 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8014be:	e8 6b f8 ff ff       	call   800d2e <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8014c3:	ff 75 14             	pushl  0x14(%ebp)
  8014c6:	53                   	push   %ebx
  8014c7:	56                   	push   %esi
  8014c8:	57                   	push   %edi
  8014c9:	e8 0c fa ff ff       	call   800eda <sys_ipc_try_send>
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	74 1b                	je     8014f0 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8014d5:	79 e7                	jns    8014be <ipc_send+0x1e>
  8014d7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8014da:	74 e2                	je     8014be <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8014dc:	83 ec 04             	sub    $0x4,%esp
  8014df:	68 6e 1d 80 00       	push   $0x801d6e
  8014e4:	6a 49                	push   $0x49
  8014e6:	68 83 1d 80 00       	push   $0x801d83
  8014eb:	e8 43 00 00 00       	call   801533 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8014f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014f3:	5b                   	pop    %ebx
  8014f4:	5e                   	pop    %esi
  8014f5:	5f                   	pop    %edi
  8014f6:	5d                   	pop    %ebp
  8014f7:	c3                   	ret    

008014f8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8014fe:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801503:	89 c2                	mov    %eax,%edx
  801505:	c1 e2 07             	shl    $0x7,%edx
  801508:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80150e:	8b 52 50             	mov    0x50(%edx),%edx
  801511:	39 ca                	cmp    %ecx,%edx
  801513:	74 11                	je     801526 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801515:	83 c0 01             	add    $0x1,%eax
  801518:	3d 00 04 00 00       	cmp    $0x400,%eax
  80151d:	75 e4                	jne    801503 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80151f:	b8 00 00 00 00       	mov    $0x0,%eax
  801524:	eb 0b                	jmp    801531 <ipc_find_env+0x39>
			return envs[i].env_id;
  801526:	c1 e0 07             	shl    $0x7,%eax
  801529:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80152e:	8b 40 48             	mov    0x48(%eax),%eax
}
  801531:	5d                   	pop    %ebp
  801532:	c3                   	ret    

00801533 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	56                   	push   %esi
  801537:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801538:	a1 04 20 80 00       	mov    0x802004,%eax
  80153d:	8b 40 48             	mov    0x48(%eax),%eax
  801540:	83 ec 04             	sub    $0x4,%esp
  801543:	68 b4 1d 80 00       	push   $0x801db4
  801548:	50                   	push   %eax
  801549:	68 ef 1c 80 00       	push   $0x801cef
  80154e:	e8 a9 ec ff ff       	call   8001fc <cprintf>
	va_list ap;

	va_start(ap, fmt);
  801553:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801556:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80155c:	e8 ae f7 ff ff       	call   800d0f <sys_getenvid>
  801561:	83 c4 04             	add    $0x4,%esp
  801564:	ff 75 0c             	pushl  0xc(%ebp)
  801567:	ff 75 08             	pushl  0x8(%ebp)
  80156a:	56                   	push   %esi
  80156b:	50                   	push   %eax
  80156c:	68 90 1d 80 00       	push   $0x801d90
  801571:	e8 86 ec ff ff       	call   8001fc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801576:	83 c4 18             	add    $0x18,%esp
  801579:	53                   	push   %ebx
  80157a:	ff 75 10             	pushl  0x10(%ebp)
  80157d:	e8 29 ec ff ff       	call   8001ab <vcprintf>
	cprintf("\n");
  801582:	c7 04 24 b9 1c 80 00 	movl   $0x801cb9,(%esp)
  801589:	e8 6e ec ff ff       	call   8001fc <cprintf>
  80158e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801591:	cc                   	int3   
  801592:	eb fd                	jmp    801591 <_panic+0x5e>

00801594 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80159a:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  8015a1:	74 0a                	je     8015ad <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	a3 08 20 80 00       	mov    %eax,0x802008
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8015ad:	83 ec 04             	sub    $0x4,%esp
  8015b0:	6a 07                	push   $0x7
  8015b2:	68 00 f0 bf ee       	push   $0xeebff000
  8015b7:	6a 00                	push   $0x0
  8015b9:	e8 8f f7 ff ff       	call   800d4d <sys_page_alloc>
		if(r < 0)
  8015be:	83 c4 10             	add    $0x10,%esp
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	78 2a                	js     8015ef <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	68 03 16 80 00       	push   $0x801603
  8015cd:	6a 00                	push   $0x0
  8015cf:	e8 c4 f8 ff ff       	call   800e98 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	85 c0                	test   %eax,%eax
  8015d9:	79 c8                	jns    8015a3 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	68 ec 1d 80 00       	push   $0x801dec
  8015e3:	6a 25                	push   $0x25
  8015e5:	68 28 1e 80 00       	push   $0x801e28
  8015ea:	e8 44 ff ff ff       	call   801533 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8015ef:	83 ec 04             	sub    $0x4,%esp
  8015f2:	68 bc 1d 80 00       	push   $0x801dbc
  8015f7:	6a 22                	push   $0x22
  8015f9:	68 28 1e 80 00       	push   $0x801e28
  8015fe:	e8 30 ff ff ff       	call   801533 <_panic>

00801603 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801603:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801604:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  801609:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80160b:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80160e:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  801612:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  801616:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801619:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80161b:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80161f:	83 c4 08             	add    $0x8,%esp
	popal
  801622:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801623:	83 c4 04             	add    $0x4,%esp
	popfl
  801626:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801627:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801628:	c3                   	ret    
  801629:	66 90                	xchg   %ax,%ax
  80162b:	66 90                	xchg   %ax,%ax
  80162d:	66 90                	xchg   %ax,%ax
  80162f:	90                   	nop

00801630 <__udivdi3>:
  801630:	55                   	push   %ebp
  801631:	57                   	push   %edi
  801632:	56                   	push   %esi
  801633:	53                   	push   %ebx
  801634:	83 ec 1c             	sub    $0x1c,%esp
  801637:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80163b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80163f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801643:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801647:	85 d2                	test   %edx,%edx
  801649:	75 4d                	jne    801698 <__udivdi3+0x68>
  80164b:	39 f3                	cmp    %esi,%ebx
  80164d:	76 19                	jbe    801668 <__udivdi3+0x38>
  80164f:	31 ff                	xor    %edi,%edi
  801651:	89 e8                	mov    %ebp,%eax
  801653:	89 f2                	mov    %esi,%edx
  801655:	f7 f3                	div    %ebx
  801657:	89 fa                	mov    %edi,%edx
  801659:	83 c4 1c             	add    $0x1c,%esp
  80165c:	5b                   	pop    %ebx
  80165d:	5e                   	pop    %esi
  80165e:	5f                   	pop    %edi
  80165f:	5d                   	pop    %ebp
  801660:	c3                   	ret    
  801661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801668:	89 d9                	mov    %ebx,%ecx
  80166a:	85 db                	test   %ebx,%ebx
  80166c:	75 0b                	jne    801679 <__udivdi3+0x49>
  80166e:	b8 01 00 00 00       	mov    $0x1,%eax
  801673:	31 d2                	xor    %edx,%edx
  801675:	f7 f3                	div    %ebx
  801677:	89 c1                	mov    %eax,%ecx
  801679:	31 d2                	xor    %edx,%edx
  80167b:	89 f0                	mov    %esi,%eax
  80167d:	f7 f1                	div    %ecx
  80167f:	89 c6                	mov    %eax,%esi
  801681:	89 e8                	mov    %ebp,%eax
  801683:	89 f7                	mov    %esi,%edi
  801685:	f7 f1                	div    %ecx
  801687:	89 fa                	mov    %edi,%edx
  801689:	83 c4 1c             	add    $0x1c,%esp
  80168c:	5b                   	pop    %ebx
  80168d:	5e                   	pop    %esi
  80168e:	5f                   	pop    %edi
  80168f:	5d                   	pop    %ebp
  801690:	c3                   	ret    
  801691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801698:	39 f2                	cmp    %esi,%edx
  80169a:	77 1c                	ja     8016b8 <__udivdi3+0x88>
  80169c:	0f bd fa             	bsr    %edx,%edi
  80169f:	83 f7 1f             	xor    $0x1f,%edi
  8016a2:	75 2c                	jne    8016d0 <__udivdi3+0xa0>
  8016a4:	39 f2                	cmp    %esi,%edx
  8016a6:	72 06                	jb     8016ae <__udivdi3+0x7e>
  8016a8:	31 c0                	xor    %eax,%eax
  8016aa:	39 eb                	cmp    %ebp,%ebx
  8016ac:	77 a9                	ja     801657 <__udivdi3+0x27>
  8016ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8016b3:	eb a2                	jmp    801657 <__udivdi3+0x27>
  8016b5:	8d 76 00             	lea    0x0(%esi),%esi
  8016b8:	31 ff                	xor    %edi,%edi
  8016ba:	31 c0                	xor    %eax,%eax
  8016bc:	89 fa                	mov    %edi,%edx
  8016be:	83 c4 1c             	add    $0x1c,%esp
  8016c1:	5b                   	pop    %ebx
  8016c2:	5e                   	pop    %esi
  8016c3:	5f                   	pop    %edi
  8016c4:	5d                   	pop    %ebp
  8016c5:	c3                   	ret    
  8016c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8016cd:	8d 76 00             	lea    0x0(%esi),%esi
  8016d0:	89 f9                	mov    %edi,%ecx
  8016d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8016d7:	29 f8                	sub    %edi,%eax
  8016d9:	d3 e2                	shl    %cl,%edx
  8016db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8016df:	89 c1                	mov    %eax,%ecx
  8016e1:	89 da                	mov    %ebx,%edx
  8016e3:	d3 ea                	shr    %cl,%edx
  8016e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8016e9:	09 d1                	or     %edx,%ecx
  8016eb:	89 f2                	mov    %esi,%edx
  8016ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016f1:	89 f9                	mov    %edi,%ecx
  8016f3:	d3 e3                	shl    %cl,%ebx
  8016f5:	89 c1                	mov    %eax,%ecx
  8016f7:	d3 ea                	shr    %cl,%edx
  8016f9:	89 f9                	mov    %edi,%ecx
  8016fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8016ff:	89 eb                	mov    %ebp,%ebx
  801701:	d3 e6                	shl    %cl,%esi
  801703:	89 c1                	mov    %eax,%ecx
  801705:	d3 eb                	shr    %cl,%ebx
  801707:	09 de                	or     %ebx,%esi
  801709:	89 f0                	mov    %esi,%eax
  80170b:	f7 74 24 08          	divl   0x8(%esp)
  80170f:	89 d6                	mov    %edx,%esi
  801711:	89 c3                	mov    %eax,%ebx
  801713:	f7 64 24 0c          	mull   0xc(%esp)
  801717:	39 d6                	cmp    %edx,%esi
  801719:	72 15                	jb     801730 <__udivdi3+0x100>
  80171b:	89 f9                	mov    %edi,%ecx
  80171d:	d3 e5                	shl    %cl,%ebp
  80171f:	39 c5                	cmp    %eax,%ebp
  801721:	73 04                	jae    801727 <__udivdi3+0xf7>
  801723:	39 d6                	cmp    %edx,%esi
  801725:	74 09                	je     801730 <__udivdi3+0x100>
  801727:	89 d8                	mov    %ebx,%eax
  801729:	31 ff                	xor    %edi,%edi
  80172b:	e9 27 ff ff ff       	jmp    801657 <__udivdi3+0x27>
  801730:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801733:	31 ff                	xor    %edi,%edi
  801735:	e9 1d ff ff ff       	jmp    801657 <__udivdi3+0x27>
  80173a:	66 90                	xchg   %ax,%ax
  80173c:	66 90                	xchg   %ax,%ax
  80173e:	66 90                	xchg   %ax,%ax

00801740 <__umoddi3>:
  801740:	55                   	push   %ebp
  801741:	57                   	push   %edi
  801742:	56                   	push   %esi
  801743:	53                   	push   %ebx
  801744:	83 ec 1c             	sub    $0x1c,%esp
  801747:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80174b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80174f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801753:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801757:	89 da                	mov    %ebx,%edx
  801759:	85 c0                	test   %eax,%eax
  80175b:	75 43                	jne    8017a0 <__umoddi3+0x60>
  80175d:	39 df                	cmp    %ebx,%edi
  80175f:	76 17                	jbe    801778 <__umoddi3+0x38>
  801761:	89 f0                	mov    %esi,%eax
  801763:	f7 f7                	div    %edi
  801765:	89 d0                	mov    %edx,%eax
  801767:	31 d2                	xor    %edx,%edx
  801769:	83 c4 1c             	add    $0x1c,%esp
  80176c:	5b                   	pop    %ebx
  80176d:	5e                   	pop    %esi
  80176e:	5f                   	pop    %edi
  80176f:	5d                   	pop    %ebp
  801770:	c3                   	ret    
  801771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801778:	89 fd                	mov    %edi,%ebp
  80177a:	85 ff                	test   %edi,%edi
  80177c:	75 0b                	jne    801789 <__umoddi3+0x49>
  80177e:	b8 01 00 00 00       	mov    $0x1,%eax
  801783:	31 d2                	xor    %edx,%edx
  801785:	f7 f7                	div    %edi
  801787:	89 c5                	mov    %eax,%ebp
  801789:	89 d8                	mov    %ebx,%eax
  80178b:	31 d2                	xor    %edx,%edx
  80178d:	f7 f5                	div    %ebp
  80178f:	89 f0                	mov    %esi,%eax
  801791:	f7 f5                	div    %ebp
  801793:	89 d0                	mov    %edx,%eax
  801795:	eb d0                	jmp    801767 <__umoddi3+0x27>
  801797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80179e:	66 90                	xchg   %ax,%ax
  8017a0:	89 f1                	mov    %esi,%ecx
  8017a2:	39 d8                	cmp    %ebx,%eax
  8017a4:	76 0a                	jbe    8017b0 <__umoddi3+0x70>
  8017a6:	89 f0                	mov    %esi,%eax
  8017a8:	83 c4 1c             	add    $0x1c,%esp
  8017ab:	5b                   	pop    %ebx
  8017ac:	5e                   	pop    %esi
  8017ad:	5f                   	pop    %edi
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    
  8017b0:	0f bd e8             	bsr    %eax,%ebp
  8017b3:	83 f5 1f             	xor    $0x1f,%ebp
  8017b6:	75 20                	jne    8017d8 <__umoddi3+0x98>
  8017b8:	39 d8                	cmp    %ebx,%eax
  8017ba:	0f 82 b0 00 00 00    	jb     801870 <__umoddi3+0x130>
  8017c0:	39 f7                	cmp    %esi,%edi
  8017c2:	0f 86 a8 00 00 00    	jbe    801870 <__umoddi3+0x130>
  8017c8:	89 c8                	mov    %ecx,%eax
  8017ca:	83 c4 1c             	add    $0x1c,%esp
  8017cd:	5b                   	pop    %ebx
  8017ce:	5e                   	pop    %esi
  8017cf:	5f                   	pop    %edi
  8017d0:	5d                   	pop    %ebp
  8017d1:	c3                   	ret    
  8017d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8017d8:	89 e9                	mov    %ebp,%ecx
  8017da:	ba 20 00 00 00       	mov    $0x20,%edx
  8017df:	29 ea                	sub    %ebp,%edx
  8017e1:	d3 e0                	shl    %cl,%eax
  8017e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017e7:	89 d1                	mov    %edx,%ecx
  8017e9:	89 f8                	mov    %edi,%eax
  8017eb:	d3 e8                	shr    %cl,%eax
  8017ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8017f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8017f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8017f9:	09 c1                	or     %eax,%ecx
  8017fb:	89 d8                	mov    %ebx,%eax
  8017fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801801:	89 e9                	mov    %ebp,%ecx
  801803:	d3 e7                	shl    %cl,%edi
  801805:	89 d1                	mov    %edx,%ecx
  801807:	d3 e8                	shr    %cl,%eax
  801809:	89 e9                	mov    %ebp,%ecx
  80180b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80180f:	d3 e3                	shl    %cl,%ebx
  801811:	89 c7                	mov    %eax,%edi
  801813:	89 d1                	mov    %edx,%ecx
  801815:	89 f0                	mov    %esi,%eax
  801817:	d3 e8                	shr    %cl,%eax
  801819:	89 e9                	mov    %ebp,%ecx
  80181b:	89 fa                	mov    %edi,%edx
  80181d:	d3 e6                	shl    %cl,%esi
  80181f:	09 d8                	or     %ebx,%eax
  801821:	f7 74 24 08          	divl   0x8(%esp)
  801825:	89 d1                	mov    %edx,%ecx
  801827:	89 f3                	mov    %esi,%ebx
  801829:	f7 64 24 0c          	mull   0xc(%esp)
  80182d:	89 c6                	mov    %eax,%esi
  80182f:	89 d7                	mov    %edx,%edi
  801831:	39 d1                	cmp    %edx,%ecx
  801833:	72 06                	jb     80183b <__umoddi3+0xfb>
  801835:	75 10                	jne    801847 <__umoddi3+0x107>
  801837:	39 c3                	cmp    %eax,%ebx
  801839:	73 0c                	jae    801847 <__umoddi3+0x107>
  80183b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80183f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801843:	89 d7                	mov    %edx,%edi
  801845:	89 c6                	mov    %eax,%esi
  801847:	89 ca                	mov    %ecx,%edx
  801849:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80184e:	29 f3                	sub    %esi,%ebx
  801850:	19 fa                	sbb    %edi,%edx
  801852:	89 d0                	mov    %edx,%eax
  801854:	d3 e0                	shl    %cl,%eax
  801856:	89 e9                	mov    %ebp,%ecx
  801858:	d3 eb                	shr    %cl,%ebx
  80185a:	d3 ea                	shr    %cl,%edx
  80185c:	09 d8                	or     %ebx,%eax
  80185e:	83 c4 1c             	add    $0x1c,%esp
  801861:	5b                   	pop    %ebx
  801862:	5e                   	pop    %esi
  801863:	5f                   	pop    %edi
  801864:	5d                   	pop    %ebp
  801865:	c3                   	ret    
  801866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80186d:	8d 76 00             	lea    0x0(%esi),%esi
  801870:	89 da                	mov    %ebx,%edx
  801872:	29 fe                	sub    %edi,%esi
  801874:	19 c2                	sbb    %eax,%edx
  801876:	89 f1                	mov    %esi,%ecx
  801878:	89 c8                	mov    %ecx,%eax
  80187a:	e9 4b ff ff ff       	jmp    8017ca <__umoddi3+0x8a>
