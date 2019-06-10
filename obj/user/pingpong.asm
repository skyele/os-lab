
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
  80003c:	e8 bc 12 00 00       	call   8012fd <fork>
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
  800053:	e8 37 15 00 00       	call   80158f <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 13 0d 00 00       	call   800d75 <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 96 2b 80 00       	push   $0x802b96
  80006a:	e8 f3 01 00 00       	call   800262 <cprintf>
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
  800082:	e8 71 15 00 00       	call   8015f8 <ipc_send>
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
  800099:	e8 d7 0c 00 00       	call   800d75 <sys_getenvid>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	50                   	push   %eax
  8000a3:	68 80 2b 80 00       	push   $0x802b80
  8000a8:	e8 b5 01 00 00       	call   800262 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	e8 3d 15 00 00       	call   8015f8 <ipc_send>
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
  8000c9:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8000d0:	00 00 00 
	envid_t find = sys_getenvid();
  8000d3:	e8 9d 0c 00 00       	call   800d75 <sys_getenvid>
  8000d8:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
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
  800121:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800127:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80012b:	7e 0a                	jle    800137 <libmain+0x77>
		binaryname = argv[0];
  80012d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800130:	8b 00                	mov    (%eax),%eax
  800132:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800137:	a1 08 50 80 00       	mov    0x805008,%eax
  80013c:	8b 40 48             	mov    0x48(%eax),%eax
  80013f:	83 ec 08             	sub    $0x8,%esp
  800142:	50                   	push   %eax
  800143:	68 a9 2b 80 00       	push   $0x802ba9
  800148:	e8 15 01 00 00       	call   800262 <cprintf>
	cprintf("before umain\n");
  80014d:	c7 04 24 c7 2b 80 00 	movl   $0x802bc7,(%esp)
  800154:	e8 09 01 00 00       	call   800262 <cprintf>
	// call user main routine
	umain(argc, argv);
  800159:	83 c4 08             	add    $0x8,%esp
  80015c:	ff 75 0c             	pushl  0xc(%ebp)
  80015f:	ff 75 08             	pushl  0x8(%ebp)
  800162:	e8 cc fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800167:	c7 04 24 d5 2b 80 00 	movl   $0x802bd5,(%esp)
  80016e:	e8 ef 00 00 00       	call   800262 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800173:	a1 08 50 80 00       	mov    0x805008,%eax
  800178:	8b 40 48             	mov    0x48(%eax),%eax
  80017b:	83 c4 08             	add    $0x8,%esp
  80017e:	50                   	push   %eax
  80017f:	68 e2 2b 80 00       	push   $0x802be2
  800184:	e8 d9 00 00 00       	call   800262 <cprintf>
	// exit gracefully
	exit();
  800189:	e8 0b 00 00 00       	call   800199 <exit>
}
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800194:	5b                   	pop    %ebx
  800195:	5e                   	pop    %esi
  800196:	5f                   	pop    %edi
  800197:	5d                   	pop    %ebp
  800198:	c3                   	ret    

00800199 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800199:	55                   	push   %ebp
  80019a:	89 e5                	mov    %esp,%ebp
  80019c:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80019f:	a1 08 50 80 00       	mov    0x805008,%eax
  8001a4:	8b 40 48             	mov    0x48(%eax),%eax
  8001a7:	68 0c 2c 80 00       	push   $0x802c0c
  8001ac:	50                   	push   %eax
  8001ad:	68 01 2c 80 00       	push   $0x802c01
  8001b2:	e8 ab 00 00 00       	call   800262 <cprintf>
	close_all();
  8001b7:	e8 a7 16 00 00       	call   801863 <close_all>
	sys_env_destroy(0);
  8001bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001c3:	e8 6c 0b 00 00       	call   800d34 <sys_env_destroy>
}
  8001c8:	83 c4 10             	add    $0x10,%esp
  8001cb:	c9                   	leave  
  8001cc:	c3                   	ret    

008001cd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	53                   	push   %ebx
  8001d1:	83 ec 04             	sub    $0x4,%esp
  8001d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d7:	8b 13                	mov    (%ebx),%edx
  8001d9:	8d 42 01             	lea    0x1(%edx),%eax
  8001dc:	89 03                	mov    %eax,(%ebx)
  8001de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ea:	74 09                	je     8001f5 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ec:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f3:	c9                   	leave  
  8001f4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	68 ff 00 00 00       	push   $0xff
  8001fd:	8d 43 08             	lea    0x8(%ebx),%eax
  800200:	50                   	push   %eax
  800201:	e8 f1 0a 00 00       	call   800cf7 <sys_cputs>
		b->idx = 0;
  800206:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	eb db                	jmp    8001ec <putch+0x1f>

00800211 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80021a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800221:	00 00 00 
	b.cnt = 0;
  800224:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80022b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80022e:	ff 75 0c             	pushl  0xc(%ebp)
  800231:	ff 75 08             	pushl  0x8(%ebp)
  800234:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023a:	50                   	push   %eax
  80023b:	68 cd 01 80 00       	push   $0x8001cd
  800240:	e8 4a 01 00 00       	call   80038f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800245:	83 c4 08             	add    $0x8,%esp
  800248:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80024e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800254:	50                   	push   %eax
  800255:	e8 9d 0a 00 00       	call   800cf7 <sys_cputs>

	return b.cnt;
}
  80025a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800260:	c9                   	leave  
  800261:	c3                   	ret    

00800262 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800262:	55                   	push   %ebp
  800263:	89 e5                	mov    %esp,%ebp
  800265:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800268:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80026b:	50                   	push   %eax
  80026c:	ff 75 08             	pushl  0x8(%ebp)
  80026f:	e8 9d ff ff ff       	call   800211 <vcprintf>
	va_end(ap);

	return cnt;
}
  800274:	c9                   	leave  
  800275:	c3                   	ret    

00800276 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800276:	55                   	push   %ebp
  800277:	89 e5                	mov    %esp,%ebp
  800279:	57                   	push   %edi
  80027a:	56                   	push   %esi
  80027b:	53                   	push   %ebx
  80027c:	83 ec 1c             	sub    $0x1c,%esp
  80027f:	89 c6                	mov    %eax,%esi
  800281:	89 d7                	mov    %edx,%edi
  800283:	8b 45 08             	mov    0x8(%ebp),%eax
  800286:	8b 55 0c             	mov    0xc(%ebp),%edx
  800289:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80028c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80028f:	8b 45 10             	mov    0x10(%ebp),%eax
  800292:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800295:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800299:	74 2c                	je     8002c7 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80029b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80029e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002ab:	39 c2                	cmp    %eax,%edx
  8002ad:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002b0:	73 43                	jae    8002f5 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002b2:	83 eb 01             	sub    $0x1,%ebx
  8002b5:	85 db                	test   %ebx,%ebx
  8002b7:	7e 6c                	jle    800325 <printnum+0xaf>
				putch(padc, putdat);
  8002b9:	83 ec 08             	sub    $0x8,%esp
  8002bc:	57                   	push   %edi
  8002bd:	ff 75 18             	pushl  0x18(%ebp)
  8002c0:	ff d6                	call   *%esi
  8002c2:	83 c4 10             	add    $0x10,%esp
  8002c5:	eb eb                	jmp    8002b2 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	6a 20                	push   $0x20
  8002cc:	6a 00                	push   $0x0
  8002ce:	50                   	push   %eax
  8002cf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d2:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d5:	89 fa                	mov    %edi,%edx
  8002d7:	89 f0                	mov    %esi,%eax
  8002d9:	e8 98 ff ff ff       	call   800276 <printnum>
		while (--width > 0)
  8002de:	83 c4 20             	add    $0x20,%esp
  8002e1:	83 eb 01             	sub    $0x1,%ebx
  8002e4:	85 db                	test   %ebx,%ebx
  8002e6:	7e 65                	jle    80034d <printnum+0xd7>
			putch(padc, putdat);
  8002e8:	83 ec 08             	sub    $0x8,%esp
  8002eb:	57                   	push   %edi
  8002ec:	6a 20                	push   $0x20
  8002ee:	ff d6                	call   *%esi
  8002f0:	83 c4 10             	add    $0x10,%esp
  8002f3:	eb ec                	jmp    8002e1 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f5:	83 ec 0c             	sub    $0xc,%esp
  8002f8:	ff 75 18             	pushl  0x18(%ebp)
  8002fb:	83 eb 01             	sub    $0x1,%ebx
  8002fe:	53                   	push   %ebx
  8002ff:	50                   	push   %eax
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	ff 75 dc             	pushl  -0x24(%ebp)
  800306:	ff 75 d8             	pushl  -0x28(%ebp)
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	ff 75 e0             	pushl  -0x20(%ebp)
  80030f:	e8 0c 26 00 00       	call   802920 <__udivdi3>
  800314:	83 c4 18             	add    $0x18,%esp
  800317:	52                   	push   %edx
  800318:	50                   	push   %eax
  800319:	89 fa                	mov    %edi,%edx
  80031b:	89 f0                	mov    %esi,%eax
  80031d:	e8 54 ff ff ff       	call   800276 <printnum>
  800322:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800325:	83 ec 08             	sub    $0x8,%esp
  800328:	57                   	push   %edi
  800329:	83 ec 04             	sub    $0x4,%esp
  80032c:	ff 75 dc             	pushl  -0x24(%ebp)
  80032f:	ff 75 d8             	pushl  -0x28(%ebp)
  800332:	ff 75 e4             	pushl  -0x1c(%ebp)
  800335:	ff 75 e0             	pushl  -0x20(%ebp)
  800338:	e8 f3 26 00 00       	call   802a30 <__umoddi3>
  80033d:	83 c4 14             	add    $0x14,%esp
  800340:	0f be 80 11 2c 80 00 	movsbl 0x802c11(%eax),%eax
  800347:	50                   	push   %eax
  800348:	ff d6                	call   *%esi
  80034a:	83 c4 10             	add    $0x10,%esp
	}
}
  80034d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800350:	5b                   	pop    %ebx
  800351:	5e                   	pop    %esi
  800352:	5f                   	pop    %edi
  800353:	5d                   	pop    %ebp
  800354:	c3                   	ret    

00800355 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80035b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80035f:	8b 10                	mov    (%eax),%edx
  800361:	3b 50 04             	cmp    0x4(%eax),%edx
  800364:	73 0a                	jae    800370 <sprintputch+0x1b>
		*b->buf++ = ch;
  800366:	8d 4a 01             	lea    0x1(%edx),%ecx
  800369:	89 08                	mov    %ecx,(%eax)
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	88 02                	mov    %al,(%edx)
}
  800370:	5d                   	pop    %ebp
  800371:	c3                   	ret    

00800372 <printfmt>:
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800378:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80037b:	50                   	push   %eax
  80037c:	ff 75 10             	pushl  0x10(%ebp)
  80037f:	ff 75 0c             	pushl  0xc(%ebp)
  800382:	ff 75 08             	pushl  0x8(%ebp)
  800385:	e8 05 00 00 00       	call   80038f <vprintfmt>
}
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	c9                   	leave  
  80038e:	c3                   	ret    

0080038f <vprintfmt>:
{
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	57                   	push   %edi
  800393:	56                   	push   %esi
  800394:	53                   	push   %ebx
  800395:	83 ec 3c             	sub    $0x3c,%esp
  800398:	8b 75 08             	mov    0x8(%ebp),%esi
  80039b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80039e:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a1:	e9 32 04 00 00       	jmp    8007d8 <vprintfmt+0x449>
		padc = ' ';
  8003a6:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003aa:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003b1:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003b8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003c6:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003cd:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d2:	8d 47 01             	lea    0x1(%edi),%eax
  8003d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003d8:	0f b6 17             	movzbl (%edi),%edx
  8003db:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003de:	3c 55                	cmp    $0x55,%al
  8003e0:	0f 87 12 05 00 00    	ja     8008f8 <vprintfmt+0x569>
  8003e6:	0f b6 c0             	movzbl %al,%eax
  8003e9:	ff 24 85 e0 2d 80 00 	jmp    *0x802de0(,%eax,4)
  8003f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003f3:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003f7:	eb d9                	jmp    8003d2 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003fc:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800400:	eb d0                	jmp    8003d2 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800402:	0f b6 d2             	movzbl %dl,%edx
  800405:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800408:	b8 00 00 00 00       	mov    $0x0,%eax
  80040d:	89 75 08             	mov    %esi,0x8(%ebp)
  800410:	eb 03                	jmp    800415 <vprintfmt+0x86>
  800412:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800415:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800418:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80041c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80041f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800422:	83 fe 09             	cmp    $0x9,%esi
  800425:	76 eb                	jbe    800412 <vprintfmt+0x83>
  800427:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80042a:	8b 75 08             	mov    0x8(%ebp),%esi
  80042d:	eb 14                	jmp    800443 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80042f:	8b 45 14             	mov    0x14(%ebp),%eax
  800432:	8b 00                	mov    (%eax),%eax
  800434:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800437:	8b 45 14             	mov    0x14(%ebp),%eax
  80043a:	8d 40 04             	lea    0x4(%eax),%eax
  80043d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800440:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800443:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800447:	79 89                	jns    8003d2 <vprintfmt+0x43>
				width = precision, precision = -1;
  800449:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80044c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800456:	e9 77 ff ff ff       	jmp    8003d2 <vprintfmt+0x43>
  80045b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80045e:	85 c0                	test   %eax,%eax
  800460:	0f 48 c1             	cmovs  %ecx,%eax
  800463:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800466:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800469:	e9 64 ff ff ff       	jmp    8003d2 <vprintfmt+0x43>
  80046e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800471:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800478:	e9 55 ff ff ff       	jmp    8003d2 <vprintfmt+0x43>
			lflag++;
  80047d:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800481:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800484:	e9 49 ff ff ff       	jmp    8003d2 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800489:	8b 45 14             	mov    0x14(%ebp),%eax
  80048c:	8d 78 04             	lea    0x4(%eax),%edi
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	53                   	push   %ebx
  800493:	ff 30                	pushl  (%eax)
  800495:	ff d6                	call   *%esi
			break;
  800497:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80049a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80049d:	e9 33 03 00 00       	jmp    8007d5 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a5:	8d 78 04             	lea    0x4(%eax),%edi
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	99                   	cltd   
  8004ab:	31 d0                	xor    %edx,%eax
  8004ad:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004af:	83 f8 11             	cmp    $0x11,%eax
  8004b2:	7f 23                	jg     8004d7 <vprintfmt+0x148>
  8004b4:	8b 14 85 40 2f 80 00 	mov    0x802f40(,%eax,4),%edx
  8004bb:	85 d2                	test   %edx,%edx
  8004bd:	74 18                	je     8004d7 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004bf:	52                   	push   %edx
  8004c0:	68 6d 31 80 00       	push   $0x80316d
  8004c5:	53                   	push   %ebx
  8004c6:	56                   	push   %esi
  8004c7:	e8 a6 fe ff ff       	call   800372 <printfmt>
  8004cc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004cf:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004d2:	e9 fe 02 00 00       	jmp    8007d5 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004d7:	50                   	push   %eax
  8004d8:	68 29 2c 80 00       	push   $0x802c29
  8004dd:	53                   	push   %ebx
  8004de:	56                   	push   %esi
  8004df:	e8 8e fe ff ff       	call   800372 <printfmt>
  8004e4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004ea:	e9 e6 02 00 00       	jmp    8007d5 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f2:	83 c0 04             	add    $0x4,%eax
  8004f5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fb:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004fd:	85 c9                	test   %ecx,%ecx
  8004ff:	b8 22 2c 80 00       	mov    $0x802c22,%eax
  800504:	0f 45 c1             	cmovne %ecx,%eax
  800507:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80050a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80050e:	7e 06                	jle    800516 <vprintfmt+0x187>
  800510:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800514:	75 0d                	jne    800523 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800516:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800519:	89 c7                	mov    %eax,%edi
  80051b:	03 45 e0             	add    -0x20(%ebp),%eax
  80051e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800521:	eb 53                	jmp    800576 <vprintfmt+0x1e7>
  800523:	83 ec 08             	sub    $0x8,%esp
  800526:	ff 75 d8             	pushl  -0x28(%ebp)
  800529:	50                   	push   %eax
  80052a:	e8 71 04 00 00       	call   8009a0 <strnlen>
  80052f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800532:	29 c1                	sub    %eax,%ecx
  800534:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800537:	83 c4 10             	add    $0x10,%esp
  80053a:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80053c:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800540:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800543:	eb 0f                	jmp    800554 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800545:	83 ec 08             	sub    $0x8,%esp
  800548:	53                   	push   %ebx
  800549:	ff 75 e0             	pushl  -0x20(%ebp)
  80054c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80054e:	83 ef 01             	sub    $0x1,%edi
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	85 ff                	test   %edi,%edi
  800556:	7f ed                	jg     800545 <vprintfmt+0x1b6>
  800558:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80055b:	85 c9                	test   %ecx,%ecx
  80055d:	b8 00 00 00 00       	mov    $0x0,%eax
  800562:	0f 49 c1             	cmovns %ecx,%eax
  800565:	29 c1                	sub    %eax,%ecx
  800567:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80056a:	eb aa                	jmp    800516 <vprintfmt+0x187>
					putch(ch, putdat);
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	53                   	push   %ebx
  800570:	52                   	push   %edx
  800571:	ff d6                	call   *%esi
  800573:	83 c4 10             	add    $0x10,%esp
  800576:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800579:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80057b:	83 c7 01             	add    $0x1,%edi
  80057e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800582:	0f be d0             	movsbl %al,%edx
  800585:	85 d2                	test   %edx,%edx
  800587:	74 4b                	je     8005d4 <vprintfmt+0x245>
  800589:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80058d:	78 06                	js     800595 <vprintfmt+0x206>
  80058f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800593:	78 1e                	js     8005b3 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800595:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800599:	74 d1                	je     80056c <vprintfmt+0x1dd>
  80059b:	0f be c0             	movsbl %al,%eax
  80059e:	83 e8 20             	sub    $0x20,%eax
  8005a1:	83 f8 5e             	cmp    $0x5e,%eax
  8005a4:	76 c6                	jbe    80056c <vprintfmt+0x1dd>
					putch('?', putdat);
  8005a6:	83 ec 08             	sub    $0x8,%esp
  8005a9:	53                   	push   %ebx
  8005aa:	6a 3f                	push   $0x3f
  8005ac:	ff d6                	call   *%esi
  8005ae:	83 c4 10             	add    $0x10,%esp
  8005b1:	eb c3                	jmp    800576 <vprintfmt+0x1e7>
  8005b3:	89 cf                	mov    %ecx,%edi
  8005b5:	eb 0e                	jmp    8005c5 <vprintfmt+0x236>
				putch(' ', putdat);
  8005b7:	83 ec 08             	sub    $0x8,%esp
  8005ba:	53                   	push   %ebx
  8005bb:	6a 20                	push   $0x20
  8005bd:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005bf:	83 ef 01             	sub    $0x1,%edi
  8005c2:	83 c4 10             	add    $0x10,%esp
  8005c5:	85 ff                	test   %edi,%edi
  8005c7:	7f ee                	jg     8005b7 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005c9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cf:	e9 01 02 00 00       	jmp    8007d5 <vprintfmt+0x446>
  8005d4:	89 cf                	mov    %ecx,%edi
  8005d6:	eb ed                	jmp    8005c5 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005db:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005e2:	e9 eb fd ff ff       	jmp    8003d2 <vprintfmt+0x43>
	if (lflag >= 2)
  8005e7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005eb:	7f 21                	jg     80060e <vprintfmt+0x27f>
	else if (lflag)
  8005ed:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005f1:	74 68                	je     80065b <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005fb:	89 c1                	mov    %eax,%ecx
  8005fd:	c1 f9 1f             	sar    $0x1f,%ecx
  800600:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8d 40 04             	lea    0x4(%eax),%eax
  800609:	89 45 14             	mov    %eax,0x14(%ebp)
  80060c:	eb 17                	jmp    800625 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8b 50 04             	mov    0x4(%eax),%edx
  800614:	8b 00                	mov    (%eax),%eax
  800616:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800619:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8d 40 08             	lea    0x8(%eax),%eax
  800622:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800625:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800628:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80062b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800631:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800635:	78 3f                	js     800676 <vprintfmt+0x2e7>
			base = 10;
  800637:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80063c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800640:	0f 84 71 01 00 00    	je     8007b7 <vprintfmt+0x428>
				putch('+', putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	53                   	push   %ebx
  80064a:	6a 2b                	push   $0x2b
  80064c:	ff d6                	call   *%esi
  80064e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800651:	b8 0a 00 00 00       	mov    $0xa,%eax
  800656:	e9 5c 01 00 00       	jmp    8007b7 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800663:	89 c1                	mov    %eax,%ecx
  800665:	c1 f9 1f             	sar    $0x1f,%ecx
  800668:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8d 40 04             	lea    0x4(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
  800674:	eb af                	jmp    800625 <vprintfmt+0x296>
				putch('-', putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	53                   	push   %ebx
  80067a:	6a 2d                	push   $0x2d
  80067c:	ff d6                	call   *%esi
				num = -(long long) num;
  80067e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800681:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800684:	f7 d8                	neg    %eax
  800686:	83 d2 00             	adc    $0x0,%edx
  800689:	f7 da                	neg    %edx
  80068b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800691:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800694:	b8 0a 00 00 00       	mov    $0xa,%eax
  800699:	e9 19 01 00 00       	jmp    8007b7 <vprintfmt+0x428>
	if (lflag >= 2)
  80069e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006a2:	7f 29                	jg     8006cd <vprintfmt+0x33e>
	else if (lflag)
  8006a4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006a8:	74 44                	je     8006ee <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8d 40 04             	lea    0x4(%eax),%eax
  8006c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c8:	e9 ea 00 00 00       	jmp    8007b7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 50 04             	mov    0x4(%eax),%edx
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8d 40 08             	lea    0x8(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e9:	e9 c9 00 00 00       	jmp    8007b7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8d 40 04             	lea    0x4(%eax),%eax
  800704:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800707:	b8 0a 00 00 00       	mov    $0xa,%eax
  80070c:	e9 a6 00 00 00       	jmp    8007b7 <vprintfmt+0x428>
			putch('0', putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	53                   	push   %ebx
  800715:	6a 30                	push   $0x30
  800717:	ff d6                	call   *%esi
	if (lflag >= 2)
  800719:	83 c4 10             	add    $0x10,%esp
  80071c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800720:	7f 26                	jg     800748 <vprintfmt+0x3b9>
	else if (lflag)
  800722:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800726:	74 3e                	je     800766 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	ba 00 00 00 00       	mov    $0x0,%edx
  800732:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800735:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800738:	8b 45 14             	mov    0x14(%ebp),%eax
  80073b:	8d 40 04             	lea    0x4(%eax),%eax
  80073e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800741:	b8 08 00 00 00       	mov    $0x8,%eax
  800746:	eb 6f                	jmp    8007b7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	8b 50 04             	mov    0x4(%eax),%edx
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800753:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	8d 40 08             	lea    0x8(%eax),%eax
  80075c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075f:	b8 08 00 00 00       	mov    $0x8,%eax
  800764:	eb 51                	jmp    8007b7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	ba 00 00 00 00       	mov    $0x0,%edx
  800770:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800773:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8d 40 04             	lea    0x4(%eax),%eax
  80077c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80077f:	b8 08 00 00 00       	mov    $0x8,%eax
  800784:	eb 31                	jmp    8007b7 <vprintfmt+0x428>
			putch('0', putdat);
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	53                   	push   %ebx
  80078a:	6a 30                	push   $0x30
  80078c:	ff d6                	call   *%esi
			putch('x', putdat);
  80078e:	83 c4 08             	add    $0x8,%esp
  800791:	53                   	push   %ebx
  800792:	6a 78                	push   $0x78
  800794:	ff d6                	call   *%esi
			num = (unsigned long long)
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007a6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	8d 40 04             	lea    0x4(%eax),%eax
  8007af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007b7:	83 ec 0c             	sub    $0xc,%esp
  8007ba:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007be:	52                   	push   %edx
  8007bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	ff 75 dc             	pushl  -0x24(%ebp)
  8007c6:	ff 75 d8             	pushl  -0x28(%ebp)
  8007c9:	89 da                	mov    %ebx,%edx
  8007cb:	89 f0                	mov    %esi,%eax
  8007cd:	e8 a4 fa ff ff       	call   800276 <printnum>
			break;
  8007d2:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d8:	83 c7 01             	add    $0x1,%edi
  8007db:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007df:	83 f8 25             	cmp    $0x25,%eax
  8007e2:	0f 84 be fb ff ff    	je     8003a6 <vprintfmt+0x17>
			if (ch == '\0')
  8007e8:	85 c0                	test   %eax,%eax
  8007ea:	0f 84 28 01 00 00    	je     800918 <vprintfmt+0x589>
			putch(ch, putdat);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	53                   	push   %ebx
  8007f4:	50                   	push   %eax
  8007f5:	ff d6                	call   *%esi
  8007f7:	83 c4 10             	add    $0x10,%esp
  8007fa:	eb dc                	jmp    8007d8 <vprintfmt+0x449>
	if (lflag >= 2)
  8007fc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800800:	7f 26                	jg     800828 <vprintfmt+0x499>
	else if (lflag)
  800802:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800806:	74 41                	je     800849 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	ba 00 00 00 00       	mov    $0x0,%edx
  800812:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800815:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800818:	8b 45 14             	mov    0x14(%ebp),%eax
  80081b:	8d 40 04             	lea    0x4(%eax),%eax
  80081e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800821:	b8 10 00 00 00       	mov    $0x10,%eax
  800826:	eb 8f                	jmp    8007b7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	8b 50 04             	mov    0x4(%eax),%edx
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800833:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8d 40 08             	lea    0x8(%eax),%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083f:	b8 10 00 00 00       	mov    $0x10,%eax
  800844:	e9 6e ff ff ff       	jmp    8007b7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	ba 00 00 00 00       	mov    $0x0,%edx
  800853:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800856:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8d 40 04             	lea    0x4(%eax),%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800862:	b8 10 00 00 00       	mov    $0x10,%eax
  800867:	e9 4b ff ff ff       	jmp    8007b7 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80086c:	8b 45 14             	mov    0x14(%ebp),%eax
  80086f:	83 c0 04             	add    $0x4,%eax
  800872:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	85 c0                	test   %eax,%eax
  80087c:	74 14                	je     800892 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80087e:	8b 13                	mov    (%ebx),%edx
  800880:	83 fa 7f             	cmp    $0x7f,%edx
  800883:	7f 37                	jg     8008bc <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800885:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800887:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80088a:	89 45 14             	mov    %eax,0x14(%ebp)
  80088d:	e9 43 ff ff ff       	jmp    8007d5 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800892:	b8 0a 00 00 00       	mov    $0xa,%eax
  800897:	bf 45 2d 80 00       	mov    $0x802d45,%edi
							putch(ch, putdat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	53                   	push   %ebx
  8008a0:	50                   	push   %eax
  8008a1:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008a3:	83 c7 01             	add    $0x1,%edi
  8008a6:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008aa:	83 c4 10             	add    $0x10,%esp
  8008ad:	85 c0                	test   %eax,%eax
  8008af:	75 eb                	jne    80089c <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b7:	e9 19 ff ff ff       	jmp    8007d5 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008bc:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008be:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c3:	bf 7d 2d 80 00       	mov    $0x802d7d,%edi
							putch(ch, putdat);
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	53                   	push   %ebx
  8008cc:	50                   	push   %eax
  8008cd:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008cf:	83 c7 01             	add    $0x1,%edi
  8008d2:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
  8008d9:	85 c0                	test   %eax,%eax
  8008db:	75 eb                	jne    8008c8 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e3:	e9 ed fe ff ff       	jmp    8007d5 <vprintfmt+0x446>
			putch(ch, putdat);
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	53                   	push   %ebx
  8008ec:	6a 25                	push   $0x25
  8008ee:	ff d6                	call   *%esi
			break;
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	e9 dd fe ff ff       	jmp    8007d5 <vprintfmt+0x446>
			putch('%', putdat);
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	53                   	push   %ebx
  8008fc:	6a 25                	push   $0x25
  8008fe:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800900:	83 c4 10             	add    $0x10,%esp
  800903:	89 f8                	mov    %edi,%eax
  800905:	eb 03                	jmp    80090a <vprintfmt+0x57b>
  800907:	83 e8 01             	sub    $0x1,%eax
  80090a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80090e:	75 f7                	jne    800907 <vprintfmt+0x578>
  800910:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800913:	e9 bd fe ff ff       	jmp    8007d5 <vprintfmt+0x446>
}
  800918:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80091b:	5b                   	pop    %ebx
  80091c:	5e                   	pop    %esi
  80091d:	5f                   	pop    %edi
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	83 ec 18             	sub    $0x18,%esp
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80092c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80092f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800933:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800936:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80093d:	85 c0                	test   %eax,%eax
  80093f:	74 26                	je     800967 <vsnprintf+0x47>
  800941:	85 d2                	test   %edx,%edx
  800943:	7e 22                	jle    800967 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800945:	ff 75 14             	pushl  0x14(%ebp)
  800948:	ff 75 10             	pushl  0x10(%ebp)
  80094b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80094e:	50                   	push   %eax
  80094f:	68 55 03 80 00       	push   $0x800355
  800954:	e8 36 fa ff ff       	call   80038f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800959:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80095c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80095f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800962:	83 c4 10             	add    $0x10,%esp
}
  800965:	c9                   	leave  
  800966:	c3                   	ret    
		return -E_INVAL;
  800967:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80096c:	eb f7                	jmp    800965 <vsnprintf+0x45>

0080096e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800974:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800977:	50                   	push   %eax
  800978:	ff 75 10             	pushl  0x10(%ebp)
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	ff 75 08             	pushl  0x8(%ebp)
  800981:	e8 9a ff ff ff       	call   800920 <vsnprintf>
	va_end(ap);

	return rc;
}
  800986:	c9                   	leave  
  800987:	c3                   	ret    

00800988 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80098e:	b8 00 00 00 00       	mov    $0x0,%eax
  800993:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800997:	74 05                	je     80099e <strlen+0x16>
		n++;
  800999:	83 c0 01             	add    $0x1,%eax
  80099c:	eb f5                	jmp    800993 <strlen+0xb>
	return n;
}
  80099e:	5d                   	pop    %ebp
  80099f:	c3                   	ret    

008009a0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009a0:	55                   	push   %ebp
  8009a1:	89 e5                	mov    %esp,%ebp
  8009a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a6:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ae:	39 c2                	cmp    %eax,%edx
  8009b0:	74 0d                	je     8009bf <strnlen+0x1f>
  8009b2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009b6:	74 05                	je     8009bd <strnlen+0x1d>
		n++;
  8009b8:	83 c2 01             	add    $0x1,%edx
  8009bb:	eb f1                	jmp    8009ae <strnlen+0xe>
  8009bd:	89 d0                	mov    %edx,%eax
	return n;
}
  8009bf:	5d                   	pop    %ebp
  8009c0:	c3                   	ret    

008009c1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	53                   	push   %ebx
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009d7:	83 c2 01             	add    $0x1,%edx
  8009da:	84 c9                	test   %cl,%cl
  8009dc:	75 f2                	jne    8009d0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009de:	5b                   	pop    %ebx
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	53                   	push   %ebx
  8009e5:	83 ec 10             	sub    $0x10,%esp
  8009e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009eb:	53                   	push   %ebx
  8009ec:	e8 97 ff ff ff       	call   800988 <strlen>
  8009f1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	01 d8                	add    %ebx,%eax
  8009f9:	50                   	push   %eax
  8009fa:	e8 c2 ff ff ff       	call   8009c1 <strcpy>
	return dst;
}
  8009ff:	89 d8                	mov    %ebx,%eax
  800a01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a04:	c9                   	leave  
  800a05:	c3                   	ret    

00800a06 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	56                   	push   %esi
  800a0a:	53                   	push   %ebx
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a11:	89 c6                	mov    %eax,%esi
  800a13:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a16:	89 c2                	mov    %eax,%edx
  800a18:	39 f2                	cmp    %esi,%edx
  800a1a:	74 11                	je     800a2d <strncpy+0x27>
		*dst++ = *src;
  800a1c:	83 c2 01             	add    $0x1,%edx
  800a1f:	0f b6 19             	movzbl (%ecx),%ebx
  800a22:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a25:	80 fb 01             	cmp    $0x1,%bl
  800a28:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a2b:	eb eb                	jmp    800a18 <strncpy+0x12>
	}
	return ret;
}
  800a2d:	5b                   	pop    %ebx
  800a2e:	5e                   	pop    %esi
  800a2f:	5d                   	pop    %ebp
  800a30:	c3                   	ret    

00800a31 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	56                   	push   %esi
  800a35:	53                   	push   %ebx
  800a36:	8b 75 08             	mov    0x8(%ebp),%esi
  800a39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a3c:	8b 55 10             	mov    0x10(%ebp),%edx
  800a3f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a41:	85 d2                	test   %edx,%edx
  800a43:	74 21                	je     800a66 <strlcpy+0x35>
  800a45:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a49:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a4b:	39 c2                	cmp    %eax,%edx
  800a4d:	74 14                	je     800a63 <strlcpy+0x32>
  800a4f:	0f b6 19             	movzbl (%ecx),%ebx
  800a52:	84 db                	test   %bl,%bl
  800a54:	74 0b                	je     800a61 <strlcpy+0x30>
			*dst++ = *src++;
  800a56:	83 c1 01             	add    $0x1,%ecx
  800a59:	83 c2 01             	add    $0x1,%edx
  800a5c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a5f:	eb ea                	jmp    800a4b <strlcpy+0x1a>
  800a61:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a63:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a66:	29 f0                	sub    %esi,%eax
}
  800a68:	5b                   	pop    %ebx
  800a69:	5e                   	pop    %esi
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a72:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a75:	0f b6 01             	movzbl (%ecx),%eax
  800a78:	84 c0                	test   %al,%al
  800a7a:	74 0c                	je     800a88 <strcmp+0x1c>
  800a7c:	3a 02                	cmp    (%edx),%al
  800a7e:	75 08                	jne    800a88 <strcmp+0x1c>
		p++, q++;
  800a80:	83 c1 01             	add    $0x1,%ecx
  800a83:	83 c2 01             	add    $0x1,%edx
  800a86:	eb ed                	jmp    800a75 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a88:	0f b6 c0             	movzbl %al,%eax
  800a8b:	0f b6 12             	movzbl (%edx),%edx
  800a8e:	29 d0                	sub    %edx,%eax
}
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	53                   	push   %ebx
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	89 c3                	mov    %eax,%ebx
  800a9e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800aa1:	eb 06                	jmp    800aa9 <strncmp+0x17>
		n--, p++, q++;
  800aa3:	83 c0 01             	add    $0x1,%eax
  800aa6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800aa9:	39 d8                	cmp    %ebx,%eax
  800aab:	74 16                	je     800ac3 <strncmp+0x31>
  800aad:	0f b6 08             	movzbl (%eax),%ecx
  800ab0:	84 c9                	test   %cl,%cl
  800ab2:	74 04                	je     800ab8 <strncmp+0x26>
  800ab4:	3a 0a                	cmp    (%edx),%cl
  800ab6:	74 eb                	je     800aa3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab8:	0f b6 00             	movzbl (%eax),%eax
  800abb:	0f b6 12             	movzbl (%edx),%edx
  800abe:	29 d0                	sub    %edx,%eax
}
  800ac0:	5b                   	pop    %ebx
  800ac1:	5d                   	pop    %ebp
  800ac2:	c3                   	ret    
		return 0;
  800ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac8:	eb f6                	jmp    800ac0 <strncmp+0x2e>

00800aca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad4:	0f b6 10             	movzbl (%eax),%edx
  800ad7:	84 d2                	test   %dl,%dl
  800ad9:	74 09                	je     800ae4 <strchr+0x1a>
		if (*s == c)
  800adb:	38 ca                	cmp    %cl,%dl
  800add:	74 0a                	je     800ae9 <strchr+0x1f>
	for (; *s; s++)
  800adf:	83 c0 01             	add    $0x1,%eax
  800ae2:	eb f0                	jmp    800ad4 <strchr+0xa>
			return (char *) s;
	return 0;
  800ae4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae9:	5d                   	pop    %ebp
  800aea:	c3                   	ret    

00800aeb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800af8:	38 ca                	cmp    %cl,%dl
  800afa:	74 09                	je     800b05 <strfind+0x1a>
  800afc:	84 d2                	test   %dl,%dl
  800afe:	74 05                	je     800b05 <strfind+0x1a>
	for (; *s; s++)
  800b00:	83 c0 01             	add    $0x1,%eax
  800b03:	eb f0                	jmp    800af5 <strfind+0xa>
			break;
	return (char *) s;
}
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	57                   	push   %edi
  800b0b:	56                   	push   %esi
  800b0c:	53                   	push   %ebx
  800b0d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b10:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b13:	85 c9                	test   %ecx,%ecx
  800b15:	74 31                	je     800b48 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b17:	89 f8                	mov    %edi,%eax
  800b19:	09 c8                	or     %ecx,%eax
  800b1b:	a8 03                	test   $0x3,%al
  800b1d:	75 23                	jne    800b42 <memset+0x3b>
		c &= 0xFF;
  800b1f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b23:	89 d3                	mov    %edx,%ebx
  800b25:	c1 e3 08             	shl    $0x8,%ebx
  800b28:	89 d0                	mov    %edx,%eax
  800b2a:	c1 e0 18             	shl    $0x18,%eax
  800b2d:	89 d6                	mov    %edx,%esi
  800b2f:	c1 e6 10             	shl    $0x10,%esi
  800b32:	09 f0                	or     %esi,%eax
  800b34:	09 c2                	or     %eax,%edx
  800b36:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b38:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b3b:	89 d0                	mov    %edx,%eax
  800b3d:	fc                   	cld    
  800b3e:	f3 ab                	rep stos %eax,%es:(%edi)
  800b40:	eb 06                	jmp    800b48 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	fc                   	cld    
  800b46:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b48:	89 f8                	mov    %edi,%eax
  800b4a:	5b                   	pop    %ebx
  800b4b:	5e                   	pop    %esi
  800b4c:	5f                   	pop    %edi
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    

00800b4f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	57                   	push   %edi
  800b53:	56                   	push   %esi
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b5d:	39 c6                	cmp    %eax,%esi
  800b5f:	73 32                	jae    800b93 <memmove+0x44>
  800b61:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b64:	39 c2                	cmp    %eax,%edx
  800b66:	76 2b                	jbe    800b93 <memmove+0x44>
		s += n;
		d += n;
  800b68:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6b:	89 fe                	mov    %edi,%esi
  800b6d:	09 ce                	or     %ecx,%esi
  800b6f:	09 d6                	or     %edx,%esi
  800b71:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b77:	75 0e                	jne    800b87 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b79:	83 ef 04             	sub    $0x4,%edi
  800b7c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b7f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b82:	fd                   	std    
  800b83:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b85:	eb 09                	jmp    800b90 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b87:	83 ef 01             	sub    $0x1,%edi
  800b8a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b8d:	fd                   	std    
  800b8e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b90:	fc                   	cld    
  800b91:	eb 1a                	jmp    800bad <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b93:	89 c2                	mov    %eax,%edx
  800b95:	09 ca                	or     %ecx,%edx
  800b97:	09 f2                	or     %esi,%edx
  800b99:	f6 c2 03             	test   $0x3,%dl
  800b9c:	75 0a                	jne    800ba8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b9e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ba1:	89 c7                	mov    %eax,%edi
  800ba3:	fc                   	cld    
  800ba4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba6:	eb 05                	jmp    800bad <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ba8:	89 c7                	mov    %eax,%edi
  800baa:	fc                   	cld    
  800bab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bad:	5e                   	pop    %esi
  800bae:	5f                   	pop    %edi
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    

00800bb1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bb7:	ff 75 10             	pushl  0x10(%ebp)
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	ff 75 08             	pushl  0x8(%ebp)
  800bc0:	e8 8a ff ff ff       	call   800b4f <memmove>
}
  800bc5:	c9                   	leave  
  800bc6:	c3                   	ret    

00800bc7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd2:	89 c6                	mov    %eax,%esi
  800bd4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bd7:	39 f0                	cmp    %esi,%eax
  800bd9:	74 1c                	je     800bf7 <memcmp+0x30>
		if (*s1 != *s2)
  800bdb:	0f b6 08             	movzbl (%eax),%ecx
  800bde:	0f b6 1a             	movzbl (%edx),%ebx
  800be1:	38 d9                	cmp    %bl,%cl
  800be3:	75 08                	jne    800bed <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800be5:	83 c0 01             	add    $0x1,%eax
  800be8:	83 c2 01             	add    $0x1,%edx
  800beb:	eb ea                	jmp    800bd7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bed:	0f b6 c1             	movzbl %cl,%eax
  800bf0:	0f b6 db             	movzbl %bl,%ebx
  800bf3:	29 d8                	sub    %ebx,%eax
  800bf5:	eb 05                	jmp    800bfc <memcmp+0x35>
	}

	return 0;
  800bf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bfc:	5b                   	pop    %ebx
  800bfd:	5e                   	pop    %esi
  800bfe:	5d                   	pop    %ebp
  800bff:	c3                   	ret    

00800c00 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c09:	89 c2                	mov    %eax,%edx
  800c0b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c0e:	39 d0                	cmp    %edx,%eax
  800c10:	73 09                	jae    800c1b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c12:	38 08                	cmp    %cl,(%eax)
  800c14:	74 05                	je     800c1b <memfind+0x1b>
	for (; s < ends; s++)
  800c16:	83 c0 01             	add    $0x1,%eax
  800c19:	eb f3                	jmp    800c0e <memfind+0xe>
			break;
	return (void *) s;
}
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    

00800c1d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	57                   	push   %edi
  800c21:	56                   	push   %esi
  800c22:	53                   	push   %ebx
  800c23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c26:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c29:	eb 03                	jmp    800c2e <strtol+0x11>
		s++;
  800c2b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c2e:	0f b6 01             	movzbl (%ecx),%eax
  800c31:	3c 20                	cmp    $0x20,%al
  800c33:	74 f6                	je     800c2b <strtol+0xe>
  800c35:	3c 09                	cmp    $0x9,%al
  800c37:	74 f2                	je     800c2b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c39:	3c 2b                	cmp    $0x2b,%al
  800c3b:	74 2a                	je     800c67 <strtol+0x4a>
	int neg = 0;
  800c3d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c42:	3c 2d                	cmp    $0x2d,%al
  800c44:	74 2b                	je     800c71 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c46:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c4c:	75 0f                	jne    800c5d <strtol+0x40>
  800c4e:	80 39 30             	cmpb   $0x30,(%ecx)
  800c51:	74 28                	je     800c7b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c53:	85 db                	test   %ebx,%ebx
  800c55:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c5a:	0f 44 d8             	cmove  %eax,%ebx
  800c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c62:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c65:	eb 50                	jmp    800cb7 <strtol+0x9a>
		s++;
  800c67:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c6a:	bf 00 00 00 00       	mov    $0x0,%edi
  800c6f:	eb d5                	jmp    800c46 <strtol+0x29>
		s++, neg = 1;
  800c71:	83 c1 01             	add    $0x1,%ecx
  800c74:	bf 01 00 00 00       	mov    $0x1,%edi
  800c79:	eb cb                	jmp    800c46 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c7b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c7f:	74 0e                	je     800c8f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c81:	85 db                	test   %ebx,%ebx
  800c83:	75 d8                	jne    800c5d <strtol+0x40>
		s++, base = 8;
  800c85:	83 c1 01             	add    $0x1,%ecx
  800c88:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c8d:	eb ce                	jmp    800c5d <strtol+0x40>
		s += 2, base = 16;
  800c8f:	83 c1 02             	add    $0x2,%ecx
  800c92:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c97:	eb c4                	jmp    800c5d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c99:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c9c:	89 f3                	mov    %esi,%ebx
  800c9e:	80 fb 19             	cmp    $0x19,%bl
  800ca1:	77 29                	ja     800ccc <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ca3:	0f be d2             	movsbl %dl,%edx
  800ca6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ca9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cac:	7d 30                	jge    800cde <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cae:	83 c1 01             	add    $0x1,%ecx
  800cb1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cb5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cb7:	0f b6 11             	movzbl (%ecx),%edx
  800cba:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cbd:	89 f3                	mov    %esi,%ebx
  800cbf:	80 fb 09             	cmp    $0x9,%bl
  800cc2:	77 d5                	ja     800c99 <strtol+0x7c>
			dig = *s - '0';
  800cc4:	0f be d2             	movsbl %dl,%edx
  800cc7:	83 ea 30             	sub    $0x30,%edx
  800cca:	eb dd                	jmp    800ca9 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ccc:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ccf:	89 f3                	mov    %esi,%ebx
  800cd1:	80 fb 19             	cmp    $0x19,%bl
  800cd4:	77 08                	ja     800cde <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cd6:	0f be d2             	movsbl %dl,%edx
  800cd9:	83 ea 37             	sub    $0x37,%edx
  800cdc:	eb cb                	jmp    800ca9 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce2:	74 05                	je     800ce9 <strtol+0xcc>
		*endptr = (char *) s;
  800ce4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ce9:	89 c2                	mov    %eax,%edx
  800ceb:	f7 da                	neg    %edx
  800ced:	85 ff                	test   %edi,%edi
  800cef:	0f 45 c2             	cmovne %edx,%eax
}
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5f                   	pop    %edi
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	57                   	push   %edi
  800cfb:	56                   	push   %esi
  800cfc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  800d02:	8b 55 08             	mov    0x8(%ebp),%edx
  800d05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d08:	89 c3                	mov    %eax,%ebx
  800d0a:	89 c7                	mov    %eax,%edi
  800d0c:	89 c6                	mov    %eax,%esi
  800d0e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d10:	5b                   	pop    %ebx
  800d11:	5e                   	pop    %esi
  800d12:	5f                   	pop    %edi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    

00800d15 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	57                   	push   %edi
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d20:	b8 01 00 00 00       	mov    $0x1,%eax
  800d25:	89 d1                	mov    %edx,%ecx
  800d27:	89 d3                	mov    %edx,%ebx
  800d29:	89 d7                	mov    %edx,%edi
  800d2b:	89 d6                	mov    %edx,%esi
  800d2d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
  800d3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d42:	8b 55 08             	mov    0x8(%ebp),%edx
  800d45:	b8 03 00 00 00       	mov    $0x3,%eax
  800d4a:	89 cb                	mov    %ecx,%ebx
  800d4c:	89 cf                	mov    %ecx,%edi
  800d4e:	89 ce                	mov    %ecx,%esi
  800d50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d52:	85 c0                	test   %eax,%eax
  800d54:	7f 08                	jg     800d5e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d59:	5b                   	pop    %ebx
  800d5a:	5e                   	pop    %esi
  800d5b:	5f                   	pop    %edi
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5e:	83 ec 0c             	sub    $0xc,%esp
  800d61:	50                   	push   %eax
  800d62:	6a 03                	push   $0x3
  800d64:	68 88 2f 80 00       	push   $0x802f88
  800d69:	6a 43                	push   $0x43
  800d6b:	68 a5 2f 80 00       	push   $0x802fa5
  800d70:	e8 6c 1a 00 00       	call   8027e1 <_panic>

00800d75 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d80:	b8 02 00 00 00       	mov    $0x2,%eax
  800d85:	89 d1                	mov    %edx,%ecx
  800d87:	89 d3                	mov    %edx,%ebx
  800d89:	89 d7                	mov    %edx,%edi
  800d8b:	89 d6                	mov    %edx,%esi
  800d8d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d8f:	5b                   	pop    %ebx
  800d90:	5e                   	pop    %esi
  800d91:	5f                   	pop    %edi
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <sys_yield>:

void
sys_yield(void)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	57                   	push   %edi
  800d98:	56                   	push   %esi
  800d99:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800da4:	89 d1                	mov    %edx,%ecx
  800da6:	89 d3                	mov    %edx,%ebx
  800da8:	89 d7                	mov    %edx,%edi
  800daa:	89 d6                	mov    %edx,%esi
  800dac:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dae:	5b                   	pop    %ebx
  800daf:	5e                   	pop    %esi
  800db0:	5f                   	pop    %edi
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
  800db9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbc:	be 00 00 00 00       	mov    $0x0,%esi
  800dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc7:	b8 04 00 00 00       	mov    $0x4,%eax
  800dcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dcf:	89 f7                	mov    %esi,%edi
  800dd1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	7f 08                	jg     800ddf <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dda:	5b                   	pop    %ebx
  800ddb:	5e                   	pop    %esi
  800ddc:	5f                   	pop    %edi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	50                   	push   %eax
  800de3:	6a 04                	push   $0x4
  800de5:	68 88 2f 80 00       	push   $0x802f88
  800dea:	6a 43                	push   $0x43
  800dec:	68 a5 2f 80 00       	push   $0x802fa5
  800df1:	e8 eb 19 00 00       	call   8027e1 <_panic>

00800df6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	57                   	push   %edi
  800dfa:	56                   	push   %esi
  800dfb:	53                   	push   %ebx
  800dfc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dff:	8b 55 08             	mov    0x8(%ebp),%edx
  800e02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e05:	b8 05 00 00 00       	mov    $0x5,%eax
  800e0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e0d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e10:	8b 75 18             	mov    0x18(%ebp),%esi
  800e13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e15:	85 c0                	test   %eax,%eax
  800e17:	7f 08                	jg     800e21 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1c:	5b                   	pop    %ebx
  800e1d:	5e                   	pop    %esi
  800e1e:	5f                   	pop    %edi
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e21:	83 ec 0c             	sub    $0xc,%esp
  800e24:	50                   	push   %eax
  800e25:	6a 05                	push   $0x5
  800e27:	68 88 2f 80 00       	push   $0x802f88
  800e2c:	6a 43                	push   $0x43
  800e2e:	68 a5 2f 80 00       	push   $0x802fa5
  800e33:	e8 a9 19 00 00       	call   8027e1 <_panic>

00800e38 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	57                   	push   %edi
  800e3c:	56                   	push   %esi
  800e3d:	53                   	push   %ebx
  800e3e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e41:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e46:	8b 55 08             	mov    0x8(%ebp),%edx
  800e49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4c:	b8 06 00 00 00       	mov    $0x6,%eax
  800e51:	89 df                	mov    %ebx,%edi
  800e53:	89 de                	mov    %ebx,%esi
  800e55:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e57:	85 c0                	test   %eax,%eax
  800e59:	7f 08                	jg     800e63 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e63:	83 ec 0c             	sub    $0xc,%esp
  800e66:	50                   	push   %eax
  800e67:	6a 06                	push   $0x6
  800e69:	68 88 2f 80 00       	push   $0x802f88
  800e6e:	6a 43                	push   $0x43
  800e70:	68 a5 2f 80 00       	push   $0x802fa5
  800e75:	e8 67 19 00 00       	call   8027e1 <_panic>

00800e7a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	57                   	push   %edi
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
  800e80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e88:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8e:	b8 08 00 00 00       	mov    $0x8,%eax
  800e93:	89 df                	mov    %ebx,%edi
  800e95:	89 de                	mov    %ebx,%esi
  800e97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	7f 08                	jg     800ea5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea0:	5b                   	pop    %ebx
  800ea1:	5e                   	pop    %esi
  800ea2:	5f                   	pop    %edi
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea5:	83 ec 0c             	sub    $0xc,%esp
  800ea8:	50                   	push   %eax
  800ea9:	6a 08                	push   $0x8
  800eab:	68 88 2f 80 00       	push   $0x802f88
  800eb0:	6a 43                	push   $0x43
  800eb2:	68 a5 2f 80 00       	push   $0x802fa5
  800eb7:	e8 25 19 00 00       	call   8027e1 <_panic>

00800ebc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	57                   	push   %edi
  800ec0:	56                   	push   %esi
  800ec1:	53                   	push   %ebx
  800ec2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eca:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed0:	b8 09 00 00 00       	mov    $0x9,%eax
  800ed5:	89 df                	mov    %ebx,%edi
  800ed7:	89 de                	mov    %ebx,%esi
  800ed9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800edb:	85 c0                	test   %eax,%eax
  800edd:	7f 08                	jg     800ee7 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800edf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee2:	5b                   	pop    %ebx
  800ee3:	5e                   	pop    %esi
  800ee4:	5f                   	pop    %edi
  800ee5:	5d                   	pop    %ebp
  800ee6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee7:	83 ec 0c             	sub    $0xc,%esp
  800eea:	50                   	push   %eax
  800eeb:	6a 09                	push   $0x9
  800eed:	68 88 2f 80 00       	push   $0x802f88
  800ef2:	6a 43                	push   $0x43
  800ef4:	68 a5 2f 80 00       	push   $0x802fa5
  800ef9:	e8 e3 18 00 00       	call   8027e1 <_panic>

00800efe <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	57                   	push   %edi
  800f02:	56                   	push   %esi
  800f03:	53                   	push   %ebx
  800f04:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f07:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f12:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f17:	89 df                	mov    %ebx,%edi
  800f19:	89 de                	mov    %ebx,%esi
  800f1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f1d:	85 c0                	test   %eax,%eax
  800f1f:	7f 08                	jg     800f29 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f24:	5b                   	pop    %ebx
  800f25:	5e                   	pop    %esi
  800f26:	5f                   	pop    %edi
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f29:	83 ec 0c             	sub    $0xc,%esp
  800f2c:	50                   	push   %eax
  800f2d:	6a 0a                	push   $0xa
  800f2f:	68 88 2f 80 00       	push   $0x802f88
  800f34:	6a 43                	push   $0x43
  800f36:	68 a5 2f 80 00       	push   $0x802fa5
  800f3b:	e8 a1 18 00 00       	call   8027e1 <_panic>

00800f40 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	57                   	push   %edi
  800f44:	56                   	push   %esi
  800f45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f46:	8b 55 08             	mov    0x8(%ebp),%edx
  800f49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f51:	be 00 00 00 00       	mov    $0x0,%esi
  800f56:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f59:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f5c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	57                   	push   %edi
  800f67:	56                   	push   %esi
  800f68:	53                   	push   %ebx
  800f69:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f71:	8b 55 08             	mov    0x8(%ebp),%edx
  800f74:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f79:	89 cb                	mov    %ecx,%ebx
  800f7b:	89 cf                	mov    %ecx,%edi
  800f7d:	89 ce                	mov    %ecx,%esi
  800f7f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	7f 08                	jg     800f8d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f88:	5b                   	pop    %ebx
  800f89:	5e                   	pop    %esi
  800f8a:	5f                   	pop    %edi
  800f8b:	5d                   	pop    %ebp
  800f8c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8d:	83 ec 0c             	sub    $0xc,%esp
  800f90:	50                   	push   %eax
  800f91:	6a 0d                	push   $0xd
  800f93:	68 88 2f 80 00       	push   $0x802f88
  800f98:	6a 43                	push   $0x43
  800f9a:	68 a5 2f 80 00       	push   $0x802fa5
  800f9f:	e8 3d 18 00 00       	call   8027e1 <_panic>

00800fa4 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	57                   	push   %edi
  800fa8:	56                   	push   %esi
  800fa9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800faa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800faf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb5:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fba:	89 df                	mov    %ebx,%edi
  800fbc:	89 de                	mov    %ebx,%esi
  800fbe:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fc0:	5b                   	pop    %ebx
  800fc1:	5e                   	pop    %esi
  800fc2:	5f                   	pop    %edi
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    

00800fc5 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	57                   	push   %edi
  800fc9:	56                   	push   %esi
  800fca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd3:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fd8:	89 cb                	mov    %ecx,%ebx
  800fda:	89 cf                	mov    %ecx,%edi
  800fdc:	89 ce                	mov    %ecx,%esi
  800fde:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fe0:	5b                   	pop    %ebx
  800fe1:	5e                   	pop    %esi
  800fe2:	5f                   	pop    %edi
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	57                   	push   %edi
  800fe9:	56                   	push   %esi
  800fea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800feb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff0:	b8 10 00 00 00       	mov    $0x10,%eax
  800ff5:	89 d1                	mov    %edx,%ecx
  800ff7:	89 d3                	mov    %edx,%ebx
  800ff9:	89 d7                	mov    %edx,%edi
  800ffb:	89 d6                	mov    %edx,%esi
  800ffd:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fff:	5b                   	pop    %ebx
  801000:	5e                   	pop    %esi
  801001:	5f                   	pop    %edi
  801002:	5d                   	pop    %ebp
  801003:	c3                   	ret    

00801004 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	57                   	push   %edi
  801008:	56                   	push   %esi
  801009:	53                   	push   %ebx
	asm volatile("int %1\n"
  80100a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100f:	8b 55 08             	mov    0x8(%ebp),%edx
  801012:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801015:	b8 11 00 00 00       	mov    $0x11,%eax
  80101a:	89 df                	mov    %ebx,%edi
  80101c:	89 de                	mov    %ebx,%esi
  80101e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801020:	5b                   	pop    %ebx
  801021:	5e                   	pop    %esi
  801022:	5f                   	pop    %edi
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    

00801025 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	57                   	push   %edi
  801029:	56                   	push   %esi
  80102a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80102b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801030:	8b 55 08             	mov    0x8(%ebp),%edx
  801033:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801036:	b8 12 00 00 00       	mov    $0x12,%eax
  80103b:	89 df                	mov    %ebx,%edi
  80103d:	89 de                	mov    %ebx,%esi
  80103f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801041:	5b                   	pop    %ebx
  801042:	5e                   	pop    %esi
  801043:	5f                   	pop    %edi
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    

00801046 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	57                   	push   %edi
  80104a:	56                   	push   %esi
  80104b:	53                   	push   %ebx
  80104c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80104f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801054:	8b 55 08             	mov    0x8(%ebp),%edx
  801057:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105a:	b8 13 00 00 00       	mov    $0x13,%eax
  80105f:	89 df                	mov    %ebx,%edi
  801061:	89 de                	mov    %ebx,%esi
  801063:	cd 30                	int    $0x30
	if(check && ret > 0)
  801065:	85 c0                	test   %eax,%eax
  801067:	7f 08                	jg     801071 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801069:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106c:	5b                   	pop    %ebx
  80106d:	5e                   	pop    %esi
  80106e:	5f                   	pop    %edi
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801071:	83 ec 0c             	sub    $0xc,%esp
  801074:	50                   	push   %eax
  801075:	6a 13                	push   $0x13
  801077:	68 88 2f 80 00       	push   $0x802f88
  80107c:	6a 43                	push   $0x43
  80107e:	68 a5 2f 80 00       	push   $0x802fa5
  801083:	e8 59 17 00 00       	call   8027e1 <_panic>

00801088 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	57                   	push   %edi
  80108c:	56                   	push   %esi
  80108d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80108e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
  801096:	b8 14 00 00 00       	mov    $0x14,%eax
  80109b:	89 cb                	mov    %ecx,%ebx
  80109d:	89 cf                	mov    %ecx,%edi
  80109f:	89 ce                	mov    %ecx,%esi
  8010a1:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010a3:	5b                   	pop    %ebx
  8010a4:	5e                   	pop    %esi
  8010a5:	5f                   	pop    %edi
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    

008010a8 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	53                   	push   %ebx
  8010ac:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8010af:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010b6:	f6 c5 04             	test   $0x4,%ch
  8010b9:	75 45                	jne    801100 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8010bb:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010c2:	83 e1 07             	and    $0x7,%ecx
  8010c5:	83 f9 07             	cmp    $0x7,%ecx
  8010c8:	74 6f                	je     801139 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8010ca:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010d1:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8010d7:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8010dd:	0f 84 b6 00 00 00    	je     801199 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8010e3:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010ea:	83 e1 05             	and    $0x5,%ecx
  8010ed:	83 f9 05             	cmp    $0x5,%ecx
  8010f0:	0f 84 d7 00 00 00    	je     8011cd <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8010f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010fe:	c9                   	leave  
  8010ff:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801100:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801107:	c1 e2 0c             	shl    $0xc,%edx
  80110a:	83 ec 0c             	sub    $0xc,%esp
  80110d:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801113:	51                   	push   %ecx
  801114:	52                   	push   %edx
  801115:	50                   	push   %eax
  801116:	52                   	push   %edx
  801117:	6a 00                	push   $0x0
  801119:	e8 d8 fc ff ff       	call   800df6 <sys_page_map>
		if(r < 0)
  80111e:	83 c4 20             	add    $0x20,%esp
  801121:	85 c0                	test   %eax,%eax
  801123:	79 d1                	jns    8010f6 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801125:	83 ec 04             	sub    $0x4,%esp
  801128:	68 b3 2f 80 00       	push   $0x802fb3
  80112d:	6a 54                	push   $0x54
  80112f:	68 c9 2f 80 00       	push   $0x802fc9
  801134:	e8 a8 16 00 00       	call   8027e1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801139:	89 d3                	mov    %edx,%ebx
  80113b:	c1 e3 0c             	shl    $0xc,%ebx
  80113e:	83 ec 0c             	sub    $0xc,%esp
  801141:	68 05 08 00 00       	push   $0x805
  801146:	53                   	push   %ebx
  801147:	50                   	push   %eax
  801148:	53                   	push   %ebx
  801149:	6a 00                	push   $0x0
  80114b:	e8 a6 fc ff ff       	call   800df6 <sys_page_map>
		if(r < 0)
  801150:	83 c4 20             	add    $0x20,%esp
  801153:	85 c0                	test   %eax,%eax
  801155:	78 2e                	js     801185 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801157:	83 ec 0c             	sub    $0xc,%esp
  80115a:	68 05 08 00 00       	push   $0x805
  80115f:	53                   	push   %ebx
  801160:	6a 00                	push   $0x0
  801162:	53                   	push   %ebx
  801163:	6a 00                	push   $0x0
  801165:	e8 8c fc ff ff       	call   800df6 <sys_page_map>
		if(r < 0)
  80116a:	83 c4 20             	add    $0x20,%esp
  80116d:	85 c0                	test   %eax,%eax
  80116f:	79 85                	jns    8010f6 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801171:	83 ec 04             	sub    $0x4,%esp
  801174:	68 b3 2f 80 00       	push   $0x802fb3
  801179:	6a 5f                	push   $0x5f
  80117b:	68 c9 2f 80 00       	push   $0x802fc9
  801180:	e8 5c 16 00 00       	call   8027e1 <_panic>
			panic("sys_page_map() panic\n");
  801185:	83 ec 04             	sub    $0x4,%esp
  801188:	68 b3 2f 80 00       	push   $0x802fb3
  80118d:	6a 5b                	push   $0x5b
  80118f:	68 c9 2f 80 00       	push   $0x802fc9
  801194:	e8 48 16 00 00       	call   8027e1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801199:	c1 e2 0c             	shl    $0xc,%edx
  80119c:	83 ec 0c             	sub    $0xc,%esp
  80119f:	68 05 08 00 00       	push   $0x805
  8011a4:	52                   	push   %edx
  8011a5:	50                   	push   %eax
  8011a6:	52                   	push   %edx
  8011a7:	6a 00                	push   $0x0
  8011a9:	e8 48 fc ff ff       	call   800df6 <sys_page_map>
		if(r < 0)
  8011ae:	83 c4 20             	add    $0x20,%esp
  8011b1:	85 c0                	test   %eax,%eax
  8011b3:	0f 89 3d ff ff ff    	jns    8010f6 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011b9:	83 ec 04             	sub    $0x4,%esp
  8011bc:	68 b3 2f 80 00       	push   $0x802fb3
  8011c1:	6a 66                	push   $0x66
  8011c3:	68 c9 2f 80 00       	push   $0x802fc9
  8011c8:	e8 14 16 00 00       	call   8027e1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011cd:	c1 e2 0c             	shl    $0xc,%edx
  8011d0:	83 ec 0c             	sub    $0xc,%esp
  8011d3:	6a 05                	push   $0x5
  8011d5:	52                   	push   %edx
  8011d6:	50                   	push   %eax
  8011d7:	52                   	push   %edx
  8011d8:	6a 00                	push   $0x0
  8011da:	e8 17 fc ff ff       	call   800df6 <sys_page_map>
		if(r < 0)
  8011df:	83 c4 20             	add    $0x20,%esp
  8011e2:	85 c0                	test   %eax,%eax
  8011e4:	0f 89 0c ff ff ff    	jns    8010f6 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011ea:	83 ec 04             	sub    $0x4,%esp
  8011ed:	68 b3 2f 80 00       	push   $0x802fb3
  8011f2:	6a 6d                	push   $0x6d
  8011f4:	68 c9 2f 80 00       	push   $0x802fc9
  8011f9:	e8 e3 15 00 00       	call   8027e1 <_panic>

008011fe <pgfault>:
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	53                   	push   %ebx
  801202:	83 ec 04             	sub    $0x4,%esp
  801205:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801208:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80120a:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80120e:	0f 84 99 00 00 00    	je     8012ad <pgfault+0xaf>
  801214:	89 c2                	mov    %eax,%edx
  801216:	c1 ea 16             	shr    $0x16,%edx
  801219:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801220:	f6 c2 01             	test   $0x1,%dl
  801223:	0f 84 84 00 00 00    	je     8012ad <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801229:	89 c2                	mov    %eax,%edx
  80122b:	c1 ea 0c             	shr    $0xc,%edx
  80122e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801235:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80123b:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801241:	75 6a                	jne    8012ad <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801243:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801248:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80124a:	83 ec 04             	sub    $0x4,%esp
  80124d:	6a 07                	push   $0x7
  80124f:	68 00 f0 7f 00       	push   $0x7ff000
  801254:	6a 00                	push   $0x0
  801256:	e8 58 fb ff ff       	call   800db3 <sys_page_alloc>
	if(ret < 0)
  80125b:	83 c4 10             	add    $0x10,%esp
  80125e:	85 c0                	test   %eax,%eax
  801260:	78 5f                	js     8012c1 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801262:	83 ec 04             	sub    $0x4,%esp
  801265:	68 00 10 00 00       	push   $0x1000
  80126a:	53                   	push   %ebx
  80126b:	68 00 f0 7f 00       	push   $0x7ff000
  801270:	e8 3c f9 ff ff       	call   800bb1 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801275:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80127c:	53                   	push   %ebx
  80127d:	6a 00                	push   $0x0
  80127f:	68 00 f0 7f 00       	push   $0x7ff000
  801284:	6a 00                	push   $0x0
  801286:	e8 6b fb ff ff       	call   800df6 <sys_page_map>
	if(ret < 0)
  80128b:	83 c4 20             	add    $0x20,%esp
  80128e:	85 c0                	test   %eax,%eax
  801290:	78 43                	js     8012d5 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801292:	83 ec 08             	sub    $0x8,%esp
  801295:	68 00 f0 7f 00       	push   $0x7ff000
  80129a:	6a 00                	push   $0x0
  80129c:	e8 97 fb ff ff       	call   800e38 <sys_page_unmap>
	if(ret < 0)
  8012a1:	83 c4 10             	add    $0x10,%esp
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	78 41                	js     8012e9 <pgfault+0xeb>
}
  8012a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    
		panic("panic at pgfault()\n");
  8012ad:	83 ec 04             	sub    $0x4,%esp
  8012b0:	68 d4 2f 80 00       	push   $0x802fd4
  8012b5:	6a 26                	push   $0x26
  8012b7:	68 c9 2f 80 00       	push   $0x802fc9
  8012bc:	e8 20 15 00 00       	call   8027e1 <_panic>
		panic("panic in sys_page_alloc()\n");
  8012c1:	83 ec 04             	sub    $0x4,%esp
  8012c4:	68 e8 2f 80 00       	push   $0x802fe8
  8012c9:	6a 31                	push   $0x31
  8012cb:	68 c9 2f 80 00       	push   $0x802fc9
  8012d0:	e8 0c 15 00 00       	call   8027e1 <_panic>
		panic("panic in sys_page_map()\n");
  8012d5:	83 ec 04             	sub    $0x4,%esp
  8012d8:	68 03 30 80 00       	push   $0x803003
  8012dd:	6a 36                	push   $0x36
  8012df:	68 c9 2f 80 00       	push   $0x802fc9
  8012e4:	e8 f8 14 00 00       	call   8027e1 <_panic>
		panic("panic in sys_page_unmap()\n");
  8012e9:	83 ec 04             	sub    $0x4,%esp
  8012ec:	68 1c 30 80 00       	push   $0x80301c
  8012f1:	6a 39                	push   $0x39
  8012f3:	68 c9 2f 80 00       	push   $0x802fc9
  8012f8:	e8 e4 14 00 00       	call   8027e1 <_panic>

008012fd <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	57                   	push   %edi
  801301:	56                   	push   %esi
  801302:	53                   	push   %ebx
  801303:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801306:	68 fe 11 80 00       	push   $0x8011fe
  80130b:	e8 32 15 00 00       	call   802842 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801310:	b8 07 00 00 00       	mov    $0x7,%eax
  801315:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	85 c0                	test   %eax,%eax
  80131c:	78 27                	js     801345 <fork+0x48>
  80131e:	89 c6                	mov    %eax,%esi
  801320:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801322:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801327:	75 48                	jne    801371 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801329:	e8 47 fa ff ff       	call   800d75 <sys_getenvid>
  80132e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801333:	c1 e0 07             	shl    $0x7,%eax
  801336:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80133b:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801340:	e9 90 00 00 00       	jmp    8013d5 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801345:	83 ec 04             	sub    $0x4,%esp
  801348:	68 38 30 80 00       	push   $0x803038
  80134d:	68 8c 00 00 00       	push   $0x8c
  801352:	68 c9 2f 80 00       	push   $0x802fc9
  801357:	e8 85 14 00 00       	call   8027e1 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80135c:	89 f8                	mov    %edi,%eax
  80135e:	e8 45 fd ff ff       	call   8010a8 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801363:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801369:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80136f:	74 26                	je     801397 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801371:	89 d8                	mov    %ebx,%eax
  801373:	c1 e8 16             	shr    $0x16,%eax
  801376:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80137d:	a8 01                	test   $0x1,%al
  80137f:	74 e2                	je     801363 <fork+0x66>
  801381:	89 da                	mov    %ebx,%edx
  801383:	c1 ea 0c             	shr    $0xc,%edx
  801386:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80138d:	83 e0 05             	and    $0x5,%eax
  801390:	83 f8 05             	cmp    $0x5,%eax
  801393:	75 ce                	jne    801363 <fork+0x66>
  801395:	eb c5                	jmp    80135c <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801397:	83 ec 04             	sub    $0x4,%esp
  80139a:	6a 07                	push   $0x7
  80139c:	68 00 f0 bf ee       	push   $0xeebff000
  8013a1:	56                   	push   %esi
  8013a2:	e8 0c fa ff ff       	call   800db3 <sys_page_alloc>
	if(ret < 0)
  8013a7:	83 c4 10             	add    $0x10,%esp
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	78 31                	js     8013df <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013ae:	83 ec 08             	sub    $0x8,%esp
  8013b1:	68 b1 28 80 00       	push   $0x8028b1
  8013b6:	56                   	push   %esi
  8013b7:	e8 42 fb ff ff       	call   800efe <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013bc:	83 c4 10             	add    $0x10,%esp
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	78 33                	js     8013f6 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013c3:	83 ec 08             	sub    $0x8,%esp
  8013c6:	6a 02                	push   $0x2
  8013c8:	56                   	push   %esi
  8013c9:	e8 ac fa ff ff       	call   800e7a <sys_env_set_status>
	if(ret < 0)
  8013ce:	83 c4 10             	add    $0x10,%esp
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	78 38                	js     80140d <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013d5:	89 f0                	mov    %esi,%eax
  8013d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013da:	5b                   	pop    %ebx
  8013db:	5e                   	pop    %esi
  8013dc:	5f                   	pop    %edi
  8013dd:	5d                   	pop    %ebp
  8013de:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013df:	83 ec 04             	sub    $0x4,%esp
  8013e2:	68 e8 2f 80 00       	push   $0x802fe8
  8013e7:	68 98 00 00 00       	push   $0x98
  8013ec:	68 c9 2f 80 00       	push   $0x802fc9
  8013f1:	e8 eb 13 00 00       	call   8027e1 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8013f6:	83 ec 04             	sub    $0x4,%esp
  8013f9:	68 5c 30 80 00       	push   $0x80305c
  8013fe:	68 9b 00 00 00       	push   $0x9b
  801403:	68 c9 2f 80 00       	push   $0x802fc9
  801408:	e8 d4 13 00 00       	call   8027e1 <_panic>
		panic("panic in sys_env_set_status()\n");
  80140d:	83 ec 04             	sub    $0x4,%esp
  801410:	68 84 30 80 00       	push   $0x803084
  801415:	68 9e 00 00 00       	push   $0x9e
  80141a:	68 c9 2f 80 00       	push   $0x802fc9
  80141f:	e8 bd 13 00 00       	call   8027e1 <_panic>

00801424 <sfork>:

// Challenge!
int
sfork(void)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	57                   	push   %edi
  801428:	56                   	push   %esi
  801429:	53                   	push   %ebx
  80142a:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  80142d:	68 fe 11 80 00       	push   $0x8011fe
  801432:	e8 0b 14 00 00       	call   802842 <set_pgfault_handler>
  801437:	b8 07 00 00 00       	mov    $0x7,%eax
  80143c:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80143e:	83 c4 10             	add    $0x10,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	78 27                	js     80146c <sfork+0x48>
  801445:	89 c7                	mov    %eax,%edi
  801447:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801449:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80144e:	75 55                	jne    8014a5 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801450:	e8 20 f9 ff ff       	call   800d75 <sys_getenvid>
  801455:	25 ff 03 00 00       	and    $0x3ff,%eax
  80145a:	c1 e0 07             	shl    $0x7,%eax
  80145d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801462:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801467:	e9 d4 00 00 00       	jmp    801540 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  80146c:	83 ec 04             	sub    $0x4,%esp
  80146f:	68 38 30 80 00       	push   $0x803038
  801474:	68 af 00 00 00       	push   $0xaf
  801479:	68 c9 2f 80 00       	push   $0x802fc9
  80147e:	e8 5e 13 00 00       	call   8027e1 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801483:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801488:	89 f0                	mov    %esi,%eax
  80148a:	e8 19 fc ff ff       	call   8010a8 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80148f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801495:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80149b:	77 65                	ja     801502 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  80149d:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8014a3:	74 de                	je     801483 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8014a5:	89 d8                	mov    %ebx,%eax
  8014a7:	c1 e8 16             	shr    $0x16,%eax
  8014aa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014b1:	a8 01                	test   $0x1,%al
  8014b3:	74 da                	je     80148f <sfork+0x6b>
  8014b5:	89 da                	mov    %ebx,%edx
  8014b7:	c1 ea 0c             	shr    $0xc,%edx
  8014ba:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014c1:	83 e0 05             	and    $0x5,%eax
  8014c4:	83 f8 05             	cmp    $0x5,%eax
  8014c7:	75 c6                	jne    80148f <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014c9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014d0:	c1 e2 0c             	shl    $0xc,%edx
  8014d3:	83 ec 0c             	sub    $0xc,%esp
  8014d6:	83 e0 07             	and    $0x7,%eax
  8014d9:	50                   	push   %eax
  8014da:	52                   	push   %edx
  8014db:	56                   	push   %esi
  8014dc:	52                   	push   %edx
  8014dd:	6a 00                	push   $0x0
  8014df:	e8 12 f9 ff ff       	call   800df6 <sys_page_map>
  8014e4:	83 c4 20             	add    $0x20,%esp
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	74 a4                	je     80148f <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8014eb:	83 ec 04             	sub    $0x4,%esp
  8014ee:	68 b3 2f 80 00       	push   $0x802fb3
  8014f3:	68 ba 00 00 00       	push   $0xba
  8014f8:	68 c9 2f 80 00       	push   $0x802fc9
  8014fd:	e8 df 12 00 00       	call   8027e1 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801502:	83 ec 04             	sub    $0x4,%esp
  801505:	6a 07                	push   $0x7
  801507:	68 00 f0 bf ee       	push   $0xeebff000
  80150c:	57                   	push   %edi
  80150d:	e8 a1 f8 ff ff       	call   800db3 <sys_page_alloc>
	if(ret < 0)
  801512:	83 c4 10             	add    $0x10,%esp
  801515:	85 c0                	test   %eax,%eax
  801517:	78 31                	js     80154a <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801519:	83 ec 08             	sub    $0x8,%esp
  80151c:	68 b1 28 80 00       	push   $0x8028b1
  801521:	57                   	push   %edi
  801522:	e8 d7 f9 ff ff       	call   800efe <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	85 c0                	test   %eax,%eax
  80152c:	78 33                	js     801561 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80152e:	83 ec 08             	sub    $0x8,%esp
  801531:	6a 02                	push   $0x2
  801533:	57                   	push   %edi
  801534:	e8 41 f9 ff ff       	call   800e7a <sys_env_set_status>
	if(ret < 0)
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 38                	js     801578 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801540:	89 f8                	mov    %edi,%eax
  801542:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801545:	5b                   	pop    %ebx
  801546:	5e                   	pop    %esi
  801547:	5f                   	pop    %edi
  801548:	5d                   	pop    %ebp
  801549:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80154a:	83 ec 04             	sub    $0x4,%esp
  80154d:	68 e8 2f 80 00       	push   $0x802fe8
  801552:	68 c0 00 00 00       	push   $0xc0
  801557:	68 c9 2f 80 00       	push   $0x802fc9
  80155c:	e8 80 12 00 00       	call   8027e1 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801561:	83 ec 04             	sub    $0x4,%esp
  801564:	68 5c 30 80 00       	push   $0x80305c
  801569:	68 c3 00 00 00       	push   $0xc3
  80156e:	68 c9 2f 80 00       	push   $0x802fc9
  801573:	e8 69 12 00 00       	call   8027e1 <_panic>
		panic("panic in sys_env_set_status()\n");
  801578:	83 ec 04             	sub    $0x4,%esp
  80157b:	68 84 30 80 00       	push   $0x803084
  801580:	68 c6 00 00 00       	push   $0xc6
  801585:	68 c9 2f 80 00       	push   $0x802fc9
  80158a:	e8 52 12 00 00       	call   8027e1 <_panic>

0080158f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	56                   	push   %esi
  801593:	53                   	push   %ebx
  801594:	8b 75 08             	mov    0x8(%ebp),%esi
  801597:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80159d:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80159f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8015a4:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8015a7:	83 ec 0c             	sub    $0xc,%esp
  8015aa:	50                   	push   %eax
  8015ab:	e8 b3 f9 ff ff       	call   800f63 <sys_ipc_recv>
	if(ret < 0){
  8015b0:	83 c4 10             	add    $0x10,%esp
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	78 2b                	js     8015e2 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8015b7:	85 f6                	test   %esi,%esi
  8015b9:	74 0a                	je     8015c5 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8015bb:	a1 08 50 80 00       	mov    0x805008,%eax
  8015c0:	8b 40 74             	mov    0x74(%eax),%eax
  8015c3:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8015c5:	85 db                	test   %ebx,%ebx
  8015c7:	74 0a                	je     8015d3 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8015c9:	a1 08 50 80 00       	mov    0x805008,%eax
  8015ce:	8b 40 78             	mov    0x78(%eax),%eax
  8015d1:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8015d3:	a1 08 50 80 00       	mov    0x805008,%eax
  8015d8:	8b 40 70             	mov    0x70(%eax),%eax
}
  8015db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015de:	5b                   	pop    %ebx
  8015df:	5e                   	pop    %esi
  8015e0:	5d                   	pop    %ebp
  8015e1:	c3                   	ret    
		if(from_env_store)
  8015e2:	85 f6                	test   %esi,%esi
  8015e4:	74 06                	je     8015ec <ipc_recv+0x5d>
			*from_env_store = 0;
  8015e6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8015ec:	85 db                	test   %ebx,%ebx
  8015ee:	74 eb                	je     8015db <ipc_recv+0x4c>
			*perm_store = 0;
  8015f0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8015f6:	eb e3                	jmp    8015db <ipc_recv+0x4c>

008015f8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	57                   	push   %edi
  8015fc:	56                   	push   %esi
  8015fd:	53                   	push   %ebx
  8015fe:	83 ec 0c             	sub    $0xc,%esp
  801601:	8b 7d 08             	mov    0x8(%ebp),%edi
  801604:	8b 75 0c             	mov    0xc(%ebp),%esi
  801607:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80160a:	85 db                	test   %ebx,%ebx
  80160c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801611:	0f 44 d8             	cmove  %eax,%ebx
  801614:	eb 05                	jmp    80161b <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801616:	e8 79 f7 ff ff       	call   800d94 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80161b:	ff 75 14             	pushl  0x14(%ebp)
  80161e:	53                   	push   %ebx
  80161f:	56                   	push   %esi
  801620:	57                   	push   %edi
  801621:	e8 1a f9 ff ff       	call   800f40 <sys_ipc_try_send>
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	85 c0                	test   %eax,%eax
  80162b:	74 1b                	je     801648 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80162d:	79 e7                	jns    801616 <ipc_send+0x1e>
  80162f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801632:	74 e2                	je     801616 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801634:	83 ec 04             	sub    $0x4,%esp
  801637:	68 a3 30 80 00       	push   $0x8030a3
  80163c:	6a 46                	push   $0x46
  80163e:	68 b8 30 80 00       	push   $0x8030b8
  801643:	e8 99 11 00 00       	call   8027e1 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801648:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80164b:	5b                   	pop    %ebx
  80164c:	5e                   	pop    %esi
  80164d:	5f                   	pop    %edi
  80164e:	5d                   	pop    %ebp
  80164f:	c3                   	ret    

00801650 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801656:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80165b:	89 c2                	mov    %eax,%edx
  80165d:	c1 e2 07             	shl    $0x7,%edx
  801660:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801666:	8b 52 50             	mov    0x50(%edx),%edx
  801669:	39 ca                	cmp    %ecx,%edx
  80166b:	74 11                	je     80167e <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80166d:	83 c0 01             	add    $0x1,%eax
  801670:	3d 00 04 00 00       	cmp    $0x400,%eax
  801675:	75 e4                	jne    80165b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801677:	b8 00 00 00 00       	mov    $0x0,%eax
  80167c:	eb 0b                	jmp    801689 <ipc_find_env+0x39>
			return envs[i].env_id;
  80167e:	c1 e0 07             	shl    $0x7,%eax
  801681:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801686:	8b 40 48             	mov    0x48(%eax),%eax
}
  801689:	5d                   	pop    %ebp
  80168a:	c3                   	ret    

0080168b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	05 00 00 00 30       	add    $0x30000000,%eax
  801696:	c1 e8 0c             	shr    $0xc,%eax
}
  801699:	5d                   	pop    %ebp
  80169a:	c3                   	ret    

0080169b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016ab:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016b0:	5d                   	pop    %ebp
  8016b1:	c3                   	ret    

008016b2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016ba:	89 c2                	mov    %eax,%edx
  8016bc:	c1 ea 16             	shr    $0x16,%edx
  8016bf:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016c6:	f6 c2 01             	test   $0x1,%dl
  8016c9:	74 2d                	je     8016f8 <fd_alloc+0x46>
  8016cb:	89 c2                	mov    %eax,%edx
  8016cd:	c1 ea 0c             	shr    $0xc,%edx
  8016d0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016d7:	f6 c2 01             	test   $0x1,%dl
  8016da:	74 1c                	je     8016f8 <fd_alloc+0x46>
  8016dc:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016e1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016e6:	75 d2                	jne    8016ba <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8016f1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8016f6:	eb 0a                	jmp    801702 <fd_alloc+0x50>
			*fd_store = fd;
  8016f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016fb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801702:	5d                   	pop    %ebp
  801703:	c3                   	ret    

00801704 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80170a:	83 f8 1f             	cmp    $0x1f,%eax
  80170d:	77 30                	ja     80173f <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80170f:	c1 e0 0c             	shl    $0xc,%eax
  801712:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801717:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80171d:	f6 c2 01             	test   $0x1,%dl
  801720:	74 24                	je     801746 <fd_lookup+0x42>
  801722:	89 c2                	mov    %eax,%edx
  801724:	c1 ea 0c             	shr    $0xc,%edx
  801727:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80172e:	f6 c2 01             	test   $0x1,%dl
  801731:	74 1a                	je     80174d <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801733:	8b 55 0c             	mov    0xc(%ebp),%edx
  801736:	89 02                	mov    %eax,(%edx)
	return 0;
  801738:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173d:	5d                   	pop    %ebp
  80173e:	c3                   	ret    
		return -E_INVAL;
  80173f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801744:	eb f7                	jmp    80173d <fd_lookup+0x39>
		return -E_INVAL;
  801746:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80174b:	eb f0                	jmp    80173d <fd_lookup+0x39>
  80174d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801752:	eb e9                	jmp    80173d <fd_lookup+0x39>

00801754 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	83 ec 08             	sub    $0x8,%esp
  80175a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80175d:	ba 00 00 00 00       	mov    $0x0,%edx
  801762:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801767:	39 08                	cmp    %ecx,(%eax)
  801769:	74 38                	je     8017a3 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80176b:	83 c2 01             	add    $0x1,%edx
  80176e:	8b 04 95 40 31 80 00 	mov    0x803140(,%edx,4),%eax
  801775:	85 c0                	test   %eax,%eax
  801777:	75 ee                	jne    801767 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801779:	a1 08 50 80 00       	mov    0x805008,%eax
  80177e:	8b 40 48             	mov    0x48(%eax),%eax
  801781:	83 ec 04             	sub    $0x4,%esp
  801784:	51                   	push   %ecx
  801785:	50                   	push   %eax
  801786:	68 c4 30 80 00       	push   $0x8030c4
  80178b:	e8 d2 ea ff ff       	call   800262 <cprintf>
	*dev = 0;
  801790:	8b 45 0c             	mov    0xc(%ebp),%eax
  801793:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801799:	83 c4 10             	add    $0x10,%esp
  80179c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    
			*dev = devtab[i];
  8017a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017a6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ad:	eb f2                	jmp    8017a1 <dev_lookup+0x4d>

008017af <fd_close>:
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	57                   	push   %edi
  8017b3:	56                   	push   %esi
  8017b4:	53                   	push   %ebx
  8017b5:	83 ec 24             	sub    $0x24,%esp
  8017b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8017bb:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017be:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017c1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017c2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017c8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017cb:	50                   	push   %eax
  8017cc:	e8 33 ff ff ff       	call   801704 <fd_lookup>
  8017d1:	89 c3                	mov    %eax,%ebx
  8017d3:	83 c4 10             	add    $0x10,%esp
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	78 05                	js     8017df <fd_close+0x30>
	    || fd != fd2)
  8017da:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017dd:	74 16                	je     8017f5 <fd_close+0x46>
		return (must_exist ? r : 0);
  8017df:	89 f8                	mov    %edi,%eax
  8017e1:	84 c0                	test   %al,%al
  8017e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e8:	0f 44 d8             	cmove  %eax,%ebx
}
  8017eb:	89 d8                	mov    %ebx,%eax
  8017ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017f0:	5b                   	pop    %ebx
  8017f1:	5e                   	pop    %esi
  8017f2:	5f                   	pop    %edi
  8017f3:	5d                   	pop    %ebp
  8017f4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017f5:	83 ec 08             	sub    $0x8,%esp
  8017f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017fb:	50                   	push   %eax
  8017fc:	ff 36                	pushl  (%esi)
  8017fe:	e8 51 ff ff ff       	call   801754 <dev_lookup>
  801803:	89 c3                	mov    %eax,%ebx
  801805:	83 c4 10             	add    $0x10,%esp
  801808:	85 c0                	test   %eax,%eax
  80180a:	78 1a                	js     801826 <fd_close+0x77>
		if (dev->dev_close)
  80180c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80180f:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801812:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801817:	85 c0                	test   %eax,%eax
  801819:	74 0b                	je     801826 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80181b:	83 ec 0c             	sub    $0xc,%esp
  80181e:	56                   	push   %esi
  80181f:	ff d0                	call   *%eax
  801821:	89 c3                	mov    %eax,%ebx
  801823:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801826:	83 ec 08             	sub    $0x8,%esp
  801829:	56                   	push   %esi
  80182a:	6a 00                	push   $0x0
  80182c:	e8 07 f6 ff ff       	call   800e38 <sys_page_unmap>
	return r;
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	eb b5                	jmp    8017eb <fd_close+0x3c>

00801836 <close>:

int
close(int fdnum)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80183c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183f:	50                   	push   %eax
  801840:	ff 75 08             	pushl  0x8(%ebp)
  801843:	e8 bc fe ff ff       	call   801704 <fd_lookup>
  801848:	83 c4 10             	add    $0x10,%esp
  80184b:	85 c0                	test   %eax,%eax
  80184d:	79 02                	jns    801851 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    
		return fd_close(fd, 1);
  801851:	83 ec 08             	sub    $0x8,%esp
  801854:	6a 01                	push   $0x1
  801856:	ff 75 f4             	pushl  -0xc(%ebp)
  801859:	e8 51 ff ff ff       	call   8017af <fd_close>
  80185e:	83 c4 10             	add    $0x10,%esp
  801861:	eb ec                	jmp    80184f <close+0x19>

00801863 <close_all>:

void
close_all(void)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	53                   	push   %ebx
  801867:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80186a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80186f:	83 ec 0c             	sub    $0xc,%esp
  801872:	53                   	push   %ebx
  801873:	e8 be ff ff ff       	call   801836 <close>
	for (i = 0; i < MAXFD; i++)
  801878:	83 c3 01             	add    $0x1,%ebx
  80187b:	83 c4 10             	add    $0x10,%esp
  80187e:	83 fb 20             	cmp    $0x20,%ebx
  801881:	75 ec                	jne    80186f <close_all+0xc>
}
  801883:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	57                   	push   %edi
  80188c:	56                   	push   %esi
  80188d:	53                   	push   %ebx
  80188e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801891:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801894:	50                   	push   %eax
  801895:	ff 75 08             	pushl  0x8(%ebp)
  801898:	e8 67 fe ff ff       	call   801704 <fd_lookup>
  80189d:	89 c3                	mov    %eax,%ebx
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	0f 88 81 00 00 00    	js     80192b <dup+0xa3>
		return r;
	close(newfdnum);
  8018aa:	83 ec 0c             	sub    $0xc,%esp
  8018ad:	ff 75 0c             	pushl  0xc(%ebp)
  8018b0:	e8 81 ff ff ff       	call   801836 <close>

	newfd = INDEX2FD(newfdnum);
  8018b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018b8:	c1 e6 0c             	shl    $0xc,%esi
  8018bb:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018c1:	83 c4 04             	add    $0x4,%esp
  8018c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018c7:	e8 cf fd ff ff       	call   80169b <fd2data>
  8018cc:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018ce:	89 34 24             	mov    %esi,(%esp)
  8018d1:	e8 c5 fd ff ff       	call   80169b <fd2data>
  8018d6:	83 c4 10             	add    $0x10,%esp
  8018d9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018db:	89 d8                	mov    %ebx,%eax
  8018dd:	c1 e8 16             	shr    $0x16,%eax
  8018e0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018e7:	a8 01                	test   $0x1,%al
  8018e9:	74 11                	je     8018fc <dup+0x74>
  8018eb:	89 d8                	mov    %ebx,%eax
  8018ed:	c1 e8 0c             	shr    $0xc,%eax
  8018f0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018f7:	f6 c2 01             	test   $0x1,%dl
  8018fa:	75 39                	jne    801935 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018ff:	89 d0                	mov    %edx,%eax
  801901:	c1 e8 0c             	shr    $0xc,%eax
  801904:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80190b:	83 ec 0c             	sub    $0xc,%esp
  80190e:	25 07 0e 00 00       	and    $0xe07,%eax
  801913:	50                   	push   %eax
  801914:	56                   	push   %esi
  801915:	6a 00                	push   $0x0
  801917:	52                   	push   %edx
  801918:	6a 00                	push   $0x0
  80191a:	e8 d7 f4 ff ff       	call   800df6 <sys_page_map>
  80191f:	89 c3                	mov    %eax,%ebx
  801921:	83 c4 20             	add    $0x20,%esp
  801924:	85 c0                	test   %eax,%eax
  801926:	78 31                	js     801959 <dup+0xd1>
		goto err;

	return newfdnum;
  801928:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80192b:	89 d8                	mov    %ebx,%eax
  80192d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801930:	5b                   	pop    %ebx
  801931:	5e                   	pop    %esi
  801932:	5f                   	pop    %edi
  801933:	5d                   	pop    %ebp
  801934:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801935:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80193c:	83 ec 0c             	sub    $0xc,%esp
  80193f:	25 07 0e 00 00       	and    $0xe07,%eax
  801944:	50                   	push   %eax
  801945:	57                   	push   %edi
  801946:	6a 00                	push   $0x0
  801948:	53                   	push   %ebx
  801949:	6a 00                	push   $0x0
  80194b:	e8 a6 f4 ff ff       	call   800df6 <sys_page_map>
  801950:	89 c3                	mov    %eax,%ebx
  801952:	83 c4 20             	add    $0x20,%esp
  801955:	85 c0                	test   %eax,%eax
  801957:	79 a3                	jns    8018fc <dup+0x74>
	sys_page_unmap(0, newfd);
  801959:	83 ec 08             	sub    $0x8,%esp
  80195c:	56                   	push   %esi
  80195d:	6a 00                	push   $0x0
  80195f:	e8 d4 f4 ff ff       	call   800e38 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801964:	83 c4 08             	add    $0x8,%esp
  801967:	57                   	push   %edi
  801968:	6a 00                	push   $0x0
  80196a:	e8 c9 f4 ff ff       	call   800e38 <sys_page_unmap>
	return r;
  80196f:	83 c4 10             	add    $0x10,%esp
  801972:	eb b7                	jmp    80192b <dup+0xa3>

00801974 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	53                   	push   %ebx
  801978:	83 ec 1c             	sub    $0x1c,%esp
  80197b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80197e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801981:	50                   	push   %eax
  801982:	53                   	push   %ebx
  801983:	e8 7c fd ff ff       	call   801704 <fd_lookup>
  801988:	83 c4 10             	add    $0x10,%esp
  80198b:	85 c0                	test   %eax,%eax
  80198d:	78 3f                	js     8019ce <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80198f:	83 ec 08             	sub    $0x8,%esp
  801992:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801995:	50                   	push   %eax
  801996:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801999:	ff 30                	pushl  (%eax)
  80199b:	e8 b4 fd ff ff       	call   801754 <dev_lookup>
  8019a0:	83 c4 10             	add    $0x10,%esp
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	78 27                	js     8019ce <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019aa:	8b 42 08             	mov    0x8(%edx),%eax
  8019ad:	83 e0 03             	and    $0x3,%eax
  8019b0:	83 f8 01             	cmp    $0x1,%eax
  8019b3:	74 1e                	je     8019d3 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b8:	8b 40 08             	mov    0x8(%eax),%eax
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	74 35                	je     8019f4 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019bf:	83 ec 04             	sub    $0x4,%esp
  8019c2:	ff 75 10             	pushl  0x10(%ebp)
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	52                   	push   %edx
  8019c9:	ff d0                	call   *%eax
  8019cb:	83 c4 10             	add    $0x10,%esp
}
  8019ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019d3:	a1 08 50 80 00       	mov    0x805008,%eax
  8019d8:	8b 40 48             	mov    0x48(%eax),%eax
  8019db:	83 ec 04             	sub    $0x4,%esp
  8019de:	53                   	push   %ebx
  8019df:	50                   	push   %eax
  8019e0:	68 05 31 80 00       	push   $0x803105
  8019e5:	e8 78 e8 ff ff       	call   800262 <cprintf>
		return -E_INVAL;
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019f2:	eb da                	jmp    8019ce <read+0x5a>
		return -E_NOT_SUPP;
  8019f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019f9:	eb d3                	jmp    8019ce <read+0x5a>

008019fb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	57                   	push   %edi
  8019ff:	56                   	push   %esi
  801a00:	53                   	push   %ebx
  801a01:	83 ec 0c             	sub    $0xc,%esp
  801a04:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a07:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a0a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a0f:	39 f3                	cmp    %esi,%ebx
  801a11:	73 23                	jae    801a36 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a13:	83 ec 04             	sub    $0x4,%esp
  801a16:	89 f0                	mov    %esi,%eax
  801a18:	29 d8                	sub    %ebx,%eax
  801a1a:	50                   	push   %eax
  801a1b:	89 d8                	mov    %ebx,%eax
  801a1d:	03 45 0c             	add    0xc(%ebp),%eax
  801a20:	50                   	push   %eax
  801a21:	57                   	push   %edi
  801a22:	e8 4d ff ff ff       	call   801974 <read>
		if (m < 0)
  801a27:	83 c4 10             	add    $0x10,%esp
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 06                	js     801a34 <readn+0x39>
			return m;
		if (m == 0)
  801a2e:	74 06                	je     801a36 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a30:	01 c3                	add    %eax,%ebx
  801a32:	eb db                	jmp    801a0f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a34:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a36:	89 d8                	mov    %ebx,%eax
  801a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5f                   	pop    %edi
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    

00801a40 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
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
  801a4f:	e8 b0 fc ff ff       	call   801704 <fd_lookup>
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	85 c0                	test   %eax,%eax
  801a59:	78 3a                	js     801a95 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a5b:	83 ec 08             	sub    $0x8,%esp
  801a5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a61:	50                   	push   %eax
  801a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a65:	ff 30                	pushl  (%eax)
  801a67:	e8 e8 fc ff ff       	call   801754 <dev_lookup>
  801a6c:	83 c4 10             	add    $0x10,%esp
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	78 22                	js     801a95 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a76:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a7a:	74 1e                	je     801a9a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a7f:	8b 52 0c             	mov    0xc(%edx),%edx
  801a82:	85 d2                	test   %edx,%edx
  801a84:	74 35                	je     801abb <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a86:	83 ec 04             	sub    $0x4,%esp
  801a89:	ff 75 10             	pushl  0x10(%ebp)
  801a8c:	ff 75 0c             	pushl  0xc(%ebp)
  801a8f:	50                   	push   %eax
  801a90:	ff d2                	call   *%edx
  801a92:	83 c4 10             	add    $0x10,%esp
}
  801a95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a9a:	a1 08 50 80 00       	mov    0x805008,%eax
  801a9f:	8b 40 48             	mov    0x48(%eax),%eax
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	53                   	push   %ebx
  801aa6:	50                   	push   %eax
  801aa7:	68 21 31 80 00       	push   $0x803121
  801aac:	e8 b1 e7 ff ff       	call   800262 <cprintf>
		return -E_INVAL;
  801ab1:	83 c4 10             	add    $0x10,%esp
  801ab4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ab9:	eb da                	jmp    801a95 <write+0x55>
		return -E_NOT_SUPP;
  801abb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ac0:	eb d3                	jmp    801a95 <write+0x55>

00801ac2 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ac8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801acb:	50                   	push   %eax
  801acc:	ff 75 08             	pushl  0x8(%ebp)
  801acf:	e8 30 fc ff ff       	call   801704 <fd_lookup>
  801ad4:	83 c4 10             	add    $0x10,%esp
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	78 0e                	js     801ae9 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ae4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	53                   	push   %ebx
  801aef:	83 ec 1c             	sub    $0x1c,%esp
  801af2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801af5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801af8:	50                   	push   %eax
  801af9:	53                   	push   %ebx
  801afa:	e8 05 fc ff ff       	call   801704 <fd_lookup>
  801aff:	83 c4 10             	add    $0x10,%esp
  801b02:	85 c0                	test   %eax,%eax
  801b04:	78 37                	js     801b3d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b06:	83 ec 08             	sub    $0x8,%esp
  801b09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0c:	50                   	push   %eax
  801b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b10:	ff 30                	pushl  (%eax)
  801b12:	e8 3d fc ff ff       	call   801754 <dev_lookup>
  801b17:	83 c4 10             	add    $0x10,%esp
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	78 1f                	js     801b3d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b21:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b25:	74 1b                	je     801b42 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2a:	8b 52 18             	mov    0x18(%edx),%edx
  801b2d:	85 d2                	test   %edx,%edx
  801b2f:	74 32                	je     801b63 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b31:	83 ec 08             	sub    $0x8,%esp
  801b34:	ff 75 0c             	pushl  0xc(%ebp)
  801b37:	50                   	push   %eax
  801b38:	ff d2                	call   *%edx
  801b3a:	83 c4 10             	add    $0x10,%esp
}
  801b3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b42:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b47:	8b 40 48             	mov    0x48(%eax),%eax
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	53                   	push   %ebx
  801b4e:	50                   	push   %eax
  801b4f:	68 e4 30 80 00       	push   $0x8030e4
  801b54:	e8 09 e7 ff ff       	call   800262 <cprintf>
		return -E_INVAL;
  801b59:	83 c4 10             	add    $0x10,%esp
  801b5c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b61:	eb da                	jmp    801b3d <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b63:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b68:	eb d3                	jmp    801b3d <ftruncate+0x52>

00801b6a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	53                   	push   %ebx
  801b6e:	83 ec 1c             	sub    $0x1c,%esp
  801b71:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b74:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b77:	50                   	push   %eax
  801b78:	ff 75 08             	pushl  0x8(%ebp)
  801b7b:	e8 84 fb ff ff       	call   801704 <fd_lookup>
  801b80:	83 c4 10             	add    $0x10,%esp
  801b83:	85 c0                	test   %eax,%eax
  801b85:	78 4b                	js     801bd2 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b87:	83 ec 08             	sub    $0x8,%esp
  801b8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b8d:	50                   	push   %eax
  801b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b91:	ff 30                	pushl  (%eax)
  801b93:	e8 bc fb ff ff       	call   801754 <dev_lookup>
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	85 c0                	test   %eax,%eax
  801b9d:	78 33                	js     801bd2 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba2:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ba6:	74 2f                	je     801bd7 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ba8:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bab:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bb2:	00 00 00 
	stat->st_isdir = 0;
  801bb5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bbc:	00 00 00 
	stat->st_dev = dev;
  801bbf:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bc5:	83 ec 08             	sub    $0x8,%esp
  801bc8:	53                   	push   %ebx
  801bc9:	ff 75 f0             	pushl  -0x10(%ebp)
  801bcc:	ff 50 14             	call   *0x14(%eax)
  801bcf:	83 c4 10             	add    $0x10,%esp
}
  801bd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    
		return -E_NOT_SUPP;
  801bd7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bdc:	eb f4                	jmp    801bd2 <fstat+0x68>

00801bde <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	56                   	push   %esi
  801be2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801be3:	83 ec 08             	sub    $0x8,%esp
  801be6:	6a 00                	push   $0x0
  801be8:	ff 75 08             	pushl  0x8(%ebp)
  801beb:	e8 22 02 00 00       	call   801e12 <open>
  801bf0:	89 c3                	mov    %eax,%ebx
  801bf2:	83 c4 10             	add    $0x10,%esp
  801bf5:	85 c0                	test   %eax,%eax
  801bf7:	78 1b                	js     801c14 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801bf9:	83 ec 08             	sub    $0x8,%esp
  801bfc:	ff 75 0c             	pushl  0xc(%ebp)
  801bff:	50                   	push   %eax
  801c00:	e8 65 ff ff ff       	call   801b6a <fstat>
  801c05:	89 c6                	mov    %eax,%esi
	close(fd);
  801c07:	89 1c 24             	mov    %ebx,(%esp)
  801c0a:	e8 27 fc ff ff       	call   801836 <close>
	return r;
  801c0f:	83 c4 10             	add    $0x10,%esp
  801c12:	89 f3                	mov    %esi,%ebx
}
  801c14:	89 d8                	mov    %ebx,%eax
  801c16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c19:	5b                   	pop    %ebx
  801c1a:	5e                   	pop    %esi
  801c1b:	5d                   	pop    %ebp
  801c1c:	c3                   	ret    

00801c1d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	56                   	push   %esi
  801c21:	53                   	push   %ebx
  801c22:	89 c6                	mov    %eax,%esi
  801c24:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c26:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c2d:	74 27                	je     801c56 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c2f:	6a 07                	push   $0x7
  801c31:	68 00 60 80 00       	push   $0x806000
  801c36:	56                   	push   %esi
  801c37:	ff 35 00 50 80 00    	pushl  0x805000
  801c3d:	e8 b6 f9 ff ff       	call   8015f8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c42:	83 c4 0c             	add    $0xc,%esp
  801c45:	6a 00                	push   $0x0
  801c47:	53                   	push   %ebx
  801c48:	6a 00                	push   $0x0
  801c4a:	e8 40 f9 ff ff       	call   80158f <ipc_recv>
}
  801c4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c52:	5b                   	pop    %ebx
  801c53:	5e                   	pop    %esi
  801c54:	5d                   	pop    %ebp
  801c55:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c56:	83 ec 0c             	sub    $0xc,%esp
  801c59:	6a 01                	push   $0x1
  801c5b:	e8 f0 f9 ff ff       	call   801650 <ipc_find_env>
  801c60:	a3 00 50 80 00       	mov    %eax,0x805000
  801c65:	83 c4 10             	add    $0x10,%esp
  801c68:	eb c5                	jmp    801c2f <fsipc+0x12>

00801c6a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	8b 40 0c             	mov    0xc(%eax),%eax
  801c76:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7e:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c83:	ba 00 00 00 00       	mov    $0x0,%edx
  801c88:	b8 02 00 00 00       	mov    $0x2,%eax
  801c8d:	e8 8b ff ff ff       	call   801c1d <fsipc>
}
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <devfile_flush>:
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9d:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca0:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ca5:	ba 00 00 00 00       	mov    $0x0,%edx
  801caa:	b8 06 00 00 00       	mov    $0x6,%eax
  801caf:	e8 69 ff ff ff       	call   801c1d <fsipc>
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <devfile_stat>:
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	53                   	push   %ebx
  801cba:	83 ec 04             	sub    $0x4,%esp
  801cbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc6:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd0:	b8 05 00 00 00       	mov    $0x5,%eax
  801cd5:	e8 43 ff ff ff       	call   801c1d <fsipc>
  801cda:	85 c0                	test   %eax,%eax
  801cdc:	78 2c                	js     801d0a <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cde:	83 ec 08             	sub    $0x8,%esp
  801ce1:	68 00 60 80 00       	push   $0x806000
  801ce6:	53                   	push   %ebx
  801ce7:	e8 d5 ec ff ff       	call   8009c1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cec:	a1 80 60 80 00       	mov    0x806080,%eax
  801cf1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cf7:	a1 84 60 80 00       	mov    0x806084,%eax
  801cfc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d02:	83 c4 10             	add    $0x10,%esp
  801d05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <devfile_write>:
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	53                   	push   %ebx
  801d13:	83 ec 08             	sub    $0x8,%esp
  801d16:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d1f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d24:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d2a:	53                   	push   %ebx
  801d2b:	ff 75 0c             	pushl  0xc(%ebp)
  801d2e:	68 08 60 80 00       	push   $0x806008
  801d33:	e8 79 ee ff ff       	call   800bb1 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d38:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3d:	b8 04 00 00 00       	mov    $0x4,%eax
  801d42:	e8 d6 fe ff ff       	call   801c1d <fsipc>
  801d47:	83 c4 10             	add    $0x10,%esp
  801d4a:	85 c0                	test   %eax,%eax
  801d4c:	78 0b                	js     801d59 <devfile_write+0x4a>
	assert(r <= n);
  801d4e:	39 d8                	cmp    %ebx,%eax
  801d50:	77 0c                	ja     801d5e <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d52:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d57:	7f 1e                	jg     801d77 <devfile_write+0x68>
}
  801d59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    
	assert(r <= n);
  801d5e:	68 54 31 80 00       	push   $0x803154
  801d63:	68 5b 31 80 00       	push   $0x80315b
  801d68:	68 98 00 00 00       	push   $0x98
  801d6d:	68 70 31 80 00       	push   $0x803170
  801d72:	e8 6a 0a 00 00       	call   8027e1 <_panic>
	assert(r <= PGSIZE);
  801d77:	68 7b 31 80 00       	push   $0x80317b
  801d7c:	68 5b 31 80 00       	push   $0x80315b
  801d81:	68 99 00 00 00       	push   $0x99
  801d86:	68 70 31 80 00       	push   $0x803170
  801d8b:	e8 51 0a 00 00       	call   8027e1 <_panic>

00801d90 <devfile_read>:
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	56                   	push   %esi
  801d94:	53                   	push   %ebx
  801d95:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d98:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d9e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801da3:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801da9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dae:	b8 03 00 00 00       	mov    $0x3,%eax
  801db3:	e8 65 fe ff ff       	call   801c1d <fsipc>
  801db8:	89 c3                	mov    %eax,%ebx
  801dba:	85 c0                	test   %eax,%eax
  801dbc:	78 1f                	js     801ddd <devfile_read+0x4d>
	assert(r <= n);
  801dbe:	39 f0                	cmp    %esi,%eax
  801dc0:	77 24                	ja     801de6 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801dc2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dc7:	7f 33                	jg     801dfc <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801dc9:	83 ec 04             	sub    $0x4,%esp
  801dcc:	50                   	push   %eax
  801dcd:	68 00 60 80 00       	push   $0x806000
  801dd2:	ff 75 0c             	pushl  0xc(%ebp)
  801dd5:	e8 75 ed ff ff       	call   800b4f <memmove>
	return r;
  801dda:	83 c4 10             	add    $0x10,%esp
}
  801ddd:	89 d8                	mov    %ebx,%eax
  801ddf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de2:	5b                   	pop    %ebx
  801de3:	5e                   	pop    %esi
  801de4:	5d                   	pop    %ebp
  801de5:	c3                   	ret    
	assert(r <= n);
  801de6:	68 54 31 80 00       	push   $0x803154
  801deb:	68 5b 31 80 00       	push   $0x80315b
  801df0:	6a 7c                	push   $0x7c
  801df2:	68 70 31 80 00       	push   $0x803170
  801df7:	e8 e5 09 00 00       	call   8027e1 <_panic>
	assert(r <= PGSIZE);
  801dfc:	68 7b 31 80 00       	push   $0x80317b
  801e01:	68 5b 31 80 00       	push   $0x80315b
  801e06:	6a 7d                	push   $0x7d
  801e08:	68 70 31 80 00       	push   $0x803170
  801e0d:	e8 cf 09 00 00       	call   8027e1 <_panic>

00801e12 <open>:
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	56                   	push   %esi
  801e16:	53                   	push   %ebx
  801e17:	83 ec 1c             	sub    $0x1c,%esp
  801e1a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e1d:	56                   	push   %esi
  801e1e:	e8 65 eb ff ff       	call   800988 <strlen>
  801e23:	83 c4 10             	add    $0x10,%esp
  801e26:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e2b:	7f 6c                	jg     801e99 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e2d:	83 ec 0c             	sub    $0xc,%esp
  801e30:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e33:	50                   	push   %eax
  801e34:	e8 79 f8 ff ff       	call   8016b2 <fd_alloc>
  801e39:	89 c3                	mov    %eax,%ebx
  801e3b:	83 c4 10             	add    $0x10,%esp
  801e3e:	85 c0                	test   %eax,%eax
  801e40:	78 3c                	js     801e7e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e42:	83 ec 08             	sub    $0x8,%esp
  801e45:	56                   	push   %esi
  801e46:	68 00 60 80 00       	push   $0x806000
  801e4b:	e8 71 eb ff ff       	call   8009c1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e53:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e5b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e60:	e8 b8 fd ff ff       	call   801c1d <fsipc>
  801e65:	89 c3                	mov    %eax,%ebx
  801e67:	83 c4 10             	add    $0x10,%esp
  801e6a:	85 c0                	test   %eax,%eax
  801e6c:	78 19                	js     801e87 <open+0x75>
	return fd2num(fd);
  801e6e:	83 ec 0c             	sub    $0xc,%esp
  801e71:	ff 75 f4             	pushl  -0xc(%ebp)
  801e74:	e8 12 f8 ff ff       	call   80168b <fd2num>
  801e79:	89 c3                	mov    %eax,%ebx
  801e7b:	83 c4 10             	add    $0x10,%esp
}
  801e7e:	89 d8                	mov    %ebx,%eax
  801e80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e83:	5b                   	pop    %ebx
  801e84:	5e                   	pop    %esi
  801e85:	5d                   	pop    %ebp
  801e86:	c3                   	ret    
		fd_close(fd, 0);
  801e87:	83 ec 08             	sub    $0x8,%esp
  801e8a:	6a 00                	push   $0x0
  801e8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8f:	e8 1b f9 ff ff       	call   8017af <fd_close>
		return r;
  801e94:	83 c4 10             	add    $0x10,%esp
  801e97:	eb e5                	jmp    801e7e <open+0x6c>
		return -E_BAD_PATH;
  801e99:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e9e:	eb de                	jmp    801e7e <open+0x6c>

00801ea0 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ea6:	ba 00 00 00 00       	mov    $0x0,%edx
  801eab:	b8 08 00 00 00       	mov    $0x8,%eax
  801eb0:	e8 68 fd ff ff       	call   801c1d <fsipc>
}
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ebd:	68 87 31 80 00       	push   $0x803187
  801ec2:	ff 75 0c             	pushl  0xc(%ebp)
  801ec5:	e8 f7 ea ff ff       	call   8009c1 <strcpy>
	return 0;
}
  801eca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <devsock_close>:
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	53                   	push   %ebx
  801ed5:	83 ec 10             	sub    $0x10,%esp
  801ed8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801edb:	53                   	push   %ebx
  801edc:	e8 f6 09 00 00       	call   8028d7 <pageref>
  801ee1:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ee4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ee9:	83 f8 01             	cmp    $0x1,%eax
  801eec:	74 07                	je     801ef5 <devsock_close+0x24>
}
  801eee:	89 d0                	mov    %edx,%eax
  801ef0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ef5:	83 ec 0c             	sub    $0xc,%esp
  801ef8:	ff 73 0c             	pushl  0xc(%ebx)
  801efb:	e8 b9 02 00 00       	call   8021b9 <nsipc_close>
  801f00:	89 c2                	mov    %eax,%edx
  801f02:	83 c4 10             	add    $0x10,%esp
  801f05:	eb e7                	jmp    801eee <devsock_close+0x1d>

00801f07 <devsock_write>:
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f0d:	6a 00                	push   $0x0
  801f0f:	ff 75 10             	pushl  0x10(%ebp)
  801f12:	ff 75 0c             	pushl  0xc(%ebp)
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	ff 70 0c             	pushl  0xc(%eax)
  801f1b:	e8 76 03 00 00       	call   802296 <nsipc_send>
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <devsock_read>:
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f28:	6a 00                	push   $0x0
  801f2a:	ff 75 10             	pushl  0x10(%ebp)
  801f2d:	ff 75 0c             	pushl  0xc(%ebp)
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	ff 70 0c             	pushl  0xc(%eax)
  801f36:	e8 ef 02 00 00       	call   80222a <nsipc_recv>
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <fd2sockid>:
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f43:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f46:	52                   	push   %edx
  801f47:	50                   	push   %eax
  801f48:	e8 b7 f7 ff ff       	call   801704 <fd_lookup>
  801f4d:	83 c4 10             	add    $0x10,%esp
  801f50:	85 c0                	test   %eax,%eax
  801f52:	78 10                	js     801f64 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f57:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f5d:	39 08                	cmp    %ecx,(%eax)
  801f5f:	75 05                	jne    801f66 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f61:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f64:	c9                   	leave  
  801f65:	c3                   	ret    
		return -E_NOT_SUPP;
  801f66:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f6b:	eb f7                	jmp    801f64 <fd2sockid+0x27>

00801f6d <alloc_sockfd>:
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	56                   	push   %esi
  801f71:	53                   	push   %ebx
  801f72:	83 ec 1c             	sub    $0x1c,%esp
  801f75:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f77:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f7a:	50                   	push   %eax
  801f7b:	e8 32 f7 ff ff       	call   8016b2 <fd_alloc>
  801f80:	89 c3                	mov    %eax,%ebx
  801f82:	83 c4 10             	add    $0x10,%esp
  801f85:	85 c0                	test   %eax,%eax
  801f87:	78 43                	js     801fcc <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f89:	83 ec 04             	sub    $0x4,%esp
  801f8c:	68 07 04 00 00       	push   $0x407
  801f91:	ff 75 f4             	pushl  -0xc(%ebp)
  801f94:	6a 00                	push   $0x0
  801f96:	e8 18 ee ff ff       	call   800db3 <sys_page_alloc>
  801f9b:	89 c3                	mov    %eax,%ebx
  801f9d:	83 c4 10             	add    $0x10,%esp
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	78 28                	js     801fcc <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa7:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fad:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fb9:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fbc:	83 ec 0c             	sub    $0xc,%esp
  801fbf:	50                   	push   %eax
  801fc0:	e8 c6 f6 ff ff       	call   80168b <fd2num>
  801fc5:	89 c3                	mov    %eax,%ebx
  801fc7:	83 c4 10             	add    $0x10,%esp
  801fca:	eb 0c                	jmp    801fd8 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fcc:	83 ec 0c             	sub    $0xc,%esp
  801fcf:	56                   	push   %esi
  801fd0:	e8 e4 01 00 00       	call   8021b9 <nsipc_close>
		return r;
  801fd5:	83 c4 10             	add    $0x10,%esp
}
  801fd8:	89 d8                	mov    %ebx,%eax
  801fda:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fdd:	5b                   	pop    %ebx
  801fde:	5e                   	pop    %esi
  801fdf:	5d                   	pop    %ebp
  801fe0:	c3                   	ret    

00801fe1 <accept>:
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fea:	e8 4e ff ff ff       	call   801f3d <fd2sockid>
  801fef:	85 c0                	test   %eax,%eax
  801ff1:	78 1b                	js     80200e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ff3:	83 ec 04             	sub    $0x4,%esp
  801ff6:	ff 75 10             	pushl  0x10(%ebp)
  801ff9:	ff 75 0c             	pushl  0xc(%ebp)
  801ffc:	50                   	push   %eax
  801ffd:	e8 0e 01 00 00       	call   802110 <nsipc_accept>
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	85 c0                	test   %eax,%eax
  802007:	78 05                	js     80200e <accept+0x2d>
	return alloc_sockfd(r);
  802009:	e8 5f ff ff ff       	call   801f6d <alloc_sockfd>
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <bind>:
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802016:	8b 45 08             	mov    0x8(%ebp),%eax
  802019:	e8 1f ff ff ff       	call   801f3d <fd2sockid>
  80201e:	85 c0                	test   %eax,%eax
  802020:	78 12                	js     802034 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802022:	83 ec 04             	sub    $0x4,%esp
  802025:	ff 75 10             	pushl  0x10(%ebp)
  802028:	ff 75 0c             	pushl  0xc(%ebp)
  80202b:	50                   	push   %eax
  80202c:	e8 31 01 00 00       	call   802162 <nsipc_bind>
  802031:	83 c4 10             	add    $0x10,%esp
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <shutdown>:
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
  802039:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80203c:	8b 45 08             	mov    0x8(%ebp),%eax
  80203f:	e8 f9 fe ff ff       	call   801f3d <fd2sockid>
  802044:	85 c0                	test   %eax,%eax
  802046:	78 0f                	js     802057 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802048:	83 ec 08             	sub    $0x8,%esp
  80204b:	ff 75 0c             	pushl  0xc(%ebp)
  80204e:	50                   	push   %eax
  80204f:	e8 43 01 00 00       	call   802197 <nsipc_shutdown>
  802054:	83 c4 10             	add    $0x10,%esp
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <connect>:
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	e8 d6 fe ff ff       	call   801f3d <fd2sockid>
  802067:	85 c0                	test   %eax,%eax
  802069:	78 12                	js     80207d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80206b:	83 ec 04             	sub    $0x4,%esp
  80206e:	ff 75 10             	pushl  0x10(%ebp)
  802071:	ff 75 0c             	pushl  0xc(%ebp)
  802074:	50                   	push   %eax
  802075:	e8 59 01 00 00       	call   8021d3 <nsipc_connect>
  80207a:	83 c4 10             	add    $0x10,%esp
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <listen>:
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	e8 b0 fe ff ff       	call   801f3d <fd2sockid>
  80208d:	85 c0                	test   %eax,%eax
  80208f:	78 0f                	js     8020a0 <listen+0x21>
	return nsipc_listen(r, backlog);
  802091:	83 ec 08             	sub    $0x8,%esp
  802094:	ff 75 0c             	pushl  0xc(%ebp)
  802097:	50                   	push   %eax
  802098:	e8 6b 01 00 00       	call   802208 <nsipc_listen>
  80209d:	83 c4 10             	add    $0x10,%esp
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
  8020a5:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020a8:	ff 75 10             	pushl  0x10(%ebp)
  8020ab:	ff 75 0c             	pushl  0xc(%ebp)
  8020ae:	ff 75 08             	pushl  0x8(%ebp)
  8020b1:	e8 3e 02 00 00       	call   8022f4 <nsipc_socket>
  8020b6:	83 c4 10             	add    $0x10,%esp
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	78 05                	js     8020c2 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020bd:	e8 ab fe ff ff       	call   801f6d <alloc_sockfd>
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	53                   	push   %ebx
  8020c8:	83 ec 04             	sub    $0x4,%esp
  8020cb:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020cd:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020d4:	74 26                	je     8020fc <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020d6:	6a 07                	push   $0x7
  8020d8:	68 00 70 80 00       	push   $0x807000
  8020dd:	53                   	push   %ebx
  8020de:	ff 35 04 50 80 00    	pushl  0x805004
  8020e4:	e8 0f f5 ff ff       	call   8015f8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020e9:	83 c4 0c             	add    $0xc,%esp
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	e8 98 f4 ff ff       	call   80158f <ipc_recv>
}
  8020f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020fc:	83 ec 0c             	sub    $0xc,%esp
  8020ff:	6a 02                	push   $0x2
  802101:	e8 4a f5 ff ff       	call   801650 <ipc_find_env>
  802106:	a3 04 50 80 00       	mov    %eax,0x805004
  80210b:	83 c4 10             	add    $0x10,%esp
  80210e:	eb c6                	jmp    8020d6 <nsipc+0x12>

00802110 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	56                   	push   %esi
  802114:	53                   	push   %ebx
  802115:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802118:	8b 45 08             	mov    0x8(%ebp),%eax
  80211b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802120:	8b 06                	mov    (%esi),%eax
  802122:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802127:	b8 01 00 00 00       	mov    $0x1,%eax
  80212c:	e8 93 ff ff ff       	call   8020c4 <nsipc>
  802131:	89 c3                	mov    %eax,%ebx
  802133:	85 c0                	test   %eax,%eax
  802135:	79 09                	jns    802140 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802137:	89 d8                	mov    %ebx,%eax
  802139:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80213c:	5b                   	pop    %ebx
  80213d:	5e                   	pop    %esi
  80213e:	5d                   	pop    %ebp
  80213f:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802140:	83 ec 04             	sub    $0x4,%esp
  802143:	ff 35 10 70 80 00    	pushl  0x807010
  802149:	68 00 70 80 00       	push   $0x807000
  80214e:	ff 75 0c             	pushl  0xc(%ebp)
  802151:	e8 f9 e9 ff ff       	call   800b4f <memmove>
		*addrlen = ret->ret_addrlen;
  802156:	a1 10 70 80 00       	mov    0x807010,%eax
  80215b:	89 06                	mov    %eax,(%esi)
  80215d:	83 c4 10             	add    $0x10,%esp
	return r;
  802160:	eb d5                	jmp    802137 <nsipc_accept+0x27>

00802162 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	53                   	push   %ebx
  802166:	83 ec 08             	sub    $0x8,%esp
  802169:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802174:	53                   	push   %ebx
  802175:	ff 75 0c             	pushl  0xc(%ebp)
  802178:	68 04 70 80 00       	push   $0x807004
  80217d:	e8 cd e9 ff ff       	call   800b4f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802182:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802188:	b8 02 00 00 00       	mov    $0x2,%eax
  80218d:	e8 32 ff ff ff       	call   8020c4 <nsipc>
}
  802192:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
  80219a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a8:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021ad:	b8 03 00 00 00       	mov    $0x3,%eax
  8021b2:	e8 0d ff ff ff       	call   8020c4 <nsipc>
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <nsipc_close>:

int
nsipc_close(int s)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021c7:	b8 04 00 00 00       	mov    $0x4,%eax
  8021cc:	e8 f3 fe ff ff       	call   8020c4 <nsipc>
}
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	53                   	push   %ebx
  8021d7:	83 ec 08             	sub    $0x8,%esp
  8021da:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021e5:	53                   	push   %ebx
  8021e6:	ff 75 0c             	pushl  0xc(%ebp)
  8021e9:	68 04 70 80 00       	push   $0x807004
  8021ee:	e8 5c e9 ff ff       	call   800b4f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021f3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021f9:	b8 05 00 00 00       	mov    $0x5,%eax
  8021fe:	e8 c1 fe ff ff       	call   8020c4 <nsipc>
}
  802203:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802206:	c9                   	leave  
  802207:	c3                   	ret    

00802208 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802216:	8b 45 0c             	mov    0xc(%ebp),%eax
  802219:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80221e:	b8 06 00 00 00       	mov    $0x6,%eax
  802223:	e8 9c fe ff ff       	call   8020c4 <nsipc>
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
  80222d:	56                   	push   %esi
  80222e:	53                   	push   %ebx
  80222f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80223a:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802240:	8b 45 14             	mov    0x14(%ebp),%eax
  802243:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802248:	b8 07 00 00 00       	mov    $0x7,%eax
  80224d:	e8 72 fe ff ff       	call   8020c4 <nsipc>
  802252:	89 c3                	mov    %eax,%ebx
  802254:	85 c0                	test   %eax,%eax
  802256:	78 1f                	js     802277 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802258:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80225d:	7f 21                	jg     802280 <nsipc_recv+0x56>
  80225f:	39 c6                	cmp    %eax,%esi
  802261:	7c 1d                	jl     802280 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802263:	83 ec 04             	sub    $0x4,%esp
  802266:	50                   	push   %eax
  802267:	68 00 70 80 00       	push   $0x807000
  80226c:	ff 75 0c             	pushl  0xc(%ebp)
  80226f:	e8 db e8 ff ff       	call   800b4f <memmove>
  802274:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802277:	89 d8                	mov    %ebx,%eax
  802279:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80227c:	5b                   	pop    %ebx
  80227d:	5e                   	pop    %esi
  80227e:	5d                   	pop    %ebp
  80227f:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802280:	68 93 31 80 00       	push   $0x803193
  802285:	68 5b 31 80 00       	push   $0x80315b
  80228a:	6a 62                	push   $0x62
  80228c:	68 a8 31 80 00       	push   $0x8031a8
  802291:	e8 4b 05 00 00       	call   8027e1 <_panic>

00802296 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
  802299:	53                   	push   %ebx
  80229a:	83 ec 04             	sub    $0x4,%esp
  80229d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022a8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022ae:	7f 2e                	jg     8022de <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022b0:	83 ec 04             	sub    $0x4,%esp
  8022b3:	53                   	push   %ebx
  8022b4:	ff 75 0c             	pushl  0xc(%ebp)
  8022b7:	68 0c 70 80 00       	push   $0x80700c
  8022bc:	e8 8e e8 ff ff       	call   800b4f <memmove>
	nsipcbuf.send.req_size = size;
  8022c1:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8022ca:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022cf:	b8 08 00 00 00       	mov    $0x8,%eax
  8022d4:	e8 eb fd ff ff       	call   8020c4 <nsipc>
}
  8022d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022dc:	c9                   	leave  
  8022dd:	c3                   	ret    
	assert(size < 1600);
  8022de:	68 b4 31 80 00       	push   $0x8031b4
  8022e3:	68 5b 31 80 00       	push   $0x80315b
  8022e8:	6a 6d                	push   $0x6d
  8022ea:	68 a8 31 80 00       	push   $0x8031a8
  8022ef:	e8 ed 04 00 00       	call   8027e1 <_panic>

008022f4 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802302:	8b 45 0c             	mov    0xc(%ebp),%eax
  802305:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80230a:	8b 45 10             	mov    0x10(%ebp),%eax
  80230d:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802312:	b8 09 00 00 00       	mov    $0x9,%eax
  802317:	e8 a8 fd ff ff       	call   8020c4 <nsipc>
}
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	56                   	push   %esi
  802322:	53                   	push   %ebx
  802323:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802326:	83 ec 0c             	sub    $0xc,%esp
  802329:	ff 75 08             	pushl  0x8(%ebp)
  80232c:	e8 6a f3 ff ff       	call   80169b <fd2data>
  802331:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802333:	83 c4 08             	add    $0x8,%esp
  802336:	68 c0 31 80 00       	push   $0x8031c0
  80233b:	53                   	push   %ebx
  80233c:	e8 80 e6 ff ff       	call   8009c1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802341:	8b 46 04             	mov    0x4(%esi),%eax
  802344:	2b 06                	sub    (%esi),%eax
  802346:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80234c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802353:	00 00 00 
	stat->st_dev = &devpipe;
  802356:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80235d:	40 80 00 
	return 0;
}
  802360:	b8 00 00 00 00       	mov    $0x0,%eax
  802365:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802368:	5b                   	pop    %ebx
  802369:	5e                   	pop    %esi
  80236a:	5d                   	pop    %ebp
  80236b:	c3                   	ret    

0080236c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
  80236f:	53                   	push   %ebx
  802370:	83 ec 0c             	sub    $0xc,%esp
  802373:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802376:	53                   	push   %ebx
  802377:	6a 00                	push   $0x0
  802379:	e8 ba ea ff ff       	call   800e38 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80237e:	89 1c 24             	mov    %ebx,(%esp)
  802381:	e8 15 f3 ff ff       	call   80169b <fd2data>
  802386:	83 c4 08             	add    $0x8,%esp
  802389:	50                   	push   %eax
  80238a:	6a 00                	push   $0x0
  80238c:	e8 a7 ea ff ff       	call   800e38 <sys_page_unmap>
}
  802391:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <_pipeisclosed>:
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	57                   	push   %edi
  80239a:	56                   	push   %esi
  80239b:	53                   	push   %ebx
  80239c:	83 ec 1c             	sub    $0x1c,%esp
  80239f:	89 c7                	mov    %eax,%edi
  8023a1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023a3:	a1 08 50 80 00       	mov    0x805008,%eax
  8023a8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023ab:	83 ec 0c             	sub    $0xc,%esp
  8023ae:	57                   	push   %edi
  8023af:	e8 23 05 00 00       	call   8028d7 <pageref>
  8023b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023b7:	89 34 24             	mov    %esi,(%esp)
  8023ba:	e8 18 05 00 00       	call   8028d7 <pageref>
		nn = thisenv->env_runs;
  8023bf:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8023c5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023c8:	83 c4 10             	add    $0x10,%esp
  8023cb:	39 cb                	cmp    %ecx,%ebx
  8023cd:	74 1b                	je     8023ea <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023cf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023d2:	75 cf                	jne    8023a3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023d4:	8b 42 58             	mov    0x58(%edx),%eax
  8023d7:	6a 01                	push   $0x1
  8023d9:	50                   	push   %eax
  8023da:	53                   	push   %ebx
  8023db:	68 c7 31 80 00       	push   $0x8031c7
  8023e0:	e8 7d de ff ff       	call   800262 <cprintf>
  8023e5:	83 c4 10             	add    $0x10,%esp
  8023e8:	eb b9                	jmp    8023a3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8023ea:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023ed:	0f 94 c0             	sete   %al
  8023f0:	0f b6 c0             	movzbl %al,%eax
}
  8023f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023f6:	5b                   	pop    %ebx
  8023f7:	5e                   	pop    %esi
  8023f8:	5f                   	pop    %edi
  8023f9:	5d                   	pop    %ebp
  8023fa:	c3                   	ret    

008023fb <devpipe_write>:
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	57                   	push   %edi
  8023ff:	56                   	push   %esi
  802400:	53                   	push   %ebx
  802401:	83 ec 28             	sub    $0x28,%esp
  802404:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802407:	56                   	push   %esi
  802408:	e8 8e f2 ff ff       	call   80169b <fd2data>
  80240d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80240f:	83 c4 10             	add    $0x10,%esp
  802412:	bf 00 00 00 00       	mov    $0x0,%edi
  802417:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80241a:	74 4f                	je     80246b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80241c:	8b 43 04             	mov    0x4(%ebx),%eax
  80241f:	8b 0b                	mov    (%ebx),%ecx
  802421:	8d 51 20             	lea    0x20(%ecx),%edx
  802424:	39 d0                	cmp    %edx,%eax
  802426:	72 14                	jb     80243c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802428:	89 da                	mov    %ebx,%edx
  80242a:	89 f0                	mov    %esi,%eax
  80242c:	e8 65 ff ff ff       	call   802396 <_pipeisclosed>
  802431:	85 c0                	test   %eax,%eax
  802433:	75 3b                	jne    802470 <devpipe_write+0x75>
			sys_yield();
  802435:	e8 5a e9 ff ff       	call   800d94 <sys_yield>
  80243a:	eb e0                	jmp    80241c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80243c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80243f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802443:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802446:	89 c2                	mov    %eax,%edx
  802448:	c1 fa 1f             	sar    $0x1f,%edx
  80244b:	89 d1                	mov    %edx,%ecx
  80244d:	c1 e9 1b             	shr    $0x1b,%ecx
  802450:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802453:	83 e2 1f             	and    $0x1f,%edx
  802456:	29 ca                	sub    %ecx,%edx
  802458:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80245c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802460:	83 c0 01             	add    $0x1,%eax
  802463:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802466:	83 c7 01             	add    $0x1,%edi
  802469:	eb ac                	jmp    802417 <devpipe_write+0x1c>
	return i;
  80246b:	8b 45 10             	mov    0x10(%ebp),%eax
  80246e:	eb 05                	jmp    802475 <devpipe_write+0x7a>
				return 0;
  802470:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802475:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802478:	5b                   	pop    %ebx
  802479:	5e                   	pop    %esi
  80247a:	5f                   	pop    %edi
  80247b:	5d                   	pop    %ebp
  80247c:	c3                   	ret    

0080247d <devpipe_read>:
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
  802480:	57                   	push   %edi
  802481:	56                   	push   %esi
  802482:	53                   	push   %ebx
  802483:	83 ec 18             	sub    $0x18,%esp
  802486:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802489:	57                   	push   %edi
  80248a:	e8 0c f2 ff ff       	call   80169b <fd2data>
  80248f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802491:	83 c4 10             	add    $0x10,%esp
  802494:	be 00 00 00 00       	mov    $0x0,%esi
  802499:	3b 75 10             	cmp    0x10(%ebp),%esi
  80249c:	75 14                	jne    8024b2 <devpipe_read+0x35>
	return i;
  80249e:	8b 45 10             	mov    0x10(%ebp),%eax
  8024a1:	eb 02                	jmp    8024a5 <devpipe_read+0x28>
				return i;
  8024a3:	89 f0                	mov    %esi,%eax
}
  8024a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024a8:	5b                   	pop    %ebx
  8024a9:	5e                   	pop    %esi
  8024aa:	5f                   	pop    %edi
  8024ab:	5d                   	pop    %ebp
  8024ac:	c3                   	ret    
			sys_yield();
  8024ad:	e8 e2 e8 ff ff       	call   800d94 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024b2:	8b 03                	mov    (%ebx),%eax
  8024b4:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024b7:	75 18                	jne    8024d1 <devpipe_read+0x54>
			if (i > 0)
  8024b9:	85 f6                	test   %esi,%esi
  8024bb:	75 e6                	jne    8024a3 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024bd:	89 da                	mov    %ebx,%edx
  8024bf:	89 f8                	mov    %edi,%eax
  8024c1:	e8 d0 fe ff ff       	call   802396 <_pipeisclosed>
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	74 e3                	je     8024ad <devpipe_read+0x30>
				return 0;
  8024ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cf:	eb d4                	jmp    8024a5 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024d1:	99                   	cltd   
  8024d2:	c1 ea 1b             	shr    $0x1b,%edx
  8024d5:	01 d0                	add    %edx,%eax
  8024d7:	83 e0 1f             	and    $0x1f,%eax
  8024da:	29 d0                	sub    %edx,%eax
  8024dc:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024e4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024e7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8024ea:	83 c6 01             	add    $0x1,%esi
  8024ed:	eb aa                	jmp    802499 <devpipe_read+0x1c>

008024ef <pipe>:
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
  8024f2:	56                   	push   %esi
  8024f3:	53                   	push   %ebx
  8024f4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8024f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024fa:	50                   	push   %eax
  8024fb:	e8 b2 f1 ff ff       	call   8016b2 <fd_alloc>
  802500:	89 c3                	mov    %eax,%ebx
  802502:	83 c4 10             	add    $0x10,%esp
  802505:	85 c0                	test   %eax,%eax
  802507:	0f 88 23 01 00 00    	js     802630 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80250d:	83 ec 04             	sub    $0x4,%esp
  802510:	68 07 04 00 00       	push   $0x407
  802515:	ff 75 f4             	pushl  -0xc(%ebp)
  802518:	6a 00                	push   $0x0
  80251a:	e8 94 e8 ff ff       	call   800db3 <sys_page_alloc>
  80251f:	89 c3                	mov    %eax,%ebx
  802521:	83 c4 10             	add    $0x10,%esp
  802524:	85 c0                	test   %eax,%eax
  802526:	0f 88 04 01 00 00    	js     802630 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80252c:	83 ec 0c             	sub    $0xc,%esp
  80252f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802532:	50                   	push   %eax
  802533:	e8 7a f1 ff ff       	call   8016b2 <fd_alloc>
  802538:	89 c3                	mov    %eax,%ebx
  80253a:	83 c4 10             	add    $0x10,%esp
  80253d:	85 c0                	test   %eax,%eax
  80253f:	0f 88 db 00 00 00    	js     802620 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802545:	83 ec 04             	sub    $0x4,%esp
  802548:	68 07 04 00 00       	push   $0x407
  80254d:	ff 75 f0             	pushl  -0x10(%ebp)
  802550:	6a 00                	push   $0x0
  802552:	e8 5c e8 ff ff       	call   800db3 <sys_page_alloc>
  802557:	89 c3                	mov    %eax,%ebx
  802559:	83 c4 10             	add    $0x10,%esp
  80255c:	85 c0                	test   %eax,%eax
  80255e:	0f 88 bc 00 00 00    	js     802620 <pipe+0x131>
	va = fd2data(fd0);
  802564:	83 ec 0c             	sub    $0xc,%esp
  802567:	ff 75 f4             	pushl  -0xc(%ebp)
  80256a:	e8 2c f1 ff ff       	call   80169b <fd2data>
  80256f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802571:	83 c4 0c             	add    $0xc,%esp
  802574:	68 07 04 00 00       	push   $0x407
  802579:	50                   	push   %eax
  80257a:	6a 00                	push   $0x0
  80257c:	e8 32 e8 ff ff       	call   800db3 <sys_page_alloc>
  802581:	89 c3                	mov    %eax,%ebx
  802583:	83 c4 10             	add    $0x10,%esp
  802586:	85 c0                	test   %eax,%eax
  802588:	0f 88 82 00 00 00    	js     802610 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80258e:	83 ec 0c             	sub    $0xc,%esp
  802591:	ff 75 f0             	pushl  -0x10(%ebp)
  802594:	e8 02 f1 ff ff       	call   80169b <fd2data>
  802599:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025a0:	50                   	push   %eax
  8025a1:	6a 00                	push   $0x0
  8025a3:	56                   	push   %esi
  8025a4:	6a 00                	push   $0x0
  8025a6:	e8 4b e8 ff ff       	call   800df6 <sys_page_map>
  8025ab:	89 c3                	mov    %eax,%ebx
  8025ad:	83 c4 20             	add    $0x20,%esp
  8025b0:	85 c0                	test   %eax,%eax
  8025b2:	78 4e                	js     802602 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8025b4:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8025b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bc:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025cb:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025d7:	83 ec 0c             	sub    $0xc,%esp
  8025da:	ff 75 f4             	pushl  -0xc(%ebp)
  8025dd:	e8 a9 f0 ff ff       	call   80168b <fd2num>
  8025e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025e5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025e7:	83 c4 04             	add    $0x4,%esp
  8025ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8025ed:	e8 99 f0 ff ff       	call   80168b <fd2num>
  8025f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025f5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025f8:	83 c4 10             	add    $0x10,%esp
  8025fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  802600:	eb 2e                	jmp    802630 <pipe+0x141>
	sys_page_unmap(0, va);
  802602:	83 ec 08             	sub    $0x8,%esp
  802605:	56                   	push   %esi
  802606:	6a 00                	push   $0x0
  802608:	e8 2b e8 ff ff       	call   800e38 <sys_page_unmap>
  80260d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802610:	83 ec 08             	sub    $0x8,%esp
  802613:	ff 75 f0             	pushl  -0x10(%ebp)
  802616:	6a 00                	push   $0x0
  802618:	e8 1b e8 ff ff       	call   800e38 <sys_page_unmap>
  80261d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802620:	83 ec 08             	sub    $0x8,%esp
  802623:	ff 75 f4             	pushl  -0xc(%ebp)
  802626:	6a 00                	push   $0x0
  802628:	e8 0b e8 ff ff       	call   800e38 <sys_page_unmap>
  80262d:	83 c4 10             	add    $0x10,%esp
}
  802630:	89 d8                	mov    %ebx,%eax
  802632:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802635:	5b                   	pop    %ebx
  802636:	5e                   	pop    %esi
  802637:	5d                   	pop    %ebp
  802638:	c3                   	ret    

00802639 <pipeisclosed>:
{
  802639:	55                   	push   %ebp
  80263a:	89 e5                	mov    %esp,%ebp
  80263c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80263f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802642:	50                   	push   %eax
  802643:	ff 75 08             	pushl  0x8(%ebp)
  802646:	e8 b9 f0 ff ff       	call   801704 <fd_lookup>
  80264b:	83 c4 10             	add    $0x10,%esp
  80264e:	85 c0                	test   %eax,%eax
  802650:	78 18                	js     80266a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802652:	83 ec 0c             	sub    $0xc,%esp
  802655:	ff 75 f4             	pushl  -0xc(%ebp)
  802658:	e8 3e f0 ff ff       	call   80169b <fd2data>
	return _pipeisclosed(fd, p);
  80265d:	89 c2                	mov    %eax,%edx
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	e8 2f fd ff ff       	call   802396 <_pipeisclosed>
  802667:	83 c4 10             	add    $0x10,%esp
}
  80266a:	c9                   	leave  
  80266b:	c3                   	ret    

0080266c <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80266c:	b8 00 00 00 00       	mov    $0x0,%eax
  802671:	c3                   	ret    

00802672 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802672:	55                   	push   %ebp
  802673:	89 e5                	mov    %esp,%ebp
  802675:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802678:	68 df 31 80 00       	push   $0x8031df
  80267d:	ff 75 0c             	pushl  0xc(%ebp)
  802680:	e8 3c e3 ff ff       	call   8009c1 <strcpy>
	return 0;
}
  802685:	b8 00 00 00 00       	mov    $0x0,%eax
  80268a:	c9                   	leave  
  80268b:	c3                   	ret    

0080268c <devcons_write>:
{
  80268c:	55                   	push   %ebp
  80268d:	89 e5                	mov    %esp,%ebp
  80268f:	57                   	push   %edi
  802690:	56                   	push   %esi
  802691:	53                   	push   %ebx
  802692:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802698:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80269d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026a3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026a6:	73 31                	jae    8026d9 <devcons_write+0x4d>
		m = n - tot;
  8026a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026ab:	29 f3                	sub    %esi,%ebx
  8026ad:	83 fb 7f             	cmp    $0x7f,%ebx
  8026b0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8026b5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8026b8:	83 ec 04             	sub    $0x4,%esp
  8026bb:	53                   	push   %ebx
  8026bc:	89 f0                	mov    %esi,%eax
  8026be:	03 45 0c             	add    0xc(%ebp),%eax
  8026c1:	50                   	push   %eax
  8026c2:	57                   	push   %edi
  8026c3:	e8 87 e4 ff ff       	call   800b4f <memmove>
		sys_cputs(buf, m);
  8026c8:	83 c4 08             	add    $0x8,%esp
  8026cb:	53                   	push   %ebx
  8026cc:	57                   	push   %edi
  8026cd:	e8 25 e6 ff ff       	call   800cf7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8026d2:	01 de                	add    %ebx,%esi
  8026d4:	83 c4 10             	add    $0x10,%esp
  8026d7:	eb ca                	jmp    8026a3 <devcons_write+0x17>
}
  8026d9:	89 f0                	mov    %esi,%eax
  8026db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026de:	5b                   	pop    %ebx
  8026df:	5e                   	pop    %esi
  8026e0:	5f                   	pop    %edi
  8026e1:	5d                   	pop    %ebp
  8026e2:	c3                   	ret    

008026e3 <devcons_read>:
{
  8026e3:	55                   	push   %ebp
  8026e4:	89 e5                	mov    %esp,%ebp
  8026e6:	83 ec 08             	sub    $0x8,%esp
  8026e9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8026ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026f2:	74 21                	je     802715 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8026f4:	e8 1c e6 ff ff       	call   800d15 <sys_cgetc>
  8026f9:	85 c0                	test   %eax,%eax
  8026fb:	75 07                	jne    802704 <devcons_read+0x21>
		sys_yield();
  8026fd:	e8 92 e6 ff ff       	call   800d94 <sys_yield>
  802702:	eb f0                	jmp    8026f4 <devcons_read+0x11>
	if (c < 0)
  802704:	78 0f                	js     802715 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802706:	83 f8 04             	cmp    $0x4,%eax
  802709:	74 0c                	je     802717 <devcons_read+0x34>
	*(char*)vbuf = c;
  80270b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80270e:	88 02                	mov    %al,(%edx)
	return 1;
  802710:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802715:	c9                   	leave  
  802716:	c3                   	ret    
		return 0;
  802717:	b8 00 00 00 00       	mov    $0x0,%eax
  80271c:	eb f7                	jmp    802715 <devcons_read+0x32>

0080271e <cputchar>:
{
  80271e:	55                   	push   %ebp
  80271f:	89 e5                	mov    %esp,%ebp
  802721:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802724:	8b 45 08             	mov    0x8(%ebp),%eax
  802727:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80272a:	6a 01                	push   $0x1
  80272c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80272f:	50                   	push   %eax
  802730:	e8 c2 e5 ff ff       	call   800cf7 <sys_cputs>
}
  802735:	83 c4 10             	add    $0x10,%esp
  802738:	c9                   	leave  
  802739:	c3                   	ret    

0080273a <getchar>:
{
  80273a:	55                   	push   %ebp
  80273b:	89 e5                	mov    %esp,%ebp
  80273d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802740:	6a 01                	push   $0x1
  802742:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802745:	50                   	push   %eax
  802746:	6a 00                	push   $0x0
  802748:	e8 27 f2 ff ff       	call   801974 <read>
	if (r < 0)
  80274d:	83 c4 10             	add    $0x10,%esp
  802750:	85 c0                	test   %eax,%eax
  802752:	78 06                	js     80275a <getchar+0x20>
	if (r < 1)
  802754:	74 06                	je     80275c <getchar+0x22>
	return c;
  802756:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80275a:	c9                   	leave  
  80275b:	c3                   	ret    
		return -E_EOF;
  80275c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802761:	eb f7                	jmp    80275a <getchar+0x20>

00802763 <iscons>:
{
  802763:	55                   	push   %ebp
  802764:	89 e5                	mov    %esp,%ebp
  802766:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802769:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80276c:	50                   	push   %eax
  80276d:	ff 75 08             	pushl  0x8(%ebp)
  802770:	e8 8f ef ff ff       	call   801704 <fd_lookup>
  802775:	83 c4 10             	add    $0x10,%esp
  802778:	85 c0                	test   %eax,%eax
  80277a:	78 11                	js     80278d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802785:	39 10                	cmp    %edx,(%eax)
  802787:	0f 94 c0             	sete   %al
  80278a:	0f b6 c0             	movzbl %al,%eax
}
  80278d:	c9                   	leave  
  80278e:	c3                   	ret    

0080278f <opencons>:
{
  80278f:	55                   	push   %ebp
  802790:	89 e5                	mov    %esp,%ebp
  802792:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802795:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802798:	50                   	push   %eax
  802799:	e8 14 ef ff ff       	call   8016b2 <fd_alloc>
  80279e:	83 c4 10             	add    $0x10,%esp
  8027a1:	85 c0                	test   %eax,%eax
  8027a3:	78 3a                	js     8027df <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027a5:	83 ec 04             	sub    $0x4,%esp
  8027a8:	68 07 04 00 00       	push   $0x407
  8027ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8027b0:	6a 00                	push   $0x0
  8027b2:	e8 fc e5 ff ff       	call   800db3 <sys_page_alloc>
  8027b7:	83 c4 10             	add    $0x10,%esp
  8027ba:	85 c0                	test   %eax,%eax
  8027bc:	78 21                	js     8027df <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027c7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027d3:	83 ec 0c             	sub    $0xc,%esp
  8027d6:	50                   	push   %eax
  8027d7:	e8 af ee ff ff       	call   80168b <fd2num>
  8027dc:	83 c4 10             	add    $0x10,%esp
}
  8027df:	c9                   	leave  
  8027e0:	c3                   	ret    

008027e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8027e1:	55                   	push   %ebp
  8027e2:	89 e5                	mov    %esp,%ebp
  8027e4:	56                   	push   %esi
  8027e5:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8027e6:	a1 08 50 80 00       	mov    0x805008,%eax
  8027eb:	8b 40 48             	mov    0x48(%eax),%eax
  8027ee:	83 ec 04             	sub    $0x4,%esp
  8027f1:	68 10 32 80 00       	push   $0x803210
  8027f6:	50                   	push   %eax
  8027f7:	68 01 2c 80 00       	push   $0x802c01
  8027fc:	e8 61 da ff ff       	call   800262 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802801:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802804:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80280a:	e8 66 e5 ff ff       	call   800d75 <sys_getenvid>
  80280f:	83 c4 04             	add    $0x4,%esp
  802812:	ff 75 0c             	pushl  0xc(%ebp)
  802815:	ff 75 08             	pushl  0x8(%ebp)
  802818:	56                   	push   %esi
  802819:	50                   	push   %eax
  80281a:	68 ec 31 80 00       	push   $0x8031ec
  80281f:	e8 3e da ff ff       	call   800262 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802824:	83 c4 18             	add    $0x18,%esp
  802827:	53                   	push   %ebx
  802828:	ff 75 10             	pushl  0x10(%ebp)
  80282b:	e8 e1 d9 ff ff       	call   800211 <vcprintf>
	cprintf("\n");
  802830:	c7 04 24 c5 2b 80 00 	movl   $0x802bc5,(%esp)
  802837:	e8 26 da ff ff       	call   800262 <cprintf>
  80283c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80283f:	cc                   	int3   
  802840:	eb fd                	jmp    80283f <_panic+0x5e>

00802842 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802842:	55                   	push   %ebp
  802843:	89 e5                	mov    %esp,%ebp
  802845:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802848:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80284f:	74 0a                	je     80285b <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802851:	8b 45 08             	mov    0x8(%ebp),%eax
  802854:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802859:	c9                   	leave  
  80285a:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80285b:	83 ec 04             	sub    $0x4,%esp
  80285e:	6a 07                	push   $0x7
  802860:	68 00 f0 bf ee       	push   $0xeebff000
  802865:	6a 00                	push   $0x0
  802867:	e8 47 e5 ff ff       	call   800db3 <sys_page_alloc>
		if(r < 0)
  80286c:	83 c4 10             	add    $0x10,%esp
  80286f:	85 c0                	test   %eax,%eax
  802871:	78 2a                	js     80289d <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802873:	83 ec 08             	sub    $0x8,%esp
  802876:	68 b1 28 80 00       	push   $0x8028b1
  80287b:	6a 00                	push   $0x0
  80287d:	e8 7c e6 ff ff       	call   800efe <sys_env_set_pgfault_upcall>
		if(r < 0)
  802882:	83 c4 10             	add    $0x10,%esp
  802885:	85 c0                	test   %eax,%eax
  802887:	79 c8                	jns    802851 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802889:	83 ec 04             	sub    $0x4,%esp
  80288c:	68 48 32 80 00       	push   $0x803248
  802891:	6a 25                	push   $0x25
  802893:	68 84 32 80 00       	push   $0x803284
  802898:	e8 44 ff ff ff       	call   8027e1 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80289d:	83 ec 04             	sub    $0x4,%esp
  8028a0:	68 18 32 80 00       	push   $0x803218
  8028a5:	6a 22                	push   $0x22
  8028a7:	68 84 32 80 00       	push   $0x803284
  8028ac:	e8 30 ff ff ff       	call   8027e1 <_panic>

008028b1 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028b1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8028b2:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8028b7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028b9:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8028bc:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8028c0:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8028c4:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8028c7:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8028c9:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8028cd:	83 c4 08             	add    $0x8,%esp
	popal
  8028d0:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8028d1:	83 c4 04             	add    $0x4,%esp
	popfl
  8028d4:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8028d5:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8028d6:	c3                   	ret    

008028d7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028d7:	55                   	push   %ebp
  8028d8:	89 e5                	mov    %esp,%ebp
  8028da:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028dd:	89 d0                	mov    %edx,%eax
  8028df:	c1 e8 16             	shr    $0x16,%eax
  8028e2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028e9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028ee:	f6 c1 01             	test   $0x1,%cl
  8028f1:	74 1d                	je     802910 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028f3:	c1 ea 0c             	shr    $0xc,%edx
  8028f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028fd:	f6 c2 01             	test   $0x1,%dl
  802900:	74 0e                	je     802910 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802902:	c1 ea 0c             	shr    $0xc,%edx
  802905:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80290c:	ef 
  80290d:	0f b7 c0             	movzwl %ax,%eax
}
  802910:	5d                   	pop    %ebp
  802911:	c3                   	ret    
  802912:	66 90                	xchg   %ax,%ax
  802914:	66 90                	xchg   %ax,%ax
  802916:	66 90                	xchg   %ax,%ax
  802918:	66 90                	xchg   %ax,%ax
  80291a:	66 90                	xchg   %ax,%ax
  80291c:	66 90                	xchg   %ax,%ax
  80291e:	66 90                	xchg   %ax,%ax

00802920 <__udivdi3>:
  802920:	55                   	push   %ebp
  802921:	57                   	push   %edi
  802922:	56                   	push   %esi
  802923:	53                   	push   %ebx
  802924:	83 ec 1c             	sub    $0x1c,%esp
  802927:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80292b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80292f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802933:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802937:	85 d2                	test   %edx,%edx
  802939:	75 4d                	jne    802988 <__udivdi3+0x68>
  80293b:	39 f3                	cmp    %esi,%ebx
  80293d:	76 19                	jbe    802958 <__udivdi3+0x38>
  80293f:	31 ff                	xor    %edi,%edi
  802941:	89 e8                	mov    %ebp,%eax
  802943:	89 f2                	mov    %esi,%edx
  802945:	f7 f3                	div    %ebx
  802947:	89 fa                	mov    %edi,%edx
  802949:	83 c4 1c             	add    $0x1c,%esp
  80294c:	5b                   	pop    %ebx
  80294d:	5e                   	pop    %esi
  80294e:	5f                   	pop    %edi
  80294f:	5d                   	pop    %ebp
  802950:	c3                   	ret    
  802951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802958:	89 d9                	mov    %ebx,%ecx
  80295a:	85 db                	test   %ebx,%ebx
  80295c:	75 0b                	jne    802969 <__udivdi3+0x49>
  80295e:	b8 01 00 00 00       	mov    $0x1,%eax
  802963:	31 d2                	xor    %edx,%edx
  802965:	f7 f3                	div    %ebx
  802967:	89 c1                	mov    %eax,%ecx
  802969:	31 d2                	xor    %edx,%edx
  80296b:	89 f0                	mov    %esi,%eax
  80296d:	f7 f1                	div    %ecx
  80296f:	89 c6                	mov    %eax,%esi
  802971:	89 e8                	mov    %ebp,%eax
  802973:	89 f7                	mov    %esi,%edi
  802975:	f7 f1                	div    %ecx
  802977:	89 fa                	mov    %edi,%edx
  802979:	83 c4 1c             	add    $0x1c,%esp
  80297c:	5b                   	pop    %ebx
  80297d:	5e                   	pop    %esi
  80297e:	5f                   	pop    %edi
  80297f:	5d                   	pop    %ebp
  802980:	c3                   	ret    
  802981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802988:	39 f2                	cmp    %esi,%edx
  80298a:	77 1c                	ja     8029a8 <__udivdi3+0x88>
  80298c:	0f bd fa             	bsr    %edx,%edi
  80298f:	83 f7 1f             	xor    $0x1f,%edi
  802992:	75 2c                	jne    8029c0 <__udivdi3+0xa0>
  802994:	39 f2                	cmp    %esi,%edx
  802996:	72 06                	jb     80299e <__udivdi3+0x7e>
  802998:	31 c0                	xor    %eax,%eax
  80299a:	39 eb                	cmp    %ebp,%ebx
  80299c:	77 a9                	ja     802947 <__udivdi3+0x27>
  80299e:	b8 01 00 00 00       	mov    $0x1,%eax
  8029a3:	eb a2                	jmp    802947 <__udivdi3+0x27>
  8029a5:	8d 76 00             	lea    0x0(%esi),%esi
  8029a8:	31 ff                	xor    %edi,%edi
  8029aa:	31 c0                	xor    %eax,%eax
  8029ac:	89 fa                	mov    %edi,%edx
  8029ae:	83 c4 1c             	add    $0x1c,%esp
  8029b1:	5b                   	pop    %ebx
  8029b2:	5e                   	pop    %esi
  8029b3:	5f                   	pop    %edi
  8029b4:	5d                   	pop    %ebp
  8029b5:	c3                   	ret    
  8029b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029bd:	8d 76 00             	lea    0x0(%esi),%esi
  8029c0:	89 f9                	mov    %edi,%ecx
  8029c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8029c7:	29 f8                	sub    %edi,%eax
  8029c9:	d3 e2                	shl    %cl,%edx
  8029cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029cf:	89 c1                	mov    %eax,%ecx
  8029d1:	89 da                	mov    %ebx,%edx
  8029d3:	d3 ea                	shr    %cl,%edx
  8029d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029d9:	09 d1                	or     %edx,%ecx
  8029db:	89 f2                	mov    %esi,%edx
  8029dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029e1:	89 f9                	mov    %edi,%ecx
  8029e3:	d3 e3                	shl    %cl,%ebx
  8029e5:	89 c1                	mov    %eax,%ecx
  8029e7:	d3 ea                	shr    %cl,%edx
  8029e9:	89 f9                	mov    %edi,%ecx
  8029eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029ef:	89 eb                	mov    %ebp,%ebx
  8029f1:	d3 e6                	shl    %cl,%esi
  8029f3:	89 c1                	mov    %eax,%ecx
  8029f5:	d3 eb                	shr    %cl,%ebx
  8029f7:	09 de                	or     %ebx,%esi
  8029f9:	89 f0                	mov    %esi,%eax
  8029fb:	f7 74 24 08          	divl   0x8(%esp)
  8029ff:	89 d6                	mov    %edx,%esi
  802a01:	89 c3                	mov    %eax,%ebx
  802a03:	f7 64 24 0c          	mull   0xc(%esp)
  802a07:	39 d6                	cmp    %edx,%esi
  802a09:	72 15                	jb     802a20 <__udivdi3+0x100>
  802a0b:	89 f9                	mov    %edi,%ecx
  802a0d:	d3 e5                	shl    %cl,%ebp
  802a0f:	39 c5                	cmp    %eax,%ebp
  802a11:	73 04                	jae    802a17 <__udivdi3+0xf7>
  802a13:	39 d6                	cmp    %edx,%esi
  802a15:	74 09                	je     802a20 <__udivdi3+0x100>
  802a17:	89 d8                	mov    %ebx,%eax
  802a19:	31 ff                	xor    %edi,%edi
  802a1b:	e9 27 ff ff ff       	jmp    802947 <__udivdi3+0x27>
  802a20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a23:	31 ff                	xor    %edi,%edi
  802a25:	e9 1d ff ff ff       	jmp    802947 <__udivdi3+0x27>
  802a2a:	66 90                	xchg   %ax,%ax
  802a2c:	66 90                	xchg   %ax,%ax
  802a2e:	66 90                	xchg   %ax,%ax

00802a30 <__umoddi3>:
  802a30:	55                   	push   %ebp
  802a31:	57                   	push   %edi
  802a32:	56                   	push   %esi
  802a33:	53                   	push   %ebx
  802a34:	83 ec 1c             	sub    $0x1c,%esp
  802a37:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a3f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a47:	89 da                	mov    %ebx,%edx
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	75 43                	jne    802a90 <__umoddi3+0x60>
  802a4d:	39 df                	cmp    %ebx,%edi
  802a4f:	76 17                	jbe    802a68 <__umoddi3+0x38>
  802a51:	89 f0                	mov    %esi,%eax
  802a53:	f7 f7                	div    %edi
  802a55:	89 d0                	mov    %edx,%eax
  802a57:	31 d2                	xor    %edx,%edx
  802a59:	83 c4 1c             	add    $0x1c,%esp
  802a5c:	5b                   	pop    %ebx
  802a5d:	5e                   	pop    %esi
  802a5e:	5f                   	pop    %edi
  802a5f:	5d                   	pop    %ebp
  802a60:	c3                   	ret    
  802a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a68:	89 fd                	mov    %edi,%ebp
  802a6a:	85 ff                	test   %edi,%edi
  802a6c:	75 0b                	jne    802a79 <__umoddi3+0x49>
  802a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a73:	31 d2                	xor    %edx,%edx
  802a75:	f7 f7                	div    %edi
  802a77:	89 c5                	mov    %eax,%ebp
  802a79:	89 d8                	mov    %ebx,%eax
  802a7b:	31 d2                	xor    %edx,%edx
  802a7d:	f7 f5                	div    %ebp
  802a7f:	89 f0                	mov    %esi,%eax
  802a81:	f7 f5                	div    %ebp
  802a83:	89 d0                	mov    %edx,%eax
  802a85:	eb d0                	jmp    802a57 <__umoddi3+0x27>
  802a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a8e:	66 90                	xchg   %ax,%ax
  802a90:	89 f1                	mov    %esi,%ecx
  802a92:	39 d8                	cmp    %ebx,%eax
  802a94:	76 0a                	jbe    802aa0 <__umoddi3+0x70>
  802a96:	89 f0                	mov    %esi,%eax
  802a98:	83 c4 1c             	add    $0x1c,%esp
  802a9b:	5b                   	pop    %ebx
  802a9c:	5e                   	pop    %esi
  802a9d:	5f                   	pop    %edi
  802a9e:	5d                   	pop    %ebp
  802a9f:	c3                   	ret    
  802aa0:	0f bd e8             	bsr    %eax,%ebp
  802aa3:	83 f5 1f             	xor    $0x1f,%ebp
  802aa6:	75 20                	jne    802ac8 <__umoddi3+0x98>
  802aa8:	39 d8                	cmp    %ebx,%eax
  802aaa:	0f 82 b0 00 00 00    	jb     802b60 <__umoddi3+0x130>
  802ab0:	39 f7                	cmp    %esi,%edi
  802ab2:	0f 86 a8 00 00 00    	jbe    802b60 <__umoddi3+0x130>
  802ab8:	89 c8                	mov    %ecx,%eax
  802aba:	83 c4 1c             	add    $0x1c,%esp
  802abd:	5b                   	pop    %ebx
  802abe:	5e                   	pop    %esi
  802abf:	5f                   	pop    %edi
  802ac0:	5d                   	pop    %ebp
  802ac1:	c3                   	ret    
  802ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ac8:	89 e9                	mov    %ebp,%ecx
  802aca:	ba 20 00 00 00       	mov    $0x20,%edx
  802acf:	29 ea                	sub    %ebp,%edx
  802ad1:	d3 e0                	shl    %cl,%eax
  802ad3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ad7:	89 d1                	mov    %edx,%ecx
  802ad9:	89 f8                	mov    %edi,%eax
  802adb:	d3 e8                	shr    %cl,%eax
  802add:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ae1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ae5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ae9:	09 c1                	or     %eax,%ecx
  802aeb:	89 d8                	mov    %ebx,%eax
  802aed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802af1:	89 e9                	mov    %ebp,%ecx
  802af3:	d3 e7                	shl    %cl,%edi
  802af5:	89 d1                	mov    %edx,%ecx
  802af7:	d3 e8                	shr    %cl,%eax
  802af9:	89 e9                	mov    %ebp,%ecx
  802afb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802aff:	d3 e3                	shl    %cl,%ebx
  802b01:	89 c7                	mov    %eax,%edi
  802b03:	89 d1                	mov    %edx,%ecx
  802b05:	89 f0                	mov    %esi,%eax
  802b07:	d3 e8                	shr    %cl,%eax
  802b09:	89 e9                	mov    %ebp,%ecx
  802b0b:	89 fa                	mov    %edi,%edx
  802b0d:	d3 e6                	shl    %cl,%esi
  802b0f:	09 d8                	or     %ebx,%eax
  802b11:	f7 74 24 08          	divl   0x8(%esp)
  802b15:	89 d1                	mov    %edx,%ecx
  802b17:	89 f3                	mov    %esi,%ebx
  802b19:	f7 64 24 0c          	mull   0xc(%esp)
  802b1d:	89 c6                	mov    %eax,%esi
  802b1f:	89 d7                	mov    %edx,%edi
  802b21:	39 d1                	cmp    %edx,%ecx
  802b23:	72 06                	jb     802b2b <__umoddi3+0xfb>
  802b25:	75 10                	jne    802b37 <__umoddi3+0x107>
  802b27:	39 c3                	cmp    %eax,%ebx
  802b29:	73 0c                	jae    802b37 <__umoddi3+0x107>
  802b2b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b2f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b33:	89 d7                	mov    %edx,%edi
  802b35:	89 c6                	mov    %eax,%esi
  802b37:	89 ca                	mov    %ecx,%edx
  802b39:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b3e:	29 f3                	sub    %esi,%ebx
  802b40:	19 fa                	sbb    %edi,%edx
  802b42:	89 d0                	mov    %edx,%eax
  802b44:	d3 e0                	shl    %cl,%eax
  802b46:	89 e9                	mov    %ebp,%ecx
  802b48:	d3 eb                	shr    %cl,%ebx
  802b4a:	d3 ea                	shr    %cl,%edx
  802b4c:	09 d8                	or     %ebx,%eax
  802b4e:	83 c4 1c             	add    $0x1c,%esp
  802b51:	5b                   	pop    %ebx
  802b52:	5e                   	pop    %esi
  802b53:	5f                   	pop    %edi
  802b54:	5d                   	pop    %ebp
  802b55:	c3                   	ret    
  802b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b5d:	8d 76 00             	lea    0x0(%esi),%esi
  802b60:	89 da                	mov    %ebx,%edx
  802b62:	29 fe                	sub    %edi,%esi
  802b64:	19 c2                	sbb    %eax,%edx
  802b66:	89 f1                	mov    %esi,%ecx
  802b68:	89 c8                	mov    %ecx,%eax
  802b6a:	e9 4b ff ff ff       	jmp    802aba <__umoddi3+0x8a>
