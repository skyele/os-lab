
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
  80003c:	e8 be 12 00 00       	call   8012ff <fork>
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
  800053:	e8 3f 15 00 00       	call   801597 <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 15 0d 00 00       	call   800d77 <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 96 2b 80 00       	push   $0x802b96
  80006a:	e8 f5 01 00 00       	call   800264 <cprintf>
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
  800082:	e8 79 15 00 00       	call   801600 <ipc_send>
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
  800099:	e8 d9 0c 00 00       	call   800d77 <sys_getenvid>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	50                   	push   %eax
  8000a3:	68 80 2b 80 00       	push   $0x802b80
  8000a8:	e8 b7 01 00 00       	call   800264 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	e8 45 15 00 00       	call   801600 <ipc_send>
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
  8000d3:	e8 9f 0c 00 00       	call   800d77 <sys_getenvid>
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
  8000f8:	74 23                	je     80011d <libmain+0x5d>
		if(envs[i].env_id == find)
  8000fa:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800100:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800106:	8b 49 48             	mov    0x48(%ecx),%ecx
  800109:	39 c1                	cmp    %eax,%ecx
  80010b:	75 e2                	jne    8000ef <libmain+0x2f>
  80010d:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800113:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800119:	89 fe                	mov    %edi,%esi
  80011b:	eb d2                	jmp    8000ef <libmain+0x2f>
  80011d:	89 f0                	mov    %esi,%eax
  80011f:	84 c0                	test   %al,%al
  800121:	74 06                	je     800129 <libmain+0x69>
  800123:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800129:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80012d:	7e 0a                	jle    800139 <libmain+0x79>
		binaryname = argv[0];
  80012f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800132:	8b 00                	mov    (%eax),%eax
  800134:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800139:	a1 08 50 80 00       	mov    0x805008,%eax
  80013e:	8b 40 48             	mov    0x48(%eax),%eax
  800141:	83 ec 08             	sub    $0x8,%esp
  800144:	50                   	push   %eax
  800145:	68 a9 2b 80 00       	push   $0x802ba9
  80014a:	e8 15 01 00 00       	call   800264 <cprintf>
	cprintf("before umain\n");
  80014f:	c7 04 24 c7 2b 80 00 	movl   $0x802bc7,(%esp)
  800156:	e8 09 01 00 00       	call   800264 <cprintf>
	// call user main routine
	umain(argc, argv);
  80015b:	83 c4 08             	add    $0x8,%esp
  80015e:	ff 75 0c             	pushl  0xc(%ebp)
  800161:	ff 75 08             	pushl  0x8(%ebp)
  800164:	e8 ca fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800169:	c7 04 24 d5 2b 80 00 	movl   $0x802bd5,(%esp)
  800170:	e8 ef 00 00 00       	call   800264 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800175:	a1 08 50 80 00       	mov    0x805008,%eax
  80017a:	8b 40 48             	mov    0x48(%eax),%eax
  80017d:	83 c4 08             	add    $0x8,%esp
  800180:	50                   	push   %eax
  800181:	68 e2 2b 80 00       	push   $0x802be2
  800186:	e8 d9 00 00 00       	call   800264 <cprintf>
	// exit gracefully
	exit();
  80018b:	e8 0b 00 00 00       	call   80019b <exit>
}
  800190:	83 c4 10             	add    $0x10,%esp
  800193:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800196:	5b                   	pop    %ebx
  800197:	5e                   	pop    %esi
  800198:	5f                   	pop    %edi
  800199:	5d                   	pop    %ebp
  80019a:	c3                   	ret    

0080019b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001a1:	a1 08 50 80 00       	mov    0x805008,%eax
  8001a6:	8b 40 48             	mov    0x48(%eax),%eax
  8001a9:	68 0c 2c 80 00       	push   $0x802c0c
  8001ae:	50                   	push   %eax
  8001af:	68 01 2c 80 00       	push   $0x802c01
  8001b4:	e8 ab 00 00 00       	call   800264 <cprintf>
	close_all();
  8001b9:	e8 b1 16 00 00       	call   80186f <close_all>
	sys_env_destroy(0);
  8001be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001c5:	e8 6c 0b 00 00       	call   800d36 <sys_env_destroy>
}
  8001ca:	83 c4 10             	add    $0x10,%esp
  8001cd:	c9                   	leave  
  8001ce:	c3                   	ret    

008001cf <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001cf:	55                   	push   %ebp
  8001d0:	89 e5                	mov    %esp,%ebp
  8001d2:	53                   	push   %ebx
  8001d3:	83 ec 04             	sub    $0x4,%esp
  8001d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d9:	8b 13                	mov    (%ebx),%edx
  8001db:	8d 42 01             	lea    0x1(%edx),%eax
  8001de:	89 03                	mov    %eax,(%ebx)
  8001e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ec:	74 09                	je     8001f7 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ee:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001f7:	83 ec 08             	sub    $0x8,%esp
  8001fa:	68 ff 00 00 00       	push   $0xff
  8001ff:	8d 43 08             	lea    0x8(%ebx),%eax
  800202:	50                   	push   %eax
  800203:	e8 f1 0a 00 00       	call   800cf9 <sys_cputs>
		b->idx = 0;
  800208:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	eb db                	jmp    8001ee <putch+0x1f>

00800213 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80021c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800223:	00 00 00 
	b.cnt = 0;
  800226:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80022d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800230:	ff 75 0c             	pushl  0xc(%ebp)
  800233:	ff 75 08             	pushl  0x8(%ebp)
  800236:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023c:	50                   	push   %eax
  80023d:	68 cf 01 80 00       	push   $0x8001cf
  800242:	e8 4a 01 00 00       	call   800391 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800247:	83 c4 08             	add    $0x8,%esp
  80024a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800250:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800256:	50                   	push   %eax
  800257:	e8 9d 0a 00 00       	call   800cf9 <sys_cputs>

	return b.cnt;
}
  80025c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800262:	c9                   	leave  
  800263:	c3                   	ret    

00800264 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80026a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80026d:	50                   	push   %eax
  80026e:	ff 75 08             	pushl  0x8(%ebp)
  800271:	e8 9d ff ff ff       	call   800213 <vcprintf>
	va_end(ap);

	return cnt;
}
  800276:	c9                   	leave  
  800277:	c3                   	ret    

00800278 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	57                   	push   %edi
  80027c:	56                   	push   %esi
  80027d:	53                   	push   %ebx
  80027e:	83 ec 1c             	sub    $0x1c,%esp
  800281:	89 c6                	mov    %eax,%esi
  800283:	89 d7                	mov    %edx,%edi
  800285:	8b 45 08             	mov    0x8(%ebp),%eax
  800288:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80028e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800291:	8b 45 10             	mov    0x10(%ebp),%eax
  800294:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800297:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80029b:	74 2c                	je     8002c9 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80029d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002a0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002aa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002ad:	39 c2                	cmp    %eax,%edx
  8002af:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002b2:	73 43                	jae    8002f7 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002b4:	83 eb 01             	sub    $0x1,%ebx
  8002b7:	85 db                	test   %ebx,%ebx
  8002b9:	7e 6c                	jle    800327 <printnum+0xaf>
				putch(padc, putdat);
  8002bb:	83 ec 08             	sub    $0x8,%esp
  8002be:	57                   	push   %edi
  8002bf:	ff 75 18             	pushl  0x18(%ebp)
  8002c2:	ff d6                	call   *%esi
  8002c4:	83 c4 10             	add    $0x10,%esp
  8002c7:	eb eb                	jmp    8002b4 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002c9:	83 ec 0c             	sub    $0xc,%esp
  8002cc:	6a 20                	push   $0x20
  8002ce:	6a 00                	push   $0x0
  8002d0:	50                   	push   %eax
  8002d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d4:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d7:	89 fa                	mov    %edi,%edx
  8002d9:	89 f0                	mov    %esi,%eax
  8002db:	e8 98 ff ff ff       	call   800278 <printnum>
		while (--width > 0)
  8002e0:	83 c4 20             	add    $0x20,%esp
  8002e3:	83 eb 01             	sub    $0x1,%ebx
  8002e6:	85 db                	test   %ebx,%ebx
  8002e8:	7e 65                	jle    80034f <printnum+0xd7>
			putch(padc, putdat);
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	57                   	push   %edi
  8002ee:	6a 20                	push   $0x20
  8002f0:	ff d6                	call   *%esi
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	eb ec                	jmp    8002e3 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	ff 75 18             	pushl  0x18(%ebp)
  8002fd:	83 eb 01             	sub    $0x1,%ebx
  800300:	53                   	push   %ebx
  800301:	50                   	push   %eax
  800302:	83 ec 08             	sub    $0x8,%esp
  800305:	ff 75 dc             	pushl  -0x24(%ebp)
  800308:	ff 75 d8             	pushl  -0x28(%ebp)
  80030b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030e:	ff 75 e0             	pushl  -0x20(%ebp)
  800311:	e8 0a 26 00 00       	call   802920 <__udivdi3>
  800316:	83 c4 18             	add    $0x18,%esp
  800319:	52                   	push   %edx
  80031a:	50                   	push   %eax
  80031b:	89 fa                	mov    %edi,%edx
  80031d:	89 f0                	mov    %esi,%eax
  80031f:	e8 54 ff ff ff       	call   800278 <printnum>
  800324:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	57                   	push   %edi
  80032b:	83 ec 04             	sub    $0x4,%esp
  80032e:	ff 75 dc             	pushl  -0x24(%ebp)
  800331:	ff 75 d8             	pushl  -0x28(%ebp)
  800334:	ff 75 e4             	pushl  -0x1c(%ebp)
  800337:	ff 75 e0             	pushl  -0x20(%ebp)
  80033a:	e8 f1 26 00 00       	call   802a30 <__umoddi3>
  80033f:	83 c4 14             	add    $0x14,%esp
  800342:	0f be 80 11 2c 80 00 	movsbl 0x802c11(%eax),%eax
  800349:	50                   	push   %eax
  80034a:	ff d6                	call   *%esi
  80034c:	83 c4 10             	add    $0x10,%esp
	}
}
  80034f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800352:	5b                   	pop    %ebx
  800353:	5e                   	pop    %esi
  800354:	5f                   	pop    %edi
  800355:	5d                   	pop    %ebp
  800356:	c3                   	ret    

00800357 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80035d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800361:	8b 10                	mov    (%eax),%edx
  800363:	3b 50 04             	cmp    0x4(%eax),%edx
  800366:	73 0a                	jae    800372 <sprintputch+0x1b>
		*b->buf++ = ch;
  800368:	8d 4a 01             	lea    0x1(%edx),%ecx
  80036b:	89 08                	mov    %ecx,(%eax)
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	88 02                	mov    %al,(%edx)
}
  800372:	5d                   	pop    %ebp
  800373:	c3                   	ret    

00800374 <printfmt>:
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80037a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80037d:	50                   	push   %eax
  80037e:	ff 75 10             	pushl  0x10(%ebp)
  800381:	ff 75 0c             	pushl  0xc(%ebp)
  800384:	ff 75 08             	pushl  0x8(%ebp)
  800387:	e8 05 00 00 00       	call   800391 <vprintfmt>
}
  80038c:	83 c4 10             	add    $0x10,%esp
  80038f:	c9                   	leave  
  800390:	c3                   	ret    

00800391 <vprintfmt>:
{
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
  800394:	57                   	push   %edi
  800395:	56                   	push   %esi
  800396:	53                   	push   %ebx
  800397:	83 ec 3c             	sub    $0x3c,%esp
  80039a:	8b 75 08             	mov    0x8(%ebp),%esi
  80039d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003a0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a3:	e9 32 04 00 00       	jmp    8007da <vprintfmt+0x449>
		padc = ' ';
  8003a8:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003ac:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003b3:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003ba:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003c1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003c8:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003cf:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d4:	8d 47 01             	lea    0x1(%edi),%eax
  8003d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003da:	0f b6 17             	movzbl (%edi),%edx
  8003dd:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003e0:	3c 55                	cmp    $0x55,%al
  8003e2:	0f 87 12 05 00 00    	ja     8008fa <vprintfmt+0x569>
  8003e8:	0f b6 c0             	movzbl %al,%eax
  8003eb:	ff 24 85 e0 2d 80 00 	jmp    *0x802de0(,%eax,4)
  8003f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003f5:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003f9:	eb d9                	jmp    8003d4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003fe:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800402:	eb d0                	jmp    8003d4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800404:	0f b6 d2             	movzbl %dl,%edx
  800407:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80040a:	b8 00 00 00 00       	mov    $0x0,%eax
  80040f:	89 75 08             	mov    %esi,0x8(%ebp)
  800412:	eb 03                	jmp    800417 <vprintfmt+0x86>
  800414:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800417:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80041a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80041e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800421:	8d 72 d0             	lea    -0x30(%edx),%esi
  800424:	83 fe 09             	cmp    $0x9,%esi
  800427:	76 eb                	jbe    800414 <vprintfmt+0x83>
  800429:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80042c:	8b 75 08             	mov    0x8(%ebp),%esi
  80042f:	eb 14                	jmp    800445 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800431:	8b 45 14             	mov    0x14(%ebp),%eax
  800434:	8b 00                	mov    (%eax),%eax
  800436:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800439:	8b 45 14             	mov    0x14(%ebp),%eax
  80043c:	8d 40 04             	lea    0x4(%eax),%eax
  80043f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800442:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800445:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800449:	79 89                	jns    8003d4 <vprintfmt+0x43>
				width = precision, precision = -1;
  80044b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80044e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800451:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800458:	e9 77 ff ff ff       	jmp    8003d4 <vprintfmt+0x43>
  80045d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800460:	85 c0                	test   %eax,%eax
  800462:	0f 48 c1             	cmovs  %ecx,%eax
  800465:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800468:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80046b:	e9 64 ff ff ff       	jmp    8003d4 <vprintfmt+0x43>
  800470:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800473:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80047a:	e9 55 ff ff ff       	jmp    8003d4 <vprintfmt+0x43>
			lflag++;
  80047f:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800483:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800486:	e9 49 ff ff ff       	jmp    8003d4 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80048b:	8b 45 14             	mov    0x14(%ebp),%eax
  80048e:	8d 78 04             	lea    0x4(%eax),%edi
  800491:	83 ec 08             	sub    $0x8,%esp
  800494:	53                   	push   %ebx
  800495:	ff 30                	pushl  (%eax)
  800497:	ff d6                	call   *%esi
			break;
  800499:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80049c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80049f:	e9 33 03 00 00       	jmp    8007d7 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a7:	8d 78 04             	lea    0x4(%eax),%edi
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	99                   	cltd   
  8004ad:	31 d0                	xor    %edx,%eax
  8004af:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004b1:	83 f8 11             	cmp    $0x11,%eax
  8004b4:	7f 23                	jg     8004d9 <vprintfmt+0x148>
  8004b6:	8b 14 85 40 2f 80 00 	mov    0x802f40(,%eax,4),%edx
  8004bd:	85 d2                	test   %edx,%edx
  8004bf:	74 18                	je     8004d9 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004c1:	52                   	push   %edx
  8004c2:	68 6d 31 80 00       	push   $0x80316d
  8004c7:	53                   	push   %ebx
  8004c8:	56                   	push   %esi
  8004c9:	e8 a6 fe ff ff       	call   800374 <printfmt>
  8004ce:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004d1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004d4:	e9 fe 02 00 00       	jmp    8007d7 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004d9:	50                   	push   %eax
  8004da:	68 29 2c 80 00       	push   $0x802c29
  8004df:	53                   	push   %ebx
  8004e0:	56                   	push   %esi
  8004e1:	e8 8e fe ff ff       	call   800374 <printfmt>
  8004e6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004ec:	e9 e6 02 00 00       	jmp    8007d7 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	83 c0 04             	add    $0x4,%eax
  8004f7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fd:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004ff:	85 c9                	test   %ecx,%ecx
  800501:	b8 22 2c 80 00       	mov    $0x802c22,%eax
  800506:	0f 45 c1             	cmovne %ecx,%eax
  800509:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80050c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800510:	7e 06                	jle    800518 <vprintfmt+0x187>
  800512:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800516:	75 0d                	jne    800525 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800518:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80051b:	89 c7                	mov    %eax,%edi
  80051d:	03 45 e0             	add    -0x20(%ebp),%eax
  800520:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800523:	eb 53                	jmp    800578 <vprintfmt+0x1e7>
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	ff 75 d8             	pushl  -0x28(%ebp)
  80052b:	50                   	push   %eax
  80052c:	e8 71 04 00 00       	call   8009a2 <strnlen>
  800531:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800534:	29 c1                	sub    %eax,%ecx
  800536:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800539:	83 c4 10             	add    $0x10,%esp
  80053c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80053e:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800542:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800545:	eb 0f                	jmp    800556 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	53                   	push   %ebx
  80054b:	ff 75 e0             	pushl  -0x20(%ebp)
  80054e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800550:	83 ef 01             	sub    $0x1,%edi
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	85 ff                	test   %edi,%edi
  800558:	7f ed                	jg     800547 <vprintfmt+0x1b6>
  80055a:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80055d:	85 c9                	test   %ecx,%ecx
  80055f:	b8 00 00 00 00       	mov    $0x0,%eax
  800564:	0f 49 c1             	cmovns %ecx,%eax
  800567:	29 c1                	sub    %eax,%ecx
  800569:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80056c:	eb aa                	jmp    800518 <vprintfmt+0x187>
					putch(ch, putdat);
  80056e:	83 ec 08             	sub    $0x8,%esp
  800571:	53                   	push   %ebx
  800572:	52                   	push   %edx
  800573:	ff d6                	call   *%esi
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80057b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80057d:	83 c7 01             	add    $0x1,%edi
  800580:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800584:	0f be d0             	movsbl %al,%edx
  800587:	85 d2                	test   %edx,%edx
  800589:	74 4b                	je     8005d6 <vprintfmt+0x245>
  80058b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80058f:	78 06                	js     800597 <vprintfmt+0x206>
  800591:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800595:	78 1e                	js     8005b5 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800597:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80059b:	74 d1                	je     80056e <vprintfmt+0x1dd>
  80059d:	0f be c0             	movsbl %al,%eax
  8005a0:	83 e8 20             	sub    $0x20,%eax
  8005a3:	83 f8 5e             	cmp    $0x5e,%eax
  8005a6:	76 c6                	jbe    80056e <vprintfmt+0x1dd>
					putch('?', putdat);
  8005a8:	83 ec 08             	sub    $0x8,%esp
  8005ab:	53                   	push   %ebx
  8005ac:	6a 3f                	push   $0x3f
  8005ae:	ff d6                	call   *%esi
  8005b0:	83 c4 10             	add    $0x10,%esp
  8005b3:	eb c3                	jmp    800578 <vprintfmt+0x1e7>
  8005b5:	89 cf                	mov    %ecx,%edi
  8005b7:	eb 0e                	jmp    8005c7 <vprintfmt+0x236>
				putch(' ', putdat);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	53                   	push   %ebx
  8005bd:	6a 20                	push   $0x20
  8005bf:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005c1:	83 ef 01             	sub    $0x1,%edi
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	85 ff                	test   %edi,%edi
  8005c9:	7f ee                	jg     8005b9 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005cb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d1:	e9 01 02 00 00       	jmp    8007d7 <vprintfmt+0x446>
  8005d6:	89 cf                	mov    %ecx,%edi
  8005d8:	eb ed                	jmp    8005c7 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005dd:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005e4:	e9 eb fd ff ff       	jmp    8003d4 <vprintfmt+0x43>
	if (lflag >= 2)
  8005e9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005ed:	7f 21                	jg     800610 <vprintfmt+0x27f>
	else if (lflag)
  8005ef:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005f3:	74 68                	je     80065d <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8b 00                	mov    (%eax),%eax
  8005fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005fd:	89 c1                	mov    %eax,%ecx
  8005ff:	c1 f9 1f             	sar    $0x1f,%ecx
  800602:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	8d 40 04             	lea    0x4(%eax),%eax
  80060b:	89 45 14             	mov    %eax,0x14(%ebp)
  80060e:	eb 17                	jmp    800627 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8b 50 04             	mov    0x4(%eax),%edx
  800616:	8b 00                	mov    (%eax),%eax
  800618:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80061b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8d 40 08             	lea    0x8(%eax),%eax
  800624:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800627:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80062a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80062d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800630:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800633:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800637:	78 3f                	js     800678 <vprintfmt+0x2e7>
			base = 10;
  800639:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80063e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800642:	0f 84 71 01 00 00    	je     8007b9 <vprintfmt+0x428>
				putch('+', putdat);
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	53                   	push   %ebx
  80064c:	6a 2b                	push   $0x2b
  80064e:	ff d6                	call   *%esi
  800650:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800653:	b8 0a 00 00 00       	mov    $0xa,%eax
  800658:	e9 5c 01 00 00       	jmp    8007b9 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800665:	89 c1                	mov    %eax,%ecx
  800667:	c1 f9 1f             	sar    $0x1f,%ecx
  80066a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8d 40 04             	lea    0x4(%eax),%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
  800676:	eb af                	jmp    800627 <vprintfmt+0x296>
				putch('-', putdat);
  800678:	83 ec 08             	sub    $0x8,%esp
  80067b:	53                   	push   %ebx
  80067c:	6a 2d                	push   $0x2d
  80067e:	ff d6                	call   *%esi
				num = -(long long) num;
  800680:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800683:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800686:	f7 d8                	neg    %eax
  800688:	83 d2 00             	adc    $0x0,%edx
  80068b:	f7 da                	neg    %edx
  80068d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800690:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800693:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800696:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069b:	e9 19 01 00 00       	jmp    8007b9 <vprintfmt+0x428>
	if (lflag >= 2)
  8006a0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006a4:	7f 29                	jg     8006cf <vprintfmt+0x33e>
	else if (lflag)
  8006a6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006aa:	74 44                	je     8006f0 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8d 40 04             	lea    0x4(%eax),%eax
  8006c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ca:	e9 ea 00 00 00       	jmp    8007b9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 50 04             	mov    0x4(%eax),%edx
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8d 40 08             	lea    0x8(%eax),%eax
  8006e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006eb:	e9 c9 00 00 00       	jmp    8007b9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 40 04             	lea    0x4(%eax),%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800709:	b8 0a 00 00 00       	mov    $0xa,%eax
  80070e:	e9 a6 00 00 00       	jmp    8007b9 <vprintfmt+0x428>
			putch('0', putdat);
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	53                   	push   %ebx
  800717:	6a 30                	push   $0x30
  800719:	ff d6                	call   *%esi
	if (lflag >= 2)
  80071b:	83 c4 10             	add    $0x10,%esp
  80071e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800722:	7f 26                	jg     80074a <vprintfmt+0x3b9>
	else if (lflag)
  800724:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800728:	74 3e                	je     800768 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80072a:	8b 45 14             	mov    0x14(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	ba 00 00 00 00       	mov    $0x0,%edx
  800734:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800737:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8d 40 04             	lea    0x4(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800743:	b8 08 00 00 00       	mov    $0x8,%eax
  800748:	eb 6f                	jmp    8007b9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80074a:	8b 45 14             	mov    0x14(%ebp),%eax
  80074d:	8b 50 04             	mov    0x4(%eax),%edx
  800750:	8b 00                	mov    (%eax),%eax
  800752:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800755:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8d 40 08             	lea    0x8(%eax),%eax
  80075e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800761:	b8 08 00 00 00       	mov    $0x8,%eax
  800766:	eb 51                	jmp    8007b9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	ba 00 00 00 00       	mov    $0x0,%edx
  800772:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800775:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8d 40 04             	lea    0x4(%eax),%eax
  80077e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800781:	b8 08 00 00 00       	mov    $0x8,%eax
  800786:	eb 31                	jmp    8007b9 <vprintfmt+0x428>
			putch('0', putdat);
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	53                   	push   %ebx
  80078c:	6a 30                	push   $0x30
  80078e:	ff d6                	call   *%esi
			putch('x', putdat);
  800790:	83 c4 08             	add    $0x8,%esp
  800793:	53                   	push   %ebx
  800794:	6a 78                	push   $0x78
  800796:	ff d6                	call   *%esi
			num = (unsigned long long)
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8b 00                	mov    (%eax),%eax
  80079d:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007a8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	8d 40 04             	lea    0x4(%eax),%eax
  8007b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b4:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007b9:	83 ec 0c             	sub    $0xc,%esp
  8007bc:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007c0:	52                   	push   %edx
  8007c1:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c4:	50                   	push   %eax
  8007c5:	ff 75 dc             	pushl  -0x24(%ebp)
  8007c8:	ff 75 d8             	pushl  -0x28(%ebp)
  8007cb:	89 da                	mov    %ebx,%edx
  8007cd:	89 f0                	mov    %esi,%eax
  8007cf:	e8 a4 fa ff ff       	call   800278 <printnum>
			break;
  8007d4:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007da:	83 c7 01             	add    $0x1,%edi
  8007dd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e1:	83 f8 25             	cmp    $0x25,%eax
  8007e4:	0f 84 be fb ff ff    	je     8003a8 <vprintfmt+0x17>
			if (ch == '\0')
  8007ea:	85 c0                	test   %eax,%eax
  8007ec:	0f 84 28 01 00 00    	je     80091a <vprintfmt+0x589>
			putch(ch, putdat);
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	53                   	push   %ebx
  8007f6:	50                   	push   %eax
  8007f7:	ff d6                	call   *%esi
  8007f9:	83 c4 10             	add    $0x10,%esp
  8007fc:	eb dc                	jmp    8007da <vprintfmt+0x449>
	if (lflag >= 2)
  8007fe:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800802:	7f 26                	jg     80082a <vprintfmt+0x499>
	else if (lflag)
  800804:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800808:	74 41                	je     80084b <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80080a:	8b 45 14             	mov    0x14(%ebp),%eax
  80080d:	8b 00                	mov    (%eax),%eax
  80080f:	ba 00 00 00 00       	mov    $0x0,%edx
  800814:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800817:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	8d 40 04             	lea    0x4(%eax),%eax
  800820:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800823:	b8 10 00 00 00       	mov    $0x10,%eax
  800828:	eb 8f                	jmp    8007b9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80082a:	8b 45 14             	mov    0x14(%ebp),%eax
  80082d:	8b 50 04             	mov    0x4(%eax),%edx
  800830:	8b 00                	mov    (%eax),%eax
  800832:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800835:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	8d 40 08             	lea    0x8(%eax),%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800841:	b8 10 00 00 00       	mov    $0x10,%eax
  800846:	e9 6e ff ff ff       	jmp    8007b9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	ba 00 00 00 00       	mov    $0x0,%edx
  800855:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800858:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	8d 40 04             	lea    0x4(%eax),%eax
  800861:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800864:	b8 10 00 00 00       	mov    $0x10,%eax
  800869:	e9 4b ff ff ff       	jmp    8007b9 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	83 c0 04             	add    $0x4,%eax
  800874:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	85 c0                	test   %eax,%eax
  80087e:	74 14                	je     800894 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800880:	8b 13                	mov    (%ebx),%edx
  800882:	83 fa 7f             	cmp    $0x7f,%edx
  800885:	7f 37                	jg     8008be <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800887:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800889:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80088c:	89 45 14             	mov    %eax,0x14(%ebp)
  80088f:	e9 43 ff ff ff       	jmp    8007d7 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800894:	b8 0a 00 00 00       	mov    $0xa,%eax
  800899:	bf 45 2d 80 00       	mov    $0x802d45,%edi
							putch(ch, putdat);
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	53                   	push   %ebx
  8008a2:	50                   	push   %eax
  8008a3:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008a5:	83 c7 01             	add    $0x1,%edi
  8008a8:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008ac:	83 c4 10             	add    $0x10,%esp
  8008af:	85 c0                	test   %eax,%eax
  8008b1:	75 eb                	jne    80089e <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b9:	e9 19 ff ff ff       	jmp    8007d7 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008be:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c5:	bf 7d 2d 80 00       	mov    $0x802d7d,%edi
							putch(ch, putdat);
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	53                   	push   %ebx
  8008ce:	50                   	push   %eax
  8008cf:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008d1:	83 c7 01             	add    $0x1,%edi
  8008d4:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008d8:	83 c4 10             	add    $0x10,%esp
  8008db:	85 c0                	test   %eax,%eax
  8008dd:	75 eb                	jne    8008ca <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e5:	e9 ed fe ff ff       	jmp    8007d7 <vprintfmt+0x446>
			putch(ch, putdat);
  8008ea:	83 ec 08             	sub    $0x8,%esp
  8008ed:	53                   	push   %ebx
  8008ee:	6a 25                	push   $0x25
  8008f0:	ff d6                	call   *%esi
			break;
  8008f2:	83 c4 10             	add    $0x10,%esp
  8008f5:	e9 dd fe ff ff       	jmp    8007d7 <vprintfmt+0x446>
			putch('%', putdat);
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	53                   	push   %ebx
  8008fe:	6a 25                	push   $0x25
  800900:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800902:	83 c4 10             	add    $0x10,%esp
  800905:	89 f8                	mov    %edi,%eax
  800907:	eb 03                	jmp    80090c <vprintfmt+0x57b>
  800909:	83 e8 01             	sub    $0x1,%eax
  80090c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800910:	75 f7                	jne    800909 <vprintfmt+0x578>
  800912:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800915:	e9 bd fe ff ff       	jmp    8007d7 <vprintfmt+0x446>
}
  80091a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80091d:	5b                   	pop    %ebx
  80091e:	5e                   	pop    %esi
  80091f:	5f                   	pop    %edi
  800920:	5d                   	pop    %ebp
  800921:	c3                   	ret    

00800922 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	83 ec 18             	sub    $0x18,%esp
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80092e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800931:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800935:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800938:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80093f:	85 c0                	test   %eax,%eax
  800941:	74 26                	je     800969 <vsnprintf+0x47>
  800943:	85 d2                	test   %edx,%edx
  800945:	7e 22                	jle    800969 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800947:	ff 75 14             	pushl  0x14(%ebp)
  80094a:	ff 75 10             	pushl  0x10(%ebp)
  80094d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800950:	50                   	push   %eax
  800951:	68 57 03 80 00       	push   $0x800357
  800956:	e8 36 fa ff ff       	call   800391 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80095b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80095e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800964:	83 c4 10             	add    $0x10,%esp
}
  800967:	c9                   	leave  
  800968:	c3                   	ret    
		return -E_INVAL;
  800969:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80096e:	eb f7                	jmp    800967 <vsnprintf+0x45>

00800970 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800976:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800979:	50                   	push   %eax
  80097a:	ff 75 10             	pushl  0x10(%ebp)
  80097d:	ff 75 0c             	pushl  0xc(%ebp)
  800980:	ff 75 08             	pushl  0x8(%ebp)
  800983:	e8 9a ff ff ff       	call   800922 <vsnprintf>
	va_end(ap);

	return rc;
}
  800988:	c9                   	leave  
  800989:	c3                   	ret    

0080098a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800990:	b8 00 00 00 00       	mov    $0x0,%eax
  800995:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800999:	74 05                	je     8009a0 <strlen+0x16>
		n++;
  80099b:	83 c0 01             	add    $0x1,%eax
  80099e:	eb f5                	jmp    800995 <strlen+0xb>
	return n;
}
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a8:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b0:	39 c2                	cmp    %eax,%edx
  8009b2:	74 0d                	je     8009c1 <strnlen+0x1f>
  8009b4:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009b8:	74 05                	je     8009bf <strnlen+0x1d>
		n++;
  8009ba:	83 c2 01             	add    $0x1,%edx
  8009bd:	eb f1                	jmp    8009b0 <strnlen+0xe>
  8009bf:	89 d0                	mov    %edx,%eax
	return n;
}
  8009c1:	5d                   	pop    %ebp
  8009c2:	c3                   	ret    

008009c3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	53                   	push   %ebx
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d2:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009d6:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009d9:	83 c2 01             	add    $0x1,%edx
  8009dc:	84 c9                	test   %cl,%cl
  8009de:	75 f2                	jne    8009d2 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009e0:	5b                   	pop    %ebx
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    

008009e3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	53                   	push   %ebx
  8009e7:	83 ec 10             	sub    $0x10,%esp
  8009ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009ed:	53                   	push   %ebx
  8009ee:	e8 97 ff ff ff       	call   80098a <strlen>
  8009f3:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009f6:	ff 75 0c             	pushl  0xc(%ebp)
  8009f9:	01 d8                	add    %ebx,%eax
  8009fb:	50                   	push   %eax
  8009fc:	e8 c2 ff ff ff       	call   8009c3 <strcpy>
	return dst;
}
  800a01:	89 d8                	mov    %ebx,%eax
  800a03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a06:	c9                   	leave  
  800a07:	c3                   	ret    

00800a08 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	56                   	push   %esi
  800a0c:	53                   	push   %ebx
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a13:	89 c6                	mov    %eax,%esi
  800a15:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a18:	89 c2                	mov    %eax,%edx
  800a1a:	39 f2                	cmp    %esi,%edx
  800a1c:	74 11                	je     800a2f <strncpy+0x27>
		*dst++ = *src;
  800a1e:	83 c2 01             	add    $0x1,%edx
  800a21:	0f b6 19             	movzbl (%ecx),%ebx
  800a24:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a27:	80 fb 01             	cmp    $0x1,%bl
  800a2a:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a2d:	eb eb                	jmp    800a1a <strncpy+0x12>
	}
	return ret;
}
  800a2f:	5b                   	pop    %ebx
  800a30:	5e                   	pop    %esi
  800a31:	5d                   	pop    %ebp
  800a32:	c3                   	ret    

00800a33 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	56                   	push   %esi
  800a37:	53                   	push   %ebx
  800a38:	8b 75 08             	mov    0x8(%ebp),%esi
  800a3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a3e:	8b 55 10             	mov    0x10(%ebp),%edx
  800a41:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a43:	85 d2                	test   %edx,%edx
  800a45:	74 21                	je     800a68 <strlcpy+0x35>
  800a47:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a4b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a4d:	39 c2                	cmp    %eax,%edx
  800a4f:	74 14                	je     800a65 <strlcpy+0x32>
  800a51:	0f b6 19             	movzbl (%ecx),%ebx
  800a54:	84 db                	test   %bl,%bl
  800a56:	74 0b                	je     800a63 <strlcpy+0x30>
			*dst++ = *src++;
  800a58:	83 c1 01             	add    $0x1,%ecx
  800a5b:	83 c2 01             	add    $0x1,%edx
  800a5e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a61:	eb ea                	jmp    800a4d <strlcpy+0x1a>
  800a63:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a65:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a68:	29 f0                	sub    %esi,%eax
}
  800a6a:	5b                   	pop    %ebx
  800a6b:	5e                   	pop    %esi
  800a6c:	5d                   	pop    %ebp
  800a6d:	c3                   	ret    

00800a6e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a74:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a77:	0f b6 01             	movzbl (%ecx),%eax
  800a7a:	84 c0                	test   %al,%al
  800a7c:	74 0c                	je     800a8a <strcmp+0x1c>
  800a7e:	3a 02                	cmp    (%edx),%al
  800a80:	75 08                	jne    800a8a <strcmp+0x1c>
		p++, q++;
  800a82:	83 c1 01             	add    $0x1,%ecx
  800a85:	83 c2 01             	add    $0x1,%edx
  800a88:	eb ed                	jmp    800a77 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a8a:	0f b6 c0             	movzbl %al,%eax
  800a8d:	0f b6 12             	movzbl (%edx),%edx
  800a90:	29 d0                	sub    %edx,%eax
}
  800a92:	5d                   	pop    %ebp
  800a93:	c3                   	ret    

00800a94 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	53                   	push   %ebx
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9e:	89 c3                	mov    %eax,%ebx
  800aa0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800aa3:	eb 06                	jmp    800aab <strncmp+0x17>
		n--, p++, q++;
  800aa5:	83 c0 01             	add    $0x1,%eax
  800aa8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800aab:	39 d8                	cmp    %ebx,%eax
  800aad:	74 16                	je     800ac5 <strncmp+0x31>
  800aaf:	0f b6 08             	movzbl (%eax),%ecx
  800ab2:	84 c9                	test   %cl,%cl
  800ab4:	74 04                	je     800aba <strncmp+0x26>
  800ab6:	3a 0a                	cmp    (%edx),%cl
  800ab8:	74 eb                	je     800aa5 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aba:	0f b6 00             	movzbl (%eax),%eax
  800abd:	0f b6 12             	movzbl (%edx),%edx
  800ac0:	29 d0                	sub    %edx,%eax
}
  800ac2:	5b                   	pop    %ebx
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    
		return 0;
  800ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aca:	eb f6                	jmp    800ac2 <strncmp+0x2e>

00800acc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad6:	0f b6 10             	movzbl (%eax),%edx
  800ad9:	84 d2                	test   %dl,%dl
  800adb:	74 09                	je     800ae6 <strchr+0x1a>
		if (*s == c)
  800add:	38 ca                	cmp    %cl,%dl
  800adf:	74 0a                	je     800aeb <strchr+0x1f>
	for (; *s; s++)
  800ae1:	83 c0 01             	add    $0x1,%eax
  800ae4:	eb f0                	jmp    800ad6 <strchr+0xa>
			return (char *) s;
	return 0;
  800ae6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aeb:	5d                   	pop    %ebp
  800aec:	c3                   	ret    

00800aed <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800afa:	38 ca                	cmp    %cl,%dl
  800afc:	74 09                	je     800b07 <strfind+0x1a>
  800afe:	84 d2                	test   %dl,%dl
  800b00:	74 05                	je     800b07 <strfind+0x1a>
	for (; *s; s++)
  800b02:	83 c0 01             	add    $0x1,%eax
  800b05:	eb f0                	jmp    800af7 <strfind+0xa>
			break;
	return (char *) s;
}
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	57                   	push   %edi
  800b0d:	56                   	push   %esi
  800b0e:	53                   	push   %ebx
  800b0f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b12:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b15:	85 c9                	test   %ecx,%ecx
  800b17:	74 31                	je     800b4a <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b19:	89 f8                	mov    %edi,%eax
  800b1b:	09 c8                	or     %ecx,%eax
  800b1d:	a8 03                	test   $0x3,%al
  800b1f:	75 23                	jne    800b44 <memset+0x3b>
		c &= 0xFF;
  800b21:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b25:	89 d3                	mov    %edx,%ebx
  800b27:	c1 e3 08             	shl    $0x8,%ebx
  800b2a:	89 d0                	mov    %edx,%eax
  800b2c:	c1 e0 18             	shl    $0x18,%eax
  800b2f:	89 d6                	mov    %edx,%esi
  800b31:	c1 e6 10             	shl    $0x10,%esi
  800b34:	09 f0                	or     %esi,%eax
  800b36:	09 c2                	or     %eax,%edx
  800b38:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b3a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b3d:	89 d0                	mov    %edx,%eax
  800b3f:	fc                   	cld    
  800b40:	f3 ab                	rep stos %eax,%es:(%edi)
  800b42:	eb 06                	jmp    800b4a <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b47:	fc                   	cld    
  800b48:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b4a:	89 f8                	mov    %edi,%eax
  800b4c:	5b                   	pop    %ebx
  800b4d:	5e                   	pop    %esi
  800b4e:	5f                   	pop    %edi
  800b4f:	5d                   	pop    %ebp
  800b50:	c3                   	ret    

00800b51 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	57                   	push   %edi
  800b55:	56                   	push   %esi
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b5f:	39 c6                	cmp    %eax,%esi
  800b61:	73 32                	jae    800b95 <memmove+0x44>
  800b63:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b66:	39 c2                	cmp    %eax,%edx
  800b68:	76 2b                	jbe    800b95 <memmove+0x44>
		s += n;
		d += n;
  800b6a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6d:	89 fe                	mov    %edi,%esi
  800b6f:	09 ce                	or     %ecx,%esi
  800b71:	09 d6                	or     %edx,%esi
  800b73:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b79:	75 0e                	jne    800b89 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b7b:	83 ef 04             	sub    $0x4,%edi
  800b7e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b81:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b84:	fd                   	std    
  800b85:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b87:	eb 09                	jmp    800b92 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b89:	83 ef 01             	sub    $0x1,%edi
  800b8c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b8f:	fd                   	std    
  800b90:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b92:	fc                   	cld    
  800b93:	eb 1a                	jmp    800baf <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b95:	89 c2                	mov    %eax,%edx
  800b97:	09 ca                	or     %ecx,%edx
  800b99:	09 f2                	or     %esi,%edx
  800b9b:	f6 c2 03             	test   $0x3,%dl
  800b9e:	75 0a                	jne    800baa <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ba0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ba3:	89 c7                	mov    %eax,%edi
  800ba5:	fc                   	cld    
  800ba6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba8:	eb 05                	jmp    800baf <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800baa:	89 c7                	mov    %eax,%edi
  800bac:	fc                   	cld    
  800bad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800baf:	5e                   	pop    %esi
  800bb0:	5f                   	pop    %edi
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bb9:	ff 75 10             	pushl  0x10(%ebp)
  800bbc:	ff 75 0c             	pushl  0xc(%ebp)
  800bbf:	ff 75 08             	pushl  0x8(%ebp)
  800bc2:	e8 8a ff ff ff       	call   800b51 <memmove>
}
  800bc7:	c9                   	leave  
  800bc8:	c3                   	ret    

00800bc9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	56                   	push   %esi
  800bcd:	53                   	push   %ebx
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd4:	89 c6                	mov    %eax,%esi
  800bd6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bd9:	39 f0                	cmp    %esi,%eax
  800bdb:	74 1c                	je     800bf9 <memcmp+0x30>
		if (*s1 != *s2)
  800bdd:	0f b6 08             	movzbl (%eax),%ecx
  800be0:	0f b6 1a             	movzbl (%edx),%ebx
  800be3:	38 d9                	cmp    %bl,%cl
  800be5:	75 08                	jne    800bef <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800be7:	83 c0 01             	add    $0x1,%eax
  800bea:	83 c2 01             	add    $0x1,%edx
  800bed:	eb ea                	jmp    800bd9 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bef:	0f b6 c1             	movzbl %cl,%eax
  800bf2:	0f b6 db             	movzbl %bl,%ebx
  800bf5:	29 d8                	sub    %ebx,%eax
  800bf7:	eb 05                	jmp    800bfe <memcmp+0x35>
	}

	return 0;
  800bf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5d                   	pop    %ebp
  800c01:	c3                   	ret    

00800c02 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c0b:	89 c2                	mov    %eax,%edx
  800c0d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c10:	39 d0                	cmp    %edx,%eax
  800c12:	73 09                	jae    800c1d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c14:	38 08                	cmp    %cl,(%eax)
  800c16:	74 05                	je     800c1d <memfind+0x1b>
	for (; s < ends; s++)
  800c18:	83 c0 01             	add    $0x1,%eax
  800c1b:	eb f3                	jmp    800c10 <memfind+0xe>
			break;
	return (void *) s;
}
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	57                   	push   %edi
  800c23:	56                   	push   %esi
  800c24:	53                   	push   %ebx
  800c25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c28:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c2b:	eb 03                	jmp    800c30 <strtol+0x11>
		s++;
  800c2d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c30:	0f b6 01             	movzbl (%ecx),%eax
  800c33:	3c 20                	cmp    $0x20,%al
  800c35:	74 f6                	je     800c2d <strtol+0xe>
  800c37:	3c 09                	cmp    $0x9,%al
  800c39:	74 f2                	je     800c2d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c3b:	3c 2b                	cmp    $0x2b,%al
  800c3d:	74 2a                	je     800c69 <strtol+0x4a>
	int neg = 0;
  800c3f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c44:	3c 2d                	cmp    $0x2d,%al
  800c46:	74 2b                	je     800c73 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c48:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c4e:	75 0f                	jne    800c5f <strtol+0x40>
  800c50:	80 39 30             	cmpb   $0x30,(%ecx)
  800c53:	74 28                	je     800c7d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c55:	85 db                	test   %ebx,%ebx
  800c57:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c5c:	0f 44 d8             	cmove  %eax,%ebx
  800c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c64:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c67:	eb 50                	jmp    800cb9 <strtol+0x9a>
		s++;
  800c69:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c6c:	bf 00 00 00 00       	mov    $0x0,%edi
  800c71:	eb d5                	jmp    800c48 <strtol+0x29>
		s++, neg = 1;
  800c73:	83 c1 01             	add    $0x1,%ecx
  800c76:	bf 01 00 00 00       	mov    $0x1,%edi
  800c7b:	eb cb                	jmp    800c48 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c7d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c81:	74 0e                	je     800c91 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c83:	85 db                	test   %ebx,%ebx
  800c85:	75 d8                	jne    800c5f <strtol+0x40>
		s++, base = 8;
  800c87:	83 c1 01             	add    $0x1,%ecx
  800c8a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c8f:	eb ce                	jmp    800c5f <strtol+0x40>
		s += 2, base = 16;
  800c91:	83 c1 02             	add    $0x2,%ecx
  800c94:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c99:	eb c4                	jmp    800c5f <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c9b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c9e:	89 f3                	mov    %esi,%ebx
  800ca0:	80 fb 19             	cmp    $0x19,%bl
  800ca3:	77 29                	ja     800cce <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ca5:	0f be d2             	movsbl %dl,%edx
  800ca8:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cab:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cae:	7d 30                	jge    800ce0 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cb0:	83 c1 01             	add    $0x1,%ecx
  800cb3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cb7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cb9:	0f b6 11             	movzbl (%ecx),%edx
  800cbc:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cbf:	89 f3                	mov    %esi,%ebx
  800cc1:	80 fb 09             	cmp    $0x9,%bl
  800cc4:	77 d5                	ja     800c9b <strtol+0x7c>
			dig = *s - '0';
  800cc6:	0f be d2             	movsbl %dl,%edx
  800cc9:	83 ea 30             	sub    $0x30,%edx
  800ccc:	eb dd                	jmp    800cab <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cce:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cd1:	89 f3                	mov    %esi,%ebx
  800cd3:	80 fb 19             	cmp    $0x19,%bl
  800cd6:	77 08                	ja     800ce0 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cd8:	0f be d2             	movsbl %dl,%edx
  800cdb:	83 ea 37             	sub    $0x37,%edx
  800cde:	eb cb                	jmp    800cab <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ce0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce4:	74 05                	je     800ceb <strtol+0xcc>
		*endptr = (char *) s;
  800ce6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ceb:	89 c2                	mov    %eax,%edx
  800ced:	f7 da                	neg    %edx
  800cef:	85 ff                	test   %edi,%edi
  800cf1:	0f 45 c2             	cmovne %edx,%eax
}
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	57                   	push   %edi
  800cfd:	56                   	push   %esi
  800cfe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cff:	b8 00 00 00 00       	mov    $0x0,%eax
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0a:	89 c3                	mov    %eax,%ebx
  800d0c:	89 c7                	mov    %eax,%edi
  800d0e:	89 c6                	mov    %eax,%esi
  800d10:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5f                   	pop    %edi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d22:	b8 01 00 00 00       	mov    $0x1,%eax
  800d27:	89 d1                	mov    %edx,%ecx
  800d29:	89 d3                	mov    %edx,%ebx
  800d2b:	89 d7                	mov    %edx,%edi
  800d2d:	89 d6                	mov    %edx,%esi
  800d2f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5f                   	pop    %edi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    

00800d36 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	57                   	push   %edi
  800d3a:	56                   	push   %esi
  800d3b:	53                   	push   %ebx
  800d3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d44:	8b 55 08             	mov    0x8(%ebp),%edx
  800d47:	b8 03 00 00 00       	mov    $0x3,%eax
  800d4c:	89 cb                	mov    %ecx,%ebx
  800d4e:	89 cf                	mov    %ecx,%edi
  800d50:	89 ce                	mov    %ecx,%esi
  800d52:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d54:	85 c0                	test   %eax,%eax
  800d56:	7f 08                	jg     800d60 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5b:	5b                   	pop    %ebx
  800d5c:	5e                   	pop    %esi
  800d5d:	5f                   	pop    %edi
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d60:	83 ec 0c             	sub    $0xc,%esp
  800d63:	50                   	push   %eax
  800d64:	6a 03                	push   $0x3
  800d66:	68 88 2f 80 00       	push   $0x802f88
  800d6b:	6a 43                	push   $0x43
  800d6d:	68 a5 2f 80 00       	push   $0x802fa5
  800d72:	e8 76 1a 00 00       	call   8027ed <_panic>

00800d77 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	57                   	push   %edi
  800d7b:	56                   	push   %esi
  800d7c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d82:	b8 02 00 00 00       	mov    $0x2,%eax
  800d87:	89 d1                	mov    %edx,%ecx
  800d89:	89 d3                	mov    %edx,%ebx
  800d8b:	89 d7                	mov    %edx,%edi
  800d8d:	89 d6                	mov    %edx,%esi
  800d8f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d91:	5b                   	pop    %ebx
  800d92:	5e                   	pop    %esi
  800d93:	5f                   	pop    %edi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <sys_yield>:

void
sys_yield(void)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	57                   	push   %edi
  800d9a:	56                   	push   %esi
  800d9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800da1:	b8 0b 00 00 00       	mov    $0xb,%eax
  800da6:	89 d1                	mov    %edx,%ecx
  800da8:	89 d3                	mov    %edx,%ebx
  800daa:	89 d7                	mov    %edx,%edi
  800dac:	89 d6                	mov    %edx,%esi
  800dae:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    

00800db5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	57                   	push   %edi
  800db9:	56                   	push   %esi
  800dba:	53                   	push   %ebx
  800dbb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbe:	be 00 00 00 00       	mov    $0x0,%esi
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc9:	b8 04 00 00 00       	mov    $0x4,%eax
  800dce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd1:	89 f7                	mov    %esi,%edi
  800dd3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd5:	85 c0                	test   %eax,%eax
  800dd7:	7f 08                	jg     800de1 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddc:	5b                   	pop    %ebx
  800ddd:	5e                   	pop    %esi
  800dde:	5f                   	pop    %edi
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de1:	83 ec 0c             	sub    $0xc,%esp
  800de4:	50                   	push   %eax
  800de5:	6a 04                	push   $0x4
  800de7:	68 88 2f 80 00       	push   $0x802f88
  800dec:	6a 43                	push   $0x43
  800dee:	68 a5 2f 80 00       	push   $0x802fa5
  800df3:	e8 f5 19 00 00       	call   8027ed <_panic>

00800df8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	57                   	push   %edi
  800dfc:	56                   	push   %esi
  800dfd:	53                   	push   %ebx
  800dfe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e01:	8b 55 08             	mov    0x8(%ebp),%edx
  800e04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e07:	b8 05 00 00 00       	mov    $0x5,%eax
  800e0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e12:	8b 75 18             	mov    0x18(%ebp),%esi
  800e15:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	7f 08                	jg     800e23 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e23:	83 ec 0c             	sub    $0xc,%esp
  800e26:	50                   	push   %eax
  800e27:	6a 05                	push   $0x5
  800e29:	68 88 2f 80 00       	push   $0x802f88
  800e2e:	6a 43                	push   $0x43
  800e30:	68 a5 2f 80 00       	push   $0x802fa5
  800e35:	e8 b3 19 00 00       	call   8027ed <_panic>

00800e3a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	53                   	push   %ebx
  800e40:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e48:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4e:	b8 06 00 00 00       	mov    $0x6,%eax
  800e53:	89 df                	mov    %ebx,%edi
  800e55:	89 de                	mov    %ebx,%esi
  800e57:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	7f 08                	jg     800e65 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e60:	5b                   	pop    %ebx
  800e61:	5e                   	pop    %esi
  800e62:	5f                   	pop    %edi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e65:	83 ec 0c             	sub    $0xc,%esp
  800e68:	50                   	push   %eax
  800e69:	6a 06                	push   $0x6
  800e6b:	68 88 2f 80 00       	push   $0x802f88
  800e70:	6a 43                	push   $0x43
  800e72:	68 a5 2f 80 00       	push   $0x802fa5
  800e77:	e8 71 19 00 00       	call   8027ed <_panic>

00800e7c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	57                   	push   %edi
  800e80:	56                   	push   %esi
  800e81:	53                   	push   %ebx
  800e82:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e90:	b8 08 00 00 00       	mov    $0x8,%eax
  800e95:	89 df                	mov    %ebx,%edi
  800e97:	89 de                	mov    %ebx,%esi
  800e99:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	7f 08                	jg     800ea7 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea2:	5b                   	pop    %ebx
  800ea3:	5e                   	pop    %esi
  800ea4:	5f                   	pop    %edi
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea7:	83 ec 0c             	sub    $0xc,%esp
  800eaa:	50                   	push   %eax
  800eab:	6a 08                	push   $0x8
  800ead:	68 88 2f 80 00       	push   $0x802f88
  800eb2:	6a 43                	push   $0x43
  800eb4:	68 a5 2f 80 00       	push   $0x802fa5
  800eb9:	e8 2f 19 00 00       	call   8027ed <_panic>

00800ebe <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	57                   	push   %edi
  800ec2:	56                   	push   %esi
  800ec3:	53                   	push   %ebx
  800ec4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed2:	b8 09 00 00 00       	mov    $0x9,%eax
  800ed7:	89 df                	mov    %ebx,%edi
  800ed9:	89 de                	mov    %ebx,%esi
  800edb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800edd:	85 c0                	test   %eax,%eax
  800edf:	7f 08                	jg     800ee9 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ee1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5f                   	pop    %edi
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee9:	83 ec 0c             	sub    $0xc,%esp
  800eec:	50                   	push   %eax
  800eed:	6a 09                	push   $0x9
  800eef:	68 88 2f 80 00       	push   $0x802f88
  800ef4:	6a 43                	push   $0x43
  800ef6:	68 a5 2f 80 00       	push   $0x802fa5
  800efb:	e8 ed 18 00 00       	call   8027ed <_panic>

00800f00 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	57                   	push   %edi
  800f04:	56                   	push   %esi
  800f05:	53                   	push   %ebx
  800f06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f14:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f19:	89 df                	mov    %ebx,%edi
  800f1b:	89 de                	mov    %ebx,%esi
  800f1d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f1f:	85 c0                	test   %eax,%eax
  800f21:	7f 08                	jg     800f2b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f26:	5b                   	pop    %ebx
  800f27:	5e                   	pop    %esi
  800f28:	5f                   	pop    %edi
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2b:	83 ec 0c             	sub    $0xc,%esp
  800f2e:	50                   	push   %eax
  800f2f:	6a 0a                	push   $0xa
  800f31:	68 88 2f 80 00       	push   $0x802f88
  800f36:	6a 43                	push   $0x43
  800f38:	68 a5 2f 80 00       	push   $0x802fa5
  800f3d:	e8 ab 18 00 00       	call   8027ed <_panic>

00800f42 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f42:	55                   	push   %ebp
  800f43:	89 e5                	mov    %esp,%ebp
  800f45:	57                   	push   %edi
  800f46:	56                   	push   %esi
  800f47:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f48:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f53:	be 00 00 00 00       	mov    $0x0,%esi
  800f58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f5b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f5e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	57                   	push   %edi
  800f69:	56                   	push   %esi
  800f6a:	53                   	push   %ebx
  800f6b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f73:	8b 55 08             	mov    0x8(%ebp),%edx
  800f76:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f7b:	89 cb                	mov    %ecx,%ebx
  800f7d:	89 cf                	mov    %ecx,%edi
  800f7f:	89 ce                	mov    %ecx,%esi
  800f81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f83:	85 c0                	test   %eax,%eax
  800f85:	7f 08                	jg     800f8f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8a:	5b                   	pop    %ebx
  800f8b:	5e                   	pop    %esi
  800f8c:	5f                   	pop    %edi
  800f8d:	5d                   	pop    %ebp
  800f8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8f:	83 ec 0c             	sub    $0xc,%esp
  800f92:	50                   	push   %eax
  800f93:	6a 0d                	push   $0xd
  800f95:	68 88 2f 80 00       	push   $0x802f88
  800f9a:	6a 43                	push   $0x43
  800f9c:	68 a5 2f 80 00       	push   $0x802fa5
  800fa1:	e8 47 18 00 00       	call   8027ed <_panic>

00800fa6 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	57                   	push   %edi
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb7:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fbc:	89 df                	mov    %ebx,%edi
  800fbe:	89 de                	mov    %ebx,%esi
  800fc0:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fc2:	5b                   	pop    %ebx
  800fc3:	5e                   	pop    %esi
  800fc4:	5f                   	pop    %edi
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	57                   	push   %edi
  800fcb:	56                   	push   %esi
  800fcc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fda:	89 cb                	mov    %ecx,%ebx
  800fdc:	89 cf                	mov    %ecx,%edi
  800fde:	89 ce                	mov    %ecx,%esi
  800fe0:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fe2:	5b                   	pop    %ebx
  800fe3:	5e                   	pop    %esi
  800fe4:	5f                   	pop    %edi
  800fe5:	5d                   	pop    %ebp
  800fe6:	c3                   	ret    

00800fe7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	57                   	push   %edi
  800feb:	56                   	push   %esi
  800fec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fed:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff2:	b8 10 00 00 00       	mov    $0x10,%eax
  800ff7:	89 d1                	mov    %edx,%ecx
  800ff9:	89 d3                	mov    %edx,%ebx
  800ffb:	89 d7                	mov    %edx,%edi
  800ffd:	89 d6                	mov    %edx,%esi
  800fff:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801001:	5b                   	pop    %ebx
  801002:	5e                   	pop    %esi
  801003:	5f                   	pop    %edi
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    

00801006 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	57                   	push   %edi
  80100a:	56                   	push   %esi
  80100b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80100c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801011:	8b 55 08             	mov    0x8(%ebp),%edx
  801014:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801017:	b8 11 00 00 00       	mov    $0x11,%eax
  80101c:	89 df                	mov    %ebx,%edi
  80101e:	89 de                	mov    %ebx,%esi
  801020:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801022:	5b                   	pop    %ebx
  801023:	5e                   	pop    %esi
  801024:	5f                   	pop    %edi
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    

00801027 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	57                   	push   %edi
  80102b:	56                   	push   %esi
  80102c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80102d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801032:	8b 55 08             	mov    0x8(%ebp),%edx
  801035:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801038:	b8 12 00 00 00       	mov    $0x12,%eax
  80103d:	89 df                	mov    %ebx,%edi
  80103f:	89 de                	mov    %ebx,%esi
  801041:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801043:	5b                   	pop    %ebx
  801044:	5e                   	pop    %esi
  801045:	5f                   	pop    %edi
  801046:	5d                   	pop    %ebp
  801047:	c3                   	ret    

00801048 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
  80104b:	57                   	push   %edi
  80104c:	56                   	push   %esi
  80104d:	53                   	push   %ebx
  80104e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801051:	bb 00 00 00 00       	mov    $0x0,%ebx
  801056:	8b 55 08             	mov    0x8(%ebp),%edx
  801059:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105c:	b8 13 00 00 00       	mov    $0x13,%eax
  801061:	89 df                	mov    %ebx,%edi
  801063:	89 de                	mov    %ebx,%esi
  801065:	cd 30                	int    $0x30
	if(check && ret > 0)
  801067:	85 c0                	test   %eax,%eax
  801069:	7f 08                	jg     801073 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80106b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106e:	5b                   	pop    %ebx
  80106f:	5e                   	pop    %esi
  801070:	5f                   	pop    %edi
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801073:	83 ec 0c             	sub    $0xc,%esp
  801076:	50                   	push   %eax
  801077:	6a 13                	push   $0x13
  801079:	68 88 2f 80 00       	push   $0x802f88
  80107e:	6a 43                	push   $0x43
  801080:	68 a5 2f 80 00       	push   $0x802fa5
  801085:	e8 63 17 00 00       	call   8027ed <_panic>

0080108a <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	57                   	push   %edi
  80108e:	56                   	push   %esi
  80108f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801090:	b9 00 00 00 00       	mov    $0x0,%ecx
  801095:	8b 55 08             	mov    0x8(%ebp),%edx
  801098:	b8 14 00 00 00       	mov    $0x14,%eax
  80109d:	89 cb                	mov    %ecx,%ebx
  80109f:	89 cf                	mov    %ecx,%edi
  8010a1:	89 ce                	mov    %ecx,%esi
  8010a3:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010a5:	5b                   	pop    %ebx
  8010a6:	5e                   	pop    %esi
  8010a7:	5f                   	pop    %edi
  8010a8:	5d                   	pop    %ebp
  8010a9:	c3                   	ret    

008010aa <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	53                   	push   %ebx
  8010ae:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8010b1:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010b8:	f6 c5 04             	test   $0x4,%ch
  8010bb:	75 45                	jne    801102 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8010bd:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010c4:	83 e1 07             	and    $0x7,%ecx
  8010c7:	83 f9 07             	cmp    $0x7,%ecx
  8010ca:	74 6f                	je     80113b <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8010cc:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010d3:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8010d9:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8010df:	0f 84 b6 00 00 00    	je     80119b <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8010e5:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010ec:	83 e1 05             	and    $0x5,%ecx
  8010ef:	83 f9 05             	cmp    $0x5,%ecx
  8010f2:	0f 84 d7 00 00 00    	je     8011cf <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8010f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801100:	c9                   	leave  
  801101:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801102:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801109:	c1 e2 0c             	shl    $0xc,%edx
  80110c:	83 ec 0c             	sub    $0xc,%esp
  80110f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801115:	51                   	push   %ecx
  801116:	52                   	push   %edx
  801117:	50                   	push   %eax
  801118:	52                   	push   %edx
  801119:	6a 00                	push   $0x0
  80111b:	e8 d8 fc ff ff       	call   800df8 <sys_page_map>
		if(r < 0)
  801120:	83 c4 20             	add    $0x20,%esp
  801123:	85 c0                	test   %eax,%eax
  801125:	79 d1                	jns    8010f8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801127:	83 ec 04             	sub    $0x4,%esp
  80112a:	68 b3 2f 80 00       	push   $0x802fb3
  80112f:	6a 54                	push   $0x54
  801131:	68 c9 2f 80 00       	push   $0x802fc9
  801136:	e8 b2 16 00 00       	call   8027ed <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80113b:	89 d3                	mov    %edx,%ebx
  80113d:	c1 e3 0c             	shl    $0xc,%ebx
  801140:	83 ec 0c             	sub    $0xc,%esp
  801143:	68 05 08 00 00       	push   $0x805
  801148:	53                   	push   %ebx
  801149:	50                   	push   %eax
  80114a:	53                   	push   %ebx
  80114b:	6a 00                	push   $0x0
  80114d:	e8 a6 fc ff ff       	call   800df8 <sys_page_map>
		if(r < 0)
  801152:	83 c4 20             	add    $0x20,%esp
  801155:	85 c0                	test   %eax,%eax
  801157:	78 2e                	js     801187 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801159:	83 ec 0c             	sub    $0xc,%esp
  80115c:	68 05 08 00 00       	push   $0x805
  801161:	53                   	push   %ebx
  801162:	6a 00                	push   $0x0
  801164:	53                   	push   %ebx
  801165:	6a 00                	push   $0x0
  801167:	e8 8c fc ff ff       	call   800df8 <sys_page_map>
		if(r < 0)
  80116c:	83 c4 20             	add    $0x20,%esp
  80116f:	85 c0                	test   %eax,%eax
  801171:	79 85                	jns    8010f8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801173:	83 ec 04             	sub    $0x4,%esp
  801176:	68 b3 2f 80 00       	push   $0x802fb3
  80117b:	6a 5f                	push   $0x5f
  80117d:	68 c9 2f 80 00       	push   $0x802fc9
  801182:	e8 66 16 00 00       	call   8027ed <_panic>
			panic("sys_page_map() panic\n");
  801187:	83 ec 04             	sub    $0x4,%esp
  80118a:	68 b3 2f 80 00       	push   $0x802fb3
  80118f:	6a 5b                	push   $0x5b
  801191:	68 c9 2f 80 00       	push   $0x802fc9
  801196:	e8 52 16 00 00       	call   8027ed <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80119b:	c1 e2 0c             	shl    $0xc,%edx
  80119e:	83 ec 0c             	sub    $0xc,%esp
  8011a1:	68 05 08 00 00       	push   $0x805
  8011a6:	52                   	push   %edx
  8011a7:	50                   	push   %eax
  8011a8:	52                   	push   %edx
  8011a9:	6a 00                	push   $0x0
  8011ab:	e8 48 fc ff ff       	call   800df8 <sys_page_map>
		if(r < 0)
  8011b0:	83 c4 20             	add    $0x20,%esp
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	0f 89 3d ff ff ff    	jns    8010f8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011bb:	83 ec 04             	sub    $0x4,%esp
  8011be:	68 b3 2f 80 00       	push   $0x802fb3
  8011c3:	6a 66                	push   $0x66
  8011c5:	68 c9 2f 80 00       	push   $0x802fc9
  8011ca:	e8 1e 16 00 00       	call   8027ed <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011cf:	c1 e2 0c             	shl    $0xc,%edx
  8011d2:	83 ec 0c             	sub    $0xc,%esp
  8011d5:	6a 05                	push   $0x5
  8011d7:	52                   	push   %edx
  8011d8:	50                   	push   %eax
  8011d9:	52                   	push   %edx
  8011da:	6a 00                	push   $0x0
  8011dc:	e8 17 fc ff ff       	call   800df8 <sys_page_map>
		if(r < 0)
  8011e1:	83 c4 20             	add    $0x20,%esp
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	0f 89 0c ff ff ff    	jns    8010f8 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011ec:	83 ec 04             	sub    $0x4,%esp
  8011ef:	68 b3 2f 80 00       	push   $0x802fb3
  8011f4:	6a 6d                	push   $0x6d
  8011f6:	68 c9 2f 80 00       	push   $0x802fc9
  8011fb:	e8 ed 15 00 00       	call   8027ed <_panic>

00801200 <pgfault>:
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	53                   	push   %ebx
  801204:	83 ec 04             	sub    $0x4,%esp
  801207:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80120a:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80120c:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801210:	0f 84 99 00 00 00    	je     8012af <pgfault+0xaf>
  801216:	89 c2                	mov    %eax,%edx
  801218:	c1 ea 16             	shr    $0x16,%edx
  80121b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801222:	f6 c2 01             	test   $0x1,%dl
  801225:	0f 84 84 00 00 00    	je     8012af <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80122b:	89 c2                	mov    %eax,%edx
  80122d:	c1 ea 0c             	shr    $0xc,%edx
  801230:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801237:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80123d:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801243:	75 6a                	jne    8012af <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801245:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80124a:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80124c:	83 ec 04             	sub    $0x4,%esp
  80124f:	6a 07                	push   $0x7
  801251:	68 00 f0 7f 00       	push   $0x7ff000
  801256:	6a 00                	push   $0x0
  801258:	e8 58 fb ff ff       	call   800db5 <sys_page_alloc>
	if(ret < 0)
  80125d:	83 c4 10             	add    $0x10,%esp
  801260:	85 c0                	test   %eax,%eax
  801262:	78 5f                	js     8012c3 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801264:	83 ec 04             	sub    $0x4,%esp
  801267:	68 00 10 00 00       	push   $0x1000
  80126c:	53                   	push   %ebx
  80126d:	68 00 f0 7f 00       	push   $0x7ff000
  801272:	e8 3c f9 ff ff       	call   800bb3 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801277:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80127e:	53                   	push   %ebx
  80127f:	6a 00                	push   $0x0
  801281:	68 00 f0 7f 00       	push   $0x7ff000
  801286:	6a 00                	push   $0x0
  801288:	e8 6b fb ff ff       	call   800df8 <sys_page_map>
	if(ret < 0)
  80128d:	83 c4 20             	add    $0x20,%esp
  801290:	85 c0                	test   %eax,%eax
  801292:	78 43                	js     8012d7 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801294:	83 ec 08             	sub    $0x8,%esp
  801297:	68 00 f0 7f 00       	push   $0x7ff000
  80129c:	6a 00                	push   $0x0
  80129e:	e8 97 fb ff ff       	call   800e3a <sys_page_unmap>
	if(ret < 0)
  8012a3:	83 c4 10             	add    $0x10,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	78 41                	js     8012eb <pgfault+0xeb>
}
  8012aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    
		panic("panic at pgfault()\n");
  8012af:	83 ec 04             	sub    $0x4,%esp
  8012b2:	68 d4 2f 80 00       	push   $0x802fd4
  8012b7:	6a 26                	push   $0x26
  8012b9:	68 c9 2f 80 00       	push   $0x802fc9
  8012be:	e8 2a 15 00 00       	call   8027ed <_panic>
		panic("panic in sys_page_alloc()\n");
  8012c3:	83 ec 04             	sub    $0x4,%esp
  8012c6:	68 e8 2f 80 00       	push   $0x802fe8
  8012cb:	6a 31                	push   $0x31
  8012cd:	68 c9 2f 80 00       	push   $0x802fc9
  8012d2:	e8 16 15 00 00       	call   8027ed <_panic>
		panic("panic in sys_page_map()\n");
  8012d7:	83 ec 04             	sub    $0x4,%esp
  8012da:	68 03 30 80 00       	push   $0x803003
  8012df:	6a 36                	push   $0x36
  8012e1:	68 c9 2f 80 00       	push   $0x802fc9
  8012e6:	e8 02 15 00 00       	call   8027ed <_panic>
		panic("panic in sys_page_unmap()\n");
  8012eb:	83 ec 04             	sub    $0x4,%esp
  8012ee:	68 1c 30 80 00       	push   $0x80301c
  8012f3:	6a 39                	push   $0x39
  8012f5:	68 c9 2f 80 00       	push   $0x802fc9
  8012fa:	e8 ee 14 00 00       	call   8027ed <_panic>

008012ff <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	57                   	push   %edi
  801303:	56                   	push   %esi
  801304:	53                   	push   %ebx
  801305:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801308:	68 00 12 80 00       	push   $0x801200
  80130d:	e8 3c 15 00 00       	call   80284e <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801312:	b8 07 00 00 00       	mov    $0x7,%eax
  801317:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	85 c0                	test   %eax,%eax
  80131e:	78 2a                	js     80134a <fork+0x4b>
  801320:	89 c6                	mov    %eax,%esi
  801322:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801324:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801329:	75 4b                	jne    801376 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  80132b:	e8 47 fa ff ff       	call   800d77 <sys_getenvid>
  801330:	25 ff 03 00 00       	and    $0x3ff,%eax
  801335:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80133b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801340:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801345:	e9 90 00 00 00       	jmp    8013da <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  80134a:	83 ec 04             	sub    $0x4,%esp
  80134d:	68 38 30 80 00       	push   $0x803038
  801352:	68 8c 00 00 00       	push   $0x8c
  801357:	68 c9 2f 80 00       	push   $0x802fc9
  80135c:	e8 8c 14 00 00       	call   8027ed <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801361:	89 f8                	mov    %edi,%eax
  801363:	e8 42 fd ff ff       	call   8010aa <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801368:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80136e:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801374:	74 26                	je     80139c <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801376:	89 d8                	mov    %ebx,%eax
  801378:	c1 e8 16             	shr    $0x16,%eax
  80137b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801382:	a8 01                	test   $0x1,%al
  801384:	74 e2                	je     801368 <fork+0x69>
  801386:	89 da                	mov    %ebx,%edx
  801388:	c1 ea 0c             	shr    $0xc,%edx
  80138b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801392:	83 e0 05             	and    $0x5,%eax
  801395:	83 f8 05             	cmp    $0x5,%eax
  801398:	75 ce                	jne    801368 <fork+0x69>
  80139a:	eb c5                	jmp    801361 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80139c:	83 ec 04             	sub    $0x4,%esp
  80139f:	6a 07                	push   $0x7
  8013a1:	68 00 f0 bf ee       	push   $0xeebff000
  8013a6:	56                   	push   %esi
  8013a7:	e8 09 fa ff ff       	call   800db5 <sys_page_alloc>
	if(ret < 0)
  8013ac:	83 c4 10             	add    $0x10,%esp
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	78 31                	js     8013e4 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	68 bd 28 80 00       	push   $0x8028bd
  8013bb:	56                   	push   %esi
  8013bc:	e8 3f fb ff ff       	call   800f00 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	78 33                	js     8013fb <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013c8:	83 ec 08             	sub    $0x8,%esp
  8013cb:	6a 02                	push   $0x2
  8013cd:	56                   	push   %esi
  8013ce:	e8 a9 fa ff ff       	call   800e7c <sys_env_set_status>
	if(ret < 0)
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	78 38                	js     801412 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013da:	89 f0                	mov    %esi,%eax
  8013dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013df:	5b                   	pop    %ebx
  8013e0:	5e                   	pop    %esi
  8013e1:	5f                   	pop    %edi
  8013e2:	5d                   	pop    %ebp
  8013e3:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013e4:	83 ec 04             	sub    $0x4,%esp
  8013e7:	68 e8 2f 80 00       	push   $0x802fe8
  8013ec:	68 98 00 00 00       	push   $0x98
  8013f1:	68 c9 2f 80 00       	push   $0x802fc9
  8013f6:	e8 f2 13 00 00       	call   8027ed <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8013fb:	83 ec 04             	sub    $0x4,%esp
  8013fe:	68 5c 30 80 00       	push   $0x80305c
  801403:	68 9b 00 00 00       	push   $0x9b
  801408:	68 c9 2f 80 00       	push   $0x802fc9
  80140d:	e8 db 13 00 00       	call   8027ed <_panic>
		panic("panic in sys_env_set_status()\n");
  801412:	83 ec 04             	sub    $0x4,%esp
  801415:	68 84 30 80 00       	push   $0x803084
  80141a:	68 9e 00 00 00       	push   $0x9e
  80141f:	68 c9 2f 80 00       	push   $0x802fc9
  801424:	e8 c4 13 00 00       	call   8027ed <_panic>

00801429 <sfork>:

// Challenge!
int
sfork(void)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	57                   	push   %edi
  80142d:	56                   	push   %esi
  80142e:	53                   	push   %ebx
  80142f:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801432:	68 00 12 80 00       	push   $0x801200
  801437:	e8 12 14 00 00       	call   80284e <set_pgfault_handler>
  80143c:	b8 07 00 00 00       	mov    $0x7,%eax
  801441:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	85 c0                	test   %eax,%eax
  801448:	78 2a                	js     801474 <sfork+0x4b>
  80144a:	89 c7                	mov    %eax,%edi
  80144c:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80144e:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801453:	75 58                	jne    8014ad <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  801455:	e8 1d f9 ff ff       	call   800d77 <sys_getenvid>
  80145a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80145f:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801465:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80146a:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80146f:	e9 d4 00 00 00       	jmp    801548 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  801474:	83 ec 04             	sub    $0x4,%esp
  801477:	68 38 30 80 00       	push   $0x803038
  80147c:	68 af 00 00 00       	push   $0xaf
  801481:	68 c9 2f 80 00       	push   $0x802fc9
  801486:	e8 62 13 00 00       	call   8027ed <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80148b:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801490:	89 f0                	mov    %esi,%eax
  801492:	e8 13 fc ff ff       	call   8010aa <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801497:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80149d:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8014a3:	77 65                	ja     80150a <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  8014a5:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8014ab:	74 de                	je     80148b <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8014ad:	89 d8                	mov    %ebx,%eax
  8014af:	c1 e8 16             	shr    $0x16,%eax
  8014b2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014b9:	a8 01                	test   $0x1,%al
  8014bb:	74 da                	je     801497 <sfork+0x6e>
  8014bd:	89 da                	mov    %ebx,%edx
  8014bf:	c1 ea 0c             	shr    $0xc,%edx
  8014c2:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014c9:	83 e0 05             	and    $0x5,%eax
  8014cc:	83 f8 05             	cmp    $0x5,%eax
  8014cf:	75 c6                	jne    801497 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014d1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014d8:	c1 e2 0c             	shl    $0xc,%edx
  8014db:	83 ec 0c             	sub    $0xc,%esp
  8014de:	83 e0 07             	and    $0x7,%eax
  8014e1:	50                   	push   %eax
  8014e2:	52                   	push   %edx
  8014e3:	56                   	push   %esi
  8014e4:	52                   	push   %edx
  8014e5:	6a 00                	push   $0x0
  8014e7:	e8 0c f9 ff ff       	call   800df8 <sys_page_map>
  8014ec:	83 c4 20             	add    $0x20,%esp
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	74 a4                	je     801497 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  8014f3:	83 ec 04             	sub    $0x4,%esp
  8014f6:	68 b3 2f 80 00       	push   $0x802fb3
  8014fb:	68 ba 00 00 00       	push   $0xba
  801500:	68 c9 2f 80 00       	push   $0x802fc9
  801505:	e8 e3 12 00 00       	call   8027ed <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80150a:	83 ec 04             	sub    $0x4,%esp
  80150d:	6a 07                	push   $0x7
  80150f:	68 00 f0 bf ee       	push   $0xeebff000
  801514:	57                   	push   %edi
  801515:	e8 9b f8 ff ff       	call   800db5 <sys_page_alloc>
	if(ret < 0)
  80151a:	83 c4 10             	add    $0x10,%esp
  80151d:	85 c0                	test   %eax,%eax
  80151f:	78 31                	js     801552 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801521:	83 ec 08             	sub    $0x8,%esp
  801524:	68 bd 28 80 00       	push   $0x8028bd
  801529:	57                   	push   %edi
  80152a:	e8 d1 f9 ff ff       	call   800f00 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80152f:	83 c4 10             	add    $0x10,%esp
  801532:	85 c0                	test   %eax,%eax
  801534:	78 33                	js     801569 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801536:	83 ec 08             	sub    $0x8,%esp
  801539:	6a 02                	push   $0x2
  80153b:	57                   	push   %edi
  80153c:	e8 3b f9 ff ff       	call   800e7c <sys_env_set_status>
	if(ret < 0)
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	85 c0                	test   %eax,%eax
  801546:	78 38                	js     801580 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801548:	89 f8                	mov    %edi,%eax
  80154a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80154d:	5b                   	pop    %ebx
  80154e:	5e                   	pop    %esi
  80154f:	5f                   	pop    %edi
  801550:	5d                   	pop    %ebp
  801551:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801552:	83 ec 04             	sub    $0x4,%esp
  801555:	68 e8 2f 80 00       	push   $0x802fe8
  80155a:	68 c0 00 00 00       	push   $0xc0
  80155f:	68 c9 2f 80 00       	push   $0x802fc9
  801564:	e8 84 12 00 00       	call   8027ed <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801569:	83 ec 04             	sub    $0x4,%esp
  80156c:	68 5c 30 80 00       	push   $0x80305c
  801571:	68 c3 00 00 00       	push   $0xc3
  801576:	68 c9 2f 80 00       	push   $0x802fc9
  80157b:	e8 6d 12 00 00       	call   8027ed <_panic>
		panic("panic in sys_env_set_status()\n");
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	68 84 30 80 00       	push   $0x803084
  801588:	68 c6 00 00 00       	push   $0xc6
  80158d:	68 c9 2f 80 00       	push   $0x802fc9
  801592:	e8 56 12 00 00       	call   8027ed <_panic>

00801597 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	56                   	push   %esi
  80159b:	53                   	push   %ebx
  80159c:	8b 75 08             	mov    0x8(%ebp),%esi
  80159f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8015a5:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8015a7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8015ac:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8015af:	83 ec 0c             	sub    $0xc,%esp
  8015b2:	50                   	push   %eax
  8015b3:	e8 ad f9 ff ff       	call   800f65 <sys_ipc_recv>
	if(ret < 0){
  8015b8:	83 c4 10             	add    $0x10,%esp
  8015bb:	85 c0                	test   %eax,%eax
  8015bd:	78 2b                	js     8015ea <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8015bf:	85 f6                	test   %esi,%esi
  8015c1:	74 0a                	je     8015cd <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8015c3:	a1 08 50 80 00       	mov    0x805008,%eax
  8015c8:	8b 40 78             	mov    0x78(%eax),%eax
  8015cb:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8015cd:	85 db                	test   %ebx,%ebx
  8015cf:	74 0a                	je     8015db <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8015d1:	a1 08 50 80 00       	mov    0x805008,%eax
  8015d6:	8b 40 7c             	mov    0x7c(%eax),%eax
  8015d9:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8015db:	a1 08 50 80 00       	mov    0x805008,%eax
  8015e0:	8b 40 74             	mov    0x74(%eax),%eax
}
  8015e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e6:	5b                   	pop    %ebx
  8015e7:	5e                   	pop    %esi
  8015e8:	5d                   	pop    %ebp
  8015e9:	c3                   	ret    
		if(from_env_store)
  8015ea:	85 f6                	test   %esi,%esi
  8015ec:	74 06                	je     8015f4 <ipc_recv+0x5d>
			*from_env_store = 0;
  8015ee:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8015f4:	85 db                	test   %ebx,%ebx
  8015f6:	74 eb                	je     8015e3 <ipc_recv+0x4c>
			*perm_store = 0;
  8015f8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8015fe:	eb e3                	jmp    8015e3 <ipc_recv+0x4c>

00801600 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	57                   	push   %edi
  801604:	56                   	push   %esi
  801605:	53                   	push   %ebx
  801606:	83 ec 0c             	sub    $0xc,%esp
  801609:	8b 7d 08             	mov    0x8(%ebp),%edi
  80160c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80160f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801612:	85 db                	test   %ebx,%ebx
  801614:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801619:	0f 44 d8             	cmove  %eax,%ebx
  80161c:	eb 05                	jmp    801623 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80161e:	e8 73 f7 ff ff       	call   800d96 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801623:	ff 75 14             	pushl  0x14(%ebp)
  801626:	53                   	push   %ebx
  801627:	56                   	push   %esi
  801628:	57                   	push   %edi
  801629:	e8 14 f9 ff ff       	call   800f42 <sys_ipc_try_send>
  80162e:	83 c4 10             	add    $0x10,%esp
  801631:	85 c0                	test   %eax,%eax
  801633:	74 1b                	je     801650 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801635:	79 e7                	jns    80161e <ipc_send+0x1e>
  801637:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80163a:	74 e2                	je     80161e <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 a3 30 80 00       	push   $0x8030a3
  801644:	6a 46                	push   $0x46
  801646:	68 b8 30 80 00       	push   $0x8030b8
  80164b:	e8 9d 11 00 00       	call   8027ed <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801650:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801653:	5b                   	pop    %ebx
  801654:	5e                   	pop    %esi
  801655:	5f                   	pop    %edi
  801656:	5d                   	pop    %ebp
  801657:	c3                   	ret    

00801658 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80165e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801663:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  801669:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80166f:	8b 52 50             	mov    0x50(%edx),%edx
  801672:	39 ca                	cmp    %ecx,%edx
  801674:	74 11                	je     801687 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801676:	83 c0 01             	add    $0x1,%eax
  801679:	3d 00 04 00 00       	cmp    $0x400,%eax
  80167e:	75 e3                	jne    801663 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801680:	b8 00 00 00 00       	mov    $0x0,%eax
  801685:	eb 0e                	jmp    801695 <ipc_find_env+0x3d>
			return envs[i].env_id;
  801687:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80168d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801692:	8b 40 48             	mov    0x48(%eax),%eax
}
  801695:	5d                   	pop    %ebp
  801696:	c3                   	ret    

00801697 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	05 00 00 00 30       	add    $0x30000000,%eax
  8016a2:	c1 e8 0c             	shr    $0xc,%eax
}
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    

008016a7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016b7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016c6:	89 c2                	mov    %eax,%edx
  8016c8:	c1 ea 16             	shr    $0x16,%edx
  8016cb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016d2:	f6 c2 01             	test   $0x1,%dl
  8016d5:	74 2d                	je     801704 <fd_alloc+0x46>
  8016d7:	89 c2                	mov    %eax,%edx
  8016d9:	c1 ea 0c             	shr    $0xc,%edx
  8016dc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016e3:	f6 c2 01             	test   $0x1,%dl
  8016e6:	74 1c                	je     801704 <fd_alloc+0x46>
  8016e8:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016ed:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016f2:	75 d2                	jne    8016c6 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8016fd:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801702:	eb 0a                	jmp    80170e <fd_alloc+0x50>
			*fd_store = fd;
  801704:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801707:	89 01                	mov    %eax,(%ecx)
			return 0;
  801709:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170e:	5d                   	pop    %ebp
  80170f:	c3                   	ret    

00801710 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801716:	83 f8 1f             	cmp    $0x1f,%eax
  801719:	77 30                	ja     80174b <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80171b:	c1 e0 0c             	shl    $0xc,%eax
  80171e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801723:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801729:	f6 c2 01             	test   $0x1,%dl
  80172c:	74 24                	je     801752 <fd_lookup+0x42>
  80172e:	89 c2                	mov    %eax,%edx
  801730:	c1 ea 0c             	shr    $0xc,%edx
  801733:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80173a:	f6 c2 01             	test   $0x1,%dl
  80173d:	74 1a                	je     801759 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80173f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801742:	89 02                	mov    %eax,(%edx)
	return 0;
  801744:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801749:	5d                   	pop    %ebp
  80174a:	c3                   	ret    
		return -E_INVAL;
  80174b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801750:	eb f7                	jmp    801749 <fd_lookup+0x39>
		return -E_INVAL;
  801752:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801757:	eb f0                	jmp    801749 <fd_lookup+0x39>
  801759:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80175e:	eb e9                	jmp    801749 <fd_lookup+0x39>

00801760 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 08             	sub    $0x8,%esp
  801766:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801769:	ba 00 00 00 00       	mov    $0x0,%edx
  80176e:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801773:	39 08                	cmp    %ecx,(%eax)
  801775:	74 38                	je     8017af <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801777:	83 c2 01             	add    $0x1,%edx
  80177a:	8b 04 95 40 31 80 00 	mov    0x803140(,%edx,4),%eax
  801781:	85 c0                	test   %eax,%eax
  801783:	75 ee                	jne    801773 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801785:	a1 08 50 80 00       	mov    0x805008,%eax
  80178a:	8b 40 48             	mov    0x48(%eax),%eax
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	51                   	push   %ecx
  801791:	50                   	push   %eax
  801792:	68 c4 30 80 00       	push   $0x8030c4
  801797:	e8 c8 ea ff ff       	call   800264 <cprintf>
	*dev = 0;
  80179c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017a5:	83 c4 10             	add    $0x10,%esp
  8017a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    
			*dev = devtab[i];
  8017af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017b2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b9:	eb f2                	jmp    8017ad <dev_lookup+0x4d>

008017bb <fd_close>:
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	57                   	push   %edi
  8017bf:	56                   	push   %esi
  8017c0:	53                   	push   %ebx
  8017c1:	83 ec 24             	sub    $0x24,%esp
  8017c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8017c7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017cd:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017ce:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017d4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017d7:	50                   	push   %eax
  8017d8:	e8 33 ff ff ff       	call   801710 <fd_lookup>
  8017dd:	89 c3                	mov    %eax,%ebx
  8017df:	83 c4 10             	add    $0x10,%esp
  8017e2:	85 c0                	test   %eax,%eax
  8017e4:	78 05                	js     8017eb <fd_close+0x30>
	    || fd != fd2)
  8017e6:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017e9:	74 16                	je     801801 <fd_close+0x46>
		return (must_exist ? r : 0);
  8017eb:	89 f8                	mov    %edi,%eax
  8017ed:	84 c0                	test   %al,%al
  8017ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f4:	0f 44 d8             	cmove  %eax,%ebx
}
  8017f7:	89 d8                	mov    %ebx,%eax
  8017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017fc:	5b                   	pop    %ebx
  8017fd:	5e                   	pop    %esi
  8017fe:	5f                   	pop    %edi
  8017ff:	5d                   	pop    %ebp
  801800:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801801:	83 ec 08             	sub    $0x8,%esp
  801804:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801807:	50                   	push   %eax
  801808:	ff 36                	pushl  (%esi)
  80180a:	e8 51 ff ff ff       	call   801760 <dev_lookup>
  80180f:	89 c3                	mov    %eax,%ebx
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	85 c0                	test   %eax,%eax
  801816:	78 1a                	js     801832 <fd_close+0x77>
		if (dev->dev_close)
  801818:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80181b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80181e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801823:	85 c0                	test   %eax,%eax
  801825:	74 0b                	je     801832 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801827:	83 ec 0c             	sub    $0xc,%esp
  80182a:	56                   	push   %esi
  80182b:	ff d0                	call   *%eax
  80182d:	89 c3                	mov    %eax,%ebx
  80182f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801832:	83 ec 08             	sub    $0x8,%esp
  801835:	56                   	push   %esi
  801836:	6a 00                	push   $0x0
  801838:	e8 fd f5 ff ff       	call   800e3a <sys_page_unmap>
	return r;
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	eb b5                	jmp    8017f7 <fd_close+0x3c>

00801842 <close>:

int
close(int fdnum)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801848:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184b:	50                   	push   %eax
  80184c:	ff 75 08             	pushl  0x8(%ebp)
  80184f:	e8 bc fe ff ff       	call   801710 <fd_lookup>
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	85 c0                	test   %eax,%eax
  801859:	79 02                	jns    80185d <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    
		return fd_close(fd, 1);
  80185d:	83 ec 08             	sub    $0x8,%esp
  801860:	6a 01                	push   $0x1
  801862:	ff 75 f4             	pushl  -0xc(%ebp)
  801865:	e8 51 ff ff ff       	call   8017bb <fd_close>
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	eb ec                	jmp    80185b <close+0x19>

0080186f <close_all>:

void
close_all(void)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	53                   	push   %ebx
  801873:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801876:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80187b:	83 ec 0c             	sub    $0xc,%esp
  80187e:	53                   	push   %ebx
  80187f:	e8 be ff ff ff       	call   801842 <close>
	for (i = 0; i < MAXFD; i++)
  801884:	83 c3 01             	add    $0x1,%ebx
  801887:	83 c4 10             	add    $0x10,%esp
  80188a:	83 fb 20             	cmp    $0x20,%ebx
  80188d:	75 ec                	jne    80187b <close_all+0xc>
}
  80188f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	57                   	push   %edi
  801898:	56                   	push   %esi
  801899:	53                   	push   %ebx
  80189a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80189d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018a0:	50                   	push   %eax
  8018a1:	ff 75 08             	pushl  0x8(%ebp)
  8018a4:	e8 67 fe ff ff       	call   801710 <fd_lookup>
  8018a9:	89 c3                	mov    %eax,%ebx
  8018ab:	83 c4 10             	add    $0x10,%esp
  8018ae:	85 c0                	test   %eax,%eax
  8018b0:	0f 88 81 00 00 00    	js     801937 <dup+0xa3>
		return r;
	close(newfdnum);
  8018b6:	83 ec 0c             	sub    $0xc,%esp
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	e8 81 ff ff ff       	call   801842 <close>

	newfd = INDEX2FD(newfdnum);
  8018c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018c4:	c1 e6 0c             	shl    $0xc,%esi
  8018c7:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018cd:	83 c4 04             	add    $0x4,%esp
  8018d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018d3:	e8 cf fd ff ff       	call   8016a7 <fd2data>
  8018d8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018da:	89 34 24             	mov    %esi,(%esp)
  8018dd:	e8 c5 fd ff ff       	call   8016a7 <fd2data>
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018e7:	89 d8                	mov    %ebx,%eax
  8018e9:	c1 e8 16             	shr    $0x16,%eax
  8018ec:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018f3:	a8 01                	test   $0x1,%al
  8018f5:	74 11                	je     801908 <dup+0x74>
  8018f7:	89 d8                	mov    %ebx,%eax
  8018f9:	c1 e8 0c             	shr    $0xc,%eax
  8018fc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801903:	f6 c2 01             	test   $0x1,%dl
  801906:	75 39                	jne    801941 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801908:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80190b:	89 d0                	mov    %edx,%eax
  80190d:	c1 e8 0c             	shr    $0xc,%eax
  801910:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801917:	83 ec 0c             	sub    $0xc,%esp
  80191a:	25 07 0e 00 00       	and    $0xe07,%eax
  80191f:	50                   	push   %eax
  801920:	56                   	push   %esi
  801921:	6a 00                	push   $0x0
  801923:	52                   	push   %edx
  801924:	6a 00                	push   $0x0
  801926:	e8 cd f4 ff ff       	call   800df8 <sys_page_map>
  80192b:	89 c3                	mov    %eax,%ebx
  80192d:	83 c4 20             	add    $0x20,%esp
  801930:	85 c0                	test   %eax,%eax
  801932:	78 31                	js     801965 <dup+0xd1>
		goto err;

	return newfdnum;
  801934:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801937:	89 d8                	mov    %ebx,%eax
  801939:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80193c:	5b                   	pop    %ebx
  80193d:	5e                   	pop    %esi
  80193e:	5f                   	pop    %edi
  80193f:	5d                   	pop    %ebp
  801940:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801941:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801948:	83 ec 0c             	sub    $0xc,%esp
  80194b:	25 07 0e 00 00       	and    $0xe07,%eax
  801950:	50                   	push   %eax
  801951:	57                   	push   %edi
  801952:	6a 00                	push   $0x0
  801954:	53                   	push   %ebx
  801955:	6a 00                	push   $0x0
  801957:	e8 9c f4 ff ff       	call   800df8 <sys_page_map>
  80195c:	89 c3                	mov    %eax,%ebx
  80195e:	83 c4 20             	add    $0x20,%esp
  801961:	85 c0                	test   %eax,%eax
  801963:	79 a3                	jns    801908 <dup+0x74>
	sys_page_unmap(0, newfd);
  801965:	83 ec 08             	sub    $0x8,%esp
  801968:	56                   	push   %esi
  801969:	6a 00                	push   $0x0
  80196b:	e8 ca f4 ff ff       	call   800e3a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801970:	83 c4 08             	add    $0x8,%esp
  801973:	57                   	push   %edi
  801974:	6a 00                	push   $0x0
  801976:	e8 bf f4 ff ff       	call   800e3a <sys_page_unmap>
	return r;
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	eb b7                	jmp    801937 <dup+0xa3>

00801980 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	53                   	push   %ebx
  801984:	83 ec 1c             	sub    $0x1c,%esp
  801987:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80198a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80198d:	50                   	push   %eax
  80198e:	53                   	push   %ebx
  80198f:	e8 7c fd ff ff       	call   801710 <fd_lookup>
  801994:	83 c4 10             	add    $0x10,%esp
  801997:	85 c0                	test   %eax,%eax
  801999:	78 3f                	js     8019da <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80199b:	83 ec 08             	sub    $0x8,%esp
  80199e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a1:	50                   	push   %eax
  8019a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a5:	ff 30                	pushl  (%eax)
  8019a7:	e8 b4 fd ff ff       	call   801760 <dev_lookup>
  8019ac:	83 c4 10             	add    $0x10,%esp
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	78 27                	js     8019da <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019b6:	8b 42 08             	mov    0x8(%edx),%eax
  8019b9:	83 e0 03             	and    $0x3,%eax
  8019bc:	83 f8 01             	cmp    $0x1,%eax
  8019bf:	74 1e                	je     8019df <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c4:	8b 40 08             	mov    0x8(%eax),%eax
  8019c7:	85 c0                	test   %eax,%eax
  8019c9:	74 35                	je     801a00 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	ff 75 10             	pushl  0x10(%ebp)
  8019d1:	ff 75 0c             	pushl  0xc(%ebp)
  8019d4:	52                   	push   %edx
  8019d5:	ff d0                	call   *%eax
  8019d7:	83 c4 10             	add    $0x10,%esp
}
  8019da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019df:	a1 08 50 80 00       	mov    0x805008,%eax
  8019e4:	8b 40 48             	mov    0x48(%eax),%eax
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	53                   	push   %ebx
  8019eb:	50                   	push   %eax
  8019ec:	68 05 31 80 00       	push   $0x803105
  8019f1:	e8 6e e8 ff ff       	call   800264 <cprintf>
		return -E_INVAL;
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019fe:	eb da                	jmp    8019da <read+0x5a>
		return -E_NOT_SUPP;
  801a00:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a05:	eb d3                	jmp    8019da <read+0x5a>

00801a07 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	57                   	push   %edi
  801a0b:	56                   	push   %esi
  801a0c:	53                   	push   %ebx
  801a0d:	83 ec 0c             	sub    $0xc,%esp
  801a10:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a13:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a16:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a1b:	39 f3                	cmp    %esi,%ebx
  801a1d:	73 23                	jae    801a42 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a1f:	83 ec 04             	sub    $0x4,%esp
  801a22:	89 f0                	mov    %esi,%eax
  801a24:	29 d8                	sub    %ebx,%eax
  801a26:	50                   	push   %eax
  801a27:	89 d8                	mov    %ebx,%eax
  801a29:	03 45 0c             	add    0xc(%ebp),%eax
  801a2c:	50                   	push   %eax
  801a2d:	57                   	push   %edi
  801a2e:	e8 4d ff ff ff       	call   801980 <read>
		if (m < 0)
  801a33:	83 c4 10             	add    $0x10,%esp
  801a36:	85 c0                	test   %eax,%eax
  801a38:	78 06                	js     801a40 <readn+0x39>
			return m;
		if (m == 0)
  801a3a:	74 06                	je     801a42 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a3c:	01 c3                	add    %eax,%ebx
  801a3e:	eb db                	jmp    801a1b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a40:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a42:	89 d8                	mov    %ebx,%eax
  801a44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a47:	5b                   	pop    %ebx
  801a48:	5e                   	pop    %esi
  801a49:	5f                   	pop    %edi
  801a4a:	5d                   	pop    %ebp
  801a4b:	c3                   	ret    

00801a4c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	53                   	push   %ebx
  801a50:	83 ec 1c             	sub    $0x1c,%esp
  801a53:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a56:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a59:	50                   	push   %eax
  801a5a:	53                   	push   %ebx
  801a5b:	e8 b0 fc ff ff       	call   801710 <fd_lookup>
  801a60:	83 c4 10             	add    $0x10,%esp
  801a63:	85 c0                	test   %eax,%eax
  801a65:	78 3a                	js     801aa1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a67:	83 ec 08             	sub    $0x8,%esp
  801a6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a6d:	50                   	push   %eax
  801a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a71:	ff 30                	pushl  (%eax)
  801a73:	e8 e8 fc ff ff       	call   801760 <dev_lookup>
  801a78:	83 c4 10             	add    $0x10,%esp
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	78 22                	js     801aa1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a82:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a86:	74 1e                	je     801aa6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a8b:	8b 52 0c             	mov    0xc(%edx),%edx
  801a8e:	85 d2                	test   %edx,%edx
  801a90:	74 35                	je     801ac7 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a92:	83 ec 04             	sub    $0x4,%esp
  801a95:	ff 75 10             	pushl  0x10(%ebp)
  801a98:	ff 75 0c             	pushl  0xc(%ebp)
  801a9b:	50                   	push   %eax
  801a9c:	ff d2                	call   *%edx
  801a9e:	83 c4 10             	add    $0x10,%esp
}
  801aa1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801aa6:	a1 08 50 80 00       	mov    0x805008,%eax
  801aab:	8b 40 48             	mov    0x48(%eax),%eax
  801aae:	83 ec 04             	sub    $0x4,%esp
  801ab1:	53                   	push   %ebx
  801ab2:	50                   	push   %eax
  801ab3:	68 21 31 80 00       	push   $0x803121
  801ab8:	e8 a7 e7 ff ff       	call   800264 <cprintf>
		return -E_INVAL;
  801abd:	83 c4 10             	add    $0x10,%esp
  801ac0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ac5:	eb da                	jmp    801aa1 <write+0x55>
		return -E_NOT_SUPP;
  801ac7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801acc:	eb d3                	jmp    801aa1 <write+0x55>

00801ace <seek>:

int
seek(int fdnum, off_t offset)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ad4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad7:	50                   	push   %eax
  801ad8:	ff 75 08             	pushl  0x8(%ebp)
  801adb:	e8 30 fc ff ff       	call   801710 <fd_lookup>
  801ae0:	83 c4 10             	add    $0x10,%esp
  801ae3:	85 c0                	test   %eax,%eax
  801ae5:	78 0e                	js     801af5 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aed:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801af0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	53                   	push   %ebx
  801afb:	83 ec 1c             	sub    $0x1c,%esp
  801afe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b01:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b04:	50                   	push   %eax
  801b05:	53                   	push   %ebx
  801b06:	e8 05 fc ff ff       	call   801710 <fd_lookup>
  801b0b:	83 c4 10             	add    $0x10,%esp
  801b0e:	85 c0                	test   %eax,%eax
  801b10:	78 37                	js     801b49 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b12:	83 ec 08             	sub    $0x8,%esp
  801b15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b18:	50                   	push   %eax
  801b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1c:	ff 30                	pushl  (%eax)
  801b1e:	e8 3d fc ff ff       	call   801760 <dev_lookup>
  801b23:	83 c4 10             	add    $0x10,%esp
  801b26:	85 c0                	test   %eax,%eax
  801b28:	78 1f                	js     801b49 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b31:	74 1b                	je     801b4e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b36:	8b 52 18             	mov    0x18(%edx),%edx
  801b39:	85 d2                	test   %edx,%edx
  801b3b:	74 32                	je     801b6f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b3d:	83 ec 08             	sub    $0x8,%esp
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	50                   	push   %eax
  801b44:	ff d2                	call   *%edx
  801b46:	83 c4 10             	add    $0x10,%esp
}
  801b49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b4e:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b53:	8b 40 48             	mov    0x48(%eax),%eax
  801b56:	83 ec 04             	sub    $0x4,%esp
  801b59:	53                   	push   %ebx
  801b5a:	50                   	push   %eax
  801b5b:	68 e4 30 80 00       	push   $0x8030e4
  801b60:	e8 ff e6 ff ff       	call   800264 <cprintf>
		return -E_INVAL;
  801b65:	83 c4 10             	add    $0x10,%esp
  801b68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b6d:	eb da                	jmp    801b49 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b6f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b74:	eb d3                	jmp    801b49 <ftruncate+0x52>

00801b76 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	53                   	push   %ebx
  801b7a:	83 ec 1c             	sub    $0x1c,%esp
  801b7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b80:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b83:	50                   	push   %eax
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	e8 84 fb ff ff       	call   801710 <fd_lookup>
  801b8c:	83 c4 10             	add    $0x10,%esp
  801b8f:	85 c0                	test   %eax,%eax
  801b91:	78 4b                	js     801bde <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b93:	83 ec 08             	sub    $0x8,%esp
  801b96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b99:	50                   	push   %eax
  801b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9d:	ff 30                	pushl  (%eax)
  801b9f:	e8 bc fb ff ff       	call   801760 <dev_lookup>
  801ba4:	83 c4 10             	add    $0x10,%esp
  801ba7:	85 c0                	test   %eax,%eax
  801ba9:	78 33                	js     801bde <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bae:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bb2:	74 2f                	je     801be3 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bb4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bb7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bbe:	00 00 00 
	stat->st_isdir = 0;
  801bc1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bc8:	00 00 00 
	stat->st_dev = dev;
  801bcb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bd1:	83 ec 08             	sub    $0x8,%esp
  801bd4:	53                   	push   %ebx
  801bd5:	ff 75 f0             	pushl  -0x10(%ebp)
  801bd8:	ff 50 14             	call   *0x14(%eax)
  801bdb:	83 c4 10             	add    $0x10,%esp
}
  801bde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    
		return -E_NOT_SUPP;
  801be3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801be8:	eb f4                	jmp    801bde <fstat+0x68>

00801bea <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	56                   	push   %esi
  801bee:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bef:	83 ec 08             	sub    $0x8,%esp
  801bf2:	6a 00                	push   $0x0
  801bf4:	ff 75 08             	pushl  0x8(%ebp)
  801bf7:	e8 22 02 00 00       	call   801e1e <open>
  801bfc:	89 c3                	mov    %eax,%ebx
  801bfe:	83 c4 10             	add    $0x10,%esp
  801c01:	85 c0                	test   %eax,%eax
  801c03:	78 1b                	js     801c20 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c05:	83 ec 08             	sub    $0x8,%esp
  801c08:	ff 75 0c             	pushl  0xc(%ebp)
  801c0b:	50                   	push   %eax
  801c0c:	e8 65 ff ff ff       	call   801b76 <fstat>
  801c11:	89 c6                	mov    %eax,%esi
	close(fd);
  801c13:	89 1c 24             	mov    %ebx,(%esp)
  801c16:	e8 27 fc ff ff       	call   801842 <close>
	return r;
  801c1b:	83 c4 10             	add    $0x10,%esp
  801c1e:	89 f3                	mov    %esi,%ebx
}
  801c20:	89 d8                	mov    %ebx,%eax
  801c22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c25:	5b                   	pop    %ebx
  801c26:	5e                   	pop    %esi
  801c27:	5d                   	pop    %ebp
  801c28:	c3                   	ret    

00801c29 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	56                   	push   %esi
  801c2d:	53                   	push   %ebx
  801c2e:	89 c6                	mov    %eax,%esi
  801c30:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c32:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c39:	74 27                	je     801c62 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c3b:	6a 07                	push   $0x7
  801c3d:	68 00 60 80 00       	push   $0x806000
  801c42:	56                   	push   %esi
  801c43:	ff 35 00 50 80 00    	pushl  0x805000
  801c49:	e8 b2 f9 ff ff       	call   801600 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c4e:	83 c4 0c             	add    $0xc,%esp
  801c51:	6a 00                	push   $0x0
  801c53:	53                   	push   %ebx
  801c54:	6a 00                	push   $0x0
  801c56:	e8 3c f9 ff ff       	call   801597 <ipc_recv>
}
  801c5b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c5e:	5b                   	pop    %ebx
  801c5f:	5e                   	pop    %esi
  801c60:	5d                   	pop    %ebp
  801c61:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c62:	83 ec 0c             	sub    $0xc,%esp
  801c65:	6a 01                	push   $0x1
  801c67:	e8 ec f9 ff ff       	call   801658 <ipc_find_env>
  801c6c:	a3 00 50 80 00       	mov    %eax,0x805000
  801c71:	83 c4 10             	add    $0x10,%esp
  801c74:	eb c5                	jmp    801c3b <fsipc+0x12>

00801c76 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c82:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8a:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c94:	b8 02 00 00 00       	mov    $0x2,%eax
  801c99:	e8 8b ff ff ff       	call   801c29 <fsipc>
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <devfile_flush>:
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	8b 40 0c             	mov    0xc(%eax),%eax
  801cac:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801cb1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb6:	b8 06 00 00 00       	mov    $0x6,%eax
  801cbb:	e8 69 ff ff ff       	call   801c29 <fsipc>
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <devfile_stat>:
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	53                   	push   %ebx
  801cc6:	83 ec 04             	sub    $0x4,%esp
  801cc9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	8b 40 0c             	mov    0xc(%eax),%eax
  801cd2:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cd7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cdc:	b8 05 00 00 00       	mov    $0x5,%eax
  801ce1:	e8 43 ff ff ff       	call   801c29 <fsipc>
  801ce6:	85 c0                	test   %eax,%eax
  801ce8:	78 2c                	js     801d16 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cea:	83 ec 08             	sub    $0x8,%esp
  801ced:	68 00 60 80 00       	push   $0x806000
  801cf2:	53                   	push   %ebx
  801cf3:	e8 cb ec ff ff       	call   8009c3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cf8:	a1 80 60 80 00       	mov    0x806080,%eax
  801cfd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d03:	a1 84 60 80 00       	mov    0x806084,%eax
  801d08:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d0e:	83 c4 10             	add    $0x10,%esp
  801d11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <devfile_write>:
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	53                   	push   %ebx
  801d1f:	83 ec 08             	sub    $0x8,%esp
  801d22:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	8b 40 0c             	mov    0xc(%eax),%eax
  801d2b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d30:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d36:	53                   	push   %ebx
  801d37:	ff 75 0c             	pushl  0xc(%ebp)
  801d3a:	68 08 60 80 00       	push   $0x806008
  801d3f:	e8 6f ee ff ff       	call   800bb3 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d44:	ba 00 00 00 00       	mov    $0x0,%edx
  801d49:	b8 04 00 00 00       	mov    $0x4,%eax
  801d4e:	e8 d6 fe ff ff       	call   801c29 <fsipc>
  801d53:	83 c4 10             	add    $0x10,%esp
  801d56:	85 c0                	test   %eax,%eax
  801d58:	78 0b                	js     801d65 <devfile_write+0x4a>
	assert(r <= n);
  801d5a:	39 d8                	cmp    %ebx,%eax
  801d5c:	77 0c                	ja     801d6a <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d5e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d63:	7f 1e                	jg     801d83 <devfile_write+0x68>
}
  801d65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    
	assert(r <= n);
  801d6a:	68 54 31 80 00       	push   $0x803154
  801d6f:	68 5b 31 80 00       	push   $0x80315b
  801d74:	68 98 00 00 00       	push   $0x98
  801d79:	68 70 31 80 00       	push   $0x803170
  801d7e:	e8 6a 0a 00 00       	call   8027ed <_panic>
	assert(r <= PGSIZE);
  801d83:	68 7b 31 80 00       	push   $0x80317b
  801d88:	68 5b 31 80 00       	push   $0x80315b
  801d8d:	68 99 00 00 00       	push   $0x99
  801d92:	68 70 31 80 00       	push   $0x803170
  801d97:	e8 51 0a 00 00       	call   8027ed <_panic>

00801d9c <devfile_read>:
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	56                   	push   %esi
  801da0:	53                   	push   %ebx
  801da1:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	8b 40 0c             	mov    0xc(%eax),%eax
  801daa:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801daf:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801db5:	ba 00 00 00 00       	mov    $0x0,%edx
  801dba:	b8 03 00 00 00       	mov    $0x3,%eax
  801dbf:	e8 65 fe ff ff       	call   801c29 <fsipc>
  801dc4:	89 c3                	mov    %eax,%ebx
  801dc6:	85 c0                	test   %eax,%eax
  801dc8:	78 1f                	js     801de9 <devfile_read+0x4d>
	assert(r <= n);
  801dca:	39 f0                	cmp    %esi,%eax
  801dcc:	77 24                	ja     801df2 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801dce:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dd3:	7f 33                	jg     801e08 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801dd5:	83 ec 04             	sub    $0x4,%esp
  801dd8:	50                   	push   %eax
  801dd9:	68 00 60 80 00       	push   $0x806000
  801dde:	ff 75 0c             	pushl  0xc(%ebp)
  801de1:	e8 6b ed ff ff       	call   800b51 <memmove>
	return r;
  801de6:	83 c4 10             	add    $0x10,%esp
}
  801de9:	89 d8                	mov    %ebx,%eax
  801deb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dee:	5b                   	pop    %ebx
  801def:	5e                   	pop    %esi
  801df0:	5d                   	pop    %ebp
  801df1:	c3                   	ret    
	assert(r <= n);
  801df2:	68 54 31 80 00       	push   $0x803154
  801df7:	68 5b 31 80 00       	push   $0x80315b
  801dfc:	6a 7c                	push   $0x7c
  801dfe:	68 70 31 80 00       	push   $0x803170
  801e03:	e8 e5 09 00 00       	call   8027ed <_panic>
	assert(r <= PGSIZE);
  801e08:	68 7b 31 80 00       	push   $0x80317b
  801e0d:	68 5b 31 80 00       	push   $0x80315b
  801e12:	6a 7d                	push   $0x7d
  801e14:	68 70 31 80 00       	push   $0x803170
  801e19:	e8 cf 09 00 00       	call   8027ed <_panic>

00801e1e <open>:
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	56                   	push   %esi
  801e22:	53                   	push   %ebx
  801e23:	83 ec 1c             	sub    $0x1c,%esp
  801e26:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e29:	56                   	push   %esi
  801e2a:	e8 5b eb ff ff       	call   80098a <strlen>
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e37:	7f 6c                	jg     801ea5 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e39:	83 ec 0c             	sub    $0xc,%esp
  801e3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e3f:	50                   	push   %eax
  801e40:	e8 79 f8 ff ff       	call   8016be <fd_alloc>
  801e45:	89 c3                	mov    %eax,%ebx
  801e47:	83 c4 10             	add    $0x10,%esp
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	78 3c                	js     801e8a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e4e:	83 ec 08             	sub    $0x8,%esp
  801e51:	56                   	push   %esi
  801e52:	68 00 60 80 00       	push   $0x806000
  801e57:	e8 67 eb ff ff       	call   8009c3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5f:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e67:	b8 01 00 00 00       	mov    $0x1,%eax
  801e6c:	e8 b8 fd ff ff       	call   801c29 <fsipc>
  801e71:	89 c3                	mov    %eax,%ebx
  801e73:	83 c4 10             	add    $0x10,%esp
  801e76:	85 c0                	test   %eax,%eax
  801e78:	78 19                	js     801e93 <open+0x75>
	return fd2num(fd);
  801e7a:	83 ec 0c             	sub    $0xc,%esp
  801e7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e80:	e8 12 f8 ff ff       	call   801697 <fd2num>
  801e85:	89 c3                	mov    %eax,%ebx
  801e87:	83 c4 10             	add    $0x10,%esp
}
  801e8a:	89 d8                	mov    %ebx,%eax
  801e8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e8f:	5b                   	pop    %ebx
  801e90:	5e                   	pop    %esi
  801e91:	5d                   	pop    %ebp
  801e92:	c3                   	ret    
		fd_close(fd, 0);
  801e93:	83 ec 08             	sub    $0x8,%esp
  801e96:	6a 00                	push   $0x0
  801e98:	ff 75 f4             	pushl  -0xc(%ebp)
  801e9b:	e8 1b f9 ff ff       	call   8017bb <fd_close>
		return r;
  801ea0:	83 c4 10             	add    $0x10,%esp
  801ea3:	eb e5                	jmp    801e8a <open+0x6c>
		return -E_BAD_PATH;
  801ea5:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801eaa:	eb de                	jmp    801e8a <open+0x6c>

00801eac <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801eb2:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb7:	b8 08 00 00 00       	mov    $0x8,%eax
  801ebc:	e8 68 fd ff ff       	call   801c29 <fsipc>
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ec9:	68 87 31 80 00       	push   $0x803187
  801ece:	ff 75 0c             	pushl  0xc(%ebp)
  801ed1:	e8 ed ea ff ff       	call   8009c3 <strcpy>
	return 0;
}
  801ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <devsock_close>:
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	53                   	push   %ebx
  801ee1:	83 ec 10             	sub    $0x10,%esp
  801ee4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ee7:	53                   	push   %ebx
  801ee8:	e8 f6 09 00 00       	call   8028e3 <pageref>
  801eed:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ef0:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ef5:	83 f8 01             	cmp    $0x1,%eax
  801ef8:	74 07                	je     801f01 <devsock_close+0x24>
}
  801efa:	89 d0                	mov    %edx,%eax
  801efc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f01:	83 ec 0c             	sub    $0xc,%esp
  801f04:	ff 73 0c             	pushl  0xc(%ebx)
  801f07:	e8 b9 02 00 00       	call   8021c5 <nsipc_close>
  801f0c:	89 c2                	mov    %eax,%edx
  801f0e:	83 c4 10             	add    $0x10,%esp
  801f11:	eb e7                	jmp    801efa <devsock_close+0x1d>

00801f13 <devsock_write>:
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f19:	6a 00                	push   $0x0
  801f1b:	ff 75 10             	pushl  0x10(%ebp)
  801f1e:	ff 75 0c             	pushl  0xc(%ebp)
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	ff 70 0c             	pushl  0xc(%eax)
  801f27:	e8 76 03 00 00       	call   8022a2 <nsipc_send>
}
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <devsock_read>:
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f34:	6a 00                	push   $0x0
  801f36:	ff 75 10             	pushl  0x10(%ebp)
  801f39:	ff 75 0c             	pushl  0xc(%ebp)
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	ff 70 0c             	pushl  0xc(%eax)
  801f42:	e8 ef 02 00 00       	call   802236 <nsipc_recv>
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <fd2sockid>:
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f4f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f52:	52                   	push   %edx
  801f53:	50                   	push   %eax
  801f54:	e8 b7 f7 ff ff       	call   801710 <fd_lookup>
  801f59:	83 c4 10             	add    $0x10,%esp
  801f5c:	85 c0                	test   %eax,%eax
  801f5e:	78 10                	js     801f70 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f63:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f69:	39 08                	cmp    %ecx,(%eax)
  801f6b:	75 05                	jne    801f72 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f6d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    
		return -E_NOT_SUPP;
  801f72:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f77:	eb f7                	jmp    801f70 <fd2sockid+0x27>

00801f79 <alloc_sockfd>:
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	56                   	push   %esi
  801f7d:	53                   	push   %ebx
  801f7e:	83 ec 1c             	sub    $0x1c,%esp
  801f81:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f86:	50                   	push   %eax
  801f87:	e8 32 f7 ff ff       	call   8016be <fd_alloc>
  801f8c:	89 c3                	mov    %eax,%ebx
  801f8e:	83 c4 10             	add    $0x10,%esp
  801f91:	85 c0                	test   %eax,%eax
  801f93:	78 43                	js     801fd8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f95:	83 ec 04             	sub    $0x4,%esp
  801f98:	68 07 04 00 00       	push   $0x407
  801f9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa0:	6a 00                	push   $0x0
  801fa2:	e8 0e ee ff ff       	call   800db5 <sys_page_alloc>
  801fa7:	89 c3                	mov    %eax,%ebx
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	85 c0                	test   %eax,%eax
  801fae:	78 28                	js     801fd8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fb9:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbe:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fc5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fc8:	83 ec 0c             	sub    $0xc,%esp
  801fcb:	50                   	push   %eax
  801fcc:	e8 c6 f6 ff ff       	call   801697 <fd2num>
  801fd1:	89 c3                	mov    %eax,%ebx
  801fd3:	83 c4 10             	add    $0x10,%esp
  801fd6:	eb 0c                	jmp    801fe4 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fd8:	83 ec 0c             	sub    $0xc,%esp
  801fdb:	56                   	push   %esi
  801fdc:	e8 e4 01 00 00       	call   8021c5 <nsipc_close>
		return r;
  801fe1:	83 c4 10             	add    $0x10,%esp
}
  801fe4:	89 d8                	mov    %ebx,%eax
  801fe6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fe9:	5b                   	pop    %ebx
  801fea:	5e                   	pop    %esi
  801feb:	5d                   	pop    %ebp
  801fec:	c3                   	ret    

00801fed <accept>:
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	e8 4e ff ff ff       	call   801f49 <fd2sockid>
  801ffb:	85 c0                	test   %eax,%eax
  801ffd:	78 1b                	js     80201a <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fff:	83 ec 04             	sub    $0x4,%esp
  802002:	ff 75 10             	pushl  0x10(%ebp)
  802005:	ff 75 0c             	pushl  0xc(%ebp)
  802008:	50                   	push   %eax
  802009:	e8 0e 01 00 00       	call   80211c <nsipc_accept>
  80200e:	83 c4 10             	add    $0x10,%esp
  802011:	85 c0                	test   %eax,%eax
  802013:	78 05                	js     80201a <accept+0x2d>
	return alloc_sockfd(r);
  802015:	e8 5f ff ff ff       	call   801f79 <alloc_sockfd>
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <bind>:
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	e8 1f ff ff ff       	call   801f49 <fd2sockid>
  80202a:	85 c0                	test   %eax,%eax
  80202c:	78 12                	js     802040 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80202e:	83 ec 04             	sub    $0x4,%esp
  802031:	ff 75 10             	pushl  0x10(%ebp)
  802034:	ff 75 0c             	pushl  0xc(%ebp)
  802037:	50                   	push   %eax
  802038:	e8 31 01 00 00       	call   80216e <nsipc_bind>
  80203d:	83 c4 10             	add    $0x10,%esp
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <shutdown>:
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	e8 f9 fe ff ff       	call   801f49 <fd2sockid>
  802050:	85 c0                	test   %eax,%eax
  802052:	78 0f                	js     802063 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802054:	83 ec 08             	sub    $0x8,%esp
  802057:	ff 75 0c             	pushl  0xc(%ebp)
  80205a:	50                   	push   %eax
  80205b:	e8 43 01 00 00       	call   8021a3 <nsipc_shutdown>
  802060:	83 c4 10             	add    $0x10,%esp
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <connect>:
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	e8 d6 fe ff ff       	call   801f49 <fd2sockid>
  802073:	85 c0                	test   %eax,%eax
  802075:	78 12                	js     802089 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802077:	83 ec 04             	sub    $0x4,%esp
  80207a:	ff 75 10             	pushl  0x10(%ebp)
  80207d:	ff 75 0c             	pushl  0xc(%ebp)
  802080:	50                   	push   %eax
  802081:	e8 59 01 00 00       	call   8021df <nsipc_connect>
  802086:	83 c4 10             	add    $0x10,%esp
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <listen>:
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	e8 b0 fe ff ff       	call   801f49 <fd2sockid>
  802099:	85 c0                	test   %eax,%eax
  80209b:	78 0f                	js     8020ac <listen+0x21>
	return nsipc_listen(r, backlog);
  80209d:	83 ec 08             	sub    $0x8,%esp
  8020a0:	ff 75 0c             	pushl  0xc(%ebp)
  8020a3:	50                   	push   %eax
  8020a4:	e8 6b 01 00 00       	call   802214 <nsipc_listen>
  8020a9:	83 c4 10             	add    $0x10,%esp
}
  8020ac:	c9                   	leave  
  8020ad:	c3                   	ret    

008020ae <socket>:

int
socket(int domain, int type, int protocol)
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
  8020b1:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020b4:	ff 75 10             	pushl  0x10(%ebp)
  8020b7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ba:	ff 75 08             	pushl  0x8(%ebp)
  8020bd:	e8 3e 02 00 00       	call   802300 <nsipc_socket>
  8020c2:	83 c4 10             	add    $0x10,%esp
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	78 05                	js     8020ce <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020c9:	e8 ab fe ff ff       	call   801f79 <alloc_sockfd>
}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	53                   	push   %ebx
  8020d4:	83 ec 04             	sub    $0x4,%esp
  8020d7:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020d9:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020e0:	74 26                	je     802108 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020e2:	6a 07                	push   $0x7
  8020e4:	68 00 70 80 00       	push   $0x807000
  8020e9:	53                   	push   %ebx
  8020ea:	ff 35 04 50 80 00    	pushl  0x805004
  8020f0:	e8 0b f5 ff ff       	call   801600 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020f5:	83 c4 0c             	add    $0xc,%esp
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	e8 94 f4 ff ff       	call   801597 <ipc_recv>
}
  802103:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802106:	c9                   	leave  
  802107:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802108:	83 ec 0c             	sub    $0xc,%esp
  80210b:	6a 02                	push   $0x2
  80210d:	e8 46 f5 ff ff       	call   801658 <ipc_find_env>
  802112:	a3 04 50 80 00       	mov    %eax,0x805004
  802117:	83 c4 10             	add    $0x10,%esp
  80211a:	eb c6                	jmp    8020e2 <nsipc+0x12>

0080211c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	56                   	push   %esi
  802120:	53                   	push   %ebx
  802121:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80212c:	8b 06                	mov    (%esi),%eax
  80212e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802133:	b8 01 00 00 00       	mov    $0x1,%eax
  802138:	e8 93 ff ff ff       	call   8020d0 <nsipc>
  80213d:	89 c3                	mov    %eax,%ebx
  80213f:	85 c0                	test   %eax,%eax
  802141:	79 09                	jns    80214c <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802143:	89 d8                	mov    %ebx,%eax
  802145:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802148:	5b                   	pop    %ebx
  802149:	5e                   	pop    %esi
  80214a:	5d                   	pop    %ebp
  80214b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80214c:	83 ec 04             	sub    $0x4,%esp
  80214f:	ff 35 10 70 80 00    	pushl  0x807010
  802155:	68 00 70 80 00       	push   $0x807000
  80215a:	ff 75 0c             	pushl  0xc(%ebp)
  80215d:	e8 ef e9 ff ff       	call   800b51 <memmove>
		*addrlen = ret->ret_addrlen;
  802162:	a1 10 70 80 00       	mov    0x807010,%eax
  802167:	89 06                	mov    %eax,(%esi)
  802169:	83 c4 10             	add    $0x10,%esp
	return r;
  80216c:	eb d5                	jmp    802143 <nsipc_accept+0x27>

0080216e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
  802171:	53                   	push   %ebx
  802172:	83 ec 08             	sub    $0x8,%esp
  802175:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802180:	53                   	push   %ebx
  802181:	ff 75 0c             	pushl  0xc(%ebp)
  802184:	68 04 70 80 00       	push   $0x807004
  802189:	e8 c3 e9 ff ff       	call   800b51 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80218e:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802194:	b8 02 00 00 00       	mov    $0x2,%eax
  802199:	e8 32 ff ff ff       	call   8020d0 <nsipc>
}
  80219e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a1:	c9                   	leave  
  8021a2:	c3                   	ret    

008021a3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b4:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021b9:	b8 03 00 00 00       	mov    $0x3,%eax
  8021be:	e8 0d ff ff ff       	call   8020d0 <nsipc>
}
  8021c3:	c9                   	leave  
  8021c4:	c3                   	ret    

008021c5 <nsipc_close>:

int
nsipc_close(int s)
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
  8021c8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021d3:	b8 04 00 00 00       	mov    $0x4,%eax
  8021d8:	e8 f3 fe ff ff       	call   8020d0 <nsipc>
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	53                   	push   %ebx
  8021e3:	83 ec 08             	sub    $0x8,%esp
  8021e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021f1:	53                   	push   %ebx
  8021f2:	ff 75 0c             	pushl  0xc(%ebp)
  8021f5:	68 04 70 80 00       	push   $0x807004
  8021fa:	e8 52 e9 ff ff       	call   800b51 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021ff:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802205:	b8 05 00 00 00       	mov    $0x5,%eax
  80220a:	e8 c1 fe ff ff       	call   8020d0 <nsipc>
}
  80220f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802222:	8b 45 0c             	mov    0xc(%ebp),%eax
  802225:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80222a:	b8 06 00 00 00       	mov    $0x6,%eax
  80222f:	e8 9c fe ff ff       	call   8020d0 <nsipc>
}
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	56                   	push   %esi
  80223a:	53                   	push   %ebx
  80223b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802246:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80224c:	8b 45 14             	mov    0x14(%ebp),%eax
  80224f:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802254:	b8 07 00 00 00       	mov    $0x7,%eax
  802259:	e8 72 fe ff ff       	call   8020d0 <nsipc>
  80225e:	89 c3                	mov    %eax,%ebx
  802260:	85 c0                	test   %eax,%eax
  802262:	78 1f                	js     802283 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802264:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802269:	7f 21                	jg     80228c <nsipc_recv+0x56>
  80226b:	39 c6                	cmp    %eax,%esi
  80226d:	7c 1d                	jl     80228c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80226f:	83 ec 04             	sub    $0x4,%esp
  802272:	50                   	push   %eax
  802273:	68 00 70 80 00       	push   $0x807000
  802278:	ff 75 0c             	pushl  0xc(%ebp)
  80227b:	e8 d1 e8 ff ff       	call   800b51 <memmove>
  802280:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802283:	89 d8                	mov    %ebx,%eax
  802285:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802288:	5b                   	pop    %ebx
  802289:	5e                   	pop    %esi
  80228a:	5d                   	pop    %ebp
  80228b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80228c:	68 93 31 80 00       	push   $0x803193
  802291:	68 5b 31 80 00       	push   $0x80315b
  802296:	6a 62                	push   $0x62
  802298:	68 a8 31 80 00       	push   $0x8031a8
  80229d:	e8 4b 05 00 00       	call   8027ed <_panic>

008022a2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
  8022a5:	53                   	push   %ebx
  8022a6:	83 ec 04             	sub    $0x4,%esp
  8022a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022b4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022ba:	7f 2e                	jg     8022ea <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022bc:	83 ec 04             	sub    $0x4,%esp
  8022bf:	53                   	push   %ebx
  8022c0:	ff 75 0c             	pushl  0xc(%ebp)
  8022c3:	68 0c 70 80 00       	push   $0x80700c
  8022c8:	e8 84 e8 ff ff       	call   800b51 <memmove>
	nsipcbuf.send.req_size = size;
  8022cd:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8022d6:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022db:	b8 08 00 00 00       	mov    $0x8,%eax
  8022e0:	e8 eb fd ff ff       	call   8020d0 <nsipc>
}
  8022e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    
	assert(size < 1600);
  8022ea:	68 b4 31 80 00       	push   $0x8031b4
  8022ef:	68 5b 31 80 00       	push   $0x80315b
  8022f4:	6a 6d                	push   $0x6d
  8022f6:	68 a8 31 80 00       	push   $0x8031a8
  8022fb:	e8 ed 04 00 00       	call   8027ed <_panic>

00802300 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80230e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802311:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802316:	8b 45 10             	mov    0x10(%ebp),%eax
  802319:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80231e:	b8 09 00 00 00       	mov    $0x9,%eax
  802323:	e8 a8 fd ff ff       	call   8020d0 <nsipc>
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	56                   	push   %esi
  80232e:	53                   	push   %ebx
  80232f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802332:	83 ec 0c             	sub    $0xc,%esp
  802335:	ff 75 08             	pushl  0x8(%ebp)
  802338:	e8 6a f3 ff ff       	call   8016a7 <fd2data>
  80233d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80233f:	83 c4 08             	add    $0x8,%esp
  802342:	68 c0 31 80 00       	push   $0x8031c0
  802347:	53                   	push   %ebx
  802348:	e8 76 e6 ff ff       	call   8009c3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80234d:	8b 46 04             	mov    0x4(%esi),%eax
  802350:	2b 06                	sub    (%esi),%eax
  802352:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802358:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80235f:	00 00 00 
	stat->st_dev = &devpipe;
  802362:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802369:	40 80 00 
	return 0;
}
  80236c:	b8 00 00 00 00       	mov    $0x0,%eax
  802371:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802374:	5b                   	pop    %ebx
  802375:	5e                   	pop    %esi
  802376:	5d                   	pop    %ebp
  802377:	c3                   	ret    

00802378 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
  80237b:	53                   	push   %ebx
  80237c:	83 ec 0c             	sub    $0xc,%esp
  80237f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802382:	53                   	push   %ebx
  802383:	6a 00                	push   $0x0
  802385:	e8 b0 ea ff ff       	call   800e3a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80238a:	89 1c 24             	mov    %ebx,(%esp)
  80238d:	e8 15 f3 ff ff       	call   8016a7 <fd2data>
  802392:	83 c4 08             	add    $0x8,%esp
  802395:	50                   	push   %eax
  802396:	6a 00                	push   $0x0
  802398:	e8 9d ea ff ff       	call   800e3a <sys_page_unmap>
}
  80239d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <_pipeisclosed>:
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	57                   	push   %edi
  8023a6:	56                   	push   %esi
  8023a7:	53                   	push   %ebx
  8023a8:	83 ec 1c             	sub    $0x1c,%esp
  8023ab:	89 c7                	mov    %eax,%edi
  8023ad:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023af:	a1 08 50 80 00       	mov    0x805008,%eax
  8023b4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023b7:	83 ec 0c             	sub    $0xc,%esp
  8023ba:	57                   	push   %edi
  8023bb:	e8 23 05 00 00       	call   8028e3 <pageref>
  8023c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023c3:	89 34 24             	mov    %esi,(%esp)
  8023c6:	e8 18 05 00 00       	call   8028e3 <pageref>
		nn = thisenv->env_runs;
  8023cb:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8023d1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023d4:	83 c4 10             	add    $0x10,%esp
  8023d7:	39 cb                	cmp    %ecx,%ebx
  8023d9:	74 1b                	je     8023f6 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023db:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023de:	75 cf                	jne    8023af <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023e0:	8b 42 58             	mov    0x58(%edx),%eax
  8023e3:	6a 01                	push   $0x1
  8023e5:	50                   	push   %eax
  8023e6:	53                   	push   %ebx
  8023e7:	68 c7 31 80 00       	push   $0x8031c7
  8023ec:	e8 73 de ff ff       	call   800264 <cprintf>
  8023f1:	83 c4 10             	add    $0x10,%esp
  8023f4:	eb b9                	jmp    8023af <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8023f6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023f9:	0f 94 c0             	sete   %al
  8023fc:	0f b6 c0             	movzbl %al,%eax
}
  8023ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802402:	5b                   	pop    %ebx
  802403:	5e                   	pop    %esi
  802404:	5f                   	pop    %edi
  802405:	5d                   	pop    %ebp
  802406:	c3                   	ret    

00802407 <devpipe_write>:
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
  80240a:	57                   	push   %edi
  80240b:	56                   	push   %esi
  80240c:	53                   	push   %ebx
  80240d:	83 ec 28             	sub    $0x28,%esp
  802410:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802413:	56                   	push   %esi
  802414:	e8 8e f2 ff ff       	call   8016a7 <fd2data>
  802419:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80241b:	83 c4 10             	add    $0x10,%esp
  80241e:	bf 00 00 00 00       	mov    $0x0,%edi
  802423:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802426:	74 4f                	je     802477 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802428:	8b 43 04             	mov    0x4(%ebx),%eax
  80242b:	8b 0b                	mov    (%ebx),%ecx
  80242d:	8d 51 20             	lea    0x20(%ecx),%edx
  802430:	39 d0                	cmp    %edx,%eax
  802432:	72 14                	jb     802448 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802434:	89 da                	mov    %ebx,%edx
  802436:	89 f0                	mov    %esi,%eax
  802438:	e8 65 ff ff ff       	call   8023a2 <_pipeisclosed>
  80243d:	85 c0                	test   %eax,%eax
  80243f:	75 3b                	jne    80247c <devpipe_write+0x75>
			sys_yield();
  802441:	e8 50 e9 ff ff       	call   800d96 <sys_yield>
  802446:	eb e0                	jmp    802428 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802448:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80244b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80244f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802452:	89 c2                	mov    %eax,%edx
  802454:	c1 fa 1f             	sar    $0x1f,%edx
  802457:	89 d1                	mov    %edx,%ecx
  802459:	c1 e9 1b             	shr    $0x1b,%ecx
  80245c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80245f:	83 e2 1f             	and    $0x1f,%edx
  802462:	29 ca                	sub    %ecx,%edx
  802464:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802468:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80246c:	83 c0 01             	add    $0x1,%eax
  80246f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802472:	83 c7 01             	add    $0x1,%edi
  802475:	eb ac                	jmp    802423 <devpipe_write+0x1c>
	return i;
  802477:	8b 45 10             	mov    0x10(%ebp),%eax
  80247a:	eb 05                	jmp    802481 <devpipe_write+0x7a>
				return 0;
  80247c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802481:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802484:	5b                   	pop    %ebx
  802485:	5e                   	pop    %esi
  802486:	5f                   	pop    %edi
  802487:	5d                   	pop    %ebp
  802488:	c3                   	ret    

00802489 <devpipe_read>:
{
  802489:	55                   	push   %ebp
  80248a:	89 e5                	mov    %esp,%ebp
  80248c:	57                   	push   %edi
  80248d:	56                   	push   %esi
  80248e:	53                   	push   %ebx
  80248f:	83 ec 18             	sub    $0x18,%esp
  802492:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802495:	57                   	push   %edi
  802496:	e8 0c f2 ff ff       	call   8016a7 <fd2data>
  80249b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80249d:	83 c4 10             	add    $0x10,%esp
  8024a0:	be 00 00 00 00       	mov    $0x0,%esi
  8024a5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024a8:	75 14                	jne    8024be <devpipe_read+0x35>
	return i;
  8024aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ad:	eb 02                	jmp    8024b1 <devpipe_read+0x28>
				return i;
  8024af:	89 f0                	mov    %esi,%eax
}
  8024b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024b4:	5b                   	pop    %ebx
  8024b5:	5e                   	pop    %esi
  8024b6:	5f                   	pop    %edi
  8024b7:	5d                   	pop    %ebp
  8024b8:	c3                   	ret    
			sys_yield();
  8024b9:	e8 d8 e8 ff ff       	call   800d96 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024be:	8b 03                	mov    (%ebx),%eax
  8024c0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024c3:	75 18                	jne    8024dd <devpipe_read+0x54>
			if (i > 0)
  8024c5:	85 f6                	test   %esi,%esi
  8024c7:	75 e6                	jne    8024af <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024c9:	89 da                	mov    %ebx,%edx
  8024cb:	89 f8                	mov    %edi,%eax
  8024cd:	e8 d0 fe ff ff       	call   8023a2 <_pipeisclosed>
  8024d2:	85 c0                	test   %eax,%eax
  8024d4:	74 e3                	je     8024b9 <devpipe_read+0x30>
				return 0;
  8024d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024db:	eb d4                	jmp    8024b1 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024dd:	99                   	cltd   
  8024de:	c1 ea 1b             	shr    $0x1b,%edx
  8024e1:	01 d0                	add    %edx,%eax
  8024e3:	83 e0 1f             	and    $0x1f,%eax
  8024e6:	29 d0                	sub    %edx,%eax
  8024e8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024f0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024f3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8024f6:	83 c6 01             	add    $0x1,%esi
  8024f9:	eb aa                	jmp    8024a5 <devpipe_read+0x1c>

008024fb <pipe>:
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
  8024fe:	56                   	push   %esi
  8024ff:	53                   	push   %ebx
  802500:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802503:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802506:	50                   	push   %eax
  802507:	e8 b2 f1 ff ff       	call   8016be <fd_alloc>
  80250c:	89 c3                	mov    %eax,%ebx
  80250e:	83 c4 10             	add    $0x10,%esp
  802511:	85 c0                	test   %eax,%eax
  802513:	0f 88 23 01 00 00    	js     80263c <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802519:	83 ec 04             	sub    $0x4,%esp
  80251c:	68 07 04 00 00       	push   $0x407
  802521:	ff 75 f4             	pushl  -0xc(%ebp)
  802524:	6a 00                	push   $0x0
  802526:	e8 8a e8 ff ff       	call   800db5 <sys_page_alloc>
  80252b:	89 c3                	mov    %eax,%ebx
  80252d:	83 c4 10             	add    $0x10,%esp
  802530:	85 c0                	test   %eax,%eax
  802532:	0f 88 04 01 00 00    	js     80263c <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802538:	83 ec 0c             	sub    $0xc,%esp
  80253b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80253e:	50                   	push   %eax
  80253f:	e8 7a f1 ff ff       	call   8016be <fd_alloc>
  802544:	89 c3                	mov    %eax,%ebx
  802546:	83 c4 10             	add    $0x10,%esp
  802549:	85 c0                	test   %eax,%eax
  80254b:	0f 88 db 00 00 00    	js     80262c <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802551:	83 ec 04             	sub    $0x4,%esp
  802554:	68 07 04 00 00       	push   $0x407
  802559:	ff 75 f0             	pushl  -0x10(%ebp)
  80255c:	6a 00                	push   $0x0
  80255e:	e8 52 e8 ff ff       	call   800db5 <sys_page_alloc>
  802563:	89 c3                	mov    %eax,%ebx
  802565:	83 c4 10             	add    $0x10,%esp
  802568:	85 c0                	test   %eax,%eax
  80256a:	0f 88 bc 00 00 00    	js     80262c <pipe+0x131>
	va = fd2data(fd0);
  802570:	83 ec 0c             	sub    $0xc,%esp
  802573:	ff 75 f4             	pushl  -0xc(%ebp)
  802576:	e8 2c f1 ff ff       	call   8016a7 <fd2data>
  80257b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80257d:	83 c4 0c             	add    $0xc,%esp
  802580:	68 07 04 00 00       	push   $0x407
  802585:	50                   	push   %eax
  802586:	6a 00                	push   $0x0
  802588:	e8 28 e8 ff ff       	call   800db5 <sys_page_alloc>
  80258d:	89 c3                	mov    %eax,%ebx
  80258f:	83 c4 10             	add    $0x10,%esp
  802592:	85 c0                	test   %eax,%eax
  802594:	0f 88 82 00 00 00    	js     80261c <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80259a:	83 ec 0c             	sub    $0xc,%esp
  80259d:	ff 75 f0             	pushl  -0x10(%ebp)
  8025a0:	e8 02 f1 ff ff       	call   8016a7 <fd2data>
  8025a5:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025ac:	50                   	push   %eax
  8025ad:	6a 00                	push   $0x0
  8025af:	56                   	push   %esi
  8025b0:	6a 00                	push   $0x0
  8025b2:	e8 41 e8 ff ff       	call   800df8 <sys_page_map>
  8025b7:	89 c3                	mov    %eax,%ebx
  8025b9:	83 c4 20             	add    $0x20,%esp
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	78 4e                	js     80260e <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8025c0:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8025c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c8:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025cd:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025d7:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025dc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025e3:	83 ec 0c             	sub    $0xc,%esp
  8025e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e9:	e8 a9 f0 ff ff       	call   801697 <fd2num>
  8025ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025f1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025f3:	83 c4 04             	add    $0x4,%esp
  8025f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8025f9:	e8 99 f0 ff ff       	call   801697 <fd2num>
  8025fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802601:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802604:	83 c4 10             	add    $0x10,%esp
  802607:	bb 00 00 00 00       	mov    $0x0,%ebx
  80260c:	eb 2e                	jmp    80263c <pipe+0x141>
	sys_page_unmap(0, va);
  80260e:	83 ec 08             	sub    $0x8,%esp
  802611:	56                   	push   %esi
  802612:	6a 00                	push   $0x0
  802614:	e8 21 e8 ff ff       	call   800e3a <sys_page_unmap>
  802619:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80261c:	83 ec 08             	sub    $0x8,%esp
  80261f:	ff 75 f0             	pushl  -0x10(%ebp)
  802622:	6a 00                	push   $0x0
  802624:	e8 11 e8 ff ff       	call   800e3a <sys_page_unmap>
  802629:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80262c:	83 ec 08             	sub    $0x8,%esp
  80262f:	ff 75 f4             	pushl  -0xc(%ebp)
  802632:	6a 00                	push   $0x0
  802634:	e8 01 e8 ff ff       	call   800e3a <sys_page_unmap>
  802639:	83 c4 10             	add    $0x10,%esp
}
  80263c:	89 d8                	mov    %ebx,%eax
  80263e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802641:	5b                   	pop    %ebx
  802642:	5e                   	pop    %esi
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    

00802645 <pipeisclosed>:
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80264b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80264e:	50                   	push   %eax
  80264f:	ff 75 08             	pushl  0x8(%ebp)
  802652:	e8 b9 f0 ff ff       	call   801710 <fd_lookup>
  802657:	83 c4 10             	add    $0x10,%esp
  80265a:	85 c0                	test   %eax,%eax
  80265c:	78 18                	js     802676 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80265e:	83 ec 0c             	sub    $0xc,%esp
  802661:	ff 75 f4             	pushl  -0xc(%ebp)
  802664:	e8 3e f0 ff ff       	call   8016a7 <fd2data>
	return _pipeisclosed(fd, p);
  802669:	89 c2                	mov    %eax,%edx
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	e8 2f fd ff ff       	call   8023a2 <_pipeisclosed>
  802673:	83 c4 10             	add    $0x10,%esp
}
  802676:	c9                   	leave  
  802677:	c3                   	ret    

00802678 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802678:	b8 00 00 00 00       	mov    $0x0,%eax
  80267d:	c3                   	ret    

0080267e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80267e:	55                   	push   %ebp
  80267f:	89 e5                	mov    %esp,%ebp
  802681:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802684:	68 df 31 80 00       	push   $0x8031df
  802689:	ff 75 0c             	pushl  0xc(%ebp)
  80268c:	e8 32 e3 ff ff       	call   8009c3 <strcpy>
	return 0;
}
  802691:	b8 00 00 00 00       	mov    $0x0,%eax
  802696:	c9                   	leave  
  802697:	c3                   	ret    

00802698 <devcons_write>:
{
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
  80269b:	57                   	push   %edi
  80269c:	56                   	push   %esi
  80269d:	53                   	push   %ebx
  80269e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026a4:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026a9:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026af:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026b2:	73 31                	jae    8026e5 <devcons_write+0x4d>
		m = n - tot;
  8026b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026b7:	29 f3                	sub    %esi,%ebx
  8026b9:	83 fb 7f             	cmp    $0x7f,%ebx
  8026bc:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8026c1:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8026c4:	83 ec 04             	sub    $0x4,%esp
  8026c7:	53                   	push   %ebx
  8026c8:	89 f0                	mov    %esi,%eax
  8026ca:	03 45 0c             	add    0xc(%ebp),%eax
  8026cd:	50                   	push   %eax
  8026ce:	57                   	push   %edi
  8026cf:	e8 7d e4 ff ff       	call   800b51 <memmove>
		sys_cputs(buf, m);
  8026d4:	83 c4 08             	add    $0x8,%esp
  8026d7:	53                   	push   %ebx
  8026d8:	57                   	push   %edi
  8026d9:	e8 1b e6 ff ff       	call   800cf9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8026de:	01 de                	add    %ebx,%esi
  8026e0:	83 c4 10             	add    $0x10,%esp
  8026e3:	eb ca                	jmp    8026af <devcons_write+0x17>
}
  8026e5:	89 f0                	mov    %esi,%eax
  8026e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026ea:	5b                   	pop    %ebx
  8026eb:	5e                   	pop    %esi
  8026ec:	5f                   	pop    %edi
  8026ed:	5d                   	pop    %ebp
  8026ee:	c3                   	ret    

008026ef <devcons_read>:
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
  8026f2:	83 ec 08             	sub    $0x8,%esp
  8026f5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8026fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026fe:	74 21                	je     802721 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802700:	e8 12 e6 ff ff       	call   800d17 <sys_cgetc>
  802705:	85 c0                	test   %eax,%eax
  802707:	75 07                	jne    802710 <devcons_read+0x21>
		sys_yield();
  802709:	e8 88 e6 ff ff       	call   800d96 <sys_yield>
  80270e:	eb f0                	jmp    802700 <devcons_read+0x11>
	if (c < 0)
  802710:	78 0f                	js     802721 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802712:	83 f8 04             	cmp    $0x4,%eax
  802715:	74 0c                	je     802723 <devcons_read+0x34>
	*(char*)vbuf = c;
  802717:	8b 55 0c             	mov    0xc(%ebp),%edx
  80271a:	88 02                	mov    %al,(%edx)
	return 1;
  80271c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802721:	c9                   	leave  
  802722:	c3                   	ret    
		return 0;
  802723:	b8 00 00 00 00       	mov    $0x0,%eax
  802728:	eb f7                	jmp    802721 <devcons_read+0x32>

0080272a <cputchar>:
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
  80272d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802730:	8b 45 08             	mov    0x8(%ebp),%eax
  802733:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802736:	6a 01                	push   $0x1
  802738:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80273b:	50                   	push   %eax
  80273c:	e8 b8 e5 ff ff       	call   800cf9 <sys_cputs>
}
  802741:	83 c4 10             	add    $0x10,%esp
  802744:	c9                   	leave  
  802745:	c3                   	ret    

00802746 <getchar>:
{
  802746:	55                   	push   %ebp
  802747:	89 e5                	mov    %esp,%ebp
  802749:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80274c:	6a 01                	push   $0x1
  80274e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802751:	50                   	push   %eax
  802752:	6a 00                	push   $0x0
  802754:	e8 27 f2 ff ff       	call   801980 <read>
	if (r < 0)
  802759:	83 c4 10             	add    $0x10,%esp
  80275c:	85 c0                	test   %eax,%eax
  80275e:	78 06                	js     802766 <getchar+0x20>
	if (r < 1)
  802760:	74 06                	je     802768 <getchar+0x22>
	return c;
  802762:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802766:	c9                   	leave  
  802767:	c3                   	ret    
		return -E_EOF;
  802768:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80276d:	eb f7                	jmp    802766 <getchar+0x20>

0080276f <iscons>:
{
  80276f:	55                   	push   %ebp
  802770:	89 e5                	mov    %esp,%ebp
  802772:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802775:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802778:	50                   	push   %eax
  802779:	ff 75 08             	pushl  0x8(%ebp)
  80277c:	e8 8f ef ff ff       	call   801710 <fd_lookup>
  802781:	83 c4 10             	add    $0x10,%esp
  802784:	85 c0                	test   %eax,%eax
  802786:	78 11                	js     802799 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802791:	39 10                	cmp    %edx,(%eax)
  802793:	0f 94 c0             	sete   %al
  802796:	0f b6 c0             	movzbl %al,%eax
}
  802799:	c9                   	leave  
  80279a:	c3                   	ret    

0080279b <opencons>:
{
  80279b:	55                   	push   %ebp
  80279c:	89 e5                	mov    %esp,%ebp
  80279e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027a4:	50                   	push   %eax
  8027a5:	e8 14 ef ff ff       	call   8016be <fd_alloc>
  8027aa:	83 c4 10             	add    $0x10,%esp
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	78 3a                	js     8027eb <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027b1:	83 ec 04             	sub    $0x4,%esp
  8027b4:	68 07 04 00 00       	push   $0x407
  8027b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8027bc:	6a 00                	push   $0x0
  8027be:	e8 f2 e5 ff ff       	call   800db5 <sys_page_alloc>
  8027c3:	83 c4 10             	add    $0x10,%esp
  8027c6:	85 c0                	test   %eax,%eax
  8027c8:	78 21                	js     8027eb <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027d3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027df:	83 ec 0c             	sub    $0xc,%esp
  8027e2:	50                   	push   %eax
  8027e3:	e8 af ee ff ff       	call   801697 <fd2num>
  8027e8:	83 c4 10             	add    $0x10,%esp
}
  8027eb:	c9                   	leave  
  8027ec:	c3                   	ret    

008027ed <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8027ed:	55                   	push   %ebp
  8027ee:	89 e5                	mov    %esp,%ebp
  8027f0:	56                   	push   %esi
  8027f1:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8027f2:	a1 08 50 80 00       	mov    0x805008,%eax
  8027f7:	8b 40 48             	mov    0x48(%eax),%eax
  8027fa:	83 ec 04             	sub    $0x4,%esp
  8027fd:	68 10 32 80 00       	push   $0x803210
  802802:	50                   	push   %eax
  802803:	68 01 2c 80 00       	push   $0x802c01
  802808:	e8 57 da ff ff       	call   800264 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80280d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802810:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802816:	e8 5c e5 ff ff       	call   800d77 <sys_getenvid>
  80281b:	83 c4 04             	add    $0x4,%esp
  80281e:	ff 75 0c             	pushl  0xc(%ebp)
  802821:	ff 75 08             	pushl  0x8(%ebp)
  802824:	56                   	push   %esi
  802825:	50                   	push   %eax
  802826:	68 ec 31 80 00       	push   $0x8031ec
  80282b:	e8 34 da ff ff       	call   800264 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802830:	83 c4 18             	add    $0x18,%esp
  802833:	53                   	push   %ebx
  802834:	ff 75 10             	pushl  0x10(%ebp)
  802837:	e8 d7 d9 ff ff       	call   800213 <vcprintf>
	cprintf("\n");
  80283c:	c7 04 24 c5 2b 80 00 	movl   $0x802bc5,(%esp)
  802843:	e8 1c da ff ff       	call   800264 <cprintf>
  802848:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80284b:	cc                   	int3   
  80284c:	eb fd                	jmp    80284b <_panic+0x5e>

0080284e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80284e:	55                   	push   %ebp
  80284f:	89 e5                	mov    %esp,%ebp
  802851:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802854:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80285b:	74 0a                	je     802867 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802865:	c9                   	leave  
  802866:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802867:	83 ec 04             	sub    $0x4,%esp
  80286a:	6a 07                	push   $0x7
  80286c:	68 00 f0 bf ee       	push   $0xeebff000
  802871:	6a 00                	push   $0x0
  802873:	e8 3d e5 ff ff       	call   800db5 <sys_page_alloc>
		if(r < 0)
  802878:	83 c4 10             	add    $0x10,%esp
  80287b:	85 c0                	test   %eax,%eax
  80287d:	78 2a                	js     8028a9 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80287f:	83 ec 08             	sub    $0x8,%esp
  802882:	68 bd 28 80 00       	push   $0x8028bd
  802887:	6a 00                	push   $0x0
  802889:	e8 72 e6 ff ff       	call   800f00 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80288e:	83 c4 10             	add    $0x10,%esp
  802891:	85 c0                	test   %eax,%eax
  802893:	79 c8                	jns    80285d <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802895:	83 ec 04             	sub    $0x4,%esp
  802898:	68 48 32 80 00       	push   $0x803248
  80289d:	6a 25                	push   $0x25
  80289f:	68 84 32 80 00       	push   $0x803284
  8028a4:	e8 44 ff ff ff       	call   8027ed <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8028a9:	83 ec 04             	sub    $0x4,%esp
  8028ac:	68 18 32 80 00       	push   $0x803218
  8028b1:	6a 22                	push   $0x22
  8028b3:	68 84 32 80 00       	push   $0x803284
  8028b8:	e8 30 ff ff ff       	call   8027ed <_panic>

008028bd <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028bd:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8028be:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8028c3:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028c5:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8028c8:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8028cc:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8028d0:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8028d3:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8028d5:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8028d9:	83 c4 08             	add    $0x8,%esp
	popal
  8028dc:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8028dd:	83 c4 04             	add    $0x4,%esp
	popfl
  8028e0:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8028e1:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8028e2:	c3                   	ret    

008028e3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
  8028e6:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028e9:	89 d0                	mov    %edx,%eax
  8028eb:	c1 e8 16             	shr    $0x16,%eax
  8028ee:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028f5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028fa:	f6 c1 01             	test   $0x1,%cl
  8028fd:	74 1d                	je     80291c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028ff:	c1 ea 0c             	shr    $0xc,%edx
  802902:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802909:	f6 c2 01             	test   $0x1,%dl
  80290c:	74 0e                	je     80291c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80290e:	c1 ea 0c             	shr    $0xc,%edx
  802911:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802918:	ef 
  802919:	0f b7 c0             	movzwl %ax,%eax
}
  80291c:	5d                   	pop    %ebp
  80291d:	c3                   	ret    
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
