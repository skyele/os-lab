
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
  80003c:	e8 2c 12 00 00       	call   80126d <fork>
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
  800053:	e8 ad 14 00 00       	call   801505 <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 83 0c 00 00       	call   800ce5 <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 f6 2a 80 00       	push   $0x802af6
  80006a:	e8 63 01 00 00       	call   8001d2 <cprintf>
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
  800082:	e8 e7 14 00 00       	call   80156e <ipc_send>
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
  800099:	e8 47 0c 00 00       	call   800ce5 <sys_getenvid>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	50                   	push   %eax
  8000a3:	68 e0 2a 80 00       	push   $0x802ae0
  8000a8:	e8 25 01 00 00       	call   8001d2 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	e8 b3 14 00 00       	call   80156e <ipc_send>
  8000bb:	83 c4 20             	add    $0x20,%esp
  8000be:	eb 88                	jmp    800048 <umain+0x15>

008000c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	56                   	push   %esi
  8000c4:	53                   	push   %ebx
  8000c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8000cb:	e8 15 0c 00 00       	call   800ce5 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8000d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d5:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000db:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e0:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e5:	85 db                	test   %ebx,%ebx
  8000e7:	7e 07                	jle    8000f0 <libmain+0x30>
		binaryname = argv[0];
  8000e9:	8b 06                	mov    (%esi),%eax
  8000eb:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8000f0:	83 ec 08             	sub    $0x8,%esp
  8000f3:	56                   	push   %esi
  8000f4:	53                   	push   %ebx
  8000f5:	e8 39 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000fa:	e8 0a 00 00 00       	call   800109 <exit>
}
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800105:	5b                   	pop    %ebx
  800106:	5e                   	pop    %esi
  800107:	5d                   	pop    %ebp
  800108:	c3                   	ret    

00800109 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800109:	55                   	push   %ebp
  80010a:	89 e5                	mov    %esp,%ebp
  80010c:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80010f:	a1 08 50 80 00       	mov    0x805008,%eax
  800114:	8b 40 48             	mov    0x48(%eax),%eax
  800117:	68 20 2b 80 00       	push   $0x802b20
  80011c:	50                   	push   %eax
  80011d:	68 13 2b 80 00       	push   $0x802b13
  800122:	e8 ab 00 00 00       	call   8001d2 <cprintf>
	close_all();
  800127:	e8 b1 16 00 00       	call   8017dd <close_all>
	sys_env_destroy(0);
  80012c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800133:	e8 6c 0b 00 00       	call   800ca4 <sys_env_destroy>
}
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	c9                   	leave  
  80013c:	c3                   	ret    

0080013d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80013d:	55                   	push   %ebp
  80013e:	89 e5                	mov    %esp,%ebp
  800140:	53                   	push   %ebx
  800141:	83 ec 04             	sub    $0x4,%esp
  800144:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800147:	8b 13                	mov    (%ebx),%edx
  800149:	8d 42 01             	lea    0x1(%edx),%eax
  80014c:	89 03                	mov    %eax,(%ebx)
  80014e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800151:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800155:	3d ff 00 00 00       	cmp    $0xff,%eax
  80015a:	74 09                	je     800165 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80015c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800160:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800163:	c9                   	leave  
  800164:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800165:	83 ec 08             	sub    $0x8,%esp
  800168:	68 ff 00 00 00       	push   $0xff
  80016d:	8d 43 08             	lea    0x8(%ebx),%eax
  800170:	50                   	push   %eax
  800171:	e8 f1 0a 00 00       	call   800c67 <sys_cputs>
		b->idx = 0;
  800176:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	eb db                	jmp    80015c <putch+0x1f>

00800181 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80018a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800191:	00 00 00 
	b.cnt = 0;
  800194:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80019b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80019e:	ff 75 0c             	pushl  0xc(%ebp)
  8001a1:	ff 75 08             	pushl  0x8(%ebp)
  8001a4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001aa:	50                   	push   %eax
  8001ab:	68 3d 01 80 00       	push   $0x80013d
  8001b0:	e8 4a 01 00 00       	call   8002ff <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001b5:	83 c4 08             	add    $0x8,%esp
  8001b8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001be:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001c4:	50                   	push   %eax
  8001c5:	e8 9d 0a 00 00       	call   800c67 <sys_cputs>

	return b.cnt;
}
  8001ca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001d0:	c9                   	leave  
  8001d1:	c3                   	ret    

008001d2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001db:	50                   	push   %eax
  8001dc:	ff 75 08             	pushl  0x8(%ebp)
  8001df:	e8 9d ff ff ff       	call   800181 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001e4:	c9                   	leave  
  8001e5:	c3                   	ret    

008001e6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	57                   	push   %edi
  8001ea:	56                   	push   %esi
  8001eb:	53                   	push   %ebx
  8001ec:	83 ec 1c             	sub    $0x1c,%esp
  8001ef:	89 c6                	mov    %eax,%esi
  8001f1:	89 d7                	mov    %edx,%edi
  8001f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001fc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800202:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800205:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800209:	74 2c                	je     800237 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80020b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80020e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800215:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800218:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80021b:	39 c2                	cmp    %eax,%edx
  80021d:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800220:	73 43                	jae    800265 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800222:	83 eb 01             	sub    $0x1,%ebx
  800225:	85 db                	test   %ebx,%ebx
  800227:	7e 6c                	jle    800295 <printnum+0xaf>
				putch(padc, putdat);
  800229:	83 ec 08             	sub    $0x8,%esp
  80022c:	57                   	push   %edi
  80022d:	ff 75 18             	pushl  0x18(%ebp)
  800230:	ff d6                	call   *%esi
  800232:	83 c4 10             	add    $0x10,%esp
  800235:	eb eb                	jmp    800222 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	6a 20                	push   $0x20
  80023c:	6a 00                	push   $0x0
  80023e:	50                   	push   %eax
  80023f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800242:	ff 75 e0             	pushl  -0x20(%ebp)
  800245:	89 fa                	mov    %edi,%edx
  800247:	89 f0                	mov    %esi,%eax
  800249:	e8 98 ff ff ff       	call   8001e6 <printnum>
		while (--width > 0)
  80024e:	83 c4 20             	add    $0x20,%esp
  800251:	83 eb 01             	sub    $0x1,%ebx
  800254:	85 db                	test   %ebx,%ebx
  800256:	7e 65                	jle    8002bd <printnum+0xd7>
			putch(padc, putdat);
  800258:	83 ec 08             	sub    $0x8,%esp
  80025b:	57                   	push   %edi
  80025c:	6a 20                	push   $0x20
  80025e:	ff d6                	call   *%esi
  800260:	83 c4 10             	add    $0x10,%esp
  800263:	eb ec                	jmp    800251 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	ff 75 18             	pushl  0x18(%ebp)
  80026b:	83 eb 01             	sub    $0x1,%ebx
  80026e:	53                   	push   %ebx
  80026f:	50                   	push   %eax
  800270:	83 ec 08             	sub    $0x8,%esp
  800273:	ff 75 dc             	pushl  -0x24(%ebp)
  800276:	ff 75 d8             	pushl  -0x28(%ebp)
  800279:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027c:	ff 75 e0             	pushl  -0x20(%ebp)
  80027f:	e8 0c 26 00 00       	call   802890 <__udivdi3>
  800284:	83 c4 18             	add    $0x18,%esp
  800287:	52                   	push   %edx
  800288:	50                   	push   %eax
  800289:	89 fa                	mov    %edi,%edx
  80028b:	89 f0                	mov    %esi,%eax
  80028d:	e8 54 ff ff ff       	call   8001e6 <printnum>
  800292:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800295:	83 ec 08             	sub    $0x8,%esp
  800298:	57                   	push   %edi
  800299:	83 ec 04             	sub    $0x4,%esp
  80029c:	ff 75 dc             	pushl  -0x24(%ebp)
  80029f:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a8:	e8 f3 26 00 00       	call   8029a0 <__umoddi3>
  8002ad:	83 c4 14             	add    $0x14,%esp
  8002b0:	0f be 80 25 2b 80 00 	movsbl 0x802b25(%eax),%eax
  8002b7:	50                   	push   %eax
  8002b8:	ff d6                	call   *%esi
  8002ba:	83 c4 10             	add    $0x10,%esp
	}
}
  8002bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c0:	5b                   	pop    %ebx
  8002c1:	5e                   	pop    %esi
  8002c2:	5f                   	pop    %edi
  8002c3:	5d                   	pop    %ebp
  8002c4:	c3                   	ret    

008002c5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002cb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002cf:	8b 10                	mov    (%eax),%edx
  8002d1:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d4:	73 0a                	jae    8002e0 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002d9:	89 08                	mov    %ecx,(%eax)
  8002db:	8b 45 08             	mov    0x8(%ebp),%eax
  8002de:	88 02                	mov    %al,(%edx)
}
  8002e0:	5d                   	pop    %ebp
  8002e1:	c3                   	ret    

008002e2 <printfmt>:
{
  8002e2:	55                   	push   %ebp
  8002e3:	89 e5                	mov    %esp,%ebp
  8002e5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002e8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002eb:	50                   	push   %eax
  8002ec:	ff 75 10             	pushl  0x10(%ebp)
  8002ef:	ff 75 0c             	pushl  0xc(%ebp)
  8002f2:	ff 75 08             	pushl  0x8(%ebp)
  8002f5:	e8 05 00 00 00       	call   8002ff <vprintfmt>
}
  8002fa:	83 c4 10             	add    $0x10,%esp
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    

008002ff <vprintfmt>:
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	57                   	push   %edi
  800303:	56                   	push   %esi
  800304:	53                   	push   %ebx
  800305:	83 ec 3c             	sub    $0x3c,%esp
  800308:	8b 75 08             	mov    0x8(%ebp),%esi
  80030b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80030e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800311:	e9 32 04 00 00       	jmp    800748 <vprintfmt+0x449>
		padc = ' ';
  800316:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80031a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800321:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800328:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80032f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800336:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80033d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800342:	8d 47 01             	lea    0x1(%edi),%eax
  800345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800348:	0f b6 17             	movzbl (%edi),%edx
  80034b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80034e:	3c 55                	cmp    $0x55,%al
  800350:	0f 87 12 05 00 00    	ja     800868 <vprintfmt+0x569>
  800356:	0f b6 c0             	movzbl %al,%eax
  800359:	ff 24 85 00 2d 80 00 	jmp    *0x802d00(,%eax,4)
  800360:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800363:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800367:	eb d9                	jmp    800342 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800369:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80036c:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800370:	eb d0                	jmp    800342 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800372:	0f b6 d2             	movzbl %dl,%edx
  800375:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800378:	b8 00 00 00 00       	mov    $0x0,%eax
  80037d:	89 75 08             	mov    %esi,0x8(%ebp)
  800380:	eb 03                	jmp    800385 <vprintfmt+0x86>
  800382:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800385:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800388:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80038c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80038f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800392:	83 fe 09             	cmp    $0x9,%esi
  800395:	76 eb                	jbe    800382 <vprintfmt+0x83>
  800397:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80039a:	8b 75 08             	mov    0x8(%ebp),%esi
  80039d:	eb 14                	jmp    8003b3 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80039f:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a2:	8b 00                	mov    (%eax),%eax
  8003a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003aa:	8d 40 04             	lea    0x4(%eax),%eax
  8003ad:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b7:	79 89                	jns    800342 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003bf:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003c6:	e9 77 ff ff ff       	jmp    800342 <vprintfmt+0x43>
  8003cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ce:	85 c0                	test   %eax,%eax
  8003d0:	0f 48 c1             	cmovs  %ecx,%eax
  8003d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003d9:	e9 64 ff ff ff       	jmp    800342 <vprintfmt+0x43>
  8003de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e1:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003e8:	e9 55 ff ff ff       	jmp    800342 <vprintfmt+0x43>
			lflag++;
  8003ed:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003f4:	e9 49 ff ff ff       	jmp    800342 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fc:	8d 78 04             	lea    0x4(%eax),%edi
  8003ff:	83 ec 08             	sub    $0x8,%esp
  800402:	53                   	push   %ebx
  800403:	ff 30                	pushl  (%eax)
  800405:	ff d6                	call   *%esi
			break;
  800407:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80040a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80040d:	e9 33 03 00 00       	jmp    800745 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800412:	8b 45 14             	mov    0x14(%ebp),%eax
  800415:	8d 78 04             	lea    0x4(%eax),%edi
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	99                   	cltd   
  80041b:	31 d0                	xor    %edx,%eax
  80041d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80041f:	83 f8 11             	cmp    $0x11,%eax
  800422:	7f 23                	jg     800447 <vprintfmt+0x148>
  800424:	8b 14 85 60 2e 80 00 	mov    0x802e60(,%eax,4),%edx
  80042b:	85 d2                	test   %edx,%edx
  80042d:	74 18                	je     800447 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80042f:	52                   	push   %edx
  800430:	68 8d 30 80 00       	push   $0x80308d
  800435:	53                   	push   %ebx
  800436:	56                   	push   %esi
  800437:	e8 a6 fe ff ff       	call   8002e2 <printfmt>
  80043c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800442:	e9 fe 02 00 00       	jmp    800745 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800447:	50                   	push   %eax
  800448:	68 3d 2b 80 00       	push   $0x802b3d
  80044d:	53                   	push   %ebx
  80044e:	56                   	push   %esi
  80044f:	e8 8e fe ff ff       	call   8002e2 <printfmt>
  800454:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800457:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80045a:	e9 e6 02 00 00       	jmp    800745 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80045f:	8b 45 14             	mov    0x14(%ebp),%eax
  800462:	83 c0 04             	add    $0x4,%eax
  800465:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800468:	8b 45 14             	mov    0x14(%ebp),%eax
  80046b:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80046d:	85 c9                	test   %ecx,%ecx
  80046f:	b8 36 2b 80 00       	mov    $0x802b36,%eax
  800474:	0f 45 c1             	cmovne %ecx,%eax
  800477:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80047a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80047e:	7e 06                	jle    800486 <vprintfmt+0x187>
  800480:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800484:	75 0d                	jne    800493 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800486:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800489:	89 c7                	mov    %eax,%edi
  80048b:	03 45 e0             	add    -0x20(%ebp),%eax
  80048e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800491:	eb 53                	jmp    8004e6 <vprintfmt+0x1e7>
  800493:	83 ec 08             	sub    $0x8,%esp
  800496:	ff 75 d8             	pushl  -0x28(%ebp)
  800499:	50                   	push   %eax
  80049a:	e8 71 04 00 00       	call   800910 <strnlen>
  80049f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a2:	29 c1                	sub    %eax,%ecx
  8004a4:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004ac:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b3:	eb 0f                	jmp    8004c4 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004b5:	83 ec 08             	sub    $0x8,%esp
  8004b8:	53                   	push   %ebx
  8004b9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004bc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004be:	83 ef 01             	sub    $0x1,%edi
  8004c1:	83 c4 10             	add    $0x10,%esp
  8004c4:	85 ff                	test   %edi,%edi
  8004c6:	7f ed                	jg     8004b5 <vprintfmt+0x1b6>
  8004c8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004cb:	85 c9                	test   %ecx,%ecx
  8004cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d2:	0f 49 c1             	cmovns %ecx,%eax
  8004d5:	29 c1                	sub    %eax,%ecx
  8004d7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004da:	eb aa                	jmp    800486 <vprintfmt+0x187>
					putch(ch, putdat);
  8004dc:	83 ec 08             	sub    $0x8,%esp
  8004df:	53                   	push   %ebx
  8004e0:	52                   	push   %edx
  8004e1:	ff d6                	call   *%esi
  8004e3:	83 c4 10             	add    $0x10,%esp
  8004e6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004e9:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004eb:	83 c7 01             	add    $0x1,%edi
  8004ee:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004f2:	0f be d0             	movsbl %al,%edx
  8004f5:	85 d2                	test   %edx,%edx
  8004f7:	74 4b                	je     800544 <vprintfmt+0x245>
  8004f9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004fd:	78 06                	js     800505 <vprintfmt+0x206>
  8004ff:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800503:	78 1e                	js     800523 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800505:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800509:	74 d1                	je     8004dc <vprintfmt+0x1dd>
  80050b:	0f be c0             	movsbl %al,%eax
  80050e:	83 e8 20             	sub    $0x20,%eax
  800511:	83 f8 5e             	cmp    $0x5e,%eax
  800514:	76 c6                	jbe    8004dc <vprintfmt+0x1dd>
					putch('?', putdat);
  800516:	83 ec 08             	sub    $0x8,%esp
  800519:	53                   	push   %ebx
  80051a:	6a 3f                	push   $0x3f
  80051c:	ff d6                	call   *%esi
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	eb c3                	jmp    8004e6 <vprintfmt+0x1e7>
  800523:	89 cf                	mov    %ecx,%edi
  800525:	eb 0e                	jmp    800535 <vprintfmt+0x236>
				putch(' ', putdat);
  800527:	83 ec 08             	sub    $0x8,%esp
  80052a:	53                   	push   %ebx
  80052b:	6a 20                	push   $0x20
  80052d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80052f:	83 ef 01             	sub    $0x1,%edi
  800532:	83 c4 10             	add    $0x10,%esp
  800535:	85 ff                	test   %edi,%edi
  800537:	7f ee                	jg     800527 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800539:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80053c:	89 45 14             	mov    %eax,0x14(%ebp)
  80053f:	e9 01 02 00 00       	jmp    800745 <vprintfmt+0x446>
  800544:	89 cf                	mov    %ecx,%edi
  800546:	eb ed                	jmp    800535 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800548:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80054b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800552:	e9 eb fd ff ff       	jmp    800342 <vprintfmt+0x43>
	if (lflag >= 2)
  800557:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80055b:	7f 21                	jg     80057e <vprintfmt+0x27f>
	else if (lflag)
  80055d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800561:	74 68                	je     8005cb <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800563:	8b 45 14             	mov    0x14(%ebp),%eax
  800566:	8b 00                	mov    (%eax),%eax
  800568:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80056b:	89 c1                	mov    %eax,%ecx
  80056d:	c1 f9 1f             	sar    $0x1f,%ecx
  800570:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	8d 40 04             	lea    0x4(%eax),%eax
  800579:	89 45 14             	mov    %eax,0x14(%ebp)
  80057c:	eb 17                	jmp    800595 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	8b 50 04             	mov    0x4(%eax),%edx
  800584:	8b 00                	mov    (%eax),%eax
  800586:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800589:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8d 40 08             	lea    0x8(%eax),%eax
  800592:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800595:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800598:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80059b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005a1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005a5:	78 3f                	js     8005e6 <vprintfmt+0x2e7>
			base = 10;
  8005a7:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005ac:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005b0:	0f 84 71 01 00 00    	je     800727 <vprintfmt+0x428>
				putch('+', putdat);
  8005b6:	83 ec 08             	sub    $0x8,%esp
  8005b9:	53                   	push   %ebx
  8005ba:	6a 2b                	push   $0x2b
  8005bc:	ff d6                	call   *%esi
  8005be:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c6:	e9 5c 01 00 00       	jmp    800727 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	8b 00                	mov    (%eax),%eax
  8005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005d3:	89 c1                	mov    %eax,%ecx
  8005d5:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	8d 40 04             	lea    0x4(%eax),%eax
  8005e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e4:	eb af                	jmp    800595 <vprintfmt+0x296>
				putch('-', putdat);
  8005e6:	83 ec 08             	sub    $0x8,%esp
  8005e9:	53                   	push   %ebx
  8005ea:	6a 2d                	push   $0x2d
  8005ec:	ff d6                	call   *%esi
				num = -(long long) num;
  8005ee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005f1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005f4:	f7 d8                	neg    %eax
  8005f6:	83 d2 00             	adc    $0x0,%edx
  8005f9:	f7 da                	neg    %edx
  8005fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800601:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800604:	b8 0a 00 00 00       	mov    $0xa,%eax
  800609:	e9 19 01 00 00       	jmp    800727 <vprintfmt+0x428>
	if (lflag >= 2)
  80060e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800612:	7f 29                	jg     80063d <vprintfmt+0x33e>
	else if (lflag)
  800614:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800618:	74 44                	je     80065e <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	ba 00 00 00 00       	mov    $0x0,%edx
  800624:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800627:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8d 40 04             	lea    0x4(%eax),%eax
  800630:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800633:	b8 0a 00 00 00       	mov    $0xa,%eax
  800638:	e9 ea 00 00 00       	jmp    800727 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	8b 50 04             	mov    0x4(%eax),%edx
  800643:	8b 00                	mov    (%eax),%eax
  800645:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800648:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8d 40 08             	lea    0x8(%eax),%eax
  800651:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800654:	b8 0a 00 00 00       	mov    $0xa,%eax
  800659:	e9 c9 00 00 00       	jmp    800727 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	ba 00 00 00 00       	mov    $0x0,%edx
  800668:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8d 40 04             	lea    0x4(%eax),%eax
  800674:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800677:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067c:	e9 a6 00 00 00       	jmp    800727 <vprintfmt+0x428>
			putch('0', putdat);
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	53                   	push   %ebx
  800685:	6a 30                	push   $0x30
  800687:	ff d6                	call   *%esi
	if (lflag >= 2)
  800689:	83 c4 10             	add    $0x10,%esp
  80068c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800690:	7f 26                	jg     8006b8 <vprintfmt+0x3b9>
	else if (lflag)
  800692:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800696:	74 3e                	je     8006d6 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8d 40 04             	lea    0x4(%eax),%eax
  8006ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b1:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b6:	eb 6f                	jmp    800727 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8b 50 04             	mov    0x4(%eax),%edx
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	8d 40 08             	lea    0x8(%eax),%eax
  8006cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006cf:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d4:	eb 51                	jmp    800727 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	8d 40 04             	lea    0x4(%eax),%eax
  8006ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ef:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f4:	eb 31                	jmp    800727 <vprintfmt+0x428>
			putch('0', putdat);
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	53                   	push   %ebx
  8006fa:	6a 30                	push   $0x30
  8006fc:	ff d6                	call   *%esi
			putch('x', putdat);
  8006fe:	83 c4 08             	add    $0x8,%esp
  800701:	53                   	push   %ebx
  800702:	6a 78                	push   $0x78
  800704:	ff d6                	call   *%esi
			num = (unsigned long long)
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	ba 00 00 00 00       	mov    $0x0,%edx
  800710:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800713:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800716:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	8d 40 04             	lea    0x4(%eax),%eax
  80071f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800722:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80072e:	52                   	push   %edx
  80072f:	ff 75 e0             	pushl  -0x20(%ebp)
  800732:	50                   	push   %eax
  800733:	ff 75 dc             	pushl  -0x24(%ebp)
  800736:	ff 75 d8             	pushl  -0x28(%ebp)
  800739:	89 da                	mov    %ebx,%edx
  80073b:	89 f0                	mov    %esi,%eax
  80073d:	e8 a4 fa ff ff       	call   8001e6 <printnum>
			break;
  800742:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800745:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800748:	83 c7 01             	add    $0x1,%edi
  80074b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80074f:	83 f8 25             	cmp    $0x25,%eax
  800752:	0f 84 be fb ff ff    	je     800316 <vprintfmt+0x17>
			if (ch == '\0')
  800758:	85 c0                	test   %eax,%eax
  80075a:	0f 84 28 01 00 00    	je     800888 <vprintfmt+0x589>
			putch(ch, putdat);
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	53                   	push   %ebx
  800764:	50                   	push   %eax
  800765:	ff d6                	call   *%esi
  800767:	83 c4 10             	add    $0x10,%esp
  80076a:	eb dc                	jmp    800748 <vprintfmt+0x449>
	if (lflag >= 2)
  80076c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800770:	7f 26                	jg     800798 <vprintfmt+0x499>
	else if (lflag)
  800772:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800776:	74 41                	je     8007b9 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	ba 00 00 00 00       	mov    $0x0,%edx
  800782:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800785:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8d 40 04             	lea    0x4(%eax),%eax
  80078e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800791:	b8 10 00 00 00       	mov    $0x10,%eax
  800796:	eb 8f                	jmp    800727 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8b 50 04             	mov    0x4(%eax),%edx
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a9:	8d 40 08             	lea    0x8(%eax),%eax
  8007ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007af:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b4:	e9 6e ff ff ff       	jmp    800727 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8d 40 04             	lea    0x4(%eax),%eax
  8007cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d2:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d7:	e9 4b ff ff ff       	jmp    800727 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	83 c0 04             	add    $0x4,%eax
  8007e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	85 c0                	test   %eax,%eax
  8007ec:	74 14                	je     800802 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007ee:	8b 13                	mov    (%ebx),%edx
  8007f0:	83 fa 7f             	cmp    $0x7f,%edx
  8007f3:	7f 37                	jg     80082c <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007f5:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fd:	e9 43 ff ff ff       	jmp    800745 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800802:	b8 0a 00 00 00       	mov    $0xa,%eax
  800807:	bf 59 2c 80 00       	mov    $0x802c59,%edi
							putch(ch, putdat);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	53                   	push   %ebx
  800810:	50                   	push   %eax
  800811:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800813:	83 c7 01             	add    $0x1,%edi
  800816:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80081a:	83 c4 10             	add    $0x10,%esp
  80081d:	85 c0                	test   %eax,%eax
  80081f:	75 eb                	jne    80080c <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800821:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
  800827:	e9 19 ff ff ff       	jmp    800745 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80082c:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80082e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800833:	bf 91 2c 80 00       	mov    $0x802c91,%edi
							putch(ch, putdat);
  800838:	83 ec 08             	sub    $0x8,%esp
  80083b:	53                   	push   %ebx
  80083c:	50                   	push   %eax
  80083d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80083f:	83 c7 01             	add    $0x1,%edi
  800842:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800846:	83 c4 10             	add    $0x10,%esp
  800849:	85 c0                	test   %eax,%eax
  80084b:	75 eb                	jne    800838 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80084d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800850:	89 45 14             	mov    %eax,0x14(%ebp)
  800853:	e9 ed fe ff ff       	jmp    800745 <vprintfmt+0x446>
			putch(ch, putdat);
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	53                   	push   %ebx
  80085c:	6a 25                	push   $0x25
  80085e:	ff d6                	call   *%esi
			break;
  800860:	83 c4 10             	add    $0x10,%esp
  800863:	e9 dd fe ff ff       	jmp    800745 <vprintfmt+0x446>
			putch('%', putdat);
  800868:	83 ec 08             	sub    $0x8,%esp
  80086b:	53                   	push   %ebx
  80086c:	6a 25                	push   $0x25
  80086e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800870:	83 c4 10             	add    $0x10,%esp
  800873:	89 f8                	mov    %edi,%eax
  800875:	eb 03                	jmp    80087a <vprintfmt+0x57b>
  800877:	83 e8 01             	sub    $0x1,%eax
  80087a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80087e:	75 f7                	jne    800877 <vprintfmt+0x578>
  800880:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800883:	e9 bd fe ff ff       	jmp    800745 <vprintfmt+0x446>
}
  800888:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80088b:	5b                   	pop    %ebx
  80088c:	5e                   	pop    %esi
  80088d:	5f                   	pop    %edi
  80088e:	5d                   	pop    %ebp
  80088f:	c3                   	ret    

00800890 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	83 ec 18             	sub    $0x18,%esp
  800896:	8b 45 08             	mov    0x8(%ebp),%eax
  800899:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80089c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80089f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008a3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ad:	85 c0                	test   %eax,%eax
  8008af:	74 26                	je     8008d7 <vsnprintf+0x47>
  8008b1:	85 d2                	test   %edx,%edx
  8008b3:	7e 22                	jle    8008d7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008b5:	ff 75 14             	pushl  0x14(%ebp)
  8008b8:	ff 75 10             	pushl  0x10(%ebp)
  8008bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008be:	50                   	push   %eax
  8008bf:	68 c5 02 80 00       	push   $0x8002c5
  8008c4:	e8 36 fa ff ff       	call   8002ff <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008cc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d2:	83 c4 10             	add    $0x10,%esp
}
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    
		return -E_INVAL;
  8008d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008dc:	eb f7                	jmp    8008d5 <vsnprintf+0x45>

008008de <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e7:	50                   	push   %eax
  8008e8:	ff 75 10             	pushl  0x10(%ebp)
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	ff 75 08             	pushl  0x8(%ebp)
  8008f1:	e8 9a ff ff ff       	call   800890 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f6:	c9                   	leave  
  8008f7:	c3                   	ret    

008008f8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800903:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800907:	74 05                	je     80090e <strlen+0x16>
		n++;
  800909:	83 c0 01             	add    $0x1,%eax
  80090c:	eb f5                	jmp    800903 <strlen+0xb>
	return n;
}
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    

00800910 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800916:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800919:	ba 00 00 00 00       	mov    $0x0,%edx
  80091e:	39 c2                	cmp    %eax,%edx
  800920:	74 0d                	je     80092f <strnlen+0x1f>
  800922:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800926:	74 05                	je     80092d <strnlen+0x1d>
		n++;
  800928:	83 c2 01             	add    $0x1,%edx
  80092b:	eb f1                	jmp    80091e <strnlen+0xe>
  80092d:	89 d0                	mov    %edx,%eax
	return n;
}
  80092f:	5d                   	pop    %ebp
  800930:	c3                   	ret    

00800931 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	53                   	push   %ebx
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80093b:	ba 00 00 00 00       	mov    $0x0,%edx
  800940:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800944:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800947:	83 c2 01             	add    $0x1,%edx
  80094a:	84 c9                	test   %cl,%cl
  80094c:	75 f2                	jne    800940 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80094e:	5b                   	pop    %ebx
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	53                   	push   %ebx
  800955:	83 ec 10             	sub    $0x10,%esp
  800958:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80095b:	53                   	push   %ebx
  80095c:	e8 97 ff ff ff       	call   8008f8 <strlen>
  800961:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	01 d8                	add    %ebx,%eax
  800969:	50                   	push   %eax
  80096a:	e8 c2 ff ff ff       	call   800931 <strcpy>
	return dst;
}
  80096f:	89 d8                	mov    %ebx,%eax
  800971:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800974:	c9                   	leave  
  800975:	c3                   	ret    

00800976 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	56                   	push   %esi
  80097a:	53                   	push   %ebx
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800981:	89 c6                	mov    %eax,%esi
  800983:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800986:	89 c2                	mov    %eax,%edx
  800988:	39 f2                	cmp    %esi,%edx
  80098a:	74 11                	je     80099d <strncpy+0x27>
		*dst++ = *src;
  80098c:	83 c2 01             	add    $0x1,%edx
  80098f:	0f b6 19             	movzbl (%ecx),%ebx
  800992:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800995:	80 fb 01             	cmp    $0x1,%bl
  800998:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80099b:	eb eb                	jmp    800988 <strncpy+0x12>
	}
	return ret;
}
  80099d:	5b                   	pop    %ebx
  80099e:	5e                   	pop    %esi
  80099f:	5d                   	pop    %ebp
  8009a0:	c3                   	ret    

008009a1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	56                   	push   %esi
  8009a5:	53                   	push   %ebx
  8009a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ac:	8b 55 10             	mov    0x10(%ebp),%edx
  8009af:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009b1:	85 d2                	test   %edx,%edx
  8009b3:	74 21                	je     8009d6 <strlcpy+0x35>
  8009b5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009b9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009bb:	39 c2                	cmp    %eax,%edx
  8009bd:	74 14                	je     8009d3 <strlcpy+0x32>
  8009bf:	0f b6 19             	movzbl (%ecx),%ebx
  8009c2:	84 db                	test   %bl,%bl
  8009c4:	74 0b                	je     8009d1 <strlcpy+0x30>
			*dst++ = *src++;
  8009c6:	83 c1 01             	add    $0x1,%ecx
  8009c9:	83 c2 01             	add    $0x1,%edx
  8009cc:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009cf:	eb ea                	jmp    8009bb <strlcpy+0x1a>
  8009d1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009d3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009d6:	29 f0                	sub    %esi,%eax
}
  8009d8:	5b                   	pop    %ebx
  8009d9:	5e                   	pop    %esi
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    

008009dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009e5:	0f b6 01             	movzbl (%ecx),%eax
  8009e8:	84 c0                	test   %al,%al
  8009ea:	74 0c                	je     8009f8 <strcmp+0x1c>
  8009ec:	3a 02                	cmp    (%edx),%al
  8009ee:	75 08                	jne    8009f8 <strcmp+0x1c>
		p++, q++;
  8009f0:	83 c1 01             	add    $0x1,%ecx
  8009f3:	83 c2 01             	add    $0x1,%edx
  8009f6:	eb ed                	jmp    8009e5 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f8:	0f b6 c0             	movzbl %al,%eax
  8009fb:	0f b6 12             	movzbl (%edx),%edx
  8009fe:	29 d0                	sub    %edx,%eax
}
  800a00:	5d                   	pop    %ebp
  800a01:	c3                   	ret    

00800a02 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	53                   	push   %ebx
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0c:	89 c3                	mov    %eax,%ebx
  800a0e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a11:	eb 06                	jmp    800a19 <strncmp+0x17>
		n--, p++, q++;
  800a13:	83 c0 01             	add    $0x1,%eax
  800a16:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a19:	39 d8                	cmp    %ebx,%eax
  800a1b:	74 16                	je     800a33 <strncmp+0x31>
  800a1d:	0f b6 08             	movzbl (%eax),%ecx
  800a20:	84 c9                	test   %cl,%cl
  800a22:	74 04                	je     800a28 <strncmp+0x26>
  800a24:	3a 0a                	cmp    (%edx),%cl
  800a26:	74 eb                	je     800a13 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a28:	0f b6 00             	movzbl (%eax),%eax
  800a2b:	0f b6 12             	movzbl (%edx),%edx
  800a2e:	29 d0                	sub    %edx,%eax
}
  800a30:	5b                   	pop    %ebx
  800a31:	5d                   	pop    %ebp
  800a32:	c3                   	ret    
		return 0;
  800a33:	b8 00 00 00 00       	mov    $0x0,%eax
  800a38:	eb f6                	jmp    800a30 <strncmp+0x2e>

00800a3a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a44:	0f b6 10             	movzbl (%eax),%edx
  800a47:	84 d2                	test   %dl,%dl
  800a49:	74 09                	je     800a54 <strchr+0x1a>
		if (*s == c)
  800a4b:	38 ca                	cmp    %cl,%dl
  800a4d:	74 0a                	je     800a59 <strchr+0x1f>
	for (; *s; s++)
  800a4f:	83 c0 01             	add    $0x1,%eax
  800a52:	eb f0                	jmp    800a44 <strchr+0xa>
			return (char *) s;
	return 0;
  800a54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a65:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a68:	38 ca                	cmp    %cl,%dl
  800a6a:	74 09                	je     800a75 <strfind+0x1a>
  800a6c:	84 d2                	test   %dl,%dl
  800a6e:	74 05                	je     800a75 <strfind+0x1a>
	for (; *s; s++)
  800a70:	83 c0 01             	add    $0x1,%eax
  800a73:	eb f0                	jmp    800a65 <strfind+0xa>
			break;
	return (char *) s;
}
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	57                   	push   %edi
  800a7b:	56                   	push   %esi
  800a7c:	53                   	push   %ebx
  800a7d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a80:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a83:	85 c9                	test   %ecx,%ecx
  800a85:	74 31                	je     800ab8 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a87:	89 f8                	mov    %edi,%eax
  800a89:	09 c8                	or     %ecx,%eax
  800a8b:	a8 03                	test   $0x3,%al
  800a8d:	75 23                	jne    800ab2 <memset+0x3b>
		c &= 0xFF;
  800a8f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a93:	89 d3                	mov    %edx,%ebx
  800a95:	c1 e3 08             	shl    $0x8,%ebx
  800a98:	89 d0                	mov    %edx,%eax
  800a9a:	c1 e0 18             	shl    $0x18,%eax
  800a9d:	89 d6                	mov    %edx,%esi
  800a9f:	c1 e6 10             	shl    $0x10,%esi
  800aa2:	09 f0                	or     %esi,%eax
  800aa4:	09 c2                	or     %eax,%edx
  800aa6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aa8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aab:	89 d0                	mov    %edx,%eax
  800aad:	fc                   	cld    
  800aae:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab0:	eb 06                	jmp    800ab8 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab5:	fc                   	cld    
  800ab6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ab8:	89 f8                	mov    %edi,%eax
  800aba:	5b                   	pop    %ebx
  800abb:	5e                   	pop    %esi
  800abc:	5f                   	pop    %edi
  800abd:	5d                   	pop    %ebp
  800abe:	c3                   	ret    

00800abf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	57                   	push   %edi
  800ac3:	56                   	push   %esi
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aca:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800acd:	39 c6                	cmp    %eax,%esi
  800acf:	73 32                	jae    800b03 <memmove+0x44>
  800ad1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ad4:	39 c2                	cmp    %eax,%edx
  800ad6:	76 2b                	jbe    800b03 <memmove+0x44>
		s += n;
		d += n;
  800ad8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800adb:	89 fe                	mov    %edi,%esi
  800add:	09 ce                	or     %ecx,%esi
  800adf:	09 d6                	or     %edx,%esi
  800ae1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ae7:	75 0e                	jne    800af7 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ae9:	83 ef 04             	sub    $0x4,%edi
  800aec:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aef:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800af2:	fd                   	std    
  800af3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af5:	eb 09                	jmp    800b00 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800af7:	83 ef 01             	sub    $0x1,%edi
  800afa:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800afd:	fd                   	std    
  800afe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b00:	fc                   	cld    
  800b01:	eb 1a                	jmp    800b1d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b03:	89 c2                	mov    %eax,%edx
  800b05:	09 ca                	or     %ecx,%edx
  800b07:	09 f2                	or     %esi,%edx
  800b09:	f6 c2 03             	test   $0x3,%dl
  800b0c:	75 0a                	jne    800b18 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b0e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b11:	89 c7                	mov    %eax,%edi
  800b13:	fc                   	cld    
  800b14:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b16:	eb 05                	jmp    800b1d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b18:	89 c7                	mov    %eax,%edi
  800b1a:	fc                   	cld    
  800b1b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b1d:	5e                   	pop    %esi
  800b1e:	5f                   	pop    %edi
  800b1f:	5d                   	pop    %ebp
  800b20:	c3                   	ret    

00800b21 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b27:	ff 75 10             	pushl  0x10(%ebp)
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	ff 75 08             	pushl  0x8(%ebp)
  800b30:	e8 8a ff ff ff       	call   800abf <memmove>
}
  800b35:	c9                   	leave  
  800b36:	c3                   	ret    

00800b37 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	56                   	push   %esi
  800b3b:	53                   	push   %ebx
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b42:	89 c6                	mov    %eax,%esi
  800b44:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b47:	39 f0                	cmp    %esi,%eax
  800b49:	74 1c                	je     800b67 <memcmp+0x30>
		if (*s1 != *s2)
  800b4b:	0f b6 08             	movzbl (%eax),%ecx
  800b4e:	0f b6 1a             	movzbl (%edx),%ebx
  800b51:	38 d9                	cmp    %bl,%cl
  800b53:	75 08                	jne    800b5d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b55:	83 c0 01             	add    $0x1,%eax
  800b58:	83 c2 01             	add    $0x1,%edx
  800b5b:	eb ea                	jmp    800b47 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b5d:	0f b6 c1             	movzbl %cl,%eax
  800b60:	0f b6 db             	movzbl %bl,%ebx
  800b63:	29 d8                	sub    %ebx,%eax
  800b65:	eb 05                	jmp    800b6c <memcmp+0x35>
	}

	return 0;
  800b67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6c:	5b                   	pop    %ebx
  800b6d:	5e                   	pop    %esi
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b79:	89 c2                	mov    %eax,%edx
  800b7b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b7e:	39 d0                	cmp    %edx,%eax
  800b80:	73 09                	jae    800b8b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b82:	38 08                	cmp    %cl,(%eax)
  800b84:	74 05                	je     800b8b <memfind+0x1b>
	for (; s < ends; s++)
  800b86:	83 c0 01             	add    $0x1,%eax
  800b89:	eb f3                	jmp    800b7e <memfind+0xe>
			break;
	return (void *) s;
}
  800b8b:	5d                   	pop    %ebp
  800b8c:	c3                   	ret    

00800b8d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	57                   	push   %edi
  800b91:	56                   	push   %esi
  800b92:	53                   	push   %ebx
  800b93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b99:	eb 03                	jmp    800b9e <strtol+0x11>
		s++;
  800b9b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b9e:	0f b6 01             	movzbl (%ecx),%eax
  800ba1:	3c 20                	cmp    $0x20,%al
  800ba3:	74 f6                	je     800b9b <strtol+0xe>
  800ba5:	3c 09                	cmp    $0x9,%al
  800ba7:	74 f2                	je     800b9b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ba9:	3c 2b                	cmp    $0x2b,%al
  800bab:	74 2a                	je     800bd7 <strtol+0x4a>
	int neg = 0;
  800bad:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bb2:	3c 2d                	cmp    $0x2d,%al
  800bb4:	74 2b                	je     800be1 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bbc:	75 0f                	jne    800bcd <strtol+0x40>
  800bbe:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc1:	74 28                	je     800beb <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc3:	85 db                	test   %ebx,%ebx
  800bc5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bca:	0f 44 d8             	cmove  %eax,%ebx
  800bcd:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bd5:	eb 50                	jmp    800c27 <strtol+0x9a>
		s++;
  800bd7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bda:	bf 00 00 00 00       	mov    $0x0,%edi
  800bdf:	eb d5                	jmp    800bb6 <strtol+0x29>
		s++, neg = 1;
  800be1:	83 c1 01             	add    $0x1,%ecx
  800be4:	bf 01 00 00 00       	mov    $0x1,%edi
  800be9:	eb cb                	jmp    800bb6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800beb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bef:	74 0e                	je     800bff <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bf1:	85 db                	test   %ebx,%ebx
  800bf3:	75 d8                	jne    800bcd <strtol+0x40>
		s++, base = 8;
  800bf5:	83 c1 01             	add    $0x1,%ecx
  800bf8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bfd:	eb ce                	jmp    800bcd <strtol+0x40>
		s += 2, base = 16;
  800bff:	83 c1 02             	add    $0x2,%ecx
  800c02:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c07:	eb c4                	jmp    800bcd <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c09:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c0c:	89 f3                	mov    %esi,%ebx
  800c0e:	80 fb 19             	cmp    $0x19,%bl
  800c11:	77 29                	ja     800c3c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c13:	0f be d2             	movsbl %dl,%edx
  800c16:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c19:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c1c:	7d 30                	jge    800c4e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c1e:	83 c1 01             	add    $0x1,%ecx
  800c21:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c25:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c27:	0f b6 11             	movzbl (%ecx),%edx
  800c2a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c2d:	89 f3                	mov    %esi,%ebx
  800c2f:	80 fb 09             	cmp    $0x9,%bl
  800c32:	77 d5                	ja     800c09 <strtol+0x7c>
			dig = *s - '0';
  800c34:	0f be d2             	movsbl %dl,%edx
  800c37:	83 ea 30             	sub    $0x30,%edx
  800c3a:	eb dd                	jmp    800c19 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c3c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c3f:	89 f3                	mov    %esi,%ebx
  800c41:	80 fb 19             	cmp    $0x19,%bl
  800c44:	77 08                	ja     800c4e <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c46:	0f be d2             	movsbl %dl,%edx
  800c49:	83 ea 37             	sub    $0x37,%edx
  800c4c:	eb cb                	jmp    800c19 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c52:	74 05                	je     800c59 <strtol+0xcc>
		*endptr = (char *) s;
  800c54:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c57:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c59:	89 c2                	mov    %eax,%edx
  800c5b:	f7 da                	neg    %edx
  800c5d:	85 ff                	test   %edi,%edi
  800c5f:	0f 45 c2             	cmovne %edx,%eax
}
  800c62:	5b                   	pop    %ebx
  800c63:	5e                   	pop    %esi
  800c64:	5f                   	pop    %edi
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	57                   	push   %edi
  800c6b:	56                   	push   %esi
  800c6c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c72:	8b 55 08             	mov    0x8(%ebp),%edx
  800c75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c78:	89 c3                	mov    %eax,%ebx
  800c7a:	89 c7                	mov    %eax,%edi
  800c7c:	89 c6                	mov    %eax,%esi
  800c7e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c80:	5b                   	pop    %ebx
  800c81:	5e                   	pop    %esi
  800c82:	5f                   	pop    %edi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c90:	b8 01 00 00 00       	mov    $0x1,%eax
  800c95:	89 d1                	mov    %edx,%ecx
  800c97:	89 d3                	mov    %edx,%ebx
  800c99:	89 d7                	mov    %edx,%edi
  800c9b:	89 d6                	mov    %edx,%esi
  800c9d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c9f:	5b                   	pop    %ebx
  800ca0:	5e                   	pop    %esi
  800ca1:	5f                   	pop    %edi
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	57                   	push   %edi
  800ca8:	56                   	push   %esi
  800ca9:	53                   	push   %ebx
  800caa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cad:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cba:	89 cb                	mov    %ecx,%ebx
  800cbc:	89 cf                	mov    %ecx,%edi
  800cbe:	89 ce                	mov    %ecx,%esi
  800cc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc2:	85 c0                	test   %eax,%eax
  800cc4:	7f 08                	jg     800cce <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc9:	5b                   	pop    %ebx
  800cca:	5e                   	pop    %esi
  800ccb:	5f                   	pop    %edi
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cce:	83 ec 0c             	sub    $0xc,%esp
  800cd1:	50                   	push   %eax
  800cd2:	6a 03                	push   $0x3
  800cd4:	68 a8 2e 80 00       	push   $0x802ea8
  800cd9:	6a 43                	push   $0x43
  800cdb:	68 c5 2e 80 00       	push   $0x802ec5
  800ce0:	e8 76 1a 00 00       	call   80275b <_panic>

00800ce5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	57                   	push   %edi
  800ce9:	56                   	push   %esi
  800cea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ceb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf0:	b8 02 00 00 00       	mov    $0x2,%eax
  800cf5:	89 d1                	mov    %edx,%ecx
  800cf7:	89 d3                	mov    %edx,%ebx
  800cf9:	89 d7                	mov    %edx,%edi
  800cfb:	89 d6                	mov    %edx,%esi
  800cfd:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cff:	5b                   	pop    %ebx
  800d00:	5e                   	pop    %esi
  800d01:	5f                   	pop    %edi
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    

00800d04 <sys_yield>:

void
sys_yield(void)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	57                   	push   %edi
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d14:	89 d1                	mov    %edx,%ecx
  800d16:	89 d3                	mov    %edx,%ebx
  800d18:	89 d7                	mov    %edx,%edi
  800d1a:	89 d6                	mov    %edx,%esi
  800d1c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d1e:	5b                   	pop    %ebx
  800d1f:	5e                   	pop    %esi
  800d20:	5f                   	pop    %edi
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	57                   	push   %edi
  800d27:	56                   	push   %esi
  800d28:	53                   	push   %ebx
  800d29:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2c:	be 00 00 00 00       	mov    $0x0,%esi
  800d31:	8b 55 08             	mov    0x8(%ebp),%edx
  800d34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d37:	b8 04 00 00 00       	mov    $0x4,%eax
  800d3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d3f:	89 f7                	mov    %esi,%edi
  800d41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d43:	85 c0                	test   %eax,%eax
  800d45:	7f 08                	jg     800d4f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4a:	5b                   	pop    %ebx
  800d4b:	5e                   	pop    %esi
  800d4c:	5f                   	pop    %edi
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4f:	83 ec 0c             	sub    $0xc,%esp
  800d52:	50                   	push   %eax
  800d53:	6a 04                	push   $0x4
  800d55:	68 a8 2e 80 00       	push   $0x802ea8
  800d5a:	6a 43                	push   $0x43
  800d5c:	68 c5 2e 80 00       	push   $0x802ec5
  800d61:	e8 f5 19 00 00       	call   80275b <_panic>

00800d66 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	57                   	push   %edi
  800d6a:	56                   	push   %esi
  800d6b:	53                   	push   %ebx
  800d6c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d75:	b8 05 00 00 00       	mov    $0x5,%eax
  800d7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d7d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d80:	8b 75 18             	mov    0x18(%ebp),%esi
  800d83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d85:	85 c0                	test   %eax,%eax
  800d87:	7f 08                	jg     800d91 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8c:	5b                   	pop    %ebx
  800d8d:	5e                   	pop    %esi
  800d8e:	5f                   	pop    %edi
  800d8f:	5d                   	pop    %ebp
  800d90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d91:	83 ec 0c             	sub    $0xc,%esp
  800d94:	50                   	push   %eax
  800d95:	6a 05                	push   $0x5
  800d97:	68 a8 2e 80 00       	push   $0x802ea8
  800d9c:	6a 43                	push   $0x43
  800d9e:	68 c5 2e 80 00       	push   $0x802ec5
  800da3:	e8 b3 19 00 00       	call   80275b <_panic>

00800da8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	57                   	push   %edi
  800dac:	56                   	push   %esi
  800dad:	53                   	push   %ebx
  800dae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db6:	8b 55 08             	mov    0x8(%ebp),%edx
  800db9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbc:	b8 06 00 00 00       	mov    $0x6,%eax
  800dc1:	89 df                	mov    %ebx,%edi
  800dc3:	89 de                	mov    %ebx,%esi
  800dc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc7:	85 c0                	test   %eax,%eax
  800dc9:	7f 08                	jg     800dd3 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dce:	5b                   	pop    %ebx
  800dcf:	5e                   	pop    %esi
  800dd0:	5f                   	pop    %edi
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd3:	83 ec 0c             	sub    $0xc,%esp
  800dd6:	50                   	push   %eax
  800dd7:	6a 06                	push   $0x6
  800dd9:	68 a8 2e 80 00       	push   $0x802ea8
  800dde:	6a 43                	push   $0x43
  800de0:	68 c5 2e 80 00       	push   $0x802ec5
  800de5:	e8 71 19 00 00       	call   80275b <_panic>

00800dea <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	57                   	push   %edi
  800dee:	56                   	push   %esi
  800def:	53                   	push   %ebx
  800df0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfe:	b8 08 00 00 00       	mov    $0x8,%eax
  800e03:	89 df                	mov    %ebx,%edi
  800e05:	89 de                	mov    %ebx,%esi
  800e07:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e09:	85 c0                	test   %eax,%eax
  800e0b:	7f 08                	jg     800e15 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e10:	5b                   	pop    %ebx
  800e11:	5e                   	pop    %esi
  800e12:	5f                   	pop    %edi
  800e13:	5d                   	pop    %ebp
  800e14:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e15:	83 ec 0c             	sub    $0xc,%esp
  800e18:	50                   	push   %eax
  800e19:	6a 08                	push   $0x8
  800e1b:	68 a8 2e 80 00       	push   $0x802ea8
  800e20:	6a 43                	push   $0x43
  800e22:	68 c5 2e 80 00       	push   $0x802ec5
  800e27:	e8 2f 19 00 00       	call   80275b <_panic>

00800e2c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	57                   	push   %edi
  800e30:	56                   	push   %esi
  800e31:	53                   	push   %ebx
  800e32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e35:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e40:	b8 09 00 00 00       	mov    $0x9,%eax
  800e45:	89 df                	mov    %ebx,%edi
  800e47:	89 de                	mov    %ebx,%esi
  800e49:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4b:	85 c0                	test   %eax,%eax
  800e4d:	7f 08                	jg     800e57 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e52:	5b                   	pop    %ebx
  800e53:	5e                   	pop    %esi
  800e54:	5f                   	pop    %edi
  800e55:	5d                   	pop    %ebp
  800e56:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e57:	83 ec 0c             	sub    $0xc,%esp
  800e5a:	50                   	push   %eax
  800e5b:	6a 09                	push   $0x9
  800e5d:	68 a8 2e 80 00       	push   $0x802ea8
  800e62:	6a 43                	push   $0x43
  800e64:	68 c5 2e 80 00       	push   $0x802ec5
  800e69:	e8 ed 18 00 00       	call   80275b <_panic>

00800e6e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	57                   	push   %edi
  800e72:	56                   	push   %esi
  800e73:	53                   	push   %ebx
  800e74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e77:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e82:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e87:	89 df                	mov    %ebx,%edi
  800e89:	89 de                	mov    %ebx,%esi
  800e8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8d:	85 c0                	test   %eax,%eax
  800e8f:	7f 08                	jg     800e99 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e99:	83 ec 0c             	sub    $0xc,%esp
  800e9c:	50                   	push   %eax
  800e9d:	6a 0a                	push   $0xa
  800e9f:	68 a8 2e 80 00       	push   $0x802ea8
  800ea4:	6a 43                	push   $0x43
  800ea6:	68 c5 2e 80 00       	push   $0x802ec5
  800eab:	e8 ab 18 00 00       	call   80275b <_panic>

00800eb0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	57                   	push   %edi
  800eb4:	56                   	push   %esi
  800eb5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebc:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ec1:	be 00 00 00 00       	mov    $0x0,%esi
  800ec6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ecc:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
  800ed9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ee9:	89 cb                	mov    %ecx,%ebx
  800eeb:	89 cf                	mov    %ecx,%edi
  800eed:	89 ce                	mov    %ecx,%esi
  800eef:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	7f 08                	jg     800efd <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efd:	83 ec 0c             	sub    $0xc,%esp
  800f00:	50                   	push   %eax
  800f01:	6a 0d                	push   $0xd
  800f03:	68 a8 2e 80 00       	push   $0x802ea8
  800f08:	6a 43                	push   $0x43
  800f0a:	68 c5 2e 80 00       	push   $0x802ec5
  800f0f:	e8 47 18 00 00       	call   80275b <_panic>

00800f14 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	57                   	push   %edi
  800f18:	56                   	push   %esi
  800f19:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f25:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f2a:	89 df                	mov    %ebx,%edi
  800f2c:	89 de                	mov    %ebx,%esi
  800f2e:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f30:	5b                   	pop    %ebx
  800f31:	5e                   	pop    %esi
  800f32:	5f                   	pop    %edi
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	57                   	push   %edi
  800f39:	56                   	push   %esi
  800f3a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f40:	8b 55 08             	mov    0x8(%ebp),%edx
  800f43:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f48:	89 cb                	mov    %ecx,%ebx
  800f4a:	89 cf                	mov    %ecx,%edi
  800f4c:	89 ce                	mov    %ecx,%esi
  800f4e:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f50:	5b                   	pop    %ebx
  800f51:	5e                   	pop    %esi
  800f52:	5f                   	pop    %edi
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    

00800f55 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	57                   	push   %edi
  800f59:	56                   	push   %esi
  800f5a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f60:	b8 10 00 00 00       	mov    $0x10,%eax
  800f65:	89 d1                	mov    %edx,%ecx
  800f67:	89 d3                	mov    %edx,%ebx
  800f69:	89 d7                	mov    %edx,%edi
  800f6b:	89 d6                	mov    %edx,%esi
  800f6d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f6f:	5b                   	pop    %ebx
  800f70:	5e                   	pop    %esi
  800f71:	5f                   	pop    %edi
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	57                   	push   %edi
  800f78:	56                   	push   %esi
  800f79:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f85:	b8 11 00 00 00       	mov    $0x11,%eax
  800f8a:	89 df                	mov    %ebx,%edi
  800f8c:	89 de                	mov    %ebx,%esi
  800f8e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f90:	5b                   	pop    %ebx
  800f91:	5e                   	pop    %esi
  800f92:	5f                   	pop    %edi
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    

00800f95 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	57                   	push   %edi
  800f99:	56                   	push   %esi
  800f9a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa6:	b8 12 00 00 00       	mov    $0x12,%eax
  800fab:	89 df                	mov    %ebx,%edi
  800fad:	89 de                	mov    %ebx,%esi
  800faf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	57                   	push   %edi
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
  800fbc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fca:	b8 13 00 00 00       	mov    $0x13,%eax
  800fcf:	89 df                	mov    %ebx,%edi
  800fd1:	89 de                	mov    %ebx,%esi
  800fd3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd5:	85 c0                	test   %eax,%eax
  800fd7:	7f 08                	jg     800fe1 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fdc:	5b                   	pop    %ebx
  800fdd:	5e                   	pop    %esi
  800fde:	5f                   	pop    %edi
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe1:	83 ec 0c             	sub    $0xc,%esp
  800fe4:	50                   	push   %eax
  800fe5:	6a 13                	push   $0x13
  800fe7:	68 a8 2e 80 00       	push   $0x802ea8
  800fec:	6a 43                	push   $0x43
  800fee:	68 c5 2e 80 00       	push   $0x802ec5
  800ff3:	e8 63 17 00 00       	call   80275b <_panic>

00800ff8 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	57                   	push   %edi
  800ffc:	56                   	push   %esi
  800ffd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ffe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801003:	8b 55 08             	mov    0x8(%ebp),%edx
  801006:	b8 14 00 00 00       	mov    $0x14,%eax
  80100b:	89 cb                	mov    %ecx,%ebx
  80100d:	89 cf                	mov    %ecx,%edi
  80100f:	89 ce                	mov    %ecx,%esi
  801011:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801013:	5b                   	pop    %ebx
  801014:	5e                   	pop    %esi
  801015:	5f                   	pop    %edi
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    

00801018 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	53                   	push   %ebx
  80101c:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  80101f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801026:	f6 c5 04             	test   $0x4,%ch
  801029:	75 45                	jne    801070 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80102b:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801032:	83 e1 07             	and    $0x7,%ecx
  801035:	83 f9 07             	cmp    $0x7,%ecx
  801038:	74 6f                	je     8010a9 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80103a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801041:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801047:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80104d:	0f 84 b6 00 00 00    	je     801109 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801053:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80105a:	83 e1 05             	and    $0x5,%ecx
  80105d:	83 f9 05             	cmp    $0x5,%ecx
  801060:	0f 84 d7 00 00 00    	je     80113d <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801066:	b8 00 00 00 00       	mov    $0x0,%eax
  80106b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80106e:	c9                   	leave  
  80106f:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801070:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801077:	c1 e2 0c             	shl    $0xc,%edx
  80107a:	83 ec 0c             	sub    $0xc,%esp
  80107d:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801083:	51                   	push   %ecx
  801084:	52                   	push   %edx
  801085:	50                   	push   %eax
  801086:	52                   	push   %edx
  801087:	6a 00                	push   $0x0
  801089:	e8 d8 fc ff ff       	call   800d66 <sys_page_map>
		if(r < 0)
  80108e:	83 c4 20             	add    $0x20,%esp
  801091:	85 c0                	test   %eax,%eax
  801093:	79 d1                	jns    801066 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801095:	83 ec 04             	sub    $0x4,%esp
  801098:	68 d3 2e 80 00       	push   $0x802ed3
  80109d:	6a 54                	push   $0x54
  80109f:	68 e9 2e 80 00       	push   $0x802ee9
  8010a4:	e8 b2 16 00 00       	call   80275b <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010a9:	89 d3                	mov    %edx,%ebx
  8010ab:	c1 e3 0c             	shl    $0xc,%ebx
  8010ae:	83 ec 0c             	sub    $0xc,%esp
  8010b1:	68 05 08 00 00       	push   $0x805
  8010b6:	53                   	push   %ebx
  8010b7:	50                   	push   %eax
  8010b8:	53                   	push   %ebx
  8010b9:	6a 00                	push   $0x0
  8010bb:	e8 a6 fc ff ff       	call   800d66 <sys_page_map>
		if(r < 0)
  8010c0:	83 c4 20             	add    $0x20,%esp
  8010c3:	85 c0                	test   %eax,%eax
  8010c5:	78 2e                	js     8010f5 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8010c7:	83 ec 0c             	sub    $0xc,%esp
  8010ca:	68 05 08 00 00       	push   $0x805
  8010cf:	53                   	push   %ebx
  8010d0:	6a 00                	push   $0x0
  8010d2:	53                   	push   %ebx
  8010d3:	6a 00                	push   $0x0
  8010d5:	e8 8c fc ff ff       	call   800d66 <sys_page_map>
		if(r < 0)
  8010da:	83 c4 20             	add    $0x20,%esp
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	79 85                	jns    801066 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8010e1:	83 ec 04             	sub    $0x4,%esp
  8010e4:	68 d3 2e 80 00       	push   $0x802ed3
  8010e9:	6a 5f                	push   $0x5f
  8010eb:	68 e9 2e 80 00       	push   $0x802ee9
  8010f0:	e8 66 16 00 00       	call   80275b <_panic>
			panic("sys_page_map() panic\n");
  8010f5:	83 ec 04             	sub    $0x4,%esp
  8010f8:	68 d3 2e 80 00       	push   $0x802ed3
  8010fd:	6a 5b                	push   $0x5b
  8010ff:	68 e9 2e 80 00       	push   $0x802ee9
  801104:	e8 52 16 00 00       	call   80275b <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801109:	c1 e2 0c             	shl    $0xc,%edx
  80110c:	83 ec 0c             	sub    $0xc,%esp
  80110f:	68 05 08 00 00       	push   $0x805
  801114:	52                   	push   %edx
  801115:	50                   	push   %eax
  801116:	52                   	push   %edx
  801117:	6a 00                	push   $0x0
  801119:	e8 48 fc ff ff       	call   800d66 <sys_page_map>
		if(r < 0)
  80111e:	83 c4 20             	add    $0x20,%esp
  801121:	85 c0                	test   %eax,%eax
  801123:	0f 89 3d ff ff ff    	jns    801066 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801129:	83 ec 04             	sub    $0x4,%esp
  80112c:	68 d3 2e 80 00       	push   $0x802ed3
  801131:	6a 66                	push   $0x66
  801133:	68 e9 2e 80 00       	push   $0x802ee9
  801138:	e8 1e 16 00 00       	call   80275b <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80113d:	c1 e2 0c             	shl    $0xc,%edx
  801140:	83 ec 0c             	sub    $0xc,%esp
  801143:	6a 05                	push   $0x5
  801145:	52                   	push   %edx
  801146:	50                   	push   %eax
  801147:	52                   	push   %edx
  801148:	6a 00                	push   $0x0
  80114a:	e8 17 fc ff ff       	call   800d66 <sys_page_map>
		if(r < 0)
  80114f:	83 c4 20             	add    $0x20,%esp
  801152:	85 c0                	test   %eax,%eax
  801154:	0f 89 0c ff ff ff    	jns    801066 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80115a:	83 ec 04             	sub    $0x4,%esp
  80115d:	68 d3 2e 80 00       	push   $0x802ed3
  801162:	6a 6d                	push   $0x6d
  801164:	68 e9 2e 80 00       	push   $0x802ee9
  801169:	e8 ed 15 00 00       	call   80275b <_panic>

0080116e <pgfault>:
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	53                   	push   %ebx
  801172:	83 ec 04             	sub    $0x4,%esp
  801175:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801178:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80117a:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80117e:	0f 84 99 00 00 00    	je     80121d <pgfault+0xaf>
  801184:	89 c2                	mov    %eax,%edx
  801186:	c1 ea 16             	shr    $0x16,%edx
  801189:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801190:	f6 c2 01             	test   $0x1,%dl
  801193:	0f 84 84 00 00 00    	je     80121d <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801199:	89 c2                	mov    %eax,%edx
  80119b:	c1 ea 0c             	shr    $0xc,%edx
  80119e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011a5:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011ab:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8011b1:	75 6a                	jne    80121d <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8011b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011b8:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8011ba:	83 ec 04             	sub    $0x4,%esp
  8011bd:	6a 07                	push   $0x7
  8011bf:	68 00 f0 7f 00       	push   $0x7ff000
  8011c4:	6a 00                	push   $0x0
  8011c6:	e8 58 fb ff ff       	call   800d23 <sys_page_alloc>
	if(ret < 0)
  8011cb:	83 c4 10             	add    $0x10,%esp
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	78 5f                	js     801231 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8011d2:	83 ec 04             	sub    $0x4,%esp
  8011d5:	68 00 10 00 00       	push   $0x1000
  8011da:	53                   	push   %ebx
  8011db:	68 00 f0 7f 00       	push   $0x7ff000
  8011e0:	e8 3c f9 ff ff       	call   800b21 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8011e5:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8011ec:	53                   	push   %ebx
  8011ed:	6a 00                	push   $0x0
  8011ef:	68 00 f0 7f 00       	push   $0x7ff000
  8011f4:	6a 00                	push   $0x0
  8011f6:	e8 6b fb ff ff       	call   800d66 <sys_page_map>
	if(ret < 0)
  8011fb:	83 c4 20             	add    $0x20,%esp
  8011fe:	85 c0                	test   %eax,%eax
  801200:	78 43                	js     801245 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801202:	83 ec 08             	sub    $0x8,%esp
  801205:	68 00 f0 7f 00       	push   $0x7ff000
  80120a:	6a 00                	push   $0x0
  80120c:	e8 97 fb ff ff       	call   800da8 <sys_page_unmap>
	if(ret < 0)
  801211:	83 c4 10             	add    $0x10,%esp
  801214:	85 c0                	test   %eax,%eax
  801216:	78 41                	js     801259 <pgfault+0xeb>
}
  801218:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    
		panic("panic at pgfault()\n");
  80121d:	83 ec 04             	sub    $0x4,%esp
  801220:	68 f4 2e 80 00       	push   $0x802ef4
  801225:	6a 26                	push   $0x26
  801227:	68 e9 2e 80 00       	push   $0x802ee9
  80122c:	e8 2a 15 00 00       	call   80275b <_panic>
		panic("panic in sys_page_alloc()\n");
  801231:	83 ec 04             	sub    $0x4,%esp
  801234:	68 08 2f 80 00       	push   $0x802f08
  801239:	6a 31                	push   $0x31
  80123b:	68 e9 2e 80 00       	push   $0x802ee9
  801240:	e8 16 15 00 00       	call   80275b <_panic>
		panic("panic in sys_page_map()\n");
  801245:	83 ec 04             	sub    $0x4,%esp
  801248:	68 23 2f 80 00       	push   $0x802f23
  80124d:	6a 36                	push   $0x36
  80124f:	68 e9 2e 80 00       	push   $0x802ee9
  801254:	e8 02 15 00 00       	call   80275b <_panic>
		panic("panic in sys_page_unmap()\n");
  801259:	83 ec 04             	sub    $0x4,%esp
  80125c:	68 3c 2f 80 00       	push   $0x802f3c
  801261:	6a 39                	push   $0x39
  801263:	68 e9 2e 80 00       	push   $0x802ee9
  801268:	e8 ee 14 00 00       	call   80275b <_panic>

0080126d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	57                   	push   %edi
  801271:	56                   	push   %esi
  801272:	53                   	push   %ebx
  801273:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801276:	68 6e 11 80 00       	push   $0x80116e
  80127b:	e8 3c 15 00 00       	call   8027bc <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801280:	b8 07 00 00 00       	mov    $0x7,%eax
  801285:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801287:	83 c4 10             	add    $0x10,%esp
  80128a:	85 c0                	test   %eax,%eax
  80128c:	78 2a                	js     8012b8 <fork+0x4b>
  80128e:	89 c6                	mov    %eax,%esi
  801290:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801292:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801297:	75 4b                	jne    8012e4 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  801299:	e8 47 fa ff ff       	call   800ce5 <sys_getenvid>
  80129e:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012a3:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8012a9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012ae:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8012b3:	e9 90 00 00 00       	jmp    801348 <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  8012b8:	83 ec 04             	sub    $0x4,%esp
  8012bb:	68 58 2f 80 00       	push   $0x802f58
  8012c0:	68 8c 00 00 00       	push   $0x8c
  8012c5:	68 e9 2e 80 00       	push   $0x802ee9
  8012ca:	e8 8c 14 00 00       	call   80275b <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8012cf:	89 f8                	mov    %edi,%eax
  8012d1:	e8 42 fd ff ff       	call   801018 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012dc:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8012e2:	74 26                	je     80130a <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8012e4:	89 d8                	mov    %ebx,%eax
  8012e6:	c1 e8 16             	shr    $0x16,%eax
  8012e9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012f0:	a8 01                	test   $0x1,%al
  8012f2:	74 e2                	je     8012d6 <fork+0x69>
  8012f4:	89 da                	mov    %ebx,%edx
  8012f6:	c1 ea 0c             	shr    $0xc,%edx
  8012f9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801300:	83 e0 05             	and    $0x5,%eax
  801303:	83 f8 05             	cmp    $0x5,%eax
  801306:	75 ce                	jne    8012d6 <fork+0x69>
  801308:	eb c5                	jmp    8012cf <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80130a:	83 ec 04             	sub    $0x4,%esp
  80130d:	6a 07                	push   $0x7
  80130f:	68 00 f0 bf ee       	push   $0xeebff000
  801314:	56                   	push   %esi
  801315:	e8 09 fa ff ff       	call   800d23 <sys_page_alloc>
	if(ret < 0)
  80131a:	83 c4 10             	add    $0x10,%esp
  80131d:	85 c0                	test   %eax,%eax
  80131f:	78 31                	js     801352 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801321:	83 ec 08             	sub    $0x8,%esp
  801324:	68 2b 28 80 00       	push   $0x80282b
  801329:	56                   	push   %esi
  80132a:	e8 3f fb ff ff       	call   800e6e <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	85 c0                	test   %eax,%eax
  801334:	78 33                	js     801369 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801336:	83 ec 08             	sub    $0x8,%esp
  801339:	6a 02                	push   $0x2
  80133b:	56                   	push   %esi
  80133c:	e8 a9 fa ff ff       	call   800dea <sys_env_set_status>
	if(ret < 0)
  801341:	83 c4 10             	add    $0x10,%esp
  801344:	85 c0                	test   %eax,%eax
  801346:	78 38                	js     801380 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801348:	89 f0                	mov    %esi,%eax
  80134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80134d:	5b                   	pop    %ebx
  80134e:	5e                   	pop    %esi
  80134f:	5f                   	pop    %edi
  801350:	5d                   	pop    %ebp
  801351:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801352:	83 ec 04             	sub    $0x4,%esp
  801355:	68 08 2f 80 00       	push   $0x802f08
  80135a:	68 98 00 00 00       	push   $0x98
  80135f:	68 e9 2e 80 00       	push   $0x802ee9
  801364:	e8 f2 13 00 00       	call   80275b <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801369:	83 ec 04             	sub    $0x4,%esp
  80136c:	68 7c 2f 80 00       	push   $0x802f7c
  801371:	68 9b 00 00 00       	push   $0x9b
  801376:	68 e9 2e 80 00       	push   $0x802ee9
  80137b:	e8 db 13 00 00       	call   80275b <_panic>
		panic("panic in sys_env_set_status()\n");
  801380:	83 ec 04             	sub    $0x4,%esp
  801383:	68 a4 2f 80 00       	push   $0x802fa4
  801388:	68 9e 00 00 00       	push   $0x9e
  80138d:	68 e9 2e 80 00       	push   $0x802ee9
  801392:	e8 c4 13 00 00       	call   80275b <_panic>

00801397 <sfork>:

// Challenge!
int
sfork(void)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
  80139a:	57                   	push   %edi
  80139b:	56                   	push   %esi
  80139c:	53                   	push   %ebx
  80139d:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8013a0:	68 6e 11 80 00       	push   $0x80116e
  8013a5:	e8 12 14 00 00       	call   8027bc <set_pgfault_handler>
  8013aa:	b8 07 00 00 00       	mov    $0x7,%eax
  8013af:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013b1:	83 c4 10             	add    $0x10,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	78 2a                	js     8013e2 <sfork+0x4b>
  8013b8:	89 c7                	mov    %eax,%edi
  8013ba:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013bc:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013c1:	75 58                	jne    80141b <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013c3:	e8 1d f9 ff ff       	call   800ce5 <sys_getenvid>
  8013c8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013cd:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8013d3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013d8:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8013dd:	e9 d4 00 00 00       	jmp    8014b6 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  8013e2:	83 ec 04             	sub    $0x4,%esp
  8013e5:	68 58 2f 80 00       	push   $0x802f58
  8013ea:	68 af 00 00 00       	push   $0xaf
  8013ef:	68 e9 2e 80 00       	push   $0x802ee9
  8013f4:	e8 62 13 00 00       	call   80275b <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8013f9:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8013fe:	89 f0                	mov    %esi,%eax
  801400:	e8 13 fc ff ff       	call   801018 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801405:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80140b:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801411:	77 65                	ja     801478 <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801413:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801419:	74 de                	je     8013f9 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80141b:	89 d8                	mov    %ebx,%eax
  80141d:	c1 e8 16             	shr    $0x16,%eax
  801420:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801427:	a8 01                	test   $0x1,%al
  801429:	74 da                	je     801405 <sfork+0x6e>
  80142b:	89 da                	mov    %ebx,%edx
  80142d:	c1 ea 0c             	shr    $0xc,%edx
  801430:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801437:	83 e0 05             	and    $0x5,%eax
  80143a:	83 f8 05             	cmp    $0x5,%eax
  80143d:	75 c6                	jne    801405 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80143f:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801446:	c1 e2 0c             	shl    $0xc,%edx
  801449:	83 ec 0c             	sub    $0xc,%esp
  80144c:	83 e0 07             	and    $0x7,%eax
  80144f:	50                   	push   %eax
  801450:	52                   	push   %edx
  801451:	56                   	push   %esi
  801452:	52                   	push   %edx
  801453:	6a 00                	push   $0x0
  801455:	e8 0c f9 ff ff       	call   800d66 <sys_page_map>
  80145a:	83 c4 20             	add    $0x20,%esp
  80145d:	85 c0                	test   %eax,%eax
  80145f:	74 a4                	je     801405 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	68 d3 2e 80 00       	push   $0x802ed3
  801469:	68 ba 00 00 00       	push   $0xba
  80146e:	68 e9 2e 80 00       	push   $0x802ee9
  801473:	e8 e3 12 00 00       	call   80275b <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801478:	83 ec 04             	sub    $0x4,%esp
  80147b:	6a 07                	push   $0x7
  80147d:	68 00 f0 bf ee       	push   $0xeebff000
  801482:	57                   	push   %edi
  801483:	e8 9b f8 ff ff       	call   800d23 <sys_page_alloc>
	if(ret < 0)
  801488:	83 c4 10             	add    $0x10,%esp
  80148b:	85 c0                	test   %eax,%eax
  80148d:	78 31                	js     8014c0 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80148f:	83 ec 08             	sub    $0x8,%esp
  801492:	68 2b 28 80 00       	push   $0x80282b
  801497:	57                   	push   %edi
  801498:	e8 d1 f9 ff ff       	call   800e6e <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80149d:	83 c4 10             	add    $0x10,%esp
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	78 33                	js     8014d7 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014a4:	83 ec 08             	sub    $0x8,%esp
  8014a7:	6a 02                	push   $0x2
  8014a9:	57                   	push   %edi
  8014aa:	e8 3b f9 ff ff       	call   800dea <sys_env_set_status>
	if(ret < 0)
  8014af:	83 c4 10             	add    $0x10,%esp
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	78 38                	js     8014ee <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8014b6:	89 f8                	mov    %edi,%eax
  8014b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014bb:	5b                   	pop    %ebx
  8014bc:	5e                   	pop    %esi
  8014bd:	5f                   	pop    %edi
  8014be:	5d                   	pop    %ebp
  8014bf:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014c0:	83 ec 04             	sub    $0x4,%esp
  8014c3:	68 08 2f 80 00       	push   $0x802f08
  8014c8:	68 c0 00 00 00       	push   $0xc0
  8014cd:	68 e9 2e 80 00       	push   $0x802ee9
  8014d2:	e8 84 12 00 00       	call   80275b <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014d7:	83 ec 04             	sub    $0x4,%esp
  8014da:	68 7c 2f 80 00       	push   $0x802f7c
  8014df:	68 c3 00 00 00       	push   $0xc3
  8014e4:	68 e9 2e 80 00       	push   $0x802ee9
  8014e9:	e8 6d 12 00 00       	call   80275b <_panic>
		panic("panic in sys_env_set_status()\n");
  8014ee:	83 ec 04             	sub    $0x4,%esp
  8014f1:	68 a4 2f 80 00       	push   $0x802fa4
  8014f6:	68 c6 00 00 00       	push   $0xc6
  8014fb:	68 e9 2e 80 00       	push   $0x802ee9
  801500:	e8 56 12 00 00       	call   80275b <_panic>

00801505 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	56                   	push   %esi
  801509:	53                   	push   %ebx
  80150a:	8b 75 08             	mov    0x8(%ebp),%esi
  80150d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801510:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801513:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801515:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80151a:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80151d:	83 ec 0c             	sub    $0xc,%esp
  801520:	50                   	push   %eax
  801521:	e8 ad f9 ff ff       	call   800ed3 <sys_ipc_recv>
	if(ret < 0){
  801526:	83 c4 10             	add    $0x10,%esp
  801529:	85 c0                	test   %eax,%eax
  80152b:	78 2b                	js     801558 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80152d:	85 f6                	test   %esi,%esi
  80152f:	74 0a                	je     80153b <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801531:	a1 08 50 80 00       	mov    0x805008,%eax
  801536:	8b 40 78             	mov    0x78(%eax),%eax
  801539:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80153b:	85 db                	test   %ebx,%ebx
  80153d:	74 0a                	je     801549 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80153f:	a1 08 50 80 00       	mov    0x805008,%eax
  801544:	8b 40 7c             	mov    0x7c(%eax),%eax
  801547:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801549:	a1 08 50 80 00       	mov    0x805008,%eax
  80154e:	8b 40 74             	mov    0x74(%eax),%eax
}
  801551:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801554:	5b                   	pop    %ebx
  801555:	5e                   	pop    %esi
  801556:	5d                   	pop    %ebp
  801557:	c3                   	ret    
		if(from_env_store)
  801558:	85 f6                	test   %esi,%esi
  80155a:	74 06                	je     801562 <ipc_recv+0x5d>
			*from_env_store = 0;
  80155c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801562:	85 db                	test   %ebx,%ebx
  801564:	74 eb                	je     801551 <ipc_recv+0x4c>
			*perm_store = 0;
  801566:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80156c:	eb e3                	jmp    801551 <ipc_recv+0x4c>

0080156e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	57                   	push   %edi
  801572:	56                   	push   %esi
  801573:	53                   	push   %ebx
  801574:	83 ec 0c             	sub    $0xc,%esp
  801577:	8b 7d 08             	mov    0x8(%ebp),%edi
  80157a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80157d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801580:	85 db                	test   %ebx,%ebx
  801582:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801587:	0f 44 d8             	cmove  %eax,%ebx
  80158a:	eb 05                	jmp    801591 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80158c:	e8 73 f7 ff ff       	call   800d04 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801591:	ff 75 14             	pushl  0x14(%ebp)
  801594:	53                   	push   %ebx
  801595:	56                   	push   %esi
  801596:	57                   	push   %edi
  801597:	e8 14 f9 ff ff       	call   800eb0 <sys_ipc_try_send>
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	74 1b                	je     8015be <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8015a3:	79 e7                	jns    80158c <ipc_send+0x1e>
  8015a5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8015a8:	74 e2                	je     80158c <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8015aa:	83 ec 04             	sub    $0x4,%esp
  8015ad:	68 c3 2f 80 00       	push   $0x802fc3
  8015b2:	6a 46                	push   $0x46
  8015b4:	68 d8 2f 80 00       	push   $0x802fd8
  8015b9:	e8 9d 11 00 00       	call   80275b <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8015be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c1:	5b                   	pop    %ebx
  8015c2:	5e                   	pop    %esi
  8015c3:	5f                   	pop    %edi
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    

008015c6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8015cc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8015d1:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8015d7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8015dd:	8b 52 50             	mov    0x50(%edx),%edx
  8015e0:	39 ca                	cmp    %ecx,%edx
  8015e2:	74 11                	je     8015f5 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8015e4:	83 c0 01             	add    $0x1,%eax
  8015e7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8015ec:	75 e3                	jne    8015d1 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8015ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f3:	eb 0e                	jmp    801603 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8015f5:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8015fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801600:	8b 40 48             	mov    0x48(%eax),%eax
}
  801603:	5d                   	pop    %ebp
  801604:	c3                   	ret    

00801605 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	05 00 00 00 30       	add    $0x30000000,%eax
  801610:	c1 e8 0c             	shr    $0xc,%eax
}
  801613:	5d                   	pop    %ebp
  801614:	c3                   	ret    

00801615 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801620:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801625:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80162a:	5d                   	pop    %ebp
  80162b:	c3                   	ret    

0080162c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801634:	89 c2                	mov    %eax,%edx
  801636:	c1 ea 16             	shr    $0x16,%edx
  801639:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801640:	f6 c2 01             	test   $0x1,%dl
  801643:	74 2d                	je     801672 <fd_alloc+0x46>
  801645:	89 c2                	mov    %eax,%edx
  801647:	c1 ea 0c             	shr    $0xc,%edx
  80164a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801651:	f6 c2 01             	test   $0x1,%dl
  801654:	74 1c                	je     801672 <fd_alloc+0x46>
  801656:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80165b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801660:	75 d2                	jne    801634 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80166b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801670:	eb 0a                	jmp    80167c <fd_alloc+0x50>
			*fd_store = fd;
  801672:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801675:	89 01                	mov    %eax,(%ecx)
			return 0;
  801677:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167c:	5d                   	pop    %ebp
  80167d:	c3                   	ret    

0080167e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801684:	83 f8 1f             	cmp    $0x1f,%eax
  801687:	77 30                	ja     8016b9 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801689:	c1 e0 0c             	shl    $0xc,%eax
  80168c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801691:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801697:	f6 c2 01             	test   $0x1,%dl
  80169a:	74 24                	je     8016c0 <fd_lookup+0x42>
  80169c:	89 c2                	mov    %eax,%edx
  80169e:	c1 ea 0c             	shr    $0xc,%edx
  8016a1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016a8:	f6 c2 01             	test   $0x1,%dl
  8016ab:	74 1a                	je     8016c7 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b0:	89 02                	mov    %eax,(%edx)
	return 0;
  8016b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b7:	5d                   	pop    %ebp
  8016b8:	c3                   	ret    
		return -E_INVAL;
  8016b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016be:	eb f7                	jmp    8016b7 <fd_lookup+0x39>
		return -E_INVAL;
  8016c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c5:	eb f0                	jmp    8016b7 <fd_lookup+0x39>
  8016c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016cc:	eb e9                	jmp    8016b7 <fd_lookup+0x39>

008016ce <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	83 ec 08             	sub    $0x8,%esp
  8016d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8016d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016dc:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8016e1:	39 08                	cmp    %ecx,(%eax)
  8016e3:	74 38                	je     80171d <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8016e5:	83 c2 01             	add    $0x1,%edx
  8016e8:	8b 04 95 60 30 80 00 	mov    0x803060(,%edx,4),%eax
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	75 ee                	jne    8016e1 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016f3:	a1 08 50 80 00       	mov    0x805008,%eax
  8016f8:	8b 40 48             	mov    0x48(%eax),%eax
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	51                   	push   %ecx
  8016ff:	50                   	push   %eax
  801700:	68 e4 2f 80 00       	push   $0x802fe4
  801705:	e8 c8 ea ff ff       	call   8001d2 <cprintf>
	*dev = 0;
  80170a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801713:	83 c4 10             	add    $0x10,%esp
  801716:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    
			*dev = devtab[i];
  80171d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801720:	89 01                	mov    %eax,(%ecx)
			return 0;
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
  801727:	eb f2                	jmp    80171b <dev_lookup+0x4d>

00801729 <fd_close>:
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	57                   	push   %edi
  80172d:	56                   	push   %esi
  80172e:	53                   	push   %ebx
  80172f:	83 ec 24             	sub    $0x24,%esp
  801732:	8b 75 08             	mov    0x8(%ebp),%esi
  801735:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801738:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80173b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80173c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801742:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801745:	50                   	push   %eax
  801746:	e8 33 ff ff ff       	call   80167e <fd_lookup>
  80174b:	89 c3                	mov    %eax,%ebx
  80174d:	83 c4 10             	add    $0x10,%esp
  801750:	85 c0                	test   %eax,%eax
  801752:	78 05                	js     801759 <fd_close+0x30>
	    || fd != fd2)
  801754:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801757:	74 16                	je     80176f <fd_close+0x46>
		return (must_exist ? r : 0);
  801759:	89 f8                	mov    %edi,%eax
  80175b:	84 c0                	test   %al,%al
  80175d:	b8 00 00 00 00       	mov    $0x0,%eax
  801762:	0f 44 d8             	cmove  %eax,%ebx
}
  801765:	89 d8                	mov    %ebx,%eax
  801767:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80176a:	5b                   	pop    %ebx
  80176b:	5e                   	pop    %esi
  80176c:	5f                   	pop    %edi
  80176d:	5d                   	pop    %ebp
  80176e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80176f:	83 ec 08             	sub    $0x8,%esp
  801772:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801775:	50                   	push   %eax
  801776:	ff 36                	pushl  (%esi)
  801778:	e8 51 ff ff ff       	call   8016ce <dev_lookup>
  80177d:	89 c3                	mov    %eax,%ebx
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	85 c0                	test   %eax,%eax
  801784:	78 1a                	js     8017a0 <fd_close+0x77>
		if (dev->dev_close)
  801786:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801789:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80178c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801791:	85 c0                	test   %eax,%eax
  801793:	74 0b                	je     8017a0 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801795:	83 ec 0c             	sub    $0xc,%esp
  801798:	56                   	push   %esi
  801799:	ff d0                	call   *%eax
  80179b:	89 c3                	mov    %eax,%ebx
  80179d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8017a0:	83 ec 08             	sub    $0x8,%esp
  8017a3:	56                   	push   %esi
  8017a4:	6a 00                	push   $0x0
  8017a6:	e8 fd f5 ff ff       	call   800da8 <sys_page_unmap>
	return r;
  8017ab:	83 c4 10             	add    $0x10,%esp
  8017ae:	eb b5                	jmp    801765 <fd_close+0x3c>

008017b0 <close>:

int
close(int fdnum)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b9:	50                   	push   %eax
  8017ba:	ff 75 08             	pushl  0x8(%ebp)
  8017bd:	e8 bc fe ff ff       	call   80167e <fd_lookup>
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	85 c0                	test   %eax,%eax
  8017c7:	79 02                	jns    8017cb <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    
		return fd_close(fd, 1);
  8017cb:	83 ec 08             	sub    $0x8,%esp
  8017ce:	6a 01                	push   $0x1
  8017d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d3:	e8 51 ff ff ff       	call   801729 <fd_close>
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	eb ec                	jmp    8017c9 <close+0x19>

008017dd <close_all>:

void
close_all(void)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	53                   	push   %ebx
  8017e1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017e4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017e9:	83 ec 0c             	sub    $0xc,%esp
  8017ec:	53                   	push   %ebx
  8017ed:	e8 be ff ff ff       	call   8017b0 <close>
	for (i = 0; i < MAXFD; i++)
  8017f2:	83 c3 01             	add    $0x1,%ebx
  8017f5:	83 c4 10             	add    $0x10,%esp
  8017f8:	83 fb 20             	cmp    $0x20,%ebx
  8017fb:	75 ec                	jne    8017e9 <close_all+0xc>
}
  8017fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	57                   	push   %edi
  801806:	56                   	push   %esi
  801807:	53                   	push   %ebx
  801808:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80180b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80180e:	50                   	push   %eax
  80180f:	ff 75 08             	pushl  0x8(%ebp)
  801812:	e8 67 fe ff ff       	call   80167e <fd_lookup>
  801817:	89 c3                	mov    %eax,%ebx
  801819:	83 c4 10             	add    $0x10,%esp
  80181c:	85 c0                	test   %eax,%eax
  80181e:	0f 88 81 00 00 00    	js     8018a5 <dup+0xa3>
		return r;
	close(newfdnum);
  801824:	83 ec 0c             	sub    $0xc,%esp
  801827:	ff 75 0c             	pushl  0xc(%ebp)
  80182a:	e8 81 ff ff ff       	call   8017b0 <close>

	newfd = INDEX2FD(newfdnum);
  80182f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801832:	c1 e6 0c             	shl    $0xc,%esi
  801835:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80183b:	83 c4 04             	add    $0x4,%esp
  80183e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801841:	e8 cf fd ff ff       	call   801615 <fd2data>
  801846:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801848:	89 34 24             	mov    %esi,(%esp)
  80184b:	e8 c5 fd ff ff       	call   801615 <fd2data>
  801850:	83 c4 10             	add    $0x10,%esp
  801853:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801855:	89 d8                	mov    %ebx,%eax
  801857:	c1 e8 16             	shr    $0x16,%eax
  80185a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801861:	a8 01                	test   $0x1,%al
  801863:	74 11                	je     801876 <dup+0x74>
  801865:	89 d8                	mov    %ebx,%eax
  801867:	c1 e8 0c             	shr    $0xc,%eax
  80186a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801871:	f6 c2 01             	test   $0x1,%dl
  801874:	75 39                	jne    8018af <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801876:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801879:	89 d0                	mov    %edx,%eax
  80187b:	c1 e8 0c             	shr    $0xc,%eax
  80187e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801885:	83 ec 0c             	sub    $0xc,%esp
  801888:	25 07 0e 00 00       	and    $0xe07,%eax
  80188d:	50                   	push   %eax
  80188e:	56                   	push   %esi
  80188f:	6a 00                	push   $0x0
  801891:	52                   	push   %edx
  801892:	6a 00                	push   $0x0
  801894:	e8 cd f4 ff ff       	call   800d66 <sys_page_map>
  801899:	89 c3                	mov    %eax,%ebx
  80189b:	83 c4 20             	add    $0x20,%esp
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	78 31                	js     8018d3 <dup+0xd1>
		goto err;

	return newfdnum;
  8018a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018a5:	89 d8                	mov    %ebx,%eax
  8018a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018aa:	5b                   	pop    %ebx
  8018ab:	5e                   	pop    %esi
  8018ac:	5f                   	pop    %edi
  8018ad:	5d                   	pop    %ebp
  8018ae:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018af:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018b6:	83 ec 0c             	sub    $0xc,%esp
  8018b9:	25 07 0e 00 00       	and    $0xe07,%eax
  8018be:	50                   	push   %eax
  8018bf:	57                   	push   %edi
  8018c0:	6a 00                	push   $0x0
  8018c2:	53                   	push   %ebx
  8018c3:	6a 00                	push   $0x0
  8018c5:	e8 9c f4 ff ff       	call   800d66 <sys_page_map>
  8018ca:	89 c3                	mov    %eax,%ebx
  8018cc:	83 c4 20             	add    $0x20,%esp
  8018cf:	85 c0                	test   %eax,%eax
  8018d1:	79 a3                	jns    801876 <dup+0x74>
	sys_page_unmap(0, newfd);
  8018d3:	83 ec 08             	sub    $0x8,%esp
  8018d6:	56                   	push   %esi
  8018d7:	6a 00                	push   $0x0
  8018d9:	e8 ca f4 ff ff       	call   800da8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018de:	83 c4 08             	add    $0x8,%esp
  8018e1:	57                   	push   %edi
  8018e2:	6a 00                	push   $0x0
  8018e4:	e8 bf f4 ff ff       	call   800da8 <sys_page_unmap>
	return r;
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	eb b7                	jmp    8018a5 <dup+0xa3>

008018ee <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	53                   	push   %ebx
  8018f2:	83 ec 1c             	sub    $0x1c,%esp
  8018f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018fb:	50                   	push   %eax
  8018fc:	53                   	push   %ebx
  8018fd:	e8 7c fd ff ff       	call   80167e <fd_lookup>
  801902:	83 c4 10             	add    $0x10,%esp
  801905:	85 c0                	test   %eax,%eax
  801907:	78 3f                	js     801948 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801909:	83 ec 08             	sub    $0x8,%esp
  80190c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190f:	50                   	push   %eax
  801910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801913:	ff 30                	pushl  (%eax)
  801915:	e8 b4 fd ff ff       	call   8016ce <dev_lookup>
  80191a:	83 c4 10             	add    $0x10,%esp
  80191d:	85 c0                	test   %eax,%eax
  80191f:	78 27                	js     801948 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801921:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801924:	8b 42 08             	mov    0x8(%edx),%eax
  801927:	83 e0 03             	and    $0x3,%eax
  80192a:	83 f8 01             	cmp    $0x1,%eax
  80192d:	74 1e                	je     80194d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80192f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801932:	8b 40 08             	mov    0x8(%eax),%eax
  801935:	85 c0                	test   %eax,%eax
  801937:	74 35                	je     80196e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801939:	83 ec 04             	sub    $0x4,%esp
  80193c:	ff 75 10             	pushl  0x10(%ebp)
  80193f:	ff 75 0c             	pushl  0xc(%ebp)
  801942:	52                   	push   %edx
  801943:	ff d0                	call   *%eax
  801945:	83 c4 10             	add    $0x10,%esp
}
  801948:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80194d:	a1 08 50 80 00       	mov    0x805008,%eax
  801952:	8b 40 48             	mov    0x48(%eax),%eax
  801955:	83 ec 04             	sub    $0x4,%esp
  801958:	53                   	push   %ebx
  801959:	50                   	push   %eax
  80195a:	68 25 30 80 00       	push   $0x803025
  80195f:	e8 6e e8 ff ff       	call   8001d2 <cprintf>
		return -E_INVAL;
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80196c:	eb da                	jmp    801948 <read+0x5a>
		return -E_NOT_SUPP;
  80196e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801973:	eb d3                	jmp    801948 <read+0x5a>

00801975 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	57                   	push   %edi
  801979:	56                   	push   %esi
  80197a:	53                   	push   %ebx
  80197b:	83 ec 0c             	sub    $0xc,%esp
  80197e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801981:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801984:	bb 00 00 00 00       	mov    $0x0,%ebx
  801989:	39 f3                	cmp    %esi,%ebx
  80198b:	73 23                	jae    8019b0 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	89 f0                	mov    %esi,%eax
  801992:	29 d8                	sub    %ebx,%eax
  801994:	50                   	push   %eax
  801995:	89 d8                	mov    %ebx,%eax
  801997:	03 45 0c             	add    0xc(%ebp),%eax
  80199a:	50                   	push   %eax
  80199b:	57                   	push   %edi
  80199c:	e8 4d ff ff ff       	call   8018ee <read>
		if (m < 0)
  8019a1:	83 c4 10             	add    $0x10,%esp
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	78 06                	js     8019ae <readn+0x39>
			return m;
		if (m == 0)
  8019a8:	74 06                	je     8019b0 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8019aa:	01 c3                	add    %eax,%ebx
  8019ac:	eb db                	jmp    801989 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019ae:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019b0:	89 d8                	mov    %ebx,%eax
  8019b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019b5:	5b                   	pop    %ebx
  8019b6:	5e                   	pop    %esi
  8019b7:	5f                   	pop    %edi
  8019b8:	5d                   	pop    %ebp
  8019b9:	c3                   	ret    

008019ba <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	53                   	push   %ebx
  8019be:	83 ec 1c             	sub    $0x1c,%esp
  8019c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019c7:	50                   	push   %eax
  8019c8:	53                   	push   %ebx
  8019c9:	e8 b0 fc ff ff       	call   80167e <fd_lookup>
  8019ce:	83 c4 10             	add    $0x10,%esp
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	78 3a                	js     801a0f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019d5:	83 ec 08             	sub    $0x8,%esp
  8019d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019db:	50                   	push   %eax
  8019dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019df:	ff 30                	pushl  (%eax)
  8019e1:	e8 e8 fc ff ff       	call   8016ce <dev_lookup>
  8019e6:	83 c4 10             	add    $0x10,%esp
  8019e9:	85 c0                	test   %eax,%eax
  8019eb:	78 22                	js     801a0f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019f4:	74 1e                	je     801a14 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019f9:	8b 52 0c             	mov    0xc(%edx),%edx
  8019fc:	85 d2                	test   %edx,%edx
  8019fe:	74 35                	je     801a35 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a00:	83 ec 04             	sub    $0x4,%esp
  801a03:	ff 75 10             	pushl  0x10(%ebp)
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	50                   	push   %eax
  801a0a:	ff d2                	call   *%edx
  801a0c:	83 c4 10             	add    $0x10,%esp
}
  801a0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a14:	a1 08 50 80 00       	mov    0x805008,%eax
  801a19:	8b 40 48             	mov    0x48(%eax),%eax
  801a1c:	83 ec 04             	sub    $0x4,%esp
  801a1f:	53                   	push   %ebx
  801a20:	50                   	push   %eax
  801a21:	68 41 30 80 00       	push   $0x803041
  801a26:	e8 a7 e7 ff ff       	call   8001d2 <cprintf>
		return -E_INVAL;
  801a2b:	83 c4 10             	add    $0x10,%esp
  801a2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a33:	eb da                	jmp    801a0f <write+0x55>
		return -E_NOT_SUPP;
  801a35:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a3a:	eb d3                	jmp    801a0f <write+0x55>

00801a3c <seek>:

int
seek(int fdnum, off_t offset)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a45:	50                   	push   %eax
  801a46:	ff 75 08             	pushl  0x8(%ebp)
  801a49:	e8 30 fc ff ff       	call   80167e <fd_lookup>
  801a4e:	83 c4 10             	add    $0x10,%esp
  801a51:	85 c0                	test   %eax,%eax
  801a53:	78 0e                	js     801a63 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	53                   	push   %ebx
  801a69:	83 ec 1c             	sub    $0x1c,%esp
  801a6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a6f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a72:	50                   	push   %eax
  801a73:	53                   	push   %ebx
  801a74:	e8 05 fc ff ff       	call   80167e <fd_lookup>
  801a79:	83 c4 10             	add    $0x10,%esp
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	78 37                	js     801ab7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a80:	83 ec 08             	sub    $0x8,%esp
  801a83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a86:	50                   	push   %eax
  801a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8a:	ff 30                	pushl  (%eax)
  801a8c:	e8 3d fc ff ff       	call   8016ce <dev_lookup>
  801a91:	83 c4 10             	add    $0x10,%esp
  801a94:	85 c0                	test   %eax,%eax
  801a96:	78 1f                	js     801ab7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a9f:	74 1b                	je     801abc <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801aa1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa4:	8b 52 18             	mov    0x18(%edx),%edx
  801aa7:	85 d2                	test   %edx,%edx
  801aa9:	74 32                	je     801add <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801aab:	83 ec 08             	sub    $0x8,%esp
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	50                   	push   %eax
  801ab2:	ff d2                	call   *%edx
  801ab4:	83 c4 10             	add    $0x10,%esp
}
  801ab7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    
			thisenv->env_id, fdnum);
  801abc:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ac1:	8b 40 48             	mov    0x48(%eax),%eax
  801ac4:	83 ec 04             	sub    $0x4,%esp
  801ac7:	53                   	push   %ebx
  801ac8:	50                   	push   %eax
  801ac9:	68 04 30 80 00       	push   $0x803004
  801ace:	e8 ff e6 ff ff       	call   8001d2 <cprintf>
		return -E_INVAL;
  801ad3:	83 c4 10             	add    $0x10,%esp
  801ad6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801adb:	eb da                	jmp    801ab7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801add:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ae2:	eb d3                	jmp    801ab7 <ftruncate+0x52>

00801ae4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	53                   	push   %ebx
  801ae8:	83 ec 1c             	sub    $0x1c,%esp
  801aeb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801af1:	50                   	push   %eax
  801af2:	ff 75 08             	pushl  0x8(%ebp)
  801af5:	e8 84 fb ff ff       	call   80167e <fd_lookup>
  801afa:	83 c4 10             	add    $0x10,%esp
  801afd:	85 c0                	test   %eax,%eax
  801aff:	78 4b                	js     801b4c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b01:	83 ec 08             	sub    $0x8,%esp
  801b04:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b07:	50                   	push   %eax
  801b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0b:	ff 30                	pushl  (%eax)
  801b0d:	e8 bc fb ff ff       	call   8016ce <dev_lookup>
  801b12:	83 c4 10             	add    $0x10,%esp
  801b15:	85 c0                	test   %eax,%eax
  801b17:	78 33                	js     801b4c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b20:	74 2f                	je     801b51 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b22:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b25:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b2c:	00 00 00 
	stat->st_isdir = 0;
  801b2f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b36:	00 00 00 
	stat->st_dev = dev;
  801b39:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b3f:	83 ec 08             	sub    $0x8,%esp
  801b42:	53                   	push   %ebx
  801b43:	ff 75 f0             	pushl  -0x10(%ebp)
  801b46:	ff 50 14             	call   *0x14(%eax)
  801b49:	83 c4 10             	add    $0x10,%esp
}
  801b4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    
		return -E_NOT_SUPP;
  801b51:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b56:	eb f4                	jmp    801b4c <fstat+0x68>

00801b58 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	56                   	push   %esi
  801b5c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b5d:	83 ec 08             	sub    $0x8,%esp
  801b60:	6a 00                	push   $0x0
  801b62:	ff 75 08             	pushl  0x8(%ebp)
  801b65:	e8 22 02 00 00       	call   801d8c <open>
  801b6a:	89 c3                	mov    %eax,%ebx
  801b6c:	83 c4 10             	add    $0x10,%esp
  801b6f:	85 c0                	test   %eax,%eax
  801b71:	78 1b                	js     801b8e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b73:	83 ec 08             	sub    $0x8,%esp
  801b76:	ff 75 0c             	pushl  0xc(%ebp)
  801b79:	50                   	push   %eax
  801b7a:	e8 65 ff ff ff       	call   801ae4 <fstat>
  801b7f:	89 c6                	mov    %eax,%esi
	close(fd);
  801b81:	89 1c 24             	mov    %ebx,(%esp)
  801b84:	e8 27 fc ff ff       	call   8017b0 <close>
	return r;
  801b89:	83 c4 10             	add    $0x10,%esp
  801b8c:	89 f3                	mov    %esi,%ebx
}
  801b8e:	89 d8                	mov    %ebx,%eax
  801b90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b93:	5b                   	pop    %ebx
  801b94:	5e                   	pop    %esi
  801b95:	5d                   	pop    %ebp
  801b96:	c3                   	ret    

00801b97 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	56                   	push   %esi
  801b9b:	53                   	push   %ebx
  801b9c:	89 c6                	mov    %eax,%esi
  801b9e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801ba0:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ba7:	74 27                	je     801bd0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ba9:	6a 07                	push   $0x7
  801bab:	68 00 60 80 00       	push   $0x806000
  801bb0:	56                   	push   %esi
  801bb1:	ff 35 00 50 80 00    	pushl  0x805000
  801bb7:	e8 b2 f9 ff ff       	call   80156e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bbc:	83 c4 0c             	add    $0xc,%esp
  801bbf:	6a 00                	push   $0x0
  801bc1:	53                   	push   %ebx
  801bc2:	6a 00                	push   $0x0
  801bc4:	e8 3c f9 ff ff       	call   801505 <ipc_recv>
}
  801bc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bcc:	5b                   	pop    %ebx
  801bcd:	5e                   	pop    %esi
  801bce:	5d                   	pop    %ebp
  801bcf:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bd0:	83 ec 0c             	sub    $0xc,%esp
  801bd3:	6a 01                	push   $0x1
  801bd5:	e8 ec f9 ff ff       	call   8015c6 <ipc_find_env>
  801bda:	a3 00 50 80 00       	mov    %eax,0x805000
  801bdf:	83 c4 10             	add    $0x10,%esp
  801be2:	eb c5                	jmp    801ba9 <fsipc+0x12>

00801be4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bea:	8b 45 08             	mov    0x8(%ebp),%eax
  801bed:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf8:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801bfd:	ba 00 00 00 00       	mov    $0x0,%edx
  801c02:	b8 02 00 00 00       	mov    $0x2,%eax
  801c07:	e8 8b ff ff ff       	call   801b97 <fsipc>
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <devfile_flush>:
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	8b 40 0c             	mov    0xc(%eax),%eax
  801c1a:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c24:	b8 06 00 00 00       	mov    $0x6,%eax
  801c29:	e8 69 ff ff ff       	call   801b97 <fsipc>
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <devfile_stat>:
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	53                   	push   %ebx
  801c34:	83 ec 04             	sub    $0x4,%esp
  801c37:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c40:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c45:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4a:	b8 05 00 00 00       	mov    $0x5,%eax
  801c4f:	e8 43 ff ff ff       	call   801b97 <fsipc>
  801c54:	85 c0                	test   %eax,%eax
  801c56:	78 2c                	js     801c84 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c58:	83 ec 08             	sub    $0x8,%esp
  801c5b:	68 00 60 80 00       	push   $0x806000
  801c60:	53                   	push   %ebx
  801c61:	e8 cb ec ff ff       	call   800931 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c66:	a1 80 60 80 00       	mov    0x806080,%eax
  801c6b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c71:	a1 84 60 80 00       	mov    0x806084,%eax
  801c76:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c7c:	83 c4 10             	add    $0x10,%esp
  801c7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <devfile_write>:
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	53                   	push   %ebx
  801c8d:	83 ec 08             	sub    $0x8,%esp
  801c90:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	8b 40 0c             	mov    0xc(%eax),%eax
  801c99:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801c9e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ca4:	53                   	push   %ebx
  801ca5:	ff 75 0c             	pushl  0xc(%ebp)
  801ca8:	68 08 60 80 00       	push   $0x806008
  801cad:	e8 6f ee ff ff       	call   800b21 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801cb2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb7:	b8 04 00 00 00       	mov    $0x4,%eax
  801cbc:	e8 d6 fe ff ff       	call   801b97 <fsipc>
  801cc1:	83 c4 10             	add    $0x10,%esp
  801cc4:	85 c0                	test   %eax,%eax
  801cc6:	78 0b                	js     801cd3 <devfile_write+0x4a>
	assert(r <= n);
  801cc8:	39 d8                	cmp    %ebx,%eax
  801cca:	77 0c                	ja     801cd8 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801ccc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cd1:	7f 1e                	jg     801cf1 <devfile_write+0x68>
}
  801cd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    
	assert(r <= n);
  801cd8:	68 74 30 80 00       	push   $0x803074
  801cdd:	68 7b 30 80 00       	push   $0x80307b
  801ce2:	68 98 00 00 00       	push   $0x98
  801ce7:	68 90 30 80 00       	push   $0x803090
  801cec:	e8 6a 0a 00 00       	call   80275b <_panic>
	assert(r <= PGSIZE);
  801cf1:	68 9b 30 80 00       	push   $0x80309b
  801cf6:	68 7b 30 80 00       	push   $0x80307b
  801cfb:	68 99 00 00 00       	push   $0x99
  801d00:	68 90 30 80 00       	push   $0x803090
  801d05:	e8 51 0a 00 00       	call   80275b <_panic>

00801d0a <devfile_read>:
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	56                   	push   %esi
  801d0e:	53                   	push   %ebx
  801d0f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d12:	8b 45 08             	mov    0x8(%ebp),%eax
  801d15:	8b 40 0c             	mov    0xc(%eax),%eax
  801d18:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d1d:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d23:	ba 00 00 00 00       	mov    $0x0,%edx
  801d28:	b8 03 00 00 00       	mov    $0x3,%eax
  801d2d:	e8 65 fe ff ff       	call   801b97 <fsipc>
  801d32:	89 c3                	mov    %eax,%ebx
  801d34:	85 c0                	test   %eax,%eax
  801d36:	78 1f                	js     801d57 <devfile_read+0x4d>
	assert(r <= n);
  801d38:	39 f0                	cmp    %esi,%eax
  801d3a:	77 24                	ja     801d60 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d3c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d41:	7f 33                	jg     801d76 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d43:	83 ec 04             	sub    $0x4,%esp
  801d46:	50                   	push   %eax
  801d47:	68 00 60 80 00       	push   $0x806000
  801d4c:	ff 75 0c             	pushl  0xc(%ebp)
  801d4f:	e8 6b ed ff ff       	call   800abf <memmove>
	return r;
  801d54:	83 c4 10             	add    $0x10,%esp
}
  801d57:	89 d8                	mov    %ebx,%eax
  801d59:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d5c:	5b                   	pop    %ebx
  801d5d:	5e                   	pop    %esi
  801d5e:	5d                   	pop    %ebp
  801d5f:	c3                   	ret    
	assert(r <= n);
  801d60:	68 74 30 80 00       	push   $0x803074
  801d65:	68 7b 30 80 00       	push   $0x80307b
  801d6a:	6a 7c                	push   $0x7c
  801d6c:	68 90 30 80 00       	push   $0x803090
  801d71:	e8 e5 09 00 00       	call   80275b <_panic>
	assert(r <= PGSIZE);
  801d76:	68 9b 30 80 00       	push   $0x80309b
  801d7b:	68 7b 30 80 00       	push   $0x80307b
  801d80:	6a 7d                	push   $0x7d
  801d82:	68 90 30 80 00       	push   $0x803090
  801d87:	e8 cf 09 00 00       	call   80275b <_panic>

00801d8c <open>:
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	56                   	push   %esi
  801d90:	53                   	push   %ebx
  801d91:	83 ec 1c             	sub    $0x1c,%esp
  801d94:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d97:	56                   	push   %esi
  801d98:	e8 5b eb ff ff       	call   8008f8 <strlen>
  801d9d:	83 c4 10             	add    $0x10,%esp
  801da0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801da5:	7f 6c                	jg     801e13 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801da7:	83 ec 0c             	sub    $0xc,%esp
  801daa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dad:	50                   	push   %eax
  801dae:	e8 79 f8 ff ff       	call   80162c <fd_alloc>
  801db3:	89 c3                	mov    %eax,%ebx
  801db5:	83 c4 10             	add    $0x10,%esp
  801db8:	85 c0                	test   %eax,%eax
  801dba:	78 3c                	js     801df8 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801dbc:	83 ec 08             	sub    $0x8,%esp
  801dbf:	56                   	push   %esi
  801dc0:	68 00 60 80 00       	push   $0x806000
  801dc5:	e8 67 eb ff ff       	call   800931 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dcd:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801dd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dda:	e8 b8 fd ff ff       	call   801b97 <fsipc>
  801ddf:	89 c3                	mov    %eax,%ebx
  801de1:	83 c4 10             	add    $0x10,%esp
  801de4:	85 c0                	test   %eax,%eax
  801de6:	78 19                	js     801e01 <open+0x75>
	return fd2num(fd);
  801de8:	83 ec 0c             	sub    $0xc,%esp
  801deb:	ff 75 f4             	pushl  -0xc(%ebp)
  801dee:	e8 12 f8 ff ff       	call   801605 <fd2num>
  801df3:	89 c3                	mov    %eax,%ebx
  801df5:	83 c4 10             	add    $0x10,%esp
}
  801df8:	89 d8                	mov    %ebx,%eax
  801dfa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dfd:	5b                   	pop    %ebx
  801dfe:	5e                   	pop    %esi
  801dff:	5d                   	pop    %ebp
  801e00:	c3                   	ret    
		fd_close(fd, 0);
  801e01:	83 ec 08             	sub    $0x8,%esp
  801e04:	6a 00                	push   $0x0
  801e06:	ff 75 f4             	pushl  -0xc(%ebp)
  801e09:	e8 1b f9 ff ff       	call   801729 <fd_close>
		return r;
  801e0e:	83 c4 10             	add    $0x10,%esp
  801e11:	eb e5                	jmp    801df8 <open+0x6c>
		return -E_BAD_PATH;
  801e13:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e18:	eb de                	jmp    801df8 <open+0x6c>

00801e1a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e20:	ba 00 00 00 00       	mov    $0x0,%edx
  801e25:	b8 08 00 00 00       	mov    $0x8,%eax
  801e2a:	e8 68 fd ff ff       	call   801b97 <fsipc>
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e37:	68 a7 30 80 00       	push   $0x8030a7
  801e3c:	ff 75 0c             	pushl  0xc(%ebp)
  801e3f:	e8 ed ea ff ff       	call   800931 <strcpy>
	return 0;
}
  801e44:	b8 00 00 00 00       	mov    $0x0,%eax
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <devsock_close>:
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	53                   	push   %ebx
  801e4f:	83 ec 10             	sub    $0x10,%esp
  801e52:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e55:	53                   	push   %ebx
  801e56:	e8 f6 09 00 00       	call   802851 <pageref>
  801e5b:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e5e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e63:	83 f8 01             	cmp    $0x1,%eax
  801e66:	74 07                	je     801e6f <devsock_close+0x24>
}
  801e68:	89 d0                	mov    %edx,%eax
  801e6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e6f:	83 ec 0c             	sub    $0xc,%esp
  801e72:	ff 73 0c             	pushl  0xc(%ebx)
  801e75:	e8 b9 02 00 00       	call   802133 <nsipc_close>
  801e7a:	89 c2                	mov    %eax,%edx
  801e7c:	83 c4 10             	add    $0x10,%esp
  801e7f:	eb e7                	jmp    801e68 <devsock_close+0x1d>

00801e81 <devsock_write>:
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e87:	6a 00                	push   $0x0
  801e89:	ff 75 10             	pushl  0x10(%ebp)
  801e8c:	ff 75 0c             	pushl  0xc(%ebp)
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	ff 70 0c             	pushl  0xc(%eax)
  801e95:	e8 76 03 00 00       	call   802210 <nsipc_send>
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <devsock_read>:
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ea2:	6a 00                	push   $0x0
  801ea4:	ff 75 10             	pushl  0x10(%ebp)
  801ea7:	ff 75 0c             	pushl  0xc(%ebp)
  801eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ead:	ff 70 0c             	pushl  0xc(%eax)
  801eb0:	e8 ef 02 00 00       	call   8021a4 <nsipc_recv>
}
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <fd2sockid>:
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ebd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ec0:	52                   	push   %edx
  801ec1:	50                   	push   %eax
  801ec2:	e8 b7 f7 ff ff       	call   80167e <fd_lookup>
  801ec7:	83 c4 10             	add    $0x10,%esp
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	78 10                	js     801ede <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed1:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801ed7:	39 08                	cmp    %ecx,(%eax)
  801ed9:	75 05                	jne    801ee0 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801edb:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    
		return -E_NOT_SUPP;
  801ee0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ee5:	eb f7                	jmp    801ede <fd2sockid+0x27>

00801ee7 <alloc_sockfd>:
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	56                   	push   %esi
  801eeb:	53                   	push   %ebx
  801eec:	83 ec 1c             	sub    $0x1c,%esp
  801eef:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ef1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef4:	50                   	push   %eax
  801ef5:	e8 32 f7 ff ff       	call   80162c <fd_alloc>
  801efa:	89 c3                	mov    %eax,%ebx
  801efc:	83 c4 10             	add    $0x10,%esp
  801eff:	85 c0                	test   %eax,%eax
  801f01:	78 43                	js     801f46 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f03:	83 ec 04             	sub    $0x4,%esp
  801f06:	68 07 04 00 00       	push   $0x407
  801f0b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0e:	6a 00                	push   $0x0
  801f10:	e8 0e ee ff ff       	call   800d23 <sys_page_alloc>
  801f15:	89 c3                	mov    %eax,%ebx
  801f17:	83 c4 10             	add    $0x10,%esp
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	78 28                	js     801f46 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f21:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f27:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f33:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f36:	83 ec 0c             	sub    $0xc,%esp
  801f39:	50                   	push   %eax
  801f3a:	e8 c6 f6 ff ff       	call   801605 <fd2num>
  801f3f:	89 c3                	mov    %eax,%ebx
  801f41:	83 c4 10             	add    $0x10,%esp
  801f44:	eb 0c                	jmp    801f52 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f46:	83 ec 0c             	sub    $0xc,%esp
  801f49:	56                   	push   %esi
  801f4a:	e8 e4 01 00 00       	call   802133 <nsipc_close>
		return r;
  801f4f:	83 c4 10             	add    $0x10,%esp
}
  801f52:	89 d8                	mov    %ebx,%eax
  801f54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5d                   	pop    %ebp
  801f5a:	c3                   	ret    

00801f5b <accept>:
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	e8 4e ff ff ff       	call   801eb7 <fd2sockid>
  801f69:	85 c0                	test   %eax,%eax
  801f6b:	78 1b                	js     801f88 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f6d:	83 ec 04             	sub    $0x4,%esp
  801f70:	ff 75 10             	pushl  0x10(%ebp)
  801f73:	ff 75 0c             	pushl  0xc(%ebp)
  801f76:	50                   	push   %eax
  801f77:	e8 0e 01 00 00       	call   80208a <nsipc_accept>
  801f7c:	83 c4 10             	add    $0x10,%esp
  801f7f:	85 c0                	test   %eax,%eax
  801f81:	78 05                	js     801f88 <accept+0x2d>
	return alloc_sockfd(r);
  801f83:	e8 5f ff ff ff       	call   801ee7 <alloc_sockfd>
}
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <bind>:
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
  801f8d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f90:	8b 45 08             	mov    0x8(%ebp),%eax
  801f93:	e8 1f ff ff ff       	call   801eb7 <fd2sockid>
  801f98:	85 c0                	test   %eax,%eax
  801f9a:	78 12                	js     801fae <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f9c:	83 ec 04             	sub    $0x4,%esp
  801f9f:	ff 75 10             	pushl  0x10(%ebp)
  801fa2:	ff 75 0c             	pushl  0xc(%ebp)
  801fa5:	50                   	push   %eax
  801fa6:	e8 31 01 00 00       	call   8020dc <nsipc_bind>
  801fab:	83 c4 10             	add    $0x10,%esp
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <shutdown>:
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	e8 f9 fe ff ff       	call   801eb7 <fd2sockid>
  801fbe:	85 c0                	test   %eax,%eax
  801fc0:	78 0f                	js     801fd1 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801fc2:	83 ec 08             	sub    $0x8,%esp
  801fc5:	ff 75 0c             	pushl  0xc(%ebp)
  801fc8:	50                   	push   %eax
  801fc9:	e8 43 01 00 00       	call   802111 <nsipc_shutdown>
  801fce:	83 c4 10             	add    $0x10,%esp
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <connect>:
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	e8 d6 fe ff ff       	call   801eb7 <fd2sockid>
  801fe1:	85 c0                	test   %eax,%eax
  801fe3:	78 12                	js     801ff7 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801fe5:	83 ec 04             	sub    $0x4,%esp
  801fe8:	ff 75 10             	pushl  0x10(%ebp)
  801feb:	ff 75 0c             	pushl  0xc(%ebp)
  801fee:	50                   	push   %eax
  801fef:	e8 59 01 00 00       	call   80214d <nsipc_connect>
  801ff4:	83 c4 10             	add    $0x10,%esp
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <listen>:
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	e8 b0 fe ff ff       	call   801eb7 <fd2sockid>
  802007:	85 c0                	test   %eax,%eax
  802009:	78 0f                	js     80201a <listen+0x21>
	return nsipc_listen(r, backlog);
  80200b:	83 ec 08             	sub    $0x8,%esp
  80200e:	ff 75 0c             	pushl  0xc(%ebp)
  802011:	50                   	push   %eax
  802012:	e8 6b 01 00 00       	call   802182 <nsipc_listen>
  802017:	83 c4 10             	add    $0x10,%esp
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <socket>:

int
socket(int domain, int type, int protocol)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802022:	ff 75 10             	pushl  0x10(%ebp)
  802025:	ff 75 0c             	pushl  0xc(%ebp)
  802028:	ff 75 08             	pushl  0x8(%ebp)
  80202b:	e8 3e 02 00 00       	call   80226e <nsipc_socket>
  802030:	83 c4 10             	add    $0x10,%esp
  802033:	85 c0                	test   %eax,%eax
  802035:	78 05                	js     80203c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802037:	e8 ab fe ff ff       	call   801ee7 <alloc_sockfd>
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	53                   	push   %ebx
  802042:	83 ec 04             	sub    $0x4,%esp
  802045:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802047:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80204e:	74 26                	je     802076 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802050:	6a 07                	push   $0x7
  802052:	68 00 70 80 00       	push   $0x807000
  802057:	53                   	push   %ebx
  802058:	ff 35 04 50 80 00    	pushl  0x805004
  80205e:	e8 0b f5 ff ff       	call   80156e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802063:	83 c4 0c             	add    $0xc,%esp
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	e8 94 f4 ff ff       	call   801505 <ipc_recv>
}
  802071:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802074:	c9                   	leave  
  802075:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802076:	83 ec 0c             	sub    $0xc,%esp
  802079:	6a 02                	push   $0x2
  80207b:	e8 46 f5 ff ff       	call   8015c6 <ipc_find_env>
  802080:	a3 04 50 80 00       	mov    %eax,0x805004
  802085:	83 c4 10             	add    $0x10,%esp
  802088:	eb c6                	jmp    802050 <nsipc+0x12>

0080208a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	56                   	push   %esi
  80208e:	53                   	push   %ebx
  80208f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80209a:	8b 06                	mov    (%esi),%eax
  80209c:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a6:	e8 93 ff ff ff       	call   80203e <nsipc>
  8020ab:	89 c3                	mov    %eax,%ebx
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	79 09                	jns    8020ba <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8020b1:	89 d8                	mov    %ebx,%eax
  8020b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020b6:	5b                   	pop    %ebx
  8020b7:	5e                   	pop    %esi
  8020b8:	5d                   	pop    %ebp
  8020b9:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020ba:	83 ec 04             	sub    $0x4,%esp
  8020bd:	ff 35 10 70 80 00    	pushl  0x807010
  8020c3:	68 00 70 80 00       	push   $0x807000
  8020c8:	ff 75 0c             	pushl  0xc(%ebp)
  8020cb:	e8 ef e9 ff ff       	call   800abf <memmove>
		*addrlen = ret->ret_addrlen;
  8020d0:	a1 10 70 80 00       	mov    0x807010,%eax
  8020d5:	89 06                	mov    %eax,(%esi)
  8020d7:	83 c4 10             	add    $0x10,%esp
	return r;
  8020da:	eb d5                	jmp    8020b1 <nsipc_accept+0x27>

008020dc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	53                   	push   %ebx
  8020e0:	83 ec 08             	sub    $0x8,%esp
  8020e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020ee:	53                   	push   %ebx
  8020ef:	ff 75 0c             	pushl  0xc(%ebp)
  8020f2:	68 04 70 80 00       	push   $0x807004
  8020f7:	e8 c3 e9 ff ff       	call   800abf <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020fc:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802102:	b8 02 00 00 00       	mov    $0x2,%eax
  802107:	e8 32 ff ff ff       	call   80203e <nsipc>
}
  80210c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80211f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802122:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802127:	b8 03 00 00 00       	mov    $0x3,%eax
  80212c:	e8 0d ff ff ff       	call   80203e <nsipc>
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <nsipc_close>:

int
nsipc_close(int s)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802141:	b8 04 00 00 00       	mov    $0x4,%eax
  802146:	e8 f3 fe ff ff       	call   80203e <nsipc>
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
  802150:	53                   	push   %ebx
  802151:	83 ec 08             	sub    $0x8,%esp
  802154:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80215f:	53                   	push   %ebx
  802160:	ff 75 0c             	pushl  0xc(%ebp)
  802163:	68 04 70 80 00       	push   $0x807004
  802168:	e8 52 e9 ff ff       	call   800abf <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80216d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802173:	b8 05 00 00 00       	mov    $0x5,%eax
  802178:	e8 c1 fe ff ff       	call   80203e <nsipc>
}
  80217d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802190:	8b 45 0c             	mov    0xc(%ebp),%eax
  802193:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802198:	b8 06 00 00 00       	mov    $0x6,%eax
  80219d:	e8 9c fe ff ff       	call   80203e <nsipc>
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	56                   	push   %esi
  8021a8:	53                   	push   %ebx
  8021a9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021b4:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8021bd:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021c2:	b8 07 00 00 00       	mov    $0x7,%eax
  8021c7:	e8 72 fe ff ff       	call   80203e <nsipc>
  8021cc:	89 c3                	mov    %eax,%ebx
  8021ce:	85 c0                	test   %eax,%eax
  8021d0:	78 1f                	js     8021f1 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021d2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021d7:	7f 21                	jg     8021fa <nsipc_recv+0x56>
  8021d9:	39 c6                	cmp    %eax,%esi
  8021db:	7c 1d                	jl     8021fa <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021dd:	83 ec 04             	sub    $0x4,%esp
  8021e0:	50                   	push   %eax
  8021e1:	68 00 70 80 00       	push   $0x807000
  8021e6:	ff 75 0c             	pushl  0xc(%ebp)
  8021e9:	e8 d1 e8 ff ff       	call   800abf <memmove>
  8021ee:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8021f1:	89 d8                	mov    %ebx,%eax
  8021f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f6:	5b                   	pop    %ebx
  8021f7:	5e                   	pop    %esi
  8021f8:	5d                   	pop    %ebp
  8021f9:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021fa:	68 b3 30 80 00       	push   $0x8030b3
  8021ff:	68 7b 30 80 00       	push   $0x80307b
  802204:	6a 62                	push   $0x62
  802206:	68 c8 30 80 00       	push   $0x8030c8
  80220b:	e8 4b 05 00 00       	call   80275b <_panic>

00802210 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
  802213:	53                   	push   %ebx
  802214:	83 ec 04             	sub    $0x4,%esp
  802217:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802222:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802228:	7f 2e                	jg     802258 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80222a:	83 ec 04             	sub    $0x4,%esp
  80222d:	53                   	push   %ebx
  80222e:	ff 75 0c             	pushl  0xc(%ebp)
  802231:	68 0c 70 80 00       	push   $0x80700c
  802236:	e8 84 e8 ff ff       	call   800abf <memmove>
	nsipcbuf.send.req_size = size;
  80223b:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802241:	8b 45 14             	mov    0x14(%ebp),%eax
  802244:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802249:	b8 08 00 00 00       	mov    $0x8,%eax
  80224e:	e8 eb fd ff ff       	call   80203e <nsipc>
}
  802253:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802256:	c9                   	leave  
  802257:	c3                   	ret    
	assert(size < 1600);
  802258:	68 d4 30 80 00       	push   $0x8030d4
  80225d:	68 7b 30 80 00       	push   $0x80307b
  802262:	6a 6d                	push   $0x6d
  802264:	68 c8 30 80 00       	push   $0x8030c8
  802269:	e8 ed 04 00 00       	call   80275b <_panic>

0080226e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80227c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802284:	8b 45 10             	mov    0x10(%ebp),%eax
  802287:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80228c:	b8 09 00 00 00       	mov    $0x9,%eax
  802291:	e8 a8 fd ff ff       	call   80203e <nsipc>
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	56                   	push   %esi
  80229c:	53                   	push   %ebx
  80229d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8022a0:	83 ec 0c             	sub    $0xc,%esp
  8022a3:	ff 75 08             	pushl  0x8(%ebp)
  8022a6:	e8 6a f3 ff ff       	call   801615 <fd2data>
  8022ab:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8022ad:	83 c4 08             	add    $0x8,%esp
  8022b0:	68 e0 30 80 00       	push   $0x8030e0
  8022b5:	53                   	push   %ebx
  8022b6:	e8 76 e6 ff ff       	call   800931 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022bb:	8b 46 04             	mov    0x4(%esi),%eax
  8022be:	2b 06                	sub    (%esi),%eax
  8022c0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022c6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022cd:	00 00 00 
	stat->st_dev = &devpipe;
  8022d0:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8022d7:	40 80 00 
	return 0;
}
  8022da:	b8 00 00 00 00       	mov    $0x0,%eax
  8022df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022e2:	5b                   	pop    %ebx
  8022e3:	5e                   	pop    %esi
  8022e4:	5d                   	pop    %ebp
  8022e5:	c3                   	ret    

008022e6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	53                   	push   %ebx
  8022ea:	83 ec 0c             	sub    $0xc,%esp
  8022ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022f0:	53                   	push   %ebx
  8022f1:	6a 00                	push   $0x0
  8022f3:	e8 b0 ea ff ff       	call   800da8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022f8:	89 1c 24             	mov    %ebx,(%esp)
  8022fb:	e8 15 f3 ff ff       	call   801615 <fd2data>
  802300:	83 c4 08             	add    $0x8,%esp
  802303:	50                   	push   %eax
  802304:	6a 00                	push   $0x0
  802306:	e8 9d ea ff ff       	call   800da8 <sys_page_unmap>
}
  80230b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <_pipeisclosed>:
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	57                   	push   %edi
  802314:	56                   	push   %esi
  802315:	53                   	push   %ebx
  802316:	83 ec 1c             	sub    $0x1c,%esp
  802319:	89 c7                	mov    %eax,%edi
  80231b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80231d:	a1 08 50 80 00       	mov    0x805008,%eax
  802322:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802325:	83 ec 0c             	sub    $0xc,%esp
  802328:	57                   	push   %edi
  802329:	e8 23 05 00 00       	call   802851 <pageref>
  80232e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802331:	89 34 24             	mov    %esi,(%esp)
  802334:	e8 18 05 00 00       	call   802851 <pageref>
		nn = thisenv->env_runs;
  802339:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80233f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802342:	83 c4 10             	add    $0x10,%esp
  802345:	39 cb                	cmp    %ecx,%ebx
  802347:	74 1b                	je     802364 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802349:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80234c:	75 cf                	jne    80231d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80234e:	8b 42 58             	mov    0x58(%edx),%eax
  802351:	6a 01                	push   $0x1
  802353:	50                   	push   %eax
  802354:	53                   	push   %ebx
  802355:	68 e7 30 80 00       	push   $0x8030e7
  80235a:	e8 73 de ff ff       	call   8001d2 <cprintf>
  80235f:	83 c4 10             	add    $0x10,%esp
  802362:	eb b9                	jmp    80231d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802364:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802367:	0f 94 c0             	sete   %al
  80236a:	0f b6 c0             	movzbl %al,%eax
}
  80236d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802370:	5b                   	pop    %ebx
  802371:	5e                   	pop    %esi
  802372:	5f                   	pop    %edi
  802373:	5d                   	pop    %ebp
  802374:	c3                   	ret    

00802375 <devpipe_write>:
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
  802378:	57                   	push   %edi
  802379:	56                   	push   %esi
  80237a:	53                   	push   %ebx
  80237b:	83 ec 28             	sub    $0x28,%esp
  80237e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802381:	56                   	push   %esi
  802382:	e8 8e f2 ff ff       	call   801615 <fd2data>
  802387:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802389:	83 c4 10             	add    $0x10,%esp
  80238c:	bf 00 00 00 00       	mov    $0x0,%edi
  802391:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802394:	74 4f                	je     8023e5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802396:	8b 43 04             	mov    0x4(%ebx),%eax
  802399:	8b 0b                	mov    (%ebx),%ecx
  80239b:	8d 51 20             	lea    0x20(%ecx),%edx
  80239e:	39 d0                	cmp    %edx,%eax
  8023a0:	72 14                	jb     8023b6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8023a2:	89 da                	mov    %ebx,%edx
  8023a4:	89 f0                	mov    %esi,%eax
  8023a6:	e8 65 ff ff ff       	call   802310 <_pipeisclosed>
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	75 3b                	jne    8023ea <devpipe_write+0x75>
			sys_yield();
  8023af:	e8 50 e9 ff ff       	call   800d04 <sys_yield>
  8023b4:	eb e0                	jmp    802396 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023b9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8023bd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8023c0:	89 c2                	mov    %eax,%edx
  8023c2:	c1 fa 1f             	sar    $0x1f,%edx
  8023c5:	89 d1                	mov    %edx,%ecx
  8023c7:	c1 e9 1b             	shr    $0x1b,%ecx
  8023ca:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8023cd:	83 e2 1f             	and    $0x1f,%edx
  8023d0:	29 ca                	sub    %ecx,%edx
  8023d2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8023d6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8023da:	83 c0 01             	add    $0x1,%eax
  8023dd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8023e0:	83 c7 01             	add    $0x1,%edi
  8023e3:	eb ac                	jmp    802391 <devpipe_write+0x1c>
	return i;
  8023e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e8:	eb 05                	jmp    8023ef <devpipe_write+0x7a>
				return 0;
  8023ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023f2:	5b                   	pop    %ebx
  8023f3:	5e                   	pop    %esi
  8023f4:	5f                   	pop    %edi
  8023f5:	5d                   	pop    %ebp
  8023f6:	c3                   	ret    

008023f7 <devpipe_read>:
{
  8023f7:	55                   	push   %ebp
  8023f8:	89 e5                	mov    %esp,%ebp
  8023fa:	57                   	push   %edi
  8023fb:	56                   	push   %esi
  8023fc:	53                   	push   %ebx
  8023fd:	83 ec 18             	sub    $0x18,%esp
  802400:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802403:	57                   	push   %edi
  802404:	e8 0c f2 ff ff       	call   801615 <fd2data>
  802409:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80240b:	83 c4 10             	add    $0x10,%esp
  80240e:	be 00 00 00 00       	mov    $0x0,%esi
  802413:	3b 75 10             	cmp    0x10(%ebp),%esi
  802416:	75 14                	jne    80242c <devpipe_read+0x35>
	return i;
  802418:	8b 45 10             	mov    0x10(%ebp),%eax
  80241b:	eb 02                	jmp    80241f <devpipe_read+0x28>
				return i;
  80241d:	89 f0                	mov    %esi,%eax
}
  80241f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802422:	5b                   	pop    %ebx
  802423:	5e                   	pop    %esi
  802424:	5f                   	pop    %edi
  802425:	5d                   	pop    %ebp
  802426:	c3                   	ret    
			sys_yield();
  802427:	e8 d8 e8 ff ff       	call   800d04 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80242c:	8b 03                	mov    (%ebx),%eax
  80242e:	3b 43 04             	cmp    0x4(%ebx),%eax
  802431:	75 18                	jne    80244b <devpipe_read+0x54>
			if (i > 0)
  802433:	85 f6                	test   %esi,%esi
  802435:	75 e6                	jne    80241d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802437:	89 da                	mov    %ebx,%edx
  802439:	89 f8                	mov    %edi,%eax
  80243b:	e8 d0 fe ff ff       	call   802310 <_pipeisclosed>
  802440:	85 c0                	test   %eax,%eax
  802442:	74 e3                	je     802427 <devpipe_read+0x30>
				return 0;
  802444:	b8 00 00 00 00       	mov    $0x0,%eax
  802449:	eb d4                	jmp    80241f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80244b:	99                   	cltd   
  80244c:	c1 ea 1b             	shr    $0x1b,%edx
  80244f:	01 d0                	add    %edx,%eax
  802451:	83 e0 1f             	and    $0x1f,%eax
  802454:	29 d0                	sub    %edx,%eax
  802456:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80245b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80245e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802461:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802464:	83 c6 01             	add    $0x1,%esi
  802467:	eb aa                	jmp    802413 <devpipe_read+0x1c>

00802469 <pipe>:
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
  80246c:	56                   	push   %esi
  80246d:	53                   	push   %ebx
  80246e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802471:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802474:	50                   	push   %eax
  802475:	e8 b2 f1 ff ff       	call   80162c <fd_alloc>
  80247a:	89 c3                	mov    %eax,%ebx
  80247c:	83 c4 10             	add    $0x10,%esp
  80247f:	85 c0                	test   %eax,%eax
  802481:	0f 88 23 01 00 00    	js     8025aa <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802487:	83 ec 04             	sub    $0x4,%esp
  80248a:	68 07 04 00 00       	push   $0x407
  80248f:	ff 75 f4             	pushl  -0xc(%ebp)
  802492:	6a 00                	push   $0x0
  802494:	e8 8a e8 ff ff       	call   800d23 <sys_page_alloc>
  802499:	89 c3                	mov    %eax,%ebx
  80249b:	83 c4 10             	add    $0x10,%esp
  80249e:	85 c0                	test   %eax,%eax
  8024a0:	0f 88 04 01 00 00    	js     8025aa <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8024a6:	83 ec 0c             	sub    $0xc,%esp
  8024a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024ac:	50                   	push   %eax
  8024ad:	e8 7a f1 ff ff       	call   80162c <fd_alloc>
  8024b2:	89 c3                	mov    %eax,%ebx
  8024b4:	83 c4 10             	add    $0x10,%esp
  8024b7:	85 c0                	test   %eax,%eax
  8024b9:	0f 88 db 00 00 00    	js     80259a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024bf:	83 ec 04             	sub    $0x4,%esp
  8024c2:	68 07 04 00 00       	push   $0x407
  8024c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8024ca:	6a 00                	push   $0x0
  8024cc:	e8 52 e8 ff ff       	call   800d23 <sys_page_alloc>
  8024d1:	89 c3                	mov    %eax,%ebx
  8024d3:	83 c4 10             	add    $0x10,%esp
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	0f 88 bc 00 00 00    	js     80259a <pipe+0x131>
	va = fd2data(fd0);
  8024de:	83 ec 0c             	sub    $0xc,%esp
  8024e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8024e4:	e8 2c f1 ff ff       	call   801615 <fd2data>
  8024e9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024eb:	83 c4 0c             	add    $0xc,%esp
  8024ee:	68 07 04 00 00       	push   $0x407
  8024f3:	50                   	push   %eax
  8024f4:	6a 00                	push   $0x0
  8024f6:	e8 28 e8 ff ff       	call   800d23 <sys_page_alloc>
  8024fb:	89 c3                	mov    %eax,%ebx
  8024fd:	83 c4 10             	add    $0x10,%esp
  802500:	85 c0                	test   %eax,%eax
  802502:	0f 88 82 00 00 00    	js     80258a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802508:	83 ec 0c             	sub    $0xc,%esp
  80250b:	ff 75 f0             	pushl  -0x10(%ebp)
  80250e:	e8 02 f1 ff ff       	call   801615 <fd2data>
  802513:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80251a:	50                   	push   %eax
  80251b:	6a 00                	push   $0x0
  80251d:	56                   	push   %esi
  80251e:	6a 00                	push   $0x0
  802520:	e8 41 e8 ff ff       	call   800d66 <sys_page_map>
  802525:	89 c3                	mov    %eax,%ebx
  802527:	83 c4 20             	add    $0x20,%esp
  80252a:	85 c0                	test   %eax,%eax
  80252c:	78 4e                	js     80257c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80252e:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802533:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802536:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802538:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80253b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802542:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802545:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802551:	83 ec 0c             	sub    $0xc,%esp
  802554:	ff 75 f4             	pushl  -0xc(%ebp)
  802557:	e8 a9 f0 ff ff       	call   801605 <fd2num>
  80255c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80255f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802561:	83 c4 04             	add    $0x4,%esp
  802564:	ff 75 f0             	pushl  -0x10(%ebp)
  802567:	e8 99 f0 ff ff       	call   801605 <fd2num>
  80256c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80256f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802572:	83 c4 10             	add    $0x10,%esp
  802575:	bb 00 00 00 00       	mov    $0x0,%ebx
  80257a:	eb 2e                	jmp    8025aa <pipe+0x141>
	sys_page_unmap(0, va);
  80257c:	83 ec 08             	sub    $0x8,%esp
  80257f:	56                   	push   %esi
  802580:	6a 00                	push   $0x0
  802582:	e8 21 e8 ff ff       	call   800da8 <sys_page_unmap>
  802587:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80258a:	83 ec 08             	sub    $0x8,%esp
  80258d:	ff 75 f0             	pushl  -0x10(%ebp)
  802590:	6a 00                	push   $0x0
  802592:	e8 11 e8 ff ff       	call   800da8 <sys_page_unmap>
  802597:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80259a:	83 ec 08             	sub    $0x8,%esp
  80259d:	ff 75 f4             	pushl  -0xc(%ebp)
  8025a0:	6a 00                	push   $0x0
  8025a2:	e8 01 e8 ff ff       	call   800da8 <sys_page_unmap>
  8025a7:	83 c4 10             	add    $0x10,%esp
}
  8025aa:	89 d8                	mov    %ebx,%eax
  8025ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025af:	5b                   	pop    %ebx
  8025b0:	5e                   	pop    %esi
  8025b1:	5d                   	pop    %ebp
  8025b2:	c3                   	ret    

008025b3 <pipeisclosed>:
{
  8025b3:	55                   	push   %ebp
  8025b4:	89 e5                	mov    %esp,%ebp
  8025b6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025bc:	50                   	push   %eax
  8025bd:	ff 75 08             	pushl  0x8(%ebp)
  8025c0:	e8 b9 f0 ff ff       	call   80167e <fd_lookup>
  8025c5:	83 c4 10             	add    $0x10,%esp
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	78 18                	js     8025e4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8025cc:	83 ec 0c             	sub    $0xc,%esp
  8025cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8025d2:	e8 3e f0 ff ff       	call   801615 <fd2data>
	return _pipeisclosed(fd, p);
  8025d7:	89 c2                	mov    %eax,%edx
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	e8 2f fd ff ff       	call   802310 <_pipeisclosed>
  8025e1:	83 c4 10             	add    $0x10,%esp
}
  8025e4:	c9                   	leave  
  8025e5:	c3                   	ret    

008025e6 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8025e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025eb:	c3                   	ret    

008025ec <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
  8025ef:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8025f2:	68 ff 30 80 00       	push   $0x8030ff
  8025f7:	ff 75 0c             	pushl  0xc(%ebp)
  8025fa:	e8 32 e3 ff ff       	call   800931 <strcpy>
	return 0;
}
  8025ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802604:	c9                   	leave  
  802605:	c3                   	ret    

00802606 <devcons_write>:
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
  802609:	57                   	push   %edi
  80260a:	56                   	push   %esi
  80260b:	53                   	push   %ebx
  80260c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802612:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802617:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80261d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802620:	73 31                	jae    802653 <devcons_write+0x4d>
		m = n - tot;
  802622:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802625:	29 f3                	sub    %esi,%ebx
  802627:	83 fb 7f             	cmp    $0x7f,%ebx
  80262a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80262f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802632:	83 ec 04             	sub    $0x4,%esp
  802635:	53                   	push   %ebx
  802636:	89 f0                	mov    %esi,%eax
  802638:	03 45 0c             	add    0xc(%ebp),%eax
  80263b:	50                   	push   %eax
  80263c:	57                   	push   %edi
  80263d:	e8 7d e4 ff ff       	call   800abf <memmove>
		sys_cputs(buf, m);
  802642:	83 c4 08             	add    $0x8,%esp
  802645:	53                   	push   %ebx
  802646:	57                   	push   %edi
  802647:	e8 1b e6 ff ff       	call   800c67 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80264c:	01 de                	add    %ebx,%esi
  80264e:	83 c4 10             	add    $0x10,%esp
  802651:	eb ca                	jmp    80261d <devcons_write+0x17>
}
  802653:	89 f0                	mov    %esi,%eax
  802655:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802658:	5b                   	pop    %ebx
  802659:	5e                   	pop    %esi
  80265a:	5f                   	pop    %edi
  80265b:	5d                   	pop    %ebp
  80265c:	c3                   	ret    

0080265d <devcons_read>:
{
  80265d:	55                   	push   %ebp
  80265e:	89 e5                	mov    %esp,%ebp
  802660:	83 ec 08             	sub    $0x8,%esp
  802663:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802668:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80266c:	74 21                	je     80268f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80266e:	e8 12 e6 ff ff       	call   800c85 <sys_cgetc>
  802673:	85 c0                	test   %eax,%eax
  802675:	75 07                	jne    80267e <devcons_read+0x21>
		sys_yield();
  802677:	e8 88 e6 ff ff       	call   800d04 <sys_yield>
  80267c:	eb f0                	jmp    80266e <devcons_read+0x11>
	if (c < 0)
  80267e:	78 0f                	js     80268f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802680:	83 f8 04             	cmp    $0x4,%eax
  802683:	74 0c                	je     802691 <devcons_read+0x34>
	*(char*)vbuf = c;
  802685:	8b 55 0c             	mov    0xc(%ebp),%edx
  802688:	88 02                	mov    %al,(%edx)
	return 1;
  80268a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80268f:	c9                   	leave  
  802690:	c3                   	ret    
		return 0;
  802691:	b8 00 00 00 00       	mov    $0x0,%eax
  802696:	eb f7                	jmp    80268f <devcons_read+0x32>

00802698 <cputchar>:
{
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
  80269b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80269e:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8026a4:	6a 01                	push   $0x1
  8026a6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026a9:	50                   	push   %eax
  8026aa:	e8 b8 e5 ff ff       	call   800c67 <sys_cputs>
}
  8026af:	83 c4 10             	add    $0x10,%esp
  8026b2:	c9                   	leave  
  8026b3:	c3                   	ret    

008026b4 <getchar>:
{
  8026b4:	55                   	push   %ebp
  8026b5:	89 e5                	mov    %esp,%ebp
  8026b7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8026ba:	6a 01                	push   $0x1
  8026bc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026bf:	50                   	push   %eax
  8026c0:	6a 00                	push   $0x0
  8026c2:	e8 27 f2 ff ff       	call   8018ee <read>
	if (r < 0)
  8026c7:	83 c4 10             	add    $0x10,%esp
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	78 06                	js     8026d4 <getchar+0x20>
	if (r < 1)
  8026ce:	74 06                	je     8026d6 <getchar+0x22>
	return c;
  8026d0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026d4:	c9                   	leave  
  8026d5:	c3                   	ret    
		return -E_EOF;
  8026d6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8026db:	eb f7                	jmp    8026d4 <getchar+0x20>

008026dd <iscons>:
{
  8026dd:	55                   	push   %ebp
  8026de:	89 e5                	mov    %esp,%ebp
  8026e0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026e6:	50                   	push   %eax
  8026e7:	ff 75 08             	pushl  0x8(%ebp)
  8026ea:	e8 8f ef ff ff       	call   80167e <fd_lookup>
  8026ef:	83 c4 10             	add    $0x10,%esp
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	78 11                	js     802707 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026ff:	39 10                	cmp    %edx,(%eax)
  802701:	0f 94 c0             	sete   %al
  802704:	0f b6 c0             	movzbl %al,%eax
}
  802707:	c9                   	leave  
  802708:	c3                   	ret    

00802709 <opencons>:
{
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
  80270c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80270f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802712:	50                   	push   %eax
  802713:	e8 14 ef ff ff       	call   80162c <fd_alloc>
  802718:	83 c4 10             	add    $0x10,%esp
  80271b:	85 c0                	test   %eax,%eax
  80271d:	78 3a                	js     802759 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80271f:	83 ec 04             	sub    $0x4,%esp
  802722:	68 07 04 00 00       	push   $0x407
  802727:	ff 75 f4             	pushl  -0xc(%ebp)
  80272a:	6a 00                	push   $0x0
  80272c:	e8 f2 e5 ff ff       	call   800d23 <sys_page_alloc>
  802731:	83 c4 10             	add    $0x10,%esp
  802734:	85 c0                	test   %eax,%eax
  802736:	78 21                	js     802759 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802741:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80274d:	83 ec 0c             	sub    $0xc,%esp
  802750:	50                   	push   %eax
  802751:	e8 af ee ff ff       	call   801605 <fd2num>
  802756:	83 c4 10             	add    $0x10,%esp
}
  802759:	c9                   	leave  
  80275a:	c3                   	ret    

0080275b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80275b:	55                   	push   %ebp
  80275c:	89 e5                	mov    %esp,%ebp
  80275e:	56                   	push   %esi
  80275f:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802760:	a1 08 50 80 00       	mov    0x805008,%eax
  802765:	8b 40 48             	mov    0x48(%eax),%eax
  802768:	83 ec 04             	sub    $0x4,%esp
  80276b:	68 30 31 80 00       	push   $0x803130
  802770:	50                   	push   %eax
  802771:	68 13 2b 80 00       	push   $0x802b13
  802776:	e8 57 da ff ff       	call   8001d2 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80277b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80277e:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802784:	e8 5c e5 ff ff       	call   800ce5 <sys_getenvid>
  802789:	83 c4 04             	add    $0x4,%esp
  80278c:	ff 75 0c             	pushl  0xc(%ebp)
  80278f:	ff 75 08             	pushl  0x8(%ebp)
  802792:	56                   	push   %esi
  802793:	50                   	push   %eax
  802794:	68 0c 31 80 00       	push   $0x80310c
  802799:	e8 34 da ff ff       	call   8001d2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80279e:	83 c4 18             	add    $0x18,%esp
  8027a1:	53                   	push   %ebx
  8027a2:	ff 75 10             	pushl  0x10(%ebp)
  8027a5:	e8 d7 d9 ff ff       	call   800181 <vcprintf>
	cprintf("\n");
  8027aa:	c7 04 24 21 2f 80 00 	movl   $0x802f21,(%esp)
  8027b1:	e8 1c da ff ff       	call   8001d2 <cprintf>
  8027b6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8027b9:	cc                   	int3   
  8027ba:	eb fd                	jmp    8027b9 <_panic+0x5e>

008027bc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8027bc:	55                   	push   %ebp
  8027bd:	89 e5                	mov    %esp,%ebp
  8027bf:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8027c2:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8027c9:	74 0a                	je     8027d5 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8027cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ce:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8027d3:	c9                   	leave  
  8027d4:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8027d5:	83 ec 04             	sub    $0x4,%esp
  8027d8:	6a 07                	push   $0x7
  8027da:	68 00 f0 bf ee       	push   $0xeebff000
  8027df:	6a 00                	push   $0x0
  8027e1:	e8 3d e5 ff ff       	call   800d23 <sys_page_alloc>
		if(r < 0)
  8027e6:	83 c4 10             	add    $0x10,%esp
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	78 2a                	js     802817 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8027ed:	83 ec 08             	sub    $0x8,%esp
  8027f0:	68 2b 28 80 00       	push   $0x80282b
  8027f5:	6a 00                	push   $0x0
  8027f7:	e8 72 e6 ff ff       	call   800e6e <sys_env_set_pgfault_upcall>
		if(r < 0)
  8027fc:	83 c4 10             	add    $0x10,%esp
  8027ff:	85 c0                	test   %eax,%eax
  802801:	79 c8                	jns    8027cb <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802803:	83 ec 04             	sub    $0x4,%esp
  802806:	68 68 31 80 00       	push   $0x803168
  80280b:	6a 25                	push   $0x25
  80280d:	68 a4 31 80 00       	push   $0x8031a4
  802812:	e8 44 ff ff ff       	call   80275b <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802817:	83 ec 04             	sub    $0x4,%esp
  80281a:	68 38 31 80 00       	push   $0x803138
  80281f:	6a 22                	push   $0x22
  802821:	68 a4 31 80 00       	push   $0x8031a4
  802826:	e8 30 ff ff ff       	call   80275b <_panic>

0080282b <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80282b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80282c:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802831:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802833:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802836:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80283a:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80283e:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802841:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802843:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802847:	83 c4 08             	add    $0x8,%esp
	popal
  80284a:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80284b:	83 c4 04             	add    $0x4,%esp
	popfl
  80284e:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80284f:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802850:	c3                   	ret    

00802851 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
  802854:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802857:	89 d0                	mov    %edx,%eax
  802859:	c1 e8 16             	shr    $0x16,%eax
  80285c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802863:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802868:	f6 c1 01             	test   $0x1,%cl
  80286b:	74 1d                	je     80288a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80286d:	c1 ea 0c             	shr    $0xc,%edx
  802870:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802877:	f6 c2 01             	test   $0x1,%dl
  80287a:	74 0e                	je     80288a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80287c:	c1 ea 0c             	shr    $0xc,%edx
  80287f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802886:	ef 
  802887:	0f b7 c0             	movzwl %ax,%eax
}
  80288a:	5d                   	pop    %ebp
  80288b:	c3                   	ret    
  80288c:	66 90                	xchg   %ax,%ax
  80288e:	66 90                	xchg   %ax,%ax

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
